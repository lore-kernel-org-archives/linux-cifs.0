From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v8 04/20] crypto: remove redundant backlog checks on EBUSY
Date: Tue,  5 Sep 2017 15:38:43 +0300
Message-ID: <1504615144-29770-5-git-send-email-gilad__26821.1274677471$1504615736$gmane$org@benyossef.com>
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

Now that -EBUSY return code only indicates backlog queueing
we can safely remove the now redundant check for the
CRYPTO_TFM_REQ_MAY_BACKLOG flag when -EBUSY is returned.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
---
 crypto/ahash.c        | 12 +++---------
 crypto/cts.c          |  6 ++----
 crypto/lrw.c          |  8 ++------
 crypto/rsa-pkcs1pad.c | 16 ++++------------
 crypto/xts.c          |  8 ++------
 5 files changed, 13 insertions(+), 37 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 5e8666e..3a35d67 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -334,9 +334,7 @@ static int ahash_op_unaligned(struct ahash_request *req,
 		return err;
 
 	err = op(req);
-	if (err == -EINPROGRESS ||
-	    (err == -EBUSY && (ahash_request_flags(req) &
-			       CRYPTO_TFM_REQ_MAY_BACKLOG)))
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
 	ahash_restore_req(req, err);
@@ -394,9 +392,7 @@ static int ahash_def_finup_finish1(struct ahash_request *req, int err)
 	req->base.complete = ahash_def_finup_done2;
 
 	err = crypto_ahash_reqtfm(req)->final(req);
-	if (err == -EINPROGRESS ||
-	    (err == -EBUSY && (ahash_request_flags(req) &
-			       CRYPTO_TFM_REQ_MAY_BACKLOG)))
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
 out:
@@ -432,9 +428,7 @@ static int ahash_def_finup(struct ahash_request *req)
 		return err;
 
 	err = tfm->update(req);
-	if (err == -EINPROGRESS ||
-	    (err == -EBUSY && (ahash_request_flags(req) &
-			       CRYPTO_TFM_REQ_MAY_BACKLOG)))
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
 	return ahash_def_finup_finish1(req, err);
diff --git a/crypto/cts.c b/crypto/cts.c
index 243f591..4773c18 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -136,8 +136,7 @@ static void crypto_cts_encrypt_done(struct crypto_async_request *areq, int err)
 		goto out;
 
 	err = cts_cbc_encrypt(req);
-	if (err == -EINPROGRESS ||
-	    (err == -EBUSY && req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
 out:
@@ -229,8 +228,7 @@ static void crypto_cts_decrypt_done(struct crypto_async_request *areq, int err)
 		goto out;
 
 	err = cts_cbc_decrypt(req);
-	if (err == -EINPROGRESS ||
-	    (err == -EBUSY && req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
 out:
diff --git a/crypto/lrw.c b/crypto/lrw.c
index a8bfae4..695cea9 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -328,9 +328,7 @@ static int do_encrypt(struct skcipher_request *req, int err)
 		      crypto_skcipher_encrypt(subreq) ?:
 		      post_crypt(req);
 
-		if (err == -EINPROGRESS ||
-		    (err == -EBUSY &&
-		     req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+		if (err == -EINPROGRESS || err == -EBUSY)
 			return err;
 	}
 
@@ -380,9 +378,7 @@ static int do_decrypt(struct skcipher_request *req, int err)
 		      crypto_skcipher_decrypt(subreq) ?:
 		      post_crypt(req);
 
-		if (err == -EINPROGRESS ||
-		    (err == -EBUSY &&
-		     req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+		if (err == -EINPROGRESS || err == -EBUSY)
 			return err;
 	}
 
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 407c64b..2908f93 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -279,9 +279,7 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
 				   req->dst, ctx->key_size - 1, req->dst_len);
 
 	err = crypto_akcipher_encrypt(&req_ctx->child_req);
-	if (err != -EINPROGRESS &&
-			(err != -EBUSY ||
-			 !(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))
+	if (err != -EINPROGRESS && err != -EBUSY)
 		return pkcs1pad_encrypt_sign_complete(req, err);
 
 	return err;
@@ -383,9 +381,7 @@ static int pkcs1pad_decrypt(struct akcipher_request *req)
 				   ctx->key_size);
 
 	err = crypto_akcipher_decrypt(&req_ctx->child_req);
-	if (err != -EINPROGRESS &&
-			(err != -EBUSY ||
-			 !(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))
+	if (err != -EINPROGRESS && err != -EBUSY)
 		return pkcs1pad_decrypt_complete(req, err);
 
 	return err;
@@ -440,9 +436,7 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 				   req->dst, ctx->key_size - 1, req->dst_len);
 
 	err = crypto_akcipher_sign(&req_ctx->child_req);
-	if (err != -EINPROGRESS &&
-			(err != -EBUSY ||
-			 !(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))
+	if (err != -EINPROGRESS && err != -EBUSY)
 		return pkcs1pad_encrypt_sign_complete(req, err);
 
 	return err;
@@ -561,9 +555,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 				   ctx->key_size);
 
 	err = crypto_akcipher_verify(&req_ctx->child_req);
-	if (err != -EINPROGRESS &&
-			(err != -EBUSY ||
-			 !(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))
+	if (err != -EINPROGRESS && err != -EBUSY)
 		return pkcs1pad_verify_complete(req, err);
 
 	return err;
diff --git a/crypto/xts.c b/crypto/xts.c
index d86c11a..af68012 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -269,9 +269,7 @@ static int do_encrypt(struct skcipher_request *req, int err)
 		      crypto_skcipher_encrypt(subreq) ?:
 		      post_crypt(req);
 
-		if (err == -EINPROGRESS ||
-		    (err == -EBUSY &&
-		     req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+		if (err == -EINPROGRESS || err == -EBUSY)
 			return err;
 	}
 
@@ -321,9 +319,7 @@ static int do_decrypt(struct skcipher_request *req, int err)
 		      crypto_skcipher_decrypt(subreq) ?:
 		      post_crypt(req);
 
-		if (err == -EINPROGRESS ||
-		    (err == -EBUSY &&
-		     req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+		if (err == -EINPROGRESS || err == -EBUSY)
 			return err;
 	}
 
-- 
2.1.4
