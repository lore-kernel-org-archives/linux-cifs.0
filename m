Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3693D2ECD0E;
	Sun, 12 Oct 2025 16:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760285981; cv=none; b=B4e9IvJ6sCYAug4ZwrIc3+JijP08Y08vE+hV++kxjXim3btMW6V2Aq+pXCKl2t7p5hvXoXRjgiRQ7AkEdcW1vxbcSTfMOecfTdmGTrgD0EFXp9e3C6DzAckOI7nSid/+rdKrwK/eIXt1WQMuHR6W8LoAbDRhcvps3O0+mcTcG64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760285981; c=relaxed/simple;
	bh=fUKthNy2wlDGAqzuUnZdkSIU7ZaaNp3xh67aJrzdFvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1wqH1Bhoiy0yEBZJ5u/C98qW06dAcCWo+mxapLmQ/oxaQSUhedeTZgc3gwv18UY4aS3fZ0/a3v+CWjJLiHK3pROdVlmZwbxfkF2okOly2QCQicXseF/GiVwKkzTBx/QX2I36nLslU/zXPp+wp3mTTmML9wkJO0DpLU2drK8Cz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285914tcf34a59a
X-QQ-Originating-IP: l0yQ2ReVHcttSPfMvuQZ2yj/Rst6xFSQUQri3hQdZoE=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:33 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 10029691931099453564
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
Subject: [PATCH v2 10/22] smb: move resume_key_ioctl_rsp to common/smb2pdu.h
Date: Mon, 13 Oct 2025 00:17:37 +0800
Message-ID: <FB53FEFFC8FE4E8B+20251012161749.2994033-11-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: NeDT84CGYoj4zNNVikBJOH3IDU382x7sEx5bvoIiDskJMzMScTzKWJ1+
	1asDSR84NUxPqQB2EqJnn9g13HReYbufR5pZtHpcF8eZ0mPUf94t4eJFJxxiKdSGjvKOkB0
	MmGK2X2u5QASEoEoWmytDjxuYtI+Y10O6gN7JcC1++CinDcqfuhpfixFFN4oaIY7AKVd0h/
	lwYvhvMjfaAr+6fvhVYoIf1tsQkIdOb+73yw1QkQUbhcmpKU/BzxjXY0QhSNaE8K57NRDg/
	SHn14xd4NRSXIMKMNLQxM7YzT+lSyEvIB6gvNwAlhDv/em8h+y9pp1W09gzovJr5lKqmRme
	o2phxGbov98lHZAWDt6gcaqlB2tE0/lwLhzzKQ8PQIU9N/8GpMw+SVPsH0lw/GQu5eEk7h/
	Ps5Ev8rEK/B/SMRb4XSDF3XIjMiI6B6pabBu7YibBV9VyTHPxDTzvbGg3b3dVuq7ENIVXM9
	kAqCYHMkCKtWCLY0FLpvkAr73Y+wAx4LKBWx4YeV8bcO0AgLT7AsiFJ8cYrG9q2z6jdV6vt
	K9sOaga5R0N05DYxZFbSc9Wq5vzzhSBIQ5XETkQs/0q1Em7H4TfPdYrYp13DqoqgyiC3kpH
	encdwrFAqMsfX5eZ+QvaKk+L2Zr1Bu22x/zRIT6ao0JgfW+rnkGvjF6wy9GY/m/oXWZIc5l
	2c+Pw9dwfth6MAOtLQXiolP4NJd/Vkk70KbFuABgTse4exImpoScX4zqiC6HMjlA+iZ+Vvr
	8biXeVtqMhtI1jA6/AaWNI5odj9EkG7dBWNLk1Y18AlxYstoknomE29UpZNOpy07p7mLM1w
	bzxcpMrZNUwE8n0pQMR9yM8W9YANZsVmHBH5Z8oYbusKPbhTEpaSfkXr2sB1rmGSgerFASV
	7XY7HO6J6D/wH3/WYe5ZTJRME8w27XeVk/ZK0kLKeA965GPlndvvx2MYPgVruPnSfUcfjHk
	vGPd6zo/VzP2Q3iEN0/8Q6UpnVbs12TOllsVCT+KcKrCzw0pJyR9GDDP6NodVZ5PxVNLyiE
	kJAmL8HgdfylY9nw2HfcVJ2Hh1Kui2inBayO23/+PUY72hHur861MjZtsB7CTK1oRRSfAL6
	1cUq0dRdxOrULdRvQmz7t4WaC4m+2QCcQ==
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

