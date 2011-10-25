From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 46/53] CIFS: Add strictcache i/o for SMB2
Date: Tue, 25 Oct 2011 10:12:19 +0400
Message-ID: <1319523146-2859-47-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/smb2file.c  |   50 ++++++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/smb2proto.h |    4 ++++
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index ba67306..83ba8eb 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -57,8 +57,8 @@ const struct file_operations smb2_file_ops = {
 const struct file_operations smb2_file_strict_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
-	.aio_read = cifs_strict_readv,
-	.aio_write = cifs_strict_writev,
+	.aio_read = smb2_strict_readv,
+	.aio_write = smb2_strict_writev,
 	.open = smb2_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
@@ -114,8 +114,8 @@ const struct file_operations smb2_file_nobrl_ops = {
 const struct file_operations smb2_file_strict_nobrl_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
-	.aio_read = cifs_strict_readv,
-	.aio_write = cifs_strict_writev,
+	.aio_read = smb2_strict_readv,
+	.aio_write = smb2_strict_writev,
 	.open = smb2_open,
 	.release = cifs_close,
 	.fsync = smb2_strict_fsync,
@@ -403,6 +403,26 @@ ssize_t smb2_user_writev(struct kiocb *iocb, const struct iovec *iov,
 	return written;
 }
 
+ssize_t smb2_strict_writev(struct kiocb *iocb, const struct iovec *iov,
+			   unsigned long nr_segs, loff_t pos)
+{
+	struct inode *inode;
+
+	inode = iocb->ki_filp->f_path.dentry->d_inode;
+
+	if (CIFS_I(inode)->clientCanCacheAll)
+		return generic_file_aio_write(iocb, iov, nr_segs, pos);
+
+	/*
+	 * In strict cache mode we need to write the data to the server exactly
+	 * from the pos to pos+len-1 rather than flush all affected pages
+	 * because it may cause a error with mandatory locks on these pages but
+	 * not on the region from pos to ppos+len-1.
+	 */
+
+	return smb2_user_writev(iocb, iov, nr_segs, pos);
+}
+
 static int
 smb2_iread_cb(int xid, struct cifsFileInfo *cfile, struct cifs_io_parms *parms,
 	      unsigned int *bytes_read, char **all_data, char **data_offset,
@@ -442,6 +462,28 @@ ssize_t smb2_user_readv(struct kiocb *iocb, const struct iovec *iov,
 	return read;
 }
 
+ssize_t smb2_strict_readv(struct kiocb *iocb, const struct iovec *iov,
+			  unsigned long nr_segs, loff_t pos)
+{
+	struct inode *inode;
+
+	inode = iocb->ki_filp->f_path.dentry->d_inode;
+
+	if (CIFS_I(inode)->clientCanCacheRead)
+		return generic_file_aio_read(iocb, iov, nr_segs, pos);
+
+	/*
+	 * In strict cache mode we need to read from the server all the time
+	 * if we don't have level II oplock because the server can delay mtime
+	 * change - so we can't make a decision about inode invalidating.
+	 * And we can also fail with pagereading if there are mandatory locks
+	 * on pages affected by this read but not on the region from pos to
+	 * pos+len-1.
+	 */
+
+	return smb2_user_readv(iocb, iov, nr_segs, pos);
+}
+
 int
 smb2_read_cb(int xid, struct cifsFileInfo *cfile, struct cifs_io_parms *parms,
 	     unsigned int *bytes_read, char **buf, int *buf_type,
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 0bff335..9f52e74 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -148,8 +148,12 @@ extern int smb2_fsync(struct file *file, loff_t start, loff_t end,
 extern int smb2_open(struct inode *inode, struct file *file);
 extern ssize_t smb2_user_readv(struct kiocb *iocb, const struct iovec *iov,
 			       unsigned long nr_segs, loff_t pos);
+extern ssize_t smb2_strict_readv(struct kiocb *iocb, const struct iovec *iov,
+				 unsigned long nr_segs, loff_t pos);
 extern ssize_t smb2_user_writev(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
+extern ssize_t smb2_strict_writev(struct kiocb *iocb, const struct iovec *iov,
+				  unsigned long nr_segs, loff_t pos);
 extern int smb2_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc);
 extern int smb2_readpages(struct file *file, struct address_space *mapping,
-- 
1.7.1
