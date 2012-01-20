From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 18/50] CIFS: Add SMB2 inode/dentry ops structures
Date: Fri, 20 Jan 2012 12:34:39 +0400
Message-ID: <1327048511-2342-18-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/cifsfs.c    |    2 +-
 fs/cifs/cifsfs.h    |    2 +-
 fs/cifs/inode.c     |   21 +++++++++-
 fs/cifs/smb2dir.c   |    8 ++++
 fs/cifs/smb2inode.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h |    7 +++
 6 files changed, 138 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a9a88a7..4869540 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -210,7 +210,7 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-static int cifs_permission(struct inode *inode, int mask)
+int cifs_permission(struct inode *inode, int mask)
 {
 	struct cifs_sb_info *cifs_sb;
 
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 30ff560..2009adc 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -62,12 +62,12 @@ extern int cifs_revalidate_dentry(struct dentry *);
 extern int cifs_invalidate_mapping(struct inode *inode);
 extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int cifs_setattr(struct dentry *, struct iattr *);
+extern int cifs_permission(struct inode *inode, int mask);
 
 extern const struct inode_operations cifs_file_inode_ops;
 extern const struct inode_operations cifs_symlink_inode_ops;
 extern const struct inode_operations cifs_dfs_referral_inode_operations;
 
-
 /* Functions related to files and directories */
 extern const struct file_operations cifs_file_ops;
 extern const struct file_operations cifs_file_direct_ops; /* if directio mnt */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 8ea171f..5fec88f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -87,8 +87,23 @@ static void cifs_set_ops(struct inode *inode)
 	}
 }
 
-/* check inode attributes against fattr. If they don't match, tag the
- * inode for cache invalidation
+static void cifs_set_ops_generic(struct inode *inode)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_tcon *tcon;
+
+	tcon = cifs_sb_master_tcon(cifs_sb);
+#ifdef CONFIG_CIFS_SMB2
+	if (tcon->ses->server->is_smb2)
+		smb2_set_ops(inode);
+	else
+#endif
+		cifs_set_ops(inode);
+}
+
+/*
+ * Check inode attributes against fattr. If they don't match, tag the
+ * inode for cache invalidation.
  */
 static void
 cifs_revalidate_cache(struct inode *inode, struct cifs_fattr *fattr)
@@ -177,7 +192,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 
 	if (fattr->cf_flags & CIFS_FATTR_DFS_REFERRAL)
 		inode->i_flags |= S_AUTOMOUNT;
-	cifs_set_ops(inode);
+	cifs_set_ops_generic(inode);
 }
 
 void
diff --git a/fs/cifs/smb2dir.c b/fs/cifs/smb2dir.c
index 7d7387d..92b664f 100644
--- a/fs/cifs/smb2dir.c
+++ b/fs/cifs/smb2dir.c
@@ -35,6 +35,14 @@
 #include "smb2glob.h"
 #include "smb2proto.h"
 
+const struct file_operations smb2_dir_ops = {
+	.readdir = cifs_readdir,
+	.release = cifs_closedir,
+	.read    = generic_read_dir,
+	.unlocked_ioctl  = cifs_ioctl,
+	.llseek = generic_file_llseek,
+};
+
 /* Note: caller must free return buffer */
 __le16 *
 cifs_convert_path_to_utf16(const char *from, struct nls_table *local_nls)
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 858f370..c7462ac 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -35,6 +35,109 @@
 #include "smb2glob.h"
 #include "smb2proto.h"
 
+const struct inode_operations smb2_dir_inode_ops = {
+	.create = cifs_create,
+	.lookup = cifs_lookup,
+	.getattr = cifs_getattr,
+	.unlink = cifs_unlink,
+	.link = cifs_hardlink,
+	.mkdir = cifs_mkdir,
+	.rmdir = cifs_rmdir,
+	.rename = cifs_rename,
+	.permission = cifs_permission,
+/*	revalidate:cifs_revalidate,   */
+	.setattr = cifs_setattr,
+	.symlink = cifs_symlink,
+	.mknod   = cifs_mknod,
+#ifdef CONFIG_CIFS_XATTR
+	.setxattr = cifs_setxattr,
+	.getxattr = cifs_getxattr,
+	.listxattr = cifs_listxattr,
+	.removexattr = cifs_removexattr,
+#endif
+};
+
+const struct inode_operations smb2_file_inode_ops = {
+/*	revalidate:cifs_revalidate, */
+	.setattr = cifs_setattr,
+	.getattr = cifs_getattr, /* do we need this anymore? */
+	.rename = cifs_rename,
+	.permission = cifs_permission,
+#ifdef CONFIG_CIFS_XATTR
+	.setxattr = cifs_setxattr,
+	.getxattr = cifs_getxattr,
+	.listxattr = cifs_listxattr,
+	.removexattr = cifs_removexattr,
+#endif
+};
+
+const struct inode_operations smb2_symlink_inode_ops = {
+	.readlink = generic_readlink,
+	.follow_link = cifs_follow_link,
+	.put_link = cifs_put_link,
+	.permission = cifs_permission,
+	/* BB add the following two eventually */
+	/* revalidate: cifs_revalidate,
+	   setattr:    cifs_notify_change, *//* BB do we need notify change */
+#ifdef CONFIG_CIFS_XATTR
+	.setxattr = cifs_setxattr,
+	.getxattr = cifs_getxattr,
+	.listxattr = cifs_listxattr,
+	.removexattr = cifs_removexattr,
+#endif
+};
+
+void smb2_set_ops(struct inode *inode)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFREG:
+		inode->i_op = &smb2_file_inode_ops;
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
+			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+				inode->i_fop = &cifs_file_direct_nobrl_ops;
+			else
+				inode->i_fop = &cifs_file_direct_ops;
+		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
+			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+				inode->i_fop = &cifs_file_strict_nobrl_ops;
+			else
+				inode->i_fop = &cifs_file_strict_ops;
+		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+			inode->i_fop = &cifs_file_nobrl_ops;
+		else { /* not direct, send byte range locks */
+			inode->i_fop = &cifs_file_ops;
+		}
+
+		/* check if server can support readpages */
+		if (cifs_sb_master_tcon(cifs_sb)->ses->server->max_read <
+				PAGE_CACHE_SIZE)
+			inode->i_data.a_ops = &cifs_addr_ops_smallbuf;
+		else
+			inode->i_data.a_ops = &cifs_addr_ops;
+		break;
+	case S_IFDIR:
+#ifdef CONFIG_CIFS_DFS_UPCALL
+		if (IS_AUTOMOUNT(inode)) {
+			inode->i_op = &cifs_dfs_referral_inode_operations;
+		} else {
+#else /* NO DFS support, treat as a directory */
+		{
+#endif
+			inode->i_op = &smb2_dir_inode_ops;
+			inode->i_fop = &smb2_dir_ops;
+		}
+		break;
+	case S_IFLNK:
+		inode->i_op = &smb2_symlink_inode_ops;
+		break;
+	default:
+		init_special_inode(inode, inode->i_mode, inode->i_rdev);
+		break;
+	}
+}
+
 static int
 smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *srch_path,
 		   __u32 desired_access, __u32 create_disposition,
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index f4996e3..8e98cf6 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -26,6 +26,12 @@
 
 struct statfs;
 
+extern const struct inode_operations smb2_file_inode_ops;
+extern const struct inode_operations smb2_dir_inode_ops;
+extern const struct inode_operations smb2_symlink_inode_ops;
+
+extern const struct file_operations smb2_dir_ops;
+
 /*
  *****************************************************************
  * All Prototypes
@@ -50,6 +56,7 @@ extern int smb2_setup_session(unsigned int xid, struct cifs_ses *psesinfo,
 extern int smb2_query_inode_info(struct inode **pinode, const char *full_path,
 				 FILE_ALL_INFO *data, struct super_block *sb,
 				 int xid);
+extern void smb2_set_ops(struct inode *inode);
 
 /*
  *  SMB2 Worker functions - most of protocol specific implementation details
-- 
1.7.1
