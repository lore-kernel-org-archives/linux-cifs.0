From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: free blkcipher in smbhash
Date: Mon, 20 Jun 2011 14:33:16 -0400
Message-ID: <1308594796-29004-1-git-send-email-jlayton@redhat.com>
Cc: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is currently leaked in the rc == 0 case.

Reported-by: J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smbencrypt.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 1525d5e..1c5b770 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -90,12 +90,10 @@ smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
 	sg_init_one(&sgout, out, 8);
 
 	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, 8);
-	if (rc) {
+	if (rc)
 		cERROR(1, "could not encrypt crypt key rc: %d\n", rc);
-		crypto_free_blkcipher(tfm_des);
-		goto smbhash_err;
-	}
 
+	crypto_free_blkcipher(tfm_des);
 smbhash_err:
 	return rc;
 }
-- 
1.7.5.4
