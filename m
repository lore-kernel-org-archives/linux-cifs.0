Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DEB3242B2
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 21:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979255; cv=none; b=ORMXJmWGjf8t0O8N3TFjMUlOXYRjVEszW+V1FeCNmAWsK4gidLn8kQz+DBe1z8Diylv2/W8Plt0uUYPBuD2nFXDOwL6OTO3ybQk5GNy7XHImLGxvZRYVIq8q7p+1gqqQ2oJcGqeGqmBsS3u5mGvINLiROKbPb9Fjidt6Txp32zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979255; c=relaxed/simple;
	bh=SwEAtUhr4KkcSFoMkGx/1aaMLxGZJ0sKZf+2vyR2jLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZ8QZzeR8NhNhPhu9It17GBubBngwurc2QVB7Hsazh4RVA1oG9TjEmZfouS8CWYhLRtUX1TqLkKiSmOtEfrXrB54LQYGWxCgyVgap3lNOMIuYtvrzAOQFP0wpol/XMhgkPQrRHm+i/mOjWoNfOsdW/kRu3BFBKa4d9PLKdx4nIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XZwRCCrh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=h2dn07Ll; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XZwRCCrh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=h2dn07Ll; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XZwRCCrh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="h2dn07Ll";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XZwRCCrh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="h2dn07Ll"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C787477AD6;
	Mon, 13 Jul 2026 21:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rGXXaL9nyZN1ft2BzJl8tywiMgwS5RQQJpVQGrgSw9k=;
	b=XZwRCCrh8GJeKtK/Czy4BZLDMjLJhcnG/WAhyHFpVzjvdGcXENV77qK1Zu3wSJn52M+S0g
	72hjIH3IbuEsJct2/mVcI7SWwQiZ2mn5MSWDgWO4cvcbsZT9oYqveo/IxaIJrRAg4udQc7
	vKMGf19taiQdKvp3IWZXBu1n/fWdyiM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979250;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rGXXaL9nyZN1ft2BzJl8tywiMgwS5RQQJpVQGrgSw9k=;
	b=h2dn07Ll7W6m22c2h0zmJ3kbS/M/CGjCjLyxYA9Fk0/zaoS+42lZdKTUxs1mscGr5fA0NB
	tP8yKORF7Ew0pUCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rGXXaL9nyZN1ft2BzJl8tywiMgwS5RQQJpVQGrgSw9k=;
	b=XZwRCCrh8GJeKtK/Czy4BZLDMjLJhcnG/WAhyHFpVzjvdGcXENV77qK1Zu3wSJn52M+S0g
	72hjIH3IbuEsJct2/mVcI7SWwQiZ2mn5MSWDgWO4cvcbsZT9oYqveo/IxaIJrRAg4udQc7
	vKMGf19taiQdKvp3IWZXBu1n/fWdyiM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979250;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rGXXaL9nyZN1ft2BzJl8tywiMgwS5RQQJpVQGrgSw9k=;
	b=h2dn07Ll7W6m22c2h0zmJ3kbS/M/CGjCjLyxYA9Fk0/zaoS+42lZdKTUxs1mscGr5fA0NB
	tP8yKORF7Ew0pUCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 162BC779AE;
	Mon, 13 Jul 2026 21:47:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8FQwM/FcVWq9UQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Jul 2026 21:47:29 +0000
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
Subject: [PATCH 08/10] smb: common: compress: implement LZ77-Huffman
Date: Mon, 13 Jul 2026 18:46:43 -0300
Message-ID: <20260713214645.550580-8-ematsumiya@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	R_RATELIMIT(0.00)[to_ip_from(RLkmoi5kqpkgjx3hbiagnu7sfh)];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -2.80

Implement LZ77-Huffman compression algorithm as per MS-XCA.

Huffman encoding adds a few extra passes on top of LZ77-style encoding
in order to provide better compression ratio (at bit level rather than
byte level).

Refer to MS-XCA spec or code/comments in huffman.* for details.

Changes:
- add huffman.{h,c} with implementation
- adjust server/ and client/ code to support new alg
- compress.c::smb_compression_add_lz77():
  rename it to smb_compression_add_lz() and it now takes an @alg arg,
  so it handles both LZ77 and LZ77-Huffman (which are handled the same
  way in that regard)
- compress.h::smb_compress_alloc_size(): add @lzalg arg to account for
  LZ77-Huffman allocation requirements
- rename smb_decompress_lz77_payload() to smb_decompress_lz_payload() so
  it now handles both LZ77 plain and Huffman variants (handled the same
  way), it also now takes an @alg argument to determine which one to use
- add LZ77-Huffman to smb_compress_alg_valid()

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress.c          |  20 +-
 fs/smb/client/smb2pdu.c           |  22 +-
 fs/smb/common/Makefile            |   2 +-
 fs/smb/common/compress/compress.c |  55 +-
 fs/smb/common/compress/compress.h |  23 +-
 fs/smb/common/compress/huffman.c  | 877 ++++++++++++++++++++++++++++++
 fs/smb/common/compress/huffman.h  |  26 +
 fs/smb/server/compress.c          |   9 +-
 fs/smb/server/smb2pdu.c           |  27 +-
 9 files changed, 1011 insertions(+), 50 deletions(-)
 create mode 100644 fs/smb/common/compress/huffman.c
 create mode 100644 fs/smb/common/compress/huffman.h

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index d94bacf3edbd..76a44ce49261 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -227,14 +227,16 @@ static int check_compressible_chunks(const u8 *buf, const u32 len, u32 *freqs)
 /*
  * Check @buf heuristics (entropy/distribution) to determine its compressibility level.
  *
+ * If @maybe_ok is false, alias MAYBE_COMPRESSIBLE to UNCOMPRESSIBLE.
+ *
  * Tests shows that this function is quite reliable in predicting data compressibility, matching
- * very close with the behaviour of LZ77 compression success and failures.
+ * very close with the behaviour of LZ* compression success and failures.
  *
  * This function allocates memory, callers must check for -ENOMEM.
  *
  * Return: one of the *COMPRESSIBLE values on success, -errno otherwise.
  */
-static __must_check int check_compressible(const u8 *buf, u32 len)
+static __must_check int check_compressible(const u8 *buf, u32 len, bool maybe_ok)
 {
 	u32 entropy, *freqs, rle = 0, rle_boost = 0;
 	const u32 min_reps = (len / 100); /* ~1% of @len */
@@ -296,6 +298,9 @@ static __must_check int check_compressible(const u8 *buf, u32 len)
 
 	kfree(freqs);
 
+	if (!maybe_ok && ret == MAYBE_COMPRESSIBLE)
+		ret = UNCOMPRESSIBLE;
+
 	return ret;
 }
 
@@ -340,6 +345,7 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 	struct iov_iter iter;
 	u32 slen, dlen, shdr_len;
 	void *src, *dst = NULL;
+	__le16 lzalg;
 	bool use_pattern;
 	int ret;
 
@@ -349,6 +355,10 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 	if (rq->rq_iov->iov_len != sizeof(struct smb2_write_req))
 		return -EINVAL;
 
+	lzalg = server->compression.alg;
+	if (unlikely(!smb_compress_alg_valid(lzalg, false)))
+		return -EINVAL;
+
 	slen = iov_iter_count(&rq->rq_iter);
 	src = kvzalloc(slen, GFP_KERNEL);
 	if (!src) {
@@ -372,7 +382,7 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 	 * uncompressible low-hanging fruits here and let smb_lz77_compress() handle the
 	 * exceptions/rare cases.
 	 */
-	ret = check_compressible(src, slen);
+	ret = check_compressible(src, slen, lzalg == SMB3_COMPRESS_LZ77_HUFF);
 
 	/* XXX: do something with MAYBE_COMPRESSIBLE */
 	if (ret != COMPRESSIBLE) {
@@ -383,14 +393,14 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 
 	use_pattern = server->compression.pattern;
 	shdr_len = rq->rq_iov[0].iov_len;
-	dlen = smb_compress_alloc_size(slen, use_pattern) + shdr_len;
+	dlen = smb_compress_alloc_size(slen, use_pattern, lzalg) + shdr_len;
 	dst = kvzalloc(dlen, GFP_KERNEL);
 	if (!dst) {
 		ret = -ENOMEM;
 		goto err_free;
 	}
 
-	ret = smb_compression_compress(SMB3_COMPRESS_LZ77, server->compression.chained, use_pattern,
+	ret = smb_compression_compress(lzalg, server->compression.chained, use_pattern,
 				       src, slen, dst, &dlen, rq->rq_iov[0].iov_base, shdr_len);
 	if (!ret && dlen < slen) {
 		struct smb_rqst comp_rq = { .rq_nvec = 1, };
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 41cdc9f5e692..ba2c601f290e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -44,6 +44,7 @@
 #include "cached_dir.h"
 #include "compress.h"
 #include "fs_context.h"
+#include "../common/compress/compress.h"
 
 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -859,14 +860,25 @@ static void decode_compress_ctx(struct TCP_Server_Info *server,
 	}
 
 	for (i = 0; i < count; i++) {
-		/* Record the intersection supported by the shared SMB codec. */
-		if (ctxt->CompressionAlgorithms[i] == SMB3_COMPRESS_LZ77)
-			server->compression.alg = SMB3_COMPRESS_LZ77;
-		else if (ctxt->CompressionAlgorithms[i] == SMB3_COMPRESS_PATTERN)
+		__le16 alg = ctxt->CompressionAlgorithms[i];
+
+		/*
+		 * Servers only return 1 LZ* algorithm, or + Pattern_V1 if chained.
+		 * server->compression.alg only tracks LZ* algs.
+		 */
+		if (alg == SMB3_COMPRESS_PATTERN)
 			server->compression.pattern = true;
+		else if (smb_compress_alg_valid(alg, false))
+			server->compression.alg = alg;
+		else
+			pr_warn_once("invalid compression algorithm '0x%04x'\n", le16_to_cpu(alg));
 	}
-	if (server->compression.alg != SMB3_COMPRESS_LZ77)
+
+	if (!server->compression.alg) {
+		memset(&server->compression, 0, sizeof(server->compression));
+		pr_warn_once("no LZ compression algorithm negotiated\n");
 		return;
+	}
 
 	/*
 	 * Pattern_V1 cannot appear in an unchained transform even if a broken
diff --git a/fs/smb/common/Makefile b/fs/smb/common/Makefile
index f2c6e09d4e77..35368807da76 100644
--- a/fs/smb/common/Makefile
+++ b/fs/smb/common/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_SMBFS) += cifs_md4.o
 obj-$(CONFIG_SMBFS) += smb_compress.o
 
-smb_compress-y := compress/compress.o compress/lz77.o
+smb_compress-y := compress/compress.o compress/lz77.o compress/huffman.o
diff --git a/fs/smb/common/compress/compress.c b/fs/smb/common/compress/compress.c
index 9f87d31e9986..b3aab089b7a3 100644
--- a/fs/smb/common/compress/compress.c
+++ b/fs/smb/common/compress/compress.c
@@ -56,11 +56,11 @@ static int smb_decompress_pattern(const u8 **src, u32 *slen, u8 **dst,
 }
 
 /*
- * LZ77 payload Length includes the four-byte OriginalPayloadSize field.
+ * LZ* payload Length includes the four-byte OriginalPayloadSize field.
  * Consume that field before passing the compressed stream to the raw codec.
  */
-static int smb_decompress_lz77_payload(const u8 **src, u32 *slen, u8 **dst,
-				       u32 *dlen, u32 len)
+static int smb_decompress_lz_payload(const u8 **src, u32 *slen, u8 **dst,
+				     u32 *dlen, u32 len, __le16 alg)
 {
 	u32 orig_size;
 	int rc;
@@ -76,7 +76,11 @@ static int smb_decompress_lz77_payload(const u8 **src, u32 *slen, u8 **dst,
 	*slen -= sizeof(__le32);
 	len -= sizeof(__le32);
 
-	rc = smb_lz77_decompress(*src, len, *dst, orig_size);
+	rc = -EINVAL;
+	if (alg == SMB3_COMPRESS_LZ77)
+		rc = smb_lz77_decompress(*src, len, *dst, orig_size);
+	else if (alg == SMB3_COMPRESS_LZ77_HUFF)
+		rc = smb_huff_decompress(*src, len, *dst, orig_size);
 	if (rc)
 		return rc;
 
@@ -132,17 +136,17 @@ static int smb_decompress_chained(__le16 alg, bool allow_chained,
 		src += SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
 		remaining -= SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
 
+		rc = -EINVAL;
 		if (payload_alg == SMB3_COMPRESS_NONE) {
 			rc = smb_decompress_none(&src, &remaining, &out,
 						 &out_remaining, len);
 		} else if (payload_alg == SMB3_COMPRESS_PATTERN) {
 			rc = smb_decompress_pattern(&src, &remaining, &out,
 						    &out_remaining, len);
-		} else if (payload_alg == alg && alg == SMB3_COMPRESS_LZ77) {
-			rc = smb_decompress_lz77_payload(&src, &remaining, &out,
-							 &out_remaining, len);
 		} else {
-			return -EINVAL;
+			/* payload_alg is validated by the function below */
+			rc = smb_decompress_lz_payload(&src, &remaining, &out,
+						       &out_remaining, len, payload_alg);
 		}
 		if (rc)
 			return rc;
@@ -170,7 +174,15 @@ static int smb_decompress_unchained(__le16 alg,
 
 	memcpy(dst, (const u8 *)hdr + sizeof(*hdr), offset);
 	comp_size = slen - sizeof(*hdr) - offset;
-	return smb_lz77_decompress((const u8 *)hdr + sizeof(*hdr) + offset,
+
+	if (alg == SMB3_COMPRESS_LZ77)
+		return smb_lz77_decompress((const u8 *)hdr + sizeof(*hdr) + offset,
+					   comp_size, (u8 *)dst + offset, orig_size);
+
+	if (WARN_ON_ONCE(alg != SMB3_COMPRESS_LZ77_HUFF))
+		return -EINVAL;
+
+	return smb_huff_decompress((const u8 *)hdr + sizeof(*hdr) + offset,
 				   comp_size, (u8 *)dst + offset, orig_size);
 }
 
@@ -195,8 +207,7 @@ int smb_compression_decompress(__le16 alg, bool allow_chained,
 	const struct smb2_compression_hdr *hdr = src;
 
 	if (!src || !dst || slen < sizeof(*hdr) ||
-	    hdr->ProtocolId != SMB2_COMPRESSION_TRANSFORM_ID ||
-	    alg == SMB3_COMPRESS_NONE)
+	    hdr->ProtocolId != SMB2_COMPRESSION_TRANSFORM_ID)
 		return -EINVAL;
 
 	if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED))
@@ -275,8 +286,8 @@ static int smb_compression_add_none(struct smb_compression_builder *builder,
 	return 0;
 }
 
-static int smb_compression_add_lz77(struct smb_compression_builder *builder,
-				    const u8 *src, u32 len, bool chained)
+static int smb_compression_add_lz(struct smb_compression_builder *builder, const u8 *src, u32 len,
+				  __le16 alg, bool chained)
 {
 	struct smb2_compression_payload_hdr *payload;
 	u32 comp_len;
@@ -288,13 +299,16 @@ static int smb_compression_add_lz77(struct smb_compression_builder *builder,
 	comp_len = builder->remaining;
 	if (chained) {
 		comp_len -= sizeof(*payload);
-		payload = smb_compression_add_payload(builder, SMB3_COMPRESS_LZ77,
-						      comp_len, true);
+		payload = smb_compression_add_payload(builder, alg, comp_len, true);
 		if (!payload)
 			return -ENOSPC;
 	}
 
-	rc = smb_lz77_compress(src, len, builder->pos, &comp_len);
+	rc = -EIO;
+	if (alg == SMB3_COMPRESS_LZ77)
+		rc = smb_lz77_compress(src, len, builder->pos, &comp_len);
+	else if (alg == SMB3_COMPRESS_LZ77_HUFF)
+		rc = smb_huff_compress(src, len, builder->pos, &comp_len);
 	if (rc)
 		return rc;
 
@@ -344,8 +358,8 @@ int smb_compression_compress(__le16 alg, bool chained, bool allow_pattern,
 	u32 forward = 0, backward = 0, middle_len;
 	int rc;
 
-	if (!src || !dst || !dlen || alg != SMB3_COMPRESS_LZ77 ||
-	    *dlen <= SMB2_COMPRESSION_CHAINED_HDR_LEN || !slen)
+	if (!src || !dst || !dlen || *dlen <= SMB2_COMPRESSION_CHAINED_HDR_LEN || !slen ||
+	    !smb_compress_alg_valid(alg, false))
 		return -EINVAL;
 
 	/* Note that the below is a bug, but (chained && !allow_pattern) is a valid combination */
@@ -406,10 +420,9 @@ int smb_compression_compress(__le16 alg, bool chained, bool allow_pattern,
 	rc = 0;
 	middle_len = slen - forward - backward;
 	if (middle_len > 1024 || !chained)
-		rc = smb_compression_add_lz77(&builder, input + forward, middle_len, chained);
+		rc = smb_compression_add_lz(&builder, input + forward, middle_len, alg, chained);
 	else if (middle_len && chained)
-		rc = smb_compression_add_none(&builder,
-					      input + forward, middle_len);
+		rc = smb_compression_add_none(&builder, input + forward, middle_len);
 	if (rc)
 		return rc;
 
diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
index e1fad498d567..93be0ad732f2 100644
--- a/fs/smb/common/compress/compress.h
+++ b/fs/smb/common/compress/compress.h
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 
 #include "../smb2pdu.h"
+#include "huffman.h"
 #include "lz77.h"
 
 #define SMB2_COMPRESSION_CHAINED_HDR_LEN \
@@ -139,16 +140,23 @@ static __always_inline u32 smb_compress_hash_ptr(const void *ptr)
  */
 static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
 {
-	if (alg == SMB3_COMPRESS_NONE)
+	switch (alg) {
+	case SMB3_COMPRESS_NONE:
 		return valid_none;
+	case SMB3_COMPRESS_LZ77:
+	case SMB3_COMPRESS_LZ77_HUFF:
+	case SMB3_COMPRESS_PATTERN:
+		return true;
+	}
 
-	return alg == SMB3_COMPRESS_LZ77 || alg == SMB3_COMPRESS_PATTERN;
+	return false;
 }
 
 /**
  * smb_compress_alloc_size() - Compute total allocation size required for compressed (dst) buffer.
  * @size:		uncompressed size
  * @use_pattern:	if Pattern_V1 is enabled
+ * @lzalg:		LZ* algorithm that will be used
  *
  * For any case:
  * - SMB2 compression hdr
@@ -161,11 +169,16 @@ static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
  *
  * (possible uncompressed leftovers are included in LZ alloc size)
  */
-static __always_inline u32 smb_compress_alloc_size(const u32 size, const bool use_pattern)
+static __always_inline u32 smb_compress_alloc_size(const u32 size, const bool use_pattern,
+						   const __le16 lzalg)
 {
-	u32 alloc_size;
+	u32 alloc_size = sizeof(struct smb2_compression_hdr);
+
+	if (lzalg == SMB3_COMPRESS_LZ77)
+		alloc_size += smb_lz77_compressed_alloc_size(size);
+	else if (lzalg == SMB3_COMPRESS_LZ77_HUFF)
+		alloc_size += smb_huff_compressed_alloc_size(size);
 
-	alloc_size = sizeof(struct smb2_compression_hdr) + smb_lz77_compressed_alloc_size(size);
 	if (use_pattern)
 		alloc_size += (SMB2_COMPRESSION_PAYLOAD_BASE_LEN * 3) +
 			(sizeof(struct smb2_compression_pattern_v1) * 2);
diff --git a/fs/smb/common/compress/huffman.c b/fs/smb/common/compress/huffman.c
new file mode 100644
index 000000000000..e47e508bebb5
--- /dev/null
+++ b/fs/smb/common/compress/huffman.c
@@ -0,0 +1,877 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026, SUSE LLC
+ *
+ * Authors: Enzo Matsumiya <ematsumiya@suse.de>
+ *
+ * Implementation of the LZ77+Huffman compression algorithm, as per MS-XCA spec.
+ */
+#include <linux/slab.h>
+#include <linux/sizes.h>
+#include <linux/count_zeros.h>
+#include <linux/sort.h>
+#include <linux/list_sort.h>
+#include <linux/uio.h>
+
+#include "compress.h"
+
+#define HUFF_TABLE_SIZE		256
+#define HUFF_BLOCK_SIZE		SZ_64K
+#define HUFF_MIN_MATCH_LEN	3
+#define HUFF_MAX_SEQUENCES	((HUFF_BLOCK_SIZE / HUFF_MIN_MATCH_LEN) + 1)
+#define HUFF_MAX_SYMS		512
+#define HUFF_SYM_MARKER		256
+
+struct huff_sym {
+	union {
+		u16 freq;
+		u16 len;
+	};
+
+	union {
+		u16 sym;
+		u16 code;
+	};
+} __packed;
+
+struct huff_sequence {
+	const u8 *lits_start;
+	const u8 *lits_end;
+
+	u16 match_sym;
+	u16 match_dist;
+	u16 match_len;
+};
+
+struct bitstream {
+	u32 next;
+	s32 free;
+
+	union {
+		const void *src;
+		void *dst;
+	};
+	void *next_pos;
+	void *end_pos;
+};
+
+#define huff_sym_ptr(ptr)	((struct huff_sym *)(ptr))
+
+static int cmp_freq(const void *a, const void *b)
+{
+	const u16 freq_a = huff_sym_ptr(a)->freq;
+	const u16 freq_b = huff_sym_ptr(b)->freq;
+
+	if (freq_a <= freq_b)
+		return -1;
+
+	/*
+	 * MS-XCA says we should compare symbol values in case of equal frequencies, but we never
+	 * have duplicate symbols in an array, at any time.
+	 */
+	return 1;
+}
+
+static __always_inline int cmp_sym(const void *a, const void *b)
+{
+	const u16 sym_a = huff_sym_ptr(a)->sym;
+	const u16 sym_b = huff_sym_ptr(b)->sym;
+
+	if (sym_a <= sym_b)
+		return -1;
+
+	/* There are no duplicate symbols ever, no need to check. */
+	return 1;
+}
+
+static __always_inline int cmp_len(const void *a, const void *b)
+{
+	const u16 len_a = huff_sym_ptr(a)->len;
+	const u16 len_b = huff_sym_ptr(b)->len;
+
+	if (len_a < len_b)
+		return -1;
+
+	if (len_a > len_b)
+		return 1;
+
+	/* Same depth, choose smallest symbol. */
+	return cmp_sym(a, b);
+}
+
+/*
+ * Bitstream ops.
+ */
+
+/*
+ * Read 1, 2, or 4 bytes directly from src buffer and advance it.
+ * Don't update bitstream state!
+ */
+#define bitstream_read_bytes(st, t)				\
+({								\
+	const t __v = MEM_UNALIGNED_READ((st)->src, t);		\
+	BUILD_BUG_ON(sizeof(t) == 3 || sizeof(t) > 4);		\
+	(st)->src += sizeof(t);					\
+	(__v);							\
+})
+
+static __always_inline u32 bitstream_decompress_init(struct bitstream *stream, const void *src)
+{
+	stream->src = src;
+
+	stream->next = bitstream_read_bytes(stream, u16) << 16;
+	stream->next |= bitstream_read_bytes(stream, u16);
+	stream->free = 16;
+
+	/* Unused on decompress. */
+	stream->next_pos = NULL;
+	stream->end_pos = NULL;
+
+	return stream->next;
+}
+
+static __always_inline u32 bitstream_read_advance(struct bitstream *stream, const u8 bits)
+{
+	stream->next <<= bits;
+	stream->free -= bits;
+	if (stream->free < 0) {
+		stream->next |= mem_read16(stream->src) << (-stream->free);
+		stream->src += sizeof(u16);
+		stream->free += 16;
+	}
+
+	return stream->next;
+}
+
+static __always_inline void bitstream_compress_init(struct bitstream *stream, void *dst)
+{
+	stream->next = 0;
+	stream->free = 16;
+	stream->dst = dst;
+	stream->next_pos = dst + 2;
+	stream->end_pos = dst + 4;
+}
+
+static __always_inline void bitstream_write(struct bitstream *stream, const u16 bits, const u8 n)
+{
+	if (n <= stream->free) {
+		stream->free -= n;
+		stream->next <<= n;
+		stream->next |= bits;
+	} else {
+		stream->next <<= stream->free;
+		stream->next |= (bits >> (n - stream->free));
+		stream->free -= n;
+
+		mem_write8(stream->dst, stream->next & 0xff);
+		mem_write8(stream->dst + 1, (stream->next >> 8) & 0xff);
+
+		stream->dst = stream->next_pos;
+		stream->next_pos = stream->end_pos;
+		stream->end_pos += 2;
+		stream->free += 16;
+		stream->next = bits;
+	}
+}
+
+static __always_inline void bitstream_write_byte(struct bitstream *stream, const u8 bits)
+{
+	mem_write8(stream->end_pos, bits);
+	stream->end_pos++;
+}
+
+static __always_inline void bitstream_write_2bytes(struct bitstream *stream, const u16 bits)
+{
+	mem_write16(stream->end_pos, bits);
+	stream->end_pos += sizeof(u16);
+}
+
+static __always_inline void bitstream_flush(struct bitstream *stream)
+{
+	stream->next <<= stream->free;
+
+	mem_write8(stream->dst, (stream->next & 0xff));
+	mem_write8(stream->dst + 1, ((stream->next >> 8) & 0xff));
+	mem_write8(stream->next_pos, 0);
+	mem_write8(stream->next_pos + 1, 0);
+}
+
+static int huff_build_histogram(struct huff_sequence *seqs, const int nseqs, struct huff_sym *syms)
+{
+	u16 nsyms = 0;
+	int i;
+
+	for (i = 0; i < nseqs; i++) {
+		struct huff_sequence *seq = &seqs[i];
+
+		if (seq->lits_start && seq->lits_end) {
+			const u8 *p = seq->lits_start;
+
+			while (p < seq->lits_end)
+				if (!syms[mem_read8(p++)].freq++)
+					nsyms++;
+		}
+
+		if (likely(seq->match_sym >= HUFF_SYM_MARKER))
+			if (!syms[seq->match_sym].freq++)
+				nsyms++;
+	}
+
+	/* Bug in huff_scan_sequences() */
+	if (unlikely(nsyms == 0 || nsyms > HUFF_MAX_SYMS))
+		return -EIO;
+
+	return nsyms;
+}
+
+static __always_inline void init_nodes(struct huff_sym *syms, const int nsyms,
+				       struct huff_sym *nodes, const int rebalances)
+{
+	u16 i, n = 0;
+
+	for (i = 0; i < HUFF_MAX_SYMS; i++) {
+		u16 freq = syms[i].freq;
+
+		if (!freq)
+			continue;
+		/*
+		 * When rebalancing, half symbols frequencies on each retry, which will generate a
+		 * shallower "tree".
+		 * Rebalancing doesn't affect original symbol count.
+		 */
+		if (unlikely(rebalances)) {
+			freq /= (2 * rebalances);
+			freq++;
+		}
+
+		nodes[n].sym = i;
+		nodes[n].freq = freq;
+		n++;
+	}
+
+	sort(nodes, nsyms, sizeof(*nodes), cmp_freq, NULL);
+}
+
+static __always_inline int select_node(int *ap, const int amax, int *bp, const int bmax,
+				       const struct huff_sym *nodes)
+{
+	const int a = *ap;
+	const int b = *bp;
+
+	if (a < amax && b >= bmax)
+		return (*ap)++;
+
+	if (a >= amax && b < bmax)
+		return (*bp)++;
+
+	if (nodes[a].freq <= nodes[b].freq)
+		return (*ap)++;
+
+	return (*bp)++;
+}
+
+/*
+ * Compute the depth (code length) of each Huffman symbol in @nodes.
+ *
+ * A full-fledged Huffman tree would be built something like:
+ *	qa = syms
+ *	qb = nodes
+ *	while (qa not empty || qb not singular) {
+ *		left = select_node(qa, qb)
+ *		right = select_node(qa, qb)
+ *		new_node->freq = left->freq + right->freq
+ *		queue_node(new_node, qb)
+ *	}
+ *	root = queue_first(qb)
+ *
+ * Then traverse the tree from root to compute each leaf (i.e. syms elements) depth.
+ *
+ * This implementation instead simulates those merges, and store frequencies and parents in a
+ * separate array, and traverse the "tree" by chasing parents in a more linear manner.
+ *
+ * Also, the Huffman tree is a full binary tree, so, given its properties, we know exactly how many
+ * merges should be done, and not rely on more complex checks.
+ *
+ * This saves memory and computing resources.
+ */
+static bool compute_code_lengths(struct huff_sym *nodes, const int nsyms, int *parents)
+{
+	int root, l = 0, n = nsyms, next = nsyms, merges = nsyms - 1;
+
+	do {
+		const int a = select_node(&l, nsyms, &n, next, nodes);
+		const int b = select_node(&l, nsyms, &n, next, nodes);
+
+		nodes[next].freq = nodes[a].freq + nodes[b].freq;
+		parents[a] = next;
+		parents[b] = next;
+
+		next++;
+	} while (--merges);
+
+	root = next - 1;
+
+	for (l = 0; l < nsyms; l++) {
+		int d = 0, p = l;
+
+		/* Chase parent's indices up until root to compute this symbol code length. */
+		while (p != root) {
+			p = parents[p];
+			d++;
+		}
+
+		if (unlikely(d > 14))
+			return false;
+
+		nodes[l].len = d;
+	}
+
+	return true;
+}
+
+static __always_inline void write_codes(struct huff_sym *nodes, struct huff_sym *syms,
+					const int nsyms, u8 *dst)
+{
+	u16 nextcode = 0, clen = 0;
+	int i;
+
+	MEM_PREFETCH(nodes);
+
+	memset(dst, 0, sizeof(struct huff_sym) * HUFF_MAX_SYMS);
+	sort(nodes, nsyms, sizeof(*nodes), cmp_len, NULL);
+
+	for (i = 0; i < nsyms; i++) {
+		struct huff_sym *node = &nodes[i];
+		const u16 len = node->len;
+		const u16 s = node->sym;
+		const u8 pos = (s >> 1);
+		const u8 shift = (s & 1) ? 4 : 0;
+
+		/* Generate symbol code. */
+		nextcode <<= len - clen;
+		clen = len;
+
+		/* Make @syms indexed by symbol value, so we can access it directly later. */
+		syms[s].code = nextcode++;
+		syms[s].len = len;
+
+		/*
+		 * Write symbol depth/code length of Huffman symbols to the table header.
+		 * There can be up to 512 Huffman symbols, but code lengths are stored on nibs
+		 * (4 bits) so the final table will be 256 bytes long.
+		 *
+		 * To keep the order for decoders, odd symbols lengths go in the upper 4 bits, even
+		 * symbols on lower 4 bits.
+		 */
+		dst[pos] |= (len << shift);
+	}
+}
+
+static noinline void *huff_encode_syms(struct huff_sym *syms, const int nsyms, void *dst)
+{
+	const int max_nodes = 2 * nsyms - 1;
+	struct huff_sym *nodes = kzalloc_objs(*nodes, max_nodes);
+	int ret, rebalances = 0, *parents = kzalloc_objs(*parents, max_nodes);
+
+	if (unlikely(!nodes || !parents)) {
+		kfree(nodes);
+		kfree(parents);
+
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ret = -EOVERFLOW;
+
+	do {
+		MEM_PREFETCH(nodes);
+
+		init_nodes(syms, nsyms, nodes, rebalances++);
+
+		if (likely(compute_code_lengths(nodes, nsyms, parents))) {
+			write_codes(nodes, syms, nsyms, dst);
+			ret = 0;
+
+			break;
+		}
+
+		/* Max code length is too large ("tree" too deep); reset, rebalance and retry. */
+		memset(parents, 0, max_nodes * sizeof(parents[0]));
+		memset(nodes, 0, max_nodes * sizeof(*nodes));
+
+		 /* XXX: should this be increased/decreased? */
+	} while (rebalances < 5);
+
+	kfree(nodes);
+	kfree(parents);
+
+	return (!ret ? dst + HUFF_TABLE_SIZE : ERR_PTR(ret));
+}
+
+static noinline void *huff_encode_final(const void *src, void *dst, struct huff_sequence *seqs,
+					const int max_seqs, struct huff_sym *syms)
+{
+	const struct huff_sequence *seq;
+	struct bitstream stream;
+	int i = 0;
+
+	bitstream_compress_init(&stream, dst);
+
+	do {
+		u16 len, sym;
+		u8 distbit;
+
+		/* Assumes @max_seqs >= 1 was checked by caller. */
+		seq = &seqs[i++];
+		if (seq->lits_start && seq->lits_end) {
+			const u8 *p = seq->lits_start;
+
+			while (p < seq->lits_end) {
+				sym = *p++;
+				bitstream_write(&stream, syms[sym].code, syms[sym].len);
+			}
+		}
+
+		/* Done, we just wrote leftover literals */
+		if (unlikely(!seq->match_len))
+			break;
+
+		sym = seq->match_sym;
+		len = seq->match_len;
+		distbit = (sym - HUFF_SYM_MARKER) / 16;
+
+		bitstream_write(&stream, syms[sym].code, syms[sym].len);
+
+		len -= 3;
+		if (len >= 15) {
+			bitstream_write_byte(&stream, (u8)umin(len - 15, 255));
+
+			if (len - 15 >= 255)
+				/*
+				 * Match length is < 64k.
+				 * No current support for longer matches.
+				 */
+				bitstream_write_2bytes(&stream, (u16)len);
+		}
+
+		bitstream_write(&stream, seq->match_dist - (1U << distbit), (u8)distbit);
+	} while (i < max_seqs);
+
+	bitstream_flush(&stream);
+
+	return stream.end_pos;
+}
+
+static __always_inline u16 huff_encode_match(const u16 dist, const u16 len)
+{
+	const u8 distbit = dist < 256 ? __fls(dist) : 8 + __fls(dist >> 8);
+
+	return (u16)(HUFF_SYM_MARKER + umin(len - 3, 15) + (16 * distbit));
+}
+
+static __always_inline u32 hash3(const void *ptr)
+{
+	return smb_compress_hash(mem_read32(ptr) & 0xffffff);
+}
+
+static const void *store_seq(struct huff_sequence *seq, const void *literals,
+			     const void *match, const void *cur, const void *end)
+{
+	if (cur > literals) {
+		seq->lits_start = literals;
+		seq->lits_end = cur;
+	}
+
+	if (likely(match)) {
+		seq->match_len = mem_match_len(match, cur, end);
+		seq->match_dist = cur - match;
+		seq->match_sym = huff_encode_match(seq->match_dist, seq->match_len);
+
+		cur += seq->match_len;
+	}
+
+	return cur;
+}
+
+/*
+ * Scan sequences on @src.
+ *
+ * Sequences are defined as:
+ * - literals chunk (start and end)
+ * - match data (symbol, distance, and length)
+ *
+ * A sequence is stored when a match is found, or at the end, if there are literal leftovers.
+ *
+ * Aside from that, the whole function structure and match finding algorithm are the same as the
+ * one found in lz77.c::smb_lz77_compress(), the only difference is that here we don't do adaptive
+ * skipping, but actually parse every @src byte (for better compression).
+ */
+static noinline int huff_scan_sequences(const void *src, const u32 slen,
+					struct huff_sequence *seqs, int *nseqs)
+{
+	const void *srcp, *rlim, *end, *anchor;
+	const int max_seqs = *nseqs;
+	u32 *htable, hash, s = 0;
+	int ret = 0;
+
+	*nseqs = 0;
+
+	srcp = anchor = src;
+	end = src + slen;
+	rlim = end - SMB_COMPRESS_MSTEP_SIZE; /* read limit for match finding */
+
+	htable = kvcalloc(SMB_COMPRESS_HASH_SIZE, sizeof(*htable), GFP_KERNEL);
+	if (!htable)
+		return -ENOMEM;
+
+	MEM_PREFETCH(srcp + SMB_COMPRESS_RSTEP_SIZE);
+
+	hash = hash3(srcp++);
+	htable[hash] = 0;
+	hash = hash3(srcp);
+
+	do {
+		const void *match, *next = srcp;
+
+		do {
+			const u32 cur_hash = hash;
+
+			srcp = next;
+			next++;
+			if (unlikely(next >= rlim))
+				goto out;
+
+			hash = hash3(next);
+			match = src + htable[cur_hash];
+			htable[cur_hash] = srcp - src;
+
+			/*
+			 * Scans are done in blocks up to HUFF_BLOCK_SIZE (64k) bytes long.
+			 * Due to encoding limitations, Huffman can only find matches that are
+			 * (64k - 1) bytes back, which is impossible, because:
+			 * - we're only reading up to 'rlim' (i.e. end - 8)
+			 * - even if going further, that would mean a match len of 1 (min is 3)
+			 *
+			 * So, IOW, with our window < block size and window < max distance, we're
+			 * always within our window, so all we need to check is 'match' == 'srcp'
+			 * (i.e. htable entry was not filled yet).
+			 */
+		} while (match == srcp || memcmp(match, srcp, HUFF_MIN_MATCH_LEN));
+
+		if (unlikely(s >= max_seqs)) {
+			ret = -EIO;
+			break;
+		}
+
+		srcp = store_seq(&seqs[s++], anchor, match, srcp, end);
+		anchor = srcp;
+		MEM_PREFETCH(srcp);
+
+		if (unlikely(srcp >= rlim))
+			break;
+
+		hash = hash3(srcp);
+	} while (srcp < end);
+out:
+	kvfree(htable);
+
+	if (!ret) {
+		if (unlikely(s >= max_seqs))
+			return -EIO;
+
+		/* Add sequence for leftover literals */
+		end = store_seq(&seqs[s++], anchor, NULL, end, NULL);
+		if (IS_ERR(end))
+			ret = PTR_ERR(end);
+	}
+
+	*nseqs = s;
+
+	return ret;
+}
+
+/*
+ * Huffman encoding performs extra steps on top of a LZ77-style encoded buffer so it can further
+ * compress the symbols at bit level, offering a much better compression (vs. e.g. LZ77 plain).
+ *
+ * The uncompressed buffer @src is parsed in 64k blocks, and each block goes through 4 main steps
+ * as described below.
+ *
+ * Expectations (compared to LZ77 plain):
+ * - compression ratio should be about 10-20% better
+ * - performance should be around 2-3x worse
+ */
+int smb_huff_compress(const void *src, const u32 slen, void *dst, u32 *dlen)
+{
+	struct huff_sequence *seqs;
+	ssize_t ret, remaining = slen;
+	struct huff_sym *syms;
+	const void *srcp = src;
+	int nseqs, nsyms;
+	void *dstp = dst;
+
+	seqs = kvzalloc_objs(*seqs, HUFF_MAX_SEQUENCES);
+	if (unlikely(!seqs))
+		return -ENOMEM;
+
+	syms = kzalloc_objs(*syms, HUFF_MAX_SYMS);
+	if (unlikely(!syms)) {
+		kvfree(seqs);
+		return -ENOMEM;
+	}
+
+	do {
+		const u32 block_slen = umin(HUFF_BLOCK_SIZE, remaining);
+
+		/*
+		 * Step 1. LZ77 encoding
+		 *
+		 * As per the spec, we should first compress @src with smb_lz77_compress() and then
+		 * use @dst as our input for step 2.
+		 * This implementation decided to NOT do the full LZ77 encoding in order to save
+		 * processing time, as it would be required to implement a smb_lz77_decompress-like
+		 * function to proceed.
+		 * Instead it stores "sequence" tokens to aggregate literals and matches data
+		 * (which are then used on step 2).
+		 *
+		 * This step is implementation specific anyway, as it only builds up intermediate
+		 * data that won't affect the final format.
+		 *
+		 * Even though the bit- vs byte-level compression does an amazing job, match
+		 * finding here still counts a lot.
+		 */
+		nseqs = HUFF_MAX_SEQUENCES;
+		ret = huff_scan_sequences(srcp, block_slen, seqs, &nseqs);
+		if (unlikely(ret))
+			break;
+
+		/*
+		 * Step 2. Symbol histogram
+		 *
+		 * Build a histogram of Huffman symbols; each literal (individual byte) is a symbol
+		 * (i.e. 0 - 255), and each match is encoded as a symbol too (256 - 511).
+		 *
+		 * Count the frequencies of each symbol occurrence, along with the number of unique
+		 * symbols in the block.
+		 */
+		nsyms = huff_build_histogram(seqs, nseqs, syms);
+		if (unlikely(nsyms < 0)) {
+			ret = nsyms;
+			break;
+		}
+
+		/*
+		 * Step 3. Encode symbols
+		 *
+		 * Canonically, this step builds up the Huffman tree in order to compute the code
+		 * and depth (or length) of each symbol.
+		 * This implementation also decided to not do it this way, but instead use a faster
+		 * approach (cf. compute_code_lengths()).
+		 *
+		 * After computing those, code lengths are written to the Huffman table (the first
+		 * 256 bytes of the compressed block).
+		 */
+		dstp = huff_encode_syms(syms, nsyms, dstp);
+		if (IS_ERR(dstp)) {
+			ret = PTR_ERR(dstp);
+			break;
+		}
+
+		/*
+		 * Step 4. Final encoding
+		 *
+		 * Now we have all symbols' codes and lengths, write those out to @dstp as a
+		 * bitstream (for bit-level compression).
+		 */
+		dstp = huff_encode_final(srcp, dstp, seqs, nseqs, syms);
+		if (IS_ERR(dstp)) {
+			ret = PTR_ERR(dstp);
+			break;
+		}
+
+		srcp += block_slen;
+		remaining -= block_slen;
+
+		if (likely(remaining > 0)) {
+			int i;
+
+			memset(syms, 0, sizeof(*syms) * HUFF_MAX_SYMS);
+
+			for (i = 0; i < HUFF_MAX_SEQUENCES; i++)
+				memset(&seqs[i], 0, sizeof(*seqs));
+		}
+	} while (remaining > 0);
+
+	kvfree(seqs);
+	kfree(syms);
+
+	if (!ret)
+		*dlen = dstp - dst;
+
+	return ret;
+}
+
+static __always_inline const void *fill_table(const u8 *header, u16 *table, u8 *clens)
+{
+	const u8 *end = header + HUFF_TABLE_SIZE;
+	int len, i = 0;
+	u8 *plens = clens;
+	u16 sym;
+
+	/* read code lenghts from Huffman table on compressed buffer */
+	while (header < end) {
+		const u8 b = mem_read8(header++);
+
+		mem_write8(plens++, (b & 0x0f));
+		mem_write8(plens++, (b & 0xf0) >> 4);
+	}
+
+	for (len = 1; len < 16; len++) {
+		for (sym = 0; sym < HUFF_MAX_SYMS; sym++) {
+			if (clens[sym] == len) {
+				int n = (1U << (SMB_COMPRESS_HASH_LOG - len));
+
+				while (n-- > 0) {
+					if (unlikely(i >= SMB_COMPRESS_HASH_SIZE))
+						return ERR_PTR(-EIO);
+
+					table[i++] = sym;
+				}
+			}
+		}
+	}
+
+	if (unlikely(i != SMB_COMPRESS_HASH_SIZE))
+		return ERR_PTR(-EIO);
+
+	return header;
+}
+
+static __always_inline int huff_decode_match(struct bitstream *stream, u32 *len)
+{
+	u32 mlen = *len & 15;
+
+	if (mlen == 15) {
+		mlen = bitstream_read_bytes(stream, u8);
+		if (mlen == 255) {
+			mlen = bitstream_read_bytes(stream, u16);
+			if (mlen == 0) {
+				mlen = bitstream_read_bytes(stream, u32);
+				if (unlikely(mlen + 15 < HUFF_BLOCK_SIZE))
+					return -EIO;
+			} else if (unlikely(mlen < 15)) {
+				return -EIO;
+			}
+			mlen -= 15;
+		}
+		mlen += 15;
+	}
+	mlen += 3;
+	*len = mlen;
+
+	return 0;
+}
+
+int smb_huff_decompress(const void *src, const u32 slen, void *dst, const u32 dlen)
+{
+	const void *srcp = src, *end = src + slen;
+	void *dstp = dst, *dst_end = dst + dlen;
+	int ret = 0;
+
+	do {
+		struct bitstream stream;
+		const void *block_end = dstp + umin(SZ_64K, dst_end - dstp);
+		u16 *table = NULL;
+		u8 *clens = NULL;
+		u32 bits;
+
+		ret = -ENOMEM;
+		table = kvzalloc_objs(*table, SMB_COMPRESS_HASH_SIZE);
+		if (!table)
+			goto err_free;
+
+		clens = kzalloc_objs(*clens, HUFF_MAX_SYMS);
+		if (!clens)
+			goto err_free;
+
+		srcp = fill_table(srcp, table, clens);
+		if (IS_ERR(srcp)) {
+			ret = PTR_ERR(srcp);
+			goto err_free;
+		}
+
+		ret = 0;
+		bits = bitstream_decompress_init(&stream, srcp);
+
+		do {
+			const u16 sym = table[bits >> (32 - 15)];
+			const u32 clen = clens[sym];
+			u16 dist, distbit;
+			const void *match;
+			u32 len;
+
+			ret = -EIO;
+			if (unlikely(sym >= HUFF_MAX_SYMS))
+				break;
+
+			if (unlikely(clen >= 16))
+				break;
+
+			/* Advance bitstream before checking sym */
+			bits = bitstream_read_advance(&stream, clen);
+
+			if (sym < HUFF_SYM_MARKER) {
+				mem_write8(dstp++, sym);
+				ret = 0;
+				continue;
+			}
+
+			if (unlikely(sym == HUFF_SYM_MARKER && stream.src >= end)) {
+				ret = 0;
+				break;
+			}
+
+			len = sym - HUFF_SYM_MARKER;
+			distbit = len >> 4;
+			if (unlikely(distbit >= 16))
+				break;
+
+			ret = huff_decode_match(&stream, &len);
+			if (unlikely(ret))
+				break;
+
+			dist = (u32)((u64)bits >> (32 - distbit));
+			dist += (1U << distbit);
+
+			if (unlikely(dist > dstp - dst))
+				break;
+
+			if (unlikely(len > dst_end - dstp))
+				break;
+
+			/* Advance bitstream only after checking match len */
+			bits = bitstream_read_advance(&stream, distbit);
+			match = dstp - dist;
+			if (match + len < dstp) {
+				memcpy(dstp, match, len);
+				dstp += len;
+			} else {
+				const void *match_end = dstp + len;
+
+				while (dstp < match_end)
+					mem_write8(dstp++, mem_read8(match++));
+			}
+
+			ret = 0;
+		} while (dstp < block_end);
+err_free:
+		kvfree(table);
+		kfree(clens);
+
+		if (unlikely(ret))
+			break;
+
+		srcp = stream.src;
+	} while (srcp < end && dstp < dst_end);
+
+	return ret;
+}
diff --git a/fs/smb/common/compress/huffman.h b/fs/smb/common/compress/huffman.h
new file mode 100644
index 000000000000..184de5fb6d59
--- /dev/null
+++ b/fs/smb/common/compress/huffman.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026, SUSE LLC
+ *
+ * Authors: Enzo Matsumiya <ematsumiya@suse.de>
+ *
+ * Implementation of the LZ77+Huffman compression algorithm, as per MS-XCA spec.
+ */
+#ifndef _SMB_COMPRESS_LZ77_HUFF_H
+#define _SMB_COMPRESS_LZ77_HUFF_H
+
+#include <linux/kernel.h>
+
+/*
+ * LZ77-Huffman metadata is Huffman table (256 bytes) at the beginning of every 64k block, so:
+ *
+ * metadata = ((@size / 64k) * 256), or simplified (@size >> 8)
+ */
+static __always_inline u32 smb_huff_compressed_alloc_size(const u32 size)
+{
+	return size + (size >> 8);
+}
+
+int smb_huff_compress(const void *src, const u32 slen, void *dst, u32 *dlen);
+int smb_huff_decompress(const void *src, const u32 slen, void *dst, const u32 dlen);
+#endif /* _SMB_COMPRESS_LZ77_HUFF_H */
diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index 648660f8bfab..5d6edbb427d7 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -98,10 +98,11 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 	struct smb2_hdr *req_hdr;
 	u32 src_len, dst_len, compressed_pdu_len, max_dst_len;
 	u8 *src = NULL, *out = NULL, *p;
+	__le16 alg = work->conn->compress_algorithm;
 	int i, rc;
 
 	if (!work->compress_response || work->encrypted ||
-	    work->conn->compress_algorithm != SMB3_COMPRESS_LZ77)
+	    smb_compress_alg_valid(alg, false))
 		return 0;
 
 	req_hdr = smb_get_msg(work->request_buf);
@@ -132,7 +133,7 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 		goto out;
 	}
 
-	max_dst_len = smb_compress_alloc_size(src_len, work->conn->compress_pattern);
+	max_dst_len = smb_compress_alloc_size(src_len, work->conn->compress_pattern, alg);
 	out = kvzalloc(sizeof(__be32) + max_dst_len,
 		       KSMBD_DEFAULT_GFP);
 	if (!out) {
@@ -142,7 +143,7 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 
 	if (work->conn->compress_chained) {
 		dst_len = max_dst_len;
-		rc = smb_compression_compress(SMB3_COMPRESS_LZ77,
+		rc = smb_compression_compress(alg,
 					      work->conn->compress_chained,
 					      work->conn->compress_pattern,
 					      src, src_len,
@@ -169,7 +170,7 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 		chdr = (struct smb2_compression_hdr *)(out + sizeof(__be32));
 		chdr->ProtocolId = SMB2_COMPRESSION_TRANSFORM_ID;
 		chdr->OriginalCompressedSegmentSize = cpu_to_le32(src_len);
-		chdr->CompressionAlgorithm = SMB3_COMPRESS_LZ77;
+		chdr->CompressionAlgorithm = alg;
 		chdr->Flags = cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE);
 		chdr->Offset = 0;
 	}
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5859fa68bb84..3bd62c16ae49 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1130,18 +1130,27 @@ static __le32 decode_compress_ctxt(struct ksmbd_conn *conn,
 		__le16 alg = algs[i];
 
 		/*
-		 * LZ77 is the required general-purpose codec. Pattern_V1 is an
+		 * LZ* are the required general-purpose codecs. Pattern_V1 is an
 		 * optional chained payload type and cannot stand alone.
+		 *
+		 * Use the first LZ algorithm found in the request array.  It's sorted by
+		 * client-preferred order, so don't overwrite it if already set.
 		 */
-		if (alg == SMB3_COMPRESS_LZ77) {
-			conn->compress_algorithm = alg;
-			conn->compress_chained =
-				pneg_ctxt->Flags ==
-				SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED;
-			ksmbd_debug(SMB, "Compression Algorithm ID = 0x%x\n",
-				    le16_to_cpu(alg));
-		} else if (alg == SMB3_COMPRESS_PATTERN) {
+		switch (alg) {
+		case SMB3_COMPRESS_LZ77:
+		case SMB3_COMPRESS_LZ77_HUFF:
+			if (conn->compress_algorithm == SMB3_COMPRESS_NONE) {
+				conn->compress_algorithm = alg;
+				conn->compress_chained =
+					pneg_ctxt->Flags ==
+					SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED;
+				ksmbd_debug(SMB, "Compression Algorithm ID = 0x%x\n",
+					    le16_to_cpu(alg));
+			}
+			break;
+		case SMB3_COMPRESS_PATTERN:
 			conn->compress_pattern = true;
+			break;
 		}
 	}
 
-- 
2.54.0

