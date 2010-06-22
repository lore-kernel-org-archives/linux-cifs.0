From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: [RFC][PATCH 08/10] cifs: store pages into local cache
Date: Tue, 22 Jun 2010 20:54:00 +0530
Message-ID: <1277220240-3674-1-git-send-email-sjayaraman@suse.de>
References: <yes>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <yes>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Store pages from an CIFS inode into the data storage object associated with
that inode.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 fs/cifs/file.c    |    6 ++++++
 fs/cifs/fscache.c |   13 +++++++++++++
 fs/cifs/fscache.h |   11 +++++++++++
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 786ec04..39c1ce0 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2060,6 +2060,8 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 				   we will hit it on next read */
 
 				/* break; */
+				/* send this page to FS-Cache */
+				cifs_readpage_to_fscache(mapping->host, page);
 			}
 		} else {
 			cFYI(1, "No bytes read (%d) at offset %lld . "
@@ -2117,6 +2119,10 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 
 	flush_dcache_page(page);
 	SetPageUptodate(page);
+
+	/* send this page to the cache */
+	cifs_readpage_to_fscache(file->f_path.dentry->d_inode, page);
+
 	rc = 0;
 
 io_error:
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index c09d3b8..13e47d5 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -145,6 +145,19 @@ int cifs_fscache_release_page(struct page *page, gfp_t gfp)
 	return 1;
 }
 
+void __cifs_readpage_to_fscache(struct inode *inode, struct page *page)
+{
+	int ret;
+
+	cFYI(1, "CIFS: readpage_to_fscache(fsc: %p, p: %p, i: %p\n",
+			CIFS_I(inode)->fscache, page, inode);
+	ret = fscache_write_page(CIFS_I(inode)->fscache, page, GFP_KERNEL);
+	cFYI(1, "CIFS: fscache_write_page returned %d\n", ret);
+
+	if (ret != 0)
+		fscache_uncache_page(CIFS_I(inode)->fscache, page);
+}
+
 void __cifs_fscache_invalidate_page(struct page *page, struct inode *inode)
 {
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
index 127cb0a..e34d8ab 100644
--- a/fs/cifs/fscache.h
+++ b/fs/cifs/fscache.h
@@ -50,6 +50,8 @@ extern void cifs_fscache_reset_inode_cookie(struct inode *);
 extern void __cifs_fscache_invalidate_page(struct page *, struct inode *);
 extern int cifs_fscache_release_page(struct page *page, gfp_t gfp);
 
+extern void __cifs_readpage_to_fscache(struct inode *, struct page *);
+
 static inline void cifs_fscache_invalidate_page(struct page *page,
 					       struct inode *inode)
 {
@@ -57,6 +59,13 @@ static inline void cifs_fscache_invalidate_page(struct page *page,
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
@@ -80,6 +89,8 @@ static inline void cifs_fscache_release_page(struct page *page, gfp_t gfp)
 
 static inline int cifs_fscache_invalidate_page(struct page *page,
 			struct inode *) {}
+static inline void cifs_readpage_to_fscache(struct inode *inode,
+			struct page *page) {}
 
 #endif /* CONFIG_CIFS_FSCACHE */
 
-- 
1.6.4.2

