From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v5 14/19] ima: move to generic async completion
Date: Mon, 14 Aug 2017 18:21:24 +0300
Message-ID: <1502724094-23305-15-git-send-email-gilad__10830.782846506$1502724491$gmane$org@benyossef.com>
References: <1502724094-23305-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
        David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>,
        Gary Hook <gary.hook-5C7GfCeVMHo@public.gmane.org>,
        Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
        Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
        Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,
        Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-crypto@v
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502724094-23305-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

ima starts several async crypto ops and  waits for their completions.
Move it over to generic code doing the same.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Acked-by: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 security/integrity/ima/ima_crypto.c | 56 +++++++++++--------------------------
 1 file changed, 17 insertions(+), 39 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 802d5d2..0e4db1fe 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -27,11 +27,6 @@
 
 #include "ima.h"
 
-struct ahash_completion {
-	struct completion completion;
-	int err;
-};
-
 /* minimum file size for ahash use */
 static unsigned long ima_ahash_minsize;
 module_param_named(ahash_minsize, ima_ahash_minsize, ulong, 0644);
@@ -196,30 +191,13 @@ static void ima_free_atfm(struct crypto_ahash *tfm)
 		crypto_free_ahash(tfm);
 }
 
-static void ahash_complete(struct crypto_async_request *req, int err)
+static inline int ahash_wait(int err, struct crypto_wait *wait)
 {
-	struct ahash_completion *res = req->data;
 
-	if (err == -EINPROGRESS)
-		return;
-	res->err = err;
-	complete(&res->completion);
-}
+	err = crypto_wait_req(err, wait);
 
-static int ahash_wait(int err, struct ahash_completion *res)
-{
-	switch (err) {
-	case 0:
-		break;
-	case -EINPROGRESS:
-	case -EBUSY:
-		wait_for_completion(&res->completion);
-		reinit_completion(&res->completion);
-		err = res->err;
-		/* fall through */
-	default:
+	if (err)
 		pr_crit_ratelimited("ahash calculation failed: err: %d\n", err);
-	}
 
 	return err;
 }
@@ -233,7 +211,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
 	int rc, read = 0, rbuf_len, active = 0, ahash_rc = 0;
 	struct ahash_request *req;
 	struct scatterlist sg[1];
-	struct ahash_completion res;
+	struct crypto_wait wait;
 	size_t rbuf_size[2];
 
 	hash->length = crypto_ahash_digestsize(tfm);
@@ -242,12 +220,12 @@ static int ima_calc_file_hash_atfm(struct file *file,
 	if (!req)
 		return -ENOMEM;
 
-	init_completion(&res.completion);
+	crypto_init_wait(&wait);
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 				   CRYPTO_TFM_REQ_MAY_SLEEP,
-				   ahash_complete, &res);
+				   crypto_req_done, &wait);
 
-	rc = ahash_wait(crypto_ahash_init(req), &res);
+	rc = ahash_wait(crypto_ahash_init(req), &wait);
 	if (rc)
 		goto out1;
 
@@ -288,7 +266,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
 			 * read/request, wait for the completion of the
 			 * previous ahash_update() request.
 			 */
-			rc = ahash_wait(ahash_rc, &res);
+			rc = ahash_wait(ahash_rc, &wait);
 			if (rc)
 				goto out3;
 		}
@@ -304,7 +282,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
 			 * read/request, wait for the completion of the
 			 * previous ahash_update() request.
 			 */
-			rc = ahash_wait(ahash_rc, &res);
+			rc = ahash_wait(ahash_rc, &wait);
 			if (rc)
 				goto out3;
 		}
@@ -318,7 +296,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
 			active = !active; /* swap buffers, if we use two */
 	}
 	/* wait for the last update request to complete */
-	rc = ahash_wait(ahash_rc, &res);
+	rc = ahash_wait(ahash_rc, &wait);
 out3:
 	if (read)
 		file->f_mode &= ~FMODE_READ;
@@ -327,7 +305,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
 out2:
 	if (!rc) {
 		ahash_request_set_crypt(req, NULL, hash->digest, 0);
-		rc = ahash_wait(crypto_ahash_final(req), &res);
+		rc = ahash_wait(crypto_ahash_final(req), &wait);
 	}
 out1:
 	ahash_request_free(req);
@@ -527,7 +505,7 @@ static int calc_buffer_ahash_atfm(const void *buf, loff_t len,
 {
 	struct ahash_request *req;
 	struct scatterlist sg;
-	struct ahash_completion res;
+	struct crypto_wait wait;
 	int rc, ahash_rc = 0;
 
 	hash->length = crypto_ahash_digestsize(tfm);
@@ -536,12 +514,12 @@ static int calc_buffer_ahash_atfm(const void *buf, loff_t len,
 	if (!req)
 		return -ENOMEM;
 
-	init_completion(&res.completion);
+	crypto_init_wait(&wait);
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 				   CRYPTO_TFM_REQ_MAY_SLEEP,
-				   ahash_complete, &res);
+				   crypto_req_done, &wait);
 
-	rc = ahash_wait(crypto_ahash_init(req), &res);
+	rc = ahash_wait(crypto_ahash_init(req), &wait);
 	if (rc)
 		goto out;
 
@@ -551,10 +529,10 @@ static int calc_buffer_ahash_atfm(const void *buf, loff_t len,
 	ahash_rc = crypto_ahash_update(req);
 
 	/* wait for the update request to complete */
-	rc = ahash_wait(ahash_rc, &res);
+	rc = ahash_wait(ahash_rc, &wait);
 	if (!rc) {
 		ahash_request_set_crypt(req, NULL, hash->digest, 0);
-		rc = ahash_wait(crypto_ahash_final(req), &res);
+		rc = ahash_wait(crypto_ahash_final(req), &wait);
 	}
 out:
 	ahash_request_free(req);
-- 
2.1.4
