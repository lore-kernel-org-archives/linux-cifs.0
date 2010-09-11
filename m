From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: New read/write cache mechanism
Date: Sat, 11 Sep 2010 14:40:10 +0400
Message-ID: <AANLkTi=VJ+eWqa0ABHJ=464yWN5jEoRVamOia2Xt3Zgm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We can do read/write ops with a cache only if we have an Exclusive Oplock
and read from the cache if we have Oplock Level II. In other cases we do
read/write ops with a server.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |   31 +++++++++++++++++++------------
 fs/cifs/file.c   |   11 +++++++++--
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b7431af..f56e67f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -533,16 +533,23 @@ cifs_get_sb(struct file_system_type *fs_type,
 	return 0;
 }

-static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-				   unsigned long nr_segs, loff_t pos)
+static ssize_t cifs_sync_read(struct file *filp, char __user *buf,
+			      size_t len, loff_t *ppos)
 {
-	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
-	ssize_t written;
+	ssize_t read;
+	struct cifsInodeInfo *cinode;

-	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
-	if (!CIFS_I(inode)->clientCanCacheAll)
-		filemap_fdatawrite(inode->i_mapping);
-	return written;
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
 }

 static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
@@ -652,10 +659,10 @@ const struct inode_operations cifs_symlink_inode_ops = {
 };

 const struct file_operations cifs_file_ops = {
-	.read = do_sync_read,
+	.read = cifs_sync_read,
 	.write = do_sync_write,
 	.aio_read = generic_file_aio_read,
-	.aio_write = cifs_file_aio_write,
+	.aio_write = generic_file_aio_write,
 	.open = cifs_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
@@ -689,10 +696,10 @@ const struct file_operations cifs_file_direct_ops = {
 	.setlease = cifs_setlease,
 };
 const struct file_operations cifs_file_nobrl_ops = {
-	.read = do_sync_read,
+	.read = cifs_sync_read,
 	.write = do_sync_write,
 	.aio_read = generic_file_aio_read,
-	.aio_write = cifs_file_aio_write,
+	.aio_write = generic_file_aio_write,
 	.open = cifs_open,
 	.release = cifs_close,
 	.fsync = cifs_fsync,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index de748c6..df52282 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -211,8 +211,14 @@ client_can_cache:
 		pCifsInode->clientCanCacheAll = true;
 		pCifsInode->clientCanCacheRead = true;
 		cFYI(1, "Exclusive Oplock granted on inode %p", inode);
-	} else if ((*oplock & 0xF) == OPLOCK_READ)
+	} else if ((*oplock & 0xF) == OPLOCK_READ) {
+		pCifsInode->clientCanCacheAll = false;
 		pCifsInode->clientCanCacheRead = true;
+		cFYI(1, "Level II Oplock franted on inode %p", inode);
+	} else {
+		pCifsInode->clientCanCacheAll = false;
+		pCifsInode->clientCanCacheRead = false;
+	}

 	return rc;
 }
@@ -633,6 +639,7 @@ int cifs_close(struct inode *inode, struct file *file)
 		   on this inode, much less write behind and read ahead */
 		CIFS_I(inode)->clientCanCacheRead = false;
 		CIFS_I(inode)->clientCanCacheAll  = false;
+		invalidate_remote_inode(inode);
 	}
 	read_unlock(&GlobalSMBSeslock);
 	if ((rc == 0) && CIFS_I(inode)->write_behind_rc)
@@ -1612,7 +1619,7 @@ static int cifs_write_end(struct file *file,
struct address_space *mapping,
 	} else if (!PageUptodate(page) && copied == PAGE_CACHE_SIZE)
 		SetPageUptodate(page);

-	if (!PageUptodate(page)) {
+	if (!PageUptodate(page) || !CIFS_I(inode)->clientCanCacheAll) {
 		char *page_data;
 		unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
 		int xid;
-- 
1.7.2.1
