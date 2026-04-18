Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8A7346A07;
	Sat, 18 Apr 2026 22:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776550417; cv=none; b=ItIl9v59lKf8qJk2pYiD8VopytvPkDQ+EUNsqb5qmY9lqgDnxXIZYcUIEp0x/y9b9v5vpVIhBp/offdDrjPfZkcCz3GIZl5mNPPA7oRzs11w7s6KH1AlWWxy/NzjnNUYEZXXLmNgzTcfVKVQbPTW3TnuABa1dOk9Kr5yXIIYqlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776550417; c=relaxed/simple;
	bh=waPxGS4ymJDY+x+TK7tcOvGyddpnwah8yt2ZpfyHgA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmXKMsh3P7yKtzT+WQJJXu/abNpUbZipRF85670OTMJuTzopL9QJJYV1f917ktr1oJX+lWE4NnWpEYXRR1CMNNxQzqW329kURqMPbodTatgZxiQ/6vvQVpuMJSAceWi2fw6NtPVQfTWO6wuvSJyNtZQCEv7u9FIv4H6R5VSQPGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPG2NKF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPG2NKF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6339FC2BCB4;
	Sat, 18 Apr 2026 22:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776550417;
	bh=waPxGS4ymJDY+x+TK7tcOvGyddpnwah8yt2ZpfyHgA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPG2NKF28m/Yrg6E7dZuZ6LoOL9j9Q4hFjaG22y3ZQwdh2nvCDoM1SXuBoJh2hb1Y
	 VFpWKY/JwTdWiksVmwCjBNjC8QBVcvq6j6SN0OpwKKiUK0unou/A/Y53MAv9hOOZj6
	 m08VPI3iEnH1J108CXep2KgytDiF+LJZo0ew+x/pzYOJz/roL6hi3WnEHz90AbsZb9
	 HnaMxRoxJtOFjiM1lIVkWowTxUNzTb4lz1lBav6YflrQkI/we6LO7ojSU/soxPGaRk
	 trqdNJYiuLTZPGm8m8o1L9/LW/lkjertIKyLvI4ZN49ZWGJf1UXLTicUksBfYwJJ2f
	 2TmVfF4HRnLmQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: linux-crypto@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 1/4] smb: client: Use AES-CMAC library for SMB3 signature calculation
Date: Sat, 18 Apr 2026 15:13:08 -0700
Message-ID: <20260418221311.67583-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418221311.67583-1-ebiggers@kernel.org>
References: <20260418221311.67583-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert smb3_calc_signature() to use the AES-CMAC library instead of a
"cmac(aes)" crypto_shash.

The result is simpler and faster code.  With the library there's no need
to allocate memory, no need to handle errors except for key preparation,
and the AES-CMAC code is accessed directly without inefficient indirect
calls and other unnecessary API overhead.

For now a "cmac(aes)" crypto_shash is still being allocated in
'struct cifs_secmech'.  Later commits will remove that, simplifying the
code even further.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/Kconfig         |  1 +
 fs/smb/client/cifsencrypt.c   | 60 ++++++++++++-----------------------
 fs/smb/client/cifsglob.h      |  2 +-
 fs/smb/client/smb2transport.c | 41 +++++-------------------
 4 files changed, 30 insertions(+), 74 deletions(-)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 63831242fddfb..029bbe595d5fa 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -8,10 +8,11 @@ config CIFS
 	select CRYPTO_CMAC
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select CRYPTO_AES
+	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select KEYS
diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 3d731f3af235f..d092bca2df62d 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -20,66 +20,49 @@
 #include <linux/random.h>
 #include <linux/highmem.h>
 #include <linux/fips.h>
 #include <linux/iov_iter.h>
 #include <crypto/aead.h>
+#include <crypto/aes-cbc-macs.h>
 #include <crypto/arc4.h>
 #include <crypto/md5.h>
 #include <crypto/sha2.h>
 
-static int cifs_sig_update(struct cifs_calc_sig_ctx *ctx,
-			   const u8 *data, size_t len)
+static size_t cifs_sig_step(void *iter_base, size_t progress, size_t len,
+			    void *priv, void *priv2)
 {
-	if (ctx->md5) {
-		md5_update(ctx->md5, data, len);
-		return 0;
-	}
-	if (ctx->hmac) {
-		hmac_sha256_update(ctx->hmac, data, len);
-		return 0;
-	}
-	return crypto_shash_update(ctx->shash, data, len);
+	struct cifs_calc_sig_ctx *ctx = priv;
+
+	if (ctx->md5)
+		md5_update(ctx->md5, iter_base, len);
+	else if (ctx->hmac)
+		hmac_sha256_update(ctx->hmac, iter_base, len);
+	else
+		aes_cmac_update(ctx->cmac, iter_base, len);
+	return 0; /* Return value is length *not* processed, i.e. 0. */
 }
 
-static int cifs_sig_final(struct cifs_calc_sig_ctx *ctx, u8 *out)
+static void cifs_sig_final(struct cifs_calc_sig_ctx *ctx, u8 *out)
 {
-	if (ctx->md5) {
+	if (ctx->md5)
 		md5_final(ctx->md5, out);
-		return 0;
-	}
-	if (ctx->hmac) {
+	else if (ctx->hmac)
 		hmac_sha256_final(ctx->hmac, out);
-		return 0;
-	}
-	return crypto_shash_final(ctx->shash, out);
-}
-
-static size_t cifs_sig_step(void *iter_base, size_t progress, size_t len,
-			    void *priv, void *priv2)
-{
-	struct cifs_calc_sig_ctx *ctx = priv;
-	int ret, *pret = priv2;
-
-	ret = cifs_sig_update(ctx, iter_base, len);
-	if (ret < 0) {
-		*pret = ret;
-		return len;
-	}
-	return 0;
+	else
+		aes_cmac_final(ctx->cmac, out);
 }
 
 /*
  * Pass the data from an iterator into a hash.
  */
 static int cifs_sig_iter(const struct iov_iter *iter, size_t maxsize,
 			 struct cifs_calc_sig_ctx *ctx)
 {
 	struct iov_iter tmp_iter = *iter;
 	size_t did;
-	int err;
 
-	did = iterate_and_advance_kernel(&tmp_iter, maxsize, ctx, &err,
+	did = iterate_and_advance_kernel(&tmp_iter, maxsize, ctx, NULL,
 					 cifs_sig_step);
 	if (did != maxsize)
 		return smb_EIO2(smb_eio_trace_sig_iter, did, maxsize);
 	return 0;
 }
@@ -106,15 +89,12 @@ int __cifs_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 
 	rc = cifs_sig_iter(&rqst->rq_iter, iov_iter_count(&rqst->rq_iter), ctx);
 	if (rc < 0)
 		return rc;
 
-	rc = cifs_sig_final(ctx, signature);
-	if (rc)
-		cifs_dbg(VFS, "%s: Could not generate hash\n", __func__);
-
-	return rc;
+	cifs_sig_final(ctx, signature);
+	return 0;
 }
 
 /* Build a proper attribute value/target info pairs blob.
  * Fill in netbios and dns domain name and workstation name
  * and client time (total five av pairs and + one end of fields indicator.
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ccfde157d3bef..74265d055c265 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2322,11 +2322,11 @@ static inline void mid_execute_callback(struct TCP_Server_Info *server,
 	  FILE_SUPPORTS_REPARSE_POINTS))
 
 struct cifs_calc_sig_ctx {
 	struct md5_ctx *md5;
 	struct hmac_sha256_ctx *hmac;
-	struct shash_desc *shash;
+	struct aes_cmac_ctx *cmac;
 };
 
 #define CIFS_RECONN_DELAY_SECS	30
 #define CIFS_MAX_RECONN_DELAY	(4 * CIFS_RECONN_DELAY_SECS)
 
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 81be2b226e264..b233e0cd91529 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -17,10 +17,11 @@
 #include <linux/uaccess.h>
 #include <asm/processor.h>
 #include <linux/mempool.h>
 #include <linux/highmem.h>
 #include <crypto/aead.h>
+#include <crypto/aes-cbc-macs.h>
 #include <crypto/sha2.h>
 #include <crypto/utils.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
@@ -472,11 +473,12 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 {
 	int rc;
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
-	struct shash_desc *shash = NULL;
+	struct aes_cmac_key cmac_key;
+	struct aes_cmac_ctx cmac_ctx;
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
 	if (server->vals->protocol_id <= SMB21_PROT_ID)
 		return smb2_calc_signature(rqst, server, allocate_crypto);
@@ -485,67 +487,40 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	if (unlikely(rc)) {
 		cifs_server_dbg(FYI, "%s: Could not get signing key\n", __func__);
 		return rc;
 	}
 
-	if (allocate_crypto) {
-		rc = cifs_alloc_hash("cmac(aes)", &shash);
-		if (rc)
-			return rc;
-	} else {
-		shash = server->secmech.aes_cmac;
-	}
-
 	memset(smb3_signature, 0x0, SMB2_CMACAES_SIZE);
 	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
-	rc = crypto_shash_setkey(shash->tfm, key, SMB2_CMACAES_SIZE);
+	rc = aes_cmac_preparekey(&cmac_key, key, SMB2_CMACAES_SIZE);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not set key for cmac aes\n", __func__);
-		goto out;
+		return rc;
 	}
 
-	/*
-	 * we already allocate aes_cmac when we init smb3 signing key,
-	 * so unlike smb2 case we do not have to check here if secmech are
-	 * initialized
-	 */
-	rc = crypto_shash_init(shash);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not init cmac aes\n", __func__);
-		goto out;
-	}
+	aes_cmac_init(&cmac_ctx, &cmac_key);
 
 	/*
 	 * For SMB2+, __cifs_calc_signature() expects to sign only the actual
 	 * data, that is, iov[0] should not contain a rfc1002 length.
 	 *
 	 * Sign the rfc1002 length prior to passing the data (iov[1-N]) down to
 	 * __cifs_calc_signature().
 	 */
 	drqst = *rqst;
 	if (drqst.rq_nvec >= 2 && iov[0].iov_len == 4) {
-		rc = crypto_shash_update(shash, iov[0].iov_base,
-					 iov[0].iov_len);
-		if (rc) {
-			cifs_server_dbg(VFS, "%s: Could not update with payload\n",
-				 __func__);
-			goto out;
-		}
+		aes_cmac_update(&cmac_ctx, iov[0].iov_base, iov[0].iov_len);
 		drqst.rq_iov++;
 		drqst.rq_nvec--;
 	}
 
 	rc = __cifs_calc_signature(
 		&drqst, server, smb3_signature,
-		&(struct cifs_calc_sig_ctx){ .shash = shash });
+		&(struct cifs_calc_sig_ctx){ .cmac = &cmac_ctx });
 	if (!rc)
 		memcpy(shdr->Signature, smb3_signature, SMB2_SIGNATURE_SIZE);
-
-out:
-	if (allocate_crypto)
-		cifs_free_hash(&shash);
 	return rc;
 }
 
 /* must be called with server->srv_mutex held */
 static int
-- 
2.53.0

