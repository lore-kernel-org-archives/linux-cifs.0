From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/7] CIFS: Implement cifs_strict_fsync
Date: Mon, 13 Dec 2010 18:00:51 +0300
Message-ID: <1292252455-4025-3-git-send-email-piastryyy@gmail.com>
References: <1292252455-4025-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292252455-4025-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Invalidate inode if we don't have at least Level II oplock in cifs_strict_fsync.
Also remove filemap_write_and_wait call from cifs_fsync because it is previously
called from vfs_fsync_range.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.h |    1 +
 fs/cifs/file.c   |   33 +++++++++++++++++++++++----------
 fs/cifs/inode.c  |    2 +-
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index e47c00d..657738f 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -61,6 +61,7 @@ extern int cifs_rename(struct inode *, struct dentry *, struct inode *,
 		       struct dentry *);
 extern int cifs_revalidate_file(struct file *filp);
 extern int cifs_revalidate_dentry(struct dentry *);
+extern void cifs_invalidate_mapping(struct inode *inode);
 extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int cifs_setattr(struct dentry *, struct iattr *);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 626cfa3..938f26a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1588,8 +1588,26 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 
 int cifs_strict_fsync(struct file *file, int datasync)
 {
+	int xid;
 	int rc = 0;
-	/* BB */
+	struct cifsTconInfo *tcon;
+	struct cifsFileInfo *smbfile = file->private_data;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+
+	xid = GetXid();
+
+	cFYI(1, "Sync file - name: %s datasync: 0x%x",
+		file->f_path.dentry->d_name.name, datasync);
+
+	if (!CIFS_I(inode)->clientCanCacheRead)
+		cifs_invalidate_mapping(inode);
+
+	tcon = tlink_tcon(smbfile->tlink);
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
+		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
+
+	FreeXid(xid);
 	return rc;
 }
 
@@ -1599,21 +1617,16 @@ int cifs_fsync(struct file *file, int datasync)
 	int rc = 0;
 	struct cifsTconInfo *tcon;
 	struct cifsFileInfo *smbfile = file->private_data;
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 
 	xid = GetXid();
 
 	cFYI(1, "Sync file - name: %s datasync: 0x%x",
 		file->f_path.dentry->d_name.name, datasync);
 
-	rc = filemap_write_and_wait(inode->i_mapping);
-	if (rc == 0) {
-		struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-
-		tcon = tlink_tcon(smbfile->tlink);
-		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
-			rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
-	}
+	tcon = tlink_tcon(smbfile->tlink);
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
+		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
 
 	FreeXid(xid);
 	return rc;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index b245cf0..a8f7cf3 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1683,7 +1683,7 @@ cifs_inode_needs_reval(struct inode *inode)
 /*
  * Zap the cache. Called when invalid_mapping flag is set.
  */
-static void
+void
 cifs_invalidate_mapping(struct inode *inode)
 {
 	int rc;
-- 
1.7.3.2
