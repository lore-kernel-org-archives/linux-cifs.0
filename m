Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D971A3166
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 19:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107294; cv=none; b=NcwgX2XulJByDALWw1uOkSNSPH6H2zRQKAodnckK6vUfUZZI9bATpPvMesikODfNH6kKX3KGI5R8RMKcmbyHyTgzhLXCN7OwheNkvMp9HBxocymg6Yl3IDdL5tw9dGJcmspFnv1XF5sDgUVXX9/K/2aLegaGoVFgla0+eAGZYS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107294; c=relaxed/simple;
	bh=4+RkreMOvZuxypCaW1yXrBr02YOT1YhvDj59vJulC94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TU+WivxZRHTA4CdEyookfr9Hwg3qsfffowAwPBIP4C0HXcQKrIAlHGvsIbuw1hvF1D8vGCGozB4wxwxAkV+Wvk/aWt1lfw3VgJ/eZ+KXp73RVxr0MY7IUxHopurFBIiKQtrqGjQcCwgQlCnEJfSai7PsGcN6kxk08BM8GDKeS7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bTbZ3gbA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0SPkAgx2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NcUANBbJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AIXi4aLV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bTbZ3gbA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0SPkAgx2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NcUANBbJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AIXi4aLV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B40795BDAF;
	Mon, 13 Apr 2026 19:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3k55yAzWZIw33nLNRF0CyfO2FfP+cQLaZgYmgyXg+do=;
	b=bTbZ3gbAmkGJbB3wmkP9qhU67IIJyY3T0VfLEBJI0Rl2YEu7AE53u7Qh3IGQY5ebjWrF+e
	r1bh2IlL9XHtUjAw4SNlOGRkwnfBqVzE+Ae89rQkPxRhc0mGJTjT17sPjMbb2GdNThrfhM
	zesy5/bYZQYk9tSqKqbvEZqCEJpEXF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3k55yAzWZIw33nLNRF0CyfO2FfP+cQLaZgYmgyXg+do=;
	b=0SPkAgx2gNVNgF8XhD/rv5+I1x+28DOWYFCX+kP6HdbNbiaI+a506uKi6S4BhDhckf/PcD
	D2DstH7aNtKkZWAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3k55yAzWZIw33nLNRF0CyfO2FfP+cQLaZgYmgyXg+do=;
	b=NcUANBbJCbao6KYj7zL0rzwbj3PMtKub9phhv49pY2frQ8nP5k7E9aJaFcnyT0DpHqRb3b
	XvppZwmgPk9nVApxCn1AWMpos2gxmRJKcKTVOoKNlYZgHCRezc20ElXCSJhrmWqLd8XQVF
	qRp+vEVYBfuWGW5QqXmOvdvik0QYznE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107289;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3k55yAzWZIw33nLNRF0CyfO2FfP+cQLaZgYmgyXg+do=;
	b=AIXi4aLV/xSBGOUdR39dr+3kZq+cp3zqMbeLcwb3jjT7q0zTQla0Ule/XlcDM/HNA/ZSq4
	m831atH/s+V9DvBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E5964B03B;
	Mon, 13 Apr 2026 19:08:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g8cDAhk/3WnCEAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Apr 2026 19:08:09 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 7/8] smb: client: compress: add compress/common.h
Date: Mon, 13 Apr 2026 16:07:12 -0300
Message-ID: <20260413190713.283939-7-ematsumiya@suse.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413190713.283939-1-ematsumiya@suse.de>
References: <20260413190713.283939-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	ARC_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

Add compress/common.h to aggregate helpers and definitions that will be
shared with other compression algorithms.

Also add a few build time checks for proper support.

Changes:
- update affected call paths in compress/lz77.c

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress/common.h | 152 ++++++++++++++++++++++++++++++++
 fs/smb/client/compress/lz77.c   | 122 +++++--------------------
 2 files changed, 175 insertions(+), 99 deletions(-)
 create mode 100644 fs/smb/client/compress/common.h

diff --git a/fs/smb/client/compress/common.h b/fs/smb/client/compress/common.h
new file mode 100644
index 000000000000..b5ccf5debd22
--- /dev/null
+++ b/fs/smb/client/compress/common.h
@@ -0,0 +1,152 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026, SUSE LLC
+ *
+ * Authors: Enzo Matsumiya <ematsumiya@suse.de>
+ *
+ * Common helpers and definitions for compression/decompression.
+ *
+ * Naming convention:
+ * - smb_compress_*:	MS-SMB2 related API
+ * - compress_*:	Compression internals
+ * - <alg>_*:		Compression algorithm specifics
+ *
+ * Upper case for macros and constants, lower case for everything else.
+ */
+#ifndef _COMPRESS_COMMON_H
+#define _COMPRESS_COMMON_H
+
+#include <linux/kernel.h>
+#include <linux/count_zeros.h>
+#include <linux/string.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+
+/*
+ * Build time checks/asserts.
+ * These are assumptions/expectations for all algorithms implemented.
+ */
+#ifndef __LITTLE_ENDIAN /* TODO */
+# error "SMB3 compression is only supported on little endian architectures"
+#endif /* !__LITTLE_ENDIAN */
+
+#if BITS_PER_LONG < 64 /* TODO */
+# error "SMB3 compression is only supported on 64-bit architectures"
+#endif /* BITS_PER_LONG < 64 */
+
+/* Build time double checks (probably unnecessary) */
+static_assert(sizeof(u16) == 2);
+static_assert(sizeof(u32) == 4);
+static_assert(sizeof(u64) == 8);
+static_assert(sizeof(size_t) == 8);
+
+#ifdef CONFIG_CIFS_DEBUG2
+# define COMPRESS_DEBUG
+#endif /* CONFIG_CIFS_DEBUG2 */
+
+#define COMPRESS_LOG_FMT	"CIFS: %s:%d %s(): "
+
+#ifdef COMPRESS_DEBUG
+# define compress_log(fmt, ...) \
+	pr_err(COMPRESS_LOG_FMT fmt, __FILE__, __LINE__, __func__, ## __VA_ARGS__)
+
+/* Make sure to handle assertion failures! */
+# define COMPRESS_ASSERT(cond) \
+	!WARN_ONCE(!(cond), COMPRESS_LOG_FMT "assertion failed: %s\n", \
+		   __FILE__, __LINE__, __func__, #cond)
+#else /* COMPRESS_DEBUG */
+# define compress_log(...)
+/* XXX: should not fail silently on non-debug? */
+# define COMPRESS_ASSERT(cond)	likely(cond)
+#endif /* !COMPRESS_DEBUG */
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
+/* mem_write64() not implemented because it's not used anywhere. */
+
+/*
+ * COMPRESS_RSTEP_SIZE:		Number of bytes to read from input buffer for hashing and initial
+ *				match check (default 4 bytes).
+ * COMPRESS_MSTEP_SIZE:		Number of bytes to extend-compare a found match (default 8 bytes).
+ */
+#define COMPRESS_RSTEP_SIZE	sizeof(u32)
+#define COMPRESS_MSTEP_SIZE	sizeof(u64)
+
+static __always_inline size_t mem_match_len(const void *match, const void *cur, const void *end)
+{
+	const void *start = cur;
+
+	/* Callers must ensure @cur + COMPRESS_MSTEP_SIZE < @end. */
+	do {
+		const u64 diff = mem_read64(cur) ^ mem_read64(match);
+
+		if (!diff) {
+			cur += COMPRESS_MSTEP_SIZE;
+			match += COMPRESS_MSTEP_SIZE;
+
+			continue;
+		}
+
+		/* This computes the number of common bytes in @diff. */
+		cur += count_trailing_zeros(diff) >> 3;
+
+		return (cur - start);
+	} while (likely(cur + COMPRESS_MSTEP_SIZE <= end));
+
+	/* Fallback to byte-by-byte comparison for last bytes (< COMPRESS_MSTEP_SIZE). */
+	while (cur < end && mem_read8(match) == mem_read8(cur)) {
+		cur++;
+		match++;
+	}
+
+	return (cur - start);
+}
+
+/*
+ * Hashing
+ *
+ * Same for all algorithms.
+ *
+ * XXX: these are fixed for now, might make them tunables in the future.
+ */
+
+/*
+ * COMPRESS_HASH_LOG:		ilog2 hash size (recommended to be 13 - 18, default 15)
+ * COMPRESS_HASH_SIZE:		Hashtable size (default is 32k (1 << COMPRESS_HASH_LOG))).
+ */
+#define COMPRESS_HASH_LOG	15
+#define COMPRESS_HASH_SIZE	(1U << COMPRESS_HASH_LOG)
+
+static __always_inline u32 compress_hash(const u32 v)
+{
+	return ((v ^ 0x9E3779B9U) * 0x85EBCA6BU) >> (32 - COMPRESS_HASH_LOG);
+}
+
+static __always_inline u32 compress_hash_ptr(const void *ptr)
+{
+	return compress_hash(mem_read32(ptr));
+}
+#endif /* _COMPRESS_COMMON_H */
diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/client/compress/lz77.c
index 7365d0f97396..d8c73f7f7483 100644
--- a/fs/smb/client/compress/lz77.c
+++ b/fs/smb/client/compress/lz77.c
@@ -11,19 +11,13 @@
 #include <linux/count_zeros.h>
 #include <linux/unaligned.h>
 
+#include "common.h"
 #include "lz77.h"
 
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
@@ -31,75 +25,10 @@
  *				compression ratio (more matches found), but will increase time.
  */
 #define LZ77_MATCH_MAX_DIST	SZ_8K
-#define LZ77_HASH_LOG		15
-#define LZ77_HASH_SIZE		(1 << LZ77_HASH_LOG)
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
@@ -120,24 +49,24 @@ static __always_inline void *lz77_encode_match(void *dst, void **nib, u16 dist,
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
 
@@ -146,23 +75,23 @@ static __always_inline void *lz77_encode_match(void *dst, void **nib, u16 dist,
 
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
@@ -200,7 +129,7 @@ static __always_inline void *lz77_encode_literals(const void *start, const void
 		*f <<= len;
 		*fc += len;
 		if (*fc == LZ77_FLAG_MAX) {
-			lz77_write32(*fp, *f);
+			mem_write32(*fp, *f);
 			*fc = 0;
 			*fp = dst;
 			dst += sizeof(u32);
@@ -210,11 +139,6 @@ static __always_inline void *lz77_encode_literals(const void *start, const void
 	return dst;
 }
 
-static __always_inline u32 lz77_hash(const u32 v)
-{
-	return ((v ^ 0x9E3779B9) * 0x85EBCA6B) >> (32 - LZ77_HASH_LOG);
-}
-
 noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen)
 {
 	const void *srcp, *rlim, *end, *anchor;
@@ -228,25 +152,25 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 
 	srcp = anchor = src;
 	end = srcp + slen; /* absolute end */
-	rlim = end - LZ77_MSTEP_SIZE; /* read limit (for lz77_match_len()) */
+	rlim = end - COMPRESS_MSTEP_SIZE; /* read limit (for mem_match_len()) */
 	dstp = dst;
 	flag_pos = dstp;
 	dstp += sizeof(u32);
 	nib = NULL;
 
-	htable = kvcalloc(LZ77_HASH_SIZE, sizeof(*htable), GFP_KERNEL);
+	htable = kvcalloc(COMPRESS_HASH_SIZE, sizeof(*htable), GFP_KERNEL);
 	if (!htable)
 		return -ENOMEM;
 
-	LZ77_PREFETCH(srcp + LZ77_RSTEP_SIZE);
+	MEM_PREFETCH(srcp + COMPRESS_RSTEP_SIZE);
 
 	/*
 	 * Adjust @srcp so we don't get a false positive match on first iteration.
 	 * Then prepare hash for first loop iteration (don't advance @srcp again).
 	 */
-	hash = lz77_hash(lz77_read32(srcp++));
+	hash = compress_hash_ptr(srcp++);
 	htable[hash] = 0;
-	hash = lz77_hash(lz77_read32(srcp));
+	hash = compress_hash_ptr(srcp);
 
 	/*
 	 * Main loop.
@@ -278,11 +202,11 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 			if (unlikely(next > rlim))
 				goto out;
 
-			hash = lz77_hash(lz77_read32(next));
+			hash = compress_hash_ptr(next);
 			match = src + htable[cur_hash];
 			htable[cur_hash] = srcp - src;
 		} while (likely(match + LZ77_MATCH_MAX_DIST < srcp) ||
-			 lz77_read32(match) != lz77_read32(srcp));
+			 mem_read32(match) != mem_read32(srcp));
 
 		/*
 		 * Match found.  Warm/cold path; begin parsing @srcp and writing to @dstp:
@@ -295,17 +219,17 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
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
@@ -315,7 +239,7 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 			break;
 
 		/* Prepare for next loop. */
-		hash = lz77_hash(lz77_read32(srcp));
+		hash = compress_hash_ptr(srcp);
 	} while (srcp < end);
 out:
 	dstp = lz77_encode_literals(anchor, end, dstp, &flag, &flag_count, &flag_pos);
@@ -323,7 +247,7 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 	flag_count = LZ77_FLAG_MAX - flag_count;
 	flag <<= flag_count;
 	flag |= (1UL << flag_count) - 1;
-	lz77_write32(flag_pos, flag);
+	mem_write32(flag_pos, flag);
 
 	*dlen = dstp - dst;
 	kvfree(htable);
-- 
2.53.0

