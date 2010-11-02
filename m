From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] CIFS: New write logic
Date: Tue,  2 Nov 2010 22:44:20 +0300
Message-ID: <1288727061-18759-3-git-send-email-piastryyy@gmail.com>
References: <1288727061-18759-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288727061-18759-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Modify cifs_file_aio_write and cifs_write_end to let the client works with
strict cache mode.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |   41 ++++++++++++++++++++++++++++++++++++-----
 fs/cifs/file.c   |   14 ++++++++++++--
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index bb7f36e..ccbbea0 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -596,12 +596,43 @@ static ssize_t cifs_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				   unsigned long nr_segs, loff_t pos)
 {
-	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
-	ssize_t written;
+	struct inode *inode;
+	struct cifs_sb_info *cifs_sb;
+	ssize_t written, cache_written;
+	loff_t saved_pos;
+
+	inode = iocb->ki_filp->f_path.dentry->d_inode;
+
+	if (CIFS_I(inode)->clientCanCacheAll)
+		return generic_file_aio_write(iocb, iov, nr_segs, pos);
+
+	cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
+
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) == 0) {
+		int rc;
+
+		written = generic_file_aio_write(iocb, iov, nr_segs, pos);
+
+		rc = filemap_fdatawrite(inode->i_mapping);
+		if (rc)
+			cFYI(1, "cifs_file_aio_write: %d rc on %p inode",
+			     rc, inode);
+		return written;
+	}
+
+	saved_pos = pos;
+	written = cifs_user_write(iocb->ki_filp, iov->iov_base,
+				  iov->iov_len, &pos);
+
+	if (written > 0) {
+		cache_written = generic_file_aio_write(iocb, iov,
+						       nr_segs, saved_pos);
+		if (cache_written != written)
+			cERROR(1, "Cache written and server written data "
+			       "lengths are different");
+	} else
+		iocb->ki_pos = pos;
 
-	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
-	if (!CIFS_I(inode)->clientCanCacheAll)
-		filemap_fdatawrite(inode->i_mapping);
 	return written;
 }
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 81ec50e..9bde94a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1541,7 +1541,11 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 			struct page *page, void *fsdata)
 {
 	int rc;
-	struct inode *inode = mapping->host;
+	struct inode *inode;
+	struct cifs_sb_info *cifs_sb;
+
+	inode = mapping->host;
+	cifs_sb = CIFS_SB(inode->i_sb);
 
 	cFYI(1, "write_end for page %p from pos %lld with %d bytes",
 		 page, pos, copied);
@@ -1574,7 +1578,13 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 	} else {
 		rc = copied;
 		pos += copied;
-		set_page_dirty(page);
+		/* if we have strict cache switched on and don't have Exclusive
+		   oplock for the inode, we don't have to set_page_dirty
+		   because we flushed the data to the server in
+		   cifs_file_aio_write before */
+		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) == 0 ||
+		    CIFS_I(inode)->clientCanCacheAll)
+			set_page_dirty(page);
 	}
 
 	if (rc > 0) {
-- 
1.7.2.3
