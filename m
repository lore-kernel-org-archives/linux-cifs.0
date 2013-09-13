From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cifs: Do not take a reference to the page in cifs_readpage_worker()
Date: Fri, 13 Sep 2013 14:11:56 +0100
Message-ID: <1379077917-31017-2-git-send-email-sprabhu@redhat.com>
References: <1379077917-31017-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379077917-31017-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We do not need to take a reference to the pagecache in
cifs_readpage_worker() since the calling function will have already
taken one before passing the pointer to the page as an argument to the
function.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 69e8431..e47c379 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3384,6 +3384,9 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	return rc;
 }
 
+/*
+ * cifs_readpage_worker must be called with the page pinned
+ */
 static int cifs_readpage_worker(struct file *file, struct page *page,
 	loff_t *poffset)
 {
@@ -3395,7 +3398,6 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 	if (rc == 0)
 		goto read_complete;
 
-	page_cache_get(page);
 	read_data = kmap(page);
 	/* for reads over a certain size could initiate async read ahead */
 
@@ -3422,7 +3424,6 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 
 io_error:
 	kunmap(page);
-	page_cache_release(page);
 
 read_complete:
 	return rc;
-- 
1.8.3.1
