Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A32E26F443
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 01:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242732; cv=none; b=Hrw6ORZ9fChY8r+744/3z145KqsiVmX9oA0LouwXh1K+BulyPxLUK9pHnyllHoxVN+4xZF6mplwRkCzp6wbmiv7MWQdUe4juRsosZ7998BcgTMD+G1B2XLAC1IjY1YdCOr+c1q5URvlWPtIQaJpOofff1BKNnshYVgRapGqCDOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242732; c=relaxed/simple;
	bh=29qtEzTo++wHYO1elddyiIlD9ws+ZZ72DUygWztxbMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvAsJnH9+UCH+3RPn+YpURhTdiZyyP35Ot1M3mKrGbD0y862eslnFjV1p3xVi6qT7ltsBdAj1hUd0pcdPZQ7UsiJ5ucPfyQxslVK1mNsYC9NYE7FkxvQo0i7HQHs+gmF/ZQt2Y4yyfb2p+L1vU80L9UbvUr5Al/L9cFM1K+27Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wl/Q7Z1/; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wl/Q7Z1/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8oBD+M/h1t11NfY8OSFEWhGcVHkSR7tMa+K775DN008=;
	b=Wl/Q7Z1/8fwijHq4qgANGSithsAbRoT+91ylw+ZMj7emSVBCqRt7HLsEgffuwPjeuA9ylF
	QZQRhcsGwnyWknMAXeUTDkPmmuJFOA4l0RGuohJeVDxgXMLtadeHpGl53trFu4t1c+/8C5
	MY+YdDZB0pRost+Kd1kawiIixNgFjiY=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 09/13] smb: move some definitions from common/smb2pdu.h into common/fscc.h
Date: Tue,  9 Dec 2025 09:10:15 +0800
Message-ID: <20251209011020.3270989-10-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

These definitions are specified in MS-FSCC, so move them into fscc.h.

Only add some documentation references, no other changes.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/common/fscc.h    | 316 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/common/smb2pdu.h | 307 --------------------------------------
 2 files changed, 316 insertions(+), 307 deletions(-)

diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index bd1e0824ac4a..0129246d1d78 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -12,6 +12,210 @@
 #ifndef _COMMON_SMB_FSCC_H
 #define _COMMON_SMB_FSCC_H
 
+/* Reparse structures - see MS-FSCC 2.1.2 */
+
+/* struct fsctl_reparse_info_req is empty, only response structs (see below) */
+struct reparse_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__u16	Reserved;
+	__u8	DataBuffer[]; /* Variable Length */
+} __packed;
+
+struct reparse_guid_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__u16	Reserved;
+	__u8	ReparseGuid[16];
+	__u8	DataBuffer[]; /* Variable Length */
+} __packed;
+
+struct reparse_mount_point_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__u16	Reserved;
+	__le16	SubstituteNameOffset;
+	__le16	SubstituteNameLength;
+	__le16	PrintNameOffset;
+	__le16	PrintNameLength;
+	__u8	PathBuffer[]; /* Variable Length */
+} __packed;
+
+#define SYMLINK_FLAG_RELATIVE 0x00000001
+
+struct reparse_symlink_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__u16	Reserved;
+	__le16	SubstituteNameOffset;
+	__le16	SubstituteNameLength;
+	__le16	PrintNameOffset;
+	__le16	PrintNameLength;
+	__le32	Flags;
+	__u8	PathBuffer[]; /* Variable Length */
+} __packed;
+
+/* For IO_REPARSE_TAG_NFS - see MS-FSCC 2.1.2.6 */
+#define NFS_SPECFILE_LNK	0x00000000014B4E4C
+#define NFS_SPECFILE_CHR	0x0000000000524843
+#define NFS_SPECFILE_BLK	0x00000000004B4C42
+#define NFS_SPECFILE_FIFO	0x000000004F464946
+#define NFS_SPECFILE_SOCK	0x000000004B434F53
+struct reparse_nfs_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__u16	Reserved;
+	__le64	InodeType; /* NFS_SPECFILE_* */
+	__u8	DataBuffer[];
+} __packed;
+
+/* For IO_REPARSE_TAG_LX_SYMLINK - see MS-FSCC 2.1.2.7 */
+struct reparse_wsl_symlink_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__u16	Reserved;
+	__le32	Version; /* Always 2 */
+	__u8	Target[]; /* Variable Length UTF-8 string without nul-term */
+} __packed;
+
+/* See MS-FSCC 2.3.7 */
+struct duplicate_extents_to_file {
+	__u64 PersistentFileHandle; /* source file handle, opaque endianness */
+	__u64 VolatileFileHandle;
+	__le64 SourceFileOffset;
+	__le64 TargetFileOffset;
+	__le64 ByteCount;  /* Bytes to be copied */
+} __packed;
+
+/* See MS-FSCC 2.3.9 */
+#define DUPLICATE_EXTENTS_DATA_EX_SOURCE_ATOMIC	0x00000001
+struct duplicate_extents_to_file_ex {
+	__u64 StructureSize; /* MUST be set to 0x30 */
+	__u64 PersistentFileHandle; /* source file handle, opaque endianness */
+	__u64 VolatileFileHandle;
+	__le64 SourceFileOffset;
+	__le64 TargetFileOffset;
+	__le64 ByteCount;  /* Bytes to be copied */
+	__le32 Flags;
+	__le32 Reserved;
+} __packed;
+
+/* See MS-FSCC 2.3.20 */
+struct fsctl_get_integrity_information_rsp {
+	__le16	ChecksumAlgorithm;
+	__le16	Reserved;
+	__le32	Flags;
+	__le32	ChecksumChunkSizeInBytes;
+	__le32	ClusterSizeInBytes;
+} __packed;
+
+/* See MS-FSCC 2.3.52 */
+struct file_allocated_range_buffer {
+	__le64	file_offset;
+	__le64	length;
+} __packed;
+
+/* See MS-FSCC 2.3.55 */
+struct fsctl_query_file_regions_req {
+	__le64	FileOffset;
+	__le64	Length;
+	__le32	DesiredUsage;
+	__le32	Reserved;
+} __packed;
+
+/* See MS-FSCC 2.3.56.1 */
+#define FILE_USAGE_INVALID_RANGE	0x00000000
+#define FILE_USAGE_VALID_CACHED_DATA	0x00000001
+#define FILE_USAGE_NONCACHED_DATA	0x00000002
+struct file_region_info {
+	__le64	FileOffset;
+	__le64	Length;
+	__le32	DesiredUsage;
+	__le32	Reserved;
+} __packed;
+
+/* See MS-FSCC 2.3.56 */
+struct fsctl_query_file_region_rsp {
+	__le32 Flags;
+	__le32 TotalRegionEntryCount;
+	__le32 RegionEntryCount;
+	__u32  Reserved;
+	struct  file_region_info Regions[];
+} __packed;
+
+/* See MS-FSCC 2.3.58 */
+struct fsctl_query_on_disk_vol_info_rsp {
+	__le64	DirectoryCount;
+	__le64	FileCount;
+	__le16	FsFormatMajVersion;
+	__le16	FsFormatMinVersion;
+	__u8	FsFormatName[24];
+	__le64	FormatTime;
+	__le64	LastUpdateTime;
+	__u8	CopyrightInfo[68];
+	__u8	AbstractInfo[68];
+	__u8	FormatImplInfo[68];
+	__u8	LastModifyImplInfo[68];
+} __packed;
+
+/* See MS-FSCC 2.3.73 */
+struct fsctl_set_integrity_information_req {
+	__le16	ChecksumAlgorithm;
+	__le16	Reserved;
+	__le32	Flags;
+} __packed;
+
+/* See MS-FSCC 2.3.75 */
+struct fsctl_set_integrity_info_ex_req {
+	__u8	EnableIntegrity;
+	__u8	KeepState;
+	__u16	Reserved;
+	__le32	Flags;
+	__u8	Version;
+	__u8	Reserved2[7];
+} __packed;
+
+/*
+ * this goes in the ioctl buffer when doing FSCTL_SET_ZERO_DATA
+ * See MS-FSCC 2.3.85
+ */
+struct file_zero_data_information {
+	__le64	FileOffset;
+	__le64	BeyondFinalZero;
+} __packed;
+
+/*
+ * This level 18, although with struct with same name is different from cifs
+ * level 0x107. Level 0x107 has an extra u64 between AccessFlags and
+ * CurrentByteOffset.
+ * See MS-FSCC 2.4.2
+ */
+struct smb2_file_all_info { /* data block encoding of response to level 18 */
+	__le64 CreationTime;	/* Beginning of FILE_BASIC_INFO equivalent */
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le32 Attributes;
+	__u32  Pad1;		/* End of FILE_BASIC_INFO_INFO equivalent */
+	__le64 AllocationSize;	/* Beginning of FILE_STANDARD_INFO equivalent */
+	__le64 EndOfFile;	/* size ie offset to first free byte in file */
+	__le32 NumberOfLinks;	/* hard links */
+	__u8   DeletePending;
+	__u8   Directory;
+	__u16  Pad2;		/* End of FILE_STANDARD_INFO equivalent */
+	__le64 IndexNumber;
+	__le32 EASize;
+	__le32 AccessFlags;
+	__le64 CurrentByteOffset;
+	__le32 Mode;
+	__le32 AlignmentRequirement;
+	__le32 FileNameLength;
+	union {
+		char __pad;	/* Legacy structure padding */
+		DECLARE_FLEX_ARRAY(char, FileName);
+	};
+} __packed; /* level 18 Query */
+
 /* See MS-FSCC 2.4.8 */
 typedef struct {
 	__le32 NextEntryOffset;
@@ -46,6 +250,11 @@ typedef struct {
 	char FileName[];
 } __packed FILE_DIRECTORY_INFO;   /* level 0x101 FF resp data */
 
+/* See MS-FSCC 2.4.13 */
+struct smb2_file_eof_info { /* encoding of request for level 10 */
+	__le64 EndOfFile; /* new end of file value */
+} __packed; /* level 20 Set */
+
 /* See MS-FSCC 2.4.14 */
 typedef struct {
 	__le32 NextEntryOffset;
@@ -80,6 +289,26 @@ typedef struct {
 	char FileName[];
 } __packed FILE_ID_FULL_DIR_INFO; /* level 0x105 FF rsp data */
 
+/* See MS-FSCC 2.4.27 */
+struct smb2_file_internal_info {
+	__le64 IndexNumber;
+} __packed; /* level 6 Query */
+
+/* See MS-FSCC 2.4.28.2 */
+struct smb2_file_link_info { /* encoding of request for level 11 */
+	/* New members MUST be added within the struct_group() macro below. */
+	__struct_group(smb2_file_link_info_hdr, __hdr, __packed,
+		__u8   ReplaceIfExists; /* 1 = replace existing link with new */
+					/* 0 = fail if link already exists */
+		__u8   Reserved[7];
+		__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
+		__le32 FileNameLength;
+	);
+	char   FileName[];     /* Name to be assigned to new link */
+} __packed; /* level 11 Set */
+static_assert(offsetof(struct smb2_file_link_info, FileName) == sizeof(struct smb2_file_link_info_hdr),
+	      "struct member likely outside of __struct_group()");
+
 /* See MS-FSCC 2.4.34 */
 struct smb2_file_network_open_info {
 	struct_group_attr(network_open_info, __packed,
@@ -94,6 +323,37 @@ struct smb2_file_network_open_info {
 	__le32 Reserved;
 } __packed; /* level 34 Query also similar returned in close rsp and open rsp */
 
+/* See MS-FSCC 2.4.42.2 */
+struct smb2_file_rename_info { /* encoding of request for level 10 */
+	/* New members MUST be added within the struct_group() macro below. */
+	__struct_group(smb2_file_rename_info_hdr, __hdr, __packed,
+		__u8   ReplaceIfExists; /* 1 = replace existing target with new */
+					/* 0 = fail if target already exists */
+		__u8   Reserved[7];
+		__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
+		__le32 FileNameLength;
+	);
+	char   FileName[];     /* New name to be assigned */
+	/* padding - overall struct size must be >= 24 so filename + pad >= 6 */
+} __packed; /* level 10 Set */
+static_assert(offsetof(struct smb2_file_rename_info, FileName) == sizeof(struct smb2_file_rename_info_hdr),
+	      "struct member likely outside of __struct_group()");
+
+/* File System Information Classes */
+/* See MS-FSCC 2.5 */
+#define FS_VOLUME_INFORMATION		1 /* Query */
+#define FS_LABEL_INFORMATION		2 /* Set */
+#define FS_SIZE_INFORMATION		3 /* Query */
+#define FS_DEVICE_INFORMATION		4 /* Query */
+#define FS_ATTRIBUTE_INFORMATION	5 /* Query */
+#define FS_CONTROL_INFORMATION		6 /* Query, Set */
+#define FS_FULL_SIZE_INFORMATION	7 /* Query */
+#define FS_OBJECT_ID_INFORMATION	8 /* Query, Set */
+#define FS_DRIVER_PATH_INFORMATION	9 /* Query */
+#define FS_SECTOR_SIZE_INFORMATION	11 /* SMB3 or later. Query */
+/* See POSIX Extensions to MS-FSCC 2.3.1.1 */
+#define FS_POSIX_INFORMATION		100 /* SMB3.1.1 POSIX. Query */
+
 /* See MS-FSCC 2.5.1 */
 #define MAX_FS_NAME_LEN		52
 typedef struct {
@@ -130,6 +390,46 @@ typedef struct {
 #define FILE_CASE_PRESERVED_NAMES	0x00000002
 #define FILE_CASE_SENSITIVE_SEARCH	0x00000001
 
+/*
+ * File System Control Information
+ * See MS-FSCC 2.5.2
+ */
+struct smb2_fs_control_info {
+	__le64 FreeSpaceStartFiltering;
+	__le64 FreeSpaceThreshold;
+	__le64 FreeSpaceStopFiltering;
+	__le64 DefaultQuotaThreshold;
+	__le64 DefaultQuotaLimit;
+	__le32 FileSystemControlFlags;
+	__le32 Padding;
+} __packed;
+
+/* See MS-FSCC 2.5.4 */
+struct smb2_fs_full_size_info {
+	__le64 TotalAllocationUnits;
+	__le64 CallerAvailableAllocationUnits;
+	__le64 ActualAvailableAllocationUnits;
+	__le32 SectorsPerAllocationUnit;
+	__le32 BytesPerSector;
+} __packed;
+
+/* See MS-FSCC 2.5.7 */
+#define SSINFO_FLAGS_ALIGNED_DEVICE		0x00000001
+#define SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE 0x00000002
+#define SSINFO_FLAGS_NO_SEEK_PENALTY		0x00000004
+#define SSINFO_FLAGS_TRIM_ENABLED		0x00000008
+
+/* sector size info struct */
+struct smb3_fs_ss_info {
+	__le32 LogicalBytesPerSector;
+	__le32 PhysicalBytesPerSectorForAtomicity;
+	__le32 PhysicalBytesPerSectorForPerf;
+	__le32 FSEffPhysicalBytesPerSectorForAtomicity;
+	__le32 Flags;
+	__le32 ByteOffsetForSectorAlignment;
+	__le32 ByteOffsetForPartitionAlignment;
+} __packed;
+
 /* See MS-FSCC 2.5.8 */
 typedef struct {
 	__le64 TotalAllocationUnits;
@@ -193,6 +493,22 @@ typedef struct {
 #define FILE_ATTRIBUTE_NO_SCRUB_DATA_LE		cpu_to_le32(FILE_ATTRIBUTE_NO_SCRUB_DATA)
 #define FILE_ATTRIBUTE_MASK_LE			cpu_to_le32(FILE_ATTRIBUTE_MASK)
 
+/*
+ * SMB2 Notify Action Flags
+ * See MS-FSCC 2.7.1
+ */
+#define FILE_ACTION_ADDED                       0x00000001
+#define FILE_ACTION_REMOVED                     0x00000002
+#define FILE_ACTION_MODIFIED                    0x00000003
+#define FILE_ACTION_RENAMED_OLD_NAME            0x00000004
+#define FILE_ACTION_RENAMED_NEW_NAME            0x00000005
+#define FILE_ACTION_ADDED_STREAM                0x00000006
+#define FILE_ACTION_REMOVED_STREAM              0x00000007
+#define FILE_ACTION_MODIFIED_STREAM             0x00000008
+#define FILE_ACTION_REMOVED_BY_DELETE           0x00000009
+#define FILE_ACTION_ID_NOT_TUNNELLED            0x0000000A
+#define FILE_ACTION_TUNNELLED_ID_COLLISION      0x0000000B
+
 /*
  * Response contains array of the following structures
  * See MS-FSCC 2.7.1
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index a4804674aaba..72f2cfc47da8 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1003,22 +1003,6 @@ struct smb2_set_info_rsp {
 #define FILE_NOTIFY_CHANGE_STREAM_SIZE		0x00000400
 #define FILE_NOTIFY_CHANGE_STREAM_WRITE		0x00000800
 
-/*
- * SMB2 Notify Action Flags
- * See MS-FSCC 2.7.1
- */
-#define FILE_ACTION_ADDED                       0x00000001
-#define FILE_ACTION_REMOVED                     0x00000002
-#define FILE_ACTION_MODIFIED                    0x00000003
-#define FILE_ACTION_RENAMED_OLD_NAME            0x00000004
-#define FILE_ACTION_RENAMED_NEW_NAME            0x00000005
-#define FILE_ACTION_ADDED_STREAM                0x00000006
-#define FILE_ACTION_REMOVED_STREAM              0x00000007
-#define FILE_ACTION_MODIFIED_STREAM             0x00000008
-#define FILE_ACTION_REMOVED_BY_DELETE           0x00000009
-#define FILE_ACTION_ID_NOT_TUNNELLED            0x0000000A
-#define FILE_ACTION_TUNNELLED_ID_COLLISION      0x0000000B
-
 /* See MS-SMB2 2.2.35 */
 struct smb2_change_notify_req {
 	struct smb2_hdr hdr;
@@ -1495,105 +1479,6 @@ struct network_interface_info_ioctl_rsp {
 	};
 } __packed;
 
-/* this goes in the ioctl buffer when doing FSCTL_SET_ZERO_DATA */
-struct file_zero_data_information {
-	__le64	FileOffset;
-	__le64	BeyondFinalZero;
-} __packed;
-
-/* See MS-FSCC 2.3.7 */
-struct duplicate_extents_to_file {
-	__u64 PersistentFileHandle; /* source file handle, opaque endianness */
-	__u64 VolatileFileHandle;
-	__le64 SourceFileOffset;
-	__le64 TargetFileOffset;
-	__le64 ByteCount;  /* Bytes to be copied */
-} __packed;
-
-/* See MS-FSCC 2.3.9 */
-#define DUPLICATE_EXTENTS_DATA_EX_SOURCE_ATOMIC	0x00000001
-struct duplicate_extents_to_file_ex {
-	__u64 StructureSize; /* MUST be set to 0x30 */
-	__u64 PersistentFileHandle; /* source file handle, opaque endianness */
-	__u64 VolatileFileHandle;
-	__le64 SourceFileOffset;
-	__le64 TargetFileOffset;
-	__le64 ByteCount;  /* Bytes to be copied */
-	__le32 Flags;
-	__le32 Reserved;
-} __packed;
-
-
-/* See MS-FSCC 2.3.20 */
-struct fsctl_get_integrity_information_rsp {
-	__le16	ChecksumAlgorithm;
-	__le16	Reserved;
-	__le32	Flags;
-	__le32	ChecksumChunkSizeInBytes;
-	__le32	ClusterSizeInBytes;
-} __packed;
-
-/* See MS-FSCC 2.3.55 */
-struct fsctl_query_file_regions_req {
-	__le64	FileOffset;
-	__le64	Length;
-	__le32	DesiredUsage;
-	__le32	Reserved;
-} __packed;
-
-/* DesiredUsage flags see MS-FSCC 2.3.56.1 */
-#define FILE_USAGE_INVALID_RANGE	0x00000000
-#define FILE_USAGE_VALID_CACHED_DATA	0x00000001
-#define FILE_USAGE_NONCACHED_DATA	0x00000002
-
-struct file_region_info {
-	__le64	FileOffset;
-	__le64	Length;
-	__le32	DesiredUsage;
-	__le32	Reserved;
-} __packed;
-
-/* See MS-FSCC 2.3.56 */
-struct fsctl_query_file_region_rsp {
-	__le32 Flags;
-	__le32 TotalRegionEntryCount;
-	__le32 RegionEntryCount;
-	__u32  Reserved;
-	struct  file_region_info Regions[];
-} __packed;
-
-/* See MS-FSCC 2.3.58 */
-struct fsctl_query_on_disk_vol_info_rsp {
-	__le64	DirectoryCount;
-	__le64	FileCount;
-	__le16	FsFormatMajVersion;
-	__le16	FsFormatMinVersion;
-	__u8	FsFormatName[24];
-	__le64	FormatTime;
-	__le64	LastUpdateTime;
-	__u8	CopyrightInfo[68];
-	__u8	AbstractInfo[68];
-	__u8	FormatImplInfo[68];
-	__u8	LastModifyImplInfo[68];
-} __packed;
-
-/* See MS-FSCC 2.3.73 */
-struct fsctl_set_integrity_information_req {
-	__le16	ChecksumAlgorithm;
-	__le16	Reserved;
-	__le32	Flags;
-} __packed;
-
-/* See MS-FSCC 2.3.75 */
-struct fsctl_set_integrity_info_ex_req {
-	__u8	EnableIntegrity;
-	__u8	KeepState;
-	__u16	Reserved;
-	__le32	Flags;
-	__u8	Version;
-	__u8	Reserved2[7];
-} __packed;
-
 /* Integrity ChecksumAlgorithm choices for above */
 #define	CHECKSUM_TYPE_NONE	0x0000
 #define	CHECKSUM_TYPE_CRC64	0x0002
@@ -1602,72 +1487,6 @@ struct fsctl_set_integrity_info_ex_req {
 /* Integrity flags for above */
 #define FSCTL_INTEGRITY_FLAG_CHECKSUM_ENFORCEMENT_OFF	0x00000001
 
-/* Reparse structures - see MS-FSCC 2.1.2 */
-
-/* struct fsctl_reparse_info_req is empty, only response structs (see below) */
-struct reparse_data_buffer {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__u8	DataBuffer[]; /* Variable Length */
-} __packed;
-
-struct reparse_guid_data_buffer {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__u8	ReparseGuid[16];
-	__u8	DataBuffer[]; /* Variable Length */
-} __packed;
-
-struct reparse_mount_point_data_buffer {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__le16	SubstituteNameOffset;
-	__le16	SubstituteNameLength;
-	__le16	PrintNameOffset;
-	__le16	PrintNameLength;
-	__u8	PathBuffer[]; /* Variable Length */
-} __packed;
-
-#define SYMLINK_FLAG_RELATIVE 0x00000001
-
-struct reparse_symlink_data_buffer {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__le16	SubstituteNameOffset;
-	__le16	SubstituteNameLength;
-	__le16	PrintNameOffset;
-	__le16	PrintNameLength;
-	__le32	Flags;
-	__u8	PathBuffer[]; /* Variable Length */
-} __packed;
-
-/* For IO_REPARSE_TAG_NFS - see MS-FSCC 2.1.2.6 */
-#define NFS_SPECFILE_LNK	0x00000000014B4E4C
-#define NFS_SPECFILE_CHR	0x0000000000524843
-#define NFS_SPECFILE_BLK	0x00000000004B4C42
-#define NFS_SPECFILE_FIFO	0x000000004F464946
-#define NFS_SPECFILE_SOCK	0x000000004B434F53
-struct reparse_nfs_data_buffer {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__le64	InodeType; /* NFS_SPECFILE_* */
-	__u8	DataBuffer[];
-} __packed;
-
-/* For IO_REPARSE_TAG_LX_SYMLINK - see MS-FSCC 2.1.2.7 */
-struct reparse_wsl_symlink_data_buffer {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__le32	Version; /* Always 2 */
-	__u8	Target[]; /* Variable Length UTF-8 string without nul-term */
-} __packed;
-
 struct validate_negotiate_info_req {
 	__le32 Capabilities;
 	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
@@ -1787,84 +1606,6 @@ struct smb2_query_info_rsp {
 	__u8   Buffer[];
 } __packed;
 
-/*
- *	PDU query infolevel structure definitions
- */
-
-/* See MS-FSCC 2.3.52 */
-struct file_allocated_range_buffer {
-	__le64	file_offset;
-	__le64	length;
-} __packed;
-
-struct smb2_file_internal_info {
-	__le64 IndexNumber;
-} __packed; /* level 6 Query */
-
-struct smb2_file_rename_info { /* encoding of request for level 10 */
-	/* New members MUST be added within the struct_group() macro below. */
-	__struct_group(smb2_file_rename_info_hdr, __hdr, __packed,
-		__u8   ReplaceIfExists; /* 1 = replace existing target with new */
-					/* 0 = fail if target already exists */
-		__u8   Reserved[7];
-		__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
-		__le32 FileNameLength;
-	);
-	char   FileName[];     /* New name to be assigned */
-	/* padding - overall struct size must be >= 24 so filename + pad >= 6 */
-} __packed; /* level 10 Set */
-static_assert(offsetof(struct smb2_file_rename_info, FileName) == sizeof(struct smb2_file_rename_info_hdr),
-	      "struct member likely outside of __struct_group()");
-
-struct smb2_file_link_info { /* encoding of request for level 11 */
-	/* New members MUST be added within the struct_group() macro below. */
-	__struct_group(smb2_file_link_info_hdr, __hdr, __packed,
-		__u8   ReplaceIfExists; /* 1 = replace existing link with new */
-					/* 0 = fail if link already exists */
-		__u8   Reserved[7];
-		__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
-		__le32 FileNameLength;
-	);
-	char   FileName[];     /* Name to be assigned to new link */
-} __packed; /* level 11 Set */
-static_assert(offsetof(struct smb2_file_link_info, FileName) == sizeof(struct smb2_file_link_info_hdr),
-	      "struct member likely outside of __struct_group()");
-
-/*
- * This level 18, although with struct with same name is different from cifs
- * level 0x107. Level 0x107 has an extra u64 between AccessFlags and
- * CurrentByteOffset.
- */
-struct smb2_file_all_info { /* data block encoding of response to level 18 */
-	__le64 CreationTime;	/* Beginning of FILE_BASIC_INFO equivalent */
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le32 Attributes;
-	__u32  Pad1;		/* End of FILE_BASIC_INFO_INFO equivalent */
-	__le64 AllocationSize;	/* Beginning of FILE_STANDARD_INFO equivalent */
-	__le64 EndOfFile;	/* size ie offset to first free byte in file */
-	__le32 NumberOfLinks;	/* hard links */
-	__u8   DeletePending;
-	__u8   Directory;
-	__u16  Pad2;		/* End of FILE_STANDARD_INFO equivalent */
-	__le64 IndexNumber;
-	__le32 EASize;
-	__le32 AccessFlags;
-	__le64 CurrentByteOffset;
-	__le32 Mode;
-	__le32 AlignmentRequirement;
-	__le32 FileNameLength;
-	union {
-		char __pad;	/* Legacy structure padding */
-		DECLARE_FLEX_ARRAY(char, FileName);
-	};
-} __packed; /* level 18 Query */
-
-struct smb2_file_eof_info { /* encoding of request for level 10 */
-	__le64 EndOfFile; /* new end of file value */
-} __packed; /* level 20 Set */
-
 /* Level 100 query info */
 struct smb311_posix_qinfo {
 	__le64 CreationTime;
@@ -1890,54 +1631,6 @@ struct smb311_posix_qinfo {
 	 */
 } __packed;
 
-/* File System Information Classes */
-#define FS_VOLUME_INFORMATION		1 /* Query */
-#define FS_LABEL_INFORMATION		2 /* Set */
-#define FS_SIZE_INFORMATION		3 /* Query */
-#define FS_DEVICE_INFORMATION		4 /* Query */
-#define FS_ATTRIBUTE_INFORMATION	5 /* Query */
-#define FS_CONTROL_INFORMATION		6 /* Query, Set */
-#define FS_FULL_SIZE_INFORMATION	7 /* Query */
-#define FS_OBJECT_ID_INFORMATION	8 /* Query, Set */
-#define FS_DRIVER_PATH_INFORMATION	9 /* Query */
-#define FS_SECTOR_SIZE_INFORMATION	11 /* SMB3 or later. Query */
-#define FS_POSIX_INFORMATION		100 /* SMB3.1.1 POSIX. Query */
-
-struct smb2_fs_full_size_info {
-	__le64 TotalAllocationUnits;
-	__le64 CallerAvailableAllocationUnits;
-	__le64 ActualAvailableAllocationUnits;
-	__le32 SectorsPerAllocationUnit;
-	__le32 BytesPerSector;
-} __packed;
-
-#define SSINFO_FLAGS_ALIGNED_DEVICE		0x00000001
-#define SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE 0x00000002
-#define SSINFO_FLAGS_NO_SEEK_PENALTY		0x00000004
-#define SSINFO_FLAGS_TRIM_ENABLED		0x00000008
-
-/* sector size info struct */
-struct smb3_fs_ss_info {
-	__le32 LogicalBytesPerSector;
-	__le32 PhysicalBytesPerSectorForAtomicity;
-	__le32 PhysicalBytesPerSectorForPerf;
-	__le32 FSEffPhysicalBytesPerSectorForAtomicity;
-	__le32 Flags;
-	__le32 ByteOffsetForSectorAlignment;
-	__le32 ByteOffsetForPartitionAlignment;
-} __packed;
-
-/* File System Control Information */
-struct smb2_fs_control_info {
-	__le64 FreeSpaceStartFiltering;
-	__le64 FreeSpaceThreshold;
-	__le64 FreeSpaceStopFiltering;
-	__le64 DefaultQuotaThreshold;
-	__le64 DefaultQuotaLimit;
-	__le32 FileSystemControlFlags;
-	__le32 Padding;
-} __packed;
-
 /* See MS-SMB2 2.2.23 through 2.2.25 */
 struct smb2_oplock_break {
 	struct smb2_hdr hdr;
-- 
2.43.0

