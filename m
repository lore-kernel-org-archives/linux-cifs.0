Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3D922A817
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968955; cv=none; b=lHq1uZ6osBoQEICR0kmefPtb3SrJgjC4oofdxz2+vkc2O0Pnwq130Gr3gF/dnm/QF/oNakDxuvycGyDG5Yu5k+EpYQ7cYbAB8FJ7wISU8DA3qoXSQ9lCY51McCMop0qVorTOmDd8PZ2wCZ9T1XeTMSjUITUhQn384RTnlTZBzUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968955; c=relaxed/simple;
	bh=gOxjhZts7KSz5mKNnK1fQ9WAdWdmbDaxnugv2I4bTg4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mN4X6Ex3T4FhAWf6yOmgpzrpnallsucNY/UcRp01hmgd0CJ+YQRh3IY9UK0KOGIKjZ+rqOYAsIUvEPz+4ElOXddJdeIieUyaRiDQtq/v4y1ocMkDfWWnItb9jyxH0W68Fbil6Ff/t8rQs1nYrrGLgURv6meKqpF3lK+tn7EVjxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYAqzG6Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYAqzG6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCB61F000E9;
	Mon, 17 Aug 2026 12:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968953;
	bh=hIDpMKz0rWQDrCmg2kq45I3X4OCiR7ayktQIHtgpSvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYAqzG6ZNFLKHevkTTYiYsuwjHOmERHhPg/WgnZ1G1FmerYJbzd714dS/g2Z9FLFq
	 hyt23inwrgORcKlFwhLTSyv+0H7HXptwbs1vkUDsMjcptX7jv25eCAGFAl4yZoD6nS
	 zc5DDAz7ZS98bS3pvu2QOdpcP5H5eCWZWAm0sBbaM+uqCus8KjVe6odve29BbqWzNa
	 mMUNncFrhugAuYEv9hK7nAfA4aZ8kA5eogCBYWWVplTNp9Se7HLJ2O8N+JAQ6Ompkd
	 yIKEGTroRXArG1k2VOJ3DgNz61kpIO3c2dDQUXaa3ikc7CuSOrs3of6S1EHyoc6Upy
	 y/B0wQHJCNNJw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: handle encrypted compressed requests
Date: Mon, 17 Aug 2026 21:15:22 +0900
Message-Id: <20260817121524.8812-10-linkinjeon@kernel.org>
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

SMB3 permits a message to be compressed before it is encrypted. After
decrypting such a request, ksmbd must trim the AEAD tag using
OriginalMessageSize, decompress the nested compression transform, and
validate the resulting SMB2 PDU.

Share the decompression helper between the connection receive path and
the post-decryption work path so unencrypted and encrypted compressed
requests follow the same validation.

Fixes: a08de24c2b85 ("ksmbd: negotiate and decode SMB2 compression")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/compress.c | 76 ++++++++++++++++++++++++++++++----------
 fs/smb/server/compress.h |  1 +
 fs/smb/server/server.c   | 22 ++++++++++++
 fs/smb/server/smb2pdu.c  | 22 ++++++++----
 4 files changed, 97 insertions(+), 24 deletions(-)

diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index 01d1771ff663..5162fb84c755 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -14,24 +14,14 @@
 
 #define SMB_COMPRESS_MIN_LEN	PAGE_SIZE
 
-/**
- * ksmbd_decompress_request() - replace a compressed request with its SMB2 PDU
- * @conn: connection which owns the current RFC1002 request buffer
- *
- * Derive the uncompressed size from the transform variant, enforce ksmbd's
- * normal message limits, and ask the common decoder to validate every payload.
- * On success, replace conn->request_buf with a regular RFC1002-framed SMB2
- * message so the rest of the request path needs no compression awareness.
- *
- * Return: 0 on success, otherwise a negative errno.
- */
-int ksmbd_decompress_request(struct ksmbd_conn *conn)
+static int __ksmbd_decompress_request(struct ksmbd_conn *conn,
+					     void *request_buf, void **out_buf)
 {
 	struct smb2_compression_hdr *hdr;
-	unsigned int pdu_size = get_rfc1002_len(conn->request_buf);
+	unsigned int pdu_size = get_rfc1002_len(request_buf);
 	u32 orig_size, offset, out_size;
 	u32 max_allowed_pdu_size;
-	char *buf, *out;
+	char *out;
 	int rc;
 
 	if (pdu_size < sizeof(struct smb2_compression_hdr))
@@ -41,7 +31,7 @@ int ksmbd_decompress_request(struct ksmbd_conn *conn)
 	    conn->compress_algorithm == SMB3_COMPRESS_NONE)
 		return -EINVAL;
 
-	hdr = smb_get_msg(conn->request_buf);
+	hdr = smb_get_msg(request_buf);
 	if (hdr->ProtocolId != SMB2_COMPRESSION_TRANSFORM_ID)
 		return -EINVAL;
 
@@ -74,19 +64,69 @@ int ksmbd_decompress_request(struct ksmbd_conn *conn)
 	if (!out)
 		return -ENOMEM;
 
-	buf = (char *)hdr;
 	*(__be32 *)out = cpu_to_be32(out_size);
 	rc = smb_compression_decompress(conn->compress_algorithm,
 					conn->compress_chained,
 					conn->compress_pattern,
-					buf, pdu_size, out + 4, out_size);
+					(char *)hdr, pdu_size, out + 4, out_size);
 	if (rc) {
 		kvfree(out);
 		return rc;
 	}
 
+	*out_buf = out;
+	return 0;
+}
+
+/**
+ * ksmbd_decompress_request() - replace a compressed request with its SMB2 PDU
+ * @conn: connection which owns the current RFC1002 request buffer
+ *
+ * Derive the uncompressed size from the transform variant, enforce ksmbd's
+ * normal message limits, and ask the common decoder to validate every payload.
+ * On success, replace conn->request_buf with a regular RFC1002-framed SMB2
+ * message so the rest of the request path needs no compression awareness.
+ *
+ * Return: 0 on success, otherwise a negative errno.
+ */
+int ksmbd_decompress_request(struct ksmbd_conn *conn)
+{
+	void *out_buf;
+	int rc;
+
+	rc = __ksmbd_decompress_request(conn, conn->request_buf, &out_buf);
+	if (rc)
+		return rc;
+
 	kvfree(conn->request_buf);
-	conn->request_buf = out;
+	conn->request_buf = out_buf;
+	return 0;
+}
+
+/**
+ * ksmbd_decompress_work_request() - decompress an encrypted work request
+ * @work: work item whose request buffer contains a compression transform
+ *
+ * SMB3 encrypts a compressed message by applying compression first and
+ * encryption second.  The receive loop can therefore only decode the
+ * compression transform before work allocation for an unencrypted request;
+ * an encrypted request must be decompressed after its encryption layer has
+ * been removed.
+ *
+ * Return: 0 on success, otherwise a negative errno.
+ */
+int ksmbd_decompress_work_request(struct ksmbd_work *work)
+{
+	void *out_buf;
+	int rc;
+
+	rc = __ksmbd_decompress_request(work->conn, work->request_buf,
+					&out_buf);
+	if (rc)
+		return rc;
+
+	kvfree(work->request_buf);
+	work->request_buf = out_buf;
 	return 0;
 }
 
diff --git a/fs/smb/server/compress.h b/fs/smb/server/compress.h
index 663c6f44f09b..13df2eb221e8 100644
--- a/fs/smb/server/compress.h
+++ b/fs/smb/server/compress.h
@@ -11,6 +11,7 @@
 #include "../common/compress/compress.h"
 
 int ksmbd_decompress_request(struct ksmbd_conn *conn);
+int ksmbd_decompress_work_request(struct ksmbd_work *work);
 int ksmbd_compress_response(struct ksmbd_work *work);
 
 #endif /* __KSMBD_COMPRESS_H__ */
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index ba44bea9ddc3..6cfe8148da85 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -193,6 +193,28 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 			return;
 		}
 		work->encrypted = true;
+
+		/*
+		 * SMB3 applies compression before encryption.  The receive loop
+		 * handles a plain compression transform before allocating work, but
+		 * an encrypted request exposes that transform only after decryption.
+		 */
+		if (((struct smb2_hdr *)smb_get_msg(work->request_buf))->ProtocolId ==
+		    SMB2_COMPRESSION_TRANSFORM_ID) {
+			rc = ksmbd_decompress_work_request(work);
+			if (rc < 0) {
+				ksmbd_conn_abort(conn);
+				return;
+			}
+		}
+
+		/* The decrypted payload must now be a complete SMB2 request. */
+		if (((struct smb2_hdr *)smb_get_msg(work->request_buf))->ProtocolId !=
+			SMB2_PROTO_NUMBER ||
+		    get_rfc1002_len(work->request_buf) < sizeof(struct smb2_pdu)) {
+			ksmbd_conn_abort(conn);
+			return;
+		}
 	}
 
 	if (conn->ops->allocate_rsp_buf(work))
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8d06c934f24f..a564535132e5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -11817,18 +11817,27 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	char *buf = work->request_buf;
 	unsigned int pdu_length = get_rfc1002_len(buf);
 	struct kvec iov[2];
-	int buf_data_size = pdu_length - sizeof(struct smb2_transform_hdr);
+	unsigned int buf_data_size;
 	struct smb2_transform_hdr *tr_hdr = smb_get_msg(buf);
+	unsigned int original_msg_size;
 	int rc = 0;
 
-	if (pdu_length < sizeof(struct smb2_transform_hdr) ||
-	    buf_data_size < sizeof(struct smb2_hdr)) {
+	if (pdu_length < sizeof(struct smb2_transform_hdr)) {
 		pr_err("Transform message is too small (%u)\n",
 		       pdu_length);
 		return -ECONNABORTED;
 	}
 
-	if (buf_data_size < le32_to_cpu(tr_hdr->OriginalMessageSize)) {
+	buf_data_size = pdu_length - sizeof(struct smb2_transform_hdr);
+	original_msg_size = le32_to_cpu(tr_hdr->OriginalMessageSize);
+	if (buf_data_size < sizeof(struct smb2_compression_hdr) ||
+	    original_msg_size < sizeof(struct smb2_compression_hdr)) {
+		pr_err("Transform message is too small (%u)\n",
+		       pdu_length);
+		return -ECONNABORTED;
+	}
+
+	if (buf_data_size < original_msg_size) {
 		pr_err("Transform message is broken\n");
 		return -ECONNABORTED;
 	}
@@ -11841,8 +11850,9 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	if (rc)
 		return rc;
 
-	memmove(buf + 4, iov[1].iov_base, buf_data_size);
-	*(__be32 *)buf = cpu_to_be32(buf_data_size);
+	/* Drop the AEAD authentication tag from the inner RFC1002 frame. */
+	memmove(buf + 4, iov[1].iov_base, original_msg_size);
+	*(__be32 *)buf = cpu_to_be32(original_msg_size);
 
 	return rc;
 }
-- 
2.25.1

