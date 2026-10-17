Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0027260D
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199981; cv=none; b=j6cjorK0mSzodIFRKcIXJJZrB4ZWaOALFAmIoTLMRRdrLIKeZrKT0n1w6UGV2Hfp++5WwrKUpYCUCGuarpZOCM/103Kt4jPqwSvgUKKS7T7jOnyK0LYnEjCTVnsrXYgFlu1olL85iYzviIgkgkI8k4slMIBU7Zdrvo6b3xJfynQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199981; c=relaxed/simple;
	bh=WUWEufo7LrbWpYNER7eFHY2aNPy8BH8OCv/9IWHrZQc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aEVtiC9cEeZRnm8QNawxItzeDZVeoK685YHKxn0bsR+Svg1abwS54pu0uvuY2iMe2n4+PhOZXCsj+xE4JcVxz5Z/Lf2CterXjTtuHzWL2Bk/syWY5B31ysbRMI+LdjAoM/MXqmzlpG5XtZE14qrUcF9cydWDjhyWrBTqtUZSW0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rp34U5Nx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rp34U5Nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7661F000C4;
	Sat, 17 Oct 2026 01:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199979;
	bh=gmgV1CvwiIfh2Puf9CjOkPW1HuPfPuFDoZFQhXmLbyw=;
	h=From:To:Cc:Subject:Date;
	b=Rp34U5Nx0HRCjm2I8BDpUu6JzwolNYcubceOWtfVD2zArTVWct6Qw2keX8mn5u1aP
	 KaX+FlYdJmbyYxlNqQETy4PlQ1kbPVtkNP2b3sOgKJOdcfn51ExCUEkdI2tbsFQnme
	 BpRsvGCVX4ak1lR3wGFbzPa1HS/li6ukaqQfkXWwG2V1haZqUlYj68had6o5/wRHuq
	 anQDtGVhBcLfE/qRnml+ZEIIOxD80dM3PCb1VpUtoA+DQaUJ5ZODeT5u9njXV8UJ7/
	 k06CPoyXkpow2vFNCHL1K1Uo3++RuFE8YbNjMc2enj035OknL/IjU5orEdzuPr08yB
	 9X31mioXuyvEQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: support FileIdAllExtdBothDirectoryInformation
Date: Sat, 17 Oct 2026 10:19:28 +0900
Message-Id: <20261017011932.14912-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Windows SMB clients can request FileIdAllExtdBothDirectoryInformation
(0x51) when enumerating a directory. ksmbd does not implement this
format, requiring the client to retry with an older information class.

Add the packed FILE_ID_ALL_EXTD_BOTH_DIR_INFORMATION wire layout from
MS-FSCC section 2.4.20 and support it throughout directory entry
reservation, name retrieval and response encoding. Include the
reparse tag separately from EaSize and retain the file attributes
when marking special files as reparse points.

Use the inode number for the 64-bit file ID, as for existing directory
classes. Set the 128-bit ID to zero because the VFS stat data does not
provide one, as required by MS-FSCC. Return no short name and zero
reserved fields and alignment padding.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c    | 51 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.h | 22 ++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 07e2ef56848e..4d0ced8e1f94 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5444,6 +5444,8 @@ static int readdir_info_level_struct_sz(int info_level)
 		return sizeof(FILE_ID_FULL_DIR_INFO);
 	case FILEID_BOTH_DIRECTORY_INFORMATION:
 		return sizeof(struct file_id_both_directory_info);
+	case FileIdAllExtdBothDirectoryInformation:
+		return sizeof(struct file_id_all_extd_both_directory_info);
 	case SMB_FIND_FILE_POSIX_INFO:
 		return sizeof(struct smb2_posix_info);
 	default:
@@ -5514,6 +5516,16 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 		d_info->name_len = le32_to_cpu(fibdinfo->FileNameLength);
 		return 0;
 	}
+	case FileIdAllExtdBothDirectoryInformation:
+	{
+		struct file_id_all_extd_both_directory_info *info;
+
+		info = (struct file_id_all_extd_both_directory_info *)d_info->rptr;
+		d_info->rptr += le32_to_cpu(info->NextEntryOffset);
+		d_info->name = info->FileName;
+		d_info->name_len = le32_to_cpu(info->FileNameLength);
+		return 0;
+	}
 	case SMB_FIND_FILE_POSIX_INFO:
 	{
 		struct smb2_posix_info *posix_info;
@@ -5751,6 +5763,33 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		fibdinfo->NextEntryOffset = cpu_to_le32(next_entry_offset);
 		break;
 	}
+	case FileIdAllExtdBothDirectoryInformation:
+	{
+		struct file_id_all_extd_both_directory_info *info;
+
+		info = (struct file_id_all_extd_both_directory_info *)kstat;
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
 	case SMB_FIND_FILE_POSIX_INFO:
 	{
 		struct smb2_posix_info *posix_info;
@@ -5997,6 +6036,17 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 		fibdinfo->NextEntryOffset = cpu_to_le32(next_entry_offset);
 		break;
 	}
+	case FileIdAllExtdBothDirectoryInformation:
+	{
+		struct file_id_all_extd_both_directory_info *info;
+
+		info = (struct file_id_all_extd_both_directory_info *)d_info->wptr;
+		memcpy(info->FileName, d_info->name, d_info->name_len);
+		info->FileName[d_info->name_len] = 0x00;
+		info->FileNameLength = cpu_to_le32(d_info->name_len);
+		info->NextEntryOffset = cpu_to_le32(next_entry_offset);
+		break;
+	}
 	case SMB_FIND_FILE_POSIX_INFO:
 	{
 		struct smb2_posix_info *posix_info;
@@ -6058,6 +6108,7 @@ static int verify_info_level(int info_level)
 	case FILEID_FULL_DIRECTORY_INFORMATION:
 	case FILEID_BOTH_DIRECTORY_INFORMATION:
 	case SMB_FIND_FILE_POSIX_INFO:
+	case FileIdAllExtdBothDirectoryInformation:
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 7b9c5cfcb63b..6ccfdee3ab19 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -133,6 +133,28 @@ struct file_id_both_directory_info {
 	char FileName[];
 } __packed;
 
+/* MS-FSCC 2.4.20 FileIdAllExtdBothDirectoryInformation */
+struct file_id_all_extd_both_directory_info {
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
+	__u8 ShortNameLength;
+	__u8 Reserved1;
+	__u8 ShortName[24];
+	char FileName[];
+} __packed;
+
 struct smb_version_ops {
 	u16 (*get_cmd_val)(struct ksmbd_work *swork);
 	void (*inc_reqs)(unsigned int cmd, __le32 status);
-- 
2.25.1

