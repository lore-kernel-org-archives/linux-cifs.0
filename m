Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB37A2D739B;
	Sun, 12 Oct 2025 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282055; cv=none; b=sIaRCbcfKsf3Y9q5TDOHfxfgp6hLc9+952Nn67qbYMg5Dcc8Tf/pr3ROmHOi7q54htleCskuc//luxMbvnZL+zdlM9MHGn/XDiZRgun9tileddrTdp2LZxkqD9KhuB+JZnTxFVuR252Af9L+EJ8Uy6mkJysbMZhV5qUf6+1Wmr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282055; c=relaxed/simple;
	bh=9fhG8rUC2Y67xiXJfY2hEFKpnkRKB2gNIMJ6ia+D7cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvjkcVMg2o54KQwi9ksxNS39MzgSvAvf+bCAag5kj8/86x7bJJO4cL93nc8rUAabned7O6ebt+p2GqOCor46ZGx6J2xo1VWyblTN0Rjxu0vD04k2gvakIETfgSjztFGvqTHXKbX55tiLdsvZJKVDhdpupg0TVpJ2o5YfnVNr9o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281847t3bcad29a
X-QQ-Originating-IP: 7fdZq8rvWj067Vat6YuiZlCdCTNLKewesOZqESftJgs=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:46 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 15875391227853962137
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
Subject: [PATCH 19/22] smb: move FILE_FULL_DIRECTORY_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:09:12 +0800
Message-ID: <F1114E31F698FF94+20251012150915.2992220-20-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: NbxtxvLq7lKKhKLAEMpmztwJEPZtCa2lIqR5x+/Hcatadt8c4NXzPEro
	n8nD/TJ5w+f3nRy0uQchUPjANI8IS7PIDYE6FU55ne2hjnNyUsI54NG0kHslOeJF9lqR/23
	uRs/cEYT5oWx2/jdmRiXipU8Kk7R9LXT7HM0owa+a591v2RSOkJlxyrp49dUMAQGFdUvqLx
	38JmxvcMdvL4cZm+ikxBgSogI/En+BqrTFbo8fEfPBBQ6ksDgRPykuAI7JHQ0zdyqcx7t3n
	yPZaYP6Av5588pq0lrJZgnBy479Nn8zlNgnpldmlPuIJ9foxzKQ9YFI53CUkqOcCFgsochv
	+aom7XW0AYmKdqfKzASvI8tgbk1k42bN122i1webwlvzh/e2LbKt8RjBfYovwm0RKZreFEA
	JWG3Efe3JRgjk9vmRwHcavNpZiZUelJouJmWSMT+E4F6bgXwARupU0YhDH9XMxIDA9lOCvh
	68FWQCBKL3eFkuip4TP+JU8Q5F2OV5ZU4P9VW56Cr4wxwuDUtC4+mFsvq+ARATyvesxAHjf
	+e8wna6PNX1h7rWZgr3i6nVtm213W4np20422jyIigQxVBxc+wAUGZzGH4kPEi2IUltNeUW
	HbJUcjIvOicuty/6VnHqMUXVu3AI1EhLy8luGzokAlymKa1w1rZq5IewvyzwFtcu5nfShzM
	HKJS6FS0bHKZ8d7ZmIBQoTY1p1ifRD8qy1Fajngd8GJ7TXn30V8Bf+4BhH8/b/Dq7nOyTEa
	Q7U13NAVjWiZPXWypjjZgwmN9dTcOzRYXYO/JV5AmqIQaBzqqMmPZ4WEnr0gxuufnBUJt27
	9aOtxP81/poe6mGxq1iRJuzciTs/i4h9XnwVNv/8Adm5tNm0c6LTNB/hvZsJj6nt6MjyTlt
	ZXR5KLQfrFa5p6krjFb95s/CoPjSRfmGsMaOKtXFiEVmzCSpKO22qE9n2rRpxbZ/grZEGv+
	26s4Xs7M/wq6v8rm7s61OPQig3PU11hHags57aQuM0IVP7JeDcSQ47+dhMvNVjlbBk/V/aW
	4MAJpSyojFirQFc4rZouGjeFCG0Y2l4jx+/xUKtzpCJ5zb+dtsF3GNsqwTHHI=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct file_full_directory_info" to "FILE_FULL_DIRECTORY_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 15 ---------------
 fs/smb/common/cifspdu.h    | 16 ++++++++++++++++
 fs/smb/server/smb2pdu.c    | 14 +++++++-------
 fs/smb/server/smb_common.h | 15 ---------------
 4 files changed, 23 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 8031e24234a9..f89abcb88dee 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2150,21 +2150,6 @@ typedef struct {
 	};
 } __attribute__((packed)) FILE_UNIX_INFO; /* level 0x202 */
 
-typedef struct {
-	__le32 NextEntryOffset;
-	__u32 FileIndex;
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 EndOfFile;
-	__le64 AllocationSize;
-	__le32 ExtFileAttributes;
-	__le32 FileNameLength;
-	__le32 EaSize; /* length of the xattrs */
-	char FileName[];
-} __attribute__((packed)) FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
-
 typedef struct {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index 82d57ba275ee..d7c9f17ed220 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -385,4 +385,20 @@ typedef struct {
 	char FileName[];
 } __attribute__((packed)) FILE_DIRECTORY_INFO;   /* level 0x101 FF resp data */
 
+/* See MS-CIFS 2.2.8.1.5 */
+typedef struct {
+	__le32 NextEntryOffset;
+	__u32 FileIndex;
+	__le64 CreationTime;
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le64 EndOfFile;
+	__le64 AllocationSize;
+	__le32 ExtFileAttributes;
+	__le32 FileNameLength;
+	__le32 EaSize; /* length of the xattrs */
+	char FileName[];
+} __attribute__((packed)) FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
+
 #endif /* _COMMON_CIFSPDU_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 679318afdce3..6121060d84ae 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3796,7 +3796,7 @@ static int readdir_info_level_struct_sz(int info_level)
 {
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
-		return sizeof(struct file_full_directory_info);
+		return sizeof(FILE_FULL_DIRECTORY_INFO);
 	case FILE_BOTH_DIRECTORY_INFORMATION:
 		return sizeof(struct file_both_directory_info);
 	case FILE_DIRECTORY_INFORMATION:
@@ -3819,9 +3819,9 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_full_directory_info *ffdinfo;
+		FILE_FULL_DIRECTORY_INFO *ffdinfo;
 
-		ffdinfo = (struct file_full_directory_info *)d_info->rptr;
+		ffdinfo = (FILE_FULL_DIRECTORY_INFO *)d_info->rptr;
 		d_info->rptr += le32_to_cpu(ffdinfo->NextEntryOffset);
 		d_info->name = ffdinfo->FileName;
 		d_info->name_len = le32_to_cpu(ffdinfo->FileNameLength);
@@ -3944,9 +3944,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_full_directory_info *ffdinfo;
+		FILE_FULL_DIRECTORY_INFO *ffdinfo;
 
-		ffdinfo = (struct file_full_directory_info *)kstat;
+		ffdinfo = (FILE_FULL_DIRECTORY_INFO *)kstat;
 		ffdinfo->FileNameLength = cpu_to_le32(conv_len);
 		ffdinfo->EaSize =
 			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
@@ -4206,9 +4206,9 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_full_directory_info *ffdinfo;
+		FILE_FULL_DIRECTORY_INFO *ffdinfo;
 
-		ffdinfo = (struct file_full_directory_info *)d_info->wptr;
+		ffdinfo = (FILE_FULL_DIRECTORY_INFO *)d_info->wptr;
 		memcpy(ffdinfo->FileName, d_info->name, d_info->name_len);
 		ffdinfo->FileName[d_info->name_len] = 0x00;
 		ffdinfo->FileNameLength = cpu_to_le32(d_info->name_len);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index ea1c64f84ff1..e325c2e89aa5 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -87,21 +87,6 @@ struct file_names_info {
 	char FileName[];
 } __packed;   /* level 0xc FF resp data */
 
-struct file_full_directory_info {
-	__le32 NextEntryOffset;
-	__u32 FileIndex;
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 EndOfFile;
-	__le64 AllocationSize;
-	__le32 ExtFileAttributes;
-	__le32 FileNameLength;
-	__le32 EaSize;
-	char FileName[];
-} __packed; /* level 0x102 FF resp */
-
 struct file_both_directory_info {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
-- 
2.43.0

