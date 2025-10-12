Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D55E1EB9FA;
	Sun, 12 Oct 2025 01:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760234387; cv=none; b=KK6+pUVAA2vJq0NXOti55U0TjOqTjFwcfd6e+Om7yL5TkIYD693X60Ky4WwUIDHx0ietWzxqtzZcbW9oQ9V3uOEdTW06nk36cvkyruq75pJDO5uBDTh1+vhNT/kGi6GcwJwEPSpuN9KZwCde2yEWBjHA+XjAZo/HaouvQc/lzSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760234387; c=relaxed/simple;
	bh=BeoMBztbvcFX7rlY3UlLBL/j/SrAexLozHMH/LcR0Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALhK9kmQe4ljWHsVWS9XcBUHMQBmTPgT22vu1SOfh9vVZQkRWlO4aYvb9g5b8uy/w1IYOVvy0nDz6mplqTXah3xTb8QysPVWd/vNx26XifrjJYwCKE2Hg8Ibl3Jto7FDaIPPEE6+88n/vGiKSUuViKuMmduWVPqESZ8VZP7pgK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/HdaC4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/HdaC4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09C2C116B1;
	Sun, 12 Oct 2025 01:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760234387;
	bh=BeoMBztbvcFX7rlY3UlLBL/j/SrAexLozHMH/LcR0Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/HdaC4uMmXHTdT/xwfRNxGkdiy2jHuLg1LULk7maMj+wD1Z5ajherw1whr2B5e18
	 ZE+xAYUnyUfn6uDMobTxz4MaOzJVUjvq0tm/9nchPlMhCJkRgA6rKXJzEkvoXj6USO
	 A1JBSfHmEK5us02Vzoqn7AThV8pcLrFXFYwruECHyMEvToRMlRpFbG5kqQnVJDMCDm
	 SLYUPP6XBI+1OIfE/n/mSR2B/VruZihrDgH41uxu+YyCgGsizvkI+68CsBbgp2RNaO
	 OCt/W8gd8dL/k0/Ge/a4/r0Yd/wgT/mVUVZGStJPPy9Dxh2fILgyUih69GNaZM2BEm
	 4nCO/ylPjB6qw==
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
Subject: [PATCH 5/8] smb: client: Use MD5 library for SMB1 signature calculation
Date: Sat, 11 Oct 2025 18:57:35 -0700
Message-ID: <20251012015738.244315-6-ebiggers@kernel.org>
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

Convert cifs_calc_signature() to use the MD5 library instead of a "md5"
crypto_shash.  This is simpler and faster.  With the library there's no
need to allocate memory, no need to handle errors, and the MD5 code is
accessed directly without inefficient indirect calls and other
unnecessary API overhead.

To preserve the existing behavior of MD5 signature support being
disabled when the kernel is booted with "fips=1", make
cifs_calc_signature() check fips_enabled itself.  Previously it relied
on the error from cifs_alloc_hash("md5", &server->secmech.md5).

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/cifsencrypt.c | 34 +++++++++++++++++-----------------
 fs/smb/client/cifsproto.h   |  1 +
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 9522088a1cfb7..80215ba7a5744 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -22,24 +22,33 @@
 #include <linux/highmem.h>
 #include <linux/fips.h>
 #include <linux/iov_iter.h>
 #include <crypto/aead.h>
 #include <crypto/arc4.h>
+#include <crypto/md5.h>
 #include <crypto/sha2.h>
 
 static int cifs_sig_update(struct cifs_calc_sig_ctx *ctx,
 			   const u8 *data, size_t len)
 {
+	if (ctx->md5) {
+		md5_update(ctx->md5, data, len);
+		return 0;
+	}
 	if (ctx->hmac) {
 		hmac_sha256_update(ctx->hmac, data, len);
 		return 0;
 	}
 	return crypto_shash_update(ctx->shash, data, len);
 }
 
 static int cifs_sig_final(struct cifs_calc_sig_ctx *ctx, u8 *out)
 {
+	if (ctx->md5) {
+		md5_final(ctx->md5, out);
+		return 0;
+	}
 	if (ctx->hmac) {
 		hmac_sha256_final(ctx->hmac, out);
 		return 0;
 	}
 	return crypto_shash_final(ctx->shash, out);
@@ -128,35 +137,26 @@ int __cifs_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
  * should be called with the server->srv_mutex held.
  */
 static int cifs_calc_signature(struct smb_rqst *rqst,
 			struct TCP_Server_Info *server, char *signature)
 {
-	int rc;
+	struct md5_ctx ctx;
 
 	if (!rqst->rq_iov || !signature || !server)
 		return -EINVAL;
-
-	rc = cifs_alloc_hash("md5", &server->secmech.md5);
-	if (rc)
-		return -1;
-
-	rc = crypto_shash_init(server->secmech.md5);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init md5\n", __func__);
-		return rc;
+	if (fips_enabled) {
+		cifs_dbg(VFS,
+			 "MD5 signature support is disabled due to FIPS\n");
+		return -EOPNOTSUPP;
 	}
 
-	rc = crypto_shash_update(server->secmech.md5,
-		server->session_key.response, server->session_key.len);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
-		return rc;
-	}
+	md5_init(&ctx);
+	md5_update(&ctx, server->session_key.response, server->session_key.len);
 
 	return __cifs_calc_signature(
 		rqst, server, signature,
-		&(struct cifs_calc_sig_ctx){ .shash = server->secmech.md5 });
+		&(struct cifs_calc_sig_ctx){ .md5 = &ctx });
 }
 
 /* must be called with server->srv_mutex held */
 int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 		   __u32 *pexpected_response_sequence_number)
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 3bb74eea0e4ff..4976be2c47c14 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -631,10 +631,11 @@ int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 int cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			   struct cifs_sb_info *cifs_sb,
 			   const unsigned char *path, char *pbuf,
 			   unsigned int *pbytes_written);
 struct cifs_calc_sig_ctx {
+	struct md5_ctx *md5;
 	struct hmac_sha256_ctx *hmac;
 	struct shash_desc *shash;
 };
 int __cifs_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 			  char *signature, struct cifs_calc_sig_ctx *ctx);
-- 
2.51.0

