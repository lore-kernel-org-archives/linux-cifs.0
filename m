Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA94B3B27FA
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 19:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576995; cv=none; b=E3+SySTXE2pDq8P6CVRWIZZEpH4I7wnp/Zjb3+/VscENknkl0Nm66dubH6yYY9rwha7uizs0Gj2pdkUrm89q7IGvfguXkDz/zkaCrKSbe4DCz8Tih9Z5DeJABMh7L289/IaK+/NbSkXa56s9cEVw5R3cShqjVL19YgUwomJduF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576995; c=relaxed/simple;
	bh=x2hPE6IxGyoMKh+FcgDrbi3qTXuoxGJmbdklbUeHmXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyBOnU4hF37YI6C1xDhxTuvZRhmLyhW4MsZd4edgNuEFNs//jFXHy9Ip70qdXWZnOK28mXXRQo0LJmEqjQBjZOChb7mFQkP2m3KBRDK+9oRjjoBFT43WqkFPrNB21jhcTL+HuZ2x7etaiOZ5sEJGB782EhqTLsUUcYnPVQCw6IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BfCZaCuz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Fg1KJLTP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BfCZaCuz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Fg1KJLTP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BfCZaCuz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Fg1KJLTP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BfCZaCuz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Fg1KJLTP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A13897A138;
	Mon, 20 Jul 2026 19:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784576987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PMb3WSISnyct0Ixh7psY+Pa+zUoqm4/6cyUVziwLByw=;
	b=BfCZaCuzPPkwljdjfdPWe5e7f0ABZMQDTpN7DilROjZJhtTeWu1Y1FajGZzvVkFMulwsPk
	8gQdKvAILNMjTk3kX4g5fEuv6srDeNj+deLMQIE0qY4pO+k4fAqcvrup4XXoRg825p1X6W
	lvsQ+1DA1V4Oa/Z7jRHlZBRaFOPIpeE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784576987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PMb3WSISnyct0Ixh7psY+Pa+zUoqm4/6cyUVziwLByw=;
	b=Fg1KJLTP4zNZF6j9CesKqwrrgT7ScbjNdADt+4fnzTPA51QDCOsn/zqLG16sTJXxxLw8MH
	1bnl81Em6nMhk/DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784576987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PMb3WSISnyct0Ixh7psY+Pa+zUoqm4/6cyUVziwLByw=;
	b=BfCZaCuzPPkwljdjfdPWe5e7f0ABZMQDTpN7DilROjZJhtTeWu1Y1FajGZzvVkFMulwsPk
	8gQdKvAILNMjTk3kX4g5fEuv6srDeNj+deLMQIE0qY4pO+k4fAqcvrup4XXoRg825p1X6W
	lvsQ+1DA1V4Oa/Z7jRHlZBRaFOPIpeE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784576987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PMb3WSISnyct0Ixh7psY+Pa+zUoqm4/6cyUVziwLByw=;
	b=Fg1KJLTP4zNZF6j9CesKqwrrgT7ScbjNdADt+4fnzTPA51QDCOsn/zqLG16sTJXxxLw8MH
	1bnl81Em6nMhk/DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F34A779AA;
	Mon, 20 Jul 2026 19:49:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B+H6Odp7XmqpCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Jul 2026 19:49:46 +0000
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
Subject: [PATCH v2 05/14] smb: common: compress: use a single function for chained and unchained compression
Date: Mon, 20 Jul 2026 16:49:16 -0300
Message-ID: <20260720194925.2108840-5-ematsumiya@suse.de>
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
X-Spam-Flag: NO
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	URIBL_BLOCKED(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_SEVEN(0.00)[11];
	R_RATELIMIT(0.00)[to_ip_from(RLkmoi5kqpkgjx3hbiagnu7sfh)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -6.80

Rename smb_compression_compress_chained() to smb_compression_compress(),
and handle both unchained and chained compressions there,
similar to smb_compression_decompress().

Changes:
- add @chained arg to smb_compression_compress(), so it's possible to
  handle (chained && !allow_pattern) cases
- drop smb_compression_builder::first field -- add all payload headers
  with Flags = "NONE", set flag "CHAINED" at the end on the starting
  header
- drop @orig_size from smb_compression_add_payload(), compute it
  directly on smb_compression_add_lz77() instead
- adjust smb_compression_compress() call in server/compress.c
  - TODO: rework the code around to fully use the single function

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/common/compress/compress.c | 119 +++++++++++++++++++-----------
 fs/smb/common/compress/compress.h |   6 +-
 fs/smb/server/compress.c          |  11 +--
 3 files changed, 83 insertions(+), 53 deletions(-)

diff --git a/fs/smb/common/compress/compress.c b/fs/smb/common/compress/compress.c
index 088e0d0d2792..75d21622c268 100644
--- a/fs/smb/common/compress/compress.c
+++ b/fs/smb/common/compress/compress.c
@@ -213,7 +213,6 @@ EXPORT_SYMBOL_GPL(smb_compression_decompress);
 struct smb_compression_builder {
 	u8 *pos;
 	u32 remaining;
-	bool first;
 };
 
 /*
@@ -222,28 +221,22 @@ struct smb_compression_builder {
  */
 static struct smb2_compression_payload_hdr *
 smb_compression_add_payload(struct smb_compression_builder *builder,
-			    __le16 alg, u32 payload_len, bool orig_size)
+			    __le16 alg, u32 payload_len)
 {
 	struct smb2_compression_payload_hdr *payload;
-	u32 hdr_len = SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
 	u32 total_len;
 
-	if (orig_size)
-		hdr_len += sizeof(payload->OriginalPayloadSize);
-	if (check_add_overflow(hdr_len, payload_len, &total_len) ||
+	if (check_add_overflow(payload_len, SMB2_COMPRESSION_PAYLOAD_BASE_LEN, &total_len) ||
 	    total_len > builder->remaining)
 		return NULL;
 
 	payload = (struct smb2_compression_payload_hdr *)builder->pos;
 	payload->CompressionAlgorithm = alg;
-	payload->Flags = cpu_to_le16(builder->first ?
-		SMB2_COMPRESSION_FLAG_CHAINED : SMB2_COMPRESSION_FLAG_NONE);
-	payload->Length = cpu_to_le32(payload_len +
-		(orig_size ? sizeof(payload->OriginalPayloadSize) : 0));
-
-	builder->pos += hdr_len;
-	builder->remaining -= hdr_len;
-	builder->first = false;
+	payload->Flags = cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE);
+	payload->Length = cpu_to_le32(payload_len);
+
+	builder->pos += SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
+	builder->remaining -= SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
 	return payload;
 }
 
@@ -252,8 +245,7 @@ static int smb_compression_add_pattern(struct smb_compression_builder *builder,
 {
 	struct smb2_compression_pattern_v1 *payload;
 
-	if (!smb_compression_add_payload(builder, SMB3_COMPRESS_PATTERN,
-					 sizeof(*payload), false))
+	if (!smb_compression_add_payload(builder, SMB3_COMPRESS_PATTERN, sizeof(*payload)))
 		return -ENOSPC;
 
 	payload = (struct smb2_compression_pattern_v1 *)builder->pos;
@@ -269,7 +261,7 @@ static int smb_compression_add_pattern(struct smb_compression_builder *builder,
 static int smb_compression_add_none(struct smb_compression_builder *builder,
 				    const u8 *src, u32 len)
 {
-	if (!smb_compression_add_payload(builder, SMB3_COMPRESS_NONE, len, false))
+	if (!smb_compression_add_payload(builder, SMB3_COMPRESS_NONE, len))
 		return -ENOSPC;
 
 	memcpy(builder->pos, src, len);
@@ -279,36 +271,47 @@ static int smb_compression_add_none(struct smb_compression_builder *builder,
 }
 
 static int smb_compression_add_lz77(struct smb_compression_builder *builder,
-				    const u8 *src, u32 len)
+				    const u8 *src, u32 len, bool chained)
 {
 	struct smb2_compression_payload_hdr *payload;
-	u32 comp_len;
+	u32 comp_len, offset = chained ? sizeof(payload->OriginalPayloadSize) : 0;
 	int rc;
 
 	if (builder->remaining <= sizeof(*payload))
 		return -ENOSPC;
 
-	comp_len = builder->remaining - sizeof(*payload);
-	payload = smb_compression_add_payload(builder, SMB3_COMPRESS_LZ77,
-					      comp_len, true);
+	/*
+	 * Always add LZ data as a payload, regardless of @chained.
+	 * The only difference is whether offset (sizeof(payload->OriginalPayloadSize)) is
+	 * accounted for.
+	 * Also, use @payload_len == 0 as we don't know compressed size yet.
+	 */
+	payload = smb_compression_add_payload(builder, SMB3_COMPRESS_LZ77, 0);
 	if (!payload)
 		return -ENOSPC;
 
+	builder->pos += offset;
+	builder->remaining -= offset;
+	comp_len = builder->remaining;
 	rc = smb_lz77_compress(src, len, builder->pos, &comp_len);
 	if (rc)
 		return rc;
 
-	payload->Length = cpu_to_le32(comp_len +
-				      sizeof(payload->OriginalPayloadSize));
-	payload->OriginalPayloadSize = cpu_to_le32(len);
+	/* These are only set when @chained. */
+	if (chained) {
+		payload->Length = cpu_to_le32(comp_len + offset);
+		payload->OriginalPayloadSize = cpu_to_le32(len);
+	}
+
 	builder->pos += comp_len;
 	builder->remaining -= comp_len;
 	return 0;
 }
 
 /**
- * smb_compression_compress_chained() - build a chained SMB2 transform
+ * smb_compression_compress() - build a SMB2 compression transform (chained optional)
  * @alg: negotiated general-purpose compression algorithm
+ * @chained: is chained compression was negotiated
  * @allow_pattern: whether Pattern_V1 was negotiated
  * @src: complete uncompressed SMB2 message
  * @slen: size of @src
@@ -325,12 +328,12 @@ static int smb_compression_add_lz77(struct smb_compression_builder *builder,
  *
  * Return: 0 on success, otherwise a negative errno.
  */
-int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
-				     const void *src, u32 slen,
-				     void *dst, u32 *dlen)
+int smb_compression_compress(__le16 alg, bool chained, bool allow_pattern,
+			     const void *src, u32 slen,
+			     void *dst, u32 *dlen)
 {
-	struct smb2_compression_hdr *hdr = dst;
 	struct smb_compression_builder builder;
+	struct smb2_compression_hdr *hdr;
 	const u8 *input = src;
 	u32 forward = 0, backward = 0, middle_len;
 	int rc;
@@ -339,13 +342,21 @@ int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
 	    *dlen <= SMB2_COMPRESSION_CHAINED_HDR_LEN || !slen)
 		return -EINVAL;
 
-	hdr->ProtocolId = SMB2_COMPRESSION_TRANSFORM_ID;
-	hdr->OriginalCompressedSegmentSize = cpu_to_le32(slen);
+	/* Note that the below is a bug, but (chained && !allow_pattern) is a valid combination */
+	if (WARN_ON_ONCE(!chained && allow_pattern))
+		return -EINVAL;
+
+	/*
+	 * Offset @dst for both unchained and chained cases, header is setup at the end.
+	 * If unchained, we must align @dst to the end of compression header.
+	 */
 	builder.pos = (u8 *)dst + SMB2_COMPRESSION_CHAINED_HDR_LEN;
 	builder.remaining = *dlen - SMB2_COMPRESSION_CHAINED_HDR_LEN;
-	builder.first = true;
 
-	if (allow_pattern && slen > 32) {
+	if (!chained || !allow_pattern)
+		goto do_lz;
+
+	if (slen > 32) {
 		for (forward = 1; forward < slen; forward++) {
 			if (input[forward] != input[0])
 				break;
@@ -366,18 +377,22 @@ int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
 		if (rc)
 			return rc;
 	}
-
+do_lz:
+	rc = -ENODATA;
 	middle_len = slen - forward - backward;
-	if (middle_len > 1024)
-		rc = smb_compression_add_lz77(&builder, input + forward,
-					      middle_len);
-	else if (middle_len)
-		rc = smb_compression_add_none(&builder,
-					      input + forward, middle_len);
-	else
-		rc = 0;
-	if (rc)
+	if (middle_len > 1024 || !chained)
+		rc = smb_compression_add_lz77(&builder, input + forward, middle_len, chained);
+	else if (middle_len && allow_pattern)
+		rc = smb_compression_add_none(&builder, input + forward, middle_len);
+
+	if (rc) {
+		/* These will allow callers to send uncompressed request in case of small input */
+		if (rc == -ENODATA) {
+			*dlen = slen;
+			rc = 0;
+		}
 		return rc;
+	}
 
 	if (backward) {
 		rc = smb_compression_add_pattern(&builder, input[slen - 1],
@@ -387,6 +402,20 @@ int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
 	}
 
 	*dlen = builder.pos - (u8 *)dst;
+
+	hdr = dst;
+	hdr->ProtocolId = SMB2_COMPRESSION_TRANSFORM_ID;
+	hdr->OriginalCompressedSegmentSize = cpu_to_le32(slen);
+
+	if (chained) {
+		/* Overwrite the first payload->Flags, the other fields must stay as is. */
+		hdr->Flags = cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED);
+	} else {
+		hdr->CompressionAlgorithm = alg;
+		hdr->Flags = cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE);
+		hdr->Offset = cpu_to_le32(0);
+	}
+
 	return 0;
 }
-EXPORT_SYMBOL_GPL(smb_compression_compress_chained);
+EXPORT_SYMBOL_GPL(smb_compression_compress);
diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
index 24b558167fe7..ade37d552067 100644
--- a/fs/smb/common/compress/compress.h
+++ b/fs/smb/common/compress/compress.h
@@ -147,8 +147,8 @@ static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
 
 int smb_compression_decompress(__le16 alg, bool allow_chained,
 			       const void *src, u32 slen, void *dst, u32 dlen);
-int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
-				     const void *src, u32 slen,
-				     void *dst, u32 *dlen);
+int smb_compression_compress(__le16 alg, bool chained, bool allow_pattern,
+			     const void *src, u32 slen,
+			     void *dst, u32 *dlen);
 
 #endif /* _COMMON_SMB_COMPRESS_H */
diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index 8c910f996e04..da7dea58c5a7 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -145,11 +145,12 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 
 	if (work->conn->compress_chained) {
 		dst_len = max_dst_len;
-		rc = smb_compression_compress_chained(SMB3_COMPRESS_LZ77,
-						      work->conn->compress_pattern,
-						      src, src_len,
-						      out + sizeof(__be32),
-						      &dst_len);
+		rc = smb_compression_compress(SMB3_COMPRESS_LZ77,
+					      work->conn->compress_chained,
+					      work->conn->compress_pattern,
+					      src, src_len,
+					      out + sizeof(__be32),
+					      &dst_len);
 		if (rc == -EMSGSIZE || dst_len >= src_len) {
 			rc = 0;
 			goto out;
-- 
2.54.0

