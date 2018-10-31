From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v4 1/3] CIFS: Add support for direct I/O read
Date: Wed, 31 Oct 2018 22:13:09 +0000
Message-ID: <20181031221311.2596-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

With direct I/O read, we transfer the data directly from transport layer to
the user data buffer.

Change in v3: add support for kernel AIO

Change in v4:
Refactor common read code to __cifs_readv for direct and non-direct I/O.
Retry on direct I/O failure.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsfs.h   |   1 +
 fs/cifs/cifsglob.h |   5 ++
 fs/cifs/file.c     | 219 +++++++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 186 insertions(+), 39 deletions(-)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 5f02318..7fba9aa 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -102,6 +102,7 @@ extern int cifs_open(struct inode *inode, struct file *file);
 extern int cifs_close(struct inode *inode, struct file *file);
 extern int cifs_closedir(struct inode *inode, struct file *file);
 extern ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to);
+extern ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to);
 extern ssize_t cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to);
 extern ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from);
 extern ssize_t cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7f62c98..52248dd 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1146,6 +1146,11 @@ struct cifs_aio_ctx {
 	unsigned int		len;
 	unsigned int		total_len;
 	bool			should_dirty;
+	/*
+	 * Indicates if this aio_ctx is for direct_io,
+	 * If yes, iter is a copy of the user passed iov_iter
+	 */
+	bool			direct_io;
 };
 
 struct cifs_readdata;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 87eece6..daab878 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2965,7 +2965,6 @@ cifs_uncached_readdata_release(struct kref *refcount)
 	kref_put(&rdata->ctx->refcount, cifs_aio_ctx_release);
 	for (i = 0; i < rdata->nr_pages; i++) {
 		put_page(rdata->pages[i]);
-		rdata->pages[i] = NULL;
 	}
 	cifs_readdata_release(refcount);
 }
@@ -3092,6 +3091,63 @@ cifs_uncached_copy_into_pages(struct TCP_Server_Info *server,
 	return uncached_fill_pages(server, rdata, iter, iter->count);
 }
 
+static int cifs_resend_rdata(struct cifs_readdata *rdata,
+                     struct list_head *rdata_list,
+                     struct cifs_aio_ctx *ctx)
+{
+	int wait_retry = 0;
+	unsigned int rsize, credits;
+	int rc;
+	struct TCP_Server_Info *server = tlink_tcon(rdata->cfile->tlink)->ses->server;
+
+	/*
+	 * Try to resend this rdata, waiting for credits up to 3 seconds.
+	 * Note: we are attempting to resend the whole rdata not in segments
+	 */
+	do {
+		rc = server->ops->wait_mtu_credits(server, rdata->bytes,
+						&rsize, &credits);
+
+		if (rc)
+			break;
+
+		if (rsize < rdata->bytes) {
+			add_credits_and_wake_if(server, credits, 0);
+			msleep(1000);
+			wait_retry++;
+		}
+	} while (rsize < rdata->bytes && wait_retry < 3);
+
+	/*
+	 * If we can't find enough credits to send this rdata
+	 * release the rdata and return failure, this will pass
+	 * whatever I/O amount we have finished to VFS.
+	 */
+	if (rsize < rdata->bytes) {
+		rc = -EBUSY;
+		goto out;
+	}
+
+	rc = -EAGAIN;
+	while (rc == -EAGAIN)
+		if (!rdata->cfile->invalidHandle ||
+		    !(rc = cifs_reopen_file(rdata->cfile, true)))
+			rc = server->ops->async_readv(rdata);
+
+	if (!rc) {
+		/* Add to aio pending list */
+		list_add_tail(&rdata->list, rdata_list);
+		return 0;
+	}
+
+	add_credits_and_wake_if(server, rdata->credits, 0);
+out:
+	kref_put(&rdata->refcount,
+		cifs_uncached_readdata_release);
+
+	return rc;
+}
+
 static int
 cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 		     struct cifs_sb_info *cifs_sb, struct list_head *rdata_list,
@@ -3103,6 +3159,9 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 	int rc;
 	pid_t pid;
 	struct TCP_Server_Info *server;
+	struct page **pagevec;
+	size_t start;
+	struct iov_iter direct_iov = ctx->iter;
 
 	server = tlink_tcon(open_file->tlink)->ses->server;
 
@@ -3111,6 +3170,9 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 	else
 		pid = current->tgid;
 
+	if (ctx->direct_io)
+		iov_iter_advance(&direct_iov, offset - ctx->pos);
+
 	do {
 		rc = server->ops->wait_mtu_credits(server, cifs_sb->rsize,
 						   &rsize, &credits);
@@ -3118,20 +3180,56 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 			break;
 
 		cur_len = min_t(const size_t, len, rsize);
-		npages = DIV_ROUND_UP(cur_len, PAGE_SIZE);
 
-		/* allocate a readdata struct */
-		rdata = cifs_readdata_alloc(npages,
+		if (ctx->direct_io) {
+
+			cur_len = iov_iter_get_pages_alloc(
+					&direct_iov, &pagevec,
+					cur_len, &start);
+			if (cur_len < 0) {
+				cifs_dbg(VFS,
+					"couldn't get user pages (cur_len=%zd)"
+					" iter type %d"
+					" iov_offset %zd count %zd\n",
+					cur_len, direct_iov.type, direct_iov.iov_offset,
+					direct_iov.count);
+				dump_stack();
+				break;
+			}
+			iov_iter_advance(&direct_iov, cur_len);
+
+			rdata = cifs_readdata_direct_alloc(
+					pagevec, cifs_uncached_readv_complete);
+			if (!rdata) {
+				add_credits_and_wake_if(server, credits, 0);
+				rc = -ENOMEM;
+				break;
+			}
+
+			npages = (cur_len + start + PAGE_SIZE-1) / PAGE_SIZE;
+			rdata->page_offset = start;
+			rdata->tailsz = npages > 1 ?
+				cur_len-(PAGE_SIZE-start)-(npages-2)*PAGE_SIZE :
+				cur_len;
+
+		} else {
+
+			npages = DIV_ROUND_UP(cur_len, PAGE_SIZE);
+			/* allocate a readdata struct */
+			rdata = cifs_readdata_alloc(npages,
 					    cifs_uncached_readv_complete);
-		if (!rdata) {
-			add_credits_and_wake_if(server, credits, 0);
-			rc = -ENOMEM;
-			break;
-		}
+			if (!rdata) {
+				add_credits_and_wake_if(server, credits, 0);
+				rc = -ENOMEM;
+				break;
+			}
 
-		rc = cifs_read_allocate_pages(rdata, npages);
-		if (rc)
-			goto error;
+			rc = cifs_read_allocate_pages(rdata, npages);
+			if (rc)
+				goto error;
+
+			rdata->tailsz = PAGE_SIZE;
+		}
 
 		rdata->cfile = cifsFileInfo_get(open_file);
 		rdata->nr_pages = npages;
@@ -3139,7 +3237,6 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 		rdata->bytes = cur_len;
 		rdata->pid = pid;
 		rdata->pagesz = PAGE_SIZE;
-		rdata->tailsz = PAGE_SIZE;
 		rdata->read_into_pages = cifs_uncached_read_into_pages;
 		rdata->copy_into_pages = cifs_uncached_copy_into_pages;
 		rdata->credits = credits;
@@ -3153,9 +3250,11 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 		if (rc) {
 			add_credits_and_wake_if(server, rdata->credits, 0);
 			kref_put(&rdata->refcount,
-				 cifs_uncached_readdata_release);
-			if (rc == -EAGAIN)
+				cifs_uncached_readdata_release);
+			if (rc == -EAGAIN) {
+				iov_iter_revert(&direct_iov, cur_len);
 				continue;
+			}
 			break;
 		}
 
@@ -3211,45 +3310,62 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 				 * reading.
 				 */
 				if (got_bytes && got_bytes < rdata->bytes) {
-					rc = cifs_readdata_to_iov(rdata, to);
+					rc = 0;
+					if (!ctx->direct_io)
+						rc = cifs_readdata_to_iov(rdata, to);
 					if (rc) {
 						kref_put(&rdata->refcount,
-						cifs_uncached_readdata_release);
+							cifs_uncached_readdata_release);
 						continue;
 					}
 				}
 
-				rc = cifs_send_async_read(
+				if (ctx->direct_io) {
+					/*
+					 * Re-use rdata as this is a
+					 * direct I/O
+					 */
+					rc = cifs_resend_rdata(
+						rdata,
+						&tmp_list, ctx);
+				} else {
+					rc = cifs_send_async_read(
 						rdata->offset + got_bytes,
 						rdata->bytes - got_bytes,
 						rdata->cfile, cifs_sb,
 						&tmp_list, ctx);
 
+					kref_put(&rdata->refcount,
+						cifs_uncached_readdata_release);
+				}
+
 				list_splice(&tmp_list, &ctx->list);
 
-				kref_put(&rdata->refcount,
-					 cifs_uncached_readdata_release);
 				goto again;
 			} else if (rdata->result)
 				rc = rdata->result;
-			else
+			else if (!ctx->direct_io)
 				rc = cifs_readdata_to_iov(rdata, to);
 
 			/* if there was a short read -- discard anything left */
 			if (rdata->got_bytes && rdata->got_bytes < rdata->bytes)
 				rc = -ENODATA;
+
+			ctx->total_len += rdata->got_bytes;
 		}
 		list_del_init(&rdata->list);
 		kref_put(&rdata->refcount, cifs_uncached_readdata_release);
 	}
 
-	for (i = 0; i < ctx->npages; i++) {
-		if (ctx->should_dirty)
-			set_page_dirty(ctx->bv[i].bv_page);
-		put_page(ctx->bv[i].bv_page);
-	}
+	if (!ctx->direct_io) {
+		for (i = 0; i < ctx->npages; i++) {
+			if (ctx->should_dirty)
+				set_page_dirty(ctx->bv[i].bv_page);
+			put_page(ctx->bv[i].bv_page);
+		}
 
-	ctx->total_len = ctx->len - iov_iter_count(to);
+		ctx->total_len = ctx->len - iov_iter_count(to);
+	}
 
 	cifs_stats_bytes_read(tcon, ctx->total_len);
 
@@ -3267,18 +3383,27 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 		complete(&ctx->done);
 }
 
-ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
+ssize_t __cifs_readv(struct kiocb *iocb, struct iov_iter *to, bool direct)
 {
-	struct file *file = iocb->ki_filp;
-	ssize_t rc;
 	size_t len;
-	ssize_t total_read = 0;
-	loff_t offset = iocb->ki_pos;
+	struct file *file = iocb->ki_filp;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *tcon;
 	struct cifsFileInfo *cfile;
+	struct cifs_tcon *tcon;
+	ssize_t rc, total_read = 0;
+	loff_t offset = iocb->ki_pos;
 	struct cifs_aio_ctx *ctx;
 
+	/*
+	 * iov_iter_get_pages_alloc() doesn't work with ITER_KVEC,
+	 * fall back to data copy read path
+	 * this could be improved by getting pages directly in ITER_KVEC
+	 */
+	if (direct && to->type & ITER_KVEC) {
+		cifs_dbg(FYI, "use non-direct cifs_user_readv for kvec I/O\n");
+		direct = false;
+	}
+
 	len = iov_iter_count(to);
 	if (!len)
 		return 0;
@@ -3305,14 +3430,20 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
 	if (to->type == ITER_IOVEC)
 		ctx->should_dirty = true;
 
-	rc = setup_aio_ctx_iter(ctx, to, READ);
-	if (rc) {
-		kref_put(&ctx->refcount, cifs_aio_ctx_release);
-		return rc;
+	if (direct) {
+		ctx->pos = offset;
+		ctx->direct_io = true;
+		ctx->iter = *to;
+		ctx->len = len;
+	} else {
+		rc = setup_aio_ctx_iter(ctx, to, READ);
+		if (rc) {
+			kref_put(&ctx->refcount, cifs_aio_ctx_release);
+			return rc;
+		}
+		len = ctx->len;
 	}
 
-	len = ctx->len;
-
 	/* grab a lock here due to read response handlers can access ctx */
 	mutex_lock(&ctx->aio_mutex);
 
@@ -3354,6 +3485,16 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
 	return rc;
 }
 
+ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to)
+{
+	return __cifs_readv(iocb, to, true);
+}
+
+ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
+{
+	return __cifs_readv(iocb, to, false);
+}
+
 ssize_t
 cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 {
-- 
2.7.4
