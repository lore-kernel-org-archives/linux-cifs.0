From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 7/8] cifs: abstract out function to marshal up the iovec array for async writes
Date: Fri,  3 Feb 2012 09:33:00 -0500
Message-ID: <1328279581-21889-8-git-send-email-jlayton@redhat.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We'll need to do something a bit different depending on the caller.
Abstract the code that marshals the page array into an iovec.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    2 ++
 fs/cifs/cifssmb.c   |   17 +++++++----------
 fs/cifs/file.c      |   22 ++++++++++++++++++++++
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index ff528f3..bceadc5 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -480,6 +480,8 @@ struct cifs_writedata {
 	pid_t				pid;
 	unsigned int			bytes;
 	int				result;
+	void (*marshal_iov) (struct kvec *iov,
+			     struct cifs_writedata *wdata);
 	unsigned int			nr_pages;
 	struct page			*pages[1];
 };
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e03a650..113b5af 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2098,7 +2098,6 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	WRITE_REQ *smb = NULL;
 	int wct;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
-	struct inode *inode = wdata->cfile->dentry->d_inode;
 	struct kvec *iov = NULL;
 
 	if (tcon->ses->capabilities & CAP_LARGE_FILES) {
@@ -2141,15 +2140,13 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	iov[0].iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4 + 1;
 	iov[0].iov_base = smb;
 
-	/* marshal up the pages into iov array */
-	wdata->bytes = 0;
-	for (i = 0; i < wdata->nr_pages; i++) {
-		iov[i + 1].iov_len = min(inode->i_size -
-				      page_offset(wdata->pages[i]),
-					(loff_t)PAGE_CACHE_SIZE);
-		iov[i + 1].iov_base = kmap(wdata->pages[i]);
-		wdata->bytes += iov[i + 1].iov_len;
-	}
+	/*
+	 * This function should marshal up the page array into the kvec
+	 * array, reserving [0] for the header. It should kmap the pages
+	 * and set the iov_len properly for each one. It may also set
+	 * wdata->bytes too.
+	 */
+	wdata->marshal_iov(iov, wdata);
 
 	cFYI(1, "async write at %llu %u bytes", wdata->offset, wdata->bytes);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 264e99c..c7e47a2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1604,6 +1604,27 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	return rc;
 }
 
+/*
+ * Marshal up the iov array, reserving the first one for the header. Also,
+ * set wdata->bytes.
+ */
+static void
+cifs_writepages_marshal_iov(struct kvec *iov, struct cifs_writedata *wdata)
+{
+	int i;
+	struct inode *inode = wdata->cfile->dentry->d_inode;
+	loff_t size = i_size_read(inode);
+
+	/* marshal up the pages into iov array */
+	wdata->bytes = 0;
+	for (i = 0; i < wdata->nr_pages; i++) {
+		iov[i + 1].iov_len = min(size - page_offset(wdata->pages[i]),
+					(loff_t)PAGE_CACHE_SIZE);
+		iov[i + 1].iov_base = kmap(wdata->pages[i]);
+		wdata->bytes += iov[i + 1].iov_len;
+	}
+}
+
 static int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
@@ -1748,6 +1769,7 @@ retry:
 		wdata->sync_mode = wbc->sync_mode;
 		wdata->nr_pages = nr_pages;
 		wdata->offset = page_offset(wdata->pages[0]);
+		wdata->marshal_iov = cifs_writepages_marshal_iov;
 
 		do {
 			if (wdata->cfile != NULL)
-- 
1.7.7.6
