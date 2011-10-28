From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 21/53] CIFS: Add SMB2 support for unlink operation
Date: Fri, 28 Oct 2011 23:54:32 +0400
Message-ID: <1319831704-3572-22-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/smb2inode.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2proto.h |    1 +
 2 files changed, 90 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 5947e49..9111153 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -39,7 +39,7 @@ const struct inode_operations smb2_dir_inode_ops = {
 	.create = cifs_create,
 	.lookup = cifs_lookup,
 	.getattr = cifs_getattr,
-	.unlink = cifs_unlink,
+	.unlink = smb2_unlink,
 	.link = cifs_hardlink,
 	.mkdir = smb2_mkdir,
 	.rmdir = smb2_rmdir,
@@ -438,3 +438,91 @@ rmdir_exit:
 	FreeXid(xid);
 	return rc;
 }
+
+int smb2_unlink(struct inode *dir, struct dentry *dentry)
+{
+	int rc = 0;
+	int xid;
+	struct inode *inode = dentry->d_inode;
+	struct cifsInodeInfo *cifs_inode;
+	struct super_block *sb = dir->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct iattr *attrs = NULL;
+	__le16 *ucs_path = NULL;
+	__u32 dosattr = 0, origattr = 0;
+
+	cFYI(1, "smb2_unlink, dir=0x%p, dentry=0x%p", dir, dentry);
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	xid = GetXid();
+
+	/* Unlink can be called from rename so we can not take the
+	 * sb->s_vfs_rename_mutex here */
+	ucs_path = build_ucspath_from_dentry(dentry);
+	if (ucs_path == NULL) {
+		rc = -ENOMEM;
+		goto unlink_out;
+	}
+
+	rc = smb2_open_op_close(xid, tcon, ucs_path, DELETE,
+				FILE_OPEN, 0, CREATE_DELETE_ON_CLOSE, NULL,
+				SMB2_OP_DELETE);
+	if (!rc) {
+		if (inode)
+			drop_nlink(inode);
+	} else if (rc == -ENOENT) {
+		d_drop(dentry);
+	} else if (rc == -ETXTBSY) {
+		/*rc = cifs_rename_pending_delete(full_path, dentry, xid);
+		if (rc == 0)
+			drop_nlink(inode);*/
+	} else if ((rc == -EACCES) && (dosattr == 0) && inode) {
+		attrs = kzalloc(sizeof(*attrs), GFP_KERNEL);
+		if (attrs == NULL) {
+			rc = -ENOMEM;
+			goto out_reval;
+		}
+
+		/* try to reset dos attributes */
+		cifs_inode = CIFS_I(inode);
+		origattr = cifs_inode->cifsAttrs;
+		if (origattr == 0)
+			origattr |= ATTR_NORMAL;
+		dosattr = origattr & ~ATTR_READONLY;
+		if (dosattr == 0)
+			dosattr |= ATTR_NORMAL;
+		dosattr |= ATTR_HIDDEN;
+
+/*		rc = cifs_set_file_info(inode, attrs, xid, full_path, dosattr);
+		if (rc != 0)
+			goto out_reval;
+
+		goto retry_std_delete;*/
+	}
+
+	/* undo the setattr if we errored out and it's needed */
+/*	if (rc != 0 && dosattr != 0)
+		cifs_set_file_info(inode, attrs, xid, full_path, origattr);*/
+out_reval:
+	if (inode) {
+		cifs_inode = CIFS_I(inode);
+		cifs_inode->time = 0;	/* will force revalidate to get info
+					   when needed */
+		inode->i_ctime = current_fs_time(sb);
+	}
+	dir->i_ctime = dir->i_mtime = current_fs_time(sb);
+	cifs_inode = CIFS_I(dir);
+	CIFS_I(dir)->time = 0;	/* force revalidate of dir as well */
+unlink_out:
+	kfree(attrs);
+	kfree(ucs_path);
+	FreeXid(xid);
+	cifs_put_tlink(tlink);
+	return rc;
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index b1a7801..2c5cf2c 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -103,6 +103,7 @@ extern int smb2_flush(struct file *file, fl_owner_t id);
 
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
+extern int smb2_unlink(struct inode *dir, struct dentry *dentry);
 
 /* extern char *smb2_compose_mount_options(const char *sb_mountdata,
 			const char *fullpath, const struct dfs_info3_param *ref,
-- 
1.7.1
