From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/16] cifs: cifs_write argument change and cleanup
Date: Mon, 11 Oct 2010 15:07:25 -0400
Message-ID: <1286824053-12084-9-git-send-email-jlayton@redhat.com>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286824053-12084-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have cifs_write take a cifsFileInfo pointer instead of a filp. Since
cifsFileInfo holds references on the dentry, and that holds one to
the inode, we can eliminate some unneeded NULL pointer checks.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Acked-by: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 fs/cifs/file.c |   51 +++++++++++++++++----------------------------------
 1 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1bcfbcd..a198ff5 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1027,8 +1027,9 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 	return total_written;
 }
 
-static ssize_t cifs_write(struct file *file, const char *write_data,
-			  size_t write_size, loff_t *poffset)
+static ssize_t cifs_write(struct cifsFileInfo *open_file,
+			  const char *write_data, size_t write_size,
+			  loff_t *poffset)
 {
 	int rc = 0;
 	unsigned int bytes_written = 0;
@@ -1036,17 +1037,14 @@ static ssize_t cifs_write(struct file *file, const char *write_data,
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
 	int xid, long_op;
-	struct cifsFileInfo *open_file;
-	struct cifsInodeInfo *cifsi = CIFS_I(file->f_path.dentry->d_inode);
+	struct dentry *dentry = open_file->dentry;
+	struct cifsInodeInfo *cifsi = CIFS_I(dentry->d_inode);
 
-	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	cifs_sb = CIFS_SB(dentry->d_sb);
 
 	cFYI(1, "write %zd bytes to offset %lld of %s", write_size,
-	   *poffset, file->f_path.dentry->d_name.name);
+	   *poffset, dentry->d_name.name);
 
-	if (file->private_data == NULL)
-		return -EBADF;
-	open_file = file->private_data;
 	pTcon = tlink_tcon(open_file->tlink);
 
 	xid = GetXid();
@@ -1056,15 +1054,6 @@ static ssize_t cifs_write(struct file *file, const char *write_data,
 	     total_written += bytes_written) {
 		rc = -EAGAIN;
 		while (rc == -EAGAIN) {
-			if (file->private_data == NULL) {
-				/* file has been closed on us */
-				FreeXid(xid);
-			/* if we have gotten here we have written some data
-			   and blocked, and the file has been freed on us
-			   while we blocked so return what we managed to
-			   write */
-				return total_written;
-			}
 			if (open_file->closePend) {
 				FreeXid(xid);
 				if (total_written)
@@ -1124,20 +1113,13 @@ static ssize_t cifs_write(struct file *file, const char *write_data,
 
 	cifs_stats_bytes_written(pTcon, total_written);
 
-	/* since the write may have blocked check these pointers again */
-	if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
-/*BB We could make this contingent on superblock ATIME flag too */
-/*		file->f_path.dentry->d_inode->i_ctime =
-		file->f_path.dentry->d_inode->i_mtime = CURRENT_TIME;*/
-		if (total_written > 0) {
-			spin_lock(&file->f_path.dentry->d_inode->i_lock);
-			if (*poffset > file->f_path.dentry->d_inode->i_size)
-				i_size_write(file->f_path.dentry->d_inode,
-					     *poffset);
-			spin_unlock(&file->f_path.dentry->d_inode->i_lock);
-		}
-		mark_inode_dirty_sync(file->f_path.dentry->d_inode);
+	if (total_written > 0) {
+		spin_lock(&dentry->d_inode->i_lock);
+		if (*poffset > dentry->d_inode->i_size)
+			i_size_write(dentry->d_inode, *poffset);
+		spin_unlock(&dentry->d_inode->i_lock);
 	}
+	mark_inode_dirty_sync(dentry->d_inode);
 	FreeXid(xid);
 	return total_written;
 }
@@ -1307,8 +1289,8 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 
 	open_file = find_writable_file(CIFS_I(mapping->host), false);
 	if (open_file) {
-		bytes_written = cifs_write(open_file->pfile, write_data,
-					   to-from, &offset);
+		bytes_written = cifs_write(open_file, write_data,
+					   to - from, &offset);
 		cifsFileInfo_put(open_file);
 		/* Does mm or vfs already set times? */
 		inode->i_atime = inode->i_mtime = current_fs_time(inode->i_sb);
@@ -1623,7 +1605,8 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 		/* BB check if anything else missing out of ppw
 		   such as updating last write time */
 		page_data = kmap(page);
-		rc = cifs_write(file, page_data + offset, copied, &pos);
+		rc = cifs_write(file->private_data, page_data + offset,
+				copied, &pos);
 		/* if (rc < 0) should we set writebehind rc? */
 		kunmap(page);
 
-- 
1.7.2.3
