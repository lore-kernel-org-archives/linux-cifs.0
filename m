From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 2/2] cifs: Use per smb session session key instead of per smb connection session key for smb2
Date: Thu,  8 Aug 2013 09:54:00 -0500
Message-ID: <1375973640-6255-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Use per smb session session key for signing for smb2 onwards.
For each signature genereation/validation, look for corrosponding
session (id) to fetch session key.
Skip checking signature of the session setup response.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h      |  5 +++--
 fs/cifs/cifsproto.h     |  5 ++++-
 fs/cifs/connect.c       | 14 +++++++++---
 fs/cifs/smb2transport.c | 59 +++++++++++++++++++++++++++++++++++++++++--------
 4 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2909380..4e24355 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -368,7 +368,8 @@ struct smb_version_operations {
 	int (*perconnkey)(struct TCP_Server_Info *server,
 					struct cifs_ses *ses);
 	/* The next two functions will need to be changed to per smb session */
-	void (*generate_signingkey)(struct TCP_Server_Info *server);
+	int (*generate_signingkey)(struct TCP_Server_Info *server,
+					struct cifs_ses *ses);
 	int (*calc_signature)(struct smb_rqst *rqst,
 				   struct TCP_Server_Info *server);
 };
@@ -546,7 +547,6 @@ struct TCP_Server_Info {
 	int timeAdj;  /* Adjust for difference in server time zone in sec */
 	__u64 CurrentMid;         /* multiplex id - rotating counter */
 	char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
-	char smb3signingkey[SMB3_SIGN_KEY_SIZE]; /* for signing smb3 packets */
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	__u32 sequence_number; /* for signing, protected by srv_mutex */
@@ -729,6 +729,7 @@ struct cifs_ses {
 	bool need_reconnect:1; /* connection reset, uid now invalid */
 #ifdef CONFIG_CIFS_SMB2
 	__u16 session_flags;
+	char smb3signingkey[SMB3_SIGN_KEY_SIZE]; /* for signing smb3 packets */
 #endif /* CONFIG_CIFS_SMB2 */
 };
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b6c1d03..261c114 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -206,6 +206,8 @@ extern void cifs_dfs_release_automount_timer(void);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
+extern void cifs_put_smb_ses(struct cifs_ses *);
+
 extern void cifs_move_llist(struct list_head *source, struct list_head *dest);
 extern void cifs_free_llist(struct list_head *llist);
 extern void cifs_del_lock_waiters(struct cifsLockInfo *lock);
@@ -435,7 +437,8 @@ extern int setup_ntlm_response(struct cifs_ses *, const struct nls_table *);
 extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_table *);
 extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
 extern int calc_seckey(struct cifs_ses *);
-extern void generate_smb3signingkey(struct TCP_Server_Info *);
+extern int generate_smb3signingkey(struct TCP_Server_Info *,
+					struct cifs_ses *);
 
 extern int perconnkey(struct TCP_Server_Info *, struct cifs_ses *);
 extern void free_authkey(struct cifs_ses *);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 98deb98..0109046 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2251,7 +2251,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 	return NULL;
 }
 
-static void
+void
 cifs_put_smb_ses(struct cifs_ses *ses)
 {
 	unsigned int xid;
@@ -3847,8 +3847,16 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 			server->sequence_number = 0x2;
 			server->session_estab = true;
 		}
-		if (server->ops->generate_signingkey)
-			server->ops->generate_signingkey(server);
+		if (server->ops->generate_signingkey) {
+			rc = server->ops->generate_signingkey(server, ses);
+			if (rc) {
+				cifs_dbg(VFS,
+					"%s: Failure to generate signing key\n",
+					__func__);
+				mutex_unlock(&server->srv_mutex);
+				goto setup_sess_ret;
+			}
+		}
 		mutex_unlock(&server->srv_mutex);
 
 		cifs_dbg(FYI, "CIFS Session Established successfully\n");
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 301b191..570e5b5 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -109,6 +109,24 @@ smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 	return 0;
 }
 
+static struct cifs_ses *
+smb2_find_smb_ses(struct smb2_hdr *smb2hdr, struct TCP_Server_Info *server)
+{
+	struct cifs_ses *ses;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		if (ses->Suid != smb2hdr->SessionId)
+			continue;
+		++ses->ses_count;
+		spin_unlock(&cifs_tcp_ses_lock);
+		return ses;
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	return NULL;
+}
+
 
 int
 smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
@@ -119,23 +137,34 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	struct kvec *iov = rqst->rq_iov;
 	int n_vec = rqst->rq_nvec;
 	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)iov[0].iov_base;
+	struct cifs_ses *ses;
+
+	ses = smb2_find_smb_ses(smb2_pdu, server);
+	if (!ses) {
+		cifs_dbg(VFS, "%s: Could not find session\n", __func__);
+		return 0;
+	}
 
 	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
 	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
 	rc = smb2_crypto_shash_allocate(server);
 	if (rc) {
+		cifs_put_smb_ses(ses);
 		cifs_dbg(VFS, "%s: shah256 alloc failed\n", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_setkey(server->secmech.hmacsha256,
-		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
+		cifs_put_smb_ses(ses);
 		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
 		return rc;
 	}
 
+	cifs_put_smb_ses(ses);
+
 	rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init sha256", __func__);
@@ -193,8 +222,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	return rc;
 }
 
-void
-generate_smb3signingkey(struct TCP_Server_Info *server)
+int
+generate_smb3signingkey(struct TCP_Server_Info *server, struct cifs_ses *ses)
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
@@ -204,7 +233,7 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
 	unsigned char *hashptr = prfhash;
 
 	memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
-	memset(server->smb3signingkey, 0x0, SMB3_SIGNKEY_SIZE);
+	memset(ses->smb3signingkey, 0x0, SMB3_SIGNKEY_SIZE);
 
 	rc = smb3_crypto_shash_allocate(server);
 	if (rc) {
@@ -213,7 +242,7 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
 	}
 
 	rc = crypto_shash_setkey(server->secmech.hmacsha256,
-		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not set with session key\n", __func__);
 		goto smb3signkey_ret;
@@ -267,27 +296,38 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
 		goto smb3signkey_ret;
 	}
 
-	memcpy(server->smb3signingkey, hashptr, SMB3_SIGNKEY_SIZE);
+	memcpy(ses->smb3signingkey, hashptr, SMB3_SIGNKEY_SIZE);
 
 smb3signkey_ret:
-	return;
+	return rc;
 }
 
 int
 smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
-	int i, rc;
+	int i;
+	int rc = 0;
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
 	unsigned char *sigptr = smb3_signature;
 	struct kvec *iov = rqst->rq_iov;
 	int n_vec = rqst->rq_nvec;
 	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)iov[0].iov_base;
+	struct cifs_ses *ses;
+
+	ses = smb2_find_smb_ses(smb2_pdu, server);
+	if (!ses) {
+		cifs_dbg(VFS, "%s: Could not find session\n", __func__);
+		return 0;
+	}
 
 	memset(smb3_signature, 0x0, SMB2_CMACAES_SIZE);
 	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
 	rc = crypto_shash_setkey(server->secmech.cmacaes,
-		server->smb3signingkey, SMB2_CMACAES_SIZE);
+		ses->smb3signingkey, SMB2_CMACAES_SIZE);
+
+	cifs_put_smb_ses(ses);
+
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not set key for cmac aes\n", __func__);
 		return rc;
@@ -384,6 +424,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 
 	if ((smb2_pdu->Command == SMB2_NEGOTIATE) ||
+	    (smb2_pdu->Command == SMB2_SESSION_SETUP) ||
 	    (smb2_pdu->Command == SMB2_OPLOCK_BREAK) ||
 	    (!server->session_estab))
 		return 0;
-- 
1.8.1.2
