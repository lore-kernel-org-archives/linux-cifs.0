Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA6533A014
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 21:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979221; cv=none; b=FP23zP/pkd9/YnsMKeDBIbDykv8a3nQtpCulcySuR0fPgMG9lEA9TmzzYBf5yXuEW4+zgq76KpFgAB3HMBHmaJHBMqzOaTVLjq7vaMbDxBz8yMC+SUWe+QibK2/JObstQSFylD8wuyad0FZZSQi1QOtCtKYmy9khPKE0jm5OfXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979221; c=relaxed/simple;
	bh=M+8edd2wY5vkWs0uStPQ22pbjJRqRAYQCqIWDB4zbuE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fxIqK+dOVaXeZtReRZBO+CWzoZi9/F9nzyw0hK25WiwvVRi8ooa32Dp3PQVrLiOyreAN8n/keyN+GhP39RKRnLjiIlkJcPTKXv/68kx0J657OG7lg1/qWJR3+qNii0jDWZccVHF6A+NoN3nnv6nzLpNSHNkm3pDKw9kXddcalgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k1Qk9hMq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=T2bmVIGF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xADOMS4Q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=B2dyvAWv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k1Qk9hMq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="T2bmVIGF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xADOMS4Q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="B2dyvAWv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7DD093E13;
	Mon, 13 Jul 2026 21:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cllIUjTLBPJuirRB+dWYNj7sDHK8clWvtfFbr0D1gaM=;
	b=k1Qk9hMqkAGOsyofQ4EhY+3jIkisObEkCxD/uTH9W2gdEGkTJQBKe9Kf1+74klVD08n5Jj
	yVd5TmGONuqwvXSK+htIqlWlGS+woEy+Y85UfGDVfgwQ6uzHdXwwqdOzfI2hx704jbnJvA
	5eS4JIqKXsRaoAt33O43mXnEgck1+PI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979217;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cllIUjTLBPJuirRB+dWYNj7sDHK8clWvtfFbr0D1gaM=;
	b=T2bmVIGFSvtWWsMsgg7juxtuRCSk8P0ISzDb3h9vdXlZQuHZoxAWPmF4LiO/zeM9mJsjWu
	GmCzTGa5jtavQ5AQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xADOMS4Q;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=B2dyvAWv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cllIUjTLBPJuirRB+dWYNj7sDHK8clWvtfFbr0D1gaM=;
	b=xADOMS4QlhANJUN5aHZ0eOilB94iM/UZ8t8QlpKw2JD6bxcktoLfULaXkPkzm9/Qu9Yj8z
	DguFQ+pomfpslVbUlFf2sRzupEpIrS7lCFaqn42/nT+7NleYFgFaUV6dh6lpLX0Ape4YXm
	f7kBq853Lc/NdBalEb3qbm/mp5Lm2xU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979216;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cllIUjTLBPJuirRB+dWYNj7sDHK8clWvtfFbr0D1gaM=;
	b=B2dyvAWvWQ47e3gJ54Q61gwCdae7ARcvKIRZ/68Q/WK7lha27llLfeXac8PMTM3dmvkRBV
	67CUih1favTmFPBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0392779AE;
	Mon, 13 Jul 2026 21:46:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cZagLM9cVWqEUQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Jul 2026 21:46:55 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 01/10] smb: common: compress: add memory access helpers to compress.h
Date: Mon, 13 Jul 2026 18:46:36 -0300
Message-ID: <20260713214645.550580-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7DD093E13
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Add memory access helpers + some other common definitions to be used
by SMB2 compression (both server and client, and all algorithms).

Changes:
- update affected call paths in lz77.c and compress.c
- update server/compress.* and client/compress.* to include compress.h
  only

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress.c          |   3 +-
 fs/smb/client/compress.h          |  11 ---
 fs/smb/common/compress/compress.c |   9 +-
 fs/smb/common/compress/compress.h | 126 ++++++++++++++++++++++++++++
 fs/smb/common/compress/lz77.c     | 134 +++++++-----------------------
 fs/smb/server/compress.c          |   3 -
 6 files changed, 156 insertions(+), 130 deletions(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 8f0860970741..5591a8d85037 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -18,11 +18,10 @@
 #include <linux/sort.h>
 
 #include "cifsglob.h"
-#include "../common/smb2pdu.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
 
-#include "../common/compress/lz77.h"
+#include "../common/compress/compress.h"
 #include "compress.h"
 
 /*
diff --git a/fs/smb/client/compress.h b/fs/smb/client/compress.h
index e08e6d339d21..fc8c8d502e45 100644
--- a/fs/smb/client/compress.h
+++ b/fs/smb/client/compress.h
@@ -17,24 +17,14 @@
 
 #include <linux/uio.h>
 #include <linux/kernel.h>
-#include "../common/smb2pdu.h"
-#include "../common/compress/compress.h"
 #include "cifsglob.h"
 
-/* sizeof(smb2_compression_hdr) - sizeof(OriginalPayloadSize) */
-#define SMB_COMPRESS_HDR_LEN		16
-/* sizeof(smb2_compression_payload_hdr) - sizeof(OriginalPayloadSize) */
-#define SMB_COMPRESS_PAYLOAD_HDR_LEN	8
-#define SMB_COMPRESS_MIN_LEN		PAGE_SIZE
-
 #ifdef CONFIG_CIFS_COMPRESSION
 typedef int (*compress_send_fn)(struct TCP_Server_Info *, int, struct smb_rqst *);
 
-
 int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq,
 		 compress_send_fn send_fn);
 bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq);
-
 #else /* !CONFIG_CIFS_COMPRESSION */
 static inline int smb_compress(void *unused1, void *unused2, void *unused3)
 {
@@ -45,6 +35,5 @@ static inline bool should_compress(void *unused1, void *unused2)
 {
 	return false;
 }
-
 #endif /* !CONFIG_CIFS_COMPRESSION */
 #endif /* _SMB_COMPRESS_H */
diff --git a/fs/smb/common/compress/compress.c b/fs/smb/common/compress/compress.c
index b07a317597a4..088e0d0d2792 100644
--- a/fs/smb/common/compress/compress.c
+++ b/fs/smb/common/compress/compress.c
@@ -7,15 +7,8 @@
 #include <linux/module.h>
 #include <linux/overflow.h>
 #include <linux/string.h>
-#include <linux/unaligned.h>
 
 #include "compress.h"
-#include "lz77.h"
-
-#define SMB2_COMPRESSION_CHAINED_HDR_LEN \
-	offsetof(struct smb2_compression_hdr, CompressionAlgorithm)
-#define SMB2_COMPRESSION_PAYLOAD_BASE_LEN \
-	(sizeof(struct smb2_compression_payload_hdr) - sizeof(__le32))
 
 /*
  * A NONE payload carries bytes verbatim. Keep both cursors and remaining
@@ -75,7 +68,7 @@ static int smb_decompress_lz77_payload(const u8 **src, u32 *slen, u8 **dst,
 	if (len < sizeof(__le32) || len > *slen)
 		return -EINVAL;
 
-	orig_size = get_unaligned_le32(*src);
+	orig_size = mem_read32(*src);
 	if (orig_size > *dlen)
 		return -EINVAL;
 
diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
index 7ace3bf4b664..24b558167fe7 100644
--- a/fs/smb/common/compress/compress.h
+++ b/fs/smb/common/compress/compress.h
@@ -1,11 +1,137 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright (C) 2026 Namjae Jeon <linkinjeon@kernel.org>
+ * Copyright (C) 2026, SUSE LLC, author: Enzo Matsumiya <ematsumiya@suse.de>
+ *
+ * Common helpers and definitions for SMB2 compression/decompression.
+ *
+ * Note that, as helpers, most assume their args were previously checked by callers.
  */
 #ifndef _COMMON_SMB_COMPRESS_H
 #define _COMMON_SMB_COMPRESS_H
+#include <linux/count_zeros.h>
+#include <linux/string.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
 
 #include "../smb2pdu.h"
+#include "lz77.h"
+
+#define SMB2_COMPRESSION_CHAINED_HDR_LEN \
+	offsetof(struct smb2_compression_hdr, CompressionAlgorithm)
+#define SMB2_COMPRESSION_PAYLOAD_BASE_LEN \
+	(sizeof(struct smb2_compression_payload_hdr) - sizeof(__le32))
+#define SMB_COMPRESS_MIN_LEN		PAGE_SIZE
+
+/*
+ * Memory ops helpers.
+ */
+#undef MEM_UNALIGNED_READ
+#undef MEM_UNALIGNED_WRITE
+
+/* Read prefetch */
+#define MEM_PREFETCH(ptr)		__builtin_prefetch((ptr), 0, 3)
+
+/*
+ * x86 safely handles unaligned reads by pointer deref.
+ * Use the unaligned helpers for other archs.
+ */
+#ifdef CONFIG_X86
+# define MEM_UNALIGNED_READ(ptr, t)	(*(const t *)(ptr))
+# define MEM_UNALIGNED_WRITE(ptr, v, t)	(*(t *)(ptr) = (t)(v))
+#else
+# include <linux/unaligned.h>
+# define MEM_UNALIGNED_READ(ptr, t)	get_unaligned((const t *)(ptr))
+# define MEM_UNALIGNED_WRITE(ptr, v, t)	put_unaligned((v), (t *)(ptr))
+#endif /* !CONFIG_X86 */
+
+#define mem_read8(ptr)			MEM_UNALIGNED_READ(ptr, u8)
+#define mem_read16(ptr)			MEM_UNALIGNED_READ(ptr, u16)
+#define mem_read32(ptr)			MEM_UNALIGNED_READ(ptr, u32)
+#define mem_read64(ptr)			MEM_UNALIGNED_READ(ptr, u64)
+#define mem_write8(ptr, v)		MEM_UNALIGNED_WRITE(ptr, v, u8)
+#define mem_write16(ptr, v)		MEM_UNALIGNED_WRITE(ptr, v, u16)
+#define mem_write32(ptr, v)		MEM_UNALIGNED_WRITE(ptr, v, u32)
+/* mem_write64() not implemented -- not used anywhere yet */
+
+/**
+ * SMB_COMPRESS_RSTEP_SIZE:	Number of bytes to read from input buffer for hashing and initial
+ *				match check (default 4 bytes).
+ * SMB_COMPRESS_MSTEP_SIZE:	Number of bytes to extend-compare a found match (default 8 bytes).
+ */
+#define SMB_COMPRESS_RSTEP_SIZE	sizeof(u32)
+#define SMB_COMPRESS_MSTEP_SIZE	sizeof(u64)
+
+/**
+ * mem_match_len() - Fast (batch) count matching bytes on a linear buffer.
+ * @start: start of buffer
+ * @head: current position on buffer
+ * @end: end of buffer
+ *
+ * Compare 8 bytes of @start and @head until a mismatch is found or @head reaches @end.
+ *
+ * Requirements:
+ * - no args can be NULL (must be asserted by caller)
+ * - all args must point to the same allocated memory (must be asserted by caller)
+ * - @start < @head + 8 <= end (asserted here)
+ *
+ * Return: number of matching bytes (0 if last requirement fails)
+ */
+static __always_inline size_t mem_match_len(const void *start, const void *head, const void *end)
+{
+	const void *cur = head;
+
+	if (unlikely(start >= head || head + SMB_COMPRESS_MSTEP_SIZE > end))
+		return 0;
+
+	do {
+		const u64 diff = mem_read64(head) ^ mem_read64(start);
+
+		if (!diff) {
+			head += SMB_COMPRESS_MSTEP_SIZE;
+			start += SMB_COMPRESS_MSTEP_SIZE;
+
+			continue;
+		}
+
+		/* This computes the number of common bytes in @diff. */
+		head += count_trailing_zeros(diff) >> 3;
+
+		return (head - cur);
+	} while (likely(head + SMB_COMPRESS_MSTEP_SIZE <= end));
+
+	/* Fallback to byte-by-byte comparison for last bytes (< SMB_COMPRESS_MSTEP_SIZE). */
+	while (head < end && mem_read8(start) == mem_read8(head)) {
+		head++;
+		start++;
+	}
+
+	return (head - cur);
+}
+
+/*
+ * Hashing parameters.
+ * Same for all algorithms.
+ *
+ * XXX: these are fixed for now, might make them tunables in the future.
+ */
+
+/**
+ * SMB_COMPRESS_HASH_LOG:	ilog2 hash size (recommended to be 13 - 18, default 15).
+ * SMB_COMPRESS_HASH_SIZE:	Hashtable size (default is 32k (1 << SMB_COMPRESS_HASH_LOG))).
+ */
+#define SMB_COMPRESS_HASH_LOG	15
+#define SMB_COMPRESS_HASH_SIZE	BIT(SMB_COMPRESS_HASH_LOG)
+
+static __always_inline u32 smb_compress_hash(const u32 v)
+{
+	return ((v ^ 0x9E3779B9U) * 0x85EBCA6BU) >> (32 - SMB_COMPRESS_HASH_LOG);
+}
+
+static __always_inline u32 smb_compress_hash_ptr(const void *ptr)
+{
+	return smb_compress_hash(mem_read32(ptr));
+}
 
 /*
  * SMB3_COMPRESS_NONE is valid only in chained payload headers. It is never
diff --git a/fs/smb/common/compress/lz77.c b/fs/smb/common/compress/lz77.c
index 9216d973d876..e32e2f3040d8 100644
--- a/fs/smb/common/compress/lz77.c
+++ b/fs/smb/common/compress/lz77.c
@@ -15,19 +15,12 @@
 #include <linux/module.h>
 #include <linux/overflow.h>
 
-#include "lz77.h"
+#include "compress.h"
 
 /*
  * Compression parameters.
  *
  * LZ77_MATCH_MAX_DIST:		Farthest back a match can be from current position (can be 1 - 8K).
- * LZ77_HASH_LOG:
- * LZ77_HASH_SIZE:		ilog2 hash size (recommended to be 13 - 18, default 15 (hash size
- *				32k)).
- * LZ77_RSTEP_SIZE:		Number of bytes to read from input buffer for hashing and initial
- *				match check (default 4 bytes, this effectivelly makes this the min
- *				match len).
- * LZ77_MSTEP_SIZE:		Number of bytes to extend-compare a found match (default 8 bytes).
  * LZ77_SKIP_TRIGGER:		ilog2 value for adaptive skipping, i.e. to progressively skip input
  *				bytes when we can't find matches.  Default is 4.
  *				Higher values (>0) will decrease compression time, but will result
@@ -35,75 +28,10 @@
  *				compression ratio (more matches found), but will increase time.
  */
 #define LZ77_MATCH_MAX_DIST	SZ_8K
-#define LZ77_HASH_LOG		15
-#define LZ77_HASH_SIZE		BIT(LZ77_HASH_LOG)
-#define LZ77_RSTEP_SIZE		sizeof(u32)
-#define LZ77_MSTEP_SIZE		sizeof(u64)
 #define LZ77_SKIP_TRIGGER	4
 
-#define LZ77_PREFETCH(ptr)	__builtin_prefetch((ptr), 0, 3)
 #define LZ77_FLAG_MAX		32
 
-static __always_inline u8 lz77_read8(const u8 *ptr)
-{
-	return get_unaligned(ptr);
-}
-
-static __always_inline u32 lz77_read32(const u32 *ptr)
-{
-	return get_unaligned(ptr);
-}
-
-static __always_inline u64 lz77_read64(const u64 *ptr)
-{
-	return get_unaligned(ptr);
-}
-
-static __always_inline void lz77_write8(u8 *ptr, u8 v)
-{
-	put_unaligned(v, ptr);
-}
-
-static __always_inline void lz77_write16(u16 *ptr, u16 v)
-{
-	put_unaligned_le16(v, ptr);
-}
-
-static __always_inline void lz77_write32(u32 *ptr, u32 v)
-{
-	put_unaligned_le32(v, ptr);
-}
-
-static __always_inline u32 lz77_match_len(const void *match, const void *cur, const void *end)
-{
-	const void *start = cur;
-
-	/* Safe for a do/while because otherwise we wouldn't reach here from the main loop. */
-	do {
-		const u64 diff = lz77_read64(cur) ^ lz77_read64(match);
-
-		if (!diff) {
-			cur += LZ77_MSTEP_SIZE;
-			match += LZ77_MSTEP_SIZE;
-
-			continue;
-		}
-
-		/* This computes the number of common bytes in @diff. */
-		cur += count_trailing_zeros(diff) >> 3;
-
-		return (cur - start);
-	} while (likely(cur + LZ77_MSTEP_SIZE <= end));
-
-	/* Fallback to byte-by-byte comparison for last <8 bytes. */
-	while (cur < end && lz77_read8(cur) == lz77_read8(match)) {
-		cur++;
-		match++;
-	}
-
-	return (cur - start);
-}
-
 /**
  * lz77_encode_match() - Match encoding.
  * @dst:	compressed buffer
@@ -124,24 +52,24 @@ static __always_inline void *lz77_encode_match(void *dst, void **nib, u16 dist,
 	dist <<= 3;
 
 	if (len < 7) {
-		lz77_write16(dst, dist + len);
+		mem_write16(dst, dist + len);
 
 		return dst + sizeof(u16);
 	}
 
 	dist |= 7;
-	lz77_write16(dst, dist);
+	mem_write16(dst, dist);
 	dst += sizeof(u16);
 	len -= 7;
 
 	if (!*nib) {
-		lz77_write8(dst, umin(len, 15));
+		mem_write8(dst, umin(len, 15));
 		*nib = dst;
 		dst++;
 	} else {
 		u8 *b = *nib;
 
-		lz77_write8(b, *b | umin(len, 15) << 4);
+		mem_write8(b, *b | umin(len, 15) << 4);
 		*nib = NULL;
 	}
 
@@ -150,23 +78,23 @@ static __always_inline void *lz77_encode_match(void *dst, void **nib, u16 dist,
 
 	len -= 15;
 	if (len < 255) {
-		lz77_write8(dst, len);
+		mem_write8(dst, len);
 
 		return dst + 1;
 	}
 
-	lz77_write8(dst, 0xff);
+	mem_write8(dst, 0xff);
 	dst++;
 	len += 7 + 15;
 	if (len <= 0xffff) {
-		lz77_write16(dst, len);
+		mem_write16(dst, len);
 
 		return dst + sizeof(u16);
 	}
 
-	lz77_write16(dst, 0);
+	mem_write16(dst, 0);
 	dst += sizeof(u16);
-	lz77_write32(dst, len);
+	mem_write32(dst, len);
 
 	return dst + sizeof(u32);
 }
@@ -204,7 +132,7 @@ static __always_inline void *lz77_encode_literals(const void *start, const void
 		*f <<= len;
 		*fc += len;
 		if (*fc == LZ77_FLAG_MAX) {
-			lz77_write32(*fp, *f);
+			mem_write32(*fp, *f);
 			*fc = 0;
 			*fp = dst;
 			dst += sizeof(u32);
@@ -214,13 +142,7 @@ static __always_inline void *lz77_encode_literals(const void *start, const void
 	return dst;
 }
 
-static __always_inline u32 lz77_hash(const u32 v)
-{
-	return ((v ^ 0x9E3779B9) * 0x85EBCA6B) >> (32 - LZ77_HASH_LOG);
-}
-
-noinline int smb_lz77_compress(const void *src, const u32 slen,
-			       void *dst, u32 *dlen)
+noinline int smb_lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen)
 {
 	const void *srcp, *rlim, *end, *anchor;
 	u32 *htable, hash, flag_count = 0;
@@ -234,25 +156,25 @@ noinline int smb_lz77_compress(const void *src, const u32 slen,
 	srcp = src;
 	anchor = src;
 	end = srcp + slen; /* absolute end */
-	rlim = end - LZ77_MSTEP_SIZE; /* read limit (for lz77_match_len()) */
+	rlim = end - SMB_COMPRESS_MSTEP_SIZE; /* read limit (for mem_match_len()) */
 	dstp = dst;
 	flag_pos = dstp;
 	dstp += sizeof(u32);
 	nib = NULL;
 
-	htable = kvcalloc(LZ77_HASH_SIZE, sizeof(*htable), GFP_KERNEL);
+	htable = kvcalloc(SMB_COMPRESS_HASH_SIZE, sizeof(*htable), GFP_KERNEL);
 	if (!htable)
 		return -ENOMEM;
 
-	LZ77_PREFETCH(srcp + LZ77_RSTEP_SIZE);
+	MEM_PREFETCH(srcp + SMB_COMPRESS_RSTEP_SIZE);
 
 	/*
 	 * Adjust @srcp so we don't get a false positive match on first iteration.
 	 * Then prepare hash for first loop iteration (don't advance @srcp again).
 	 */
-	hash = lz77_hash(lz77_read32(srcp++));
+	hash = smb_compress_hash_ptr(srcp++);
 	htable[hash] = 0;
-	hash = lz77_hash(lz77_read32(srcp));
+	hash = smb_compress_hash_ptr(srcp);
 
 	/*
 	 * Main loop.
@@ -285,11 +207,11 @@ noinline int smb_lz77_compress(const void *src, const u32 slen,
 			if (unlikely(next > rlim))
 				goto out;
 
-			hash = lz77_hash(lz77_read32(next));
+			hash = smb_compress_hash_ptr(next);
 			match = src + htable[cur_hash];
 			htable[cur_hash] = srcp - src;
 		} while (likely(match + LZ77_MATCH_MAX_DIST < srcp) ||
-			 lz77_read32(match) != lz77_read32(srcp));
+			 mem_read32(match) != mem_read32(srcp));
 
 		/*
 		 * Match found.  Warm/cold path; begin parsing @srcp and writing to @dstp:
@@ -302,17 +224,17 @@ noinline int smb_lz77_compress(const void *src, const u32 slen,
 		 * redundantly compute it again in lz77_match_len() than to adjust pointers/len.
 		 */
 		dstp = lz77_encode_literals(anchor, srcp, dstp, &flag, &flag_count, &flag_pos);
-		len = lz77_match_len(match, srcp, end);
+		len = mem_match_len(match, srcp, end);
 		dstp = lz77_encode_match(dstp, &nib, srcp - match, len);
 		srcp += len;
 		anchor = srcp;
 
-		LZ77_PREFETCH(srcp);
+		MEM_PREFETCH(srcp);
 
 		flag = (flag << 1) | 1;
 		flag_count++;
 		if (flag_count == LZ77_FLAG_MAX) {
-			lz77_write32(flag_pos, flag);
+			mem_write32(flag_pos, flag);
 			flag_count = 0;
 			flag_pos = dstp;
 			dstp += sizeof(u32);
@@ -322,7 +244,7 @@ noinline int smb_lz77_compress(const void *src, const u32 slen,
 			break;
 
 		/* Prepare for next loop. */
-		hash = lz77_hash(lz77_read32(srcp));
+		hash = smb_compress_hash_ptr(srcp);
 	} while (srcp < end);
 out:
 	dstp = lz77_encode_literals(anchor, end, dstp, &flag, &flag_count, &flag_pos);
@@ -330,7 +252,7 @@ noinline int smb_lz77_compress(const void *src, const u32 slen,
 	flag_count = LZ77_FLAG_MAX - flag_count;
 	flag <<= flag_count;
 	flag |= (1UL << flag_count) - 1;
-	lz77_write32(flag_pos, flag);
+	mem_write32(flag_pos, flag);
 
 	*dlen = dstp - dst;
 	kvfree(htable);
@@ -376,7 +298,7 @@ static int lz77_decode_match_len(const u8 **src, const u8 *end, u16 token,
 
 			if (end - *src < 2)
 				return -EINVAL;
-			w = get_unaligned_le16(*src);
+			w = mem_read16(*src);
 			*src += 2;
 			if (w) {
 				*len = w + 3;
@@ -385,7 +307,7 @@ static int lz77_decode_match_len(const u8 **src, const u8 *end, u16 token,
 
 				if (end - *src < 4)
 					return -EINVAL;
-				long_len = get_unaligned_le32(*src);
+				long_len = mem_read32(*src);
 				*src += 4;
 				if (check_add_overflow(long_len, 3, len))
 					return -EINVAL;
@@ -413,7 +335,7 @@ int smb_lz77_decompress(const void *src, const u32 slen, void *dst,
 		if (!flag_count) {
 			if (send - sp < 4)
 				return -EINVAL;
-			flags = get_unaligned_le32(sp);
+			flags = mem_read32(sp);
 			sp += 4;
 			flag_count = 32;
 		}
@@ -433,7 +355,7 @@ int smb_lz77_decompress(const void *src, const u32 slen, void *dst,
 		if (send - sp < 2)
 			return -EINVAL;
 
-		token = get_unaligned_le16(sp);
+		token = mem_read16(sp);
 		sp += 2;
 
 		dist = (token >> 3) + 1;
diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index f8cf515b9c30..8c910f996e04 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -10,9 +10,6 @@
 
 #include "compress.h"
 #include "smb_common.h"
-#include "../common/compress/lz77.h"
-
-#define SMB_COMPRESS_MIN_LEN	PAGE_SIZE
 
 /**
  * ksmbd_decompress_request() - replace a compressed request with its SMB2 PDU
-- 
2.54.0

