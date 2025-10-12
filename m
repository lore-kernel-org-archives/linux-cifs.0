Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73432F6168;
	Sun, 12 Oct 2025 15:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.154.54.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282761; cv=none; b=R1TeN2n/dYqaLOVr+zF9xlZgtQ2EeP8SRVTB92zwnl2T1bAs/2Nk2HITgljHGdwZW21RZSLVYjXbkz8eEqusB3Hz34Vi3hNq21M1EzD+82McgpFcCc+PttJfTvpUbwcwAielbx78CUk4vYGe+8t8WLg/INFY8J9TLo2JIyQx62s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282761; c=relaxed/simple;
	bh=bGSjiGhKrW0fwcd2uFIhvIfrxchHrqrL9vlAAJS9bRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FytaOu/lxmCn4k5LqxuhXR+RvbaKXcsPknpk2ofoSLQjD0b3lo8NrEiy7JH8LgI36O6RptdBKxy50gkFILg88HCQMDtGxuReq32RLcWV8/oEAhDpcAJTIiTon7Dgq3WIWvZw1ZHJObyFvlZsnB4YFyJdO4FxtJAq3JaKUEvQQPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.154.54.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282627tbd271936
X-QQ-Originating-IP: pWFC6fOx+zuD/xNWbWmS49J6pyCTdE+Ahjk58pXKayg=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:46 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 54060577276940906
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
Subject: [PATCH RESEND 21/22] smb: move SEARCH_ID_FULL_DIR_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:22:46 +0800
Message-ID: <35FBD9E039C5295C+20251012152247.2992573-22-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: OKgraWJYmkAvL7fPE92Omsptk1DLUdKa76/9Ld3Att18dsr1fakjhl6s
	3k20d+jg6C940o0thza/7qgovb0qflqnWM94sxSfIKnrpR5uuaQ3T8JBACDDE/U7Yo6U8M7
	wDHMWkTT2XUc4b/Q21aljxJtk07XRtANkQq9FQDmTZ5hpo4g8m/bFnnUAJvIt2oGZdulANE
	bCUjRBtzxUBYT7qZjaLp5AnQl6FByKD7ok02PCU5Qi9F50/0FNLch4FXxUV1oHh++D8vjJH
	aUNbbt/tqazMNJYqU4U8o1ClrfJTqIyUDDh0KEz5sLJwUOH4EB/nwxc90vwSp7dm/nNRlBv
	xMC3UrPeV9gCDCi6YDcEMjOnbC2WBt6u1TtB93gsJjLy0dWc9aCRKi41bZcGCbfdrHSE1VM
	fUgj+wk9g+uhbfg5G9Kcf9rkWUyomrtiWM1f4u86Gm7bSK6kgLyNwtMx+DvUmvDrXcoBWkl
	1Y8G/XH4tLxMogGwBlvpLWclfrJIgjwHhZcpJvZw/UG0TH0JH/jkaEeGLdndJ+IA8CBeMub
	6XpfgQPgJsmhZGQDIBCnDC42Lczpg2HAuCPdjiFlBywwyfrZf7MKRkwFKFRZEDOisz5ypRQ
	1lwE7YajshunWAuDrUSERP7Cmhk3bXyUBt5mCcAcaxxEfOgUiicjnD3DBSNhv9HBZiByB6G
	/CLuWXo/O4uXcaDVxuGuQpjOWhBqa+ud1IHujFqlB/f4iUqzkwfHwsXCU/Um7MgRhxueOgi
	4mroqICJHd2Tz2nc8ZewR21dVeMUAIVlTi7SsCOjJvpOrCYdJ8tg5WxY8iwJW1qi7O5h391
	/v4cs3iImJlxjI2P+nalFPNXeDk5iq7Zd0YON92kJuAAtmmlGe1KH8B4exKjXLxeNpBRpc+
	QtNKnG90qAwmjZsCqBJUAuFVKOpsOCdjWizS0/iDCq9rObjxpYqn5BnAJYoIHjPGqtMcjRv
	FxhqpRd2nXgpBkLtNOr/lK+oOf2xmrvjffAVk16OXJKG/4RH/23OJ7YNleLL4Eto6Scq3Vf
	/tDU1bv40384HMUgUiSzj4hlry1Pn9THrh+v4GJIJXmJw7K72TRrEJM7CN7+v6S9j08P/CM
	0ZVfL4IEoNwAb0rxpQEy56mFZUbFrtcfL4OKDN0bg6QIvxkDA2/S7A=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct file_id_full_dir_info" to "SEARCH_ID_FULL_DIR_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 17 -----------------
 fs/smb/common/cifspdu.h    | 18 ++++++++++++++++++
 fs/smb/server/smb2pdu.c    | 14 +++++++-------
 fs/smb/server/smb_common.h | 17 -----------------
 4 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 3db5e7e6172e..68e3af176add 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2150,23 +2150,6 @@ typedef struct {
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
-	__le32 EaSize; /* EA size */
-	__le32 Reserved;
-	__le64 UniqueId; /* inode num - le since Samba puts ino in low 32 bit*/
-	char FileName[];
-} __attribute__((packed)) SEARCH_ID_FULL_DIR_INFO; /* level 0x105 FF rsp data */
-
 typedef struct {
 	__u32  ResumeKey;
 	__le16 CreationDate; /* SMB Date */
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index cf5e3ee577d0..b4ca0c36cf84 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -401,6 +401,24 @@ typedef struct {
 	char FileName[];
 } __attribute__((packed)) FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
 
+/* See MS-SMB 2.2.8.1.2 */
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
+	__le32 EaSize; /* EA size */
+	__le32 Reserved;
+	__le64 UniqueId; /* inode num - le since Samba puts ino in low 32 bit*/
+	char FileName[];
+} __attribute__((packed)) SEARCH_ID_FULL_DIR_INFO; /* level 0x105 FF rsp data */
+
 /* See MS-CIFS 2.2.8.1.7 */
 typedef struct {
 	__le32 NextEntryOffset;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8c5700102cc6..065e0daaa91b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3804,7 +3804,7 @@ static int readdir_info_level_struct_sz(int info_level)
 	case FILE_NAMES_INFORMATION:
 		return sizeof(struct file_names_info);
 	case FILEID_FULL_DIRECTORY_INFORMATION:
-		return sizeof(struct file_id_full_dir_info);
+		return sizeof(SEARCH_ID_FULL_DIR_INFO);
 	case FILEID_BOTH_DIRECTORY_INFORMATION:
 		return sizeof(struct file_id_both_directory_info);
 	case SMB_FIND_FILE_POSIX_INFO:
@@ -3859,9 +3859,9 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 	}
 	case FILEID_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_id_full_dir_info *dinfo;
+		SEARCH_ID_FULL_DIR_INFO *dinfo;
 
-		dinfo = (struct file_id_full_dir_info *)d_info->rptr;
+		dinfo = (SEARCH_ID_FULL_DIR_INFO *)d_info->rptr;
 		d_info->rptr += le32_to_cpu(dinfo->NextEntryOffset);
 		d_info->name = dinfo->FileName;
 		d_info->name_len = le32_to_cpu(dinfo->FileNameLength);
@@ -4000,9 +4000,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 	}
 	case FILEID_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_id_full_dir_info *dinfo;
+		SEARCH_ID_FULL_DIR_INFO *dinfo;
 
-		dinfo = (struct file_id_full_dir_info *)kstat;
+		dinfo = (SEARCH_ID_FULL_DIR_INFO *)kstat;
 		dinfo->FileNameLength = cpu_to_le32(conv_len);
 		dinfo->EaSize =
 			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
@@ -4250,9 +4250,9 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 	}
 	case FILEID_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_id_full_dir_info *dinfo;
+		SEARCH_ID_FULL_DIR_INFO *dinfo;
 
-		dinfo = (struct file_id_full_dir_info *)d_info->wptr;
+		dinfo = (SEARCH_ID_FULL_DIR_INFO *)d_info->wptr;
 		memcpy(dinfo->FileName, d_info->name, d_info->name_len);
 		dinfo->FileName[d_info->name_len] = 0x00;
 		dinfo->FileNameLength = cpu_to_le32(d_info->name_len);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 9e72c45c100b..4f48dbf9c13b 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -107,23 +107,6 @@ struct file_id_both_directory_info {
 	char FileName[];
 } __packed;
 
-struct file_id_full_dir_info {
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
-	__le32 EaSize; /* EA size */
-	__le32 Reserved;
-	__le64 UniqueId; /* inode num - le since Samba puts ino in low 32 bit*/
-	char FileName[];
-} __packed; /* level 0x105 FF rsp data */
-
 struct filesystem_posix_info {
 	/* For undefined recommended transfer size return -1 in that field */
 	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
-- 
2.43.0

