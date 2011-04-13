From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/7] cifs: convert cifs_writepages to use async writes
Date: Wed, 13 Apr 2011 07:43:13 -0400
Message-ID: <1302694994-8303-7-git-send-email-jlayton@redhat.com>
References: <1302694994-8303-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302694994-8303-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have cifs_writepages issue asynchronous writes instead of waiting on
each write call to complete before issuing another. This also allows us
to return more quickly from writepages in the WB_SYNC_NONE case. It
can just send out all of the I/Os and not wait around for the replies.

In the WB_SYNC_ALL case, have it wait for all of the writes to complete
after issuing them and return any errors that turn up from it. If those
errors turn out to all be retryable (-EAGAIN), then retry the entire
operation again.

This also changes the page locking semantics a little bit. Instead of
holding the page lock until the response is received, release it after
doing the send. This will reduce contention for the page lock and should
prevent processes that have the file mmap'ed from being blocked
unnecessarily.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |  292 +++++++++++++++++++++++++++++---------------------------
 1 files changed, 152 insertions(+), 140 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b3d2e3f..7ff138f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1089,32 +1089,65 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	return rc;
 }
 
+/*
+ * walk a list of in progress async writes and wait for them to complete.
+ * Check the result code on each one.
+ *
+ * There's a clear heirarchy: 0 < EAGAIN < other errors
+ *
+ * If we get an EAGAIN return on a WB_SYNC_ALL writeout, then we need to
+ * go back and do the whole operation again. If we get other errors then
+ * the mapping already likely has AS_EIO or AS_ENOSPC set, so we can
+ * give up and just return an error.
+ */
+static int
+cifs_wait_for_write_completion(struct address_space *mapping,
+				struct list_head *pending)
+{
+	int tmprc, rc = 0;
+	struct cifs_writedata *wdata;
+
+	/* wait for writes to complete */
+	for (;;) {
+		/* anything left on list? */
+		spin_lock(&mapping->private_lock);
+		if (list_empty(pending)) {
+			spin_unlock(&mapping->private_lock);
+			break;
+		}
+
+		/* dequeue an entry */
+		wdata = list_first_entry(pending, struct cifs_writedata,
+					 pending);
+		list_del_init(&wdata->pending);
+		spin_unlock(&mapping->private_lock);
+
+		/* wait for it to complete */
+		tmprc = wait_for_completion_killable(&wdata->completion);
+		if (tmprc)
+			rc = tmprc;
+
+		if (wdata->result == -EAGAIN)
+			rc = rc ? rc : wdata->result;
+		else if (wdata->result != 0)
+			rc = wdata->result;
+
+		kref_put(&wdata->refcount, cifs_writedata_release);
+	}
+
+	return rc;
+}
+
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
-	struct cifs_tcon *tcon;
-	struct cifsInodeInfo *cifsi = CIFS_I(mapping->host);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(mapping->host->i_sb);
+	bool done = false, scanned = false, range_whole = false;
+	pgoff_t end, index;
+	struct cifs_writedata *wdata;
 	struct page *page;
-	struct pagevec pvec;
+	struct list_head pending;
 	int rc = 0;
-	int scanned = 0;
-	int xid;
-
-	cifs_sb = CIFS_SB(mapping->host->i_sb);
 
 	/*
 	 * If wsize is smaller that the page cache size, default to writing
@@ -1123,27 +1156,8 @@ static int cifs_writepages(struct address_space *mapping,
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
+	INIT_LIST_HEAD(&pending);
 
-	xid = GetXid();
-
-	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
@@ -1151,24 +1165,34 @@ static int cifs_writepages(struct address_space *mapping,
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
+		found_pages = find_get_pages_tag(mapping, &index,
+						 PAGECACHE_TAG_DIRTY,
+						 tofind, wdata->pages);
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
@@ -1177,7 +1201,7 @@ retry:
 			 * mapping
 			 */
 
-			if (first < 0)
+			if (nr_pages == 0)
 				lock_page(page);
 			else if (!trylock_page(page))
 				break;
@@ -1188,7 +1212,7 @@ retry:
 			}
 
 			if (!wbc->range_cyclic && page->index > end) {
-				done = 1;
+				done = true;
 				unlock_page(page);
 				break;
 			}
@@ -1215,119 +1239,107 @@ retry:
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
+
+		wdata->nr_pages = nr_pages;
+		wdata->offset = page_offset(wdata->pages[0]);
+
+		do {
+			if (wdata->cfile != NULL)
+				cifsFileInfo_put(wdata->cfile);
+			wdata->cfile = find_writable_file(CIFS_I(mapping->host),
+							  false);
+			if (!wdata->cfile) {
 				cERROR(1, "No writable handles for inode");
 				rc = -EBADF;
-			} else {
-				rc = CIFSSMBWrite2(xid, tcon, open_file->netfid,
-						   bytes_to_write, offset,
-						   &bytes_written, iov, n_iov,
-						   0);
-				cifsFileInfo_put(open_file);
+				break;
 			}
-
-			cFYI(1, "Write2 rc=%d, wrote=%u", rc, bytes_written);
-
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
+			if (wbc->sync_mode == WB_SYNC_ALL) {
+				spin_lock(&mapping->private_lock);
+				list_move(&wdata->pending, &pending);
+				spin_unlock(&mapping->private_lock);
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
-
-			if ((wbc->nr_to_write -= n_iov) <= 0)
-				done = 1;
-			index = next;
-		} else
-			/* Need to re-find the pages we skipped */
-			index = pvec.pages[0]->index + 1;
+			kref_put(&wdata->refcount, cifs_writedata_release);
+		} else if (wbc->sync_mode == WB_SYNC_NONE) {
+			kref_put(&wdata->refcount, cifs_writedata_release);
+		}
 
-		pagevec_release(&pvec);
+		if ((wbc->nr_to_write -= nr_pages) <= 0)
+			done = true;
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
+	/*
+	 * for WB_SYNC_ALL, we must wait until the writes complete. If any
+	 * return -EAGAIN however, we need to retry the whole thing again.
+	 * At that point nr_to_write will be all screwed up, but that
+	 * shouldn't really matter for WB_SYNC_ALL (right?)
+	 */
+	if (wbc->sync_mode == WB_SYNC_ALL) {
+		rc = cifs_wait_for_write_completion(mapping, &pending);
+		if (rc == -EAGAIN) {
+			index = wbc->range_start >> PAGE_CACHE_SHIFT;
+			goto retry;
+		}
+	}
+
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 
-	FreeXid(xid);
-	kfree(iov);
 	return rc;
 }
 
-- 
1.7.4.2
