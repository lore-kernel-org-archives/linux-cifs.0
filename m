From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v2 02/15] CIFS: Add support for direct pages in rdata
Date: Wed, 30 May 2018 12:47:54 -0700
Message-ID: <20180530194807.31657-3-longli@linuxonhyperv.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Add a function to allocate rdata without allocating pages for data
transfer. This gives the caller an option to pass a number of pages
that point to the data buffer.

rdata is still reponsible for free those pages after it's done.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsglob.h |  2 +-
 fs/cifs/file.c     | 23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8d16c3e..56864a87 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1179,7 +1179,7 @@ struct cifs_readdata {
 	unsigned int			tailsz;
 	unsigned int			credits;
 	unsigned int			nr_pages;
-	struct page			*pages[];
+	struct page			**pages;
 };
 
 struct cifs_writedata;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 23fd430..1c98293 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2880,13 +2880,13 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 }
 
 static struct cifs_readdata *
-cifs_readdata_alloc(unsigned int nr_pages, work_func_t complete)
+cifs_readdata_direct_alloc(struct page **pages, work_func_t complete)
 {
 	struct cifs_readdata *rdata;
 
-	rdata = kzalloc(sizeof(*rdata) + (sizeof(struct page *) * nr_pages),
-			GFP_KERNEL);
+	rdata = kzalloc(sizeof(*rdata), GFP_KERNEL);
 	if (rdata != NULL) {
+		rdata->pages = pages;
 		kref_init(&rdata->refcount);
 		INIT_LIST_HEAD(&rdata->list);
 		init_completion(&rdata->done);
@@ -2896,6 +2896,22 @@ cifs_readdata_alloc(unsigned int nr_pages, work_func_t complete)
 	return rdata;
 }
 
+static struct cifs_readdata *
+cifs_readdata_alloc(unsigned int nr_pages, work_func_t complete)
+{
+	struct page **pages =
+		kzalloc(sizeof(struct page *) * nr_pages, GFP_KERNEL);
+	struct cifs_readdata *ret = NULL;
+
+	if (pages) {
+		ret = cifs_readdata_direct_alloc(pages, complete);
+		if (!ret)
+			kfree(pages);
+	}
+
+	return ret;
+}
+
 void
 cifs_readdata_release(struct kref *refcount)
 {
@@ -2910,6 +2926,7 @@ cifs_readdata_release(struct kref *refcount)
 	if (rdata->cfile)
 		cifsFileInfo_put(rdata->cfile);
 
+	kvfree(rdata->pages);
 	kfree(rdata);
 }
 
-- 
2.7.4
