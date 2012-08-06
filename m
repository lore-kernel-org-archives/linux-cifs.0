From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 13/15] cifs: convert async read code to use pages array without kmapping
Date: Mon,  6 Aug 2012 07:31:10 -0400
Message-ID: <1344252672-15244-14-git-send-email-jlayton@redhat.com>
References: <1344252672-15244-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344252672-15244-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Replace the "marshal_iov" function with a "read_into_pages" function.
That function will copy the read data off the socket and into the
pages array, kmapping and reading pages one at a time.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |   7 ++-
 fs/cifs/cifssmb.c  |  27 +++++-------
 fs/cifs/file.c     | 123 ++++++++++++++++++++++++++---------------------------
 fs/cifs/smb2pdu.c  |   6 ++-
 4 files changed, 80 insertions(+), 83 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2a1689a..48a5eba 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -977,8 +977,11 @@ struct cifs_readdata {
 	pid_t				pid;
 	int				result;
 	struct work_struct		work;
-	int (*marshal_iov) (struct cifs_readdata *rdata,
-			    unsigned int remaining);
+	int (*read_into_pages)(struct TCP_Server_Info *server,
+				struct cifs_readdata *rdata,
+				unsigned int len);
+	unsigned int			pagesz;
+	unsigned int			tailsz;
 	unsigned int			nr_iov;
 	struct kvec			*iov;
 	unsigned int			nr_pages;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a110e07..5d7bd75 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1496,6 +1496,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	/* set up first iov for signature check */
 	rdata->iov[0].iov_base = buf;
 	rdata->iov[0].iov_len = server->total_read;
+	rdata->nr_iov = 1;
 	cFYI(1, "0: iov_base=%p iov_len=%zu",
 		rdata->iov[0].iov_base, rdata->iov[0].iov_len);
 
@@ -1507,23 +1508,11 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		return cifs_readv_discard(server, mid);
 	}
 
-	/* marshal up the page array */
-	cifs_kmap_lock();
-	len = rdata->marshal_iov(rdata, data_len);
-	cifs_kmap_unlock();
-	data_len -= len;
-
-	/* issue the read if we have any iovecs left to fill */
-	if (rdata->nr_iov > 1) {
-		length = cifs_readv_from_socket(server, &rdata->iov[1],
-						rdata->nr_iov - 1, len);
-		if (length < 0)
-			return length;
-		server->total_read += length;
-	} else {
-		length = 0;
-	}
+	length = rdata->read_into_pages(server, rdata, data_len);
+	if (length < 0)
+		return length;
 
+	server->total_read += length;
 	rdata->bytes = length;
 
 	cFYI(1, "total_read=%u buflen=%u remaining=%u", server->total_read,
@@ -1544,7 +1533,11 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
-				 .rq_nvec = rdata->nr_iov };
+				 .rq_nvec = rdata->nr_iov,
+				 .rq_pages = rdata->pages,
+				 .rq_npages = rdata->nr_pages,
+				 .rq_pagesz = rdata->pagesz,
+				 .rq_tailsz = rdata->tailsz };
 
 	cFYI(1, "%s: mid=%llu state=%d result=%d bytes=%u", __func__,
 		mid->mid, mid->mid_state, rdata->result, rdata->bytes);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cf7485a..8b23cb2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2566,65 +2566,57 @@ cifs_uncached_readv_complete(struct work_struct *work)
 {
 	struct cifs_readdata *rdata = container_of(work,
 						struct cifs_readdata, work);
-	unsigned int i;
-
-	/* if the result is non-zero then the pages weren't kmapped */
-	if (rdata->result == 0) {
-		struct page *page;
-
-		for (i = 0; i < rdata->nr_pages; i++)
-			kunmap(page);
-	}
 
 	complete(&rdata->done);
 	kref_put(&rdata->refcount, cifs_uncached_readdata_release);
 }
 
 static int
-cifs_uncached_read_marshal_iov(struct cifs_readdata *rdata,
-				unsigned int remaining)
+cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
+			struct cifs_readdata *rdata, unsigned int len)
 {
-	int len = 0;
+	int total_read = 0, result = 0;
 	unsigned int i;
 	unsigned int nr_pages = rdata->nr_pages;
+	struct kvec iov;
 
-	rdata->nr_iov = 1;
+	rdata->tailsz = PAGE_SIZE;
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = rdata->pages[i];
 
-		if (remaining >= PAGE_SIZE) {
+		if (len >= PAGE_SIZE) {
 			/* enough data to fill the page */
-			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
-			rdata->iov[rdata->nr_iov].iov_len = PAGE_SIZE;
-			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
-				rdata->nr_iov, page->index,
-				rdata->iov[rdata->nr_iov].iov_base,
-				rdata->iov[rdata->nr_iov].iov_len);
-			++rdata->nr_iov;
-			len += PAGE_SIZE;
-			remaining -= PAGE_SIZE;
-		} else if (remaining > 0) {
+			iov.iov_base = kmap(page);
+			iov.iov_len = PAGE_SIZE;
+			cFYI(1, "%u: iov_base=%p iov_len=%zu",
+				i, iov.iov_base, iov.iov_len);
+			len -= PAGE_SIZE;
+		} else if (len > 0) {
 			/* enough for partial page, fill and zero the rest */
-			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
-			rdata->iov[rdata->nr_iov].iov_len = remaining;
-			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
-				rdata->nr_iov, page->index,
-				rdata->iov[rdata->nr_iov].iov_base,
-				rdata->iov[rdata->nr_iov].iov_len);
-			memset(rdata->iov[rdata->nr_iov].iov_base + remaining,
-				'\0', PAGE_SIZE - remaining);
-			++rdata->nr_iov;
-			len += remaining;
-			remaining = 0;
+			iov.iov_base = kmap(page);
+			iov.iov_len = len;
+			cFYI(1, "%u: iov_base=%p iov_len=%zu",
+				i, iov.iov_base, iov.iov_len);
+			memset(iov.iov_base + len, '\0', PAGE_SIZE - len);
+			rdata->tailsz = len;
+			len = 0;
 		} else {
 			/* no need to hold page hostage */
 			rdata->pages[i] = NULL;
 			rdata->nr_pages--;
 			put_page(page);
+			continue;
 		}
+
+		result = cifs_readv_from_socket(server, &iov, 1, iov.iov_len);
+		kunmap(page);
+		if (result < 0)
+			break;
+
+		total_read += result;
 	}
 
-	return len;
+	return total_read > 0 ? total_read : result;
 }
 
 static ssize_t
@@ -2687,7 +2679,8 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 		rdata->offset = offset;
 		rdata->bytes = cur_len;
 		rdata->pid = pid;
-		rdata->marshal_iov = cifs_uncached_read_marshal_iov;
+		rdata->pagesz = PAGE_SIZE;
+		rdata->read_into_pages = cifs_uncached_read_into_pages;
 
 		rc = cifs_retry_async_readv(rdata);
 error:
@@ -2937,7 +2930,6 @@ cifs_readv_complete(struct work_struct *work)
 		lru_cache_add_file(page);
 
 		if (rdata->result == 0) {
-			kunmap(page);
 			flush_dcache_page(page);
 			SetPageUptodate(page);
 		}
@@ -2954,47 +2946,42 @@ cifs_readv_complete(struct work_struct *work)
 }
 
 static int
-cifs_readpages_marshal_iov(struct cifs_readdata *rdata, unsigned int remaining)
+cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
+			struct cifs_readdata *rdata, unsigned int len)
 {
-	int len = 0;
+	int total_read = 0, result = 0;
 	unsigned int i;
 	u64 eof;
 	pgoff_t eof_index;
 	unsigned int nr_pages = rdata->nr_pages;
+	struct kvec iov;
 
 	/* determine the eof that the server (probably) has */
 	eof = CIFS_I(rdata->mapping->host)->server_eof;
 	eof_index = eof ? (eof - 1) >> PAGE_CACHE_SHIFT : 0;
 	cFYI(1, "eof=%llu eof_index=%lu", eof, eof_index);
 
-	rdata->nr_iov = 1;
+	rdata->tailsz = PAGE_CACHE_SIZE;
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = rdata->pages[i];
 
-		if (remaining >= PAGE_CACHE_SIZE) {
+		if (len >= PAGE_CACHE_SIZE) {
 			/* enough data to fill the page */
-			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
-			rdata->iov[rdata->nr_iov].iov_len = PAGE_CACHE_SIZE;
+			iov.iov_base = kmap(page);
+			iov.iov_len = PAGE_CACHE_SIZE;
 			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
-				rdata->nr_iov, page->index,
-				rdata->iov[rdata->nr_iov].iov_base,
-				rdata->iov[rdata->nr_iov].iov_len);
-			++rdata->nr_iov;
-			len += PAGE_CACHE_SIZE;
-			remaining -= PAGE_CACHE_SIZE;
-		} else if (remaining > 0) {
+				i, page->index, iov.iov_base, iov.iov_len);
+			len -= PAGE_CACHE_SIZE;
+		} else if (len > 0) {
 			/* enough for partial page, fill and zero the rest */
-			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
-			rdata->iov[rdata->nr_iov].iov_len = remaining;
+			iov.iov_base = kmap(page);
+			iov.iov_len = len;
 			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
-				rdata->nr_iov, page->index,
-				rdata->iov[rdata->nr_iov].iov_base,
-				rdata->iov[rdata->nr_iov].iov_len);
-			memset(rdata->iov[rdata->nr_iov].iov_base + remaining,
-				'\0', PAGE_CACHE_SIZE - remaining);
-			++rdata->nr_iov;
-			len += remaining;
-			remaining = 0;
+				i, page->index, iov.iov_base, iov.iov_len);
+			memset(iov.iov_base + len,
+				'\0', PAGE_CACHE_SIZE - len);
+			rdata->tailsz = len;
+			len = 0;
 		} else if (page->index > eof_index) {
 			/*
 			 * The VFS will not try to do readahead past the
@@ -3012,6 +2999,7 @@ cifs_readpages_marshal_iov(struct cifs_readdata *rdata, unsigned int remaining)
 			page_cache_release(page);
 			rdata->pages[i] = NULL;
 			rdata->nr_pages--;
+			continue;
 		} else {
 			/* no need to hold page hostage */
 			lru_cache_add_file(page);
@@ -3019,10 +3007,18 @@ cifs_readpages_marshal_iov(struct cifs_readdata *rdata, unsigned int remaining)
 			page_cache_release(page);
 			rdata->pages[i] = NULL;
 			rdata->nr_pages--;
+			continue;
 		}
+
+		result = cifs_readv_from_socket(server, &iov, 1, iov.iov_len);
+		kunmap(page);
+		if (result < 0)
+			break;
+
+		total_read += result;
 	}
 
-	return len;
+	return total_read > 0 ? total_read : result;
 }
 
 static int cifs_readpages(struct file *file, struct address_space *mapping,
@@ -3146,7 +3142,8 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		rdata->offset = offset;
 		rdata->bytes = bytes;
 		rdata->pid = pid;
-		rdata->marshal_iov = cifs_readpages_marshal_iov;
+		rdata->pagesz = PAGE_CACHE_SIZE;
+		rdata->read_into_pages = cifs_readpages_read_into_pages;
 
 		list_for_each_entry_safe(page, tpage, &tmplist, lru) {
 			list_del(&page->lru);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5d74254..ebd65e6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1300,7 +1300,11 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	struct smb2_hdr *buf = (struct smb2_hdr *)rdata->iov[0].iov_base;
 	unsigned int credits_received = 1;
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
-				 .rq_nvec = rdata->nr_iov };
+				 .rq_nvec = 1,
+				 .rq_pages = rdata->pages,
+				 .rq_npages = rdata->nr_pages,
+				 .rq_pagesz = rdata->pagesz,
+				 .rq_tailsz = rdata->tailsz };
 
 	cFYI(1, "%s: mid=%llu state=%d result=%d bytes=%u", __func__,
 		mid->mid, mid->mid_state, rdata->result, rdata->bytes);
-- 
1.7.11.2
