From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Support NTLM2 session security during NTLMSSP authentication [try #3]
Date: Thu,  9 Dec 2010 11:58:11 -0600
Message-ID: <1291917491-5924-1-git-send-email-shirishpargaonkar@gmail.com>
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


Reported-and-Tested-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/sess.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 7b01d3f..ea39f3f 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
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
-- 
1.6.0.2
