Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFC52DE719
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549829; cv=none; b=IVExp9IS/URdr67k+BRebsjln4NAOKUwdK3dO7jPak6wv0MKjc0bNlFLirtdRNi6N3YWbAO1VwNykqkSkmfVfoTFPOOZGuNzZBI8thJRMRR3qbLfXMQ5dAJbU0jAADKxRnDIAeYEiNxJi5EXVHQQpVvdFL86UJHvWk0HVsJuNX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549829; c=relaxed/simple;
	bh=SkqKBZXxog5ZlgIJHE7/3cbOvSRpBP3o9vlWXW2MInY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieC5Ze7y/j3Y6wNZ67VlEj5bNtDXWPevwrl4dUY7YeIE1Qkc0tNDTD/jtwl0sQaKf8NRqEyVGQELzpPAz1kyJl9aNjFJuBE0VBNaHGO8HpFD0ZOs/wvzG/5y2mYpLK1Tv39hTTQwFID05VgDmxtjMnczkw7jt5zaP9jziwQqsbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U16ESKVa; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U16ESKVa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xKu16hoh+lI6u2jjZXA4ya5Kp6Jm/q+v+WgXhovtXEQ=;
	b=U16ESKVanqO8GSBjppjyWMStGL5vvn3vYX0ANm5RJ1ittTwnrziuaJkcvjK7rxYxnU/oUM
	/UOEZjC3i4FDxiZeD83oWjFSnCyhtklZnweDM59zYFmlO2mYXg7LfwTVoqYXKagHwbuNBG
	of/8OehPKmeTmpQjFox1HvXVRDpuBHY=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 17/24] smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h
Date: Mon, 27 Oct 2025 15:21:59 +0800
Message-ID: <20251027072206.3468578-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Replace some fields in "struct create_durable_reconn_v2_req" with "struct
durable_reconnect_context_v2", rename "create_durable_reconn_v2_req" to
"create_durable_handle_reconnect_v2", then move duplicate definitions to
common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.h | 17 -----------------
 fs/smb/common/smb2pdu.h | 16 ++++++++++++++++
 fs/smb/server/smb2pdu.c | 10 +++++-----
 fs/smb/server/smb2pdu.h | 11 -----------
 4 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 94d184733f33..23cf5ac713ee 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -138,29 +138,12 @@ struct share_redirect_error_context_rsp {
 /* Flags */
 #define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
 
-/* See MS-SMB2 2.2.13.2.12 */
-struct durable_reconnect_context_v2 {
-	struct {
-		__u64 PersistentFileId;
-		__u64 VolatileFileId;
-	} Fid;
-	__u8 CreateGuid[16];
-	__le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
-} __packed;
-
 /* See MS-SMB2 2.2.14.2.12 */
 struct durable_reconnect_context_v2_rsp {
 	__le32 Timeout;
 	__le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
 } __packed;
 
-struct create_durable_handle_reconnect_v2 {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	struct durable_reconnect_context_v2 dcontext;
-	__u8   Pad[4];
-} __packed;
-
 /* See MS-SMB2 2.2.13.2.5 */
 struct crt_twarp_ctxt {
 	struct create_context_hdr ccontext;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 6a5c8eef357d..0fd1c8ad51c3 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1298,6 +1298,22 @@ struct create_durable_req_v2 {
 	struct durable_context_v2_req dcontext;
 } __packed;
 
+/* See MS-SMB2 2.2.13.2.12 */
+struct durable_reconnect_context_v2 {
+	struct {
+		__u64 PersistentFileId;
+		__u64 VolatileFileId;
+	} Fid;
+	__u8 CreateGuid[16];
+	__le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
+} __packed;
+
+struct create_durable_handle_reconnect_v2 {
+	struct create_context_hdr ccontext;
+	__u8   Name[8];
+	struct durable_reconnect_context_v2 dcontext;
+} __packed;
+
 /* See MS-SMB2 2.2.14.2.5 */
 struct create_mxac_rsp {
 	struct create_context_hdr ccontext;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 92bd086ca715..6b3503c7bfaa 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2726,7 +2726,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 		switch (dh_idx) {
 		case DURABLE_RECONN_V2:
 		{
-			struct create_durable_reconn_v2_req *recon_v2;
+			struct create_durable_handle_reconnect_v2 *recon_v2;
 
 			if (dh_info->type == DURABLE_RECONN ||
 			    dh_info->type == DURABLE_REQ_V2) {
@@ -2736,13 +2736,13 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 
 			if (le16_to_cpu(context->DataOffset) +
 				le32_to_cpu(context->DataLength) <
-			    sizeof(struct create_durable_reconn_v2_req)) {
+			    sizeof(struct create_durable_handle_reconnect_v2)) {
 				err = -EINVAL;
 				goto out;
 			}
 
-			recon_v2 = (struct create_durable_reconn_v2_req *)context;
-			persistent_id = recon_v2->Fid.PersistentFileId;
+			recon_v2 = (struct create_durable_handle_reconnect_v2 *)context;
+			persistent_id = recon_v2->dcontext.Fid.PersistentFileId;
 			dh_info->fp = ksmbd_lookup_durable_fd(persistent_id);
 			if (!dh_info->fp) {
 				ksmbd_debug(SMB, "Failed to get durable handle state\n");
@@ -2750,7 +2750,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (memcmp(dh_info->fp->create_guid, recon_v2->CreateGuid,
+			if (memcmp(dh_info->fp->create_guid, recon_v2->dcontext.CreateGuid,
 				   SMB2_CREATE_GUID_SIZE)) {
 				err = -EBADF;
 				ksmbd_put_durable_fd(dh_info->fp);
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index e9df94e4749c..d27a587b134c 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -80,17 +80,6 @@ struct create_durable_reconn_req {
 	} Data;
 } __packed;
 
-struct create_durable_reconn_v2_req {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	struct {
-		__u64 PersistentFileId;
-		__u64 VolatileFileId;
-	} Fid;
-	__u8 CreateGuid[16];
-	__le32 Flags;
-} __packed;
-
 struct create_alloc_size_req {
 	struct create_context_hdr ccontext;
 	__u8   Name[8];
-- 
2.43.0

