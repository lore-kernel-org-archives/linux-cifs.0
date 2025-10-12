Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.65.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7AB2F28FC;
	Sun, 12 Oct 2025 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.155.65.254
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282753; cv=none; b=TLPfQXnr9EGWjGGjlIebiZb8zKecLUnpbWpmYRLQODIYhc5ywEqPBNRR4XIKfuTTFMHVEkoCfHSOM+kXc/UPnzHvFyqw/Fv1YlKzZJn+Ki2FCjSYS4UusbN1VP0SzOrHJzJ3vLCk+hd2N4WV7BFoInWXT2p2Xl9TNkf/N0w6k+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282753; c=relaxed/simple;
	bh=oBWHsb5ZrCzAgydcykXvb0C1NNG8ufvsu6D1kbmawFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DngOFUiHs9fZrJcq4d82PNhqjYvjTqi5nNGs/M0Z9iDhQkiaDXBW3Ubdu8yjRsFpuNNy7Y8DZY8OsU6gJnH02bRgsd1XJ0ZIisyutqTwajpaTj+7aL4yHgxwr9ybm9P7wYqIw2ccL7zivB1QvJc3KkFEMyozC1yVoAfge6zAeu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.155.65.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282626t5dabdfde
X-QQ-Originating-IP: JsuyVrsh0niSEvW7Taah2q2O97wztrREcvu4zWkajqM=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:45 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2485996429906228301
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
Subject: [PATCH RESEND 20/22] smb: move FILE_BOTH_DIRECTORY_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:22:45 +0800
Message-ID: <8E1187ED8B9B35B1+20251012152247.2992573-21-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
References: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: N8RLcQ8dzVhjEF3L4jGjp3/9c14bzsV71kcbBsnggkZZPdvKgIJOsOo/
	YiHRq3eyHnlAenf7hbClZUzW6n6OSDcWFtmU1c94aM+Yn35YgF4eM7nQnz4cCclcZHpA08n
	smBCmrF49K+iUUoyV3tMXVi4y8MYwN9aq6jQpw0+O7KMbPpa6u8Mfd0Z5CbA3TrNkDYXH45
	8qw/Ak/Y0O7ohKGQTwpF4AZW7oby2cgxEn1/KeQthfet20fr0qGw6ZwUcSmAWPKTHRekfoo
	L6wdMxfreE2ubQwtA426NhG6d2v29l5Ho/UuisFtmGOHI+yP8jHd/VIAunROCThE8Og5wcU
	WJ8BHOVpCcVIPNwNuH/g5QL+0FnFH5+6N+6NX07yHpdi4pEvbUcGSDbtCuO20O33AL+1Umw
	m3tN8NWBbbU0pA+mLC75pRaxSiPrf3/WOHFf/dH3GjZ4DhLgdxHNAMrWfahw7zc1rd9tu0Z
	VeNO+9eVgTZNclHEg7cJa6BBh8vhQFSViqxJhaOBSdX3ANNYDY0/jQl9r5tEVCQDffetDoz
	V7XAIgvonLZamX4ku31gq3Gnl2Jg3WXJRuS2NCAL4L0yscZXouB8Dl/HGtk40YE3SYCdrfU
	FnZ4JRATtJ9C9Bg/w0Qv5Ll9PbttM2xXFo8ep9LxCSzcvqrVXfV3b6W7lznynWWfpXswA/j
	7QBLj4jEiFaop+PSMn0GHetqTvnKlBxuiELPxoVY2FCa6n1QP6p1zAF3nHeDza4bNMzYJw0
	Bicv9JWzODO15jNsGUwHEwUREw6fBJ52S7Wv2j+eJq2evyKRMI2sQWSL339xV9bxXwmQYCp
	32lL9inqViLkLJp2oBifpD/aFlvd/Wz4EwJ5MRsRDVhcvuZl9JWg0ujAXHVttx+Xusj9IXP
	PP2MYzhzA3JDMR91RuTP1PqrfxQ1ldOeSmLXIH8Bdf6sicBUXNuEadNW/MN76i4V7Ibs+Bk
	KV71PN8cNxWMMRoN3RmASA8uwUaiel51k2MnXect4znKhhxBleuzoWgwQcpUzWMoty9whKT
	GPEYePZDD9tImTogXrn5EE0IZjbfTM6F0YPHRzfGMKNehz1YUMfEG5ULqv7d6uDbUZTJS2B
	R0+aJhXynKB0v+DyKNuYu+mzvm2O3gQULpqUHAouZJ0
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct file_both_directory_info" to "FILE_BOTH_DIRECTORY_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 18 ------------------
 fs/smb/common/cifspdu.h    | 19 +++++++++++++++++++
 fs/smb/server/smb2pdu.c    | 14 +++++++-------
 fs/smb/server/smb_common.h | 18 ------------------
 4 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index f89abcb88dee..3db5e7e6172e 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2167,24 +2167,6 @@ typedef struct {
 	char FileName[];
 } __attribute__((packed)) SEARCH_ID_FULL_DIR_INFO; /* level 0x105 FF rsp data */
 
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
-	__u8   ShortNameLength;
-	__u8   Reserved;
-	__u8   ShortName[24];
-	char FileName[];
-} __attribute__((packed)) FILE_BOTH_DIRECTORY_INFO; /* level 0x104 FFrsp data */
-
 typedef struct {
 	__u32  ResumeKey;
 	__le16 CreationDate; /* SMB Date */
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index d7c9f17ed220..cf5e3ee577d0 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -401,4 +401,23 @@ typedef struct {
 	char FileName[];
 } __attribute__((packed)) FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
 
+/* See MS-CIFS 2.2.8.1.7 */
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
+	__u8   ShortNameLength;
+	__u8   Reserved;
+	__u8   ShortName[24];
+	char FileName[];
+} __attribute__((packed)) FILE_BOTH_DIRECTORY_INFO; /* level 0x104 FFrsp data */
+
 #endif /* _COMMON_CIFSPDU_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6121060d84ae..8c5700102cc6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3798,7 +3798,7 @@ static int readdir_info_level_struct_sz(int info_level)
 	case FILE_FULL_DIRECTORY_INFORMATION:
 		return sizeof(FILE_FULL_DIRECTORY_INFO);
 	case FILE_BOTH_DIRECTORY_INFORMATION:
-		return sizeof(struct file_both_directory_info);
+		return sizeof(FILE_BOTH_DIRECTORY_INFO);
 	case FILE_DIRECTORY_INFORMATION:
 		return sizeof(FILE_DIRECTORY_INFO);
 	case FILE_NAMES_INFORMATION:
@@ -3829,9 +3829,9 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 	}
 	case FILE_BOTH_DIRECTORY_INFORMATION:
 	{
-		struct file_both_directory_info *fbdinfo;
+		FILE_BOTH_DIRECTORY_INFO *fbdinfo;
 
-		fbdinfo = (struct file_both_directory_info *)d_info->rptr;
+		fbdinfo = (FILE_BOTH_DIRECTORY_INFO *)d_info->rptr;
 		d_info->rptr += le32_to_cpu(fbdinfo->NextEntryOffset);
 		d_info->name = fbdinfo->FileName;
 		d_info->name_len = le32_to_cpu(fbdinfo->FileNameLength);
@@ -3960,9 +3960,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 	}
 	case FILE_BOTH_DIRECTORY_INFORMATION:
 	{
-		struct file_both_directory_info *fbdinfo;
+		FILE_BOTH_DIRECTORY_INFO *fbdinfo;
 
-		fbdinfo = (struct file_both_directory_info *)kstat;
+		fbdinfo = (FILE_BOTH_DIRECTORY_INFO *)kstat;
 		fbdinfo->FileNameLength = cpu_to_le32(conv_len);
 		fbdinfo->EaSize =
 			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
@@ -4217,9 +4217,9 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 	}
 	case FILE_BOTH_DIRECTORY_INFORMATION:
 	{
-		struct file_both_directory_info *fbdinfo;
+		FILE_BOTH_DIRECTORY_INFO *fbdinfo;
 
-		fbdinfo = (struct file_both_directory_info *)d_info->wptr;
+		fbdinfo = (FILE_BOTH_DIRECTORY_INFO *)d_info->wptr;
 		memcpy(fbdinfo->FileName, d_info->name, d_info->name_len);
 		fbdinfo->FileName[d_info->name_len] = 0x00;
 		fbdinfo->FileNameLength = cpu_to_le32(d_info->name_len);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index e325c2e89aa5..9e72c45c100b 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -87,24 +87,6 @@ struct file_names_info {
 	char FileName[];
 } __packed;   /* level 0xc FF resp data */
 
-struct file_both_directory_info {
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
-	__u8   ShortNameLength;
-	__u8   Reserved;
-	__u8   ShortName[24];
-	char FileName[];
-} __packed; /* level 0x104 FFrsp data */
-
 struct file_id_both_directory_info {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
-- 
2.43.0

