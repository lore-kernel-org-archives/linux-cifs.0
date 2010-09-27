From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] CIFS: New read cache mechanism
Date: Mon, 27 Sep 2010 22:31:54 +0400
Message-ID: <AANLkTi=U-4Go7jzMJWQ61j+2v1GXJoMFn5MLUNA4MZ-U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add cifs_sync_read call to provide reading from the cache if we have at least
Level II oplock and otherwise - reading from the server.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 898d2a5..a7361ee 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -549,6 +549,28 @@ cifs_get_sb(struct file_system_type *fs_type,
 	return 0;
 }

+static ssize_t cifs_sync_read(struct file *filp, char __user *buf,
+			      size_t len, loff_t *ppos)
+{
+	ssize_t read;
+	struct cifsInodeInfo *cinode;
+	struct cifs_sb_info *cifs_sb;
+
+	cifs_sb = CIFS_SB(filp->f_path.dentry->d_inode->i_sb);
+
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO))
+		return do_sync_read(filp, buf, len, ppos);
+
+	cinode = CIFS_I(filp->f_path.dentry->d_inode);
+
+	if (cinode->clientCanCacheRead)
+		read = do_sync_read(filp, buf, len, ppos);
+	else
+		read = cifs_user_read(filp, buf, len, ppos);
+
+	return read;
+}
+
 static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				   unsigned long nr_segs, loff_t pos)
 {
@@ -668,7 +690,7 @@ const struct inode_operations cifs_symlink_inode_ops = {
 };

 const struct file_operations cifs_file_ops = {
-	.read = do_sync_read,
+	.read = cifs_sync_read,
 	.write = do_sync_write,
 	.aio_read = generic_file_aio_read,
 	.aio_write = cifs_file_aio_write,
@@ -705,7 +727,7 @@ const struct file_operations cifs_file_direct_ops = {
 	.setlease = cifs_setlease,
 };
 const struct file_operations cifs_file_nobrl_ops = {
-	.read = do_sync_read,
+	.read = cifs_sync_read,
 	.write = do_sync_write,
 	.aio_read = generic_file_aio_read,
 	.aio_write = cifs_file_aio_write,
-- 
1.7.2.1
