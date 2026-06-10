Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13912DC79A
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 15:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781104584; cv=none; b=SVK4/nsHcdg7/wR5W5rnZS9d2ZxUWQvuGjhHf1MFlEmefWj++KdqwNLGrSogPUztiIXZJPczZxDsb/SsWCEZKCDHdToy3U01fN2hHI/lFLbVdGnpg/yjzIhw4DvztslxehmjMNWS8sjlv0NS72CGiRCQlyUwF/OlG0sAG3LQcHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781104584; c=relaxed/simple;
	bh=fHZq2iG/GdpXb9TgI/hga9bi1OB/9dbL75XnV31tKpM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q0i2cSFOnDveY3hvmgWyPYqtNtXHGBfoU8bd1PBNw3up+QQQs2e2rIPxdogMfENopTjmXE9ZPXOxWybPv8vJUDUIvB5hk1oK4MieggxcpKAdLL8at5+T958oo/So7mB8pr97gNGmDsIbsEN5TUJFLrt5Ax/BC0bUuEmpJh6FMEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTvOsmQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTvOsmQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532921F00898;
	Wed, 10 Jun 2026 15:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781104582;
	bh=QR7STUmqxTPJkY1xhC/S6lDRYWw4qbOFnTr/KlAiKCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTvOsmQaDxs947LHkBsObZjOomXeLNOnIIrHJGaOHUhKwksL2Wapu2JdHiVNHHNmd
	 T4GIqdEZvTzByO1jueV0/2EHr47gJHpFatDz5RD8+ZEbhCREdTtn0cpRbTZJytNtBq
	 gqXHP3bOumiP23eaJzuI7Wh4p+fDp2zNPR2rzou+45z0kcsr3Ukr86LlYPlFrypmAm
	 EjGNUiZmXUBT3Y8pGKtQX0i77YbbZBHs2B2UyAzaWBJOjMW0l44oTBFGebVRz70ZK+
	 qsYO5Nq2Uwzy5LTxjcg0c2YRayf5GNFKgu7nS4Z3DziOszxefaBJRtb/0QWu0wNSSk
	 0fpfdPojTr9nQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5/5] ksmbd: compress SMB2 READ responses
Date: Thu, 11 Jun 2026 00:15:43 +0900
Message-Id: <20260610151543.25218-6-linkinjeon@kernel.org>
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

Handle SMB2_READFLAG_REQUEST_COMPRESSED for non-RDMA reads.

Flatten the response iov, emit chained or unchained LZ77 transforms when
compression is beneficial, and retain the generated buffer until the work
item is released.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/compress.c   | 132 +++++++++++++++++++++++++++++++++++++
 fs/smb/server/compress.h   |   1 +
 fs/smb/server/ksmbd_work.c |   1 +
 fs/smb/server/ksmbd_work.h |   4 ++
 fs/smb/server/server.c     |  10 +++
 fs/smb/server/smb2pdu.c    |   9 +++
 6 files changed, 157 insertions(+)

diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index 7c9f8a6cceb8..f8cf515b9c30 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -10,6 +10,9 @@
 
 #include "compress.h"
 #include "smb_common.h"
+#include "../common/compress/lz77.h"
+
+#define SMB_COMPRESS_MIN_LEN	PAGE_SIZE
 
 /**
  * ksmbd_decompress_request() - replace a compressed request with its SMB2 PDU
@@ -75,3 +78,132 @@ int ksmbd_decompress_request(struct ksmbd_conn *conn)
 	conn->request_buf = out;
 	return 0;
 }
+
+/**
+ * ksmbd_compress_response() - compress an eligible ksmbd response
+ * @work: request work item containing the response iov
+ *
+ * Compression transforms describe one contiguous SMB2 message, while ksmbd
+ * builds responses from multiple iov entries. Flatten the response first,
+ * produce the negotiated transform, and replace the response iov only when the
+ * result is smaller than the original message.
+ *
+ * Encrypted and compound responses are intentionally left unchanged. The
+ * caller may still continue sending the original response when this function
+ * returns zero.
+ *
+ * Return: 1 if the response was replaced, 0 if compression was skipped, or a
+ * negative errno on failure.
+ */
+int ksmbd_compress_response(struct ksmbd_work *work)
+{
+	struct smb2_compression_hdr *chdr;
+	struct smb2_hdr *req_hdr;
+	u32 src_len, dst_len, compressed_pdu_len, max_dst_len;
+	u8 *src = NULL, *out = NULL, *p;
+	int i, rc;
+
+	if (!work->compress_response || work->encrypted ||
+	    work->conn->compress_algorithm != SMB3_COMPRESS_LZ77)
+		return 0;
+
+	req_hdr = smb_get_msg(work->request_buf);
+	if (req_hdr->NextCommand || work->next_smb2_rcv_hdr_off ||
+	    work->next_smb2_rsp_hdr_off)
+		return 0;
+
+	src_len = get_rfc1002_len(work->iov[0].iov_base);
+	if (src_len < SMB_COMPRESS_MIN_LEN)
+		return 0;
+
+	src = kvmalloc(src_len, KSMBD_DEFAULT_GFP);
+	if (!src)
+		return -ENOMEM;
+
+	p = src;
+	/* iov[0] contains only the RFC1002 length; the SMB2 PDU starts at iov[1]. */
+	for (i = 1; i < work->iov_cnt; i++) {
+		if (work->iov[i].iov_len > src + src_len - p) {
+			rc = -EINVAL;
+			goto out;
+		}
+		memcpy(p, work->iov[i].iov_base, work->iov[i].iov_len);
+		p += work->iov[i].iov_len;
+	}
+	if (p != src + src_len) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	max_dst_len = smb_lz77_compressed_alloc_size(src_len) +
+		sizeof(struct smb2_compression_hdr) +
+		3 * sizeof(struct smb2_compression_payload_hdr) +
+		2 * sizeof(struct smb2_compression_pattern_v1);
+	out = kvzalloc(sizeof(__be32) + max_dst_len,
+		       KSMBD_DEFAULT_GFP);
+	if (!out) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (work->conn->compress_chained) {
+		dst_len = max_dst_len;
+		rc = smb_compression_compress_chained(SMB3_COMPRESS_LZ77,
+						      work->conn->compress_pattern,
+						      src, src_len,
+						      out + sizeof(__be32),
+						      &dst_len);
+		if (rc == -EMSGSIZE || dst_len >= src_len) {
+			rc = 0;
+			goto out;
+		}
+		if (rc)
+			goto out;
+		compressed_pdu_len = dst_len;
+	} else {
+		/*
+		 * Peers which did not negotiate chained compression still use
+		 * the original 16-byte unchained transform format.
+		 */
+		dst_len = smb_lz77_compressed_alloc_size(src_len);
+		rc = smb_lz77_compress(src, src_len,
+				       out + sizeof(__be32) + sizeof(*chdr),
+				       &dst_len);
+		if (rc == -EMSGSIZE ||
+		    dst_len + sizeof(*chdr) >= src_len) {
+			rc = 0;
+			goto out;
+		}
+		if (rc)
+			goto out;
+
+		compressed_pdu_len = sizeof(*chdr) + dst_len;
+		chdr = (struct smb2_compression_hdr *)(out + sizeof(__be32));
+		chdr->ProtocolId = SMB2_COMPRESSION_TRANSFORM_ID;
+		chdr->OriginalCompressedSegmentSize = cpu_to_le32(src_len);
+		chdr->CompressionAlgorithm = SMB3_COMPRESS_LZ77;
+		chdr->Flags = cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE);
+		chdr->Offset = 0;
+	}
+
+	*(__be32 *)out = cpu_to_be32(compressed_pdu_len);
+
+	/*
+	 * Keep the transform in work->compress_buf until send completion.
+	 * Existing response iovs can then be replaced without changing their
+	 * individual ownership rules.
+	 */
+	work->compress_buf = out;
+	work->iov[0].iov_base = out;
+	work->iov[0].iov_len = sizeof(__be32);
+	work->iov[1].iov_base = out + sizeof(__be32);
+	work->iov[1].iov_len = compressed_pdu_len;
+	work->iov_cnt = 2;
+	work->iov_idx = 1;
+	out = NULL;
+	rc = 1;
+out:
+	kvfree(out);
+	kvfree(src);
+	return rc;
+}
diff --git a/fs/smb/server/compress.h b/fs/smb/server/compress.h
index 49b36d931aac..663c6f44f09b 100644
--- a/fs/smb/server/compress.h
+++ b/fs/smb/server/compress.h
@@ -11,5 +11,6 @@
 #include "../common/compress/compress.h"
 
 int ksmbd_decompress_request(struct ksmbd_conn *conn);
+int ksmbd_compress_response(struct ksmbd_work *work);
 
 #endif /* __KSMBD_COMPRESS_H__ */
diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index ab4958dc3eb0..a5ab6799a65c 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -53,6 +53,7 @@ void ksmbd_free_work_struct(struct ksmbd_work *work)
 	}
 
 	kfree(work->tr_buf);
+	kvfree(work->compress_buf);
 	kvfree(work->request_buf);
 	kfree(work->iov);
 
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index d36393ff8310..0da8cc0972d6 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -67,12 +67,16 @@ struct ksmbd_work {
 	unsigned int                    response_sz;
 
 	void				*tr_buf;
+	/* Contiguous SMB2 compression transform owned by this work item. */
+	void				*compress_buf;
 
 	unsigned char			state;
 	/* No response for cancelled request */
 	bool                            send_no_response:1;
 	/* Request is encrypted */
 	bool                            encrypted:1;
+	/* READ response should be wrapped in a compression transform. */
+	bool                            compress_response:1;
 	/* Is this SYNC or ASYNC ksmbd_work */
 	bool                            asynchronous:1;
 	bool                            need_invalidate_rkey:1;
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 5d799b2d4c62..36feda7e0942 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -22,6 +22,7 @@
 #include "crypto_ctx.h"
 #include "auth.h"
 #include "stats.h"
+#include "compress.h"
 
 int ksmbd_debug_types;
 
@@ -244,6 +245,15 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 	if (work->tcon)
 		ksmbd_tree_connect_put(work->tcon);
 	smb3_preauth_hash_rsp(work);
+	/*
+	 * Preauthentication hashes cover the original SMB2 response. Apply the
+	 * transport compression wrapper only after updating the hash.
+	 */
+	if (work->compress_response) {
+		rc = ksmbd_compress_response(work);
+		if (rc < 0)
+			ksmbd_debug(CONN, "Failed to compress response: %d\n", rc);
+	}
 	if (work->sess && work->sess->enc && work->encrypted &&
 	    conn->ops->encrypt_resp) {
 		rc = conn->ops->encrypt_resp(work);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 86309dc70a62..5d5f868e7817 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7097,6 +7097,15 @@ int smb2_read(struct ksmbd_work *work)
 		kvfree(aux_payload_buf);
 		goto out;
 	}
+	/*
+	 * RDMA responses are transferred through channel buffers and encrypted
+	 * responses use the encryption transform, so only normal SMB transport
+	 * responses are candidates for compression.
+	 */
+	if (!is_rdma_channel && nbytes &&
+	    (req->Flags & SMB2_READFLAG_REQUEST_COMPRESSED) &&
+	    conn->compress_algorithm != SMB3_COMPRESS_NONE)
+		work->compress_response = true;
 	ksmbd_fd_put(work, fp);
 	return 0;
 
-- 
2.25.1

