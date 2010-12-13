From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/7] CIFS: Implement cifs_strict_write
Date: Mon, 13 Dec 2010 18:00:54 +0300
Message-ID: <1292252455-4025-6-git-send-email-piastryyy@gmail.com>
References: <1292252455-4025-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292252455-4025-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we don't have Exclusive oplock we write a data to the server through
cifs_write. Also set invalidate_mapping flag on the inode if we wrote
something to the server.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c    |   58 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/cifsproto.h |    3 ++
 fs/cifs/file.c      |    5 +--
 3 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e3f0024..d5a9eb9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -629,8 +629,53 @@ static ssize_t cifs_strict_read(struct kiocb *iocb, const struct iovec *iov,
 static ssize_t cifs_strict_write(struct kiocb *iocb, const struct iovec *iov,
 				 unsigned long nr_segs, loff_t pos)
 {
+	struct inode *inode;
+	struct cifs_sb_info *cifs_sb;
 	ssize_t written = 0;
-	/* BB */
+	unsigned long i, len = 0;
+	char *buf, *offset;
+
+	inode = iocb->ki_filp->f_path.dentry->d_inode;
+
+	if (CIFS_I(inode)->clientCanCacheAll)
+		return generic_file_aio_write(iocb, iov, nr_segs, pos);
+
+	cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
+
+	/*
+	 * In strict cache mode we need to write the data to the server exactly
+	 * from the pos to pos+len-1 rather than flush all affected pages
+	 * because it may cause a error with mandatory locks on these pages but
+	 * not on the region from pos to ppos+len-1.
+	 */
+
+	for (i = 0; i < nr_segs; i++)
+		len += iov[i].iov_len;
+
+	buf = kmalloc(len, GFP_KERNEL);
+
+	for (i = 0, offset = buf; i < nr_segs; i++) {
+		if (copy_from_user(offset, iov[i].iov_base, iov[i].iov_len)) {
+			kfree(buf);
+			return -EFAULT;
+		}
+
+		offset += iov[i].iov_len;
+	}
+
+	written = cifs_write((struct cifsFileInfo *)iocb->ki_filp->private_data,
+			     buf, len, &pos);
+	if (written < 0) {
+		kfree(buf);
+		return written;
+	}
+
+	iocb->ki_pos = pos;
+
+	if (written > 0)
+		CIFS_I(inode)->invalid_mapping = true;
+
+	kfree(buf);
 	return written;
 }
 
@@ -639,10 +684,17 @@ static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 {
 	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
 	ssize_t written;
+	int rc;
 
 	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
-	if (!CIFS_I(inode)->clientCanCacheAll)
-		filemap_fdatawrite(inode->i_mapping);
+
+	if (CIFS_I(inode)->clientCanCacheAll)
+		return written;
+
+	rc = filemap_fdatawrite(inode->i_mapping);
+	if (rc)
+		cFYI(1, "cifs_file_aio_write: %d rc on %p inode", rc, inode);
+
 	return written;
 }
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 05f6446..62d083f 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -81,6 +81,9 @@ extern bool is_valid_oplock_break(struct smb_hdr *smb,
 extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
 extern ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 			 loff_t *poffset);
+extern ssize_t cifs_write(struct cifsFileInfo *open_file,
+			  const char *write_data, size_t write_size,
+			  loff_t *poffset);
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, bool);
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
 extern unsigned int smbCalcSize(struct smb_hdr *ptr);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1f96326..2f63885 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1026,9 +1026,8 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 	return total_written;
 }
 
-static ssize_t cifs_write(struct cifsFileInfo *open_file,
-			  const char *write_data, size_t write_size,
-			  loff_t *poffset)
+ssize_t cifs_write(struct cifsFileInfo *open_file, const char *write_data,
+		   size_t write_size, loff_t *poffset)
 {
 	int rc = 0;
 	unsigned int bytes_written = 0;
-- 
1.7.3.2
