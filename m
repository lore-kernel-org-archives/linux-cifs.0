Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F722E0936
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549845; cv=none; b=q6L7k41x21Tv3lsH3Ut9J/ZSDGfA7QEuTNor8uR1JFTGdUrmJjcJn1wkbZN/XX5eZ4ujFi3/mgKg7a5NrPxAPNC7mOMsQOwPwrRDcmGMk7HBeIlOtl/p6cHVKoWVE+iAJZlxy+W9lMfPa5T+ChFTaTn+hqCykLi5DJ604w1TLSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549845; c=relaxed/simple;
	bh=PotWsMbGcM+zrmUMslr6oQNvXGw88qJ+9KO2MxJnyio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhf68I+A7of3vB/mquewLVJ+lR7W52RKlpC76TGqHbfqWICoedjr3Wtnxt1y8h900hk85YDM/Uc+oMBUj2E+WcZtdin1MoZg91YWVDct6x+hqvSx2JFcNUWc/3BTfpeEIrQRufba4qKDNJhlUuFmfcNZBRtbO2ENAL6nUENPnvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bj1MyUtz; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bj1MyUtz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=35vWquObWcS+BwNDIhUb8QoFDfJfPtKNdRQDD08D+Bs=;
	b=Bj1MyUtzMSL9StmQNRLB60vstkpZMveAy44yxCaINymiyy/d84YJMzqxG2lXq/VSk8mWmO
	CsHiynAmvxL476McYLSVqky60gTJB03eTr7opf57kk7++3+xmxUQpszLe/5S6iA/30uT38
	d1x8I8dkguFAlCzPBhkT/jKM+0E2viQ=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 23/24] smb: move resume_key_ioctl_rsp to common/smb2pdu.h
Date: Mon, 27 Oct 2025 15:22:05 +0800
Message-ID: <20251027072206.3468578-9-chenxiaosong.chenxiaosong@linux.dev>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Rename 2 places:

  - resume_key_req -> resume_key_ioctl_rsp
  - server: ResumeKey -> ResumeKeyU64

Merge the struct members of the server and the client, then move duplicate
definitions to common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/smb2ops.c |  4 ++--
 fs/smb/client/smb2pdu.h |  6 ------
 fs/smb/common/smb2pdu.h | 10 ++++++++++
 fs/smb/server/smb2pdu.c |  4 ++--
 fs/smb/server/smb2pdu.h |  6 ------
 5 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a2319eef2801..80191bf3fdff 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1528,7 +1528,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	int rc;
 	unsigned int ret_data_len;
-	struct resume_key_req *res_key;
+	struct resume_key_ioctl_rsp *res_key;
 
 	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
 			FSCTL_SRV_REQUEST_RESUME_KEY, NULL, 0 /* no input */,
@@ -1541,7 +1541,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_tcon_dbg(VFS, "refcpy ioctl error %d getting resume key\n", rc);
 		goto req_res_key_exit;
 	}
-	if (ret_data_len < sizeof(struct resume_key_req)) {
+	if (ret_data_len < sizeof(struct resume_key_ioctl_rsp)) {
 		cifs_tcon_dbg(VFS, "Invalid refcopy resume key length\n");
 		rc = -EINVAL;
 		goto req_res_key_exit;
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index f8aa4bcc5eac..0fcc903fbcd1 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -158,12 +158,6 @@ struct crt_sd_ctxt {
 	struct smb3_sd sd;
 } __packed;
 
-struct resume_key_req {
-	char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
-	__le32	ContextLength;	/* MBZ */
-	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
-} __packed;
-
 /* See MS-FSCC 2.3.29 and 2.3.30 */
 struct get_retrieval_pointer_count_req {
 	__le64 StartingVcn; /* virtual cluster number (signed) */
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 319890c6d46b..c7e64712f856 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1453,6 +1453,16 @@ struct copychunk_ioctl_rsp {
 	__le32 TotalBytesWritten;
 } __packed;
 
+/* See MS-SMB2 2.2.32.3 */
+struct resume_key_ioctl_rsp {
+	union {
+		char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
+		__u64 ResumeKeyU64[3];
+	};
+	__le32	ContextLength;	/* MBZ */
+	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
+} __packed;
+
 struct smb2_ioctl_rsp {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 49 */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 44e2cef70f27..96e50dd7d64f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8122,8 +8122,8 @@ static int fsctl_request_resume_key(struct ksmbd_work *work,
 		return -ENOENT;
 
 	memset(key_rsp, 0, sizeof(*key_rsp));
-	key_rsp->ResumeKey[0] = req->VolatileFileId;
-	key_rsp->ResumeKey[1] = req->PersistentFileId;
+	key_rsp->ResumeKeyU64[0] = req->VolatileFileId;
+	key_rsp->ResumeKeyU64[1] = req->PersistentFileId;
 	ksmbd_fd_put(work, fp);
 
 	return 0;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index ab4359f384b3..a6940e971047 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -130,12 +130,6 @@ struct file_object_buf_type1_ioctl_rsp {
 	__u8 DomainId[16];
 } __packed;
 
-struct resume_key_ioctl_rsp {
-	__u64 ResumeKey[3];
-	__le32 ContextLength;
-	__u8 Context[4]; /* ignored, Windows sets to 4 bytes of zero */
-} __packed;
-
 struct file_sparse {
 	__u8	SetSparse;
 } __packed;
-- 
2.43.0

