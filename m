From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 2/3] CIFS: Add asynchronous read support through kernel AIO
Date: Tue, 25 Apr 2017 11:52:30 -0700
Message-ID: <1493146351-124933-3-git-send-email-pshilov@microsoft.com>
References: <1493146351-124933-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493146351-124933-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch adds support to process read calls passed by io_submit()
asynchronously. It based on the previously introduced async context
that allows to process i/o responses in a separate thread and
return the caller immediately for asynchronous calls.

This improves reading performance of single threaded applications
with increasing of i/o queue depth size.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h |   1 +
 fs/cifs/file.c     | 169 ++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 131 insertions(+), 39 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bb41226..9438c7c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1140,6 +1140,7 @@ struct cifs_readdata {
 	struct completion		done;
 	struct cifsFileInfo		*cfile;
 	struct address_space		*mapping;
+	struct cifs_aio_ctx		*ctx;
 	__u64				offset;
 	unsigned int			bytes;
 	unsigned int			got_bytes;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 21d4045..9564e2c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2859,6 +2859,7 @@ cifs_uncached_readdata_release(struct kref *refcount)
 					struct cifs_readdata, refcount);
 	unsigned int i;
 
+	kref_put(&rdata->ctx->refcount, cifs_aio_ctx_release);
 	for (i = 0; i < rdata->nr_pages; i++) {
 		put_page(rdata->pages[i]);
 		rdata->pages[i] = NULL;
@@ -2900,6 +2901,8 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, struct iov_iter *iter)
 	return remaining ? -EFAULT : 0;
 }
 
+static void collect_uncached_read_data(struct cifs_aio_ctx *ctx);
+
 static void
 cifs_uncached_readv_complete(struct work_struct *work)
 {
@@ -2907,6 +2910,8 @@ cifs_uncached_readv_complete(struct work_struct *work)
 						struct cifs_readdata, work);
 
 	complete(&rdata->done);
+	collect_uncached_read_data(rdata->ctx);
+	/* the below call can possibly free the last ref to aio ctx */
 	kref_put(&rdata->refcount, cifs_uncached_readdata_release);
 }
 
@@ -2973,7 +2978,8 @@ cifs_uncached_copy_into_pages(struct TCP_Server_Info *server,
 
 static int
 cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
-		     struct cifs_sb_info *cifs_sb, struct list_head *rdata_list)
+		     struct cifs_sb_info *cifs_sb, struct list_head *rdata_list,
+		     struct cifs_aio_ctx *ctx)
 {
 	struct cifs_readdata *rdata;
 	unsigned int npages, rsize, credits;
@@ -3020,6 +3026,8 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 		rdata->read_into_pages = cifs_uncached_read_into_pages;
 		rdata->copy_into_pages = cifs_uncached_copy_into_pages;
 		rdata->credits = credits;
+		rdata->ctx = ctx;
+		kref_get(&ctx->refcount);
 
 		if (!rdata->cfile->invalidHandle ||
 		    !(rc = cifs_reopen_file(rdata->cfile, true)))
@@ -3042,50 +3050,37 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 	return rc;
 }
 
-ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
+static void
+collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 {
-	struct file *file = iocb->ki_filp;
-	ssize_t rc;
-	size_t len;
-	ssize_t total_read = 0;
-	loff_t offset = iocb->ki_pos;
+	struct cifs_readdata *rdata, *tmp;
+	struct iov_iter *to = &ctx->iter;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
-	struct cifsFileInfo *open_file;
-	struct cifs_readdata *rdata, *tmp;
-	struct list_head rdata_list;
-
-	len = iov_iter_count(to);
-	if (!len)
-		return 0;
+	unsigned int i;
+	int rc;
 
-	INIT_LIST_HEAD(&rdata_list);
-	cifs_sb = CIFS_FILE_SB(file);
-	open_file = file->private_data;
-	tcon = tlink_tcon(open_file->tlink);
+	tcon = tlink_tcon(ctx->cfile->tlink);
+	cifs_sb = CIFS_SB(ctx->cfile->dentry->d_sb);
 
-	if (!tcon->ses->server->ops->async_readv)
-		return -ENOSYS;
+	mutex_lock(&ctx->aio_mutex);
 
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		cifs_dbg(FYI, "attempting read on write only file instance\n");
-
-	rc = cifs_send_async_read(offset, len, open_file, cifs_sb, &rdata_list);
-
-	/* if at least one read request send succeeded, then reset rc */
-	if (!list_empty(&rdata_list))
-		rc = 0;
+	if (list_empty(&ctx->list)) {
+		mutex_unlock(&ctx->aio_mutex);
+		return;
+	}
 
-	len = iov_iter_count(to);
+	rc = ctx->rc;
 	/* the loop below should proceed in the order of increasing offsets */
 again:
-	list_for_each_entry_safe(rdata, tmp, &rdata_list, list) {
+	list_for_each_entry_safe(rdata, tmp, &ctx->list, list) {
 		if (!rc) {
-			/* FIXME: freezable sleep too? */
-			rc = wait_for_completion_killable(&rdata->done);
-			if (rc)
-				rc = -EINTR;
-			else if (rdata->result == -EAGAIN) {
+			if (!try_wait_for_completion(&rdata->done)) {
+				mutex_unlock(&ctx->aio_mutex);
+				return;
+			}
+
+			if (rdata->result == -EAGAIN) {
 				/* resend call if it's a retryable error */
 				struct list_head tmp_list;
 				unsigned int got_bytes = rdata->got_bytes;
@@ -3111,9 +3106,9 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
 						rdata->offset + got_bytes,
 						rdata->bytes - got_bytes,
 						rdata->cfile, cifs_sb,
-						&tmp_list);
+						&tmp_list, ctx);
 
-				list_splice(&tmp_list, &rdata_list);
+				list_splice(&tmp_list, &ctx->list);
 
 				kref_put(&rdata->refcount,
 					 cifs_uncached_readdata_release);
@@ -3131,14 +3126,110 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
 		kref_put(&rdata->refcount, cifs_uncached_readdata_release);
 	}
 
-	total_read = len - iov_iter_count(to);
+	for (i = 0; i < ctx->npages; i++) {
+		if (ctx->should_dirty)
+			set_page_dirty(ctx->bv[i].bv_page);
+		put_page(ctx->bv[i].bv_page);
+	}
 
-	cifs_stats_bytes_read(tcon, total_read);
+	ctx->total_len = ctx->len - iov_iter_count(to);
+
+	cifs_stats_bytes_read(tcon, ctx->total_len);
 
 	/* mask nodata case */
 	if (rc == -ENODATA)
 		rc = 0;
 
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
+ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct file *file = iocb->ki_filp;
+	ssize_t rc;
+	size_t len;
+	ssize_t total_read = 0;
+	loff_t offset = iocb->ki_pos;
+	struct cifs_sb_info *cifs_sb;
+	struct cifs_tcon *tcon;
+	struct cifsFileInfo *cfile;
+	struct cifs_aio_ctx *ctx;
+
+	len = iov_iter_count(to);
+	if (!len)
+		return 0;
+
+	cifs_sb = CIFS_FILE_SB(file);
+	cfile = file->private_data;
+	tcon = tlink_tcon(cfile->tlink);
+
+	if (!tcon->ses->server->ops->async_readv)
+		return -ENOSYS;
+
+	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
+		cifs_dbg(FYI, "attempting read on write only file instance\n");
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
+	if (to->type & ITER_IOVEC)
+		ctx->should_dirty = true;
+
+	rc = setup_aio_ctx_iter(ctx, to, READ);
+	if (rc) {
+		kref_put(&ctx->refcount, cifs_aio_ctx_release);
+		return rc;
+	}
+
+	len = ctx->len;
+
+	/* grab a lock here due to read response handlers can access ctx */
+	mutex_lock(&ctx->aio_mutex);
+
+	rc = cifs_send_async_read(offset, len, cfile, cifs_sb, &ctx->list, ctx);
+
+	/* if at least one read request send succeeded, then reset rc */
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
+	rc = wait_for_completion_killable(&ctx->done);
+	if (rc) {
+		mutex_lock(&ctx->aio_mutex);
+		ctx->rc = rc = -EINTR;
+		total_read = ctx->total_len;
+		mutex_unlock(&ctx->aio_mutex);
+	} else {
+		rc = ctx->rc;
+		total_read = ctx->total_len;
+	}
+
+	kref_put(&ctx->refcount, cifs_aio_ctx_release);
+
 	if (total_read) {
 		iocb->ki_pos += total_read;
 		return total_read;
-- 
2.7.4
