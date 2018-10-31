From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v4 2/3] CIFS: Add support for direct I/O write
Date: Wed, 31 Oct 2018 22:13:10 +0000
Message-ID: <20181031221311.2596-2-longli@linuxonhyperv.com>
References: <20181031221311.2596-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181031221311.2596-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

With direct I/O write, user supplied buffers are pinned to the memory and data
are transferred directly from user buffers to the transport layer.

Change in v3: add support for kernel AIO

Change in v4:
Refactor common write code to __cifs_writev for direct and non-direct I/O.
Retry on direct I/O failure.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsfs.h |   1 +
 fs/cifs/file.c   | 194 +++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 154 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 7fba9aa..e9c5103 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -105,6 +105,7 @@ extern ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to);
 extern ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to);
 extern ssize_t cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to);
 extern ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from);
+extern ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from);
 extern ssize_t cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from);
 extern int cifs_lock(struct file *, int, struct file_lock *);
 extern int cifs_fsync(struct file *, loff_t, loff_t, int);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index daab878..1a41c04 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2524,6 +2524,55 @@ wdata_fill_from_iovec(struct cifs_writedata *wdata, struct iov_iter *from,
 }
 
 static int
+cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list, struct cifs_aio_ctx *ctx)
+{
+	int wait_retry = 0;
+	unsigned int wsize, credits;
+	int rc;
+	struct TCP_Server_Info *server = tlink_tcon(wdata->cfile->tlink)->ses->server;
+
+	/*
+	 * Try to resend this wdata, waiting for credits up to 3 seconds.
+	 * Note: we are attempting to resend the whole wdata not in segments
+	 */
+	do {
+		rc = server->ops->wait_mtu_credits(server, wdata->bytes, &wsize, &credits);
+
+		if (rc)
+			break;
+
+		if (wsize < wdata->bytes) {
+			add_credits_and_wake_if(server, credits, 0);
+			msleep(1000);
+			wait_retry++;
+		}
+	} while (wsize < wdata->bytes && wait_retry < 3);
+
+	if (wsize < wdata->bytes) {
+		rc = -EBUSY;
+		goto out;
+	}
+
+	rc = -EAGAIN;
+	while (rc == -EAGAIN)
+		if (!wdata->cfile->invalidHandle ||
+		    !(rc = cifs_reopen_file(wdata->cfile, false)))
+			rc = server->ops->async_writev(wdata,
+					cifs_uncached_writedata_release);
+
+	if (!rc) {
+		list_add_tail(&wdata->list, wdata_list);
+		return 0;
+	}
+
+	add_credits_and_wake_if(server, wdata->credits, 0);
+out:
+	kref_put(&wdata->refcount, cifs_uncached_writedata_release);
+
+	return rc;
+}
+
+static int
 cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 		     struct cifsFileInfo *open_file,
 		     struct cifs_sb_info *cifs_sb, struct list_head *wdata_list,
@@ -2537,6 +2586,8 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 	loff_t saved_offset = offset;
 	pid_t pid;
 	struct TCP_Server_Info *server;
+	struct page **pagevec;
+	size_t start;
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
@@ -2553,38 +2604,74 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 		if (rc)
 			break;
 
-		nr_pages = get_numpages(wsize, len, &cur_len);
-		wdata = cifs_writedata_alloc(nr_pages,
+		if (ctx->direct_io) {
+			cur_len = iov_iter_get_pages_alloc(
+				from, &pagevec, wsize, &start);
+			if (cur_len < 0) {
+				cifs_dbg(VFS,
+					"direct_writev couldn't get user pages "
+					"(rc=%zd) iter type %d iov_offset %zd count"
+					" %zd\n",
+					cur_len, from->type,
+					from->iov_offset, from->count);
+				dump_stack();
+				break;
+			}
+			iov_iter_advance(from, cur_len);
+
+			nr_pages = (cur_len + start + PAGE_SIZE - 1) / PAGE_SIZE;
+
+			wdata = cifs_writedata_direct_alloc(pagevec,
 					     cifs_uncached_writev_complete);
-		if (!wdata) {
-			rc = -ENOMEM;
-			add_credits_and_wake_if(server, credits, 0);
-			break;
-		}
+			if (!wdata) {
+				rc = -ENOMEM;
+				add_credits_and_wake_if(server, credits, 0);
+				break;
+			}
 
-		rc = cifs_write_allocate_pages(wdata->pages, nr_pages);
-		if (rc) {
-			kfree(wdata);
-			add_credits_and_wake_if(server, credits, 0);
-			break;
-		}
 
-		num_pages = nr_pages;
-		rc = wdata_fill_from_iovec(wdata, from, &cur_len, &num_pages);
-		if (rc) {
-			for (i = 0; i < nr_pages; i++)
-				put_page(wdata->pages[i]);
-			kfree(wdata);
-			add_credits_and_wake_if(server, credits, 0);
-			break;
-		}
+			wdata->page_offset = start;
+			wdata->tailsz =
+				nr_pages > 1 ?
+					cur_len - (PAGE_SIZE - start) -
+					(nr_pages - 2) * PAGE_SIZE :
+					cur_len;
+		} else {
+			nr_pages = get_numpages(wsize, len, &cur_len);
+			wdata = cifs_writedata_alloc(nr_pages,
+					     cifs_uncached_writev_complete);
+			if (!wdata) {
+				rc = -ENOMEM;
+				add_credits_and_wake_if(server, credits, 0);
+				break;
+			}
 
-		/*
-		 * Bring nr_pages down to the number of pages we actually used,
-		 * and free any pages that we didn't use.
-		 */
-		for ( ; nr_pages > num_pages; nr_pages--)
-			put_page(wdata->pages[nr_pages - 1]);
+			rc = cifs_write_allocate_pages(wdata->pages, nr_pages);
+			if (rc) {
+				kfree(wdata);
+				add_credits_and_wake_if(server, credits, 0);
+				break;
+			}
+
+			num_pages = nr_pages;
+			rc = wdata_fill_from_iovec(wdata, from, &cur_len, &num_pages);
+			if (rc) {
+				for (i = 0; i < nr_pages; i++)
+					put_page(wdata->pages[i]);
+				kfree(wdata);
+				add_credits_and_wake_if(server, credits, 0);
+				break;
+			}
+
+			/*
+			 * Bring nr_pages down to the number of pages we actually used,
+			 * and free any pages that we didn't use.
+			 */
+			for ( ; nr_pages > num_pages; nr_pages--)
+				put_page(wdata->pages[nr_pages - 1]);
+
+			wdata->tailsz = cur_len - ((nr_pages - 1) * PAGE_SIZE);
+		}
 
 		wdata->sync_mode = WB_SYNC_ALL;
 		wdata->nr_pages = nr_pages;
@@ -2593,7 +2680,6 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 		wdata->pid = pid;
 		wdata->bytes = cur_len;
 		wdata->pagesz = PAGE_SIZE;
-		wdata->tailsz = cur_len - ((nr_pages - 1) * PAGE_SIZE);
 		wdata->credits = credits;
 		wdata->ctx = ctx;
 		kref_get(&ctx->refcount);
@@ -2668,13 +2754,17 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 				INIT_LIST_HEAD(&tmp_list);
 				list_del_init(&wdata->list);
 
-				iov_iter_advance(&tmp_from,
+				if (ctx->direct_io)
+					rc = cifs_resend_wdata(wdata, &tmp_list, ctx);
+				else {
+					iov_iter_advance(&tmp_from,
 						 wdata->offset - ctx->pos);
 
-				rc = cifs_write_from_iter(wdata->offset,
+					rc = cifs_write_from_iter(wdata->offset,
 						wdata->bytes, &tmp_from,
 						ctx->cfile, cifs_sb, &tmp_list,
 						ctx);
+				}
 
 				list_splice(&tmp_list, &ctx->list);
 
@@ -2687,8 +2777,9 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 		kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 	}
 
-	for (i = 0; i < ctx->npages; i++)
-		put_page(ctx->bv[i].bv_page);
+	if (!ctx->direct_io)
+		for (i = 0; i < ctx->npages; i++)
+			put_page(ctx->bv[i].bv_page);
 
 	cifs_stats_bytes_written(tcon, ctx->total_len);
 	set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(dentry->d_inode)->flags);
@@ -2703,7 +2794,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 		complete(&ctx->done);
 }
 
-ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
+static ssize_t __cifs_writev(struct kiocb *iocb, struct iov_iter *from, bool direct)
 {
 	struct file *file = iocb->ki_filp;
 	ssize_t total_written = 0;
@@ -2712,13 +2803,18 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_aio_ctx *ctx;
 	struct iov_iter saved_from = *from;
+	size_t len = iov_iter_count(from);
 	int rc;
 
 	/*
-	 * BB - optimize the way when signing is disabled. We can drop this
-	 * extra memory-to-memory copying and use iovec buffers for constructing
-	 * write request.
+	 * iov_iter_get_pages_alloc doesn't work with ITER_KVEC.
+	 * In this case, fall back to non-direct write function.
+	 * this could be improved by getting pages directly in ITER_KVEC
 	 */
+	if (direct && from->type & ITER_KVEC) {
+		cifs_dbg(FYI, "use non-direct cifs_writev for kvec I/O\n");
+		direct = false;
+	}
 
 	rc = generic_write_checks(iocb, from);
 	if (rc <= 0)
@@ -2742,10 +2838,16 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
 
 	ctx->pos = iocb->ki_pos;
 
-	rc = setup_aio_ctx_iter(ctx, from, WRITE);
-	if (rc) {
-		kref_put(&ctx->refcount, cifs_aio_ctx_release);
-		return rc;
+	if (direct) {
+		ctx->direct_io = true;
+		ctx->iter = *from;
+		ctx->len = len;
+	} else {
+		rc = setup_aio_ctx_iter(ctx, from, WRITE);
+		if (rc) {
+			kref_put(&ctx->refcount, cifs_aio_ctx_release);
+			return rc;
+		}
 	}
 
 	/* grab a lock here due to read response handlers can access ctx */
@@ -2795,6 +2897,16 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
 	return total_written;
 }
 
+ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from)
+{
+	return __cifs_writev(iocb, from, true);
+}
+
+ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
+{
+	return __cifs_writev(iocb, from, false);
+}
+
 static ssize_t
 cifs_writev(struct kiocb *iocb, struct iov_iter *from)
 {
-- 
2.7.4
