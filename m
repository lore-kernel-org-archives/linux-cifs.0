From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Simplify invalidate part (try #4)
Date: Fri, 22 Apr 2011 12:11:14 +0400
Message-ID: <1303459874-5184-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Simplify many places when we call cifs_revalidate/invalidate to make
it does what it exactly needs.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c |   23 +++++++-----
 fs/cifs/cifsfs.h |    4 ++-
 fs/cifs/file.c   |   16 ++++++--
 fs/cifs/inode.c  |  105 ++++++++++++++++++++++++++++++++---------------------
 4 files changed, 91 insertions(+), 57 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 30fc505..1f26727 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -618,16 +618,19 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
 {
 	/* origin == SEEK_END => we must revalidate the cached file length */
 	if (origin == SEEK_END) {
-		int retval;
-
-		/* some applications poll for the file length in this strange
-		   way so we must seek to end on non-oplocked files by
-		   setting the revalidate time to zero */
-		CIFS_I(file->f_path.dentry->d_inode)->time = 0;
-
-		retval = cifs_revalidate_file(file);
-		if (retval < 0)
-			return (loff_t)retval;
+		int rc;
+		struct inode *inode = file->f_path.dentry->d_inode;
+
+		/*
+		 * Some applications poll for the file length in this strange
+		 * way so we must seek to end on non-oplocked files by
+		 * setting the revalidate time to zero.
+		 */
+		CIFS_I(inode)->time = 0;
+
+		rc = cifs_revalidate_file_attr(file);
+		if (rc < 0)
+			return (loff_t)rc;
 	}
 	return generic_file_llseek_unlocked(file, offset, origin);
 }
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 371d021..e005dfd 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -59,9 +59,11 @@ extern int cifs_mkdir(struct inode *, struct dentry *, int);
 extern int cifs_rmdir(struct inode *, struct dentry *);
 extern int cifs_rename(struct inode *, struct dentry *, struct inode *,
 		       struct dentry *);
+extern int cifs_revalidate_file_attr(struct file *filp);
+extern int cifs_revalidate_dentry_attr(struct dentry *);
 extern int cifs_revalidate_file(struct file *filp);
 extern int cifs_revalidate_dentry(struct dentry *);
-extern void cifs_invalidate_mapping(struct inode *inode);
+extern int cifs_invalidate_mapping(struct inode *inode);
 extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int cifs_setattr(struct dentry *, struct iattr *);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 00b466e..3bb68c4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1534,8 +1534,13 @@ int cifs_strict_fsync(struct file *file, int datasync)
 	cFYI(1, "Sync file - name: %s datasync: 0x%x",
 		file->f_path.dentry->d_name.name, datasync);
 
-	if (!CIFS_I(inode)->clientCanCacheRead)
-		cifs_invalidate_mapping(inode);
+	if (!CIFS_I(inode)->clientCanCacheRead) {
+		rc = cifs_invalidate_mapping(inode);
+		if (rc) {
+			cFYI(1, "rc: %d during invalidate phase", rc);
+			rc = 0; /* don't care about it in fsync */
+		}
+	}
 
 	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
@@ -2002,8 +2007,11 @@ int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
 
 	xid = GetXid();
 
-	if (!CIFS_I(inode)->clientCanCacheRead)
-		cifs_invalidate_mapping(inode);
+	if (!CIFS_I(inode)->clientCanCacheRead) {
+		rc = cifs_invalidate_mapping(inode);
+		if (rc)
+			return rc;
+	}
 
 	rc = generic_file_mmap(file, vma);
 	if (rc == 0)
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index fbe7d58..68ee2f1 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1683,18 +1683,15 @@ cifs_inode_needs_reval(struct inode *inode)
 /*
  * Zap the cache. Called when invalid_mapping flag is set.
  */
-void
+int
 cifs_invalidate_mapping(struct inode *inode)
 {
-	int rc;
+	int rc = 0;
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 
 	cifs_i->invalid_mapping = false;
 
 	if (inode->i_mapping && inode->i_mapping->nrpages != 0) {
-		/* write back any cached data */
-		rc = filemap_write_and_wait(inode->i_mapping);
-		mapping_set_error(inode->i_mapping, rc);
 		rc = invalidate_inode_pages2(inode->i_mapping);
 		if (rc) {
 			cERROR(1, "%s: could not invalidate inode %p", __func__,
@@ -1704,56 +1701,52 @@ cifs_invalidate_mapping(struct inode *inode)
 	}
 
 	cifs_fscache_reset_inode_cookie(inode);
+	return rc;
 }
 
-int cifs_revalidate_file(struct file *filp)
+int cifs_revalidate_file_attr(struct file *filp)
 {
 	int rc = 0;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *) filp->private_data;
 
 	if (!cifs_inode_needs_reval(inode))
-		goto check_inval;
+		return rc;
 
 	if (tlink_tcon(cfile->tlink)->unix_ext)
 		rc = cifs_get_file_info_unix(filp);
 	else
 		rc = cifs_get_file_info(filp);
 
-check_inval:
-	if (CIFS_I(inode)->invalid_mapping)
-		cifs_invalidate_mapping(inode);
-
 	return rc;
 }
 
-/* revalidate a dentry's inode attributes */
-int cifs_revalidate_dentry(struct dentry *dentry)
+int cifs_revalidate_dentry_attr(struct dentry *dentry)
 {
 	int xid;
 	int rc = 0;
-	char *full_path = NULL;
 	struct inode *inode = dentry->d_inode;
 	struct super_block *sb = dentry->d_sb;
+	char *full_path = NULL;
 
 	if (inode == NULL)
 		return -ENOENT;
 
-	xid = GetXid();
-
 	if (!cifs_inode_needs_reval(inode))
-		goto check_inval;
+		return rc;
+
+	xid = GetXid();
 
 	/* can not safely grab the rename sem here if rename calls revalidate
 	   since that would deadlock */
 	full_path = build_path_from_dentry(dentry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		goto check_inval;
+		goto out;
 	}
 
-	cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
-		 "jiffies %ld", full_path, inode, inode->i_count.counter,
+	cFYI(1, "Update attributes: %s inode 0x%p count %d dentry: 0x%p d_time "
+		 "%ld jiffies %ld", full_path, inode, inode->i_count.counter,
 		 dentry, dentry->d_time, jiffies);
 
 	if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
@@ -1762,41 +1755,69 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
 					 xid, NULL);
 
-check_inval:
-	if (CIFS_I(inode)->invalid_mapping)
-		cifs_invalidate_mapping(inode);
-
+out:
 	kfree(full_path);
 	FreeXid(xid);
 	return rc;
 }
 
+int cifs_revalidate_file(struct file *filp)
+{
+	int rc;
+	struct inode *inode = filp->f_path.dentry->d_inode;
+
+	rc = cifs_revalidate_file_attr(filp);
+	if (rc)
+		return rc;
+
+	if (CIFS_I(inode)->invalid_mapping)
+		rc = cifs_invalidate_mapping(inode);
+	return rc;
+}
+
+/* revalidate a dentry's inode attributes */
+int cifs_revalidate_dentry(struct dentry *dentry)
+{
+	int rc;
+	struct inode *inode = dentry->d_inode;
+
+	rc = cifs_revalidate_dentry_attr(dentry);
+	if (rc)
+		return rc;
+
+	if (CIFS_I(inode)->invalid_mapping)
+		rc = cifs_invalidate_mapping(inode);
+	return rc;
+}
+
 int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
-	int err = cifs_revalidate_dentry(dentry);
+	int rc;
+
+	rc = cifs_revalidate_dentry_attr(dentry);
+	if (rc)
+		return rc;
 
-	if (!err) {
-		generic_fillattr(dentry->d_inode, stat);
-		stat->blksize = CIFS_MAX_MSGSIZE;
-		stat->ino = CIFS_I(dentry->d_inode)->uniqueid;
+	generic_fillattr(dentry->d_inode, stat);
+	stat->blksize = CIFS_MAX_MSGSIZE;
+	stat->ino = CIFS_I(dentry->d_inode)->uniqueid;
 
-		/*
-		 * If on a multiuser mount without unix extensions, and the
-		 * admin hasn't overridden them, set the ownership to the
-		 * fsuid/fsgid of the current process.
-		 */
-		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
-		    !tcon->unix_ext) {
-			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID))
-				stat->uid = current_fsuid();
-			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID))
-				stat->gid = current_fsgid();
-		}
+	/*
+	 * If on a multiuser mount without unix extensions, and the admin hasn't
+	 * overridden them, set the ownership to the fsuid/fsgid of the current
+	 * process.
+	 */
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
+	    !tcon->unix_ext) {
+		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID))
+			stat->uid = current_fsuid();
+		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID))
+			stat->gid = current_fsgid();
 	}
-	return err;
+	return rc;
 }
 
 static int cifs_truncate_page(struct address_space *mapping, loff_t from)
-- 
1.7.1
