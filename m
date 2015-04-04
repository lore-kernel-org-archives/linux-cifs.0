From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 07/16] cifs: use is_xxx_kiocb instead of filp->fl_flags
Date: Sat,  4 Apr 2015 23:13:16 +0400
Message-ID: <1428174805-853-8-git-send-email-dmonakhov@openvz.org>
References: <1428174805-853-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-cifs@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428174805-853-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Cc: linux-cifs@vger.kernel.org
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/cifs/file.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a94b3e6..25527e9 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2560,7 +2560,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 }
 
 static ssize_t
-cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
+cifs_iovec_write(struct kiocb *iocb, struct iov_iter *from, loff_t *poffset)
 {
 	size_t len;
 	ssize_t total_written = 0;
@@ -2573,7 +2573,7 @@ cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
 	int rc;
 
 	len = iov_iter_count(from);
-	rc = generic_write_checks(file, poffset, &len, 0);
+	rc = generic_write_checks(iocb, poffset, &len, 0);
 	if (rc)
 		return rc;
 
@@ -2583,8 +2583,8 @@ cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
 	iov_iter_truncate(from, len);
 
 	INIT_LIST_HEAD(&wdata_list);
-	cifs_sb = CIFS_FILE_SB(file);
-	open_file = file->private_data;
+	cifs_sb = CIFS_FILE_SB(iocb->ki_filp);
+	open_file = iocb->ki_filp->private_data;
 	tcon = tlink_tcon(open_file->tlink);
 
 	if (!tcon->ses->server->ops->async_writev)
@@ -2670,7 +2670,7 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
 	 * write request.
 	 */
 
-	written = cifs_iovec_write(iocb->ki_filp, from, &pos);
+	written = cifs_iovec_write(iocb, from, &pos);
 	if (written > 0) {
 		set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags);
 		iocb->ki_pos = pos;
@@ -2696,7 +2696,7 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
 	 */
 	down_read(&cinode->lock_sem);
 	mutex_lock(&inode->i_mutex);
-	if (file->f_flags & O_APPEND)
+	if (is_append_kiocb(iocb))
 		lock_pos = i_size_read(inode);
 	if (!cifs_find_lock_conflict(cfile, lock_pos, iov_iter_count(from),
 				     server->vals->exclusive_lock_type, NULL,
-- 
1.7.1
