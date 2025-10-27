Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC342DEA71
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549831; cv=none; b=RZ/GY5iNJACi5WxEuiwYTbJ6Aof+cPbg6ZmzPu1vHnzCN/Don0Tdke5LweiFnKIbn//JAygcCHZH4g6EK8ydYULYNUKTbmcp44XVMHcqunR17ao8yXrt/iNvJ4mmwTln3PNDJ+KkXUHQBuGAmWrYH6s9pVZPbJ0o9uiqJeYm12Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549831; c=relaxed/simple;
	bh=XJNbF+vSu4+776URpUXpCLOJvtjIgvZEfnNX0/odM/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYFRBrGpvT+L5Ow1/xaJqYdiSR2Z0Ejqwvy1CSsSrNBnyd86nmmBOxHx4cdchUy1SW7SRSQJI12SQWZrA2lrL7kven5NOGK3lPxQOA4HYzdoEtIpQHiKmMEri96IvM8p6vDvVqERUdZQENV8AFNn1xGv+9fnc79npLTCw6qSiNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UplzdlEL; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UplzdlEL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gpxw7zZ//kFrOgRd8a2SnlcDsF6vADOPwFJ/FGSGt0Q=;
	b=UplzdlEL+/Dfza+kRvZVBYhYe1IW2v+alkiY+YPFtn9QQutCWsS7oQHllS1Q3beqEnSWcl
	LCy5/bz0xwLX2KxNOAFa6olUGSxIzSLBUD1+kS2Jn4A1MfCZBGO2kZwWNy4kbjgvLzeW1q
	FLVlXnH1rgFGwgkwY7Gb2564tBG+nvY=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 18/24] smb: move create_durable_rsp_v2 to common/smb2pdu.h
Date: Mon, 27 Oct 2025 15:22:00 +0800
Message-ID: <20251027072206.3468578-4-chenxiaosong.chenxiaosong@linux.dev>
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

Replace some fields in "struct create_durable_v2_rsp" with "struct
durable_context_v2_rsp", rename 2 places:

  - durable_reconnect_context_v2_rsp -> durable_context_v2_rsp
  - create_durable_v2_rsp -> create_durable_rsp_v2

Then move them to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.h |  6 ------
 fs/smb/common/smb2pdu.h | 12 ++++++++++++
 fs/smb/server/oplock.c  |  8 ++++----
 fs/smb/server/smb2ops.c |  6 +++---
 fs/smb/server/smb2pdu.h |  6 ------
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 23cf5ac713ee..a0d2bb18d4cc 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -138,12 +138,6 @@ struct share_redirect_error_context_rsp {
 /* Flags */
 #define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
 
-/* See MS-SMB2 2.2.14.2.12 */
-struct durable_reconnect_context_v2_rsp {
-	__le32 Timeout;
-	__le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
-} __packed;
-
 /* See MS-SMB2 2.2.13.2.5 */
 struct crt_twarp_ctxt {
 	struct create_context_hdr ccontext;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 0fd1c8ad51c3..c09045a33d34 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1314,6 +1314,18 @@ struct create_durable_handle_reconnect_v2 {
 	struct durable_reconnect_context_v2 dcontext;
 } __packed;
 
+/* See MS-SMB2 2.2.14.2.12 */
+struct durable_context_v2_rsp {
+	__le32 Timeout;
+	__le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
+} __packed;
+
+struct create_durable_rsp_v2 {
+	struct create_context_hdr ccontext;
+	__u8   Name[8];
+	struct durable_context_v2_rsp dcontext;
+} __packed;
+
 /* See MS-SMB2 2.2.14.2.5 */
 struct create_mxac_rsp {
 	struct create_context_hdr ccontext;
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index a04d5702820d..1f07ebf431d7 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1617,9 +1617,9 @@ void create_durable_rsp_buf(char *cc)
  */
 void create_durable_v2_rsp_buf(char *cc, struct ksmbd_file *fp)
 {
-	struct create_durable_v2_rsp *buf;
+	struct create_durable_rsp_v2 *buf;
 
-	buf = (struct create_durable_v2_rsp *)cc;
+	buf = (struct create_durable_rsp_v2 *)cc;
 	memset(buf, 0, sizeof(struct create_durable_rsp));
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
 			(struct create_durable_rsp, Data));
@@ -1633,9 +1633,9 @@ void create_durable_v2_rsp_buf(char *cc, struct ksmbd_file *fp)
 	buf->Name[2] = '2';
 	buf->Name[3] = 'Q';
 
-	buf->Timeout = cpu_to_le32(fp->durable_timeout);
+	buf->dcontext.Timeout = cpu_to_le32(fp->durable_timeout);
 	if (fp->is_persistent)
-		buf->Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
+		buf->dcontext.Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
 }
 
 /**
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index bcf05caa2304..edd7eca0714a 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -59,7 +59,7 @@ static struct smb_version_values smb30_server_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.create_lease_size = sizeof(struct create_lease_v2),
 	.create_durable_size = sizeof(struct create_durable_rsp),
-	.create_durable_v2_size = sizeof(struct create_durable_v2_rsp),
+	.create_durable_v2_size = sizeof(struct create_durable_rsp_v2),
 	.create_mxac_size = sizeof(struct create_mxac_rsp),
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
@@ -86,7 +86,7 @@ static struct smb_version_values smb302_server_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.create_lease_size = sizeof(struct create_lease_v2),
 	.create_durable_size = sizeof(struct create_durable_rsp),
-	.create_durable_v2_size = sizeof(struct create_durable_v2_rsp),
+	.create_durable_v2_size = sizeof(struct create_durable_rsp_v2),
 	.create_mxac_size = sizeof(struct create_mxac_rsp),
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
@@ -113,7 +113,7 @@ static struct smb_version_values smb311_server_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.create_lease_size = sizeof(struct create_lease_v2),
 	.create_durable_size = sizeof(struct create_durable_rsp),
-	.create_durable_v2_size = sizeof(struct create_durable_v2_rsp),
+	.create_durable_v2_size = sizeof(struct create_durable_rsp_v2),
 	.create_mxac_size = sizeof(struct create_mxac_rsp),
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index d27a587b134c..099e9f20812b 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -98,12 +98,6 @@ struct create_durable_rsp {
 /* See MS-SMB2 2.2.13.2.11 */
 /* Flags */
 #define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
-struct create_durable_v2_rsp {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	__le32 Timeout;
-	__le32 Flags;
-} __packed;
 
 /* equivalent of the contents of SMB3.1.1 POSIX open context response */
 struct create_posix_rsp {
-- 
2.43.0

