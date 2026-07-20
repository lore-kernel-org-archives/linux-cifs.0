Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AC03859F5
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 19:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577017; cv=none; b=OtcvZEPcdgiwWBEnG9EjV9Yk8iqMmopNuBYZJB+fsPfAL5BYmeNxssGvvcz+OBSQeWeDUwDw4w+3+lk4yQjNwkGa9DfYGLcFNsJJDYwbjr3sj14lzLn2wmPmNXDz9HjH1KO/VcOniYxkRuOKlYTWRfsqeXLePzucD6yFlRxJSlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577017; c=relaxed/simple;
	bh=xcdMoyHiggEz4ijVKntjora0vKpsrhB/i8+2KjyIWgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFgO0th8ELYQUyX5LsYpl/Li+uOU4Bpzrz3ss4wtutpKzuYtlbv9yBiAcuHwpCAY8pjAfVNLgzA64BlahY2S7g4l2hzGiR7fEeqMNtjC8yyTCKdpxPJtF3whhxqnKNcX5iJpD4UVV9QhjjgUkvoXfbMYr1xVJR3ow/5BBUr2F7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1CF603E93;
	Mon, 20 Jul 2026 19:50:14 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DADB779AA;
	Mon, 20 Jul 2026 19:50:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LfESGfV7XmrQCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Jul 2026 19:50:13 +0000
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
Subject: [PATCH v2 12/14] smb: client: add support for decompressing READs
Date: Mon, 20 Jul 2026 16:49:23 -0300
Message-ID: <20260720194925.2108840-12-ematsumiya@suse.de>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 1CF603E93
X-Rspamd-Action: no action

Implement decompression support for SMB2 READ messages.

Changes:
- smb2ops.c: add receive_compressed() and check_decompressed_smb2()
  - check for compress header in smb3_is_transform_hdr() as well so we
    fall into the same path handling offloaded READ decryption
- common/compress/compress.h: add is_compress_hdr() and
  smb_decompress_alloc_size() helpers

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/smb2ops.c           | 160 +++++++++++++++++++++++++++++-
 fs/smb/client/smb2pdu.c           |   6 ++
 fs/smb/common/compress/compress.h |  86 ++++++++++++++++
 3 files changed, 251 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d60bc537ecf1..09cbc00e83b0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -30,6 +30,8 @@
 #include "fs_context.h"
 #include "cached_dir.h"
 #include "reparse.h"
+#include "../common/compress/compress.h"
+#include "compress.h"
 
 /* Change credits for different ops and return the total number of credits */
 static int
@@ -4714,7 +4716,7 @@ smb3_is_transform_hdr(void *buf)
 {
 	struct smb2_transform_hdr *trhdr = buf;
 
-	return trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM;
+	return (trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) || is_compress_hdr(buf);
 }
 
 static int
@@ -5246,6 +5248,153 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	return ret;
 }
 
+static __always_inline bool check_decompressed_smb2(const void *buf, const u32 len)
+{
+	const struct smb2_read_rsp *rsp = buf;
+
+	if (unlikely(rsp->hdr.ProtocolId != SMB2_PROTO_NUMBER)) {
+		cifs_dbg(VFS, "decompressed message is not an SMB2 message (got ProtocolId 0x%x)\n",
+			 rsp->hdr.ProtocolId);
+		return false;
+	}
+
+	if (unlikely(rsp->hdr.Command != SMB2_READ)) {
+		cifs_dbg(VFS, "decompressed message is not an SMB2 READ (got %u)\n",
+			 le16_to_cpu(rsp->hdr.Command));
+		return false;
+	}
+
+	if (unlikely(le32_to_cpu(rsp->DataLength) != len)) {
+		cifs_dbg(VFS, "invalid decompressed length for SMB2 READ (got %u, expected %u)\n",
+			 le32_to_cpu(rsp->DataLength), len);
+		return false;
+	}
+
+	return true;
+}
+
+static int receive_compressed(struct TCP_Server_Info *server)
+{
+	struct mid_q_entry *mid;
+	void *src = NULL, *dst = NULL;
+	u32 slen, dlen;
+	int read, ret;
+
+	/* smb2_compression_pattern_v1 is the smallest compressed data we can have. */
+	slen = server->pdu_size;
+	if (unlikely(slen < sizeof(struct smb2_compression_hdr) +
+			    sizeof(struct smb2_compression_pattern_v1))) {
+		ret = -EINVAL;
+		goto err_free;
+	}
+
+	src = kvzalloc(slen, GFP_KERNEL);
+	if (unlikely(!src)) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
+	read = server->total_read;
+	if (unlikely(read > slen)) {
+		ret = -EINVAL;
+		goto err_free;
+	}
+
+	memcpy(src, server->smallbuf, read);
+	ret = cifs_read_from_socket(server, src + read, slen - read);
+	if (ret < 0)
+		goto err_free;
+
+	server->total_read += ret;
+	if (unlikely(slen - ret != read)) {
+		ret = -EINVAL;
+		goto err_free;
+	}
+
+	ret = -EINVAL;
+	read = server->vals->read_rsp_size;
+	dlen = smb_decompress_alloc_size(src, slen, read, read + 256 +
+					 SMB2_COMPRESSION_PAYLOAD_BASE_LEN + server->max_read,
+					 server->compression.chained);
+	if (unlikely(dlen == 0))
+		goto err_free;
+
+	dst = kvzalloc(dlen, GFP_KERNEL);
+	if (unlikely(!dst)) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
+	ret = smb_compression_decompress(server->compression.alg, server->compression.chained,
+					 src, slen, dst, dlen);
+	if (unlikely(ret))
+		goto err_free;
+
+	if (unlikely(!check_decompressed_smb2(dst, dlen - server->vals->read_rsp_size))) {
+		ret = -EINVAL;
+		goto err_free;
+	}
+
+	mid = smb2_find_dequeue_mid(server, dst);
+	if (!mid) {
+		ret = -EIO;
+		goto err_free;
+	}
+
+	ret = handle_read_data(server, mid, dst, dlen, NULL, 0, true);
+	if (!ret) {
+		struct cifs_io_subrequest *rdata = mid->callback_data;
+#ifdef CONFIG_CIFS_STATS2
+		mid->when_received = jiffies;
+#endif
+		if (server->ops->is_network_name_deleted)
+			server->ops->is_network_name_deleted(dst, server);
+
+		rdata->iov[0].iov_base = dst;
+		rdata->iov[0].iov_len = server->vals->read_rsp_size;
+		mid_execute_callback(server, mid);
+	} else {
+		spin_lock(&server->srv_lock);
+		if (server->tcpStatus == CifsNeedReconnect) {
+			spin_lock(&server->mid_queue_lock);
+			mid->mid_state = MID_RETRY_NEEDED;
+			spin_unlock(&server->mid_queue_lock);
+			spin_unlock(&server->srv_lock);
+
+			mid_execute_callback(server, mid);
+		} else {
+			spin_lock(&server->mid_queue_lock);
+			mid->mid_state = MID_REQUEST_SUBMITTED;
+			mid->deleted_from_q = false;
+			list_add_tail(&mid->qhead, &server->pending_mid_q);
+			spin_unlock(&server->mid_queue_lock);
+			spin_unlock(&server->srv_lock);
+		}
+	}
+
+	release_mid(server, mid);
+err_free:
+	kvfree(src);
+	kvfree(dst);
+
+	/*
+	 * We _must_ disconnect on any failed decompression.
+	 * Actually, there's not much we can do to handle different decompression errors here, so
+	 * forcing a reconnect (which will disable compression) is our best option as the request
+	 * should be retried.
+	 */
+	if (unlikely(ret)) {
+		/* Alias only if not -ENOMEM */
+		if (ret != -ENOMEM)
+			ret = -ECONNRESET;
+		spin_lock(&server->srv_lock);
+		server->tcpStatus = CifsNeedReconnect;
+		spin_unlock(&server->srv_lock);
+	}
+
+	return ret;
+}
+
 static int
 smb3_receive_transform(struct TCP_Server_Info *server,
 		       struct mid_q_entry **mids, char **bufs, int *num_mids)
@@ -5255,6 +5404,13 @@ smb3_receive_transform(struct TCP_Server_Info *server,
 	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
 	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 
+	if (is_compress_hdr(buf))
+		return receive_compressed(server);
+
+	/*
+	 * @buf is either a compress or transform (encrypt) header, previously checked by cifsd
+	 * (or we wouldn't reach here), so no need to check again.
+	 */
 	if (pdu_length < sizeof(struct smb2_transform_hdr) +
 						sizeof(struct smb2_hdr)) {
 		cifs_server_dbg(VFS, "Transform message is too small (%u)\n",
@@ -5296,6 +5452,8 @@ static int smb2_next_header(struct TCP_Server_Info *server, char *buf,
 		*noff = le32_to_cpu(t_hdr->OriginalMessageSize);
 		if (unlikely(check_add_overflow(*noff, sizeof(*t_hdr), noff)))
 			return -EINVAL;
+	} else if (hdr->ProtocolId == SMB2_COMPRESSION_TRANSFORM_ID) {
+		*noff = 0;
 	} else {
 		*noff = le32_to_cpu(hdr->NextCommand);
 	}
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e58ac7be30a3..bf2b3c7fa4b8 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4933,6 +4933,12 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 		flags |= CIFS_HAS_CREDITS;
 	}
 
+	if (should_compress(io_parms.tcon, &rqst)) {
+		struct smb2_read_req *req = (struct smb2_read_req *)buf;
+
+		req->Flags |= SMB2_READFLAG_REQUEST_COMPRESSED;
+	}
+
 	rc = cifs_call_async(server, &rqst,
 			     cifs_readv_receive, smb2_readv_callback,
 			     smb3_handle_read_data, rdata, flags,
diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
index 43dba4bb1176..e0ec41a21505 100644
--- a/fs/smb/common/compress/compress.h
+++ b/fs/smb/common/compress/compress.h
@@ -152,6 +152,92 @@ static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
 	return false;
 }
 
+static __always_inline bool is_compress_hdr(const void *buf)
+{
+	const struct smb2_compression_hdr *hdr = buf;
+
+	return likely(hdr) && hdr->ProtocolId == SMB2_COMPRESSION_TRANSFORM_ID;
+}
+
+/**
+ * smb_decompress_alloc_size() - Validate received SMB2 compression header + return allocation size
+ *				 for the decompressed buffer.
+ * @buf: received buffer
+ * @pdu_size: size of @buf
+ * @dmin: minimum decompressed size allowed (inclusive)
+ * @dmax: maximum decompressed size allowed (inclusive)
+ * @chained: if chaining was negotiated
+ *
+ * Return: decompressed size, or 0 if invalid.
+ */
+static __always_inline u32 smb_decompress_alloc_size(const void *buf, const u32 pdu_size,
+						     const u32 dmin, const u32 dmax, bool chained)
+{
+	const struct smb2_compression_hdr *hdr = buf;
+	__le16 alg, flags;
+	u32 len;
+
+	if (unlikely(!is_compress_hdr(buf) || pdu_size < sizeof(*hdr))) {
+		pr_warn("invalid SMB2 compressed buffer/header\n");
+		return 0;
+	}
+
+	len = le32_to_cpu(hdr->OriginalCompressedSegmentSize);
+	alg = le16_to_cpu(hdr->CompressionAlgorithm);
+	flags = le16_to_cpu(hdr->Flags);
+
+	if (flags == SMB2_COMPRESSION_FLAG_CHAINED) {
+		if (unlikely(!chained)) {
+			pr_warn("chained payload but chaining wasn't negotiated\n");
+			return 0;
+		}
+
+		if (unlikely(!smb_compress_alg_valid(alg, true))) {
+			pr_warn("invalid chained compression algorithm (%u)\n", alg);
+			return 0;
+		}
+
+		/* This is the first payload_hdr->Length field, so it can never be 0 */
+		if (unlikely(le32_to_cpu(hdr->Offset) == 0)) {
+			pr_warn("invalid chained compression payload length 0\n");
+			return 0;
+		}
+	} else if (flags == SMB2_COMPRESSION_FLAG_NONE) {
+		/*
+		 * When unchained, we must account for the offset (uncompressed) part as well
+		 * (usually SMB2 header, but can be anything).
+		 */
+		u32 res, offset = le32_to_cpu(hdr->Offset);
+
+		if (unlikely(chained)) {
+			pr_warn("unchained payload but chaining negotiated\n");
+			return 0;
+		}
+
+		if (unlikely(offset > pdu_size - sizeof(*hdr) ||
+			     check_add_overflow(len, offset, &res))) {
+			pr_warn("invalid unchained compression offset (%u, len=%u)\n", offset, len);
+			return 0;
+		}
+
+		len = res;
+		if (unlikely(!smb_compress_alg_valid(alg, false) || alg == SMB3_COMPRESS_PATTERN)) {
+			pr_warn("invalid unchained compression algorithm (%u)\n", alg);
+			return 0;
+		}
+	} else {
+		pr_warn("invalid SMB2 compression flags (0x%x)\n", flags);
+		return 0;
+	}
+
+	if (unlikely(len < dmin || len > dmax)) {
+		pr_warn("decompressed size %u out of range (min=%u, max=%u)\n", len, dmin, dmax);
+		return 0;
+	}
+
+	return len;
+}
+
 /**
  * smb_compress_alloc_size() - Compute total allocation size required for compressed (dst) buffer.
  * @size:		uncompressed size
-- 
2.54.0

