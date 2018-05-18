From: Long Li <longli@linuxonhyperv.com>
Subject: [RFC PATCH 08/09] Implement direct file I/O interfaces
Date: Thu, 17 May 2018 17:22:13 -0700
Message-ID: <20180518002214.5657-9-longli@linuxonhyperv.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518002214.5657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Implement the main filesystem interface for doing read and write. These functions
don't copy the user data into a kenrel buffer for data transfer. Pages are directly
pinned and passed to the RDMA transport.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsfs.c |  19 ++++
 fs/cifs/cifsfs.h |   3 +
 fs/cifs/file.c   | 322 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 329 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f715609..ba19fed 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1118,6 +1118,25 @@ const struct file_operations cifs_file_direct_ops = {
 	.fallocate = cifs_fallocate,
 };
 
+const struct file_operations cifs_file_direct_rdma_ops = {
+	.read_iter = cifs_direct_readv,
+	.write_iter = cifs_direct_writev,
+	.open = cifs_open,
+	.release = cifs_close,
+	.lock = cifs_lock,
+	.fsync = cifs_fsync,
+	.flush = cifs_flush,
+	.mmap = cifs_file_mmap,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
+	.unlocked_ioctl  = cifs_ioctl,
+	.copy_file_range = cifs_copy_file_range,
+	.clone_file_range = cifs_clone_file_range,
+	.llseek = cifs_llseek,
+	.setlease = cifs_setlease,
+	.fallocate = cifs_fallocate,
+};
+
 const struct file_operations cifs_file_nobrl_ops = {
 	.read_iter = cifs_loose_read_iter,
 	.write_iter = cifs_file_write_iter,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 013ba2a..223cca8 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -94,6 +94,7 @@ extern const struct inode_operations cifs_dfs_referral_inode_operations;
 /* Functions related to files and directories */
 extern const struct file_operations cifs_file_ops;
 extern const struct file_operations cifs_file_direct_ops; /* if directio mnt */
+extern const struct file_operations cifs_file_direct_rdma_ops; /* if directio mnt */
 extern const struct file_operations cifs_file_strict_ops; /* if strictio mnt */
 extern const struct file_operations cifs_file_nobrl_ops; /* no brlocks */
 extern const struct file_operations cifs_file_direct_nobrl_ops;
@@ -102,8 +103,10 @@ extern int cifs_open(struct inode *inode, struct file *file);
 extern int cifs_close(struct inode *inode, struct file *file);
 extern int cifs_closedir(struct inode *inode, struct file *file);
 extern ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to);
+extern ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to);
 extern ssize_t cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to);
 extern ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from);
+extern ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from);
 extern ssize_t cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from);
 extern int cifs_lock(struct file *, int, struct file_lock *);
 extern int cifs_fsync(struct file *, loff_t, loff_t, int);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e240c7c..0b394db 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2452,15 +2452,46 @@ cifs_uncached_writedata_release(struct kref *refcount)
 	int i;
 	struct cifs_writedata *wdata = container_of(refcount,
 					struct cifs_writedata, refcount);
+	struct page **pages = wdata->direct_pages ? wdata->direct_pages : wdata->pages;
 
 	kref_put(&wdata->ctx->refcount, cifs_aio_ctx_release);
 	for (i = 0; i < wdata->nr_pages; i++)
-		put_page(wdata->pages[i]);
+		put_page(pages[i]);
 	cifs_writedata_release(refcount);
 }
 
 static void collect_uncached_write_data(struct cifs_aio_ctx *ctx);
 
+static void cifs_direct_writedata_release(struct kref *refcount)
+{
+	int i;
+	struct cifs_writedata *wdata = container_of(refcount,
+					struct cifs_writedata, refcount);
+
+	for (i = 0; i < wdata->nr_pages; i++)
+		put_page(wdata->direct_pages[i]);
+	kvfree(wdata->direct_pages);
+
+	cifs_writedata_release(refcount);
+}
+
+static void cifs_direct_writev_complete(struct work_struct *work)
+{
+	struct cifs_writedata *wdata = container_of(work,
+					struct cifs_writedata, work);
+	struct inode *inode = d_inode(wdata->cfile->dentry);
+	struct cifsInodeInfo *cifsi = CIFS_I(inode);
+
+	spin_lock(&inode->i_lock);
+	cifs_update_eof(cifsi, wdata->offset, wdata->bytes);
+	if (cifsi->server_eof > inode->i_size)
+		i_size_write(inode, cifsi->server_eof);
+	spin_unlock(&inode->i_lock);
+
+	complete(&wdata->done);
+	kref_put(&wdata->refcount, cifs_direct_writedata_release);
+}
+
 static void
 cifs_uncached_writev_complete(struct work_struct *work)
 {
@@ -2703,6 +2734,125 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 		complete(&ctx->done);
 }
 
+ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	ssize_t total_written = 0;
+	struct cifsFileInfo *cfile;
+	struct cifs_tcon *tcon;
+	struct cifs_sb_info *cifs_sb;
+	struct TCP_Server_Info *server;
+	pid_t pid;
+	unsigned long nr_pages;
+	loff_t offset = iocb->ki_pos;
+	size_t len = iov_iter_count(from);
+	int rc;
+	struct cifs_writedata *wdata;
+
+	rc = generic_write_checks(iocb, from);
+	if (rc <= 0)
+		return rc;
+
+	cifs_sb = CIFS_FILE_SB(file);
+	cfile = file->private_data;
+	tcon = tlink_tcon(cfile->tlink);
+	server = tcon->ses->server;
+
+	if (!server->ops->async_writev)
+		return -ENOSYS;
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		pid = cfile->pid;
+	else
+		pid = current->tgid;
+
+	do {
+		unsigned int wsize, credits;
+		struct page **pagevec;
+		size_t start;
+		ssize_t cur_len;
+
+		rc = server->ops->wait_mtu_credits(server, cifs_sb->wsize,
+						   &wsize, &credits);
+		if (rc)
+			break;
+
+		cur_len = iov_iter_get_pages_alloc(from, &pagevec, wsize, &start);
+		if (cur_len < 0) {
+			cifs_dbg(VFS, "direct_writev couldn't get user pages (rc=%zd) iter type %d iov_offset %lu count %lu\n", cur_len, from->type, from->iov_offset, from->count);
+			dump_stack();
+			break;
+		}
+		if (cur_len < 0)
+			break;
+
+		nr_pages = (cur_len + start + PAGE_SIZE -1) / PAGE_SIZE;
+
+		wdata = cifs_writedata_alloc(nr_pages, pagevec,
+					     cifs_direct_writev_complete);
+		if (!wdata) {
+			rc = -ENOMEM;
+			add_credits_and_wake_if(server, credits, 0);
+			break;
+		}
+
+		wdata->nr_pages = nr_pages;
+		wdata->page_offset = start;
+		wdata->pagesz = PAGE_SIZE;
+		wdata->tailsz =
+			nr_pages > 1 ?
+			cur_len - (PAGE_SIZE-start) - (nr_pages - 2)*PAGE_SIZE :
+			cur_len;
+
+		wdata->sync_mode = WB_SYNC_ALL;
+		wdata->offset = (__u64)offset;
+		wdata->cfile = cifsFileInfo_get(cfile);
+		wdata->pid = pid;
+		wdata->bytes = cur_len;
+		wdata->credits = credits;
+
+		kref_get(&wdata->refcount);
+
+		if (!wdata->cfile->invalidHandle ||
+		    !(rc = cifs_reopen_file(wdata->cfile, false)))
+			rc = server->ops->async_writev(wdata,
+					cifs_direct_writedata_release);
+		if (rc) {
+			add_credits_and_wake_if(server, wdata->credits, 0);
+			kref_put(&wdata->refcount,
+				 cifs_writedata_release);
+			if (rc == -EAGAIN)
+				continue;
+			break;
+		} else
+			wait_for_completion(&wdata->done);
+
+		if (wdata->result) {
+			rc = wdata->result;
+			kref_put(&wdata->refcount, cifs_direct_writedata_release);
+			if (rc == -EAGAIN)
+				continue;
+			break;
+		}
+
+		kref_put(&wdata->refcount, cifs_direct_writedata_release);
+
+		iov_iter_advance(from, cur_len);
+		total_written += cur_len;
+		offset += cur_len;
+		len -= cur_len;
+	} while (len);
+
+	if (unlikely(!total_written)) {
+		printk(KERN_ERR "%s: total_written=%ld rc=%d\n", __func__, total_written, rc);
+		return rc;
+	}
+
+	iocb->ki_pos += total_written;
+	return total_written;
+
+}
+
 ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
@@ -2942,18 +3092,30 @@ cifs_read_allocate_pages(struct cifs_readdata *rdata, unsigned int nr_pages)
 	return rc;
 }
 
+static void cifs_direct_readdata_release(struct kref *refcount)
+{
+	struct cifs_readdata *rdata = container_of(refcount,
+					struct cifs_readdata, refcount);
+	unsigned int i;
+	for (i = 0; i < rdata->nr_pages; i++) {
+		put_page(rdata->direct_pages[i]);
+	}
+	kvfree(rdata->direct_pages);
+
+	cifs_readdata_release(refcount);
+}
+
 static void
 cifs_uncached_readdata_release(struct kref *refcount)
 {
 	struct cifs_readdata *rdata = container_of(refcount,
 					struct cifs_readdata, refcount);
 	unsigned int i;
+	struct page **pages = rdata->direct_pages ? rdata->direct_pages : rdata->pages;
 
 	kref_put(&rdata->ctx->refcount, cifs_aio_ctx_release);
-	for (i = 0; i < rdata->nr_pages; i++) {
-		put_page(rdata->pages[i]);
-		rdata->pages[i] = NULL;
-	}
+	for (i = 0; i < rdata->nr_pages; i++)
+		put_page(pages[i]);
 	cifs_readdata_release(refcount);
 }
 
@@ -3013,30 +3175,32 @@ uncached_fill_pages(struct TCP_Server_Info *server,
 	int result = 0;
 	unsigned int i;
 	unsigned int nr_pages = rdata->nr_pages;
+	unsigned int page_offset = rdata->page_offset;
 
 	rdata->got_bytes = 0;
 	rdata->tailsz = PAGE_SIZE;
 	for (i = 0; i < nr_pages; i++) {
-		struct page *page = rdata->pages[i];
+		struct page *page = rdata->direct_pages ? rdata->direct_pages[i] : rdata->pages[i];
 		size_t n;
+		unsigned int segment_size = rdata->pagesz;
+
+		if (i == 0)
+			segment_size -= page_offset;
+		else
+			page_offset = 0;
+
 
 		if (len <= 0) {
 			/* no need to hold page hostage */
-			rdata->pages[i] = NULL;
 			rdata->nr_pages--;
 			put_page(page);
 			continue;
 		}
 		n = len;
-		if (len >= PAGE_SIZE) {
+		if (len >= segment_size)
 			/* enough data to fill the page */
-			n = PAGE_SIZE;
-			len -= n;
-		} else {
-			zero_user(page, len, PAGE_SIZE - len);
-			rdata->tailsz = len;
-			len = 0;
-		}
+			n = segment_size;
+		len -= n;
 		if (iter)
 			result = copy_page_from_iter(page, 0, n, iter);
 #ifdef CONFIG_CIFS_SMB_DIRECT
@@ -3243,6 +3407,134 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 		complete(&ctx->done);
 }
 
+static void cifs_direct_readv_complete(struct work_struct *work)
+{
+	struct cifs_readdata *rdata = container_of(work, struct cifs_readdata, work);
+	int i = 0;
+	unsigned int bytes = 0;
+
+	// Set them dirty?
+	while (bytes < rdata->got_bytes + rdata->page_offset) {
+		set_page_dirty(rdata->direct_pages[i++]);
+		bytes += rdata->pagesz;
+	}
+	
+	complete(&rdata->done);
+	kref_put(&rdata->refcount, cifs_direct_readdata_release);
+}
+
+ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to)
+{
+	size_t len, cur_len, start;
+	unsigned int npages, rsize, credits;
+	struct file *file;
+	struct cifs_sb_info *cifs_sb;
+	struct cifsFileInfo *cfile;
+	struct cifs_tcon *tcon;
+	struct page **pagevec;
+	ssize_t rc, total_read = 0;
+	struct TCP_Server_Info *server;
+	loff_t offset = iocb->ki_pos;
+	pid_t pid;
+	struct cifs_readdata *rdata;
+	char *buf = to->iov->iov_base;
+
+	len = iov_iter_count(to);
+	if (!len)
+		return 0;
+
+	file = iocb->ki_filp;
+	cifs_sb = CIFS_FILE_SB(file);
+	cfile = file->private_data;
+	tcon = tlink_tcon(cfile->tlink);
+	server = tcon->ses->server;
+
+	if (!server->ops->async_readv)
+		return -ENOSYS;
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		pid = cfile->pid;
+	else
+		pid = current->tgid;
+
+	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
+		cifs_dbg(FYI, "attempting read on write only file instance\n");
+
+	do {
+		rc = server->ops->wait_mtu_credits(server, cifs_sb->rsize,
+					&rsize, &credits);
+		if (rc)
+			break;
+
+		cur_len = min_t(const size_t, len, rsize);
+
+		rc = iov_iter_get_pages_alloc(to, &pagevec, cur_len, &start);
+		if (rc < 0) {
+			cifs_dbg(VFS, "couldn't get user pages (rc=%zd) iter type %d iov_offset %lu count %lu\n", rc, to->type, to->iov_offset, to->count);
+			dump_stack();
+			break;
+		}
+
+		rdata = cifs_readdata_alloc(0, pagevec, cifs_direct_readv_complete);
+		if (!rdata) {
+			add_credits_and_wake_if(server, credits, 0);
+			rc = -ENOMEM;
+			break;
+		}
+
+		npages = (rc + start + PAGE_SIZE-1) / PAGE_SIZE;
+		rdata->nr_pages = npages;
+		rdata->page_offset = start;
+		rdata->pagesz = PAGE_SIZE;
+		rdata->tailsz = npages > 1 ?
+				rc-(PAGE_SIZE-start)-(npages-2)*PAGE_SIZE :
+				rc;
+		cur_len = rc;
+
+		rdata->cfile = cfile;
+		rdata->offset = offset;
+		rdata->bytes = rc;
+		rdata->pid = pid;
+		rdata->read_into_pages = cifs_uncached_read_into_pages;
+		rdata->copy_into_pages = cifs_uncached_copy_into_pages;
+		rdata->credits = credits;
+
+		kref_get(&rdata->refcount);
+
+		if (!rdata->cfile->invalidHandle ||
+		    !(rc = cifs_reopen_file(rdata->cfile, true)))
+			rc = server->ops->async_readv(rdata);
+
+		if (rc) {
+			add_credits_and_wake_if(server, rdata->credits, 0);
+			kref_put(&rdata->refcount,
+				 cifs_direct_readdata_release);
+			if (rc == -EAGAIN)
+				continue;
+		} else
+			wait_for_completion(&rdata->done);
+
+		rc = rdata->result;
+		if (rc) {
+			kref_put(&rdata->refcount, cifs_direct_readdata_release);
+			if (rc == -EAGAIN)
+				continue;
+			break;
+		}
+
+		total_read += rdata->got_bytes;
+		kref_put(&rdata->refcount, cifs_direct_readdata_release);
+
+		iov_iter_advance(to, cur_len);
+		len -= cur_len;
+		offset += cur_len;
+	} while (len);
+
+	iocb->ki_pos += total_read;
+
+	return total_read;
+}
+
 ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
-- 
2.7.4
