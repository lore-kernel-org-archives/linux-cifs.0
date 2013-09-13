From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cifs: Avoid calling unlock_page() twice in cifs_readpage() when using fscache
Date: Fri, 13 Sep 2013 14:11:57 +0100
Message-ID: <1379077917-31017-3-git-send-email-sprabhu@redhat.com>
References: <1379077917-31017-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379077917-31017-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When reading a single page with cifs_readpage(), we make a call to
fscache_read_or_alloc_page() which once done, asynchronously calls
the completion function cifs_readpage_from_fscache_complete(). This
completion function unlocks the page once it has been populated from
cache. The module then attempts to unlock the page a second time in
cifs_readpage() which leads to warning messages.

In case of a successful call to fscache_read_or_alloc_page() we should skip
the second unlock_page() since this will be called by the
cifs_readpage_from_fscache_complete() once the page has been populated by
fscache.

With the modifications to cifs_readpage_worker(), we will need to re-grab the
page lock in cifs_write_begin().

The problem was first noticed when testing new fscache patches for cifs.
https://bugzilla.redhat.com/show_bug.cgi?id=1005737

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e47c379..7b5d0cb 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3424,6 +3424,7 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 
 io_error:
 	kunmap(page);
+	unlock_page(page);
 
 read_complete:
 	return rc;
@@ -3448,8 +3449,6 @@ static int cifs_readpage(struct file *file, struct page *page)
 
 	rc = cifs_readpage_worker(file, page, &offset);
 
-	unlock_page(page);
-
 	free_xid(xid);
 	return rc;
 }
@@ -3503,6 +3502,7 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
+	int oncethru = 0;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	loff_t offset = pos & (PAGE_CACHE_SIZE - 1);
 	loff_t page_start = pos & PAGE_MASK;
@@ -3512,6 +3512,7 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
 
 	cifs_dbg(FYI, "write_begin from %lld len %d\n", (long long)pos, len);
 
+start:
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
 		rc = -ENOMEM;
@@ -3553,13 +3554,16 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
 		}
 	}
 
-	if ((file->f_flags & O_ACCMODE) != O_WRONLY) {
+	if ((file->f_flags & O_ACCMODE) != O_WRONLY && !oncethru) {
 		/*
 		 * might as well read a page, it is fast enough. If we get
 		 * an error, we don't need to return it. cifs_write_end will
 		 * do a sync write instead since PG_uptodate isn't set.
 		 */
 		cifs_readpage_worker(file, page, &page_start);
+		page_cache_release(page);
+		oncethru = 1;
+		goto start;
 	} else {
 		/* we could try using another file handle if there is one -
 		   but how would we lock it to prevent close of that handle
-- 
1.8.3.1
