Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947FD38B7BC
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 19:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107250; cv=none; b=VnFRJqCWVPkHXCqXqfGeG9OQk01P5kOgPBATgEBqd+8oXJz098oHs/oZo1FbOqWHIB2r8zjgGkd8kLpFZ5mh1CdSxzk0MwP9HlnLv7fV6f4MoROYAKNy1WVmJrBohw3nw77n6RMKnQAYdMTBFaagTBoPI/lolaCKGUY15SgTGzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107250; c=relaxed/simple;
	bh=j91SzjZ2g9OpHX3ROrRd/Y6k480sxPDbnrwKL41AW+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dq2Kb9sSxvcdPRTOpr+cXNeQ5XFLy+bcoYgn6Pt/AWkpISE1dQwCVD3f5lFmq4+AZOrkFGs4Y9RMNhx4h22AwTsCjvYZqRdz3bX574Lq4IYz860Pf8EKrxxCWEMvgaPFf60XKUR4dlfaACI0AXqtMovmazSvvPZDxQM4bMIe4KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MUuNso+B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mOmE7m5I; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MUuNso+B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mOmE7m5I; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MUuNso+B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mOmE7m5I";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MUuNso+B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mOmE7m5I"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB1B36A8B4;
	Mon, 13 Apr 2026 19:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iNOE1chA0D7Yhs9M0bldWcMEAIZ98RbaBTci4JlK7oE=;
	b=MUuNso+BerNr2ufYtfVNj/3AxjTE9DMJxNDvoLGVh4hhQVkzGC43dgy6jAih2aoZPxKHPW
	UewrkRqdvwEaETIhuJVu3tBUY9hty8w9UkuLkL8r9ysIH7V0ZIKo/T/nKos9tZ863W2PeC
	OJcn7hrf50T2p95+BtAT2J3Rbib6eY4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iNOE1chA0D7Yhs9M0bldWcMEAIZ98RbaBTci4JlK7oE=;
	b=mOmE7m5IuAU3D8p16zB2pb0Q3kBwjzc/rerUFqabGu8uB8/K21ZIaw/9ggSEesrRNzwtSl
	7ZHiim+g4IKGzkDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iNOE1chA0D7Yhs9M0bldWcMEAIZ98RbaBTci4JlK7oE=;
	b=MUuNso+BerNr2ufYtfVNj/3AxjTE9DMJxNDvoLGVh4hhQVkzGC43dgy6jAih2aoZPxKHPW
	UewrkRqdvwEaETIhuJVu3tBUY9hty8w9UkuLkL8r9ysIH7V0ZIKo/T/nKos9tZ863W2PeC
	OJcn7hrf50T2p95+BtAT2J3Rbib6eY4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iNOE1chA0D7Yhs9M0bldWcMEAIZ98RbaBTci4JlK7oE=;
	b=mOmE7m5IuAU3D8p16zB2pb0Q3kBwjzc/rerUFqabGu8uB8/K21ZIaw/9ggSEesrRNzwtSl
	7ZHiim+g4IKGzkDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52A004B038;
	Mon, 13 Apr 2026 19:07:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QS4YBu4+3WkXEAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Apr 2026 19:07:26 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 1/8] smb: client: compress: fix buffer overrun in lz77_compress()
Date: Mon, 13 Apr 2026 16:07:06 -0300
Message-ID: <20260413190713.283939-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
X-Spam-Score: -2.80
X-Spam-Level: 

@dst buffer is allocated with same size as @src, which, for good
compression cases, works fine.

However, when compression goes bad (e.g. random bytes payloads), the
compressed size can increase significantly, and even by stopping the
main loop at 7/8 of @slen, writing leftover literals could write past
the end of @dst because of LZ77 metadata.

To fix this, add lz77_compressed_alloc_size() helper to compute the
correct allocation size for @dst, accounting for metadata and worst
cast scenario (all literals).

While this is overprovisioning memory, it's not only correct, but also
allows lz77_compress() main loop to run without ever checking @dst
limits (i.e. a perf improvement).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress.c      |  6 +-----
 fs/smb/client/compress/lz77.c | 14 ++++----------
 fs/smb/client/compress/lz77.h | 28 ++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 3d1e73f5d9af..be9023f841e6 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -329,11 +329,7 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 		goto err_free;
 	}
 
-	/*
-	 * This is just overprovisioning, as the algorithm will error out if @dst reaches 7/8
-	 * of @slen.
-	 */
-	dlen = slen;
+	dlen = lz77_compressed_alloc_size(slen);
 	dst = kvzalloc(dlen, GFP_KERNEL);
 	if (!dst) {
 		ret = -ENOMEM;
diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/client/compress/lz77.c
index 96e8a8057a77..16c7d8f3ef17 100644
--- a/fs/smb/client/compress/lz77.c
+++ b/fs/smb/client/compress/lz77.c
@@ -137,6 +137,10 @@ noinline int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen)
 	long flag = 0;
 	u64 *htable;
 
+	/* This is probably a bug, so throw a warning. */
+	if (WARN_ON_ONCE(*dlen < lz77_compressed_alloc_size(slen)))
+		return -EINVAL;
+
 	srcp = src;
 	end = src + slen;
 	dstp = dst;
@@ -180,15 +184,6 @@ noinline int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen)
 			continue;
 		}
 
-		/*
-		 * Bail out if @dstp reached >= 7/8 of @slen -- already compressed badly, not worth
-		 * going further.
-		 */
-		if (unlikely(dstp - dst >= slen - (slen >> 3))) {
-			*dlen = slen;
-			goto out;
-		}
-
 		dstp = lz77_write_match(dstp, &nib, dist, len);
 		srcp += len;
 
@@ -225,7 +220,6 @@ noinline int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen)
 	lz77_write32(flag_pos, flag);
 
 	*dlen = dstp - dst;
-out:
 	kvfree(htable);
 
 	if (*dlen < slen)
diff --git a/fs/smb/client/compress/lz77.h b/fs/smb/client/compress/lz77.h
index cdcb191b48a2..2603eab9e071 100644
--- a/fs/smb/client/compress/lz77.h
+++ b/fs/smb/client/compress/lz77.h
@@ -11,5 +11,33 @@
 
 #include <linux/kernel.h>
 
+/**
+ * lz77_compressed_alloc_size() - Compute compressed buffer size.
+ * @size:	uncompressed (src) size
+ *
+ * Compute allocation size for the compressed buffer based on uncompressed size.
+ * Accounts for metadata and overprovision for the worst case scenario.
+ *
+ * LZ77 metadata is a 4-byte flag that is written:
+ * - on dst begin (pos 0)
+ * - every 32 literals or matches
+ * - on end-of-stream (possibly, if last write was another flag)
+ *
+ * Worst case scenario is an all-literal compression, which means:
+ * metadata bytes = 4 + ((@size / 32) * 4) + 4, or, simplified, (@size >> 3) + 8
+ *
+ * The worst case scenario rarely happens, but such overprovisioning also allows lz77_compress()
+ * main loop to run without ever bound checking dst, which is a huge perf improvement, while also
+ * being safe when compression goes bad.
+ *
+ * Return: required (*) allocation size for compressed buffer.
+ *
+ * (*) checked once in the beginning of lz77_compress()
+ */
+static __always_inline u32 lz77_compressed_alloc_size(const u32 size)
+{
+	return size + (size >> 3) + 8;
+}
+
 int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen);
 #endif /* _SMB_COMPRESS_LZ77_H */
-- 
2.53.0

