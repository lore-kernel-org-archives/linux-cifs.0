From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] CIFS: Fix cache coherency for read oplock case
Date: Tue,  4 Sep 2012 20:24:05 +0400
Message-ID: <1346775847-7894-3-git-send-email-pshilovsky@etersoft.ru>
References: <1346775847-7894-1-git-send-email-pshilovsky@etersoft.ru>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346775847-7894-1-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

When we have a file opened with read oplock and we are writing a data
to this file, we need to store the data in the cache and then send to
the server to ensure that the next read operation will get a coherent
data.

Also mark it as CONFIG_CIFS_SMB2 because it's more suitable for SMB2
code but can fix some CIFS problems too (when server delays sending
an oplock break after a write request). We can drop this ifdefs
dependence in future.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f15c30c..da7e3d4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2421,11 +2421,29 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = -EACCES;
 
+#ifdef CONFIG_CIFS_SMB2
 	/*
-	 * In strict cache mode we need to write the data to the server exactly
-	 * from the pos to pos+len-1 rather than flush all affected pages
-	 * because it may cause a error with mandatory locks on these pages but
-	 * not on the region from pos to ppos+len-1.
+	 * If we have an oplock for read and want to write a data to the file
+	 * we need to store it in the page cache and then push it to the server
+	 * to be sure the next read will get a valid data.
+	 */
+	if (!cinode->clientCanCacheAll && cinode->clientCanCacheRead) {
+		ssize_t written;
+
+		written = generic_file_aio_write(iocb, iov, nr_segs, pos);
+		rc = filemap_fdatawrite(inode->i_mapping);
+		if (rc)
+			return (ssize_t)rc;
+
+		return written;
+	}
+#endif
+
+	/*
+	 * For non-oplocked files in strict cache mode we need to write the data
+	 * to the server exactly from the pos to pos+len-1 rather than flush all
+	 * affected pages because it may cause a error with mandatory locks on
+	 * these pages but not on the region from pos to ppos+len-1.
 	 */
 
 	if (!cinode->clientCanCacheAll)
-- 
1.7.1
