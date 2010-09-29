From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/7 cifs] ntlm authentication and signing - Correct response length for ntlmv2 authentication without extended security
Date: Wed, 29 Sep 2010 09:38:48 -0500
Message-ID: <1285771128-23075-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Fix incorrect calculation of case sensitive response length in the
ntlmv2 (without extended security) response.

 
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/sess.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index af18a50..9148fd8 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -739,9 +739,6 @@ ssetup_ntlmssp_authenticate:
 		pSMB->req_no_secext.CaseInsensitivePasswordLength = 0;
 		/*	cpu_to_le16(LM2_SESS_KEY_SIZE); */
 
-		pSMB->req_no_secext.CaseSensitivePasswordLength =
-			cpu_to_le16(sizeof(struct ntlmv2_resp));
-
 		/* calculate session key */
 		rc = setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
 		if (rc) {
@@ -756,11 +753,17 @@ ssetup_ntlmssp_authenticate:
 		if (ses->tilen > 0) {
 			memcpy(bcc_ptr, ses->tiblob, ses->tilen);
 			bcc_ptr += ses->tilen;
+			pSMB->req_no_secext.CaseSensitivePasswordLength =
+				cpu_to_le16(sizeof(struct ntlmv2_resp) +
+						ses->tilen);
 			/* we never did allocate ses->domainName to free */
 			kfree(ses->tiblob);
 			ses->tiblob = NULL;
 			ses->tilen = 0;
-		}
+		} else
+			pSMB->req_no_secext.CaseSensitivePasswordLength =
+				cpu_to_le16(sizeof(struct ntlmv2_resp));
+
 		if (ses->capabilities & CAP_UNICODE) {
 			if (iov[0].iov_len % 2) {
 				*bcc_ptr = 0;
-- 
1.6.0.2
