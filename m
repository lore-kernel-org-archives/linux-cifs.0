From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v3 01/16] CIFS: Add support for direct pages in rdata
Date: Sat,  8 Sep 2018 02:13:33 +0000
Message-ID: <20180908021348.19956-2-longli@linuxonhyperv.com>
References: <20180908021348.19956-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180908021348.19956-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Add a function to allocate rdata without allocating pages for data
transfer. This gives the caller an option to pass a number of pages
that point to the data buffer.

rdata is reponsible for free those pages after it's done.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsglob.h |  3 +--
 fs/cifs/file.c     | 23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 80a34ce..166e140 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1173,14 +1173,13 @@ struct cifs_readdata {
 	struct kvec			iov[2];
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	struct smbd_mr			*mr;
-	struct page			**direct_pages;
 #endif
 	unsigned int			pagesz;
 	unsigned int			page_offset;
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
