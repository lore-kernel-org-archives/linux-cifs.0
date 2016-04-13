From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 4/8] ceph: Get rid of d_find_alias in ceph_set_acl
Date: Thu, 14 Apr 2016 00:30:16 +0200
Message-ID: <1460586620-5717-5-git-send-email-agruenba@redhat.com>
References: <1460586620-5717-1-git-send-email-agruenba@redhat.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org, cluster-devel@redhat.com,
	"Yan, Zheng" <zyan@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <1460586620-5717-1-git-send-email-agruenba@redhat.com>
In-Reply-To: <20160413182026.GR25498@ZenIV.linux.org.uk>
References: <20160413182026.GR25498@ZenIV.linux.org.uk>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Create a variant of ceph_setattr that takes an inode instead of a
dentry.  Change __ceph_setxattr (and also __ceph_removexattr) to take an
inode instead of a dentry.  Use those in ceph_set_acl so that we no
longer need a dentry there.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/acl.c   | 14 +++++---------
 fs/ceph/inode.c | 16 ++++++++++------
 fs/ceph/super.h |  4 ++--
 fs/ceph/xattr.c | 28 ++++++++++++----------------
 4 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 5457f216..4f67227 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -90,7 +90,6 @@ int ceph_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	char *value = NULL;
 	struct iattr newattrs;
 	umode_t new_mode = inode->i_mode, old_mode = inode->i_mode;
-	struct dentry *dentry;
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
@@ -128,29 +127,26 @@ int ceph_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 			goto out_free;
 	}
 
-	dentry = d_find_alias(inode);
 	if (new_mode != old_mode) {
 		newattrs.ia_mode = new_mode;
 		newattrs.ia_valid = ATTR_MODE;
-		ret = ceph_setattr(dentry, &newattrs);
+		ret = __ceph_setattr(inode, &newattrs);
 		if (ret)
-			goto out_dput;
+			goto out_free;
 	}
 
-	ret = __ceph_setxattr(dentry, name, value, size, 0);
+	ret = __ceph_setxattr(inode, name, value, size, 0);
 	if (ret) {
 		if (new_mode != old_mode) {
 			newattrs.ia_mode = old_mode;
 			newattrs.ia_valid = ATTR_MODE;
-			ceph_setattr(dentry, &newattrs);
+			__ceph_setattr(inode, &newattrs);
 		}
-		goto out_dput;
+		goto out_free;
 	}
 
 	ceph_set_cached_acl(inode, type, acl);
 
-out_dput:
-	dput(dentry);
 out_free:
 	kfree(value);
 out:
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index ed58b16..cadb6ae 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1776,16 +1776,12 @@ static const struct inode_operations ceph_symlink_iops = {
 	.removexattr = ceph_removexattr,
 };
 
-/*
- * setattr
- */
-int ceph_setattr(struct dentry *dentry, struct iattr *attr)
+int __ceph_setattr(struct inode *inode, struct iattr *attr)
 {
-	struct inode *inode = d_inode(dentry);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	const unsigned int ia_valid = attr->ia_valid;
 	struct ceph_mds_request *req;
-	struct ceph_mds_client *mdsc = ceph_sb_to_client(dentry->d_sb)->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_cap_flush *prealloc_cf;
 	int issued;
 	int release = 0, dirtied = 0;
@@ -2010,6 +2006,14 @@ out_put:
 }
 
 /*
+ * setattr
+ */
+int ceph_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	return __ceph_setattr(d_inode(dentry), attr);
+}
+
+/*
  * Verify that we have a lease on the given mask.  If not,
  * do a getattr against an mds.
  */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index beb893b..1e41bc2 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -785,6 +785,7 @@ static inline int ceph_do_getattr(struct inode *inode, int mask, bool force)
 	return __ceph_do_getattr(inode, NULL, mask, force);
 }
 extern int ceph_permission(struct inode *inode, int mask);
+extern int __ceph_setattr(struct inode *inode, struct iattr *attr);
 extern int ceph_setattr(struct dentry *dentry, struct iattr *attr);
 extern int ceph_getattr(struct vfsmount *mnt, struct dentry *dentry,
 			struct kstat *stat);
@@ -792,9 +793,8 @@ extern int ceph_getattr(struct vfsmount *mnt, struct dentry *dentry,
 /* xattr.c */
 extern int ceph_setxattr(struct dentry *, const char *, const void *,
 			 size_t, int);
-int __ceph_setxattr(struct dentry *, const char *, const void *, size_t, int);
+int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
 ssize_t __ceph_getxattr(struct inode *, const char *, void *, size_t);
-int __ceph_removexattr(struct dentry *, const char *);
 extern ssize_t ceph_getxattr(struct dentry *, struct inode *, const char *, void *, size_t);
 extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
 extern int ceph_removexattr(struct dentry *, const char *);
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index c6e917d..248e32e3 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -877,11 +877,10 @@ out:
 	return err;
 }
 
-static int ceph_sync_setxattr(struct dentry *dentry, const char *name,
+static int ceph_sync_setxattr(struct inode *inode, const char *name,
 			      const char *value, size_t size, int flags)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
-	struct inode *inode = d_inode(dentry);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
@@ -939,13 +938,12 @@ out:
 	return err;
 }
 
-int __ceph_setxattr(struct dentry *dentry, const char *name,
+int __ceph_setxattr(struct inode *inode, const char *name,
 			const void *value, size_t size, int flags)
 {
-	struct inode *inode = d_inode(dentry);
 	struct ceph_vxattr *vxattr;
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_mds_client *mdsc = ceph_sb_to_client(dentry->d_sb)->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_cap_flush *prealloc_cf = NULL;
 	int issued;
 	int err;
@@ -1056,7 +1054,7 @@ do_sync_unlocked:
 				    "during filling trace\n", inode);
 		err = -EBUSY;
 	} else {
-		err = ceph_sync_setxattr(dentry, name, value, size, flags);
+		err = ceph_sync_setxattr(inode, name, value, size, flags);
 	}
 out:
 	ceph_free_cap_flush(prealloc_cf);
@@ -1078,14 +1076,13 @@ int ceph_setxattr(struct dentry *dentry, const char *name,
 	if (size == 0)
 		value = "";  /* empty EA, do not remove */
 
-	return __ceph_setxattr(dentry, name, value, size, flags);
+	return __ceph_setxattr(d_inode(dentry), name, value, size, flags);
 }
 
-static int ceph_send_removexattr(struct dentry *dentry, const char *name)
+static int ceph_send_removexattr(struct inode *inode, const char *name)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
-	struct inode *inode = d_inode(dentry);
 	struct ceph_mds_request *req;
 	int err;
 
@@ -1106,12 +1103,11 @@ static int ceph_send_removexattr(struct dentry *dentry, const char *name)
 	return err;
 }
 
-int __ceph_removexattr(struct dentry *dentry, const char *name)
+static int __ceph_removexattr(struct inode *inode, const char *name)
 {
-	struct inode *inode = d_inode(dentry);
 	struct ceph_vxattr *vxattr;
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_mds_client *mdsc = ceph_sb_to_client(dentry->d_sb)->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_cap_flush *prealloc_cf = NULL;
 	int issued;
 	int err;
@@ -1192,7 +1188,7 @@ do_sync_unlocked:
 	if (lock_snap_rwsem)
 		up_read(&mdsc->snap_rwsem);
 	ceph_free_cap_flush(prealloc_cf);
-	err = ceph_send_removexattr(dentry, name);
+	err = ceph_send_removexattr(inode, name);
 	return err;
 }
 
@@ -1204,7 +1200,7 @@ int ceph_removexattr(struct dentry *dentry, const char *name)
 	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
 		return generic_removexattr(dentry, name);
 
-	return __ceph_removexattr(dentry, name);
+	return __ceph_removexattr(d_inode(dentry), name);
 }
 
 #ifdef CONFIG_SECURITY
-- 
2.4.11

