Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB46F26ED27
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068770; cv=none; b=Thm3Kj1U8t14Jqgo+Fw/5eOy41fV81nZsi/y7lzyIK0I6QoHFM89xVKvWiKL7dYc5q7V6xTG8rsRhcQKNGDK/9UqtlM+biG+YvlWZcYTI1Cg1rZBDbkkGryfrIOvu9L0d1zazczNLpuTvOQWM+kDikKgGH7A1PtgCW8DhGvKeuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068770; c=relaxed/simple;
	bh=o+RlPZptq5KODI8OAErhAOJ/TqkXvxVDL0vf3/acYRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQjvLJqU69Hhv1POzmt1oxqT1rCqx0bpRAwjbJsK1T6We9lVv11gUSfADd4BbKGSfa20wjOXXEdKCZEEXUbANuWAYAdQy2GqzutWuFo9F2Ge35qN8uAbNuHs35vi3NhZb03mI2Y6eKH0hk17kGnqtsFZCXX/Ei3tGfwhHKDvNbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rWQ7I21l; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rWQ7I21l"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y7/ugo/v3Xsh3P8Lkxresj8soX9mhOIhRrSKUwQsdj4=;
	b=rWQ7I21loCoiwTtROUmCFRe7FVSTZvlhTfOp9z2n9l3KAzFbDY/G6noY1ZI7lJ6pBLxuMZ
	UZwPJ/hSuaw40eET+vSZTvAMYxWb9UnAzc2o3fOPJQPLDediAg4uMDOEupJEyM/DjoOL2F
	EJ/lO6znnmOJ5HGDzG2TjAT3685gcJ0=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 10/14] smb: move some duplicate struct definitions to common/fscc.h
Date: Sun,  2 Nov 2025 15:30:55 +0800
Message-ID: <20251102073059.3681026-11-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Modify the following places:

  - smb2_file_ntwrk_info -> smb2_file_network_open_info
  - struct filesystem_device_info -> FILE_SYSTEM_DEVICE_INFO
  - struct file_directory_info -> FILE_DIRECTORY_INFO
  - struct file_full_directory_info -> FILE_FULL_DIRECTORY_INFO
  - struct file_both_directory_info -> FILE_BOTH_DIRECTORY_INFO
  - struct file_id_full_dir_info -> FILE_ID_FULL_DIR_INFO
  - struct filesystem_posix_info -> FILE_SYSTEM_POSIX_INFO

The fields of these structures are exactly the same on both client and
server, so move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    |  91 -----------------------------
 fs/smb/client/inode.c      |   4 +-
 fs/smb/client/readdir.c    |   2 +-
 fs/smb/client/smb2pdu.c    |   2 +-
 fs/smb/client/smb2pdu.h    |  13 -----
 fs/smb/common/fscc.h       | 115 +++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.c    |  72 +++++++++++------------
 fs/smb/server/smb2pdu.h    |  11 ----
 fs/smb/server/smb_common.h |  92 -----------------------------
 fs/smb/server/vfs.c        |   2 +-
 10 files changed, 156 insertions(+), 248 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 7816bd3da8d7..39f431051860 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2036,28 +2036,6 @@ typedef struct {
 
 #define CIFS_POSIX_EXTENSIONS           0x00000010 /* support for new QFSInfo */
 
-typedef struct {
-	/* For undefined recommended transfer size return -1 in that field */
-	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
-	__le32 BlockSize;
-    /* The next three fields are in terms of the block size.
-	(above). If block size is unknown, 4096 would be a
-	reasonable block size for a server to report.
-	Note that returning the blocks/blocksavail removes need
-	to make a second call (to QFSInfo level 0x103 to get this info.
-	UserBlockAvail is typically less than or equal to BlocksAvail,
-	if no distinction is made return the same value in each */
-	__le64 TotalBlocks;
-	__le64 BlocksAvail;       /* bfree */
-	__le64 UserBlocksAvail;   /* bavail */
-    /* For undefined Node fields or FSID return -1 */
-	__le64 TotalFileNodes;
-	__le64 FreeFileNodes;
-	__le64 FileSysIdentifier;   /* fsid */
-	/* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
-	/* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
-} __attribute__((packed)) FILE_SYSTEM_POSIX_INFO;
-
 /* DeviceType Flags */
 #define FILE_DEVICE_CD_ROM              0x00000002
 #define FILE_DEVICE_CD_ROM_FILE_SYSTEM  0x00000003
@@ -2092,11 +2070,6 @@ typedef struct {
 #define FILE_PORTABLE_DEVICE			0x00004000
 #define FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL 0x00020000
 
-typedef struct {
-	__le32 DeviceType;
-	__le32 DeviceCharacteristics;
-} __attribute__((packed)) FILE_SYSTEM_DEVICE_INFO; /* device info level 0x104 */
-
 /* minimum includes first three fields, and empty FS Name */
 #define MIN_FS_ATTR_INFO_SIZE 12
 
@@ -2332,70 +2305,6 @@ typedef struct {
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
-	char FileName[];
-} __attribute__((packed)) FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
-
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
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index cac355364e43..c2ac39d89df2 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1328,7 +1328,7 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 			/* for easier reading */
 			FILE_ALL_INFO *fi;
 			FILE_DIRECTORY_INFO *fdi;
-			SEARCH_ID_FULL_DIR_INFO *si;
+			FILE_ID_FULL_DIR_INFO *si;
 
 			rc = cifs_backup_query_path_info(xid, tcon, sb,
 							 full_path,
@@ -1339,7 +1339,7 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 
 			move_cifs_info_to_smb2(&data->fi, fi);
 			fdi = (FILE_DIRECTORY_INFO *)fi;
-			si = (SEARCH_ID_FULL_DIR_INFO *)fi;
+			si = (FILE_ID_FULL_DIR_INFO *)fi;
 
 			cifs_dir_info_to_fattr(fattr, fdi, cifs_sb);
 			fattr->cf_uniqueid = le64_to_cpu(si->UniqueId);
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index f0ce26622a14..2fd95c1e91ab 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -548,7 +548,7 @@ static void cifs_fill_dirent_full(struct cifs_dirent *de,
 }
 
 static void cifs_fill_dirent_search(struct cifs_dirent *de,
-		const SEARCH_ID_FULL_DIR_INFO *info)
+		const FILE_ID_FULL_DIR_INFO *info)
 {
 	de->name = &info->FileName[0];
 	de->namelen = le32_to_cpu(info->FileNameLength);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c1f67864c84b..db7ea0ff4c05 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5451,7 +5451,7 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 		info_buf_size = sizeof(FILE_DIRECTORY_INFO);
 		break;
 	case SMB_FIND_FILE_ID_FULL_DIR_INFO:
-		info_buf_size = sizeof(SEARCH_ID_FULL_DIR_INFO);
+		info_buf_size = sizeof(FILE_ID_FULL_DIR_INFO);
 		break;
 	case SMB_FIND_FILE_POSIX_INFO:
 		/* note that posix payload are variable size */
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 98ed7a22cd57..78bb99f29d38 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -224,19 +224,6 @@ struct smb2_file_reparse_point_info {
 	__le32 Tag;
 } __packed;
 
-struct smb2_file_network_open_info {
-	struct_group_attr(network_open_info, __packed,
-		__le64 CreationTime;
-		__le64 LastAccessTime;
-		__le64 LastWriteTime;
-		__le64 ChangeTime;
-		__le64 AllocationSize;
-		__le64 EndOfFile;
-		__le32 Attributes;
-	);
-	__le32 Reserved;
-} __packed; /* level 34 Query also similar returned in close rsp and open rsp */
-
 /* See MS-FSCC 2.4.21 */
 struct smb2_file_id_information {
 	__le64	VolumeSerialNumber;
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index c8bfb87232ac..6fa7c65d304b 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -12,6 +12,88 @@
 #ifndef _COMMON_SMB_FSCC_H
 #define _COMMON_SMB_FSCC_H
 
+/* See MS-FSCC 2.4.8 */
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
+} __packed FILE_BOTH_DIRECTORY_INFO; /* level 0x104 FFrsp data */
+
+/* See MS-FSCC 2.4.10 */
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
+/* See MS-FSCC 2.4.14 */
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
+	char FileName[];
+} __packed FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
+
+/* See MS-FSCC 2.4.24 */
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
+} __packed FILE_ID_FULL_DIR_INFO; /* level 0x105 FF rsp data */
+
+/* See MS-FSCC 2.4.34 */
+struct smb2_file_network_open_info {
+	struct_group_attr(network_open_info, __packed,
+		__le64 CreationTime;
+		__le64 LastAccessTime;
+		__le64 LastWriteTime;
+		__le64 ChangeTime;
+		__le64 AllocationSize;
+		__le64 EndOfFile;
+		__le32 Attributes;
+	);
+	__le32 Reserved;
+} __packed; /* level 34 Query also similar returned in close rsp and open rsp */
+
 /* List of FileSystemAttributes - see MS-FSCC 2.5.1 */
 #define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
 #define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
@@ -39,4 +121,37 @@
 #define FILE_CASE_PRESERVED_NAMES	0x00000002
 #define FILE_CASE_SENSITIVE_SEARCH	0x00000001
 
+/* See MS-FSCC 2.5.10 */
+typedef struct {
+	__le32 DeviceType;
+	__le32 DeviceCharacteristics;
+} __packed FILE_SYSTEM_DEVICE_INFO; /* device info level 0x104 */
+
+/*
+ * See POSIX Extensions to MS-FSCC 2.3.2.1
+ * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/fscc_posix_extensions.md
+ */
+typedef struct {
+	/* For undefined recommended transfer size return -1 in that field */
+	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
+	__le32 BlockSize;
+	/* The next three fields are in terms of the block size.
+	 * (above). If block size is unknown, 4096 would be a
+	 * reasonable block size for a server to report.
+	 * Note that returning the blocks/blocksavail removes need
+	 * to make a second call (to QFSInfo level 0x103 to get this info.
+	 * UserBlockAvail is typically less than or equal to BlocksAvail,
+	 * if no distinction is made return the same value in each
+	 */
+	__le64 TotalBlocks;
+	__le64 BlocksAvail;       /* bfree */
+	__le64 UserBlocksAvail;   /* bavail */
+	/* For undefined Node fields or FSID return -1 */
+	__le64 TotalFileNodes;
+	__le64 FreeFileNodes;
+	__le64 FileSysIdentifier;   /* fsid */
+	/* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
+	/* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
+} __packed FILE_SYSTEM_POSIX_INFO;
+
 #endif /* _COMMON_SMB_FSCC_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 3c2ddf0da344..541732208c37 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3796,15 +3796,15 @@ static int readdir_info_level_struct_sz(int info_level)
 {
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
-		return sizeof(struct file_full_directory_info);
+		return sizeof(FILE_FULL_DIRECTORY_INFO);
 	case FILE_BOTH_DIRECTORY_INFORMATION:
-		return sizeof(struct file_both_directory_info);
+		return sizeof(FILE_BOTH_DIRECTORY_INFO);
 	case FILE_DIRECTORY_INFORMATION:
-		return sizeof(struct file_directory_info);
+		return sizeof(FILE_DIRECTORY_INFO);
 	case FILE_NAMES_INFORMATION:
 		return sizeof(struct file_names_info);
 	case FILEID_FULL_DIRECTORY_INFORMATION:
-		return sizeof(struct file_id_full_dir_info);
+		return sizeof(FILE_ID_FULL_DIR_INFO);
 	case FILEID_BOTH_DIRECTORY_INFORMATION:
 		return sizeof(struct file_id_both_directory_info);
 	case SMB_FIND_FILE_POSIX_INFO:
@@ -3819,9 +3819,9 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_full_directory_info *ffdinfo;
+		FILE_FULL_DIRECTORY_INFO *ffdinfo;
 
-		ffdinfo = (struct file_full_directory_info *)d_info->rptr;
+		ffdinfo = (FILE_FULL_DIRECTORY_INFO *)d_info->rptr;
 		d_info->rptr += le32_to_cpu(ffdinfo->NextEntryOffset);
 		d_info->name = ffdinfo->FileName;
 		d_info->name_len = le32_to_cpu(ffdinfo->FileNameLength);
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
@@ -3859,9 +3859,9 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 	}
 	case FILEID_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_id_full_dir_info *dinfo;
+		FILE_ID_FULL_DIR_INFO *dinfo;
 
-		dinfo = (struct file_id_full_dir_info *)d_info->rptr;
+		dinfo = (FILE_ID_FULL_DIR_INFO *)d_info->rptr;
 		d_info->rptr += le32_to_cpu(dinfo->NextEntryOffset);
 		d_info->name = dinfo->FileName;
 		d_info->name_len = le32_to_cpu(dinfo->FileNameLength);
@@ -3944,9 +3944,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_full_directory_info *ffdinfo;
+		FILE_FULL_DIRECTORY_INFO *ffdinfo;
 
-		ffdinfo = (struct file_full_directory_info *)kstat;
+		ffdinfo = (FILE_FULL_DIRECTORY_INFO *)kstat;
 		ffdinfo->FileNameLength = cpu_to_le32(conv_len);
 		ffdinfo->EaSize =
 			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
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
@@ -4000,9 +4000,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 	}
 	case FILEID_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_id_full_dir_info *dinfo;
+		FILE_ID_FULL_DIR_INFO *dinfo;
 
-		dinfo = (struct file_id_full_dir_info *)kstat;
+		dinfo = (FILE_ID_FULL_DIR_INFO *)kstat;
 		dinfo->FileNameLength = cpu_to_le32(conv_len);
 		dinfo->EaSize =
 			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
@@ -4206,9 +4206,9 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_full_directory_info *ffdinfo;
+		FILE_FULL_DIRECTORY_INFO *ffdinfo;
 
-		ffdinfo = (struct file_full_directory_info *)d_info->wptr;
+		ffdinfo = (FILE_FULL_DIRECTORY_INFO *)d_info->wptr;
 		memcpy(ffdinfo->FileName, d_info->name, d_info->name_len);
 		ffdinfo->FileName[d_info->name_len] = 0x00;
 		ffdinfo->FileNameLength = cpu_to_le32(d_info->name_len);
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
@@ -4250,9 +4250,9 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 	}
 	case FILEID_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_id_full_dir_info *dinfo;
+		FILE_ID_FULL_DIR_INFO *dinfo;
 
-		dinfo = (struct file_id_full_dir_info *)d_info->wptr;
+		dinfo = (FILE_ID_FULL_DIR_INFO *)d_info->wptr;
 		memcpy(dinfo->FileName, d_info->name, d_info->name_len);
 		dinfo->FileName[d_info->name_len] = 0x00;
 		dinfo->FileNameLength = cpu_to_le32(d_info->name_len);
@@ -4514,7 +4514,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 			goto err_out;
 	} else {
 no_buf_len:
-		((struct file_directory_info *)
+		((FILE_DIRECTORY_INFO *)
 		((char *)rsp->Buffer + d_info.last_entry_offset))
 		->NextEntryOffset = 0;
 		if (d_info.data_count >= d_info.last_entry_off_align)
@@ -5133,7 +5133,7 @@ static int get_file_internal_info(struct smb2_query_info_rsp *rsp,
 static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 				      struct ksmbd_file *fp, void *rsp_org)
 {
-	struct smb2_file_ntwrk_info *file_info;
+	struct smb2_file_network_open_info *file_info;
 	struct kstat stat;
 	u64 time;
 	int ret;
@@ -5149,7 +5149,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	if (ret)
 		return ret;
 
-	file_info = (struct smb2_file_ntwrk_info *)rsp->Buffer;
+	file_info = (struct smb2_file_network_open_info *)rsp->Buffer;
 
 	file_info->CreationTime = cpu_to_le64(fp->create_time);
 	time = ksmbd_UnixTimeToNT(stat.atime);
@@ -5168,7 +5168,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	}
 	file_info->Reserved = cpu_to_le32(0);
 	rsp->OutputBufferLength =
-		cpu_to_le32(sizeof(struct smb2_file_ntwrk_info));
+		cpu_to_le32(sizeof(struct smb2_file_network_open_info));
 	return 0;
 }
 
@@ -5476,9 +5476,9 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	switch (fsinfoclass) {
 	case FS_DEVICE_INFORMATION:
 	{
-		struct filesystem_device_info *info;
+		FILE_SYSTEM_DEVICE_INFO *info;
 
-		info = (struct filesystem_device_info *)rsp->Buffer;
+		info = (FILE_SYSTEM_DEVICE_INFO *)rsp->Buffer;
 
 		info->DeviceType = cpu_to_le32(FILE_DEVICE_DISK);
 		info->DeviceCharacteristics =
@@ -5633,14 +5633,14 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	case FS_POSIX_INFORMATION:
 	{
-		struct filesystem_posix_info *info;
+		FILE_SYSTEM_POSIX_INFO *info;
 
 		if (!work->tcon->posix_extensions) {
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
 			path_put(&path);
 			return -EOPNOTSUPP;
 		} else {
-			info = (struct filesystem_posix_info *)(rsp->Buffer);
+			info = (FILE_SYSTEM_POSIX_INFO *)(rsp->Buffer);
 			info->OptimalTransferSize = cpu_to_le32(stfs.f_bsize);
 			info->BlockSize = cpu_to_le32(stfs.f_bsize);
 			info->TotalBlocks = cpu_to_le64(stfs.f_blocks);
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index acaf5955eec1..66cdc8e4a648 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -205,17 +205,6 @@ struct smb2_file_stream_info {
 	char   StreamName[];
 } __packed;
 
-struct smb2_file_ntwrk_info {
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 AllocationSize;
-	__le64 EndOfFile;
-	__le32 Attributes;
-	__le32 Reserved;
-} __packed;
-
 struct smb2_file_standard_info {
 	__le64 AllocationSize;
 	__le64 EndOfFile;
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index a6004338c6c3..576c2ce591a5 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -104,11 +104,6 @@ struct filesystem_attribute_info {
 	__le16 FileSystemName[]; /* do not have to save this - get subset? */
 } __packed;
 
-struct filesystem_device_info {
-	__le32 DeviceType;
-	__le32 DeviceCharacteristics;
-} __packed; /* device info level 0x104 */
-
 struct filesystem_vol_info {
 	__le64 VolumeCreationTime;
 	__le32 SerialNumber;
@@ -140,20 +135,6 @@ struct object_id_info {
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
@@ -161,39 +142,6 @@ struct file_names_info {
 	char FileName[];
 } __packed;   /* level 0xc FF resp data */
 
-struct file_full_directory_info {
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
-	__le32 EaSize;
-	char FileName[];
-} __packed; /* level 0x102 FF resp */
-
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
@@ -214,46 +162,6 @@ struct file_id_both_directory_info {
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
-struct filesystem_posix_info {
-	/* For undefined recommended transfer size return -1 in that field */
-	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
-	__le32 BlockSize;
-	/* The next three fields are in terms of the block size.
-	 * (above). If block size is unknown, 4096 would be a
-	 * reasonable block size for a server to report.
-	 * Note that returning the blocks/blocksavail removes need
-	 * to make a second call (to QFSInfo level 0x103 to get this info.
-	 * UserBlockAvail is typically less than or equal to BlocksAvail,
-	 * if no distinction is made return the same value in each
-	 */
-	__le64 TotalBlocks;
-	__le64 BlocksAvail;       /* bfree */
-	__le64 UserBlocksAvail;   /* bavail */
-	/* For undefined Node fields or FSID return -1 */
-	__le64 TotalFileNodes;
-	__le64 FreeFileNodes;
-	__le64 FileSysIdentifier;   /* fsid */
-	/* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
-	/* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
-} __packed;
-
 struct smb_version_ops {
 	u16 (*get_cmd_val)(struct ksmbd_work *swork);
 	int (*init_rsp_hdr)(struct ksmbd_work *swork);
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

