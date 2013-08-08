From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 1/2] cifs: Make session key from per smb connection to per smb session
Date: Thu,  8 Aug 2013 09:53:48 -0500
Message-ID: <1375973628-6218-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Change session key from per smb connection to per smb session for
smb2 onwards.
perconnkey is defined for only cifs/smb.
For smb3, generate signing key per smb session.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c | 20 ++++++++++++++++++++
 fs/cifs/cifsglob.h    |  2 ++
 fs/cifs/cifsproto.h   |  3 +++
 fs/cifs/connect.c     | 27 +++++++++++++++++++--------
 fs/cifs/sess.c        |  6 ++++--
 fs/cifs/smb1ops.c     |  1 +
 fs/cifs/smb2pdu.c     |  1 +
 7 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 45e57cc..f9ef57a 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -720,6 +720,26 @@ setup_ntlmv2_rsp_ret:
 	return rc;
 }
 
+void
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
+		ses->auth_key.len, GFP_KERNEL);
+	if (!server->session_key.response)
+		return -ENOMEM;
+	server->session_key.len = ses->auth_key.len;
+
+	return 0;
+}
+
 int
 calc_seckey(struct cifs_ses *ses)
 {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1fdc370..2909380 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -365,6 +365,8 @@ struct smb_version_operations {
 	void (*set_lease_key)(struct inode *, struct cifs_fid *fid);
 	/* generate new lease key */
 	void (*new_lease_key)(struct cifs_fid *fid);
+	int (*perconnkey)(struct TCP_Server_Info *server,
+					struct cifs_ses *ses);
 	/* The next two functions will need to be changed to per smb session */
 	void (*generate_signingkey)(struct TCP_Server_Info *server);
 	int (*calc_signature)(struct smb_rqst *rqst,
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index f7e584d..b6c1d03 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -437,6 +437,9 @@ extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
 extern int calc_seckey(struct cifs_ses *);
 extern void generate_smb3signingkey(struct TCP_Server_Info *);
 
+extern int perconnkey(struct TCP_Server_Info *, struct cifs_ses *);
+extern void free_authkey(struct cifs_ses *);
+
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 extern int calc_lanman_hash(const char *password, const char *cryptkey,
 				bool encrypt, char *lnm_session_key);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fa68813..98deb98 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2117,6 +2117,8 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		goto out_err_crypto_release;
 	}
 
+	tcp_ses->session_key.response = NULL;
+	tcp_ses->session_key.len = 0;
 	tcp_ses->noblocksnd = volume_info->noblocksnd;
 	tcp_ses->noautotune = volume_info->noautotune;
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
@@ -2270,6 +2272,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 		server->ops->logoff(xid, ses);
 		_free_xid(xid);
 	}
+	if (!server->ops->perconnkey)
+		free_authkey(ses);
 	sesInfoFree(ses);
 	cifs_put_tcp_session(server);
 }
@@ -2484,6 +2488,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	ses->sectype = volume_info->sectype;
 	ses->sign = volume_info->sign;
 
+	ses->auth_key.response = NULL;
+	ses->auth_key.len = 0;
+
 	mutex_lock(&ses->session_mutex);
 	rc = cifs_negotiate_protocol(xid, ses);
 	if (!rc)
@@ -3830,14 +3837,18 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
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
+		if (server->ops->generate_signingkey)
+			server->ops->generate_signingkey(server);
 		mutex_unlock(&server->srv_mutex);
 
 		cifs_dbg(FYI, "CIFS Session Established successfully\n");
@@ -3847,9 +3858,9 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		spin_unlock(&GlobalMid_Lock);
 	}
 
-	kfree(ses->auth_key.response);
-	ses->auth_key.response = NULL;
-	ses->auth_key.len = 0;
+setup_sess_ret:
+	if (server->ops->perconnkey)
+		free_authkey(ses);
 	kfree(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 79358e3..77642cd 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -428,7 +428,8 @@ void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 	if (ses->server->sign) {
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
-		if (!ses->server->session_estab)
+		if ((!ses->server->session_estab) ||
+				(!ses->server->ops->perconnkey))
 			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
 	}
 
@@ -466,7 +467,8 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 	if (ses->server->sign) {
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
-		if (!ses->server->session_estab)
+		if ((!ses->server->session_estab) ||
+				(!ses->server->ops->perconnkey))
 			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
 	}
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 6457690..331b406 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -944,6 +944,7 @@ struct smb_version_operations smb1_operations = {
 	.mand_lock = cifs_mand_lock,
 	.mand_unlock_range = cifs_unlock_range,
 	.push_mand_locks = cifs_push_mandatory_locks,
+	.perconnkey = perconnkey,
 };
 
 struct smb_version_values smb1_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index abc9c28..11de60b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -477,6 +477,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 		return -EIO;
 	}
 
+	free_authkey(ses);
 	/*
 	 * If memory allocation is successful, caller of this function
 	 * frees it.
-- 
1.8.1.2
