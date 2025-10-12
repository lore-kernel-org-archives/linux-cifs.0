Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020B51DC198;
	Sun, 12 Oct 2025 01:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760234386; cv=none; b=Q1jtoL9HIBolQ3IB0N2JEIKXSuRDikoFdRXRq5CmpQI9iRVIJvqJ0vHjBBGkn0Vq3u4OqvYzpuRHUM6USZphvTngz/gnvz3jy0787LYeGTtng3w45RaOBuyqMRgS0HNN8+NYZ0PX9ahl/huQagHX6HvuRAL9f4dCtLca+KE2WSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760234386; c=relaxed/simple;
	bh=CFwwvsQDJoXU8kuloHYUxNSwdl7+OvrAbXEAKBrRTe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCojj8RytR7aVz5B7VwfcbsGNbrsMssAaOw88wZkA5YRG5Uf+XCgUvk9csq3X4FedRRO9us4jcOhv/JB5fBPNkRPXygcg3CSFgH900VMLeZ1mkFcfTs2/Uy0TclHzgfuyP/6rcvnJtk8fRyen7ft++/Ve3HQnIj3uugAeutpRQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmS8iJ5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmS8iJ5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5404AC4CEF9;
	Sun, 12 Oct 2025 01:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760234385;
	bh=CFwwvsQDJoXU8kuloHYUxNSwdl7+OvrAbXEAKBrRTe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmS8iJ5wZo2v/APcs9jWMtqsxbTgtSEjmDdCu3oDUiknoCMzKkmOgdUHCWJrTbS4b
	 Hzdb53bi94VrmBLcx4CTAuh9o7ywWsWBwefpoism2V1G2DirNqoov69rz9yPowI1do
	 MpiGiKdO27bAp2jPhYah4+CFjj7HOmkZ77JJXyM7uz2Q5Tou6/TZ/wJ0i2X2xDG2AQ
	 j55ePl7Sokh6zCyzTEz+JU83ofSsWCNBIr1YgJSk7+VKi2+5ZddUDp9QzHjgwlpCTe
	 E/zotRg8dClJx0KKFWz5Kv/yfR3JgYJfwCoYCkSrkO3pEqXVecMen/zRkCR3iQoj8K
	 lX2n9F70kELcw==
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
Subject: [PATCH 2/8] smb: client: Use HMAC-SHA256 library for key generation
Date: Sat, 11 Oct 2025 18:57:32 -0700
Message-ID: <20251012015738.244315-3-ebiggers@kernel.org>
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

Convert generate_key() to use the HMAC-SHA256 library instead of a
"hmac(sha256)" crypto_shash.  This is simpler and faster.  With the
library there's no need to allocate memory, no need to handle errors,
and the HMAC-SHA256 code is accessed directly without inefficient
indirect calls and other unnecessary API overhead.

Also remove the unnecessary 'hashptr' variable.

For now smb3_crypto_shash_allocate() still allocates a "hmac(sha256)"
crypto_shash.  It will be removed in a later commit.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/Kconfig         |  1 +
 fs/smb/client/smb2transport.c | 68 ++++++++---------------------------
 2 files changed, 15 insertions(+), 54 deletions(-)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 4ac79ff5649bf..f0c1ff8544f67 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -14,10 +14,11 @@ config CIFS
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select CRYPTO_ECB
 	select CRYPTO_AES
 	select CRYPTO_LIB_ARC4
+	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select KEYS
 	select DNS_RESOLVER
 	select ASN1
 	select OID_REGISTRY
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 33f33013b3927..bde96eace8c94 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -17,10 +17,11 @@
 #include <linux/uaccess.h>
 #include <asm/processor.h>
 #include <linux/mempool.h>
 #include <linux/highmem.h>
 #include <crypto/aead.h>
+#include <crypto/sha2.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
 #include "cifs_debug.h"
 #include "../common/smb2status.h"
@@ -334,80 +335,39 @@ static int generate_key(struct cifs_ses *ses, struct kvec label,
 	__u8 i[4] = {0, 0, 0, 1};
 	__u8 L128[4] = {0, 0, 0, 128};
 	__u8 L256[4] = {0, 0, 1, 0};
 	int rc = 0;
 	unsigned char prfhash[SMB2_HMACSHA256_SIZE];
-	unsigned char *hashptr = prfhash;
 	struct TCP_Server_Info *server = ses->server;
+	struct hmac_sha256_ctx hmac_ctx;
 
 	memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
 	memset(key, 0x0, key_size);
 
 	rc = smb3_crypto_shash_allocate(server);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: crypto alloc failed\n", __func__);
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_setkey(server->secmech.hmacsha256->tfm,
-		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not set with session key\n", __func__);
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_init(server->secmech.hmacsha256);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not init sign hmac\n", __func__);
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_update(server->secmech.hmacsha256, i, 4);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not update with n\n", __func__);
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_update(server->secmech.hmacsha256, label.iov_base, label.iov_len);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not update with label\n", __func__);
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_update(server->secmech.hmacsha256, &zero, 1);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not update with zero\n", __func__);
-		goto smb3signkey_ret;
+		return rc;
 	}
 
-	rc = crypto_shash_update(server->secmech.hmacsha256, context.iov_base, context.iov_len);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not update with context\n", __func__);
-		goto smb3signkey_ret;
-	}
+	hmac_sha256_init_usingrawkey(&hmac_ctx, ses->auth_key.response,
+				     SMB2_NTLMV2_SESSKEY_SIZE);
+	hmac_sha256_update(&hmac_ctx, i, 4);
+	hmac_sha256_update(&hmac_ctx, label.iov_base, label.iov_len);
+	hmac_sha256_update(&hmac_ctx, &zero, 1);
+	hmac_sha256_update(&hmac_ctx, context.iov_base, context.iov_len);
 
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
 		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM)) {
-		rc = crypto_shash_update(server->secmech.hmacsha256, L256, 4);
+		hmac_sha256_update(&hmac_ctx, L256, 4);
 	} else {
-		rc = crypto_shash_update(server->secmech.hmacsha256, L128, 4);
-	}
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not update with L\n", __func__);
-		goto smb3signkey_ret;
+		hmac_sha256_update(&hmac_ctx, L128, 4);
 	}
+	hmac_sha256_final(&hmac_ctx, prfhash);
 
-	rc = crypto_shash_final(server->secmech.hmacsha256, hashptr);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not generate sha256 hash\n", __func__);
-		goto smb3signkey_ret;
-	}
-
-	memcpy(key, hashptr, key_size);
-
-smb3signkey_ret:
-	return rc;
+	memcpy(key, prfhash, key_size);
+	return 0;
 }
 
 struct derivation {
 	struct kvec label;
 	struct kvec context;
-- 
2.51.0

