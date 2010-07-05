From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 07/09] cifs: store pages into local cache
Date: Mon,  5 Jul 2010 18:13:11 +0530
Message-ID: <1278333791-30792-1-git-send-email-sjayaraman@suse.de>
References: <Yes>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yes>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Store pages from an CIFS inode into the data storage object associated with
that inode.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/file.c    |    7 +++++++
 fs/cifs/fscache.c |   11 +++++++++++
 fs/cifs/fscache.h |   11 +++++++++++
 3 files changed, 29 insertions(+)

Index: cifs-2.6/fs/cifs/file.c
===================================================================
--- cifs-2.6.orig/fs/cifs/file.c
+++ cifs-2.6/fs/cifs/file.c
@@ -1948,6 +1948,9 @@ static void cifs_copy_cache_pages(struct
 		SetPageUptodate(page);
 		unlock_page(page);
 		data += PAGE_CACHE_SIZE;
+
+		/* add page to FS-Cache */
+		cifs_readpage_to_fscache(mapping->host, page);
 	}
 	return;
 }
@@ -2117,6 +2120,10 @@ static int cifs_readpage_worker(struct f
 
 	flush_dcache_page(page);
 	SetPageUptodate(page);
+
+	/* send this page to the cache */
+	cifs_readpage_to_fscache(file->f_path.dentry->d_inode, page);
+
 	rc = 0;
 
 io_error:
Index: cifs-2.6/fs/cifs/fscache.c
===================================================================
--- cifs-2.6.orig/fs/cifs/fscache.c
+++ cifs-2.6/fs/cifs/fscache.c
@@ -140,6 +140,17 @@ int cifs_fscache_release_page(struct pag
 	return 1;
 }
 
+void __cifs_readpage_to_fscache(struct inode *inode, struct page *page)
+{
+	int ret;
+
+	cFYI(1, "CIFS: readpage_to_fscache(fsc: %p, p: %p, i: %p",
+			CIFS_I(inode)->fscache, page, inode);
+	ret = fscache_write_page(CIFS_I(inode)->fscache, page, GFP_KERNEL);
+	if (ret != 0)
+		fscache_uncache_page(CIFS_I(inode)->fscache, page);
+}
+
 void __cifs_fscache_invalidate_page(struct page *page, struct inode *inode)
 {
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
Index: cifs-2.6/fs/cifs/fscache.h
===================================================================
--- cifs-2.6.orig/fs/cifs/fscache.h
+++ cifs-2.6/fs/cifs/fscache.h
@@ -51,6 +51,8 @@ extern void cifs_fscache_reset_inode_coo
 extern void __cifs_fscache_invalidate_page(struct page *, struct inode *);
 extern int cifs_fscache_release_page(struct page *page, gfp_t gfp);
 
+extern void __cifs_readpage_to_fscache(struct inode *, struct page *);
+
 static inline void cifs_fscache_invalidate_page(struct page *page,
 					       struct inode *inode)
 {
@@ -58,6 +60,13 @@ static inline void cifs_fscache_invalida
 		__cifs_fscache_invalidate_page(page, inode);
 }
 
+static inline void cifs_readpage_to_fscache(struct inode *inode,
+					    struct page *page)
+{
+	if (PageFsCache(page))
+		__cifs_readpage_to_fscache(inode, page);
+}
+
 #else /* CONFIG_CIFS_FSCACHE */
 static inline int cifs_fscache_register(void) { return 0; }
 static inline void cifs_fscache_unregister(void) {}
@@ -81,6 +90,8 @@ static inline void cifs_fscache_release_
 
 static inline int cifs_fscache_invalidate_page(struct page *page,
 			struct inode *) {}
+static inline void cifs_readpage_to_fscache(struct inode *inode,
+			struct page *page) {}
 
 #endif /* CONFIG_CIFS_FSCACHE */
 
