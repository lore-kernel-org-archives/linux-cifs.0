Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706C52E7BB6;
	Tue, 14 Oct 2025 23:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760483917; cv=none; b=S8aHOIf6QbGOxAQAWcnMUXeyVUt2Ggb5eYMtVKfeyeXIv6I46cP15fZ2cHYo767eVEfhhcLvxS4zkGdVREK4V46vJOvcDyPtI4MPaLN2g5DHTJ/1v0XJJ8WVMWv7csvAo/tS0TPtTib0hOEPR0dEWn26frP6xOQRJ17Ol7pQQUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760483917; c=relaxed/simple;
	bh=FoBerBuzOHVTmy3VwSOStcvA5MzBO3MB2TRB3nVSUYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWo98Bv9UWivfQWUBf1M3rmDTGE3TJSrHCykbEyP9yzOBB60WiVh16DICJY6bbRxElHqn86crh/bSkm2oDKtj9MiR6ZCPSVogsatVO43r0ql/YeWW7epjg9qYB1MXpz+VA6T17s7lCGx0Xc7Ote5vqonpWH0GhkWNNm5wnAC31k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aq339o40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aq339o40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAC6C4CEF9;
	Tue, 14 Oct 2025 23:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760483916;
	bh=FoBerBuzOHVTmy3VwSOStcvA5MzBO3MB2TRB3nVSUYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aq339o40BdF5VAktYB7OBmZgqXVcavKIDRiPnUmu88d/+bVZPQ0eyDF4Pxw9KVkt5
	 OKI5E9oj/ypn71m5AfiPTYwvPQYAJERBwGZlJ64wf0znrvKD6cu+ULkd2Ds5ffxHWE
	 wKXMScv9vcbf1trL0wJPX9OCCbTDf84uvybL62rIfJ5sRICh8hD45/MLv7kgFi1ZtF
	 qXi7n/EM9qBoRneZk0bYddD3dTOtAcPZgpZoPepgmBs+zlXd6IfdpebivfREhKvDnE
	 7ncC2fAVufmtj+SkPfX2XGDghQRUkditR6eKPefKJrL+pP/P/SxTgA6LoSBTcgvX3S
	 jqx+RTCLiriNQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] ksmbd: Use HMAC-SHA256 library for message signing and key generation
Date: Tue, 14 Oct 2025 16:17:58 -0700
Message-ID: <20251014231759.136630-3-ebiggers@kernel.org>
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

Convert ksmbd_sign_smb2_pdu() and generate_key() to use the HMAC-SHA256
library instead of a "hmac(sha256)" crypto_shash.  This is simpler and
faster.  With the library there's no need to allocate memory, no need to
handle errors, and the HMAC-SHA256 code is accessed directly without
inefficient indirect calls and other unnecessary API overhead.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/server/Kconfig      |   1 -
 fs/smb/server/auth.c       | 176 ++++++++-----------------------------
 fs/smb/server/auth.h       |  10 +--
 fs/smb/server/crypto_ctx.c |   8 --
 fs/smb/server/crypto_ctx.h |   5 --
 fs/smb/server/server.c     |   1 -
 fs/smb/server/smb2pdu.c    |  26 ++----
 fs/smb/server/smb_common.h |   2 +-
 8 files changed, 52 insertions(+), 177 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index d5f3a417246d4..788104cfb082f 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -12,11 +12,10 @@ config SMB_SERVER
 	select CRYPTO_ECB
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
-	select CRYPTO_SHA256
 	select CRYPTO_CMAC
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select ASN1
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index b7f2feede221f..54918f43d2c6b 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -588,50 +588,20 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
  * @iov:        buffer iov array
  * @n_vec:	number of iovecs
  * @sig:	signature value generated for client request packet
  *
  */
-int ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
-			int n_vec, char *sig)
+void ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
+			 int n_vec, char *sig)
 {
-	struct ksmbd_crypto_ctx *ctx;
-	int rc, i;
-
-	ctx = ksmbd_crypto_ctx_find_hmacsha256();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not crypto alloc hmacmd5\n");
-		return -ENOMEM;
-	}
+	struct hmac_sha256_ctx ctx;
+	int i;
 
-	rc = crypto_shash_setkey(CRYPTO_HMACSHA256_TFM(ctx),
-				 key,
-				 SMB2_NTLMV2_SESSKEY_SIZE);
-	if (rc)
-		goto out;
-
-	rc = crypto_shash_init(CRYPTO_HMACSHA256(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "hmacsha256 init error %d\n", rc);
-		goto out;
-	}
-
-	for (i = 0; i < n_vec; i++) {
-		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx),
-					 iov[i].iov_base,
-					 iov[i].iov_len);
-		if (rc) {
-			ksmbd_debug(AUTH, "hmacsha256 update error %d\n", rc);
-			goto out;
-		}
-	}
-
-	rc = crypto_shash_final(CRYPTO_HMACSHA256(ctx), sig);
-	if (rc)
-		ksmbd_debug(AUTH, "hmacsha256 generation error %d\n", rc);
-out:
-	ksmbd_release_crypto_ctx(ctx);
-	return rc;
+	hmac_sha256_init_usingrawkey(&ctx, key, SMB2_NTLMV2_SESSKEY_SIZE);
+	for (i = 0; i < n_vec; i++)
+		hmac_sha256_update(&ctx, iov[i].iov_base, iov[i].iov_len);
+	hmac_sha256_final(&ctx, sig);
 }
 
 /**
  * ksmbd_sign_smb3_pdu() - function to generate packet signing
  * @conn:	connection
@@ -687,102 +657,43 @@ struct derivation {
 	struct kvec label;
 	struct kvec context;
 	bool binding;
 };
 
-static int generate_key(struct ksmbd_conn *conn, struct ksmbd_session *sess,
-			struct kvec label, struct kvec context, __u8 *key,
-			unsigned int key_size)
+static void generate_key(struct ksmbd_conn *conn, struct ksmbd_session *sess,
+			 struct kvec label, struct kvec context, __u8 *key,
+			 unsigned int key_size)
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
 	__u8 L128[4] = {0, 0, 0, 128};
 	__u8 L256[4] = {0, 0, 1, 0};
-	int rc;
 	unsigned char prfhash[SMB2_HMACSHA256_SIZE];
-	unsigned char *hashptr = prfhash;
-	struct ksmbd_crypto_ctx *ctx;
-
-	memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
-	memset(key, 0x0, key_size);
-
-	ctx = ksmbd_crypto_ctx_find_hmacsha256();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not crypto alloc hmacmd5\n");
-		return -ENOMEM;
-	}
+	struct hmac_sha256_ctx ctx;
 
-	rc = crypto_shash_setkey(CRYPTO_HMACSHA256_TFM(ctx),
-				 sess->sess_key,
-				 SMB2_NTLMV2_SESSKEY_SIZE);
-	if (rc)
-		goto smb3signkey_ret;
-
-	rc = crypto_shash_init(CRYPTO_HMACSHA256(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "hmacsha256 init error %d\n", rc);
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), i, 4);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with n\n");
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx),
-				 label.iov_base,
-				 label.iov_len);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with label\n");
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), &zero, 1);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with zero\n");
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx),
-				 context.iov_base,
-				 context.iov_len);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with context\n");
-		goto smb3signkey_ret;
-	}
+	hmac_sha256_init_usingrawkey(&ctx, sess->sess_key,
+				     SMB2_NTLMV2_SESSKEY_SIZE);
+	hmac_sha256_update(&ctx, i, 4);
+	hmac_sha256_update(&ctx, label.iov_base, label.iov_len);
+	hmac_sha256_update(&ctx, &zero, 1);
+	hmac_sha256_update(&ctx, context.iov_base, context.iov_len);
 
 	if (key_size == SMB3_ENC_DEC_KEY_SIZE &&
 	    (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
 	     conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L256, 4);
+		hmac_sha256_update(&ctx, L256, 4);
 	else
-		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L128, 4);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with L\n");
-		goto smb3signkey_ret;
-	}
+		hmac_sha256_update(&ctx, L128, 4);
 
-	rc = crypto_shash_final(CRYPTO_HMACSHA256(ctx), hashptr);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate hmacmd5 hash error %d\n",
-			    rc);
-		goto smb3signkey_ret;
-	}
-
-	memcpy(key, hashptr, key_size);
-
-smb3signkey_ret:
-	ksmbd_release_crypto_ctx(ctx);
-	return rc;
+	hmac_sha256_final(&ctx, prfhash);
+	memcpy(key, prfhash, key_size);
 }
 
 static int generate_smb3signingkey(struct ksmbd_session *sess,
 				   struct ksmbd_conn *conn,
 				   const struct derivation *signing)
 {
-	int rc;
 	struct channel *chann;
 	char *key;
 
 	chann = lookup_chann_list(sess, conn);
 	if (!chann)
@@ -791,14 +702,12 @@ static int generate_smb3signingkey(struct ksmbd_session *sess,
 	if (conn->dialect >= SMB30_PROT_ID && signing->binding)
 		key = chann->smb3signingkey;
 	else
 		key = sess->smb3signingkey;
 
-	rc = generate_key(conn, sess, signing->label, signing->context, key,
-			  SMB3_SIGN_KEY_SIZE);
-	if (rc)
-		return rc;
+	generate_key(conn, sess, signing->label, signing->context, key,
+		     SMB3_SIGN_KEY_SIZE);
 
 	if (!(conn->dialect >= SMB30_PROT_ID && signing->binding))
 		memcpy(chann->smb3signingkey, key, SMB3_SIGN_KEY_SIZE);
 
 	ksmbd_debug(AUTH, "dumping generated AES signing keys\n");
@@ -850,27 +759,21 @@ int ksmbd_gen_smb311_signingkey(struct ksmbd_session *sess,
 struct derivation_twin {
 	struct derivation encryption;
 	struct derivation decryption;
 };
 
-static int generate_smb3encryptionkey(struct ksmbd_conn *conn,
-				      struct ksmbd_session *sess,
-				      const struct derivation_twin *ptwin)
+static void generate_smb3encryptionkey(struct ksmbd_conn *conn,
+				       struct ksmbd_session *sess,
+				       const struct derivation_twin *ptwin)
 {
-	int rc;
+	generate_key(conn, sess, ptwin->encryption.label,
+		     ptwin->encryption.context, sess->smb3encryptionkey,
+		     SMB3_ENC_DEC_KEY_SIZE);
 
-	rc = generate_key(conn, sess, ptwin->encryption.label,
-			  ptwin->encryption.context, sess->smb3encryptionkey,
-			  SMB3_ENC_DEC_KEY_SIZE);
-	if (rc)
-		return rc;
-
-	rc = generate_key(conn, sess, ptwin->decryption.label,
-			  ptwin->decryption.context,
-			  sess->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE);
-	if (rc)
-		return rc;
+	generate_key(conn, sess, ptwin->decryption.label,
+		     ptwin->decryption.context,
+		     sess->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE);
 
 	ksmbd_debug(AUTH, "dumping generated AES encryption keys\n");
 	ksmbd_debug(AUTH, "Cipher type   %d\n", conn->cipher_type);
 	ksmbd_debug(AUTH, "Session Id    %llu\n", sess->id);
 	ksmbd_debug(AUTH, "Session Key   %*ph\n",
@@ -885,15 +788,14 @@ static int generate_smb3encryptionkey(struct ksmbd_conn *conn,
 		ksmbd_debug(AUTH, "ServerIn Key  %*ph\n",
 			    SMB3_GCM128_CRYPTKEY_SIZE, sess->smb3encryptionkey);
 		ksmbd_debug(AUTH, "ServerOut Key %*ph\n",
 			    SMB3_GCM128_CRYPTKEY_SIZE, sess->smb3decryptionkey);
 	}
-	return 0;
 }
 
-int ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
-				  struct ksmbd_session *sess)
+void ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
+				   struct ksmbd_session *sess)
 {
 	struct derivation_twin twin;
 	struct derivation *d;
 
 	d = &twin.encryption;
@@ -906,15 +808,15 @@ int ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
 	d->label.iov_base = "SMB2AESCCM";
 	d->label.iov_len = 11;
 	d->context.iov_base = "ServerIn ";
 	d->context.iov_len = 10;
 
-	return generate_smb3encryptionkey(conn, sess, &twin);
+	generate_smb3encryptionkey(conn, sess, &twin);
 }
 
-int ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
-				   struct ksmbd_session *sess)
+void ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
+				    struct ksmbd_session *sess)
 {
 	struct derivation_twin twin;
 	struct derivation *d;
 
 	d = &twin.encryption;
@@ -927,11 +829,11 @@ int ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
 	d->label.iov_base = "SMBC2SCipherKey";
 	d->label.iov_len = 16;
 	d->context.iov_base = sess->Preauth_HashValue;
 	d->context.iov_len = 64;
 
-	return generate_smb3encryptionkey(conn, sess, &twin);
+	generate_smb3encryptionkey(conn, sess, &twin);
 }
 
 int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
 				     __u8 *pi_hash)
 {
diff --git a/fs/smb/server/auth.h b/fs/smb/server/auth.h
index 6879a1bd1b91f..6d351d61b0e57 100644
--- a/fs/smb/server/auth.h
+++ b/fs/smb/server/auth.h
@@ -50,20 +50,20 @@ int ksmbd_decode_ntlmssp_neg_blob(struct negotiate_message *negblob,
 unsigned int
 ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
 				   struct ksmbd_conn *conn);
 int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 			    int in_len,	char *out_blob, int *out_len);
-int ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
-			int n_vec, char *sig);
+void ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
+			 int n_vec, char *sig);
 int ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
 			int n_vec, char *sig);
 int ksmbd_gen_smb30_signingkey(struct ksmbd_session *sess,
 			       struct ksmbd_conn *conn);
 int ksmbd_gen_smb311_signingkey(struct ksmbd_session *sess,
 				struct ksmbd_conn *conn);
-int ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
-				  struct ksmbd_session *sess);
-int ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
+void ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
 				   struct ksmbd_session *sess);
+void ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
+				    struct ksmbd_session *sess);
 int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
 				     __u8 *pi_hash);
 #endif
diff --git a/fs/smb/server/crypto_ctx.c b/fs/smb/server/crypto_ctx.c
index 1de41b10528bc..a5ec22ba8ae37 100644
--- a/fs/smb/server/crypto_ctx.c
+++ b/fs/smb/server/crypto_ctx.c
@@ -67,13 +67,10 @@ static struct shash_desc *alloc_shash_desc(int id)
 
 	switch (id) {
 	case CRYPTO_SHASH_HMACMD5:
 		tfm = crypto_alloc_shash("hmac(md5)", 0, 0);
 		break;
-	case CRYPTO_SHASH_HMACSHA256:
-		tfm = crypto_alloc_shash("hmac(sha256)", 0, 0);
-		break;
 	case CRYPTO_SHASH_CMACAES:
 		tfm = crypto_alloc_shash("cmac(aes)", 0, 0);
 		break;
 	default:
 		return NULL;
@@ -180,15 +177,10 @@ static struct ksmbd_crypto_ctx *____crypto_shash_ctx_find(int id)
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacmd5(void)
 {
 	return ____crypto_shash_ctx_find(CRYPTO_SHASH_HMACMD5);
 }
 
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacsha256(void)
-{
-	return ____crypto_shash_ctx_find(CRYPTO_SHASH_HMACSHA256);
-}
-
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void)
 {
 	return ____crypto_shash_ctx_find(CRYPTO_SHASH_CMACAES);
 }
 
diff --git a/fs/smb/server/crypto_ctx.h b/fs/smb/server/crypto_ctx.h
index 4e8954acd8b8b..c571d65a16f3e 100644
--- a/fs/smb/server/crypto_ctx.h
+++ b/fs/smb/server/crypto_ctx.h
@@ -9,11 +9,10 @@
 #include <crypto/hash.h>
 #include <crypto/aead.h>
 
 enum {
 	CRYPTO_SHASH_HMACMD5	= 0,
-	CRYPTO_SHASH_HMACSHA256,
 	CRYPTO_SHASH_CMACAES,
 	CRYPTO_SHASH_MAX,
 };
 
 enum {
@@ -33,24 +32,20 @@ struct ksmbd_crypto_ctx {
 	struct shash_desc		*desc[CRYPTO_SHASH_MAX];
 	struct crypto_aead		*ccmaes[CRYPTO_AEAD_MAX];
 };
 
 #define CRYPTO_HMACMD5(c)	((c)->desc[CRYPTO_SHASH_HMACMD5])
-#define CRYPTO_HMACSHA256(c)	((c)->desc[CRYPTO_SHASH_HMACSHA256])
 #define CRYPTO_CMACAES(c)	((c)->desc[CRYPTO_SHASH_CMACAES])
 
 #define CRYPTO_HMACMD5_TFM(c)	((c)->desc[CRYPTO_SHASH_HMACMD5]->tfm)
-#define CRYPTO_HMACSHA256_TFM(c)\
-				((c)->desc[CRYPTO_SHASH_HMACSHA256]->tfm)
 #define CRYPTO_CMACAES_TFM(c)	((c)->desc[CRYPTO_SHASH_CMACAES]->tfm)
 
 #define CRYPTO_GCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_GCM])
 #define CRYPTO_CCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_CCM])
 
 void ksmbd_release_crypto_ctx(struct ksmbd_crypto_ctx *ctx);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacmd5(void);
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacsha256(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_gcm(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_ccm(void);
 void ksmbd_crypto_destroy(void);
 int ksmbd_crypto_create(void);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 51e2aee2a6985..8bce97633e01a 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -625,11 +625,10 @@ MODULE_SOFTDEP("pre: ecb");
 MODULE_SOFTDEP("pre: hmac");
 MODULE_SOFTDEP("pre: md5");
 MODULE_SOFTDEP("pre: nls");
 MODULE_SOFTDEP("pre: aes");
 MODULE_SOFTDEP("pre: cmac");
-MODULE_SOFTDEP("pre: sha256");
 MODULE_SOFTDEP("pre: aead2");
 MODULE_SOFTDEP("pre: ccm");
 MODULE_SOFTDEP("pre: gcm");
 module_init(ksmbd_server_init)
 module_exit(ksmbd_server_exit)
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ab1d45fcebdef..b315b07bc4043 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1536,16 +1536,11 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
 		sess->sign = true;
 
 	if (smb3_encryption_negotiated(conn) &&
 			!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
-		rc = conn->ops->generate_encryptionkey(conn, sess);
-		if (rc) {
-			ksmbd_debug(SMB,
-					"SMB3 encryption key generation failed\n");
-			return -EINVAL;
-		}
+		conn->ops->generate_encryptionkey(conn, sess);
 		sess->enc = true;
 		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
 			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
 		/*
 		 * signing is disable if encryption is enable
@@ -1638,16 +1633,11 @@ static int krb5_authenticate(struct ksmbd_work *work,
 	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
 		sess->sign = true;
 
 	if (smb3_encryption_negotiated(conn) &&
 	    !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
-		retval = conn->ops->generate_encryptionkey(conn, sess);
-		if (retval) {
-			ksmbd_debug(SMB,
-				    "SMB3 encryption key generation failed\n");
-			return -EINVAL;
-		}
+		conn->ops->generate_encryptionkey(conn, sess);
 		sess->enc = true;
 		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
 			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
 		sess->sign = false;
 	}
@@ -8850,13 +8840,12 @@ int smb2_check_sign_req(struct ksmbd_work *work)
 	memset(hdr->Signature, 0, SMB2_SIGNATURE_SIZE);
 
 	iov[0].iov_base = (char *)&hdr->ProtocolId;
 	iov[0].iov_len = len;
 
-	if (ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
-				signature))
-		return 0;
+	ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
+			    signature);
 
 	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
@@ -8876,22 +8865,21 @@ void smb2_set_sign_rsp(struct ksmbd_work *work)
 	struct kvec *iov;
 	int n_vec = 1;
 
 	hdr = ksmbd_resp_buf_curr(work);
 	hdr->Flags |= SMB2_FLAGS_SIGNED;
-	memset(hdr->Signature, 0, SMB2_SIGNATURE_SIZE);
 
 	if (hdr->Command == SMB2_READ) {
 		iov = &work->iov[work->iov_idx - 1];
 		n_vec++;
 	} else {
 		iov = &work->iov[work->iov_idx];
 	}
 
-	if (!ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, n_vec,
-				 signature))
-		memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
+	ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, n_vec,
+			    signature);
+	memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
 }
 
 /**
  * smb3_check_sign_req() - handler for req packet sign processing
  * @work:   smb work containing notify command buffer
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index d742ba754348b..b6e0659a7e414 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -407,11 +407,11 @@ struct smb_version_ops {
 	int (*get_ksmbd_tcon)(struct ksmbd_work *work);
 	bool (*is_sign_req)(struct ksmbd_work *work, unsigned int command);
 	int (*check_sign_req)(struct ksmbd_work *work);
 	void (*set_sign_rsp)(struct ksmbd_work *work);
 	int (*generate_signingkey)(struct ksmbd_session *sess, struct ksmbd_conn *conn);
-	int (*generate_encryptionkey)(struct ksmbd_conn *conn, struct ksmbd_session *sess);
+	void (*generate_encryptionkey)(struct ksmbd_conn *conn, struct ksmbd_session *sess);
 	bool (*is_transform_hdr)(void *buf);
 	int (*decrypt_req)(struct ksmbd_work *work);
 	int (*encrypt_resp)(struct ksmbd_work *work);
 };
 
-- 
2.51.0

