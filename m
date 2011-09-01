From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] cifs: convert cifs_readpages to use async reads
Date: Thu,  1 Sep 2011 17:29:46 -0400
Message-ID: <1314912588-20435-4-git-send-email-jlayton@redhat.com>
References: <1314912588-20435-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314912588-20435-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we have code in place to do asynchronous reads, convert
cifs_readpages to use it. The new cifs_readpages walks the page_list
that gets passed in, locks and adds the pages to the pagecache and
sets up cifs_readdata to handle the reads.

The rest is handled by the cifs_async_readv infrastructure.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |  270 +++++++++++++++++++++-----------------------------------
 1 files changed, 102 insertions(+), 168 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fd57165..8ba82d2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1957,82 +1957,19 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return rc;
 }
 
-
-static void cifs_copy_cache_pages(struct address_space *mapping,
-	struct list_head *pages, int bytes_read, char *data)
-{
-	struct page *page;
-	char *target;
-
-	while (bytes_read > 0) {
-		if (list_empty(pages))
-			break;
-
-		page = list_entry(pages->prev, struct page, lru);
-		list_del(&page->lru);
-
-		if (add_to_page_cache_lru(page, mapping, page->index,
-				      GFP_KERNEL)) {
-			page_cache_release(page);
-			cFYI(1, "Add page cache failed");
-			data += PAGE_CACHE_SIZE;
-			bytes_read -= PAGE_CACHE_SIZE;
-			continue;
-		}
-		page_cache_release(page);
-
-		target = kmap_atomic(page, KM_USER0);
-
-		if (PAGE_CACHE_SIZE > bytes_read) {
-			memcpy(target, data, bytes_read);
-			/* zero the tail end of this partial page */
-			memset(target + bytes_read, 0,
-			       PAGE_CACHE_SIZE - bytes_read);
-			bytes_read = 0;
-		} else {
-			memcpy(target, data, PAGE_CACHE_SIZE);
-			bytes_read -= PAGE_CACHE_SIZE;
-		}
-		kunmap_atomic(target, KM_USER0);
-
-		flush_dcache_page(page);
-		SetPageUptodate(page);
-		unlock_page(page);
-		data += PAGE_CACHE_SIZE;
-
-		/* add page to FS-Cache */
-		cifs_readpage_to_fscache(mapping->host, page);
-	}
-	return;
-}
-
 static int cifs_readpages(struct file *file, struct address_space *mapping,
 	struct list_head *page_list, unsigned num_pages)
 {
-	int rc = -EACCES;
-	int xid;
-	loff_t offset;
-	struct page *page;
-	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *pTcon;
-	unsigned int bytes_read = 0;
-	unsigned int read_size, i;
-	char *smb_read_data = NULL;
-	struct smb_com_read_rsp *pSMBr;
-	struct cifsFileInfo *open_file;
-	struct cifs_io_parms io_parms;
-	int buf_type = CIFS_NO_BUFFER;
-	__u32 pid;
+	int rc;
+	struct list_head tmplist;
+	struct cifsFileInfo *open_file = file->private_data;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	unsigned int rsize = cifs_sb->rsize;
+	pid_t pid;
 
-	xid = GetXid();
-	if (file->private_data == NULL) {
-		rc = -EBADF;
-		FreeXid(xid);
-		return rc;
-	}
-	open_file = file->private_data;
-	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	pTcon = tlink_tcon(open_file->tlink);
+	/* Give up immediately if rsize is too small to read a page */
+	if (rsize < PAGE_CACHE_SIZE)
+		return 0;
 
 	/*
 	 * Reads as many pages as possible from fscache. Returns -ENOBUFS
@@ -2041,125 +1978,122 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	rc = cifs_readpages_from_fscache(mapping->host, mapping, page_list,
 					 &num_pages);
 	if (rc == 0)
-		goto read_complete;
+		return rc;
 
-	cFYI(DBG2, "rpages: num pages %d", num_pages);
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
 
-	for (i = 0; i < num_pages; ) {
-		unsigned contig_pages;
-		struct page *tmp_page;
-		unsigned long expected_index;
+	rc = 0;
+	INIT_LIST_HEAD(&tmplist);
 
-		if (list_empty(page_list))
-			break;
+	cFYI(1, "%s: file=%p mapping=%p num_pages=%u", __func__, file,
+		mapping, num_pages);
+
+	/*
+	 * Start with the page at end of list and move it to private
+	 * list. Do the same with any following pages until we hit
+	 * the rsize limit, hit an index discontinuity, or run out of
+	 * pages. Issue the async read and then start the loop again
+	 * until the list is empty.
+	 *
+	 * Note that list order is important. The page_list is in
+	 * the order of declining indexes. When we put the pages in
+	 * the rdata->pages, then we want them in increasing order.
+	 */
+	while (!list_empty(page_list)) {
+		unsigned int bytes = PAGE_CACHE_SIZE;
+		unsigned int expected_index;
+		unsigned int nr_pages = 1;
+		loff_t offset;
+		struct page *page, *tpage;
+		struct cifs_readdata *rdata;
 
 		page = list_entry(page_list->prev, struct page, lru);
+
+		lock_page(page);
+		rc = add_to_page_cache_locked(page, mapping,
+					      page->index, GFP_KERNEL);
+
+		/* give up if we can't stick it in the cache */
+		if (rc) {
+			unlock_page(page);
+			break;
+		}
+
+		/* move first page to the tmplist */
 		offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
+		list_move(&page->lru, &tmplist);
+
+		/* now try and add more pages onto the request */
+		expected_index = page->index + 1;
+		list_for_each_entry_safe_reverse(page, tpage, page_list, lru) {
+			/* discontinuity ? */
+			if (page->index != expected_index)
+				break;
+
+			/* would this page push the read over the rsize? */
+			if (bytes + PAGE_CACHE_SIZE > rsize)
+				break;
 
-		/* count adjacent pages that we will read into */
-		contig_pages = 0;
-		expected_index =
-			list_entry(page_list->prev, struct page, lru)->index;
-		list_for_each_entry_reverse(tmp_page, page_list, lru) {
-			if (tmp_page->index == expected_index) {
-				contig_pages++;
-				expected_index++;
-			} else
+			lock_page(page);
+			if (add_to_page_cache_locked(page, mapping,
+						page->index, GFP_KERNEL)) {
+				unlock_page(page);
 				break;
+			}
+			list_move_tail(&page->lru, &tmplist);
+			bytes += PAGE_CACHE_SIZE;
+			expected_index++;
+			nr_pages++;
 		}
-		if (contig_pages + i >  num_pages)
-			contig_pages = num_pages - i;
-
-		/* for reads over a certain size could initiate async
-		   read ahead */
-
-		read_size = contig_pages * PAGE_CACHE_SIZE;
-		/* Read size needs to be in multiples of one page */
-		read_size = min_t(const unsigned int, read_size,
-				  cifs_sb->rsize & PAGE_CACHE_MASK);
-		cFYI(DBG2, "rpages: read size 0x%x  contiguous pages %d",
-				read_size, contig_pages);
-		rc = -EAGAIN;
-		while (rc == -EAGAIN) {
+
+		rdata = cifs_readdata_alloc(nr_pages);
+		if (!rdata) {
+			/* best to give up if we're out of mem */
+			list_for_each_entry_safe(page, tpage, &tmplist, lru) {
+				list_del(&page->lru);
+				delete_from_page_cache(page);
+				unlock_page(page);
+				page_cache_release(page);
+			}
+			rc = -ENOMEM;
+			break;
+		}
+
+		spin_lock(&cifs_file_list_lock);
+		cifsFileInfo_get(open_file);
+		spin_unlock(&cifs_file_list_lock);
+		rdata->cfile = open_file;
+		rdata->mapping = mapping;
+		rdata->offset = offset;
+		rdata->bytes = bytes;
+		rdata->pid = pid;
+		list_splice_init(&tmplist, &rdata->pages);
+
+		do {
 			if (open_file->invalidHandle) {
 				rc = cifs_reopen_file(open_file, true);
 				if (rc != 0)
-					break;
-			}
-			io_parms.netfid = open_file->netfid;
-			io_parms.pid = pid;
-			io_parms.tcon = pTcon;
-			io_parms.offset = offset;
-			io_parms.length = read_size;
-			rc = CIFSSMBRead(xid, &io_parms, &bytes_read,
-					 &smb_read_data, &buf_type);
-			/* BB more RC checks ? */
-			if (rc == -EAGAIN) {
-				if (smb_read_data) {
-					if (buf_type == CIFS_SMALL_BUFFER)
-						cifs_small_buf_release(smb_read_data);
-					else if (buf_type == CIFS_LARGE_BUFFER)
-						cifs_buf_release(smb_read_data);
-					smb_read_data = NULL;
-				}
+					continue;
 			}
-		}
-		if ((rc < 0) || (smb_read_data == NULL)) {
-			cFYI(1, "Read error in readpages: %d", rc);
-			break;
-		} else if (bytes_read > 0) {
-			task_io_account_read(bytes_read);
-			pSMBr = (struct smb_com_read_rsp *)smb_read_data;
-			cifs_copy_cache_pages(mapping, page_list, bytes_read,
-				smb_read_data + 4 /* RFC1001 hdr */ +
-				le16_to_cpu(pSMBr->DataOffset));
-
-			i +=  bytes_read >> PAGE_CACHE_SHIFT;
-			cifs_stats_bytes_read(pTcon, bytes_read);
-			if ((bytes_read & PAGE_CACHE_MASK) != bytes_read) {
-				i++; /* account for partial page */
-
-				/* server copy of file can have smaller size
-				   than client */
-				/* BB do we need to verify this common case ?
-				   this case is ok - if we are at server EOF
-				   we will hit it on next read */
+			rc = cifs_async_readv(rdata);
+		} while (rc == -EAGAIN);
 
-				/* break; */
+		if (rc != 0) {
+			list_for_each_entry_safe(page, tpage, &rdata->pages,
+						 lru) {
+				list_del(&page->lru);
+				delete_from_page_cache(page);
+				unlock_page(page);
+				page_cache_release(page);
 			}
-		} else {
-			cFYI(1, "No bytes read (%d) at offset %lld . "
-				"Cleaning remaining pages from readahead list",
-				bytes_read, offset);
-			/* BB turn off caching and do new lookup on
-			   file size at server? */
+			cifs_readdata_free(rdata);
 			break;
 		}
-		if (smb_read_data) {
-			if (buf_type == CIFS_SMALL_BUFFER)
-				cifs_small_buf_release(smb_read_data);
-			else if (buf_type == CIFS_LARGE_BUFFER)
-				cifs_buf_release(smb_read_data);
-			smb_read_data = NULL;
-		}
-		bytes_read = 0;
-	}
-
-/* need to free smb_read_data buf before exit */
-	if (smb_read_data) {
-		if (buf_type == CIFS_SMALL_BUFFER)
-			cifs_small_buf_release(smb_read_data);
-		else if (buf_type == CIFS_LARGE_BUFFER)
-			cifs_buf_release(smb_read_data);
-		smb_read_data = NULL;
 	}
 
-read_complete:
-	FreeXid(xid);
 	return rc;
 }
 
-- 
1.7.6
