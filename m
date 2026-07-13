Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491C233A014
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 21:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979229; cv=none; b=mhTaphlb0g6w3Z1oE3c+Rw0jsZgwyyrS1Rw2jUb0kPHaaSVk4sOrh297s9h5T4dXpDspKPgWQoHp5/kTQ4oegEmEsO6JBNVt+FKwSw1R9JP1+BqOnkeORn8NSCi36Thy0OcJ2SOM16LAg5ceXasKmhO91ctRtrWqvjfY2O0xdPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979229; c=relaxed/simple;
	bh=SCt/6oUZWvyh1wHDshWr/3Qpq8SHHlW1GKCVTi7TnTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUikSIMhOJyvJ7si/HTOP/PTgnpGgpFs+X9BZ/v9HZgwDBSwuuooPKbLIJHTJr6QrdoXEJ2sJthpC8XwLf0hj+idsphHsS+kh7zlGOTaYR2ADrfE2y9CS61ylYyzzG8AevOcsvYku/cC+8uV8P/h4tjDXaYSyEipq79G5cLWiNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WcEIdRjP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2yR9G7oM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WcEIdRjP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2yR9G7oM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WcEIdRjP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2yR9G7oM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WcEIdRjP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2yR9G7oM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9C5F93E14;
	Mon, 13 Jul 2026 21:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fDK2LwBM8wiC8dptBfNOSyeeXPHuDS3t6FX++qoYqv0=;
	b=WcEIdRjPoqfJtfzxZFNxo1utgbdoGx4X7oN44vivLZgX/2wAy++igbe2WaYZOa7JmfJhEC
	VAwVesMUqXM8XBaN6uieEaVFbbS0UHmpA4rW4OyqRuAq6Dz/CsiNGx9gXTJ0D6eLIfQxBV
	Kd0MUCEDa3dBH2a68ArtAtsGW35XF3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979223;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fDK2LwBM8wiC8dptBfNOSyeeXPHuDS3t6FX++qoYqv0=;
	b=2yR9G7oMIAFyhKDosXOkRigRWrjvUKzzmGmNhNoQGU13xImFVZNLGDZfrGudtvIFP4QS7j
	+1DfQgRpe51LheDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fDK2LwBM8wiC8dptBfNOSyeeXPHuDS3t6FX++qoYqv0=;
	b=WcEIdRjPoqfJtfzxZFNxo1utgbdoGx4X7oN44vivLZgX/2wAy++igbe2WaYZOa7JmfJhEC
	VAwVesMUqXM8XBaN6uieEaVFbbS0UHmpA4rW4OyqRuAq6Dz/CsiNGx9gXTJ0D6eLIfQxBV
	Kd0MUCEDa3dBH2a68ArtAtsGW35XF3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979223;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fDK2LwBM8wiC8dptBfNOSyeeXPHuDS3t6FX++qoYqv0=;
	b=2yR9G7oMIAFyhKDosXOkRigRWrjvUKzzmGmNhNoQGU13xImFVZNLGDZfrGudtvIFP4QS7j
	+1DfQgRpe51LheDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2677D779AE;
	Mon, 13 Jul 2026 21:47:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m8CVN9ZcVWqPUQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Jul 2026 21:47:02 +0000
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
Subject: [PATCH 02/10] smb: client: compress: rework compression heuristics
Date: Mon, 13 Jul 2026 18:46:37 -0300
Message-ID: <20260713214645.550580-2-ematsumiya@suse.de>
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
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -2.80

- add enum with *COMPRESSIBLE values
- is_compressible() is now check_compressible(), and is called from
  smb_compress() instead of should_compress();  the latter only does
  the basic checks (write >= 4K)
- compressibility check now also may return 'MAYBE_COMPRESSIBLE',
  for cases when even with deeper analysis, it can't return a
  decisive result
- rewrite Shannon entropy computation (original code was copied over
  from btrfs, so it carelessly used their parameters)
- divide heuristics checks in stages:
  1. check if buffer is filled with same byte (RLE)
  2. check if partial RLE (first ~1% of buffer repeats same byte)
  3. check whole buffer entropy
  4. split buffer in 64k chunks and check entropy and byte distribution
     (based on hardcoded thresholds)
- remove collect_sample() and collect_step() helpers, heuristics checks
  are run on the entire buffer now
- remove calc_byte_distribution(), as it's a redundant entropy check

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress.c | 440 ++++++++++++++++++++++-----------------
 1 file changed, 244 insertions(+), 196 deletions(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 5591a8d85037..7c08e2b843c2 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2024, SUSE LLC
+ * Copyright (C) 2024-2026, SUSE LLC
  *
  * Authors: Enzo Matsumiya <ematsumiya@suse.de>
  *
@@ -24,242 +24,277 @@
 #include "../common/compress/compress.h"
 #include "compress.h"
 
-/*
- * The heuristic_*() functions below try to determine data compressibility.
+/**
+ * freq_count() - Count symbols (bytes) frequencies in a buffer.
+ * @buf:	uncompressed buffer
+ * @len:	size of @buf
+ * @mem:	(caller-allocated) auxiliary memory for parallel accumulators
+ * @count:	on exit, set to unique byte count (alphabet size) in @buf
  *
- * Derived from fs/btrfs/compression.c, changing coding style, some parameters, and removing
- * unused parts.
+ * This function counts all bytes' unique count and frequencies.
+ * Expect @mem to be 1024 * sizeof(u32) long and zeroed.
+ * Final frequencies will be stored on first 256 elements of @mem.
  *
- * Read that file for better and more detailed explanation of the calculations.
+ * Function is optimized for OoO CPUs (straightforward iterative count is about 2-3x slower).
  *
- * The algorithms are ran in a collected sample of the input (uncompressed) data.
- * The sample is formed of 2K reads in PAGE_SIZE intervals, with a maximum size of 4M.
+ * Return: max frequency found in @buf.
  *
- * Parsing the sample goes from "low-hanging fruits" (fastest algorithms, likely compressible)
- * to "need more analysis" (likely uncompressible).
+ * (*) This is an adapted version of FSE's https://github.com/Cyan4973/FiniteStateEntropy
  */
+static noinline u32 freq_count(const u8 *buf, const u32 len, u32 *mem, u32 *count)
+{
+	const u8 *p = buf, *end = p + len;
+	u32 c = 0, max_freq = 0;
+	u32 v = mem_read32(p);
+	u32 *acc1 = mem;
+	u32 *acc2 = acc1 + 256;
+	u32 *acc3 = acc2 + 256;
+	u32 *acc4 = acc3 + 256;
+
+	p += sizeof(u32);
+
+	/* Count by stripes of 16 bytes. */
+	while (p < end - 15) {
+		u32 cached = v;
+
+		v = mem_read32(p);
+		p += 4;
+		acc1[(u8)cached]++;
+		acc2[(u8)(cached>>8)]++;
+		acc3[(u8)(cached>>16)]++;
+		acc4[(u8)(cached>>24)]++;
+
+		cached = v;
+		v = mem_read32(p);
+		p += 4;
+		acc1[(u8)cached]++;
+		acc2[(u8)(cached>>8)]++;
+		acc3[(u8)(cached>>16)]++;
+		acc4[(u8)(cached>>24)]++;
+
+		cached = v;
+		v = mem_read32(p);
+		p += 4;
+		acc1[(u8)cached]++;
+		acc2[(u8)(cached>>8)]++;
+		acc3[(u8)(cached>>16)]++;
+		acc4[(u8)(cached>>24)]++;
+
+		cached = v;
+		v = mem_read32(p);
+		p += 4;
+		acc1[(u8)cached]++;
+		acc2[(u8)(cached>>8)]++;
+		acc3[(u8)(cached>>16)]++;
+		acc4[(u8)(cached>>24)]++;
+	}
 
-struct bucket {
-	unsigned int count;
-};
+	p -= 4;
+
+	/* Count lefotver symbols. */
+	while (p < end)
+		acc1[*p++]++;
+
+	/*
+	 * Combine accumulators + store.
+	 *
+	 * Avoid dereferencing @count here because performance.
+	 */
+	for (v = 0; v < 256; v++) {
+		acc1[v] += acc2[v] + acc3[v] + acc4[v];
+
+		if (acc1[v]) {
+			c++;
+			if (acc1[v] > max_freq)
+				max_freq = acc1[v];
+		}
+	}
 
-static inline size_t pow4(size_t n)
-{
-	return n * n * n * n;
+	if (count)
+		*count = c;
+
+	return max_freq;
 }
 
-/*
- * has_low_entropy() - Compute Shannon entropy of the sampled data.
- * @bkt:	Bytes counts of the sample.
- * @slen:	Size of the sample.
+/**
+ * calc_entropy() - Compute Shannon entropy of a sample symbols' frequencies.
+ * @freqs:	frequency counts of the sample
+ * @len:	size of the sample
+ * @scale:	scale for final result
  *
- * Return: true if the level (percentage of number of bits that would be required to
- *	   compress the data) is below the minimum threshold.
+ * @freqs may include zero freq symbols.
+ * The final sum is multiplied by @factor to fit callers' precision requirements.
  *
- * Note:
- * There _is_ an entropy level here that's > 65 (minimum threshold) that would indicate a
- * possibility of compression, but compressing, or even further analysing, it would waste so much
- * resources that it's simply not worth it.
+ * Valid results interpretation for @factor == 1:
+ *   < 6: definitely compressible
+ * 6 - 7: probably compressible, but needs other parameters/heuristics for decisive result
+ *   > 7: probably uncompressible -- other parameters/heuristics _might_ evaluate to "somewhat
+ *	  compressible", but usually not much
  *
- * Also Shannon entropy is the last computed heuristic; if we got this far and ended up
- * with uncertainty, just stay on the safe side and call it uncompressible.
+ * Return: approximate number of bits (scaled to @scale) per byte that would be required to
+ * compress the data.
  */
-static bool has_low_entropy(struct bucket *bkt, size_t slen)
+static __always_inline u32 calc_entropy(const u32 *freqs, const u32 len, const u32 scale)
 {
-	const size_t threshold = 65, max_entropy = 8 * ilog2(16);
-	size_t i, p, p2, len, sum = 0;
-
-	len = ilog2(pow4(slen));
+	const u32 len2 = ilog2(len);
+	size_t i, p, sum = 0;
 
-	for (i = 0; i < 256 && bkt[i].count > 0; i++) {
-		p = bkt[i].count;
-		p2 = ilog2(pow4(p));
-		sum += p * (len - p2);
+	for (i = 0; i < 256; i++) {
+		/* 0 freq won't skew the results (ilog2(n) also returns 0 if n < 2) */
+		p = freqs[i];
+		sum += p * (len2 - ilog2(p));
 	}
 
-	sum /= slen;
-
-	return ((sum * 100 / max_entropy) <= threshold);
+	return (sum * scale / len);
 }
 
-#define BYTE_DIST_BAD		0
-#define BYTE_DIST_GOOD		1
-#define BYTE_DIST_MAYBE		2
 /*
- * calc_byte_distribution() - Compute byte distribution on the sampled data.
- * @bkt:	Byte counts of the sample.
- * @slen:	Size of the sample.
- *
- * Return:
- * BYTE_DIST_BAD:	A "hard no" for compression -- a computed uniform distribution of
- *			the bytes (e.g. random or encrypted data).
- * BYTE_DIST_GOOD:	High probability (normal (Gaussian) distribution) of the data being
- *			compressible.
- * BYTE_DIST_MAYBE:	When computed byte distribution resulted in "low > n < high"
- *			grounds.  has_low_entropy() should be used for a final decision.
+ * Heuristic limit values.
+ * These are based on 64k blocks.
  */
-static int calc_byte_distribution(struct bucket *bkt, size_t slen)
-{
-	const size_t low = 64, high = 200, threshold = slen * 90 / 100;
-	size_t sum = 0;
-	int i;
-
-	for (i = 0; i < low; i++)
-		sum += bkt[i].count;
-
-	if (sum > threshold)
-		return BYTE_DIST_BAD;
-
-	for (; i < high && bkt[i].count > 0; i++) {
-		sum += bkt[i].count;
-		if (sum > threshold)
-			break;
-	}
-
-	if (i <= low)
-		return BYTE_DIST_GOOD;
-
-	if (i >= high)
-		return BYTE_DIST_BAD;
-
-	return BYTE_DIST_MAYBE;
-}
-
-static bool is_mostly_ascii(const struct bucket *bkt)
-{
-	size_t count = 0;
-	int i;
-
-	for (i = 0; i < 256; i++)
-		if (bkt[i].count > 0)
-			/* Too many non-ASCII (0-63) bytes. */
-			if (++count > 64)
-				return false;
-
-	return true;
-}
-
-static bool has_repeated_data(const u8 *sample, size_t len)
-{
-	size_t s = len / 2;
-
-	return (!memcmp(&sample[0], &sample[s], s));
-}
-
-static int cmp_bkt(const void *_a, const void *_b)
-{
-	const struct bucket *a = _a, *b = _b;
-
-	/* Reverse sort. */
-	if (a->count > b->count)
-		return -1;
-
-	return 1;
-}
+static const u32 heuristic_freq_hi	= 8000;
+static const u32 heuristic_freq_lo	= 5000;
+static const u32 heuristic_entropy_hi	= 800;
+static const u32 heuristic_entropy_mid	= 700;
+static const u32 heuristic_entropy_lo	= 600;
+static const u32 heuristic_alphabet_hi	= 256;
+static const u32 heuristic_alphabet_lo	= 128;
+
+enum {
+	UNCOMPRESSIBLE = 0,
+	COMPRESSIBLE,
+	MAYBE_COMPRESSIBLE,
+};
 
 /*
- * Collect some 2K samples with 2K gaps between.
+ * Computes entropy and byte dominance of @buf, on a 64k block basis.
+ *
+ * Return: one of the *COMPRESSIBLE values
  */
-static int collect_sample(const struct iov_iter *source, ssize_t max, u8 *sample)
+static int check_compressible_chunks(const u8 *buf, const u32 len, u32 *freqs)
 {
-	struct iov_iter iter = *source;
-	size_t s = 0;
-
-	while (iov_iter_count(&iter) >= SZ_2K) {
-		size_t part = umin(umin(iov_iter_count(&iter), SZ_2K), max);
-		size_t n;
-
-		n = copy_from_iter(sample + s, part, &iter);
-		if (n != part)
-			return -EFAULT;
+	int score = 0, boost = 0, n = 0;
+	const u32 freqs_size = 1024 * sizeof(u32);
+	const u32 max_samples = 64;
+	const u32 max_sample_len = (len / max_samples);
+	const u32 nsamples = umin(max_samples, len / max_sample_len);
+	const s32 half_samples = nsamples / 2;
+	const u8 *end = buf + len;
+
+	while (buf < end) {
+		u32 alphabet = 0;
+		const u32 remaining = end - buf;
+		const u32 slen = umin(max_sample_len, remaining);
+		const u32 max_freq = freq_count(buf, slen, freqs, &alphabet);
+		const u32 entropy = calc_entropy(freqs, slen, 100);
+
+		if (entropy < heuristic_entropy_mid && max_freq > heuristic_freq_hi)
+			score++;
+		else if (entropy >= heuristic_entropy_mid && max_freq < heuristic_freq_lo)
+			score--;
+
+		if (alphabet < heuristic_alphabet_hi) {
+			boost++;
+			if (alphabet < heuristic_alphabet_lo)
+				boost++;
+		}
+
+		/* Reward/penalty for really good/bad entropy. */
+		if (entropy > heuristic_entropy_hi)
+			boost -= 2;
+		else if (entropy < heuristic_entropy_lo)
+			boost += 2;
+
+		memset(freqs, 0, freqs_size);
+		buf += slen;
+		n++;
+	}
 
-		s += n;
-		max -= n;
+	/* Check how much the heuristics above impacted (at least) half of @buf. */
+	if (score + boost > 0 && score + boost < half_samples)
+		return MAYBE_COMPRESSIBLE;
 
-		if (iov_iter_count(&iter) < PAGE_SIZE - SZ_2K)
-			break;
+	if (score + boost > -half_samples) {
+		if (score > half_samples || score + boost > half_samples)
+			return COMPRESSIBLE;
 
-		iov_iter_advance(&iter, SZ_2K);
+		return MAYBE_COMPRESSIBLE;
 	}
 
-	return s;
+	return UNCOMPRESSIBLE;
 }
 
 /*
- * is_compressible() - Determines if a chunk of data is compressible.
- * @data: Iterator containing uncompressed data.
+ * Check @buf heuristics (entropy/distribution) to determine its compressibility level.
+ *
+ * Tests shows that this function is quite reliable in predicting data compressibility, matching
+ * very close with the behaviour of LZ77 compression success and failures.
  *
- * Return: true if @data is compressible, false otherwise.
+ * This function allocates memory, callers must check for -ENOMEM.
  *
- * Tests shows that this function is quite reliable in predicting data compressibility,
- * matching close to 1:1 with the behaviour of LZ77 compression success and failures.
+ * Return: one of the *COMPRESSIBLE values on success, -errno otherwise.
  */
-static bool is_compressible(const struct iov_iter *data)
+static __must_check int check_compressible(const u8 *buf, u32 len)
 {
-	const size_t read_size = SZ_2K, bkt_size = 256, max = SZ_4M;
-	struct bucket *bkt = NULL;
-	size_t len;
-	u8 *sample;
-	bool ret = false;
-	int i;
-
-	/* Preventive double check -- already checked in should_compress(). */
-	len = iov_iter_count(data);
-	if (unlikely(len < read_size))
-		return ret;
-
-	if (len - read_size > max)
-		len = max;
-
-	sample = kvzalloc(len, GFP_KERNEL);
-	if (!sample) {
-		WARN_ON_ONCE(1);
-
-		return ret;
-	}
-
-	/* Sample 2K bytes per page of the uncompressed data. */
-	i = collect_sample(data, len, sample);
-	if (i <= 0) {
-		WARN_ON_ONCE(1);
+	u32 entropy, *freqs, rle = 0, rle_boost = 0;
+	const u32 min_reps = (len / 100); /* ~1% of @len */
+	const u8 *p;
+	int ret;
 
-		goto out;
-	}
+	if (unlikely(!buf || !len))
+		return -EINVAL;
 
-	len = i;
-	ret = true;
+	/* Stage 1: RLE (@buf is filled with same byte, a.k.a Run-Length Encoding). */
+	p = memchr_inv(buf, *buf, len);
+	if (!p)
+		/* Full RLE */
+		return 1;
 
-	if (has_repeated_data(sample, len))
-		goto out;
+	/* Stage 2: partial/starting RLE (repeating bytes cover are at least @min_reps long). */
+	if (p - buf >= min_reps) {
+		rle = (p - buf);
 
-	bkt = kzalloc_objs(*bkt, bkt_size);
-	if (!bkt) {
-		WARN_ON_ONCE(1);
-		ret = false;
+		buf += rle;
+		len -= rle;
 
-		goto out;
+		rle_boost = rle >> (ilog2(len) - 1);
 	}
 
-	for (i = 0; i < len; i++)
-		bkt[sample[i]].count++;
-
-	if (is_mostly_ascii(bkt))
-		goto out;
-
-	/* Sort in descending order */
-	sort(bkt, bkt_size, sizeof(*bkt), cmp_bkt, NULL);
-
-	i = calc_byte_distribution(bkt, len);
-	if (i != BYTE_DIST_MAYBE) {
-		ret = !!i;
-
-		goto out;
+	freqs = kcalloc(1024, sizeof(*freqs), GFP_KERNEL);
+	if (!freqs)
+		return -ENOMEM;
+
+	/*
+	 * Stage 3: whole buffer entropy check (decisive results if too high or too low).
+	 *
+	 * Don't care about max freq or alphabet size here.
+	 */
+	(void)freq_count(buf, len, freqs, NULL);
+	entropy = calc_entropy(freqs, len, 1);
+	ret = MAYBE_COMPRESSIBLE;
+
+	if (entropy >= 8)
+		ret = UNCOMPRESSIBLE;
+	else if (entropy < 6 || (rle_boost && entropy - rle_boost <= 6) || len <= SZ_64K)
+		ret = COMPRESSIBLE;
+
+	if (ret == MAYBE_COMPRESSIBLE) {
+		memset(freqs, 0, sizeof(u32) * 1024);
+
+		/*
+		 * Stage 4: break down buffer into 64k chunks for more detailed analysis.
+		 *
+		 * Note that it's quite common to go from MAYBE_COMPRESSIBLE -> COMPRESSIBLE after
+		 * chunks analysis.
+		 *
+		 * OTOH, getting again MAYBE_COMPRESSIBLE really means 'uncompressible' for
+		 * compressors that focus on speed (e.g. LZ77).
+		 * Compressors focused on compression ratio might yield a good compression.
+		 */
+		ret = check_compressible_chunks(buf, len, freqs);
 	}
 
-	ret = has_low_entropy(bkt, len);
-out:
-	kvfree(sample);
-	kfree(bkt);
+	kfree(freqs);
 
 	return ret;
 }
@@ -275,7 +310,6 @@ static bool is_compressible(const struct iov_iter *data)
  * - server has enabled compression for the share
  * - it's a read or write request
  * - (write only) request length is >= SMB_COMPRESS_MIN_LEN
- * - (write only) is_compressible() returns 1
  *
  * Return false otherwise.
  */
@@ -295,10 +329,7 @@ bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
 	if (shdr->Command == SMB2_WRITE) {
 		const struct smb2_write_req *wreq = rq->rq_iov->iov_base;
 
-		if (le32_to_cpu(wreq->Length) < SMB_COMPRESS_MIN_LEN)
-			return false;
-
-		return is_compressible(&rq->rq_iter);
+		return (le32_to_cpu(wreq->Length) >= SMB_COMPRESS_MIN_LEN);
 	}
 
 	return (shdr->Command == SMB2_READ);
@@ -332,6 +363,23 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 		goto err_free;
 	}
 
+	/*
+	 * Even though smb_lz77_compress() runs quite fast on uncompressible data (it ends up
+	 * usually just parsing the input buffer), this is much faster.
+	 *
+	 * So to keep things balanced (compress performance vs prediction accuracy), let's drop the
+	 * uncompressible low-hanging fruits here and let smb_lz77_compress() handle the
+	 * exceptions/rare cases.
+	 */
+	ret = check_compressible(src, slen);
+
+	/* XXX: do something with MAYBE_COMPRESSIBLE */
+	if (ret != COMPRESSIBLE) {
+		if (ret >= 0)
+			ret = send_fn(server, 1, rq);
+		goto err_free;
+	}
+
 	dlen = smb_lz77_compressed_alloc_size(slen);
 	dst = kvzalloc(dlen, GFP_KERNEL);
 	if (!dst) {
-- 
2.54.0

