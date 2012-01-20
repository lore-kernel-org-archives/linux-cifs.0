From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 21/50] CIFS: Add SMB2 support for unlink operation
Date: Fri, 20 Jan 2012 12:34:42 +0400
Message-ID: <1327048511-2342-21-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2inode.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2proto.h |    1 +
 2 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 73cf635..667723a 100644
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
@@ -442,3 +442,67 @@ rmdir_exit:
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
+	__le16 *utf16_path = NULL;
+
+	cFYI(1, "%s: dir=0x%p, dentry=0x%p", __func__, dir, dentry);
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	xid = GetXid();
+
+	/*
+	 * Unlink can be called from rename so we can not take the
+	 * sb->s_vfs_rename_mutex here.
+	 */
+	utf16_path = cifs_build_utf16path_from_dentry(dentry);
+	if (utf16_path == NULL) {
+		rc = -ENOMEM;
+		goto unlink_out;
+	}
+
+	rc = smb2_open_op_close(xid, tcon, utf16_path, DELETE,
+				FILE_OPEN, 0, CREATE_DELETE_ON_CLOSE, NULL,
+				SMB2_OP_DELETE);
+	if (!rc) {
+		if (inode)
+			drop_nlink(inode);
+	} else if (rc == -ENOENT) {
+		d_drop(dentry);
+	} else if (rc == -ETXTBSY) {
+		/* rc = cifs_rename_pending_delete(full_path, dentry, xid);
+		if (rc == 0)
+			drop_nlink(inode); */
+	} else if ((rc == -EACCES) && inode)
+		/* BB reset dos attributes and retry once */
+
+	/* BB undo the setattr if we errored out and it's needed */
+	if (inode) {
+		cifs_inode = CIFS_I(inode);
+		/* will force revalidate to get info when needed */
+		cifs_inode->time = 0;
+		inode->i_ctime = current_fs_time(sb);
+	}
+	dir->i_ctime = dir->i_mtime = current_fs_time(sb);
+	cifs_inode = CIFS_I(dir);
+	/* force revalidate of dir as well */
+	CIFS_I(dir)->time = 0;
+unlink_out:
+	kfree(utf16_path);
+	FreeXid(xid);
+	cifs_put_tlink(tlink);
+	return rc;
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 8c2f734..32c064c 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -60,6 +60,7 @@ extern int smb2_query_inode_info(struct inode **pinode, const char *full_path,
 extern void smb2_set_ops(struct inode *inode);
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
+extern int smb2_unlink(struct inode *dir, struct dentry *dentry);
 
 /*
  *  SMB2 Worker functions - most of protocol specific implementation details
-- 
1.7.1
