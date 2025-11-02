Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF3425A2CF
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068746; cv=none; b=d9VmMFNCOp2lLBH/jBSxxgf8M/EAwRPX0wDm/HTJ584gMGYCyQrkxVAwfuD56WDQLRUVHIWnQl99eIjNA31bY8QNJO4R1nKggoBioFsKiOSjAw5R0jEHd/iYwUroeKLHPaTK+LhP1oP0Mc4h0JOAzmllZlWXAG0j1G9/2m/bSjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068746; c=relaxed/simple;
	bh=oFcduW8EBxovJps2xM5lgpemOawzxJSoVsXhB7ssgQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihUoFASO8s90uX0g0eGWHCLHFyxZsnshJD4n42iN+FLY3UZ707HEa0DG8pE2bfYXuxtJ0gIXgULz6DXLMO0xidf3/7UUFNnJi63h+wc5BAMEFHDs7UAYpIYYU3auyqEj6F2/XKbFfjtAEjAv7M3+HLwxBrjs1ZLdFtMmnyT4NTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j7cgBI3e; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j7cgBI3e"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TBMBBXhF+iAnhKajC9o8kG0oZA2xlyraE66PEpXklMs=;
	b=j7cgBI3e8M7YicrLU+sHT23zY2CtM1Uj5TkyvJIglYwWu974nwU2WJ4oMKGEZ6r+7IjHGT
	YHNU+Adrv/PToW0yOr1wbAOftZDnzCT5o6U6r7MrF7kRSS5GoqOBon1atJFQvD6RS/pJXF
	tvQZLb/eG4DRQtiY1WxEDdba+uTF+rU=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 03/14] smb: move create_durable_req_v2 to common/smb2pdu.h
Date: Sun,  2 Nov 2025 15:30:48 +0800
Message-ID: <20251102073059.3681026-4-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Modify the following places:

  - some fields in "struct create_durable_req_v2" ->
                           struct durable_context_v2
  - durable_context_v2 -> durable_context_v2_req
  - create_durable_v2 -> create_durable_req_v2

Then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.c | 14 +++++++-------
 fs/smb/client/smb2pdu.h | 12 ------------
 fs/smb/common/smb2pdu.h | 14 ++++++++++++++
 fs/smb/server/smb2pdu.c |  8 ++++----
 fs/smb/server/smb2pdu.h |  9 ---------
 5 files changed, 25 insertions(+), 32 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b0739a2661bf..c1f67864c84b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2424,21 +2424,21 @@ add_lease_context(struct TCP_Server_Info *server,
 	return 0;
 }
 
-static struct create_durable_v2 *
+static struct create_durable_req_v2 *
 create_durable_v2_buf(struct cifs_open_parms *oparms)
 {
 	struct cifs_fid *pfid = oparms->fid;
-	struct create_durable_v2 *buf;
+	struct create_durable_req_v2 *buf;
 
-	buf = kzalloc(sizeof(struct create_durable_v2), GFP_KERNEL);
+	buf = kzalloc(sizeof(struct create_durable_req_v2), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
-					(struct create_durable_v2, dcontext));
-	buf->ccontext.DataLength = cpu_to_le32(sizeof(struct durable_context_v2));
+					(struct create_durable_req_v2, dcontext));
+	buf->ccontext.DataLength = cpu_to_le32(sizeof(struct durable_context_v2_req));
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
-				(struct create_durable_v2, Name));
+				(struct create_durable_req_v2, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
 
 	/*
@@ -2508,7 +2508,7 @@ add_durable_v2_context(struct kvec *iov, unsigned int *num_iovec,
 	iov[num].iov_base = create_durable_v2_buf(oparms);
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
-	iov[num].iov_len = sizeof(struct create_durable_v2);
+	iov[num].iov_len = sizeof(struct create_durable_req_v2);
 	*num_iovec = num + 1;
 	return 0;
 }
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 0ce9f93f108f..a700b404a57c 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -137,18 +137,6 @@ struct share_redirect_error_context_rsp {
 /* See MS-SMB2 2.2.13.2.11 */
 /* Flags */
 #define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
-struct durable_context_v2 {
-	__le32 Timeout;
-	__le32 Flags;
-	__u64 Reserved;
-	__u8 CreateGuid[16];
-} __packed;
-
-struct create_durable_v2 {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	struct durable_context_v2 dcontext;
-} __packed;
 
 /* See MS-SMB2 2.2.13.2.12 */
 struct durable_reconnect_context_v2 {
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index a7ea4214d061..681855ebacc9 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1290,6 +1290,20 @@ struct create_mxac_req {
 	__le64 Timestamp;
 } __packed;
 
+/* See MS-SMB2 2.2.13.2.11 */
+struct durable_context_v2_req {
+	__le32 Timeout;
+	__le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
+	__u64 Reserved;
+	__u8 CreateGuid[16];
+} __packed;
+
+struct create_durable_req_v2 {
+	struct create_context_hdr ccontext;
+	__u8   Name[8];
+	struct durable_context_v2_req dcontext;
+} __packed;
+
 /* See MS-SMB2 2.2.14.2.5 */
 struct create_mxac_rsp {
 	struct create_context_hdr ccontext;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e50d54a3a9c5..96c6bbc9d3d3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2816,7 +2816,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 			durable_v2_blob =
 				(struct create_durable_req_v2 *)context;
 			ksmbd_debug(SMB, "Request for durable v2 open\n");
-			dh_info->fp = ksmbd_lookup_fd_cguid(durable_v2_blob->CreateGuid);
+			dh_info->fp = ksmbd_lookup_fd_cguid(durable_v2_blob->dcontext.CreateGuid);
 			if (dh_info->fp) {
 				if (!memcmp(conn->ClientGUID, dh_info->fp->client_guid,
 					    SMB2_CLIENT_GUID_SIZE)) {
@@ -2834,11 +2834,11 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 			if ((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
 			    req_op_level == SMB2_OPLOCK_LEVEL_BATCH) {
 				dh_info->CreateGuid =
-					durable_v2_blob->CreateGuid;
+					durable_v2_blob->dcontext.CreateGuid;
 				dh_info->persistent =
-					le32_to_cpu(durable_v2_blob->Flags);
+					le32_to_cpu(durable_v2_blob->dcontext.Flags);
 				dh_info->timeout =
-					le32_to_cpu(durable_v2_blob->Timeout);
+					le32_to_cpu(durable_v2_blob->dcontext.Timeout);
 				dh_info->type = dh_idx;
 			}
 			break;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 807079d19d1e..93d43da626d4 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -66,15 +66,6 @@ struct preauth_integrity_info {
 /* Apple Defined Contexts */
 #define SMB2_CREATE_AAPL		"AAPL"
 
-struct create_durable_req_v2 {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	__le32 Timeout;
-	__le32 Flags;
-	__u8 Reserved[8];
-	__u8 CreateGuid[16];
-} __packed;
-
 #define DURABLE_HANDLE_MAX_TIMEOUT	300000
 
 struct create_durable_reconn_req {
-- 
2.43.0

