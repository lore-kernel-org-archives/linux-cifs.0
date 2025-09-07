Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ACE1A0728;
	Sun,  7 Sep 2025 03:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757215326; cv=none; b=dCkwbE0IRffRwbyhQNVl5WfT+knN+kkNoTKfRn8fMAVaDbi+0jgBbC9Nga6NMA5g9CjJY0Tndks5tbpS0gm9n7v+PgsPcIvUPbojQRdncr6FJYAu+q/9zFyLJprGIIJcyhgJNk5Idyx0GIRLsoTeusAcIf+pjdJF9/PoU5kcBqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757215326; c=relaxed/simple;
	bh=tInP6J7NJp//z767MSb09gQ5BOw84i+fFF4Se4q9AeE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U/7zzxYvhA8bFipXSpudPzglpax7FjJrVOvRaMegtkKge+qIIjpC4zzzV1a+MFclJZuEbdaXlarJddJHzH3C7PXofpXs/TU9AijTTUp167iyh4X/1MXt9sQoOz4pel8UQZSY507i4R4yup0L3DHC0bsHleVR5b+6d0yQnJ88+5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k9zYPG2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k9zYPG2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B008DC4CEF4;
	Sun,  7 Sep 2025 03:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757215326;
	bh=tInP6J7NJp//z767MSb09gQ5BOw84i+fFF4Se4q9AeE=;
	h=From:To:Cc:Subject:Date:From;
	b=k9zYPG2c5Xzn7cQ8M1dCgA9gSknrXT14mFB90EnnCKxRm0YFuhf6ucVAx9cBB6qwe
	 RpuYB1k6P//GmCHIKccZM+G1zR7CXxAih2q1VECvvnHgfs681oLLdOXPCY4rF8l31d
	 pSLX1s9VdoJT7xIKY5FXuv+Q6RtsowFsgR54EaclSdAC8Sw2vg7WThrzJwsuOBYDcd
	 2jRuuY0cJ+HeOCpt97Ao2ifZeu5yVSxxeC8KcJgeXUlKjE+XalfJBoOCY1rSOfD54K
	 HnPNKwa3QeXp+i3UjfY58fcxkbjCrJeQLpw9wUleybh+jarhgj3GfjqQIq9NdHsMcR
	 3zYPgG5ipvaew==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] smb: Use arc4 library instead of duplicate arc4 code
Date: Sat,  6 Sep 2025 20:20:03 -0700
Message-ID: <20250907032003.386794-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs/smb/common/cifs_arc4.c has an implementation of ARC4, but a copy of
this same code is also present in lib/crypto/arc4.c to serve the other
users of this legacy algorithm in the kernel.  Remove the duplicate
implementation in fs/smb/, which seems to have been added because of a
misunderstanding, and just use the lib/crypto/ one.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/Kconfig       |  1 +
 fs/smb/client/cifsencrypt.c |  8 ++--
 fs/smb/common/Makefile      |  1 -
 fs/smb/common/arc4.h        | 23 ------------
 fs/smb/common/cifs_arc4.c   | 75 -------------------------------------
 fs/smb/server/Kconfig       |  1 +
 fs/smb/server/auth.c        |  9 ++---
 7 files changed, 10 insertions(+), 108 deletions(-)
 delete mode 100644 fs/smb/common/arc4.h
 delete mode 100644 fs/smb/common/cifs_arc4.c

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 9f05f94e265a6..a4c02199fef48 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -13,10 +13,11 @@ config CIFS
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select CRYPTO_ECB
 	select CRYPTO_AES
+	select CRYPTO_LIB_ARC4
 	select KEYS
 	select DNS_RESOLVER
 	select ASN1
 	select OID_REGISTRY
 	select NETFS_SUPPORT
diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 3cc6862469087..7b7c8c38fdd08 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -20,12 +20,12 @@
 #include <linux/ctype.h>
 #include <linux/random.h>
 #include <linux/highmem.h>
 #include <linux/fips.h>
 #include <linux/iov_iter.h>
-#include "../common/arc4.h"
 #include <crypto/aead.h>
+#include <crypto/arc4.h>
 
 static size_t cifs_shash_step(void *iter_base, size_t progress, size_t len,
 			      void *priv, void *priv2)
 {
 	struct shash_desc *shash = priv;
@@ -723,13 +723,13 @@ calc_seckey(struct cifs_ses *ses)
 	if (!ctx_arc4) {
 		cifs_dbg(VFS, "Could not allocate arc4 context\n");
 		return -ENOMEM;
 	}
 
-	cifs_arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZE);
-	cifs_arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
-			CIFS_CPHTXT_SIZE);
+	arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZE);
+	arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
+		   CIFS_CPHTXT_SIZE);
 
 	/* make secondary_key/nonce as session key */
 	memcpy(ses->auth_key.response, sec_key, CIFS_SESS_KEY_SIZE);
 	/* and make len as that of session key only */
 	ses->auth_key.len = CIFS_SESS_KEY_SIZE;
diff --git a/fs/smb/common/Makefile b/fs/smb/common/Makefile
index c66dbbc1469c3..9e0730a385fb1 100644
--- a/fs/smb/common/Makefile
+++ b/fs/smb/common/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
 # Makefile for Linux filesystem routines that are shared by client and server.
 #
 
-obj-$(CONFIG_SMBFS) += cifs_arc4.o
 obj-$(CONFIG_SMBFS) += cifs_md4.o
diff --git a/fs/smb/common/arc4.h b/fs/smb/common/arc4.h
deleted file mode 100644
index 12e71ec033a18..0000000000000
--- a/fs/smb/common/arc4.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0+ */
-/*
- * Common values for ARC4 Cipher Algorithm
- */
-
-#ifndef _CRYPTO_ARC4_H
-#define _CRYPTO_ARC4_H
-
-#include <linux/types.h>
-
-#define ARC4_MIN_KEY_SIZE	1
-#define ARC4_MAX_KEY_SIZE	256
-#define ARC4_BLOCK_SIZE		1
-
-struct arc4_ctx {
-	u32 S[256];
-	u32 x, y;
-};
-
-int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len);
-void cifs_arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
-
-#endif /* _CRYPTO_ARC4_H */
diff --git a/fs/smb/common/cifs_arc4.c b/fs/smb/common/cifs_arc4.c
deleted file mode 100644
index df360ca47826a..0000000000000
--- a/fs/smb/common/cifs_arc4.c
+++ /dev/null
@@ -1,75 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Cryptographic API
- *
- * ARC4 Cipher Algorithm
- *
- * Jon Oberheide <jon@oberheide.org>
- */
-
-#include <linux/module.h>
-#include "arc4.h"
-
-MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
-MODULE_LICENSE("GPL");
-
-int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len)
-{
-	int i, j = 0, k = 0;
-
-	ctx->x = 1;
-	ctx->y = 0;
-
-	for (i = 0; i < 256; i++)
-		ctx->S[i] = i;
-
-	for (i = 0; i < 256; i++) {
-		u32 a = ctx->S[i];
-
-		j = (j + in_key[k] + a) & 0xff;
-		ctx->S[i] = ctx->S[j];
-		ctx->S[j] = a;
-		if (++k >= key_len)
-			k = 0;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(cifs_arc4_setkey);
-
-void cifs_arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsigned int len)
-{
-	u32 *const S = ctx->S;
-	u32 x, y, a, b;
-	u32 ty, ta, tb;
-
-	if (len == 0)
-		return;
-
-	x = ctx->x;
-	y = ctx->y;
-
-	a = S[x];
-	y = (y + a) & 0xff;
-	b = S[y];
-
-	do {
-		S[y] = a;
-		a = (a + b) & 0xff;
-		S[x] = b;
-		x = (x + 1) & 0xff;
-		ta = S[x];
-		ty = (y + ta) & 0xff;
-		tb = S[ty];
-		*out++ = *in++ ^ S[a];
-		if (--len == 0)
-			break;
-		y = ty;
-		a = ta;
-		b = tb;
-	} while (true);
-
-	ctx->x = x;
-	ctx->y = y;
-}
-EXPORT_SYMBOL_GPL(cifs_arc4_crypt);
diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 4a23a5e7e8fec..098cac98d31e6 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -8,10 +8,11 @@ config SMB_SERVER
 	select NLS_UCS2_UTILS
 	select CRYPTO
 	select CRYPTO_MD5
 	select CRYPTO_HMAC
 	select CRYPTO_ECB
+	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_SHA256
 	select CRYPTO_CMAC
 	select CRYPTO_SHA512
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index d99871c214518..b4020bb55a268 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -18,20 +18,20 @@
 
 #include "auth.h"
 #include "glob.h"
 
 #include <linux/fips.h>
+#include <crypto/arc4.h>
 #include <crypto/des.h>
 
 #include "server.h"
 #include "smb_common.h"
 #include "connection.h"
 #include "mgmt/user_session.h"
 #include "mgmt/user_config.h"
 #include "crypto_ctx.h"
 #include "transport_ipc.h"
-#include "../common/arc4.h"
 
 /*
  * Fixed format data defining GSS header and fixed string
  * "not_defined_in_RFC4178@please_ignore".
  * So sec blob data in neg phase could be generated statically.
@@ -363,14 +363,13 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 
 		ctx_arc4 = kmalloc(sizeof(*ctx_arc4), KSMBD_DEFAULT_GFP);
 		if (!ctx_arc4)
 			return -ENOMEM;
 
-		cifs_arc4_setkey(ctx_arc4, sess->sess_key,
-				 SMB2_NTLMV2_SESSKEY_SIZE);
-		cifs_arc4_crypt(ctx_arc4, sess->sess_key,
-				(char *)authblob + sess_key_off, sess_key_len);
+		arc4_setkey(ctx_arc4, sess->sess_key, SMB2_NTLMV2_SESSKEY_SIZE);
+		arc4_crypt(ctx_arc4, sess->sess_key,
+			   (char *)authblob + sess_key_off, sess_key_len);
 		kfree_sensitive(ctx_arc4);
 	}
 
 	return ret;
 }

base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.50.1

