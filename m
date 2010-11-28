From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] CIFS: Make write call work with strict cache mode (try #2)
Date: Sun, 28 Nov 2010 11:12:49 +0300
Message-ID: <1290931972-2770-4-git-send-email-piastryyy@gmail.com>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290931972-2770-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On strict cache mode if we don't have Exclusive oplock we write a data to
the server through cifs_user_write. Then if we Level II oplock store it in
the cache, otherwise - invalidate inode pages affected by this writing.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index bbb5294..901c82b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -598,12 +598,44 @@ static ssize_t cifs_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				   unsigned long nr_segs, loff_t pos)
 {
-	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
+	struct inode *inode;
+	struct cifs_sb_info *cifs_sb;
 	ssize_t written;
 
-	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
-	if (!CIFS_I(inode)->clientCanCacheAll)
-		filemap_fdatawrite(inode->i_mapping);
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
+	/* in strict cache mode we need to write the data to the server exactly
+	   from the pos to pos+len-1 rather than flush all affected pages
+	   because it may cause a error with mandatory locks on these pages but
+	   not on the region from pos to ppos+len-1 */
+	written = cifs_user_write(iocb->ki_filp, iov->iov_base,
+				  iov->iov_len, &pos);
+
+	iocb->ki_pos = pos;
+
+	/* if we were successful - invalidate inode pages the write affected */
+	if (written > 0)
+		invalidate_mapping_pages(inode->i_mapping,
+					      (pos-written) >> PAGE_CACHE_SHIFT,
+					      (pos-1) >> PAGE_CACHE_SHIFT);
+
 	return written;
 }
 
-- 
1.7.3.2
