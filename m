From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: New read cache mechanism
Date: Sat, 18 Sep 2010 10:32:03 +0400
Message-ID: <AANLkTinA+YpcYFF6YE-df7sg-thCg87_7Bn5qjC+LxYH@mail.gmail.com>
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
 fs/cifs/cifsfs.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b7431af..ba70048 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -533,6 +533,25 @@ cifs_get_sb(struct file_system_type *fs_type,
 	return 0;
 }

+static ssize_t cifs_sync_read(struct file *filp, char __user *buf,
+			      size_t len, loff_t *ppos)
+{
+	ssize_t read;
+	struct cifsInodeInfo *cinode;
+
+	if (filp && filp->f_path.dentry && filp->f_path.dentry->d_inode)
+		cinode = CIFS_I(filp->f_path.dentry->d_inode);
+	else
+		return -ENOENT;
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
@@ -652,7 +671,7 @@ const struct inode_operations cifs_symlink_inode_ops = {
 };

 const struct file_operations cifs_file_ops = {
-	.read = do_sync_read,
+	.read = cifs_sync_read,
 	.write = do_sync_write,
 	.aio_read = generic_file_aio_read,
 	.aio_write = cifs_file_aio_write,
@@ -689,7 +708,7 @@ const struct file_operations cifs_file_direct_ops = {
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
