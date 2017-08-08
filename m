From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v4 17/19] crypto: qce: move to generic async completion
Date: Tue,  8 Aug 2017 15:03:48 +0300
Message-ID: <1502193834-11289-18-git-send-email-gilad__25687.4970080846$1502194155$gmane$org@benyossef.com>
References: <1502193834-11289-1-git-send-email-gilad@benyossef.com>
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
In-Reply-To: <1502193834-11289-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The qce driver starts several async crypto ops and  waits for their
completions. Move it over to generic code doing the same.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
---
 drivers/crypto/qce/sha.c | 30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 47e114a..53227d7 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -349,28 +349,12 @@ static int qce_ahash_digest(struct ahash_request *req)
 	return qce->async_req_enqueue(tmpl->qce, &req->base);
 }
 
-struct qce_ahash_result {
-	struct completion completion;
-	int error;
-};
-
-static void qce_digest_complete(struct crypto_async_request *req, int error)
-{
-	struct qce_ahash_result *result = req->data;
-
-	if (error == -EINPROGRESS)
-		return;
-
-	result->error = error;
-	complete(&result->completion);
-}
-
 static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 				 unsigned int keylen)
 {
 	unsigned int digestsize = crypto_ahash_digestsize(tfm);
 	struct qce_sha_ctx *ctx = crypto_tfm_ctx(&tfm->base);
-	struct qce_ahash_result result;
+	struct crypto_wait wait;
 	struct ahash_request *req;
 	struct scatterlist sg;
 	unsigned int blocksize;
@@ -405,9 +389,9 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 		goto err_free_ahash;
 	}
 
-	init_completion(&result.completion);
+	crypto_init_wait(&wait);
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   qce_digest_complete, &result);
+				   crypto_req_done, &wait);
 	crypto_ahash_clear_flags(ahash_tfm, ~0);
 
 	buf = kzalloc(keylen + QCE_MAX_ALIGN_SIZE, GFP_KERNEL);
@@ -420,13 +404,7 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	sg_init_one(&sg, buf, keylen);
 	ahash_request_set_crypt(req, &sg, ctx->authkey, keylen);
 
-	ret = crypto_ahash_digest(req);
-	if (ret == -EINPROGRESS || ret == -EBUSY) {
-		ret = wait_for_completion_interruptible(&result.completion);
-		if (!ret)
-			ret = result.error;
-	}
-
+	ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
 	if (ret)
 		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
-- 
2.1.4
