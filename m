From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: cifs and win2k8
Date: Tue,  1 Nov 2011 21:13:05 +0300
Message-ID: <1320171185-11150-1-git-send-email-piastry@etersoft.ru>
References: <20111024073534.GB7086@cobija.connexer.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111024073534.GB7086-Znhnm/lQSyjxW5zecs3cv0EOCMrvLtNR@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sorry for so long delay on this. Here is the fixed version of the patch:

[PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with prefixpath option

but I found out one use case where it doesn't work right:

1) mount //server/share/a/b/ test
2) mount //server/share/ test2
3) stat test2/a/b - return wrong inode number (autodisable server inode number happens)

In the same time if I add "ls test2" before step #3 it works! May be VFS can't
handle negative dentry with children in this case, but I am not sure.

Reorganize code and make it send qpath info request only for a full
path (//server/share/prefixpath) rather than request for every path
compoment. In this case we end up with negative dentries for all
components except full one and we will instantiate them later if
such a mount is requested.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c   |  138 +++++++++++++++++++++++++++++++--------------------
 fs/cifs/cifsfs.h   |    3 +-
 fs/cifs/cifsglob.h |    6 ++
 fs/cifs/dir.c      |    3 +-
 fs/cifs/inode.c    |    7 ++-
 fs/cifs/readdir.c  |   43 ++++++++++------
 6 files changed, 124 insertions(+), 76 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8f1fe32..a188be1 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -90,14 +90,13 @@ extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
 
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
@@ -115,26 +114,6 @@ cifs_read_super(struct super_block *sb)
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
 
 #ifdef CONFIG_CIFS_NFSD_EXPORT
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
@@ -143,14 +122,7 @@ cifs_read_super(struct super_block *sb)
 	}
 #endif /* CONFIG_CIFS_NFSD_EXPORT */
 
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
@@ -528,6 +500,17 @@ static const struct super_operations cifs_super_ops = {
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
@@ -535,8 +518,10 @@ static const struct super_operations cifs_super_ops = {
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
@@ -548,20 +533,30 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 
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
 	sep = CIFS_DIR_SEP(cifs_sb);
 	dentry = dget(sb->s_root);
 	p = s = full_path;
 
 	do {
-		struct inode *dir = dentry->d_inode;
 		struct dentry *child;
 
-		if (!dir) {
-			dput(dentry);
-			dentry = ERR_PTR(-ENOENT);
-			break;
-		}
-
 		/* skip separators */
 		while (*s == sep)
 			s++;
@@ -572,12 +567,55 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
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
 	} while (!IS_ERR(dentry));
+
+	if (IS_ERR(dentry))
+		goto out;
+
+	mutex_lock(&cifs_root_mutex);
+
+	if (dentry->d_parent->d_inode)
+		mutex_lock(&dentry->d_parent->d_inode->i_mutex);
+
+	if (!dentry->d_inode) {
+		inode = cifs_mntroot_iget(sb, full_path);
+		if (IS_ERR(inode)) {
+			dput(dentry);
+			dentry = ERR_CAST(inode);
+			goto out;
+		}
+
+		found = d_instantiate_unique(dentry, inode);
+		if (found) {
+			dput(dentry);
+			dentry = found;
+		}
+	}
+
+	if (dentry->d_parent->d_inode)
+		mutex_unlock(&dentry->d_parent->d_inode->i_mutex);
+
+	mutex_unlock(&cifs_root_mutex);
+out:
 	kfree(full_path);
 	return dentry;
 }
@@ -644,16 +682,7 @@ cifs_do_mount(struct file_system_type *fs_type,
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
@@ -1112,6 +1141,7 @@ init_cifs(void)
 	spin_lock_init(&cifs_tcp_ses_lock);
 	spin_lock_init(&cifs_file_list_lock);
 	spin_lock_init(&GlobalMid_Lock);
+	mutex_init(&cifs_root_mutex);
 
 	if (cifs_max_pending < 2) {
 		cifs_max_pending = 2;
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 30ff560..cf28150 100644
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
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8238aa1..67f6852 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -958,6 +958,12 @@ GLOBAL_EXTERN spinlock_t		cifs_tcp_ses_lock;
  */
 GLOBAL_EXTERN spinlock_t	cifs_file_list_lock;
 
+/*
+ * This lock protects root dentry in cifs_get_root from being instantiated
+ * twice.
+ */
+GLOBAL_EXTERN struct mutex cifs_root_mutex;
+
 #ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
 /* Outstanding dir notify requests */
 GLOBAL_EXTERN struct list_head GlobalDnotifyReqList;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index d7eeb9d..d6b3319 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -553,6 +553,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 
 	if (direntry->d_inode != NULL) {
 		cFYI(1, "non-NULL inode in lookup");
+		newInode = direntry->d_inode;
 	} else {
 		cFYI(1, "NULL inode in lookup");
 	}
@@ -596,7 +597,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		rc = cifs_get_inode_info(&newInode, full_path, NULL,
 				parent_dir_inode->i_sb, xid, NULL);
 
-	if ((rc == 0) && (newInode != NULL)) {
+	if ((rc == 0) && (newInode != NULL) && !direntry->d_inode) {
 		d_add(direntry, newInode);
 		if (posix_open) {
 			filp = lookup_instantiate_filp(nd, direntry,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 2c50bd2..7b7fccd 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -878,7 +878,7 @@ retry_iget5_locked:
 }
 
 /* gets root inode */
-struct inode *cifs_root_iget(struct super_block *sb)
+struct inode *cifs_mntroot_iget(struct super_block *sb, const char *full_path)
 {
 	int xid;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
@@ -888,9 +888,10 @@ struct inode *cifs_root_iget(struct super_block *sb)
 
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
index 5de03ec..b2f8851 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -65,10 +65,8 @@ static inline void dump_cifs_file_struct(struct file *file, char *label)
 }
 #endif /* DEBUG2 */
 
-/*
- * Find the dentry that matches "name". If there isn't one, create one. If it's
- * a negative dentry or the uniqueid changed, then drop it and recreate it.
- */
+
+/* Find the dentry that matches "name". If there isn't one, create one. */
 static struct dentry *
 cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 		    struct cifs_fattr *fattr)
@@ -84,32 +82,38 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 	else
 		name->hash = full_name_hash(name->name, name->len);
 
+	mutex_lock(&cifs_root_mutex);
+
 	dentry = d_lookup(parent, name);
 	if (dentry) {
 		/* FIXME: check for inode number changes? */
 		if (dentry->d_inode != NULL)
-			return dentry;
-		d_drop(dentry);
-		dput(dentry);
+			goto out;
+	} else {
+		dentry = d_alloc(parent, name);
+		if (dentry == NULL)
+			goto out;
+		d_rehash(dentry);
 	}
 
-	dentry = d_alloc(parent, name);
-	if (dentry == NULL)
-		return NULL;
-
 	inode = cifs_iget(sb, fattr);
 	if (!inode) {
 		dput(dentry);
-		return NULL;
+		dentry = NULL;
+		goto out;
 	}
 
-	alias = d_materialise_unique(dentry, inode);
+	alias = d_instantiate_unique(dentry, inode);
 	if (alias != NULL) {
 		dput(dentry);
-		if (IS_ERR(alias))
-			return NULL;
+		if (IS_ERR(alias)) {
+			dentry = NULL;
+			goto out;
+		}
 		dentry = alias;
 	}
+out:
+	mutex_unlock(&cifs_root_mutex);
 
 	return dentry;
 }
@@ -708,6 +712,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	char *tmp_buf = NULL;
 	char *end_of_smb;
 	unsigned int max_len;
+	ino_t ino;
 
 	xid = GetXid();
 
@@ -732,8 +737,12 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
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
