From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v8 17/20] crypto: talitos: move to generic async completion
Date: Tue,  5 Sep 2017 15:38:56 +0300
Message-ID: <1504615144-29770-18-git-send-email-gilad@benyossef.com>
References: <1504615144-29770-1-git-send-email-gilad@benyossef.com>
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
        Steffen Klassert <steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>,
        Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>,
        Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>,
        Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504615144-29770-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The talitos driver starts several async crypto ops and  waits for their
completions. Move it over to generic code doing the same.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
---
 drivers/crypto/talitos.c | 38 +++++---------------------------------
 1 file changed, 5 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 79791c6..194a307 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2037,22 +2037,6 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 	return 0;
 }
 
-struct keyhash_result {
-	struct completion completion;
-	int err;
-};
-
-static void keyhash_complete(struct crypto_async_request *req, int err)
-{
-	struct keyhash_result *res = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	res->err = err;
-	complete(&res->completion);
-}
-
 static int keyhash(struct crypto_ahash *tfm, const u8 *key, unsigned int keylen,
 		   u8 *hash)
 {
@@ -2060,10 +2044,10 @@ static int keyhash(struct crypto_ahash *tfm, const u8 *key, unsigned int keylen,
 
 	struct scatterlist sg[1];
 	struct ahash_request *req;
-	struct keyhash_result hresult;
+	struct crypto_wait wait;
 	int ret;
 
-	init_completion(&hresult.completion);
+	crypto_init_wait(&wait);
 
 	req = ahash_request_alloc(tfm, GFP_KERNEL);
 	if (!req)
@@ -2072,25 +2056,13 @@ static int keyhash(struct crypto_ahash *tfm, const u8 *key, unsigned int keylen,
 	/* Keep tfm keylen == 0 during hash of the long key */
 	ctx->keylen = 0;
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   keyhash_complete, &hresult);
+				   crypto_req_done, &wait);
 
 	sg_init_one(&sg[0], key, keylen);
 
 	ahash_request_set_crypt(req, sg, hash, keylen);
-	ret = crypto_ahash_digest(req);
-	switch (ret) {
-	case 0:
-		break;
-	case -EINPROGRESS:
-	case -EBUSY:
-		ret = wait_for_completion_interruptible(
-			&hresult.completion);
-		if (!ret)
-			ret = hresult.err;
-		break;
-	default:
-		break;
-	}
+	ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
+
 	ahash_request_free(req);
 
 	return ret;
-- 
2.1.4
