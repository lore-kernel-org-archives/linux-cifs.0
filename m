Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252B917753
	for <linux-cifs@vger.kernel.org>; Mon, 16 Sep 2024 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726504282; cv=none; b=d/68dudkbu1D5CacVSqFcw3QT0/dxEMvhLv9SIQCLC3XFmRyX4mLWYo9qxtsj0LygPvhPfYoYXzfoLrXcxDIuTLlW0oPKDXy2xU1f9WXYxrDWCB64qHYtyLNST1nw+IFBb6ovbDPnDwfOxwzheKqcVbnP1yuiwGnmiS3lNnIqZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726504282; c=relaxed/simple;
	bh=WITxlsylckl2ORoQeOBH/YLb23eYOZBk/FE4KKS0VF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oM/05kRG9VfmdqAYivn/KHxPwlyGm4YO5kEaAtsO+xjpBtM19iVmitjG+HFWPp6HqVeVKFfFnguuBj+pwmshvcT+mf2k629bvt3HrZ9fRjvdxbaTiozBhodE4wwvIilf6pzNzfAzsP4un6cwnKGwDcR4L67Zd5CV6rAcciituzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x8TU8mtB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NhfuZ8Vu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x8TU8mtB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NhfuZ8Vu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x8TU8mtB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NhfuZ8Vu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x8TU8mtB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NhfuZ8Vu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3957721C15;
	Mon, 16 Sep 2024 16:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726504278; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hhbzZhZfl2oTqHTz0b6ljJ1GmefTjQZUbbKN8w2Vkgk=;
	b=x8TU8mtB8ol3p7HJCZG0CBe96UjTAScqc48x9eR0WxLhYEULXC3yoMOWRIYu+lBJAFycXC
	txV2NnozeS+/2+sH036JbevkV+leLiLTwLhQKwvidAYHE5sp07vbak3TVSr207NxspdHZ5
	OSKx20xMbWHs1qE5xWMF0ay8MdPjfbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726504278;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hhbzZhZfl2oTqHTz0b6ljJ1GmefTjQZUbbKN8w2Vkgk=;
	b=NhfuZ8Vuq4sI+LCH2wb8rZ5geshzkBD1rNrwPX6OiK7p42AooBQ8IckG1q9OVTsl8S14It
	hDMnjHi3pjp4zUBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x8TU8mtB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NhfuZ8Vu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726504278; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hhbzZhZfl2oTqHTz0b6ljJ1GmefTjQZUbbKN8w2Vkgk=;
	b=x8TU8mtB8ol3p7HJCZG0CBe96UjTAScqc48x9eR0WxLhYEULXC3yoMOWRIYu+lBJAFycXC
	txV2NnozeS+/2+sH036JbevkV+leLiLTwLhQKwvidAYHE5sp07vbak3TVSr207NxspdHZ5
	OSKx20xMbWHs1qE5xWMF0ay8MdPjfbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726504278;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hhbzZhZfl2oTqHTz0b6ljJ1GmefTjQZUbbKN8w2Vkgk=;
	b=NhfuZ8Vuq4sI+LCH2wb8rZ5geshzkBD1rNrwPX6OiK7p42AooBQ8IckG1q9OVTsl8S14It
	hDMnjHi3pjp4zUBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC089139CE;
	Mon, 16 Sep 2024 16:31:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CZJIHFVd6GZQWgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 16 Sep 2024 16:31:17 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] smb: client: fix compression heuristic functions
Date: Mon, 16 Sep 2024 13:30:49 -0300
Message-ID: <20240916163049.287477-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3957721C15
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
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com,linaro.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

Change is_compressible() return type to bool, use WARN_ON_ONCE(1) for
internal errors and return false for those.

Renames:
check_repeated_data -> has_repeated_data
check_ascii_bytes -> is_mostly_ascii (also refactor into a single loop)
calc_shannon_entropy -> has_low_entropy

Also wraps "wreq->Length" in le32_to_cpu() in should_compress() (caught
by sparse).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/smb/client/compress.c | 105 ++++++++++++++++++++-------------------
 1 file changed, 55 insertions(+), 50 deletions(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 2c008e9f0206..63b5a55b7a57 100644
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
 
@@ -222,71 +219,79 @@ static int collect_sample(const struct iov_iter *iter, ssize_t max, u8 *sample)
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
+		return ret;
 
 	if (len - read_size > max)
 		len = max;
 
 	sample = kvzalloc(len, GFP_KERNEL);
-	if (!sample)
-		return -ENOMEM;
+	if (!sample) {
+		WARN_ON_ONCE(1);
+
+		return ret;
+	}
 
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
+		WARN_ON_ONCE(1);
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
@@ -305,7 +310,7 @@ bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
 	if (shdr->Command == SMB2_WRITE) {
 		const struct smb2_write_req *wreq = rq->rq_iov->iov_base;
 
-		if (wreq->Length < SMB_COMPRESS_MIN_LEN)
+		if (le32_to_cpu(wreq->Length) < SMB_COMPRESS_MIN_LEN)
 			return false;
 
 		return is_compressible(&rq->rq_iter);
-- 
2.46.0

