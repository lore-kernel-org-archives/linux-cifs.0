From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 1/2] CIFS: Add launder_page operation (try #2)
Date: Sun, 10 Apr 2011 11:29:44 +0400
Message-ID: <1302420584-4307-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add this let us drop filemap_write_and_wait from cifs_invalidate_mapping
and simplify the code to properly process invalidate logic.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   46 ++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9c7f83f..613f965 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1331,9 +1331,10 @@ retry_write:
 	return rc;
 }
 
-static int cifs_writepage(struct page *page, struct writeback_control *wbc)
+static int
+cifs_writepage_locked(struct page *page, struct writeback_control *wbc)
 {
-	int rc = -EFAULT;
+	int rc;
 	int xid;
 
 	xid = GetXid();
@@ -1353,15 +1354,29 @@ static int cifs_writepage(struct page *page, struct writeback_control *wbc)
 	 * to fail to update with the state of the page correctly.
 	 */
 	set_page_writeback(page);
+retry_write:
 	rc = cifs_partialpagewrite(page, 0, PAGE_CACHE_SIZE);
-	SetPageUptodate(page); /* BB add check for error and Clearuptodate? */
-	unlock_page(page);
+	if (rc == -EAGAIN && wbc->sync_mode == WB_SYNC_ALL)
+		goto retry_write;
+	else if (rc == -EAGAIN)
+		redirty_page_for_writepage(wbc, page);
+	else if (rc != 0)
+		SetPageError(page);
+	else
+		SetPageUptodate(page);
 	end_page_writeback(page);
 	page_cache_release(page);
 	FreeXid(xid);
 	return rc;
 }
 
+static int cifs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	int rc = cifs_writepage_locked(page, wbc);
+	unlock_page(page);
+	return rc;
+}
+
 static int cifs_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
@@ -2344,6 +2359,27 @@ static void cifs_invalidate_page(struct page *page, unsigned long offset)
 		cifs_fscache_invalidate_page(page, &cifsi->vfs_inode);
 }
 
+static int cifs_launder_page(struct page *page)
+{
+	int rc = 0;
+	loff_t range_start = page_offset(page);
+	loff_t range_end = range_start + (loff_t)(PAGE_CACHE_SIZE - 1);
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_ALL,
+		.nr_to_write = 0,
+		.range_start = range_start,
+		.range_end = range_end,
+	};
+
+	cFYI(1, "Launder page: %p", page);
+
+	if (clear_page_dirty_for_io(page))
+		rc = cifs_writepage_locked(page, &wbc);
+
+	cifs_fscache_invalidate_page(page, page->mapping->host);
+	return rc;
+}
+
 void cifs_oplock_break(struct work_struct *work)
 {
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
@@ -2415,6 +2451,7 @@ const struct address_space_operations cifs_addr_ops = {
 	.set_page_dirty = __set_page_dirty_nobuffers,
 	.releasepage = cifs_release_page,
 	.invalidatepage = cifs_invalidate_page,
+	.launder_page = cifs_launder_page,
 	/* .sync_page = cifs_sync_page, */
 	/* .direct_IO = */
 };
@@ -2433,6 +2470,7 @@ const struct address_space_operations cifs_addr_ops_smallbuf = {
 	.set_page_dirty = __set_page_dirty_nobuffers,
 	.releasepage = cifs_release_page,
 	.invalidatepage = cifs_invalidate_page,
+	.launder_page = cifs_launder_page,
 	/* .sync_page = cifs_sync_page, */
 	/* .direct_IO = */
 };
-- 
1.7.1
