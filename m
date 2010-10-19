From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] [CIFS] Clean up two declarations of blob_len
Date: Tue, 19 Oct 2010 11:47:52 -0500
Message-ID: <1287506872-5700-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


- Eliminate double declaration of variable blob_len
- Modify function build_ntlmssp_auth_blob to return error code
  as well as length of the blob.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/sess.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 2111bed..e35dc60 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -464,6 +464,7 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
    maximum possible size is fixed and small, making this approach cleaner.
    This function returns the length of the data in the blob */
 static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
+					u16 *buflen,
 				   struct cifsSesInfo *ses,
 				   const struct nls_table *nls_cp)
 {
@@ -558,7 +559,8 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->SessionKey.MaximumLength = 0;
 
 setup_ntlmv2_ret:
-	return tmp - pbuffer;
+	*buflen = tmp - pbuffer;
+	return rc;
 }
 
 
@@ -591,7 +593,7 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesInfo *ses,
 	int bytes_remaining;
 	struct key *spnego_key = NULL;
 	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
-	int blob_len;
+	u16 blob_len;
 	char *ntlmsspblob = NULL;
 
 	if (ses == NULL)
@@ -848,8 +850,10 @@ ssetup_ntlmssp_authenticate:
 					goto ssetup_exit;
 				}
 
-				blob_len = build_ntlmssp_auth_blob(ntlmsspblob,
-							ses, nls_cp);
+				rc = build_ntlmssp_auth_blob(ntlmsspblob,
+							&blob_len, ses, nls_cp);
+				if (rc)
+					goto ssetup_exit;
 				iov[1].iov_len = blob_len;
 				iov[1].iov_base = ntlmsspblob;
 				pSMB->req.SecurityBlobLength =
@@ -927,7 +931,6 @@ ssetup_ntlmssp_authenticate:
 	bcc_ptr = pByteArea(smb_buf);
 
 	if (smb_buf->WordCount == 4) {
-		__u16 blob_len;
 		blob_len = le16_to_cpu(pSMB->resp.SecurityBlobLength);
 		if (blob_len > bytes_remaining) {
 			cERROR(1, "bad security blob length %d", blob_len);
-- 
1.6.0.2
