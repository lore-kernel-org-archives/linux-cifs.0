From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 5/5] cifs: convert cifs_iovec_read to use async reads
Date: Fri, 13 Apr 2012 22:23:22 -0400
Message-ID: <1334370202-30711-6-git-send-email-jlayton@redhat.com>
References: <1334370202-30711-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334370202-30711-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Convert cifs_iovec_read to use async I/O. This also raises the limit on
the rsize for uncached reads. We first allocate a set of pages to hold
the replies, then issue the reads in parallel and then collect the
replies and copy the results into the iovec.

A possible future optimization would be to kmap and inline the iovec
buffers and read the data directly from the socket into that. That would
require some rather complex conversion of the iovec into a kvec however.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    2 +
 fs/cifs/file.c      |  294 ++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 236 insertions(+), 60 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 63e91c7..eeb789d 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -465,6 +465,8 @@ extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 /* asynchronous read support */
 struct cifs_readdata {
 	struct kref			refcount;
+	struct list_head		list;
+	struct completion		done;
 	struct cifsFileInfo		*cfile;
 	struct address_space		*mapping;
 	__u64				offset;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d2a4259..c53a953 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2348,6 +2348,8 @@ cifs_readdata_alloc(unsigned int nr_vecs, work_func_t complete)
 			sizeof(struct kvec) * nr_vecs, GFP_KERNEL);
 	if (rdata != NULL) {
 		kref_init(&rdata->refcount);
+		INIT_LIST_HEAD(&rdata->list);
+		init_completion(&rdata->done);
 		INIT_WORK(&rdata->work, complete);
 		INIT_LIST_HEAD(&rdata->pages);
 	}
@@ -2367,6 +2369,45 @@ cifs_readdata_release(struct kref *refcount)
 }
 
 static int
+cifs_read_allocate_pages(struct list_head *list, unsigned int npages)
+{
+	int rc = 0;
+	struct page *page, *tpage;
+	unsigned int i;
+
+	for (i = 0; i < npages; i++) {
+		page = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
+		if (!page) {
+			rc = -ENOMEM;
+			break;
+		}
+		list_add(&page->lru, list);
+	}
+
+	if (rc) {
+		list_for_each_entry_safe(page, tpage, list, lru) {
+			list_del(&page->lru);
+			put_page(page);
+		}
+	}
+	return rc;
+}
+
+static void
+cifs_uncached_readdata_release(struct kref *refcount)
+{
+	struct page *page, *tpage;
+	struct cifs_readdata *rdata = container_of(refcount,
+					struct cifs_readdata, refcount);
+
+	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
+		list_del(&page->lru);
+		put_page(page);
+	}
+	cifs_readdata_release(refcount);
+}
+
+static int
 cifs_retry_async_readv(struct cifs_readdata *rdata)
 {
 	int rc;
@@ -2383,24 +2424,139 @@ cifs_retry_async_readv(struct cifs_readdata *rdata)
 	return rc;
 }
 
+/**
+ * cifs_readdata_to_iov - copy data from pages in response to an iovec
+ * @rdata:	the readdata response with list of pages holding data
+ * @iov:	vector in which we should copy the data
+ * @nr_segs:	number of segments in vector
+ * @offset:	offset into file of the first iovec
+ * @copied:	used to return the amount of data copied to the iov
+ *
+ * This function copies data from a list of pages in a readdata response into
+ * an array of iovecs. It will first calculate where the data should go
+ * based on the info in the readdata and then copy the data into that spot.
+ */
+static ssize_t
+cifs_readdata_to_iov(struct cifs_readdata *rdata, const struct iovec *iov,
+			unsigned long nr_segs, loff_t offset, ssize_t *copied)
+{
+	int rc = 0;
+	struct iov_iter ii;
+	size_t pos = rdata->offset - offset;
+	struct page *page, *tpage;
+	ssize_t remaining = rdata->bytes;
+	unsigned char *pdata;
+
+	/* set up iov_iter and advance to the correct offset */
+	iov_iter_init(&ii, iov, nr_segs, iov_length(iov, nr_segs), 0);
+	iov_iter_advance(&ii, pos);
+
+	*copied = 0;
+	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
+		ssize_t copy;
+
+		/* copy a whole page or whatever's left */
+		copy = min_t(ssize_t, remaining, PAGE_SIZE);
+
+		/* ...but limit it to whatever space is left in the iov */
+		copy = min_t(ssize_t, copy, iov_iter_count(&ii));
+
+		/* go while there's data to be copied and no errors */
+		if (copy && !rc) {
+			pdata = kmap(page);
+			rc = memcpy_toiovecend(ii.iov, pdata, ii.iov_offset,
+						(int)copy);
+			kunmap(page);
+			if (!rc) {
+				*copied += copy;
+				remaining -= copy;
+				iov_iter_advance(&ii, copy);
+			}
+		}
+
+		list_del(&page->lru);
+		put_page(page);
+	}
+
+	return rc;
+}
+
+static void
+cifs_uncached_readv_complete(struct work_struct *work)
+{
+	struct cifs_readdata *rdata = container_of(work,
+						struct cifs_readdata, work);
+
+	/* if the result is non-zero then the pages weren't kmapped */
+	if (rdata->result == 0) {
+		struct page *page;
+
+		list_for_each_entry(page, &rdata->pages, lru)
+			kunmap(page);
+	}
+
+	complete(&rdata->done);
+	kref_put(&rdata->refcount, cifs_uncached_readdata_release);
+}
+
+static int
+cifs_uncached_read_marshal_iov(struct cifs_readdata *rdata,
+				unsigned int remaining)
+{
+	int len = 0;
+	struct page *page, *tpage;
+
+	rdata->nr_iov = 1;
+	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
+		if (remaining >= PAGE_SIZE) {
+			/* enough data to fill the page */
+			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
+			rdata->iov[rdata->nr_iov].iov_len = PAGE_SIZE;
+			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
+				rdata->nr_iov, page->index,
+				rdata->iov[rdata->nr_iov].iov_base,
+				rdata->iov[rdata->nr_iov].iov_len);
+			++rdata->nr_iov;
+			len += PAGE_SIZE;
+			remaining -= PAGE_SIZE;
+		} else if (remaining > 0) {
+			/* enough for partial page, fill and zero the rest */
+			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
+			rdata->iov[rdata->nr_iov].iov_len = remaining;
+			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
+				rdata->nr_iov, page->index,
+				rdata->iov[rdata->nr_iov].iov_base,
+				rdata->iov[rdata->nr_iov].iov_len);
+			memset(rdata->iov[rdata->nr_iov].iov_base + remaining,
+				'\0', PAGE_SIZE - remaining);
+			++rdata->nr_iov;
+			len += remaining;
+			remaining = 0;
+		} else {
+			/* no need to hold page hostage */
+			list_del(&page->lru);
+			put_page(page);
+		}
+	}
+
+	return len;
+}
+
 static ssize_t
 cifs_iovec_read(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
-	int rc;
-	int xid;
-	ssize_t total_read;
-	unsigned int bytes_read = 0;
+	ssize_t rc;
 	size_t len, cur_len;
-	int iov_offset = 0;
+	ssize_t total_read = 0;
+	loff_t offset = *poffset;
+	unsigned int npages;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
 	struct cifsFileInfo *open_file;
-	struct smb_com_read_rsp *pSMBr;
-	struct cifs_io_parms io_parms;
-	char *read_data;
-	unsigned int rsize;
-	__u32 pid;
+	struct cifs_readdata *rdata, *tmp;
+	struct list_head rdata_list;
+	pid_t pid;
 
 	if (!nr_segs)
 		return 0;
@@ -2409,14 +2565,10 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	if (!len)
 		return 0;
 
-	xid = GetXid();
+	INIT_LIST_HEAD(&rdata_list);
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-
-	/* FIXME: set up handlers for larger reads and/or convert to async */
-	rsize = min_t(unsigned int, cifs_sb->rsize, CIFSMaxBufSize);
-
 	open_file = file->private_data;
-	pTcon = tlink_tcon(open_file->tlink);
+	tcon = tlink_tcon(open_file->tlink);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
@@ -2426,56 +2578,78 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
 
-	for (total_read = 0; total_read < len; total_read += bytes_read) {
-		cur_len = min_t(const size_t, len - total_read, rsize);
-		rc = -EAGAIN;
-		read_data = NULL;
+	do {
+		cur_len = min_t(const size_t, len - total_read, cifs_sb->rsize);
+		npages = DIV_ROUND_UP(cur_len, PAGE_SIZE);
 
-		while (rc == -EAGAIN) {
-			int buf_type = CIFS_NO_BUFFER;
-			if (open_file->invalidHandle) {
-				rc = cifs_reopen_file(open_file, true);
-				if (rc != 0)
-					break;
-			}
-			io_parms.netfid = open_file->netfid;
-			io_parms.pid = pid;
-			io_parms.tcon = pTcon;
-			io_parms.offset = *poffset;
-			io_parms.length = cur_len;
-			rc = CIFSSMBRead(xid, &io_parms, &bytes_read,
-					 &read_data, &buf_type);
-			pSMBr = (struct smb_com_read_rsp *)read_data;
-			if (read_data) {
-				char *data_offset = read_data + 4 +
-						le16_to_cpu(pSMBr->DataOffset);
-				if (memcpy_toiovecend(iov, data_offset,
-						      iov_offset, bytes_read))
-					rc = -EFAULT;
-				if (buf_type == CIFS_SMALL_BUFFER)
-					cifs_small_buf_release(read_data);
-				else if (buf_type == CIFS_LARGE_BUFFER)
-					cifs_buf_release(read_data);
-				read_data = NULL;
-				iov_offset += bytes_read;
-			}
+		/* allocate a readdata struct */
+		rdata = cifs_readdata_alloc(npages,
+					    cifs_uncached_readv_complete);
+		if (!rdata) {
+			rc = -ENOMEM;
+			goto error;
 		}
 
-		if (rc || (bytes_read == 0)) {
-			if (total_read) {
-				break;
-			} else {
-				FreeXid(xid);
-				return rc;
+		rc = cifs_read_allocate_pages(&rdata->pages, npages);
+		if (rc)
+			goto error;
+
+		rdata->cfile = cifsFileInfo_get(open_file);
+		rdata->offset = offset;
+		rdata->bytes = cur_len;
+		rdata->pid = pid;
+		rdata->marshal_iov = cifs_uncached_read_marshal_iov;
+
+		rc = cifs_retry_async_readv(rdata);
+error:
+		if (rc) {
+			kref_put(&rdata->refcount,
+				 cifs_uncached_readdata_release);
+			break;
+		}
+
+		list_add_tail(&rdata->list, &rdata_list);
+		offset += cur_len;
+		len -= cur_len;
+	} while (len > 0);
+
+	/* if at least one read request send succeeded, then reset rc */
+	if (!list_empty(&rdata_list))
+		rc = 0;
+
+	/* the loop below should proceed in the order of increasing offsets */
+restart_loop:
+	list_for_each_entry_safe(rdata, tmp, &rdata_list, list) {
+		if (!rc) {
+			ssize_t copied;
+
+			/* FIXME: freezable sleep too? */
+			rc = wait_for_completion_killable(&rdata->done);
+			if (rc)
+				rc = -EINTR;
+			else if (rdata->result)
+				rc = rdata->result;
+			else {
+				rc = cifs_readdata_to_iov(rdata, iov,
+							nr_segs, *poffset,
+							&copied);
+				total_read += copied;
 			}
-		} else {
-			cifs_stats_bytes_read(pTcon, bytes_read);
-			*poffset += bytes_read;
+
+                        /* resend call if it's a retryable error */
+                        if (rc == -EAGAIN) {
+                                rc = cifs_retry_async_readv(rdata);
+                                goto restart_loop;
+                        }
 		}
+		list_del_init(&rdata->list);
+		kref_put(&rdata->refcount, cifs_uncached_readdata_release);
 	}
 
-	FreeXid(xid);
-	return total_read;
+	cifs_stats_bytes_read(tcon, total_read);
+	*poffset += total_read;
+
+	return total_read ? total_read : rc;
 }
 
 ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *iov,
-- 
1.7.7.6
