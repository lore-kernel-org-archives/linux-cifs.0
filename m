Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5D47260D
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199988; cv=none; b=H6jS3pXQHIHH4PPQPxGU4WYrSLlBCFzdxobdqG/60timD9AL9NM5YWrXJ3V3+YQh7icNeTDICPhx22JaCZQpa6skEHwggt32paucSCgrDMCWU0Oz2eG6X16220nPOc9DKIE5aec/i1zE1JTfVzjYZSdyGva9vY1gqpfkKA2lx7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199988; c=relaxed/simple;
	bh=cntEnU6gd4p8Whd4QrRVmw0fm3aefS0GOcQokUvMav0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tjP9SpCTuZybjcugdxiS7qqFElFH53itHbgIHLbVIJD+dMluuCgAFWX+egAbjLdlh7CBVtl+iXxCGKrdEf/6vvAqze5NCjhuHxtJA5LEg5dugipor5GN0abMT3O//N7Cdbboy1WqrkvuOu8SzEXRFV5+3ZsJJvxCiK/+z9Z9GAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBv9yMcw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBv9yMcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82D41F000C4;
	Sat, 17 Oct 2026 01:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199987;
	bh=oqCN4WCGtaYcoYIbPCZikAZCG8t0RFLqS8cQA1JNE0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBv9yMcw9vpbXDCDq13hMGSpuC/wSnGYTMKSeADznQcAEku73NcfD43ks6ZdEn0z/
	 kA9FH2Jcjd9nnXf9GpdRvd02OJAHMsZ3XPQ0jfFhveG2ohVTwXS1guVv5ay3Nu+3uq
	 i7ynpxvvbktAqGK9Re2kw1kTy5qI/TOj7bv7mGB7m/Y1Z/+B9DqYZa4YYA0W7rekgZ
	 iuWsT1CaS0wHFECnmwkLf2vgoNRahwD+NbZpuhMHfWhfFZ53vGOlWKbOoK04UtFJrl
	 VNXbCTZhuY5pucmIIvmNc1epppvP6h21+KJOAQVxZV5yVLXu7v0R+3bS4e8mJ1xGXv
	 pbqLC3SGtKTSA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: support FileId64ExtdBothDirectoryInformation
Date: Sat, 17 Oct 2026 10:19:31 +0900
Message-Id: <20261017011932.14912-4-linkinjeon@kernel.org>
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

Handle FileId64ExtdBothDirectoryInformation (0x4f) in SMB2 QUERY_DIRECTORY.
Add the packed wire layout specified by MS-FSCC 2.4.18 and support
this class in entry reservation, filename lookup and response encoding.

Use the VFS inode number for the 64-bit file ID and retain the existing
Apple extension behavior of returning a zero ID. Return an empty short
name and zero its storage and the reserved byte. Report reparse tags
separately from the EA size, set the reparse flag without changing other
file attributes, and initialize entry padding.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c    | 49 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.h | 21 ++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 13fc73e38f55..2c0378d306a8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5448,6 +5448,8 @@ static int readdir_info_level_struct_sz(int info_level)
 		return sizeof(struct file_id_extd_directory_info);
 	case FileId64ExtdDirectoryInformation:
 		return sizeof(struct file_id_64_extd_directory_info);
+	case FileId64ExtdBothDirectoryInformation:
+		return sizeof(struct file_id_64_extd_both_directory_info);
 	case FileIdAllExtdBothDirectoryInformation:
 		return sizeof(struct file_id_all_extd_both_directory_info);
 	case SMB_FIND_FILE_POSIX_INFO:
@@ -5540,6 +5542,16 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 		d_info->name_len = le32_to_cpu(info->FileNameLength);
 		return 0;
 	}
+	case FileId64ExtdBothDirectoryInformation:
+	{
+		struct file_id_64_extd_both_directory_info *info;
+
+		info = (struct file_id_64_extd_both_directory_info *)d_info->rptr;
+		d_info->rptr += le32_to_cpu(info->NextEntryOffset);
+		d_info->name = info->FileName;
+		d_info->name_len = le32_to_cpu(info->FileNameLength);
+		return 0;
+	}
 	case FileIdAllExtdBothDirectoryInformation:
 	{
 		struct file_id_all_extd_both_directory_info *info;
@@ -5829,6 +5841,31 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
 		break;
 	}
+	case FileId64ExtdBothDirectoryInformation:
+	{
+		struct file_id_64_extd_both_directory_info *info;
+
+		info = (struct file_id_64_extd_both_directory_info *)kstat;
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
+		info->ShortNameLength = 0;
+		info->Reserved1 = 0;
+		memset(info->ShortName, 0, sizeof(info->ShortName));
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
@@ -6124,6 +6161,17 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
 		break;
 	}
+	case FileId64ExtdBothDirectoryInformation:
+	{
+		struct file_id_64_extd_both_directory_info *info;
+
+		info = (struct file_id_64_extd_both_directory_info *)d_info->wptr;
+		memcpy(info->FileName, d_info->name, d_info->name_len);
+		info->FileName[d_info->name_len] = 0x00;
+		info->FileNameLength = cpu_to_le32(d_info->name_len);
+		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
+		break;
+	}
 	case FileIdAllExtdBothDirectoryInformation:
 	{
 		struct file_id_all_extd_both_directory_info *info;
@@ -6198,6 +6246,7 @@ static int verify_info_level(int info_level)
 	case SMB_FIND_FILE_POSIX_INFO:
 	case FILE_ID_EXTD_DIRECTORY_INFORMATION:
 	case FileId64ExtdDirectoryInformation:
+	case FileId64ExtdBothDirectoryInformation:
 	case FileIdAllExtdBothDirectoryInformation:
 		break;
 	default:
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index bfd0122d972c..571b0e9e35d2 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -169,6 +169,27 @@ struct file_id_64_extd_directory_info {
 	char FileName[];
 } __packed;
 
+/* MS-FSCC 2.4.18 FileId64ExtdBothDirectoryInformation */
+struct file_id_64_extd_both_directory_info {
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
+	__u8 ShortNameLength;
+	__u8 Reserved1;
+	__u8 ShortName[24];
+	char FileName[];
+} __packed;
+
 /* MS-FSCC 2.4.20 FileIdAllExtdBothDirectoryInformation */
 struct file_id_all_extd_both_directory_info {
 	__le32 NextEntryOffset;
-- 
2.25.1

