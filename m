Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F18AC4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 03:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3493360698
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 03:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbhHSDVn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:21:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236654AbhHSDVe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 18 Aug 2021 23:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629343257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=saRScd3gYB25IfaOS7B0hUA+4tzyPd/oC/W1Tnd6TNY=;
        b=ame60q5t5XKl4C2mg58XJ1zM/otDAlpkmRvmWrLUBvN8egbC5idosN13kYqlb4XtUz7i+p
        vtptssgBMJsUsebeQBB2Ntk6xumKyPqHCSXmaifA8SW3Hk6UsV27eaMgDCHZi3ckUwndAy
        uDOE8CVzORZAT4pXWZtao9RdZjUCk8Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-C7ipQok5OrqEkPKB3OslJA-1; Wed, 18 Aug 2021 23:20:53 -0400
X-MC-Unique: C7ipQok5OrqEkPKB3OslJA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D463D190B2A1;
        Thu, 19 Aug 2021 03:20:52 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 971B45C1D1;
        Thu, 19 Aug 2021 03:20:51 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fork arc4 and add a private copy in fs/cifs
Date:   Thu, 19 Aug 2021 13:20:44 +1000
Message-Id: <20210819032044.1269514-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SMB supports two authentication modes, a modified krb5 mode which contains
ActiveDirectory extensions and accound information for the tickets and
NTLMSSP.

For NTLMSSP in SMB1/2/3 authentication uses a combination of all three of
md4/md5/arc4.

Fork/copy the ARC4 implementation from the crypto library into fs/cifs
so that we have a private version for NTLMSSP once ARC4 is removed from the
kernel crypto libraries.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/Kconfig       |  1 -
 fs/cifs/Makefile      |  2 +-
 fs/cifs/arc4.c        | 69 +++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/arc4.h        | 23 +++++++++++++++
 fs/cifs/cifsencrypt.c |  2 +-
 5 files changed, 94 insertions(+), 3 deletions(-)
 create mode 100644 fs/cifs/arc4.c
 create mode 100644 fs/cifs/arc4.h

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index c01464476ba9..76ccb72e5aa6 100644
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
diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 96739082718d..a8cb5bedc7dc 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_CIFS) += cifs.o
 
 cifs-y := trace.o cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o \
 	  inode.o link.o misc.o netmisc.o smbencrypt.o transport.o \
-	  cifs_unicode.o nterr.o cifsencrypt.o \
+	  arc4.o cifs_unicode.o nterr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o unc.o winucase.o \
 	  smb2ops.o smb2maperror.o smb2transport.o \
 	  smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o fs_context.o \
diff --git a/fs/cifs/arc4.c b/fs/cifs/arc4.c
new file mode 100644
index 000000000000..996bba153967
--- /dev/null
+++ b/fs/cifs/arc4.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Cryptographic API
+ *
+ * ARC4 Cipher Algorithm
+ *
+ * Jon Oberheide <jon@oberheide.org>
+ */
+
+#include "arc4.h"
+
+int arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len)
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
+
+void arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsigned int len)
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
diff --git a/fs/cifs/arc4.h b/fs/cifs/arc4.h
new file mode 100644
index 000000000000..f3c22fe01704
--- /dev/null
+++ b/fs/cifs/arc4.h
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
+int arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len);
+void arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
+
+#endif /* _CRYPTO_ARC4_H */
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 7680e0a9bea3..3b47093ceb74 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -22,7 +22,7 @@
 #include <linux/random.h>
 #include <linux/highmem.h>
 #include <linux/fips.h>
-#include <crypto/arc4.h>
+#include "arc4.h"
 #include <crypto/aead.h>
 
 int __cifs_calc_signature(struct smb_rqst *rqst,
-- 
2.30.2

