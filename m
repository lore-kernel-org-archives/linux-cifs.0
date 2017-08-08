From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v4 09/19] crypto: move gcm to generic async completion
Date: Tue,  8 Aug 2017 15:03:40 +0300
Message-ID: <1502193834-11289-10-git-send-email-gilad__17368.9427473166$1502194259$gmane$org@benyossef.com>
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

gcm is starting an async. crypto op and waiting for it complete.
Move it over to generic code doing the same.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
---
 crypto/gcm.c | 32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 3841b5e..fb923a5 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -16,7 +16,6 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/hash.h>
 #include "internal.h"
-#include <linux/completion.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -78,11 +77,6 @@ struct crypto_gcm_req_priv_ctx {
 	} u;
 };
 
-struct crypto_gcm_setkey_result {
-	int err;
-	struct completion completion;
-};
-
 static struct {
 	u8 buf[16];
 	struct scatterlist sg;
@@ -98,17 +92,6 @@ static inline struct crypto_gcm_req_priv_ctx *crypto_gcm_reqctx(
 	return (void *)PTR_ALIGN((u8 *)aead_request_ctx(req), align + 1);
 }
 
-static void crypto_gcm_setkey_done(struct crypto_async_request *req, int err)
-{
-	struct crypto_gcm_setkey_result *result = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	result->err = err;
-	complete(&result->completion);
-}
-
 static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 			     unsigned int keylen)
 {
@@ -119,7 +102,7 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 		be128 hash;
 		u8 iv[16];
 
-		struct crypto_gcm_setkey_result result;
+		struct crypto_wait wait;
 
 		struct scatterlist sg[1];
 		struct skcipher_request req;
@@ -140,21 +123,18 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	if (!data)
 		return -ENOMEM;
 
-	init_completion(&data->result.completion);
+	crypto_init_wait(&data->wait);
 	sg_init_one(data->sg, &data->hash, sizeof(data->hash));
 	skcipher_request_set_tfm(&data->req, ctr);
 	skcipher_request_set_callback(&data->req, CRYPTO_TFM_REQ_MAY_SLEEP |
 						  CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      crypto_gcm_setkey_done,
-				      &data->result);
+				      crypto_req_done,
+				      &data->wait);
 	skcipher_request_set_crypt(&data->req, data->sg, data->sg,
 				   sizeof(data->hash), data->iv);
 
-	err = crypto_skcipher_encrypt(&data->req);
-	if (err == -EINPROGRESS || err == -EBUSY) {
-		wait_for_completion(&data->result.completion);
-		err = data->result.err;
-	}
+	err = crypto_wait_req(crypto_skcipher_encrypt(&data->req),
+							&data->wait);
 
 	if (err)
 		goto out;
-- 
2.1.4
