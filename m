From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 8/9] CIFS: Fix wsize usage in iovec write
Date: Mon, 23 Jun 2014 18:58:36 +0400
Message-ID: <1403535517-8301-9-git-send-email-pshilovsky@samba.org>
References: <1403535517-8301-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403535517-8301-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If a server change maximum buffer size for write (wsize) requests
on reconnect we can fail on repeating with a big size buffer on
-EAGAIN error in iovec write. Fix this by checking wsize all the
time before repeating request in iovec write.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c |   62 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 887c18c..4ba59cd 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2401,28 +2401,6 @@ cifs_uncached_writev_complete(struct work_struct *work)
 	kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 }
 
-/* attempt to send write to server, retry on any -EAGAIN errors */
-static int
-cifs_uncached_retry_writev(struct cifs_writedata *wdata)
-{
-	int rc;
-	struct TCP_Server_Info *server;
-
-	server = tlink_tcon(wdata->cfile->tlink)->ses->server;
-
-	do {
-		if (wdata->cfile->invalidHandle) {
-			rc = cifs_reopen_file(wdata->cfile, false);
-			if (rc != 0)
-				continue;
-		}
-		rc = server->ops->async_writev(wdata,
-					       cifs_uncached_writedata_release);
-	} while (rc == -EAGAIN);
-
-	return rc;
-}
-
 static int
 wdata_fill_from_iovec(struct cifs_writedata *wdata, struct iov_iter *it,
 		      size_t *len, unsigned long nr_pages)
@@ -2472,23 +2450,28 @@ wdata_fill_from_iovec(struct cifs_writedata *wdata, struct iov_iter *it,
 
 static int
 cifs_write_from_iovec(loff_t offset, size_t len, const struct iovec *iov,
-		      unsigned long nr_segs, struct cifsFileInfo *open_file,
+		      unsigned long nr_segs, loff_t written,
+		      struct cifsFileInfo *open_file,
 		      struct cifs_sb_info *cifs_sb,
 		      struct list_head *wdata_list)
 {
 	int rc = 0;
-	size_t cur_len;
+	size_t cur_len, saved_len = len;
 	unsigned long nr_pages, i;
 	struct cifs_writedata *wdata;
 	struct iov_iter it;
+	loff_t saved_offset = offset;
 	pid_t pid;
+	struct TCP_Server_Info *server;
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
 
-	iov_iter_init(&it, iov, nr_segs, len, 0);
+	server = tlink_tcon(open_file->tlink)->ses->server;
+
+	iov_iter_init(&it, iov, nr_segs, len, written);
 	do {
 		nr_pages = get_numpages(cifs_sb->wsize, len, &cur_len);
 		wdata = cifs_writedata_alloc(nr_pages,
@@ -2520,10 +2503,19 @@ cifs_write_from_iovec(loff_t offset, size_t len, const struct iovec *iov,
 		wdata->bytes = cur_len;
 		wdata->pagesz = PAGE_SIZE;
 		wdata->tailsz = cur_len - ((nr_pages - 1) * PAGE_SIZE);
-		rc = cifs_uncached_retry_writev(wdata);
+
+		if (!wdata->cfile->invalidHandle ||
+		    !cifs_reopen_file(wdata->cfile, false))
+			rc = server->ops->async_writev(wdata,
+					cifs_uncached_writedata_release);
 		if (rc) {
 			kref_put(&wdata->refcount,
 				 cifs_uncached_writedata_release);
+			if (rc == -EAGAIN) {
+				iov_iter_init(&it, iov, nr_segs, saved_len,
+					      written + offset - saved_offset);
+				continue;
+			}
 			break;
 		}
 
@@ -2564,7 +2556,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	if (!tcon->ses->server->ops->async_writev)
 		return -ENOSYS;
 
-	rc = cifs_write_from_iovec(*poffset, len, iov, nr_segs, open_file,
+	rc = cifs_write_from_iovec(*poffset, len, iov, nr_segs, 0, open_file,
 				   cifs_sb, &wdata_list);
 
 	/*
@@ -2595,7 +2587,21 @@ restart_loop:
 
 			/* resend call if it's a retryable error */
 			if (rc == -EAGAIN) {
-				rc = cifs_uncached_retry_writev(wdata);
+				struct list_head tmp_list;
+
+				INIT_LIST_HEAD(&tmp_list);
+				list_del_init(&wdata->list);
+
+				rc = cifs_write_from_iovec(wdata->offset,
+					wdata->bytes, iov, nr_segs,
+					wdata->offset - *poffset, open_file,
+					cifs_sb, &tmp_list);
+
+				if (!list_empty(&tmp_list))
+					list_splice(&tmp_list, &wdata_list);
+
+				kref_put(&wdata->refcount,
+					 cifs_uncached_writedata_release);
 				goto restart_loop;
 			}
 		}
-- 
1.7.10.4
