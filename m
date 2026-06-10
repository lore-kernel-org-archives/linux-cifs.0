Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E6B17BB21
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 15:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781104576; cv=none; b=e9Z2FlT3q8v7dpXpUTqxbyxUIaVPvlKtvbmR2CUSm9XcWun/Z2OgHImppN5cROV0n2QTJPcK3qy3wqk3XyYJwz7IwM514Bfq+tkaKU1sCfJMtMJQqpyrZxUWhJFl9+xrdRhoZVbXXfWvqbJXUPM7qFfP3hEQb2w0Duke/aFgemc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781104576; c=relaxed/simple;
	bh=K7fPtqoIi/RnZXt48mfBBVancOqeiKOUKLqaIbHou3E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nRq4TbqTBaChspuIEdWr3AwhJI5wzzOZsUJJOeS+hrQwVKFFHvVwK2s8phbXWcexKK7n/NSacCqiKhDOsMAVI0Ux2NhtzdHqtRdAwKqk6RCX2KGKIdFjjYWEe6vZxLk6g3HINbaYtTo1aTj6ycI8uK352z47snMM1lsiI44EVYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8kIpqMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8kIpqMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9395E1F00893;
	Wed, 10 Jun 2026 15:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781104574;
	bh=siY1CFET5YZMGgRkBGP9t7pSh4qwabEEJ85LoPQ+kPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8kIpqMX5UpDf9aEm/R9Zhdl69wPKMOcC8P2HTdRKo1RMrsT6PzSwqNlj/iX5da5v
	 vFbCs0BXoShigc3ZYjGzjZZsJMtv3v3IGyuPkjE+8230Dlp2B7sfyB41YndMeiPHrF
	 ut5olp+my1ZUsPiFKTVWFKVHIRDpIcdM1Thb3qxzPvG0qYMdP2NppFdzRqScXFj1xU
	 NobnC5bM97OmY9eURmEsupcNiq4kITuGqJaBfNGcnFsTsVTiUsDywvNLws+rM+dVw+
	 E9OhtOBGv1RSZQs3C2LtH4tHd7zle0vFoCmct+5FfDmXqpcMvXyKN/VBErRUCTCsmp
	 yBf8kCFfet1VA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/5] smb: add common SMB2 compression transform helpers
Date: Thu, 11 Jun 2026 00:15:40 +0900
Message-Id: <20260610151543.25218-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260610151543.25218-1-linkinjeon@kernel.org>
References: <20260610151543.25218-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement common validation, compression and decompression for SMB2
compression transforms.

Support unchained LZ77 and chained NONE, LZ77 and Pattern_V1 payloads.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/common/Makefile            |   2 +-
 fs/smb/common/compress/compress.c | 399 ++++++++++++++++++++++++++++++
 fs/smb/common/compress/compress.h |   6 +
 fs/smb/common/smb2pdu.h           |  11 +-
 4 files changed, 410 insertions(+), 8 deletions(-)
 create mode 100644 fs/smb/common/compress/compress.c

diff --git a/fs/smb/common/Makefile b/fs/smb/common/Makefile
index bd188d36fb6b..f2c6e09d4e77 100644
--- a/fs/smb/common/Makefile
+++ b/fs/smb/common/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_SMBFS) += cifs_md4.o
 obj-$(CONFIG_SMBFS) += smb_compress.o
 
-smb_compress-y := compress/lz77.o
+smb_compress-y := compress/compress.o compress/lz77.o
diff --git a/fs/smb/common/compress/compress.c b/fs/smb/common/compress/compress.c
new file mode 100644
index 000000000000..b07a317597a4
--- /dev/null
+++ b/fs/smb/common/compress/compress.c
@@ -0,0 +1,399 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * SMB2 compression transform helpers.
+ *
+ * Copyright (C) 2026 Namjae Jeon <linkinjeon@kernel.org>
+ */
+#include <linux/module.h>
+#include <linux/overflow.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
+
+#include "compress.h"
+#include "lz77.h"
+
+#define SMB2_COMPRESSION_CHAINED_HDR_LEN \
+	offsetof(struct smb2_compression_hdr, CompressionAlgorithm)
+#define SMB2_COMPRESSION_PAYLOAD_BASE_LEN \
+	(sizeof(struct smb2_compression_payload_hdr) - sizeof(__le32))
+
+/*
+ * A NONE payload carries bytes verbatim. Keep both cursors and remaining
+ * lengths together so every chained payload handler applies identical bounds
+ * accounting.
+ */
+static int smb_decompress_none(const u8 **src, u32 *slen, u8 **dst, u32 *dlen,
+			       u32 len)
+{
+	if (len > *slen || len > *dlen)
+		return -EINVAL;
+
+	memcpy(*dst, *src, len);
+	*src += len;
+	*slen -= len;
+	*dst += len;
+	*dlen -= len;
+	return 0;
+}
+
+/*
+ * Pattern_V1 represents a run of one byte. Its wire payload is always the
+ * fixed-size smb2_compression_pattern_v1 structure.
+ */
+static int smb_decompress_pattern(const u8 **src, u32 *slen, u8 **dst,
+				  u32 *dlen, u32 len)
+{
+	const struct smb2_compression_pattern_v1 *pattern;
+	u32 repetitions;
+
+	if (len != sizeof(*pattern) || len > *slen)
+		return -EINVAL;
+
+	pattern = (const struct smb2_compression_pattern_v1 *)*src;
+	repetitions = le32_to_cpu(pattern->Repetitions);
+	if (repetitions > *dlen)
+		return -EINVAL;
+
+	memset(*dst, pattern->Pattern, repetitions);
+	*src += len;
+	*slen -= len;
+	*dst += repetitions;
+	*dlen -= repetitions;
+	return 0;
+}
+
+/*
+ * LZ77 payload Length includes the four-byte OriginalPayloadSize field.
+ * Consume that field before passing the compressed stream to the raw codec.
+ */
+static int smb_decompress_lz77_payload(const u8 **src, u32 *slen, u8 **dst,
+				       u32 *dlen, u32 len)
+{
+	u32 orig_size;
+	int rc;
+
+	if (len < sizeof(__le32) || len > *slen)
+		return -EINVAL;
+
+	orig_size = get_unaligned_le32(*src);
+	if (orig_size > *dlen)
+		return -EINVAL;
+
+	*src += sizeof(__le32);
+	*slen -= sizeof(__le32);
+	len -= sizeof(__le32);
+
+	rc = smb_lz77_decompress(*src, len, *dst, orig_size);
+	if (rc)
+		return rc;
+
+	*src += len;
+	*slen -= len;
+	*dst += orig_size;
+	*dlen -= orig_size;
+	return 0;
+}
+
+static int smb_decompress_chained(__le16 alg, bool allow_chained,
+				  const struct smb2_compression_hdr *hdr,
+				  u32 slen, void *dst, u32 dlen)
+{
+	const struct smb2_compression_payload_hdr *payload;
+	const u8 *src = (const u8 *)hdr + SMB2_COMPRESSION_CHAINED_HDR_LEN;
+	u32 orig_size = le32_to_cpu(hdr->OriginalCompressedSegmentSize);
+	u32 remaining = slen - SMB2_COMPRESSION_CHAINED_HDR_LEN;
+	u8 *out = dst;
+	u32 out_remaining = dlen;
+	bool first = true;
+	int rc;
+
+	if (!allow_chained || orig_size != dlen)
+		return -EINVAL;
+
+	/*
+	 * The chained transform has an eight-byte top-level header. The next
+	 * bytes are a sequence of payload headers whose Length fields account
+	 * for payload data, including OriginalPayloadSize where applicable.
+	 */
+	while (remaining) {
+		__le16 payload_alg;
+		__le16 flags;
+		u32 len;
+
+		if (remaining < SMB2_COMPRESSION_PAYLOAD_BASE_LEN)
+			return -EINVAL;
+
+		payload = (const struct smb2_compression_payload_hdr *)src;
+		payload_alg = payload->CompressionAlgorithm;
+		flags = payload->Flags;
+		len = le32_to_cpu(payload->Length);
+
+		/*
+		 * CHAINED marks only the first payload. Requiring NONE on every
+		 * later payload rejects ambiguous or independently chained data.
+		 */
+		if ((first && flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED)) ||
+		    (!first && flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE)))
+			return -EINVAL;
+
+		src += SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
+		remaining -= SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
+
+		if (payload_alg == SMB3_COMPRESS_NONE) {
+			rc = smb_decompress_none(&src, &remaining, &out,
+						 &out_remaining, len);
+		} else if (payload_alg == SMB3_COMPRESS_PATTERN) {
+			rc = smb_decompress_pattern(&src, &remaining, &out,
+						    &out_remaining, len);
+		} else if (payload_alg == alg && alg == SMB3_COMPRESS_LZ77) {
+			rc = smb_decompress_lz77_payload(&src, &remaining, &out,
+							 &out_remaining, len);
+		} else {
+			return -EINVAL;
+		}
+		if (rc)
+			return rc;
+		first = false;
+	}
+
+	return out_remaining ? -EINVAL : 0;
+}
+
+static int smb_decompress_unchained(__le16 alg,
+				    const struct smb2_compression_hdr *hdr,
+				    u32 slen, void *dst, u32 dlen)
+{
+	u32 orig_size, offset, comp_size;
+
+	if (hdr->CompressionAlgorithm != alg ||
+	    !smb_compress_alg_valid(hdr->CompressionAlgorithm, false))
+		return -EINVAL;
+
+	orig_size = le32_to_cpu(hdr->OriginalCompressedSegmentSize);
+	offset = le32_to_cpu(hdr->Offset);
+	if (offset > slen - sizeof(*hdr) || offset > dlen ||
+	    orig_size > dlen - offset || orig_size + offset != dlen)
+		return -EINVAL;
+
+	memcpy(dst, (const u8 *)hdr + sizeof(*hdr), offset);
+	comp_size = slen - sizeof(*hdr) - offset;
+	return smb_lz77_decompress((const u8 *)hdr + sizeof(*hdr) + offset,
+				   comp_size, (u8 *)dst + offset, orig_size);
+}
+
+/**
+ * smb_compression_decompress() - decode an SMB2 compression transform
+ * @alg: negotiated general-purpose compression algorithm
+ * @allow_chained: whether chained transforms were negotiated
+ * @src: transform header followed by compressed payload data
+ * @slen: total number of bytes available at @src
+ * @dst: output buffer for the reconstructed SMB2 message
+ * @dlen: exact expected size of the reconstructed SMB2 message
+ *
+ * Validate the transform type and negotiated capabilities before dispatching
+ * to the chained or unchained decoder. The caller supplies the expected output
+ * size after applying its transport-specific message size limits.
+ *
+ * Return: 0 on success, otherwise a negative errno.
+ */
+int smb_compression_decompress(__le16 alg, bool allow_chained,
+			       const void *src, u32 slen, void *dst, u32 dlen)
+{
+	const struct smb2_compression_hdr *hdr = src;
+
+	if (!src || !dst || slen < sizeof(*hdr) ||
+	    hdr->ProtocolId != SMB2_COMPRESSION_TRANSFORM_ID ||
+	    alg == SMB3_COMPRESS_NONE)
+		return -EINVAL;
+
+	if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED))
+		return smb_decompress_chained(alg, allow_chained, hdr, slen,
+					      dst, dlen);
+
+	if (hdr->Flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE))
+		return -EINVAL;
+
+	return smb_decompress_unchained(alg, hdr, slen, dst, dlen);
+}
+EXPORT_SYMBOL_GPL(smb_compression_decompress);
+
+struct smb_compression_builder {
+	u8 *pos;
+	u32 remaining;
+	bool first;
+};
+
+/*
+ * Reserve one chained payload header and initialize its common fields.
+ * OriginalPayloadSize is present only for LZNT1/LZ77/LZ77+Huffman payloads.
+ */
+static struct smb2_compression_payload_hdr *
+smb_compression_add_payload(struct smb_compression_builder *builder,
+			    __le16 alg, u32 payload_len, bool orig_size)
+{
+	struct smb2_compression_payload_hdr *payload;
+	u32 hdr_len = SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
+	u32 total_len;
+
+	if (orig_size)
+		hdr_len += sizeof(payload->OriginalPayloadSize);
+	if (check_add_overflow(hdr_len, payload_len, &total_len) ||
+	    total_len > builder->remaining)
+		return NULL;
+
+	payload = (struct smb2_compression_payload_hdr *)builder->pos;
+	payload->CompressionAlgorithm = alg;
+	payload->Flags = cpu_to_le16(builder->first ?
+		SMB2_COMPRESSION_FLAG_CHAINED : SMB2_COMPRESSION_FLAG_NONE);
+	payload->Length = cpu_to_le32(payload_len +
+		(orig_size ? sizeof(payload->OriginalPayloadSize) : 0));
+
+	builder->pos += hdr_len;
+	builder->remaining -= hdr_len;
+	builder->first = false;
+	return payload;
+}
+
+static int smb_compression_add_pattern(struct smb_compression_builder *builder,
+				       u8 pattern, u32 repetitions)
+{
+	struct smb2_compression_pattern_v1 *payload;
+
+	if (!smb_compression_add_payload(builder, SMB3_COMPRESS_PATTERN,
+					 sizeof(*payload), false))
+		return -ENOSPC;
+
+	payload = (struct smb2_compression_pattern_v1 *)builder->pos;
+	payload->Pattern = pattern;
+	payload->Reserved1 = 0;
+	payload->Reserved2 = 0;
+	payload->Repetitions = cpu_to_le32(repetitions);
+	builder->pos += sizeof(*payload);
+	builder->remaining -= sizeof(*payload);
+	return 0;
+}
+
+static int smb_compression_add_none(struct smb_compression_builder *builder,
+				    const u8 *src, u32 len)
+{
+	if (!smb_compression_add_payload(builder, SMB3_COMPRESS_NONE, len, false))
+		return -ENOSPC;
+
+	memcpy(builder->pos, src, len);
+	builder->pos += len;
+	builder->remaining -= len;
+	return 0;
+}
+
+static int smb_compression_add_lz77(struct smb_compression_builder *builder,
+				    const u8 *src, u32 len)
+{
+	struct smb2_compression_payload_hdr *payload;
+	u32 comp_len;
+	int rc;
+
+	if (builder->remaining <= sizeof(*payload))
+		return -ENOSPC;
+
+	comp_len = builder->remaining - sizeof(*payload);
+	payload = smb_compression_add_payload(builder, SMB3_COMPRESS_LZ77,
+					      comp_len, true);
+	if (!payload)
+		return -ENOSPC;
+
+	rc = smb_lz77_compress(src, len, builder->pos, &comp_len);
+	if (rc)
+		return rc;
+
+	payload->Length = cpu_to_le32(comp_len +
+				      sizeof(payload->OriginalPayloadSize));
+	payload->OriginalPayloadSize = cpu_to_le32(len);
+	builder->pos += comp_len;
+	builder->remaining -= comp_len;
+	return 0;
+}
+
+/**
+ * smb_compression_compress_chained() - build a chained SMB2 transform
+ * @alg: negotiated general-purpose compression algorithm
+ * @allow_pattern: whether Pattern_V1 was negotiated
+ * @src: complete uncompressed SMB2 message
+ * @slen: size of @src
+ * @dst: output buffer for the transform
+ * @dlen: input capacity of @dst and output transform size
+ *
+ * Following the algorithm in [MS-SMB2] 3.1.4.4, encode sufficiently long
+ * repeated runs at the front and back as Pattern_V1 payloads. Compress a
+ * middle region larger than 1 KiB with LZ77; smaller middle regions are
+ * represented by a chained NONE payload.
+ *
+ * This helper does not decide whether the final transform is smaller than the
+ * original message. The transport caller owns that policy decision.
+ *
+ * Return: 0 on success, otherwise a negative errno.
+ */
+int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
+				     const void *src, u32 slen,
+				     void *dst, u32 *dlen)
+{
+	struct smb2_compression_hdr *hdr = dst;
+	struct smb_compression_builder builder;
+	const u8 *input = src;
+	u32 forward = 0, backward = 0, middle_len;
+	int rc;
+
+	if (!src || !dst || !dlen || alg != SMB3_COMPRESS_LZ77 ||
+	    *dlen <= SMB2_COMPRESSION_CHAINED_HDR_LEN || !slen)
+		return -EINVAL;
+
+	hdr->ProtocolId = SMB2_COMPRESSION_TRANSFORM_ID;
+	hdr->OriginalCompressedSegmentSize = cpu_to_le32(slen);
+	builder.pos = (u8 *)dst + SMB2_COMPRESSION_CHAINED_HDR_LEN;
+	builder.remaining = *dlen - SMB2_COMPRESSION_CHAINED_HDR_LEN;
+	builder.first = true;
+
+	if (allow_pattern && slen > 32) {
+		for (forward = 1; forward < slen; forward++) {
+			if (input[forward] != input[0])
+				break;
+		}
+		if (forward <= 32)
+			forward = 0;
+
+		for (backward = 1; backward < slen - forward; backward++) {
+			if (input[slen - backward - 1] != input[slen - 1])
+				break;
+		}
+		if (backward <= 32)
+			backward = 0;
+	}
+
+	if (forward) {
+		rc = smb_compression_add_pattern(&builder, input[0], forward);
+		if (rc)
+			return rc;
+	}
+
+	middle_len = slen - forward - backward;
+	if (middle_len > 1024)
+		rc = smb_compression_add_lz77(&builder, input + forward,
+					      middle_len);
+	else if (middle_len)
+		rc = smb_compression_add_none(&builder,
+					      input + forward, middle_len);
+	else
+		rc = 0;
+	if (rc)
+		return rc;
+
+	if (backward) {
+		rc = smb_compression_add_pattern(&builder, input[slen - 1],
+						 backward);
+		if (rc)
+			return rc;
+	}
+
+	*dlen = builder.pos - (u8 *)dst;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(smb_compression_compress_chained);
diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
index b504cd38b128..7ace3bf4b664 100644
--- a/fs/smb/common/compress/compress.h
+++ b/fs/smb/common/compress/compress.h
@@ -19,4 +19,10 @@ static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
 	return alg == SMB3_COMPRESS_LZ77 || alg == SMB3_COMPRESS_PATTERN;
 }
 
+int smb_compression_decompress(__le16 alg, bool allow_chained,
+			       const void *src, u32 slen, void *dst, u32 dlen);
+int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
+				     const void *src, u32 slen,
+				     void *dst, u32 *dlen);
+
 #endif /* _COMMON_SMB_COMPRESS_H */
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index aeb0a245c532..325ff83b12fe 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -218,10 +218,9 @@ struct smb2_transform_hdr {
  * These are simplified versions from the spec, as we don't need a fully fledged
  * form of both unchained and chained structs.
  *
- * Moreover, even in chained compressed payloads, the initial compression header
- * has the form of the unchained one -- i.e. it never has the
- * OriginalPayloadSize field and ::Offset field always represent an offset
- * (instead of a length, as it is in the chained header).
+ * For chained payloads, only the first 8 bytes belong to the transform header.
+ * CompressionAlgorithm, Flags and Offset below overlay the first chained
+ * payload header, where Offset represents Length.
  *
  * See MS-SMB2 2.2.42 for more details.
  */
@@ -524,9 +523,7 @@ struct smb2_compression_capabilities_context {
 	__le16	CompressionAlgorithmCount;
 	__le16	Padding;
 	__le32	Flags;
-	__le16	CompressionAlgorithms[3];
-	__u16	Pad;  /* Some servers require pad to DataLen multiple of 8 */
-	/* Check if pad needed */
+	__le16	CompressionAlgorithms[4];
 } __packed;
 
 /*
-- 
2.25.1

