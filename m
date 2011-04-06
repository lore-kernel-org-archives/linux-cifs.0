From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Fix extended security auth failure
Date: Wed,  6 Apr 2011 08:46:06 -0500
Message-ID: <1302097566-11576-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Fix authentication failures using extended security mechanisms.
cifs client does not take into consideration extended security bit
in capabilities field in negotiate protocol response from the server.

Please refer to Samba bugzilla 8046.


Reported-and-tested by: Werner Maes <Werner.Maes-UiU5zyVfpuo0a//2gYcwQw@public.gmane.org>
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifssmb.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 3291770..e119d70 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -570,18 +570,10 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 	if (pSMBr->EncryptionKeyLength == CIFS_CRYPTO_KEY_SIZE) {
 		memcpy(ses->server->cryptkey, pSMBr->u.EncryptionKey,
 		       CIFS_CRYPTO_KEY_SIZE);
-	} else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC)
-			&& (pSMBr->EncryptionKeyLength == 0)) {
+	} else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC ||
+			server->capabilities & CAP_EXTENDED_SECURITY) &&
+				(pSMBr->EncryptionKeyLength == 0)) {
 		/* decode security blob */
-	} else if (server->sec_mode & SECMODE_PW_ENCRYPT) {
-		rc = -EIO; /* no crypt key only if plain text pwd */
-		goto neg_err_exit;
-	}
-
-	/* BB might be helpful to save off the domain of server here */
-
-	if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC) &&
-		(server->capabilities & CAP_EXTENDED_SECURITY)) {
 		count = get_bcc(&pSMBr->hdr);
 		if (count < 16) {
 			rc = -EIO;
@@ -624,6 +616,9 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 			} else
 					rc = -EOPNOTSUPP;
 		}
+	} else if (server->sec_mode & SECMODE_PW_ENCRYPT) {
+		rc = -EIO; /* no crypt key only if plain text pwd */
+		goto neg_err_exit;
 	} else
 		server->capabilities &= ~CAP_EXTENDED_SECURITY;
 
-- 
1.6.0.2
