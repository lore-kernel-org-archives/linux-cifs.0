From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Support NTLM2 session security during NTLMSSP authentication [try #4]
Date: Fri, 10 Dec 2010 10:30:47 -0600
Message-ID: <1291998647-10763-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Indicate to the server a capability of NTLM2 session security (NTLM2 Key)
during ntlmssp protocol exchange in one of the bits of the flags field.
If server supports this capability, send NTLM2 key even if signing is not
required on the server.

If the server requires signing, the session keys exchanged for NTLMv2
and NTLM2 session security in auth packet of the nlmssp exchange are same.

Send the same flags in authenticate message (type 3) that client sent in
negotiate message (type 1).

Remove function setup_ntlmssp_neg_req() and allocate zero'ed buffers
to prepare ntlmssp negotiate and authenticat requests.


Reported-and-Tested-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/sess.c |   46 +++++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 7b01d3f..56e945a 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -425,7 +425,7 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 
 /* We do not malloc the blob, it is passed in pbuffer, because
    it is fixed size, and small, making this approach cleaner */
-static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
+static void build_ntlmssp_negotiate_blob(char *pbuffer,
 					 struct cifsSesInfo *ses)
 {
 	NEGOTIATE_MESSAGE *sec_blob = (NEGOTIATE_MESSAGE *)pbuffer;
@@ -437,7 +437,7 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 	/* BB is NTLMV2 session security format easier to use here? */
 	flags = NTLMSSP_NEGOTIATE_56 |	NTLMSSP_REQUEST_TARGET |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NTLM;
+		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 	if (ses->server->secMode &
 			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
@@ -446,7 +446,7 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 				NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 	}
 
-	sec_blob->NegotiateFlags |= cpu_to_le32(flags);
+	sec_blob->NegotiateFlags = cpu_to_le32(flags);
 
 	sec_blob->WorkstationName.BufferOffset = 0;
 	sec_blob->WorkstationName.Length = 0;
@@ -477,7 +477,7 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	flags = NTLMSSP_NEGOTIATE_56 |
 		NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIATE_TARGET_INFO |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NTLM;
+		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 	if (ses->server->secMode &
 	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
@@ -485,7 +485,7 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		flags |= NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
 
 	tmp = pbuffer + sizeof(AUTHENTICATE_MESSAGE);
-	sec_blob->NegotiateFlags |= cpu_to_le32(flags);
+	sec_blob->NegotiateFlags = cpu_to_le32(flags);
 
 	sec_blob->LmChallengeResponse.BufferOffset =
 				cpu_to_le32(sizeof(AUTHENTICATE_MESSAGE));
@@ -544,8 +544,9 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->WorkstationName.MaximumLength = 0;
 	tmp += 2;
 
-	if ((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY_XCH) &&
-			!calc_seckey(ses)) {
+	if (((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY_XCH) ||
+		(ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
+			&& !calc_seckey(ses)) {
 		memcpy(tmp, ses->ntlmssp->ciphertext, CIFS_CPHTXT_SIZE);
 		sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
 		sec_blob->SessionKey.Length = cpu_to_le16(CIFS_CPHTXT_SIZE);
@@ -562,16 +563,6 @@ setup_ntlmv2_ret:
 	*buflen = tmp - pbuffer;
 	return rc;
 }
-
-
-static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
-				 struct cifsSesInfo *ses)
-{
-	build_ntlmssp_negotiate_blob(&pSMB->req.SecurityBlob[0], ses);
-	pSMB->req.SecurityBlobLength = cpu_to_le16(sizeof(NEGOTIATE_MESSAGE));
-
-	return;
-}
 #endif
 
 int
@@ -595,6 +586,7 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesInfo *ses,
 	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
 	u16 blob_len;
 	char *ntlmsspblob = NULL;
+	char *ntlmsspnblob = NULL;
 
 	if (ses == NULL)
 		return -EINVAL;
@@ -828,16 +820,26 @@ ssetup_ntlmssp_authenticate:
 			capabilities |= CAP_EXTENDED_SECURITY;
 			pSMB->req.Capabilities |= cpu_to_le32(capabilities);
 			if (phase == NtLmNegotiate) {
-				setup_ntlmssp_neg_req(pSMB, ses);
+				ntlmsspnblob = kzalloc(
+					sizeof(struct _NEGOTIATE_MESSAGE),
+					GFP_KERNEL);
+				if (!ntlmsspnblob) {
+					cERROR(1, "Can't allocate NTLMSSPN");
+					rc = -ENOMEM;
+					goto ssetup_exit;
+				}
+				build_ntlmssp_negotiate_blob(ntlmsspnblob, ses);
 				iov[1].iov_len = sizeof(NEGOTIATE_MESSAGE);
-				iov[1].iov_base = &pSMB->req.SecurityBlob[0];
+				iov[1].iov_base = ntlmsspnblob;
+				pSMB->req.SecurityBlobLength =
+					cpu_to_le16(sizeof(NEGOTIATE_MESSAGE));
 			} else if (phase == NtLmAuthenticate) {
-				/* 5 is an empirical value, large enought to
+				/* 5 is an empirical value, large enough to
 				 * hold authenticate message, max 10 of
 				 * av paris, doamin,user,workstation mames,
 				 * flags etc..
 				 */
-				ntlmsspblob = kmalloc(
+				ntlmsspblob = kzalloc(
 					5*sizeof(struct _AUTHENTICATE_MESSAGE),
 					GFP_KERNEL);
 				if (!ntlmsspblob) {
@@ -960,6 +962,8 @@ ssetup_exit:
 		key_put(spnego_key);
 	}
 	kfree(str_area);
+	kfree(ntlmsspnblob);
+	ntlmsspnblob = NULL;
 	kfree(ntlmsspblob);
 	ntlmsspblob = NULL;
 	if (resp_buf_type == CIFS_SMALL_BUFFER) {
-- 
1.6.0.2
