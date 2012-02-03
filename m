From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 8/8] cifs: convert cifs_iovec_write to use async writes
Date: Fri,  3 Feb 2012 09:33:01 -0500
Message-ID: <1328279581-21889-9-git-send-email-jlayton@redhat.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    2 +
 fs/cifs/cifssmb.c   |    4 +-
 fs/cifs/file.c      |  191 ++++++++++++++++++++++++++++++++-------------------
 3 files changed, 126 insertions(+), 71 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index bceadc5..a131ded 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -473,6 +473,8 @@ int cifs_async_readv(struct cifs_readdata *rdata);
 /* asynchronous write support */
 struct cifs_writedata {
 	struct kref			refcount;
+	struct list_head		list;
+	struct completion		done;
 	enum writeback_sync_modes	sync_mode;
 	struct work_struct		work;
 	struct cifsFileInfo		*cfile;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 113b5af..6e93c9e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2034,8 +2034,10 @@ cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete)
 	wdata = kzalloc(sizeof(*wdata) +
 			sizeof(struct page *) * (nr_pages - 1), GFP_NOFS);
 	if (wdata != NULL) {
-		INIT_WORK(&wdata->work, complete);
 		kref_init(&wdata->refcount);
+		INIT_LIST_HEAD(&wdata->list);
+		init_completion(&wdata->done);
+		INIT_WORK(&wdata->work, complete);
 	}
 	return wdata;
 }
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c7e47a2..ef25fc5 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2057,23 +2057,55 @@ size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
 	return num_pages;
 }
 
+static void
+cifs_uncached_marshal_iov(struct kvec *iov, struct cifs_writedata *wdata)
+{
+	int i;
+	size_t bytes = wdata->bytes;
+
+	/* marshal up the pages into iov array */
+	for (i = 0; i < wdata->nr_pages; i++) {
+		iov[i + 1].iov_len = min(bytes, PAGE_SIZE);
+		iov[i + 1].iov_base = kmap(wdata->pages[i]);
+		bytes -= iov[i + 1].iov_len;
+	}
+}
+
+static void
+cifs_uncached_writev_complete(struct work_struct *work)
+{
+	int i;
+	struct cifs_writedata *wdata = container_of(work,
+					struct cifs_writedata, work);
+
+	complete(&wdata->done);
+
+	if (wdata->result != -EAGAIN) {
+		for (i = 0; i < wdata->nr_pages; i++)
+			put_page(wdata->pages[i]);
+	}
+
+	kref_put(&wdata->refcount, cifs_writedata_release);
+}
+
 static ssize_t
 cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
-	unsigned int written;
-	unsigned long num_pages, npages, i;
+	unsigned long nr_pages, i;
 	size_t copied, len, cur_len;
 	ssize_t total_written = 0;
-	struct kvec *to_send;
-	struct page **pages;
+	loff_t offset = *poffset;
 	struct iov_iter it;
-	struct inode *inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsFileInfo *open_file;
 	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb;
-	int xid, rc;
-	__u32 pid;
+	struct cifs_writedata *wdata, *tmp;
+	struct list_head wdata_list;
+	int rc;
+	pid_t pid;
 
 	len = iov_length(iov, nr_segs);
 	if (!len)
@@ -2083,103 +2115,122 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	if (rc)
 		return rc;
 
+	INIT_LIST_HEAD(&wdata_list);
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	num_pages = get_numpages(cifs_sb->wsize, len, &cur_len);
-
-	pages = kmalloc(sizeof(struct pages *)*num_pages, GFP_KERNEL);
-	if (!pages)
-		return -ENOMEM;
-
-	to_send = kmalloc(sizeof(struct kvec)*(num_pages + 1), GFP_KERNEL);
-	if (!to_send) {
-		kfree(pages);
-		return -ENOMEM;
-	}
-
-	rc = cifs_write_allocate_pages(pages, num_pages);
-	if (rc) {
-		kfree(pages);
-		kfree(to_send);
-		return rc;
-	}
-
-	xid = GetXid();
 	open_file = file->private_data;
+	tcon = tlink_tcon(open_file->tlink);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
 
-	tcon = tlink_tcon(open_file->tlink);
-	inode = file->f_path.dentry->d_inode;
-
 	iov_iter_init(&it, iov, nr_segs, len, 0);
-	npages = num_pages;
-
 	do {
-		size_t save_len = cur_len;
-		for (i = 0; i < npages; i++) {
-			copied = min_t(const size_t, cur_len, PAGE_CACHE_SIZE);
-			copied = iov_iter_copy_from_user(pages[i], &it, 0,
-							 copied);
+		size_t save_len;
+
+		nr_pages = get_numpages(cifs_sb->wsize, len, &cur_len);
+		wdata = cifs_writedata_alloc(nr_pages,
+					     cifs_uncached_writev_complete);
+		if (!wdata) {
+			rc = -ENOMEM;
+			break;
+		}
+
+		rc = cifs_write_allocate_pages(wdata->pages, nr_pages);
+		if (rc) {
+			kfree(wdata);
+			break;
+		}
+
+		save_len = cur_len;
+		for (i = 0; i < nr_pages; i++) {
+			copied = min_t(const size_t, cur_len, PAGE_SIZE);
+			copied = iov_iter_copy_from_user(wdata->pages[i], &it,
+							 0, copied);
 			cur_len -= copied;
 			iov_iter_advance(&it, copied);
-			to_send[i+1].iov_base = kmap(pages[i]);
-			to_send[i+1].iov_len = copied;
 		}
-
 		cur_len = save_len - cur_len;
 
+		wdata->sync_mode = WB_SYNC_ALL;
+		wdata->nr_pages = nr_pages;
+		wdata->offset = (__u64)offset;
+		wdata->cfile = cifsFileInfo_get(open_file);
+		wdata->pid = pid;
+		wdata->bytes = cur_len;
+		wdata->marshal_iov = cifs_uncached_marshal_iov;
 		do {
 			if (open_file->invalidHandle) {
 				rc = cifs_reopen_file(open_file, false);
 				if (rc != 0)
 					break;
 			}
-			io_parms.netfid = open_file->netfid;
-			io_parms.pid = pid;
-			io_parms.tcon = tcon;
-			io_parms.offset = *poffset;
-			io_parms.length = cur_len;
-			rc = CIFSSMBWrite2(xid, &io_parms, &written, to_send,
-					   npages, 0);
+			rc = cifs_async_writev(wdata);
 		} while (rc == -EAGAIN);
 
-		for (i = 0; i < npages; i++)
-			kunmap(pages[i]);
-
-		if (written) {
-			len -= written;
-			total_written += written;
-			cifs_update_eof(CIFS_I(inode), *poffset, written);
-			*poffset += written;
-		} else if (rc < 0) {
-			if (!total_written)
-				total_written = rc;
+		if (rc) {
+			kref_put(&wdata->refcount, cifs_writedata_release);
 			break;
 		}
 
-		/* get length and number of kvecs of the next write */
-		npages = get_numpages(cifs_sb->wsize, len, &cur_len);
+		list_add_tail(&wdata->list, &wdata_list);
+		offset += cur_len;
+		len -= cur_len;
 	} while (len > 0);
 
+	/*
+	 * If at least one write was successfully sent, then discard any rc
+	 * value from the later writes. If the other write succeeds, then
+	 * we'll end up returning whatever was written. If it fails, then
+	 * we'll get a new rc value from that.
+	 */
+	if (!list_empty(&wdata_list))
+		rc = 0;
+
+	/*
+	 * Wait for and collect replies for any successful sends in order of
+	 * increasing offset. Once an error is hit or we get a fatal signal
+	 * while waiting, then return without waiting for any more replies.
+	 */
+restart_loop:
+	list_for_each_entry_safe(wdata, tmp, &wdata_list, list) {
+		if (!rc) {
+			/* FIXME: freezable too? */
+			rc = wait_for_completion_killable(&wdata->done);
+			if (!rc) {
+				if (wdata->result)
+					rc = wdata->result;
+				else
+					total_written += wdata->bytes;
+			} else if (rc == -EAGAIN) {
+				do {
+					if (open_file->invalidHandle) {
+						rc = cifs_reopen_file(open_file,
+									false);
+						if (rc != 0)
+							break;
+					}
+					rc = cifs_async_writev(wdata);
+				} while (rc == -EAGAIN);
+				goto restart_loop;
+			}
+		}
+		list_del_init(&wdata->list);
+		kref_put(&wdata->refcount, cifs_writedata_release);
+	}
+
 	if (total_written > 0) {
+		cifs_update_eof(cifsi, *poffset, total_written);
+		*poffset += total_written;
 		spin_lock(&inode->i_lock);
-		if (*poffset > inode->i_size)
-			i_size_write(inode, *poffset);
+		if (offset > inode->i_size)
+			i_size_write(inode, cifsi->server_eof);
 		spin_unlock(&inode->i_lock);
 	}
 
 	cifs_stats_bytes_written(tcon, total_written);
-	mark_inode_dirty_sync(inode);
-
-	for (i = 0; i < num_pages; i++)
-		put_page(pages[i]);
-	kfree(to_send);
-	kfree(pages);
-	FreeXid(xid);
-	return total_written;
+	return total_written ? total_written : (ssize_t)rc;
 }
 
 ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
-- 
1.7.7.6
