From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 37/53] CIFS: Add SMB2 support for rename operation
Date: Tue, 25 Oct 2011 10:12:10 +0400
Message-ID: <1319523146-2859-38-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2inode.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2proto.h |    2 +
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index a47544e..d48d78f 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -45,7 +45,7 @@ const struct inode_operations smb2_dir_inode_ops = {
 	.link = cifs_hardlink,
 	.mkdir = smb2_mkdir,
 	.rmdir = smb2_rmdir,
-	.rename = cifs_rename,
+	.rename = smb2_rename,
 	.permission = cifs_permission,
 /*	revalidate:cifs_revalidate,   */
 	.setattr = cifs_setattr,
@@ -63,7 +63,7 @@ const struct inode_operations smb2_file_inode_ops = {
 /*	revalidate:cifs_revalidate, */
 	.setattr = cifs_setattr,
 	.getattr = cifs_getattr, /* do we need this anymore? */
-	.rename = cifs_rename,
+	.rename = smb2_rename,
 	.permission = cifs_permission,
 #ifdef CONFIG_CIFS_XATTR
 	.setxattr = cifs_setxattr,
@@ -167,6 +167,10 @@ smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *srch_path,
 		/* Directories are created through parameters in the
 		 * SMB2_open() call. */
 		break;
+	case SMB2_OP_RENAME:
+		tmprc = SMB2_rename(xid, tcon, persist_fid, volatile_fid,
+				    (__le16 *)data);
+		break;
 	default:
 		cERROR(1, "Invalid command");
 		break;
@@ -751,3 +755,67 @@ smb2_create_out:
 	FreeXid(xid);
 	return rc;
 }
+
+static int
+smb2_do_rename(struct dentry *from_dentry, __le16 *from_path,
+	       struct dentry *to_dentry, __le16 *to_path)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(from_dentry->d_sb);
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	int rc, xid;
+
+	xid = GetXid();
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	rc = smb2_open_op_close(xid, tcon, from_path, FILE_DELETE_LE,
+				FILE_OPEN_LE, 0, 0, to_path, SMB2_OP_RENAME);
+
+	cifs_put_tlink(tlink);
+	FreeXid(xid);
+	return rc;
+}
+
+int smb2_rename(struct inode *source_dir, struct dentry *source_dentry,
+		struct inode *target_dir, struct dentry *target_dentry)
+{
+	__le16 *from_name = NULL;
+	__le16 *to_name = NULL;
+	int rc, tmprc;
+
+	/*
+	 * we already have the rename sem so we do not need to
+	 * grab it again here to protect the path integrity
+	 */
+	from_name = build_ucspath_from_dentry(source_dentry);
+	if (from_name == NULL) {
+		rc = -ENOMEM;
+		goto smb2_rename_exit;
+	}
+
+	to_name = build_ucspath_from_dentry(target_dentry);
+	if (to_name == NULL) {
+		rc = -ENOMEM;
+		goto smb2_rename_exit;
+	}
+
+	rc = smb2_do_rename(source_dentry, from_name, target_dentry, to_name);
+
+	/* Try unlinking the target dentry if it's not negative */
+	if (target_dentry->d_inode && (rc == -EACCES || rc == -EEXIST)) {
+		tmprc = smb2_unlink(target_dir, target_dentry);
+		if (tmprc)
+			goto smb2_rename_exit;
+
+		rc = smb2_do_rename(source_dentry, from_name, target_dentry,
+				    to_name);
+	}
+
+smb2_rename_exit:
+	kfree(from_name);
+	kfree(to_name);
+	return rc;
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 070eec9..a9be5de 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -154,6 +154,8 @@ extern int smb2_create(struct inode *dir, struct dentry *direntry, int mode,
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
 extern int smb2_unlink(struct inode *dir, struct dentry *dentry);
+extern int smb2_rename(struct inode *source_dir, struct dentry *source_dentry,
+		       struct inode *target_dir, struct dentry *target_dentry);
 
 extern int smb2_readdir(struct file *file, void *direntry, filldir_t filldir);
 
-- 
1.7.1
