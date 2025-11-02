Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD0F255240
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068752; cv=none; b=WmPHEYQ22xhwLCMRCU3z/RJOPXGZdEDSGG2gG/Vwk5tD0sBjYvFFO3f6GqRFtyNlw9qVd6ocYwWsJIcaV32MJcpWao2OMZEtgReERZtuqdaq+/ZXgC3usKCpXWE6RWSaKu20Tzj6ruTDv85XQLbQIF/2glkzqWT6HHRGYBzsjB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068752; c=relaxed/simple;
	bh=dndL03p7rRbhKx5ViGo9nW4QO3MeiGD4iWOFiG9NRq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbAWNM7C/fGLl5xSEyTjQJlZzQvzOHmrH3APIxmL9Je9Rr7+o8bYkw/j1PD0Y0JADmGQ5Xwfv7y2kXjoZIxo8mPE8ZTIoXzfJlAfq6L8XpZezfHhrh7yykcT9asCEq0xs3kZlr5sCIW0U730N8eg3OP1eAjZDGhIl8r28+AvN9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SXLAYjWi; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SXLAYjWi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ufdq4aNwPnUC0XnIBJYqN4y6PY/tZMqt0u26zaoa1S0=;
	b=SXLAYjWirfKZYgjC0sRd28OETDzhvQKoFON1GVJchOg8CiN9q0Bv5ZXzyhQd2b+XAdmUbj
	J/urY3aoiz3/dR6eteSNbLizRuhujOd4tnbaTBFprg+Vj/ccr5eVhus1lHEVyPQd67byG2
	zd3HVVk+8ppedsYc3VwL/+gSzJv38kY=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 05/14] smb: move create_durable_rsp_v2 to common/smb2pdu.h
Date: Sun,  2 Nov 2025 15:30:50 +0800
Message-ID: <20251102073059.3681026-6-chenxiaosong.chenxiaosong@linux.dev>
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

  - some fields in "struct create_durable_v2_rsp" ->
                       struct durable_context_v2_rsp
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
index 741ceabc3bba..32da7a4773e1 100644
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
index 77b1b8eb9c0e..4ea515732b38 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1320,6 +1320,18 @@ struct create_durable_handle_reconnect_v2 {
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
index d4026d313d67..46e14bd4f2da 100644
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

