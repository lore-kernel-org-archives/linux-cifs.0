From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 39/53] CIFS: Add SMB2 support for flush operation
Date: Tue, 25 Oct 2011 10:12:12 +0400
Message-ID: <1319523146-2859-40-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/cifsglob.h  |    1 +
 fs/cifs/cifsproto.h |    5 +++++
 fs/cifs/file.c      |   34 +++++++++++++++++++++++++---------
 fs/cifs/smb2file.c  |   30 ++++++++++++++++++++++++------
 fs/cifs/smb2proto.h |    6 ++++--
 5 files changed, 59 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d878378..b71c3fc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -656,6 +656,7 @@ typedef int (iread_callback_t)(int, struct cifsFileInfo *,
 typedef int (read_callback_t)(int, struct cifsFileInfo *,
 			      struct cifs_io_parms *, unsigned int *, char **,
 			      int *, unsigned int);
+typedef int (fsync_callback_t)(int, struct cifsFileInfo *);
 
 /*
  * Take a reference on the file private data. Must be called with
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c0afafd..e99db0a 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -220,6 +220,11 @@ extern int is_dir_changed(struct file *file);
 extern struct dentry *cifs_readdir_lookup(struct dentry *parent,
 					  struct qstr *name,
 					  struct cifs_fattr *fattr);
+extern int cifs_strict_fsync_generic(struct file *file, loff_t start,
+				     loff_t end, int datasync,
+				     fsync_callback_t *fsync_cb);
+extern int cifs_fsync_generic(struct file *file, loff_t start, loff_t end,
+			      int datasync, fsync_callback_t *fsync_cb);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 22cf18b..2c9471c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2044,12 +2044,17 @@ int cifs_write_end(struct file *file, struct address_space *mapping, loff_t pos,
 	return rc;
 }
 
-int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
-		      int datasync)
+static int
+cifs_fsync_cb(int xid, struct cifsFileInfo *cfile)
+{
+	return CIFSSMBFlush(xid, tlink_tcon(cfile->tlink), cfile->netfid);
+}
+
+int cifs_strict_fsync_generic(struct file *file, loff_t start, loff_t end,
+			      int datasync, fsync_callback_t *fsync_cb)
 {
 	int xid;
 	int rc = 0;
-	struct cifs_tcon *tcon;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
@@ -2072,20 +2077,26 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 		}
 	}
 
-	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
-		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
+		rc = fsync_cb(xid, smbfile);
 
 	FreeXid(xid);
 	mutex_unlock(&inode->i_mutex);
 	return rc;
 }
 
-int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+int
+cifs_strict_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return cifs_strict_fsync_generic(file, datasync, start, end,
+					 cifs_fsync_cb);
+}
+
+int cifs_fsync_generic(struct file *file, loff_t start, loff_t end,
+		       int datasync, fsync_callback_t *fsync_cb)
 {
 	int xid;
 	int rc = 0;
-	struct cifs_tcon *tcon;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	struct inode *inode = file->f_mapping->host;
@@ -2100,15 +2111,20 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	cFYI(1, "Sync file - name: %s datasync: 0x%x",
 		file->f_path.dentry->d_name.name, datasync);
 
-	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
-		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
+		rc = fsync_cb(xid, smbfile);
 
 	FreeXid(xid);
 	mutex_unlock(&inode->i_mutex);
 	return rc;
 }
 
+int
+cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return cifs_fsync_generic(file, start, end, datasync, cifs_fsync_cb);
+}
+
 /*
  * As file closes, flush all cached write data for this inode checking
  * for write behind errors.
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index c81f76a..318e4b9 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -43,7 +43,7 @@ const struct file_operations smb2_file_ops = {
 	.open = smb2_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
-	.fsync = cifs_fsync,
+	.fsync = smb2_fsync,
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
@@ -62,7 +62,7 @@ const struct file_operations smb2_file_strict_ops = {
 	.open = smb2_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
-	.fsync = cifs_strict_fsync,
+	.fsync = smb2_strict_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
@@ -82,7 +82,7 @@ const struct file_operations smb2_file_direct_ops = {
 	.open = smb2_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
-	.fsync = cifs_fsync,
+	.fsync = smb2_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
@@ -100,7 +100,7 @@ const struct file_operations smb2_file_nobrl_ops = {
 	.aio_write = cifs_file_aio_write,
 	.open = smb2_open,
 	.release = cifs_close,
-	.fsync = cifs_fsync,
+	.fsync = smb2_fsync,
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
@@ -118,7 +118,7 @@ const struct file_operations smb2_file_strict_nobrl_ops = {
 	.aio_write = cifs_strict_writev,
 	.open = smb2_open,
 	.release = cifs_close,
-	.fsync = cifs_strict_fsync,
+	.fsync = smb2_strict_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
@@ -137,7 +137,7 @@ const struct file_operations smb2_file_direct_nobrl_ops = {
 	.aio_write = smb2_user_writev,
 	.open = smb2_open,
 	.release = cifs_close,
-	.fsync = cifs_fsync,
+	.fsync = smb2_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
@@ -478,3 +478,21 @@ smb2_readpages(struct file *file, struct address_space *mapping,
 	return cifs_readpages_generic(file, mapping, page_list, num_pages,
 				      smb2_async_readv);
 }
+
+static int
+smb2_fsync_cb(int xid, struct cifsFileInfo *cfile)
+{
+	return SMB2_flush(xid, tlink_tcon(cfile->tlink), cfile->persist_fid,
+			  cfile->volatile_fid);
+}
+
+int smb2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return cifs_fsync_generic(file, start, end, datasync, smb2_fsync_cb);
+}
+
+int smb2_strict_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return cifs_strict_fsync_generic(file, start, end, datasync,
+					 smb2_fsync_cb);
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 450b414..73aab65 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -124,8 +124,6 @@ extern void smb2_allinfo_to_fattr(struct cifs_fattr *attr,
 extern void smb2_create_dfs_attr(struct cifs_fattr *fattr,
 				 struct super_block *sb);
 extern void cifs_fattr_to_inode(struct inode *pinode, struct cifs_fattr *attr);
-extern int smb2_fsync(struct file *file, int datasync);
-extern int smb2_flush(struct file *file, fl_owner_t id);
 extern struct cifsFileInfo *smb2_new_fileinfo(__u64 persist_fid,
 					      __u64 volatile_fid,
 					      struct file *file,
@@ -142,6 +140,10 @@ extern int smb2_write_cb(int xid, struct cifsFileInfo *cfile,
 			 struct cifs_io_parms *parms, unsigned int *written,
 			 struct kvec *iov, unsigned long nr_segs,
 			 unsigned int remaining_bytes, int timeout);
+extern int smb2_strict_fsync(struct file *file, loff_t start, loff_t end,
+			     int datasync);
+extern int smb2_fsync(struct file *file, loff_t start, loff_t end,
+		      int datasync);
 
 extern int smb2_open(struct inode *inode, struct file *file);
 extern ssize_t smb2_user_readv(struct kiocb *iocb, const struct iovec *iov,
-- 
1.7.1
