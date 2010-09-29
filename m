From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 5/7 cifs]  ntlm authentication and signing - Copy auth key data to session key for first successful smb session for an smb connection
Date: Wed, 29 Sep 2010 09:40:06 -0500
Message-ID: <1285771206-23195-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Only after a very first smb session succeeds, it copies/makes its
session key, session key of smb connection.  This key stays with
the smb connection throughout its life.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |    9 +++++++++
 fs/cifs/sess.c    |   19 ++++---------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f96f3c6..7e72591 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3086,6 +3086,15 @@ int cifs_setup_session(unsigned int xid, struct cifsSesInfo *ses,
 	if (rc) {
 		cERROR(1, "Send error in SessSetup = %d", rc);
 	} else {
+		mutex_lock(&ses->server->srv_mutex);
+		if (!server->session_estab) {
+			memcpy(&server->session_key.data,
+				&ses->auth_key.data, ses->auth_key.len);
+			server->session_key.len = ses->auth_key.len;
+			ses->server->session_estab = true;
+		}
+		mutex_unlock(&server->srv_mutex);
+
 		cFYI(1, "CIFS Session Established successfully");
 		spin_lock(&GlobalMid_Lock);
 		ses->status = CifsGood;
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 588de94..8ddd2be 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -582,17 +582,12 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesInfo *ses,
 	int bytes_remaining;
 	struct key *spnego_key = NULL;
 	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
-	bool first_time;
 	int blob_len;
 	char *ntlmsspblob = NULL;
 
 	if (ses == NULL)
 		return -EINVAL;
 
-	read_lock(&cifs_tcp_ses_lock);
-	first_time = is_first_ses_reconnect(ses);
-	read_unlock(&cifs_tcp_ses_lock);
-
 	type = ses->server->secType;
 
 	cFYI(1, "sess setup type %d", type);
@@ -692,12 +687,9 @@ ssetup_ntlmssp_authenticate:
 		/* calculate session key */
 		SMBNTencrypt(ses->password, ses->cryptKey, ntlm_session_key);
 
-		if (first_time) /* should this be moved into common code
-				   with similar ntlmv2 path? */
-			cifs_calculate_session_key(&ses->auth_key,
-				ntlm_session_key, ses->password);
+		cifs_calculate_session_key(&ses->auth_key,
+					ntlm_session_key, ses->password);
 		/* copy session key */
-
 		memcpy(bcc_ptr, (char *)ntlm_session_key, CIFS_SESS_KEY_SIZE);
 		bcc_ptr += CIFS_SESS_KEY_SIZE;
 		memcpy(bcc_ptr, (char *)ntlm_session_key, CIFS_SESS_KEY_SIZE);
@@ -787,11 +779,8 @@ ssetup_ntlmssp_authenticate:
 			rc = -EOVERFLOW;
 			goto ssetup_exit;
 		}
-		if (first_time) {
-			ses->auth_key.len = msg->sesskey_len;
-			memcpy(ses->auth_key.data.krb5,
-				msg->data, msg->sesskey_len);
-		}
+		ses->auth_key.len = msg->sesskey_len;
+		memcpy(ses->auth_key.data.krb5, msg->data, msg->sesskey_len);
 		pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
 		capabilities |= CAP_EXTENDED_SECURITY;
 		pSMB->req.Capabilities = cpu_to_le32(capabilities);
-- 
1.6.0.2
