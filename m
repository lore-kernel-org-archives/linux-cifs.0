From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2] cifs: Stop using NTLMSSP flag bit NTLMSSP_NEGOTIATE_EXTENDED_SEC for key exchange
Date: Thu, 20 Mar 2014 15:27:06 -0500
Message-ID: <1395347226-9184-1-git-send-email-spargaonkar@suse.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org,
	Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>


Send EncryptedRandomSessionKey in an Authenticate message of NTLMSSP exchange
based only on whether server set flag bit NTLMSSP_NEGOTIATE_KEY_EXCH in the
Challenge message of the NTLMSSP exchange.

This is per section of MS-NLMP.
3.1.5.1.2 Client Receives a CHALLENGE_MESSAGE from the Server


Reported-by: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Signed-off-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/sess.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index e87387d..1bd6f4f 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
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
