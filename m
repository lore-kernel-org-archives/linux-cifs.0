Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E4BC8CE;
	Sat, 18 Apr 2026 22:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776550712; cv=none; b=cywlRJSgVdcxvJ1ehpu9AEZ5bpRQZfxQt7f03wu0fMF1DNuYIAfKSzQpXzYrI65iNzGTxgogUCWaK18QCedmob213tMj8e5ZT8HbACc4iFXZ6BXbDnWGdvk91Eb+L0x3g499QuhU/4ay9KpUTsyMttKLP7qp1nA9EvREp9GPzP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776550712; c=relaxed/simple;
	bh=4SqN0/imj48EocU/KcOP+YvUMBfC3KL8Tw0kM9BHH+8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LigfgVqPwiGNJcsb3atM3C1azDJKFlLXmgWx3Q9FvsWorDvjTEwpwHSuQbv8oCepb+Gz/cDp6NmkT4gUM3olIes+GBKpZNPEuHDDNyPLmiwe7qYyNVLsgHELRNuepkmklihwZIzDnEG8MDoQNmQZ9FlFAHzkMAJwjxqN/v2GHV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjDUiE6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjDUiE6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E659BC19424;
	Sat, 18 Apr 2026 22:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776550712;
	bh=4SqN0/imj48EocU/KcOP+YvUMBfC3KL8Tw0kM9BHH+8=;
	h=From:To:Cc:Subject:Date:From;
	b=BjDUiE6tyfJ1jF49Z2OtqJatQ7fVkJwq59xur4wLLj9kPPpwQnA+H72qXyJB6pqv3
	 FpwcLblvp2vySyA9Wau9up2SsgZ5e82O2woJpaPJSJx+S691uSQRht7te3XAYjOtA6
	 olxNAqYRhtedYa2mWilxUotkvrHySvYgDj+94yG3QFnJI8H5YFSI4OGuc+50ChoYmG
	 tZxRQovequxGqUtqBE3um6vGNGyy/Kc4A3kpLFJXgnmH329/RZ0Pi+yHv2zPEIo7lU
	 AysYMQGTaFZushQdSjwmMsM6ZkMMdemEDcj4Z3lsPwFevIqaeTg/8OYOYaNLsQ0dBN
	 fSXYsbpHjK3aQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] ksmbd: Use AES-CMAC library for SMB3 signature calculation
Date: Sat, 18 Apr 2026 15:17:07 -0700
Message-ID: <20260418221707.67972-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that AES-CMAC has a library API, convert ksmbd_sign_smb3_pdu() to
use it instead of a "cmac(aes)" crypto_shash.

The result is simpler and faster code.  With the library there's no need
to dynamically allocate memory, no need to handle errors, and the
AES-CMAC code is accessed directly without inefficient indirect calls
and other unnecessary API overhead.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch was originally sent as patch 12 of the series
https://lore.kernel.org/r/20260218213501.136844-1-ebiggers@kernel.org/
The only change from that version was adding tags and rebasing.

This is intended to be taken through the ksmbd tree, either 7.1 or 7.2
depending on maintainer preference.

 fs/smb/server/Kconfig      |  2 +-
 fs/smb/server/auth.c       | 51 +++++++++------------------------
 fs/smb/server/auth.h       |  4 +--
 fs/smb/server/crypto_ctx.c | 58 --------------------------------------
 fs/smb/server/crypto_ctx.h | 12 --------
 fs/smb/server/server.c     |  1 -
 fs/smb/server/smb2pdu.c    |  8 ++----
 7 files changed, 19 insertions(+), 117 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 37387410e5bb3..8827b36537864 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -5,17 +5,17 @@ config SMB_SERVER
 	depends on FILE_LOCKING
 	select NLS
 	select NLS_UTF8
 	select NLS_UCS2_UTILS
 	select CRYPTO
+	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select CRYPTO_LIB_UTILS
-	select CRYPTO_CMAC
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select ASN1
 	select OID_REGISTRY
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 7d0691f7263fe..e99409fa721cd 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -9,12 +9,12 @@
 #include <linux/uaccess.h>
 #include <linux/backing-dev.h>
 #include <linux/writeback.h>
 #include <linux/uio.h>
 #include <linux/xattr.h>
-#include <crypto/hash.h>
 #include <crypto/aead.h>
+#include <crypto/aes-cbc-macs.h>
 #include <crypto/md5.h>
 #include <crypto/sha2.h>
 #include <crypto/utils.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
@@ -488,50 +488,25 @@ void ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
  * @iov:        buffer iov array
  * @n_vec:	number of iovecs
  * @sig:	signature value generated for client request packet
  *
  */
-int ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
-			int n_vec, char *sig)
+void ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
+			 int n_vec, char *sig)
 {
-	struct ksmbd_crypto_ctx *ctx;
-	int rc, i;
-
-	ctx = ksmbd_crypto_ctx_find_cmacaes();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not crypto alloc cmac\n");
-		return -ENOMEM;
-	}
-
-	rc = crypto_shash_setkey(CRYPTO_CMACAES_TFM(ctx),
-				 key,
-				 SMB2_CMACAES_SIZE);
-	if (rc)
-		goto out;
-
-	rc = crypto_shash_init(CRYPTO_CMACAES(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "cmaces init error %d\n", rc);
-		goto out;
-	}
+	struct aes_cmac_key cmac_key;
+	struct aes_cmac_ctx cmac_ctx;
+	int i;
 
-	for (i = 0; i < n_vec; i++) {
-		rc = crypto_shash_update(CRYPTO_CMACAES(ctx),
-					 iov[i].iov_base,
-					 iov[i].iov_len);
-		if (rc) {
-			ksmbd_debug(AUTH, "cmaces update error %d\n", rc);
-			goto out;
-		}
-	}
+	/* This cannot fail, since we always pass a valid key length. */
+	static_assert(SMB2_CMACAES_SIZE == AES_KEYSIZE_128);
+	aes_cmac_preparekey(&cmac_key, key, SMB2_CMACAES_SIZE);
 
-	rc = crypto_shash_final(CRYPTO_CMACAES(ctx), sig);
-	if (rc)
-		ksmbd_debug(AUTH, "cmaces generation error %d\n", rc);
-out:
-	ksmbd_release_crypto_ctx(ctx);
-	return rc;
+	aes_cmac_init(&cmac_ctx, &cmac_key);
+	for (i = 0; i < n_vec; i++)
+		aes_cmac_update(&cmac_ctx, iov[i].iov_base, iov[i].iov_len);
+	aes_cmac_final(&cmac_ctx, sig);
 }
 
 struct derivation {
 	struct kvec label;
 	struct kvec context;
diff --git a/fs/smb/server/auth.h b/fs/smb/server/auth.h
index 6d351d61b0e57..5767aabc63c9b 100644
--- a/fs/smb/server/auth.h
+++ b/fs/smb/server/auth.h
@@ -52,12 +52,12 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
 				   struct ksmbd_conn *conn);
 int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 			    int in_len,	char *out_blob, int *out_len);
 void ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
 			 int n_vec, char *sig);
-int ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
-			int n_vec, char *sig);
+void ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
+			 int n_vec, char *sig);
 int ksmbd_gen_smb30_signingkey(struct ksmbd_session *sess,
 			       struct ksmbd_conn *conn);
 int ksmbd_gen_smb311_signingkey(struct ksmbd_session *sess,
 				struct ksmbd_conn *conn);
 void ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
diff --git a/fs/smb/server/crypto_ctx.c b/fs/smb/server/crypto_ctx.c
index 8fd9713b00b7f..2fe7d33004807 100644
--- a/fs/smb/server/crypto_ctx.c
+++ b/fs/smb/server/crypto_ctx.c
@@ -26,18 +26,10 @@ static inline void free_aead(struct crypto_aead *aead)
 {
 	if (aead)
 		crypto_free_aead(aead);
 }
 
-static void free_shash(struct shash_desc *shash)
-{
-	if (shash) {
-		crypto_free_shash(shash->tfm);
-		kfree(shash);
-	}
-}
-
 static struct crypto_aead *alloc_aead(int id)
 {
 	struct crypto_aead *tfm = NULL;
 
 	switch (id) {
@@ -58,41 +50,14 @@ static struct crypto_aead *alloc_aead(int id)
 	}
 
 	return tfm;
 }
 
-static struct shash_desc *alloc_shash_desc(int id)
-{
-	struct crypto_shash *tfm = NULL;
-	struct shash_desc *shash;
-
-	switch (id) {
-	case CRYPTO_SHASH_CMACAES:
-		tfm = crypto_alloc_shash("cmac(aes)", 0, 0);
-		break;
-	default:
-		return NULL;
-	}
-
-	if (IS_ERR(tfm))
-		return NULL;
-
-	shash = kzalloc(sizeof(*shash) + crypto_shash_descsize(tfm),
-			KSMBD_DEFAULT_GFP);
-	if (!shash)
-		crypto_free_shash(tfm);
-	else
-		shash->tfm = tfm;
-	return shash;
-}
-
 static void ctx_free(struct ksmbd_crypto_ctx *ctx)
 {
 	int i;
 
-	for (i = 0; i < CRYPTO_SHASH_MAX; i++)
-		free_shash(ctx->desc[i]);
 	for (i = 0; i < CRYPTO_AEAD_MAX; i++)
 		free_aead(ctx->ccmaes[i]);
 	kfree(ctx);
 }
 
@@ -151,33 +116,10 @@ void ksmbd_release_crypto_ctx(struct ksmbd_crypto_ctx *ctx)
 	ctx_list.avail_ctx--;
 	spin_unlock(&ctx_list.ctx_lock);
 	ctx_free(ctx);
 }
 
-static struct ksmbd_crypto_ctx *____crypto_shash_ctx_find(int id)
-{
-	struct ksmbd_crypto_ctx *ctx;
-
-	if (id >= CRYPTO_SHASH_MAX)
-		return NULL;
-
-	ctx = ksmbd_find_crypto_ctx();
-	if (ctx->desc[id])
-		return ctx;
-
-	ctx->desc[id] = alloc_shash_desc(id);
-	if (ctx->desc[id])
-		return ctx;
-	ksmbd_release_crypto_ctx(ctx);
-	return NULL;
-}
-
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void)
-{
-	return ____crypto_shash_ctx_find(CRYPTO_SHASH_CMACAES);
-}
-
 static struct ksmbd_crypto_ctx *____crypto_aead_ctx_find(int id)
 {
 	struct ksmbd_crypto_ctx *ctx;
 
 	if (id >= CRYPTO_AEAD_MAX)
diff --git a/fs/smb/server/crypto_ctx.h b/fs/smb/server/crypto_ctx.h
index 27fd553d10aab..b22c6e086f032 100644
--- a/fs/smb/server/crypto_ctx.h
+++ b/fs/smb/server/crypto_ctx.h
@@ -4,40 +4,28 @@
  */
 
 #ifndef __CRYPTO_CTX_H__
 #define __CRYPTO_CTX_H__
 
-#include <crypto/hash.h>
 #include <crypto/aead.h>
 
-enum {
-	CRYPTO_SHASH_CMACAES	= 0,
-	CRYPTO_SHASH_MAX,
-};
-
 enum {
 	CRYPTO_AEAD_AES_GCM = 16,
 	CRYPTO_AEAD_AES_CCM,
 	CRYPTO_AEAD_MAX,
 };
 
 struct ksmbd_crypto_ctx {
 	struct list_head		list;
 
-	struct shash_desc		*desc[CRYPTO_SHASH_MAX];
 	struct crypto_aead		*ccmaes[CRYPTO_AEAD_MAX];
 };
 
-#define CRYPTO_CMACAES(c)	((c)->desc[CRYPTO_SHASH_CMACAES])
-
-#define CRYPTO_CMACAES_TFM(c)	((c)->desc[CRYPTO_SHASH_CMACAES]->tfm)
-
 #define CRYPTO_GCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_GCM])
 #define CRYPTO_CCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_CCM])
 
 void ksmbd_release_crypto_ctx(struct ksmbd_crypto_ctx *ctx);
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_gcm(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_ccm(void);
 void ksmbd_crypto_destroy(void);
 int ksmbd_crypto_create(void);
 
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index d8893079abdb5..58ef02c423fce 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -629,11 +629,10 @@ static void __exit ksmbd_server_exit(void)
 MODULE_AUTHOR("Namjae Jeon <linkinjeon@kernel.org>");
 MODULE_DESCRIPTION("Linux kernel CIFS/SMB SERVER");
 MODULE_LICENSE("GPL");
 MODULE_SOFTDEP("pre: nls");
 MODULE_SOFTDEP("pre: aes");
-MODULE_SOFTDEP("pre: cmac");
 MODULE_SOFTDEP("pre: aead2");
 MODULE_SOFTDEP("pre: ccm");
 MODULE_SOFTDEP("pre: gcm");
 module_init(ksmbd_server_init)
 module_exit(ksmbd_server_exit)
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ee32e61b6d3c7..4ec83d094b3b9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9065,12 +9065,11 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	memcpy(signature_req, hdr->Signature, SMB2_SIGNATURE_SIZE);
 	memset(hdr->Signature, 0, SMB2_SIGNATURE_SIZE);
 	iov[0].iov_base = (char *)&hdr->ProtocolId;
 	iov[0].iov_len = len;
 
-	if (ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature))
-		return 0;
+	ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature);
 
 	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
@@ -9117,13 +9116,12 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 		n_vec++;
 	} else {
 		iov = &work->iov[work->iov_idx];
 	}
 
-	if (!ksmbd_sign_smb3_pdu(conn, signing_key, iov, n_vec,
-				 signature))
-		memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
+	ksmbd_sign_smb3_pdu(conn, signing_key, iov, n_vec, signature);
+	memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
 }
 
 /**
  * smb3_preauth_hash_rsp() - handler for computing preauth hash on response
  * @work:   smb work containing response buffer

base-commit: 8541d8f725c673db3bd741947f27974358b2e163
-- 
2.53.0

