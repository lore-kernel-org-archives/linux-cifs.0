From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Fix regression in LANMAN (LM) auth code
Date: Thu, 17 Feb 2011 14:38:31 -0600
Message-ID: <1297975111-4466-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

LANMAN response length was changed to 16 bytes instead of 24 bytes.
Revert it back to 24 bytes.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/sess.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 1adc962..1676570 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -656,13 +656,13 @@ ssetup_ntlmssp_authenticate:
 
 	if (type == LANMAN) {
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
-		char lnm_session_key[CIFS_SESS_KEY_SIZE];
+		char lnm_session_key[CIFS_AUTH_RESP_SIZE];
 
 		pSMB->req.hdr.Flags2 &= ~SMBFLG2_UNICODE;
 
 		/* no capabilities flags in old lanman negotiation */
 
-		pSMB->old_req.PasswordLength = cpu_to_le16(CIFS_SESS_KEY_SIZE);
+		pSMB->old_req.PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
 
 		/* Calculate hash with password and copy into bcc_ptr.
 		 * Encryption Key (stored as in cryptkey) gets used if the
@@ -675,8 +675,8 @@ ssetup_ntlmssp_authenticate:
 					true : false, lnm_session_key);
 
 		ses->flags |= CIFS_SES_LANMAN;
-		memcpy(bcc_ptr, (char *)lnm_session_key, CIFS_SESS_KEY_SIZE);
-		bcc_ptr += CIFS_SESS_KEY_SIZE;
+		memcpy(bcc_ptr, (char *)lnm_session_key, CIFS_AUTH_RESP_SIZE);
+		bcc_ptr += CIFS_AUTH_RESP_SIZE;
 
 		/* can not sign if LANMAN negotiated so no need
 		to calculate signing key? but what if server
-- 
1.6.0.2
