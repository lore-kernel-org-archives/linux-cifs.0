From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 1/5] cifs: make cifs_readdata_alloc take a work_func_t arg
Date: Fri, 13 Apr 2012 22:23:18 -0400
Message-ID: <1334370202-30711-2-git-send-email-jlayton@redhat.com>
References: <1334370202-30711-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334370202-30711-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We'll need different completion routines for an uncached read. Allow
the caller to set the one he needs at allocation time. Also, move
most of these functions to file.c so we can make more of them static.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    2 --
 fs/cifs/cifssmb.c   |   50 --------------------------------------------------
 fs/cifs/file.c      |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 96192c1..d57cdf4 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -476,8 +476,6 @@ struct cifs_readdata {
 	struct kvec			iov[1];
 };
 
-struct cifs_readdata *cifs_readdata_alloc(unsigned int nr_pages);
-void cifs_readdata_free(struct cifs_readdata *rdata);
 int cifs_async_readv(struct cifs_readdata *rdata);
 
 /* asynchronous write support */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index f52c5ab..b84c555 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -87,7 +87,6 @@ static struct {
 #endif /* CIFS_POSIX */
 
 /* Forward declarations */
-static void cifs_readv_complete(struct work_struct *work);
 
 /* Mark as invalid, all open files on tree connections since they
    were closed when session to server was lost */
@@ -1385,28 +1384,6 @@ openRetry:
 	return rc;
 }
 
-struct cifs_readdata *
-cifs_readdata_alloc(unsigned int nr_pages)
-{
-	struct cifs_readdata *rdata;
-
-	/* readdata + 1 kvec for each page */
-	rdata = kzalloc(sizeof(*rdata) +
-			sizeof(struct kvec) * nr_pages, GFP_KERNEL);
-	if (rdata != NULL) {
-		INIT_WORK(&rdata->work, cifs_readv_complete);
-		INIT_LIST_HEAD(&rdata->pages);
-	}
-	return rdata;
-}
-
-void
-cifs_readdata_free(struct cifs_readdata *rdata)
-{
-	cifsFileInfo_put(rdata->cfile);
-	kfree(rdata);
-}
-
 /*
  * Discard any remaining data in the current SMB. To do this, we borrow the
  * current bigbuf.
@@ -1632,33 +1609,6 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 }
 
 static void
-cifs_readv_complete(struct work_struct *work)
-{
-	struct cifs_readdata *rdata = container_of(work,
-						struct cifs_readdata, work);
-	struct page *page, *tpage;
-
-	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
-		list_del(&page->lru);
-		lru_cache_add_file(page);
-
-		if (rdata->result == 0) {
-			kunmap(page);
-			flush_dcache_page(page);
-			SetPageUptodate(page);
-		}
-
-		unlock_page(page);
-
-		if (rdata->result == 0)
-			cifs_readpage_to_fscache(rdata->mapping->host, page);
-
-		page_cache_release(page);
-	}
-	cifs_readdata_free(rdata);
-}
-
-static void
 cifs_readv_callback(struct mid_q_entry *mid)
 {
 	struct cifs_readdata *rdata = mid->callback_data;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 81725e9..d210288 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2339,6 +2339,27 @@ ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 	return cifs_user_writev(iocb, iov, nr_segs, pos);
 }
 
+static struct cifs_readdata *
+cifs_readdata_alloc(unsigned int nr_vecs, work_func_t complete)
+{
+	struct cifs_readdata *rdata;
+
+	rdata = kzalloc(sizeof(*rdata) +
+			sizeof(struct kvec) * nr_vecs, GFP_KERNEL);
+	if (rdata != NULL) {
+		INIT_WORK(&rdata->work, complete);
+		INIT_LIST_HEAD(&rdata->pages);
+	}
+	return rdata;
+}
+
+static void
+cifs_readdata_free(struct cifs_readdata *rdata)
+{
+	cifsFileInfo_put(rdata->cfile);
+	kfree(rdata);
+}
+
 static ssize_t
 cifs_iovec_read(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
@@ -2606,6 +2627,33 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return rc;
 }
 
+static void
+cifs_readv_complete(struct work_struct *work)
+{
+	struct cifs_readdata *rdata = container_of(work,
+						struct cifs_readdata, work);
+	struct page *page, *tpage;
+
+	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
+		list_del(&page->lru);
+		lru_cache_add_file(page);
+
+		if (rdata->result == 0) {
+			kunmap(page);
+			flush_dcache_page(page);
+			SetPageUptodate(page);
+		}
+
+		unlock_page(page);
+
+		if (rdata->result == 0)
+			cifs_readpage_to_fscache(rdata->mapping->host, page);
+
+		page_cache_release(page);
+	}
+	cifs_readdata_free(rdata);
+}
+
 static int cifs_readpages(struct file *file, struct address_space *mapping,
 	struct list_head *page_list, unsigned num_pages)
 {
@@ -2708,7 +2756,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 			nr_pages++;
 		}
 
-		rdata = cifs_readdata_alloc(nr_pages);
+		rdata = cifs_readdata_alloc(nr_pages, cifs_readv_complete);
 		if (!rdata) {
 			/* best to give up if we're out of mem */
 			list_for_each_entry_safe(page, tpage, &tmplist, lru) {
-- 
1.7.7.6
