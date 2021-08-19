Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B168C4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 10:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E519461152
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 10:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbhHSKfy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Aug 2021 06:35:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236149AbhHSKfx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 19 Aug 2021 06:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629369317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f9nT0dJsBmo7asxOIkn6X2C3gDeE70NaQpz6dAEy5is=;
        b=jJHAKxlqir1A6wrv37UyI05wVd3/qQxwAC7B1dr/EoJv1R9JOCAM162bh2Wfed6eU8Bdy1
        JXydQWzx5y5vDSfrajqfBHJV/LM7E0yceo08hlEsFLPFjLocLFXPJGwCBmZL5Fz7ORvrjl
        zLUgDuRJANLMG0J9/a9fHQRA1esNr04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-Q6u70LT5N86_toqbS-GkUw-1; Thu, 19 Aug 2021 06:35:14 -0400
X-MC-Unique: Q6u70LT5N86_toqbS-GkUw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47BAE801A92;
        Thu, 19 Aug 2021 10:35:13 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44F8910013D6;
        Thu, 19 Aug 2021 10:35:12 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 2/2] cifs: fork arc4 and create a separate module for it for cifs and other users
Date:   Thu, 19 Aug 2021 20:34:59 +1000
Message-Id: <20210819103459.1291412-3-lsahlber@redhat.com>
In-Reply-To: <20210819103459.1291412-1-lsahlber@redhat.com>
References: <20210819103459.1291412-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can not drop ARC4 and basically destroy CIFS connectivity for
almost all CIFS users so create a new forked ARC4 molule that CIFS and other
subsystems that have a hard dependency on ARC4 can use.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/Kconfig                 |  7 +++
 fs/Makefile                |  1 +
 fs/cifs/Kconfig            |  1 -
 fs/cifs/cifsencrypt.c      |  8 ++--
 fs/cifs_common/Makefile    |  6 +++
 fs/cifs_common/arc4.h      | 23 ++++++++++
 fs/cifs_common/cifs_arc4.c | 87 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 128 insertions(+), 5 deletions(-)
 create mode 100644 fs/cifs_common/Makefile
 create mode 100644 fs/cifs_common/arc4.h
 create mode 100644 fs/cifs_common/cifs_arc4.c

diff --git a/fs/Kconfig b/fs/Kconfig
index a7749c126b8e..6d719f2c5828 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -358,7 +358,14 @@ config NFS_V4_2_SSC_HELPER
 
 source "net/sunrpc/Kconfig"
 source "fs/ceph/Kconfig"
+
 source "fs/cifs/Kconfig"
+
+config CIFS_COMMON
+	tristate
+	default y if CIFS=y
+	default m if CIFS=m
+
 source "fs/coda/Kconfig"
 source "fs/afs/Kconfig"
 source "fs/9p/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index f98f3e691c37..77b0e79c8b4f 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_LOCKD)		+= lockd/
 obj-$(CONFIG_NLS)		+= nls/
 obj-$(CONFIG_UNICODE)		+= unicode/
 obj-$(CONFIG_SYSV_FS)		+= sysv/
+obj-$(CONFIG_CIFS_COMMON)	+= cifs_common/
 obj-$(CONFIG_CIFS)		+= cifs/
 obj-$(CONFIG_HPFS_FS)		+= hpfs/
 obj-$(CONFIG_NTFS_FS)		+= ntfs/
diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 2e8b132efdbc..aa4457d72392 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -10,7 +10,6 @@ config CIFS
 	select CRYPTO_SHA512
 	select CRYPTO_CMAC
 	select CRYPTO_HMAC
-	select CRYPTO_LIB_ARC4
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 7680e0a9bea3..6679e07e533e 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -22,7 +22,7 @@
 #include <linux/random.h>
 #include <linux/highmem.h>
 #include <linux/fips.h>
-#include <crypto/arc4.h>
+#include "../cifs_common/arc4.h"
 #include <crypto/aead.h>
 
 int __cifs_calc_signature(struct smb_rqst *rqst,
@@ -699,9 +699,9 @@ calc_seckey(struct cifs_ses *ses)
 		return -ENOMEM;
 	}
 
-	arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZE);
-	arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
-		   CIFS_CPHTXT_SIZE);
+	cifs_arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZE);
+	cifs_arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
+			CIFS_CPHTXT_SIZE);
 
 	/* make secondary_key/nonce as session key */
 	memcpy(ses->auth_key.response, sec_key, CIFS_SESS_KEY_SIZE);
diff --git a/fs/cifs_common/Makefile b/fs/cifs_common/Makefile
new file mode 100644
index 000000000000..2fc9b40345c4
--- /dev/null
+++ b/fs/cifs_common/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for Linux filesystem routines that are shared by client and server.
+#
+
+obj-$(CONFIG_CIFS_COMMON) += cifs_arc4.o
diff --git a/fs/cifs_common/arc4.h b/fs/cifs_common/arc4.h
new file mode 100644
index 000000000000..12e71ec033a1
--- /dev/null
+++ b/fs/cifs_common/arc4.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Common values for ARC4 Cipher Algorithm
+ */
+
+#ifndef _CRYPTO_ARC4_H
+#define _CRYPTO_ARC4_H
+
+#include <linux/types.h>
+
+#define ARC4_MIN_KEY_SIZE	1
+#define ARC4_MAX_KEY_SIZE	256
+#define ARC4_BLOCK_SIZE		1
+
+struct arc4_ctx {
+	u32 S[256];
+	u32 x, y;
+};
+
+int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len);
+void cifs_arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
+
+#endif /* _CRYPTO_ARC4_H */
diff --git a/fs/cifs_common/cifs_arc4.c b/fs/cifs_common/cifs_arc4.c
new file mode 100644
index 000000000000..b964cc682944
--- /dev/null
+++ b/fs/cifs_common/cifs_arc4.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Cryptographic API
+ *
+ * ARC4 Cipher Algorithm
+ *
+ * Jon Oberheide <jon@oberheide.org>
+ */
+
+#include <linux/module.h>
+#include "arc4.h"
+
+MODULE_LICENSE("GPL");
+
+int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len)
+{
+	int i, j = 0, k = 0;
+
+	ctx->x = 1;
+	ctx->y = 0;
+
+	for (i = 0; i < 256; i++)
+		ctx->S[i] = i;
+
+	for (i = 0; i < 256; i++) {
+		u32 a = ctx->S[i];
+
+		j = (j + in_key[k] + a) & 0xff;
+		ctx->S[i] = ctx->S[j];
+		ctx->S[j] = a;
+		if (++k >= key_len)
+			k = 0;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cifs_arc4_setkey);
+
+void cifs_arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsigned int len)
+{
+	u32 *const S = ctx->S;
+	u32 x, y, a, b;
+	u32 ty, ta, tb;
+
+	if (len == 0)
+		return;
+
+	x = ctx->x;
+	y = ctx->y;
+
+	a = S[x];
+	y = (y + a) & 0xff;
+	b = S[y];
+
+	do {
+		S[y] = a;
+		a = (a + b) & 0xff;
+		S[x] = b;
+		x = (x + 1) & 0xff;
+		ta = S[x];
+		ty = (y + ta) & 0xff;
+		tb = S[ty];
+		*out++ = *in++ ^ S[a];
+		if (--len == 0)
+			break;
+		y = ty;
+		a = ta;
+		b = tb;
+	} while (true);
+
+	ctx->x = x;
+	ctx->y = y;
+}
+EXPORT_SYMBOL_GPL(cifs_arc4_crypt);
+
+static int __init
+init_cifs_common(void)
+{
+	return 0;
+}
+static void __init
+exit_cifs_common(void)
+{
+}
+
+module_init(init_cifs_common)
+module_exit(exit_cifs_common)
-- 
2.30.2

