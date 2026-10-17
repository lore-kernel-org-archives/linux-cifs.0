Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518F621CC59
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199983; cv=none; b=X+7WGboLjavHrJhiv7C1sDr18rUx4FSdFsMuybd++8bd+D4YBvFlsVjpRNuEL9mKS4cDhoF4/0PYwmlcualv7RQT+cKGMe7XVyinhOOgjSNZEJc4CRLDZF+5A2NP7YElZv4IaVksQIRB4XASOLpS92Vka47x5/LaUonHrXKIfjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199983; c=relaxed/simple;
	bh=x2Ic6f1Q2VwxEriGCLGUG2836X+OCrOht4pgO6Foimo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=syUk56aQghyQ9n6WugHS8XRa5cQwkrKFRjaGsV2xWVWoSESj9eXuH24D0XbsqITwp0BNTkN9RuTcxugSSePPpO/x9kN8YSFwfi92qiDTO2mv7WClsE6hPLiSScybZ3Jzox5u9PWOO7KCH/rrgR7s8HIg9nyb5W0evxFBMzvedZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TM6/BYXt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TM6/BYXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B731F000C5;
	Sat, 17 Oct 2026 01:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199982;
	bh=zTl3lVoWDBVTZN8x9hL0/ltQgkPTJt5bXg3K8IN9MTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TM6/BYXtKbi9fi03Yo80ZG6xc9iZHi9A0qkIOqYk8vOOHKbRDM0uC2pAnHWg3LL8c
	 W821OI32wq2lcd+yxZqK894nowjXYhXfKlS9zdbWNQ3UrAZ+Yqv+Rc1VIrtmhU5LA1
	 OnSTSyvv+X5rWX8Ps1dAhLELN8EwAbv47uZ0BGD5i7j8jyX1BijjB3yiWs3dZXg0JD
	 pdElogoCgpcGfzIGggNGUEZ73ggcBw/sJfp8xfxw9ODz7S5V9TNoJOmAfrB63L8HMK
	 8RA8OVZKduc+lkqFBYE6JXVmcvWa+u6VBZXKIdmInzM8Rxjibg0lHIyde9rJbo+N4y
	 nuDxU9iOkWJfw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: support FileIdExtdDirectoryInformation
Date: Sat, 17 Oct 2026 10:19:29 +0900
Message-Id: <20261017011932.14912-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017011932.14912-1-linkinjeon@kernel.org>
References: <20261017011932.14912-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handle FileIdExtdDirectoryInformation (0x3c) in SMB2 QUERY_DIRECTORY.
Add the packed wire layout specified by MS-FSCC 2.4.23 and support
this class in entry reservation, filename lookup and response encoding.

Return reparse tags separately from the EA size and set the reparse flag
without changing other file attributes. Zero the 128-bit file ID because
the VFS provides only a 64-bit inode number, as permitted by the
specification, and initialize entry padding.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c    | 44 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.h | 18 ++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4d0ced8e1f94..e1e884f62f2b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5444,6 +5444,8 @@ static int readdir_info_level_struct_sz(int info_level)
 		return sizeof(FILE_ID_FULL_DIR_INFO);
 	case FILEID_BOTH_DIRECTORY_INFORMATION:
 		return sizeof(struct file_id_both_directory_info);
+	case FILE_ID_EXTD_DIRECTORY_INFORMATION:
+		return sizeof(struct file_id_extd_directory_info);
 	case FileIdAllExtdBothDirectoryInformation:
 		return sizeof(struct file_id_all_extd_both_directory_info);
 	case SMB_FIND_FILE_POSIX_INFO:
@@ -5516,6 +5518,16 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 		d_info->name_len = le32_to_cpu(fibdinfo->FileNameLength);
 		return 0;
 	}
+	case FILE_ID_EXTD_DIRECTORY_INFORMATION:
+	{
+		struct file_id_extd_directory_info *info;
+
+		info = (struct file_id_extd_directory_info *)d_info->rptr;
+		d_info->rptr += le32_to_cpu(info->NextEntryOffset);
+		d_info->name = info->FileName;
+		d_info->name_len = le32_to_cpu(info->FileNameLength);
+		return 0;
+	}
 	case FileIdAllExtdBothDirectoryInformation:
 	{
 		struct file_id_all_extd_both_directory_info *info;
@@ -5763,6 +5775,26 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		fibdinfo->NextEntryOffset = cpu_to_le32(next_entry_offset);
 		break;
 	}
+	case FILE_ID_EXTD_DIRECTORY_INFORMATION:
+	{
+		struct file_id_extd_directory_info *info;
+
+		info = (struct file_id_extd_directory_info *)kstat;
+		info->FileNameLength = cpu_to_le32(conv_len);
+		info->EaSize = 0;
+		info->ReparsePointTag =
+			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
+		if (info->ReparsePointTag)
+			info->ExtFileAttributes |= FILE_ATTRIBUTE_REPARSE_POINT_LE;
+		/* The VFS does not provide a 128-bit file ID. */
+		memset(info->FileId, 0, sizeof(info->FileId));
+		if (d_info->hide_dot_file && d_info->name[0] == '.')
+			info->ExtFileAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
+		memcpy(info->FileName, conv_name, conv_len);
+		memset(info->FileName + conv_len, 0, d_info->last_entry_off_align);
+		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
+		break;
+	}
 	case FileIdAllExtdBothDirectoryInformation:
 	{
 		struct file_id_all_extd_both_directory_info *info;
@@ -6036,6 +6068,17 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 		fibdinfo->NextEntryOffset = cpu_to_le32(next_entry_offset);
 		break;
 	}
+	case FILE_ID_EXTD_DIRECTORY_INFORMATION:
+	{
+		struct file_id_extd_directory_info *info;
+
+		info = (struct file_id_extd_directory_info *)d_info->wptr;
+		memcpy(info->FileName, d_info->name, d_info->name_len);
+		info->FileName[d_info->name_len] = 0x00;
+		info->FileNameLength = cpu_to_le32(d_info->name_len);
+		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
+		break;
+	}
 	case FileIdAllExtdBothDirectoryInformation:
 	{
 		struct file_id_all_extd_both_directory_info *info;
@@ -6108,6 +6151,7 @@ static int verify_info_level(int info_level)
 	case FILEID_FULL_DIRECTORY_INFORMATION:
 	case FILEID_BOTH_DIRECTORY_INFORMATION:
 	case SMB_FIND_FILE_POSIX_INFO:
+	case FILE_ID_EXTD_DIRECTORY_INFORMATION:
 	case FileIdAllExtdBothDirectoryInformation:
 		break;
 	default:
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 6ccfdee3ab19..458255684f6c 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -133,6 +133,24 @@ struct file_id_both_directory_info {
 	char FileName[];
 } __packed;
 
+/* MS-FSCC 2.4.23 FileIdExtdDirectoryInformation */
+struct file_id_extd_directory_info {
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
+	__le32 EaSize;
+	__le32 ReparsePointTag;
+	__u8 FileId[16];
+	char FileName[];
+} __packed;
+
 /* MS-FSCC 2.4.20 FileIdAllExtdBothDirectoryInformation */
 struct file_id_all_extd_both_directory_info {
 	__le32 NextEntryOffset;
-- 
2.25.1

