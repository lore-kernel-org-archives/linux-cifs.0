Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198F8165EFC;
	Wed, 14 May 2025 04:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747198275; cv=none; b=Sy7MNtaoj8RhGezzkRiMWbLORC54L7SUAp/jTxkC8b4qiS64wugOpWAdtFQ1eeaEQfNuaX+kGbVE8pb5MpyiI8/5Gk/p5TnAV7De5ajNAsJiKh1KzGGgUPVRXkL/wnofvZMfQt+h+cm6nCpsY8sB7Qk6b6oSqGe96xceuxBTBdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747198275; c=relaxed/simple;
	bh=TIGczNcqEIjwZ4QAV7Jj5pfPYOn3tRAflnNe1fJTNv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LjxMnPYCoDW9U5xLQ0n4Iix8XdLFCTjdP2IoyrLG8qrAJkF3MiWGUDWpOOe6rMaerxcRSA8rrXe7Fpg5fZGnf2JdLFg3+REcARus5rKXyoI46mLGFHrW9lINDYh+itUh+BdX36bDSFSjje/UbINkFGDB9Pf7/cKpxmfHPBaTEko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H14kCCKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H14kCCKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA6CC4CEED;
	Wed, 14 May 2025 04:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747198274;
	bh=TIGczNcqEIjwZ4QAV7Jj5pfPYOn3tRAflnNe1fJTNv4=;
	h=From:To:Cc:Subject:Date:From;
	b=H14kCCKzgrAI33NI/ccyV938vqAGyMoz+7O/TwX1rBSes/pCd8m6EiK35XgMVodop
	 muTKgQ52t0tdnpW42DF3CjgiUwdcoDEnFeyTo9V7DQvuNwRMFfqlAP6zNDqggVtL3w
	 9rABTgUXlLt5PNSKzovQZTLmOUiEtIaWUw/Q2zCXg4Qgpm1xBe5BtUCOIe8tTRjRX/
	 IJeG+RAAS0BuZugmJ/hedeeb2XcEutTbQeoX+jZFilNpdoTaQeQBaqz0fnVS5PXplj
	 FBDWZxvZwehImuG85xsa6nJMZbp76lnSImTjdXAvX9/BuYSWR5ZkJvGhE79x5wPldU
	 ec7nQ0J0F/mwQ==
From: Eric Biggers <ebiggers@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH] ksmbd: use SHA-256 library API instead of crypto_shash API
Date: Tue, 13 May 2025 21:50:34 -0700
Message-ID: <20250514045034.118130-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

ksmbd_gen_sd_hash() does not support any other algorithm, so the
crypto_shash abstraction provides no value.  Just use the SHA-256
library API instead, which is much simpler and easier to use.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This patch is targeting the ksmbd tree.

 fs/smb/server/Kconfig      |  1 +
 fs/smb/server/auth.c       | 34 ----------------------------------
 fs/smb/server/auth.h       |  2 --
 fs/smb/server/crypto_ctx.c |  8 --------
 fs/smb/server/crypto_ctx.h |  4 ----
 fs/smb/server/vfs.c        | 20 ++++----------------
 6 files changed, 5 insertions(+), 64 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index cf70e96ad4dee..4a23a5e7e8fec 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -9,10 +9,11 @@ config SMB_SERVER
 	select CRYPTO
 	select CRYPTO_MD5
 	select CRYPTO_HMAC
 	select CRYPTO_ECB
 	select CRYPTO_LIB_DES
+	select CRYPTO_LIB_SHA256
 	select CRYPTO_SHA256
 	select CRYPTO_CMAC
 	select CRYPTO_SHA512
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index b3d121052408c..d99871c214518 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -977,44 +977,10 @@ int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
 out:
 	ksmbd_release_crypto_ctx(ctx);
 	return rc;
 }
 
-int ksmbd_gen_sd_hash(struct ksmbd_conn *conn, char *sd_buf, int len,
-		      __u8 *pi_hash)
-{
-	int rc;
-	struct ksmbd_crypto_ctx *ctx = NULL;
-
-	ctx = ksmbd_crypto_ctx_find_sha256();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not alloc sha256\n");
-		return -ENOMEM;
-	}
-
-	rc = crypto_shash_init(CRYPTO_SHA256(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "could not init shashn");
-		goto out;
-	}
-
-	rc = crypto_shash_update(CRYPTO_SHA256(ctx), sd_buf, len);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with n\n");
-		goto out;
-	}
-
-	rc = crypto_shash_final(CRYPTO_SHA256(ctx), pi_hash);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate hash err : %d\n", rc);
-		goto out;
-	}
-out:
-	ksmbd_release_crypto_ctx(ctx);
-	return rc;
-}
-
 static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
 				    int enc, u8 *key)
 {
 	struct ksmbd_session *sess;
 	u8 *ses_enc_key;
diff --git a/fs/smb/server/auth.h b/fs/smb/server/auth.h
index 362b6159a6cff..6879a1bd1b91f 100644
--- a/fs/smb/server/auth.h
+++ b/fs/smb/server/auth.h
@@ -64,8 +64,6 @@ int ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
 				  struct ksmbd_session *sess);
 int ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
 				   struct ksmbd_session *sess);
 int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
 				     __u8 *pi_hash);
-int ksmbd_gen_sd_hash(struct ksmbd_conn *conn, char *sd_buf, int len,
-		      __u8 *pi_hash);
 #endif
diff --git a/fs/smb/server/crypto_ctx.c b/fs/smb/server/crypto_ctx.c
index ce733dc9a4a35..80bd68c8635ea 100644
--- a/fs/smb/server/crypto_ctx.c
+++ b/fs/smb/server/crypto_ctx.c
@@ -73,13 +73,10 @@ static struct shash_desc *alloc_shash_desc(int id)
 		tfm = crypto_alloc_shash("hmac(sha256)", 0, 0);
 		break;
 	case CRYPTO_SHASH_CMACAES:
 		tfm = crypto_alloc_shash("cmac(aes)", 0, 0);
 		break;
-	case CRYPTO_SHASH_SHA256:
-		tfm = crypto_alloc_shash("sha256", 0, 0);
-		break;
 	case CRYPTO_SHASH_SHA512:
 		tfm = crypto_alloc_shash("sha512", 0, 0);
 		break;
 	default:
 		return NULL;
@@ -196,15 +193,10 @@ struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacsha256(void)
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void)
 {
 	return ____crypto_shash_ctx_find(CRYPTO_SHASH_CMACAES);
 }
 
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_sha256(void)
-{
-	return ____crypto_shash_ctx_find(CRYPTO_SHASH_SHA256);
-}
-
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_sha512(void)
 {
 	return ____crypto_shash_ctx_find(CRYPTO_SHASH_SHA512);
 }
 
diff --git a/fs/smb/server/crypto_ctx.h b/fs/smb/server/crypto_ctx.h
index 4a367c62f6536..ac64801d52d38 100644
--- a/fs/smb/server/crypto_ctx.h
+++ b/fs/smb/server/crypto_ctx.h
@@ -11,11 +11,10 @@
 
 enum {
 	CRYPTO_SHASH_HMACMD5	= 0,
 	CRYPTO_SHASH_HMACSHA256,
 	CRYPTO_SHASH_CMACAES,
-	CRYPTO_SHASH_SHA256,
 	CRYPTO_SHASH_SHA512,
 	CRYPTO_SHASH_MAX,
 };
 
 enum {
@@ -37,29 +36,26 @@ struct ksmbd_crypto_ctx {
 };
 
 #define CRYPTO_HMACMD5(c)	((c)->desc[CRYPTO_SHASH_HMACMD5])
 #define CRYPTO_HMACSHA256(c)	((c)->desc[CRYPTO_SHASH_HMACSHA256])
 #define CRYPTO_CMACAES(c)	((c)->desc[CRYPTO_SHASH_CMACAES])
-#define CRYPTO_SHA256(c)	((c)->desc[CRYPTO_SHASH_SHA256])
 #define CRYPTO_SHA512(c)	((c)->desc[CRYPTO_SHASH_SHA512])
 
 #define CRYPTO_HMACMD5_TFM(c)	((c)->desc[CRYPTO_SHASH_HMACMD5]->tfm)
 #define CRYPTO_HMACSHA256_TFM(c)\
 				((c)->desc[CRYPTO_SHASH_HMACSHA256]->tfm)
 #define CRYPTO_CMACAES_TFM(c)	((c)->desc[CRYPTO_SHASH_CMACAES]->tfm)
-#define CRYPTO_SHA256_TFM(c)	((c)->desc[CRYPTO_SHASH_SHA256]->tfm)
 #define CRYPTO_SHA512_TFM(c)	((c)->desc[CRYPTO_SHASH_SHA512]->tfm)
 
 #define CRYPTO_GCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_GCM])
 #define CRYPTO_CCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_CCM])
 
 void ksmbd_release_crypto_ctx(struct ksmbd_crypto_ctx *ctx);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacmd5(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacsha256(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_sha512(void);
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_sha256(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_gcm(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_ccm(void);
 void ksmbd_crypto_destroy(void);
 int ksmbd_crypto_create(void);
 
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 156ded9ac889b..bc5098d917a51 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -2,10 +2,11 @@
 /*
  *   Copyright (C) 2016 Namjae Jeon <linkinjeon@kernel.org>
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
  */
 
+#include <crypto/sha2.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/filelock.h>
 #include <linux/uaccess.h>
 #include <linux/backing-dev.h>
@@ -1474,15 +1475,11 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 		cpu_to_le32(le32_to_cpu(pntsd->dacloffset) + NDR_NTSD_OFFSETOF);
 
 	acl.sd_buf = (char *)pntsd;
 	acl.sd_size = len;
 
-	rc = ksmbd_gen_sd_hash(conn, acl.sd_buf, acl.sd_size, acl.hash);
-	if (rc) {
-		pr_err("failed to generate hash for ndr acl\n");
-		return rc;
-	}
+	sha256(acl.sd_buf, acl.sd_size, acl.hash);
 
 	smb_acl = ksmbd_vfs_make_xattr_posix_acl(idmap, inode,
 						 ACL_TYPE_ACCESS);
 	if (S_ISDIR(inode->i_mode))
 		def_smb_acl = ksmbd_vfs_make_xattr_posix_acl(idmap, inode,
@@ -1493,16 +1490,11 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 	if (rc) {
 		pr_err("failed to encode ndr to posix acl\n");
 		goto out;
 	}
 
-	rc = ksmbd_gen_sd_hash(conn, acl_ndr.data, acl_ndr.offset,
-			       acl.posix_acl_hash);
-	if (rc) {
-		pr_err("failed to generate hash for ndr acl\n");
-		goto out;
-	}
+	sha256(acl_ndr.data, acl_ndr.offset, acl.posix_acl_hash);
 
 	rc = ndr_encode_v4_ntacl(&sd_ndr, &acl);
 	if (rc) {
 		pr_err("failed to encode ndr to posix acl\n");
 		goto out;
@@ -1555,15 +1547,11 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	if (rc) {
 		pr_err("failed to encode ndr to posix acl\n");
 		goto out_free;
 	}
 
-	rc = ksmbd_gen_sd_hash(conn, acl_ndr.data, acl_ndr.offset, cmp_hash);
-	if (rc) {
-		pr_err("failed to generate hash for ndr acl\n");
-		goto out_free;
-	}
+	sha256(acl_ndr.data, acl_ndr.offset, cmp_hash);
 
 	if (memcmp(cmp_hash, acl.posix_acl_hash, XATTR_SD_HASH_SIZE)) {
 		pr_err("hash value diff\n");
 		rc = -EINVAL;
 		goto out_free;

base-commit: aa94665adc28f3fdc3de2979ac1e98bae961d6ca
-- 
2.49.0

