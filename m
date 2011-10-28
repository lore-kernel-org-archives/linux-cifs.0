From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 34/53] [CIFS] Add SMB2 support for cifs_get_file_info
Date: Fri, 28 Oct 2011 23:54:45 +0400
Message-ID: <1319831704-3572-35-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/inode.c     |   18 +++++++++++++++---
 fs/cifs/smb2inode.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h |    1 +
 3 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a465d04..9db398e 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -568,7 +568,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 	fattr->cf_gid = cifs_sb->mnt_gid;
 }
 
-int cifs_get_file_info(struct file *filp)
+static int
+cifs_query_file_info(struct file *filp)
 {
 	int rc;
 	int xid;
@@ -599,7 +600,7 @@ int cifs_get_file_info(struct file *filp)
 		rc = 0;
 		CIFS_I(inode)->time = 0;
 	default:
-		goto cgfi_exit;
+		goto cqfi_exit;
 	}
 
 	/*
@@ -609,11 +610,22 @@ int cifs_get_file_info(struct file *filp)
 	fattr.cf_uniqueid = CIFS_I(inode)->uniqueid;
 	fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
 	cifs_fattr_to_inode(inode, &fattr);
-cgfi_exit:
+cqfi_exit:
 	FreeXid(xid);
 	return rc;
 }
 
+int cifs_get_file_info(struct file *filp)
+{
+#ifdef CONFIG_CIFS_SMB2
+	struct cifsFileInfo *cfile = filp->private_data;
+
+	if (tlink_tcon(cfile->tlink)->ses->server->is_smb2)
+		return smb2_query_file_info(filp);
+#endif
+	return cifs_query_file_info(filp);
+}
+
 static int
 cifs_query_inode_info(struct inode **pinode, const char *full_path,
 			FILE_ALL_INFO *data, struct super_block *sb, int xid,
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 1d21185..17297e4 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -284,6 +284,48 @@ sqii_exit:
 	return rc;
 }
 
+int smb2_query_file_info(struct file *filp)
+{
+	int rc;
+	int xid;
+	FILE_ALL_INFO find_data;
+	struct cifs_fattr fattr;
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsFileInfo *cfile = filp->private_data;
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+	FILE_ALL_INFO_SMB2 *smb2_data;
+
+	smb2_data = kzalloc(sizeof(FILE_ALL_INFO_SMB2) + MAX_NAME*2,
+			    GFP_KERNEL);
+	if (smb2_data == NULL)
+		return -ENOMEM;
+
+	xid = GetXid();
+	rc = SMB2_query_info(xid, tcon, cfile->persist_fid,
+			     cfile->volatile_fid, smb2_data);
+	if (!rc) {
+		move_smb2_info_to_cifs(&find_data, smb2_data);
+		cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false);
+	} else if (rc == -EREMOTE) {
+		cifs_create_dfs_fattr(&fattr, inode->i_sb);
+		rc = 0;
+	} else
+		goto sqfi_exit;
+
+	/*
+	 * don't bother with SFU junk here -- just mark inode as needing
+	 * revalidation.
+	 */
+	fattr.cf_uniqueid = CIFS_I(inode)->uniqueid;
+	fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
+	cifs_fattr_to_inode(inode, &fattr);
+sqfi_exit:
+	FreeXid(xid);
+	kfree(smb2_data);
+	return rc;
+}
+
 int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 {
 	int rc = 0, tmprc;
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 45ce215..73bc050 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -105,6 +105,7 @@ extern int smb2_setup_session(unsigned int xid, struct cifs_ses *pses_info,
 extern int smb2_umount(struct super_block *, struct cifs_sb_info *);
 
 extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst, FILE_ALL_INFO_SMB2 *src);
+extern int smb2_query_file_info(struct file *filp);
 extern int smb2_query_inode_info(struct inode **pinode, const char *full_path,
 				 FILE_ALL_INFO *data, struct super_block *sb,
 				 int xid);
-- 
1.7.1
