Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE092E1C7E
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549351; cv=none; b=Z098B/VkHgtsxoZtWWB2LTPYeH/12T6fDqmwOI1atPaXFCgpKw8Clz1/D7ELuUPvQDKLaIkwrGnlEB2aX51E3fepQ7DcsEbdX0bh+J8MM7iqTLAFzwVYYx9a5J5TEu7e5cxIm2rN5D1S6lMcyPFPRGFTK2Lyu8psCaidgkSn/BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549351; c=relaxed/simple;
	bh=O8KUB3CsooDHmf4ZflySRRm4E4n9y/C5l9t3/FEVHIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqLg5f0cnryLqq7jvMbMs5c7cFbKjw4TMdrKqiB16uJCmdlD9TSPrAFtjgIWDWSitMcKmk/kNCzzBrxVWGOU8Z9sbKwqnvvgSqOX0JUQnO8llNPjIplDhpRRli9tcPOxgonc+oHq1EDld0crnKr2SxLFWsddt0NmC+59biN2t7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RZXTHwov; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RZXTHwov"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V9blrSrhjy6jjuF/Xoc8xDhBclo1M/7Y4sN8wwjEBzY=;
	b=RZXTHwovNpURRqDuEJ8ktS9OdrAL23Df2m82cP6jCYSgMuRZIhC0azKxaqR922at5OaJz8
	Iqar5GKIyg968qvvI5WQiqDPYjNJ1OYAZurZv5hIPYC/QapYafDXDZ+RsrAH64svgGOv6a
	lwUlAwPE+XiM/Ku7pnjfpxzQSzjV2FA=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 11/24] smb: move FILE_DIRECTORY_INFO to common/smb1pdu.h
Date: Mon, 27 Oct 2025 15:13:03 +0800
Message-ID: <20251027071316.3468472-12-chenxiaosong.chenxiaosong@linux.dev>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct file_directory_info" to "FILE_DIRECTORY_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 14 --------------
 fs/smb/common/smb1pdu.h    | 15 +++++++++++++++
 fs/smb/server/smb2pdu.c    | 16 ++++++++--------
 fs/smb/server/smb_common.h | 14 --------------
 fs/smb/server/vfs.c        |  2 +-
 5 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index d4addb0d7942..38e5b0a9f427 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2159,20 +2159,6 @@ typedef struct {
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
diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
index 02b8cda74f47..e6ddfb4c872c 100644
--- a/fs/smb/common/smb1pdu.h
+++ b/fs/smb/common/smb1pdu.h
@@ -368,4 +368,19 @@ typedef struct {
 	__le16 FileSystemName[]; /* do not have to save this - get subset? */
 } __packed FILE_SYSTEM_ATTRIBUTE_INFO;
 
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
+} __packed FILE_DIRECTORY_INFO;   /* level 0x101 FF resp data */
+
 #endif /* _COMMON_SMB1_PDU_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d063d2827868..3f4646270f96 100644
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
index d8aeab6115f5..f983231544a6 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -81,20 +81,6 @@ struct object_id_info {
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

