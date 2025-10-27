Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CCD2DCBE0
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549825; cv=none; b=qY9C72o6LDPxU28hGVkHzJIAxGkQQl0gPTI+4RkuCMBjniCMG8mSXpMR5DmcRX2u4qeSBYX3jsrCYkAdKLRXRJGbSQQNNzFtW7n1zxuKMlC7rN2AKa0IGRBQnL2+ihHhlaAL3DbOvU4W0E3ui9fqad0BxY4o8+0MBmaAK3COEFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549825; c=relaxed/simple;
	bh=Zf6J3Hs4f2PorXqJZOx/hFVWj6S8Oc8vZdNa5KsWoCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSR6rJnEREnVPYdxnT3t/Qy+tziQT3ACAslKRfLhQP91wtlVZN1jkaB/5JLqSvUWMDx723owQO4L4vglGVFfeis5wlsXRDAaZkciOXpo020NndI545PeP8uYF1lBFPwk5wrAfwzwG3cr2DXBEQwz8TyiD8YHhL4DVbMXpY5vErA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lc8F/9Oo; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lc8F/9Oo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XY3enVx+NvA5c1N34me4+c6U2C2vkgiExeqfsy34gg4=;
	b=Lc8F/9Ooob/pZbJrTuEuibSyurS41EDeihqkYR0pdMPs4fj/TmNJvXzzxBgw0tcDXvBj7c
	opG7oq/Fl0I1vUfwAalgTX6iRq6YKVphGKFfxp+866J1IUBjqQDtsoKIQ0OWo+FPoSjP4o
	BcOxpvpCgkjKA1HSirMfTcefqlVf/5Q=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 16/24] smb: move create_durable_req_v2 to common/smb2pdu.h
Date: Mon, 27 Oct 2025 15:21:58 +0800
Message-ID: <20251027072206.3468578-2-chenxiaosong.chenxiaosong@linux.dev>
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

Replace some fields in "struct create_durable_req_v2" with "struct
durable_context_v2", rename 2 places:

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
index 101024f8f725..94d184733f33 100644
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
index f2fbd651ab8f..6a5c8eef357d 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1284,6 +1284,20 @@ struct create_mxac_req {
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
index dc0f0ed4ccb6..92bd086ca715 100644
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
index 5163d5241b90..e9df94e4749c 100644
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

