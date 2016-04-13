From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 7/8] posix acls: Export xattr_handler functions
Date: Thu, 14 Apr 2016 00:27:45 +0200
Message-ID: <1460586466-5518-8-git-send-email-agruenba@redhat.com>
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

These functions are useful in filesystems like gfs2 which require
pre-/postamble code around xattr operations.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
---
 fs/posix_acl.c                  | 9 ++++++---
 include/linux/posix_acl_xattr.h | 8 ++++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 2c60f17..1da2c63 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -795,7 +795,7 @@ posix_acl_to_xattr(struct user_namespace *user_ns, const struct posix_acl *acl,
 }
 EXPORT_SYMBOL (posix_acl_to_xattr);
 
-static int
+int
 posix_acl_xattr_get(const struct xattr_handler *handler,
 		    struct dentry *unused, struct inode *inode,
 		    const char *name, void *value, size_t size)
@@ -819,8 +819,9 @@ posix_acl_xattr_get(const struct xattr_handler *handler,
 
 	return error;
 }
+EXPORT_SYMBOL(posix_acl_xattr_get);
 
-static int
+int
 posix_acl_xattr_set(const struct xattr_handler *handler,
 		    struct dentry *dentry, const char *name,
 		    const void *value, size_t size, int flags)
@@ -856,12 +857,14 @@ out:
 	posix_acl_release(acl);
 	return ret;
 }
+EXPORT_SYMBOL(posix_acl_xattr_set);
 
-static bool
+bool
 posix_acl_xattr_list(struct dentry *dentry)
 {
 	return IS_POSIXACL(d_backing_inode(dentry));
 }
+EXPORT_SYMBOL(posix_acl_xattr_list);
 
 const struct xattr_handler posix_acl_access_xattr_handler = {
 	.name = XATTR_NAME_POSIX_ACL_ACCESS,
diff --git a/include/linux/posix_acl_xattr.h b/include/linux/posix_acl_xattr.h
index e5e8ec4..c92607c 100644
--- a/include/linux/posix_acl_xattr.h
+++ b/include/linux/posix_acl_xattr.h
@@ -65,6 +65,14 @@ struct posix_acl *posix_acl_from_xattr(struct user_namespace *user_ns,
 int posix_acl_to_xattr(struct user_namespace *user_ns,
 		       const struct posix_acl *acl, void *buffer, size_t size);
 
+int posix_acl_xattr_get(const struct xattr_handler *handler,
+			struct dentry *unused, struct inode *inode,
+			const char *name, void *value, size_t size);
+int posix_acl_xattr_set(const struct xattr_handler *handler,
+			struct dentry *dentry, const char *name,
+			const void *value, size_t size, int flags);
+bool posix_acl_xattr_list(struct dentry *dentry);
+
 extern const struct xattr_handler posix_acl_access_xattr_handler;
 extern const struct xattr_handler posix_acl_default_xattr_handler;
 
-- 
2.4.11

