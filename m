From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v8 09/20] crypto: move drbg to generic async completion
Date: Tue,  5 Sep 2017 15:38:48 +0300
Message-ID: <1504615144-29770-10-git-send-email-gilad__3531.2416068793$1504615346$gmane$org@benyossef.com>
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

DRBG is starting an async. crypto op and waiting for it complete.
Move it over to generic code doing the same.

The code now also passes CRYPTO_TFM_REQ_MAY_SLEEP flag indicating
crypto request memory allocation may use GFP_KERNEL which should
be perfectly fine as the code is obviously sleeping for the
completion of the request any way.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
---
 crypto/drbg.c         | 36 +++++++++---------------------------
 include/crypto/drbg.h |  3 +--
 2 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 633a88e..c522251 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1651,16 +1651,6 @@ static int drbg_fini_sym_kernel(struct drbg_state *drbg)
 	return 0;
 }
 
-static void drbg_skcipher_cb(struct crypto_async_request *req, int error)
-{
-	struct drbg_state *drbg = req->data;
-
-	if (error == -EINPROGRESS)
-		return;
-	drbg->ctr_async_err = error;
-	complete(&drbg->ctr_completion);
-}
-
 static int drbg_init_sym_kernel(struct drbg_state *drbg)
 {
 	struct crypto_cipher *tfm;
@@ -1691,7 +1681,7 @@ static int drbg_init_sym_kernel(struct drbg_state *drbg)
 		return PTR_ERR(sk_tfm);
 	}
 	drbg->ctr_handle = sk_tfm;
-	init_completion(&drbg->ctr_completion);
+	crypto_init_wait(&drbg->ctr_wait);
 
 	req = skcipher_request_alloc(sk_tfm, GFP_KERNEL);
 	if (!req) {
@@ -1700,8 +1690,9 @@ static int drbg_init_sym_kernel(struct drbg_state *drbg)
 		return -ENOMEM;
 	}
 	drbg->ctr_req = req;
-	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					drbg_skcipher_cb, drbg);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+						CRYPTO_TFM_REQ_MAY_SLEEP,
+					crypto_req_done, &drbg->ctr_wait);
 
 	alignmask = crypto_skcipher_alignmask(sk_tfm);
 	drbg->ctr_null_value_buf = kzalloc(DRBG_CTR_NULL_LEN + alignmask,
@@ -1762,21 +1753,12 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 		/* Output buffer may not be valid for SGL, use scratchpad */
 		skcipher_request_set_crypt(drbg->ctr_req, &sg_in, &sg_out,
 					   cryptlen, drbg->V);
-		ret = crypto_skcipher_encrypt(drbg->ctr_req);
-		switch (ret) {
-		case 0:
-			break;
-		case -EINPROGRESS:
-		case -EBUSY:
-			wait_for_completion(&drbg->ctr_completion);
-			if (!drbg->ctr_async_err) {
-				reinit_completion(&drbg->ctr_completion);
-				break;
-			}
-		default:
+		ret = crypto_wait_req(crypto_skcipher_encrypt(drbg->ctr_req),
+					&drbg->ctr_wait);
+		if (ret)
 			goto out;
-		}
-		init_completion(&drbg->ctr_completion);
+
+		crypto_init_wait(&drbg->ctr_wait);
 
 		memcpy(outbuf, drbg->outscratchpad, cryptlen);
 
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 22f884c..8f94110 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -126,8 +126,7 @@ struct drbg_state {
 	__u8 *ctr_null_value;			/* CTR mode aligned zero buf */
 	__u8 *outscratchpadbuf;			/* CTR mode output scratchpad */
         __u8 *outscratchpad;			/* CTR mode aligned outbuf */
-	struct completion ctr_completion;	/* CTR mode async handler */
-	int ctr_async_err;			/* CTR mode async error */
+	struct crypto_wait ctr_wait;		/* CTR mode async wait obj */
 
 	bool seeded;		/* DRBG fully seeded? */
 	bool pr;		/* Prediction resistance enabled? */
-- 
2.1.4
