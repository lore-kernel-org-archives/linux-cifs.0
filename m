From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: directio read/write cleanups
Date: Thu, 10 Mar 2011 13:11:05 +0300
Message-ID: <1299751865-2741-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Recently introduced strictcache mode brought a new code that can be
efficiently used by directio part. That's let us add vectored operations
and break unnecessary cifs_user_read and cifs_user_write.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c |   18 +++++----
 fs/cifs/cifsfs.h |    8 ++--
 fs/cifs/file.c   |  103 +----------------------------------------------------
 3 files changed, 16 insertions(+), 113 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 120a9cf..77c2989 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -763,10 +763,11 @@ const struct file_operations cifs_file_strict_ops = {
 };
 
 const struct file_operations cifs_file_direct_ops = {
-	/* no aio, no readv -
-	   BB reevaluate whether they can be done with directio, no cache */
-	.read = cifs_user_read,
-	.write = cifs_user_write,
+	/* BB reevaluate whether they can be done with directio, no cache */
+	.read = do_sync_read,
+	.write = do_sync_write,
+	.aio_read = cifs_user_readv,
+	.aio_write = cifs_user_writev,
 	.open = cifs_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
@@ -818,10 +819,11 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
 };
 
 const struct file_operations cifs_file_direct_nobrl_ops = {
-	/* no mmap, no aio, no readv -
-	   BB reevaluate whether they can be done with directio, no cache */
-	.read = cifs_user_read,
-	.write = cifs_user_write,
+	/* BB reevaluate whether they can be done with directio, no cache */
+	.read = do_sync_read,
+	.write = do_sync_write,
+	.aio_read = cifs_user_readv,
+	.aio_write = cifs_user_writev,
 	.open = cifs_open,
 	.release = cifs_close,
 	.fsync = cifs_fsync,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 371d021..bb64313 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -80,12 +80,12 @@ extern const struct file_operations cifs_file_strict_nobrl_ops;
 extern int cifs_open(struct inode *inode, struct file *file);
 extern int cifs_close(struct inode *inode, struct file *file);
 extern int cifs_closedir(struct inode *inode, struct file *file);
-extern ssize_t cifs_user_read(struct file *file, char __user *read_data,
-			      size_t read_size, loff_t *poffset);
+extern ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *iov,
+			       unsigned long nr_segs, loff_t pos);
 extern ssize_t cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
 				 unsigned long nr_segs, loff_t pos);
-extern ssize_t cifs_user_write(struct file *file, const char __user *write_data,
-			       size_t write_size, loff_t *poffset);
+extern ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
+				unsigned long nr_segs, loff_t pos);
 extern ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 				  unsigned long nr_segs, loff_t pos);
 extern int cifs_lock(struct file *, int, struct file_lock *);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9293ff2..b9731c9 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -855,95 +855,6 @@ cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
 		cifsi->server_eof = end_of_write;
 }
 
-ssize_t cifs_user_write(struct file *file, const char __user *write_data,
-	size_t write_size, loff_t *poffset)
-{
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int rc = 0;
-	unsigned int bytes_written = 0;
-	unsigned int total_written;
-	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *pTcon;
-	int xid;
-	struct cifsFileInfo *open_file;
-	struct cifsInodeInfo *cifsi = CIFS_I(inode);
-
-	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-
-	/* cFYI(1, " write %d bytes to offset %lld of %s", write_size,
-	   *poffset, file->f_path.dentry->d_name.name); */
-
-	if (file->private_data == NULL)
-		return -EBADF;
-
-	open_file = file->private_data;
-	pTcon = tlink_tcon(open_file->tlink);
-
-	rc = generic_write_checks(file, poffset, &write_size, 0);
-	if (rc)
-		return rc;
-
-	xid = GetXid();
-
-	for (total_written = 0; write_size > total_written;
-	     total_written += bytes_written) {
-		rc = -EAGAIN;
-		while (rc == -EAGAIN) {
-			if (file->private_data == NULL) {
-				/* file has been closed on us */
-				FreeXid(xid);
-			/* if we have gotten here we have written some data
-			   and blocked, and the file has been freed on us while
-			   we blocked so return what we managed to write */
-				return total_written;
-			}
-			if (open_file->invalidHandle) {
-				/* we could deadlock if we called
-				   filemap_fdatawait from here so tell
-				   reopen_file not to flush data to server
-				   now */
-				rc = cifs_reopen_file(open_file, false);
-				if (rc != 0)
-					break;
-			}
-
-			rc = CIFSSMBWrite(xid, pTcon,
-				open_file->netfid,
-				min_t(const int, cifs_sb->wsize,
-				      write_size - total_written),
-				*poffset, &bytes_written,
-				NULL, write_data + total_written, 0);
-		}
-		if (rc || (bytes_written == 0)) {
-			if (total_written)
-				break;
-			else {
-				FreeXid(xid);
-				return rc;
-			}
-		} else {
-			cifs_update_eof(cifsi, *poffset, bytes_written);
-			*poffset += bytes_written;
-		}
-	}
-
-	cifs_stats_bytes_written(pTcon, total_written);
-
-/* Do not update local mtime - server will set its actual value on write
- *	inode->i_ctime = inode->i_mtime =
- * 		current_fs_time(inode->i_sb);*/
-	if (total_written > 0) {
-		spin_lock(&inode->i_lock);
-		if (*poffset > inode->i_size)
-			i_size_write(inode, *poffset);
-		spin_unlock(&inode->i_lock);
-	}
-	mark_inode_dirty_sync(inode);
-
-	FreeXid(xid);
-	return total_written;
-}
-
 static ssize_t cifs_write(struct cifsFileInfo *open_file,
 			  const char *write_data, size_t write_size,
 			  loff_t *poffset)
@@ -1772,7 +1683,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	return total_written;
 }
 
-static ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
+ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos)
 {
 	ssize_t written;
@@ -1895,17 +1806,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	return total_read;
 }
 
-ssize_t cifs_user_read(struct file *file, char __user *read_data,
-		       size_t read_size, loff_t *poffset)
-{
-	struct iovec iov;
-	iov.iov_base = read_data;
-	iov.iov_len = read_size;
-
-	return cifs_iovec_read(file, &iov, 1, poffset);
-}
-
-static ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *iov,
+ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *iov,
 			       unsigned long nr_segs, loff_t pos)
 {
 	ssize_t read;
-- 
1.7.1
