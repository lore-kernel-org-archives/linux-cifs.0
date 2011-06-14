From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: add list_to_page macro and use it
Date: Tue, 14 Jun 2011 21:39:26 +0530
Message-ID: <4DF787B6.1090104@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/file.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e960072..37f7e00 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -42,6 +42,8 @@
 #include "cifs_fs_sb.h"
 #include "fscache.h"
 
+#define list_to_page(head) (list_entry((head)->prev, struct page, lru))
+
 static inline int cifs_convert_flags(unsigned int flags)
 {
 	if ((flags & O_ACCMODE) == O_RDONLY)
@@ -1954,7 +1956,7 @@ static void cifs_copy_cache_pages(struct address_space *mapping,
 		if (list_empty(pages))
 			break;
 
-		page = list_entry(pages->prev, struct page, lru);
+		page = list_to_page(pages);
 		list_del(&page->lru);
 
 		if (add_to_page_cache_lru(page, mapping, page->index,
@@ -2043,13 +2045,13 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		if (list_empty(page_list))
 			break;
 
-		page = list_entry(page_list->prev, struct page, lru);
+		page = list_to_page(page_list);
 		offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
 
 		/* count adjacent pages that we will read into */
 		contig_pages = 0;
 		expected_index =
-			list_entry(page_list->prev, struct page, lru)->index;
+			list_to_page(page_list)->index;
 		list_for_each_entry_reverse(tmp_page, page_list, lru) {
 			if (tmp_page->index == expected_index) {
 				contig_pages++;
