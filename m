Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B030A2DCBF4;
	Tue, 14 Oct 2025 23:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760483916; cv=none; b=bNnSwQB7WrLejzzh6BUkDCRG0wSqiJYpsLviojoONIrj+GG05Idc1P3fCw6GuxLgBwHJaqW4OqyOPcGiZp772jP6vl15kYGMF1bPgV8PUjsgWBpIbL73dT/IpOEab8UEw4s0iJqq6TlEs5+n7cOZh8rTP+e9VtrLsppPo38s1gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760483916; c=relaxed/simple;
	bh=DoVJReXyny+lfJvkeCzLU3jxVcM7bGnt3EW7kkSm4nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMYRz2q0H6TnNI4YTl/Ok6pdnjrXWwRMucnK3j9k4KhNy1n8Dcg1FOLwdLfycwtGXLZkL4s2p0u6NV/ooHmPg+ueMgrkRUQKGQF6sD1Yg7a6mGf0ksYNoxtIQyK5xbjiyvaNX+carbLPcUtjfNDONxaTrk9W3XUiGLMXfKNG+qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s2Ce/xFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s2Ce/xFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDA7C116D0;
	Tue, 14 Oct 2025 23:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760483916;
	bh=DoVJReXyny+lfJvkeCzLU3jxVcM7bGnt3EW7kkSm4nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2Ce/xFMETDEGUIN/5WTXjpK3af+aUpakI6oj3gncPOHxrfwKx7zJbZXFXBIk2Npt
	 8JfvVHLIZPCARSljSiXb3fYddJi1tpok0gb4PN/ymrNRrC+l2FVvwJfBveC+Jv92ID
	 OjfVDBPX/gXdemYKC1N0VIUBnlqNcdJ5hVWqmo8rP0LIqlSgYSOgr67UiAU1q6tB/k
	 f+Js4jjw6neu7JkKb9keSPtuI9Q5Bh3eCKIMJLoVGkGNS1tbW69KDMixzaIg9Io3EF
	 KQjSPH35jBpHCvSNhxSf54j9joMRS2okTGxN4BwpeZQLRCpN3U6eepzaqUhXC9jKgJ
	 6qFl3azyXfo9A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] ksmbd: Use SHA-512 library for SMB3.1.1 preauth hash
Date: Tue, 14 Oct 2025 16:17:57 -0700
Message-ID: <20251014231759.136630-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014231759.136630-1-ebiggers@kernel.org>
References: <20251014231759.136630-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert ksmbd_gen_preauth_integrity_hash() to use the SHA-512 library
instead of a "sha512" crypto_shash.  This is simpler and faster.  With
the library there's no need to allocate memory, no need to handle
errors, and the SHA-512 code is accessed directly without inefficient
indirect calls and other unnecessary API overhead.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/server/Kconfig      |  2 +-
 fs/smb/server/auth.c       | 41 +++++++-------------------------------
 fs/smb/server/crypto_ctx.c |  8 --------
 fs/smb/server/crypto_ctx.h |  4 ----
 fs/smb/server/server.c     |  1 -
 5 files changed, 8 insertions(+), 48 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 098cac98d31e6..d5f3a417246d4 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -11,13 +11,13 @@ config SMB_SERVER
 	select CRYPTO_HMAC
 	select CRYPTO_ECB
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
 	select CRYPTO_SHA256
 	select CRYPTO_CMAC
-	select CRYPTO_SHA512
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select ASN1
 	select OID_REGISTRY
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index b4020bb55a268..b7f2feede221f 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -11,10 +11,11 @@
 #include <linux/writeback.h>
 #include <linux/uio.h>
 #include <linux/xattr.h>
 #include <crypto/hash.h>
 #include <crypto/aead.h>
+#include <crypto/sha2.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
 
 #include "auth.h"
 #include "glob.h"
@@ -932,52 +933,24 @@ int ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
 }
 
 int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
 				     __u8 *pi_hash)
 {
-	int rc;
 	struct smb2_hdr *rcv_hdr = smb2_get_msg(buf);
 	char *all_bytes_msg = (char *)&rcv_hdr->ProtocolId;
 	int msg_size = get_rfc1002_len(buf);
-	struct ksmbd_crypto_ctx *ctx = NULL;
+	struct sha512_ctx sha_ctx;
 
 	if (conn->preauth_info->Preauth_HashId !=
 	    SMB2_PREAUTH_INTEGRITY_SHA512)
 		return -EINVAL;
 
-	ctx = ksmbd_crypto_ctx_find_sha512();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not alloc sha512\n");
-		return -ENOMEM;
-	}
-
-	rc = crypto_shash_init(CRYPTO_SHA512(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "could not init shashn");
-		goto out;
-	}
-
-	rc = crypto_shash_update(CRYPTO_SHA512(ctx), pi_hash, 64);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with n\n");
-		goto out;
-	}
-
-	rc = crypto_shash_update(CRYPTO_SHA512(ctx), all_bytes_msg, msg_size);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with n\n");
-		goto out;
-	}
-
-	rc = crypto_shash_final(CRYPTO_SHA512(ctx), pi_hash);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate hash err : %d\n", rc);
-		goto out;
-	}
-out:
-	ksmbd_release_crypto_ctx(ctx);
-	return rc;
+	sha512_init(&sha_ctx);
+	sha512_update(&sha_ctx, pi_hash, 64);
+	sha512_update(&sha_ctx, all_bytes_msg, msg_size);
+	sha512_final(&sha_ctx, pi_hash);
+	return 0;
 }
 
 static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
 				    int enc, u8 *key)
 {
diff --git a/fs/smb/server/crypto_ctx.c b/fs/smb/server/crypto_ctx.c
index 80bd68c8635ea..1de41b10528bc 100644
--- a/fs/smb/server/crypto_ctx.c
+++ b/fs/smb/server/crypto_ctx.c
@@ -73,13 +73,10 @@ static struct shash_desc *alloc_shash_desc(int id)
 		tfm = crypto_alloc_shash("hmac(sha256)", 0, 0);
 		break;
 	case CRYPTO_SHASH_CMACAES:
 		tfm = crypto_alloc_shash("cmac(aes)", 0, 0);
 		break;
-	case CRYPTO_SHASH_SHA512:
-		tfm = crypto_alloc_shash("sha512", 0, 0);
-		break;
 	default:
 		return NULL;
 	}
 
 	if (IS_ERR(tfm))
@@ -193,15 +190,10 @@ struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacsha256(void)
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void)
 {
 	return ____crypto_shash_ctx_find(CRYPTO_SHASH_CMACAES);
 }
 
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_sha512(void)
-{
-	return ____crypto_shash_ctx_find(CRYPTO_SHASH_SHA512);
-}
-
 static struct ksmbd_crypto_ctx *____crypto_aead_ctx_find(int id)
 {
 	struct ksmbd_crypto_ctx *ctx;
 
 	if (id >= CRYPTO_AEAD_MAX)
diff --git a/fs/smb/server/crypto_ctx.h b/fs/smb/server/crypto_ctx.h
index ac64801d52d38..4e8954acd8b8b 100644
--- a/fs/smb/server/crypto_ctx.h
+++ b/fs/smb/server/crypto_ctx.h
@@ -11,11 +11,10 @@
 
 enum {
 	CRYPTO_SHASH_HMACMD5	= 0,
 	CRYPTO_SHASH_HMACSHA256,
 	CRYPTO_SHASH_CMACAES,
-	CRYPTO_SHASH_SHA512,
 	CRYPTO_SHASH_MAX,
 };
 
 enum {
 	CRYPTO_AEAD_AES_GCM = 16,
@@ -36,26 +35,23 @@ struct ksmbd_crypto_ctx {
 };
 
 #define CRYPTO_HMACMD5(c)	((c)->desc[CRYPTO_SHASH_HMACMD5])
 #define CRYPTO_HMACSHA256(c)	((c)->desc[CRYPTO_SHASH_HMACSHA256])
 #define CRYPTO_CMACAES(c)	((c)->desc[CRYPTO_SHASH_CMACAES])
-#define CRYPTO_SHA512(c)	((c)->desc[CRYPTO_SHASH_SHA512])
 
 #define CRYPTO_HMACMD5_TFM(c)	((c)->desc[CRYPTO_SHASH_HMACMD5]->tfm)
 #define CRYPTO_HMACSHA256_TFM(c)\
 				((c)->desc[CRYPTO_SHASH_HMACSHA256]->tfm)
 #define CRYPTO_CMACAES_TFM(c)	((c)->desc[CRYPTO_SHASH_CMACAES]->tfm)
-#define CRYPTO_SHA512_TFM(c)	((c)->desc[CRYPTO_SHASH_SHA512]->tfm)
 
 #define CRYPTO_GCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_GCM])
 #define CRYPTO_CCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_CCM])
 
 void ksmbd_release_crypto_ctx(struct ksmbd_crypto_ctx *ctx);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacmd5(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacsha256(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void);
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_sha512(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_gcm(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_ccm(void);
 void ksmbd_crypto_destroy(void);
 int ksmbd_crypto_create(void);
 
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 40420544cc25a..51e2aee2a6985 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -626,11 +626,10 @@ MODULE_SOFTDEP("pre: hmac");
 MODULE_SOFTDEP("pre: md5");
 MODULE_SOFTDEP("pre: nls");
 MODULE_SOFTDEP("pre: aes");
 MODULE_SOFTDEP("pre: cmac");
 MODULE_SOFTDEP("pre: sha256");
-MODULE_SOFTDEP("pre: sha512");
 MODULE_SOFTDEP("pre: aead2");
 MODULE_SOFTDEP("pre: ccm");
 MODULE_SOFTDEP("pre: gcm");
 module_init(ksmbd_server_init)
 module_exit(ksmbd_server_exit)
-- 
2.51.0

