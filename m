Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C463FA5E7
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968958; cv=none; b=bI8g2BTkh62rUuLJCC/Chtobg/zq9sH4UoANde3gdrxvp57yN+AHXe0pYJAEbPBrbBlsrqgNr/wktttXADM8f6wYmqLu5YmceqrZ+ySqBIYO9JDj7H/gQpw7AE+KyMoAe7VAP5ZveOyQOzsFDFWRyVvKxlTJofMvDJzJy+ixlEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968958; c=relaxed/simple;
	bh=iZU1k/+Hhv/FljyG9uA1KKgmXgGcl0zPo6CgZ20eQoM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V564nMkubHv7YY9mI1vvwZM44j7VBNkLqS/RiwQeOJiZ4zQQUMxcMqqfiJexBsDjhHCUPCgToOTdGaIRU/5eL1dBXdkyQ4oKVRvDkM2/+a3zSSh3+/dchPw77P96PlIpHzaXmPi27pq4rqo03Ov3CpKLrgXSbGZQ2D4DfEYZbbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WgIq00Er; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WgIq00Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EC51F0155A;
	Mon, 17 Aug 2026 12:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968956;
	bh=SBdyEalHo7ehN6fbYNQu8convRdROMzXpadsIls0/rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgIq00ErKkqb67XoujFdEzmYzEu7B3fqKZdkQ5hk3OFLtccd546oTdMsU4p4E8Kk8
	 9wqCPSxP7ThgWXk3rb1x0wv/Dogb1GqGxsoROdMe2pWTK0N1AsWwdegdgW/x1UHkeE
	 InJmACP75ZU5dCpcAAAtNtbMswgL/Kug+5b2EQVLeu2rjvKu4S+VILtr1pU2ZJjVwE
	 NUcl/D1HW/BUVavNL5zHqIqWMTufZE0KCyojvl5/fiCy4zT8+OjemCKZG5wxIrdGgN
	 0rU60q1MdejlAQ6wKDBJDKuVqscbIiQX1IMGwTOOcsIqIoP/YVZlnerAMzJsFWEnCC
	 jUCwTU8ObrOhQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: add SMB Direct RDMA encryption transform
Date: Mon, 17 Aug 2026 21:15:23 +0900
Message-Id: <20260817121524.8812-11-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817121524.8812-1-linkinjeon@kernel.org>
References: <20260817121524.8812-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Port SMB Direct RDMA payload encryption support to the current ksmbd tree.
The current tree already supports all-state lookup for encrypted expired
sessions, so the overlapping lookup hunk from the original patch is
intentionally omitted.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/smb2pdu.h        |  24 --
 fs/smb/common/smb2pdu.h        |  22 ++
 fs/smb/common/smb2status.h     |   1 +
 fs/smb/server/auth.c           | 158 +++++++++++
 fs/smb/server/auth.h           |   4 +
 fs/smb/server/connection.c     |   2 +
 fs/smb/server/connection.h     |   3 +
 fs/smb/server/smb2pdu.c        | 500 ++++++++++++++++++++++++++++++---
 fs/smb/server/transport_rdma.c |  10 +
 fs/smb/server/transport_rdma.h |   2 +
 10 files changed, 663 insertions(+), 63 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index b9bf2fa989d5..ab6c667bebc0 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -21,30 +21,6 @@
 /* The total header size for SMB2 read and write */
 #define SMB2_READWRITE_PDU_HEADER_SIZE (48 + sizeof(struct smb2_hdr))
 
-/* See MS-SMB2 2.2.43 */
-struct smb2_rdma_transform {
-	__le16 RdmaDescriptorOffset;
-	__le16 RdmaDescriptorLength;
-	__le32 Channel; /* for values see channel description in smb2 read above */
-	__le16 TransformCount;
-	__le16 Reserved1;
-	__le32 Reserved2;
-} __packed;
-
-/* TransformType */
-#define SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION	0x0001
-#define SMB2_RDMA_TRANSFORM_TYPE_SIGNING	0x0002
-
-struct smb2_rdma_crypto_transform {
-	__le16	TransformType;
-	__le16	SignatureLength;
-	__le16	NonceLength;
-	__u16	Reserved;
-	__u8	Signature[]; /* variable length */
-	/* u8 Nonce[] */
-	/* followed by padding */
-} __packed;
-
 /*
  *	Definitions for SMB2 Protocol Data Units (network frames)
  *
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index d9650aff0d3c..f9a8862cb3d4 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -743,6 +743,28 @@ struct smb2_close_rsp {
 #define SMB2_CHANNEL_RDMA_V1_INVALIDATE cpu_to_le32(0x00000002)
 #define SMB2_CHANNEL_RDMA_TRANSFORM     cpu_to_le32(0x00000003)
 
+/* See MS-SMB2 2.2.43. */
+struct smb2_rdma_transform {
+	__le16 RdmaDescriptorOffset;
+	__le16 RdmaDescriptorLength;
+	__le32 Channel;
+	__le16 TransformCount;
+	__le16 Reserved1;
+	__le32 Reserved2;
+} __packed;
+
+#define SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION	0x0001
+#define SMB2_RDMA_TRANSFORM_TYPE_SIGNING	0x0002
+
+struct smb2_rdma_crypto_transform {
+	__le16 TransformType;
+	__le16 SignatureLength;
+	__le16 NonceLength;
+	__le16 Reserved;
+	__u8 Signature[];
+	/* Followed by Nonce[] and optional alignment padding. */
+} __packed;
+
 /* SMB2 read request without RFC1001 length at the beginning */
 struct smb2_read_req {
 	struct smb2_hdr hdr;
diff --git a/fs/smb/common/smb2status.h b/fs/smb/common/smb2status.h
index b6421bc5113c..2989c3a5cb67 100644
--- a/fs/smb/common/smb2status.h
+++ b/fs/smb/common/smb2status.h
@@ -1049,6 +1049,7 @@ struct ntstatus {
 #define STATUS_WOW_ASSERTION			cpu_to_le32(0xC0009898) // -EIO
 #define STATUS_INVALID_SIGNATURE		cpu_to_le32(0xC000A000) // -EIO
 #define STATUS_HMAC_NOT_SUPPORTED		cpu_to_le32(0xC000A001) // -EIO
+#define STATUS_AUTH_TAG_MISMATCH		cpu_to_le32(0xC000A002) // -EBADMSG
 #define STATUS_IPSEC_QUEUE_OVERFLOW		cpu_to_le32(0xC000A010) // -EIO
 #define STATUS_ND_QUEUE_OVERFLOW		cpu_to_le32(0xC000A011) // -EIO
 #define STATUS_HOPLIMIT_EXCEEDED		cpu_to_le32(0xC000A012) // -EIO
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 78491b20897e..db362c64af8d 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -833,6 +833,164 @@ static struct scatterlist *ksmbd_init_sg(struct kvec *iov, unsigned int nvec,
 	return sg;
 }
 
+/**
+ * ksmbd_init_rdma_sg() - build an AEAD scatterlist for an RDMA payload
+ * @buf: payload buffer
+ * @buflen: payload length
+ * @tag: authentication tag buffer
+ * @taglen: authentication tag length
+ *
+ * Split vmalloc-backed payloads at page boundaries and append the detached
+ * authentication tag as the final scatterlist entry.
+ *
+ * Return: allocated scatterlist, or NULL on allocation failure
+ */
+static struct scatterlist *ksmbd_init_rdma_sg(void *buf,
+					      unsigned int buflen,
+					      u8 *tag,
+					      unsigned int taglen)
+{
+	struct scatterlist *sg;
+	unsigned int nr_data = 1, nr_entries, i = 0;
+	void *data = buf;
+	int len = buflen;
+
+	if (is_vmalloc_addr(buf))
+		nr_data = DIV_ROUND_UP(offset_in_page(buf) + buflen, PAGE_SIZE);
+	nr_entries = nr_data + 1;
+
+	sg = kmalloc_objs(struct scatterlist, nr_entries, KSMBD_DEFAULT_GFP);
+	if (!sg)
+		return NULL;
+
+	sg_init_table(sg, nr_entries);
+	if (!is_vmalloc_addr(buf)) {
+		smb2_sg_set_buf(&sg[i++], buf, buflen);
+	} else {
+		while (len) {
+			unsigned int bytes = min_t(unsigned int,
+						PAGE_SIZE - offset_in_page(data), len);
+
+			sg_set_page(&sg[i++], vmalloc_to_page(data), bytes,
+				    offset_in_page(data));
+			data += bytes;
+			len -= bytes;
+		}
+	}
+	smb2_sg_set_buf(&sg[i], tag, taglen);
+	return sg;
+}
+
+/**
+ * ksmbd_crypt_rdma() - encrypt or decrypt an SMB Direct data buffer
+ * @conn: connection containing the negotiated cipher
+ * @key: session encryption or decryption key
+ * @buf: RDMA payload, transformed in place
+ * @buflen: payload length (the authentication tag is carried out of band)
+ * @nonce: transform nonce
+ * @nonce_len: nonce length
+ * @tag: authentication tag output for encryption, input for decryption
+ * @tag_len: authentication tag length
+ * @enc: true to encrypt, false to decrypt
+ *
+ * SMB2_RDMA_CRYPTO_TRANSFORM carries the nonce and authentication tag in the
+ * SMB2 message while only the payload is transferred through RDMA.  Therefore
+ * this uses AEAD without the normal SMB3 transform header as associated data.
+ *
+ * Return: 0 on success, otherwise a negative errno
+ */
+int ksmbd_crypt_rdma(struct ksmbd_conn *conn, const u8 *key,
+		     void *buf, unsigned int buflen, const u8 *nonce,
+		     unsigned int nonce_len, u8 *tag, unsigned int tag_len,
+		     bool enc)
+{
+	struct ksmbd_crypto_ctx *ctx;
+	struct crypto_aead *tfm;
+	struct aead_request *req = NULL;
+	struct scatterlist *sg = NULL;
+	unsigned int iv_len, crypt_len;
+	u8 auth_tag[SMB2_SIGNATURE_SIZE] = {};
+	u8 *iv = NULL;
+	int rc;
+	DECLARE_CRYPTO_WAIT(wait);
+
+	if (!buflen || !tag_len || tag_len > SMB2_SIGNATURE_SIZE)
+		return -EINVAL;
+	if (!enc)
+		memcpy(auth_tag, tag, tag_len);
+
+	if (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
+	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
+		if (nonce_len != SMB3_AES_GCM_NONCE)
+			return -EINVAL;
+		ctx = ksmbd_crypto_ctx_find_gcm();
+	} else {
+		if (nonce_len != SMB3_AES_CCM_NONCE)
+			return -EINVAL;
+		ctx = ksmbd_crypto_ctx_find_ccm();
+	}
+	if (!ctx)
+		return -ENOMEM;
+
+	tfm = (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
+	       conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) ?
+		CRYPTO_GCM(ctx) : CRYPTO_CCM(ctx);
+	if (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
+		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
+	else
+		rc = crypto_aead_setkey(tfm, key, SMB3_GCM128_CRYPTKEY_SIZE);
+	if (rc)
+		goto out;
+
+	rc = crypto_aead_setauthsize(tfm, tag_len);
+	if (rc)
+		goto out;
+
+	req = aead_request_alloc(tfm, KSMBD_DEFAULT_GFP);
+	if (!req) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	sg = ksmbd_init_rdma_sg(buf, buflen, auth_tag, tag_len);
+	if (!sg) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	iv_len = crypto_aead_ivsize(tfm);
+	iv = kzalloc(iv_len, KSMBD_DEFAULT_GFP);
+	if (!iv) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	if (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
+	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
+		memcpy(iv, nonce, nonce_len);
+	} else {
+		iv[0] = 3;
+		memcpy(iv + 1, nonce, nonce_len);
+	}
+
+	crypt_len = buflen + (enc ? 0 : tag_len);
+	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
+	aead_request_set_ad(req, 0);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				  CRYPTO_TFM_REQ_MAY_SLEEP,
+				  crypto_req_done, &wait);
+	rc = crypto_wait_req(enc ? crypto_aead_encrypt(req) :
+			     crypto_aead_decrypt(req), &wait);
+	if (!rc && enc)
+		memcpy(tag, auth_tag, tag_len);
+out:
+	kfree(iv);
+	kfree(sg);
+	aead_request_free(req);
+	ksmbd_release_crypto_ctx(ctx);
+	return rc;
+}
+
 int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 			unsigned int nvec, int enc)
 {
diff --git a/fs/smb/server/auth.h b/fs/smb/server/auth.h
index f14b7c033264..7ce9c42d58f1 100644
--- a/fs/smb/server/auth.h
+++ b/fs/smb/server/auth.h
@@ -38,6 +38,10 @@ struct kvec;
 
 int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 			unsigned int nvec, int enc);
+int ksmbd_crypt_rdma(struct ksmbd_conn *conn, const u8 *key,
+		     void *buf, unsigned int buflen, const u8 *nonce,
+		     unsigned int nonce_len, u8 *tag, unsigned int tag_len,
+		     bool enc);
 void ksmbd_copy_gss_neg_header(void *buf);
 int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 		      struct ntlmv2_resp *ntlmv2, int blen, char *domain_name,
diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 5d729473dd18..d32f4f3cef93 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -77,6 +77,8 @@ static void proc_show_conn_features(struct seq_file *m,
 	proc_show_conn_feature(m, &separator,
 			       conn->compress_algorithm != SMB3_COMPRESS_NONE,
 			       "compress");
+	proc_show_conn_feature(m, &separator, conn->rdma_transform_ids,
+			       "rdma-transform");
 	proc_show_conn_feature(m, &separator, conn->posix_ext_supported, "posix");
 	if (!separator)
 		seq_puts(m, "none");
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 421907aed473..63484c8efbbd 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -139,6 +139,9 @@ struct ksmbd_conn {
 	/* Negotiated SMB 3.1.1 compression capabilities. */
 	bool				compress_chained;
 	bool				compress_pattern;
+	/* Bitmap indexed by SMB2_RDMA_TRANSFORM_* IDs. */
+	unsigned long			rdma_transform_ids;
+	bool				rdma_transform_negotiated;
 	bool				posix_ext_supported;
 	bool				signing_negotiated;
 	__le16				signing_algorithm;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a564535132e5..b48eff02dbf8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1356,6 +1356,37 @@ static void build_compress_ctxt(struct smb2_compression_capabilities_context *pn
 	pneg_ctxt->CompressionAlgorithms[3] = 0;
 }
 
+/**
+ * build_rdma_ctx() - build an RDMA transform negotiate response context
+ * @ctxt: response context header to populate
+ * @transform_ids: bitmap of transforms common to the client and server
+ *
+ * Return: encoded negotiate context length
+ */
+static int build_rdma_ctx(struct smb2_neg_context *ctxt,
+			  unsigned long transform_ids)
+{
+	struct smb2_rdma_transform_capabilities_context *pneg_ctxt;
+	int count = 0;
+
+	pneg_ctxt = (void *)ctxt;
+	pneg_ctxt->ContextType = SMB2_RDMA_TRANSFORM_CAPABILITIES;
+	pneg_ctxt->Reserved = 0;
+	pneg_ctxt->Reserved1 = 0;
+	pneg_ctxt->Reserved2 = 0;
+	if (transform_ids & BIT(SMB2_RDMA_TRANSFORM_ENCRYPTION))
+		pneg_ctxt->RDMATransformIds[count++] =
+			cpu_to_le16(SMB2_RDMA_TRANSFORM_ENCRYPTION);
+	if (!count)
+		pneg_ctxt->RDMATransformIds[count++] =
+			cpu_to_le16(SMB2_RDMA_TRANSFORM_NONE);
+
+	pneg_ctxt->TransformCount = cpu_to_le16(count);
+	pneg_ctxt->DataLength = cpu_to_le16(8 + count * sizeof(__le16));
+	return sizeof(struct smb2_neg_context) +
+		le16_to_cpu(pneg_ctxt->DataLength);
+}
+
 static void build_sign_cap_ctxt(struct smb2_signing_capabilities *pneg_ctxt,
 				__le16 sign_algo)
 {
@@ -1431,6 +1462,18 @@ static unsigned int assemble_neg_contexts(struct ksmbd_conn *conn,
 			(conn->compress_pattern ? 12 : 10);
 	}
 
+	if (conn->rdma_transform_negotiated) {
+		struct smb2_neg_context *rdma_ctxt;
+
+		ctxt_size = round_up(ctxt_size, 8);
+		ksmbd_debug(SMB,
+			    "assemble SMB2_RDMA_TRANSFORM_CAPABILITIES context\n");
+		rdma_ctxt = (void *)(pneg_ctxt + ctxt_size);
+		ctxt_size += build_rdma_ctx(rdma_ctxt,
+					     conn->rdma_transform_ids);
+		neg_ctxt_cnt++;
+	}
+
 	if (conn->posix_ext_supported) {
 		ctxt_size = round_up(ctxt_size, 8);
 		ksmbd_debug(SMB,
@@ -1631,6 +1674,46 @@ static void decode_sign_cap_ctxt(struct ksmbd_conn *conn,
 	}
 }
 
+/**
+ * decode_rdma_ctx() - decode an RDMA transform negotiate request context
+ * @conn: connection being negotiated
+ * @ctxt: request context header to decode
+ * @ctxt_len: total context length, including the negotiate context header
+ *
+ * Record transforms supported by both peers only for SMB Direct connections.
+ *
+ * Return: NT status describing the decode result
+ */
+static __le32 decode_rdma_ctx(struct ksmbd_conn *conn,
+			      struct smb2_neg_context *ctxt, int ctxt_len)
+{
+	struct smb2_rdma_transform_capabilities_context *pneg_ctxt;
+	unsigned int count, i;
+
+	pneg_ctxt = (void *)ctxt;
+	/* RDMA transforms are a node capability, not just a transport capability. */
+	if (!ksmbd_rdma_enabled())
+		return STATUS_SUCCESS;
+
+	if (ctxt_len < sizeof(*pneg_ctxt))
+		return STATUS_INVALID_PARAMETER;
+
+	count = le16_to_cpu(pneg_ctxt->TransformCount);
+	if (!count || count >
+	    (ctxt_len - sizeof(*pneg_ctxt)) / sizeof(__le16))
+		return STATUS_INVALID_PARAMETER;
+
+	conn->rdma_transform_negotiated = true;
+	conn->rdma_transform_ids = 0;
+	for (i = 0; i < count; i++) {
+		u16 id = le16_to_cpu(pneg_ctxt->RDMATransformIds[i]);
+
+		if (id == SMB2_RDMA_TRANSFORM_ENCRYPTION)
+			conn->rdma_transform_ids |= BIT(id);
+	}
+	return STATUS_SUCCESS;
+}
+
 static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 				      struct smb2_negotiate_req *req,
 				      unsigned int len_of_smb)
@@ -1641,7 +1724,7 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 	unsigned int offset = le32_to_cpu(req->NegotiateContextOffset);
 	unsigned int neg_ctxt_cnt = le16_to_cpu(req->NegotiateContextCount);
 	__le32 status = STATUS_INVALID_PARAMETER;
-	int compress_ctxt_cnt = 0;
+	int compress_ctxt_cnt = 0, rdma_transform_ctxt_cnt = 0;
 
 	ksmbd_debug(SMB, "decoding %d negotiate contexts\n", neg_ctxt_cnt);
 	if (len_of_smb <= offset) {
@@ -1700,6 +1783,17 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 		} else if (pctx->ContextType == SMB2_NETNAME_NEGOTIATE_CONTEXT_ID) {
 			ksmbd_debug(SMB,
 				    "deassemble SMB2_NETNAME_NEGOTIATE_CONTEXT_ID context\n");
+		} else if (pctx->ContextType == SMB2_RDMA_TRANSFORM_CAPABILITIES) {
+			ksmbd_debug(SMB,
+				    "deassemble SMB2_RDMA_TRANSFORM_CAPABILITIES context\n");
+			if (ksmbd_rdma_enabled() &&
+			    rdma_transform_ctxt_cnt++) {
+				status = STATUS_INVALID_PARAMETER;
+				break;
+			}
+			status = decode_rdma_ctx(conn, pctx, ctxt_len);
+			if (status != STATUS_SUCCESS)
+				break;
 		} else if (pctx->ContextType == SMB2_POSIX_EXTENSIONS_AVAILABLE) {
 			ksmbd_debug(SMB,
 				    "deassemble SMB2_POSIX_EXTENSIONS_AVAILABLE context\n");
@@ -1807,6 +1901,9 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 			conn->preauth_info = NULL;
 			goto err_out;
 		}
+		if (!conn->cipher_type)
+			conn->rdma_transform_ids &=
+				~BIT(SMB2_RDMA_TRANSFORM_ENCRYPTION);
 
 		rc = init_smb3_11_server(conn);
 		if (rc < 0) {
@@ -8553,18 +8650,31 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	return err;
 }
 
-static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
-					struct smbdirect_buffer_descriptor_v1 *desc,
-					__le32 Channel,
-					__le16 ChannelInfoLength)
+/**
+ * smb2_set_rdma_key() - validate descriptors and save invalidation state
+ * @work: request work item
+ * @desc: first RDMA buffer descriptor
+ * @Channel: nested RDMA channel type
+ * @channel_info_len: descriptor array length
+ *
+ * Return: 0 on success, otherwise -EINVAL
+ */
+static int smb2_set_rdma_key(struct ksmbd_work *work,
+			     struct smbdirect_buffer_descriptor_v1 *desc,
+			     __le32 Channel, __le16 channel_info_len)
 {
 	unsigned int i, ch_count;
 
+	if (Channel != SMB2_CHANNEL_RDMA_V1 &&
+	    Channel != SMB2_CHANNEL_RDMA_V1_INVALIDATE)
+		return -EINVAL;
 	if (work->conn->dialect == SMB30_PROT_ID &&
 	    Channel != SMB2_CHANNEL_RDMA_V1)
 		return -EINVAL;
+	if (le16_to_cpu(channel_info_len) % sizeof(*desc))
+		return -EINVAL;
 
-	ch_count = le16_to_cpu(ChannelInfoLength) / sizeof(*desc);
+	ch_count = le16_to_cpu(channel_info_len) / sizeof(*desc);
 	if (ksmbd_debug_types & KSMBD_DEBUG_RDMA) {
 		for (i = 0; i < ch_count; i++) {
 			pr_info("RDMA r/w request %#x: token %#x, length %#x\n",
@@ -8583,9 +8693,223 @@ static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
 	return 0;
 }
 
-static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
-				      struct smb2_read_req *req, void *data_buf,
-				      size_t length)
+/**
+ * smb2_prep_rdma_read() - transform an RDMA READ payload
+ * @work: request work item
+ * @req: READ request controlling encryption or signing
+ * @rsp: READ response receiving transform metadata
+ * @data: data that will be transferred through RDMA
+ * @datalen: data length
+ *
+ * Encrypt the payload in place and encode the detached crypto metadata in
+ * the response buffer.
+ *
+ * Return: metadata length, zero when no transform applies, or negative errno
+ */
+static int smb2_prep_rdma_read(struct ksmbd_work *work,
+			       struct smb2_read_req *req,
+			       struct smb2_read_rsp *rsp,
+			       void *data, unsigned int datalen)
+{
+	struct ksmbd_conn *conn = work->conn;
+	struct smb2_rdma_transform *transform;
+	struct smb2_rdma_crypto_transform *crypto;
+	u8 *nonce;
+	unsigned int nonce_len = 0, transform_len;
+	u16 transform_type;
+	int err;
+
+	if (work->encrypted &&
+	    (conn->rdma_transform_ids & BIT(SMB2_RDMA_TRANSFORM_ENCRYPTION))) {
+		transform_type = SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION;
+		nonce_len = (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
+			     conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) ?
+			SMB3_AES_GCM_NONCE : SMB3_AES_CCM_NONCE;
+	} else {
+		return 0;
+	}
+
+	transform = (struct smb2_rdma_transform *)rsp->Buffer;
+	crypto = (struct smb2_rdma_crypto_transform *)(transform + 1);
+	memset(transform, 0, sizeof(*transform) + sizeof(*crypto) +
+	       SMB2_SIGNATURE_SIZE + nonce_len);
+	transform->Channel = SMB2_CHANNEL_NONE;
+	transform->TransformCount = cpu_to_le16(1);
+
+	crypto->TransformType = cpu_to_le16(transform_type);
+	crypto->SignatureLength = cpu_to_le16(SMB2_SIGNATURE_SIZE);
+	crypto->NonceLength = cpu_to_le16(nonce_len);
+	nonce = crypto->Signature + SMB2_SIGNATURE_SIZE;
+
+	get_random_bytes(nonce, nonce_len);
+	err = ksmbd_crypt_rdma(conn,
+			       work->sess->smb3encryptionkey,
+			       data, datalen, nonce, nonce_len,
+			       crypto->Signature,
+			       SMB2_SIGNATURE_SIZE, true);
+	if (err)
+		return err;
+
+	transform_len = sizeof(*transform) + sizeof(*crypto) +
+		SMB2_SIGNATURE_SIZE + nonce_len;
+	rsp->Flags = SMB2_READFLAG_RESPONSE_RDMA_TRANSFORM;
+	rsp->DataLength = cpu_to_le32(transform_len);
+	return transform_len;
+}
+
+struct smb2_rdma_write_transform {
+	struct smbdirect_buffer_descriptor_v1 *desc;
+	struct smb2_rdma_crypto_transform *crypto;
+	u8 *nonce;
+	unsigned int desc_len;
+	unsigned int nonce_len;
+	unsigned int signature_len;
+	u16 type;
+	__le32 channel;
+};
+
+/**
+ * smb2_current_req_len() - return the current compound request element size
+ * @work: request work item
+ * @hdr: current SMB2 header
+ *
+ * Return: current request element length measured from the SMB2 header
+ */
+static unsigned int smb2_current_req_len(struct ksmbd_work *work,
+					 struct smb2_hdr *hdr)
+{
+	if (hdr->NextCommand)
+		return le32_to_cpu(hdr->NextCommand);
+	return get_rfc1002_len(work->request_buf) -
+		work->next_smb2_rcv_hdr_off;
+}
+
+/**
+ * check_rdma_desc() - validate an RDMA descriptor array
+ * @desc: descriptor array
+ * @desc_len: descriptor array length
+ * @required_len: minimum aggregate buffer length
+ *
+ * Return: 0 when the descriptors cover the transfer, otherwise -EINVAL
+ */
+static int check_rdma_desc(struct smbdirect_buffer_descriptor_v1 *desc,
+			   unsigned int desc_len,
+			   unsigned int required_len)
+{
+	unsigned int i, count;
+	u64 described_len = 0;
+
+	if (!desc_len || desc_len % sizeof(*desc))
+		return -EINVAL;
+	count = desc_len / sizeof(*desc);
+	if (!le32_to_cpu(desc[0].length))
+		return -EINVAL;
+	for (i = 0; i < count; i++)
+		described_len += le32_to_cpu(desc[i].length);
+	return described_len < required_len ? -EINVAL : 0;
+}
+
+/**
+ * smb2_parse_rdma_write_transform() - validate RDMA WRITE transform metadata
+ * @work: request work item
+ * @req: WRITE request containing the transform
+ * @info: parsed transform information
+ *
+ * Validate transform counts, crypto fields, descriptor alignment and bounds,
+ * negotiated algorithms, and the nested RDMA channel.
+ *
+ * Return: 0 on success, otherwise a negative errno
+ */
+static int smb2_parse_rdma_write_transform(struct ksmbd_work *work,
+					   struct smb2_write_req *req,
+					   struct smb2_rdma_write_transform *info)
+{
+	struct smb2_rdma_transform *transform;
+	struct smb2_rdma_crypto_transform *crypto;
+	unsigned int req_len = smb2_current_req_len(work, &req->hdr);
+	unsigned int offset = le16_to_cpu(req->WriteChannelInfoOffset);
+	unsigned int length = le16_to_cpu(req->WriteChannelInfoLength);
+	unsigned int desc_offset, desc_len, crypto_len, expected_desc_offset;
+
+	if (!work->conn->rdma_transform_ids ||
+	    offset < offsetof(struct smb2_write_req, Buffer) ||
+	    length < sizeof(*transform) || offset > req_len ||
+	    length > req_len - offset)
+		return -EINVAL;
+
+	transform = (struct smb2_rdma_transform *)((char *)req + offset);
+	if (le16_to_cpu(transform->TransformCount) != 1 ||
+	    (transform->Channel != SMB2_CHANNEL_RDMA_V1 &&
+	     transform->Channel != SMB2_CHANNEL_RDMA_V1_INVALIDATE))
+		return -EINVAL;
+
+	desc_offset = le16_to_cpu(transform->RdmaDescriptorOffset);
+	desc_len = le16_to_cpu(transform->RdmaDescriptorLength);
+	if (!desc_len || desc_len % sizeof(*info->desc) ||
+	    desc_offset < sizeof(*transform) || desc_offset > length ||
+	    desc_len > length - desc_offset)
+		return -EINVAL;
+
+	crypto = (struct smb2_rdma_crypto_transform *)(transform + 1);
+	if (length - sizeof(*transform) < sizeof(*crypto))
+		return -EINVAL;
+	info->type = le16_to_cpu(crypto->TransformType);
+	info->signature_len = le16_to_cpu(crypto->SignatureLength);
+	info->nonce_len = le16_to_cpu(crypto->NonceLength);
+	if (!info->signature_len)
+		return info->type == SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION ?
+			-EBADMSG : -EINVAL;
+	if (info->signature_len > SMB2_SIGNATURE_SIZE)
+		return info->type == SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION ?
+			-EBADMSG : -EINVAL;
+	if (info->signature_len > length - sizeof(*transform) - sizeof(*crypto) ||
+	    info->nonce_len > length - sizeof(*transform) - sizeof(*crypto) -
+				 info->signature_len)
+		return -EINVAL;
+
+	crypto_len = sizeof(*crypto) + info->signature_len + info->nonce_len;
+	expected_desc_offset = ALIGN(sizeof(*transform) + crypto_len, 8);
+	if (desc_offset != expected_desc_offset)
+		return -EINVAL;
+
+	if (info->type == SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION) {
+		unsigned int expected_nonce_len;
+
+		if (!(work->conn->rdma_transform_ids &
+		      BIT(SMB2_RDMA_TRANSFORM_ENCRYPTION)) || !work->encrypted)
+			return -EINVAL;
+		expected_nonce_len =
+			(work->conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
+			 work->conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) ?
+			SMB3_AES_GCM_NONCE : SMB3_AES_CCM_NONCE;
+		if (info->nonce_len != expected_nonce_len)
+			return -EBADMSG;
+	} else {
+		return -EINVAL;
+	}
+
+	info->desc = (struct smbdirect_buffer_descriptor_v1 *)
+		((char *)transform + desc_offset);
+	info->desc_len = desc_len;
+	info->crypto = crypto;
+	info->nonce = crypto->Signature + info->signature_len;
+	info->channel = transform->Channel;
+	return check_rdma_desc(info->desc, info->desc_len,
+			       le32_to_cpu(req->RemainingBytes));
+}
+
+/**
+ * smb2_read_rdma() - transfer READ data to client RDMA buffers
+ * @work: request work item
+ * @req: READ request containing client descriptors
+ * @data_buf: data to transfer
+ * @length: data length
+ *
+ * Return: transferred length on success, otherwise a negative errno
+ */
+static ssize_t smb2_read_rdma(struct ksmbd_work *work,
+			      struct smb2_read_req *req, void *data_buf,
+			      size_t length)
 {
 	int err;
 
@@ -8615,6 +8939,7 @@ int smb2_read(struct ksmbd_work *work)
 	size_t length, mincount;
 	ssize_t nbytes = 0, remain_bytes = 0;
 	int err = 0;
+	int rdma_transform_len = 0;
 	bool is_rdma_channel = false, async_interim = false;
 	unsigned int max_read_size = conn->vals->max_read_size;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
@@ -8649,6 +8974,12 @@ int smb2_read(struct ksmbd_work *work)
 		pid = req->PersistentFileId;
 	}
 
+	if (req->Channel != SMB2_CHANNEL_NONE &&
+	    req->Channel != SMB2_CHANNEL_RDMA_V1 &&
+	    req->Channel != SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+		err = -EINVAL;
+		goto out;
+	}
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
 		is_rdma_channel = true;
@@ -8661,16 +8992,24 @@ int smb2_read(struct ksmbd_work *work)
 
 	if (is_rdma_channel == true) {
 		unsigned int ch_offset = le16_to_cpu(req->ReadChannelInfoOffset);
+		unsigned int ch_len = le16_to_cpu(req->ReadChannelInfoLength);
+		unsigned int req_len = smb2_current_req_len(work, &req->hdr);
+		struct smbdirect_buffer_descriptor_v1 *desc;
 
-		if (ch_offset < offsetof(struct smb2_read_req, Buffer)) {
+		if (!le32_to_cpu(req->Length) ||
+		    ch_offset < offsetof(struct smb2_read_req, Buffer) ||
+		    ch_offset > req_len || ch_len > req_len - ch_offset) {
 			err = -EINVAL;
 			goto out;
 		}
-		err = smb2_set_remote_key_for_rdma(work,
-						   (struct smbdirect_buffer_descriptor_v1 *)
-						   ((char *)req + ch_offset),
-						   req->Channel,
-						   req->ReadChannelInfoLength);
+		desc = (struct smbdirect_buffer_descriptor_v1 *)
+			((char *)req + ch_offset);
+		err = check_rdma_desc(desc, ch_len, le32_to_cpu(req->Length));
+		if (err)
+			goto out;
+		err = smb2_set_rdma_key(work, desc,
+					req->Channel,
+					req->ReadChannelInfoLength);
 		if (err)
 			goto out;
 	}
@@ -8753,10 +9092,19 @@ int smb2_read(struct ksmbd_work *work)
 		    nbytes, offset, mincount);
 
 	if (is_rdma_channel == true) {
+		rdma_transform_len = smb2_prep_rdma_read(work, req,
+							 rsp,
+							 aux_payload_buf,
+							 nbytes);
+		if (rdma_transform_len < 0) {
+			kvfree(aux_payload_buf);
+			err = rdma_transform_len;
+			goto out;
+		}
 		/* write data to the client using rdma channel */
-		remain_bytes = smb2_read_rdma_channel(work, req,
-						      aux_payload_buf,
-						      nbytes);
+		remain_bytes = smb2_read_rdma(work, req,
+					      aux_payload_buf,
+					      nbytes);
 		kvfree(aux_payload_buf);
 		aux_payload_buf = NULL;
 		nbytes = 0;
@@ -8769,11 +9117,13 @@ int smb2_read(struct ksmbd_work *work)
 	rsp->StructureSize = cpu_to_le16(17);
 	rsp->DataOffset = 80;
 	rsp->Reserved = 0;
-	rsp->DataLength = cpu_to_le32(nbytes);
+	rsp->DataLength = cpu_to_le32(rdma_transform_len ?: nbytes);
 	rsp->DataRemaining = cpu_to_le32(remain_bytes);
-	rsp->Flags = 0;
+	rsp->Flags = rdma_transform_len ?
+		SMB2_READFLAG_RESPONSE_RDMA_TRANSFORM : 0;
 	err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
-				     offsetof(struct smb2_read_rsp, Buffer),
+				     offsetof(struct smb2_read_rsp, Buffer) +
+				     rdma_transform_len,
 				     aux_payload_buf, nbytes);
 	if (err) {
 		kvfree(aux_payload_buf);
@@ -8885,10 +9235,28 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	return err;
 }
 
-static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
-				       struct smb2_write_req *req,
-				       struct ksmbd_file *fp,
-				       loff_t offset, size_t length, bool sync)
+/**
+ * smb2_write_rdma() - receive and store an RDMA WRITE payload
+ * @work: request work item
+ * @desc: client RDMA buffer descriptors
+ * @desc_len: descriptor array length
+ * @transform: parsed transform, or NULL for an untransformed transfer
+ * @fp: target open file
+ * @offset: target file offset
+ * @length: transfer length
+ * @sync: request synchronous storage completion
+ *
+ * Receive the payload, authenticate or decrypt it when required, and write it
+ * to the target file.
+ *
+ * Return: written byte count on success, otherwise a negative errno
+ */
+static ssize_t smb2_write_rdma(struct ksmbd_work *work,
+			       struct smbdirect_buffer_descriptor_v1 *desc,
+			       unsigned int desc_len,
+			       struct smb2_rdma_write_transform *transform,
+			       struct ksmbd_file *fp, loff_t offset,
+			       size_t length, bool sync)
 {
 	char *data_buf;
 	int ret;
@@ -8898,15 +9266,27 @@ static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
 	if (!data_buf)
 		return -ENOMEM;
 
-	ret = ksmbd_conn_rdma_read(work->conn, data_buf, length,
-				   (struct smbdirect_buffer_descriptor_v1 *)
-				   ((char *)req + le16_to_cpu(req->WriteChannelInfoOffset)),
-				   le16_to_cpu(req->WriteChannelInfoLength));
+	ret = ksmbd_conn_rdma_read(work->conn, data_buf, length, desc,
+				   desc_len);
 	if (ret < 0) {
 		kvfree(data_buf);
 		return ret;
 	}
 
+	if (transform &&
+	    transform->type == SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION) {
+		ret = ksmbd_crypt_rdma(work->conn,
+				       work->sess->smb3decryptionkey,
+				       data_buf, length, transform->nonce,
+				       transform->nonce_len,
+				       transform->crypto->Signature,
+				       transform->signature_len, false);
+		if (ret) {
+			kvfree(data_buf);
+			return ret == -ENOMEM ? ret : -EBADMSG;
+		}
+	}
+
 	ret = ksmbd_vfs_write(work, fp, data_buf, length, &offset, sync, &nbytes);
 	kvfree(data_buf);
 	if (ret < 0)
@@ -8925,6 +9305,10 @@ int smb2_write(struct ksmbd_work *work)
 {
 	struct smb2_write_req *req;
 	struct smb2_write_rsp *rsp;
+	struct smb2_rdma_write_transform rdma_transform = {};
+	struct smb2_rdma_write_transform *rdma_info = NULL;
+	struct smbdirect_buffer_descriptor_v1 *rdma_desc = NULL;
+	unsigned int rdma_desc_len = 0;
 	struct ksmbd_file *fp = NULL;
 	loff_t offset;
 	size_t length;
@@ -8969,8 +9353,21 @@ int smb2_write(struct ksmbd_work *work)
 	}
 	length = le32_to_cpu(req->Length);
 
+	if (req->Channel != SMB2_CHANNEL_NONE &&
+	    req->Channel != SMB2_CHANNEL_RDMA_V1 &&
+	    req->Channel != SMB2_CHANNEL_RDMA_V1_INVALIDATE &&
+	    req->Channel != SMB2_CHANNEL_RDMA_TRANSFORM) {
+		err = -EINVAL;
+		goto out;
+	}
+	if (req->Channel == SMB2_CHANNEL_RDMA_TRANSFORM &&
+	    work->conn->dialect != SMB311_PROT_ID) {
+		err = -EINVAL;
+		goto out;
+	}
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
-	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
+	    req->Channel == SMB2_CHANNEL_RDMA_TRANSFORM) {
 		is_rdma_channel = true;
 		max_write_size = get_smbd_max_read_write_size(work->conn->transport);
 		if (max_write_size == 0) {
@@ -8995,17 +9392,37 @@ int smb2_write(struct ksmbd_work *work)
 
 	if (is_rdma_channel == true) {
 		unsigned int ch_offset = le16_to_cpu(req->WriteChannelInfoOffset);
+		unsigned int ch_len = le16_to_cpu(req->WriteChannelInfoLength);
+		unsigned int req_len = smb2_current_req_len(work, &req->hdr);
 
-		if (req->Length != 0 || req->DataOffset != 0 ||
-		    ch_offset < offsetof(struct smb2_write_req, Buffer)) {
+		if (!length || req->Length != 0 || req->DataOffset != 0 ||
+		    ch_offset < offsetof(struct smb2_write_req, Buffer) ||
+		    ch_offset > req_len || ch_len > req_len - ch_offset) {
 			err = -EINVAL;
 			goto out;
 		}
-		err = smb2_set_remote_key_for_rdma(work,
-						   (struct smbdirect_buffer_descriptor_v1 *)
-						   ((char *)req + ch_offset),
-						   req->Channel,
-						   req->WriteChannelInfoLength);
+		if (req->Channel == SMB2_CHANNEL_RDMA_TRANSFORM) {
+			err = smb2_parse_rdma_write_transform(work, req,
+							      &rdma_transform);
+			if (err)
+				goto out;
+			rdma_desc = rdma_transform.desc;
+			rdma_desc_len = rdma_transform.desc_len;
+			rdma_info = &rdma_transform;
+			err = smb2_set_rdma_key(work, rdma_desc,
+						rdma_transform.channel,
+						cpu_to_le16(rdma_desc_len));
+		} else {
+			rdma_desc = (struct smbdirect_buffer_descriptor_v1 *)
+				((char *)req + ch_offset);
+			rdma_desc_len = ch_len;
+			err = check_rdma_desc(rdma_desc, rdma_desc_len, length);
+			if (err)
+				goto out;
+			err = smb2_set_rdma_key(work, rdma_desc,
+						req->Channel,
+						req->WriteChannelInfoLength);
+		}
 		if (err)
 			goto out;
 	}
@@ -9074,8 +9491,9 @@ int smb2_write(struct ksmbd_work *work)
 		/* read data from the client using rdma channel, and
 		 * write the data.
 		 */
-		nbytes = smb2_write_rdma_channel(work, req, fp, offset, length,
-						 writethrough);
+		nbytes = smb2_write_rdma(work, rdma_desc, rdma_desc_len,
+					 rdma_info, fp, offset, length,
+					 writethrough);
 		if (nbytes < 0) {
 			err = (int)nbytes;
 			goto out;
@@ -9112,6 +9530,10 @@ int smb2_write(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_SHARING_VIOLATION;
 	else if (err == -EINVAL)
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+	else if (err == -EBADMSG)
+		rsp->hdr.Status = STATUS_AUTH_TAG_MISMATCH;
+	else if (err == -EKEYREJECTED)
+		rsp->hdr.Status = STATUS_INVALID_SIGNATURE;
 	else if (rsp->hdr.Status == 0)
 		rsp->hdr.Status = STATUS_INVALID_HANDLE;
 
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 85d12c4c354c..ee28a4d1cc86 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -76,6 +76,8 @@ static int smb_direct_max_receive_size = 1364;
 
 static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
 
+static bool smb_direct_enabled;
+
 static struct smb_direct_listener {
 	int			port;
 
@@ -512,18 +514,26 @@ int ksmbd_rdma_init(void)
 	ksmbd_debug(RDMA, "iWarp RDMA listener. socket=%p\n",
 		    smb_direct_iw_listener.socket);
 
+	WRITE_ONCE(smb_direct_enabled, true);
 	return 0;
 err:
+	WRITE_ONCE(smb_direct_enabled, false);
 	ksmbd_rdma_stop_listening();
 	return ret;
 }
 
 void ksmbd_rdma_stop_listening(void)
 {
+	WRITE_ONCE(smb_direct_enabled, false);
 	smb_direct_listener_destroy(&smb_direct_ib_listener);
 	smb_direct_listener_destroy(&smb_direct_iw_listener);
 }
 
+bool ksmbd_rdma_enabled(void)
+{
+	return READ_ONCE(smb_direct_enabled);
+}
+
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 {
 	u8 node_type = smbdirect_netdev_rdma_capable_node_type(netdev);
diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
index 8b78917a1795..23247713b5c3 100644
--- a/fs/smb/server/transport_rdma.h
+++ b/fs/smb/server/transport_rdma.h
@@ -14,12 +14,14 @@
 #ifdef CONFIG_SMB_SERVER_SMBDIRECT
 int ksmbd_rdma_init(void);
 void ksmbd_rdma_stop_listening(void);
+bool ksmbd_rdma_enabled(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
 void init_smbd_max_io_size(unsigned int sz);
 unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
 static inline void ksmbd_rdma_stop_listening(void) { }
+static inline bool ksmbd_rdma_enabled(void) { return false; }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) { return false; }
 static inline void init_smbd_max_io_size(unsigned int sz) { }
 static inline unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt) { return 0; }
-- 
2.25.1

