From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 36/45] CIFS: Add SMB2 support for set_file_size
Date: Wed, 18 Jul 2012 19:48:52 +0400
Message-ID: <1342626541-29872-37-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2glob.h  |    1 +
 fs/cifs/smb2inode.c |   15 +++++++++++++++
 fs/cifs/smb2ops.c   |   11 +++++++++++
 fs/cifs/smb2pdu.c   |   26 +++++++++++++++++++++++---
 fs/cifs/smb2pdu.h   |    4 ++++
 fs/cifs/smb2proto.h |    6 ++++++
 6 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 21555d8..05d429b 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -41,6 +41,7 @@
 #define SMB2_OP_RENAME 6
 #define SMB2_OP_DELETE 7
 #define SMB2_OP_HARDLINK 8
+#define SMB2_OP_SET_EOF 9
 
 /* Used when constructing chained read requests. */
 #define CHAINED_REQUEST 1
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 1921c9c..2905830 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -82,6 +82,10 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 		tmprc = SMB2_set_hardlink(xid, tcon, persistent_fid,
 					  volatile_fid, (__le16 *)data);
 		break;
+	case SMB2_OP_SET_EOF:
+		tmprc = SMB2_set_eof(xid, tcon, persistent_fid, volatile_fid,
+				     current->tgid, (__le64 *)data);
+		break;
 	default:
 		cERROR(1, "Invalid command");
 		break;
@@ -217,3 +221,14 @@ smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 	return smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
 				  FILE_READ_ATTRIBUTES, SMB2_OP_HARDLINK);
 }
+
+int
+smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
+		   const char *full_path, __u64 size,
+		   struct cifs_sb_info *cifs_sb, bool set_alloc)
+{
+	__le64 eof = cpu_to_le64(size);
+	return smb2_open_op_close(xid, tcon, cifs_sb, full_path,
+				  FILE_WRITE_DATA, FILE_OPEN, 0, 0, &eof,
+				  SMB2_OP_SET_EOF);
+}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f9e3a13..3aad536 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -406,6 +406,15 @@ smb2_sync_write(const unsigned int xid, struct cifsFileInfo *cfile,
 	return SMB2_write(xid, parms, written, iov, nr_segs);
 }
 
+static int
+smb2_set_file_size(const unsigned int xid, struct cifs_tcon *tcon,
+		   struct cifsFileInfo *cfile, __u64 size, bool set_alloc)
+{
+	__le64 eof = cpu_to_le64(size);
+	return SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
+			    cfile->fid.volatile_fid, cfile->pid, &eof);
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -437,6 +446,8 @@ struct smb_version_operations smb21_operations = {
 	.query_path_info = smb2_query_path_info,
 	.get_srv_inum = smb2_get_srv_inum,
 	.query_file_info = smb2_query_file_info,
+	.set_path_size = smb2_set_path_size,
+	.set_file_size = smb2_set_file_size,
 	.build_path_to_root = smb2_build_path_to_root,
 	.mkdir = smb2_mkdir,
 	.mkdir_setinfo = smb2_mkdir_setinfo,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 4d9ef2c..f1edc5e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1600,7 +1600,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 static int
 send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
-	       u64 persistent_fid, u64 volatile_fid, int info_class,
+	       u64 persistent_fid, u64 volatile_fid, u32 pid, int info_class,
 	       unsigned int num, void **data, unsigned int *size)
 {
 	struct smb2_set_info_req *req;
@@ -1630,6 +1630,8 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
+	req->hdr.ProcessId = cpu_to_le32(pid);
+
 	req->InfoType = SMB2_O_INFO_FILE;
 	req->FileInfoClass = info_class;
 	req->PersistentFileId = persistent_fid;
@@ -1700,7 +1702,8 @@ SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
 	size[1] = len + 2 /* null */;
 
 	rc = send_set_info(xid, tcon, persistent_fid, volatile_fid,
-			   FILE_RENAME_INFORMATION, 2, data, size);
+			   current->tgid, FILE_RENAME_INFORMATION, 2, data,
+			   size);
 	kfree(data);
 	return rc;
 }
@@ -1731,7 +1734,24 @@ SMB2_set_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 	size[1] = len + 2 /* null */;
 
 	rc = send_set_info(xid, tcon, persistent_fid, volatile_fid,
-			   FILE_LINK_INFORMATION, 2, data, size);
+			   current->tgid, FILE_LINK_INFORMATION, 2, data, size);
 	kfree(data);
 	return rc;
 }
+
+int
+SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
+	     u64 volatile_fid, u32 pid, __le64 *eof)
+{
+	struct smb2_file_eof_info info;
+	void *data;
+	unsigned int size;
+
+	info.EndOfFile = *eof;
+
+	data = &info;
+	size = sizeof(struct smb2_file_eof_info);
+
+	return send_set_info(xid, tcon, persistent_fid, volatile_fid, pid,
+			     FILE_END_OF_FILE_INFORMATION, 1, &data, &size);
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 34a9329..45ecae9 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -688,4 +688,8 @@ struct smb2_file_all_info { /* data block encoding of response to level 18 */
 	char   FileName[1];
 } __packed; /* level 18 Query */
 
+struct smb2_file_eof_info { /* encoding of request for level 10 */
+	__le64 EndOfFile; /* new end of file value */
+} __packed; /* level 20 Set */
+
 #endif				/* _SMB2PDU_H */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 99f6945..3d48662 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -56,6 +56,9 @@ extern int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb,
 				const char *full_path, FILE_ALL_INFO *data,
 				bool *adjust_tz);
+extern int smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
+			      const char *full_path, __u64 size,
+			      struct cifs_sb_info *cifs_sb, bool set_alloc);
 extern int smb2_mkdir(const unsigned int xid, struct cifs_tcon *tcon,
 		      const char *name, struct cifs_sb_info *cifs_sb);
 extern void smb2_mkdir_setinfo(struct inode *inode, const char *full_path,
@@ -118,5 +121,8 @@ extern int SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_set_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 			     u64 persistent_fid, u64 volatile_fid,
 			     __le16 *target_file);
+extern int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
+			u64 persistent_fid, u64 volatile_fid, u32 pid,
+			__le64 *eof);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
