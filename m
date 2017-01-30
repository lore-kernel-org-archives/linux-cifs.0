From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 12/15] CIFS: Add copy into pages callback for a read operation
Date: Mon, 30 Jan 2017 13:39:41 -0800
Message-ID: <1485812384-28870-13-git-send-email-pshilov@microsoft.com>
References: <1485812384-28870-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485812384-28870-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since we have two different types of reads (pagecache and direct)
we need to process such responses differently after decryption of
a packet. The change allows to specify a callback that copies a read
payload data into preallocated pages.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h |  3 +++
 fs/cifs/file.c     | 52 ++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index dc41ae4..fa56f47 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1127,6 +1127,9 @@ struct cifs_readdata {
 	int (*read_into_pages)(struct TCP_Server_Info *server,
 				struct cifs_readdata *rdata,
 				unsigned int len);
+	int (*copy_into_pages)(struct TCP_Server_Info *server,
+				struct cifs_readdata *rdata,
+				struct iov_iter *iter);
 	struct kvec			iov[2];
 	unsigned int			pagesz;
 	unsigned int			tailsz;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7e23261..d7c5a2c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2910,8 +2910,9 @@ cifs_uncached_readv_complete(struct work_struct *work)
 }
 
 static int
-cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
-			struct cifs_readdata *rdata, unsigned int len)
+uncached_fill_pages(struct TCP_Server_Info *server,
+		    struct cifs_readdata *rdata, struct iov_iter *iter,
+		    unsigned int len)
 {
 	int result = 0;
 	unsigned int i;
@@ -2940,7 +2941,10 @@ cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
 			rdata->tailsz = len;
 			len = 0;
 		}
-		result = cifs_read_page_from_socket(server, page, n);
+		if (iter)
+			result = copy_page_from_iter(page, 0, n, iter);
+		else
+			result = cifs_read_page_from_socket(server, page, n);
 		if (result < 0)
 			break;
 
@@ -2952,6 +2956,21 @@ cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
 }
 
 static int
+cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
+			      struct cifs_readdata *rdata, unsigned int len)
+{
+	return uncached_fill_pages(server, rdata, NULL, len);
+}
+
+static int
+cifs_uncached_copy_into_pages(struct TCP_Server_Info *server,
+			      struct cifs_readdata *rdata,
+			      struct iov_iter *iter)
+{
+	return uncached_fill_pages(server, rdata, iter, iter->count);
+}
+
+static int
 cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 		     struct cifs_sb_info *cifs_sb, struct list_head *rdata_list)
 {
@@ -2998,6 +3017,7 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 		rdata->pid = pid;
 		rdata->pagesz = PAGE_SIZE;
 		rdata->read_into_pages = cifs_uncached_read_into_pages;
+		rdata->copy_into_pages = cifs_uncached_copy_into_pages;
 		rdata->credits = credits;
 
 		if (!rdata->cfile->invalidHandle ||
@@ -3348,8 +3368,9 @@ cifs_readv_complete(struct work_struct *work)
 }
 
 static int
-cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
-			struct cifs_readdata *rdata, unsigned int len)
+readpages_fill_pages(struct TCP_Server_Info *server,
+		     struct cifs_readdata *rdata, struct iov_iter *iter,
+		     unsigned int len)
 {
 	int result = 0;
 	unsigned int i;
@@ -3403,7 +3424,10 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 			continue;
 		}
 
-		result = cifs_read_page_from_socket(server, page, n);
+		if (iter)
+			result = copy_page_from_iter(page, 0, n, iter);
+		else
+			result = cifs_read_page_from_socket(server, page, n);
 		if (result < 0)
 			break;
 
@@ -3415,6 +3439,21 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 }
 
 static int
+cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
+			       struct cifs_readdata *rdata, unsigned int len)
+{
+	return readpages_fill_pages(server, rdata, NULL, len);
+}
+
+static int
+cifs_readpages_copy_into_pages(struct TCP_Server_Info *server,
+			       struct cifs_readdata *rdata,
+			       struct iov_iter *iter)
+{
+	return readpages_fill_pages(server, rdata, iter, iter->count);
+}
+
+static int
 readpages_get_pages(struct address_space *mapping, struct list_head *page_list,
 		    unsigned int rsize, struct list_head *tmplist,
 		    unsigned int *nr_pages, loff_t *offset, unsigned int *bytes)
@@ -3568,6 +3607,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		rdata->pid = pid;
 		rdata->pagesz = PAGE_SIZE;
 		rdata->read_into_pages = cifs_readpages_read_into_pages;
+		rdata->copy_into_pages = cifs_readpages_copy_into_pages;
 		rdata->credits = credits;
 
 		list_for_each_entry_safe(page, tpage, &tmplist, lru) {
-- 
2.7.4
