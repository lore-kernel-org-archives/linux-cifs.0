From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Consolidate error handling for cifs_invalidate_mapping
Date: Thu, 24 Mar 2011 17:39:47 +0300
Message-ID: <1300977587-8218-1-git-send-email-piastry@etersoft.ru>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Base of approach for splitting all calls that uses cifs_invalidate_mapping
(or cifs_revalidate_dentry, cifs_revalidate_file) into two groups:
1) aware about -EBUSY error code and report it back (cifs_d_revalidate,
cifs_strict_fsync, cifs_file_strict_mmap);
2) don't do it (cifs_getattrs, cifs_lseek).

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c |    8 +++++++-
 fs/cifs/cifsfs.h |    2 +-
 fs/cifs/file.c   |   18 ++++++++++++++----
 fs/cifs/inode.c  |   30 ++++++++++++++++++------------
 4 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index de49fbb..b275d76 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -634,7 +634,13 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
 		CIFS_I(file->f_path.dentry->d_inode)->time = 0;
 
 		retval = cifs_revalidate_file(file);
-		if (retval < 0)
+		/*
+		 * We only need to get right file length and don't need to
+		 * aware about busy pages (-EBUSY error code).
+		 */
+		if (retval == -EBUSY)
+			retval = 0;
+		else if (retval < 0)
 			return (loff_t)retval;
 	}
 	return generic_file_llseek_unlocked(file, offset, origin);
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index bb64313..f4391ff 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -61,7 +61,7 @@ extern int cifs_rename(struct inode *, struct dentry *, struct inode *,
 		       struct dentry *);
 extern int cifs_revalidate_file(struct file *filp);
 extern int cifs_revalidate_dentry(struct dentry *);
-extern void cifs_invalidate_mapping(struct inode *inode);
+extern int cifs_invalidate_mapping(struct inode *inode);
 extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int cifs_setattr(struct dentry *, struct iattr *);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b9731c9..d99cf48 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1448,8 +1448,13 @@ int cifs_strict_fsync(struct file *file, int datasync)
 	cFYI(1, "Sync file - name: %s datasync: 0x%x",
 		file->f_path.dentry->d_name.name, datasync);
 
-	if (!CIFS_I(inode)->clientCanCacheRead)
-		cifs_invalidate_mapping(inode);
+	if (!CIFS_I(inode)->clientCanCacheRead) {
+		rc = cifs_invalidate_mapping(inode);
+		if (rc) {
+			FreeXid(xid);
+			return rc;
+		}
+	}
 
 	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
@@ -1916,8 +1921,13 @@ int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
 
 	xid = GetXid();
 
-	if (!CIFS_I(inode)->clientCanCacheRead)
-		cifs_invalidate_mapping(inode);
+	if (!CIFS_I(inode)->clientCanCacheRead) {
+		rc = cifs_invalidate_mapping(inode);
+		if (rc) {
+			FreeXid(xid);
+			return rc;
+		}
+	}
 
 	rc = generic_file_mmap(file, vma);
 	FreeXid(xid);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index adb6324..d3abfc5 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1683,27 +1683,25 @@ cifs_inode_needs_reval(struct inode *inode)
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
 
-	cifs_i->invalid_mapping = false;
-
 	if (inode->i_mapping && inode->i_mapping->nrpages != 0) {
 		/* write back any cached data */
 		rc = filemap_write_and_wait(inode->i_mapping);
 		mapping_set_error(inode->i_mapping, rc);
 		rc = invalidate_inode_pages2(inode->i_mapping);
-		if (rc) {
-			cERROR(1, "%s: could not invalidate inode %p", __func__,
-			       inode);
-			cifs_i->invalid_mapping = true;
-		}
+		if (rc)
+			cFYI(1, "%s: could not invalidate inode %p", __func__,
+			     inode);
+		cifs_i->invalid_mapping = (rc != 0) ? true : false;
 	}
 
 	cifs_fscache_reset_inode_cookie(inode);
+	return rc;
 }
 
 int cifs_revalidate_file(struct file *filp)
@@ -1722,7 +1720,7 @@ int cifs_revalidate_file(struct file *filp)
 
 check_inval:
 	if (CIFS_I(inode)->invalid_mapping)
-		cifs_invalidate_mapping(inode);
+		rc = cifs_invalidate_mapping(inode);
 
 	return rc;
 }
@@ -1764,7 +1762,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 
 check_inval:
 	if (CIFS_I(inode)->invalid_mapping)
-		cifs_invalidate_mapping(inode);
+		rc = cifs_invalidate_mapping(inode);
 
 	kfree(full_path);
 	FreeXid(xid);
@@ -1776,7 +1774,15 @@ int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
-	int err = cifs_revalidate_dentry(dentry);
+	int err;
+
+	err = cifs_revalidate_dentry(dentry);
+	/*
+	 * We only need to get file attributes and don't need to
+	 * aware about busy pages (-EBUSY error code).
+	 */
+	if (err == -EBUSY)
+		err = 0;
 
 	if (!err) {
 		generic_fillattr(dentry->d_inode, stat);
-- 
1.7.1
