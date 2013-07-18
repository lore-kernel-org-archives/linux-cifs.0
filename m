From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] [cifs] Change session key to per smb session key for smb2 onwards
Date: Thu, 18 Jul 2013 09:31:22 -0500
Message-ID: <1374157882-2642-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
Change session key to per session key for SMB2 onwards and start
using that for smb2/smb3 signature generation.
Session key is per connection for CIFS/SMB

Copy auth key to session key for the first SMB/CIFS session per connection
and free the key.  Free session keys for rest of the session for that
connections.
For SMB2/3, do not copy the session key to server structure.

Do not check signature for session setup response from the server
even though that packet is signed.

Set key exchange bit for all the sessions even though it does not
matter for subsequent CIFS/SMB sessions.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 fs/cifs/cifsencrypt.c   | 20 +++++++++++++
 fs/cifs/cifsglob.h      |  8 ++++--
 fs/cifs/cifsproto.h     |  5 +++-
 fs/cifs/connect.c       | 25 ++++++++++------
 fs/cifs/sess.c          | 17 +++++------
 fs/cifs/smb1ops.c       |  1 +
 fs/cifs/smb2transport.c | 76 +++++++++++++++++++++++++++++++++++++++++++------
 7 files changed, 122 insertions(+), 30 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index ce2d331..0e7a34a 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -769,6 +769,26 @@ calc_seckey(struct cifs_ses *ses)
 }
 
 void
+free_authkey(struct cifs_ses *ses)
+{
+	kfree(ses->auth_key.response);
+	ses->auth_key.response = NULL;
+	ses->auth_key.len = 0;
+}
+
+int
+perconnkey(struct TCP_Server_Info *server, struct cifs_ses *ses)
+{
+	server->session_key.response = kmemdup(ses->auth_key.response,
+			ses->auth_key.len, GFP_KERNEL);
+	if (!server->session_key.response)
+		return -ENOMEM;
+	server->session_key.len = ses->auth_key.len;
+
+	return 0;
+}
+
+void
 cifs_crypto_shash_release(struct TCP_Server_Info *server)
 {
 	if (server->secmech.cmacaes) {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 88280e0..3a3420b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -366,7 +366,11 @@ struct smb_version_operations {
 	/* generate new lease key */
 	void (*new_lease_key)(struct cifs_fid *fid);
 	/* The next two functions will need to be changed to per smb session */
-	void (*generate_signingkey)(struct TCP_Server_Info *server);
+	int (*generate_signingkey)(struct TCP_Server_Info *server,
+					struct cifs_ses *ses);
+	int (*perconnkey)(struct TCP_Server_Info *server,
+					struct cifs_ses *ses);
+	void (*free_authkey)(struct cifs_ses *ses);
 	int (*calc_signature)(struct smb_rqst *rqst,
 				   struct TCP_Server_Info *server);
 	int (*query_mf_symlink)(const unsigned char *path, char *pbuf,
@@ -548,7 +552,6 @@ struct TCP_Server_Info {
 	int timeAdj;  /* Adjust for difference in server time zone in sec */
 	__u64 CurrentMid;         /* multiplex id - rotating counter */
 	char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
-	char smb3signingkey[SMB3_SIGN_KEY_SIZE]; /* for signing smb3 packets */
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	__u32 sequence_number; /* for signing, protected by srv_mutex */
@@ -731,6 +734,7 @@ struct cifs_ses {
 	bool need_reconnect:1; /* connection reset, uid now invalid */
 #ifdef CONFIG_CIFS_SMB2
 	__u16 session_flags;
+	char smb3signingkey[SMB3_SIGN_KEY_SIZE]; /* for signing smb3 packets */
 #endif /* CONFIG_CIFS_SMB2 */
 };
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b29a012..cb65f9d 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -435,7 +435,10 @@ extern int setup_ntlm_response(struct cifs_ses *, const struct nls_table *);
 extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_table *);
 extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
 extern int calc_seckey(struct cifs_ses *);
-extern void generate_smb3signingkey(struct TCP_Server_Info *);
+extern int generate_smb3signingkey(struct TCP_Server_Info *,
+					struct cifs_ses *);
+extern int perconnkey(struct TCP_Server_Info *, struct cifs_ses *);
+extern void free_authkey(struct cifs_ses *);
 
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 extern int calc_lanman_hash(const char *password, const char *cryptkey,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ed6bf20..5cc273c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2118,6 +2118,8 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		goto out_err_crypto_release;
 	}
 
+	tcp_ses->session_key.response = NULL;
+	tcp_ses->session_key.len = 0;
 	tcp_ses->noblocksnd = volume_info->noblocksnd;
 	tcp_ses->noautotune = volume_info->noautotune;
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
@@ -2271,6 +2273,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 		server->ops->logoff(xid, ses);
 		_free_xid(xid);
 	}
+	if (!server->ops->free_authkey)
+		free_authkey(ses);
 	sesInfoFree(ses);
 	cifs_put_tcp_session(server);
 }
@@ -2485,6 +2489,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	ses->sectype = volume_info->sectype;
 	ses->sign = volume_info->sign;
 
+	ses->auth_key.response = NULL;
+	ses->auth_key.len = 0;
+
 	mutex_lock(&ses->session_mutex);
 	rc = cifs_negotiate_protocol(xid, ses);
 	if (!rc)
@@ -3831,13 +3838,15 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	} else {
 		mutex_lock(&server->srv_mutex);
 		if (!server->session_estab) {
-			server->session_key.response = ses->auth_key.response;
-			server->session_key.len = ses->auth_key.len;
+			if (server->ops->perconnkey) {
+				rc = server->ops->perconnkey(server, ses);
+				if (rc) {
+					mutex_unlock(&server->srv_mutex);
+					goto setup_sess_ret;
+				}
+			}
 			server->sequence_number = 0x2;
 			server->session_estab = true;
-			ses->auth_key.response = NULL;
-			if (server->ops->generate_signingkey)
-				server->ops->generate_signingkey(server);
 		}
 		mutex_unlock(&server->srv_mutex);
 
@@ -3848,9 +3857,9 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		spin_unlock(&GlobalMid_Lock);
 	}
 
-	kfree(ses->auth_key.response);
-	ses->auth_key.response = NULL;
-	ses->auth_key.len = 0;
+setup_sess_ret:
+	if (server->ops->free_authkey)
+		free_authkey(ses);
 	kfree(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 106a575..1884884 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -426,11 +426,8 @@ void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 	flags = NTLMSSP_NEGOTIATE_56 |	NTLMSSP_REQUEST_TARGET |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
 		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
-	if (ses->server->sign) {
-		flags |= NTLMSSP_NEGOTIATE_SIGN;
-		if (!ses->server->session_estab)
-			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
-	}
+	if (ses->server->sign)
+		flags |= NTLMSSP_NEGOTIATE_SIGN | NTLMSSP_NEGOTIATE_KEY_XCH;
 
 	sec_blob->NegotiateFlags = cpu_to_le32(flags);
 
@@ -464,11 +461,8 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIATE_TARGET_INFO |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
 		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
-	if (ses->server->sign) {
-		flags |= NTLMSSP_NEGOTIATE_SIGN;
-		if (!ses->server->session_estab)
-			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
-	}
+	if (ses->server->sign)
+		flags |= NTLMSSP_NEGOTIATE_SIGN | NTLMSSP_NEGOTIATE_KEY_XCH;
 
 	tmp = pbuffer + sizeof(AUTHENTICATE_MESSAGE);
 	sec_blob->NegotiateFlags = cpu_to_le32(flags);
@@ -734,6 +728,7 @@ ssetup_ntlmssp_authenticate:
 		pSMB->req_no_secext.CaseSensitivePasswordLength =
 			cpu_to_le16(CIFS_AUTH_RESP_SIZE);
 
+		free_authkey(ses);
 		/* calculate ntlm response and session key */
 		rc = setup_ntlm_response(ses, nls_cp);
 		if (rc) {
@@ -760,6 +755,7 @@ ssetup_ntlmssp_authenticate:
 		} else
 			ascii_ssetup_strings(&bcc_ptr, ses, nls_cp);
 	} else if (type == NTLMv2) {
+		free_authkey(ses);
 		pSMB->req_no_secext.Capabilities = cpu_to_le32(capabilities);
 
 		/* LM2 password would be here if we supported it */
@@ -858,6 +854,7 @@ ssetup_ntlmssp_authenticate:
 		pSMB->req.Capabilities |= cpu_to_le32(capabilities);
 		switch(phase) {
 		case NtLmNegotiate:
+			free_authkey(ses);
 			build_ntlmssp_negotiate_blob(
 				pSMB->req.SecurityBlob, ses);
 			iov[1].iov_len = sizeof(NEGOTIATE_MESSAGE);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 6094397..65a94a5 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -945,6 +945,7 @@ struct smb_version_operations smb1_operations = {
 	.mand_unlock_range = cifs_unlock_range,
 	.push_mand_locks = cifs_push_mandatory_locks,
 	.query_mf_symlink = open_query_close_cifs_symlink,
+	.perconnkey = perconnkey,
 };
 
 struct smb_version_values smb1_values = {
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 301b191..eee058d 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -109,6 +109,23 @@ smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
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
 
 int
 smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
@@ -119,23 +136,40 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
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
+		spin_lock(&cifs_tcp_ses_lock);
+		--ses->ses_count;
+		spin_unlock(&cifs_tcp_ses_lock);
 		cifs_dbg(VFS, "%s: shah256 alloc failed\n", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_setkey(server->secmech.hmacsha256,
-		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
+		spin_lock(&cifs_tcp_ses_lock);
+		--ses->ses_count;
+		spin_unlock(&cifs_tcp_ses_lock);
 		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
 		return rc;
 	}
 
+	spin_lock(&cifs_tcp_ses_lock);
+	--ses->ses_count;
+	spin_unlock(&cifs_tcp_ses_lock);
+
 	rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init sha256", __func__);
@@ -193,8 +227,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	return rc;
 }
 
-void
-generate_smb3signingkey(struct TCP_Server_Info *server)
+int
+generate_smb3signingkey(struct TCP_Server_Info *server, struct cifs_ses *ses)
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
@@ -204,7 +238,7 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
 	unsigned char *hashptr = prfhash;
 
 	memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
-	memset(server->smb3signingkey, 0x0, SMB3_SIGNKEY_SIZE);
+	memset(ses->smb3signingkey, 0x0, SMB3_SIGNKEY_SIZE);
 
 	rc = smb3_crypto_shash_allocate(server);
 	if (rc) {
@@ -213,7 +247,7 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
 	}
 
 	rc = crypto_shash_setkey(server->secmech.hmacsha256,
-		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not set with session key\n", __func__);
 		goto smb3signkey_ret;
@@ -267,27 +301,50 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
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
+
+	if (server->ops->generate_signingkey)
+		rc = server->ops->generate_signingkey(server, ses);
+	if (rc) {
+		spin_lock(&cifs_tcp_ses_lock);
+		--ses->ses_count;
+		spin_unlock(&cifs_tcp_ses_lock);
+		cifs_dbg(VFS, "%s: crypto alloc failed\n", __func__);
+		return rc;
+	}
 
 	memset(smb3_signature, 0x0, SMB2_CMACAES_SIZE);
 	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
 	rc = crypto_shash_setkey(server->secmech.cmacaes,
-		server->smb3signingkey, SMB2_CMACAES_SIZE);
+		ses->smb3signingkey, SMB2_CMACAES_SIZE);
+
+	spin_lock(&cifs_tcp_ses_lock);
+	--ses->ses_count;
+	spin_unlock(&cifs_tcp_ses_lock);
+
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not set key for cmac aes\n", __func__);
 		return rc;
@@ -384,6 +441,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 
 	if ((smb2_pdu->Command == SMB2_NEGOTIATE) ||
+	    (smb2_pdu->Command == SMB2_SESSION_SETUP_HE) ||
 	    (smb2_pdu->Command == SMB2_OPLOCK_BREAK) ||
 	    (!server->session_estab))
 		return 0;
-- 
1.7.12.4
