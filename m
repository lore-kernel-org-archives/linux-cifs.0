From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH] cifs: revalidate mapping prior to satisfying read_iter request with cache=loose
Date: Fri, 23 May 2014 06:50:21 -0400
Message-ID: <1400842221-12168-1-git-send-email-jlayton@poochiereds.net>
References: <20140513131616.59f41b7a@canb.auug.org.au>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140513131616.59f41b7a-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Before satisfying a read with cache=loose, we should always check
that the pagecache is valid before allowing a read to be satisfied
out of it.

Reported-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
---
 fs/cifs/cifsfs.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 2c90d07c0b3a..888398067420 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -725,6 +725,19 @@ out_nls:
 	goto out;
 }
 
+static ssize_t
+cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	ssize_t rc;
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	rc = cifs_revalidate_mapping(inode);
+	if (rc)
+		return rc;
+
+	return generic_file_read_iter(iocb, iter);
+}
+
 static ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
@@ -881,7 +894,7 @@ const struct inode_operations cifs_symlink_inode_ops = {
 const struct file_operations cifs_file_ops = {
 	.read = new_sync_read,
 	.write = new_sync_write,
-	.read_iter = generic_file_read_iter,
+	.read_iter = cifs_loose_read_iter,
 	.write_iter = cifs_file_write_iter,
 	.open = cifs_open,
 	.release = cifs_close,
@@ -939,7 +952,7 @@ const struct file_operations cifs_file_direct_ops = {
 const struct file_operations cifs_file_nobrl_ops = {
 	.read = new_sync_read,
 	.write = new_sync_write,
-	.read_iter = generic_file_read_iter,
+	.read_iter = cifs_loose_read_iter,
 	.write_iter = cifs_file_write_iter,
 	.open = cifs_open,
 	.release = cifs_close,
-- 
1.9.0
