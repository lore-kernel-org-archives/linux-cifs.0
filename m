From: Long Li <longli@linuxonhyperv.com>
Subject: [RFC PATCH 03/09] Change rdata alloc to support direct pages
Date: Thu, 17 May 2018 17:22:08 -0700
Message-ID: <20180518002214.5657-4-longli@linuxonhyperv.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518002214.5657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

There is no need to allocate pages when using pages directly from user buffer

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/file.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a6ec896..ed25e04 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2880,11 +2880,15 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 }
 
 static struct cifs_readdata *
-cifs_readdata_alloc(unsigned int nr_pages, work_func_t complete)
+cifs_readdata_alloc(unsigned int nr_pages, struct page **direct_pages, work_func_t complete)
 {
 	struct cifs_readdata *rdata;
 
-	rdata = kzalloc(sizeof(*rdata) + (sizeof(struct page *) * nr_pages),
+	if (direct_pages) {
+		rdata = kzalloc(sizeof(*rdata), GFP_KERNEL);
+		rdata->direct_pages = direct_pages;
+	} else
+		rdata = kzalloc(sizeof(*rdata) + (sizeof(struct page *) * nr_pages),
 			GFP_KERNEL);
 	if (rdata != NULL) {
 		kref_init(&rdata->refcount);
@@ -3095,14 +3099,13 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 		npages = DIV_ROUND_UP(cur_len, PAGE_SIZE);
 
 		/* allocate a readdata struct */
-		rdata = cifs_readdata_alloc(npages,
+		rdata = cifs_readdata_alloc(npages, NULL,
 					    cifs_uncached_readv_complete);
 		if (!rdata) {
 			add_credits_and_wake_if(server, credits, 0);
 			rc = -ENOMEM;
 			break;
 		}
-
 		rc = cifs_read_allocate_pages(rdata, npages);
 		if (rc)
 			goto error;
@@ -3770,7 +3773,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 			break;
 		}
 
-		rdata = cifs_readdata_alloc(nr_pages, cifs_readv_complete);
+		rdata = cifs_readdata_alloc(nr_pages, NULL, cifs_readv_complete);
 		if (!rdata) {
 			/* best to give up if we're out of mem */
 			list_for_each_entry_safe(page, tpage, &tmplist, lru) {
-- 
2.7.4
