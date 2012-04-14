From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 2/5] cifs: abstract out function to marshal the iovec for readv receives
Date: Fri, 13 Apr 2012 22:23:19 -0400
Message-ID: <1334370202-30711-3-git-send-email-jlayton@redhat.com>
References: <1334370202-30711-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334370202-30711-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Cached and uncached reads will need to do different things here to
handle the difference when the pages are in pagecache and not. Abstract
out the function that marshals the page list into a kvec array.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    2 +
 fs/cifs/cifssmb.c   |   67 +++-----------------------------------------------
 fs/cifs/file.c      |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+), 63 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index d57cdf4..f309b43 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -472,6 +472,8 @@ struct cifs_readdata {
 	int				result;
 	struct list_head		pages;
 	struct work_struct		work;
+	int (*marshal_iov) (struct cifs_readdata *rdata,
+			    unsigned int remaining);
 	unsigned int			nr_iov;
 	struct kvec			iov[1];
 };
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index b84c555..733af77 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1436,13 +1436,10 @@ static int
 cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	int length, len;
-	unsigned int data_offset, remaining, data_len;
+	unsigned int data_offset, data_len;
 	struct cifs_readdata *rdata = mid->callback_data;
 	char *buf = server->smallbuf;
 	unsigned int buflen = get_rfc1002_length(buf) + 4;
-	u64 eof;
-	pgoff_t eof_index;
-	struct page *page, *tpage;
 
 	cFYI(1, "%s: mid=%llu offset=%llu bytes=%u", __func__,
 		mid->mid, rdata->offset, rdata->bytes);
@@ -1525,64 +1522,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 
 	/* marshal up the page array */
-	len = 0;
-	remaining = data_len;
-	rdata->nr_iov = 1;
-
-	/* determine the eof that the server (probably) has */
-	eof = CIFS_I(rdata->mapping->host)->server_eof;
-	eof_index = eof ? (eof - 1) >> PAGE_CACHE_SHIFT : 0;
-	cFYI(1, "eof=%llu eof_index=%lu", eof, eof_index);
-
-	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
-		if (remaining >= PAGE_CACHE_SIZE) {
-			/* enough data to fill the page */
-			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
-			rdata->iov[rdata->nr_iov].iov_len = PAGE_CACHE_SIZE;
-			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
-				rdata->nr_iov, page->index,
-				rdata->iov[rdata->nr_iov].iov_base,
-				rdata->iov[rdata->nr_iov].iov_len);
-			++rdata->nr_iov;
-			len += PAGE_CACHE_SIZE;
-			remaining -= PAGE_CACHE_SIZE;
-		} else if (remaining > 0) {
-			/* enough for partial page, fill and zero the rest */
-			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
-			rdata->iov[rdata->nr_iov].iov_len = remaining;
-			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
-				rdata->nr_iov, page->index,
-				rdata->iov[rdata->nr_iov].iov_base,
-				rdata->iov[rdata->nr_iov].iov_len);
-			memset(rdata->iov[rdata->nr_iov].iov_base + remaining,
-				'\0', PAGE_CACHE_SIZE - remaining);
-			++rdata->nr_iov;
-			len += remaining;
-			remaining = 0;
-		} else if (page->index > eof_index) {
-			/*
-			 * The VFS will not try to do readahead past the
-			 * i_size, but it's possible that we have outstanding
-			 * writes with gaps in the middle and the i_size hasn't
-			 * caught up yet. Populate those with zeroed out pages
-			 * to prevent the VFS from repeatedly attempting to
-			 * fill them until the writes are flushed.
-			 */
-			zero_user(page, 0, PAGE_CACHE_SIZE);
-			list_del(&page->lru);
-			lru_cache_add_file(page);
-			flush_dcache_page(page);
-			SetPageUptodate(page);
-			unlock_page(page);
-			page_cache_release(page);
-		} else {
-			/* no need to hold page hostage */
-			list_del(&page->lru);
-			lru_cache_add_file(page);
-			unlock_page(page);
-			page_cache_release(page);
-		}
-	}
+	len = rdata->marshal_iov(rdata, data_len);
+	data_len -= len;
 
 	/* issue the read if we have any iovecs left to fill */
 	if (rdata->nr_iov > 1) {
@@ -1598,7 +1539,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	rdata->bytes = length;
 
 	cFYI(1, "total_read=%u buflen=%u remaining=%u", server->total_read,
-		buflen, remaining);
+		buflen, data_len);
 
 	/* discard anything left over */
 	if (server->total_read < buflen)
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d210288..183381d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2654,6 +2654,73 @@ cifs_readv_complete(struct work_struct *work)
 	cifs_readdata_free(rdata);
 }
 
+static int
+cifs_readpages_marshal_iov(struct cifs_readdata *rdata, unsigned int remaining)
+{
+	int len = 0;
+	struct page *page, *tpage;
+	u64 eof;
+	pgoff_t eof_index;
+
+	/* determine the eof that the server (probably) has */
+	eof = CIFS_I(rdata->mapping->host)->server_eof;
+	eof_index = eof ? (eof - 1) >> PAGE_CACHE_SHIFT : 0;
+	cFYI(1, "eof=%llu eof_index=%lu", eof, eof_index);
+
+	rdata->nr_iov = 1;
+	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
+		if (remaining >= PAGE_CACHE_SIZE) {
+			/* enough data to fill the page */
+			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
+			rdata->iov[rdata->nr_iov].iov_len = PAGE_CACHE_SIZE;
+			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
+				rdata->nr_iov, page->index,
+				rdata->iov[rdata->nr_iov].iov_base,
+				rdata->iov[rdata->nr_iov].iov_len);
+			++rdata->nr_iov;
+			len += PAGE_CACHE_SIZE;
+			remaining -= PAGE_CACHE_SIZE;
+		} else if (remaining > 0) {
+			/* enough for partial page, fill and zero the rest */
+			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
+			rdata->iov[rdata->nr_iov].iov_len = remaining;
+			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
+				rdata->nr_iov, page->index,
+				rdata->iov[rdata->nr_iov].iov_base,
+				rdata->iov[rdata->nr_iov].iov_len);
+			memset(rdata->iov[rdata->nr_iov].iov_base + remaining,
+				'\0', PAGE_CACHE_SIZE - remaining);
+			++rdata->nr_iov;
+			len += remaining;
+			remaining = 0;
+		} else if (page->index > eof_index) {
+			/*
+			 * The VFS will not try to do readahead past the
+			 * i_size, but it's possible that we have outstanding
+			 * writes with gaps in the middle and the i_size hasn't
+			 * caught up yet. Populate those with zeroed out pages
+			 * to prevent the VFS from repeatedly attempting to
+			 * fill them until the writes are flushed.
+			 */
+			zero_user(page, 0, PAGE_CACHE_SIZE);
+			list_del(&page->lru);
+			lru_cache_add_file(page);
+			flush_dcache_page(page);
+			SetPageUptodate(page);
+			unlock_page(page);
+			page_cache_release(page);
+		} else {
+			/* no need to hold page hostage */
+			list_del(&page->lru);
+			lru_cache_add_file(page);
+			unlock_page(page);
+			page_cache_release(page);
+		}
+	}
+
+	return len;
+}
+
 static int cifs_readpages(struct file *file, struct address_space *mapping,
 	struct list_head *page_list, unsigned num_pages)
 {
@@ -2777,6 +2844,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		rdata->offset = offset;
 		rdata->bytes = bytes;
 		rdata->pid = pid;
+		rdata->marshal_iov = cifs_readpages_marshal_iov;
 		list_splice_init(&tmplist, &rdata->pages);
 
 		do {
-- 
1.7.7.6
