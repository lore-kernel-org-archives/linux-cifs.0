From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 13/45] CIFS: Add open/close file support for SMB2
Date: Wed, 18 Jul 2012 19:48:29 +0400
Message-ID: <1342626541-29872-14-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/Makefile    |    2 +-
 fs/cifs/cifsglob.h  |    4 ++
 fs/cifs/smb2file.c  |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2inode.c |    4 +-
 fs/cifs/smb2ops.c   |   22 ++++++++++++-
 fs/cifs/smb2pdu.c   |   53 ++++++++++++++++++++++++-------
 fs/cifs/smb2pdu.h   |    4 ++
 fs/cifs/smb2proto.h |   14 ++++++++-
 8 files changed, 172 insertions(+), 17 deletions(-)
 create mode 100644 fs/cifs/smb2file.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index feee943..aa0d68b 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -17,4 +17,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
 cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o smb2transport.o \
-			    smb2misc.o smb2pdu.o smb2inode.o
+			    smb2misc.o smb2pdu.o smb2inode.o smb2file.o
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b3cbce6..bd2b397 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -757,6 +757,10 @@ struct cifs_search_info {
 
 struct cifs_fid {
 	__u16 netfid;
+#ifdef CONFIG_CIFS_SMB2
+	__u64 persistent_fid;	/* persist file id for smb2 */
+	__u64 volatile_fid;	/* volatile file id for smb2 */
+#endif
 };
 
 struct cifsFileInfo {
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
new file mode 100644
index 0000000..a7618df
--- /dev/null
+++ b/fs/cifs/smb2file.c
@@ -0,0 +1,86 @@
+/*
+ *   fs/cifs/smb2file.c
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002, 2011
+ *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org),
+ *              Pavel Shilovsky ((pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
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
+#include "smb2proto.h"
+
+int
+smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
+	       int disposition, int desired_access, int create_options,
+	       struct cifs_fid *fid, __u32 *oplock, FILE_ALL_INFO *buf,
+	       struct cifs_sb_info *cifs_sb)
+{
+	int rc;
+	__le16 *smb2_path;
+	struct smb2_file_all_info *smb2_data = NULL;
+
+	smb2_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	if (smb2_path == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+			    GFP_KERNEL);
+	if (smb2_data == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	desired_access |= FILE_READ_ATTRIBUTES;
+
+	rc = SMB2_open(xid, tcon, smb2_path, &fid->persistent_fid,
+		       &fid->volatile_fid, desired_access, disposition,
+		       0, 0, smb2_data);
+	if (rc)
+		goto out;
+
+	if (buf) {
+		/* open response does not have IndexNumber field - get it */
+		rc = SMB2_get_srv_num(xid, tcon, fid->persistent_fid,
+				      fid->volatile_fid,
+				      &smb2_data->IndexNumber);
+		if (rc) {
+			/* let get_inode_info disable server inode numbers */
+			smb2_data->IndexNumber = 0;
+			rc = 0;
+		}
+		move_smb2_info_to_cifs(buf, smb2_data);
+	}
+
+out:
+	*oplock = 0;
+	kfree(smb2_data);
+	kfree(smb2_path);
+	return rc;
+}
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 02a9bda..ee3a1ef 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -54,7 +54,7 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
 		       desired_access, create_disposition, file_attributes,
-		       create_options);
+		       create_options, NULL);
 	if (rc) {
 		kfree(utf16_path);
 		return rc;
@@ -86,7 +86,7 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-static void
+void
 move_smb2_info_to_cifs(FILE_ALL_INFO *dst, struct smb2_file_all_info *src)
 {
 	memcpy(dst, src, (size_t)(&src->CurrentByteOffset) - (size_t)src);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index bf9b318..eba12b3 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -170,7 +170,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOMEM;
 
 	rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
-		       FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0);
+		       FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0, NULL);
 	if (rc) {
 		kfree(utf16_path);
 		return rc;
@@ -292,6 +292,23 @@ smb2_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
 #endif
 }
 
+static void
+smb2_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
+{
+	/* struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode); */
+	cfile->fid.persistent_fid = fid->persistent_fid;
+	cfile->fid.volatile_fid = fid->volatile_fid;
+	/* cifs_set_oplock_level(cinode, oplock); */
+	/* cinode->can_cache_brlcks = cinode->clientCanCacheAll; */
+}
+
+static int
+smb2_close_file(const unsigned int xid, struct cifs_tcon *tcon,
+		struct cifs_fid *fid)
+{
+	return SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -322,6 +339,9 @@ struct smb_version_operations smb21_operations = {
 	.mkdir_setinfo = smb2_mkdir_setinfo,
 	.rmdir = smb2_rmdir,
 	.unlink = smb2_unlink,
+	.open = smb2_open_file,
+	.set_fid = smb2_set_fid,
+	.close = smb2_close_file,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 62b3f17..231e970 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -833,7 +833,8 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 int
 SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	  u64 *persistent_fid, u64 *volatile_fid, __u32 desired_access,
-	  __u32 create_disposition, __u32 file_attributes, __u32 create_options)
+	  __u32 create_disposition, __u32 file_attributes, __u32 create_options,
+	  struct smb2_file_all_info *buf)
 {
 	struct smb2_create_req *req;
 	struct smb2_create_rsp *rsp;
@@ -856,9 +857,9 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	if (rc)
 		return rc;
 
-	if (enable_oplocks)
+	/* if (server->oplocks)
 		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_BATCH;
-	else
+	else */
 		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_NONE;
 	req->ImpersonationLevel = IL_IMPERSONATION;
 	req->DesiredAccess = cpu_to_le32(desired_access);
@@ -906,6 +907,15 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	}
 	*persistent_fid = rsp->PersistentFileId;
 	*volatile_fid = rsp->VolatileFileId;
+
+	if (buf) {
+		memcpy(buf, &rsp->CreationTime, 32);
+		buf->AllocationSize = rsp->AllocationSize;
+		buf->EndOfFile = rsp->EndofFile;
+		buf->Attributes = rsp->FileAttributes;
+		buf->NumberOfLinks = cpu_to_le32(1);
+		buf->DeletePending = 0;
+	}
 creat_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
@@ -1019,10 +1029,10 @@ validate_and_copy_buf(unsigned int offset, unsigned int buffer_length,
 	return 0;
 }
 
-int
-SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
-		u64 persistent_fid, u64 volatile_fid,
-		struct smb2_file_all_info *data)
+static int
+query_info(const unsigned int xid, struct cifs_tcon *tcon,
+	   u64 persistent_fid, u64 volatile_fid, u8 info_class,
+	   size_t output_len, size_t min_len, void *data)
 {
 	struct smb2_query_info_req *req;
 	struct smb2_query_info_rsp *rsp = NULL;
@@ -1044,14 +1054,13 @@ SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 
 	req->InfoType = SMB2_O_INFO_FILE;
-	req->FileInfoClass = FILE_ALL_INFORMATION;
+	req->FileInfoClass = info_class;
 	req->PersistentFileId = persistent_fid;
 	req->VolatileFileId = volatile_fid;
 	/* 4 for rfc1002 length field and 1 for Buffer */
 	req->InputBufferOffset =
 		cpu_to_le16(sizeof(struct smb2_query_info_req) - 1 - 4);
-	req->OutputBufferLength =
-		cpu_to_le32(sizeof(struct smb2_file_all_info) + MAX_NAME * 2);
+	req->OutputBufferLength = cpu_to_le32(output_len);
 
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field */
@@ -1067,14 +1076,34 @@ SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = validate_and_copy_buf(le16_to_cpu(rsp->OutputBufferOffset),
 				   le32_to_cpu(rsp->OutputBufferLength),
-				   &rsp->hdr, sizeof(struct smb2_file_all_info),
-				   (char *)data);
+				   &rsp->hdr, min_len, data);
 
 qinf_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
 
+int
+SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
+		u64 persistent_fid, u64 volatile_fid,
+		struct smb2_file_all_info *data)
+{
+	return query_info(xid, tcon, persistent_fid, volatile_fid,
+			  FILE_ALL_INFORMATION,
+			  sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+			  sizeof(struct smb2_file_all_info), data);
+}
+
+int
+SMB2_get_srv_num(const unsigned int xid, struct cifs_tcon *tcon,
+		 u64 persistent_fid, u64 volatile_fid, __le64 *uniqueid)
+{
+	return query_info(xid, tcon, persistent_fid, volatile_fid,
+			  FILE_INTERNAL_INFORMATION,
+			  sizeof(struct smb2_file_internal_info),
+			  sizeof(struct smb2_file_internal_info), uniqueid);
+}
+
 /*
  * This is a no-op for now. We're not really interested in the reply, but
  * rather in the fact that the server sent one and that server->lstrp
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f37a1b4..7f1caff 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -546,6 +546,10 @@ struct smb2_query_info_rsp {
 #define FILEID_GLOBAL_TX_DIRECTORY_INFORMATION 50
 #define FILE_STANDARD_LINK_INFORMATION	54
 
+struct smb2_file_internal_info {
+	__le64 IndexNumber;
+} __packed; /* level 6 Query */
+
 /*
  * This level 18, although with struct with same name is different from cifs
  * level 0x107. Level 0x107 has an extra u64 between AccessFlags and
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index f4ac727..624d344 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -48,6 +48,8 @@ extern int smb2_setup_async_request(struct TCP_Server_Info *server,
 				    struct mid_q_entry **ret_mid);
 extern void smb2_echo_request(struct work_struct *work);
 
+extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst,
+				   struct smb2_file_all_info *src);
 extern int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb,
 				const char *full_path, FILE_ALL_INFO *data,
@@ -62,6 +64,12 @@ extern int smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
 extern int smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon,
 		       const char *name, struct cifs_sb_info *cifs_sb);
 
+extern int smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon,
+			  const char *full_path, int disposition,
+			  int desired_access, int create_options,
+			  struct cifs_fid *fid, __u32 *oplock,
+			  FILE_ALL_INFO *buf, struct cifs_sb_info *cifs_sb);
+
 /*
  * SMB2 Worker functions - most of protocol specific implementation details
  * are contained within these calls.
@@ -77,12 +85,16 @@ extern int SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon);
 extern int SMB2_open(const unsigned int xid, struct cifs_tcon *tcon,
 		     __le16 *path, u64 *persistent_fid, u64 *volatile_fid,
 		     __u32 desired_access, __u32 create_disposition,
-		     __u32 file_attributes, __u32 create_options);
+		     __u32 file_attributes, __u32 create_options,
+		     struct smb2_file_all_info *buf);
 extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 		      u64 persistent_file_id, u64 volatile_file_id);
 extern int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 			   u64 persistent_file_id, u64 volatile_file_id,
 			   struct smb2_file_all_info *data);
+extern int SMB2_get_srv_num(const unsigned int xid, struct cifs_tcon *tcon,
+			    u64 persistent_fid, u64 volatile_fid,
+			    __le64 *uniqueid);
 extern int SMB2_echo(struct TCP_Server_Info *server);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
