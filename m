From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: don't try to unlock pagecache page after releasing it
Date: Mon,  4 Mar 2013 15:18:25 -0500
Message-ID: <1362428305-26502-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We had a recent fix to fix the release of pagecache pages when
cifs_writev_requeue writes fail. Unfortunately, it releases the page
before trying to unlock it. At that point, the page might be gone by the
time the unlock comes in.

Unlock the page first before checking the value of "rc", and only then
end writeback and release the pages. The page lock isn't required for
any of those operations so this should be safe.

Reported-by: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 7353bc5..8e2e799 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1909,12 +1909,12 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 	} while (rc == -EAGAIN);
 
 	for (i = 0; i < wdata->nr_pages; i++) {
+		unlock_page(wdata->pages[i]);
 		if (rc != 0) {
 			SetPageError(wdata->pages[i]);
 			end_page_writeback(wdata->pages[i]);
 			page_cache_release(wdata->pages[i]);
 		}
-		unlock_page(wdata->pages[i]);
 	}
 
 	mapping_set_error(inode->i_mapping, rc);
-- 
1.7.11.7
