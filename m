From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with prefixpath option
Date: Fri, 26 Aug 2011 10:52:21 +0400
Message-ID: <1314341541-2476-1-git-send-email-piastry@etersoft.ru>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reorganize code and make it send qpath info request only for a full
path (//server/share/prefixpath) rather than request for every path
compoment. In this case we end up with negative dentries for all
components except full one and we will instantiate them later if
such a mount is requested.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c  |  123 +++++++++++++++++++++++++++++++----------------------
 fs/cifs/cifsfs.h  |    3 +-
 fs/cifs/inode.c   |    7 ++-
 fs/cifs/readdir.c |    9 +++-
 4 files changed, 85 insertions(+), 57 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 0435bb9..33a2e1e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -95,14 +95,13 @@ mempool_t *smb2_mid_poolp;
 static struct kmem_cache *smb2_mid_cachep;
 #endif /* CONFIG_CIFS_SMB2 */
 
-static int
+static void
 cifs_read_super(struct super_block *sb)
 {
-	struct inode *inode;
-	struct cifs_sb_info *cifs_sb;
-	int rc = 0;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	cifs_sb = CIFS_SB(sb);
+	/* BB should we make this contingent on mount parm? */
+	sb->s_flags |= MS_NODIRATIME | MS_NOATIME;
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
 		sb->s_flags |= MS_POSIXACL;
@@ -120,26 +119,6 @@ cifs_read_super(struct super_block *sb)
 	sb->s_bdi = &cifs_sb->bdi;
 	sb->s_blocksize = CIFS_MAX_MSGSIZE;
 	sb->s_blocksize_bits = 14;	/* default 2**14 = CIFS_MAX_MSGSIZE */
-	inode = cifs_root_iget(sb);
-
-	if (IS_ERR(inode)) {
-		rc = PTR_ERR(inode);
-		inode = NULL;
-		goto out_no_root;
-	}
-
-	sb->s_root = d_alloc_root(inode);
-
-	if (!sb->s_root) {
-		rc = -ENOMEM;
-		goto out_no_root;
-	}
-
-	/* do that *after* d_alloc_root() - we want NULL ->d_op for root here */
-	if (cifs_sb_master_tcon(cifs_sb)->nocase)
-		sb->s_d_op = &cifs_ci_dentry_ops;
-	else
-		sb->s_d_op = &cifs_dentry_ops;
 
 #ifdef CIFS_NFSD_EXPORT
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
@@ -148,14 +127,7 @@ cifs_read_super(struct super_block *sb)
 	}
 #endif /* CIFS_NFSD_EXPORT */
 
-	return 0;
-
-out_no_root:
-	cERROR(1, "cifs_read_super: get root inode failed");
-	if (inode)
-		iput(inode);
-
-	return rc;
+	sb->s_flags |= MS_ACTIVE;
 }
 
 static void cifs_kill_sb(struct super_block *sb)
@@ -529,6 +501,17 @@ static const struct super_operations cifs_super_ops = {
 #endif
 };
 
+static struct dentry *
+cifs_alloc_root(struct super_block *sb)
+{
+	struct qstr q;
+
+	q.name = "/";
+	q.len = 1;
+	q.hash = full_name_hash(q.name, q.len);
+	return d_alloc_pseudo(sb, &q);
+}
+
 /*
  * Get root dentry from superblock according to prefix path mount option.
  * Return dentry with refcount + 1 on success and NULL otherwise.
@@ -536,8 +519,10 @@ static const struct super_operations cifs_super_ops = {
 static struct dentry *
 cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 {
-	struct dentry *dentry;
+	struct dentry *dentry, *found;
+	struct inode *inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct qstr q;
 	char *full_path = NULL;
 	char *s, *p;
 	char sep;
@@ -550,13 +535,29 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 
 	cFYI(1, "Get root dentry for %s", full_path);
 
+	if (!sb->s_root) {
+		sb->s_root = cifs_alloc_root(sb);
+		if (IS_ERR(sb->s_root)) {
+			dentry = ERR_PTR(-ENOMEM);
+			goto out;
+		}
+
+		/*
+		 * do that *after* cifs_alloc_root() - we want NULL ->d_op for
+		 * root here
+		 */
+		if (cifs_sb_master_tcon(cifs_sb)->nocase)
+			sb->s_d_op = &cifs_ci_dentry_ops;
+		else
+			sb->s_d_op = &cifs_dentry_ops;
+	}
+
 	xid = GetXid();
 	sep = CIFS_DIR_SEP(cifs_sb);
 	dentry = dget(sb->s_root);
 	p = s = full_path;
 
 	do {
-		struct inode *dir = dentry->d_inode;
 		struct dentry *child;
 
 		/* skip separators */
@@ -569,16 +570,45 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 		while (*s && *s != sep)
 			s++;
 
-		mutex_lock(&dir->i_mutex);
-		child = lookup_one_len(p, dentry, s - p);
-		mutex_unlock(&dir->i_mutex);
+		q.name = p;
+		q.len = s - p;
+		if (dentry->d_flags & DCACHE_OP_HASH)
+			dentry->d_op->d_hash(dentry, dentry->d_inode, &q);
+		else
+			q.hash = full_name_hash(q.name, q.len);
+
+		child = d_lookup(dentry, &q);
+		if (!child) {
+			child = d_alloc(dentry, &q);
+			if (IS_ERR(child)) {
+				dput(dentry);
+				dentry = ERR_CAST(child);
+				break;
+			}
+			d_rehash(child);
+		}
 		dput(dentry);
 		dentry = child;
-		if (!dentry->d_inode) {
+	} while (!IS_ERR(dentry));
+
+	if (IS_ERR(dentry))
+		goto out;
+
+	if (!dentry->d_inode) {
+		inode = cifs_mntroot_iget(sb, full_path);
+		if (IS_ERR(inode)) {
 			dput(dentry);
-			dentry = ERR_PTR(-ENOENT);
+			dentry = ERR_CAST(inode);
+			goto out;
 		}
-	} while (!IS_ERR(dentry));
+
+		found = d_instantiate_unique(dentry, inode);
+		if (found) {
+			dput(dentry);
+			dentry = dget(found);
+		}
+	}
+out:
 	_FreeXid(xid);
 	kfree(full_path);
 	return dentry;
@@ -646,16 +676,7 @@ cifs_do_mount(struct file_system_type *fs_type,
 		cifs_umount(cifs_sb);
 	} else {
 		sb->s_flags = flags;
-		/* BB should we make this contingent on mount parm? */
-		sb->s_flags |= MS_NODIRATIME | MS_NOATIME;
-
-		rc = cifs_read_super(sb);
-		if (rc) {
-			root = ERR_PTR(rc);
-			goto out_super;
-		}
-
-		sb->s_flags |= MS_ACTIVE;
+		cifs_read_super(sb);
 	}
 
 	root = cifs_get_root(volume_info, sb);
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 3145c18..47d9ec9 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -43,7 +43,8 @@ extern const struct address_space_operations cifs_addr_ops_smallbuf;
 
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
-extern struct inode *cifs_root_iget(struct super_block *);
+extern struct inode *cifs_mntroot_iget(struct super_block *sb,
+				       const char *full_path);
 extern int cifs_create(struct inode *, struct dentry *, int,
 		       struct nameidata *);
 extern struct dentry *cifs_lookup(struct inode *, struct dentry *,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index aee0c0b..dedfed3 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -931,7 +931,7 @@ retry_iget5_locked:
 }
 
 /* gets root inode */
-struct inode *cifs_root_iget(struct super_block *sb)
+struct inode *cifs_mntroot_iget(struct super_block *sb, const char *full_path)
 {
 	int xid;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
@@ -941,9 +941,10 @@ struct inode *cifs_root_iget(struct super_block *sb)
 
 	xid = GetXid();
 	if (tcon->unix_ext)
-		rc = cifs_get_inode_info_unix(&inode, "", sb, xid);
+		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
 	else
-		rc = cifs_get_inode_info(&inode, "", NULL, sb, xid, NULL);
+		rc = cifs_get_inode_info(&inode, full_path, NULL, sb, xid,
+					 NULL);
 
 	if (!inode) {
 		inode = ERR_PTR(rc);
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 75e8b5c..7475cba 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -708,6 +708,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	char *tmp_buf = NULL;
 	char *end_of_smb;
 	unsigned int max_len;
+	ino_t ino;
 
 	xid = GetXid();
 
@@ -732,8 +733,12 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 		}
 		file->f_pos++;
 	case 1:
-		if (filldir(direntry, "..", 2, file->f_pos,
-		     parent_ino(file->f_path.dentry), DT_DIR) < 0) {
+		if (!file->f_path.dentry->d_parent->d_inode) {
+			cFYI(1, "parent dir is negative, filling as current");
+			ino = file->f_path.dentry->d_inode->i_ino;
+		} else
+			ino = parent_ino(file->f_path.dentry);
+		if (filldir(direntry, "..", 2, file->f_pos, ino, DT_DIR) < 0) {
 			cERROR(1, "Filldir for parent dir failed");
 			rc = -ENOMEM;
 			break;
-- 
1.7.1
