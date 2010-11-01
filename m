From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v2 1/1] FS: cifs, remove unneeded NULL tests
Date: Mon,  1 Nov 2010 16:08:55 +0100
Message-ID: <1288624135-24170-1-git-send-email-jslaby@suse.cz>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	linux-cifs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: sfrench@samba.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Stanse found that pSMBFile in cifs_ioctl and file->f_path.dentry in
cifs_user_write are dereferenced prior their test to NULL.

The alternative is not to dereference them before the tests. The patch is
to point out the problem, you have to decide.

While at it we cache the inode in cifs_user_write to a local variable
and use all over the function.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/cifs/file.c  |   25 +++++++++++--------------
 fs/cifs/ioctl.c |    4 ----
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ae82159..5d06eb3 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -956,6 +956,7 @@ cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
 ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 	size_t write_size, loff_t *poffset)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int rc = 0;
 	unsigned int bytes_written = 0;
 	unsigned int total_written;
@@ -963,7 +964,7 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 	struct cifsTconInfo *pTcon;
 	int xid, long_op;
 	struct cifsFileInfo *open_file;
-	struct cifsInodeInfo *cifsi = CIFS_I(file->f_path.dentry->d_inode);
+	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 
@@ -1029,21 +1030,17 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 
 	cifs_stats_bytes_written(pTcon, total_written);
 
-	/* since the write may have blocked check these pointers again */
-	if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
-		struct inode *inode = file->f_path.dentry->d_inode;
 /* Do not update local mtime - server will set its actual value on write
- *		inode->i_ctime = inode->i_mtime =
- * 			current_fs_time(inode->i_sb);*/
-		if (total_written > 0) {
-			spin_lock(&inode->i_lock);
-			if (*poffset > file->f_path.dentry->d_inode->i_size)
-				i_size_write(file->f_path.dentry->d_inode,
-					*poffset);
-			spin_unlock(&inode->i_lock);
-		}
-		mark_inode_dirty_sync(file->f_path.dentry->d_inode);
+ *	inode->i_ctime = inode->i_mtime =
+ * 		current_fs_time(inode->i_sb);*/
+	if (total_written > 0) {
+		spin_lock(&inode->i_lock);
+		if (*poffset > inode->i_size)
+			i_size_write(inode, *poffset);
+		spin_unlock(&inode->i_lock);
 	}
+	mark_inode_dirty_sync(inode);
+
 	FreeXid(xid);
 	return total_written;
 }
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 077bf75..2fa22f2 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -63,8 +63,6 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 #ifdef CONFIG_CIFS_POSIX
 		case FS_IOC_GETFLAGS:
 			if (CIFS_UNIX_EXTATTR_CAP & caps) {
-				if (pSMBFile == NULL)
-					break;
 				rc = CIFSGetExtAttr(xid, tcon, pSMBFile->netfid,
 					&ExtAttrBits, &ExtAttrMask);
 				if (rc == 0)
@@ -80,8 +78,6 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 					rc = -EFAULT;
 					break;
 				}
-				if (pSMBFile == NULL)
-					break;
 				/* rc= CIFSGetExtAttr(xid,tcon,pSMBFile->netfid,
 					extAttrBits, &ExtAttrMask);*/
 			}
-- 
1.7.3.1


