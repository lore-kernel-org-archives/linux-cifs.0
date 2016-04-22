From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] cifs: Switch to generic xattr handlers
Date: Fri, 22 Apr 2016 12:11:38 +0200
Message-ID: <1461319898-28926-1-git-send-email-agruenba@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Use xattr handlers for resolving attribute names.  The amount of setup
code required on cifs is nontrivial, so use the same get and set
functions for all handlers, with switch statements for the different
types of attributes in them.

The set_EA handler can handle NULL values, so we don't need a separate
removexattr function anymore.  Remove the cifs_dbg statements related to
xattr name resolution; they don't add much.  Don't build xattr.o when
CONFIG_CIFS_XATTR is not defined.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/cifs/Makefile |   3 +-
 fs/cifs/cifsfs.c |  26 ++---
 fs/cifs/cifsfs.h |  12 +-
 fs/cifs/xattr.c  | 342 +++++++++++++++++++++++--------------------------------
 4 files changed, 165 insertions(+), 218 deletions(-)

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 1964d21..eed7eb0 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -5,9 +5,10 @@ obj-$(CONFIG_CIFS) += cifs.o
 
 cifs-y := cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o inode.o \
 	  link.o misc.o netmisc.o smbencrypt.o transport.o asn1.o \
-	  cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
+	  cifs_unicode.o nterr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o smb1ops.o winucase.o
 
+cifs-$(CONFIG_CIFS_XATTR) += xattr.o
 cifs-$(CONFIG_CIFS_ACL) += cifsacl.o
 
 cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 1d86fc6..43cc522b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -37,6 +37,7 @@
 #include <linux/freezer.h>
 #include <linux/namei.h>
 #include <linux/random.h>
+#include <linux/xattr.h>
 #include <net/ipv6.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
@@ -135,6 +136,7 @@ cifs_read_super(struct super_block *sb)
 
 	sb->s_magic = CIFS_MAGIC_NUMBER;
 	sb->s_op = &cifs_super_ops;
+	sb->s_xattr = cifs_xattr_handlers;
 	sb->s_bdi = &cifs_sb->bdi;
 	sb->s_blocksize = CIFS_MAX_MSGSIZE;
 	sb->s_blocksize_bits = 14;	/* default 2**14 = CIFS_MAX_MSGSIZE */
@@ -892,12 +894,10 @@ const struct inode_operations cifs_dir_inode_ops = {
 	.setattr = cifs_setattr,
 	.symlink = cifs_symlink,
 	.mknod   = cifs_mknod,
-#ifdef CONFIG_CIFS_XATTR
-	.setxattr = cifs_setxattr,
-	.getxattr = cifs_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = cifs_removexattr,
-#endif
+	.removexattr = generic_removexattr,
 };
 
 const struct inode_operations cifs_file_inode_ops = {
@@ -905,12 +905,10 @@ const struct inode_operations cifs_file_inode_ops = {
 	.setattr = cifs_setattr,
 	.getattr = cifs_getattr, /* do we need this anymore? */
 	.permission = cifs_permission,
-#ifdef CONFIG_CIFS_XATTR
-	.setxattr = cifs_setxattr,
-	.getxattr = cifs_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = cifs_removexattr,
-#endif
+	.removexattr = generic_removexattr,
 };
 
 const struct inode_operations cifs_symlink_inode_ops = {
@@ -920,12 +918,10 @@ const struct inode_operations cifs_symlink_inode_ops = {
 	/* BB add the following two eventually */
 	/* revalidate: cifs_revalidate,
 	   setattr:    cifs_notify_change, *//* BB do we need notify change */
-#ifdef CONFIG_CIFS_XATTR
-	.setxattr = cifs_setxattr,
-	.getxattr = cifs_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = cifs_removexattr,
-#endif
+	.removexattr = generic_removexattr,
 };
 
 static int cifs_clone_file_range(struct file *src_file, loff_t off,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index c89ecd7..c1e749a 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -120,11 +120,15 @@ extern const char *cifs_get_link(struct dentry *, struct inode *,
 			struct delayed_call *);
 extern int cifs_symlink(struct inode *inode, struct dentry *direntry,
 			const char *symname);
-extern int	cifs_removexattr(struct dentry *, const char *);
-extern int	cifs_setxattr(struct dentry *, const char *, const void *,
-			size_t, int);
-extern ssize_t	cifs_getxattr(struct dentry *, struct inode *, const char *, void *, size_t);
+
+#ifdef CONFIG_CIFS_XATTR
+extern const struct xattr_handler *cifs_xattr_handlers[];
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
+#else
+# define cifs_xattr_handlers NULL
+# define cifs_listxattr NULL
+#endif
+
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_CIFS_NFSD_EXPORT
 extern const struct export_operations cifs_export_ops;
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 721c6db..c8b77aa 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -32,76 +32,19 @@
 #include "cifs_unicode.h"
 
 #define MAX_EA_VALUE_SIZE 65535
-#define CIFS_XATTR_DOS_ATTRIB "user.DosAttrib"
 #define CIFS_XATTR_CIFS_ACL "system.cifs_acl"
 
 /* BB need to add server (Samba e.g) support for security and trusted prefix */
 
-int cifs_removexattr(struct dentry *direntry, const char *ea_name)
-{
-	int rc = -EOPNOTSUPP;
-#ifdef CONFIG_CIFS_XATTR
-	unsigned int xid;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
-	struct tcon_link *tlink;
-	struct cifs_tcon *pTcon;
-	char *full_path = NULL;
-
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink))
-		return PTR_ERR(tlink);
-	pTcon = tlink_tcon(tlink);
+enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT };
 
-	xid = get_xid();
-
-	full_path = build_path_from_dentry(direntry);
-	if (full_path == NULL) {
-		rc = -ENOMEM;
-		goto remove_ea_exit;
-	}
-	if (ea_name == NULL) {
-		cifs_dbg(FYI, "Null xattr names not supported\n");
-	} else if (!strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto remove_ea_exit;
-
-		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
-		if (pTcon->ses->server->ops->set_EA)
-			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
-				full_path, ea_name, NULL, (__u16)0,
-				cifs_sb->local_nls, cifs_remap(cifs_sb));
-	} else if (!strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto remove_ea_exit;
-
-		ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
-		if (pTcon->ses->server->ops->set_EA)
-			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
-				full_path, ea_name, NULL, (__u16)0,
-				cifs_sb->local_nls, cifs_remap(cifs_sb));
-	} else {
-		cifs_dbg(FYI,
-			 "illegal xattr request %s (only user namespace supported)\n",
-			 ea_name);
-		/* BB what if no namespace prefix? */
-		/* Should we just pass them to server, except for
-		system and perhaps security prefixes? */
-	}
-remove_ea_exit:
-	kfree(full_path);
-	free_xid(xid);
-	cifs_put_tlink(tlink);
-#endif
-	return rc;
-}
-
-int cifs_setxattr(struct dentry *direntry, const char *ea_name,
-		  const void *ea_value, size_t value_size, int flags)
+static int cifs_xattr_set(const struct xattr_handler *handler,
+			  struct dentry *dentry, const char *name,
+			  const void *value, size_t size, int flags)
 {
 	int rc = -EOPNOTSUPP;
-#ifdef CONFIG_CIFS_XATTR
 	unsigned int xid;
-	struct super_block *sb = direntry->d_sb;
+	struct super_block *sb = dentry->d_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct tcon_link *tlink;
 	struct cifs_tcon *pTcon;
@@ -114,10 +57,10 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 
 	xid = get_xid();
 
-	full_path = build_path_from_dentry(direntry);
+	full_path = build_path_from_dentry(dentry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		goto set_ea_exit;
+		goto out;
 	}
 	/* return dos attributes as pseudo xattr */
 	/* return alt name if available as pseudo attr */
@@ -125,104 +68,88 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 	/* if proc/fs/cifs/streamstoxattr is set then
 		search server for EAs or streams to
 		returns as xattrs */
-	if (value_size > MAX_EA_VALUE_SIZE) {
+	if (size > MAX_EA_VALUE_SIZE) {
 		cifs_dbg(FYI, "size of EA value too large\n");
 		rc = -EOPNOTSUPP;
-		goto set_ea_exit;
+		goto out;
 	}
 
-	if (ea_name == NULL) {
-		cifs_dbg(FYI, "Null xattr names not supported\n");
-	} else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
-		   == 0) {
+	switch (handler->flags) {
+	case XATTR_USER:
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto set_ea_exit;
-		if (strcmp(ea_name, CIFS_XATTR_DOS_ATTRIB) == 0)
-			cifs_dbg(FYI, "attempt to set cifs inode metadata\n");
+			goto out;
 
-		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
 		if (pTcon->ses->server->ops->set_EA)
 			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
-				full_path, ea_name, ea_value, (__u16)value_size,
+				full_path, name, value, (__u16)size,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
-	} else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)
-		   == 0) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto set_ea_exit;
+		break;
 
-		ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
-		if (pTcon->ses->server->ops->set_EA)
-			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
-				full_path, ea_name, ea_value, (__u16)value_size,
-				cifs_sb->local_nls, cifs_remap(cifs_sb));
-	} else if (strcmp(ea_name, CIFS_XATTR_CIFS_ACL) == 0) {
+	case XATTR_CIFS_ACL: {
 #ifdef CONFIG_CIFS_ACL
 		struct cifs_ntsd *pacl;
-		pacl = kmalloc(value_size, GFP_KERNEL);
+
+		if (!value)
+			goto out;
+		pacl = kmalloc(size, GFP_KERNEL);
 		if (!pacl) {
 			rc = -ENOMEM;
 		} else {
-			memcpy(pacl, ea_value, value_size);
-			if (pTcon->ses->server->ops->set_acl)
+			memcpy(pacl, value, size);
+			if (value &&
+			    pTcon->ses->server->ops->set_acl)
 				rc = pTcon->ses->server->ops->set_acl(pacl,
-						value_size, d_inode(direntry),
+						size, d_inode(dentry),
 						full_path, CIFS_ACL_DACL);
 			else
 				rc = -EOPNOTSUPP;
 			if (rc == 0) /* force revalidate of the inode */
-				CIFS_I(d_inode(direntry))->time = 0;
+				CIFS_I(d_inode(dentry))->time = 0;
 			kfree(pacl);
 		}
-#else
-		cifs_dbg(FYI, "Set CIFS ACL not supported yet\n");
 #endif /* CONFIG_CIFS_ACL */
-	} else {
-		if (strcmp(ea_name, XATTR_NAME_POSIX_ACL_ACCESS) == 0) {
+		break;
+	}
+
+	case XATTR_ACL_ACCESS:
 #ifdef CONFIG_CIFS_POSIX
-			if (sb->s_flags & MS_POSIXACL)
-				rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
-					ea_value, (const int)value_size,
-					ACL_TYPE_ACCESS, cifs_sb->local_nls,
-					cifs_remap(cifs_sb));
-			cifs_dbg(FYI, "set POSIX ACL rc %d\n", rc);
-#else
-			cifs_dbg(FYI, "set POSIX ACL not supported\n");
-#endif
-		} else if (strcmp(ea_name, XATTR_NAME_POSIX_ACL_DEFAULT) == 0) {
+		if (!value)
+			goto out;
+		if (sb->s_flags & MS_POSIXACL)
+			rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
+				value, (const int)size,
+				ACL_TYPE_ACCESS, cifs_sb->local_nls,
+				cifs_remap(cifs_sb));
+#endif  /* CONFIG_CIFS_POSIX */
+		break;
+
+	case XATTR_ACL_DEFAULT:
 #ifdef CONFIG_CIFS_POSIX
-			if (sb->s_flags & MS_POSIXACL)
-				rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
-					ea_value, (const int)value_size,
-					ACL_TYPE_DEFAULT, cifs_sb->local_nls,
-					cifs_remap(cifs_sb));
-			cifs_dbg(FYI, "set POSIX default ACL rc %d\n", rc);
-#else
-			cifs_dbg(FYI, "set default POSIX ACL not supported\n");
-#endif
-		} else {
-			cifs_dbg(FYI, "illegal xattr request %s (only user namespace supported)\n",
-				 ea_name);
-		  /* BB what if no namespace prefix? */
-		  /* Should we just pass them to server, except for
-		  system and perhaps security prefixes? */
-		}
+		if (!value)
+			goto out;
+		if (sb->s_flags & MS_POSIXACL)
+			rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
+				value, (const int)size,
+				ACL_TYPE_DEFAULT, cifs_sb->local_nls,
+				cifs_remap(cifs_sb));
+#endif  /* CONFIG_CIFS_POSIX */
+		break;
 	}
 
-set_ea_exit:
+out:
 	kfree(full_path);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
-#endif
 	return rc;
 }
 
-ssize_t cifs_getxattr(struct dentry *direntry, struct inode *inode,
-	const char *ea_name, void *ea_value, size_t buf_size)
+static int cifs_xattr_get(const struct xattr_handler *handler,
+			  struct dentry *dentry, struct inode *inode,
+			  const char *name, void *value, size_t size)
 {
 	ssize_t rc = -EOPNOTSUPP;
-#ifdef CONFIG_CIFS_XATTR
 	unsigned int xid;
-	struct super_block *sb = direntry->d_sb;
+	struct super_block *sb = dentry->d_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct tcon_link *tlink;
 	struct cifs_tcon *pTcon;
@@ -235,95 +162,72 @@ ssize_t cifs_getxattr(struct dentry *direntry, struct inode *inode,
 
 	xid = get_xid();
 
-	full_path = build_path_from_dentry(direntry);
+	full_path = build_path_from_dentry(dentry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		goto get_ea_exit;
+		goto out;
 	}
 	/* return dos attributes as pseudo xattr */
 	/* return alt name if available as pseudo attr */
-	if (ea_name == NULL) {
-		cifs_dbg(FYI, "Null xattr names not supported\n");
-	} else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
-		   == 0) {
+	switch (handler->flags) {
+	case XATTR_USER:
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto get_ea_exit;
+			goto out;
 
-		if (strcmp(ea_name, CIFS_XATTR_DOS_ATTRIB) == 0) {
-			cifs_dbg(FYI, "attempt to query cifs inode metadata\n");
-			/* revalidate/getattr then populate from inode */
-		} /* BB add else when above is implemented */
-		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
 		if (pTcon->ses->server->ops->query_all_EAs)
 			rc = pTcon->ses->server->ops->query_all_EAs(xid, pTcon,
-				full_path, ea_name, ea_value, buf_size,
+				full_path, name, value, size,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
-	} else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto get_ea_exit;
+		break;
 
-		ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
-		if (pTcon->ses->server->ops->query_all_EAs)
-			rc = pTcon->ses->server->ops->query_all_EAs(xid, pTcon,
-				full_path, ea_name, ea_value, buf_size,
-				cifs_sb->local_nls, cifs_remap(cifs_sb));
-	} else if (strcmp(ea_name, XATTR_NAME_POSIX_ACL_ACCESS) == 0) {
+	case XATTR_CIFS_ACL: {
+#ifdef CONFIG_CIFS_ACL
+		u32 acllen;
+		struct cifs_ntsd *pacl;
+
+		if (pTcon->ses->server->ops->get_acl == NULL)
+			goto out; /* rc already EOPNOTSUPP */
+
+		pacl = pTcon->ses->server->ops->get_acl(cifs_sb,
+				inode, full_path, &acllen);
+		if (IS_ERR(pacl)) {
+			rc = PTR_ERR(pacl);
+			cifs_dbg(VFS, "%s: error %zd getting sec desc\n",
+				 __func__, rc);
+		} else {
+			if (value) {
+				if (acllen > size)
+					acllen = -ERANGE;
+				else
+					memcpy(value, pacl, acllen);
+			}
+			rc = acllen;
+			kfree(pacl);
+		}
+#endif  /* CONFIG_CIFS_ACL */
+		break;
+	}
+
+	case XATTR_ACL_ACCESS:
 #ifdef CONFIG_CIFS_POSIX
 		if (sb->s_flags & MS_POSIXACL)
 			rc = CIFSSMBGetPosixACL(xid, pTcon, full_path,
-				ea_value, buf_size, ACL_TYPE_ACCESS,
+				value, size, ACL_TYPE_ACCESS,
 				cifs_sb->local_nls,
 				cifs_remap(cifs_sb));
-#else
-		cifs_dbg(FYI, "Query POSIX ACL not supported yet\n");
-#endif /* CONFIG_CIFS_POSIX */
-	} else if (strcmp(ea_name, XATTR_NAME_POSIX_ACL_DEFAULT) == 0) {
+#endif  /* CONFIG_CIFS_POSIX */
+		break;
+
+	case XATTR_ACL_DEFAULT:
 #ifdef CONFIG_CIFS_POSIX
 		if (sb->s_flags & MS_POSIXACL)
 			rc = CIFSSMBGetPosixACL(xid, pTcon, full_path,
-				ea_value, buf_size, ACL_TYPE_DEFAULT,
+				value, size, ACL_TYPE_DEFAULT,
 				cifs_sb->local_nls,
 				cifs_remap(cifs_sb));
-#else
-		cifs_dbg(FYI, "Query POSIX default ACL not supported yet\n");
-#endif /* CONFIG_CIFS_POSIX */
-	} else if (strcmp(ea_name, CIFS_XATTR_CIFS_ACL) == 0) {
-#ifdef CONFIG_CIFS_ACL
-			u32 acllen;
-			struct cifs_ntsd *pacl;
-
-			if (pTcon->ses->server->ops->get_acl == NULL)
-				goto get_ea_exit; /* rc already EOPNOTSUPP */
-
-			pacl = pTcon->ses->server->ops->get_acl(cifs_sb,
-					inode, full_path, &acllen);
-			if (IS_ERR(pacl)) {
-				rc = PTR_ERR(pacl);
-				cifs_dbg(VFS, "%s: error %zd getting sec desc\n",
-					 __func__, rc);
-			} else {
-				if (ea_value) {
-					if (acllen > buf_size)
-						acllen = -ERANGE;
-					else
-						memcpy(ea_value, pacl, acllen);
-				}
-				rc = acllen;
-				kfree(pacl);
-			}
-#else
-			cifs_dbg(FYI, "Query CIFS ACL not supported yet\n");
-#endif /* CONFIG_CIFS_ACL */
-	} else if (strncmp(ea_name,
-		  XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) == 0) {
-		cifs_dbg(FYI, "Trusted xattr namespace not supported yet\n");
-	} else if (strncmp(ea_name,
-		  XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) == 0) {
-		cifs_dbg(FYI, "Security xattr namespace not supported yet\n");
-	} else
-		cifs_dbg(FYI,
-			 "illegal xattr request %s (only user namespace supported)\n",
-			 ea_name);
+#endif  /* CONFIG_CIFS_POSIX */
+		break;
+	}
 
 	/* We could add an additional check for streams ie
 	    if proc/fs/cifs/streamstoxattr is set then
@@ -333,18 +237,16 @@ ssize_t cifs_getxattr(struct dentry *direntry, struct inode *inode,
 	if (rc == -EINVAL)
 		rc = -EOPNOTSUPP;
 
-get_ea_exit:
+out:
 	kfree(full_path);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
-#endif
 	return rc;
 }
 
 ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 {
 	ssize_t rc = -EOPNOTSUPP;
-#ifdef CONFIG_CIFS_XATTR
 	unsigned int xid;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
 	struct tcon_link *tlink;
@@ -381,6 +283,50 @@ list_ea_exit:
 	kfree(full_path);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
-#endif
 	return rc;
 }
+
+static const struct xattr_handler cifs_user_xattr_handler = {
+	.prefix = XATTR_USER_PREFIX,
+	.flags = XATTR_USER,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
+/* os2.* attributes are treated like user.* attributes */
+static const struct xattr_handler cifs_os2_xattr_handler = {
+	.prefix = XATTR_OS2_PREFIX,
+	.flags = XATTR_USER,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
+static const struct xattr_handler cifs_cifs_acl_xattr_handler = {
+	.name = CIFS_XATTR_CIFS_ACL,
+	.flags = XATTR_CIFS_ACL,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
+static const struct xattr_handler cifs_posix_acl_access_xattr_handler = {
+	.name = XATTR_NAME_POSIX_ACL_ACCESS,
+	.flags = XATTR_ACL_ACCESS,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
+static const struct xattr_handler cifs_posix_acl_default_xattr_handler = {
+	.name = XATTR_NAME_POSIX_ACL_DEFAULT,
+	.flags = XATTR_ACL_DEFAULT,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
+const struct xattr_handler *cifs_xattr_handlers[] = {
+	&cifs_user_xattr_handler,
+	&cifs_os2_xattr_handler,
+	&cifs_cifs_acl_xattr_handler,
+	&cifs_posix_acl_access_xattr_handler,
+	&cifs_posix_acl_default_xattr_handler,
+	NULL
+};
-- 
2.5.5

