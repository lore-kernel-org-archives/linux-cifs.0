Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97152C4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 23:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7384E610CF
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 23:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhHSXdo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Aug 2021 19:33:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37994 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229808AbhHSXdo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 19 Aug 2021 19:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629415986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uJ3v098MWmwYqdUXM0UWORe/Fcu5YN8slhKKhJP5K8w=;
        b=SU+baFGNioxhvvIEdeIew9RQLaMvD8cNlyUZcQgkOl1peAhMqxnuFf07Z3ZDdAxt+B6+uG
        rWp0Iv847sj4W/pUDBVWO79tY5U8lBDcy7YCi/LBUtD0DBNa2XezvvvtGJLieV1u1GNkzY
        nzIWsHn6CRBVVo+90nyWvN4sGt89N4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-GFmPKo3kPge12U5IDpUppg-1; Thu, 19 Aug 2021 19:33:05 -0400
X-MC-Unique: GFmPKo3kPge12U5IDpUppg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9977C107AD64;
        Thu, 19 Aug 2021 23:33:04 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58EFF1970F;
        Thu, 19 Aug 2021 23:33:02 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: create a MD4 module and switch cifs.ko to use it
Date:   Fri, 20 Aug 2021 09:32:56 +1000
Message-Id: <20210819233256.1320659-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/Kconfig           |   1 -
 fs/cifs/cifsfs.c          |   1 -
 fs/cifs/smbencrypt.c      |  24 ++---
 fs/cifs_common/Makefile   |   1 +
 fs/cifs_common/cifs_md4.c | 201 ++++++++++++++++++++++++++++++++++++++
 fs/cifs_common/md4.h      |  27 +++++
 6 files changed, 239 insertions(+), 16 deletions(-)
 create mode 100644 fs/cifs_common/cifs_md4.c
 create mode 100644 fs/cifs_common/md4.h

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index aa4457d72392..3b7e3b9e4fd2 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -4,7 +4,6 @@ config CIFS
 	depends on INET
 	select NLS
 	select CRYPTO
-	select CRYPTO_MD4
 	select CRYPTO_MD5
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 85c884db909d..c5ba42d75bc2 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1749,7 +1749,6 @@ MODULE_DESCRIPTION
 MODULE_VERSION(CIFS_VERSION);
 MODULE_SOFTDEP("ecb");
 MODULE_SOFTDEP("hmac");
-MODULE_SOFTDEP("md4");
 MODULE_SOFTDEP("md5");
 MODULE_SOFTDEP("nls");
 MODULE_SOFTDEP("aes");
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 5da7eea3323f..c4b0bf239073 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -24,6 +24,7 @@
 #include "cifsglob.h"
 #include "cifs_debug.h"
 #include "cifsproto.h"
+#include "../cifs_common/md4.h"
 
 #ifndef false
 #define false 0
@@ -42,29 +43,24 @@ static int
 mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
 {
 	int rc;
-	struct crypto_shash *md4 = NULL;
-	struct sdesc *sdescmd4 = NULL;
+	struct md4_ctx mctx;
 
-	rc = cifs_alloc_hash("md4", &md4, &sdescmd4);
-	if (rc)
-		goto mdfour_err;
-
-	rc = crypto_shash_init(&sdescmd4->shash);
+	rc = cifs_md4_init(&mctx);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init md4 shash\n", __func__);
+		cifs_dbg(VFS, "%s: Could not init MD4\n", __func__);
 		goto mdfour_err;
 	}
-	rc = crypto_shash_update(&sdescmd4->shash, link_str, link_len);
+	rc = cifs_md4_update(&mctx, link_str, link_len);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update with link_str\n", __func__);
+		cifs_dbg(VFS, "%s: Could not update MD4\n", __func__);
 		goto mdfour_err;
 	}
-	rc = crypto_shash_final(&sdescmd4->shash, md4_hash);
-	if (rc)
-		cifs_dbg(VFS, "%s: Could not generate md4 hash\n", __func__);
+	rc = cifs_md4_final(&mctx, md4_hash);
+	if (rc) {
+		cifs_dbg(VFS, "%s: Could not finalize MD4\n", __func__);
+	}
 
 mdfour_err:
-	cifs_free_hash(&md4, &sdescmd4);
 	return rc;
 }
 
diff --git a/fs/cifs_common/Makefile b/fs/cifs_common/Makefile
index 2fc9b40345c4..6fedd2f88a25 100644
--- a/fs/cifs_common/Makefile
+++ b/fs/cifs_common/Makefile
@@ -4,3 +4,4 @@
 #
 
 obj-$(CONFIG_CIFS_COMMON) += cifs_arc4.o
+obj-$(CONFIG_CIFS_COMMON) += cifs_md4.o
diff --git a/fs/cifs_common/cifs_md4.c b/fs/cifs_common/cifs_md4.c
new file mode 100644
index 000000000000..b975026759da
--- /dev/null
+++ b/fs/cifs_common/cifs_md4.c
@@ -0,0 +1,201 @@
+/* 
+ * Cryptographic API.
+ *
+ * MD4 Message Digest Algorithm (RFC1320).
+ *
+ * Implementation derived from Andrew Tridgell and Steve French's
+ * CIFS MD4 implementation, and the cryptoapi implementation
+ * originally based on the public domain implementation written
+ * by Colin Plumb in 1993.
+ *
+ * Copyright (c) Andrew Tridgell 1997-1998.
+ * Modified by Steve French (sfrench@us.ibm.com) 2002
+ * Copyright (c) Cryptoapi developers.
+ * Copyright (c) 2002 David S. Miller (davem@redhat.com)
+ * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include "md4.h"
+
+MODULE_LICENSE("GPL");
+
+static inline u32 lshift(u32 x, unsigned int s)
+{
+	x &= 0xFFFFFFFF;
+	return ((x << s) & 0xFFFFFFFF) | (x >> (32 - s));
+}
+
+static inline u32 F(u32 x, u32 y, u32 z)
+{
+	return (x & y) | ((~x) & z);
+}
+
+static inline u32 G(u32 x, u32 y, u32 z)
+{
+	return (x & y) | (x & z) | (y & z);
+}
+
+static inline u32 H(u32 x, u32 y, u32 z)
+{
+	return x ^ y ^ z;
+}
+
+#define ROUND1(a,b,c,d,k,s) (a = lshift(a + F(b,c,d) + k, s))
+#define ROUND2(a,b,c,d,k,s) (a = lshift(a + G(b,c,d) + k + (u32)0x5A827999,s))
+#define ROUND3(a,b,c,d,k,s) (a = lshift(a + H(b,c,d) + k + (u32)0x6ED9EBA1,s))
+
+static void md4_transform(u32 *hash, u32 const *in)
+{
+	u32 a, b, c, d;
+
+	a = hash[0];
+	b = hash[1];
+	c = hash[2];
+	d = hash[3];
+
+	ROUND1(a, b, c, d, in[0], 3);
+	ROUND1(d, a, b, c, in[1], 7);
+	ROUND1(c, d, a, b, in[2], 11);
+	ROUND1(b, c, d, a, in[3], 19);
+	ROUND1(a, b, c, d, in[4], 3);
+	ROUND1(d, a, b, c, in[5], 7);
+	ROUND1(c, d, a, b, in[6], 11);
+	ROUND1(b, c, d, a, in[7], 19);
+	ROUND1(a, b, c, d, in[8], 3);
+	ROUND1(d, a, b, c, in[9], 7);
+	ROUND1(c, d, a, b, in[10], 11);
+	ROUND1(b, c, d, a, in[11], 19);
+	ROUND1(a, b, c, d, in[12], 3);
+	ROUND1(d, a, b, c, in[13], 7);
+	ROUND1(c, d, a, b, in[14], 11);
+	ROUND1(b, c, d, a, in[15], 19);
+
+	ROUND2(a, b, c, d,in[ 0], 3);
+	ROUND2(d, a, b, c, in[4], 5);
+	ROUND2(c, d, a, b, in[8], 9);
+	ROUND2(b, c, d, a, in[12], 13);
+	ROUND2(a, b, c, d, in[1], 3);
+	ROUND2(d, a, b, c, in[5], 5);
+	ROUND2(c, d, a, b, in[9], 9);
+	ROUND2(b, c, d, a, in[13], 13);
+	ROUND2(a, b, c, d, in[2], 3);
+	ROUND2(d, a, b, c, in[6], 5);
+	ROUND2(c, d, a, b, in[10], 9);
+	ROUND2(b, c, d, a, in[14], 13);
+	ROUND2(a, b, c, d, in[3], 3);
+	ROUND2(d, a, b, c, in[7], 5);
+	ROUND2(c, d, a, b, in[11], 9);
+	ROUND2(b, c, d, a, in[15], 13);
+
+	ROUND3(a, b, c, d,in[ 0], 3);
+	ROUND3(d, a, b, c, in[8], 9);
+	ROUND3(c, d, a, b, in[4], 11);
+	ROUND3(b, c, d, a, in[12], 15);
+	ROUND3(a, b, c, d, in[2], 3);
+	ROUND3(d, a, b, c, in[10], 9);
+	ROUND3(c, d, a, b, in[6], 11);
+	ROUND3(b, c, d, a, in[14], 15);
+	ROUND3(a, b, c, d, in[1], 3);
+	ROUND3(d, a, b, c, in[9], 9);
+	ROUND3(c, d, a, b, in[5], 11);
+	ROUND3(b, c, d, a, in[13], 15);
+	ROUND3(a, b, c, d, in[3], 3);
+	ROUND3(d, a, b, c, in[11], 9);
+	ROUND3(c, d, a, b, in[7], 11);
+	ROUND3(b, c, d, a, in[15], 15);
+
+	hash[0] += a;
+	hash[1] += b;
+	hash[2] += c;
+	hash[3] += d;
+}
+
+static inline void md4_transform_helper(struct md4_ctx *ctx)
+{
+	le32_to_cpu_array(ctx->block, ARRAY_SIZE(ctx->block));
+	md4_transform(ctx->hash, ctx->block);
+}
+
+int cifs_md4_init(struct md4_ctx *mctx)
+{
+	memset(mctx, 0, sizeof(struct md4_ctx));
+	mctx->hash[0] = 0x67452301;
+	mctx->hash[1] = 0xefcdab89;
+	mctx->hash[2] = 0x98badcfe;
+	mctx->hash[3] = 0x10325476;
+	mctx->byte_count = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cifs_md4_init);
+
+int cifs_md4_update(struct md4_ctx *mctx, const u8 *data, unsigned int len)
+{
+	const u32 avail = sizeof(mctx->block) - (mctx->byte_count & 0x3f);
+
+	mctx->byte_count += len;
+
+	if (avail > len) {
+		memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
+		       data, len);
+		return 0;
+	}
+
+	memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
+	       data, avail);
+
+	md4_transform_helper(mctx);
+	data += avail;
+	len -= avail;
+
+	while (len >= sizeof(mctx->block)) {
+		memcpy(mctx->block, data, sizeof(mctx->block));
+		md4_transform_helper(mctx);
+		data += sizeof(mctx->block);
+		len -= sizeof(mctx->block);
+	}
+
+	memcpy(mctx->block, data, len);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cifs_md4_update);
+
+int cifs_md4_final(struct md4_ctx *mctx, u8 *out)
+{
+	const unsigned int offset = mctx->byte_count & 0x3f;
+	char *p = (char *)mctx->block + offset;
+	int padding = 56 - (offset + 1);
+
+	*p++ = 0x80;
+	if (padding < 0) {
+		memset(p, 0x00, padding + sizeof (u64));
+		md4_transform_helper(mctx);
+		p = (char *)mctx->block;
+		padding = 56;
+	}
+
+	memset(p, 0, padding);
+	mctx->block[14] = mctx->byte_count << 3;
+	mctx->block[15] = mctx->byte_count >> 29;
+	le32_to_cpu_array(mctx->block, (sizeof(mctx->block) -
+	                  sizeof(u64)) / sizeof(u32));
+	md4_transform(mctx->hash, mctx->block);
+	cpu_to_le32_array(mctx->hash, ARRAY_SIZE(mctx->hash));
+	memcpy(out, mctx->hash, sizeof(mctx->hash));
+	memset(mctx, 0, sizeof(*mctx));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cifs_md4_final);
diff --git a/fs/cifs_common/md4.h b/fs/cifs_common/md4.h
new file mode 100644
index 000000000000..5337becc699a
--- /dev/null
+++ b/fs/cifs_common/md4.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Common values for ARC4 Cipher Algorithm
+ */
+
+#ifndef _CIFS_MD4_H
+#define _CIFS_MD4_H
+
+#include <linux/types.h>
+
+#define MD4_DIGEST_SIZE		16
+#define MD4_HMAC_BLOCK_SIZE	64
+#define MD4_BLOCK_WORDS		16
+#define MD4_HASH_WORDS		4
+
+struct md4_ctx {
+	u32 hash[MD4_HASH_WORDS];
+	u32 block[MD4_BLOCK_WORDS];
+	u64 byte_count;
+};
+
+
+int cifs_md4_init(struct md4_ctx *mctx);
+int cifs_md4_update(struct md4_ctx *mctx, const u8 *data, unsigned int len);
+int cifs_md4_final(struct md4_ctx *mctx, u8 *out);
+
+#endif /* _CIFS_MD4_H */
-- 
2.30.2

