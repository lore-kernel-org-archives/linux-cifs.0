From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v3 03/16] CIFS: Add support for direct pages in wdata
Date: Sat,  8 Sep 2018 02:13:35 +0000
Message-ID: <20180908021348.19956-4-longli@linuxonhyperv.com>
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

Add a function to allocate wdata without allocating pages for data
transfer. This gives the caller an option to pass a number of pages that
point to the data buffer to write to.

wdata is reponsible for free those pages after it's done.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsglob.h  |  3 +--
 fs/cifs/cifsproto.h |  2 ++
 fs/cifs/cifssmb.c   | 17 ++++++++++++++---
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 166e140..7f62c98 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1199,14 +1199,13 @@ struct cifs_writedata {
 	int				result;
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
 
 /*
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1f27d8e..7933c5f 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -533,6 +533,8 @@ int cifs_async_writev(struct cifs_writedata *wdata,
 void cifs_writev_complete(struct work_struct *work);
 struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages,
 						work_func_t complete);
+struct cifs_writedata *cifs_writedata_direct_alloc(struct page **pages,
+						work_func_t complete);
 void cifs_writedata_release(struct kref *refcount);
 int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			  struct cifs_sb_info *cifs_sb,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a1af258..503e0ed 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1953,6 +1953,7 @@ cifs_writedata_release(struct kref *refcount)
 	if (wdata->cfile)
 		cifsFileInfo_put(wdata->cfile);
 
+	kvfree(wdata->pages);
 	kfree(wdata);
 }
 
@@ -2076,12 +2077,22 @@ cifs_writev_complete(struct work_struct *work)
 struct cifs_writedata *
 cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete)
 {
+	struct page **pages =
+		kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
+	if (pages)
+		return cifs_writedata_direct_alloc(pages, complete);
+
+	return NULL;
+}
+
+struct cifs_writedata *
+cifs_writedata_direct_alloc(struct page **pages, work_func_t complete)
+{
 	struct cifs_writedata *wdata;
 
-	/* writedata + number of page pointers */
-	wdata = kzalloc(sizeof(*wdata) +
-			sizeof(struct page *) * nr_pages, GFP_NOFS);
+	wdata = kzalloc(sizeof(*wdata), GFP_NOFS);
 	if (wdata != NULL) {
+		wdata->pages = pages;
 		kref_init(&wdata->refcount);
 		INIT_LIST_HEAD(&wdata->list);
 		init_completion(&wdata->done);
-- 
2.7.4
