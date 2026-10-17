Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F7B1A682A
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199985; cv=none; b=kZgY4/esT2PTrpvDNX6AwcgvGe87mfwsDWx4XBeuR48RhgQOlpPuKd4ogPmb/79Fhccj4S0OJOFPmsowEMh3phvRbokvH8j844LwefY00t6YN3DHNGKzJ9E73X00tR3fnJPNv8bKCO+GaCWQ80zE0AJq3q2V0MgIPhliH6+ZKbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199985; c=relaxed/simple;
	bh=BTI7Up0OLUDvS6I2Hw1pkhkNwF+3iblIlFCw6y6+dQ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZgjQhhqXFIW/Fy4r8hHQoQdyvqHXRqr0feHY/dYfW8c6A7AU6rJ2xQ6/op66HF9temWM0Pbc4n+hLI+BVwBHVdzyUw6+wejl0WGFFCDNUZUDCgDYOV3w4fpGNfDj9jUOB/uj7qJwRPpSjlw0fSvobczFNE11Hjei6cpJ7b2oIa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bfxos8Pv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bfxos8Pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94691F000C4;
	Sat, 17 Oct 2026 01:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199984;
	bh=zqzjiYChyQXipJyNWBulHFxeHnMoPeniEUkXkjhkzDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bfxos8Pvbc80ZHQZRY32Eyncj6lGzWvaudMpWQboM0yL6SpH2HAGMKFnBHpikUdLD
	 xKsRf9TZZETMuDhdOGhO2U8sa+uiyd1V73UvoSNeMWapq+7kfWckWYHDY3xSH8D7Xa
	 SQwy6ezUcJZW/TRGoSVlNMjJDjNkSH6K6bdyrPQO0IEW6cnwkmKKs8apqTJp9yQK/s
	 FuyNNAMIJ6s75PW0bAJP7RXGx6ULisLv+fO80NIxS3VBLOsKNjYW1FC5jwwlOBD50H
	 l4V/oT8cnggK2bCI1DK63XVyR8UR2Zr6DX4NuHaiy5VYZw8KIUghoCU7phj9o7Z2Jh
	 RUempp5fOK5LA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: support FileId64ExtdDirectoryInformation
Date: Sat, 17 Oct 2026 10:19:30 +0900
Message-Id: <20261017011932.14912-3-linkinjeon@kernel.org>
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

Handle FileId64ExtdDirectoryInformation (0x4e) in SMB2 QUERY_DIRECTORY.
Add the packed wire layout specified by MS-FSCC 2.4.19 and support
this class in entry reservation, filename lookup and response encoding.

Use the VFS inode number for the 64-bit file ID and retain the existing
Apple extension behavior of returning a zero ID. Report reparse tags
separately from the EA size, set the reparse flag without changing other
file attributes, and initialize entry padding.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c    | 46 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.h | 18 +++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e1e884f62f2b..13fc73e38f55 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5446,6 +5446,8 @@ static int readdir_info_level_struct_sz(int info_level)
 		return sizeof(struct file_id_both_directory_info);
 	case FILE_ID_EXTD_DIRECTORY_INFORMATION:
 		return sizeof(struct file_id_extd_directory_info);
+	case FileId64ExtdDirectoryInformation:
+		return sizeof(struct file_id_64_extd_directory_info);
 	case FileIdAllExtdBothDirectoryInformation:
 		return sizeof(struct file_id_all_extd_both_directory_info);
 	case SMB_FIND_FILE_POSIX_INFO:
@@ -5528,6 +5530,16 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 		d_info->name_len = le32_to_cpu(info->FileNameLength);
 		return 0;
 	}
+	case FileId64ExtdDirectoryInformation:
+	{
+		struct file_id_64_extd_directory_info *info;
+
+		info = (struct file_id_64_extd_directory_info *)d_info->rptr;
+		d_info->rptr += le32_to_cpu(info->NextEntryOffset);
+		d_info->name = info->FileName;
+		d_info->name_len = le32_to_cpu(info->FileNameLength);
+		return 0;
+	}
 	case FileIdAllExtdBothDirectoryInformation:
 	{
 		struct file_id_all_extd_both_directory_info *info;
@@ -5795,6 +5807,28 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
 		break;
 	}
+	case FileId64ExtdDirectoryInformation:
+	{
+		struct file_id_64_extd_directory_info *info;
+
+		info = (struct file_id_64_extd_directory_info *)kstat;
+		info->FileNameLength = cpu_to_le32(conv_len);
+		info->EaSize = 0;
+		info->ReparsePointTag =
+			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
+		if (info->ReparsePointTag)
+			info->ExtFileAttributes |= FILE_ATTRIBUTE_REPARSE_POINT_LE;
+		if (conn->is_aapl)
+			info->FileId = 0;
+		else
+			info->FileId = cpu_to_le64(ksmbd_kstat->kstat->ino);
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
@@ -6079,6 +6113,17 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
 		break;
 	}
+	case FileId64ExtdDirectoryInformation:
+	{
+		struct file_id_64_extd_directory_info *info;
+
+		info = (struct file_id_64_extd_directory_info *)d_info->wptr;
+		memcpy(info->FileName, d_info->name, d_info->name_len);
+		info->FileName[d_info->name_len] = 0x00;
+		info->FileNameLength = cpu_to_le32(d_info->name_len);
+		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
+		break;
+	}
 	case FileIdAllExtdBothDirectoryInformation:
 	{
 		struct file_id_all_extd_both_directory_info *info;
@@ -6152,6 +6197,7 @@ static int verify_info_level(int info_level)
 	case FILEID_BOTH_DIRECTORY_INFORMATION:
 	case SMB_FIND_FILE_POSIX_INFO:
 	case FILE_ID_EXTD_DIRECTORY_INFORMATION:
+	case FileId64ExtdDirectoryInformation:
 	case FileIdAllExtdBothDirectoryInformation:
 		break;
 	default:
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 458255684f6c..bfd0122d972c 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -151,6 +151,24 @@ struct file_id_extd_directory_info {
 	char FileName[];
 } __packed;
 
+/* MS-FSCC 2.4.19 FileId64ExtdDirectoryInformation */
+struct file_id_64_extd_directory_info {
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
+	__le64 FileId;
+	char FileName[];
+} __packed;
+
 /* MS-FSCC 2.4.20 FileIdAllExtdBothDirectoryInformation */
 struct file_id_all_extd_both_directory_info {
 	__le32 NextEntryOffset;
-- 
2.25.1

