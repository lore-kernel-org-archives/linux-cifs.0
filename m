Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0842EB5B0;
	Tue, 14 Oct 2025 23:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760483918; cv=none; b=Fv3j1WhLH4PDpMzpUsnxUCBsOSPZ5hiRTzD+slLxIhaxuJkc1U6VMbnMC75x+3mURLcDHIbDVH5areGlFfO0Mt2NXxmMKwHLDeBmYrTPkjk/Cc+SYi4in0JG3mwQOoOKvjx/3poQWTTQxRhEeIWUmUbUA4A08XftiMjSY0N8IQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760483918; c=relaxed/simple;
	bh=iU1b1tmxAfgBGN57RXP8uM5OEr3EPx4GGjCp+YIZ86Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWgBUU6LMfxnhaHR10zES0Bs39g+CQYycqpGp1UdMnquleMBAA8wtGhasUMgVd0JOyyQ6iOYLQFveJXTs6zOLwYTycMJxG5/8zKKwUZ7zM/q5iAXCdSznuNkcGIL5a5RQP4cekXb/ADDgs1HVgTNTSSiS/BMYCP+StszDPu5sSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S2W/crxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2W/crxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D71C116C6;
	Tue, 14 Oct 2025 23:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760483917;
	bh=iU1b1tmxAfgBGN57RXP8uM5OEr3EPx4GGjCp+YIZ86Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2W/crxWeJHM/nCt6O6XJQ8HvtHCBY3vaBZCmtaL/Dpm8MRP8OMrFu5ouZWdrIUe4
	 IDo7EeaV2mBXbAvIx1MfqkpFS+yiDYNcgHOKOlb+GbcKJk2ztmnbXJMUK84mNyZbrk
	 vZUVdIEU8VKhz7cNptMc3tr8Tm8rw8JRxa0G2AAHhOGZ6/+xY+rMWJ1b01JAD85MSD
	 BRpcw1Oj8kZXR6Kg9816CgugkB9BWId4479sB5kotAC8yjPvmPuQEOKAAVxGc007n/
	 GDob4VZBJd0Jhi3lwKoT2IY6Zg2qZOauzjtd92cwT4RBnmDEh8UVr4fThhI/yWx9EJ
	 xj4VzGyyAhq8w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/3] ksmbd: Use HMAC-MD5 library for NTLMv2
Date: Tue, 14 Oct 2025 16:17:59 -0700
Message-ID: <20251014231759.136630-4-ebiggers@kernel.org>
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

For the HMAC-MD5 computations in NTLMv2, use the HMAC-MD5 library
instead of a "hmac(md5)" crypto_shash.  This is simpler and faster.
With the library there's no need to allocate memory, no need to handle
errors, and the HMAC-MD5 code is accessed directly without inefficient
indirect calls and other unnecessary API overhead.

To preserve the existing behavior of NTLMv2 support being disabled when
the kernel is booted with "fips=1", make ksmbd_auth_ntlmv2() check
fips_enabled itself.  Previously it relied on the error from
crypto_alloc_shash("hmac(md5)") being bubbled up.  I don't know for sure
that this is actually needed, but this preserves the existing behavior.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/server/Kconfig      |   3 +-
 fs/smb/server/auth.c       | 173 ++++++-------------------------------
 fs/smb/server/crypto_ctx.c |   8 --
 fs/smb/server/crypto_ctx.h |   6 +-
 fs/smb/server/server.c     |   2 -
 5 files changed, 27 insertions(+), 165 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 788104cfb082f..2775162c535c6 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -5,15 +5,14 @@ config SMB_SERVER
 	depends on FILE_LOCKING
 	select NLS
 	select NLS_UTF8
 	select NLS_UCS2_UTILS
 	select CRYPTO
-	select CRYPTO_MD5
-	select CRYPTO_HMAC
 	select CRYPTO_ECB
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_DES
+	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select CRYPTO_CMAC
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 54918f43d2c6b..f2767c4b51326 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -11,10 +11,11 @@
 #include <linux/writeback.h>
 #include <linux/uio.h>
 #include <linux/xattr.h>
 #include <crypto/hash.h>
 #include <crypto/aead.h>
+#include <crypto/md5.h>
 #include <crypto/sha2.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
 
 #include "auth.h"
@@ -68,89 +69,20 @@ static char NEGOTIATE_GSS_HEADER[AUTH_GSS_LENGTH] = {
 void ksmbd_copy_gss_neg_header(void *buf)
 {
 	memcpy(buf, NEGOTIATE_GSS_HEADER, AUTH_GSS_LENGTH);
 }
 
-/**
- * ksmbd_gen_sess_key() - function to generate session key
- * @sess:	session of connection
- * @hash:	source hash value to be used for find session key
- * @hmac:	source hmac value to be used for finding session key
- *
- */
-static int ksmbd_gen_sess_key(struct ksmbd_session *sess, char *hash,
-			      char *hmac)
-{
-	struct ksmbd_crypto_ctx *ctx;
-	int rc;
-
-	ctx = ksmbd_crypto_ctx_find_hmacmd5();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not crypto alloc hmacmd5\n");
-		return -ENOMEM;
-	}
-
-	rc = crypto_shash_setkey(CRYPTO_HMACMD5_TFM(ctx),
-				 hash,
-				 CIFS_HMAC_MD5_HASH_SIZE);
-	if (rc) {
-		ksmbd_debug(AUTH, "hmacmd5 set key fail error %d\n", rc);
-		goto out;
-	}
-
-	rc = crypto_shash_init(CRYPTO_HMACMD5(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "could not init hmacmd5 error %d\n", rc);
-		goto out;
-	}
-
-	rc = crypto_shash_update(CRYPTO_HMACMD5(ctx),
-				 hmac,
-				 SMB2_NTLMV2_SESSKEY_SIZE);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not update with response error %d\n", rc);
-		goto out;
-	}
-
-	rc = crypto_shash_final(CRYPTO_HMACMD5(ctx), sess->sess_key);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate hmacmd5 hash error %d\n", rc);
-		goto out;
-	}
-
-out:
-	ksmbd_release_crypto_ctx(ctx);
-	return rc;
-}
-
 static int calc_ntlmv2_hash(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 			    char *ntlmv2_hash, char *dname)
 {
 	int ret, len, conv_len;
 	wchar_t *domain = NULL;
 	__le16 *uniname = NULL;
-	struct ksmbd_crypto_ctx *ctx;
-
-	ctx = ksmbd_crypto_ctx_find_hmacmd5();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "can't generate ntlmv2 hash\n");
-		return -ENOMEM;
-	}
+	struct hmac_md5_ctx ctx;
 
-	ret = crypto_shash_setkey(CRYPTO_HMACMD5_TFM(ctx),
-				  user_passkey(sess->user),
+	hmac_md5_init_usingrawkey(&ctx, user_passkey(sess->user),
 				  CIFS_ENCPWD_SIZE);
-	if (ret) {
-		ksmbd_debug(AUTH, "Could not set NT Hash as a key\n");
-		goto out;
-	}
-
-	ret = crypto_shash_init(CRYPTO_HMACMD5(ctx));
-	if (ret) {
-		ksmbd_debug(AUTH, "could not init hmacmd5\n");
-		goto out;
-	}
 
 	/* convert user_name to unicode */
 	len = strlen(user_name(sess->user));
 	uniname = kzalloc(2 + UNICODE_LEN(len), KSMBD_DEFAULT_GFP);
 	if (!uniname) {
@@ -164,17 +96,11 @@ static int calc_ntlmv2_hash(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 		ret = -EINVAL;
 		goto out;
 	}
 	UniStrupr(uniname);
 
-	ret = crypto_shash_update(CRYPTO_HMACMD5(ctx),
-				  (char *)uniname,
-				  UNICODE_LEN(conv_len));
-	if (ret) {
-		ksmbd_debug(AUTH, "Could not update with user\n");
-		goto out;
-	}
+	hmac_md5_update(&ctx, (const u8 *)uniname, UNICODE_LEN(conv_len));
 
 	/* Convert domain name or conn name to unicode and uppercase */
 	len = strlen(dname);
 	domain = kzalloc(2 + UNICODE_LEN(len), KSMBD_DEFAULT_GFP);
 	if (!domain) {
@@ -187,25 +113,16 @@ static int calc_ntlmv2_hash(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 	if (conv_len < 0 || conv_len > len) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	ret = crypto_shash_update(CRYPTO_HMACMD5(ctx),
-				  (char *)domain,
-				  UNICODE_LEN(conv_len));
-	if (ret) {
-		ksmbd_debug(AUTH, "Could not update with domain\n");
-		goto out;
-	}
-
-	ret = crypto_shash_final(CRYPTO_HMACMD5(ctx), ntlmv2_hash);
-	if (ret)
-		ksmbd_debug(AUTH, "Could not generate md5 hash\n");
+	hmac_md5_update(&ctx, (const u8 *)domain, UNICODE_LEN(conv_len));
+	hmac_md5_final(&ctx, ntlmv2_hash);
+	ret = 0;
 out:
 	kfree(uniname);
 	kfree(domain);
-	ksmbd_release_crypto_ctx(ctx);
 	return ret;
 }
 
 /**
  * ksmbd_auth_ntlmv2() - NTLMv2 authentication handler
@@ -222,77 +139,37 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 		      struct ntlmv2_resp *ntlmv2, int blen, char *domain_name,
 		      char *cryptkey)
 {
 	char ntlmv2_hash[CIFS_ENCPWD_SIZE];
 	char ntlmv2_rsp[CIFS_HMAC_MD5_HASH_SIZE];
-	struct ksmbd_crypto_ctx *ctx = NULL;
-	char *construct = NULL;
-	int rc, len;
-
-	rc = calc_ntlmv2_hash(conn, sess, ntlmv2_hash, domain_name);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not get v2 hash rc %d\n", rc);
-		goto out;
-	}
-
-	ctx = ksmbd_crypto_ctx_find_hmacmd5();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not crypto alloc hmacmd5\n");
-		return -ENOMEM;
-	}
-
-	rc = crypto_shash_setkey(CRYPTO_HMACMD5_TFM(ctx),
-				 ntlmv2_hash,
-				 CIFS_HMAC_MD5_HASH_SIZE);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not set NTLMV2 Hash as a key\n");
-		goto out;
-	}
-
-	rc = crypto_shash_init(CRYPTO_HMACMD5(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not init hmacmd5\n");
-		goto out;
-	}
+	struct hmac_md5_ctx ctx;
+	int rc;
 
-	len = CIFS_CRYPTO_KEY_SIZE + blen;
-	construct = kzalloc(len, KSMBD_DEFAULT_GFP);
-	if (!construct) {
-		rc = -ENOMEM;
-		goto out;
+	if (fips_enabled) {
+		ksmbd_debug(AUTH, "NTLMv2 support is disabled due to FIPS\n");
+		return -EOPNOTSUPP;
 	}
 
-	memcpy(construct, cryptkey, CIFS_CRYPTO_KEY_SIZE);
-	memcpy(construct + CIFS_CRYPTO_KEY_SIZE, &ntlmv2->blob_signature, blen);
-
-	rc = crypto_shash_update(CRYPTO_HMACMD5(ctx), construct, len);
+	rc = calc_ntlmv2_hash(conn, sess, ntlmv2_hash, domain_name);
 	if (rc) {
-		ksmbd_debug(AUTH, "Could not update with response\n");
-		goto out;
+		ksmbd_debug(AUTH, "could not get v2 hash rc %d\n", rc);
+		return rc;
 	}
 
-	rc = crypto_shash_final(CRYPTO_HMACMD5(ctx), ntlmv2_rsp);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate md5 hash\n");
-		goto out;
-	}
-	ksmbd_release_crypto_ctx(ctx);
-	ctx = NULL;
+	hmac_md5_init_usingrawkey(&ctx, ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+	hmac_md5_update(&ctx, cryptkey, CIFS_CRYPTO_KEY_SIZE);
+	hmac_md5_update(&ctx, (const u8 *)&ntlmv2->blob_signature, blen);
+	hmac_md5_final(&ctx, ntlmv2_rsp);
 
-	rc = ksmbd_gen_sess_key(sess, ntlmv2_hash, ntlmv2_rsp);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate sess key\n");
-		goto out;
-	}
+	/* Generate the session key */
+	hmac_md5_usingrawkey(ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE,
+			     ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE,
+			     sess->sess_key);
 
 	if (memcmp(ntlmv2->ntlmv2_hash, ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE) != 0)
-		rc = -EINVAL;
-out:
-	if (ctx)
-		ksmbd_release_crypto_ctx(ctx);
-	kfree(construct);
-	return rc;
+		return -EINVAL;
+	return 0;
 }
 
 /**
  * ksmbd_decode_ntlmssp_auth_blob() - helper function to construct
  * authenticate blob
diff --git a/fs/smb/server/crypto_ctx.c b/fs/smb/server/crypto_ctx.c
index a5ec22ba8ae37..fe29d186baf68 100644
--- a/fs/smb/server/crypto_ctx.c
+++ b/fs/smb/server/crypto_ctx.c
@@ -64,13 +64,10 @@ static struct shash_desc *alloc_shash_desc(int id)
 {
 	struct crypto_shash *tfm = NULL;
 	struct shash_desc *shash;
 
 	switch (id) {
-	case CRYPTO_SHASH_HMACMD5:
-		tfm = crypto_alloc_shash("hmac(md5)", 0, 0);
-		break;
 	case CRYPTO_SHASH_CMACAES:
 		tfm = crypto_alloc_shash("cmac(aes)", 0, 0);
 		break;
 	default:
 		return NULL;
@@ -172,15 +169,10 @@ static struct ksmbd_crypto_ctx *____crypto_shash_ctx_find(int id)
 		return ctx;
 	ksmbd_release_crypto_ctx(ctx);
 	return NULL;
 }
 
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacmd5(void)
-{
-	return ____crypto_shash_ctx_find(CRYPTO_SHASH_HMACMD5);
-}
-
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void)
 {
 	return ____crypto_shash_ctx_find(CRYPTO_SHASH_CMACAES);
 }
 
diff --git a/fs/smb/server/crypto_ctx.h b/fs/smb/server/crypto_ctx.h
index c571d65a16f3e..b9476ed520ae4 100644
--- a/fs/smb/server/crypto_ctx.h
+++ b/fs/smb/server/crypto_ctx.h
@@ -8,12 +8,11 @@
 
 #include <crypto/hash.h>
 #include <crypto/aead.h>
 
 enum {
-	CRYPTO_SHASH_HMACMD5	= 0,
-	CRYPTO_SHASH_CMACAES,
+	CRYPTO_SHASH_CMACAES	= 0,
 	CRYPTO_SHASH_MAX,
 };
 
 enum {
 	CRYPTO_AEAD_AES_GCM = 16,
@@ -31,21 +30,18 @@ struct ksmbd_crypto_ctx {
 
 	struct shash_desc		*desc[CRYPTO_SHASH_MAX];
 	struct crypto_aead		*ccmaes[CRYPTO_AEAD_MAX];
 };
 
-#define CRYPTO_HMACMD5(c)	((c)->desc[CRYPTO_SHASH_HMACMD5])
 #define CRYPTO_CMACAES(c)	((c)->desc[CRYPTO_SHASH_CMACAES])
 
-#define CRYPTO_HMACMD5_TFM(c)	((c)->desc[CRYPTO_SHASH_HMACMD5]->tfm)
 #define CRYPTO_CMACAES_TFM(c)	((c)->desc[CRYPTO_SHASH_CMACAES]->tfm)
 
 #define CRYPTO_GCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_GCM])
 #define CRYPTO_CCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_CCM])
 
 void ksmbd_release_crypto_ctx(struct ksmbd_crypto_ctx *ctx);
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacmd5(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_gcm(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_ccm(void);
 void ksmbd_crypto_destroy(void);
 int ksmbd_crypto_create(void);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 8bce97633e01a..3cea16050e4f7 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -620,12 +620,10 @@ static void __exit ksmbd_server_exit(void)
 
 MODULE_AUTHOR("Namjae Jeon <linkinjeon@kernel.org>");
 MODULE_DESCRIPTION("Linux kernel CIFS/SMB SERVER");
 MODULE_LICENSE("GPL");
 MODULE_SOFTDEP("pre: ecb");
-MODULE_SOFTDEP("pre: hmac");
-MODULE_SOFTDEP("pre: md5");
 MODULE_SOFTDEP("pre: nls");
 MODULE_SOFTDEP("pre: aes");
 MODULE_SOFTDEP("pre: cmac");
 MODULE_SOFTDEP("pre: aead2");
 MODULE_SOFTDEP("pre: ccm");
-- 
2.51.0

