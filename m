From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 19/53] CIFS: Add SMB2 support for mkdir operation
Date: Tue, 25 Oct 2011 10:11:52 +0400
Message-ID: <1319523146-2859-20-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/cifsfs.c    |    3 +
 fs/cifs/smb2inode.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2proto.h |    3 +-
 3 files changed, 126 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d402c89..c7b316e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -49,6 +49,9 @@
 #include "cifs_spnego.h"
 #include "fscache.h"
 #define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
 int cifsFYI = 0;
 int cifsERROR = 1;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 13d39e2..722a5b2 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -41,7 +41,7 @@ const struct inode_operations smb2_dir_inode_ops = {
 	.getattr = cifs_getattr,
 	.unlink = cifs_unlink,
 	.link = cifs_hardlink,
-	.mkdir = cifs_mkdir,
+	.mkdir = smb2_mkdir,
 	.rmdir = cifs_rmdir,
 	.rename = cifs_rename,
 	.permission = cifs_permission,
@@ -220,21 +220,37 @@ out:
 	return rc;
 }
 
-int smb2_get_inode_info(struct inode **pinode, const char *full_path,
-			FILE_ALL_INFO *data, struct super_block *sb,
-			int xid, struct cifs_tcon *tcon)
+int
+smb2_query_inode_info(struct inode **pinode, const char *full_path,
+		      FILE_ALL_INFO *data, struct super_block *sb, int xid)
 {
 	int rc = 0;
+	struct cifs_tcon *tcon;
+	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	char *buf = NULL;
 	struct cifs_fattr fattr;
 
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	cFYI(1, "Getting info on %s", full_path);
+
+	if ((data == NULL) && (*pinode != NULL)) {
+		if (CIFS_I(*pinode)->clientCanCacheRead) {
+			cFYI(1, "No need to revalidate cached inode sizes");
+			goto sqii_exit;
+		}
+	}
+
 	/* if file info not passed in then get it from server */
 	if (data == NULL) {
 		buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 		if (buf == NULL) {
 			rc = -ENOMEM;
-			goto sgii_exit;
+			goto sqii_exit;
 		}
 		data = (FILE_ALL_INFO *)buf;
 		rc = smb2_qinfo_helper(xid, cifs_sb, tcon, full_path, data);
@@ -247,7 +263,7 @@ int smb2_get_inode_info(struct inode **pinode, const char *full_path,
 		cifs_create_dfs_fattr(&fattr, sb);
 		rc = 0;
 	} else {
-		goto sgii_exit;
+		goto sqii_exit;
 	}
 
 	if (*pinode == NULL)
@@ -263,7 +279,105 @@ int smb2_get_inode_info(struct inode **pinode, const char *full_path,
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
-sgii_exit:
+sqii_exit:
 	kfree(buf);
+	cifs_put_tlink(tlink);
+	return rc;
+}
+
+int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode)
+{
+	int rc = 0, tmprc;
+	int xid;
+	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct inode *newinode = NULL;
+	__le16 *ucs_path = NULL;
+	char *full_path = NULL;
+
+	cFYI(1, "In mkdir, mode = 0x%x inode = 0x%p", mode, inode);
+
+	cifs_sb = CIFS_SB(inode->i_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	xid = GetXid();
+
+	full_path = build_path_from_dentry(direntry);
+	if (full_path == NULL) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	ucs_path = cifs_convert_path_to_ucs(full_path, cifs_sb->local_nls);
+	if (ucs_path == NULL) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	rc = smb2_open_op_close(xid, tcon, ucs_path, FILE_WRITE_ATTRIBUTES_LE,
+				FILE_CREATE_LE, 0, FILE_DIRECTORY_FILE_LE, NULL,
+				SMB2_OP_MKDIR);
+	if (rc)
+		goto err_out;
+
+	inc_nlink(inode);
+
+	rc = cifs_get_inode_info(&newinode, full_path, NULL, inode->i_sb, xid,
+				 NULL);
+
+	d_instantiate(direntry, newinode);
+	 /* setting nlink not necessary except in cases where we
+	  * failed to get it from the server or was set bogus */
+	if ((direntry->d_inode) && (direntry->d_inode->i_nlink < 2))
+		direntry->d_inode->i_nlink = 2;
+
+	mode &= ~current_umask();
+	/* must turn on setgid bit if parent dir has it */
+	if (inode->i_mode & S_ISGID)
+		mode |= S_ISGID;
+
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
+	    (mode & S_IWUGO) == 0) {
+		FILE_BASIC_INFO data;
+		struct cifsInodeInfo *cifs_i;
+		u32 dosattrs;
+		memset(&data, 0, sizeof(data));
+		cifs_i = CIFS_I(newinode);
+		dosattrs = cifs_i->cifsAttrs | ATTR_READONLY;
+		data.Attributes = cpu_to_le32(dosattrs);
+		tmprc = smb2_open_op_close(xid, tcon, ucs_path,
+					   FILE_WRITE_ATTRIBUTES_LE,
+					   FILE_CREATE_LE, 0,
+					   FILE_DIRECTORY_FILE_LE, &data,
+					   SMB2_OP_SET_INFO);
+		if (tmprc == 0)
+			cifs_i->cifsAttrs = dosattrs;
+	}
+
+	if (direntry->d_inode) {
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+			direntry->d_inode->i_mode = (mode | S_IFDIR);
+
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+			direntry->d_inode->i_uid = current_fsuid();
+			if (inode->i_mode & S_ISGID)
+				direntry->d_inode->i_gid = inode->i_gid;
+			else
+				direntry->d_inode->i_gid = current_fsgid();
+		}
+	}
+
+out:
+	kfree(ucs_path);
+	FreeXid(xid);
+	cifs_put_tlink(tlink);
 	return rc;
+err_out:
+	cFYI(1, "smb2_mkdir returned 0x%x", rc);
+	d_drop(direntry);
+	goto out;
 }
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 888c796..091e0f5 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -53,7 +53,6 @@ extern int checkSMB2(struct smb2_hdr *smb2, __u64 mid, unsigned int length);
 extern char *smb2_get_data_area_len(int *poff, int *pln, struct smb2_hdr *psmb);
 extern unsigned int smb2_calc_size(struct smb2_hdr *ptr);
 extern int map_smb2_to_linux_error(struct smb2_hdr *smb2, int logErr);
-extern __le16 *cifs_build_ucspath_from_dentry(struct dentry *);
 extern __le16 *cifs_convert_path_to_ucs(const char *from,
 					struct nls_table *local_nls);
 
@@ -102,6 +101,8 @@ extern void cifs_fattr_to_inode(struct inode *pinode, struct cifs_fattr *attr);
 extern int smb2_fsync(struct file *file, int datasync);
 extern int smb2_flush(struct file *file, fl_owner_t id);
 
+extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
+
 /* extern char *smb2_compose_mount_options(const char *sb_mountdata,
 			const char *fullpath, const struct dfs_info3_param *ref,
 			char **devname);
-- 
1.7.1
