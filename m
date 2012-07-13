From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 24/32] CIFS: Query SMB2 inode info
Date: Fri, 13 Jul 2012 11:53:37 +0400
Message-ID: <1342166025-29377-25-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/Makefile    |    2 +-
 fs/cifs/smb2glob.h  |   44 ++++++++++++++++++
 fs/cifs/smb2inode.c |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2misc.c  |    7 +++-
 fs/cifs/smb2ops.c   |   11 +++++
 fs/cifs/smb2pdu.c   |  113 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |  111 +++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h |    7 +++
 8 files changed, 417 insertions(+), 2 deletions(-)
 create mode 100644 fs/cifs/smb2glob.h
 create mode 100644 fs/cifs/smb2inode.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index daf6837..feee943 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -17,4 +17,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
 cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o smb2transport.o \
-			    smb2misc.o smb2pdu.o
+			    smb2misc.o smb2pdu.o smb2inode.o
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
new file mode 100644
index 0000000..33c1d89
--- /dev/null
+++ b/fs/cifs/smb2glob.h
@@ -0,0 +1,44 @@
+/*
+ *   fs/cifs/smb2glob.h
+ *
+ *   Definitions for various global variables and structures
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002, 2011
+ *                 Etersoft, 2012
+ *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Jeremy Allison (jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
+ *              Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ */
+#ifndef _SMB2_GLOB_H
+#define _SMB2_GLOB_H
+
+/*
+ *****************************************************************
+ * Constants go here
+ *****************************************************************
+ */
+
+/*
+ * Identifiers for functions that use the open, operation, close pattern
+ * in smb2inode.c:smb2_open_op_close()
+ */
+#define SMB2_OP_SET_DELETE 1
+#define SMB2_OP_SET_INFO 2
+#define SMB2_OP_QUERY_INFO 3
+#define SMB2_OP_QUERY_DIR 4
+#define SMB2_OP_MKDIR 5
+#define SMB2_OP_RENAME 6
+#define SMB2_OP_DELETE 7
+
+#endif	/* _SMB2_GLOB_H */
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
new file mode 100644
index 0000000..1ba5c40
--- /dev/null
+++ b/fs/cifs/smb2inode.c
@@ -0,0 +1,124 @@
+/*
+ *   fs/cifs/smb2inode.c
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002, 2011
+ *                 Etersoft, 2012
+ *   Author(s): Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org),
+ *              Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#include <linux/fs.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <asm/div64.h>
+#include "cifsfs.h"
+#include "cifspdu.h"
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "cifs_debug.h"
+#include "cifs_fs_sb.h"
+#include "cifs_unicode.h"
+#include "fscache.h"
+#include "smb2glob.h"
+#include "smb2pdu.h"
+#include "smb2proto.h"
+
+static int
+smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
+		   struct cifs_sb_info *cifs_sb, const char *full_path,
+		   __u32 desired_access, __u32 create_disposition,
+		   __u32 file_attributes, __u32 create_options,
+		   void *data, int command)
+{
+	int rc, tmprc = 0;
+	u64 persistent_fid, volatile_fid;
+	__le16 *utf16_path;
+
+	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
+	if (!utf16_path)
+		return -ENOMEM;
+
+	rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
+		       desired_access, create_disposition, file_attributes,
+		       create_options);
+	if (rc) {
+		kfree(utf16_path);
+		return rc;
+	}
+
+	switch (command) {
+	case SMB2_OP_DELETE:
+		break;
+	case SMB2_OP_QUERY_INFO:
+		tmprc = SMB2_query_info(xid, tcon, persistent_fid,
+					volatile_fid,
+					(struct smb2_file_all_info *)data);
+		break;
+	case SMB2_OP_MKDIR:
+		/*
+		 * Directories are created through parameters in the
+		 * SMB2_open() call.
+		 */
+		break;
+	default:
+		cERROR(1, "Invalid command");
+		break;
+	}
+
+	rc = SMB2_close(xid, tcon, persistent_fid, volatile_fid);
+	if (tmprc)
+		rc = tmprc;
+	kfree(utf16_path);
+	return rc;
+}
+
+static void
+move_smb2_info_to_cifs(FILE_ALL_INFO *dst, struct smb2_file_all_info *src)
+{
+	memcpy(dst, src, (size_t)(&src->CurrentByteOffset) - (size_t)src);
+	dst->CurrentByteOffset = src->CurrentByteOffset;
+	dst->Mode = src->Mode;
+	dst->AlignmentRequirement = src->AlignmentRequirement;
+	dst->IndexNumber1 = 0; /* we don't use it */
+}
+
+int
+smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
+		     struct cifs_sb_info *cifs_sb, const char *full_path,
+		     FILE_ALL_INFO *data, bool *adjust_tz)
+{
+	int rc;
+	struct smb2_file_all_info *smb2_data;
+
+	*adjust_tz = false;
+
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+			    GFP_KERNEL);
+	if (smb2_data == NULL)
+		return -ENOMEM;
+
+	rc = smb2_open_op_close(xid, tcon, cifs_sb, full_path,
+				FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0,
+				smb2_data, SMB2_OP_QUERY_INFO);
+	if (rc)
+		goto out;
+
+	move_smb2_info_to_cifs(data, smb2_data);
+out:
+	kfree(smb2_data);
+	return rc;
+}
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index eb73a13..a4ff5d5 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -235,8 +235,13 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 		*len = le32_to_cpu(
 		    ((struct smb2_create_rsp *)hdr)->CreateContextsLength);
 		break;
-	case SMB2_READ:
 	case SMB2_QUERY_INFO:
+		*off = le16_to_cpu(
+		    ((struct smb2_query_info_rsp *)hdr)->OutputBufferOffset);
+		*len = le32_to_cpu(
+		    ((struct smb2_query_info_rsp *)hdr)->OutputBufferLength);
+		break;
+	case SMB2_READ:
 	case SMB2_QUERY_DIRECTORY:
 	case SMB2_IOCTL:
 	case SMB2_CHANGE_NOTIFY:
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 1266137..bcf310c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -181,6 +181,15 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static int
+smb2_get_srv_inum(const unsigned int xid, struct cifs_tcon *tcon,
+		  struct cifs_sb_info *cifs_sb, const char *full_path,
+		  u64 *uniqueid, FILE_ALL_INFO *data)
+{
+	*uniqueid = le64_to_cpu(data->IndexNumber);
+	return 0;
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.check_receive = smb2_check_receive,
@@ -199,6 +208,8 @@ struct smb_version_operations smb21_operations = {
 	.tree_connect = SMB2_tcon,
 	.tree_disconnect = SMB2_tdis,
 	.is_path_accessible = smb2_is_path_accessible,
+	.query_path_info = smb2_query_path_info,
+	.get_srv_inum = smb2_get_srv_inum,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ef0769c..7ef5324 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -961,3 +961,116 @@ close_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
+
+static int
+validate_buf(unsigned int offset, unsigned int buffer_length,
+	     struct smb2_hdr *hdr, unsigned int min_buf_size)
+
+{
+	unsigned int smb_len = be32_to_cpu(hdr->smb2_buf_length);
+	char *end_of_smb = smb_len + 4 /* RFC1001 length field */ + (char *)hdr;
+	char *begin_of_buf = 4 /* RFC1001 len field */ + offset + (char *)hdr;
+	char *end_of_buf = begin_of_buf + buffer_length;
+
+
+	if (buffer_length < min_buf_size) {
+		cERROR(1, "buffer length %d smaller than minimum size %d",
+			   buffer_length, min_buf_size);
+		return -EINVAL;
+	}
+
+	/* check if beyond RFC1001 maximum length */
+	if ((smb_len > 0x7FFFFF) || (buffer_length > 0x7FFFFF)) {
+		cERROR(1, "buffer length %d or smb length %d too large",
+			   buffer_length, smb_len);
+		return -EINVAL;
+	}
+
+	if ((begin_of_buf > end_of_smb) || (end_of_buf > end_of_smb)) {
+		cERROR(1, "illegal server response, bad offset to data");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * If SMB buffer fields are valid, copy into temporary buffer to hold result.
+ * Caller must free buffer.
+ */
+static int
+validate_and_copy_buf(unsigned int offset, unsigned int buffer_length,
+		      struct smb2_hdr *hdr, unsigned int minbufsize,
+		      char *data)
+
+{
+	char *begin_of_buf = 4 /* RFC1001 len field */ + offset + (char *)hdr;
+	int rc;
+
+	if (!data)
+		return -EINVAL;
+
+	rc = validate_buf(offset, buffer_length, hdr, minbufsize);
+	if (rc)
+		return rc;
+
+	memcpy(data, begin_of_buf, buffer_length);
+
+	return 0;
+}
+
+int
+SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
+		u64 persistent_fid, u64 volatile_fid,
+		struct smb2_file_all_info *data)
+{
+	struct smb2_query_info_req *req;
+	struct smb2_query_info_rsp *rsp = NULL;
+	struct kvec iov[2];
+	int rc = 0;
+	int resp_buftype;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+
+	cFYI(1, "Query Info");
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_QUERY_INFO, tcon, (void **) &req);
+	if (rc)
+		return rc;
+
+	req->InfoType = SMB2_O_INFO_FILE;
+	req->FileInfoClass = FILE_ALL_INFORMATION;
+	req->PersistentFileId = persistent_fid;
+	req->VolatileFileId = volatile_fid;
+	/* 4 for rfc1002 length field and 1 for Buffer */
+	req->InputBufferOffset =
+		cpu_to_le16(sizeof(struct smb2_query_info_req) - 1 - 4);
+	req->OutputBufferLength =
+		cpu_to_le32(sizeof(struct smb2_file_all_info) + MAX_NAME * 2);
+
+	iov[0].iov_base = (char *)req;
+	/* 4 for rfc1002 length field */
+	iov[0].iov_len = get_rfc1002_length(req) + 4;
+
+	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, 0);
+	if (rc) {
+		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
+		goto qinf_exit;
+	}
+
+	rsp = (struct smb2_query_info_rsp *)iov[0].iov_base;
+
+	rc = validate_and_copy_buf(le16_to_cpu(rsp->OutputBufferOffset),
+				   le32_to_cpu(rsp->OutputBufferLength),
+				   &rsp->hdr, sizeof(struct smb2_file_all_info),
+				   (char *)data);
+
+qinf_exit:
+	free_rsp_buf(resp_buftype, rsp);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 5cd358e..9151e90 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -448,4 +448,115 @@ struct smb2_close_rsp {
 	__le32 Attributes;
 } __packed;
 
+/* Possible InfoType values */
+#define SMB2_O_INFO_FILE	0x01
+#define SMB2_O_INFO_FILESYSTEM	0x02
+#define SMB2_O_INFO_SECURITY	0x03
+#define SMB2_O_INFO_QUOTA	0x04
+
+struct smb2_query_info_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 41 */
+	__u8   InfoType;
+	__u8   FileInfoClass;
+	__le32 OutputBufferLength;
+	__le16 InputBufferOffset;
+	__u16  Reserved;
+	__le32 InputBufferLength;
+	__le32 AdditionalInformation;
+	__le32 Flags;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+	__u8   Buffer[1];
+} __packed;
+
+struct smb2_query_info_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 9 */
+	__le16 OutputBufferOffset;
+	__le32 OutputBufferLength;
+	__u8   Buffer[1];
+} __packed;
+
+/*
+ *	PDU infolevel structure definitions
+ *	BB consider moving to a different header
+ */
+
+/* partial list of QUERY INFO levels */
+#define FILE_DIRECTORY_INFORMATION	1
+#define FILE_FULL_DIRECTORY_INFORMATION 2
+#define FILE_BOTH_DIRECTORY_INFORMATION 3
+#define FILE_BASIC_INFORMATION		4
+#define FILE_STANDARD_INFORMATION	5
+#define FILE_INTERNAL_INFORMATION	6
+#define FILE_EA_INFORMATION	        7
+#define FILE_ACCESS_INFORMATION		8
+#define FILE_NAME_INFORMATION		9
+#define FILE_RENAME_INFORMATION		10
+#define FILE_LINK_INFORMATION		11
+#define FILE_NAMES_INFORMATION		12
+#define FILE_DISPOSITION_INFORMATION	13
+#define FILE_POSITION_INFORMATION	14
+#define FILE_FULL_EA_INFORMATION	15
+#define FILE_MODE_INFORMATION		16
+#define FILE_ALIGNMENT_INFORMATION	17
+#define FILE_ALL_INFORMATION		18
+#define FILE_ALLOCATION_INFORMATION	19
+#define FILE_END_OF_FILE_INFORMATION	20
+#define FILE_ALTERNATE_NAME_INFORMATION 21
+#define FILE_STREAM_INFORMATION		22
+#define FILE_PIPE_INFORMATION		23
+#define FILE_PIPE_LOCAL_INFORMATION	24
+#define FILE_PIPE_REMOTE_INFORMATION	25
+#define FILE_MAILSLOT_QUERY_INFORMATION 26
+#define FILE_MAILSLOT_SET_INFORMATION	27
+#define FILE_COMPRESSION_INFORMATION	28
+#define FILE_OBJECT_ID_INFORMATION	29
+/* Number 30 not defined in documents */
+#define FILE_MOVE_CLUSTER_INFORMATION	31
+#define FILE_QUOTA_INFORMATION		32
+#define FILE_REPARSE_POINT_INFORMATION	33
+#define FILE_NETWORK_OPEN_INFORMATION	34
+#define FILE_ATTRIBUTE_TAG_INFORMATION	35
+#define FILE_TRACKING_INFORMATION	36
+#define FILEID_BOTH_DIRECTORY_INFORMATION 37
+#define FILEID_FULL_DIRECTORY_INFORMATION 38
+#define FILE_VALID_DATA_LENGTH_INFORMATION 39
+#define FILE_SHORT_NAME_INFORMATION	40
+#define FILE_SFIO_RESERVE_INFORMATION	44
+#define FILE_SFIO_VOLUME_INFORMATION	45
+#define FILE_HARD_LINK_INFORMATION	46
+#define FILE_NORMALIZED_NAME_INFORMATION 48
+#define FILEID_GLOBAL_TX_DIRECTORY_INFORMATION 50
+#define FILE_STANDARD_LINK_INFORMATION	54
+
+/*
+ * This level 18, although with struct with same name is different from cifs
+ * level 0x107. Level 0x107 has an extra u64 between AccessFlags and
+ * CurrentByteOffset.
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
+	char   FileName[1];
+} __packed; /* level 18 Query */
+
 #endif				/* _SMB2PDU_H */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 85aa8d5..1517b4c 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -44,6 +44,10 @@ extern int smb2_check_receive(struct mid_q_entry *mid,
 extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 			      unsigned int nvec, struct mid_q_entry **ret_mid);
 
+extern int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
+				struct cifs_sb_info *cifs_sb,
+				const char *full_path, FILE_ALL_INFO *data,
+				bool *adjust_tz);
 /*
  * SMB2 Worker functions - most of protocol specific implementation details
  * are contained within these calls.
@@ -62,5 +66,8 @@ extern int SMB2_open(const unsigned int xid, struct cifs_tcon *tcon,
 		     __u32 file_attributes, __u32 create_options);
 extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 		      u64 persistent_file_id, u64 volatile_file_id);
+extern int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
+			   u64 persistent_file_id, u64 volatile_file_id,
+			   struct smb2_file_all_info *data);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
