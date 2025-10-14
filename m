Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA4B30F53F
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 07:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760427059; cv=none; b=eLMnwN4rcDQQ5xAXBZyE79qKVqfiPrA4E08gdb51E9O+SG/+xh4mk5yaMrEcYDl/5GvJIyUwd4ozravLPK/A9IFJJHIGjytXjt0Ip3QB4FP8mtF3Ov23KaAObIL0NKnriNSZJPINrvUdqb+sBdsevbDCQjMbSO+GfJPjem1Xelk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760427059; c=relaxed/simple;
	bh=F6Sq6Ie75/UTc0yIY1uQJ2UUmS8cT5UNdaUtmeFRic8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PINJEoijq1MimWo98aJVtQD3Z4icUuxS63+23BSyh4Wye3UuWuvk5RbLtSDYP/zc2TBMNrFWbvJ5xldPTKiLIsh5Q0kw3f9yaCpYAZqbjSZgebZevCPmtB3U6D76AzeB6fGoy5NglIQl2TZKXjMmAho655fj7xx+ulwpG+B0ZyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Le9zhNY7; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Le9zhNY7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760427043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vdm0/KJOf76Q2nOSqV2xt7ZCooQwXtilUlu0YCsTMZI=;
	b=Le9zhNY7JS+1qpQ5ijokk6A7GyJJVsIUKwWlCpONnXPI1QWc9ijlSZd5/wDkXzrrUnqP91
	b5BmmkidFnrbAVC4k58gJpN2zdmzm0ZzYLEO6OubyBe6ffSdUkYUDd4TejewndVtaLG/UP
	ey4dtGntpAUio7Cn8G/sNw7Lk7dVe/E=
From: chenxiaosong.chenxiaosong@linux.dev
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
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 18/22] smb: move FILE_DIRECTORY_INFO to common/cifspdu.h
Date: Tue, 14 Oct 2025 15:28:52 +0800
Message-ID: <20251014072856.3004683-8-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct file_directory_info" to "FILE_DIRECTORY_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 14 --------------
 fs/smb/common/cifspdu.h    | 15 +++++++++++++++
 fs/smb/server/smb2pdu.c    | 16 ++++++++--------
 fs/smb/server/smb_common.h | 14 --------------
 fs/smb/server/vfs.c        |  2 +-
 5 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 889be409146c..8031e24234a9 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2150,20 +2150,6 @@ typedef struct {
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
-	char FileName[];
-} __attribute__((packed)) FILE_DIRECTORY_INFO;   /* level 0x101 FF resp data */
-
 typedef struct {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index 548d621ec233..82d57ba275ee 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -370,4 +370,19 @@ typedef struct {
 	__le16 FileSystemName[]; /* do not have to save this - get subset? */
 } __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
 
+/* See MS-CIFS 2.2.8.1.4 */
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
+	char FileName[];
+} __attribute__((packed)) FILE_DIRECTORY_INFO;   /* level 0x101 FF resp data */
+
 #endif /* _COMMON_CIFSPDU_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2ad46a11e7ef..679318afdce3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3800,7 +3800,7 @@ static int readdir_info_level_struct_sz(int info_level)
 	case FILE_BOTH_DIRECTORY_INFORMATION:
 		return sizeof(struct file_both_directory_info);
 	case FILE_DIRECTORY_INFORMATION:
-		return sizeof(struct file_directory_info);
+		return sizeof(FILE_DIRECTORY_INFO);
 	case FILE_NAMES_INFORMATION:
 		return sizeof(struct file_names_info);
 	case FILEID_FULL_DIRECTORY_INFORMATION:
@@ -3839,9 +3839,9 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 	}
 	case FILE_DIRECTORY_INFORMATION:
 	{
-		struct file_directory_info *fdinfo;
+		FILE_DIRECTORY_INFO *fdinfo;
 
-		fdinfo = (struct file_directory_info *)d_info->rptr;
+		fdinfo = (FILE_DIRECTORY_INFO *)d_info->rptr;
 		d_info->rptr += le32_to_cpu(fdinfo->NextEntryOffset);
 		d_info->name = fdinfo->FileName;
 		d_info->name_len = le32_to_cpu(fdinfo->FileNameLength);
@@ -3978,9 +3978,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 	}
 	case FILE_DIRECTORY_INFORMATION:
 	{
-		struct file_directory_info *fdinfo;
+		FILE_DIRECTORY_INFO *fdinfo;
 
-		fdinfo = (struct file_directory_info *)kstat;
+		fdinfo = (FILE_DIRECTORY_INFO *)kstat;
 		fdinfo->FileNameLength = cpu_to_le32(conv_len);
 		if (d_info->hide_dot_file && d_info->name[0] == '.')
 			fdinfo->ExtFileAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
@@ -4228,9 +4228,9 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 	}
 	case FILE_DIRECTORY_INFORMATION:
 	{
-		struct file_directory_info *fdinfo;
+		FILE_DIRECTORY_INFO *fdinfo;
 
-		fdinfo = (struct file_directory_info *)d_info->wptr;
+		fdinfo = (FILE_DIRECTORY_INFO *)d_info->wptr;
 		memcpy(fdinfo->FileName, d_info->name, d_info->name_len);
 		fdinfo->FileName[d_info->name_len] = 0x00;
 		fdinfo->FileNameLength = cpu_to_le32(d_info->name_len);
@@ -4514,7 +4514,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 			goto err_out;
 	} else {
 no_buf_len:
-		((struct file_directory_info *)
+		((FILE_DIRECTORY_INFO *)
 		((char *)rsp->Buffer + d_info.last_entry_offset))
 		->NextEntryOffset = 0;
 		if (d_info.data_count >= d_info.last_entry_off_align)
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index d6351b0ee62a..ea1c64f84ff1 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -80,20 +80,6 @@ struct object_id_info {
 	struct fs_extended_info extended_info;
 } __packed;
 
-struct file_directory_info {
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
-	char FileName[];
-} __packed;   /* level 0x101 FF resp data */
-
 struct file_names_info {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 891ed2dc2b73..a8660487e4ae 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1654,7 +1654,7 @@ int ksmbd_vfs_get_dos_attrib_xattr(struct mnt_idmap *idmap,
  */
 void *ksmbd_vfs_init_kstat(char **p, struct ksmbd_kstat *ksmbd_kstat)
 {
-	struct file_directory_info *info = (struct file_directory_info *)(*p);
+	FILE_DIRECTORY_INFO *info = (FILE_DIRECTORY_INFO *)(*p);
 	struct kstat *kstat = ksmbd_kstat->kstat;
 	u64 time;
 
-- 
2.43.0

