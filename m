From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Fix regression during share-level security mounts
Date: Thu,  6 Jan 2011 09:24:03 -0600
Message-ID: <1294327443-24293-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


NTLM response length was changed during to 16 bytes instead of 24 bytes
that get sent in Tree Connection Request during share-level security
share mounts.  Revert it back to 24 bytes.


Reported-by: Grzegorz Ozanski <grzegorz.ozanski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 41f002f..cdba196 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2966,7 +2966,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 		bcc_ptr++;              /* skip password */
 		/* already aligned so no need to do it below */
 	} else {
-		pSMB->PasswordLength = cpu_to_le16(CIFS_SESS_KEY_SIZE);
+		pSMB->PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
 		/* BB FIXME add code to fail this if NTLMv2 or Kerberos
 		   specified as required (when that support is added to
 		   the vfs in the future) as only NTLM or the much
@@ -2984,7 +2984,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 #endif /* CIFS_WEAK_PW_HASH */
 		SMBNTencrypt(tcon->password, ses->server->cryptkey, bcc_ptr);
 
-		bcc_ptr += CIFS_SESS_KEY_SIZE;
+		bcc_ptr += CIFS_AUTH_RESP_SIZE;
 		if (ses->capabilities & CAP_UNICODE) {
 			/* must align unicode strings */
 			*bcc_ptr = 0; /* null byte password */
-- 
1.6.0.2
