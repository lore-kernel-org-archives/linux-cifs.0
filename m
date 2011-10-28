From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 38/53] CIFS: Add SMB2 support for hardlink operation
Date: Fri, 28 Oct 2011 23:54:49 +0400
Message-ID: <1319831704-3572-39-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2glob.h  |    3 +-
 fs/cifs/smb2inode.c |   10 +++-
 fs/cifs/smb2link.c  |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   |    2 +-
 fs/cifs/smb2proto.h |    6 +++
 5 files changed, 124 insertions(+), 5 deletions(-)
 create mode 100644 fs/cifs/smb2link.c

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 55d76ad..9e42f71 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -174,7 +174,7 @@ struct page_req {
 #define SMB2_MAX_REQ 256
 
 /* Identifiers for functions that use the open, operation, close pattern
- * in inode.c:open_op_close() */
+ * in smb2inode.c:smb2_open_op_close() */
 #define SMB2_OP_SET_DELETE 1
 #define SMB2_OP_SET_INFO 2
 #define SMB2_OP_QUERY_INFO 3
@@ -182,6 +182,7 @@ struct page_req {
 #define SMB2_OP_MKDIR 5
 #define SMB2_OP_RENAME 6
 #define SMB2_OP_DELETE 7
+#define SMB2_OP_HARDLINK 8
 
 /* Used when constructing chained read requests. */
 #define CHAINED_REQUEST 1
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index f881055..8e69650 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -42,7 +42,7 @@ const struct inode_operations smb2_dir_inode_ops = {
 	.lookup = cifs_lookup,
 	.getattr = cifs_getattr,
 	.unlink = smb2_unlink,
-	.link = cifs_hardlink,
+	.link = smb2_hardlink,
 	.mkdir = smb2_mkdir,
 	.rmdir = smb2_rmdir,
 	.rename = smb2_rename,
@@ -140,7 +140,7 @@ void smb2_set_ops(struct inode *inode)
 	}
 }
 
-static int
+int
 smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *path,
 		   __u32 desired_access, __u32 create_disposition,
 		   __u32 file_attributes, __u32 create_options,
@@ -149,7 +149,7 @@ smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *path,
 	int rc, tmprc = 0;
 	u64 persist_fid, volatile_fid;
 
-	rc = SMB2_open(xid, tcon, srch_path, &persist_fid, &volatile_fid,
+	rc = SMB2_open(xid, tcon, path, &persist_fid, &volatile_fid,
 		       desired_access, create_disposition, file_attributes,
 		       create_options);
 	if (rc)
@@ -171,6 +171,10 @@ smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *path,
 		tmprc = SMB2_rename(xid, tcon, persist_fid, volatile_fid,
 				    (__le16 *)data);
 		break;
+	case SMB2_OP_HARDLINK:
+		tmprc = SMB2_set_hardlink(xid, tcon, persist_fid, volatile_fid,
+					  (__le16 *)data);
+		break;
 	default:
 		cERROR(1, "Invalid command");
 		break;
diff --git a/fs/cifs/smb2link.c b/fs/cifs/smb2link.c
new file mode 100644
index 0000000..8bac250
--- /dev/null
+++ b/fs/cifs/smb2link.c
@@ -0,0 +1,108 @@
+/*
+ *   fs/cifs/smb2link.c
+ *
+ *   Copyright (C) 2011
+ *   Author(s): Pavel Shilovsky (piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org),
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
+#include <linux/namei.h>
+#include "cifsfs.h"
+#include "cifspdu.h"
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "cifs_debug.h"
+#include "cifs_fs_sb.h"
+#include "smb2glob.h"
+#include "smb2proto.h"
+
+int
+smb2_hardlink(struct dentry *old_file, struct inode *inode,
+	      struct dentry *direntry)
+{
+	int rc = -EACCES;
+	int xid;
+	__le16 *from_name = NULL;
+	__le16 *to_name = NULL;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct cifsInodeInfo *cinode;
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	xid = GetXid();
+
+	from_name = build_ucspath_from_dentry(old_file);
+	to_name = build_ucspath_from_dentry(direntry);
+	if ((from_name == NULL) || (to_name == NULL)) {
+		rc = -ENOMEM;
+		goto smb2_hl_exit;
+	}
+
+	rc = smb2_open_op_close(xid, tcon, from_name, FILE_READ_ATTRIBUTES,
+				FILE_OPEN, 0, 0, to_name, SMB2_OP_HARDLINK);
+
+	if ((rc == -EIO) || (rc == -EINVAL))
+		rc = -EOPNOTSUPP;
+
+	d_drop(direntry);	/* force new lookup from server of target */
+
+	/*
+	 * if source file is cached (oplocked) revalidate will not go to server
+	 * until the file is closed or oplock broken so update nlinks locally.
+	 */
+	if (old_file->d_inode) {
+		cinode = CIFS_I(old_file->d_inode);
+		if (rc == 0) {
+			old_file->d_inode->i_nlink++;
+/* BB should we make this contingent on superblock flag NOATIME? */
+/*			old_file->d_inode->i_ctime = CURRENT_TIME;*/
+			/*
+			 * parent dir timestamps will update from srv
+			 * within a second, would it really be worth it
+			 * to set the parent dir cifs inode time to zero
+			 * to force revalidate (faster) for it too?
+			 */
+		}
+		/*
+		 * if not oplocked will force revalidate to get info
+		 * on source file from srv.
+		 */
+		cinode->time = 0;
+
+		/*
+		 * Will update parent dir timestamps from srv within a second.
+		 * Would it really be worth it to set the parent dir (cifs
+		 * inode) time field to zero to force revalidate on parent
+		 * directory faster ie
+			CIFS_I(inode)->time = 0;
+		 */
+	}
+
+smb2_hl_exit:
+	kfree(from_name);
+	kfree(to_name);
+	FreeXid(xid);
+	cifs_put_tlink(tlink);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e5373da..308dd36 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1965,7 +1965,7 @@ set_delete_exit:
 }
 
 int SMB2_set_hardlink(const int xid, struct cifs_tcon *tcon,
-		    u64 persistent_fid, u64 volatile_fid, __le16 *target_file)
+		      u64 persistent_fid, u64 volatile_fid, __le16 *target_file)
 {
 	struct set_info_req *pSMB2;
 	struct set_info_rsp *pSMB2r = NULL;
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 0ed7773..4e7337c 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -109,6 +109,10 @@ extern int smb2_query_file_info(struct file *filp);
 extern int smb2_query_inode_info(struct inode **pinode, const char *full_path,
 				 FILE_ALL_INFO *data, struct super_block *sb,
 				 int xid);
+extern int smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *path,
+			      __u32 desired_access, __u32 create_disposition,
+			      __u32 file_attributes, __u32 create_options,
+			      void *data, int command);
 extern void smb2_set_ops(struct inode *inode);
 extern bool smb2_is_size_safe_to_change(struct smb2_inode *smb2_ind,
 					__u64 end_of_file);
@@ -156,6 +160,8 @@ extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
 extern int smb2_unlink(struct inode *dir, struct dentry *dentry);
 extern int smb2_rename(struct inode *source_dir, struct dentry *source_dentry,
 		       struct inode *target_dir, struct dentry *target_dentry);
+extern int smb2_hardlink(struct dentry *old_file, struct inode *inode,
+			 struct dentry *direntry);
 
 extern int smb2_readdir(struct file *file, void *direntry, filldir_t filldir);
 
-- 
1.7.1
