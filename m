From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 2/4] FS: cifs, remove unneeded NULL tests
Date: Wed, 27 Oct 2010 13:50:20 +0200
Message-ID: <1288180220-19869-1-git-send-email-jslaby@suse.cz>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jirislaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Stanse found that pSMBFile in cifs_ioctl and file->f_path.dentry in
cifs_user_write are dereferenced prior their test to NULL.

The alternative is not to dereference them before the tests. The patch is
to point out the problem, you have to decide.

Signed-off-by: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/cifs/file.c  |    2 +-
 fs/cifs/ioctl.c |    4 ----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 45af003..db7eaf7 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1031,7 +1031,7 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 	cifs_stats_bytes_written(pTcon, total_written);
 
 	/* since the write may have blocked check these pointers again */
-	if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
+	if (file->f_path.dentry->d_inode) {
 		struct inode *inode = file->f_path.dentry->d_inode;
 /* Do not update local mtime - server will set its actual value on write
  *		inode->i_ctime = inode->i_mtime =
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
