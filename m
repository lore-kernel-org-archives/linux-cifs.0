From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/7] cifs: convert cifs_writepages to use async writes
Date: Thu, 19 May 2011 16:22:57 -0400
Message-ID: <1305836578-26333-7-git-send-email-jlayton@redhat.com>
References: <1305836578-26333-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305836578-26333-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have cifs_writepages issue asynchronous writes instead of waiting on
each write call to complete before issuing another. This also allows us
to return more quickly from writepages. It can just send out all of the
I/Os and not wait around for the replies.

In the WB_SYNC_ALL case, if the write completes with a retryable error,
then the completion workqueue job will resend the write.

This also changes the page locking semantics a little bit. Instead of
holding the page lock until the response is received, release it after
doing the send. This will reduce contention for the page lock and should
prevent processes that have the file mmap'ed from being blocked
unnecessarily.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |  241 +++++++++++++++++++++++---------------------------------
 1 files changed, 99 insertions(+), 142 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0aeaaf7..b81bbd8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1092,58 +1092,20 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 static int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
-	unsigned int bytes_to_write;
-	unsigned int bytes_written;
-	struct cifs_sb_info *cifs_sb;
-	int done = 0;
-	pgoff_t end;
-	pgoff_t index;
-	int range_whole = 0;
-	struct kvec *iov;
-	int len;
-	int n_iov = 0;
-	pgoff_t next;
-	int nr_pages;
-	__u64 offset = 0;
-	struct cifsFileInfo *open_file;
-	struct cifsTconInfo *tcon;
-	struct cifsInodeInfo *cifsi = CIFS_I(mapping->host);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(mapping->host->i_sb);
+	bool done = false, scanned = false, range_whole = false;
+	pgoff_t end, index;
+	struct cifs_writedata *wdata;
 	struct page *page;
-	struct pagevec pvec;
 	int rc = 0;
-	int scanned = 0;
-	int xid;
-
-	cifs_sb = CIFS_SB(mapping->host->i_sb);
 
 	/*
-	 * If wsize is smaller that the page cache size, default to writing
+	 * If wsize is smaller than the page cache size, default to writing
 	 * one page at a time via cifs_writepage
 	 */
 	if (cifs_sb->wsize < PAGE_CACHE_SIZE)
 		return generic_writepages(mapping, wbc);
 
-	iov = kmalloc(32 * sizeof(struct kvec), GFP_KERNEL);
-	if (iov == NULL)
-		return generic_writepages(mapping, wbc);
-
-	/*
-	 * if there's no open file, then this is likely to fail too,
-	 * but it'll at least handle the return. Maybe it should be
-	 * a BUG() instead?
-	 */
-	open_file = find_writable_file(CIFS_I(mapping->host), false);
-	if (!open_file) {
-		kfree(iov);
-		return generic_writepages(mapping, wbc);
-	}
-
-	tcon = tlink_tcon(open_file->tlink);
-	cifsFileInfo_put(open_file);
-
-	xid = GetXid();
-
-	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
@@ -1151,24 +1113,49 @@ static int cifs_writepages(struct address_space *mapping,
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-			range_whole = 1;
-		scanned = 1;
+			range_whole = true;
+		scanned = true;
 	}
 retry:
-	while (!done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-			PAGECACHE_TAG_DIRTY,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1))) {
-		int first;
-		unsigned int i;
-
-		first = -1;
-		next = 0;
-		n_iov = 0;
-		bytes_to_write = 0;
-
-		for (i = 0; i < nr_pages; i++) {
-			page = pvec.pages[i];
+	while (!done && index <= end) {
+		unsigned int i, nr_pages, found_pages;
+		pgoff_t next = 0, tofind;
+		struct page **pages;
+
+		tofind = min((cifs_sb->wsize / PAGE_CACHE_SIZE) - 1,
+				end - index) + 1;
+
+		wdata = cifs_writedata_alloc((unsigned int)tofind);
+		if (!wdata) {
+			rc = -ENOMEM;
+			break;
+		}
+
+		/*
+		 * find_get_pages_tag seems to return a max of 256 on each
+		 * iteration, so we must call it several times in order to
+		 * fill the array or the wsize is effectively limited to
+		 * 256 * PAGE_CACHE_SIZE.
+		 */
+		found_pages = 0;
+		pages = wdata->pages;
+		do {
+			nr_pages = find_get_pages_tag(mapping, &index,
+							PAGECACHE_TAG_DIRTY,
+							tofind, pages);
+			found_pages += nr_pages;
+			tofind -= nr_pages;
+			pages += nr_pages;
+		} while (nr_pages && tofind && index <= end);
+
+		if (found_pages == 0) {
+			kref_put(&wdata->refcount, cifs_writedata_release);
+			break;
+		}
+
+		nr_pages = 0;
+		for (i = 0; i < found_pages; i++) {
+			page = wdata->pages[i];
 			/*
 			 * At this point we hold neither mapping->tree_lock nor
 			 * lock on the page itself: the page may be truncated or
@@ -1177,7 +1164,7 @@ retry:
 			 * mapping
 			 */
 
-			if (first < 0)
+			if (nr_pages == 0)
 				lock_page(page);
 			else if (!trylock_page(page))
 				break;
@@ -1188,7 +1175,7 @@ retry:
 			}
 
 			if (!wbc->range_cyclic && page->index > end) {
-				done = 1;
+				done = true;
 				unlock_page(page);
 				break;
 			}
@@ -1215,119 +1202,89 @@ retry:
 			set_page_writeback(page);
 
 			if (page_offset(page) >= mapping->host->i_size) {
-				done = 1;
+				done = true;
 				unlock_page(page);
 				end_page_writeback(page);
 				break;
 			}
 
-			/*
-			 * BB can we get rid of this?  pages are held by pvec
-			 */
-			page_cache_get(page);
+			wdata->pages[i] = page;
+			next = page->index + 1;
+			++nr_pages;
+		}
 
-			len = min(mapping->host->i_size - page_offset(page),
-				  (loff_t)PAGE_CACHE_SIZE);
+		/* reset index to refind any pages skipped */
+		if (nr_pages == 0)
+			index = wdata->pages[0]->index + 1;
 
-			/* reserve iov[0] for the smb header */
-			n_iov++;
-			iov[n_iov].iov_base = kmap(page);
-			iov[n_iov].iov_len = len;
-			bytes_to_write += len;
+		/* put any pages we aren't going to use */
+		for (i = nr_pages; i < found_pages; i++) {
+			page_cache_release(wdata->pages[i]);
+			wdata->pages[i] = NULL;
+		}
 
-			if (first < 0) {
-				first = i;
-				offset = page_offset(page);
-			}
-			next = page->index + 1;
-			if (bytes_to_write + PAGE_CACHE_SIZE > cifs_sb->wsize)
-				break;
+		/* nothing to write? */
+		if (nr_pages == 0) {
+			kref_put(&wdata->refcount, cifs_writedata_release);
+			continue;
 		}
-		if (n_iov) {
-retry_write:
-			open_file = find_writable_file(CIFS_I(mapping->host),
-							false);
-			if (!open_file) {
-				cERROR(1, "No writable handles for inode");
-				rc = -EBADF;
-			} else {
-				rc = CIFSSMBWrite2(xid, tcon, open_file->netfid,
-						   bytes_to_write, offset,
-						   &bytes_written, iov, n_iov,
-						   0);
-				cifsFileInfo_put(open_file);
-			}
 
-			cFYI(1, "Write2 rc=%d, wrote=%u", rc, bytes_written);
+		wdata->sync_mode = wbc->sync_mode;
+		wdata->nr_pages = nr_pages;
+		wdata->offset = page_offset(wdata->pages[0]);
 
-			/*
-			 * For now, treat a short write as if nothing got
-			 * written. A zero length write however indicates
-			 * ENOSPC or EFBIG. We have no way to know which
-			 * though, so call it ENOSPC for now. EFBIG would
-			 * get translated to AS_EIO anyway.
-			 *
-			 * FIXME: make it take into account the data that did
-			 *	  get written
-			 */
-			if (rc == 0) {
-				if (bytes_written == 0)
-					rc = -ENOSPC;
-				else if (bytes_written < bytes_to_write)
-					rc = -EAGAIN;
+		do {
+			if (wdata->cfile != NULL)
+				cifsFileInfo_put(wdata->cfile);
+			wdata->cfile = find_writable_file(CIFS_I(mapping->host),
+							  false);
+			if (!wdata->cfile) {
+				cERROR(1, "No writable handles for inode");
+				rc = -EBADF;
+				break;
 			}
+			rc = cifs_async_writev(wdata);
+		} while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
 
-			/* retry on data-integrity flush */
-			if (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN)
-				goto retry_write;
+		for (i = 0; i < nr_pages; ++i)
+			unlock_page(wdata->pages[i]);
 
-			/* fix the stats and EOF */
-			if (bytes_written > 0) {
-				cifs_stats_bytes_written(tcon, bytes_written);
-				cifs_update_eof(cifsi, offset, bytes_written);
-			}
-
-			for (i = 0; i < n_iov; i++) {
-				page = pvec.pages[first + i];
-				/* on retryable write error, redirty page */
+		/* send failure -- clean up the mess */
+		if (rc != 0) {
+			for (i = 0; i < nr_pages; ++i) {
 				if (rc == -EAGAIN)
-					redirty_page_for_writepage(wbc, page);
-				else if (rc != 0)
-					SetPageError(page);
-				kunmap(page);
-				unlock_page(page);
-				end_page_writeback(page);
-				page_cache_release(page);
+					redirty_page_for_writepage(wbc,
+							   wdata->pages[i]);
+				else
+					SetPageError(wdata->pages[i]);
+				end_page_writeback(wdata->pages[i]);
+				page_cache_release(wdata->pages[i]);
 			}
-
 			if (rc != -EAGAIN)
 				mapping_set_error(mapping, rc);
-			else
-				rc = 0;
+		}
+		kref_put(&wdata->refcount, cifs_writedata_release);
 
-			if ((wbc->nr_to_write -= n_iov) <= 0)
-				done = 1;
-			index = next;
-		} else
-			/* Need to re-find the pages we skipped */
-			index = pvec.pages[0]->index + 1;
+		wbc->nr_to_write -= nr_pages;
+		if (wbc->nr_to_write <= 0)
+			done = true;
 
-		pagevec_release(&pvec);
+		index = next;
 	}
+
 	if (!scanned && !done) {
 		/*
 		 * We hit the last page and there is more work to be done: wrap
 		 * back to the start of the file
 		 */
-		scanned = 1;
+		scanned = true;
 		index = 0;
 		goto retry;
 	}
+
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 
-	FreeXid(xid);
-	kfree(iov);
 	return rc;
 }
 
-- 
1.7.4.4
