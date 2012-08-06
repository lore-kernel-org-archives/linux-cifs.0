From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 08/15] cifs: convert async write code to pass in data via rq_pages array
Date: Mon,  6 Aug 2012 07:31:05 -0400
Message-ID: <1344252672-15244-9-git-send-email-jlayton@redhat.com>
References: <1344252672-15244-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344252672-15244-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |  4 ++--
 fs/cifs/cifssmb.c  | 39 +++++++++++----------------------------
 fs/cifs/file.c     | 48 ++++++++++--------------------------------------
 fs/cifs/smb2pdu.c  | 37 ++++++++++---------------------------
 4 files changed, 33 insertions(+), 95 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1fd99bc..0f06a57 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -998,8 +998,8 @@ struct cifs_writedata {
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
index 2f86c84..a110e07 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2033,11 +2033,11 @@ cifs_writev_callback(struct mid_q_entry *mid)
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
@@ -2054,15 +2054,6 @@ cifs_async_writev(struct cifs_writedata *wdata)
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
 
@@ -2079,18 +2070,15 @@ cifs_async_writev(struct cifs_writedata *wdata)
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
 
@@ -2106,7 +2094,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 				(struct smb_com_writex_req *)smb;
 		inc_rfc1001_len(&smbw->hdr, wdata->bytes + 5);
 		put_bcc(wdata->bytes + 5, &smbw->hdr);
-		iov[0].iov_len += 4; /* pad bigger by four bytes */
+		iov.iov_len += 4; /* pad bigger by four bytes */
 	}
 
 	kref_get(&wdata->refcount);
@@ -2118,13 +2106,8 @@ cifs_async_writev(struct cifs_writedata *wdata)
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
index 404949a0..3876abb 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1738,27 +1738,6 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
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
@@ -1769,6 +1748,7 @@ static int cifs_writepages(struct address_space *mapping,
 	struct TCP_Server_Info *server;
 	struct page *page;
 	int rc = 0;
+	loff_t isize = i_size_read(mapping->host);
 
 	/*
 	 * If wsize is smaller than the page cache size, default to writing
@@ -1873,7 +1853,7 @@ retry:
 			 */
 			set_page_writeback(page);
 
-			if (page_offset(page) >= mapping->host->i_size) {
+			if (page_offset(page) >= isize) {
 				done = true;
 				unlock_page(page);
 				end_page_writeback(page);
@@ -1904,7 +1884,12 @@ retry:
 		wdata->sync_mode = wbc->sync_mode;
 		wdata->nr_pages = nr_pages;
 		wdata->offset = page_offset(wdata->pages[0]);
-		wdata->marshal_iov = cifs_writepages_marshal_iov;
+		wdata->pagesz = PAGE_CACHE_SIZE;
+		wdata->tailsz =
+			min(isize - page_offset(wdata->pages[nr_pages - 1]),
+			    (loff_t)PAGE_CACHE_SIZE);
+		wdata->bytes = ((nr_pages - 1) * PAGE_CACHE_SIZE) +
+					wdata->tailsz;
 
 		do {
 			if (wdata->cfile != NULL)
@@ -2206,20 +2191,6 @@ size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
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
@@ -2339,7 +2310,8 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 		wdata->cfile = cifsFileInfo_get(open_file);
 		wdata->pid = pid;
 		wdata->bytes = cur_len;
-		wdata->marshal_iov = cifs_uncached_marshal_iov;
+		wdata->pagesz = PAGE_SIZE;
+		wdata->tailsz = cur_len - ((nr_pages - 1) * PAGE_SIZE);
 		rc = cifs_uncached_retry_writev(wdata);
 		if (rc) {
 			kref_put(&wdata->refcount, cifs_writedata_release);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1084dc7..5d74254 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1480,25 +1480,16 @@ smb2_writev_callback(struct mid_q_entry *mid)
 int
 smb2_async_writev(struct cifs_writedata *wdata)
 {
-	int i, rc = -EACCES;
+	int rc = -EACCES;
 	struct smb2_write_req *req = NULL;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
-	struct kvec *iov = NULL;
+	struct kvec iov;
 	struct smb_rqst rqst;
 
 	rc = small_smb2_init(SMB2_WRITE, tcon, (void **) &req);
 	if (rc)
 		goto async_writev_out;
 
-	/* 1 iov per page + 1 for header */
-	iov = kzalloc((wdata->nr_pages + 1) * sizeof(*iov), GFP_NOFS);
-	if (iov == NULL) {
-		rc = -ENOMEM;
-		goto async_writev_out;
-	}
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = wdata->nr_pages + 1;
-
 	req->hdr.ProcessId = cpu_to_le32(wdata->cfile->pid);
 
 	req->PersistentFileId = wdata->cfile->fid.persistent_fid;
@@ -1513,18 +1504,15 @@ smb2_async_writev(struct cifs_writedata *wdata)
 	req->RemainingBytes = 0;
 
 	/* 4 for rfc1002 length field and 1 for Buffer */
-	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
-	iov[0].iov_base = (char *)req;
+	iov.iov_len = get_rfc1002_length(req) + 4 - 1;
+	iov.iov_base = req;
 
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
 
@@ -1539,13 +1527,8 @@ smb2_async_writev(struct cifs_writedata *wdata)
 	if (rc)
 		kref_put(&wdata->refcount, cifs_writedata_release);
 
-	/* send is done, unmap pages */
-	for (i = 0; i < wdata->nr_pages; i++)
-		kunmap(wdata->pages[i]);
-
 async_writev_out:
 	cifs_small_buf_release(req);
-	kfree(iov);
 	return rc;
 }
 
-- 
1.7.11.2
