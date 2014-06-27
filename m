From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 12/16] CIFS: Fix rsize usage in readpages
Date: Fri, 27 Jun 2014 13:57:49 +0400
Message-ID: <1403863073-19526-13-git-send-email-pshilovsky@samba.org>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403863073-19526-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If a server changes maximum buffer size for read (rsize) requests
on reconnect we can fail on repeating with a big size buffer on
-EAGAIN error in readpages. Fix this by checking rsize all the
time before repeating requests.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ee7c547..5f3fa33 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3348,6 +3348,8 @@ readpages_get_pages(struct address_space *mapping, struct list_head *page_list,
 	unsigned int expected_index;
 	int rc;
 
+	INIT_LIST_HEAD(tmplist);
+
 	page = list_entry(page_list->prev, struct page, lru);
 
 	/*
@@ -3403,19 +3405,10 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	struct list_head tmplist;
 	struct cifsFileInfo *open_file = file->private_data;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	unsigned int rsize = cifs_sb->rsize;
+	struct TCP_Server_Info *server;
 	pid_t pid;
 
 	/*
-	 * Give up immediately if rsize is too small to read an entire page.
-	 * The VFS will fall back to readpage. We should never reach this
-	 * point however since we set ra_pages to 0 when the rsize is smaller
-	 * than a cache page.
-	 */
-	if (unlikely(rsize < PAGE_CACHE_SIZE))
-		return 0;
-
-	/*
 	 * Reads as many pages as possible from fscache. Returns -ENOBUFS
 	 * immediately if the cookie is negative
 	 *
@@ -3433,7 +3426,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		pid = current->tgid;
 
 	rc = 0;
-	INIT_LIST_HEAD(&tmplist);
+	server = tlink_tcon(open_file->tlink)->ses->server;
 
 	cifs_dbg(FYI, "%s: file=%p mapping=%p num_pages=%u\n",
 		 __func__, file, mapping, num_pages);
@@ -3455,8 +3448,17 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		struct page *page, *tpage;
 		struct cifs_readdata *rdata;
 
-		rc = readpages_get_pages(mapping, page_list, rsize, &tmplist,
-					 &nr_pages, &offset, &bytes);
+		/*
+		 * Give up immediately if rsize is too small to read an entire
+		 * page. The VFS will fall back to readpage. We should never
+		 * reach this point however since we set ra_pages to 0 when the
+		 * rsize is smaller than a cache page.
+		 */
+		if (unlikely(cifs_sb->rsize < PAGE_CACHE_SIZE))
+			return 0;
+
+		rc = readpages_get_pages(mapping, page_list, cifs_sb->rsize,
+					 &tmplist, &nr_pages, &offset, &bytes);
 		if (rc)
 			break;
 
@@ -3486,15 +3488,24 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 			rdata->pages[rdata->nr_pages++] = page;
 		}
 
-		rc = cifs_retry_async_readv(rdata);
-		if (rc != 0) {
+		if (!rdata->cfile->invalidHandle ||
+		    !cifs_reopen_file(rdata->cfile, true))
+			rc = server->ops->async_readv(rdata);
+		if (rc) {
 			for (i = 0; i < rdata->nr_pages; i++) {
 				page = rdata->pages[i];
 				lru_cache_add_file(page);
 				unlock_page(page);
 				page_cache_release(page);
+				if (rc == -EAGAIN)
+					list_add_tail(&page->lru, &tmplist);
 			}
 			kref_put(&rdata->refcount, cifs_readdata_release);
+			if (rc == -EAGAIN) {
+				/* Re-add pages to the page_list and retry */
+				list_splice(&tmplist, page_list);
+				continue;
+			}
 			break;
 		}
 
-- 
1.8.1.2
