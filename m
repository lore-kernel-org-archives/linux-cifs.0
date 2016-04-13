From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/8] cifs: Fix xattr name checks
Date: Thu, 14 Apr 2016 00:30:13 +0200
Message-ID: <1460586620-5717-2-git-send-email-agruenba@redhat.com>
References: <1460586620-5717-1-git-send-email-agruenba@redhat.com>
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460586620-5717-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <20160413182026.GR25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
References: <20160413182026.GR25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use strcmp(str, name) instead of strncmp(str, name, strlen(name)) for
checking if str and name are the same (as opposed to name being a prefix
of str) in the gexattr and setxattr inode operations.

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/xattr.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 5d57c85..6e73ba9 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -129,7 +129,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 		   == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto set_ea_exit;
-		if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0)
+		if (strcmp(ea_name, CIFS_XATTR_DOS_ATTRIB) == 0)
 			cifs_dbg(FYI, "attempt to set cifs inode metadata\n");
 
 		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
@@ -147,8 +147,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
 				full_path, ea_name, ea_value, (__u16)value_size,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
-	} else if (strncmp(ea_name, CIFS_XATTR_CIFS_ACL,
-			strlen(CIFS_XATTR_CIFS_ACL)) == 0) {
+	} else if (strcmp(ea_name, CIFS_XATTR_CIFS_ACL) == 0) {
 #ifdef CONFIG_CIFS_ACL
 		struct cifs_ntsd *pacl;
 		pacl = kmalloc(value_size, GFP_KERNEL);
@@ -170,10 +169,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 		cifs_dbg(FYI, "Set CIFS ACL not supported yet\n");
 #endif /* CONFIG_CIFS_ACL */
 	} else {
-		int temp;
-		temp = strncmp(ea_name, XATTR_NAME_POSIX_ACL_ACCESS,
-			strlen(XATTR_NAME_POSIX_ACL_ACCESS));
-		if (temp == 0) {
+		if (strcmp(ea_name, XATTR_NAME_POSIX_ACL_ACCESS) == 0) {
 #ifdef CONFIG_CIFS_POSIX
 			if (sb->s_flags & MS_POSIXACL)
 				rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
@@ -184,8 +180,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 #else
 			cifs_dbg(FYI, "set POSIX ACL not supported\n");
 #endif
-		} else if (strncmp(ea_name, XATTR_NAME_POSIX_ACL_DEFAULT,
-				   strlen(XATTR_NAME_POSIX_ACL_DEFAULT)) == 0) {
+		} else if (strcmp(ea_name, XATTR_NAME_POSIX_ACL_DEFAULT) == 0) {
 #ifdef CONFIG_CIFS_POSIX
 			if (sb->s_flags & MS_POSIXACL)
 				rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
@@ -246,7 +241,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, struct inode *inode,
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto get_ea_exit;
 
-		if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0) {
+		if (strcmp(ea_name, CIFS_XATTR_DOS_ATTRIB) == 0) {
 			cifs_dbg(FYI, "attempt to query cifs inode metadata\n");
 			/* revalidate/getattr then populate from inode */
 		} /* BB add else when above is implemented */
@@ -264,8 +259,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, struct inode *inode,
 			rc = pTcon->ses->server->ops->query_all_EAs(xid, pTcon,
 				full_path, ea_name, ea_value, buf_size,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
-	} else if (strncmp(ea_name, XATTR_NAME_POSIX_ACL_ACCESS,
-			  strlen(XATTR_NAME_POSIX_ACL_ACCESS)) == 0) {
+	} else if (strcmp(ea_name, XATTR_NAME_POSIX_ACL_ACCESS) == 0) {
 #ifdef CONFIG_CIFS_POSIX
 		if (sb->s_flags & MS_POSIXACL)
 			rc = CIFSSMBGetPosixACL(xid, pTcon, full_path,
@@ -275,8 +269,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, struct inode *inode,
 #else
 		cifs_dbg(FYI, "Query POSIX ACL not supported yet\n");
 #endif /* CONFIG_CIFS_POSIX */
-	} else if (strncmp(ea_name, XATTR_NAME_POSIX_ACL_DEFAULT,
-			  strlen(XATTR_NAME_POSIX_ACL_DEFAULT)) == 0) {
+	} else if (strcmp(ea_name, XATTR_NAME_POSIX_ACL_DEFAULT) == 0) {
 #ifdef CONFIG_CIFS_POSIX
 		if (sb->s_flags & MS_POSIXACL)
 			rc = CIFSSMBGetPosixACL(xid, pTcon, full_path,
@@ -286,8 +279,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, struct inode *inode,
 #else
 		cifs_dbg(FYI, "Query POSIX default ACL not supported yet\n");
 #endif /* CONFIG_CIFS_POSIX */
-	} else if (strncmp(ea_name, CIFS_XATTR_CIFS_ACL,
-				strlen(CIFS_XATTR_CIFS_ACL)) == 0) {
+	} else if (strcmp(ea_name, CIFS_XATTR_CIFS_ACL) == 0) {
 #ifdef CONFIG_CIFS_ACL
 			u32 acllen;
 			struct cifs_ntsd *pacl;
-- 
2.4.11
