From: santosh nayak <santoshprasadnayak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cifs: possible memory leak in xattr.
Date: Fri,  2 Mar 2012 11:47:26 +0530
Message-ID: <1330669046-13738-1-git-send-email-santoshprasadnayak@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Santosh Nayak <santoshprasadnayak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Santosh Nayak <santoshprasadnayak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Memory is allocated irrespective of whether CIFS_ACL is configured
or not. But free is happenning only if CIFS_ACL is set. This is a
possible memory leak scenario.

Fix is:
Allocate and free memory only if CIFS_ACL is configured.

Signed-off-by: Santosh Nayak <santoshprasadnayak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/xattr.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 45f07c4..10d92cf 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -105,7 +105,6 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 	struct cifs_tcon *pTcon;
 	struct super_block *sb;
 	char *full_path;
-	struct cifs_ntsd *pacl;
 
 	if (direntry == NULL)
 		return -EIO;
@@ -164,23 +163,24 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	} else if (strncmp(ea_name, CIFS_XATTR_CIFS_ACL,
 			strlen(CIFS_XATTR_CIFS_ACL)) == 0) {
+#ifdef CONFIG_CIFS_ACL
+		struct cifs_ntsd *pacl;
 		pacl = kmalloc(value_size, GFP_KERNEL);
 		if (!pacl) {
 			cFYI(1, "%s: Can't allocate memory for ACL",
 					__func__);
 			rc = -ENOMEM;
 		} else {
-#ifdef CONFIG_CIFS_ACL
 			memcpy(pacl, ea_value, value_size);
 			rc = set_cifs_acl(pacl, value_size,
 				direntry->d_inode, full_path, CIFS_ACL_DACL);
 			if (rc == 0) /* force revalidate of the inode */
 				CIFS_I(direntry->d_inode)->time = 0;
 			kfree(pacl);
+		}
 #else
 			cFYI(1, "Set CIFS ACL not supported yet");
 #endif /* CONFIG_CIFS_ACL */
-		}
 	} else {
 		int temp;
 		temp = strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
-- 
1.7.4.4
