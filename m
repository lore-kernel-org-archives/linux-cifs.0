From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] CIFS: Implement cifs_strict_writev (try #4)
Date: Mon, 27 Dec 2010 21:11:43 +0300
Message-ID: <1293473503-5533-2-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we don't have Exclusive oplock we write a data to the server.
Also set invalidate_mapping flag on the inode if we wrote something
to the server. Add cifs_iovec_write to let the client write iovec
buffers through CIFSSMBWrite2.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c    |   15 +++-
 fs/cifs/cifsfs.h    |    4 +-
 fs/cifs/cifsproto.h |    2 +
 fs/cifs/file.c      |  202 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 217 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 0d6b005..76ba04e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -578,10 +578,17 @@ static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
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
 
@@ -715,7 +722,7 @@ const struct file_operations cifs_file_strict_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
 	.aio_read = cifs_strict_readv,
-	.aio_write = cifs_file_aio_write,
+	.aio_write = cifs_strict_writev,
 	.open = cifs_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
@@ -771,7 +778,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
 	.aio_read = cifs_strict_readv,
-	.aio_write = cifs_file_aio_write,
+	.aio_write = cifs_strict_writev,
 	.open = cifs_open,
 	.release = cifs_close,
 	.fsync = cifs_strict_fsync,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index d97c96e..3396cd0 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -85,7 +85,9 @@ extern ssize_t cifs_user_read(struct file *file, char __user *read_data,
 extern ssize_t cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
 				 unsigned long nr_segs, loff_t pos);
 extern ssize_t cifs_user_write(struct file *file, const char __user *write_data,
-			 size_t write_size, loff_t *poffset);
+			       size_t write_size, loff_t *poffset);
+extern ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
+				  unsigned long nr_segs, loff_t pos);
 extern int cifs_lock(struct file *, int, struct file_lock *);
 extern int cifs_fsync(struct file *, int);
 extern int cifs_strict_fsync(struct file *, int);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e6d1481..e7d6c24 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -79,6 +79,8 @@ extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length);
 extern bool is_valid_oplock_break(struct smb_hdr *smb,
 				  struct TCP_Server_Info *);
 extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
+extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
+			    unsigned int bytes_written);
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, bool);
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
 extern unsigned int smbCalcSize(struct smb_hdr *ptr);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0f30095..d78f464 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -924,7 +924,7 @@ cifs_write_timeout(struct cifsInodeInfo *cifsi, loff_t offset)
 }
 
 /* update the file size (if needed) after a write */
-static void
+void
 cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
 		      unsigned int bytes_written)
 {
@@ -1677,6 +1677,206 @@ int cifs_flush(struct file *file, fl_owner_t id)
 	return rc;
 }
 
+static int
+cifs_write_allocate_pages(struct page **pages, unsigned long num_pages)
+{
+	int rc = 0;
+	unsigned long i;
+
+	for (i = 0; i < num_pages; i++) {
+		pages[i] = alloc_page(__GFP_HIGHMEM);
+		if (!pages[i]) {
+			/*
+			 * save number of pages we have already allocated and
+			 * return with ENOMEM error
+			 */
+			num_pages = i;
+			rc = -ENOMEM;
+			goto error;
+		}
+	}
+
+	return rc;
+
+error:
+	for (i = 0; i < num_pages; i++)
+		put_page(pages[i]);
+	return rc;
+}
+
+static inline
+size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
+{
+	size_t num_pages;
+	size_t clen;
+
+	clen = min_t(const size_t, len, wsize);
+	num_pages = clen / PAGE_CACHE_SIZE;
+	if (clen % PAGE_CACHE_SIZE)
+		num_pages++;
+
+	if (cur_len)
+		*cur_len = clen;
+
+	return num_pages;
+}
+
+static ssize_t
+cifs_iovec_write(struct file *file, const struct iovec *iov,
+		 unsigned long nr_segs, loff_t *poffset)
+{
+	size_t total_written = 0, written = 0;
+	unsigned long num_pages, npages;
+	size_t copied, len, cur_len, i;
+	struct kvec *to_send;
+	struct page **pages;
+	struct iov_iter it;
+	struct inode *inode;
+	struct cifsFileInfo *open_file;
+	struct cifsTconInfo *pTcon;
+	struct cifs_sb_info *cifs_sb;
+	int xid, rc;
+
+	len = iov_length(iov, nr_segs);
+	if (!len)
+		return 0;
+
+	rc = generic_write_checks(file, poffset, &len, 0);
+	if (rc)
+		return rc;
+
+	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	num_pages = get_numpages(cifs_sb->wsize, len, &cur_len);
+
+	pages = kmalloc(sizeof(struct pages *)*num_pages, GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	to_send = kmalloc(sizeof(struct kvec)*(num_pages + 1), GFP_KERNEL);
+	if (!to_send) {
+		kfree(pages);
+		return -ENOMEM;
+	}
+
+	rc = cifs_write_allocate_pages(pages, num_pages);
+	if (rc) {
+		kfree(pages);
+		kfree(to_send);
+		return rc;
+	}
+
+	xid = GetXid();
+	open_file = file->private_data;
+	pTcon = tlink_tcon(open_file->tlink);
+	inode = file->f_path.dentry->d_inode;
+
+	iov_iter_init(&it, iov, nr_segs, len, 0);
+	npages = num_pages;
+
+	do {
+		size_t save_len = cur_len;
+		for (i = 0; i < npages; i++) {
+			copied = min_t(const size_t, cur_len, PAGE_CACHE_SIZE);
+			copied = iov_iter_copy_from_user(pages[i], &it, 0,
+							 copied);
+			cur_len -= copied;
+			iov_iter_advance(&it, copied);
+			to_send[i+1].iov_base = kmap(pages[i]);
+			to_send[i+1].iov_len = copied;
+		}
+
+		cur_len = save_len - cur_len;
+
+		do {
+			if (open_file->invalidHandle) {
+				rc = cifs_reopen_file(open_file, false);
+				if (rc != 0)
+					break;
+			}
+			rc = CIFSSMBWrite2(xid, pTcon, open_file->netfid,
+					   cur_len, *poffset, &written,
+					   to_send, npages, 0);
+		} while (rc == -EAGAIN);
+
+		for (i = 0; i < npages; i++)
+			kunmap(pages[i]);
+
+		if (written) {
+			len -= written;
+			total_written += written;
+			cifs_update_eof(CIFS_I(inode), *poffset, written);
+			*poffset += written;
+		} else if (rc < 0) {
+			if (!total_written)
+				total_written = rc;
+			break;
+		}
+
+		/* get length and number of kvecs of the next write */
+		npages = get_numpages(cifs_sb->wsize, len, &cur_len);
+	} while (len > 0);
+
+	if (total_written > 0) {
+		spin_lock(&inode->i_lock);
+		if (*poffset > inode->i_size)
+			i_size_write(inode, *poffset);
+		spin_unlock(&inode->i_lock);
+	}
+
+	cifs_stats_bytes_written(pTcon, total_written);
+	mark_inode_dirty_sync(inode);
+
+	for (i = 0; i < num_pages; i++)
+		put_page(pages[i]);
+	kfree(to_send);
+	kfree(pages);
+	FreeXid(xid);
+	return total_written;
+}
+
+static ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
+				unsigned long nr_segs, loff_t pos)
+{
+	ssize_t written;
+	struct inode *inode;
+
+	inode = iocb->ki_filp->f_path.dentry->d_inode;
+
+	/*
+	 * BB - optimize the way when signing is disabled. We can drop this
+	 * extra memory-to-memory copying and use iovec buffers for constructing
+	 * write request.
+	 */
+
+	written = cifs_iovec_write(iocb->ki_filp, iov, nr_segs, &pos);
+	if (written > 0) {
+		CIFS_I(inode)->invalid_mapping = true;
+		iocb->ki_pos = pos;
+	}
+
+	return written;
+}
+
+ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
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
+	return cifs_user_writev(iocb, iov, nr_segs, pos);
+}
+
 static ssize_t
 cifs_iovec_read(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
-- 
1.7.3.4
