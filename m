From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 26/50] CIFS: Add address space ops structures for SMB2
Date: Fri, 20 Jan 2012 12:34:47 +0400
Message-ID: <1327048511-2342-26-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsproto.h |   15 +++++++++++++++
 fs/cifs/file.c      |   28 ++++++++++++++--------------
 fs/cifs/smb2file.c  |   30 ++++++++++++++++++++++++++++++
 fs/cifs/smb2inode.c |    4 ++--
 fs/cifs/smb2proto.h |    3 +++
 5 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 76b65dd..9b447a0 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -198,6 +198,21 @@ extern ssize_t cifs_iovec_read_generic(struct file *file,
 				       unsigned long nr_segs, loff_t *poffset,
 				       iread_callback_t *read_cb);
 extern void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
+extern int cifs_write_end(struct file *file, struct address_space *mapping,
+			  loff_t pos, unsigned len, unsigned copied,
+			  struct page *page, void *fsdata);
+extern int cifs_write_begin(struct file *file, struct address_space *mapping,
+			    loff_t pos, unsigned len, unsigned flags,
+			    struct page **pagep, void **fsdata);
+extern int cifs_release_page(struct page *page, gfp_t gfp);
+extern void cifs_invalidate_page(struct page *page, unsigned long offset);
+extern int cifs_launder_page(struct page *page);
+extern int cifs_readpage(struct file *file, struct page *page);
+extern int cifs_readpages(struct file *file, struct address_space *mapping,
+			  struct list_head *page_list, unsigned num_pages);
+extern int cifs_writepages(struct address_space *mapping,
+			   struct writeback_control *wbc);
+extern int cifs_writepage(struct page *page, struct writeback_control *wbc);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b90417e..f8adef8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1720,7 +1720,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	return rc;
 }
 
-static int cifs_writepages(struct address_space *mapping,
+int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(mapping->host->i_sb);
@@ -1958,16 +1958,16 @@ retry_write:
 	return rc;
 }
 
-static int cifs_writepage(struct page *page, struct writeback_control *wbc)
+int cifs_writepage(struct page *page, struct writeback_control *wbc)
 {
 	int rc = cifs_writepage_locked(page, wbc);
 	unlock_page(page);
 	return rc;
 }
 
-static int cifs_write_end(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned copied,
-			struct page *page, void *fsdata)
+int cifs_write_end(struct file *file, struct address_space *mapping, loff_t pos,
+		   unsigned len, unsigned copied, struct page *page,
+		   void *fsdata)
 {
 	int rc;
 	struct inode *inode = mapping->host;
@@ -2652,8 +2652,8 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return rc;
 }
 
-static int cifs_readpages(struct file *file, struct address_space *mapping,
-	struct list_head *page_list, unsigned num_pages)
+int cifs_readpages(struct file *file, struct address_space *mapping,
+		   struct list_head *page_list, unsigned num_pages)
 {
 	int rc;
 	struct list_head tmplist;
@@ -2846,7 +2846,7 @@ read_complete:
 	return rc;
 }
 
-static int cifs_readpage(struct file *file, struct page *page)
+int cifs_readpage(struct file *file, struct page *page)
 {
 	loff_t offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	int rc = -EACCES;
@@ -2916,9 +2916,9 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file)
 		return true;
 }
 
-static int cifs_write_begin(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned flags,
-			struct page **pagep, void **fsdata)
+int cifs_write_begin(struct file *file, struct address_space *mapping,
+		     loff_t pos, unsigned len, unsigned flags,
+		     struct page **pagep, void **fsdata)
 {
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	loff_t offset = pos & (PAGE_CACHE_SIZE - 1);
@@ -2988,7 +2988,7 @@ out:
 	return rc;
 }
 
-static int cifs_release_page(struct page *page, gfp_t gfp)
+int cifs_release_page(struct page *page, gfp_t gfp)
 {
 	if (PagePrivate(page))
 		return 0;
@@ -2996,7 +2996,7 @@ static int cifs_release_page(struct page *page, gfp_t gfp)
 	return cifs_fscache_release_page(page, gfp);
 }
 
-static void cifs_invalidate_page(struct page *page, unsigned long offset)
+void cifs_invalidate_page(struct page *page, unsigned long offset)
 {
 	struct cifsInodeInfo *cifsi = CIFS_I(page->mapping->host);
 
@@ -3004,7 +3004,7 @@ static void cifs_invalidate_page(struct page *page, unsigned long offset)
 		cifs_fscache_invalidate_page(page, &cifsi->vfs_inode);
 }
 
-static int cifs_launder_page(struct page *page)
+int cifs_launder_page(struct page *page)
 {
 	int rc = 0;
 	loff_t range_start = page_offset(page);
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 9829ed7..99d4c5f 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -147,6 +147,36 @@ const struct file_operations smb2_file_direct_nobrl_ops = {
 	.setlease = cifs_setlease,
 };
 
+const struct address_space_operations smb2_addr_ops = {
+	.readpage = cifs_readpage,
+	.readpages = cifs_readpages,
+	.writepage = cifs_writepage,
+	.writepages = cifs_writepages,
+	.write_begin = cifs_write_begin,
+	.write_end = cifs_write_end,
+	.set_page_dirty = __set_page_dirty_nobuffers,
+	.releasepage = cifs_release_page,
+	.invalidatepage = cifs_invalidate_page,
+	.launder_page = cifs_launder_page,
+};
+
+/*
+ * cifs_readpages requires the server to support a buffer large enough to
+ * contain the header plus one complete page of data.  Otherwise, we need
+ * to leave cifs_readpages out of the address space operations.
+ */
+const struct address_space_operations smb2_addr_ops_smallbuf = {
+	.readpage = cifs_readpage,
+	.writepage = cifs_writepage,
+	.writepages = cifs_writepages,
+	.write_begin = cifs_write_begin,
+	.write_end = cifs_write_end,
+	.set_page_dirty = __set_page_dirty_nobuffers,
+	.releasepage = cifs_release_page,
+	.invalidatepage = cifs_invalidate_page,
+	.launder_page = cifs_launder_page,
+};
+
 struct cifsFileInfo *
 smb2_new_fileinfo(__u64 persist_fid, __u64 volatile_fid, struct file *file,
 		  struct tcon_link *tlink, __u32 oplock)
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 97bef79..60e8b1e 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -113,9 +113,9 @@ void smb2_set_ops(struct inode *inode)
 		/* check if server can support readpages */
 		if (cifs_sb_master_tcon(cifs_sb)->ses->server->max_read <
 				PAGE_CACHE_SIZE)
-			inode->i_data.a_ops = &cifs_addr_ops_smallbuf;
+			inode->i_data.a_ops = &smb2_addr_ops_smallbuf;
 		else
-			inode->i_data.a_ops = &cifs_addr_ops;
+			inode->i_data.a_ops = &smb2_addr_ops;
 		break;
 	case S_IFDIR:
 #ifdef CONFIG_CIFS_DFS_UPCALL
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index b477b90..6c73551 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -39,6 +39,9 @@ extern const struct file_operations smb2_file_nobrl_ops; /* no brlocks */
 extern const struct file_operations smb2_file_direct_nobrl_ops;
 extern const struct file_operations smb2_file_strict_nobrl_ops;
 
+extern const struct address_space_operations smb2_addr_ops;
+extern const struct address_space_operations smb2_addr_ops_smallbuf;
+
 /*
  *****************************************************************
  * All Prototypes
-- 
1.7.1
