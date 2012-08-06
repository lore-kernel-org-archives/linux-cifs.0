From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 12/15] cifs: turn the pages list in cifs_readdata into an array
Date: Mon,  6 Aug 2012 07:31:09 -0400
Message-ID: <1344252672-15244-13-git-send-email-jlayton@redhat.com>
References: <1344252672-15244-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344252672-15244-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We'll need an array to put into a smb_rqst, so convert this into an array
instead of (ab)using the lru list_head.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |  3 +-
 fs/cifs/file.c     | 82 ++++++++++++++++++++++++++++++++----------------------
 2 files changed, 50 insertions(+), 35 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9437162..2a1689a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -976,12 +976,13 @@ struct cifs_readdata {
 	unsigned int			bytes;
 	pid_t				pid;
 	int				result;
-	struct list_head		pages;
 	struct work_struct		work;
 	int (*marshal_iov) (struct cifs_readdata *rdata,
 			    unsigned int remaining);
 	unsigned int			nr_iov;
 	struct kvec			*iov;
+	unsigned int			nr_pages;
+	struct page			*pages[];
 };
 
 struct cifs_writedata;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7d822c6..cf7485a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2419,13 +2419,13 @@ cifs_readdata_alloc(unsigned int nr_pages, work_func_t complete)
 	if (!iov)
 		return (struct cifs_readdata *)iov;
 
-	rdata = kzalloc(sizeof(*rdata), GFP_KERNEL);
+	rdata = kzalloc(sizeof(*rdata) + (sizeof(struct page *) * nr_pages),
+			GFP_KERNEL);
 	if (rdata != NULL) {
 		kref_init(&rdata->refcount);
 		INIT_LIST_HEAD(&rdata->list);
 		init_completion(&rdata->done);
 		INIT_WORK(&rdata->work, complete);
-		INIT_LIST_HEAD(&rdata->pages);
 		rdata->iov = iov;
 	} else {
 		kfree(iov);
@@ -2448,25 +2448,25 @@ cifs_readdata_release(struct kref *refcount)
 }
 
 static int
-cifs_read_allocate_pages(struct list_head *list, unsigned int npages)
+cifs_read_allocate_pages(struct cifs_readdata *rdata, unsigned int nr_pages)
 {
 	int rc = 0;
-	struct page *page, *tpage;
+	struct page *page;
 	unsigned int i;
 
-	for (i = 0; i < npages; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		page = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
 		if (!page) {
 			rc = -ENOMEM;
 			break;
 		}
-		list_add(&page->lru, list);
+		rdata->pages[i] = page;
 	}
 
 	if (rc) {
-		list_for_each_entry_safe(page, tpage, list, lru) {
-			list_del(&page->lru);
-			put_page(page);
+		for (i = 0; i < nr_pages; i++) {
+			put_page(rdata->pages[i]);
+			rdata->pages[i] = NULL;
 		}
 	}
 	return rc;
@@ -2475,13 +2475,13 @@ cifs_read_allocate_pages(struct list_head *list, unsigned int npages)
 static void
 cifs_uncached_readdata_release(struct kref *refcount)
 {
-	struct page *page, *tpage;
 	struct cifs_readdata *rdata = container_of(refcount,
 					struct cifs_readdata, refcount);
+	unsigned int i;
 
-	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
-		list_del(&page->lru);
-		put_page(page);
+	for (i = 0; i < rdata->nr_pages; i++) {
+		put_page(rdata->pages[i]);
+		rdata->pages[i] = NULL;
 	}
 	cifs_readdata_release(refcount);
 }
@@ -2525,17 +2525,18 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, const struct iovec *iov,
 	int rc = 0;
 	struct iov_iter ii;
 	size_t pos = rdata->offset - offset;
-	struct page *page, *tpage;
 	ssize_t remaining = rdata->bytes;
 	unsigned char *pdata;
+	unsigned int i;
 
 	/* set up iov_iter and advance to the correct offset */
 	iov_iter_init(&ii, iov, nr_segs, iov_length(iov, nr_segs), 0);
 	iov_iter_advance(&ii, pos);
 
 	*copied = 0;
-	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
+	for (i = 0; i < rdata->nr_pages; i++) {
 		ssize_t copy;
+		struct page *page = rdata->pages[i];
 
 		/* copy a whole page or whatever's left */
 		copy = min_t(ssize_t, remaining, PAGE_SIZE);
@@ -2555,9 +2556,6 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, const struct iovec *iov,
 				iov_iter_advance(&ii, copy);
 			}
 		}
-
-		list_del(&page->lru);
-		put_page(page);
 	}
 
 	return rc;
@@ -2568,12 +2566,13 @@ cifs_uncached_readv_complete(struct work_struct *work)
 {
 	struct cifs_readdata *rdata = container_of(work,
 						struct cifs_readdata, work);
+	unsigned int i;
 
 	/* if the result is non-zero then the pages weren't kmapped */
 	if (rdata->result == 0) {
 		struct page *page;
 
-		list_for_each_entry(page, &rdata->pages, lru)
+		for (i = 0; i < rdata->nr_pages; i++)
 			kunmap(page);
 	}
 
@@ -2586,10 +2585,13 @@ cifs_uncached_read_marshal_iov(struct cifs_readdata *rdata,
 				unsigned int remaining)
 {
 	int len = 0;
-	struct page *page, *tpage;
+	unsigned int i;
+	unsigned int nr_pages = rdata->nr_pages;
 
 	rdata->nr_iov = 1;
-	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page = rdata->pages[i];
+
 		if (remaining >= PAGE_SIZE) {
 			/* enough data to fill the page */
 			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
@@ -2616,7 +2618,8 @@ cifs_uncached_read_marshal_iov(struct cifs_readdata *rdata,
 			remaining = 0;
 		} else {
 			/* no need to hold page hostage */
-			list_del(&page->lru);
+			rdata->pages[i] = NULL;
+			rdata->nr_pages--;
 			put_page(page);
 		}
 	}
@@ -2675,11 +2678,12 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 			goto error;
 		}
 
-		rc = cifs_read_allocate_pages(&rdata->pages, npages);
+		rc = cifs_read_allocate_pages(rdata, npages);
 		if (rc)
 			goto error;
 
 		rdata->cfile = cifsFileInfo_get(open_file);
+		rdata->nr_pages = npages;
 		rdata->offset = offset;
 		rdata->bytes = cur_len;
 		rdata->pid = pid;
@@ -2923,12 +2927,13 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 static void
 cifs_readv_complete(struct work_struct *work)
 {
+	unsigned int i;
 	struct cifs_readdata *rdata = container_of(work,
 						struct cifs_readdata, work);
-	struct page *page, *tpage;
 
-	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
-		list_del(&page->lru);
+	for (i = 0; i < rdata->nr_pages; i++) {
+		struct page *page = rdata->pages[i];
+
 		lru_cache_add_file(page);
 
 		if (rdata->result == 0) {
@@ -2943,6 +2948,7 @@ cifs_readv_complete(struct work_struct *work)
 			cifs_readpage_to_fscache(rdata->mapping->host, page);
 
 		page_cache_release(page);
+		rdata->pages[i] = NULL;
 	}
 	kref_put(&rdata->refcount, cifs_readdata_release);
 }
@@ -2951,9 +2957,10 @@ static int
 cifs_readpages_marshal_iov(struct cifs_readdata *rdata, unsigned int remaining)
 {
 	int len = 0;
-	struct page *page, *tpage;
+	unsigned int i;
 	u64 eof;
 	pgoff_t eof_index;
+	unsigned int nr_pages = rdata->nr_pages;
 
 	/* determine the eof that the server (probably) has */
 	eof = CIFS_I(rdata->mapping->host)->server_eof;
@@ -2961,7 +2968,9 @@ cifs_readpages_marshal_iov(struct cifs_readdata *rdata, unsigned int remaining)
 	cFYI(1, "eof=%llu eof_index=%lu", eof, eof_index);
 
 	rdata->nr_iov = 1;
-	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page = rdata->pages[i];
+
 		if (remaining >= PAGE_CACHE_SIZE) {
 			/* enough data to fill the page */
 			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
@@ -2996,18 +3005,20 @@ cifs_readpages_marshal_iov(struct cifs_readdata *rdata, unsigned int remaining)
 			 * fill them until the writes are flushed.
 			 */
 			zero_user(page, 0, PAGE_CACHE_SIZE);
-			list_del(&page->lru);
 			lru_cache_add_file(page);
 			flush_dcache_page(page);
 			SetPageUptodate(page);
 			unlock_page(page);
 			page_cache_release(page);
+			rdata->pages[i] = NULL;
+			rdata->nr_pages--;
 		} else {
 			/* no need to hold page hostage */
-			list_del(&page->lru);
 			lru_cache_add_file(page);
 			unlock_page(page);
 			page_cache_release(page);
+			rdata->pages[i] = NULL;
+			rdata->nr_pages--;
 		}
 	}
 
@@ -3065,6 +3076,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	 * the rdata->pages, then we want them in increasing order.
 	 */
 	while (!list_empty(page_list)) {
+		unsigned int i;
 		unsigned int bytes = PAGE_CACHE_SIZE;
 		unsigned int expected_index;
 		unsigned int nr_pages = 1;
@@ -3135,13 +3147,15 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		rdata->bytes = bytes;
 		rdata->pid = pid;
 		rdata->marshal_iov = cifs_readpages_marshal_iov;
-		list_splice_init(&tmplist, &rdata->pages);
+
+		list_for_each_entry_safe(page, tpage, &tmplist, lru) {
+			list_del(&page->lru);
+			rdata->pages[rdata->nr_pages++] = page;
+		}
 
 		rc = cifs_retry_async_readv(rdata);
 		if (rc != 0) {
-			list_for_each_entry_safe(page, tpage, &rdata->pages,
-						 lru) {
-				list_del(&page->lru);
+			for (i = 0; i < rdata->nr_pages; i++) {
 				lru_cache_add_file(page);
 				unlock_page(page);
 				page_cache_release(page);
-- 
1.7.11.2
