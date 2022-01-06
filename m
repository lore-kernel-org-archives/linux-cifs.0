Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD078C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jan 2022 21:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239110AbiAFVcT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:32:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39695 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244236AbiAFVcT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Jan 2022 16:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641504738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bZ+uP3i2HIIL83Jha0USkkIYjKNg1rDkMjmaw4ssGIw=;
        b=BbwkJNpJovXFdAMYEwnY00AwfpGL66vQhid46uw/2l86TLiWJN2r063YOX5u9aE0LWJEBa
        zY8P4Ttu+/nQvXq1JmbbUPTjJe4ndiOiSzoYiHMjSn0RDeKquttJbXDmm++NqeKkCWLsjC
        rxmwcvayxDG0gnHATxH8kNKVvkN5lqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-ZZrU4t-LMEyKYqL10iGjmw-1; Thu, 06 Jan 2022 16:32:15 -0500
X-MC-Unique: ZZrU4t-LMEyKYqL10iGjmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 315E3102C84E;
        Thu,  6 Jan 2022 21:32:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37DB6519CC;
        Thu,  6 Jan 2022 21:32:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH v2 1/3] cifs: Use netfslib
From:   David Howells <dhowells@redhat.com>
To:     smfrench@gmail.com
Cc:     nspmangalore@gmail.com, dhowells@redhat.com, jlayton@kernel.org,
        linux-cifs@vger.kernel.org, linux-cachefs@redhat.com
Date:   Thu, 06 Jan 2022 21:32:07 +0000
Message-ID: <164150472733.2994594.3384212286033434409.stgit@warthog.procyon.org.uk>
In-Reply-To: <164150471440.2994594.16990036181824162931.stgit@warthog.procyon.org.uk>
References: <164150471440.2994594.16990036181824162931.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


---

 fs/cifs/Kconfig     |    1 
 fs/cifs/cifsglob.h  |    2 
 fs/cifs/cifsproto.h |    3 
 fs/cifs/cifssmb.c   |   16 +
 fs/cifs/connect.c   |   18 +-
 fs/cifs/file.c      |  582 ++++++++++++++-------------------------------------
 fs/cifs/fscache.c   |   35 ---
 fs/cifs/fscache.h   |   52 -----
 fs/cifs/smb2pdu.c   |   10 +
 9 files changed, 201 insertions(+), 518 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 3b7e3b9e4fd2..c47e2d3a101f 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -2,6 +2,7 @@
 config CIFS
 	tristate "SMB3 and CIFS support (advanced network filesystem)"
 	depends on INET
+	select NETFS_SUPPORT
 	select NLS
 	select CRYPTO
 	select CRYPTO_MD5
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ba6fbb1ad8f3..a5edae959f60 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1320,6 +1320,7 @@ struct cifs_aio_ctx {
 
 /* asynchronous read support */
 struct cifs_readdata {
+	struct netfs_read_subrequest	*subreq;
 	struct kref			refcount;
 	struct list_head		list;
 	struct completion		done;
@@ -1338,6 +1339,7 @@ struct cifs_readdata {
 	int (*copy_into_pages)(struct TCP_Server_Info *server,
 				struct cifs_readdata *rdata,
 				struct iov_iter *iter);
+	struct iov_iter			iter;
 	struct kvec			iov[2];
 	struct TCP_Server_Info		*server;
 #ifdef CONFIG_CIFS_SMB_DIRECT
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 4f5a3e857df4..99c239dca807 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -237,6 +237,9 @@ extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
 					unsigned int page_offset,
 					unsigned int to_read);
 extern int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb);
+extern int cifs_read_iter_from_socket(struct TCP_Server_Info *server,
+				      struct iov_iter *iter,
+				      unsigned int to_read);
 extern int cifs_match_super(struct super_block *, void *);
 extern int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx);
 extern void cifs_umount(struct cifs_sb_info *);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 243d17696f06..e068e3bda304 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -23,6 +23,7 @@
 #include <linux/swap.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/uaccess.h>
+#include <linux/netfs.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsacl.h"
@@ -1332,11 +1333,11 @@ int
 cifs_discard_remaining_data(struct TCP_Server_Info *server)
 {
 	unsigned int rfclen = server->pdu_size;
-	int remaining = rfclen + server->vals->header_preamble_size -
+	size_t remaining = rfclen + server->vals->header_preamble_size -
 		server->total_read;
 
 	while (remaining > 0) {
-		int length;
+		ssize_t length;
 
 		length = cifs_discard_from_socket(server,
 				min_t(size_t, remaining,
@@ -1551,7 +1552,15 @@ cifs_readv_callback(struct mid_q_entry *mid)
 		rdata->result = -EIO;
 	}
 
-	queue_work(cifsiod_wq, &rdata->work);
+	if (rdata->subreq) {
+		netfs_subreq_terminated(rdata->subreq,
+					(rdata->result == 0 || rdata->result == -EAGAIN) ?
+					rdata->got_bytes : rdata->result,
+					false);
+		kref_put(&rdata->refcount, cifs_readdata_release);
+	} else {
+		queue_work(cifsiod_wq, &rdata->work);
+	}
 	DeleteMidQEntry(mid);
 	add_credits(server, &credits, 0);
 }
@@ -1996,7 +2005,6 @@ cifs_writev_complete(struct work_struct *work)
 		else if (wdata->result < 0)
 			SetPageError(page);
 		end_page_writeback(page);
-		cifs_readpage_to_fscache(inode, page);
 		put_page(page);
 	}
 	if (wdata->result != -EAGAIN)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a52fd3a30c88..f6a145301e34 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -162,7 +162,7 @@ static void cifs_resolve_server(struct work_struct *work)
 	mutex_unlock(&server->srv_mutex);
 }
 
-/**
+/*
  * Mark all sessions and tcons for reconnect.
  *
  * @server needs to be previously set to CifsNeedReconnect.
@@ -656,6 +656,22 @@ cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
 	return cifs_readv_from_socket(server, &smb_msg);
 }
 
+int
+cifs_read_iter_from_socket(struct TCP_Server_Info *server, struct iov_iter *iter,
+			   unsigned int to_read)
+{
+	struct msghdr smb_msg;
+	int ret;
+
+	smb_msg.msg_iter = *iter;
+	if (smb_msg.msg_iter.count > to_read)
+		smb_msg.msg_iter.count = to_read;
+	ret = cifs_readv_from_socket(server, &smb_msg);
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
+	return ret;
+}
+
 static bool
 is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d872f6fe8e7d..a3b9c0ecf02c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/mm.h>
+#include <linux/netfs.h>
 #include <asm/div64.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
@@ -2614,6 +2615,7 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	struct cifsFileInfo *cfile = file->private_data;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
+	struct folio *folio = page_folio(page);
 	__u32 pid;
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
@@ -2624,14 +2626,14 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 	cifs_dbg(FYI, "write_end for page %p from pos %lld with %d bytes\n",
 		 page, pos, copied);
 
-	if (PageChecked(page)) {
+	if (folio_test_checked(folio)) {
 		if (copied == len)
-			SetPageUptodate(page);
-		ClearPageChecked(page);
-	} else if (!PageUptodate(page) && copied == PAGE_SIZE)
-		SetPageUptodate(page);
+			folio_mark_uptodate(folio);
+		folio_clear_checked(folio);
+	} else if (!folio_test_uptodate(folio) && copied == PAGE_SIZE)
+		folio_mark_uptodate(folio);
 
-	if (!PageUptodate(page)) {
+	if (!folio_test_uptodate(folio)) {
 		char *page_data;
 		unsigned offset = pos & (PAGE_SIZE - 1);
 		unsigned int xid;
@@ -4110,98 +4112,6 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 	return rc;
 }
 
-static ssize_t
-cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
-{
-	int rc = -EACCES;
-	unsigned int bytes_read = 0;
-	unsigned int total_read;
-	unsigned int current_read_size;
-	unsigned int rsize;
-	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *server;
-	unsigned int xid;
-	char *cur_offset;
-	struct cifsFileInfo *open_file;
-	struct cifs_io_parms io_parms = {0};
-	int buf_type = CIFS_NO_BUFFER;
-	__u32 pid;
-
-	xid = get_xid();
-	cifs_sb = CIFS_FILE_SB(file);
-
-	/* FIXME: set up handlers for larger reads and/or convert to async */
-	rsize = min_t(unsigned int, cifs_sb->ctx->rsize, CIFSMaxBufSize);
-
-	if (file->private_data == NULL) {
-		rc = -EBADF;
-		free_xid(xid);
-		return rc;
-	}
-	open_file = file->private_data;
-	tcon = tlink_tcon(open_file->tlink);
-	server = cifs_pick_channel(tcon->ses);
-
-	if (!server->ops->sync_read) {
-		free_xid(xid);
-		return -ENOSYS;
-	}
-
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
-		pid = open_file->pid;
-	else
-		pid = current->tgid;
-
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		cifs_dbg(FYI, "attempting read on write only file instance\n");
-
-	for (total_read = 0, cur_offset = read_data; read_size > total_read;
-	     total_read += bytes_read, cur_offset += bytes_read) {
-		do {
-			current_read_size = min_t(uint, read_size - total_read,
-						  rsize);
-			/*
-			 * For windows me and 9x we do not want to request more
-			 * than it negotiated since it will refuse the read
-			 * then.
-			 */
-			if (!(tcon->ses->capabilities &
-				tcon->ses->server->vals->cap_large_files)) {
-				current_read_size = min_t(uint,
-					current_read_size, CIFSMaxBufSize);
-			}
-			if (open_file->invalidHandle) {
-				rc = cifs_reopen_file(open_file, true);
-				if (rc != 0)
-					break;
-			}
-			io_parms.pid = pid;
-			io_parms.tcon = tcon;
-			io_parms.offset = *offset;
-			io_parms.length = current_read_size;
-			io_parms.server = server;
-			rc = server->ops->sync_read(xid, &open_file->fid, &io_parms,
-						    &bytes_read, &cur_offset,
-						    &buf_type);
-		} while (rc == -EAGAIN);
-
-		if (rc || (bytes_read == 0)) {
-			if (total_read) {
-				break;
-			} else {
-				free_xid(xid);
-				return rc;
-			}
-		} else {
-			cifs_stats_bytes_read(tcon, total_read);
-			*offset += bytes_read;
-		}
-	}
-	free_xid(xid);
-	return total_read;
-}
-
 /*
  * If the page is mmap'ed into a process' page tables, then we need to make
  * sure that it doesn't change while being written back.
@@ -4211,13 +4121,19 @@ cifs_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
 
+	/* Wait for the page to be written to the cache before we allow it to
+	 * be modified.  We then assume the entire page will need writing back.
+	 */
 #ifdef CONFIG_CIFS_FSCACHE
 	if (PageFsCache(page) &&
 	    wait_on_page_fscache_killable(page) < 0)
 		return VM_FAULT_RETRY;
 #endif
 
-	lock_page(page);
+	wait_on_page_writeback(page);
+
+	if (lock_page_killable(page) < 0)
+		return VM_FAULT_RETRY;
 	return VM_FAULT_LOCKED;
 }
 
@@ -4264,40 +4180,6 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return rc;
 }
 
-static void
-cifs_readv_complete(struct work_struct *work)
-{
-	unsigned int i, got_bytes;
-	struct cifs_readdata *rdata = container_of(work,
-						struct cifs_readdata, work);
-
-	got_bytes = rdata->got_bytes;
-	for (i = 0; i < rdata->nr_pages; i++) {
-		struct page *page = rdata->pages[i];
-
-		lru_cache_add(page);
-
-		if (rdata->result == 0 ||
-		    (rdata->result == -EAGAIN && got_bytes)) {
-			flush_dcache_page(page);
-			SetPageUptodate(page);
-		} else
-			SetPageError(page);
-
-		unlock_page(page);
-
-		if (rdata->result == 0 ||
-		    (rdata->result == -EAGAIN && got_bytes))
-			cifs_readpage_to_fscache(rdata->mapping->host, page);
-
-		got_bytes -= min_t(unsigned int, PAGE_SIZE, got_bytes);
-
-		put_page(page);
-		rdata->pages[i] = NULL;
-	}
-	kref_put(&rdata->refcount, cifs_readdata_release);
-}
-
 static int
 readpages_fill_pages(struct TCP_Server_Info *server,
 		     struct cifs_readdata *rdata, struct iov_iter *iter,
@@ -4372,8 +4254,7 @@ readpages_fill_pages(struct TCP_Server_Info *server,
 			result = n;
 #endif
 		else
-			result = cifs_read_page_from_socket(
-					server, page, page_offset, n);
+			result = cifs_read_iter_from_socket(server, &rdata->iter, n);
 		if (result < 0)
 			break;
 
@@ -4388,7 +4269,12 @@ static int
 cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 			       struct cifs_readdata *rdata, unsigned int len)
 {
-	return readpages_fill_pages(server, rdata, NULL, len);
+	int rc;
+
+	rc = cifs_read_iter_from_socket(server, &rdata->iter, len);
+	if (rc > 0)
+		rdata->got_bytes += rc;
+	return rc;
 }
 
 static int
@@ -4396,292 +4282,158 @@ cifs_readpages_copy_into_pages(struct TCP_Server_Info *server,
 			       struct cifs_readdata *rdata,
 			       struct iov_iter *iter)
 {
+	printk("cifs_readpages_copy_into_pages\n");
 	return readpages_fill_pages(server, rdata, iter, iter->count);
 }
 
-static int
-readpages_get_pages(struct address_space *mapping, struct list_head *page_list,
-		    unsigned int rsize, struct list_head *tmplist,
-		    unsigned int *nr_pages, loff_t *offset, unsigned int *bytes)
-{
-	struct page *page, *tpage;
-	unsigned int expected_index;
-	int rc;
-	gfp_t gfp = readahead_gfp_mask(mapping);
-
-	INIT_LIST_HEAD(tmplist);
-
-	page = lru_to_page(page_list);
-
-	/*
-	 * Lock the page and put it in the cache. Since no one else
-	 * should have access to this page, we're safe to simply set
-	 * PG_locked without checking it first.
-	 */
-	__SetPageLocked(page);
-	rc = add_to_page_cache_locked(page, mapping,
-				      page->index, gfp);
-
-	/* give up if we can't stick it in the cache */
-	if (rc) {
-		__ClearPageLocked(page);
-		return rc;
-	}
-
-	/* move first page to the tmplist */
-	*offset = (loff_t)page->index << PAGE_SHIFT;
-	*bytes = PAGE_SIZE;
-	*nr_pages = 1;
-	list_move_tail(&page->lru, tmplist);
-
-	/* now try and add more pages onto the request */
-	expected_index = page->index + 1;
-	list_for_each_entry_safe_reverse(page, tpage, page_list, lru) {
-		/* discontinuity ? */
-		if (page->index != expected_index)
-			break;
-
-		/* would this page push the read over the rsize? */
-		if (*bytes + PAGE_SIZE > rsize)
-			break;
-
-		__SetPageLocked(page);
-		rc = add_to_page_cache_locked(page, mapping, page->index, gfp);
-		if (rc) {
-			__ClearPageLocked(page);
-			break;
-		}
-		list_move_tail(&page->lru, tmplist);
-		(*bytes) += PAGE_SIZE;
-		expected_index++;
-		(*nr_pages)++;
-	}
-	return rc;
-}
-
-static int cifs_readpages(struct file *file, struct address_space *mapping,
-	struct list_head *page_list, unsigned num_pages)
+/*
+ * Issue a read operation on behalf of the netfs helper functions.  We're asked
+ * to make a read of a certain size at a point in the file.  We are permitted
+ * to only read a portion of that, but as long as we read something, the netfs
+ * helper will call us again so that we can issue another read.
+ */
+static void cifs_req_issue_op(struct netfs_read_subrequest *subreq)
 {
-	int rc;
-	int err = 0;
-	struct list_head tmplist;
-	struct cifsFileInfo *open_file = file->private_data;
-	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
+	struct netfs_read_request *rreq = subreq->rreq;
 	struct TCP_Server_Info *server;
-	pid_t pid;
+	struct cifs_readdata *rdata;
+	struct cifsFileInfo *open_file = rreq->netfs_priv;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(rreq->inode->i_sb);
+	struct cifs_credits credits_on_stack, *credits = &credits_on_stack;
 	unsigned int xid;
+	pid_t pid;
+	int rc = 0;
+	unsigned int rsize;
 
 	xid = get_xid();
-	/*
-	 * Reads as many pages as possible from fscache. Returns -ENOBUFS
-	 * immediately if the cookie is negative
-	 *
-	 * After this point, every page in the list might have PG_fscache set,
-	 * so we will need to clean that up off of every page we don't use.
-	 */
-	rc = cifs_readpages_from_fscache(mapping->host, mapping, page_list,
-					 &num_pages);
-	if (rc == 0) {
-		free_xid(xid);
-		return rc;
-	}
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
-		pid = current->tgid;
+		pid = current->tgid; // Ummm...  This may be a workqueue
 
-	rc = 0;
 	server = cifs_pick_channel(tlink_tcon(open_file->tlink)->ses);
 
-	cifs_dbg(FYI, "%s: file=%p mapping=%p num_pages=%u\n",
-		 __func__, file, mapping, num_pages);
+	cifs_dbg(FYI, "%s: op=%08x[%x] mapping=%p len=%zu/%zu\n",
+		 __func__, rreq->debug_id, subreq->debug_index, rreq->mapping,
+		 subreq->transferred, subreq->len);
 
-	/*
-	 * Start with the page at end of list and move it to private
-	 * list. Do the same with any following pages until we hit
-	 * the rsize limit, hit an index discontinuity, or run out of
-	 * pages. Issue the async read and then start the loop again
-	 * until the list is empty.
-	 *
-	 * Note that list order is important. The page_list is in
-	 * the order of declining indexes. When we put the pages in
-	 * the rdata->pages, then we want them in increasing order.
-	 */
-	while (!list_empty(page_list) && !err) {
-		unsigned int i, nr_pages, bytes, rsize;
-		loff_t offset;
-		struct page *page, *tpage;
-		struct cifs_readdata *rdata;
-		struct cifs_credits credits_on_stack;
-		struct cifs_credits *credits = &credits_on_stack;
-
-		if (open_file->invalidHandle) {
+	if (open_file->invalidHandle) {
+		do {
 			rc = cifs_reopen_file(open_file, true);
-			if (rc == -EAGAIN)
-				continue;
-			else if (rc)
-				break;
-		}
-
-		rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
-						   &rsize, credits);
+		} while (rc == -EAGAIN);
 		if (rc)
-			break;
-
-		/*
-		 * Give up immediately if rsize is too small to read an entire
-		 * page. The VFS will fall back to readpage. We should never
-		 * reach this point however since we set ra_pages to 0 when the
-		 * rsize is smaller than a cache page.
-		 */
-		if (unlikely(rsize < PAGE_SIZE)) {
-			add_credits_and_wake_if(server, credits, 0);
-			free_xid(xid);
-			return 0;
-		}
-
-		nr_pages = 0;
-		err = readpages_get_pages(mapping, page_list, rsize, &tmplist,
-					 &nr_pages, &offset, &bytes);
-		if (!nr_pages) {
-			add_credits_and_wake_if(server, credits, 0);
-			break;
-		}
-
-		rdata = cifs_readdata_alloc(nr_pages, cifs_readv_complete);
-		if (!rdata) {
-			/* best to give up if we're out of mem */
-			list_for_each_entry_safe(page, tpage, &tmplist, lru) {
-				list_del(&page->lru);
-				lru_cache_add(page);
-				unlock_page(page);
-				put_page(page);
-			}
-			rc = -ENOMEM;
-			add_credits_and_wake_if(server, credits, 0);
-			break;
-		}
+			goto out;
+	}
 
-		rdata->cfile = cifsFileInfo_get(open_file);
-		rdata->server = server;
-		rdata->mapping = mapping;
-		rdata->offset = offset;
-		rdata->bytes = bytes;
-		rdata->pid = pid;
-		rdata->pagesz = PAGE_SIZE;
-		rdata->tailsz = PAGE_SIZE;
-		rdata->read_into_pages = cifs_readpages_read_into_pages;
-		rdata->copy_into_pages = cifs_readpages_copy_into_pages;
-		rdata->credits = credits_on_stack;
+	rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize, &rsize, credits);
+	if (rc)
+		goto out;
 
-		list_for_each_entry_safe(page, tpage, &tmplist, lru) {
-			list_del(&page->lru);
-			rdata->pages[rdata->nr_pages++] = page;
-		}
+	rdata = cifs_readdata_alloc(0, NULL);
+	if (!rdata) {
+		add_credits_and_wake_if(server, credits, 0);
+		rc = -ENOMEM;
+		goto out;
+	}
 
-		rc = adjust_credits(server, &rdata->credits, rdata->bytes);
+	rdata->subreq = subreq;
+	rdata->cfile = cifsFileInfo_get(open_file);
+	rdata->server = server;
+	rdata->mapping = rreq->mapping;
+	rdata->offset = subreq->start + subreq->transferred;
+	rdata->bytes = subreq->len   - subreq->transferred;
+	rdata->pid = pid;
+	rdata->pagesz = PAGE_SIZE;
+	rdata->tailsz = PAGE_SIZE;
+	rdata->read_into_pages = cifs_readpages_read_into_pages;
+	rdata->copy_into_pages = cifs_readpages_copy_into_pages;
+	rdata->credits = credits_on_stack;
 
-		if (!rc) {
-			if (rdata->cfile->invalidHandle)
-				rc = -EAGAIN;
-			else
-				rc = server->ops->async_readv(rdata);
-		}
+	iov_iter_xarray(&rdata->iter, READ, &rreq->mapping->i_pages,
+			rdata->offset, rdata->bytes);
 
-		if (rc) {
-			add_credits_and_wake_if(server, &rdata->credits, 0);
-			for (i = 0; i < rdata->nr_pages; i++) {
-				page = rdata->pages[i];
-				lru_cache_add(page);
-				unlock_page(page);
-				put_page(page);
-			}
-			/* Fallback to the readpage in error/reconnect cases */
-			kref_put(&rdata->refcount, cifs_readdata_release);
-			break;
-		}
+	rc = adjust_credits(server, &rdata->credits, rdata->bytes);
+	if (!rc) {
+		if (rdata->cfile->invalidHandle)
+			rc = -EAGAIN;
+		else
+			rc = server->ops->async_readv(rdata);
+	}
 
+	if (rc) {
+		add_credits_and_wake_if(server, &rdata->credits, 0);
+		/* Fallback to the readpage in error/reconnect cases */
 		kref_put(&rdata->refcount, cifs_readdata_release);
 	}
 
+	kref_put(&rdata->refcount, cifs_readdata_release);
+
+out:
 	free_xid(xid);
-	return rc;
+	if (rc)
+		netfs_subreq_terminated(subreq, rc, false);
+}
+
+static void cifs_init_rreq(struct netfs_read_request *rreq, struct file *file)
+{
+	rreq->netfs_priv = file->private_data;
 }
 
 /*
- * cifs_readpage_worker must be called with the page pinned
+ * Expand the size of a readahead to the size of the rsize, if at least as
+ * large as a page, allowing for the possibility that rsize is not pow-2
+ * aligned.
  */
-static int cifs_readpage_worker(struct file *file, struct page *page,
-	loff_t *poffset)
+static void cifs_expand_readahead(struct netfs_read_request *rreq)
 {
-	char *read_data;
-	int rc;
-
-	/* Is the page cached? */
-	rc = cifs_readpage_from_fscache(file_inode(file), page);
-	if (rc == 0)
-		goto read_complete;
-
-	read_data = kmap(page);
-	/* for reads over a certain size could initiate async read ahead */
-
-	rc = cifs_read(file, read_data, PAGE_SIZE, poffset);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(rreq->inode->i_sb);
+	unsigned int rsize = cifs_sb->ctx->rsize;
+	loff_t misalignment, i_size = i_size_read(rreq->inode);
 
-	if (rc < 0)
-		goto io_error;
-	else
-		cifs_dbg(FYI, "Bytes read %d\n", rc);
+	if (rsize < PAGE_SIZE)
+		return;
 
-	/* we do not want atime to be less than mtime, it broke some apps */
-	file_inode(file)->i_atime = current_time(file_inode(file));
-	if (timespec64_compare(&(file_inode(file)->i_atime), &(file_inode(file)->i_mtime)))
-		file_inode(file)->i_atime = file_inode(file)->i_mtime;
+	if (rsize < INT_MAX)
+		rsize = roundup_pow_of_two(rsize);
 	else
-		file_inode(file)->i_atime = current_time(file_inode(file));
-
-	if (PAGE_SIZE > rc)
-		memset(read_data + rc, 0, PAGE_SIZE - rc);
-
-	flush_dcache_page(page);
-	SetPageUptodate(page);
-
-	/* send this page to the cache */
-	cifs_readpage_to_fscache(file_inode(file), page);
-
-	rc = 0;
+		rsize = ((unsigned int)INT_MAX + 1) / 2;
 
-io_error:
-	kunmap(page);
-	unlock_page(page);
+	misalignment = rreq->start & (rsize - 1);
+	if (misalignment) {
+		rreq->start -= misalignment;
+		rreq->len += misalignment;
+	}
 
-read_complete:
-	return rc;
+	rreq->len = round_up(rreq->len, rsize);
+	if (rreq->start < i_size && rreq->len > i_size - rreq->start)
+		rreq->len = i_size - rreq->start;
 }
 
-static int cifs_readpage(struct file *file, struct page *page)
+static void cifs_rreq_done(struct netfs_read_request *rreq)
 {
-	loff_t offset = page_file_offset(page);
-	int rc = -EACCES;
-	unsigned int xid;
-
-	xid = get_xid();
-
-	if (file->private_data == NULL) {
-		rc = -EBADF;
-		free_xid(xid);
-		return rc;
-	}
-
-	cifs_dbg(FYI, "readpage %p at offset %d 0x%x\n",
-		 page, (int)offset, (int)offset);
+	struct inode *inode = rreq->inode;
 
-	rc = cifs_readpage_worker(file, page, &offset);
+	/* we do not want atime to be less than mtime, it broke some apps */
+	inode->i_atime = current_time(inode);
+	if (timespec64_compare(&inode->i_atime, &inode->i_mtime))
+		inode->i_atime = inode->i_mtime;
+	else
+		inode->i_atime = current_time(inode);
+}
 
-	free_xid(xid);
-	return rc;
+static void cifs_req_cleanup(struct address_space *mapping, void *netfs_priv)
+{
 }
 
+const struct netfs_read_request_ops cifs_req_ops = {
+	.init_rreq		= cifs_init_rreq,
+	.expand_readahead	= cifs_expand_readahead,
+	.issue_op		= cifs_req_issue_op,
+	.done			= cifs_rreq_done,
+	.cleanup		= cifs_req_cleanup,
+};
+
 static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
 {
 	struct cifsFileInfo *open_file;
@@ -4731,34 +4483,21 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
-	int oncethru = 0;
-	pgoff_t index = pos >> PAGE_SHIFT;
-	loff_t offset = pos & (PAGE_SIZE - 1);
-	loff_t page_start = pos & PAGE_MASK;
-	loff_t i_size;
-	struct page *page;
-	int rc = 0;
+	struct folio *folio;
+	int rc;
 
 	cifs_dbg(FYI, "write_begin from %lld len %d\n", (long long)pos, len);
 
-start:
-	page = grab_cache_page_write_begin(mapping, index, flags);
-	if (!page) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	if (PageUptodate(page))
-		goto out;
-
-	/*
-	 * If we write a full page it will be up to date, no need to read from
-	 * the server. If the write is short, we'll end up doing a sync write
-	 * instead.
+	/* Prefetch area to be written into the cache if we're caching this
+	 * file.  We need to do this before we get a lock on the page in case
+	 * there's more than one writer competing for the same cache block.
 	 */
-	if (len == PAGE_SIZE)
-		goto out;
+	rc = netfs_write_begin(file, mapping, pos, len, flags, &folio, fsdata,
+			       &cifs_req_ops, NULL);
+	if (rc < 0)
+		return rc;
 
+#if 0
 	/*
 	 * optimize away the read when we have an oplock, and we're not
 	 * expecting to use any of the data we'd be reading in. That
@@ -4773,34 +4512,17 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
 					   offset + len,
 					   PAGE_SIZE);
 			/*
-			 * PageChecked means that the parts of the page
-			 * to which we're not writing are considered up
-			 * to date. Once the data is copied to the
-			 * page, it can be set uptodate.
+			 * Marking a folio checked means that the parts of the
+			 * page to which we're not writing are considered up to
+			 * date. Once the data is copied to the page, it can be
+			 * set uptodate.
 			 */
-			SetPageChecked(page);
+			folio_set_checked(folio);
 			goto out;
 		}
 	}
-
-	if ((file->f_flags & O_ACCMODE) != O_WRONLY && !oncethru) {
-		/*
-		 * might as well read a page, it is fast enough. If we get
-		 * an error, we don't need to return it. cifs_write_end will
-		 * do a sync write instead since PG_uptodate isn't set.
-		 */
-		cifs_readpage_worker(file, page, &page_start);
-		put_page(page);
-		oncethru = 1;
-		goto start;
-	} else {
-		/* we could try using another file handle if there is one -
-		   but how would we lock it to prevent close of that handle
-		   racing with this read? In any case
-		   this will be written out by write_end so is fine */
-	}
-out:
-	*pagep = page;
+#endif
+	*pagep = folio_page(folio, pos / PAGE_SIZE);
 	return rc;
 }
 
@@ -5010,9 +4732,19 @@ static int cifs_set_page_dirty(struct page *page)
 #define cifs_set_page_dirty __set_page_dirty_nobuffers
 #endif
 
+static int cifs_readpage(struct file *file, struct page *page)
+{
+	return netfs_readpage(file, page_folio(page), &cifs_req_ops, NULL);
+}
+
+static void cifs_readahead(struct readahead_control *ractl)
+{
+	netfs_readahead(ractl, &cifs_req_ops, NULL);
+}
+
 const struct address_space_operations cifs_addr_ops = {
 	.readpage = cifs_readpage,
-	.readpages = cifs_readpages,
+	.readahead = cifs_readahead,
 	.writepage = cifs_writepage,
 	.writepages = cifs_writepages,
 	.write_begin = cifs_write_begin,
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index efaac4d5ff55..76e1edc99aec 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -133,38 +133,3 @@ void cifs_fscache_release_inode_cookie(struct inode *inode)
 		cifsi->fscache = NULL;
 	}
 }
-
-/*
- * Retrieve a page from FS-Cache
- */
-int __cifs_readpage_from_fscache(struct inode *inode, struct page *page)
-{
-	cifs_dbg(FYI, "%s: (fsc:%p, p:%p, i:0x%p\n",
-		 __func__, CIFS_I(inode)->fscache, page, inode);
-	return -ENOBUFS; // Needs conversion to using netfslib
-}
-
-/*
- * Retrieve a set of pages from FS-Cache
- */
-int __cifs_readpages_from_fscache(struct inode *inode,
-				struct address_space *mapping,
-				struct list_head *pages,
-				unsigned *nr_pages)
-{
-	cifs_dbg(FYI, "%s: (0x%p/%u/0x%p)\n",
-		 __func__, CIFS_I(inode)->fscache, *nr_pages, inode);
-	return -ENOBUFS; // Needs conversion to using netfslib
-}
-
-void __cifs_readpage_to_fscache(struct inode *inode, struct page *page)
-{
-	struct cifsInodeInfo *cifsi = CIFS_I(inode);
-
-	WARN_ON(!cifsi->fscache);
-
-	cifs_dbg(FYI, "%s: (fsc: %p, p: %p, i: %p)\n",
-		 __func__, cifsi->fscache, page, inode);
-
-	// Needs conversion to using netfslib
-}
diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
index 0fc3f9252c84..9718feac1d68 100644
--- a/fs/cifs/fscache.h
+++ b/fs/cifs/fscache.h
@@ -58,46 +58,11 @@ void cifs_fscache_fill_coherency(struct inode *inode,
 }
 
 
-extern int cifs_fscache_release_page(struct page *page, gfp_t gfp);
-extern int __cifs_readpage_from_fscache(struct inode *, struct page *);
-extern int __cifs_readpages_from_fscache(struct inode *,
-					 struct address_space *,
-					 struct list_head *,
-					 unsigned *);
-extern void __cifs_readpage_to_fscache(struct inode *, struct page *);
-
 static inline struct fscache_cookie *cifs_inode_cookie(struct inode *inode)
 {
 	return CIFS_I(inode)->fscache;
 }
 
-static inline int cifs_readpage_from_fscache(struct inode *inode,
-					     struct page *page)
-{
-	if (CIFS_I(inode)->fscache)
-		return __cifs_readpage_from_fscache(inode, page);
-
-	return -ENOBUFS;
-}
-
-static inline int cifs_readpages_from_fscache(struct inode *inode,
-					      struct address_space *mapping,
-					      struct list_head *pages,
-					      unsigned *nr_pages)
-{
-	if (CIFS_I(inode)->fscache)
-		return __cifs_readpages_from_fscache(inode, mapping, pages,
-						     nr_pages);
-	return -ENOBUFS;
-}
-
-static inline void cifs_readpage_to_fscache(struct inode *inode,
-					    struct page *page)
-{
-	if (PageFsCache(page))
-		__cifs_readpage_to_fscache(inode, page);
-}
-
 #else /* CONFIG_CIFS_FSCACHE */
 static inline
 void cifs_fscache_fill_coherency(struct inode *inode,
@@ -113,23 +78,6 @@ static inline void cifs_fscache_release_inode_cookie(struct inode *inode) {}
 static inline void cifs_fscache_unuse_inode_cookie(struct inode *inode, bool update) {}
 static inline struct fscache_cookie *cifs_inode_cookie(struct inode *inode) { return NULL; }
 
-static inline int
-cifs_readpage_from_fscache(struct inode *inode, struct page *page)
-{
-	return -ENOBUFS;
-}
-
-static inline int cifs_readpages_from_fscache(struct inode *inode,
-					      struct address_space *mapping,
-					      struct list_head *pages,
-					      unsigned *nr_pages)
-{
-	return -ENOBUFS;
-}
-
-static inline void cifs_readpage_to_fscache(struct inode *inode,
-			struct page *page) {}
-
 #endif /* CONFIG_CIFS_FSCACHE */
 
 #endif /* _CIFS_FSCACHE_H */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8b3670388cda..ea2f8a2d9e57 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -23,6 +23,7 @@
 #include <linux/uuid.h>
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
+#include <linux/netfs.h>
 #include "cifsglob.h"
 #include "cifsacl.h"
 #include "cifsproto.h"
@@ -4084,7 +4085,14 @@ smb2_readv_callback(struct mid_q_entry *mid)
 				     tcon->tid, tcon->ses->Suid,
 				     rdata->offset, rdata->got_bytes);
 
-	queue_work(cifsiod_wq, &rdata->work);
+	if (rdata->subreq) {
+		netfs_subreq_terminated(rdata->subreq,
+					(rdata->result == 0 || rdata->result == -EAGAIN) ?
+					rdata->got_bytes : rdata->result, false);
+		kref_put(&rdata->refcount, cifs_readdata_release);
+	} else {
+		queue_work(cifsiod_wq, &rdata->work);
+	}
 	DeleteMidQEntry(mid);
 	add_credits(server, &credits, 0);
 }


