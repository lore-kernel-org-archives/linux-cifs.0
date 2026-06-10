Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29FD27FD4B
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 15:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781104574; cv=none; b=H4e5XZcGgIKsKNTw7Ir02ov51Qen3wS4OBEzd66DVz0WHhCUQxhrStc7VlF7E/apeRToZ2qpsxefEHW0YtPhsGGnViMUzo2owCWF4tCBqyCv4dTNYJwfx0hg7px197ob/PWhoZ+QmYFYsAL23+Nf7fJGPfeHa7U4ICbfZmPvC7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781104574; c=relaxed/simple;
	bh=D/oQg29d3yIXC22p5cDqG/9A3LxaRH4xCaQ1D7VV6lE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ruPNvEeytPLujLJuvZHyD0AAooOUgDdrX/Ip/JbvM72osSdJFbt0LTVJ2390bt63N0VOf13HZnFpIqVC/pw6hksd8lKfkTbfbsZpjVDBmwaivj+azytm/GImEm5U1Mv/VOaOowIezuhQ+sOxaZ0HINP5PzH3mch3m1TEDKPfpkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aKF7xbNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKF7xbNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDD81F00898;
	Wed, 10 Jun 2026 15:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781104572;
	bh=zAO75vQlaxZP8EEyJorRIzxUGJwMR2zLzMHXz63bkFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKF7xbNIvQiweHdXCtnNjQyOupNBxy4eG7gRI0/2OdOJti+uR8BaVbM6g5nN2z156
	 ZBk0lkvh9BW2LewKyOxfeU4SBpj2x/BbIOR4QAbcQeRgol+y09A836T7z/LbMm9Hma
	 Pl3E9Glg5q5LgI7u1r0LfkcRD0eyeXrPVNOoEpPdXvuX4hFXstoHvC6qGCW531GehB
	 uQgHJxy9SujVtbxDtUbhLFLahlIVmCbKbcNtcAAPlBnJIraTyyN/mmWRja2r3+Lcwb
	 KE3HY5f7motLk8ZAf5U/4gQOD2LaqFF/lix6mO9Kx6z7XQXfX/UyMhvvP4UV6PwIZS
	 ayW0h2E1HdN5A==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/5] smb: move LZ77 compression into common code
Date: Thu, 11 Jun 2026 00:15:39 +0900
Message-Id: <20260610151543.25218-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260610151543.25218-1-linkinjeon@kernel.org>
References: <20260610151543.25218-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the LZ77 codec in cifs.ko to smb/common/ so both the SMB
client and ksmbd can use it.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/Makefile                    |   2 +-
 fs/smb/client/compress.c                  |  12 +-
 fs/smb/client/compress.h                  |  28 +----
 fs/smb/common/Makefile                    |   3 +
 fs/smb/common/compress/compress.h         |  22 ++++
 fs/smb/{client => common}/compress/lz77.c | 136 +++++++++++++++++++++-
 fs/smb/{client => common}/compress/lz77.h |  17 +--
 7 files changed, 176 insertions(+), 44 deletions(-)
 create mode 100644 fs/smb/common/compress/compress.h
 rename fs/smb/{client => common}/compress/lz77.c (75%)
 rename fs/smb/{client => common}/compress/lz77.h (65%)

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 6e83b5204699..fc6b9d35c962 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -42,7 +42,7 @@ cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += \
 	smb1session.o \
 	smb1transport.o
 
-cifs-$(CONFIG_CIFS_COMPRESSION) += compress.o compress/lz77.o
+cifs-$(CONFIG_CIFS_COMPRESSION) += compress.o
 
 ifneq ($(CONFIG_CIFS_ALLOW_INSECURE_LEGACY),)
 #
diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index be9023f841e6..8f0860970741 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -22,7 +22,7 @@
 #include "cifsproto.h"
 #include "smb2proto.h"
 
-#include "compress/lz77.h"
+#include "../common/compress/lz77.h"
 #include "compress.h"
 
 /*
@@ -44,6 +44,11 @@ struct bucket {
 	unsigned int count;
 };
 
+static inline size_t pow4(size_t n)
+{
+	return n * n * n * n;
+}
+
 /*
  * has_low_entropy() - Compute Shannon entropy of the sampled data.
  * @bkt:	Bytes counts of the sample.
@@ -65,7 +70,6 @@ static bool has_low_entropy(struct bucket *bkt, size_t slen)
 	const size_t threshold = 65, max_entropy = 8 * ilog2(16);
 	size_t i, p, p2, len, sum = 0;
 
-#define pow4(n) (n * n * n * n)
 	len = ilog2(pow4(slen));
 
 	for (i = 0; i < 256 && bkt[i].count > 0; i++) {
@@ -329,14 +333,14 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 		goto err_free;
 	}
 
-	dlen = lz77_compressed_alloc_size(slen);
+	dlen = smb_lz77_compressed_alloc_size(slen);
 	dst = kvzalloc(dlen, GFP_KERNEL);
 	if (!dst) {
 		ret = -ENOMEM;
 		goto err_free;
 	}
 
-	ret = lz77_compress(src, slen, dst, &dlen);
+	ret = smb_lz77_compress(src, slen, dst, &dlen);
 	if (!ret) {
 		struct smb2_compression_hdr hdr = { 0 };
 		struct smb_rqst comp_rq = { .rq_nvec = 3, };
diff --git a/fs/smb/client/compress.h b/fs/smb/client/compress.h
index 2679baca129b..e08e6d339d21 100644
--- a/fs/smb/client/compress.h
+++ b/fs/smb/client/compress.h
@@ -18,6 +18,7 @@
 #include <linux/uio.h>
 #include <linux/kernel.h>
 #include "../common/smb2pdu.h"
+#include "../common/compress/compress.h"
 #include "cifsglob.h"
 
 /* sizeof(smb2_compression_hdr) - sizeof(OriginalPayloadSize) */
@@ -34,29 +35,6 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq,
 		 compress_send_fn send_fn);
 bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq);
 
-/*
- * smb_compress_alg_valid() - Validate a compression algorithm.
- * @alg: Compression algorithm to check.
- * @valid_none: Conditional check whether NONE algorithm should be
- *		considered valid or not.
- *
- * If @alg is SMB3_COMPRESS_NONE, this function returns @valid_none.
- *
- * Note that 'NONE' (0) compressor type is considered invalid in protocol
- * negotiation, as it's never requested to/returned from the server.
- *
- * Return: true if @alg is valid/supported, false otherwise.
- */
-static __always_inline int smb_compress_alg_valid(__le16 alg, bool valid_none)
-{
-	if (alg == SMB3_COMPRESS_NONE)
-		return valid_none;
-
-	if (alg == SMB3_COMPRESS_LZ77 || alg == SMB3_COMPRESS_PATTERN)
-		return true;
-
-	return false;
-}
 #else /* !CONFIG_CIFS_COMPRESSION */
 static inline int smb_compress(void *unused1, void *unused2, void *unused3)
 {
@@ -68,9 +46,5 @@ static inline bool should_compress(void *unused1, void *unused2)
 	return false;
 }
 
-static inline int smb_compress_alg_valid(__le16 unused1, bool unused2)
-{
-	return -EOPNOTSUPP;
-}
 #endif /* !CONFIG_CIFS_COMPRESSION */
 #endif /* _SMB_COMPRESS_H */
diff --git a/fs/smb/common/Makefile b/fs/smb/common/Makefile
index 9e0730a385fb..bd188d36fb6b 100644
--- a/fs/smb/common/Makefile
+++ b/fs/smb/common/Makefile
@@ -4,3 +4,6 @@
 #
 
 obj-$(CONFIG_SMBFS) += cifs_md4.o
+obj-$(CONFIG_SMBFS) += smb_compress.o
+
+smb_compress-y := compress/lz77.o
diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
new file mode 100644
index 000000000000..b504cd38b128
--- /dev/null
+++ b/fs/smb/common/compress/compress.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026 Namjae Jeon <linkinjeon@kernel.org>
+ */
+#ifndef _COMMON_SMB_COMPRESS_H
+#define _COMMON_SMB_COMPRESS_H
+
+#include "../smb2pdu.h"
+
+/*
+ * SMB3_COMPRESS_NONE is valid only in chained payload headers. It is never
+ * negotiated as a compression algorithm.
+ */
+static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
+{
+	if (alg == SMB3_COMPRESS_NONE)
+		return valid_none;
+
+	return alg == SMB3_COMPRESS_LZ77 || alg == SMB3_COMPRESS_PATTERN;
+}
+
+#endif /* _COMMON_SMB_COMPRESS_H */
diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/common/compress/lz77.c
similarity index 75%
rename from fs/smb/client/compress/lz77.c
rename to fs/smb/common/compress/lz77.c
index 7365d0f97396..9216d973d876 100644
--- a/fs/smb/client/compress/lz77.c
+++ b/fs/smb/common/compress/lz77.c
@@ -1,8 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2024-2026, SUSE LLC
+ * Copyright (C) 2026 Namjae Jeon <linkinjeon@kernel.org>
  *
  * Authors: Enzo Matsumiya <ematsumiya@suse.de>
+ *          Namjae Jeon <linkinjeon@kernel.org>
  *
  * Implementation of the LZ77 "plain" compression algorithm, as per MS-XCA spec.
  */
@@ -10,6 +12,8 @@
 #include <linux/sizes.h>
 #include <linux/count_zeros.h>
 #include <linux/unaligned.h>
+#include <linux/module.h>
+#include <linux/overflow.h>
 
 #include "lz77.h"
 
@@ -32,7 +36,7 @@
  */
 #define LZ77_MATCH_MAX_DIST	SZ_8K
 #define LZ77_HASH_LOG		15
-#define LZ77_HASH_SIZE		(1 << LZ77_HASH_LOG)
+#define LZ77_HASH_SIZE		BIT(LZ77_HASH_LOG)
 #define LZ77_RSTEP_SIZE		sizeof(u32)
 #define LZ77_MSTEP_SIZE		sizeof(u64)
 #define LZ77_SKIP_TRIGGER	4
@@ -215,7 +219,8 @@ static __always_inline u32 lz77_hash(const u32 v)
 	return ((v ^ 0x9E3779B9) * 0x85EBCA6B) >> (32 - LZ77_HASH_LOG);
 }
 
-noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen)
+noinline int smb_lz77_compress(const void *src, const u32 slen,
+			       void *dst, u32 *dlen)
 {
 	const void *srcp, *rlim, *end, *anchor;
 	u32 *htable, hash, flag_count = 0;
@@ -223,10 +228,11 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 	long flag = 0;
 
 	/* This is probably a bug, so throw a warning. */
-	if (WARN_ON_ONCE(*dlen < lz77_compressed_alloc_size(slen)))
+	if (WARN_ON_ONCE(*dlen < smb_lz77_compressed_alloc_size(slen)))
 		return -EINVAL;
 
-	srcp = anchor = src;
+	srcp = src;
+	anchor = src;
 	end = srcp + slen; /* absolute end */
 	rlim = end - LZ77_MSTEP_SIZE; /* read limit (for lz77_match_len()) */
 	dstp = dst;
@@ -251,7 +257,8 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 	/*
 	 * Main loop.
 	 *
-	 * @dlen is >= lz77_compressed_alloc_size(), so run without bound-checking @dstp.
+	 * @dlen is >= smb_lz77_compressed_alloc_size(), so run without
+	 * bound-checking @dstp.
 	 *
 	 * This code was crafted in a way to best utilise fetch-decode-execute CPU flow.
 	 * Any attempt to optimize it, or even organize it, can lead to huge performance loss.
@@ -333,3 +340,122 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 
 	return -EMSGSIZE;
 }
+EXPORT_SYMBOL_GPL(smb_lz77_compress);
+
+static int lz77_decode_match_len(const u8 **src, const u8 *end, u16 token,
+				 u8 *nibble, bool *have_nibble, u32 *len)
+{
+	u8 extra;
+
+	*len = (token & 0x7) + 3;
+	if ((token & 0x7) != 0x7)
+		return 0;
+
+	if (!*have_nibble) {
+		if (*src >= end)
+			return -EINVAL;
+		*nibble = *(*src)++;
+		extra = *nibble & 0xf;
+		*have_nibble = true;
+	} else {
+		extra = *nibble >> 4;
+		*have_nibble = false;
+	}
+
+	*len += extra;
+	if (extra == 0xf) {
+		u8 b;
+
+		if (*src >= end)
+			return -EINVAL;
+		b = *(*src)++;
+		if (b != 0xff) {
+			*len += b;
+		} else {
+			u16 w;
+
+			if (end - *src < 2)
+				return -EINVAL;
+			w = get_unaligned_le16(*src);
+			*src += 2;
+			if (w) {
+				*len = w + 3;
+			} else {
+				u32 long_len;
+
+				if (end - *src < 4)
+					return -EINVAL;
+				long_len = get_unaligned_le32(*src);
+				*src += 4;
+				if (check_add_overflow(long_len, 3, len))
+					return -EINVAL;
+			}
+		}
+	}
+
+	return 0;
+}
+
+int smb_lz77_decompress(const void *src, const u32 slen, void *dst,
+			const u32 dlen)
+{
+	const u8 *sp = src, *send = sp + slen;
+	u8 *dp = dst, *dend = dp + dlen;
+	u32 flags = 0;
+	int flag_count = 0;
+	u8 nibble = 0;
+	bool have_nibble = false;
+
+	while (dp < dend) {
+		u32 len, dist;
+		u16 token;
+
+		if (!flag_count) {
+			if (send - sp < 4)
+				return -EINVAL;
+			flags = get_unaligned_le32(sp);
+			sp += 4;
+			flag_count = 32;
+		}
+
+		if (!(flags & 0x80000000)) {
+			if (sp >= send)
+				return -EINVAL;
+			*dp++ = *sp++;
+			flags <<= 1;
+			flag_count--;
+			continue;
+		}
+
+		flags <<= 1;
+		flag_count--;
+
+		if (send - sp < 2)
+			return -EINVAL;
+
+		token = get_unaligned_le16(sp);
+		sp += 2;
+
+		dist = (token >> 3) + 1;
+		if (dist > dp - (u8 *)dst)
+			return -EINVAL;
+
+		if (lz77_decode_match_len(&sp, send, token, &nibble,
+					  &have_nibble, &len))
+			return -EINVAL;
+
+		if (len > dend - dp)
+			return -EINVAL;
+
+		while (len--) {
+			*dp = *(dp - dist);
+			dp++;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(smb_lz77_decompress);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SMB plain LZ77 compression");
diff --git a/fs/smb/client/compress/lz77.h b/fs/smb/common/compress/lz77.h
similarity index 65%
rename from fs/smb/client/compress/lz77.h
rename to fs/smb/common/compress/lz77.h
index 4e570846aefa..e032c0f1b48d 100644
--- a/fs/smb/client/compress/lz77.h
+++ b/fs/smb/common/compress/lz77.h
@@ -12,7 +12,7 @@
 #include <linux/kernel.h>
 
 /**
- * lz77_compressed_alloc_size() - Compute compressed buffer size.
+ * smb_lz77_compressed_alloc_size() - Compute compressed buffer size.
  * @size:	uncompressed (src) size
  *
  * Compute allocation size for the compressed buffer based on uncompressed size.
@@ -26,18 +26,21 @@
  * Worst case scenario is an all-literal compression, which means:
  * metadata bytes = 4 + ((@size / 32) * 4) + 4, or, simplified, (@size >> 3) + 8
  *
- * The worst case scenario rarely happens, but such overprovisioning also allows lz77_compress()
- * main loop to run without ever bound checking dst, which is a huge perf improvement, while also
- * being safe when compression goes bad.
+ * The worst case scenario rarely happens, but such overprovisioning also
+ * allows smb_lz77_compress() main loop to run without ever bound checking dst,
+ * which is a huge perf improvement, while also being safe when compression goes
+ * bad.
  *
  * Return: required (*) allocation size for compressed buffer.
  *
- * (*) checked once in the beginning of lz77_compress()
+ * (*) checked once in the beginning of smb_lz77_compress()
  */
-static __always_inline u32 lz77_compressed_alloc_size(const u32 size)
+static __always_inline u32 smb_lz77_compressed_alloc_size(const u32 size)
 {
 	return size + (size >> 3) + 8;
 }
 
-int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen);
+int smb_lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen);
+int smb_lz77_decompress(const void *src, const u32 slen, void *dst,
+			const u32 dlen);
 #endif /* _SMB_COMPRESS_LZ77_H */
-- 
2.25.1

