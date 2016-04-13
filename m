From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 8/8] gfs2: Switch to generic xattr handlers
Date: Thu, 14 Apr 2016 00:27:46 +0200
Message-ID: <1460586466-5518-9-git-send-email-agruenba@redhat.com>
References: <1460586466-5518-1-git-send-email-agruenba@redhat.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org, cluster-devel@redhat.com
To: unlisted-recipients:; (no To-header on input)
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <1460586466-5518-1-git-send-email-agruenba@redhat.com>
In-Reply-To: <20160413182026.GR25498@ZenIV.linux.org.uk>
References: <20160413182026.GR25498@ZenIV.linux.org.uk>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Move the pre- and postamble code in gfs2_{get,set,remove}xattr into the
handlers in gfs2_xattr_handlers.  Replace the generic POSIX ACL handlers
in there with gfs2-specific versions that wrap the generic handlers into
the pre- and postamble code.  With that, gfs2_{get,set,remove}xattr can
be removed and replaced with the generic inode operations.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
---
 fs/gfs2/inode.c |  78 +++++-----------------------------------
 fs/gfs2/xattr.c | 108 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 109 insertions(+), 77 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 45f516ca..3398342 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1948,66 +1948,6 @@ static int gfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	return 0;
 }
 
-static int gfs2_setxattr(struct dentry *dentry, const char *name,
-			 const void *data, size_t size, int flags)
-{
-	struct inode *inode = d_inode(dentry);
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_holder gh;
-	int ret;
-
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
-	ret = gfs2_glock_nq(&gh);
-	if (ret == 0) {
-		ret = gfs2_rsqa_alloc(ip);
-		if (ret == 0)
-			ret = generic_setxattr(dentry, name, data, size, flags);
-		gfs2_glock_dq(&gh);
-	}
-	gfs2_holder_uninit(&gh);
-	return ret;
-}
-
-static ssize_t gfs2_getxattr(struct dentry *dentry, struct inode *inode,
-			     const char *name, void *data, size_t size)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_holder gh;
-	int ret;
-
-	/* For selinux during lookup */
-	if (gfs2_glock_is_locked_by_me(ip->i_gl))
-		return generic_getxattr(dentry, inode, name, data, size);
-
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
-	ret = gfs2_glock_nq(&gh);
-	if (ret == 0) {
-		ret = generic_getxattr(dentry, inode, name, data, size);
-		gfs2_glock_dq(&gh);
-	}
-	gfs2_holder_uninit(&gh);
-	return ret;
-}
-
-static int gfs2_removexattr(struct dentry *dentry, const char *name)
-{
-	struct inode *inode = d_inode(dentry);
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_holder gh;
-	int ret;
-
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
-	ret = gfs2_glock_nq(&gh);
-	if (ret == 0) {
-		ret = gfs2_rsqa_alloc(ip);
-		if (ret == 0)
-			ret = generic_removexattr(dentry, name);
-		gfs2_glock_dq(&gh);
-	}
-	gfs2_holder_uninit(&gh);
-	return ret;
-}
-
 static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len)
 {
@@ -2054,10 +1994,10 @@ const struct inode_operations gfs2_file_iops = {
 	.permission = gfs2_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
-	.setxattr = gfs2_setxattr,
-	.getxattr = gfs2_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = gfs2_listxattr,
-	.removexattr = gfs2_removexattr,
+	.removexattr = generic_removexattr,
 	.fiemap = gfs2_fiemap,
 	.get_acl = gfs2_get_acl,
 	.set_acl = gfs2_set_acl,
@@ -2076,10 +2016,10 @@ const struct inode_operations gfs2_dir_iops = {
 	.permission = gfs2_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
-	.setxattr = gfs2_setxattr,
-	.getxattr = gfs2_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = gfs2_listxattr,
-	.removexattr = gfs2_removexattr,
+	.removexattr = generic_removexattr,
 	.fiemap = gfs2_fiemap,
 	.get_acl = gfs2_get_acl,
 	.set_acl = gfs2_set_acl,
@@ -2092,10 +2032,10 @@ const struct inode_operations gfs2_symlink_iops = {
 	.permission = gfs2_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
-	.setxattr = gfs2_setxattr,
-	.getxattr = gfs2_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = gfs2_listxattr,
-	.removexattr = gfs2_removexattr,
+	.removexattr = generic_removexattr,
 	.fiemap = gfs2_fiemap,
 };
 
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 619886b..92d5b4c 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -583,13 +583,11 @@ out:
  *
  * Returns: actual size of data on success, -errno on error
  */
-static int gfs2_xattr_get(const struct xattr_handler *handler,
-			  struct dentry *unused, struct inode *inode,
-			  const char *name, void *buffer, size_t size)
+static int __gfs2_xattr_get(struct inode *inode, const char *name,
+			    void *buffer, size_t size, int type)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_ea_location el;
-	int type = handler->flags;
 	int error;
 
 	if (!ip->i_eattr)
@@ -611,6 +609,28 @@ static int gfs2_xattr_get(const struct xattr_handler *handler,
 	return error;
 }
 
+static int gfs2_xattr_get(const struct xattr_handler *handler,
+			  struct dentry *unused, struct inode *inode,
+			  const char *name, void *buffer, size_t size)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	int ret;
+
+	/* For selinux during lookup */
+	if (gfs2_glock_is_locked_by_me(ip->i_gl))
+		return __gfs2_xattr_get(inode, name, buffer, size, handler->flags);
+
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
+	ret = gfs2_glock_nq(&gh);
+	if (ret == 0) {
+		ret = __gfs2_xattr_get(inode, name, buffer, size, handler->flags);
+		gfs2_glock_dq(&gh);
+	}
+	gfs2_holder_uninit(&gh);
+	return ret;
+}
+
 /**
  * ea_alloc_blk - allocates a new block for extended attributes.
  * @ip: A pointer to the inode that's getting extended attributes
@@ -1233,8 +1253,23 @@ static int gfs2_xattr_set(const struct xattr_handler *handler,
 			  struct dentry *dentry, const char *name,
 			  const void *value, size_t size, int flags)
 {
-	return __gfs2_xattr_set(d_inode(dentry), name, value,
-				size, flags, handler->flags);
+	struct inode *inode = d_inode(dentry);
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	int ret;
+
+	ret = gfs2_rsqa_alloc(ip);
+	if (ret)
+		return ret;
+
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	ret = gfs2_glock_nq(&gh);
+	if (ret == 0) {
+		ret = __gfs2_xattr_set(inode, name, value, size, flags, handler->flags);
+		gfs2_glock_dq(&gh);
+	}
+	gfs2_holder_uninit(&gh);
+	return ret;
 }
 
 static int ea_dealloc_indirect(struct gfs2_inode *ip)
@@ -1437,6 +1472,63 @@ out_quota:
 	return error;
 }
 
+static int gfs2_posix_acl_xattr_get(const struct xattr_handler *handler,
+				    struct dentry *dentry, struct inode *inode,
+				    const char *name, void *buffer, size_t size)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	int ret;
+
+	/* For selinux during lookup */
+	if (gfs2_glock_is_locked_by_me(ip->i_gl))
+		return posix_acl_xattr_get(handler, dentry, inode, name, buffer, size);
+
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
+	ret = gfs2_glock_nq(&gh);
+	if (ret == 0) {
+		ret = posix_acl_xattr_get(handler, dentry, inode, name, buffer, size);
+		gfs2_glock_dq(&gh);
+	}
+	gfs2_holder_uninit(&gh);
+	return ret;
+}
+
+static int gfs2_posix_acl_xattr_set(const struct xattr_handler *handler,
+				    struct dentry *dentry, const char *name,
+				    const void *value, size_t size, int flags)
+{
+	struct inode *inode = d_inode(dentry);
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	int ret;
+
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	ret = gfs2_glock_nq(&gh);
+	if (ret == 0) {
+		ret = posix_acl_xattr_set(handler, dentry, name, value, size, flags);
+		gfs2_glock_dq(&gh);
+	}
+	gfs2_holder_uninit(&gh);
+	return ret;
+}
+
+static const struct xattr_handler gfs2_posix_acl_access_xattr_handler = {
+	.name = XATTR_NAME_POSIX_ACL_ACCESS,
+	.flags = ACL_TYPE_ACCESS,
+	.list = posix_acl_xattr_list,
+	.get = gfs2_posix_acl_xattr_get,
+	.set = gfs2_posix_acl_xattr_set,
+};
+
+static const struct xattr_handler gfs2_posix_acl_default_xattr_handler = {
+	.name = XATTR_NAME_POSIX_ACL_DEFAULT,
+	.flags = ACL_TYPE_DEFAULT,
+	.list = posix_acl_xattr_list,
+	.get = gfs2_posix_acl_xattr_get,
+	.set = gfs2_posix_acl_xattr_set,
+};
+
 static const struct xattr_handler gfs2_xattr_user_handler = {
 	.prefix = XATTR_USER_PREFIX,
 	.flags  = GFS2_EATYPE_USR,
@@ -1454,8 +1546,8 @@ static const struct xattr_handler gfs2_xattr_security_handler = {
 const struct xattr_handler *gfs2_xattr_handlers[] = {
 	&gfs2_xattr_user_handler,
 	&gfs2_xattr_security_handler,
-	&posix_acl_access_xattr_handler,
-	&posix_acl_default_xattr_handler,
+	&gfs2_posix_acl_access_xattr_handler,
+	&gfs2_posix_acl_default_xattr_handler,
 	NULL,
 };
 
-- 
2.4.11

