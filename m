From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 05/16] CIFS: Fix wsize usage in writepages
Date: Fri, 27 Jun 2014 13:57:42 +0400
Message-ID: <1403863073-19526-6-git-send-email-pshilovsky@samba.org>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403863073-19526-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If a server change maximum buffer size for write (wsize) requests
on reconnect we can fail on repeating with a big size buffer on
-EAGAIN error in writepages. Fix this by checking wsize all the
time before repeating request in writepages.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4117da0..21f9be0 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2009,19 +2009,17 @@ wdata_send_pages(struct cifs_writedata *wdata, unsigned int nr_pages,
 			(loff_t)PAGE_CACHE_SIZE);
 	wdata->bytes = ((nr_pages - 1) * PAGE_CACHE_SIZE) + wdata->tailsz;
 
-	do {
-		if (wdata->cfile != NULL)
-			cifsFileInfo_put(wdata->cfile);
-		wdata->cfile = find_writable_file(CIFS_I(mapping->host), false);
-		if (!wdata->cfile) {
-			cifs_dbg(VFS, "No writable handles for inode\n");
-			rc = -EBADF;
-			break;
-		}
+	if (wdata->cfile != NULL)
+		cifsFileInfo_put(wdata->cfile);
+	wdata->cfile = find_writable_file(CIFS_I(mapping->host), false);
+	if (!wdata->cfile) {
+		cifs_dbg(VFS, "No writable handles for inode\n");
+		rc = -EBADF;
+	} else {
 		wdata->pid = wdata->cfile->pid;
 		server = tlink_tcon(wdata->cfile->tlink)->ses->server;
 		rc = server->ops->async_writev(wdata, cifs_writedata_release);
-	} while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
+	}
 
 	for (i = 0; i < nr_pages; ++i)
 		unlock_page(wdata->pages[i]);
@@ -2073,7 +2071,7 @@ static int cifs_writepages(struct address_space *mapping,
 retry:
 	while (!done && index <= end) {
 		unsigned int nr_pages, found_pages;
-		pgoff_t next = 0, tofind;
+		pgoff_t next = 0, tofind, saved_index = index;
 
 		tofind = min((cifs_sb->wsize / PAGE_CACHE_SIZE) - 1,
 				end - index) + 1;
@@ -2102,6 +2100,11 @@ retry:
 		rc = wdata_send_pages(wdata, nr_pages, mapping, wbc);
 		kref_put(&wdata->refcount, cifs_writedata_release);
 
+		if (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN) {
+			index = saved_index;
+			continue;
+		}
+
 		wbc->nr_to_write -= nr_pages;
 		if (wbc->nr_to_write <= 0)
 			done = true;
-- 
1.8.1.2
