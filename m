From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] cifs: avoid unused variable and label
Date: Tue, 08 Dec 2015 16:18:51 +0100
Message-ID: <1626899.G9TJfXXyu0@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The newly introduced cifs_clone_file_range() function produces
two harmless compile-time warnings:

cifsfs.c: In function 'cifs_clone_file_range':
cifsfs.c:963:1: warning: label 'out_unlock' defined but not used [-Wunused-label]
cifsfs.c:924:20: warning: unused variable 'src_tcon' [-Wunused-variable]

In both cases, removing the extraneous line avoids the warning.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Fixes: c6f2a1e2e5f8 ("vfs: pull btrfs clone API to vfs layer")
---
 fs/cifs/cifsfs.c | 2 --
 1 file changed, 2 deletions(-)

Found on ARM allmodconfig builds.

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5cc7f5390a2a..b4d1cca853fc 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -921,7 +921,6 @@ static int cifs_clone_file_range(struct file *src_file, loff_t off,
 	struct inode *target_inode = file_inode(dst_file);
 	struct cifsFileInfo *smb_file_src = src_file->private_data;
 	struct cifsFileInfo *smb_file_target = dst_file->private_data;
-	struct cifs_tcon *src_tcon = tlink_tcon(smb_file_src->tlink);
 	struct cifs_tcon *target_tcon = tlink_tcon(smb_file_target->tlink);
 	unsigned int xid;
 	int rc;
@@ -960,7 +959,6 @@ static int cifs_clone_file_range(struct file *src_file, loff_t off,
 	/* force revalidate of size and timestamps of target file now
 	   that target is updated on the server */
 	CIFS_I(target_inode)->time = 0;
-out_unlock:
 	/* although unlocking in the reverse order from locking is not
 	   strictly necessary here it is a little cleaner to be consistent */
 	unlock_two_nondirectories(src_inode, target_inode);
-- 
2.1.0.rc2
