From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: don't allow mmap'ed pages to be dirtied while under writeback (try #3)
Date: Tue, 12 Apr 2011 09:14:26 -0400
Message-ID: <1302614066-24572-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is more or less the same patch as before, but with some merge
conflicts fixed up.

If a process has a dirty page mapped into its page tables, then it has
the ability to change it while the client is trying to write the data
out to the server. If that happens after the signature has been
calculated then that signature will then be wrong, and the server will
likely reset the TCP connection.

This patch adds a page_mkwrite handler for CIFS that simply takes the
page lock. Because the page lock is held over the life of writepage and
writepages, this prevents the page from becoming writeable until
the write call has completed.

With this, we can also remove the "sign_zero_copy" module option and
always inline the pages when writing.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    4 ---
 fs/cifs/cifsglob.h |    1 -
 fs/cifs/file.c     |   64 ++++++++++++++++++++++++++-------------------------
 3 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e3352a1..5c412b3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -81,10 +81,6 @@ module_param(echo_retries, ushort, 0644);
 MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giving up and "
 			       "reconnecting server. Default: 5. 0 means "
 			       "never reconnect.");
-bool sign_zero_copy;  /* globals init to false automatically */
-module_param(sign_zero_copy, bool, 0644);
-MODULE_PARM_DESC(sign_zero_copy, "Don't copy pages on write with signing "
-				 "enabled. Default: N");
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ddb3599..a5d1106 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -826,7 +826,6 @@ GLOBAL_EXTERN unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
 GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
 GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
-GLOBAL_EXTERN bool sign_zero_copy; /* don't copy written pages with signing */
 
 /* reconnect after this many failed echo attempts */
 GLOBAL_EXTERN unsigned short echo_retries;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e2d7b6b..faf5952 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -972,6 +972,9 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 	     total_written += bytes_written) {
 		rc = -EAGAIN;
 		while (rc == -EAGAIN) {
+			struct kvec iov[2];
+			unsigned int len;
+
 			if (open_file->invalidHandle) {
 				/* we could deadlock if we called
 				   filemap_fdatawait from here so tell
@@ -981,31 +984,14 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 				if (rc != 0)
 					break;
 			}
-			if (sign_zero_copy || (pTcon->ses->server &&
-				((pTcon->ses->server->secMode &
-				(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
-				== 0))) {
-				struct kvec iov[2];
-				unsigned int len;
-
-				len = min((size_t)cifs_sb->wsize,
-					  write_size - total_written);
-				/* iov[0] is reserved for smb header */
-				iov[1].iov_base = (char *)write_data +
-						  total_written;
-				iov[1].iov_len = len;
-				rc = CIFSSMBWrite2(xid, pTcon,
-						open_file->netfid, len,
-						*poffset, &bytes_written,
-						iov, 1, 0);
-			} else
-				rc = CIFSSMBWrite(xid, pTcon,
-					 open_file->netfid,
-					 min_t(const int, cifs_sb->wsize,
-					       write_size - total_written),
-					 *poffset, &bytes_written,
-					 write_data + total_written,
-					 NULL, 0);
+
+			len = min((size_t)cifs_sb->wsize,
+				  write_size - total_written);
+			/* iov[0] is reserved for smb header */
+			iov[1].iov_base = (char *)write_data + total_written;
+			iov[1].iov_len = len;
+			rc = CIFSSMBWrite2(xid, pTcon, open_file->netfid, len,
+					   *poffset, &bytes_written, iov, 1, 0);
 		}
 		if (rc || (bytes_written == 0)) {
 			if (total_written)
@@ -1242,12 +1228,6 @@ static int cifs_writepages(struct address_space *mapping,
 	}
 
 	tcon = tlink_tcon(open_file->tlink);
-	if (!sign_zero_copy && tcon->ses->server->secMode &
-			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
-		cifsFileInfo_put(open_file);
-		kfree(iov);
-		return generic_writepages(mapping, wbc);
-	}
 	cifsFileInfo_put(open_file);
 
 	xid = GetXid();
@@ -1982,6 +1962,24 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	return total_read;
 }
 
+/*
+ * If the page is mmap'ed into a process' page tables, then we need to make
+ * sure that it doesn't change while being written back.
+ */
+static int
+cifs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct page *page = vmf->page;
+
+	lock_page(page);
+	return VM_FAULT_LOCKED;
+}
+
+static struct vm_operations_struct cifs_file_vm_ops = {
+	.fault = filemap_fault,
+	.page_mkwrite = cifs_page_mkwrite,
+};
+
 int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int rc, xid;
@@ -1993,6 +1991,8 @@ int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
 		cifs_invalidate_mapping(inode);
 
 	rc = generic_file_mmap(file, vma);
+	if (rc == 0)
+		vma->vm_ops = &cifs_file_vm_ops;
 	FreeXid(xid);
 	return rc;
 }
@@ -2009,6 +2009,8 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 		return rc;
 	}
 	rc = generic_file_mmap(file, vma);
+	if (rc == 0)
+		vma->vm_ops = &cifs_file_vm_ops;
 	FreeXid(xid);
 	return rc;
 }
-- 
1.7.4.2
