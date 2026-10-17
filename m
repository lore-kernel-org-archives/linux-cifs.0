Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E0720D4FC
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199081; cv=none; b=roIT1ANGi5jX0dkX0VqVu5tOCuFa5EAY/FQYkdjsWi6BGojBpm40gTV4cMMdlAJRjYn3cQZBHufNzHj1fKfDIDeKLVjkAH9vczqExm6jutYzXO0qPcjehxqSmOeQEc8Lfwp9J+NG1q34hq0P2+CCmx1LaYhkOZOrcnkj7oLDPeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199081; c=relaxed/simple;
	bh=Rdx712Sym94fi9ABo0uGtZTCbKZSvyi3RiuX4sszRLw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DL0Xq6ex6Q+37Z2VjSxXVYC/Npsjh15yQ6dNcEpAZrQsq68ngRgAkN45zLn/YhCfEFprnrQ4YA6MpjpB7byKTzhq5bVguNFXKsYTfUqlM5z7KgBf2RNfADqGaEG8UJIDN7AZExJrNPLpQZ5i7C4m0qkDwN5wrX7M8GIGk9RlFVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cr0e+Xrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cr0e+Xrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A651F000C5;
	Sat, 17 Oct 2026 01:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199080;
	bh=WBpSM8B4iQHO4Ql5HOCLS+ZDzi4MXp7tW27mXy+GFng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cr0e+Xrtyj5W1bTZhP0EOG3T9O2QiOxAsnfu++5Qc3n9DrYFZDoCFOmpfgbWteYiE
	 4ZcOUmoLcFhYMQlFu+DaHPWGU/9ia5HI5KxhPv4Mhyr3i3DlCmAZRKRKNArkgDE2YK
	 qH2i2D1nExqqu1luls2DsttvbYtVaNbWbxUpPyUhRJs0+GPNF1Wu3xEoua+v2B04cX
	 xHIBn5XvmPFpmkt6oghSE+zorEsjqJWpdr9v7zYMZ7ofyGAs5wrIiGnfss3RQXF1AH
	 vs+wV1dS6VJBqyKtyNa4DCENZTqErtOvHRX5hWxXbIRvVtSU0CZoCiwfmM+DoGriuq
	 gI0DXjR2xITpA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 18/22] ksmbd: correct POSIX file metadata in responses
Date: Sat, 17 Oct 2026 10:03:40 +0900
Message-Id: <20261017010344.11478-18-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

POSIX responses omit special permission bits, and the create response
reports a file identifier as its reparse tag without encoding the file
type. Directory and file queries also report rdev as the filesystem
device identifier.

Report the POSIX mode and file type in create responses, include
special permission bits in all three response paths, and use the
special-file reparse tag consistently. Set the corresponding DOS
attribute in directory and file queries, report the filesystem device
identifier and initialize reserved fields.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  | 23 +++++++++++++++++++++--
 fs/smb/server/smb2pdu.c | 19 ++++++++++++++-----
 fs/smb/server/smb2pdu.h |  2 ++
 3 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index a911ff70b29e..10c81550b8a7 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -2569,8 +2569,27 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 	buf->Name[15] = 0x7C;
 
 	buf->nlink = cpu_to_le32(inode->i_nlink);
-	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
-	buf->mode = cpu_to_le32(inode->i_mode & 0777);
+	buf->reparse_tag = smb2_get_reparse_tag_special_file(inode->i_mode);
+	buf->mode = cpu_to_le32(inode->i_mode & 07777);
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFDIR:
+		buf->mode |= cpu_to_le32(POSIX_TYPE_DIR << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFLNK:
+		buf->mode |= cpu_to_le32(POSIX_TYPE_SYMLINK << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFCHR:
+		buf->mode |= cpu_to_le32(POSIX_TYPE_CHARDEV << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFBLK:
+		buf->mode |= cpu_to_le32(POSIX_TYPE_BLKDEV << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFIFO:
+		buf->mode |= cpu_to_le32(POSIX_TYPE_FIFO << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFSOCK:
+		buf->mode |= cpu_to_le32(POSIX_TYPE_SOCKET << POSIX_FILETYPE_SHIFT);
+	}
 	/*
 	 * SidBuffer(44) contain two sids(Domain sid(28), UNIX group sid(16)).
 	 * Domain sid(28) = revision(1) + num_subauth(1) + authority(6) +
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 92489bb86791..a4908b6e566e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1294,7 +1294,7 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 	ksmbd_free_work_struct(in_work);
 }
 
-static __le32 smb2_get_reparse_tag_special_file(umode_t mode)
+__le32 smb2_get_reparse_tag_special_file(umode_t mode)
 {
 	if (S_ISDIR(mode) || S_ISREG(mode))
 		return 0;
@@ -6020,6 +6020,7 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 
 		posix_info = (struct smb2_posix_info *)kstat;
 		posix_info->Ignored = 0;
+		posix_info->Zero = 0;
 		posix_info->CreationTime = cpu_to_le64(ksmbd_kstat->create_time);
 		time = ksmbd_UnixTimeToNT(ksmbd_kstat->kstat->ctime);
 		posix_info->ChangeTime = cpu_to_le64(time);
@@ -6029,9 +6030,11 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		posix_info->LastWriteTime = cpu_to_le64(time);
 		posix_info->EndOfFile = cpu_to_le64(ksmbd_kstat->kstat->size);
 		posix_info->AllocationSize = cpu_to_le64(ksmbd_kstat->kstat->blocks << 9);
-		posix_info->DeviceId = cpu_to_le32(ksmbd_kstat->kstat->rdev);
+		posix_info->DeviceId = cpu_to_le32(ksmbd_kstat->kstat->dev);
 		posix_info->HardLinks = cpu_to_le32(ksmbd_kstat->kstat->nlink);
-		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode & 0777);
+		posix_info->ReparseTag =
+			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
+		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode & 07777);
 		switch (ksmbd_kstat->kstat->mode & S_IFMT) {
 		case S_IFDIR:
 			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_DIR << POSIX_FILETYPE_SHIFT);
@@ -6056,6 +6059,8 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		posix_info->DosAttributes =
 			S_ISDIR(ksmbd_kstat->kstat->mode) ?
 				FILE_ATTRIBUTE_DIRECTORY_LE : FILE_ATTRIBUTE_ARCHIVE_LE;
+		if (posix_info->ReparseTag)
+			posix_info->DosAttributes |= FILE_ATTRIBUTE_REPARSE_POINT_LE;
 		if (d_info->hide_dot_file && d_info->name[0] == '.')
 			posix_info->DosAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
 		/*
@@ -7500,7 +7505,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 		file_info->AllocationSize = cpu_to_le64((u64)seof);
 	}
 	file_info->HardLinks = cpu_to_le32(stat.nlink);
-	file_info->Mode = cpu_to_le32(stat.mode & 0777);
+	file_info->Mode = cpu_to_le32(stat.mode & 07777);
 	switch (stat.mode & S_IFMT) {
 	case S_IFDIR:
 		file_info->Mode |= cpu_to_le32(POSIX_TYPE_DIR << POSIX_FILETYPE_SHIFT);
@@ -7521,7 +7526,11 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 		file_info->Mode |= cpu_to_le32(POSIX_TYPE_SOCKET << POSIX_FILETYPE_SHIFT);
 	}
 
-	file_info->DeviceId = cpu_to_le32(stat.rdev);
+	file_info->DeviceId = cpu_to_le32(stat.dev);
+	file_info->Zero = 0;
+	file_info->ReparseTag = smb2_get_reparse_tag_special_file(stat.mode);
+	if (file_info->ReparseTag)
+		file_info->DosAttributes |= FILE_ATTRIBUTE_REPARSE_POINT_LE;
 
 	/*
 	 * Sids(32) contain two sids(Domain sid(16), UNIX group sid(16)).
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index e07700d0a405..e706aa52352c 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -168,6 +168,8 @@ struct create_posix_rsp {
 	u8 SidBuffer[44];
 } __packed;
 
+__le32 smb2_get_reparse_tag_special_file(umode_t mode);
+
 #define SMB2_0_IOCTL_IS_FSCTL 0x00000001
 
 struct sockaddr_storage_rsp {
-- 
2.25.1

