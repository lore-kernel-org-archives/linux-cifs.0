From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/7] CIFS: Add strict cache file operations
Date: Mon, 13 Dec 2010 18:00:50 +0300
Message-ID: <1292252455-4025-2-git-send-email-piastryyy@gmail.com>
References: <1292252455-4025-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292252455-4025-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add skeleton read, write, fsync and mmap functions for strict cache
mode into new strict file_ops structures.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsfs.h |    8 ++++++--
 fs/cifs/file.c   |   14 ++++++++++++++
 fs/cifs/inode.c  |    6 +++++-
 4 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 3936aa7..a0e35d3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -572,6 +572,22 @@ cifs_do_mount(struct file_system_type *fs_type,
 	return dget(sb->s_root);
 }
 
+static ssize_t cifs_strict_read(struct kiocb *iocb, const struct iovec *iov,
+				unsigned long nr_segs, loff_t pos)
+{
+	ssize_t read = 0;
+	/* BB */
+	return read;
+}
+
+static ssize_t cifs_strict_write(struct kiocb *iocb, const struct iovec *iov,
+				 unsigned long nr_segs, loff_t pos)
+{
+	ssize_t written = 0;
+	/* BB */
+	return written;
+}
+
 static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				   unsigned long nr_segs, loff_t pos)
 {
@@ -710,6 +726,25 @@ const struct file_operations cifs_file_ops = {
 	.setlease = cifs_setlease,
 };
 
+const struct file_operations cifs_file_strict_ops = {
+	.read = do_sync_read,
+	.write = do_sync_write,
+	.aio_read = cifs_strict_read,
+	.aio_write = cifs_strict_write,
+	.open = cifs_open,
+	.release = cifs_close,
+	.lock = cifs_lock,
+	.fsync = cifs_strict_fsync,
+	.flush = cifs_flush,
+	.mmap = cifs_file_strict_mmap,
+	.splice_read = generic_file_splice_read,
+	.llseek = cifs_llseek,
+#ifdef CONFIG_CIFS_POSIX
+	.unlocked_ioctl	= cifs_ioctl,
+#endif /* CONFIG_CIFS_POSIX */
+	.setlease = cifs_setlease,
+};
+
 const struct file_operations cifs_file_direct_ops = {
 	/* no aio, no readv -
 	   BB reevaluate whether they can be done with directio, no cache */
@@ -728,6 +763,7 @@ const struct file_operations cifs_file_direct_ops = {
 	.llseek = cifs_llseek,
 	.setlease = cifs_setlease,
 };
+
 const struct file_operations cifs_file_nobrl_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
@@ -746,6 +782,24 @@ const struct file_operations cifs_file_nobrl_ops = {
 	.setlease = cifs_setlease,
 };
 
+const struct file_operations cifs_file_strict_nobrl_ops = {
+	.read = do_sync_read,
+	.write = do_sync_write,
+	.aio_read = cifs_strict_read,
+	.aio_write = cifs_strict_write,
+	.open = cifs_open,
+	.release = cifs_close,
+	.fsync = cifs_strict_fsync,
+	.flush = cifs_flush,
+	.mmap = cifs_file_strict_mmap,
+	.splice_read = generic_file_splice_read,
+	.llseek = cifs_llseek,
+#ifdef CONFIG_CIFS_POSIX
+	.unlocked_ioctl	= cifs_ioctl,
+#endif /* CONFIG_CIFS_POSIX */
+	.setlease = cifs_setlease,
+};
+
 const struct file_operations cifs_file_direct_nobrl_ops = {
 	/* no mmap, no aio, no readv -
 	   BB reevaluate whether they can be done with directio, no cache */
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 897b2b2..e47c00d 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -72,8 +72,10 @@ extern const struct inode_operations cifs_dfs_referral_inode_operations;
 /* Functions related to files and directories */
 extern const struct file_operations cifs_file_ops;
 extern const struct file_operations cifs_file_direct_ops; /* if directio mnt */
-extern const struct file_operations cifs_file_nobrl_ops;
-extern const struct file_operations cifs_file_direct_nobrl_ops; /* no brlocks */
+extern const struct file_operations cifs_file_strict_ops; /* if strictio mnt */
+extern const struct file_operations cifs_file_nobrl_ops; /* no brlocks */
+extern const struct file_operations cifs_file_direct_nobrl_ops;
+extern const struct file_operations cifs_file_strict_nobrl_ops;
 extern int cifs_open(struct inode *inode, struct file *file);
 extern int cifs_close(struct inode *inode, struct file *file);
 extern int cifs_closedir(struct inode *inode, struct file *file);
@@ -83,8 +85,10 @@ extern ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 			 size_t write_size, loff_t *poffset);
 extern int cifs_lock(struct file *, int, struct file_lock *);
 extern int cifs_fsync(struct file *, int);
+extern int cifs_strict_fsync(struct file *, int);
 extern int cifs_flush(struct file *, fl_owner_t id);
 extern int cifs_file_mmap(struct file * , struct vm_area_struct *);
+extern int cifs_file_strict_mmap(struct file * , struct vm_area_struct *);
 extern const struct file_operations cifs_dir_ops;
 extern int cifs_dir_open(struct inode *inode, struct file *file);
 extern int cifs_readdir(struct file *file, void *direntry, filldir_t filldir);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 60c3f84..626cfa3 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1586,6 +1586,13 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 	return rc;
 }
 
+int cifs_strict_fsync(struct file *file, int datasync)
+{
+	int rc = 0;
+	/* BB */
+	return rc;
+}
+
 int cifs_fsync(struct file *file, int datasync)
 {
 	int xid;
@@ -1807,6 +1814,13 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	return total_read;
 }
 
+int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int rc = 0;
+	/* BB */
+	return rc;
+}
+
 int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int rc, xid;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 589f3e3..b245cf0 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -44,13 +44,17 @@ static void cifs_set_ops(struct inode *inode, const bool is_dfs_referral)
 				inode->i_fop = &cifs_file_direct_nobrl_ops;
 			else
 				inode->i_fop = &cifs_file_direct_ops;
+		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
+			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+				inode->i_fop = &cifs_file_strict_nobrl_ops;
+			else
+				inode->i_fop = &cifs_file_strict_ops;
 		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
 			inode->i_fop = &cifs_file_nobrl_ops;
 		else { /* not direct, send byte range locks */
 			inode->i_fop = &cifs_file_ops;
 		}
 
-
 		/* check if server can support readpages */
 		if (cifs_sb_master_tcon(cifs_sb)->ses->server->maxBuf <
 				PAGE_CACHE_SIZE + MAX_CIFS_HDR_SIZE)
-- 
1.7.3.2
