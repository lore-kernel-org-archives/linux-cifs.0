Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9445D1DF75B;
	Sun, 12 Oct 2025 01:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760234386; cv=none; b=LfbWehseQbOUNh3LmipSEnOfAuFWeyug5K7n1bsGovq2zzVLUejmQvSD6+770YEGSXX5hhXVsz2Tg6VqPGkFQQSFlaaIVUSvtAlHxKQ6L/xqEjzUch+YHdnaO8iWDSW4Sgg6U3cZsq6HtKix0LFzkYDCbScTq77IoVyLDd22Bv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760234386; c=relaxed/simple;
	bh=jA2FZfxhMt+Si3tAOFKV6vLTDHlRUvrqQRWqaoJ6Ieo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhXS7o7FHPaXx2HkwcovLj8FAih4sE/iOdCP2Mfa4xXaUeiFPf9IqTimeieLJp+GbeVlgP+tMAWNYg3gSMHJ0w+I2lid6/iezCMy5NM7R1PXcePgOJVWeyoBbUx9zvgyMkcr8tBxRr+03EgeaR15oKnslhiLPrpsEeAXqUlg2SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGIj1BEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGIj1BEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA03CC113D0;
	Sun, 12 Oct 2025 01:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760234386;
	bh=jA2FZfxhMt+Si3tAOFKV6vLTDHlRUvrqQRWqaoJ6Ieo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGIj1BEKaeQNdOQJatY5joQ+mhAEmceSlsKZ07M995GmsWcevhNyI72yekQyflvmp
	 OiAIf64Khoz1HHwJUrEoFFPNqxg9NUCl3F/OT8GNHVyZwFailW5Pp/6aBXpMyYDUIr
	 03FqqwtTUIKAIhQ4tdDkNXMDign9Tsmeo5XOQQHV/KjsxC5D+wXHsT/T574vEK541j
	 wAV28xUb+Kl3sAWuBwlLzHyB0WsjIiAgakUex4oHzXFA90fx9Kj97vS6pKWalVs3Zk
	 AhCOpaItBbULbLBgSSomWvKyIJLr5Yu0LioaEi9dugeSNddJO8f0544w4h07bPjjqv
	 fobeEWN+6MWWg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: samba-technical@lists.samba.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/8] smb: client: Use HMAC-SHA256 library for SMB2 signature calculation
Date: Sat, 11 Oct 2025 18:57:33 -0700
Message-ID: <20251012015738.244315-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251012015738.244315-1-ebiggers@kernel.org>
References: <20251012015738.244315-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert smb2_calc_signature() to use the HMAC-SHA256 library instead of
a "hmac(sha256)" crypto_shash.  This is simpler and faster.  With the
library there's no need to allocate memory, no need to handle errors,
and the HMAC-SHA256 code is accessed directly without inefficient
indirect calls and other unnecessary API overhead.

To make this possible, make __cifs_calc_signature() support both the
HMAC-SHA256 library and crypto_shash.  (crypto_shash is still needed for
HMAC-MD5 and AES-CMAC.  A later commit will switch HMAC-MD5 from shash
to the library.  I'd like to eventually do the same for AES-CMAC, but it
doesn't have a library API yet.  So for now, shash is still needed.)

Also remove the unnecessary 'sigptr' variable.

For now smb3_crypto_shash_allocate() still allocates a "hmac(sha256)"
crypto_shash.  It will be removed in a later commit.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/cifsencrypt.c   | 52 +++++++++++++++++++++++-----------
 fs/smb/client/cifsproto.h     |  9 ++++--
 fs/smb/client/smb2transport.c | 53 ++++++++---------------------------
 3 files changed, 53 insertions(+), 61 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 7b7c8c38fdd08..9522088a1cfb7 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -22,43 +22,62 @@
 #include <linux/highmem.h>
 #include <linux/fips.h>
 #include <linux/iov_iter.h>
 #include <crypto/aead.h>
 #include <crypto/arc4.h>
+#include <crypto/sha2.h>
 
-static size_t cifs_shash_step(void *iter_base, size_t progress, size_t len,
-			      void *priv, void *priv2)
+static int cifs_sig_update(struct cifs_calc_sig_ctx *ctx,
+			   const u8 *data, size_t len)
 {
-	struct shash_desc *shash = priv;
+	if (ctx->hmac) {
+		hmac_sha256_update(ctx->hmac, data, len);
+		return 0;
+	}
+	return crypto_shash_update(ctx->shash, data, len);
+}
+
+static int cifs_sig_final(struct cifs_calc_sig_ctx *ctx, u8 *out)
+{
+	if (ctx->hmac) {
+		hmac_sha256_final(ctx->hmac, out);
+		return 0;
+	}
+	return crypto_shash_final(ctx->shash, out);
+}
+
+static size_t cifs_sig_step(void *iter_base, size_t progress, size_t len,
+			    void *priv, void *priv2)
+{
+	struct cifs_calc_sig_ctx *ctx = priv;
 	int ret, *pret = priv2;
 
-	ret = crypto_shash_update(shash, iter_base, len);
+	ret = cifs_sig_update(ctx, iter_base, len);
 	if (ret < 0) {
 		*pret = ret;
 		return len;
 	}
 	return 0;
 }
 
 /*
  * Pass the data from an iterator into a hash.
  */
-static int cifs_shash_iter(const struct iov_iter *iter, size_t maxsize,
-			   struct shash_desc *shash)
+static int cifs_sig_iter(const struct iov_iter *iter, size_t maxsize,
+			 struct cifs_calc_sig_ctx *ctx)
 {
 	struct iov_iter tmp_iter = *iter;
 	int err = -EIO;
 
-	if (iterate_and_advance_kernel(&tmp_iter, maxsize, shash, &err,
-				       cifs_shash_step) != maxsize)
+	if (iterate_and_advance_kernel(&tmp_iter, maxsize, ctx, &err,
+				       cifs_sig_step) != maxsize)
 		return err;
 	return 0;
 }
 
-int __cifs_calc_signature(struct smb_rqst *rqst,
-			  struct TCP_Server_Info *server, char *signature,
-			  struct shash_desc *shash)
+int __cifs_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
+			  char *signature, struct cifs_calc_sig_ctx *ctx)
 {
 	int i;
 	ssize_t rc;
 	struct kvec *iov = rqst->rq_iov;
 	int n_vec = rqst->rq_nvec;
@@ -80,24 +99,23 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 		if (iov[i].iov_base == NULL) {
 			cifs_dbg(VFS, "null iovec entry\n");
 			return -EIO;
 		}
 
-		rc = crypto_shash_update(shash,
-					 iov[i].iov_base, iov[i].iov_len);
+		rc = cifs_sig_update(ctx, iov[i].iov_base, iov[i].iov_len);
 		if (rc) {
 			cifs_dbg(VFS, "%s: Could not update with payload\n",
 				 __func__);
 			return rc;
 		}
 	}
 
-	rc = cifs_shash_iter(&rqst->rq_iter, iov_iter_count(&rqst->rq_iter), shash);
+	rc = cifs_sig_iter(&rqst->rq_iter, iov_iter_count(&rqst->rq_iter), ctx);
 	if (rc < 0)
 		return rc;
 
-	rc = crypto_shash_final(shash, signature);
+	rc = cifs_sig_final(ctx, signature);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate hash\n", __func__);
 
 	return rc;
 }
@@ -132,11 +150,13 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
 		return rc;
 	}
 
-	return __cifs_calc_signature(rqst, server, signature, server->secmech.md5);
+	return __cifs_calc_signature(
+		rqst, server, signature,
+		&(struct cifs_calc_sig_ctx){ .shash = server->secmech.md5 });
 }
 
 /* must be called with server->srv_mutex held */
 int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 		   __u32 *pexpected_response_sequence_number)
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index e8fba98690ce3..3bb74eea0e4ff 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -630,13 +630,16 @@ int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			  unsigned int *pbytes_read);
 int cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			   struct cifs_sb_info *cifs_sb,
 			   const unsigned char *path, char *pbuf,
 			   unsigned int *pbytes_written);
-int __cifs_calc_signature(struct smb_rqst *rqst,
-			struct TCP_Server_Info *server, char *signature,
-			struct shash_desc *shash);
+struct cifs_calc_sig_ctx {
+	struct hmac_sha256_ctx *hmac;
+	struct shash_desc *shash;
+};
+int __cifs_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
+			  char *signature, struct cifs_calc_sig_ctx *ctx);
 enum securityEnum cifs_select_sectype(struct TCP_Server_Info *,
 					enum securityEnum);
 
 int cifs_alloc_hash(const char *name, struct shash_desc **sdesc);
 void cifs_free_hash(struct shash_desc **sdesc);
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index bde96eace8c94..89258accc2203 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -252,14 +252,13 @@ int
 smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 			bool allocate_crypto)
 {
 	int rc;
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
-	unsigned char *sigptr = smb2_signature;
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
-	struct shash_desc *shash = NULL;
+	struct hmac_sha256_ctx hmac_ctx;
 	struct smb_rqst drqst;
 	__u64 sid = le64_to_cpu(shdr->SessionId);
 	u8 key[SMB2_NTLMV2_SESSKEY_SIZE];
 
 	rc = smb2_get_sign_key(server, sid, key);
@@ -270,63 +269,32 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	}
 
 	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
 	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
-	if (allocate_crypto) {
-		rc = cifs_alloc_hash("hmac(sha256)", &shash);
-		if (rc) {
-			cifs_server_dbg(VFS,
-					"%s: sha256 alloc failed\n", __func__);
-			goto out;
-		}
-	} else {
-		shash = server->secmech.hmacsha256;
-	}
-
-	rc = crypto_shash_setkey(shash->tfm, key, sizeof(key));
-	if (rc) {
-		cifs_server_dbg(VFS,
-				"%s: Could not update with response\n",
-				__func__);
-		goto out;
-	}
-
-	rc = crypto_shash_init(shash);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not init sha256", __func__);
-		goto out;
-	}
+	hmac_sha256_init_usingrawkey(&hmac_ctx, key, sizeof(key));
 
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
-			cifs_server_dbg(VFS,
-					"%s: Could not update with payload\n",
-					__func__);
-			goto out;
-		}
+		hmac_sha256_update(&hmac_ctx, iov[0].iov_base, iov[0].iov_len);
 		drqst.rq_iov++;
 		drqst.rq_nvec--;
 	}
 
-	rc = __cifs_calc_signature(&drqst, server, sigptr, shash);
+	rc = __cifs_calc_signature(
+		&drqst, server, smb2_signature,
+		&(struct cifs_calc_sig_ctx){ .hmac = &hmac_ctx });
 	if (!rc)
-		memcpy(shdr->Signature, sigptr, SMB2_SIGNATURE_SIZE);
+		memcpy(shdr->Signature, smb2_signature, SMB2_SIGNATURE_SIZE);
 
-out:
-	if (allocate_crypto)
-		cifs_free_hash(&shash);
 	return rc;
 }
 
 static int generate_key(struct cifs_ses *ses, struct kvec label,
 			struct kvec context, __u8 *key, unsigned int key_size)
@@ -540,11 +508,10 @@ int
 smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 			bool allocate_crypto)
 {
 	int rc;
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
-	unsigned char *sigptr = smb3_signature;
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct shash_desc *shash = NULL;
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
@@ -601,13 +568,15 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 		}
 		drqst.rq_iov++;
 		drqst.rq_nvec--;
 	}
 
-	rc = __cifs_calc_signature(&drqst, server, sigptr, shash);
+	rc = __cifs_calc_signature(
+		&drqst, server, smb3_signature,
+		&(struct cifs_calc_sig_ctx){ .shash = shash });
 	if (!rc)
-		memcpy(shdr->Signature, sigptr, SMB2_SIGNATURE_SIZE);
+		memcpy(shdr->Signature, smb3_signature, SMB2_SIGNATURE_SIZE);
 
 out:
 	if (allocate_crypto)
 		cifs_free_hash(&shash);
 	return rc;
-- 
2.51.0

