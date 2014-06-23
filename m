From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/9] CIFS: Separate page processing from writepages
Date: Mon, 23 Jun 2014 18:58:29 +0400
Message-ID: <1403535517-8301-2-git-send-email-pshilovsky@samba.org>
References: <1403535517-8301-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403535517-8301-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c |  154 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 83 insertions(+), 71 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 208f56e..216959e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1878,6 +1878,86 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	return rc;
 }
 
+static unsigned int
+wdata_prepare_pages(struct cifs_writedata *wdata, unsigned int found_pages,
+		    struct address_space *mapping,
+		    struct writeback_control *wbc,
+		    pgoff_t end, pgoff_t *index, pgoff_t *next, bool *done)
+{
+	unsigned int nr_pages = 0, i;
+	struct page *page;
+
+	for (i = 0; i < found_pages; i++) {
+		page = wdata->pages[i];
+		/*
+		 * At this point we hold neither mapping->tree_lock nor
+		 * lock on the page itself: the page may be truncated or
+		 * invalidated (changing page->mapping to NULL), or even
+		 * swizzled back from swapper_space to tmpfs file
+		 * mapping
+		 */
+
+		if (nr_pages == 0)
+			lock_page(page);
+		else if (!trylock_page(page))
+			break;
+
+		if (unlikely(page->mapping != mapping)) {
+			unlock_page(page);
+			break;
+		}
+
+		if (!wbc->range_cyclic && page->index > end) {
+			*done = true;
+			unlock_page(page);
+			break;
+		}
+
+		if (*next && (page->index != *next)) {
+			/* Not next consecutive page */
+			unlock_page(page);
+			break;
+		}
+
+		if (wbc->sync_mode != WB_SYNC_NONE)
+			wait_on_page_writeback(page);
+
+		if (PageWriteback(page) ||
+				!clear_page_dirty_for_io(page)) {
+			unlock_page(page);
+			break;
+		}
+
+		/*
+		 * This actually clears the dirty bit in the radix tree.
+		 * See cifs_writepage() for more commentary.
+		 */
+		set_page_writeback(page);
+		if (page_offset(page) >= i_size_read(mapping->host)) {
+			*done = true;
+			unlock_page(page);
+			end_page_writeback(page);
+			break;
+		}
+
+		wdata->pages[i] = page;
+		*next = page->index + 1;
+		++nr_pages;
+	}
+
+	/* reset index to refind any pages skipped */
+	if (nr_pages == 0)
+		*index = wdata->pages[0]->index + 1;
+
+	/* put any pages we aren't going to use */
+	for (i = nr_pages; i < found_pages; i++) {
+		page_cache_release(wdata->pages[i]);
+		wdata->pages[i] = NULL;
+	}
+
+	return nr_pages;
+}
+
 static int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
@@ -1886,7 +1966,6 @@ static int cifs_writepages(struct address_space *mapping,
 	pgoff_t end, index;
 	struct cifs_writedata *wdata;
 	struct TCP_Server_Info *server;
-	struct page *page;
 	int rc = 0;
 
 	/*
@@ -1908,7 +1987,7 @@ static int cifs_writepages(struct address_space *mapping,
 	}
 retry:
 	while (!done && index <= end) {
-		unsigned int i, nr_pages, found_pages;
+		unsigned int nr_pages, found_pages;
 		pgoff_t next = 0, tofind;
 		struct page **pages;
 
@@ -1944,75 +2023,8 @@ retry:
 			break;
 		}
 
-		nr_pages = 0;
-		for (i = 0; i < found_pages; i++) {
-			page = wdata->pages[i];
-			/*
-			 * At this point we hold neither mapping->tree_lock nor
-			 * lock on the page itself: the page may be truncated or
-			 * invalidated (changing page->mapping to NULL), or even
-			 * swizzled back from swapper_space to tmpfs file
-			 * mapping
-			 */
-
-			if (nr_pages == 0)
-				lock_page(page);
-			else if (!trylock_page(page))
-				break;
-
-			if (unlikely(page->mapping != mapping)) {
-				unlock_page(page);
-				break;
-			}
-
-			if (!wbc->range_cyclic && page->index > end) {
-				done = true;
-				unlock_page(page);
-				break;
-			}
-
-			if (next && (page->index != next)) {
-				/* Not next consecutive page */
-				unlock_page(page);
-				break;
-			}
-
-			if (wbc->sync_mode != WB_SYNC_NONE)
-				wait_on_page_writeback(page);
-
-			if (PageWriteback(page) ||
-					!clear_page_dirty_for_io(page)) {
-				unlock_page(page);
-				break;
-			}
-
-			/*
-			 * This actually clears the dirty bit in the radix tree.
-			 * See cifs_writepage() for more commentary.
-			 */
-			set_page_writeback(page);
-
-			if (page_offset(page) >= i_size_read(mapping->host)) {
-				done = true;
-				unlock_page(page);
-				end_page_writeback(page);
-				break;
-			}
-
-			wdata->pages[i] = page;
-			next = page->index + 1;
-			++nr_pages;
-		}
-
-		/* reset index to refind any pages skipped */
-		if (nr_pages == 0)
-			index = wdata->pages[0]->index + 1;
-
-		/* put any pages we aren't going to use */
-		for (i = nr_pages; i < found_pages; i++) {
-			page_cache_release(wdata->pages[i]);
-			wdata->pages[i] = NULL;
-		}
+		nr_pages = wdata_prepare_pages(wdata, found_pages, mapping, wbc,
+					       end, &index, &next, &done);
 
 		/* nothing to write? */
 		if (nr_pages == 0) {
-- 
1.7.10.4
