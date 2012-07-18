From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 38/45] CIFS: Add set_file_info support for SMB2
Date: Wed, 18 Jul 2012 19:48:54 +0400
Message-ID: <1342626541-29872-39-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2inode.c |   22 ++++++++++++++++++++++
 fs/cifs/smb2ops.c   |    1 +
 fs/cifs/smb2pdu.c   |   11 +++++++++++
 fs/cifs/smb2proto.h |    5 +++++
 4 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 2905830..1bd6b0f 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -86,6 +86,10 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 		tmprc = SMB2_set_eof(xid, tcon, persistent_fid, volatile_fid,
 				     current->tgid, (__le64 *)data);
 		break;
+	case SMB2_OP_SET_INFO:
+		tmprc = SMB2_set_info(xid, tcon, persistent_fid, volatile_fid,
+				      (FILE_BASIC_INFO *)data);
+		break;
 	default:
 		cERROR(1, "Invalid command");
 		break;
@@ -232,3 +236,21 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 				  FILE_WRITE_DATA, FILE_OPEN, 0, 0, &eof,
 				  SMB2_OP_SET_EOF);
 }
+
+int
+smb2_set_file_info(struct inode *inode, const char *full_path,
+		   FILE_BASIC_INFO *buf, const unsigned int xid)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink;
+	int rc;
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	rc = smb2_open_op_close(xid, tlink_tcon(tlink), cifs_sb, full_path,
+				FILE_WRITE_ATTRIBUTES, FILE_OPEN, 0, 0, buf,
+				SMB2_OP_SET_INFO);
+	cifs_put_tlink(tlink);
+	return rc;
+}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3aad536..7ecb117 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -448,6 +448,7 @@ struct smb_version_operations smb21_operations = {
 	.query_file_info = smb2_query_file_info,
 	.set_path_size = smb2_set_path_size,
 	.set_file_size = smb2_set_file_size,
+	.set_file_info = smb2_set_file_info,
 	.build_path_to_root = smb2_build_path_to_root,
 	.mkdir = smb2_mkdir,
 	.mkdir_setinfo = smb2_mkdir_setinfo,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f1edc5e..1587761 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1755,3 +1755,14 @@ SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	return send_set_info(xid, tcon, persistent_fid, volatile_fid, pid,
 			     FILE_END_OF_FILE_INFORMATION, 1, &data, &size);
 }
+
+int
+SMB2_set_info(const unsigned int xid, struct cifs_tcon *tcon,
+	      u64 persistent_fid, u64 volatile_fid, FILE_BASIC_INFO *buf)
+{
+	unsigned int size;
+	size = sizeof(FILE_BASIC_INFO);
+	return send_set_info(xid, tcon, persistent_fid, volatile_fid,
+			     current->tgid, FILE_BASIC_INFORMATION, 1,
+			     (void **)&buf, &size);
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 3d48662..2774724 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -59,6 +59,8 @@ extern int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 extern int smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 			      const char *full_path, __u64 size,
 			      struct cifs_sb_info *cifs_sb, bool set_alloc);
+extern int smb2_set_file_info(struct inode *inode, const char *full_path,
+			      FILE_BASIC_INFO *buf, const unsigned int xid);
 extern int smb2_mkdir(const unsigned int xid, struct cifs_tcon *tcon,
 		      const char *name, struct cifs_sb_info *cifs_sb);
 extern void smb2_mkdir_setinfo(struct inode *inode, const char *full_path,
@@ -124,5 +126,8 @@ extern int SMB2_set_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
 			u64 persistent_fid, u64 volatile_fid, u32 pid,
 			__le64 *eof);
+extern int SMB2_set_info(const unsigned int xid, struct cifs_tcon *tcon,
+			 u64 persistent_fid, u64 volatile_fid,
+			 FILE_BASIC_INFO *buf);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
