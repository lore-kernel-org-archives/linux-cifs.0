From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] CIFS: New write logic
Date: Tue, 26 Oct 2010 17:03:49 +0400
Message-ID: <AANLkTikD7Lw-+o6ky6P7NW05B1QYPick0PvZeaqF-_v2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Modify cifs_file_aio_write and cifs_write_end to let the client works with
strict cache mode.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |   35 ++++++++++++++++++++++++++++++-----
 fs/cifs/file.c   |   23 ++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 21e0f47..85042e4 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -603,12 +603,37 @@ static ssize_t cifs_file_aio_read(struct kiocb
*iocb, const struct iovec *iov,
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
+		written = generic_file_aio_write(iocb, iov, nr_segs, pos);
+		filemap_write_and_wait(inode->i_mapping);
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
index 02a045e..a4d4b3a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1578,11 +1578,31 @@ static int cifs_write_end(struct file *file,
struct address_space *mapping,
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

+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
+		rc = copied;
+		pos += copied;
+
+		if (CIFS_I(inode)->clientCanCacheAll) {
+			SetPageUptodate(page);
+			set_page_dirty(page);
+		}
+
+		/* if we don't have an exclusive oplock the page data was
+		   previously written to the server in cifs_file_aio_write,
+		   so we don't need to do it again - goto exit */
+
+		goto exit;
+	}
+
 	if (PageChecked(page)) {
 		if (copied == len)
 			SetPageUptodate(page);
@@ -1614,6 +1634,7 @@ static int cifs_write_end(struct file *file,
struct address_space *mapping,
 		set_page_dirty(page);
 	}

+exit:
 	if (rc > 0) {
 		spin_lock(&inode->i_lock);
 		if (pos > inode->i_size)
-- 
1.6.3.3
