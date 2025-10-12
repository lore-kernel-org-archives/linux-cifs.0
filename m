Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D5D2D46B3;
	Sun, 12 Oct 2025 15:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282028; cv=none; b=oo6zjBaFXMqlbS/WSemWa7bc8cEOjkuMYCCWLich9tD0jfwelHBnGmHeg7tkrCvBCOGVm7MNJCwOOfQtI4Y2AgauMZO4RCEAQ8THXahqwetvtn+rB5yfcjbUSdyYU5i/EKU2fF2HDG+DX2CsgtsoZkky8UusTb86W2Z3+W67z9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282028; c=relaxed/simple;
	bh=fUKthNy2wlDGAqzuUnZdkSIU7ZaaNp3xh67aJrzdFvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGT3gkB27Av/ovVBLFvzU9tGr98BLUSNc41MryNc9BNpf0e3VLknlYXVdCGZmXyFN0iWAIVsXBZIEuQsv1NQJ8MJ8/wW2UP1tc/17iWKzOt+CVVBQv8eMVadFFg9a9SJy7PvwK29kslofHK5qNhwlbTB+6fOxm2lGFxqZu5VWmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281827t6bb9a53a
X-QQ-Originating-IP: 69Rv+sTMWHOnpookkkXjw6/9KEmmv7n9ULxFPBXoDhA=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:26 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 15071498245468663790
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
Subject: [PATCH 10/22] smb: move resume_key_ioctl_rsp to common/smb2pdu.h
Date: Sun, 12 Oct 2025 23:09:03 +0800
Message-ID: <6CF041E3D67815E2+20251012150915.2992220-11-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: Ncu1oMVBQDrn+BLfC1OIjRvZmanA9FgBKv8OZ6e67thgjg5Wed3b3VBE
	BcGTxDcDN5R7vV5jDsYbPd+dQb23t9yVYGROqBNHVu600a0CZoREtzrsnOfcTf4Elleb4P9
	2QgNCMZaHghqyDYfVq3j/UGOXhuqJPxFDfqIKkS/7F2z9cxmfAALPyC9MGmdw/za+Hj2XEe
	sH8rXhR60lOYTd/CVhytrVYpUBut2mllwbjvK9tsPiE3jhqIMRpUwbXqPiJLl8YoedMDlw0
	Je+fNHjZKNAU9u3oxZKPHUQ6SyJc36w4RQHjumLYU8M9BCxq7pjmhVEFion9X6ZUKWh8xn2
	9bbWCQhvqPZ/I7rWxLTfY7wwtpr5S6WklzP+vC18FwNarVhkiyn/XaxoeycE2C+iGmRZnW2
	DiXkG9/kJ9HbekZbDFfG/wIIz01e4wVJkIOIkIxKEpxr3aOKD33PI132IlJ9/S64Mkr0Fpw
	a5BC2u6WsuMZEIBBPKPis0vhDZR+R/cCm9SHeK7OKkRUeVBgjKJDuiHcYaDOXiKcek1P++D
	gM+o0y0wDMO+2N4bqylww+9uwRchfUdJgqzuUWfu9L9QgwlS+etClhKu8Wm6gTMWV+gxi4j
	32Gh6s+ovcQ8Xusd9EwZnlwh5KZLzJhHBwACsdT8bIy4iVBCFud2Qce4Tml6txh7bQScsmf
	xWlM1dvRb7wzp3/ppemllki7bZmsZKAzKzhGFtneqmTQt7t3dqWQgbRDTAUxrEJFGRfprmU
	Ixg08uwK9BdgQ7E86HmZEv2OhiH2aaztshGGE8garhukW6ee7TFelq0p2Q0ycVmuJPJl2af
	kLx7IVR813+liLZ5S/T0JQ0v+ZMWD9u43yKV2uRoqjOIgkJKfHrYWVsPha+zDCWz0XkXGNJ
	l3i6xK83At1/zSBRROgS4cBBgaVQehkYfJ/Qc64M/Co0zsSnSGMgBRrLo9w9OHq3CLicDJm
	OQEv4GHAdKJbsS1bX/qJu0ByjtkrNzYzNXnFZMwWXBfbpNBLEfk65GJQpzYfuFDTgQLreTJ
	NWGvJa26s2m6efuX4ovWREwhSNl9s=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

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
index ea9709d81851..8da5fe4efa2d 100644
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
index 9b5880e60a4e..77dceca20240 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -191,12 +191,6 @@ struct crt_sd_ctxt {
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
index 857e6a577e84..15932ee05c98 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1421,6 +1421,16 @@ struct copychunk_ioctl_rsp {
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
index 846cca45195b..200bce13b467 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8115,8 +8115,8 @@ static int fsctl_request_resume_key(struct ksmbd_work *work,
 		return -ENOENT;
 
 	memset(key_rsp, 0, sizeof(*key_rsp));
-	key_rsp->ResumeKey[0] = req->VolatileFileId;
-	key_rsp->ResumeKey[1] = req->PersistentFileId;
+	key_rsp->ResumeKeyU64[0] = req->VolatileFileId;
+	key_rsp->ResumeKeyU64[1] = req->PersistentFileId;
 	ksmbd_fd_put(work, fp);
 
 	return 0;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index eecd1f1f5505..3d000c5d964b 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -151,12 +151,6 @@ struct file_object_buf_type1_ioctl_rsp {
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

