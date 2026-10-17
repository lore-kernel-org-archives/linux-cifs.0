Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD127260D
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199991; cv=none; b=J/wkEDK9X2vSRP7ao91gMgy1Tip0jT1KRE/ejMh6uKhhZtB7Huc2t9DvAmUnb8zMWJnGbgM8YWI3WnWa6yIUGbUBbId9spJ/qu+wZjvoNrWDj5WZ31VdHt+Bxp4ZVcByM6Fl+8x9tiIKOB3PS6XG/ELmRmiv9D/k186wl2XPakA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199991; c=relaxed/simple;
	bh=llSzyr2F4Dx8ABSmRlwKrBSp99CiocNgdWaMQpeHWOc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=omSnhOVd6QXXRd7Vx2GF/hJHTIXXCIz6eFmuoOWTT+HAWfLY9BBvFfaUiMzF6VkaGPeWyV5/aYpFbehuxWP4kii5ozNBgBvBlCRcilEC+rsQz9j1Io/rgE0RcpEC5IKfOd5vONHhVjRLokE6VSPvwl6rE5eLtSC3X7ZNTSEkxoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXzE1ZpS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXzE1ZpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703981F000C4;
	Sat, 17 Oct 2026 01:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199989;
	bh=sIYmt+TnHgOuzp0KMs/rj8SopA12Xq2KwF+2W5aq5+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXzE1ZpSpTD+asPLB8XW36vYT/mGfu+TdcdTB2TPZU+ai3/BmCf3+Pi67D2rmSDp0
	 eGVsNpa+8q6HrhnjMhs6SCyAhZ565lEh6rfNOuRO8zQvjBee6Hw69CGYwnjM93tAKe
	 JWjwdjwswltXv5j1CSXBVslk96xYqPcOJxpJHradGopiFWMnQxF7cUXWTxbl39RyK8
	 JuhUPvAmG0e8JhiC12YvqixDIVfCdUvpQLdkQXX4DY1h79zMaj7BaKxVUakul8XmvL
	 uJ4Xu6AEzau3rIx/0sEl4YJF0G5ZCj/vU0sWqKGpJjVXlOrgoSqNcZLIur18yNjl3C
	 U6zkcLncypvQA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: support FileIdAllExtdDirectoryInformation
Date: Sat, 17 Oct 2026 10:19:32 +0900
Message-Id: <20261017011932.14912-5-linkinjeon@kernel.org>
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

Handle FileIdAllExtdDirectoryInformation (0x50) in SMB2 QUERY_DIRECTORY.
Add the packed wire layout specified by MS-FSCC 2.4.21 and support
this class in entry reservation, filename lookup and response encoding.

Use the VFS inode number for the 64-bit file ID and retain the existing
Apple extension behavior of returning a zero ID. Zero the 128-bit file
ID because the VFS provides only a 64-bit inode number, as permitted by
the specification. Report reparse tags separately from the EA size, set
the reparse flag without changing other file attributes, and initialize
entry padding.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c    | 48 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.h | 19 +++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2c0378d306a8..32fd06171cdd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5450,6 +5450,8 @@ static int readdir_info_level_struct_sz(int info_level)
 		return sizeof(struct file_id_64_extd_directory_info);
 	case FileId64ExtdBothDirectoryInformation:
 		return sizeof(struct file_id_64_extd_both_directory_info);
+	case FileIdAllExtdDirectoryInformation:
+		return sizeof(struct file_id_all_extd_directory_info);
 	case FileIdAllExtdBothDirectoryInformation:
 		return sizeof(struct file_id_all_extd_both_directory_info);
 	case SMB_FIND_FILE_POSIX_INFO:
@@ -5552,6 +5554,16 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 		d_info->name_len = le32_to_cpu(info->FileNameLength);
 		return 0;
 	}
+	case FileIdAllExtdDirectoryInformation:
+	{
+		struct file_id_all_extd_directory_info *info;
+
+		info = (struct file_id_all_extd_directory_info *)d_info->rptr;
+		d_info->rptr += le32_to_cpu(info->NextEntryOffset);
+		d_info->name = info->FileName;
+		d_info->name_len = le32_to_cpu(info->FileNameLength);
+		return 0;
+	}
 	case FileIdAllExtdBothDirectoryInformation:
 	{
 		struct file_id_all_extd_both_directory_info *info;
@@ -5866,6 +5878,30 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
 		break;
 	}
+	case FileIdAllExtdDirectoryInformation:
+	{
+		struct file_id_all_extd_directory_info *info;
+
+		info = (struct file_id_all_extd_directory_info *)kstat;
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
+		/* The VFS does not provide a 128-bit file ID. */
+		memset(info->FileId128, 0, sizeof(info->FileId128));
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
@@ -6172,6 +6208,17 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
 		break;
 	}
+	case FileIdAllExtdDirectoryInformation:
+	{
+		struct file_id_all_extd_directory_info *info;
+
+		info = (struct file_id_all_extd_directory_info *)d_info->wptr;
+		memcpy(info->FileName, d_info->name, d_info->name_len);
+		info->FileName[d_info->name_len] = 0x00;
+		info->FileNameLength = cpu_to_le32(d_info->name_len);
+		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
+		break;
+	}
 	case FileIdAllExtdBothDirectoryInformation:
 	{
 		struct file_id_all_extd_both_directory_info *info;
@@ -6247,6 +6294,7 @@ static int verify_info_level(int info_level)
 	case FILE_ID_EXTD_DIRECTORY_INFORMATION:
 	case FileId64ExtdDirectoryInformation:
 	case FileId64ExtdBothDirectoryInformation:
+	case FileIdAllExtdDirectoryInformation:
 	case FileIdAllExtdBothDirectoryInformation:
 		break;
 	default:
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 571b0e9e35d2..a9cc09e31721 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -190,6 +190,25 @@ struct file_id_64_extd_both_directory_info {
 	char FileName[];
 } __packed;
 
+/* MS-FSCC 2.4.21 FileIdAllExtdDirectoryInformation */
+struct file_id_all_extd_directory_info {
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
+	__u8 FileId128[16];
+	char FileName[];
+} __packed;
+
 /* MS-FSCC 2.4.20 FileIdAllExtdBothDirectoryInformation */
 struct file_id_all_extd_both_directory_info {
 	__le32 NextEntryOffset;
-- 
2.25.1

