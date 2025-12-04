Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB271DF25F
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 05:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764824406; cv=none; b=tae7ysfpGl3eTufTJcroWxmp00V33XKImwSbpB5MULMPdmaoDwEET6UrS7eTXCK4u6BPa/4zDvSdlC8+iyYNRacp0jvlki/oxwc20dB9bPGhEvVDHuC9N0UScKD8HZ/d4/06Pas2YxSHpukJtGgN4YjSqtVa2vgYmYqGoznJqgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764824406; c=relaxed/simple;
	bh=FntEXDEilc4dKtFA300LaBptfch7n2a6/jxLKrcwXjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wr/NzoxWXtotqpcb5tATunMhGf0naMKNanMHAmj2EvwqxorAyF7J9T5PuowIRkYU7akZpgHdyWuDO0hGhK0gCimNE5YSu4UeC3pvIJBQbaXwXIYdSZeonsFyVUYpD+kAPMshLJnLacmVVKhQaPu/LcxYtVG6AMCexD+q8HGLFkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LYVRtQP1; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LYVRtQP1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764824402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LtxePjWpMJc4YcyMV/WO2g/5lhEnkqKOVHXZHFiGmM0=;
	b=LYVRtQP1FbhwjBgO0Y3aOh/DPbq/okZoK+pcwYWnA1wapWrG7bjka+rzr2YlS+nPWEV2Hi
	BkfZcOdWJFibCImOKdiTbpAeXfvUUcY+hGa3vKAzai0yJO1gNGmUVrKmqX/hoOqAQYYcdj
	xQmjzC20z91K4TYvVrfwzuk+Ins5WFU=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 09/10] smb: create common/common.h and common/common.c
Date: Thu,  4 Dec 2025 12:58:17 +0800
Message-ID: <20251204045818.2590727-10-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Preparation for moving client/smb2maperror.c to common/.

We can put cifs_md4 and smb2maperror into a single smb_common.ko,
instead of creating two separate .ko (cifs_md4.ko and smb2maperror.ko).

  - rename md4.h -> common.h, and update include guard
  - create common.c, and move module info from cifs_md4.c into common.c

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smbencrypt.c        |  2 +-
 fs/smb/common/Makefile            |  3 ++-
 fs/smb/common/cifs_md4.c          |  5 +----
 fs/smb/common/common.c            | 28 ++++++++++++++++++++++++++++
 fs/smb/common/{md4.h => common.h} | 14 +++++++-------
 5 files changed, 39 insertions(+), 13 deletions(-)
 create mode 100644 fs/smb/common/common.c
 rename fs/smb/common/{md4.h => common.h} (86%)

diff --git a/fs/smb/client/smbencrypt.c b/fs/smb/client/smbencrypt.c
index 1d1ee9f18f37..abbedcdf7613 100644
--- a/fs/smb/client/smbencrypt.c
+++ b/fs/smb/client/smbencrypt.c
@@ -24,7 +24,7 @@
 #include "cifsglob.h"
 #include "cifs_debug.h"
 #include "cifsproto.h"
-#include "../common/md4.h"
+#include "../common/common.h"
 
 /* following came from the other byteorder.h to avoid include conflicts */
 #define CVAL(buf,pos) (((unsigned char *)(buf))[pos])
diff --git a/fs/smb/common/Makefile b/fs/smb/common/Makefile
index 9e0730a385fb..4f1dc5123e99 100644
--- a/fs/smb/common/Makefile
+++ b/fs/smb/common/Makefile
@@ -3,4 +3,5 @@
 # Makefile for Linux filesystem routines that are shared by client and server.
 #
 
-obj-$(CONFIG_SMBFS) += cifs_md4.o
+obj-$(CONFIG_SMBFS) += smb_common.o
+smb_common-objs := common.o cifs_md4.o
diff --git a/fs/smb/common/cifs_md4.c b/fs/smb/common/cifs_md4.c
index 7ee7f4dad90c..c619c0daf217 100644
--- a/fs/smb/common/cifs_md4.c
+++ b/fs/smb/common/cifs_md4.c
@@ -22,10 +22,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
-#include "md4.h"
-
-MODULE_DESCRIPTION("MD4 Message Digest Algorithm (RFC1320)");
-MODULE_LICENSE("GPL");
+#include "common.h"
 
 static inline u32 lshift(u32 x, unsigned int s)
 {
diff --git a/fs/smb/common/common.c b/fs/smb/common/common.c
new file mode 100644
index 000000000000..4142e05039c0
--- /dev/null
+++ b/fs/smb/common/common.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) International Business Machines  Corp., 2009
+ *                 2018 Samsung Electronics Co., Ltd.
+ *   Author(s): Steve French <sfrench@us.ibm.com>
+ *              Namjae Jeon <linkinjeon@kernel.org>
+ */
+
+#include <linux/module.h>
+#include "common.h"
+
+static int __init smb_common_init(void)
+{
+	int rc = 0;
+
+	return rc;
+}
+
+static void __exit smb_common_exit(void)
+{
+}
+
+MODULE_AUTHOR("Steve French <stfrench@microsoft.com>");
+MODULE_AUTHOR("Namjae Jeon <linkinjeon@kernel.org>");
+MODULE_DESCRIPTION("Linux kernel SMB common");
+MODULE_LICENSE("GPL");
+module_init(smb_common_init)
+module_exit(smb_common_exit)
diff --git a/fs/smb/common/md4.h b/fs/smb/common/common.h
similarity index 86%
rename from fs/smb/common/md4.h
rename to fs/smb/common/common.h
index 5337becc699a..07ee24ecccb8 100644
--- a/fs/smb/common/md4.h
+++ b/fs/smb/common/common.h
@@ -1,13 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
-/*
- * Common values for ARC4 Cipher Algorithm
- */
 
-#ifndef _CIFS_MD4_H
-#define _CIFS_MD4_H
+#ifndef __SMB_COMMON_H__
+#define __SMB_COMMON_H__
 
 #include <linux/types.h>
 
+/*
+ * Common values for ARC4 Cipher Algorithm
+ */
+
 #define MD4_DIGEST_SIZE		16
 #define MD4_HMAC_BLOCK_SIZE	64
 #define MD4_BLOCK_WORDS		16
@@ -19,9 +20,8 @@ struct md4_ctx {
 	u64 byte_count;
 };
 
-
 int cifs_md4_init(struct md4_ctx *mctx);
 int cifs_md4_update(struct md4_ctx *mctx, const u8 *data, unsigned int len);
 int cifs_md4_final(struct md4_ctx *mctx, u8 *out);
 
-#endif /* _CIFS_MD4_H */
+#endif /* __SMB_COMMON_H__ */
-- 
2.43.0

