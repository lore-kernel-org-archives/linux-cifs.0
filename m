From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: [PATCH 08/09] cifs: read pages from FS-Cache
Date: Mon,  5 Jul 2010 18:13:25 +0530
Message-ID: <1278333805-30839-1-git-send-email-sjayaraman@suse.de>
References: <Yes>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-cachefs@redhat.com, David Howells <dhowells@redhat.com>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Yes>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Read pages from a FS-Cache data storage object into a CIFS inode.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Acked-by: David Howells <dhowells@redhat.com>
---
 fs/cifs/file.c    |   17 ++++++++++++
 fs/cifs/fscache.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/fscache.h |   40 ++++++++++++++++++++++++++++-
 3 files changed, 129 insertions(+), 1 deletion(-)

Index: cifs-2.6/fs/cifs/file.c
===================================================================
--- cifs-2.6.orig/fs/cifs/file.c
+++ cifs-2.6/fs/cifs/file.c
@@ -1981,6 +1981,15 @@ static int cifs_readpages(struct file *f
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	pTcon = cifs_sb->tcon;
 
+	/*
+	 * Reads as many pages as possible from fscache. Returns -ENOBUFS
+	 * immediately if the cookie is negative
+	 */
+	rc = cifs_readpages_from_fscache(mapping->host, mapping, page_list,
+					 &num_pages);
+	if (rc == 0)
+		goto read_complete;
+
 	cFYI(DBG2, "rpages: num pages %d", num_pages);
 	for (i = 0; i < num_pages; ) {
 		unsigned contig_pages;
@@ -2091,6 +2100,7 @@ static int cifs_readpages(struct file *f
 		smb_read_data = NULL;
 	}
 
+read_complete:
 	FreeXid(xid);
 	return rc;
 }
@@ -2101,6 +2111,11 @@ static int cifs_readpage_worker(struct f
 	char *read_data;
 	int rc;
 
+	/* Is the page cached? */
+	rc = cifs_readpage_from_fscache(file->f_path.dentry->d_inode, page);
+	if (rc == 0)
+		goto read_complete;
+
 	page_cache_get(page);
 	read_data = kmap(page);
 	/* for reads over a certain size could initiate async read ahead */
@@ -2129,6 +2144,8 @@ static int cifs_readpage_worker(struct f
 io_error:
 	kunmap(page);
 	page_cache_release(page);
+
+read_complete:
 	return rc;
 }
 
Index: cifs-2.6/fs/cifs/fscache.c
===================================================================
--- cifs-2.6.orig/fs/cifs/fscache.c
+++ cifs-2.6/fs/cifs/fscache.c
@@ -140,6 +140,79 @@ int cifs_fscache_release_page(struct pag
 	return 1;
 }
 
+static void cifs_readpage_from_fscache_complete(struct page *page, void *ctx,
+						int error)
+{
+	cFYI(1, "CFS: readpage_from_fscache_complete (0x%p/%d)",
+			page, error);
+	if (!error)
+		SetPageUptodate(page);
+	unlock_page(page);
+}
+
+/*
+ * Retrieve a page from FS-Cache
+ */
+int __cifs_readpage_from_fscache(struct inode *inode, struct page *page)
+{
+	int ret;
+
+	cFYI(1, "CIFS: readpage_from_fscache(fsc:%p, p:%p, i:0x%p",
+			CIFS_I(inode)->fscache, page, inode);
+	ret = fscache_read_or_alloc_page(CIFS_I(inode)->fscache, page,
+					 cifs_readpage_from_fscache_complete,
+					 NULL,
+					 GFP_KERNEL);
+	switch (ret) {
+
+	case 0: /* page found in fscache, read submitted */
+		cFYI(1, "CIFS: readpage_from_fscache: submitted");
+		return ret;
+	case -ENOBUFS:	/* page won't be cached */
+	case -ENODATA:	/* page not in cache */
+		cFYI(1, "CIFS: readpage_from_fscache %d", ret);
+		return 1;
+
+	default:
+		cERROR(1, "unknown error ret = %d", ret);
+	}
+	return ret;
+}
+
+/*
+ * Retrieve a set of pages from FS-Cache
+ */
+int __cifs_readpages_from_fscache(struct inode *inode,
+				struct address_space *mapping,
+				struct list_head *pages,
+				unsigned *nr_pages)
+{
+	int ret;
+
+	cFYI(1, "CIFS: __cifs_readpages_from_fscache (0x%p/%u/0x%p)",
+			CIFS_I(inode)->fscache, *nr_pages, inode);
+	ret = fscache_read_or_alloc_pages(CIFS_I(inode)->fscache, mapping,
+					  pages, nr_pages,
+					  cifs_readpage_from_fscache_complete,
+					  NULL,
+					  mapping_gfp_mask(mapping));
+	switch (ret) {
+	case 0:	/* read submitted to the cache for all pages */
+		cFYI(1, "CIFS: readpages_from_fscache: submitted");
+		return ret;
+
+	case -ENOBUFS:	/* some pages are not cached and can't be */
+	case -ENODATA:	/* some pages are not cached */
+		cFYI(1, "CIFS: readpages_from_fscache: no page");
+		return 1;
+
+	default:
+		cFYI(1, "unknown error ret = %d", ret);
+	}
+
+	return ret;
+}
+
 void __cifs_readpage_to_fscache(struct inode *inode, struct page *page)
 {
 	int ret;
Index: cifs-2.6/fs/cifs/fscache.h
===================================================================
--- cifs-2.6.orig/fs/cifs/fscache.h
+++ cifs-2.6/fs/cifs/fscache.h
@@ -32,7 +32,6 @@ extern const struct fscache_cookie_def c
 extern const struct fscache_cookie_def cifs_fscache_super_index_def;
 extern const struct fscache_cookie_def cifs_fscache_inode_object_def;
 
-
 extern int cifs_fscache_register(void);
 extern void cifs_fscache_unregister(void);
 
@@ -50,6 +49,11 @@ extern void cifs_fscache_reset_inode_coo
 
 extern void __cifs_fscache_invalidate_page(struct page *, struct inode *);
 extern int cifs_fscache_release_page(struct page *page, gfp_t gfp);
+extern int __cifs_readpage_from_fscache(struct inode *, struct page *);
+extern int __cifs_readpages_from_fscache(struct inode *,
+					 struct address_space *,
+					 struct list_head *,
+					 unsigned *);
 
 extern void __cifs_readpage_to_fscache(struct inode *, struct page *);
 
@@ -60,6 +64,26 @@ static inline void cifs_fscache_invalida
 		__cifs_fscache_invalidate_page(page, inode);
 }
 
+static inline int cifs_readpage_from_fscache(struct inode *inode,
+					     struct page *page)
+{
+	if (CIFS_I(inode)->fscache)
+		return __cifs_readpage_from_fscache(inode, page);
+
+	return -ENOBUFS;
+}
+
+static inline int cifs_readpages_from_fscache(struct inode *inode,
+					      struct address_space *mapping,
+					      struct list_head *pages,
+					      unsigned *nr_pages)
+{
+	if (CIFS_I(inode)->fscache)
+		return __cifs_readpages_from_fscache(inode, mapping, pages,
+						     nr_pages);
+	return -ENOBUFS;
+}
+
 static inline void cifs_readpage_to_fscache(struct inode *inode,
 					    struct page *page)
 {
@@ -90,6 +114,20 @@ static inline void cifs_fscache_release_
 
 static inline int cifs_fscache_invalidate_page(struct page *page,
 			struct inode *) {}
+static inline int
+cifs_readpage_from_fscache(struct inode *inode, struct page *page)
+{
+	return -ENOBUFS;
+}
+
+static inline int cifs_readpages_from_fscache(struct inode *inode,
+					      struct address_space *mapping,
+					      struct list_head *pages,
+					      unsigned *nr_pages)
+{
+	return -ENOBUFS;
+}
+
 static inline void cifs_readpage_to_fscache(struct inode *inode,
 			struct page *page) {}
 
