From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/7 cifs] ntlm authentication and signing - Correct response length for ntlmv2 authentication without extended security
Date: Mon,  4 Oct 2010 19:56:13 -0500
Message-ID: <1286240173-30716-1-git-send-email-shirishpargaonkar@gmail.com>
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
 fs/cifs/sess.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index af18a50..c926e6c 100644
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
@@ -753,6 +750,11 @@ ssetup_ntlmssp_authenticate:
 				sizeof(struct ntlmv2_resp));
 		bcc_ptr += sizeof(struct ntlmv2_resp);
 		kfree(v2_sess_key);
+		/* set case sensitive password length after tilen may get
+		 * assigned, tilen is 0 otherwise.
+		 */
+		pSMB->req_no_secext.CaseSensitivePasswordLength =
+			cpu_to_le16(sizeof(struct ntlmv2_resp) + ses->tilen);
 		if (ses->tilen > 0) {
 			memcpy(bcc_ptr, ses->tiblob, ses->tilen);
 			bcc_ptr += ses->tilen;
@@ -761,6 +763,7 @@ ssetup_ntlmssp_authenticate:
 			ses->tiblob = NULL;
 			ses->tilen = 0;
 		}
+
 		if (ses->capabilities & CAP_UNICODE) {
 			if (iov[0].iov_len % 2) {
 				*bcc_ptr = 0;
-- 
1.6.0.2
