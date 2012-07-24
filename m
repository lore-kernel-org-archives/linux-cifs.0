From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 09/11] cifs: convert async write code to pass in data via rq_pages array
Date: Tue, 24 Jul 2012 13:37:52 -0400
Message-ID: <1343151472-12862-1-git-send-email-jlayton@redhat.com>
References: <CAKywueTO3OCTV8M4Lo1kSpfZjyHDPDxRZthE-URkr=5=ow-Z2g@mail.gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTO3OCTV8M4Lo1kSpfZjyHDPDxRZthE-URkr=5=ow-Z2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    4 ++--
 fs/cifs/cifssmb.c   |   39 +++++++++++----------------------------
 fs/cifs/file.c      |   47 +++++++++--------------------------------------
 3 files changed, 22 insertions(+), 68 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index a2cf97b..77bcdba 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -516,8 +516,8 @@ struct cifs_writedata {
 	pid_t				pid;
 	unsigned int			bytes;
 	int				result;
-	void (*marshal_iov) (struct kvec *iov,
-			     struct cifs_writedata *wdata);
+	unsigned int			pagesz;
+	unsigned int			tailsz;
 	unsigned int			nr_pages;
 	struct page			*pages[1];
 };
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 7e51ec6..7826c78 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2048,11 +2048,11 @@ cifs_writev_callback(struct mid_q_entry *mid)
 int
 cifs_async_writev(struct cifs_writedata *wdata)
 {
-	int i, rc = -EACCES;
+	int rc = -EACCES;
 	WRITE_REQ *smb = NULL;
 	int wct;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
-	struct kvec *iov = NULL;
+	struct kvec iov;
 	struct smb_rqst rqst = { };
 
 	if (tcon->ses->capabilities & CAP_LARGE_FILES) {
@@ -2069,15 +2069,6 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	if (rc)
 		goto async_writev_out;
 
-	/* 1 iov per page + 1 for header */
-	rqst.rq_nvec = wdata->nr_pages + 1;
-	iov = kzalloc((rqst.rq_nvec) * sizeof(*iov), GFP_NOFS);
-	if (iov == NULL) {
-		rc = -ENOMEM;
-		goto async_writev_out;
-	}
-	rqst.rq_iov = iov;
-
 	smb->hdr.Pid = cpu_to_le16((__u16)wdata->pid);
 	smb->hdr.PidHigh = cpu_to_le16((__u16)(wdata->pid >> 16));
 
@@ -2094,18 +2085,15 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	    cpu_to_le16(offsetof(struct smb_com_write_req, Data) - 4);
 
 	/* 4 for RFC1001 length + 1 for BCC */
-	iov[0].iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4 + 1;
-	iov[0].iov_base = smb;
+	iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4 + 1;
+	iov.iov_base = smb;
 
-	/*
-	 * This function should marshal up the page array into the kvec
-	 * array, reserving [0] for the header. It should kmap the pages
-	 * and set the iov_len properly for each one. It may also set
-	 * wdata->bytes too.
-	 */
-	cifs_kmap_lock();
-	wdata->marshal_iov(iov, wdata);
-	cifs_kmap_unlock();
+	rqst.rq_iov = &iov;
+	rqst.rq_nvec = 1;
+	rqst.rq_pages = wdata->pages;
+	rqst.rq_npages = wdata->nr_pages;
+	rqst.rq_pagesz = wdata->pagesz;
+	rqst.rq_tailsz = wdata->tailsz;
 
 	cFYI(1, "async write at %llu %u bytes", wdata->offset, wdata->bytes);
 
@@ -2121,7 +2109,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 				(struct smb_com_writex_req *)smb;
 		inc_rfc1001_len(&smbw->hdr, wdata->bytes + 5);
 		put_bcc(wdata->bytes + 5, &smbw->hdr);
-		iov[0].iov_len += 4; /* pad bigger by four bytes */
+		iov.iov_len += 4; /* pad bigger by four bytes */
 	}
 
 	kref_get(&wdata->refcount);
@@ -2133,13 +2121,8 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	else
 		kref_put(&wdata->refcount, cifs_writedata_release);
 
-	/* send is done, unmap pages */
-	for (i = 0; i < wdata->nr_pages; i++)
-		kunmap(wdata->pages[i]);
-
 async_writev_out:
 	cifs_small_buf_release(smb);
-	kfree(iov);
 	return rc;
 }
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1d5a268..88ddd1e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1708,27 +1708,6 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	return rc;
 }
 
-/*
- * Marshal up the iov array, reserving the first one for the header. Also,
- * set wdata->bytes.
- */
-static void
-cifs_writepages_marshal_iov(struct kvec *iov, struct cifs_writedata *wdata)
-{
-	int i;
-	struct inode *inode = wdata->cfile->dentry->d_inode;
-	loff_t size = i_size_read(inode);
-
-	/* marshal up the pages into iov array */
-	wdata->bytes = 0;
-	for (i = 0; i < wdata->nr_pages; i++) {
-		iov[i + 1].iov_len = min(size - page_offset(wdata->pages[i]),
-					(loff_t)PAGE_CACHE_SIZE);
-		iov[i + 1].iov_base = kmap(wdata->pages[i]);
-		wdata->bytes += iov[i + 1].iov_len;
-	}
-}
-
 static int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
@@ -1738,6 +1717,7 @@ static int cifs_writepages(struct address_space *mapping,
 	struct cifs_writedata *wdata;
 	struct page *page;
 	int rc = 0;
+	loff_t isize = i_size_read(mapping->host);
 
 	/*
 	 * If wsize is smaller than the page cache size, default to writing
@@ -1842,7 +1822,7 @@ retry:
 			 */
 			set_page_writeback(page);
 
-			if (page_offset(page) >= mapping->host->i_size) {
+			if (page_offset(page) >= isize) {
 				done = true;
 				unlock_page(page);
 				end_page_writeback(page);
@@ -1873,7 +1853,11 @@ retry:
 		wdata->sync_mode = wbc->sync_mode;
 		wdata->nr_pages = nr_pages;
 		wdata->offset = page_offset(wdata->pages[0]);
-		wdata->marshal_iov = cifs_writepages_marshal_iov;
+		wdata->pagesz = PAGE_CACHE_SIZE;
+		wdata->tailsz = min(isize - page_offset(wdata->pages[nr_pages - 1]),
+					(loff_t)PAGE_CACHE_SIZE);
+		wdata->bytes = ((nr_pages - 1) * PAGE_CACHE_SIZE) +
+					wdata->tailsz;
 
 		do {
 			if (wdata->cfile != NULL)
@@ -2162,20 +2146,6 @@ size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
 }
 
 static void
-cifs_uncached_marshal_iov(struct kvec *iov, struct cifs_writedata *wdata)
-{
-	int i;
-	size_t bytes = wdata->bytes;
-
-	/* marshal up the pages into iov array */
-	for (i = 0; i < wdata->nr_pages; i++) {
-		iov[i + 1].iov_len = min_t(size_t, bytes, PAGE_SIZE);
-		iov[i + 1].iov_base = kmap(wdata->pages[i]);
-		bytes -= iov[i + 1].iov_len;
-	}
-}
-
-static void
 cifs_uncached_writev_complete(struct work_struct *work)
 {
 	int i;
@@ -2288,7 +2258,8 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 		wdata->cfile = cifsFileInfo_get(open_file);
 		wdata->pid = pid;
 		wdata->bytes = cur_len;
-		wdata->marshal_iov = cifs_uncached_marshal_iov;
+		wdata->pagesz = PAGE_SIZE;
+		wdata->tailsz = cur_len - ((nr_pages - 1) * PAGE_SIZE);
 		rc = cifs_uncached_retry_writev(wdata);
 		if (rc) {
 			kref_put(&wdata->refcount, cifs_writedata_release);
-- 
1.7.10.4
