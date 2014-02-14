From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix wrong pos argument of cifs_find_lock_conflict
Date: Fri, 14 Feb 2014 13:31:03 +0400
Message-ID: <1392370263-10364-2-git-send-email-piastry@etersoft.ru>
References: <1392370263-10364-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392370263-10364-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and use generic_file_aio_write rather than __generic_file_aio_write
in cifs_writev.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a7eda8e..d34dc3b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2539,31 +2539,19 @@ cifs_writev(struct kiocb *iocb, const struct iovec *iov,
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
 	ssize_t rc = -EACCES;
+	loff_t lock_pos = pos;
 
-	BUG_ON(iocb->ki_pos != pos);
-
+	if (file->f_flags & O_APPEND)
+		lock_pos = i_size_read(inode);
 	/*
 	 * We need to hold the sem to be sure nobody modifies lock list
 	 * with a brlock that prevents writing.
 	 */
 	down_read(&cinode->lock_sem);
-	if (!cifs_find_lock_conflict(cfile, pos, iov_length(iov, nr_segs),
+	if (!cifs_find_lock_conflict(cfile, lock_pos, iov_length(iov, nr_segs),
 				     server->vals->exclusive_lock_type, NULL,
-				     CIFS_WRITE_OP)) {
-		mutex_lock(&inode->i_mutex);
-		rc = __generic_file_aio_write(iocb, iov, nr_segs,
-					       &iocb->ki_pos);
-		mutex_unlock(&inode->i_mutex);
-	}
-
-	if (rc > 0) {
-		ssize_t err;
-
-		err = generic_write_sync(file, iocb->ki_pos - rc, rc);
-		if (err < 0)
-			rc = err;
-	}
-
+				     CIFS_WRITE_OP))
+		rc = generic_file_aio_write(iocb, iov, nr_segs, pos);
 	up_read(&cinode->lock_sem);
 	return rc;
 }
-- 
1.7.10.4
