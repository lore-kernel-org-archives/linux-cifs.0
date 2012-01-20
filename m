From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 20/50] CIFS: Add SMB2 support for rmdir operation
Date: Fri, 20 Jan 2012 12:34:41 +0400
Message-ID: <1327048511-2342-20-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/smb2dir.c   |   16 +++++++++++++
 fs/cifs/smb2inode.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2proto.h |    2 +
 3 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/smb2dir.c b/fs/cifs/smb2dir.c
index 92b664f..cf0e966 100644
--- a/fs/cifs/smb2dir.c
+++ b/fs/cifs/smb2dir.c
@@ -59,3 +59,19 @@ cifs_convert_path_to_utf16(const char *from, struct nls_table *local_nls)
 	to = cifs_strndup_to_utf16(start_of_path, PATH_MAX, &len, local_nls);
 	return to;
 }
+
+__le16 *
+cifs_build_utf16path_from_dentry(struct dentry *direntry)
+{
+	char *path;
+	__le16 *utf16_path;
+
+	path = build_path_from_dentry(direntry);
+	if (path == NULL)
+		return NULL;
+
+	utf16_path = cifs_convert_path_to_utf16(path,
+					CIFS_SB(direntry->d_sb)->local_nls);
+	kfree(path);
+	return utf16_path;
+}
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 9c634f0..73cf635 100644
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
@@ -381,3 +381,64 @@ err_out:
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
+	__le16 *utf16_path = NULL;
+	struct cifsInodeInfo *cifsInode;
+
+	cFYI(1, "%s: inode = 0x%p", __func__, inode);
+
+	xid = GetXid();
+
+	utf16_path = cifs_build_utf16path_from_dentry(direntry);
+	if (utf16_path == NULL) {
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
+	rc = smb2_open_op_close(xid, tcon, utf16_path, DELETE, FILE_OPEN, 0,
+				CREATE_NOT_FILE | CREATE_DELETE_ON_CLOSE, NULL,
+				SMB2_OP_DELETE);
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
+	/* force revalidate to go get info when needed */
+	cifsInode->time = 0;
+
+	cifsInode = CIFS_I(inode);
+	/*
+	 * force revalidate to get parent dir info since cached search results
+	 * now invalid
+	 */
+	cifsInode->time = 0;
+
+	direntry->d_inode->i_ctime = inode->i_ctime = inode->i_mtime =
+		current_fs_time(inode->i_sb);
+
+rmdir_exit:
+	kfree(utf16_path);
+	FreeXid(xid);
+	return rc;
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 52eea64..8c2f734 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -44,6 +44,7 @@ extern char *smb2_get_data_area_len(int *poff, int *plen,
 				     struct smb2_hdr *pSMB2);
 extern __le16 *cifs_convert_path_to_utf16(const char *from,
 					  struct nls_table *local_nls);
+extern __le16 *cifs_build_utf16path_from_dentry(struct dentry *direntry);
 
 extern int smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
 			 struct kvec *vec, int nvec, int *ret_buf_type,
@@ -58,6 +59,7 @@ extern int smb2_query_inode_info(struct inode **pinode, const char *full_path,
 				 int xid);
 extern void smb2_set_ops(struct inode *inode);
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
+extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
 
 /*
  *  SMB2 Worker functions - most of protocol specific implementation details
-- 
1.7.1
