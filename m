From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] CIFS: Add asynchronous write support through kernel AIO
Date: Fri, 10 Feb 2017 15:17:58 -0800
Message-ID: <1486768678-36802-3-git-send-email-pshilov@microsoft.com>
References: <1486768678-36802-1-git-send-email-pshilov@microsoft.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486768678-36802-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch adds support to process write calls passed by io_submit()
asynchronously. It based on the previously introduced async context
that allows to process i/o responses in a separate thread and
return the caller immediately for asynchronous calls.

This improves writing performance of single threaded applications
with increasing of i/o queue depth size.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h |   2 +
 fs/cifs/file.c     | 189 ++++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 140 insertions(+), 51 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 80771ca..caa6f1a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1119,6 +1119,7 @@ struct cifs_aio_ctx {
 	struct cifsFileInfo	*cfile;
 	struct page		**pages;
 	struct bio_vec		*bv;
+	loff_t			pos;
 	unsigned int		npages;
 	ssize_t			rc;
 	unsigned int		len;
@@ -1166,6 +1167,7 @@ struct cifs_writedata {
 	enum writeback_sync_modes	sync_mode;
 	struct work_struct		work;
 	struct cifsFileInfo		*cfile;
+	struct cifs_aio_ctx		*ctx;
 	__u64				offset;
 	pid_t				pid;
 	unsigned int			bytes;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6ceeed2..8f80397 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2561,11 +2561,14 @@ cifs_uncached_writedata_release(struct kref *refcount)
 	struct cifs_writedata *wdata = container_of(refcount,
 					struct cifs_writedata, refcount);
 
+	kref_put(&wdata->ctx->refcount, cifs_aio_ctx_release);
 	for (i = 0; i < wdata->nr_pages; i++)
 		put_page(wdata->pages[i]);
 	cifs_writedata_release(refcount);
 }
 
+static void collect_uncached_write_data(struct cifs_aio_ctx *ctx);
+
 static void
 cifs_uncached_writev_complete(struct work_struct *work)
 {
@@ -2581,7 +2584,8 @@ cifs_uncached_writev_complete(struct work_struct *work)
 	spin_unlock(&inode->i_lock);
 
 	complete(&wdata->done);
-
+	collect_uncached_write_data(wdata->ctx);
+	/* the below call can possibly free the last ref to aio ctx */
 	kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 }
 
@@ -2630,7 +2634,8 @@ wdata_fill_from_iovec(struct cifs_writedata *wdata, struct iov_iter *from,
 static int
 cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 		     struct cifsFileInfo *open_file,
-		     struct cifs_sb_info *cifs_sb, struct list_head *wdata_list)
+		     struct cifs_sb_info *cifs_sb, struct list_head *wdata_list,
+		     struct cifs_aio_ctx *ctx)
 {
 	int rc = 0;
 	size_t cur_len;
@@ -2698,6 +2703,8 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 		wdata->pagesz = PAGE_SIZE;
 		wdata->tailsz = cur_len - ((nr_pages - 1) * PAGE_SIZE);
 		wdata->credits = credits;
+		wdata->ctx = ctx;
+		kref_get(&ctx->refcount);
 
 		if (!wdata->cfile->invalidHandle ||
 		    !cifs_reopen_file(wdata->cfile, false))
@@ -2723,81 +2730,61 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 	return rc;
 }
 
-ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
+static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 {
-	struct file *file = iocb->ki_filp;
-	ssize_t total_written = 0;
-	struct cifsFileInfo *open_file;
+	struct cifs_writedata *wdata, *tmp;
 	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_writedata *wdata, *tmp;
-	struct list_head wdata_list;
-	struct iov_iter saved_from = *from;
+	struct dentry *dentry = ctx->cfile->dentry;
+	unsigned int i;
 	int rc;
 
-	/*
-	 * BB - optimize the way when signing is disabled. We can drop this
-	 * extra memory-to-memory copying and use iovec buffers for constructing
-	 * write request.
-	 */
-
-	rc = generic_write_checks(iocb, from);
-	if (rc <= 0)
-		return rc;
-
-	INIT_LIST_HEAD(&wdata_list);
-	cifs_sb = CIFS_FILE_SB(file);
-	open_file = file->private_data;
-	tcon = tlink_tcon(open_file->tlink);
-
-	if (!tcon->ses->server->ops->async_writev)
-		return -ENOSYS;
+	tcon = tlink_tcon(ctx->cfile->tlink);
+	cifs_sb = CIFS_SB(dentry->d_sb);
 
-	rc = cifs_write_from_iter(iocb->ki_pos, iov_iter_count(from), from,
-				  open_file, cifs_sb, &wdata_list);
+	mutex_lock(&ctx->aio_mutex);
 
-	/*
-	 * If at least one write was successfully sent, then discard any rc
-	 * value from the later writes. If the other write succeeds, then
-	 * we'll end up returning whatever was written. If it fails, then
-	 * we'll get a new rc value from that.
-	 */
-	if (!list_empty(&wdata_list))
-		rc = 0;
+	if (list_empty(&ctx->list)) {
+		mutex_unlock(&ctx->aio_mutex);
+		return;
+	}
 
+	rc = ctx->rc;
 	/*
 	 * Wait for and collect replies for any successful sends in order of
-	 * increasing offset. Once an error is hit or we get a fatal signal
-	 * while waiting, then return without waiting for any more replies.
+	 * increasing offset. Once an error is hit, then return without waiting
+	 * for any more replies.
 	 */
 restart_loop:
-	list_for_each_entry_safe(wdata, tmp, &wdata_list, list) {
+	list_for_each_entry_safe(wdata, tmp, &ctx->list, list) {
 		if (!rc) {
-			/* FIXME: freezable too? */
-			rc = wait_for_completion_killable(&wdata->done);
-			if (rc)
-				rc = -EINTR;
-			else if (wdata->result)
+			if (!try_wait_for_completion(&wdata->done)) {
+				mutex_unlock(&ctx->aio_mutex);
+				return;
+			}
+
+			if (wdata->result)
 				rc = wdata->result;
 			else
-				total_written += wdata->bytes;
+				ctx->total_len += wdata->bytes;
 
 			/* resend call if it's a retryable error */
 			if (rc == -EAGAIN) {
 				struct list_head tmp_list;
-				struct iov_iter tmp_from = saved_from;
+				struct iov_iter tmp_from = ctx->iter;
 
 				INIT_LIST_HEAD(&tmp_list);
 				list_del_init(&wdata->list);
 
 				iov_iter_advance(&tmp_from,
-						 wdata->offset - iocb->ki_pos);
+						 wdata->offset - ctx->pos);
 
 				rc = cifs_write_from_iter(wdata->offset,
 						wdata->bytes, &tmp_from,
-						open_file, cifs_sb, &tmp_list);
+						ctx->cfile, cifs_sb, &tmp_list,
+						ctx);
 
-				list_splice(&tmp_list, &wdata_list);
+				list_splice(&tmp_list, &ctx->list);
 
 				kref_put(&wdata->refcount,
 					 cifs_uncached_writedata_release);
@@ -2808,12 +2795,112 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
 		kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 	}
 
+	for (i = 0; i < ctx->npages; i++)
+		put_page(ctx->bv[i].bv_page);
+
+	cifs_stats_bytes_written(tcon, ctx->total_len);
+	set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(dentry->d_inode)->flags);
+
+	ctx->rc = (rc == 0) ? ctx->total_len : rc;
+
+	mutex_unlock(&ctx->aio_mutex);
+
+	if (ctx->iocb && ctx->iocb->ki_complete)
+		ctx->iocb->ki_complete(ctx->iocb, ctx->rc, 0);
+	else
+		complete(&ctx->done);
+}
+
+ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	ssize_t total_written = 0;
+	struct cifsFileInfo *cfile;
+	struct cifs_tcon *tcon;
+	struct cifs_sb_info *cifs_sb;
+	struct cifs_aio_ctx *ctx;
+	struct iov_iter saved_from = *from;
+	int rc;
+
+	/*
+	 * BB - optimize the way when signing is disabled. We can drop this
+	 * extra memory-to-memory copying and use iovec buffers for constructing
+	 * write request.
+	 */
+
+	rc = generic_write_checks(iocb, from);
+	if (rc <= 0)
+		return rc;
+
+	cifs_sb = CIFS_FILE_SB(file);
+	cfile = file->private_data;
+	tcon = tlink_tcon(cfile->tlink);
+
+	if (!tcon->ses->server->ops->async_writev)
+		return -ENOSYS;
+
+	ctx = cifs_aio_ctx_alloc();
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->cfile = cifsFileInfo_get(cfile);
+
+	if (!is_sync_kiocb(iocb))
+		ctx->iocb = iocb;
+
+	ctx->pos = iocb->ki_pos;
+
+	rc = setup_aio_ctx_iter(ctx, from, WRITE);
+	if (rc) {
+		kref_put(&ctx->refcount, cifs_aio_ctx_release);
+		return rc;
+	}
+
+	/* grab a lock here due to read response handlers can access ctx */
+	mutex_lock(&ctx->aio_mutex);
+
+	rc = cifs_write_from_iter(iocb->ki_pos, ctx->len, &saved_from,
+				  cfile, cifs_sb, &ctx->list, ctx);
+
+	/*
+	 * If at least one write was successfully sent, then discard any rc
+	 * value from the later writes. If the other write succeeds, then
+	 * we'll end up returning whatever was written. If it fails, then
+	 * we'll get a new rc value from that.
+	 */
+	if (!list_empty(&ctx->list))
+		rc = 0;
+
+	mutex_unlock(&ctx->aio_mutex);
+
+	if (rc) {
+		kref_put(&ctx->refcount, cifs_aio_ctx_release);
+		return rc;
+	}
+
+	if (!is_sync_kiocb(iocb)) {
+		kref_put(&ctx->refcount, cifs_aio_ctx_release);
+		return -EIOCBQUEUED;
+	}
+
+	/* FIXME: freezable sleep too? */
+	rc = wait_for_completion_killable(&ctx->done);
+	if (rc) {
+		mutex_lock(&ctx->aio_mutex);
+		ctx->rc = rc = -EINTR;
+		total_written = ctx->total_len;
+		mutex_unlock(&ctx->aio_mutex);
+	} else {
+		rc = ctx->rc;
+		total_written = ctx->total_len;
+	}
+
+	kref_put(&ctx->refcount, cifs_aio_ctx_release);
+
 	if (unlikely(!total_written))
 		return rc;
 
 	iocb->ki_pos += total_written;
-	set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(file_inode(file))->flags);
-	cifs_stats_bytes_written(tcon, total_written);
 	return total_written;
 }
 
-- 
2.7.4
