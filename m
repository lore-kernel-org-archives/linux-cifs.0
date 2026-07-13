Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37CF30C155
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 21:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979236; cv=none; b=Yl4bl2HRM0M/53OGN5SbtXuanb/QFahqrkfr1NDOIVJkn8dxQUsPWXy8faCtueCj4Col2NEU24D/7cZU2cZ2kplm46jdQ58yINkdidb3rTQYLISjBHYGQUdPLwAQCfACocWR5UzPOcVPHOtawxYT7Qp3erinXc+rAqzqVDpWAlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979236; c=relaxed/simple;
	bh=t2g/xXNtHZBadwh++SUDgC4sB4LJ8mZ2OQamzHU5CkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+90U9DMWmGv4rJ+th3t0OLT8xtuKl/NRGWwlcFRWNNg7uV0OywuQitWNriZUUQzycNW1omE/F3hYRutYpiuCfwy+ZFt0ssRq4JkSqEsGoLIzLnrIwng3MissJXadBm2hB6jXuw+Rsiu1UsZK1AxNlaRmu0hhqsB1mR69eYyDek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XLZjbMNc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Wv0XjfTe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iA1DpPIb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VwkNg4D9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XLZjbMNc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Wv0XjfTe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iA1DpPIb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VwkNg4D9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EF90C77AD6;
	Mon, 13 Jul 2026 21:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DbYomPixQ5MxlI65W9tejhFObhqdKL3Bt9JRd2DpSwY=;
	b=XLZjbMNcuiOJKvlvYeqlq9TKhXF2uvYIvgu/W7xQ3DhdXrevPxTViBEBYK4TSZxzJdv8Nk
	5p865freE28YI7TSd6b8ApvG3XhWUfo32kbRyZZlDXTrwpOwMlO16G35x2d4jUQzJ7wj6f
	QAcCIFv1QXjsXAoH0E9pCHduAXEr1SY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DbYomPixQ5MxlI65W9tejhFObhqdKL3Bt9JRd2DpSwY=;
	b=Wv0XjfTeIzN+TxJaUgjUXG2FNcm+313Jjy+V7WwnaS7QzmaSaGcJzCG/CJDdrvSsqVhLBu
	Kyr5OtdSvPE/nvAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DbYomPixQ5MxlI65W9tejhFObhqdKL3Bt9JRd2DpSwY=;
	b=iA1DpPIb+cCgAKVnjnIuxjNAX3uCc/Q60m8RFceMgQ7viYgZcouxNOJQz0R9Ie3C1YNYvv
	11BgWSrjFlQJ4NKI+bgpRqqpAU9n2JVvFVzO53pGRC5gYplw3PqtD+d7dr1SxIo7hGjaBC
	Q5Q3pWpM/abZ8hq473d0RrBXdCRxGIc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DbYomPixQ5MxlI65W9tejhFObhqdKL3Bt9JRd2DpSwY=;
	b=VwkNg4D9mnxU77+Wn4qH1L0ZYu2q6F34ioKCSsN+OHXzCUlurmW7KJNGV4eZMCKfiCbYOT
	ELdrpRH0GbAFBrCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7BA29779AE;
	Mon, 13 Jul 2026 21:47:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oszaEN1cVWqZUQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Jul 2026 21:47:09 +0000
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
Subject: [PATCH 04/10] smb: common: compress: do chained and unchained compression in a single function
Date: Mon, 13 Jul 2026 18:46:39 -0300
Message-ID: <20260713214645.550580-4-ematsumiya@suse.de>
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
X-Spam-Score: -2.80
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

Rename smb_compression_compress_chained() to smb_compression_compress(),
and allow it to handle both unchained and chained compressions.

Also, for both unchained and chained cases, MS-SMB2 spec allows the
compressed request to have a leading uncompressed chunk (between
header and compressed payload).

smb_compression_compress_chained() fully compressed @dst without
allowing such flexibility.

Add a @uncomp and @uncomp_len to allow callers to include an external
uncompressed chunk in the final payload, or copy those bytes from @src
(@uncomp == NULL && @uncomp_len > 0).

Other changes:
- drop smb_compression_builder::first field -- add all payload headers
  with Flags = "NONE", setup the first flag "CHAINED" at the end
- server/compress.c:
  - use smb_compression_compress() with @uncomp == NULL and
    @uncomp_len == 0 (ksmbd always compresses the whole data)
  - TODO: rework caller to use the generic function (instead of calling
    smb_lz77_compress() separately)

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/common/compress/compress.c | 114 ++++++++++++++++++++++--------
 fs/smb/common/compress/compress.h |   6 +-
 fs/smb/server/compress.c          |  11 +--
 3 files changed, 94 insertions(+), 37 deletions(-)

diff --git a/fs/smb/common/compress/compress.c b/fs/smb/common/compress/compress.c
index 088e0d0d2792..9f87d31e9986 100644
--- a/fs/smb/common/compress/compress.c
+++ b/fs/smb/common/compress/compress.c
@@ -213,7 +213,6 @@ EXPORT_SYMBOL_GPL(smb_compression_decompress);
 struct smb_compression_builder {
 	u8 *pos;
 	u32 remaining;
-	bool first;
 };
 
 /*
@@ -236,14 +235,12 @@ smb_compression_add_payload(struct smb_compression_builder *builder,
 
 	payload = (struct smb2_compression_payload_hdr *)builder->pos;
 	payload->CompressionAlgorithm = alg;
-	payload->Flags = cpu_to_le16(builder->first ?
-		SMB2_COMPRESSION_FLAG_CHAINED : SMB2_COMPRESSION_FLAG_NONE);
+	payload->Flags = cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE);
 	payload->Length = cpu_to_le32(payload_len +
 		(orig_size ? sizeof(payload->OriginalPayloadSize) : 0));
 
 	builder->pos += hdr_len;
 	builder->remaining -= hdr_len;
-	builder->first = false;
 	return payload;
 }
 
@@ -279,7 +276,7 @@ static int smb_compression_add_none(struct smb_compression_builder *builder,
 }
 
 static int smb_compression_add_lz77(struct smb_compression_builder *builder,
-				    const u8 *src, u32 len)
+				    const u8 *src, u32 len, bool chained)
 {
 	struct smb2_compression_payload_hdr *payload;
 	u32 comp_len;
@@ -288,32 +285,40 @@ static int smb_compression_add_lz77(struct smb_compression_builder *builder,
 	if (builder->remaining <= sizeof(*payload))
 		return -ENOSPC;
 
-	comp_len = builder->remaining - sizeof(*payload);
-	payload = smb_compression_add_payload(builder, SMB3_COMPRESS_LZ77,
-					      comp_len, true);
-	if (!payload)
-		return -ENOSPC;
+	comp_len = builder->remaining;
+	if (chained) {
+		comp_len -= sizeof(*payload);
+		payload = smb_compression_add_payload(builder, SMB3_COMPRESS_LZ77,
+						      comp_len, true);
+		if (!payload)
+			return -ENOSPC;
+	}
 
 	rc = smb_lz77_compress(src, len, builder->pos, &comp_len);
 	if (rc)
 		return rc;
 
-	payload->Length = cpu_to_le32(comp_len +
-				      sizeof(payload->OriginalPayloadSize));
-	payload->OriginalPayloadSize = cpu_to_le32(len);
+	if (chained) {
+		payload->Length = cpu_to_le32(comp_len + sizeof(payload->OriginalPayloadSize));
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
  * @dst: output buffer for the transform
  * @dlen: input capacity of @dst and output transform size
+ * @uncomp: (optional) uncompressed data to be included in the compressed payload
+ * @uncomp_len: (optional) @uncomp size, or amount of bytes to copy uncompressed from @src
  *
  * Following the algorithm in [MS-SMB2] 3.1.4.4, encode sufficiently long
  * repeated runs at the front and back as Pattern_V1 payloads. Compress a
@@ -323,14 +328,18 @@ static int smb_compression_add_lz77(struct smb_compression_builder *builder,
  * This helper does not decide whether the final transform is smaller than the
  * original message. The transport caller owns that policy decision.
  *
+ * If @uncomp is not NULL, copy @uncomp_len from it, as is, to right after the compression header.
+ * Otherwise, if @uncomp_len is >0, copy that many bytes from @src to right after compression
+ * header.
+ *
  * Return: 0 on success, otherwise a negative errno.
  */
-int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
-				     const void *src, u32 slen,
-				     void *dst, u32 *dlen)
+int smb_compression_compress(__le16 alg, bool chained, bool allow_pattern,
+			     const void *src, u32 slen, void *dst, u32 *dlen,
+			     const void *uncomp, u32 uncomp_len)
 {
-	struct smb2_compression_hdr *hdr = dst;
 	struct smb_compression_builder builder;
+	struct smb2_compression_hdr *hdr;
 	const u8 *input = src;
 	u32 forward = 0, backward = 0, middle_len;
 	int rc;
@@ -339,11 +348,38 @@ int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
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
+	 *
+	 * Note the layouts:
+	 *
+	 * smb2_compression_hdr			| smb2_compression_payload_hdr
+	 * -------------------------------------|-------------------------------
+	 *   ProtocolId				|
+	 *   OriginalCompressedSegmentSize	|
+	 *   CompressionAlgorithm		| CompressionAlgorithm
+	 *   Flags				| Flags
+	 *   Offset				| Length
+	 *
+	 * By aligning @dst to start at the "first payload header", @uncomp_len fits nicely for
+	 * both unchained and chained cases as well.
+	 */
 	builder.pos = (u8 *)dst + SMB2_COMPRESSION_CHAINED_HDR_LEN;
 	builder.remaining = *dlen - SMB2_COMPRESSION_CHAINED_HDR_LEN;
-	builder.first = true;
+
+	if (uncomp_len) {
+		smb_compression_add_none(&builder, uncomp ?: input, uncomp_len);
+
+		if (!uncomp)
+			input += uncomp_len;
+	}
+
+	if (!chained)
+		goto do_lz;
 
 	if (allow_pattern && slen > 32) {
 		for (forward = 1; forward < slen; forward++) {
@@ -366,16 +402,14 @@ int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
 		if (rc)
 			return rc;
 	}
-
+do_lz:
+	rc = 0;
 	middle_len = slen - forward - backward;
-	if (middle_len > 1024)
-		rc = smb_compression_add_lz77(&builder, input + forward,
-					      middle_len);
-	else if (middle_len)
+	if (middle_len > 1024 || !chained)
+		rc = smb_compression_add_lz77(&builder, input + forward, middle_len, chained);
+	else if (middle_len && chained)
 		rc = smb_compression_add_none(&builder,
 					      input + forward, middle_len);
-	else
-		rc = 0;
 	if (rc)
 		return rc;
 
@@ -387,6 +421,28 @@ int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
 	}
 
 	*dlen = builder.pos - (u8 *)dst;
+
+	/*
+	 * Set header at the end so we overwrite the flag of first payload (when chained).
+	 * Also when chained, if @uncomp_len > 0, that uncompressed chunk is also part of the whole
+	 * payload, so we must account for that.
+	 */
+	hdr = dst;
+	hdr->ProtocolId = SMB2_COMPRESSION_TRANSFORM_ID;
+	hdr->OriginalCompressedSegmentSize = cpu_to_le32(slen);
+	hdr->Flags = cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE);
+
+	if (chained) {
+		hdr->OriginalCompressedSegmentSize += cpu_to_le32(uncomp_len);
+		hdr->Flags = cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED);
+	} else if (uncomp_len) {
+		/*
+		 * If we copied an uncompressed chunk, it was added with a "NONE" algorithm,
+		 * so set the correct one when unchained.
+		 */
+		hdr->CompressionAlgorithm = alg;
+	}
+
 	return 0;
 }
-EXPORT_SYMBOL_GPL(smb_compression_compress_chained);
+EXPORT_SYMBOL_GPL(smb_compression_compress);
diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
index 24b558167fe7..6760862de04c 100644
--- a/fs/smb/common/compress/compress.h
+++ b/fs/smb/common/compress/compress.h
@@ -147,8 +147,8 @@ static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
 
 int smb_compression_decompress(__le16 alg, bool allow_chained,
 			       const void *src, u32 slen, void *dst, u32 dlen);
-int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
-				     const void *src, u32 slen,
-				     void *dst, u32 *dlen);
+int smb_compression_compress(__le16 alg, bool chained, bool allow_pattern,
+			     const void *src, u32 slen, void *dst, u32 *dlen,
+			     const void *uncomp, u32 uncomp_len);
 
 #endif /* _COMMON_SMB_COMPRESS_H */
diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index 8c910f996e04..32027a15f7ab 100644
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
+					      out + sizeof(__be32), &dst_len,
+					      NULL, 0);
 		if (rc == -EMSGSIZE || dst_len >= src_len) {
 			rc = 0;
 			goto out;
-- 
2.54.0

