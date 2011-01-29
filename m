From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: No need to check crypto blockcipher allocation
Date: Sat, 29 Jan 2011 13:54:58 -0600
Message-ID: <1296330898-1442-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Missed one change as per earlier suggestion.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 0db5f1d..a51585f 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -657,9 +657,10 @@ calc_seckey(struct cifsSesInfo *ses)
 	get_random_bytes(sec_key, CIFS_SESS_KEY_SIZE);
 
 	tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
-	if (!tfm_arc4 || IS_ERR(tfm_arc4)) {
+	if (IS_ERR(tfm_arc4)) {
+		rc = PTR_ERR(tfm_arc4);
 		cERROR(1, "could not allocate crypto API arc4\n");
-		return PTR_ERR(tfm_arc4);
+		return rc;
 	}
 
 	desc.tfm = tfm_arc4;
-- 
1.6.0.2
