Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2117A449B22
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 19:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577001; cv=none; b=P+TWaaPxqg04/hu9scS4Hx/w3RqcnHmmhalZaPB1hoThk9b35TKjOW8jCE5BHdAz1DL1Rqt4TAmHwJDsoIumNYJc9DXDuBpbx36ZewtmXDso2mwjtndw/JvLilphhA+tgTYzVi8lxf1ms3CcajJVzoLdp0fx5xgPFKcysLJuQpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577001; c=relaxed/simple;
	bh=trQzl3uJncOEVtlfzKwoE/0/uRsLXyzU8edvGASK6Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRxmmDc5AatUPYYa/gIKmpnYAO9GNvUw3aONfj/HrRM8I8WBvgXeiKC9P5/iUT3svhJoB7I15fvm9mhZgWGppFPODYcSprn5WQxwbjMRBATHJIVfD49yP7aUZcIBpvraHcL0B1ypANZi2WO8N5kbUSIQuAcbx/qllTuNExv5okI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UP2TYXXu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jAeE/oY8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UP2TYXXu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jAeE/oY8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UP2TYXXu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jAeE/oY8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UP2TYXXu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jAeE/oY8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D0AE47A16B;
	Mon, 20 Jul 2026 19:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784576990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r0XJ3fjsqxe16YurdqaLFEojzTTAhcPXB8yrKoW5z/g=;
	b=UP2TYXXuanVA9zkO37NYaJvJkDnnhY/78t9QwWTSJ4U4VkO2mlSUuGLU06ywhjQfUyMhBE
	kFHFbT+Eh+YmkoCyH7jaIyDYdipVGSd4BeojG4aZq6/joccSWFrqiIEeiqWoFn4XiXHBGh
	Jv2WvUC0GyjZFLEIosJ1RI0InN/zGGA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784576990;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r0XJ3fjsqxe16YurdqaLFEojzTTAhcPXB8yrKoW5z/g=;
	b=jAeE/oY81YNduvjmvxXlGa9zk/q207VxOPs93p/t/QF08z1qedBdG5bCEpBDLvRzlwVBcX
	ngCM6t3R7lA2qsBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784576990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r0XJ3fjsqxe16YurdqaLFEojzTTAhcPXB8yrKoW5z/g=;
	b=UP2TYXXuanVA9zkO37NYaJvJkDnnhY/78t9QwWTSJ4U4VkO2mlSUuGLU06ywhjQfUyMhBE
	kFHFbT+Eh+YmkoCyH7jaIyDYdipVGSd4BeojG4aZq6/joccSWFrqiIEeiqWoFn4XiXHBGh
	Jv2WvUC0GyjZFLEIosJ1RI0InN/zGGA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784576990;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r0XJ3fjsqxe16YurdqaLFEojzTTAhcPXB8yrKoW5z/g=;
	b=jAeE/oY81YNduvjmvxXlGa9zk/q207VxOPs93p/t/QF08z1qedBdG5bCEpBDLvRzlwVBcX
	ngCM6t3R7lA2qsBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A53B779AA;
	Mon, 20 Jul 2026 19:49:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YT0gCN57XmquCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Jul 2026 19:49:50 +0000
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
Subject: [PATCH v2 06/14] smb: common: compress: drop 'allow_chained' arg from smb_decompress_chained()
Date: Mon, 20 Jul 2026 16:49:17 -0300
Message-ID: <20260720194925.2108840-6-ematsumiya@suse.de>
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
X-Spam-Score: -6.80
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLkmoi5kqpkgjx3hbiagnu7sfh)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

That arg is redundant as the function is already only called when
chaining was detected on header.

Also 'NONE' payloads are allowed as the first payload when chained, so
check for it only if not chained.

Other changes:
- remove 'first' variable, check only the first
  payload->Flags == CHAINED, then == NONE in the loop
- code style changes

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/common/compress/compress.c | 72 ++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 31 deletions(-)

diff --git a/fs/smb/common/compress/compress.c b/fs/smb/common/compress/compress.c
index 75d21622c268..64c33af95877 100644
--- a/fs/smb/common/compress/compress.c
+++ b/fs/smb/common/compress/compress.c
@@ -87,8 +87,7 @@ static int smb_decompress_lz77_payload(const u8 **src, u32 *slen, u8 **dst,
 	return 0;
 }
 
-static int smb_decompress_chained(__le16 alg, bool allow_chained,
-				  const struct smb2_compression_hdr *hdr,
+static int smb_decompress_chained(__le16 alg, const struct smb2_compression_hdr *hdr,
 				  u32 slen, void *dst, u32 dlen)
 {
 	const struct smb2_compression_payload_hdr *payload;
@@ -97,10 +96,17 @@ static int smb_decompress_chained(__le16 alg, bool allow_chained,
 	u32 remaining = slen - SMB2_COMPRESSION_CHAINED_HDR_LEN;
 	u8 *out = dst;
 	u32 out_remaining = dlen;
-	bool first = true;
 	int rc;
 
-	if (!allow_chained || orig_size != dlen)
+	if (orig_size != dlen)
+		return -EINVAL;
+
+	payload = (const struct smb2_compression_payload_hdr *)src;
+	/*
+	 * CHAINED marks only the first payload. Requiring NONE on every
+	 * later payload rejects ambiguous or independently chained data.
+	 */
+	if (unlikely(payload->Flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED)))
 		return -EINVAL;
 
 	/*
@@ -110,43 +116,40 @@ static int smb_decompress_chained(__le16 alg, bool allow_chained,
 	 */
 	while (remaining) {
 		__le16 payload_alg;
-		__le16 flags;
 		u32 len;
 
 		if (remaining < SMB2_COMPRESSION_PAYLOAD_BASE_LEN)
 			return -EINVAL;
 
-		payload = (const struct smb2_compression_payload_hdr *)src;
 		payload_alg = payload->CompressionAlgorithm;
-		flags = payload->Flags;
-		len = le32_to_cpu(payload->Length);
-
-		/*
-		 * CHAINED marks only the first payload. Requiring NONE on every
-		 * later payload rejects ambiguous or independently chained data.
-		 */
-		if ((first && flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED)) ||
-		    (!first && flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE)))
+		if (unlikely(!smb_compress_alg_valid(payload_alg, true)))
 			return -EINVAL;
 
+		len = le32_to_cpu(payload->Length);
 		src += SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
 		remaining -= SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
 
-		if (payload_alg == SMB3_COMPRESS_NONE) {
-			rc = smb_decompress_none(&src, &remaining, &out,
-						 &out_remaining, len);
-		} else if (payload_alg == SMB3_COMPRESS_PATTERN) {
-			rc = smb_decompress_pattern(&src, &remaining, &out,
-						    &out_remaining, len);
-		} else if (payload_alg == alg && alg == SMB3_COMPRESS_LZ77) {
+		rc = -EINVAL;
+		switch (payload_alg) {
+		case SMB3_COMPRESS_NONE:
+			rc = smb_decompress_none(&src, &remaining, &out, &out_remaining, len);
+			break;
+		case SMB3_COMPRESS_LZ77:
 			rc = smb_decompress_lz77_payload(&src, &remaining, &out,
 							 &out_remaining, len);
-		} else {
-			return -EINVAL;
+			break;
+		case SMB3_COMPRESS_PATTERN:
+			rc = smb_decompress_pattern(&src, &remaining, &out, &out_remaining, len);
+			break;
 		}
+
 		if (rc)
 			return rc;
-		first = false;
+
+		payload = (const struct smb2_compression_payload_hdr *)src;
+		if (remaining >= SMB2_COMPRESSION_PAYLOAD_BASE_LEN &&
+		    unlikely(payload->Flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE)))
+			return -EINVAL;
 	}
 
 	return out_remaining ? -EINVAL : 0;
@@ -195,15 +198,22 @@ int smb_compression_decompress(__le16 alg, bool allow_chained,
 	const struct smb2_compression_hdr *hdr = src;
 
 	if (!src || !dst || slen < sizeof(*hdr) ||
-	    hdr->ProtocolId != SMB2_COMPRESSION_TRANSFORM_ID ||
-	    alg == SMB3_COMPRESS_NONE)
+	    hdr->ProtocolId != SMB2_COMPRESSION_TRANSFORM_ID)
 		return -EINVAL;
 
-	if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED))
-		return smb_decompress_chained(alg, allow_chained, hdr, slen,
-					      dst, dlen);
+	/* If @allow_chained == true, the first payload hdr may have "NONE" algorithm */
+	if (unlikely(!allow_chained && (hdr->CompressionAlgorithm == SMB3_COMPRESS_NONE ||
+					hdr->CompressionAlgorithm == SMB3_COMPRESS_PATTERN)))
+		return -EINVAL;
+
+	if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED)) {
+		if (likely(allow_chained))
+			return smb_decompress_chained(alg, hdr, slen, dst, dlen);
+
+		return -EINVAL;
+	}
 
-	if (hdr->Flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE))
+	if (unlikely(hdr->Flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE) || allow_chained))
 		return -EINVAL;
 
 	return smb_decompress_unchained(alg, hdr, slen, dst, dlen);
-- 
2.54.0

