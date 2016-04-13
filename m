From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5/8] ceph: Switch to generic xattr handlers
Date: Thu, 14 Apr 2016 00:27:43 +0200
Message-ID: <1460586466-5518-6-git-send-email-agruenba@redhat.com>
References: <1460586466-5518-1-git-send-email-agruenba@redhat.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org, cluster-devel@redhat.com,
	"Yan, Zheng" <zyan@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <1460586466-5518-1-git-send-email-agruenba@redhat.com>
In-Reply-To: <20160413182026.GR25498@ZenIV.linux.org.uk>
References: <20160413182026.GR25498@ZenIV.linux.org.uk>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Add a catch-all xattr handler at the end of ceph_xattr_handlers.  Check
for valid attribute names there, and remove those checks from
__ceph_{get,set,remove}xattr instead.  No "system.*" xattrs need to be
handled by the catch-all handler anymore.

The set xattr handler is called with a NULL value to indicate that the
attribute should be removed; __ceph_setxattr already handles that case
correctly (ceph_set_acl could already calling __ceph_setxattr with a NULL
value).

Move the check for snapshots from ceph_{set,remove}xattr into
__ceph_{set,remove}xattr.  With that, ceph_{get,set,remove}xattr can be
replaced with the generic iops.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/dir.c   |  7 +++---
 fs/ceph/inode.c | 13 ++++++------
 fs/ceph/super.h |  4 ----
 fs/ceph/xattr.c | 66 +++++++++++++++++++++++----------------------------------
 4 files changed, 38 insertions(+), 52 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index fadc243..2e0afdc 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -5,6 +5,7 @@
 #include <linux/namei.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/xattr.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -1342,10 +1343,10 @@ const struct inode_operations ceph_dir_iops = {
 	.permission = ceph_permission,
 	.getattr = ceph_getattr,
 	.setattr = ceph_setattr,
-	.setxattr = ceph_setxattr,
-	.getxattr = ceph_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = ceph_listxattr,
-	.removexattr = ceph_removexattr,
+	.removexattr = generic_removexattr,
 	.get_acl = ceph_get_acl,
 	.set_acl = ceph_set_acl,
 	.mknod = ceph_mknod,
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index cadb6ae..addf8ef 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/writeback.h>
 #include <linux/vmalloc.h>
+#include <linux/xattr.h>
 #include <linux/posix_acl.h>
 #include <linux/random.h>
 
@@ -92,10 +93,10 @@ const struct inode_operations ceph_file_iops = {
 	.permission = ceph_permission,
 	.setattr = ceph_setattr,
 	.getattr = ceph_getattr,
-	.setxattr = ceph_setxattr,
-	.getxattr = ceph_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = ceph_listxattr,
-	.removexattr = ceph_removexattr,
+	.removexattr = generic_removexattr,
 	.get_acl = ceph_get_acl,
 	.set_acl = ceph_set_acl,
 };
@@ -1770,10 +1771,10 @@ static const struct inode_operations ceph_symlink_iops = {
 	.get_link = simple_get_link,
 	.setattr = ceph_setattr,
 	.getattr = ceph_getattr,
-	.setxattr = ceph_setxattr,
-	.getxattr = ceph_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = ceph_listxattr,
-	.removexattr = ceph_removexattr,
+	.removexattr = generic_removexattr,
 };
 
 int __ceph_setattr(struct inode *inode, struct iattr *attr)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 1e41bc2..7b99eb7 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -791,13 +791,9 @@ extern int ceph_getattr(struct vfsmount *mnt, struct dentry *dentry,
 			struct kstat *stat);
 
 /* xattr.c */
-extern int ceph_setxattr(struct dentry *, const char *, const void *,
-			 size_t, int);
 int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
 ssize_t __ceph_getxattr(struct inode *, const char *, void *, size_t);
-extern ssize_t ceph_getxattr(struct dentry *, struct inode *, const char *, void *, size_t);
 extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
-extern int ceph_removexattr(struct dentry *, const char *);
 extern void __ceph_build_xattrs_blob(struct ceph_inode_info *ci);
 extern void __ceph_destroy_xattrs(struct ceph_inode_info *ci);
 extern void __init ceph_xattr_init(void);
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 248e32e3..8966e9d 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -16,6 +16,8 @@
 static int __remove_xattr(struct ceph_inode_info *ci,
 			  struct ceph_inode_xattr *xattr);
 
+const struct xattr_handler ceph_other_xattr_handler;
+
 /*
  * List of handlers for synthetic system.* attributes. Other
  * attributes are handled directly.
@@ -25,6 +27,7 @@ const struct xattr_handler *ceph_xattr_handlers[] = {
 	&posix_acl_access_xattr_handler,
 	&posix_acl_default_xattr_handler,
 #endif
+	&ceph_other_xattr_handler,
 	NULL,
 };
 
@@ -33,7 +36,6 @@ static bool ceph_is_valid_xattr(const char *name)
 	return !strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN) ||
 	       !strncmp(name, XATTR_SECURITY_PREFIX,
 			XATTR_SECURITY_PREFIX_LEN) ||
-	       !strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN) ||
 	       !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||
 	       !strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
 }
@@ -740,9 +742,6 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 	int req_mask;
 	int err;
 
-	if (!ceph_is_valid_xattr(name))
-		return -ENODATA;
-
 	/* let's see if a virtual xattr was requested */
 	vxattr = ceph_match_vxattr(inode, name);
 	if (vxattr) {
@@ -804,15 +803,6 @@ out:
 	return err;
 }
 
-ssize_t ceph_getxattr(struct dentry *dentry, struct inode *inode,
-		      const char *name, void *value, size_t size)
-{
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		return generic_getxattr(dentry, inode, name, value, size);
-
-	return __ceph_getxattr(inode, name, value, size);
-}
-
 ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
 {
 	struct inode *inode = d_inode(dentry);
@@ -956,8 +946,8 @@ int __ceph_setxattr(struct inode *inode, const char *name,
 	int required_blob_size;
 	bool lock_snap_rwsem = false;
 
-	if (!ceph_is_valid_xattr(name))
-		return -EOPNOTSUPP;
+	if (ceph_snap(inode) != CEPH_NOSNAP)
+		return -EROFS;
 
 	vxattr = ceph_match_vxattr(inode, name);
 	if (vxattr && vxattr->readonly)
@@ -1064,21 +1054,6 @@ out:
 	return err;
 }
 
-int ceph_setxattr(struct dentry *dentry, const char *name,
-		  const void *value, size_t size, int flags)
-{
-	if (ceph_snap(d_inode(dentry)) != CEPH_NOSNAP)
-		return -EROFS;
-
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		return generic_setxattr(dentry, name, value, size, flags);
-
-	if (size == 0)
-		value = "";  /* empty EA, do not remove */
-
-	return __ceph_setxattr(d_inode(dentry), name, value, size, flags);
-}
-
 static int ceph_send_removexattr(struct inode *inode, const char *name)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
@@ -1115,8 +1090,8 @@ static int __ceph_removexattr(struct inode *inode, const char *name)
 	int dirty;
 	bool lock_snap_rwsem = false;
 
-	if (!ceph_is_valid_xattr(name))
-		return -EOPNOTSUPP;
+	if (ceph_snap(inode) != CEPH_NOSNAP)
+		return -EROFS;
 
 	vxattr = ceph_match_vxattr(inode, name);
 	if (vxattr && vxattr->readonly)
@@ -1192,17 +1167,30 @@ do_sync_unlocked:
 	return err;
 }
 
-int ceph_removexattr(struct dentry *dentry, const char *name)
+static int ceph_get_xattr_handler(const struct xattr_handler *handler,
+				  struct dentry *dentry, struct inode *inode,
+				  const char *name, void *value, size_t size)
 {
-	if (ceph_snap(d_inode(dentry)) != CEPH_NOSNAP)
-		return -EROFS;
-
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		return generic_removexattr(dentry, name);
+	if (!ceph_is_valid_xattr(name))
+		return -EOPNOTSUPP;
+	return __ceph_getxattr(inode, name, value, size);
+}
 
-	return __ceph_removexattr(d_inode(dentry), name);
+static int ceph_set_xattr_handler(const struct xattr_handler *handler,
+				  struct dentry *dentry, const char *name,
+				  const void *value, size_t size, int flags)
+{
+	if (!ceph_is_valid_xattr(name))
+		return -EOPNOTSUPP;
+	return __ceph_setxattr(d_inode(dentry), name, value, size, flags);
 }
 
+const struct xattr_handler ceph_other_xattr_handler = {
+	.prefix = "",  /* match any name => handlers called with full name */
+	.get = ceph_get_xattr_handler,
+	.set = ceph_set_xattr_handler,
+};
+
 #ifdef CONFIG_SECURITY
 bool ceph_security_xattr_wanted(struct inode *in)
 {
-- 
2.4.11

