From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: Remove some obsolete comments
Date: Wed, 18 May 2016 20:57:33 -0500
Message-ID: <1463623053-117056-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Remove some obsolete comments in the cifs inode_operations
structs that were pointed out by Stephen Rothwell.

CC: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
CC: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/cifsfs.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 67f622d..5d8b7ed 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -890,7 +890,6 @@ const struct inode_operations cifs_dir_inode_ops = {
 	.rmdir = cifs_rmdir,
 	.rename2 = cifs_rename2,
 	.permission = cifs_permission,
-/*	revalidate:cifs_revalidate,   */
 	.setattr = cifs_setattr,
 	.symlink = cifs_symlink,
 	.mknod   = cifs_mknod,
@@ -901,9 +900,8 @@ const struct inode_operations cifs_dir_inode_ops = {
 };
 
 const struct inode_operations cifs_file_inode_ops = {
-/*	revalidate:cifs_revalidate, */
 	.setattr = cifs_setattr,
-	.getattr = cifs_getattr, /* do we need this anymore? */
+	.getattr = cifs_getattr,
 	.permission = cifs_permission,
 	.setxattr = generic_setxattr,
 	.getxattr = generic_getxattr,
@@ -915,9 +913,6 @@ const struct inode_operations cifs_symlink_inode_ops = {
 	.readlink = generic_readlink,
 	.get_link = cifs_get_link,
 	.permission = cifs_permission,
-	/* BB add the following two eventually */
-	/* revalidate: cifs_revalidate,
-	   setattr:    cifs_notify_change, *//* BB do we need notify change */
 	.setxattr = generic_setxattr,
 	.getxattr = generic_getxattr,
 	.listxattr = cifs_listxattr,
-- 
1.9.1
