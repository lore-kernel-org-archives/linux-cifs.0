From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 20/53] CIFS: Add SMB2 support for rmdir operation
Date: Fri, 28 Oct 2011 23:54:31 +0400
Message-ID: <1319831704-3572-21-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/smb2inode.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2proto.h |    1 +
 2 files changed, 60 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 09df087..5947e49 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -42,7 +42,7 @@ const struct inode_operations smb2_dir_inode_ops = {
 	.unlink = cifs_unlink,
 	.link = cifs_hardlink,
 	.mkdir = smb2_mkdir,
-	.rmdir = cifs_rmdir,
+	.rmdir = smb2_rmdir,
 	.rename = cifs_rename,
 	.permission = cifs_permission,
 /*	revalidate:cifs_revalidate,   */
@@ -380,3 +380,61 @@ err_out:
 	d_drop(direntry);
 	goto out;
 }
+
+int smb2_rmdir(struct inode *inode, struct dentry *direntry)
+{
+	int rc = 0;
+	int xid;
+	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	__le16 *ucs_path = NULL;
+	struct cifsInodeInfo *cifsInode;
+
+	cFYI(1, "smb2_rmdir, inode = 0x%p", inode);
+
+	xid = GetXid();
+
+	ucs_path = build_ucspath_from_dentry(direntry);
+	if (ucs_path == NULL) {
+		rc = -ENOMEM;
+		goto rmdir_exit;
+	}
+
+	cifs_sb = CIFS_SB(inode->i_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
+		goto rmdir_exit;
+	}
+	tcon = tlink_tcon(tlink);
+
+	rc = smb2_open_op_close(xid, tcon, ucs_path, DELETE,
+				FILE_OPEN, 0, CREATE_NOT_FILE |
+				CREATE_DELETE_ON_CLOSE, NULL, SMB2_OP_DELETE);
+	cifs_put_tlink(tlink);
+
+	if (!rc) {
+		drop_nlink(inode);
+		spin_lock(&direntry->d_inode->i_lock);
+		i_size_write(direntry->d_inode, 0);
+		clear_nlink(direntry->d_inode);
+		spin_unlock(&direntry->d_inode->i_lock);
+	}
+
+	cifsInode = CIFS_I(direntry->d_inode);
+	cifsInode->time = 0;	/* force revalidate to go get info when
+				   needed */
+
+	cifsInode = CIFS_I(inode);
+	cifsInode->time = 0;	/* force revalidate to get parent dir info
+				   since cached search results now invalid */
+
+	direntry->d_inode->i_ctime = inode->i_ctime = inode->i_mtime =
+		current_fs_time(inode->i_sb);
+
+rmdir_exit:
+	kfree(ucs_path);
+	FreeXid(xid);
+	return rc;
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index c73e664..b1a7801 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -102,6 +102,7 @@ extern int smb2_fsync(struct file *file, int datasync);
 extern int smb2_flush(struct file *file, fl_owner_t id);
 
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
+extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
 
 /* extern char *smb2_compose_mount_options(const char *sb_mountdata,
 			const char *fullpath, const struct dfs_info3_param *ref,
-- 
1.7.1
