Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3297C3234
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748448165; cv=none; b=OkarT4Mm1ZGGSbpOsv29AP3ChRKnCKV2JBeG2DBoKq7dHNsUw4sCUuvKbnsbG6uEgjRSsYFPcd4jXYSPQ46YxtnRfixLBD6V/AGqRFTgAc15/yIdnnGsMAs0yGZ87/N9HfrH+QhBduCmDsSKnYt5ONdWtykXXMswnxlIPB2Ytig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748448165; c=relaxed/simple;
	bh=v/jPQcgkIknJAtMZ1SIw26E4fKipzgEDpq9klYdfasQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TPA1QDZsTGPykDJIYd1aRBGMkvj9ZvAatLxZ/pANT/0TV4oET6GMwLAY7cdMJ8R6DoCXB99bV758TMc6e3p+cWTHjpZ47r4981fFmnAWuLHvxKOWvqBUgP/tV8qUFi/uKVzXJdbgT8gg62B3rRTDHzJpf2L2Z+rMkiLWbb97v34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=OHDS8/uy; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OHDS8/uy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=/jmE3OrOek0uyTvGELgfC3Erx3e9sATf5y9xZJo9UcM=; b=OHDS8/uyMwpWoeq1CRLNuh8n8X
	GeC1RzcZXZjIuWsxEsKrg2cmVozKg9rmpgKDTFL5lJYVH7ghaAyHca8N4liHg8+BQS2EqcMqjWWDh
	nZTwA2/opr5dKFCs4jpafmy7tKLb26dgXGdFITu7WQHG49RnoqSR0OUxMHm3dmvYNrXGLgnGMgGKH
	CxkdjzEFy9e9o7u/4N7gDb6YsHKritIsKq897qFUDz4srRRKTuuPJ6XuvUY3CWolvrqZIX3r/voQO
	sMCtHcXI7rxdze7ougMAW9jXUw9utbdS/AxHZIANsgfQzJGdbz+2i9KEJZ/LLDbmbxv2G5TaLQ9XI
	HWfBTJoP/0PUiFeACJIrJ10R9WtmZp4tuBNOvtxMo6u1Sp7McI+l9162CSpd8/K4uBtC0u3kL3RLD
	dXwMWJ+Wz9fRCoSSxl7jfbBuVDo9ZlYM+b+5ZlqIKb4NVqcJwJoT5VbxAtR8srLM9juz2MmYhCCo1
	DN19NxJgWmvqOqlkkLgAXOPc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uKJEi-007hKU-12;
	Wed, 28 May 2025 16:02:36 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH v2 05/12] smb: client: make use of common smbdirect.h
Date: Wed, 28 May 2025 18:01:34 +0200
Message-Id: <cd1351a794c6af9c2a7f6f0820bb266df3f9cf40.1748446473.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1748446473.git.metze@samba.org>
References: <cover.1748446473.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smb2pdu.c   | 17 +++++++++--------
 fs/smb/client/smbdirect.h |  7 -------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 701a138b82c8..3529b829cda7 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -36,6 +36,7 @@
 #include "smb2glob.h"
 #include "cifspdu.h"
 #include "cifs_spnego.h"
+#include "../common/smbdirect/smbdirect.h"
 #include "smbdirect.h"
 #include "trace.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
@@ -4442,10 +4443,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	/*
 	 * If we want to do a RDMA write, fill in and append
-	 * smbd_buffer_descriptor_v1 to the end of read request
+	 * smbdirect_buffer_descriptor_v1 to the end of read request
 	 */
 	if (rdata && smb3_use_rdma_offload(io_parms)) {
-		struct smbd_buffer_descriptor_v1 *v1;
+		struct smbdirect_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
 		rdata->mr = smbd_register_mr(server->smbd_conn, &rdata->subreq.io_iter,
@@ -4459,8 +4460,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 		req->ReadChannelInfoOffset =
 			cpu_to_le16(offsetof(struct smb2_read_req, Buffer));
 		req->ReadChannelInfoLength =
-			cpu_to_le16(sizeof(struct smbd_buffer_descriptor_v1));
-		v1 = (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
+			cpu_to_le16(sizeof(struct smbdirect_buffer_descriptor_v1));
+		v1 = (struct smbdirect_buffer_descriptor_v1 *) &req->Buffer[0];
 		v1->offset = cpu_to_le64(rdata->mr->mr->iova);
 		v1->token = cpu_to_le32(rdata->mr->mr->rkey);
 		v1->length = cpu_to_le32(rdata->mr->mr->length);
@@ -4968,10 +4969,10 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	/*
 	 * If we want to do a server RDMA read, fill in and append
-	 * smbd_buffer_descriptor_v1 to the end of write request
+	 * smbdirect_buffer_descriptor_v1 to the end of write request
 	 */
 	if (smb3_use_rdma_offload(io_parms)) {
-		struct smbd_buffer_descriptor_v1 *v1;
+		struct smbdirect_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
 		wdata->mr = smbd_register_mr(server->smbd_conn, &wdata->subreq.io_iter,
@@ -4990,8 +4991,8 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		req->WriteChannelInfoOffset =
 			cpu_to_le16(offsetof(struct smb2_write_req, Buffer));
 		req->WriteChannelInfoLength =
-			cpu_to_le16(sizeof(struct smbd_buffer_descriptor_v1));
-		v1 = (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
+			cpu_to_le16(sizeof(struct smbdirect_buffer_descriptor_v1));
+		v1 = (struct smbdirect_buffer_descriptor_v1 *) &req->Buffer[0];
 		v1->offset = cpu_to_le64(wdata->mr->mr->iova);
 		v1->token = cpu_to_le32(wdata->mr->mr->rkey);
 		v1->length = cpu_to_le32(wdata->mr->mr->length);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 4da0974ce730..8561e19a23a3 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -177,13 +177,6 @@ enum smbd_message_type {
 	SMBD_TRANSFER_DATA,
 };
 
-/* The packet fields for a registered RDMA buffer */
-struct smbd_buffer_descriptor_v1 {
-	__le64 offset;
-	__le32 token;
-	__le32 length;
-} __packed;
-
 /* Maximum number of SGEs used by smbdirect.c in any send work request */
 #define SMBDIRECT_MAX_SEND_SGE	6
 
-- 
2.34.1

