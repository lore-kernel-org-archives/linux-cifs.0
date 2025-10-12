Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C5C25783C;
	Sun, 12 Oct 2025 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760281924; cv=none; b=lt9880Dsmd2hGZxdwA8WAnQ1M+TvXBYOk+RFVEx7tTAjkb3kZ5IhY8Xsj1aV2VBu/r9z42WJsd3chVDYo7KlezxTtvPTMChIZuvtPIgL+Fq3npuzwHgF27dzqXOrp+zOVDsPMMa+A9ljTRTdSuSIvG8a5CYuXobO7csc4KHZeBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760281924; c=relaxed/simple;
	bh=oteY2DB6t8StVBkclNm0ZCXNfCcJGBmqqtuWOd8wqCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InImAbq95htKS0hWfVqjZTkVptODCMCy6whOxPFUAiLo5yn5S5lqOamhY/v6qzn44AFRvxHp2C2QJWESPFvX1SD3gtqkiKtGEA8Y7MhbxjufD99EaFJ6cI3x8BNAqnGbn+4AS1ONMPyJB/jQ4dBW0hwcL2P+vxWDGOERJ5ieGw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281825t635632e9
X-QQ-Originating-IP: 6HLTX+dRc9CYL1tk1F4OdQ5zclB6J+QcMRbQrl4qaqw=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:23 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 11190244469557168826
From: chenxiaosong@chenxiaosong.com
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 09/22] smb: move copychunk definitions to common/smb2pdu.h
Date: Sun, 12 Oct 2025 23:09:02 +0800
Message-ID: <41D148FBA128451D+20251012150915.2992220-10-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
References: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: NLq8blVtEno84RSzHtBJub+JPGsk1j1x6rDhlsZTz38MKhqWJsER+Vvs
	CLDnwpWX9+NLUus1H4CyH/yznSjHnUafuyYtDKtN2L2eJjp6/Spc5O7rQQS8KtVFnMTqWY/
	+hspwUFkhSav23qhVQH2e08vnyv6Hei/iAU+oiSg+ah+sRFMPrbrhBpWZYwuWLcnSM0opZb
	7ImPPEWiFSIRtXsyXJhkWB/cGmyzhrg9G2+lGWI5DKwyvmk4Iuz9Q9Xx10nAw1B4fBmFEI2
	9khiUSoj3HFTXhdzXcwBdgtxIm8Anr+E8+OeqeYVN3k/Mfor56hwHCqpD2OKQ4Z1kEN69ZC
	U6rT57Y/wAanqt+ZcxBx7pXjG/07D6ioxMuMdSc3j2jdy3OCp3tv+GyHcJpPog3FrGJ/xhk
	5wCftkL/vkusjQyXXULrp4l8qMH4BPusCnQuyhsdIkmhN8lq0ItGfaUYdVIxumudh3oSrAL
	Jwhl974koz2GOVnU6zGdViddW3XlHNrBqdnaZmCpShXhOEGyIt8LxMxtbktnXSIkvadXOb5
	q/GjwP8jJRz+st0V60If/KmQttpazBKGPkvj/6DGYSfDIgH4RKM7sAB/YpNap6fhWjwinMp
	i9qhBor5ASTA3mlDg3yQsBWUQ5SCXrTW+aXUn+9z1y05O9c+olSJr0L9NM7bFAXNR1KEhnS
	nDqrskylEzFyHNYRiWS8Z+plNKjdfpnkjgBuhzvSC3nMnoDQrY8TWwZiUgt0XwRMJQ9Ew3h
	evdSpI1iNc3rahq4qXr4nJFKbknViJEv3QzvlmzXYi/78B3/b9Hz6PLAa/MZUhj4Z5RCWVJ
	ZwM7Ny46B47ianFz8Pcqa0pXQ9GrZvwuSmxBJaWQIr4EKBFA+8yMcKLYdZcq+E5A+m9Wz56
	S55dIORLd14ZbnlqkNOWsBr5pIJc0bua93F52ihicloEQoxnxPuV1HZon5VqlNCvjAlbmfM
	/rhGjUZRVzC5Y+0LffooESgAbFSdiK3OYGbL2OvwTlfuMfjyAHgqI7NM+vdGz8YeEtRH778
	D+IOth+9WWBgrvhWbsNxPLjLOmBic=
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Rename 3 places:

  - copychunk_ioctl -> copychunk_ioctl_req
  - copychunk -> srv_copychunk
  - server: ResumeKey -> SourceKeyU64

Merge the struct members of the server and the client, then move duplicate
definitions to common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/cifspdu.h |  8 --------
 fs/smb/client/smb2ops.c |  6 +++---
 fs/smb/client/smb2pdu.h | 24 ------------------------
 fs/smb/common/smb2pdu.h | 29 +++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.c |  4 ++--
 fs/smb/server/smb2pdu.h | 20 --------------------
 6 files changed, 34 insertions(+), 57 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index d9cf7db0ac35..c86a329e5822 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1323,14 +1323,6 @@ typedef struct smb_com_ntransact_rsp {
 	/* parms and data follow */
 } __attribute__((packed)) NTRANSACT_RSP;
 
-/* See MS-SMB 2.2.7.2.1.1 */
-struct srv_copychunk {
-	__le64 SourceOffset;
-	__le64 DestinationOffset;
-	__le32 CopyLength;
-	__u32  Reserved;
-} __packed;
-
 typedef struct smb_com_transaction_ioctl_req {
 	struct smb_hdr hdr;	/* wct = 23 */
 	__u8 MaxSetupCount;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e90ca77d2ac7..ea9709d81851 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1524,7 +1524,7 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 static int
 SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid,
-		     struct copychunk_ioctl *pcchunk)
+		     struct copychunk_ioctl_req *pcchunk)
 {
 	int rc;
 	unsigned int ret_data_len;
@@ -1857,10 +1857,10 @@ smb2_copychunk_range(const unsigned int xid,
 {
 	int rc = 0;
 	unsigned int ret_data_len = 0;
-	struct copychunk_ioctl *cc_req = NULL;
+	struct copychunk_ioctl_req *cc_req = NULL;
 	struct copychunk_ioctl_rsp *cc_rsp = NULL;
 	struct cifs_tcon *tcon;
-	struct copychunk *chunk;
+	struct srv_copychunk *chunk;
 	u32 chunks, chunk_count, chunk_bytes;
 	u32 copy_bytes, copy_bytes_left;
 	u32 chunks_written, bytes_written;
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 0be63c00f848..9b5880e60a4e 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -191,36 +191,12 @@ struct crt_sd_ctxt {
 	struct smb3_sd sd;
 } __packed;
 
-
-#define COPY_CHUNK_RES_KEY_SIZE	24
 struct resume_key_req {
 	char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
 	__le32	ContextLength;	/* MBZ */
 	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
 } __packed;
 
-
-struct copychunk {
-	__le64 SourceOffset;
-	__le64 TargetOffset;
-	__le32 Length;
-	__le32 Reserved;
-} __packed;
-
-/* this goes in the ioctl buffer when doing a copychunk request */
-struct copychunk_ioctl {
-	char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
-	__le32 ChunkCount;
-	__le32 Reserved;
-	struct copychunk Chunks[];
-} __packed;
-
-struct copychunk_ioctl_rsp {
-	__le32 ChunksWritten;
-	__le32 ChunkBytesWritten;
-	__le32 TotalBytesWritten;
-} __packed;
-
 /* See MS-FSCC 2.3.29 and 2.3.30 */
 struct get_retrieval_pointer_count_req {
 	__le64 StartingVcn; /* virtual cluster number (signed) */
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index b01114108d23..857e6a577e84 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1392,6 +1392,35 @@ struct smb2_ioctl_req {
 	__u8   Buffer[];
 } __packed;
 
+/* See MS-SMB2 2.2.31.1.1 */
+struct srv_copychunk {
+	__le64 SourceOffset;
+	__le64 TargetOffset;
+	__le32 Length;
+	__le32 Reserved;
+} __packed;
+
+#define COPY_CHUNK_RES_KEY_SIZE	24
+
+/* See MS-SMB2 2.2.31.1 */
+/* this goes in the ioctl buffer when doing a copychunk request */
+struct copychunk_ioctl_req {
+	union {
+		char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
+		__le64 SourceKeyU64[3];
+	};
+	__le32 ChunkCount;
+	__le32 Reserved;
+	struct srv_copychunk Chunks[] __counted_by_le(ChunkCount);
+} __packed;
+
+/* See MS-SMB2 2.2.32.1 */
+struct copychunk_ioctl_rsp {
+	__le32 ChunksWritten;
+	__le32 ChunkBytesWritten;
+	__le32 TotalBytesWritten;
+} __packed;
+
 struct smb2_ioctl_rsp {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 49 */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index dd6f1375a833..846cca45195b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7757,11 +7757,11 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 	}
 
 	src_fp = ksmbd_lookup_foreign_fd(work,
-					 le64_to_cpu(ci_req->ResumeKey[0]));
+					 le64_to_cpu(ci_req->SourceKeyU64[0]));
 	dst_fp = ksmbd_lookup_fd_slow(work, volatile_id, persistent_id);
 	ret = -EINVAL;
 	if (!src_fp ||
-	    src_fp->persistent_id != le64_to_cpu(ci_req->ResumeKey[1])) {
+	    src_fp->persistent_id != le64_to_cpu(ci_req->SourceKeyU64[1])) {
 		rsp->hdr.Status = STATUS_OBJECT_NAME_NOT_FOUND;
 		goto out;
 	}
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 5a76b706ccd9..eecd1f1f5505 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -157,26 +157,6 @@ struct resume_key_ioctl_rsp {
 	__u8 Context[4]; /* ignored, Windows sets to 4 bytes of zero */
 } __packed;
 
-struct srv_copychunk {
-	__le64 SourceOffset;
-	__le64 TargetOffset;
-	__le32 Length;
-	__le32 Reserved;
-} __packed;
-
-struct copychunk_ioctl_req {
-	__le64 ResumeKey[3];
-	__le32 ChunkCount;
-	__le32 Reserved;
-	struct srv_copychunk Chunks[] __counted_by_le(ChunkCount);
-} __packed;
-
-struct copychunk_ioctl_rsp {
-	__le32 ChunksWritten;
-	__le32 ChunkBytesWritten;
-	__le32 TotalBytesWritten;
-} __packed;
-
 struct file_sparse {
 	__u8	SetSparse;
 } __packed;
-- 
2.43.0

