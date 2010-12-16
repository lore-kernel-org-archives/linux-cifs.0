From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] CIFS: Implement cifs_strict_read (try #2)
Date: Thu, 16 Dec 2010 10:53:32 +0300
Message-ID: <1292486012-9641-2-git-send-email-piastryyy@gmail.com>
References: <1292486012-9641-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292486012-9641-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Read from the cache if we have at least Level II oplock - otherwise
read from the server. Add cifs_user_readv to let the client read into
several buffers.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |   38 ++++++++++++++++++-
 fs/cifs/cifsfs.h |    4 +-
 fs/cifs/file.c   |  108 +++++++++++++++++++++++++++++++++++++++---------------
 3 files changed, 117 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a218afe..bcb4d2c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -572,6 +572,40 @@ cifs_do_mount(struct file_system_type *fs_type,
 	return dget(sb->s_root);
 }
 
+static ssize_t cifs_strict_read(struct kiocb *iocb, const struct iovec *iov,
+				unsigned long nr_segs, loff_t pos)
+{
+	struct inode *inode;
+	struct cifs_sb_info *cifs_sb;
+	ssize_t read = 0;
+
+	if (!nr_segs)
+		return read;
+
+	inode = iocb->ki_filp->f_path.dentry->d_inode;
+	cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
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
+	read = cifs_user_readv(iocb->ki_filp, iov, nr_segs, &pos);
+	if (read < 0)
+		return read;
+
+	iocb->ki_pos = pos;
+
+	return read;
+}
+
 static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				   unsigned long nr_segs, loff_t pos)
 {
@@ -713,7 +747,7 @@ const struct file_operations cifs_file_ops = {
 const struct file_operations cifs_file_strict_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
-	.aio_read = generic_file_aio_read,
+	.aio_read = cifs_strict_read,
 	.aio_write = cifs_file_aio_write,
 	.open = cifs_open,
 	.release = cifs_close,
@@ -769,7 +803,7 @@ const struct file_operations cifs_file_nobrl_ops = {
 const struct file_operations cifs_file_strict_nobrl_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
-	.aio_read = generic_file_aio_read,
+	.aio_read = cifs_strict_read,
 	.aio_write = cifs_file_aio_write,
 	.open = cifs_open,
 	.release = cifs_close,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 657738f..f690d1c 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -81,7 +81,9 @@ extern int cifs_open(struct inode *inode, struct file *file);
 extern int cifs_close(struct inode *inode, struct file *file);
 extern int cifs_closedir(struct inode *inode, struct file *file);
 extern ssize_t cifs_user_read(struct file *file, char __user *read_data,
-			 size_t read_size, loff_t *poffset);
+			      size_t read_size, loff_t *poffset);
+extern ssize_t cifs_user_readv(struct file *file, const struct iovec *iov,
+			       unsigned long nr_segs, loff_t *poffset);
 extern ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 			 size_t write_size, loff_t *poffset);
 extern int cifs_lock(struct file *, int, struct file_lock *);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d48723c..bc53e9e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1677,20 +1677,60 @@ int cifs_flush(struct file *file, fl_owner_t id)
 	return rc;
 }
 
-ssize_t cifs_user_read(struct file *file, char __user *read_data,
-	size_t read_size, loff_t *poffset)
+static int
+cifs_fill_iov(const struct iovec *iov, unsigned long nr_segs,
+	      unsigned long *last_len, unsigned long *last_ind, char *data,
+	      size_t datalen)
 {
-	int rc = -EACCES;
-	unsigned int bytes_read = 0;
-	unsigned int total_read = 0;
-	unsigned int current_read_size;
+	const struct iovec *ciov;
+	unsigned long cur_len;
+
+	while (datalen) {
+		cur_len = min_t(unsigned long, datalen,
+					      *last_len);
+		ciov = &iov[*last_ind];
+
+		if (copy_to_user(ciov->iov_base + (ciov->iov_len - *last_len),
+				 data, cur_len))
+			return -EFAULT;
+
+		datalen -= cur_len;
+		data += cur_len;
+
+		*last_len -= cur_len;
+		if (*last_len == 0) {
+			(*last_ind)++;
+			*last_len = iov[*last_ind].iov_len;
+		}
+	}
+
+	return 0;
+}
+
+ssize_t cifs_user_readv(struct file *file, const struct iovec *iov,
+			unsigned long nr_segs, loff_t *poffset)
+{
+	int rc;
+	int xid;
+	unsigned int bytes_read = 0, total_read = 0;
+	unsigned long last_len = 0, len = 0, last_ind = 0;
+	unsigned long cur_len, i;
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
-	int xid;
 	struct cifsFileInfo *open_file;
-	char *smb_read_data;
-	char __user *current_offset;
 	struct smb_com_read_rsp *pSMBr;
+	char *read_data;
+
+	if (!nr_segs)
+		return 0;
+
+	last_len = iov->iov_len;
+
+	for (i = 0; i < nr_segs; i++)
+		len += iov[i].iov_len;
+
+	if (!len)
+		return 0;
 
 	xid = GetXid();
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
@@ -1700,19 +1740,19 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 		FreeXid(xid);
 		return rc;
 	}
+
 	open_file = file->private_data;
 	pTcon = tlink_tcon(open_file->tlink);
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
 
-	for (total_read = 0, current_offset = read_data;
-	     read_size > total_read;
-	     total_read += bytes_read, current_offset += bytes_read) {
-		current_read_size = min_t(const int, read_size - total_read,
+	for (total_read = 0; total_read < len; total_read += bytes_read) {
+		cur_len = min_t(const int, len - total_read,
 					  cifs_sb->rsize);
 		rc = -EAGAIN;
-		smb_read_data = NULL;
+		read_data = NULL;
+
 		while (rc == -EAGAIN) {
 			int buf_type = CIFS_NO_BUFFER;
 			if (open_file->invalidHandle) {
@@ -1721,26 +1761,24 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 					break;
 			}
 			rc = CIFSSMBRead(xid, pTcon,
-					 open_file->netfid,
-					 current_read_size, *poffset,
-					 &bytes_read, &smb_read_data,
-					 &buf_type);
-			pSMBr = (struct smb_com_read_rsp *)smb_read_data;
-			if (smb_read_data) {
-				if (copy_to_user(current_offset,
-						smb_read_data +
-						4 /* RFC1001 length field */ +
-						le16_to_cpu(pSMBr->DataOffset),
-						bytes_read))
+					 open_file->netfid, cur_len, *poffset,
+					 &bytes_read, &read_data, &buf_type);
+			pSMBr = (struct smb_com_read_rsp *)read_data;
+			if (read_data) {
+				char *data_offset = read_data + 4 +
+						le16_to_cpu(pSMBr->DataOffset);
+				if (cifs_fill_iov(iov, nr_segs,
+					&last_len, &last_ind,
+					data_offset, bytes_read))
 					rc = -EFAULT;
-
 				if (buf_type == CIFS_SMALL_BUFFER)
-					cifs_small_buf_release(smb_read_data);
+					cifs_small_buf_release(read_data);
 				else if (buf_type == CIFS_LARGE_BUFFER)
-					cifs_buf_release(smb_read_data);
-				smb_read_data = NULL;
+					cifs_buf_release(read_data);
+				read_data = NULL;
 			}
 		}
+
 		if (rc || (bytes_read == 0)) {
 			if (total_read) {
 				break;
@@ -1753,13 +1791,23 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 			*poffset += bytes_read;
 		}
 	}
+
 	FreeXid(xid);
 	return total_read;
 }
 
+ssize_t cifs_user_read(struct file *file, char __user *read_data,
+		       size_t read_size, loff_t *poffset)
+{
+	struct iovec iov;
+	iov.iov_base = read_data;
+	iov.iov_len = read_size;
+
+	return cifs_user_readv(file, &iov, 1, poffset);
+}
 
 static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
-	loff_t *poffset)
+			 loff_t *poffset)
 {
 	int rc = -EACCES;
 	unsigned int bytes_read = 0;
-- 
1.7.3.2
