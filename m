From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix error handling in cifs_readv_complete
Date: Fri, 21 Oct 2011 10:14:04 +0400
Message-ID: <1319177644-2551-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In cifs_readv_receive we don't update rdata->result to error value
after kmap'ing a page. We should kunmap the page in the no error
case only.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifssmb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 949e121..5c81cd4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1667,9 +1667,9 @@ cifs_readv_complete(struct work_struct *work)
 	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
 		list_del(&page->lru);
 		lru_cache_add_file(page);
-		kunmap(page);
 
 		if (rdata->result == 0) {
+			kunmap(page);
 			flush_dcache_page(page);
 			SetPageUptodate(page);
 		}
-- 
1.7.1
