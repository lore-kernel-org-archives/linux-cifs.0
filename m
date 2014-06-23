From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/9] CIFS: Separate page sending from writepages
Date: Mon, 23 Jun 2014 18:58:30 +0400
Message-ID: <1403535517-8301-3-git-send-email-pshilovsky@samba.org>
References: <1403535517-8301-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403535517-8301-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c |   98 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 53 insertions(+), 45 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 216959e..f143a4f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1958,6 +1958,58 @@ wdata_prepare_pages(struct cifs_writedata *wdata, unsigned int found_pages,
 	return nr_pages;
 }
 
+static int
+wdata_send_pages(struct cifs_writedata *wdata, unsigned int nr_pages,
+		 struct address_space *mapping, struct writeback_control *wbc)
+{
+	int rc = 0;
+	struct TCP_Server_Info *server;
+	unsigned int i;
+
+	wdata->sync_mode = wbc->sync_mode;
+	wdata->nr_pages = nr_pages;
+	wdata->offset = page_offset(wdata->pages[0]);
+	wdata->pagesz = PAGE_CACHE_SIZE;
+	wdata->tailsz = min(i_size_read(mapping->host) -
+			page_offset(wdata->pages[nr_pages - 1]),
+			(loff_t)PAGE_CACHE_SIZE);
+	wdata->bytes = ((nr_pages - 1) * PAGE_CACHE_SIZE) + wdata->tailsz;
+
+	do {
+		if (wdata->cfile != NULL)
+			cifsFileInfo_put(wdata->cfile);
+		wdata->cfile = find_writable_file(CIFS_I(mapping->host), false);
+		if (!wdata->cfile) {
+			cifs_dbg(VFS, "No writable handles for inode\n");
+			rc = -EBADF;
+			break;
+		}
+		wdata->pid = wdata->cfile->pid;
+		server = tlink_tcon(wdata->cfile->tlink)->ses->server;
+		rc = server->ops->async_writev(wdata, cifs_writedata_release);
+	} while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
+
+	for (i = 0; i < nr_pages; ++i)
+		unlock_page(wdata->pages[i]);
+
+	if (!rc)
+		return rc;
+
+	/* send failure -- clean up the mess */
+	for (i = 0; i < nr_pages; ++i) {
+		if (rc == -EAGAIN)
+			redirty_page_for_writepage(wbc, wdata->pages[i]);
+		else
+			SetPageError(wdata->pages[i]);
+		end_page_writeback(wdata->pages[i]);
+		page_cache_release(wdata->pages[i]);
+	}
+	if (rc != -EAGAIN)
+		mapping_set_error(mapping, rc);
+
+	return rc;
+}
+
 static int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
@@ -1965,7 +2017,6 @@ static int cifs_writepages(struct address_space *mapping,
 	bool done = false, scanned = false, range_whole = false;
 	pgoff_t end, index;
 	struct cifs_writedata *wdata;
-	struct TCP_Server_Info *server;
 	int rc = 0;
 
 	/*
@@ -2032,50 +2083,7 @@ retry:
 			continue;
 		}
 
-		wdata->sync_mode = wbc->sync_mode;
-		wdata->nr_pages = nr_pages;
-		wdata->offset = page_offset(wdata->pages[0]);
-		wdata->pagesz = PAGE_CACHE_SIZE;
-		wdata->tailsz =
-			min(i_size_read(mapping->host) -
-			    page_offset(wdata->pages[nr_pages - 1]),
-			    (loff_t)PAGE_CACHE_SIZE);
-		wdata->bytes = ((nr_pages - 1) * PAGE_CACHE_SIZE) +
-					wdata->tailsz;
-
-		do {
-			if (wdata->cfile != NULL)
-				cifsFileInfo_put(wdata->cfile);
-			wdata->cfile = find_writable_file(CIFS_I(mapping->host),
-							  false);
-			if (!wdata->cfile) {
-				cifs_dbg(VFS, "No writable handles for inode\n");
-				rc = -EBADF;
-				break;
-			}
-			wdata->pid = wdata->cfile->pid;
-			server = tlink_tcon(wdata->cfile->tlink)->ses->server;
-			rc = server->ops->async_writev(wdata,
-							cifs_writedata_release);
-		} while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
-
-		for (i = 0; i < nr_pages; ++i)
-			unlock_page(wdata->pages[i]);
-
-		/* send failure -- clean up the mess */
-		if (rc != 0) {
-			for (i = 0; i < nr_pages; ++i) {
-				if (rc == -EAGAIN)
-					redirty_page_for_writepage(wbc,
-							   wdata->pages[i]);
-				else
-					SetPageError(wdata->pages[i]);
-				end_page_writeback(wdata->pages[i]);
-				page_cache_release(wdata->pages[i]);
-			}
-			if (rc != -EAGAIN)
-				mapping_set_error(mapping, rc);
-		}
+		rc = wdata_send_pages(wdata, nr_pages, mapping, wbc);
 		kref_put(&wdata->refcount, cifs_writedata_release);
 
 		wbc->nr_to_write -= nr_pages;
-- 
1.7.10.4
