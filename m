From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 6/9] CIFS: Separate filling pages from iovec write
Date: Mon, 23 Jun 2014 18:58:34 +0400
Message-ID: <1403535517-8301-7-git-send-email-pshilovsky@samba.org>
References: <1403535517-8301-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403535517-8301-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c |   88 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 50 insertions(+), 38 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e9dc57a..89d647b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2423,12 +2423,59 @@ cifs_uncached_retry_writev(struct cifs_writedata *wdata)
 	return rc;
 }
 
+static int
+wdata_fill_from_iovec(struct cifs_writedata *wdata, struct iov_iter *it,
+		      size_t *len, unsigned long nr_pages)
+{
+	int rc = 0;
+	size_t save_len, copied, bytes, cur_len = *len;
+	unsigned long i;
+
+	save_len = cur_len;
+	for (i = 0; i < nr_pages; i++) {
+		bytes = min_t(const size_t, cur_len, PAGE_SIZE);
+		copied = iov_iter_copy_from_user(wdata->pages[i], it,
+						 0, bytes);
+		cur_len -= copied;
+		iov_iter_advance(it, copied);
+		/*
+		 * If we didn't copy as much as we expected, then that
+		 * may mean we trod into an unmapped area. Stop copying
+		 * at that point. On the next pass through the big
+		 * loop, we'll likely end up getting a zero-length
+		 * write and bailing out of it.
+		 */
+		if (copied < bytes)
+			break;
+	}
+	cur_len = save_len - cur_len;
+	*len = cur_len;
+
+	/*
+	 * If we have no data to send, then that probably means that
+	 * the copy above failed altogether. That's most likely because
+	 * the address in the iovec was bogus. Return -EFAULT and let
+	 * the caller free anything we allocated and bail out.
+	 */
+	if (!cur_len)
+		return -EFAULT;
+
+	/*
+	 * i + 1 now represents the number of pages we actually used in
+	 * the copy phase above. Bring nr_pages down to that, and free
+	 * any pages that we didn't use.
+	 */
+	for ( ; nr_pages > i + 1; nr_pages--)
+		put_page(wdata->pages[nr_pages - 1]);
+	return rc;
+}
+
 static ssize_t
 cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
 	unsigned long nr_pages, i;
-	size_t bytes, copied, len, cur_len;
+	size_t len, cur_len;
 	ssize_t total_written = 0;
 	loff_t offset;
 	struct iov_iter it;
@@ -2465,8 +2512,6 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 
 	iov_iter_init(&it, iov, nr_segs, len, 0);
 	do {
-		size_t save_len;
-
 		nr_pages = get_numpages(cifs_sb->wsize, len, &cur_len);
 		wdata = cifs_writedata_alloc(nr_pages,
 					     cifs_uncached_writev_complete);
@@ -2481,47 +2526,14 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 			break;
 		}
 
-		save_len = cur_len;
-		for (i = 0; i < nr_pages; i++) {
-			bytes = min_t(const size_t, cur_len, PAGE_SIZE);
-			copied = iov_iter_copy_from_user(wdata->pages[i], &it,
-							 0, bytes);
-			cur_len -= copied;
-			iov_iter_advance(&it, copied);
-			/*
-			 * If we didn't copy as much as we expected, then that
-			 * may mean we trod into an unmapped area. Stop copying
-			 * at that point. On the next pass through the big
-			 * loop, we'll likely end up getting a zero-length
-			 * write and bailing out of it.
-			 */
-			if (copied < bytes)
-				break;
-		}
-		cur_len = save_len - cur_len;
-
-		/*
-		 * If we have no data to send, then that probably means that
-		 * the copy above failed altogether. That's most likely because
-		 * the address in the iovec was bogus. Set the rc to -EFAULT,
-		 * free anything we allocated and bail out.
-		 */
-		if (!cur_len) {
+		rc = wdata_fill_from_iovec(wdata, &it, &cur_len, nr_pages);
+		if (rc) {
 			for (i = 0; i < nr_pages; i++)
 				put_page(wdata->pages[i]);
 			kfree(wdata);
-			rc = -EFAULT;
 			break;
 		}
 
-		/*
-		 * i + 1 now represents the number of pages we actually used in
-		 * the copy phase above. Bring nr_pages down to that, and free
-		 * any pages that we didn't use.
-		 */
-		for ( ; nr_pages > i + 1; nr_pages--)
-			put_page(wdata->pages[nr_pages - 1]);
-
 		wdata->sync_mode = WB_SYNC_ALL;
 		wdata->nr_pages = nr_pages;
 		wdata->offset = (__u64)offset;
-- 
1.7.10.4
