From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Stop using NTLMSSP flag bit NTLMSSP_NEGOTIATE_EXTENDED_SEC
Date: Tue,  4 Feb 2014 16:57:40 -0600
Message-ID: <1391554660-11308-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>


Since cifs client does not support NTLM2 Session Security, do not set
bit NTLMSSP_NEGOTIATE_EXTENDED_SESSIONSECURITY in Negotiate and
Authenticate messages of the NTLMSSP exchange during session setup. 

Send EncryptedRandomSessionKey in an Authenticate message of NTLMSSP exchange
based only on whether server set NTLMSSP_NEGOTIATE_KEY_EXCH in the
Challenge message of the NTLMSSP exchange.


Reported-by: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Signed-off-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/sess.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index e87387d..cdc57be 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -343,7 +343,7 @@ void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 	/* BB is NTLMV2 session security format easier to use here? */
 	flags = NTLMSSP_NEGOTIATE_56 |	NTLMSSP_REQUEST_TARGET |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
+		NTLMSSP_NEGOTIATE_NTLM;
 	if (ses->server->sign) {
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
 		if (!ses->server->session_estab ||
@@ -382,7 +382,7 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	flags = NTLMSSP_NEGOTIATE_56 |
 		NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIATE_TARGET_INFO |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
+		NTLMSSP_NEGOTIATE_NTLM;
 	if (ses->server->sign) {
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
 		if (!ses->server->session_estab ||
@@ -450,8 +450,7 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->WorkstationName.MaximumLength = 0;
 	tmp += 2;
 
-	if (((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY_XCH) ||
-		(ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
+	if ((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY_XCH)
 			&& !calc_seckey(ses)) {
 		memcpy(tmp, ses->ntlmssp->ciphertext, CIFS_CPHTXT_SIZE);
 		sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
-- 
1.8.3.2
