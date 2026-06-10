Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739CB2F8EB5
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781104581; cv=none; b=VQaPGlAqwaD2HnI6rvD+zfkQsiQILcif00z+owPecACH8MX7o8EJd25+H1E2uVPKDtC4arKROuK5ClSs6M/+er3U5LdVxXfMGnsQV+zFyG2c2lrGRiq7K74DGCqJj1jZ/sW87TrCpqOL+it/5u0rTOqqP3BDtrP8CTbdf7x/vyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781104581; c=relaxed/simple;
	bh=sYglwa0ajga0GeFgFhmcUKjVcCKH2P6TGrP0E82pTMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YgPRCDjfdqPwpfqmNeDQszUeSb+5aJbVvic3CcqcefMe3X1rHnHCnWk7mz4DbfhssnWmH4TYuekUxW8Kdv3OogXxBkk8etdoZ+Dh50DEdQTso16lTL9z0XN+ke1R7SLaAstBhvGGezM7mBGvUlifbFk1hXJ6G3Mmlr6WP4AZGN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Su+Ewm77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Su+Ewm77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DA41F00893;
	Wed, 10 Jun 2026 15:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781104580;
	bh=M3DzhDZQm03Tj2ZWDHPNqJUSRh8U/EZmUOYVRNA9Ds0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Su+Ewm77bMCKKj/OH1rXhmHYGwJ2yIradaz8yZ0QCpwssz9U2aqq7GJIdYJCQOJLg
	 J7pH9/IuH7go6oB8Dk5xNTIsGFZkRXKweS/4VyXI/m11KkUo9T3wbFK+ZRsfOk0zbi
	 lMUK1K+0jNPB1HUezQuuhHVNEu5LLUFDxnbHX7myhqZyAU4CN4fhDuNr/IWEXXfrty
	 7UdoSJvhvaDfBEMlNrZp4ZNixXFIEL2EpBNe7X+ykdt5QVI6dFo1T3wHFuahttlJJ8
	 2uqCuyvvnJspOfe/m9/R1kmcaN2ygpLLw1WqTAHZGvb0rMYWnpI8hSEnMDqKYwofA7
	 HfgmN5py/qsyg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 4/5] ksmbd: negotiate and decode SMB2 compression
Date: Thu, 11 Jun 2026 00:15:42 +0900
Message-Id: <20260610151543.25218-5-linkinjeon@kernel.org>
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

Parse the SMB 3.1.1 compression capabilities context and negotiate LZ77
with optional chained Pattern_V1 support.

Advertise compression on tree connections and decode compressed requests
before normal SMB dispatch.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/Makefile     |   2 +-
 fs/smb/server/compress.c   |  77 ++++++++++++++++++++++++++
 fs/smb/server/compress.h   |  15 +++++
 fs/smb/server/connection.c |  12 ++++
 fs/smb/server/connection.h |   3 +
 fs/smb/server/smb2pdu.c    | 109 ++++++++++++++++++++++++++++++++++---
 fs/smb/server/smb_common.c |   5 --
 7 files changed, 210 insertions(+), 13 deletions(-)
 create mode 100644 fs/smb/server/compress.c
 create mode 100644 fs/smb/server/compress.h

diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index 6407ba6b9340..a3e9306055e8 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -10,7 +10,7 @@ ksmbd-y :=	unicode.o auth.o vfs.o vfs_cache.o server.o ndr.o \
 		mgmt/tree_connect.o mgmt/user_session.o smb_common.o \
 		transport_tcp.o transport_ipc.o smbacl.o smb2pdu.o \
 		smb2ops.o smb2misc.o ksmbd_spnego_negtokeninit.asn1.o \
-		ksmbd_spnego_negtokentarg.asn1.o asn1.o
+		ksmbd_spnego_negtokentarg.asn1.o asn1.o compress.o
 
 $(obj)/asn1.o: $(obj)/ksmbd_spnego_negtokeninit.asn1.h $(obj)/ksmbd_spnego_negtokentarg.asn1.h
 
diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
new file mode 100644
index 000000000000..7c9f8a6cceb8
--- /dev/null
+++ b/fs/smb/server/compress.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * SMB2 compression support for ksmbd.
+ *
+ * Receive and send SMB 3.1.1 compression transforms using the common helpers.
+ *
+ * Copyright (C) 2026 Namjae Jeon <linkinjeon@kernel.org>
+ */
+#include <linux/slab.h>
+
+#include "compress.h"
+#include "smb_common.h"
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
+	struct smb2_compression_hdr *hdr;
+	unsigned int pdu_size = get_rfc1002_len(conn->request_buf);
+	u32 orig_size, offset, out_size;
+	u32 max_allowed_pdu_size;
+	char *buf, *out;
+	int rc;
+
+	if (pdu_size < sizeof(struct smb2_compression_hdr))
+		return -EINVAL;
+
+	if (conn->dialect != SMB311_PROT_ID ||
+	    conn->compress_algorithm == SMB3_COMPRESS_NONE)
+		return -EINVAL;
+
+	hdr = smb_get_msg(conn->request_buf);
+	if (hdr->ProtocolId != SMB2_COMPRESSION_TRANSFORM_ID)
+		return -EINVAL;
+
+	orig_size = le32_to_cpu(hdr->OriginalCompressedSegmentSize);
+	if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED)) {
+		out_size = orig_size;
+	} else {
+		offset = le32_to_cpu(hdr->Offset);
+		if (offset > pdu_size - sizeof(*hdr) ||
+		    check_add_overflow(orig_size, offset, &out_size))
+			return -EINVAL;
+	}
+
+	max_allowed_pdu_size = SMB3_MAX_MSGSIZE + conn->vals->max_write_size;
+	if (out_size > max_allowed_pdu_size ||
+	    out_size > MAX_STREAM_PROT_LEN)
+		return -EINVAL;
+
+	out = kvmalloc(out_size + 4 + 1, KSMBD_DEFAULT_GFP);
+	if (!out)
+		return -ENOMEM;
+
+	buf = (char *)hdr;
+	*(__be32 *)out = cpu_to_be32(out_size);
+	rc = smb_compression_decompress(conn->compress_algorithm,
+					conn->compress_chained,
+					buf, pdu_size, out + 4, out_size);
+	if (rc) {
+		kvfree(out);
+		return rc;
+	}
+
+	kvfree(conn->request_buf);
+	conn->request_buf = out;
+	return 0;
+}
diff --git a/fs/smb/server/compress.h b/fs/smb/server/compress.h
new file mode 100644
index 000000000000..49b36d931aac
--- /dev/null
+++ b/fs/smb/server/compress.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * SMB2 compression support for ksmbd.
+ *
+ * Copyright (C) 2026 Namjae Jeon <linkinjeon@kernel.org>
+ */
+#ifndef __KSMBD_COMPRESS_H__
+#define __KSMBD_COMPRESS_H__
+
+#include "connection.h"
+#include "../common/compress/compress.h"
+
+int ksmbd_decompress_request(struct ksmbd_conn *conn);
+
+#endif /* __KSMBD_COMPRESS_H__ */
diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 8347495dbc62..9e8fdb39e5a2 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -12,6 +12,7 @@
 #include "smb_common.h"
 #include "mgmt/ksmbd_ida.h"
 #include "connection.h"
+#include "compress.h"
 #include "transport_tcp.h"
 #include "transport_rdma.h"
 #include "misc.h"
@@ -531,6 +532,17 @@ int ksmbd_conn_handler_loop(void *p)
 			continue;
 		}
 
+		if (((struct smb2_hdr *)smb_get_msg(conn->request_buf))->ProtocolId ==
+		    SMB2_COMPRESSION_TRANSFORM_ID) {
+			/*
+			 * Convert the transform into a normal RFC1002-framed SMB2
+			 * request before protocol validation and work allocation.
+			 */
+			if (ksmbd_decompress_request(conn))
+				break;
+			pdu_size = get_rfc1002_len(conn->request_buf);
+		}
+
 		if (!ksmbd_smb_request(conn))
 			break;
 
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index e074be942582..ec75633b7da0 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -115,6 +115,9 @@ struct ksmbd_conn {
 
 	__le16				cipher_type;
 	__le16				compress_algorithm;
+	/* Negotiated SMB 3.1.1 compression capabilities. */
+	bool				compress_chained;
+	bool				compress_pattern;
 	bool				posix_ext_supported;
 	bool				signing_negotiated;
 	__le16				signing_algorithm;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7e61377a16bb..86309dc70a62 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -41,6 +41,7 @@
 #include "ndr.h"
 #include "stats.h"
 #include "transport_tcp.h"
+#include "compress.h"
 
 static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
 {
@@ -803,6 +804,30 @@ static void build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt,
 	pneg_ctxt->Ciphers[0] = cipher_type;
 }
 
+static void build_compress_ctxt(struct smb2_compression_capabilities_context *pneg_ctxt,
+				__le16 compress_algorithm, bool compress_chained,
+				bool compress_pattern)
+{
+	/*
+	 * Return only algorithms implemented by ksmbd. Pattern_V1 is advertised
+	 * as a second ID when the client also enabled chained transforms.
+	 */
+	pneg_ctxt->ContextType = SMB2_COMPRESSION_CAPABILITIES;
+	pneg_ctxt->DataLength = cpu_to_le16(compress_pattern ? 12 : 10);
+	pneg_ctxt->Reserved = cpu_to_le32(0);
+	pneg_ctxt->CompressionAlgorithmCount =
+		cpu_to_le16(compress_pattern ? 2 : 1);
+	pneg_ctxt->Padding = cpu_to_le16(0);
+	pneg_ctxt->Flags = compress_chained ?
+		SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED :
+		SMB2_COMPRESSION_CAPABILITIES_FLAG_NONE;
+	pneg_ctxt->CompressionAlgorithms[0] = compress_algorithm;
+	pneg_ctxt->CompressionAlgorithms[1] = compress_pattern ?
+		SMB3_COMPRESS_PATTERN : 0;
+	pneg_ctxt->CompressionAlgorithms[2] = 0;
+	pneg_ctxt->CompressionAlgorithms[3] = 0;
+}
+
 static void build_sign_cap_ctxt(struct smb2_signing_capabilities *pneg_ctxt,
 				__le16 sign_algo)
 {
@@ -864,8 +889,19 @@ static unsigned int assemble_neg_contexts(struct ksmbd_conn *conn,
 		ctxt_size += sizeof(struct smb2_encryption_neg_context) + 2;
 	}
 
-	/* compression context not yet supported */
-	WARN_ON(conn->compress_algorithm != SMB3_COMPRESS_NONE);
+	if (conn->compress_algorithm != SMB3_COMPRESS_NONE) {
+		ctxt_size = round_up(ctxt_size, 8);
+		ksmbd_debug(SMB,
+			    "assemble SMB2_COMPRESSION_CAPABILITIES context\n");
+		build_compress_ctxt((struct smb2_compression_capabilities_context *)
+				    (pneg_ctxt + ctxt_size),
+				    conn->compress_algorithm,
+				    conn->compress_chained,
+				    conn->compress_pattern);
+		neg_ctxt_cnt++;
+		ctxt_size += sizeof(struct smb2_neg_context) +
+			(conn->compress_pattern ? 12 : 10);
+	}
 
 	if (conn->posix_ext_supported) {
 		ctxt_size = round_up(ctxt_size, 8);
@@ -969,10 +1005,59 @@ bool smb3_encryption_negotiated(struct ksmbd_conn *conn)
 	    conn->cipher_type;
 }
 
-static void decode_compress_ctxt(struct ksmbd_conn *conn,
-				 struct smb2_compression_capabilities_context *pneg_ctxt)
+static __le32 decode_compress_ctxt(struct ksmbd_conn *conn,
+				   struct smb2_compression_capabilities_context *pneg_ctxt,
+				   int ctxt_len)
 {
+	int alg_cnt, algs_size, i;
+
+	if (sizeof(struct smb2_neg_context) + 10 > ctxt_len) {
+		pr_err("Invalid SMB2_COMPRESSION_CAPABILITIES context length\n");
+		return STATUS_INVALID_PARAMETER;
+	}
+
 	conn->compress_algorithm = SMB3_COMPRESS_NONE;
+	conn->compress_chained = false;
+	conn->compress_pattern = false;
+
+	alg_cnt = le16_to_cpu(pneg_ctxt->CompressionAlgorithmCount);
+	if (!alg_cnt)
+		return STATUS_INVALID_PARAMETER;
+
+	if (pneg_ctxt->Flags != SMB2_COMPRESSION_CAPABILITIES_FLAG_NONE &&
+	    pneg_ctxt->Flags != SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED)
+		return STATUS_INVALID_PARAMETER;
+
+	algs_size = alg_cnt * sizeof(__le16);
+	if (sizeof(struct smb2_neg_context) + 8 + algs_size > ctxt_len) {
+		pr_err("Invalid compression algorithm count(%d)\n", alg_cnt);
+		return STATUS_INVALID_PARAMETER;
+	}
+
+	for (i = 0; i < alg_cnt; i++) {
+		__le16 alg = pneg_ctxt->CompressionAlgorithms[i];
+
+		/*
+		 * LZ77 is the required general-purpose codec. Pattern_V1 is an
+		 * optional chained payload type and cannot stand alone.
+		 */
+		if (alg == SMB3_COMPRESS_LZ77) {
+			conn->compress_algorithm = alg;
+			conn->compress_chained =
+				pneg_ctxt->Flags ==
+				SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED;
+			ksmbd_debug(SMB, "Compression Algorithm ID = 0x%x\n",
+				    le16_to_cpu(alg));
+		} else if (alg == SMB3_COMPRESS_PATTERN) {
+			conn->compress_pattern = true;
+		}
+	}
+
+	if (conn->compress_algorithm == SMB3_COMPRESS_NONE ||
+	    !conn->compress_chained)
+		conn->compress_pattern = false;
+
+	return STATUS_SUCCESS;
 }
 
 static void decode_sign_cap_ctxt(struct ksmbd_conn *conn,
@@ -1020,6 +1105,7 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 	unsigned int offset = le32_to_cpu(req->NegotiateContextOffset);
 	unsigned int neg_ctxt_cnt = le16_to_cpu(req->NegotiateContextCount);
 	__le32 status = STATUS_INVALID_PARAMETER;
+	int compress_ctxt_cnt = 0;
 
 	ksmbd_debug(SMB, "decoding %d negotiate contexts\n", neg_ctxt_cnt);
 	if (len_of_smb <= offset) {
@@ -1065,11 +1151,16 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 		} else if (pctx->ContextType == SMB2_COMPRESSION_CAPABILITIES) {
 			ksmbd_debug(SMB,
 				    "deassemble SMB2_COMPRESSION_CAPABILITIES context\n");
-			if (conn->compress_algorithm)
+			if (compress_ctxt_cnt++) {
+				status = STATUS_INVALID_PARAMETER;
 				break;
+			}
 
-			decode_compress_ctxt(conn,
-					     (struct smb2_compression_capabilities_context *)pctx);
+			status = decode_compress_ctxt(conn,
+				(struct smb2_compression_capabilities_context *)
+				pctx, ctxt_len);
+			if (status != STATUS_SUCCESS)
+				break;
 		} else if (pctx->ContextType == SMB2_NETNAME_NEGOTIATE_CONTEXT_ID) {
 			ksmbd_debug(SMB,
 				    "deassemble SMB2_NETNAME_NEGOTIATE_CONTEXT_ID context\n");
@@ -2060,6 +2151,10 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	rsp->Reserved = 0;
 	/* default manual caching */
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
+	/* Tell the client that READ requests may request compressed responses. */
+	if (conn->dialect == SMB311_PROT_ID &&
+	    conn->compress_algorithm != SMB3_COMPRESS_NONE)
+		rsp->ShareFlags |= cpu_to_le32(SMB2_SHAREFLAG_COMPRESS_DATA);
 
 	rc = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_tree_connect_rsp));
 	if (rc)
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 82de4fdfe446..7de73223189a 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -185,11 +185,6 @@ bool ksmbd_smb_request(struct ksmbd_conn *conn)
 		return false;
 
 	proto = (__le32 *)smb_get_msg(conn->request_buf);
-	if (*proto == SMB2_COMPRESSION_TRANSFORM_ID) {
-		pr_err_ratelimited("smb2 compression not support yet");
-		return false;
-	}
-
 	if (*proto != SMB1_PROTO_NUMBER &&
 	    *proto != SMB2_PROTO_NUMBER &&
 	    *proto != SMB2_TRANSFORM_PROTO_NUM)
-- 
2.25.1

