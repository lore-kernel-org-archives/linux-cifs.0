Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA530C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jan 2022 17:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241753AbiAFR7O (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Jan 2022 12:59:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242189AbiAFR7N (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Jan 2022 12:59:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641491953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=soB8HyZR09O24F4dK1rwMmq3Irz+Ud+2SroS3H+/1Vc=;
        b=JXUfAQZz6P6RBIvymDoNkbrQiGKDnGOFD1vkUw9eLqesB9VPjq+m9twRsNtc47qSREXQ4S
        rsniss2nIzOEoQM+ENpEnjTsaaGQ+IZ5nKKxfLOttIJojzWnTDaRVuT1BvzYuk/WF84BFH
        tU/xPWrte4WGfskKlVfXlCvt70RW5H0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-Ftx1s-tHPqqeDukBSM88aQ-1; Thu, 06 Jan 2022 12:59:07 -0500
X-MC-Unique: Ftx1s-tHPqqeDukBSM88aQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEBC81083F61;
        Thu,  6 Jan 2022 17:59:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4B23838F7;
        Thu,  6 Jan 2022 17:58:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/3] cifs: Reverse the way iov_iters are used in reading
From:   David Howells <dhowells@redhat.com>
To:     smfrench@gmail.com
Cc:     nspmangalore@gmail.com, dhowells@redhat.com, jlayton@kernel.org,
        linux-cifs@vger.kernel.org, linux-cachefs@redhat.com
Date:   Thu, 06 Jan 2022 17:58:53 +0000
Message-ID: <164149193387.2867367.6974748727717146892.stgit@warthog.procyon.org.uk>
In-Reply-To: <164149189935.2867367.12096515579793121868.stgit@warthog.procyon.org.uk>
References: <164149189935.2867367.12096515579793121868.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reverse the way iov_iters are used in reading such that the top layer
passes down an iterator for data to be copied into inside
handle_read_data() and cifs_readv_receive().

Get rid of ->read_into_pages() and ->copy_into_pages() and have the callers
just write directly into the iterator instead.

Generalise setup_aio_ctx_iter() and move it to lib/iov_iter.c as
extract_iter_to_iter().  Other filesystems want to take the iterator passed
to ->read_iter() or ->write_iter() and copy the buffer list too.

Note that extract_iter_to_iter() doesn't actually need to make a separate
allocation for the page array.  It can place the page array at the end of
the bvec array storage, provided it traverses both arrays from the 0th
element forwards.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cifs/cifsglob.h  |    6 -
 fs/cifs/cifsproto.h |    1 
 fs/cifs/cifssmb.c   |   13 ++-
 fs/cifs/file.c      |  239 ++++-----------------------------------------------
 fs/cifs/misc.c      |   90 -------------------
 fs/cifs/smb2ops.c   |   54 ++++--------
 include/linux/uio.h |    3 +
 lib/iov_iter.c      |   94 ++++++++++++++++++++
 8 files changed, 146 insertions(+), 354 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a5edae959f60..c1665ef5b946 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1333,12 +1333,6 @@ struct cifs_readdata {
 	pid_t				pid;
 	int				result;
 	struct work_struct		work;
-	int (*read_into_pages)(struct TCP_Server_Info *server,
-				struct cifs_readdata *rdata,
-				unsigned int len);
-	int (*copy_into_pages)(struct TCP_Server_Info *server,
-				struct cifs_readdata *rdata,
-				struct iov_iter *iter);
 	struct iov_iter			iter;
 	struct kvec			iov[2];
 	struct TCP_Server_Info		*server;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 99c239dca807..9cfc160897e9 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -587,7 +587,6 @@ enum securityEnum cifs_select_sectype(struct TCP_Server_Info *,
 					enum securityEnum);
 struct cifs_aio_ctx *cifs_aio_ctx_alloc(void);
 void cifs_aio_ctx_release(struct kref *refcount);
-int setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw);
 void smb2_cached_lease_break(struct work_struct *work);
 
 int cifs_alloc_hash(const char *name, struct crypto_shash **shash,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e068e3bda304..96c901ed1524 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1484,10 +1484,15 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		return cifs_readv_discard(server, mid);
 	}
 
-	length = rdata->read_into_pages(server, rdata, data_len);
-	if (length < 0)
-		return length;
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	if (rdata->mr)
+		length = data_len; /* An RDMA read is already done. */
+	else
+#endif
+		length = cifs_read_iter_from_socket(server, &rdata->iter,
+						    data_len);
+	if (length > 0)
+		rdata->got_bytes += length;
 	server->total_read += length;
 
 	cifs_dbg(FYI, "total_read=%u buflen=%u remaining=%u\n",
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a3b9c0ecf02c..a12feb3ffdc4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3276,11 +3276,13 @@ static ssize_t __cifs_writev(
 		ctx->iter = *from;
 		ctx->len = len;
 	} else {
-		rc = setup_aio_ctx_iter(ctx, from, WRITE);
-		if (rc) {
+		rc = extract_iter_to_iter(from, &ctx->iter, &ctx->bv);
+		if (rc < 0) {
 			kref_put(&ctx->refcount, cifs_aio_ctx_release);
 			return rc;
 		}
+		ctx->npages = rc;
+		ctx->len = iov_iter_count(&ctx->iter);
 	}
 
 	/* grab a lock here due to read response handlers can access ctx */
@@ -3566,80 +3568,6 @@ cifs_uncached_readv_complete(struct work_struct *work)
 	kref_put(&rdata->refcount, cifs_uncached_readdata_release);
 }
 
-static int
-uncached_fill_pages(struct TCP_Server_Info *server,
-		    struct cifs_readdata *rdata, struct iov_iter *iter,
-		    unsigned int len)
-{
-	int result = 0;
-	unsigned int i;
-	unsigned int nr_pages = rdata->nr_pages;
-	unsigned int page_offset = rdata->page_offset;
-
-	rdata->got_bytes = 0;
-	rdata->tailsz = PAGE_SIZE;
-	for (i = 0; i < nr_pages; i++) {
-		struct page *page = rdata->pages[i];
-		size_t n;
-		unsigned int segment_size = rdata->pagesz;
-
-		if (i == 0)
-			segment_size -= page_offset;
-		else
-			page_offset = 0;
-
-
-		if (len <= 0) {
-			/* no need to hold page hostage */
-			rdata->pages[i] = NULL;
-			rdata->nr_pages--;
-			put_page(page);
-			continue;
-		}
-
-		n = len;
-		if (len >= segment_size)
-			/* enough data to fill the page */
-			n = segment_size;
-		else
-			rdata->tailsz = len;
-		len -= n;
-
-		if (iter)
-			result = copy_page_from_iter(
-					page, page_offset, n, iter);
-#ifdef CONFIG_CIFS_SMB_DIRECT
-		else if (rdata->mr)
-			result = n;
-#endif
-		else
-			result = cifs_read_page_from_socket(
-					server, page, page_offset, n);
-		if (result < 0)
-			break;
-
-		rdata->got_bytes += result;
-	}
-
-	return rdata->got_bytes > 0 && result != -ECONNABORTED ?
-						rdata->got_bytes : result;
-}
-
-static int
-cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
-			      struct cifs_readdata *rdata, unsigned int len)
-{
-	return uncached_fill_pages(server, rdata, NULL, len);
-}
-
-static int
-cifs_uncached_copy_into_pages(struct TCP_Server_Info *server,
-			      struct cifs_readdata *rdata,
-			      struct iov_iter *iter)
-{
-	return uncached_fill_pages(server, rdata, iter, iter->count);
-}
-
 static int cifs_resend_rdata(struct cifs_readdata *rdata,
 			struct list_head *rdata_list,
 			struct cifs_aio_ctx *ctx)
@@ -3725,7 +3653,6 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 	int rc;
 	pid_t pid;
 	struct TCP_Server_Info *server;
-	struct page **pagevec;
 	size_t start;
 	struct iov_iter direct_iov = ctx->iter;
 
@@ -3756,23 +3683,6 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 		cur_len = min_t(const size_t, len, rsize);
 
 		if (ctx->direct_io) {
-			ssize_t result;
-
-			result = iov_iter_get_pages_alloc(
-					&direct_iov, &pagevec,
-					cur_len, &start);
-			if (result < 0) {
-				cifs_dbg(VFS,
-					 "Couldn't get user pages (rc=%zd) iter type %d iov_offset %zd count %zd\n",
-					 result, iov_iter_type(&direct_iov),
-					 direct_iov.iov_offset,
-					 direct_iov.count);
-				dump_stack();
-
-				rc = result;
-				add_credits_and_wake_if(server, credits, 0);
-				break;
-			}
 			cur_len = (size_t)result;
 			iov_iter_advance(&direct_iov, cur_len);
 
@@ -3815,15 +3725,14 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 
 		rdata->server = server;
 		rdata->cfile = cifsFileInfo_get(open_file);
-		rdata->nr_pages = npages;
+		rdata->nr_pages = ctx->npages;
 		rdata->offset = offset;
 		rdata->bytes = cur_len;
 		rdata->pid = pid;
 		rdata->pagesz = PAGE_SIZE;
-		rdata->read_into_pages = cifs_uncached_read_into_pages;
-		rdata->copy_into_pages = cifs_uncached_copy_into_pages;
 		rdata->credits = credits_on_stack;
 		rdata->ctx = ctx;
+		rdata->iter = ctx->iter;
 		kref_get(&ctx->refcount);
 
 		rc = adjust_credits(server, &rdata->credits, rdata->bytes);
@@ -4013,11 +3922,13 @@ static ssize_t __cifs_readv(
 		ctx->iter = *to;
 		ctx->len = len;
 	} else {
-		rc = setup_aio_ctx_iter(ctx, to, READ);
-		if (rc) {
+		rc = extract_iter_to_iter(to, &ctx->iter, &ctx->bv);
+		if (rc < 0) {
 			kref_put(&ctx->refcount, cifs_aio_ctx_release);
 			return rc;
 		}
+		ctx->npages = rc;
+		ctx->len = iov_iter_count(&ctx->iter);
 		len = ctx->len;
 	}
 
@@ -4180,112 +4091,6 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return rc;
 }
 
-static int
-readpages_fill_pages(struct TCP_Server_Info *server,
-		     struct cifs_readdata *rdata, struct iov_iter *iter,
-		     unsigned int len)
-{
-	int result = 0;
-	unsigned int i;
-	u64 eof;
-	pgoff_t eof_index;
-	unsigned int nr_pages = rdata->nr_pages;
-	unsigned int page_offset = rdata->page_offset;
-
-	/* determine the eof that the server (probably) has */
-	eof = CIFS_I(rdata->mapping->host)->server_eof;
-	eof_index = eof ? (eof - 1) >> PAGE_SHIFT : 0;
-	cifs_dbg(FYI, "eof=%llu eof_index=%lu\n", eof, eof_index);
-
-	rdata->got_bytes = 0;
-	rdata->tailsz = PAGE_SIZE;
-	for (i = 0; i < nr_pages; i++) {
-		struct page *page = rdata->pages[i];
-		unsigned int to_read = rdata->pagesz;
-		size_t n;
-
-		if (i == 0)
-			to_read -= page_offset;
-		else
-			page_offset = 0;
-
-		n = to_read;
-
-		if (len >= to_read) {
-			len -= to_read;
-		} else if (len > 0) {
-			/* enough for partial page, fill and zero the rest */
-			zero_user(page, len + page_offset, to_read - len);
-			n = rdata->tailsz = len;
-			len = 0;
-		} else if (page->index > eof_index) {
-			/*
-			 * The VFS will not try to do readahead past the
-			 * i_size, but it's possible that we have outstanding
-			 * writes with gaps in the middle and the i_size hasn't
-			 * caught up yet. Populate those with zeroed out pages
-			 * to prevent the VFS from repeatedly attempting to
-			 * fill them until the writes are flushed.
-			 */
-			zero_user(page, 0, PAGE_SIZE);
-			lru_cache_add(page);
-			flush_dcache_page(page);
-			SetPageUptodate(page);
-			unlock_page(page);
-			put_page(page);
-			rdata->pages[i] = NULL;
-			rdata->nr_pages--;
-			continue;
-		} else {
-			/* no need to hold page hostage */
-			lru_cache_add(page);
-			unlock_page(page);
-			put_page(page);
-			rdata->pages[i] = NULL;
-			rdata->nr_pages--;
-			continue;
-		}
-
-		if (iter)
-			result = copy_page_from_iter(
-					page, page_offset, n, iter);
-#ifdef CONFIG_CIFS_SMB_DIRECT
-		else if (rdata->mr)
-			result = n;
-#endif
-		else
-			result = cifs_read_iter_from_socket(server, &rdata->iter, n);
-		if (result < 0)
-			break;
-
-		rdata->got_bytes += result;
-	}
-
-	return rdata->got_bytes > 0 && result != -ECONNABORTED ?
-						rdata->got_bytes : result;
-}
-
-static int
-cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
-			       struct cifs_readdata *rdata, unsigned int len)
-{
-	int rc;
-
-	rc = cifs_read_iter_from_socket(server, &rdata->iter, len);
-	if (rc > 0)
-		rdata->got_bytes += rc;
-	return rc;
-}
-
-static int
-cifs_readpages_copy_into_pages(struct TCP_Server_Info *server,
-			       struct cifs_readdata *rdata,
-			       struct iov_iter *iter)
-{
-	printk("cifs_readpages_copy_into_pages\n");
-	return readpages_fill_pages(server, rdata, iter, iter->count);
-}
-
 /*
  * Issue a read operation on behalf of the netfs helper functions.  We're asked
  * to make a read of a certain size at a point in the file.  We are permitted
@@ -4337,18 +4142,16 @@ static void cifs_req_issue_op(struct netfs_read_subrequest *subreq)
 		goto out;
 	}
 
-	rdata->subreq = subreq;
-	rdata->cfile = cifsFileInfo_get(open_file);
-	rdata->server = server;
-	rdata->mapping = rreq->mapping;
-	rdata->offset = subreq->start + subreq->transferred;
-	rdata->bytes = subreq->len   - subreq->transferred;
-	rdata->pid = pid;
-	rdata->pagesz = PAGE_SIZE;
-	rdata->tailsz = PAGE_SIZE;
-	rdata->read_into_pages = cifs_readpages_read_into_pages;
-	rdata->copy_into_pages = cifs_readpages_copy_into_pages;
-	rdata->credits = credits_on_stack;
+	rdata->subreq	= subreq;
+	rdata->cfile	= cifsFileInfo_get(open_file);
+	rdata->server	= server;
+	rdata->mapping	= rreq->mapping;
+	rdata->offset	= subreq->start + subreq->transferred;
+	rdata->bytes	= subreq->len   - subreq->transferred;
+	rdata->pid	= pid;
+	rdata->pagesz	= PAGE_SIZE;
+	rdata->tailsz	= PAGE_SIZE;
+	rdata->credits	= credits_on_stack;
 
 	iov_iter_xarray(&rdata->iter, READ, &rreq->mapping->i_pages,
 			rdata->offset, rdata->bytes);
@@ -4652,7 +4455,7 @@ void cifs_oplock_break(struct work_struct *work)
  * In the non-cached mode (mount with cache=none), we shunt off direct read and write requests
  * so this method should never be called.
  *
- * Direct IO is not yet supported in the cached mode. 
+ * Direct IO is not yet supported in the cached mode.
  */
 static ssize_t
 cifs_direct_io(struct kiocb *iocb, struct iov_iter *iter)
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 5148d48d6a35..ece7fc8a7740 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -974,96 +974,6 @@ cifs_aio_ctx_release(struct kref *refcount)
 	kfree(ctx);
 }
 
-#define CIFS_AIO_KMALLOC_LIMIT (1024 * 1024)
-
-int
-setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw)
-{
-	ssize_t rc;
-	unsigned int cur_npages;
-	unsigned int npages = 0;
-	unsigned int i;
-	size_t len;
-	size_t count = iov_iter_count(iter);
-	unsigned int saved_len;
-	size_t start;
-	unsigned int max_pages = iov_iter_npages(iter, INT_MAX);
-	struct page **pages = NULL;
-	struct bio_vec *bv = NULL;
-
-	if (iov_iter_is_kvec(iter)) {
-		memcpy(&ctx->iter, iter, sizeof(*iter));
-		ctx->len = count;
-		iov_iter_advance(iter, count);
-		return 0;
-	}
-
-	if (array_size(max_pages, sizeof(*bv)) <= CIFS_AIO_KMALLOC_LIMIT)
-		bv = kmalloc_array(max_pages, sizeof(*bv), GFP_KERNEL);
-
-	if (!bv) {
-		bv = vmalloc(array_size(max_pages, sizeof(*bv)));
-		if (!bv)
-			return -ENOMEM;
-	}
-
-	if (array_size(max_pages, sizeof(*pages)) <= CIFS_AIO_KMALLOC_LIMIT)
-		pages = kmalloc_array(max_pages, sizeof(*pages), GFP_KERNEL);
-
-	if (!pages) {
-		pages = vmalloc(array_size(max_pages, sizeof(*pages)));
-		if (!pages) {
-			kvfree(bv);
-			return -ENOMEM;
-		}
-	}
-
-	saved_len = count;
-
-	while (count && npages < max_pages) {
-		rc = iov_iter_get_pages(iter, pages, count, max_pages, &start);
-		if (rc < 0) {
-			cifs_dbg(VFS, "Couldn't get user pages (rc=%zd)\n", rc);
-			break;
-		}
-
-		if (rc > count) {
-			cifs_dbg(VFS, "get pages rc=%zd more than %zu\n", rc,
-				 count);
-			break;
-		}
-
-		iov_iter_advance(iter, rc);
-		count -= rc;
-		rc += start;
-		cur_npages = DIV_ROUND_UP(rc, PAGE_SIZE);
-
-		if (npages + cur_npages > max_pages) {
-			cifs_dbg(VFS, "out of vec array capacity (%u vs %u)\n",
-				 npages + cur_npages, max_pages);
-			break;
-		}
-
-		for (i = 0; i < cur_npages; i++) {
-			len = rc > PAGE_SIZE ? PAGE_SIZE : rc;
-			bv[npages + i].bv_page = pages[i];
-			bv[npages + i].bv_offset = start;
-			bv[npages + i].bv_len = len - start;
-			rc -= len;
-			start = 0;
-		}
-
-		npages += cur_npages;
-	}
-
-	kvfree(pages);
-	ctx->bv = bv;
-	ctx->len = saved_len - count;
-	ctx->npages = npages;
-	iov_iter_bvec(&ctx->iter, rw, ctx->bv, npages, ctx->len);
-	return 0;
-}
-
 /**
  * cifs_alloc_hash - allocate hash and hash context together
  * @name: The name of the crypto hash algo
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c5b1dea54ebc..a5ce04331613 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4754,30 +4754,24 @@ read_data_into_pages(struct TCP_Server_Info *server, struct page **pages,
 }
 
 static int
-init_read_bvec(struct page **pages, unsigned int npages, unsigned int data_size,
-	       unsigned int cur_off, struct bio_vec **page_vec)
+cifs_copy_pages_to_iter(struct page **pages, unsigned int npages, unsigned int data_size,
+			unsigned int cur_off, struct iov_iter *iter)
 {
-	struct bio_vec *bvec;
-	int i;
-
-	bvec = kcalloc(npages, sizeof(struct bio_vec), GFP_KERNEL);
-	if (!bvec)
-		return -ENOMEM;
+	unsigned int i;
 
 	for (i = 0; i < npages; i++) {
-		bvec[i].bv_page = pages[i];
-		bvec[i].bv_offset = (i == 0) ? cur_off : 0;
-		bvec[i].bv_len = min_t(unsigned int, PAGE_SIZE, data_size);
-		data_size -= bvec[i].bv_len;
-	}
-
-	if (data_size != 0) {
-		cifs_dbg(VFS, "%s: something went wrong\n", __func__);
-		kfree(bvec);
-		return -EIO;
+		size_t n, len = min_t(unsigned int, PAGE_SIZE, data_size);
+
+		n = copy_page_to_iter(pages[i],
+				      (i == 0) ? cur_off : 0,
+				      len, iter);
+		if (n != len) {
+			cifs_dbg(VFS, "%s: something went wrong\n", __func__);
+			return -EIO;
+		}
+		data_size -= n;
 	}
 
-	*page_vec = bvec;
 	return 0;
 }
 
@@ -4794,9 +4788,6 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	unsigned int pad_len;
 	struct cifs_readdata *rdata = mid->callback_data;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-	struct bio_vec *bvec = NULL;
-	struct iov_iter iter;
-	struct kvec iov;
 	int length;
 	bool use_rdma_mr = false;
 
@@ -4895,8 +4886,9 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			return 0;
 		}
 
-		rdata->result = init_read_bvec(pages, npages, page_data_size,
-					       cur_off, &bvec);
+		/* Copy the data to the output I/O iterator. */
+		rdata->result = cifs_copy_pages_to_iter(pages, npages, page_data_size,
+							cur_off, &rdata->iter);
 		if (rdata->result != 0) {
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
@@ -4905,13 +4897,12 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			return 0;
 		}
 
-		iov_iter_bvec(&iter, WRITE, bvec, npages, data_len);
 	} else if (buf_len >= data_offset + data_len) {
 		/* read response payload is in buf */
 		WARN_ONCE(npages > 0, "read data can be either in buf or in pages");
-		iov.iov_base = buf + data_offset;
-		iov.iov_len = data_len;
-		iov_iter_kvec(&iter, WRITE, &iov, 1, data_len);
+		length = copy_to_iter(buf + data_offset, data_len, &rdata->iter);
+		if (length < 0)
+			return length;
 	} else {
 		/* read response payload cannot be in both buf and pages */
 		WARN_ONCE(1, "buf can not contain only a part of read data");
@@ -4923,13 +4914,6 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		return 0;
 	}
 
-	length = rdata->copy_into_pages(server, rdata, &iter);
-
-	kfree(bvec);
-
-	if (length < 0)
-		return length;
-
 	if (is_offloaded)
 		mid->mid_state = MID_RESPONSE_RECEIVED;
 	else
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 6350354f97e9..931528bc2eab 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -247,6 +247,9 @@ ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
 			size_t maxsize, unsigned maxpages, size_t *start);
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
+ssize_t extract_iter_to_iter(struct iov_iter *orig,
+			     struct iov_iter *new,
+			     struct bio_vec **_bv);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
 void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state);
 
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 66a740e6e153..cebfdb617fd8 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1696,6 +1696,100 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 }
 EXPORT_SYMBOL(iov_iter_get_pages_alloc);
 
+/**
+ * extract_iter_to_iter - Extract the pages from one iterator into another
+ * @orig: The original iterator
+ * @new: The iterator to be set up
+ * @_bv: Where to store the allocated bvec table pointer, if allocated
+ *
+ * Extract the page fragments from an iterator and build up a second iterator
+ * that refers to all of those bits so that the original iterator can be
+ * disposed of.
+ *
+ * If a bvec array is created, the number of pages in the array is returned and
+ * a pointer to the array is saved into *@_bv;
+ */
+ssize_t extract_iter_to_iter(struct iov_iter *orig,
+			     struct iov_iter *new,
+			     struct bio_vec **_bv)
+{
+	struct bio_vec *bv = NULL;
+	struct page **pages;
+	unsigned int cur_npages;
+	unsigned int max_pages = iov_iter_npages(orig, INT_MAX);
+	unsigned int saved_len;
+	unsigned int npages = 0;
+	unsigned int i;
+	ssize_t ret;
+	size_t bv_size, pg_size;
+	size_t count = iov_iter_count(orig);
+	size_t start;
+	size_t len;
+
+	*_bv = NULL;
+
+	if (iov_iter_is_kvec(orig) || iov_iter_is_discard(orig)) {
+		memcpy(new, orig, sizeof(*new));
+		iov_iter_advance(orig, count);
+		return 0;
+	}
+
+	bv_size = array_size(max_pages, sizeof(*bv));
+	bv = kvmalloc(bv_size, GFP_KERNEL);
+	if (!bv)
+		return -ENOMEM;
+
+	/* Put the page list at the end of the bvec list storage.  bvec
+	 * elements are larger than page pointers, so as long as we work
+	 * 0->last, we should be fine.
+	 */
+	pg_size = array_size(max_pages, sizeof(*pages));
+	pages = (void *)bv + bv_size - pg_size;
+
+	saved_len = count;
+
+	while (count && npages < max_pages) {
+		ret = iov_iter_get_pages(orig, pages, count, max_pages - npages,
+					 &start);
+		if (ret < 0) {
+			pr_err("Couldn't get user pages (rc=%zd)\n", ret);
+			break;
+		}
+
+		if (ret > count) {
+			pr_err("get_pages rc=%zd more than %zu\n", ret, count);
+			break;
+		}
+
+		iov_iter_advance(orig, ret);
+		count -= ret;
+		ret += start;
+		cur_npages = DIV_ROUND_UP(ret, PAGE_SIZE);
+
+		if (npages + cur_npages > max_pages) {
+			pr_err("Out of bvec array capacity (%u vs %u)\n",
+			       npages + cur_npages, max_pages);
+			break;
+		}
+
+		for (i = 0; i < cur_npages; i++) {
+			len = ret > PAGE_SIZE ? PAGE_SIZE : ret;
+			bv[npages + i].bv_page	 = *pages++;
+			bv[npages + i].bv_offset = start;
+			bv[npages + i].bv_len	 = len - start;
+			ret -= len;
+			start = 0;
+		}
+
+		npages += cur_npages;
+	}
+
+	*_bv = bv;
+	iov_iter_bvec(new, iov_iter_rw(orig), bv, npages, saved_len - count);
+	return npages;
+}
+EXPORT_SYMBOL(extract_iter_to_iter);
+
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
 			       struct iov_iter *i)
 {


