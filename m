From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 06/09] cifs: FS-Cache page management
Date: Mon,  5 Jul 2010 18:13:00 +0530
Message-ID: <1278333780-30746-1-git-send-email-sjayaraman@suse.de>
References: <Yes>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yes>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Takes care of invalidation and release of FS-Cache marked pages and also
invalidation of the FsCache page flag when the inode is removed.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cache.c   |   31 +++++++++++++++++++++++++++++++
 fs/cifs/file.c    |   20 ++++++++++++++++++++
 fs/cifs/fscache.c |   26 ++++++++++++++++++++++++++
 fs/cifs/fscache.h |   16 ++++++++++++++++
 4 files changed, 93 insertions(+)

Index: cifs-2.6/fs/cifs/cache.c
===================================================================
--- cifs-2.6.orig/fs/cifs/cache.c
+++ cifs-2.6/fs/cifs/cache.c
@@ -290,6 +290,36 @@ fscache_checkaux cifs_fscache_inode_chec
 	return FSCACHE_CHECKAUX_OKAY;
 }
 
+static void cifs_fscache_inode_now_uncached(void *cookie_netfs_data)
+{
+	struct cifsInodeInfo *cifsi = cookie_netfs_data;
+	struct pagevec pvec;
+	pgoff_t first;
+	int loop, nr_pages;
+
+	pagevec_init(&pvec, 0);
+	first = 0;
+
+	cFYI(1, "cifs inode 0x%p now uncached", cifsi);
+
+	for (;;) {
+		nr_pages = pagevec_lookup(&pvec,
+					  cifsi->vfs_inode.i_mapping, first,
+					  PAGEVEC_SIZE - pagevec_count(&pvec));
+		if (!nr_pages)
+			break;
+
+		for (loop = 0; loop < nr_pages; loop++)
+			ClearPageFsCache(pvec.pages[loop]);
+
+		first = pvec.pages[nr_pages - 1]->index + 1;
+
+		pvec.nr = nr_pages;
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+}
+
 const struct fscache_cookie_def cifs_fscache_inode_object_def = {
 	.name		= "CIFS.uniqueid",
 	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
@@ -297,4 +327,5 @@ const struct fscache_cookie_def cifs_fsc
 	.get_attr	= cifs_fscache_inode_get_attr,
 	.get_aux	= cifs_fscache_inode_get_aux,
 	.check_aux	= cifs_fscache_inode_check_aux,
+	.now_uncached	= cifs_fscache_inode_now_uncached,
 };
Index: cifs-2.6/fs/cifs/file.c
===================================================================
--- cifs-2.6.orig/fs/cifs/file.c
+++ cifs-2.6/fs/cifs/file.c
@@ -2271,6 +2271,22 @@ out:
 	return rc;
 }
 
+static int cifs_release_page(struct page *page, gfp_t gfp)
+{
+	if (PagePrivate(page))
+		return 0;
+
+	return cifs_fscache_release_page(page, gfp);
+}
+
+static void cifs_invalidate_page(struct page *page, unsigned long offset)
+{
+	struct cifsInodeInfo *cifsi = CIFS_I(page->mapping->host);
+
+	if (offset == 0)
+		cifs_fscache_invalidate_page(page, &cifsi->vfs_inode);
+}
+
 static void
 cifs_oplock_break(struct slow_work *work)
 {
@@ -2344,6 +2360,8 @@ const struct address_space_operations ci
 	.write_begin = cifs_write_begin,
 	.write_end = cifs_write_end,
 	.set_page_dirty = __set_page_dirty_nobuffers,
+	.releasepage = cifs_release_page,
+	.invalidatepage = cifs_invalidate_page,
 	/* .sync_page = cifs_sync_page, */
 	/* .direct_IO = */
 };
@@ -2360,6 +2378,8 @@ const struct address_space_operations ci
 	.write_begin = cifs_write_begin,
 	.write_end = cifs_write_end,
 	.set_page_dirty = __set_page_dirty_nobuffers,
+	.releasepage = cifs_release_page,
+	.invalidatepage = cifs_invalidate_page,
 	/* .sync_page = cifs_sync_page, */
 	/* .direct_IO = */
 };
Index: cifs-2.6/fs/cifs/fscache.c
===================================================================
--- cifs-2.6.orig/fs/cifs/fscache.c
+++ cifs-2.6/fs/cifs/fscache.c
@@ -124,3 +124,29 @@ void cifs_fscache_reset_inode_cookie(str
 				cifsi->fscache, old);
 	}
 }
+
+int cifs_fscache_release_page(struct page *page, gfp_t gfp)
+{
+	if (PageFsCache(page)) {
+		struct inode *inode = page->mapping->host;
+		struct cifsInodeInfo *cifsi = CIFS_I(inode);
+
+		cFYI(1, "CIFS: fscache release page (0x%p/0x%p)",
+				page, cifsi->fscache);
+		if (!fscache_maybe_release_page(cifsi->fscache, page, gfp))
+			return 0;
+	}
+
+	return 1;
+}
+
+void __cifs_fscache_invalidate_page(struct page *page, struct inode *inode)
+{
+	struct cifsInodeInfo *cifsi = CIFS_I(inode);
+	struct fscache_cookie *cookie = cifsi->fscache;
+
+	cFYI(1, "CIFS: fscache invalidatepage (0x%p/0x%p)", page, cookie);
+	fscache_wait_on_page_write(cookie, page);
+	fscache_uncache_page(cookie, page);
+}
+
Index: cifs-2.6/fs/cifs/fscache.h
===================================================================
--- cifs-2.6.orig/fs/cifs/fscache.h
+++ cifs-2.6/fs/cifs/fscache.h
@@ -48,6 +48,16 @@ extern void cifs_fscache_release_inode_c
 extern void cifs_fscache_set_inode_cookie(struct inode *, struct file *);
 extern void cifs_fscache_reset_inode_cookie(struct inode *);
 
+extern void __cifs_fscache_invalidate_page(struct page *, struct inode *);
+extern int cifs_fscache_release_page(struct page *page, gfp_t gfp);
+
+static inline void cifs_fscache_invalidate_page(struct page *page,
+					       struct inode *inode)
+{
+	if (PageFsCache(page))
+		__cifs_fscache_invalidate_page(page, inode);
+}
+
 #else /* CONFIG_CIFS_FSCACHE */
 static inline int cifs_fscache_register(void) { return 0; }
 static inline void cifs_fscache_unregister(void) {}
@@ -64,7 +74,13 @@ static inline void cifs_fscache_release_
 static inline void cifs_fscache_set_inode_cookie(struct inode *inode,
 						 struct file *filp) {}
 static inline void cifs_fscache_reset_inode_cookie(struct inode *inode) {}
+static inline void cifs_fscache_release_page(struct page *page, gfp_t gfp)
+{
+	return 1; /* May release page */
+}
 
+static inline int cifs_fscache_invalidate_page(struct page *page,
+			struct inode *) {}
 
 #endif /* CONFIG_CIFS_FSCACHE */
 
