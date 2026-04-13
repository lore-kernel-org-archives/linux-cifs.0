Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90EE3451B2
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 19:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107282; cv=none; b=jT7duGy2nob1ZZ0SipvyYPu4WvkntkATi/pKl0qt1a4T/DXfe8vbe8MaROFvHrBE/Bg8XfMtTDGxXCKtbalms5bFpLZiASLVJ2RUsAgKGZm9LcUInRh+Gfs3CieguI1R1FXH8sYdc/Hv+xkqvwikM/kLvXgqo1jMRPqYdoxaWF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107282; c=relaxed/simple;
	bh=bYivK3gZhsGgdNoAUWS1izuFxzT4vWHPYqi9PhN8ie8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoxXYOCY2vWW0gH3Wz4w2WvTKDhLGqmmXmj2jj1AoYnzkszawIoz1EYQJrNv+TwgR6Ou9z+xBValt3kXZeSqYSzZ0jzClGueNSIWFaNAS29reqX2YGJbxwZ+n+exBSIick4uO8dPoeGtygpZThd0ohDqn0JRBFL1clUmwxxsfgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tCvwpcOU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hkIMDIAs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tCvwpcOU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hkIMDIAs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tCvwpcOU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hkIMDIAs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tCvwpcOU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hkIMDIAs"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4D5075BDAE;
	Mon, 13 Apr 2026 19:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5MkbUwX5Hev4qpFGKHQ4CvdhNmiSmmV3TbWd349AfXw=;
	b=tCvwpcOUJWUJx+8YjotsA/4OSaZ/Yq5LUtgynTpWqxN1R5vyGzQr8t2r8Wgs0w00LblP7S
	omc4Hu1UkwyV1PquQYA4YJ22LZRqjmYbKH0jVJIwitReYEJf1rm+8VPqzfWEtWLLGN+SHx
	pke4utx7sQOZAUCBv4+tW98dJ8UNsu0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5MkbUwX5Hev4qpFGKHQ4CvdhNmiSmmV3TbWd349AfXw=;
	b=hkIMDIAscSBXLB0u14XV6C22qq57I8RJPU70tU5O+varEH2rAgEQCEIYhLevlY5KnAUkNP
	t/XfCtOZwNm/WCBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tCvwpcOU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hkIMDIAs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5MkbUwX5Hev4qpFGKHQ4CvdhNmiSmmV3TbWd349AfXw=;
	b=tCvwpcOUJWUJx+8YjotsA/4OSaZ/Yq5LUtgynTpWqxN1R5vyGzQr8t2r8Wgs0w00LblP7S
	omc4Hu1UkwyV1PquQYA4YJ22LZRqjmYbKH0jVJIwitReYEJf1rm+8VPqzfWEtWLLGN+SHx
	pke4utx7sQOZAUCBv4+tW98dJ8UNsu0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5MkbUwX5Hev4qpFGKHQ4CvdhNmiSmmV3TbWd349AfXw=;
	b=hkIMDIAscSBXLB0u14XV6C22qq57I8RJPU70tU5O+varEH2rAgEQCEIYhLevlY5KnAUkNP
	t/XfCtOZwNm/WCBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC2424B039;
	Mon, 13 Apr 2026 19:07:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jgxAJA4/3Wm4EAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Apr 2026 19:07:58 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 5/8] smb: client: compress: LZ77 optimizations
Date: Mon, 13 Apr 2026 16:07:10 -0300
Message-ID: <20260413190713.283939-5-ematsumiya@suse.de>
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
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 4D5075BDAE

This patch implements several micro-optimizations on lz77_compress()
with the goal of reducing the number of instructions per [input]
byte (a.k.a. IPB).

Changes:
- change hashtable to be u32 (instead of u64) -- change the hash
  function to reflect that (adds lz77_hash() and lz77_read32() helpers)
- batch-write literals instead of 1 by 1 -- now that we have a well
  defined hot path (match finding) and a cold path (encode literals +
  match), batch writing makes a significant difference
- implement adaptive skipping of input bytes -- skip input bytes more
  aggressively if too few matches are being found
- name some constants for more meaningful context

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress/lz77.c | 173 +++++++++++++++++++++-------------
 fs/smb/client/compress/lz77.h |   4 +-
 2 files changed, 108 insertions(+), 69 deletions(-)

diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/client/compress/lz77.c
index 480927dcd4c6..96744f52e364 100644
--- a/fs/smb/client/compress/lz77.c
+++ b/fs/smb/client/compress/lz77.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2024, SUSE LLC
+ * Copyright (C) 2024-2026, SUSE LLC
  *
  * Authors: Enzo Matsumiya <ematsumiya@suse.de>
  *
@@ -16,17 +16,26 @@
 /*
  * Compression parameters.
  */
-#define LZ77_MATCH_MIN_LEN	4
 #define LZ77_MATCH_MAX_DIST	SZ_8K
 #define LZ77_HASH_LOG		15
 #define LZ77_HASH_SIZE		(1 << LZ77_HASH_LOG)
-#define LZ77_STEP_SIZE		sizeof(u64)
+#define LZ77_RSTEP_SIZE		sizeof(u32)
+#define LZ77_MSTEP_SIZE		sizeof(u64)
+#define LZ77_SKIP_TRIGGER	4
+
+#define LZ77_PREFETCH(ptr)	__builtin_prefetch((ptr), 0, 3)
+#define LZ77_FLAG_MAX		32
 
 static __always_inline u8 lz77_read8(const u8 *ptr)
 {
 	return get_unaligned(ptr);
 }
 
+static __always_inline u32 lz77_read32(const u32 *ptr)
+{
+	return get_unaligned(ptr);
+}
+
 static __always_inline u64 lz77_read64(const u64 *ptr)
 {
 	return get_unaligned(ptr);
@@ -50,14 +59,14 @@ static __always_inline void lz77_write32(u32 *ptr, u32 v)
 static __always_inline u32 lz77_match_len(const void *match, const void *cur, const void *end)
 {
 	const void *start = cur;
-	u64 diff;
 
 	/* Safe for a do/while because otherwise we wouldn't reach here from the main loop. */
 	do {
-		diff = lz77_read64(cur) ^ lz77_read64(match);
+		const u64 diff = lz77_read64(cur) ^ lz77_read64(match);
+
 		if (!diff) {
-			cur += LZ77_STEP_SIZE;
-			match += LZ77_STEP_SIZE;
+			cur += LZ77_MSTEP_SIZE;
+			match += LZ77_MSTEP_SIZE;
 
 			continue;
 		}
@@ -66,7 +75,7 @@ static __always_inline u32 lz77_match_len(const void *match, const void *cur, co
 		cur += count_trailing_zeros(diff) >> 3;
 
 		return (cur - start);
-	} while (likely(cur + LZ77_STEP_SIZE <= end));
+	} while (likely(cur + LZ77_MSTEP_SIZE <= end));
 
 	/* Fallback to byte-by-byte comparison for last <8 bytes. */
 	while (cur < end && lz77_read8(cur) == lz77_read8(match)) {
@@ -77,7 +86,7 @@ static __always_inline u32 lz77_match_len(const void *match, const void *cur, co
 	return (cur - start);
 }
 
-static __always_inline void *lz77_write_match(void *dst, void **nib, u32 dist, u32 len)
+static __always_inline void *lz77_encode_match(void *dst, void **nib, u16 dist, u32 len)
 {
 	len -= 3;
 	dist--;
@@ -131,94 +140,124 @@ static __always_inline void *lz77_write_match(void *dst, void **nib, u32 dist, u
 	return dst + 4;
 }
 
-noinline int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen)
+static __always_inline void *lz77_encode_literals(const void *start, const void *end, void *dst,
+						  long *f, u32 *fc, void **fp)
+{
+	if (start >= end)
+		return dst;
+
+	do {
+		const u32 len = umin(end - start, LZ77_FLAG_MAX - *fc);
+
+		memcpy(dst, start, len);
+
+		dst += len;
+		start += len;
+
+		*f <<= len;
+		*fc += len;
+		if (*fc == LZ77_FLAG_MAX) {
+			lz77_write32(*fp, *f);
+			*fc = 0;
+			*fp = dst;
+			dst += 4;
+		}
+	} while (start < end);
+
+	return dst;
+}
+
+static __always_inline u32 lz77_hash(const u32 v)
+{
+	return ((v ^ 0x9E3779B9) * 0x85EBCA6B) >> (32 - LZ77_HASH_LOG);
+}
+
+noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen)
 {
-	const void *srcp, *end;
+	const void *srcp, *rlim, *end, *anchor;
+	u32 *htable, hash, flag_count = 0;
 	void *dstp, *nib, *flag_pos;
-	u32 flag_count = 0;
 	long flag = 0;
-	u64 *htable;
 
 	/* This is probably a bug, so throw a warning. */
 	if (WARN_ON_ONCE(*dlen < lz77_compressed_alloc_size(slen)))
 		return -EINVAL;
 
-	srcp = src;
-	end = src + slen;
+	srcp = anchor = src;
+	end = srcp + slen; /* absolute end */
+	rlim = end - LZ77_MSTEP_SIZE; /* read limit (for lz77_match_len()) */
 	dstp = dst;
-	nib = NULL;
 	flag_pos = dstp;
 	dstp += 4;
+	nib = NULL;
 
 	htable = kvcalloc(LZ77_HASH_SIZE, sizeof(*htable), GFP_KERNEL);
 	if (!htable)
 		return -ENOMEM;
 
-	/* Main loop. */
-	do {
-		u32 dist, len = 0;
-		const void *wnd;
-		u64 hash;
-
-		hash = ((lz77_read64(srcp) << 24) * 889523592379ULL) >> (64 - LZ77_HASH_LOG);
-		wnd = src + htable[hash];
-		htable[hash] = srcp - src;
-		dist = srcp - wnd;
-
-		if (dist && dist < LZ77_MATCH_MAX_DIST)
-			len = lz77_match_len(wnd, srcp, end);
+	LZ77_PREFETCH(srcp + LZ77_RSTEP_SIZE);
 
-		if (len < LZ77_MATCH_MIN_LEN) {
-			lz77_write8(dstp, lz77_read8(srcp));
-
-			dstp++;
-			srcp++;
-
-			flag <<= 1;
-			flag_count++;
-			if (flag_count == 32) {
-				lz77_write32(flag_pos, flag);
-				flag_count = 0;
-				flag_pos = dstp;
-				dstp += 4;
-			}
-
-			continue;
-		}
+	hash = lz77_hash(lz77_read32(srcp++));
+	htable[hash] = 0;
+	hash = lz77_hash(lz77_read32(srcp));
 
-		dstp = lz77_write_match(dstp, &nib, dist, len);
+	/*
+	 * Main loop.
+	 *
+	 * @dlen is >= lz77_compressed_alloc_size(), so run without bound-checking @dstp.
+	 *
+	 * This code was crafted in a way to best utilise fetch-decode-execute CPU flow.
+	 * Any attempt to optimize it, or even organize it, can lead to huge performance loss.
+	 */
+	do {
+		const void *match, *next = srcp;
+		u32 len, step = 1, skip = 1U << LZ77_SKIP_TRIGGER;
+
+		/* Match finding (hot path -- don't change the read/check/write order). */
+		do {
+			const u32 cur_hash = hash;
+
+			srcp = next;
+			next += step;
+			step = (skip++ >> LZ77_SKIP_TRIGGER);
+			if (unlikely(next > rlim))
+				goto out;
+
+			hash = lz77_hash(lz77_read32(next));
+			match = src + htable[cur_hash];
+			htable[cur_hash] = srcp - src;
+		} while (likely(match + LZ77_MATCH_MAX_DIST < srcp) ||
+			 lz77_read32(match) != lz77_read32(srcp));
+
+		dstp = lz77_encode_literals(anchor, srcp, dstp, &flag, &flag_count, &flag_pos);
+		len = lz77_match_len(match, srcp, end);
+		dstp = lz77_encode_match(dstp, &nib, srcp - match, len);
 		srcp += len;
+		anchor = srcp;
+
+		LZ77_PREFETCH(srcp);
 
 		flag = (flag << 1) | 1;
 		flag_count++;
-		if (flag_count == 32) {
+		if (flag_count == LZ77_FLAG_MAX) {
 			lz77_write32(flag_pos, flag);
 			flag_count = 0;
 			flag_pos = dstp;
 			dstp += 4;
 		}
-	} while (likely(srcp + LZ77_STEP_SIZE <= end));
-
-	while (srcp < end) {
-		u32 c = umin(end - srcp, 32 - flag_count);
 
-		memcpy(dstp, srcp, c);
+		if (unlikely(srcp > rlim))
+			break;
 
-		dstp += c;
-		srcp += c;
-
-		flag <<= c;
-		flag_count += c;
-		if (flag_count == 32) {
-			lz77_write32(flag_pos, flag);
-			flag_count = 0;
-			flag_pos = dstp;
-			dstp += 4;
-		}
-	}
+		/* Prepare for next loop. */
+		hash = lz77_hash(lz77_read32(srcp));
+	} while (srcp < end);
+out:
+	dstp = lz77_encode_literals(anchor, end, dstp, &flag, &flag_count, &flag_pos);
 
-	flag <<= (32 - flag_count);
-	flag |= (1UL << (32 - flag_count)) - 1;
+	flag_count = LZ77_FLAG_MAX - flag_count;
+	flag <<= flag_count;
+	flag |= (1UL << flag_count) - 1;
 	lz77_write32(flag_pos, flag);
 
 	*dlen = dstp - dst;
diff --git a/fs/smb/client/compress/lz77.h b/fs/smb/client/compress/lz77.h
index 2603eab9e071..4e570846aefa 100644
--- a/fs/smb/client/compress/lz77.h
+++ b/fs/smb/client/compress/lz77.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (C) 2024, SUSE LLC
+ * Copyright (C) 2024-2026, SUSE LLC
  *
  * Authors: Enzo Matsumiya <ematsumiya@suse.de>
  *
@@ -39,5 +39,5 @@ static __always_inline u32 lz77_compressed_alloc_size(const u32 size)
 	return size + (size >> 3) + 8;
 }
 
-int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen);
+int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen);
 #endif /* _SMB_COMPRESS_LZ77_H */
-- 
2.53.0

