Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15663502A5
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 19:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577014; cv=none; b=qk6iwHB/w2TO/IPgYaeW5bAukdqrXMraUxAdiaaxkDro4lWxjVJhmKltPvDKDal1bXAADqJQF+xXRXj7y6cEUvxiQrNQkjKZedm6y+76JBoIqc5LO8SsV5Z0CGxbY726Vj9BbgCzy9IZaohbgpWB5qkqM0GfEC/r3OYWLzfIeXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577014; c=relaxed/simple;
	bh=+8PTN3sRymjtm3dGGGiQQfYe70fcjytE8fBQZtC5whM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/x9io+DrST08pfs20CCSUTzjAdmxelHDKdhd/69JjruKdDysLH+I06t9GI12KvYqNxZK3FN2c9ImPJD0YBvXajvcj+/US1+ZnRpseCHHJk1qReootzlVyA/R0EeP/p5x6HXNolDrAxLXyZDnaQUM03iuYP7sXd8zpE9wqailV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 94CCD7A183;
	Mon, 20 Jul 2026 19:50:07 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D271779AA;
	Mon, 20 Jul 2026 19:50:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9V/eNO57XmrFCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Jul 2026 19:50:06 +0000
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
Subject: [PATCH v2 10/14] smb: common: compress: smb_lz77_decompress() improvements
Date: Mon, 20 Jul 2026 16:49:21 -0300
Message-ID: <20260720194925.2108840-10-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720194925.2108840-1-ematsumiya@suse.de>
References: <20260720194925.2108840-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 94CCD7A183
X-Rspamd-Action: no action

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

Other:
- warn and return -EIO if decompressed buffer length != @dlen (a bug)

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/common/compress/lz77.c | 284 +++++++++++++++++++++++-----------
 1 file changed, 192 insertions(+), 92 deletions(-)

diff --git a/fs/smb/common/compress/lz77.c b/fs/smb/common/compress/lz77.c
index f88f49e01629..16b6f576a6f5 100644
--- a/fs/smb/common/compress/lz77.c
+++ b/fs/smb/common/compress/lz77.c
@@ -261,117 +261,217 @@ noinline int smb_lz77_compress(const void *src, const u32 slen, void *dst, u32 *
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
+/* @dlen is expected to be the _exact_ decompressed size of this payload, regardless of chaining */
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
+	const void *srcp = src, *end = src + slen, *nib = NULL;
+	void *dstp = dst, *dst_end = dst + dlen;
 
-		if (!(flags & 0x80000000)) {
-			if (sp >= send)
-				return -EINVAL;
-			*dp++ = *sp++;
-			flags <<= 1;
-			flag_count--;
-			continue;
-		}
+	while (srcp + SMB_COMPRESS_RSTEP_SIZE <= end) {
+		u32 flag, flag_count = LZ77_FLAG_MAX;
 
-		flags <<= 1;
-		flag_count--;
-
-		if (send - sp < 2)
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
 
-		token = mem_read16(sp);
-		sp += 2;
+		do {
+			u32 m = 0, l;
 
-		dist = (token >> 3) + 1;
-		if (dist > dp - (u8 *)dst)
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
+			 * - we can't rely on bit counting alone as bound-checking because the
+			 *   final flag in compressed payload might contain lots of 1s
+			 *   (((1 << (32 - @flag_count)) - 1), cf. smb_lz77_compress()).
+			 *
+			 * Also, matches can be encoded from 2 up to 10 bytes each, and since we
+			 * don't know the size of each match beforehand, we can't determine a
+			 * fixed limit, so we have to check @srcp limits before each match read.
+			 */
+			if (flag) {
+				m = flag < 0xFFFFFFFF ? __builtin_clz(~flag) : LZ77_FLAG_MAX;
+				flag_count -= m;
+				if (m < 32)
+					flag <<= m;
+				else
+					flag = 0;
+			}
 
-		if (lz77_decode_match_len(&sp, send, token, &nibble,
-					  &have_nibble, &len))
-			return -EINVAL;
+			l = flag ? umin(__builtin_clz(flag), flag_count) : flag_count;
+			flag_count -= l;
+			if (l < 32)
+				flag <<= l;
+			else
+				flag = 0;
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
+				if (unlikely(srcp + sizeof(u16) > end)) {
+					/* unexpected truncated input */
+					if (unlikely(srcp < end))
+						return -EFAULT;
+					goto out;
+				}
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
+				if (unlikely(len < 3 || len == U32_MAX || dst_end - dstp < len))
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
 
-		if (len > dend - dp)
-			return -EINVAL;
+			if (l) {
+				if (unlikely(end - srcp < l || dst_end - dstp < l))
+					return -EFAULT;
 
-		while (len--) {
-			*dp = *(dp - dist);
-			dp++;
-		}
+				memcpy(dstp, srcp, l);
+				srcp += l;
+				dstp += l;
+			}
+		} while (flag_count);
 	}
+out:
+	/*
+	 * @dstp > @dst_end is an OOB write (and should've been caught in the loop above).
+	 * @dstp < @dst_end, without any other decoding errors, might be:
+	 * - caller bug (wrong input arguments, e.g. wrong @src or @dlen)
+	 * - decoding bug (compressed buffer decodes fine (passes all checks), but parsed a bogus
+	 *   length value)
+	 */
+	if (WARN_ON_ONCE(dstp != dst_end))
+		return -EIO;
 
+	/*
+	 * We've now fully parsed the compressed buffer without any processing errors.
+	 * However, it's up to callers to determine the validity of @dst.
+	 */
 	return 0;
 }
 EXPORT_SYMBOL_GPL(smb_lz77_decompress);
-- 
2.54.0

