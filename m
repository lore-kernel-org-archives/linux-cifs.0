Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E851C5781
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 14:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726671517; cv=none; b=bP8K09gQuKUYTR2qkE8yTMA9jKsrsb+rz1JgycXU3PbZaQISRE2nneX+voF9W1ExXRuki2LdAuXwE3oaQqpi1hh+tmMAGReBZuyFy3E+9T3wO9naUc90DQoK2GgOPm4EHWcaGMtE+UyQBfI7tBeWa5WwzjYdBMoQjYdTkAJlfV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726671517; c=relaxed/simple;
	bh=EjWueMhIkKPV+UDwTSlWLt7o7SDFs4hRE1QEXPHlDmU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SGY8mOASjDazLy9VKFw3WpGrdt3fccZjLe4se/ff5uesxpLT7sDc21OGRQoi4KsGv/gReJP+isgOXnjsX1XLBr0d1f9QVI0qQNG6CHQeHhiVX10uRbuQd0mIXzNPU3sbWb8aIWEgJnHfU1hMGgqQLv+qkxwDnz8wD4548zDwQjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aSLg/s1D; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JTYACS5l; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aSLg/s1D; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JTYACS5l; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aSLg/s1D";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JTYACS5l";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aSLg/s1D";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JTYACS5l"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 75C7420506;
	Wed, 18 Sep 2024 14:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726671513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wq+vIQOlEnx7DK83Y6YeEHvgEZRHHyromqT5u8TkMqg=;
	b=aSLg/s1DxCEBohjpkuMDD+pXCaZIkCodUYMYWTcbhDvaM9hgsaMT9F/vZkl57z9EjCQJ2P
	nrCP8Td0IGv1Cnxh/NsZeXATl+nGfRC0X5gEudzXu6LmEJ5ICtn6CPSTXBa+Z0mKpkh4Jo
	XOEtHoUORHmukkAYgAUcecBi9T2g7Hk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726671513;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wq+vIQOlEnx7DK83Y6YeEHvgEZRHHyromqT5u8TkMqg=;
	b=JTYACS5lDdAqACrFILJ6lsmqO653EpyUgBreuPToOxQ4QIH/juZgEw927lcBiziSpJXLf+
	2N5Qcs/s3qu28LDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="aSLg/s1D";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JTYACS5l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726671513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wq+vIQOlEnx7DK83Y6YeEHvgEZRHHyromqT5u8TkMqg=;
	b=aSLg/s1DxCEBohjpkuMDD+pXCaZIkCodUYMYWTcbhDvaM9hgsaMT9F/vZkl57z9EjCQJ2P
	nrCP8Td0IGv1Cnxh/NsZeXATl+nGfRC0X5gEudzXu6LmEJ5ICtn6CPSTXBa+Z0mKpkh4Jo
	XOEtHoUORHmukkAYgAUcecBi9T2g7Hk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726671513;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wq+vIQOlEnx7DK83Y6YeEHvgEZRHHyromqT5u8TkMqg=;
	b=JTYACS5lDdAqACrFILJ6lsmqO653EpyUgBreuPToOxQ4QIH/juZgEw927lcBiziSpJXLf+
	2N5Qcs/s3qu28LDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E25CE13A57;
	Wed, 18 Sep 2024 14:58:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E2A1Kpjq6mayVAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 18 Sep 2024 14:58:32 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2] smb: client: fix compression heuristic functions
Date: Wed, 18 Sep 2024 11:58:34 -0300
Message-ID: <20240918145834.750247-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 75C7420506
X-Spam-Level: 
X-Spamd-Result: default: False [-5.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com,linaro.org];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -5.01
X-Spam-Flag: NO

Change is_compressible() return type to bool, use WARN_ON_ONCE(1) for
some internal errors and return false for those.

Renames:
check_repeated_data -> has_repeated_data
check_ascii_bytes -> is_mostly_ascii (also refactor into a single loop)
calc_shannon_entropy -> has_low_entropy

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
Changes from v1:
- remove WARN_ON_ONCE from memory allocation failures checks
- return 'false' explicitly for memory allocation failures
- move sparse warning fix about le32_to_cpu to a separate patch

 fs/smb/client/compress.c | 97 ++++++++++++++++++++--------------------
 1 file changed, 49 insertions(+), 48 deletions(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 2c008e9f0206..baaa6a470f53 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -45,7 +45,7 @@ struct bucket {
 };
 
 /**
- * calc_shannon_entropy() - Compute Shannon entropy of the sampled data.
+ * has_low_entropy() - Compute Shannon entropy of the sampled data.
  * @bkt:	Bytes counts of the sample.
  * @slen:	Size of the sample.
  *
@@ -60,7 +60,7 @@ struct bucket {
  * Also Shannon entropy is the last computed heuristic; if we got this far and ended up
  * with uncertainty, just stay on the safe side and call it uncompressible.
  */
-static bool calc_shannon_entropy(struct bucket *bkt, size_t slen)
+static bool has_low_entropy(struct bucket *bkt, size_t slen)
 {
 	const size_t threshold = 65, max_entropy = 8 * ilog2(16);
 	size_t i, p, p2, len, sum = 0;
@@ -79,17 +79,21 @@ static bool calc_shannon_entropy(struct bucket *bkt, size_t slen)
 	return ((sum * 100 / max_entropy) <= threshold);
 }
 
+#define BYTE_DIST_BAD		0
+#define BYTE_DIST_GOOD		1
+#define BYTE_DIST_MAYBE		2
 /**
  * calc_byte_distribution() - Compute byte distribution on the sampled data.
  * @bkt:	Byte counts of the sample.
  * @slen:	Size of the sample.
  *
  * Return:
- * 1:	High probability (normal (Gaussian) distribution) of the data being compressible.
- * 0:	A "hard no" for compression -- either a computed uniform distribution of the bytes (e.g.
- *	random or encrypted data), or calc_shannon_entropy() returned false (see above).
- * 2:	When computed byte distribution resulted in "low > n < high" grounds.
- *	calc_shannon_entropy() should be used for a final decision.
+ * BYTE_DIST_BAD:	A "hard no" for compression -- a computed uniform distribution of
+ *			the bytes (e.g. random or encrypted data).
+ * BYTE_DIST_GOOD:	High probability (normal (Gaussian) distribution) of the data being
+ *			compressible.
+ * BYTE_DIST_MAYBE:	When computed byte distribution resulted in "low > n < high"
+ *			grounds.  has_low_entropy() should be used for a final decision.
  */
 static int calc_byte_distribution(struct bucket *bkt, size_t slen)
 {
@@ -101,7 +105,7 @@ static int calc_byte_distribution(struct bucket *bkt, size_t slen)
 		sum += bkt[i].count;
 
 	if (sum > threshold)
-		return i;
+		return BYTE_DIST_BAD;
 
 	for (; i < high && bkt[i].count > 0; i++) {
 		sum += bkt[i].count;
@@ -110,36 +114,29 @@ static int calc_byte_distribution(struct bucket *bkt, size_t slen)
 	}
 
 	if (i <= low)
-		return 1;
+		return BYTE_DIST_GOOD;
 
 	if (i >= high)
-		return 0;
+		return BYTE_DIST_BAD;
 
-	return 2;
+	return BYTE_DIST_MAYBE;
 }
 
-static bool check_ascii_bytes(const struct bucket *bkt)
+static bool is_mostly_ascii(const struct bucket *bkt)
 {
-	const size_t threshold = 64;
 	size_t count = 0;
 	int i;
 
-	for (i = 0; i < threshold; i++)
+	for (i = 0; i < 256; i++)
 		if (bkt[i].count > 0)
-			count++;
+			/* Too many non-ASCII (0-63) bytes. */
+			if (++count > 64)
+				return false;
 
-	for (; i < 256; i++) {
-		if (bkt[i].count > 0) {
-			count++;
-			if (count > threshold)
-				break;
-		}
-	}
-
-	return (count < threshold);
+	return true;
 }
 
-static bool check_repeated_data(const u8 *sample, size_t len)
+static bool has_repeated_data(const u8 *sample, size_t len)
 {
 	size_t s = len / 2;
 
@@ -222,71 +219,75 @@ static int collect_sample(const struct iov_iter *iter, ssize_t max, u8 *sample)
  * is_compressible() - Determines if a chunk of data is compressible.
  * @data: Iterator containing uncompressed data.
  *
- * Return:
- * 0:		@data is not compressible
- * 1:		@data is compressible
- * -ENOMEM:	failed to allocate memory for sample buffer
+ * Return: true if @data is compressible, false otherwise.
  *
  * Tests shows that this function is quite reliable in predicting data compressibility,
  * matching close to 1:1 with the behaviour of LZ77 compression success and failures.
  */
-static int is_compressible(const struct iov_iter *data)
+static bool is_compressible(const struct iov_iter *data)
 {
 	const size_t read_size = SZ_2K, bkt_size = 256, max = SZ_4M;
 	struct bucket *bkt = NULL;
-	int i = 0, ret = 0;
 	size_t len;
 	u8 *sample;
+	bool ret = false;
+	int i;
 
+	/* Preventive double check -- already checked in should_compress(). */
 	len = iov_iter_count(data);
-	if (len < read_size)
-		return 0;
+	if (unlikely(len < read_size))
+		return false;
 
 	if (len - read_size > max)
 		len = max;
 
 	sample = kvzalloc(len, GFP_KERNEL);
 	if (!sample)
-		return -ENOMEM;
+		return false;
 
 	/* Sample 2K bytes per page of the uncompressed data. */
-	ret = collect_sample(data, len, sample);
-	if (ret < 0)
+	i = collect_sample(data, len, sample);
+	if (i <= 0) {
+		WARN_ON_ONCE(1);
+
 		goto out;
+	}
 
-	len = ret;
-	ret = 1;
+	len = i;
+	ret = true;
 
-	if (check_repeated_data(sample, len))
+	if (has_repeated_data(sample, len))
 		goto out;
 
 	bkt = kcalloc(bkt_size, sizeof(*bkt), GFP_KERNEL);
 	if (!bkt) {
-		kvfree(sample);
-		return -ENOMEM;
+		ret = false;
+
+		goto out;
 	}
 
 	for (i = 0; i < len; i++)
 		bkt[sample[i]].count++;
 
-	if (check_ascii_bytes(bkt))
+	if (is_mostly_ascii(bkt))
 		goto out;
 
 	/* Sort in descending order */
 	sort(bkt, bkt_size, sizeof(*bkt), cmp_bkt, NULL);
 
-	ret = calc_byte_distribution(bkt, len);
-	if (ret != 2)
+	i = calc_byte_distribution(bkt, len);
+	if (i != BYTE_DIST_MAYBE) {
+		ret = !!i;
+
 		goto out;
+	}
 
-	ret = calc_shannon_entropy(bkt, len);
+	ret = has_low_entropy(bkt, len);
 out:
 	kvfree(sample);
 	kfree(bkt);
 
-	WARN(ret < 0, "%s: ret=%d\n", __func__, ret);
-
-	return !!ret;
+	return ret;
 }
 
 bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
-- 
2.46.0

