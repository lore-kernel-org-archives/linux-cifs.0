From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 08/15] CIFS: Enable encryption during session setup phase
Date: Tue,  6 Dec 2016 14:02:31 -0800
Message-ID: <1481061758-52020-9-git-send-email-pshilov@microsoft.com>
References: <1481061758-52020-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481061758-52020-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In order to allow encryption on SMB connection we need to exchange
a session key and generate encryption and decryption keys.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/sess.c    | 22 ++++++++++------------
 fs/cifs/smb2pdu.c | 12 ++----------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index a1118e3..dcbcc92 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -344,13 +344,12 @@ void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 	/* BB is NTLMV2 session security format easier to use here? */
 	flags = NTLMSSP_NEGOTIATE_56 |	NTLMSSP_REQUEST_TARGET |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
-	if (ses->server->sign) {
+		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC |
+		NTLMSSP_NEGOTIATE_SEAL;
+	if (ses->server->sign)
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
-		if (!ses->server->session_estab ||
-				ses->ntlmssp->sesskey_per_smbsess)
-			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
-	}
+	if (!ses->server->session_estab || ses->ntlmssp->sesskey_per_smbsess)
+		flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
 
 	sec_blob->NegotiateFlags = cpu_to_le32(flags);
 
@@ -407,13 +406,12 @@ int build_ntlmssp_auth_blob(unsigned char **pbuffer,
 	flags = NTLMSSP_NEGOTIATE_56 |
 		NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIATE_TARGET_INFO |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
-	if (ses->server->sign) {
+		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC |
+		NTLMSSP_NEGOTIATE_SEAL;
+	if (ses->server->sign)
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
-		if (!ses->server->session_estab ||
-				ses->ntlmssp->sesskey_per_smbsess)
-			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
-	}
+	if (!ses->server->session_estab || ses->ntlmssp->sesskey_per_smbsess)
+		flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
 
 	tmp = *pbuffer + sizeof(AUTHENTICATE_MESSAGE);
 	sec_blob->NegotiateFlags = cpu_to_le32(flags);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index bf5b693..b088c50 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -756,15 +756,13 @@ SMB2_sess_establish_session(struct SMB2_sess_data *sess_data)
 	struct cifs_ses *ses = sess_data->ses;
 
 	mutex_lock(&ses->server->srv_mutex);
-	if (ses->server->sign && ses->server->ops->generate_signingkey) {
+	if (ses->server->ops->generate_signingkey) {
 		rc = ses->server->ops->generate_signingkey(ses);
-		kfree(ses->auth_key.response);
-		ses->auth_key.response = NULL;
 		if (rc) {
 			cifs_dbg(FYI,
 				"SMB3 session key generation failed\n");
 			mutex_unlock(&ses->server->srv_mutex);
-			goto keygen_exit;
+			return rc;
 		}
 	}
 	if (!ses->server->session_estab) {
@@ -778,12 +776,6 @@ SMB2_sess_establish_session(struct SMB2_sess_data *sess_data)
 	ses->status = CifsGood;
 	ses->need_reconnect = false;
 	spin_unlock(&GlobalMid_Lock);
-
-keygen_exit:
-	if (!ses->server->sign) {
-		kfree(ses->auth_key.response);
-		ses->auth_key.response = NULL;
-	}
 	return rc;
 }
 
-- 
2.7.4
