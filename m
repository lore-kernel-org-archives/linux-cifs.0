From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] CIFS: Make cifs_fsync work with strict cache mode (try #3)
Date: Mon, 29 Nov 2010 16:36:43 +0300
Message-ID: <1291037804-4000-3-git-send-email-piastryyy@gmail.com>
References: <1291037804-4000-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291037804-4000-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Remove filemap_write_and_wait call because it is previously called from
vfs_fsync_range and invalidate inode if we don't have at least Level II
oplock and strcit cache mode switched on.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.h |    1 +
 fs/cifs/file.c   |   14 +++++++-------
 fs/cifs/inode.c  |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 897b2b2..b8d783c 100644
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
index f853bf0..d216879 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1595,20 +1595,20 @@ int cifs_fsync(struct file *file, int datasync)
 	struct cifsTconInfo *tcon;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct inode *inode = file->f_path.dentry->d_inode;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
 	xid = GetXid();
 
 	cFYI(1, "Sync file - name: %s datasync: 0x%x",
 		file->f_path.dentry->d_name.name, datasync);
 
-	rc = filemap_write_and_wait(inode->i_mapping);
-	if (rc == 0) {
-		struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	if (!CIFS_I(inode)->clientCanCacheRead &&
+	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO))
+		cifs_invalidate_mapping(inode);
 
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
index ff7d299..f90a40a 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1671,7 +1671,7 @@ cifs_inode_needs_reval(struct inode *inode)
 }
 
 /* check invalid_mapping flag and zap the cache if it's set */
-static void
+void
 cifs_invalidate_mapping(struct inode *inode)
 {
 	int rc;
-- 
1.7.3.2
