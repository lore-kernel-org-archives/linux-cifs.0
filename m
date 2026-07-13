Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A6B3242B2
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 21:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979250; cv=none; b=PpW57UTWJgFJYSi+zUV54o46NKocaPNMMlde67JzqSSbiBYtrq9zPr2PT0EPpSyHxwTwD6xaB+hV9sH87NTNZAL/jHKjcNR830RG/ifPX6o4Z5tlcp1/nnuAXYBLO3OQfBsWWsFPYmN7Cc+flh74dzooH6vxULfgDAeHCWsWmos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979250; c=relaxed/simple;
	bh=zzBAY8ZcWD9QMrkBHfCrnDaOXZYQxCj3Q0IbLh0l8/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPgJBhPXptYqAYknPLx8jMLdrMlOsLWmw+GdQ+mzdLMQZty5M0how+WLWaX9wXRzNzbB8GNIXnaHG02WsWvHloqlizEtIM7NnrvoBJVyYoHBHtJ/6p8v8c2+7wpG0NgLdRAsUXstMQ9WqoVurZSZqM38kKitVOb8m+F8BvsAywE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QC4y8dBU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wABreweK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QC4y8dBU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wABreweK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QC4y8dBU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wABreweK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QC4y8dBU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wABreweK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D9D63E13;
	Mon, 13 Jul 2026 21:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vdLwUx53unSv23QxoC0mHCSBipj/lXO3bB0rLtwVu8k=;
	b=QC4y8dBUnuHPVVeOa9AqWOiAvbffnZ7uRxL4258qAF9+Nb8qvTbO58r9PUauh+datAxkq4
	+5sQ7yniXdnCETIvks+nvl7FUJeSKoJip1067FVlr3mILR7Sv/tKXP4Szg0LCwGD+ksa/d
	LsvFljsrxsQBwUo4KRy7KZC3jNL/Le8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979247;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vdLwUx53unSv23QxoC0mHCSBipj/lXO3bB0rLtwVu8k=;
	b=wABreweKFWc+MOqOC8uzy2SyhVGDkEt42y0fo1Q/uTtCP9lFwQNCKHg0ts2ceCqGpNCOgD
	1MTd0Z6fJI8NaZCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QC4y8dBU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wABreweK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vdLwUx53unSv23QxoC0mHCSBipj/lXO3bB0rLtwVu8k=;
	b=QC4y8dBUnuHPVVeOa9AqWOiAvbffnZ7uRxL4258qAF9+Nb8qvTbO58r9PUauh+datAxkq4
	+5sQ7yniXdnCETIvks+nvl7FUJeSKoJip1067FVlr3mILR7Sv/tKXP4Szg0LCwGD+ksa/d
	LsvFljsrxsQBwUo4KRy7KZC3jNL/Le8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979247;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vdLwUx53unSv23QxoC0mHCSBipj/lXO3bB0rLtwVu8k=;
	b=wABreweKFWc+MOqOC8uzy2SyhVGDkEt42y0fo1Q/uTtCP9lFwQNCKHg0ts2ceCqGpNCOgD
	1MTd0Z6fJI8NaZCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DCBC9779AE;
	Mon, 13 Jul 2026 21:47:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E913KO5cVWq3UQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Jul 2026 21:47:26 +0000
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
Subject: [PATCH 07/10] smb: common: compress: smb_lz77_decompress() improvements
Date: Mon, 13 Jul 2026 18:46:42 -0300
Message-ID: <20260713214645.550580-7-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260713214645.550580-1-ematsumiya@suse.de>
References: <20260713214645.550580-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5D9D63E13
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

LZ77 decompression performance improvements:
- make use of mem_read*() helpers for faster unaligned reads in x86
- change lz77_decode_match_len() to return a pointer as it advances
  (instead of dereferencing @src every time to update it, which is
   costlier)
  - also use a pointer for nib position instead of 2 separate args
    (@nibble and @have_nibble)
- decode flags in batches instead of one by one, e.g. a 00001111 flag
  is read only once now, with decoding operations in sequence
  (saves a few operations on back-and-forth reading/parsing)
- use memcpy() when copying non-overlapping memory (faster and a much
  more common case)

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/common/compress/lz77.c | 272 ++++++++++++++++++++++------------
 1 file changed, 178 insertions(+), 94 deletions(-)

diff --git a/fs/smb/common/compress/lz77.c b/fs/smb/common/compress/lz77.c
index f88f49e01629..f86c13736e34 100644
--- a/fs/smb/common/compress/lz77.c
+++ b/fs/smb/common/compress/lz77.c
@@ -261,117 +261,201 @@ noinline int smb_lz77_compress(const void *src, const u32 slen, void *dst, u32 *
 }
 EXPORT_SYMBOL_GPL(smb_lz77_compress);
 
-static int lz77_decode_match_len(const u8 **src, const u8 *end, u16 token,
-				 u8 *nibble, bool *have_nibble, u32 *len)
+static __always_inline const void *lz77_decode_match_len(const void *src, const void *end,
+							 const void **nib, u32 *len)
 {
-	u8 extra;
-
-	*len = (token & 0x7) + 3;
-	if ((token & 0x7) != 0x7)
-		return 0;
-
-	if (!*have_nibble) {
-		if (*src >= end)
-			return -EINVAL;
-		*nibble = *(*src)++;
-		extra = *nibble & 0xf;
-		*have_nibble = true;
-	} else {
-		extra = *nibble >> 4;
-		*have_nibble = false;
-	}
-
-	*len += extra;
-	if (extra == 0xf) {
-		u8 b;
+	u32 mlen = *len & 7;
 
-		if (*src >= end)
-			return -EINVAL;
-		b = *(*src)++;
-		if (b != 0xff) {
-			*len += b;
+	/*
+	 * *@len points to the initial match length decoded.
+	 * We'll keep checking + decoding further if extra bits/bytes were used to encode larger
+	 * lengths.
+	 *
+	 * Since we're reading from @src itself, this means any OOB read is an error
+	 * (bug, malformed payload, etc).
+	 */
+	if (mlen == 7) {
+		if (!*nib) {
+			*nib = src;
+			if (unlikely(src >= end))
+				return NULL;
+
+			mlen = mem_read8(src) & 15;
+			src++;
 		} else {
-			u16 w;
-
-			if (end - *src < 2)
-				return -EINVAL;
-			w = mem_read16(*src);
-			*src += 2;
-			if (w) {
-				*len = w + 3;
-			} else {
-				u32 long_len;
-
-				if (end - *src < 4)
-					return -EINVAL;
-				long_len = mem_read32(*src);
-				*src += 4;
-				if (check_add_overflow(long_len, 3, len))
-					return -EINVAL;
+			mlen = mem_read8(*nib) >> 4;
+			*nib = NULL;
+		}
+
+		if (mlen == 15) {
+			if (unlikely(src >= end))
+				return NULL;
+
+			mlen = mem_read8(src);
+			src++;
+
+			if (mlen == 255) {
+				if (unlikely(src + sizeof(u16) > end))
+					return NULL;
+
+				mlen = mem_read16(src);
+				src += sizeof(u16);
+
+				if (mlen == 0) {
+					if (unlikely(src + sizeof(u32) > end))
+						return NULL;
+
+					mlen = mem_read32(src);
+					src += sizeof(u32);
+				}
+
+				/* Unexpected match len < 15 + 7 (decoding bug) */
+				if (unlikely(mlen < 23))
+					return NULL;
+
+				mlen -= (15 + 7);
 			}
+			mlen += 15;
 		}
+		mlen += 7;
 	}
+	mlen += 3;
+	*len = mlen;
 
-	return 0;
+	return src;
 }
 
-int smb_lz77_decompress(const void *src, const u32 slen, void *dst,
-			const u32 dlen)
+noinline int smb_lz77_decompress(const void *src, const u32 slen, void *dst, const u32 dlen)
 {
-	const u8 *sp = src, *send = sp + slen;
-	u8 *dp = dst, *dend = dp + dlen;
-	u32 flags = 0;
-	int flag_count = 0;
-	u8 nibble = 0;
-	bool have_nibble = false;
-
-	while (dp < dend) {
-		u32 len, dist;
-		u16 token;
-
-		if (!flag_count) {
-			if (send - sp < 4)
-				return -EINVAL;
-			flags = mem_read32(sp);
-			sp += 4;
-			flag_count = 32;
-		}
-
-		if (!(flags & 0x80000000)) {
-			if (sp >= send)
-				return -EINVAL;
-			*dp++ = *sp++;
-			flags <<= 1;
-			flag_count--;
-			continue;
-		}
+	const void *srcp, *end, *nib = NULL;
+	void *dstp, *dst_end;
 
-		flags <<= 1;
-		flag_count--;
-
-		if (send - sp < 2)
-			return -EINVAL;
+	srcp = src;
+	end = srcp + slen;
+	dstp = dst;
+	dst_end = dstp + dlen;
 
-		token = mem_read16(sp);
-		sp += 2;
+	do {
+		u32 flag, flag_count = LZ77_FLAG_MAX;
 
-		dist = (token >> 3) + 1;
-		if (dist > dp - (u8 *)dst)
-			return -EINVAL;
+		/*
+		 * Read flag.
+		 *
+		 * LZ77 flags are 32-bit bitmaps where 0s indicates a literal in the stream
+		 * (straight copied from @srcp to @dstp) and 1s indicates a match (decoded from
+		 * @srcp).
+		 *
+		 * Compressed payloads always starts with a flag.
+		 */
+		flag = mem_read32(srcp);
+		srcp += SMB_COMPRESS_RSTEP_SIZE;
 
-		if (lz77_decode_match_len(&sp, send, token, &nibble,
-					  &have_nibble, &len))
-			return -EINVAL;
+		do {
+			u32 m, l;
 
-		if (len > dend - dp)
-			return -EINVAL;
+			/*
+			 * Decode flag.
+			 *
+			 * Each bit in @flag represents a literal (0) or a match (1).
+			 * Instead of processing them as individual bits, do it in batches:
+			 *   (@m matches, @l literals)
+			 *
+			 * Count leading zeroes for that (flip @flag bits to compute matches).
+			 *
+			 * Notes:
+			 * - @flag == 0 means we're are bound by @flag_count literals
+			 * - __builtin_clz() yields UB if arg is 0
+			 * - unlike smb_lz77_compress(), we don't use a 'long' flag here because
+			 *   of CLZ (in order to avoid extra math (sizeof(long) == 8))
+			 * - we can't rely on bit counting alone as bound-checking because the
+			 *   final flag in compressed payload might contain lots of 1s
+			 *   (((1 << (32 - @flag_count)) - 1), cf. smb_lz77_compress()).
+			 *
+			 * Also, matches can be encoded from 2 up to 10 bytes each, and since we
+			 * don't know the size of each match beforehand, we can't determine a
+			 * fixed limit, so we have to check @srcp limits before each match read.
+			 */
+			m = flag ? __builtin_clz(~flag) : 0;
+			flag_count -= m;
+			flag <<= m;
+
+			l = flag ? umin(__builtin_clz(flag), flag_count) : flag_count;
+			flag_count -= l;
+			flag <<= l;
+
+			/* Decoding bug (or, unlikely, __builtin_clz() bug) */
+			if (WARN_ON_ONCE(l + m > LZ77_FLAG_MAX))
+				return -EIO;
+
+			while (m--) {
+				const void *match;
+				u32 dist, len;
+
+				/*
+				 * Final flag done (not a bug).
+				 *
+				 * Note that even if we reached here (@m wasn't 0), we can't rely
+				 * on that value alone as a "true match flag counter" because of
+				 * how the last flag is encoded (cf. smb_lz77_compress()).
+				 */
+				if (unlikely(srcp + sizeof(u16) > end))
+					goto out;
+
+				/* Store match symbol in @len */
+				len = mem_read16(srcp);
+				srcp += sizeof(u16);
+				dist = (len >> 3) + 1;
+				srcp = lz77_decode_match_len(srcp, end, &nib, &len);
+				if (unlikely(!srcp))
+					return -EFAULT;
+
+				/*
+				 * Check bogus match values.
+				 *
+				 * We don't know what compression parameters (e.g. match max dist,
+				 * min len) the server is using, so check against limits allowed
+				 * by spec.
+				 *
+				 * Also check if within @dst boundaries so we can do a straight
+				 * copy.
+				 */
+				if (unlikely(!dist || dist > SZ_8K || dstp - dst < dist))
+					return -EFAULT;
+
+				if (unlikely(len < 3 || len == U32_MAX || dstp + len > dst_end))
+					return -EFAULT;
+
+				/*
+				 * If non-overlapping memory, we can use memcpy() (common case).
+				 * Otherwise, we have to do it byte by byte.
+				 *
+				 * Note @match is always behind @dstp (@dist is at least 1).
+				 */
+				match = dstp - dist;
+				if (likely(len < dist)) {
+					memcpy(dstp, match, len);
+					dstp += len;
+				} else {
+					while (len--)
+						mem_write8(dstp++, mem_read8(match++));
+				}
+			}
 
-		while (len--) {
-			*dp = *(dp - dist);
-			dp++;
-		}
-	}
+			if (l) {
+				if (unlikely(srcp + l > end || dstp + l > dst_end))
+					return -EFAULT;
 
+				memcpy(dstp, srcp, l);
+				srcp += l;
+				dstp += l;
+			}
+		} while (flag_count);
+	} while (srcp + SMB_COMPRESS_RSTEP_SIZE <= end);
+out:
+	/*
+	 * We've now fully parsed the compressed buffer without any processing errors.
+	 * However, it's up to callers to determine the validity of @dst.
+	 */
 	return 0;
 }
 EXPORT_SYMBOL_GPL(smb_lz77_decompress);
-- 
2.54.0

