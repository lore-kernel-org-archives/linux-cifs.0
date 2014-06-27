From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 11/16] CIFS: Separate page search from readpages
Date: Fri, 27 Jun 2014 13:57:48 +0400
Message-ID: <1403863073-19526-12-git-send-email-pshilovsky@samba.org>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403863073-19526-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c | 107 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 61 insertions(+), 46 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 2e49a17..ee7c547 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3339,6 +3339,63 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 	return total_read > 0 && result != -EAGAIN ? total_read : result;
 }
 
+static int
+readpages_get_pages(struct address_space *mapping, struct list_head *page_list,
+		    unsigned int rsize, struct list_head *tmplist,
+		    unsigned int *nr_pages, loff_t *offset, unsigned int *bytes)
+{
+	struct page *page, *tpage;
+	unsigned int expected_index;
+	int rc;
+
+	page = list_entry(page_list->prev, struct page, lru);
+
+	/*
+	 * Lock the page and put it in the cache. Since no one else
+	 * should have access to this page, we're safe to simply set
+	 * PG_locked without checking it first.
+	 */
+	__set_page_locked(page);
+	rc = add_to_page_cache_locked(page, mapping,
+				      page->index, GFP_KERNEL);
+
+	/* give up if we can't stick it in the cache */
+	if (rc) {
+		__clear_page_locked(page);
+		return rc;
+	}
+
+	/* move first page to the tmplist */
+	*offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
+	*bytes = PAGE_CACHE_SIZE;
+	*nr_pages = 1;
+	list_move_tail(&page->lru, tmplist);
+
+	/* now try and add more pages onto the request */
+	expected_index = page->index + 1;
+	list_for_each_entry_safe_reverse(page, tpage, page_list, lru) {
+		/* discontinuity ? */
+		if (page->index != expected_index)
+			break;
+
+		/* would this page push the read over the rsize? */
+		if (*bytes + PAGE_CACHE_SIZE > rsize)
+			break;
+
+		__set_page_locked(page);
+		if (add_to_page_cache_locked(page, mapping, page->index,
+								GFP_KERNEL)) {
+			__clear_page_locked(page);
+			break;
+		}
+		list_move_tail(&page->lru, tmplist);
+		(*bytes) += PAGE_CACHE_SIZE;
+		expected_index++;
+		(*nr_pages)++;
+	}
+	return rc;
+}
+
 static int cifs_readpages(struct file *file, struct address_space *mapping,
 	struct list_head *page_list, unsigned num_pages)
 {
@@ -3393,57 +3450,15 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	 * the rdata->pages, then we want them in increasing order.
 	 */
 	while (!list_empty(page_list)) {
-		unsigned int i;
-		unsigned int bytes = PAGE_CACHE_SIZE;
-		unsigned int expected_index;
-		unsigned int nr_pages = 1;
+		unsigned int i, nr_pages, bytes;
 		loff_t offset;
 		struct page *page, *tpage;
 		struct cifs_readdata *rdata;
 
-		page = list_entry(page_list->prev, struct page, lru);
-
-		/*
-		 * Lock the page and put it in the cache. Since no one else
-		 * should have access to this page, we're safe to simply set
-		 * PG_locked without checking it first.
-		 */
-		__set_page_locked(page);
-		rc = add_to_page_cache_locked(page, mapping,
-					      page->index, GFP_KERNEL);
-
-		/* give up if we can't stick it in the cache */
-		if (rc) {
-			__clear_page_locked(page);
+		rc = readpages_get_pages(mapping, page_list, rsize, &tmplist,
+					 &nr_pages, &offset, &bytes);
+		if (rc)
 			break;
-		}
-
-		/* move first page to the tmplist */
-		offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
-		list_move_tail(&page->lru, &tmplist);
-
-		/* now try and add more pages onto the request */
-		expected_index = page->index + 1;
-		list_for_each_entry_safe_reverse(page, tpage, page_list, lru) {
-			/* discontinuity ? */
-			if (page->index != expected_index)
-				break;
-
-			/* would this page push the read over the rsize? */
-			if (bytes + PAGE_CACHE_SIZE > rsize)
-				break;
-
-			__set_page_locked(page);
-			if (add_to_page_cache_locked(page, mapping,
-						page->index, GFP_KERNEL)) {
-				__clear_page_locked(page);
-				break;
-			}
-			list_move_tail(&page->lru, &tmplist);
-			bytes += PAGE_CACHE_SIZE;
-			expected_index++;
-			nr_pages++;
-		}
 
 		rdata = cifs_readdata_alloc(nr_pages, cifs_readv_complete);
 		if (!rdata) {
-- 
1.8.1.2
