From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] CIFS: New read logic
Date: Tue,  2 Nov 2010 22:44:19 +0300
Message-ID: <1288727061-18759-2-git-send-email-piastryyy@gmail.com>
References: <1288727061-18759-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288727061-18759-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add cifs_file_aio_read to let the client works with strict cache mode.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 38526a6..bb7f36e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -569,6 +569,30 @@ cifs_do_mount(struct file_system_type *fs_type,
 	return dget(sb->s_root);
 }
 
+static ssize_t cifs_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
+				   unsigned long nr_segs, loff_t pos)
+{
+	struct inode *inode;
+	struct cifs_sb_info *cifs_sb;
+	ssize_t read;
+
+	inode = iocb->ki_filp->f_path.dentry->d_inode;
+	cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
+
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) == 0)
+		/* BB call cifs_revalidate_file before generic_file_aio_read */
+		return generic_file_aio_read(iocb, iov, nr_segs, pos);
+
+	if (!CIFS_I(inode)->clientCanCacheRead) {
+		read = cifs_user_read(iocb->ki_filp, iov->iov_base,
+				      iov->iov_len, &pos);
+		iocb->ki_pos = pos;
+	} else
+		read = generic_file_aio_read(iocb, iov, nr_segs, pos);
+
+	return read;
+}
+
 static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				   unsigned long nr_segs, loff_t pos)
 {
@@ -691,7 +715,7 @@ const struct inode_operations cifs_symlink_inode_ops = {
 const struct file_operations cifs_file_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
-	.aio_read = generic_file_aio_read,
+	.aio_read = cifs_file_aio_read,
 	.aio_write = cifs_file_aio_write,
 	.open = cifs_open,
 	.release = cifs_close,
@@ -728,7 +752,7 @@ const struct file_operations cifs_file_direct_ops = {
 const struct file_operations cifs_file_nobrl_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
-	.aio_read = generic_file_aio_read,
+	.aio_read = cifs_file_aio_read,
 	.aio_write = cifs_file_aio_write,
 	.open = cifs_open,
 	.release = cifs_close,
-- 
1.7.2.3
