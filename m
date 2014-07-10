From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 7/7] CIFS: Optimize readpages in a short read case on reconnects
Date: Thu, 10 Jul 2014 13:30:47 +0400
Message-ID: <1404984647-8710-8-git-send-email-pshilovsky@samba.org>
References: <1404984647-8710-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404984647-8710-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

by marking pages with a data from a partially received response up-to-date.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d7246cb..d225895 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3280,25 +3280,30 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 static void
 cifs_readv_complete(struct work_struct *work)
 {
-	unsigned int i;
+	unsigned int i, got_bytes;
 	struct cifs_readdata *rdata = container_of(work,
 						struct cifs_readdata, work);
 
+	got_bytes = rdata->got_bytes;
 	for (i = 0; i < rdata->nr_pages; i++) {
 		struct page *page = rdata->pages[i];
 
 		lru_cache_add_file(page);
 
-		if (rdata->result == 0) {
+		if (rdata->result == 0 ||
+		    (rdata->result == -EAGAIN && got_bytes)) {
 			flush_dcache_page(page);
 			SetPageUptodate(page);
 		}
 
 		unlock_page(page);
 
-		if (rdata->result == 0)
+		if (rdata->result == 0 ||
+		    (rdata->result == -EAGAIN && got_bytes))
 			cifs_readpage_to_fscache(rdata->mapping->host, page);
 
+		got_bytes -= min_t(unsigned int, PAGE_CACHE_SIZE, got_bytes);
+
 		page_cache_release(page);
 		rdata->pages[i] = NULL;
 	}
-- 
1.8.1.2
