From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: set mapping error when page writeback fails in writepage or launder_pages
Date: Thu, 25 May 2017 06:59:52 -0400
Message-ID: <20170525105952.8867-1-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/cifs/file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0fd081bd2a2f..5009860dbdc6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2234,14 +2234,16 @@ cifs_writepage_locked(struct page *page, struct writeback_control *wbc)
 	set_page_writeback(page);
 retry_write:
 	rc = cifs_partialpagewrite(page, 0, PAGE_SIZE);
-	if (rc == -EAGAIN && wbc->sync_mode == WB_SYNC_ALL)
-		goto retry_write;
-	else if (rc == -EAGAIN)
+	if (rc == -EAGAIN) {
+		if (wbc->sync_mode == WB_SYNC_ALL)
+			goto retry_write;
 		redirty_page_for_writepage(wbc, page);
-	else if (rc != 0)
+	} else if (rc != 0) {
 		SetPageError(page);
-	else
+		mapping_set_error(page->mapping, rc);
+	} else {
 		SetPageUptodate(page);
+	}
 	end_page_writeback(page);
 	put_page(page);
 	free_xid(xid);
-- 
2.9.4
