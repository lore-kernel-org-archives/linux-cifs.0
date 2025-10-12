Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3842EFD92;
	Sun, 12 Oct 2025 16:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760286105; cv=none; b=qOISQvecn9ia3+fgW+0laiyWnRQ4QyP2vJgVjEqk1HeWh2JZnhNqF1D05cvuavU7J4mgRsSPvKb1eLtMZIx/dsdlDAXsyu7ZBS00OG2X6NH/8N3T0e2hV+zCy8BSnSh8gzpyJ4OnQcqZmBab2B2/7BrRHoiht5cAfvNjwt+Uwpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760286105; c=relaxed/simple;
	bh=oBWHsb5ZrCzAgydcykXvb0C1NNG8ufvsu6D1kbmawFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gL0ePhbubIaISVRjGqolMHPTxuO5JsQ3HNKzYMGxnFujw11Q32ZFJ+Jy8naieOwjvch7jU/2JKLqKX2H3lCpt037UdC6QZTIhnMUukD5sMiu4qskijkyaGTcU0ldVewuICplu4BUSm3jsjVDZ37TIn1zQe7rEeMWRZdqcJOj+2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285936tc99b24fe
X-QQ-Originating-IP: +w8OSXZH4McVin1FnxSkVW4BuHj5kuY7yzCkkOHhZn4=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:55 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 7876261125783223663
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
Subject: [PATCH v2 20/22] smb: move FILE_BOTH_DIRECTORY_INFO to common/cifspdu.h
Date: Mon, 13 Oct 2025 00:17:47 +0800
Message-ID: <EE43E4DE36C71EE5+20251012161749.2994033-21-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: ONMinSPvVgZRBqvn9Zv3HMLYl6rhaOP585RCTRhDXuB2OhBaW/5KHycc
	a3X2ktfPQnSirs5EFgCbvcqRdbR90KokOQeMKIG36Xj+RRvCMzXouVpJXlT3AZr68qOkAhN
	/AAVacb0RJdsXuDo/b9IG5OW8mmFKQhjPvrnpweA8xC6gffA786p8gKEF2AKtsHuWqPVdMt
	nCrN4Y5Vqc+GNVWrs/BVyHDlRWK9pAtS27/J5SoQRoPW/TcT0BMvaIbPcIz/2PBSX2ZJqWp
	E/1jO/16tyhWJxc6J3ppMlsQqZ8Ivt1WYc2j4ugyim9toDsWEQJOdJG/gnvxHsq6bG8pMBR
	Es40CHHaGfdyIyQMD8jMshTqwiZ/z/XRoGb9vrUeaaEfGlhQ0lqO5v6UZCmZIo0D9tKeHqy
	W1m1bO1HjsN2QmLw/ciRcx60RUbf8hYr4GXRau8xln7cxhlUMX4zXRBJIYD69gjyjPnHRYi
	zJYADSSUtFDpcm/mogez5dNva8jS2ktQFbNTypo5c8txbefWMGiRQtaZ/MADKevuUcKCLtP
	DDz0zdbbzFP5p/R3qoydScvntOANabbtHit5nZvlu+5S/SrRJ3pHvR/50Rre64vWFQday0M
	9QSJ7IkYq/AI2JUp4ohc6OtVgHR92dSBLZKLp/tHorEEVcswzT4RPbMmdx4cnbAE5gAgPtw
	DyXnupWBKtNjTyhmR/mtaGf7bR/Jrrgi/hYyf9XPvg2oTyKHma4/vPO3K1xdLyPRtfj+koN
	S9dptRIgXvZaq9DjQutF1VryNNWHi7mxq9SJLYIQrdkPnH4KBlrPYj35tkvYfgcgQxYrew4
	B/CJtEMoxMd9ZGWluIVahLtbyMJjPUtzUtQ+wxzoDbDmxz3w9sAxWAUbqHZ7mn4m92Wsp3u
	L//KNsgobUrVKyw8pZIUqbZiBkTaoZY8Cia2TDwraDDptj5UkTAo2W5bvLlipe6Q6qalRnL
	lE+YY6qL0YyO8yQB9zuL5lHJSrj+Lk+Gvzqu724q61NvGdeceJmEjbIwMO5oz3W0qSNYGyW
	os+dP8r9428UfwiS6wsGP22OSXwQeQ9lXX5/iq/Bc8uFRq/AhHNl+DIXG0SaS4r30BqEtrN
	V0Q7EaGhLcxCd3VoRsr6v8=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

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

