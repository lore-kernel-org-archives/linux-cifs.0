From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [RFC 01/10] crypto: factor async completion for general use
Date: Sat,  6 May 2017 15:59:50 +0300
Message-ID: <1494075602-5061-2-git-send-email-gilad@benyossef.com>
References: <1494075602-5061-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-fsdevel@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, Steve French <sfrench@samba.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1494075602-5061-1-git-send-email-gilad@benyossef.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Invoking a possibly async. crypto op and waiting for completion
while correctly handling backlog processing is a common task
in the crypto API implementation and outside users of it.

This patch re-factors one of the in crypto API implementation in
preparation for using it across the board instead of hand
rolled versions.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/af_alg.c         | 27 ---------------------------
 crypto/algif_aead.c     | 14 +++++++-------
 crypto/algif_hash.c     | 30 +++++++++++++++---------------
 crypto/algif_skcipher.c | 10 +++++-----
 crypto/api.c            | 28 ++++++++++++++++++++++++++++
 include/crypto/if_alg.h | 14 --------------
 include/linux/crypto.h  | 28 ++++++++++++++++++++++++++++
 7 files changed, 83 insertions(+), 68 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 3556d8e..bf4acaf 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -480,33 +480,6 @@ int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
 }
 EXPORT_SYMBOL_GPL(af_alg_cmsg_send);
 
-int af_alg_wait_for_completion(int err, struct af_alg_completion *completion)
-{
-	switch (err) {
-	case -EINPROGRESS:
-	case -EBUSY:
-		wait_for_completion(&completion->completion);
-		reinit_completion(&completion->completion);
-		err = completion->err;
-		break;
-	};
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(af_alg_wait_for_completion);
-
-void af_alg_complete(struct crypto_async_request *req, int err)
-{
-	struct af_alg_completion *completion = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	completion->err = err;
-	complete(&completion->completion);
-}
-EXPORT_SYMBOL_GPL(af_alg_complete);
-
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 8af664f..9543589 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -57,7 +57,7 @@ struct aead_ctx {
 
 	void *iv;
 
-	struct af_alg_completion completion;
+	struct crypto_wait wait;
 
 	unsigned long used;
 
@@ -648,10 +648,10 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 			       used, ctx->iv);
 	aead_request_set_ad(&ctx->aead_req, ctx->aead_assoclen);
 
-	err = af_alg_wait_for_completion(ctx->enc ?
-					 crypto_aead_encrypt(&ctx->aead_req) :
-					 crypto_aead_decrypt(&ctx->aead_req),
-					 &ctx->completion);
+	err = crypto_wait_req(ctx->enc ?
+				 crypto_aead_encrypt(&ctx->aead_req) :
+				 crypto_aead_decrypt(&ctx->aead_req),
+				 &ctx->wait);
 
 	if (err) {
 		/* EBADMSG implies a valid cipher operation took place */
@@ -912,7 +912,7 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
 	ctx->enc = 0;
 	ctx->tsgl.cur = 0;
 	ctx->aead_assoclen = 0;
-	af_alg_init_completion(&ctx->completion);
+	crypto_init_wait(&ctx->wait);
 	sg_init_table(ctx->tsgl.sg, ALG_MAX_PAGES);
 	INIT_LIST_HEAD(&ctx->list);
 
@@ -920,7 +920,7 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
 
 	aead_request_set_tfm(&ctx->aead_req, aead);
 	aead_request_set_callback(&ctx->aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  af_alg_complete, &ctx->completion);
+				  crypto_req_done, &ctx->wait);
 
 	sk->sk_destruct = aead_sock_destruct;
 
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 5e92bd2..fd7a6010 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -26,7 +26,7 @@ struct hash_ctx {
 
 	u8 *result;
 
-	struct af_alg_completion completion;
+	struct crypto_wait wait;
 
 	unsigned int len;
 	bool more;
@@ -88,8 +88,8 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 		if ((msg->msg_flags & MSG_MORE))
 			hash_free_result(sk, ctx);
 
-		err = af_alg_wait_for_completion(crypto_ahash_init(&ctx->req),
-						&ctx->completion);
+		err = crypto_wait_req(crypto_ahash_init(&ctx->req),
+						&ctx->wait);
 		if (err)
 			goto unlock;
 	}
@@ -110,8 +110,8 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 
 		ahash_request_set_crypt(&ctx->req, ctx->sgl.sg, NULL, len);
 
-		err = af_alg_wait_for_completion(crypto_ahash_update(&ctx->req),
-						 &ctx->completion);
+		err = crypto_wait_req(crypto_ahash_update(&ctx->req),
+						 &ctx->wait);
 		af_alg_free_sg(&ctx->sgl);
 		if (err)
 			goto unlock;
@@ -129,8 +129,8 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 			goto unlock;
 
 		ahash_request_set_crypt(&ctx->req, NULL, ctx->result, 0);
-		err = af_alg_wait_for_completion(crypto_ahash_final(&ctx->req),
-						 &ctx->completion);
+		err = crypto_wait_req(crypto_ahash_final(&ctx->req),
+						 &ctx->wait);
 	}
 
 unlock:
@@ -171,7 +171,7 @@ static ssize_t hash_sendpage(struct socket *sock, struct page *page,
 	} else {
 		if (!ctx->more) {
 			err = crypto_ahash_init(&ctx->req);
-			err = af_alg_wait_for_completion(err, &ctx->completion);
+			err = crypto_wait_req(err, &ctx->wait);
 			if (err)
 				goto unlock;
 		}
@@ -179,7 +179,7 @@ static ssize_t hash_sendpage(struct socket *sock, struct page *page,
 		err = crypto_ahash_update(&ctx->req);
 	}
 
-	err = af_alg_wait_for_completion(err, &ctx->completion);
+	err = crypto_wait_req(err, &ctx->wait);
 	if (err)
 		goto unlock;
 
@@ -215,17 +215,17 @@ static int hash_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	ahash_request_set_crypt(&ctx->req, NULL, ctx->result, 0);
 
 	if (!result && !ctx->more) {
-		err = af_alg_wait_for_completion(
+		err = crypto_wait_req(
 				crypto_ahash_init(&ctx->req),
-				&ctx->completion);
+				&ctx->wait);
 		if (err)
 			goto unlock;
 	}
 
 	if (!result || ctx->more) {
 		ctx->more = 0;
-		err = af_alg_wait_for_completion(crypto_ahash_final(&ctx->req),
-						 &ctx->completion);
+		err = crypto_wait_req(crypto_ahash_final(&ctx->req),
+						 &ctx->wait);
 		if (err)
 			goto unlock;
 	}
@@ -476,13 +476,13 @@ static int hash_accept_parent_nokey(void *private, struct sock *sk)
 	ctx->result = NULL;
 	ctx->len = len;
 	ctx->more = 0;
-	af_alg_init_completion(&ctx->completion);
+	crypto_init_wait(&ctx->wait);
 
 	ask->private = ctx;
 
 	ahash_request_set_tfm(&ctx->req, hash);
 	ahash_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   af_alg_complete, &ctx->completion);
+				   crypto_req_done, &ctx->wait);
 
 	sk->sk_destruct = hash_sock_destruct;
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 43839b0..ec7b40f 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -43,7 +43,7 @@ struct skcipher_ctx {
 
 	void *iv;
 
-	struct af_alg_completion completion;
+	struct crypto_wait wait;
 
 	atomic_t inflight;
 	size_t used;
@@ -684,11 +684,11 @@ static int skcipher_recvmsg_sync(struct socket *sock, struct msghdr *msg,
 		skcipher_request_set_crypt(&ctx->req, sg, ctx->rsgl.sg, used,
 					   ctx->iv);
 
-		err = af_alg_wait_for_completion(
+		err = crypto_wait_req(
 				ctx->enc ?
 					crypto_skcipher_encrypt(&ctx->req) :
 					crypto_skcipher_decrypt(&ctx->req),
-				&ctx->completion);
+				&ctx->wait);
 
 free:
 		af_alg_free_sg(&ctx->rsgl);
@@ -948,14 +948,14 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 	ctx->merge = 0;
 	ctx->enc = 0;
 	atomic_set(&ctx->inflight, 0);
-	af_alg_init_completion(&ctx->completion);
+	crypto_init_wait(&ctx->wait);
 
 	ask->private = ctx;
 
 	skcipher_request_set_tfm(&ctx->req, skcipher);
 	skcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_SLEEP |
 						 CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      af_alg_complete, &ctx->completion);
+				      crypto_req_done, &ctx->wait);
 
 	sk->sk_destruct = skcipher_sock_destruct;
 
diff --git a/crypto/api.c b/crypto/api.c
index 941cd4c..1c6e9cd 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -24,6 +24,7 @@
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/completion.h>
 #include "internal.h"
 
 LIST_HEAD(crypto_alg_list);
@@ -595,5 +596,32 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_alg);
 
+int crypto_wait_req(int err, struct crypto_wait *wait)
+{
+	switch (err) {
+	case -EINPROGRESS:
+	case -EBUSY:
+		wait_for_completion(&wait->completion);
+		reinit_completion(&wait->completion);
+		err = wait->err;
+		break;
+	};
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_wait_req);
+
+void crypto_req_done(struct crypto_async_request *req, int err)
+{
+	struct crypto_wait *wait = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	wait->err = err;
+	complete(&wait->completion);
+}
+EXPORT_SYMBOL_GPL(crypto_req_done);
+
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index e2b9c6f..86764fb 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -14,7 +14,6 @@
 #define _CRYPTO_IF_ALG_H
 
 #include <linux/compiler.h>
-#include <linux/completion.h>
 #include <linux/if_alg.h>
 #include <linux/scatterlist.h>
 #include <linux/types.h>
@@ -37,11 +36,6 @@ struct alg_sock {
 	void *private;
 };
 
-struct af_alg_completion {
-	struct completion completion;
-	int err;
-};
-
 struct af_alg_control {
 	struct af_alg_iv *iv;
 	int op;
@@ -81,17 +75,9 @@ void af_alg_link_sg(struct af_alg_sgl *sgl_prev, struct af_alg_sgl *sgl_new);
 
 int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con);
 
-int af_alg_wait_for_completion(int err, struct af_alg_completion *completion);
-void af_alg_complete(struct crypto_async_request *req, int err);
-
 static inline struct alg_sock *alg_sk(struct sock *sk)
 {
 	return (struct alg_sock *)sk;
 }
 
-static inline void af_alg_init_completion(struct af_alg_completion *completion)
-{
-	init_completion(&completion->completion);
-}
-
 #endif	/* _CRYPTO_IF_ALG_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 84da997..df2f72f 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <linux/completion.h>
 
 /*
  * Autoloaded crypto modules should only use a prefixed name to avoid allowing
@@ -137,6 +138,13 @@
 
 #define CRYPTO_MINALIGN_ATTR __attribute__ ((__aligned__(CRYPTO_MINALIGN)))
 
+/*
+ * Macro for declaring a crypto op async wait object on stack
+ */
+#define DECLARE_CRYPTO_WAIT(_wait) \
+	struct crypto_wait _wait = { \
+		COMPLETION_INITIALIZER_ONSTACK((_wait).completion), 0 }
+
 struct scatterlist;
 struct crypto_ablkcipher;
 struct crypto_async_request;
@@ -467,6 +475,25 @@ struct crypto_alg {
 	struct module *cra_module;
 } CRYPTO_MINALIGN_ATTR;
 
+/**
+ * A helper struct for waiting for completion of async crypto ops
+ */
+struct crypto_wait {
+	struct completion completion;
+	int err;
+};
+
+/*
+ * Async ops completion helper functioons
+ */
+int crypto_wait_req(int err, struct crypto_wait *wait);
+void crypto_req_done(struct crypto_async_request *req, int err);
+
+static inline void crypto_init_wait(struct crypto_wait *wait)
+{
+	init_completion(&wait->completion);
+}
+
 /*
  * Algorithm registration interface.
  */
@@ -1604,5 +1631,6 @@ static inline int crypto_comp_decompress(struct crypto_comp *tfm,
 						    src, slen, dst, dlen);
 }
 
+
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
2.1.4
