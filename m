Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9E81E0DFE;
	Sun, 12 Oct 2025 01:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760234386; cv=none; b=ZXTNC9rzzv9yA2aihBrcPYHoPR1DVtnwtL7CpDg4OohDWAC/LsW9K1wYFDSo5W8BOvVSHLzCosbH1zm0UMsrf4ydPFc+x3c1oNqgAU4SWPgO9Dz8vNPjCIOrrBGht5/B4w7hv/TSEY2w3ixkcn+6zR1T6l2DyIZkXUBKwbMdSaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760234386; c=relaxed/simple;
	bh=JhHxre8sN4Y1ugTTLTf0Yhjkw9zjfabtQaNOSXJn+OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJfx5kYoDJ793c6IWdsQxqk2ZM0natXQWefZestdKuzeXbRvVuYOFvpzNuy4/h9XKxEC8k5idvWCF2I0h6qKjwDo6xaMkfCQQ8k1B6Oj/ghavo0TeFF/fbqq7MEMCFPnr7A/fGjGWVXEIpSk2hcJFVE2pIqOzZcuy4xj1w3XgeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sa30SE0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sa30SE0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B95FC4CEF9;
	Sun, 12 Oct 2025 01:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760234386;
	bh=JhHxre8sN4Y1ugTTLTf0Yhjkw9zjfabtQaNOSXJn+OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sa30SE0+EqxZyaE63NhzySKXds81BVuFMAZIUhwiffgHWzABbBQG9NAjqIu+fSede
	 Lj6Yg9xae/goWaRuySxh19XVDzLc2RvVXi1PlRkEEMcxkamzBipF/MaRwEAOZjpn1J
	 eUHBmHbENwi3UefeoAd82vZsHef4xD8JxgFac9lCFnanOmSv1jn2GRD7qFOvS0ILOy
	 n2bHdgtImzZJvS23Skuhze89+6SkEmkyGaAAaiCiCnn7V6tAj+feLqAUQVDxCCW2Aa
	 H/Ib5LxeJy4VzXQOgdCsSKfGPaAdT3+XrQ2sC1Ju+xVULfUu0dXwDGaQyEjpG7bm+5
	 e7izBmIHvV+HA==
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
Subject: [PATCH 4/8] smb: client: Use MD5 library for M-F symlink hashing
Date: Sat, 11 Oct 2025 18:57:34 -0700
Message-ID: <20251012015738.244315-5-ebiggers@kernel.org>
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

Convert parse_mf_symlink() and format_mf_symlink() to use the MD5
library instead of a "md5" crypto_shash.  This is simpler and faster.
With the library there's no need to allocate memory, no need to handle
errors, and the MD5 code is accessed directly without inefficient
indirect calls and other unnecessary API overhead.

This also fixes an issue where these functions did not work on kernels
booted in FIPS mode.  The use of MD5 here is for data integrity rather
than a security purpose, so it can use a non-FIPS-approved algorithm.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/Kconfig |  1 +
 fs/smb/client/link.c  | 31 +++----------------------------
 2 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index f0c1ff8544f67..f5a980bdfc939 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -14,10 +14,11 @@ config CIFS
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select CRYPTO_ECB
 	select CRYPTO_AES
 	select CRYPTO_LIB_ARC4
+	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select KEYS
 	select DNS_RESOLVER
 	select ASN1
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index fe80e711cd756..70f3c0c67eebd 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -3,10 +3,11 @@
  *
  *   Copyright (C) International Business Machines  Corp., 2002,2008
  *   Author(s): Steve French (sfrench@us.ibm.com)
  *
  */
+#include <crypto/md5.h>
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/namei.h>
 #include "cifsfs.h"
@@ -34,27 +35,10 @@
 
 #define CIFS_MF_SYMLINK_LEN_FORMAT "XSym\n%04u\n"
 #define CIFS_MF_SYMLINK_MD5_FORMAT "%16phN\n"
 #define CIFS_MF_SYMLINK_MD5_ARGS(md5_hash) md5_hash
 
-static int
-symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
-{
-	int rc;
-	struct shash_desc *md5 = NULL;
-
-	rc = cifs_alloc_hash("md5", &md5);
-	if (rc)
-		return rc;
-
-	rc = crypto_shash_digest(md5, link_str, link_len, md5_hash);
-	if (rc)
-		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
-	cifs_free_hash(&md5);
-	return rc;
-}
-
 static int
 parse_mf_symlink(const u8 *buf, unsigned int buf_len, unsigned int *_link_len,
 		 char **_link_str)
 {
 	int rc;
@@ -75,15 +59,11 @@ parse_mf_symlink(const u8 *buf, unsigned int buf_len, unsigned int *_link_len,
 		return -EINVAL;
 
 	if (link_len > CIFS_MF_SYMLINK_LINK_MAXLEN)
 		return -EINVAL;
 
-	rc = symlink_hash(link_len, link_str, md5_hash);
-	if (rc) {
-		cifs_dbg(FYI, "%s: MD5 hash failure: %d\n", __func__, rc);
-		return rc;
-	}
+	md5(link_str, link_len, md5_hash);
 
 	scnprintf(md5_str2, sizeof(md5_str2),
 		  CIFS_MF_SYMLINK_MD5_FORMAT,
 		  CIFS_MF_SYMLINK_MD5_ARGS(md5_hash));
 
@@ -101,11 +81,10 @@ parse_mf_symlink(const u8 *buf, unsigned int buf_len, unsigned int *_link_len,
 }
 
 static int
 format_mf_symlink(u8 *buf, unsigned int buf_len, const char *link_str)
 {
-	int rc;
 	unsigned int link_len;
 	unsigned int ofs;
 	u8 md5_hash[16];
 
 	if (buf_len != CIFS_MF_SYMLINK_FILE_SIZE)
@@ -114,15 +93,11 @@ format_mf_symlink(u8 *buf, unsigned int buf_len, const char *link_str)
 	link_len = strlen(link_str);
 
 	if (link_len > CIFS_MF_SYMLINK_LINK_MAXLEN)
 		return -ENAMETOOLONG;
 
-	rc = symlink_hash(link_len, link_str, md5_hash);
-	if (rc) {
-		cifs_dbg(FYI, "%s: MD5 hash failure: %d\n", __func__, rc);
-		return rc;
-	}
+	md5(link_str, link_len, md5_hash);
 
 	scnprintf(buf, buf_len,
 		  CIFS_MF_SYMLINK_LEN_FORMAT CIFS_MF_SYMLINK_MD5_FORMAT,
 		  link_len,
 		  CIFS_MF_SYMLINK_MD5_ARGS(md5_hash));
-- 
2.51.0

