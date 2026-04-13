Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927C53451B2
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 19:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107288; cv=none; b=rvI9MWhiK+98Rsv9rnISZXry5SE/Nq0h3t+1Fp/Yl3hk9gmmwegpgNjPCwZZIlANY5E2kLz2BTVkeWkUtmBtqHdqWqtCKuteodZYpaP0aICWZH9kEDZr/1RMiwFHQT3kD62JfWnDn3BFJ4Ea1d81ZFWUBIaCDrljtl9KP9D5TYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107288; c=relaxed/simple;
	bh=V//V62Q2v+wajQ0OijbPU9FJ+No831yBSRazDncdWIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INumKuNOGT/wyPZMPNGN0A13MGjIuRg6AgYoVgMI/3P33ty68CexlJEBysRFEDDBFAZJbZnGiR3gzPeFPk5XjMsSvuET4s2U3siCDt8Rgb8ilh8MA23P/KrWgrX1NaCml2ToqxnoiCBz9Dm8m0fW4jtcDn/d/FuCuikr+lmD+WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=K+gKDnQo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/VQarDDb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=K+gKDnQo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/VQarDDb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="K+gKDnQo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/VQarDDb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="K+gKDnQo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/VQarDDb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8E5225BDAA;
	Mon, 13 Apr 2026 19:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Smgo8n6nEsF6d/RuoS+Juxc2vRq9LSJl8Ub74GO0wGU=;
	b=K+gKDnQobktkzre+vzqwHC1mp1zxOnOvxYMB/3zcKF6ZV+9LlVJC9R5SD4gtuhB2G/peFu
	4MIUcGZG1L8cA7ocirQChbfBPUHa16MPk23tFvRCYMJ9Wz2WFmyZ1tQYY6rXoKAG9fuJw/
	QKxviO2xJ33ZH6Lq4hmHiJ8SK0wfTf4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Smgo8n6nEsF6d/RuoS+Juxc2vRq9LSJl8Ub74GO0wGU=;
	b=/VQarDDbYPkueHPaqBKxoEslILgLCt9939jKFgqFG9I9OSFJrph1rmrZluGIs0st4ZjJaE
	JpjzsPtJlql9CrDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Smgo8n6nEsF6d/RuoS+Juxc2vRq9LSJl8Ub74GO0wGU=;
	b=K+gKDnQobktkzre+vzqwHC1mp1zxOnOvxYMB/3zcKF6ZV+9LlVJC9R5SD4gtuhB2G/peFu
	4MIUcGZG1L8cA7ocirQChbfBPUHa16MPk23tFvRCYMJ9Wz2WFmyZ1tQYY6rXoKAG9fuJw/
	QKxviO2xJ33ZH6Lq4hmHiJ8SK0wfTf4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Smgo8n6nEsF6d/RuoS+Juxc2vRq9LSJl8Ub74GO0wGU=;
	b=/VQarDDbYPkueHPaqBKxoEslILgLCt9939jKFgqFG9I9OSFJrph1rmrZluGIs0st4ZjJaE
	JpjzsPtJlql9CrDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12CF34B039;
	Mon, 13 Apr 2026 19:08:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iLYOMhE/3Wm9EAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Apr 2026 19:08:01 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 6/8] smb: client: compress: add code docs to lz77.c
Date: Mon, 13 Apr 2026 16:07:11 -0300
Message-ID: <20260413190713.283939-6-ematsumiya@suse.de>
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

Document parts of the code, especially the apparently
non-sense parts.

Other:
- change pointer increment constants to sizeof() values

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress/lz77.c | 81 +++++++++++++++++++++++++++++++----
 1 file changed, 73 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/client/compress/lz77.c
index 96744f52e364..7365d0f97396 100644
--- a/fs/smb/client/compress/lz77.c
+++ b/fs/smb/client/compress/lz77.c
@@ -15,6 +15,20 @@
 
 /*
  * Compression parameters.
+ *
+ * LZ77_MATCH_MAX_DIST:		Farthest back a match can be from current position (can be 1 - 8K).
+ * LZ77_HASH_LOG:
+ * LZ77_HASH_SIZE:		ilog2 hash size (recommended to be 13 - 18, default 15 (hash size
+ *				32k)).
+ * LZ77_RSTEP_SIZE:		Number of bytes to read from input buffer for hashing and initial
+ *				match check (default 4 bytes, this effectivelly makes this the min
+ *				match len).
+ * LZ77_MSTEP_SIZE:		Number of bytes to extend-compare a found match (default 8 bytes).
+ * LZ77_SKIP_TRIGGER:		ilog2 value for adaptive skipping, i.e. to progressively skip input
+ *				bytes when we can't find matches.  Default is 4.
+ *				Higher values (>0) will decrease compression time, but will result
+ *				in worse compression ratio.  Lower values will give better
+ *				compression ratio (more matches found), but will increase time.
  */
 #define LZ77_MATCH_MAX_DIST	SZ_8K
 #define LZ77_HASH_LOG		15
@@ -86,6 +100,19 @@ static __always_inline u32 lz77_match_len(const void *match, const void *cur, co
 	return (cur - start);
 }
 
+/**
+ * lz77_encode_match() - Match encoding.
+ * @dst:	compressed buffer
+ * @nib:	pointer to an address in @dst
+ * @dist:	match distance
+ * @len:	match length
+ *
+ * Assumes all args were previously checked.
+ *
+ * Return: @dst advanced to new position
+ *
+ * Ref: MS-XCA 2.3.4 "Plain LZ77 Compression Algorithm Details" - "Processing"
+ */
 static __always_inline void *lz77_encode_match(void *dst, void **nib, u16 dist, u32 len)
 {
 	len -= 3;
@@ -95,12 +122,12 @@ static __always_inline void *lz77_encode_match(void *dst, void **nib, u16 dist,
 	if (len < 7) {
 		lz77_write16(dst, dist + len);
 
-		return dst + 2;
+		return dst + sizeof(u16);
 	}
 
 	dist |= 7;
 	lz77_write16(dst, dist);
-	dst += 2;
+	dst += sizeof(u16);
 	len -= 7;
 
 	if (!*nib) {
@@ -130,16 +157,32 @@ static __always_inline void *lz77_encode_match(void *dst, void **nib, u16 dist,
 	if (len <= 0xffff) {
 		lz77_write16(dst, len);
 
-		return dst + 2;
+		return dst + sizeof(u16);
 	}
 
 	lz77_write16(dst, 0);
-	dst += 2;
+	dst += sizeof(u16);
 	lz77_write32(dst, len);
 
-	return dst + 4;
+	return dst + sizeof(u32);
 }
 
+/**
+ * lz77_encode_literals() - Literals encoding.
+ * @start:	where to start copying literals (uncompressed buffer)
+ * @end:	when to stop copying (uncompressed buffer)
+ * @dst:	compressed buffer
+ * @f:		pointer to current flag value
+ * @fc:		pointer to current flag count
+ * @fp:		pointer to current flag address
+ *
+ * Batch copy literals from @start to @dst, updating flag values accordingly.
+ * Assumes all args were previously checked.
+ *
+ * Return: @dst advanced to new position
+ *
+ * MS-XCA 2.3.4 "Plain LZ77 Compression Algorithm Details" - "Processing"
+ */
 static __always_inline void *lz77_encode_literals(const void *start, const void *end, void *dst,
 						  long *f, u32 *fc, void **fp)
 {
@@ -160,7 +203,7 @@ static __always_inline void *lz77_encode_literals(const void *start, const void
 			lz77_write32(*fp, *f);
 			*fc = 0;
 			*fp = dst;
-			dst += 4;
+			dst += sizeof(u32);
 		}
 	} while (start < end);
 
@@ -188,7 +231,7 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 	rlim = end - LZ77_MSTEP_SIZE; /* read limit (for lz77_match_len()) */
 	dstp = dst;
 	flag_pos = dstp;
-	dstp += 4;
+	dstp += sizeof(u32);
 	nib = NULL;
 
 	htable = kvcalloc(LZ77_HASH_SIZE, sizeof(*htable), GFP_KERNEL);
@@ -197,6 +240,10 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 
 	LZ77_PREFETCH(srcp + LZ77_RSTEP_SIZE);
 
+	/*
+	 * Adjust @srcp so we don't get a false positive match on first iteration.
+	 * Then prepare hash for first loop iteration (don't advance @srcp again).
+	 */
 	hash = lz77_hash(lz77_read32(srcp++));
 	htable[hash] = 0;
 	hash = lz77_hash(lz77_read32(srcp));
@@ -219,6 +266,14 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 
 			srcp = next;
 			next += step;
+
+			/*
+			 * Adaptive skipping.
+			 *
+			 * Increment @step every (1 << LZ77_SKIP_TRIGGER, 16 in our case) bytes
+			 * without a match.
+			 * Reset to 1 when a match is found.
+			 */
 			step = (skip++ >> LZ77_SKIP_TRIGGER);
 			if (unlikely(next > rlim))
 				goto out;
@@ -229,6 +284,16 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 		} while (likely(match + LZ77_MATCH_MAX_DIST < srcp) ||
 			 lz77_read32(match) != lz77_read32(srcp));
 
+		/*
+		 * Match found.  Warm/cold path; begin parsing @srcp and writing to @dstp:
+		 * - flush literals
+		 * - compute match length (*)
+		 * - encode match
+		 *
+		 * (*) Current minimum match length is defined by the memory read size above, so
+		 * here we already know that we have 4 matching bytes, but it's just faster to
+		 * redundantly compute it again in lz77_match_len() than to adjust pointers/len.
+		 */
 		dstp = lz77_encode_literals(anchor, srcp, dstp, &flag, &flag_count, &flag_pos);
 		len = lz77_match_len(match, srcp, end);
 		dstp = lz77_encode_match(dstp, &nib, srcp - match, len);
@@ -243,7 +308,7 @@ noinline int lz77_compress(const void *src, const u32 slen, void *dst, u32 *dlen
 			lz77_write32(flag_pos, flag);
 			flag_count = 0;
 			flag_pos = dstp;
-			dstp += 4;
+			dstp += sizeof(u32);
 		}
 
 		if (unlikely(srcp > rlim))
-- 
2.53.0

