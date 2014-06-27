From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 14/16] CIFS: Fix rsize usage in user read
Date: Fri, 27 Jun 2014 13:57:51 +0400
Message-ID: <1403863073-19526-15-git-send-email-pshilovsky@samba.org>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403863073-19526-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If a server changes maximum buffer size for read (rsize) requests
on reconnect we can fail on repeating with a big size buffer on
-EAGAIN error in user read. Fix this by checking rsize all the
time before repeating requests.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c | 45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6b5b95a..021adf6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2827,26 +2827,6 @@ cifs_uncached_readdata_release(struct kref *refcount)
 	cifs_readdata_release(refcount);
 }
 
-static int
-cifs_retry_async_readv(struct cifs_readdata *rdata)
-{
-	int rc;
-	struct TCP_Server_Info *server;
-
-	server = tlink_tcon(rdata->cfile->tlink)->ses->server;
-
-	do {
-		if (rdata->cfile->invalidHandle) {
-			rc = cifs_reopen_file(rdata->cfile, true);
-			if (rc != 0)
-				continue;
-		}
-		rc = server->ops->async_readv(rdata);
-	} while (rc == -EAGAIN);
-
-	return rc;
-}
-
 /**
  * cifs_readdata_to_iov - copy data from pages in response to an iovec
  * @rdata:	the readdata response with list of pages holding data
@@ -2940,6 +2920,9 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 	size_t cur_len;
 	int rc;
 	pid_t pid;
+	struct TCP_Server_Info *server;
+
+	server = tlink_tcon(open_file->tlink)->ses->server;
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
@@ -2970,11 +2953,15 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 		rdata->pagesz = PAGE_SIZE;
 		rdata->read_into_pages = cifs_uncached_read_into_pages;
 
-		rc = cifs_retry_async_readv(rdata);
+		if (!rdata->cfile->invalidHandle ||
+		    !cifs_reopen_file(rdata->cfile, true))
+			rc = server->ops->async_readv(rdata);
 error:
 		if (rc) {
 			kref_put(&rdata->refcount,
 				 cifs_uncached_readdata_release);
+			if (rc == -EAGAIN)
+				continue;
 			break;
 		}
 
@@ -3022,8 +3009,8 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
 
 	len = iov_iter_count(to);
 	/* the loop below should proceed in the order of increasing offsets */
+again:
 	list_for_each_entry_safe(rdata, tmp, &rdata_list, list) {
-	again:
 		if (!rc) {
 			/* FIXME: freezable sleep too? */
 			rc = wait_for_completion_killable(&rdata->done);
@@ -3033,7 +3020,19 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
 				rc = rdata->result;
 				/* resend call if it's a retryable error */
 				if (rc == -EAGAIN) {
-					rc = cifs_retry_async_readv(rdata);
+					struct list_head tmp_list;
+
+					list_del_init(&rdata->list);
+					INIT_LIST_HEAD(&tmp_list);
+
+					rc = cifs_send_async_read(rdata->offset,
+						rdata->bytes, rdata->cfile,
+						cifs_sb, &tmp_list);
+
+					list_splice(&tmp_list, &rdata_list);
+
+					kref_put(&rdata->refcount,
+						cifs_uncached_readdata_release);
 					goto again;
 				}
 			} else {
-- 
1.8.1.2
