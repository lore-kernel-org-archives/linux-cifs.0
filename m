From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] handle extended attribute name cifsacl to generate cifs
 acl blob
Date: Tue, 12 Oct 2010 09:26:35 -0400
Message-ID: <20101012132635.GA2567@infradead.org>
References: <1286460207-4024-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1286460207-4024-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 07, 2010 at 09:03:27AM -0500, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Add extended attribute name system.cifsacl
> 
> Get/generate cifs/ntfs acl blob and hand over to the invoker however
> it wants to parse/process it.
> 
> Stop generating cifs/ntfs acl blob for xattr name system.posix_acl_access

Please don't make the cifs code even more messy than it already is.
If you add new attrs please switch to split handlers like in the patch
I posted some month ago.


Below is the lastest version I could find on my laptop:

---
From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH] cifs: use xattr handlers

Rewrite the cifs xattr code to use the generic xattr dispatch handlers
and clean up the code using it.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Index: linux-2.6/fs/cifs/Makefile
===================================================================
--- linux-2.6.orig/fs/cifs/Makefile	2010-06-29 16:58:41.638254185 +0200
+++ linux-2.6/fs/cifs/Makefile	2010-06-29 16:59:11.105253486 +0200
@@ -5,9 +5,9 @@ obj-$(CONFIG_CIFS) += cifs.o
 
 cifs-y := cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o inode.o \
 	  link.o misc.o netmisc.o smbdes.o smbencrypt.o transport.o asn1.o \
-	  md4.o md5.o cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
+	  md4.o md5.o cifs_unicode.o nterr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o cifsacl.o
 
+cifs-$(CONFIG_CIFS_XATTR) += xattr.o
 cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
-
 cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
Index: linux-2.6/fs/cifs/xattr.c
===================================================================
--- linux-2.6.orig/fs/cifs/xattr.c	2010-06-29 16:58:41.646254045 +0200
+++ linux-2.6/fs/cifs/xattr.c	2010-06-29 17:13:33.386284428 +0200
@@ -22,356 +22,272 @@
 #include <linux/fs.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
 
-#define MAX_EA_VALUE_SIZE 65535
-#define CIFS_XATTR_DOS_ATTRIB "user.DosAttrib"
-#define CIFS_XATTR_USER_PREFIX "user."
-#define CIFS_XATTR_SYSTEM_PREFIX "system."
-#define CIFS_XATTR_OS2_PREFIX "os2."
-#define CIFS_XATTR_SECURITY_PREFIX ".security"
-#define CIFS_XATTR_TRUSTED_PREFIX "trusted."
-#define XATTR_TRUSTED_PREFIX_LEN  8
-#define XATTR_SECURITY_PREFIX_LEN 9
-/* BB need to add server (Samba e.g) support for security and trusted prefix */
+#define MAX_EA_VALUE_SIZE	65535
+#define CIFS_XATTR_OS2_PREFIX	"os2."
 
-
-
-int cifs_removexattr(struct dentry *direntry, const char *ea_name)
+/*
+ * TODO (maybe):
+ *	- return dos attributes as pseudo xattr
+ *	- return alt name if available as pseudo attr
+ *	- if proc/fs/cifs/streamstoxattr is set then search server for
+ *	  EAs or streams to returns as xattrs
+ *	- need to add server (Samba e.g) support for security and
+ *	  trusted prefix
+ */
+
+static int
+cifs_xattr_set(struct dentry *dentry, const char *name, const void *value,
+		size_t size, int flags, int xflags)
 {
-	int rc = -EOPNOTSUPP;
-#ifdef CONFIG_CIFS_XATTR
-	int xid;
-	struct cifs_sb_info *cifs_sb;
-	struct cifsTconInfo *pTcon;
-	struct super_block *sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_inode->i_sb);
 	char *full_path;
+	int xid;
+	int rc;
 
-	if (direntry == NULL)
-		return -EIO;
-	if (direntry->d_inode == NULL)
-		return -EIO;
-	sb = direntry->d_inode->i_sb;
-	if (sb == NULL)
-		return -EIO;
-	xid = GetXid();
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+		return -EOPNOTSUPP;
 
-	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb->tcon;
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
 
-	full_path = build_path_from_dentry(direntry);
-	if (full_path == NULL) {
+	xid = GetXid();
+	full_path = build_path_from_dentry(dentry);
+	if (!full_path) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto out_free_xid;
 	}
-	if (ea_name == NULL) {
-		cFYI(1, "Null xattr names not supported");
-	} else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5)
-		&& (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4))) {
-		cFYI(1,
-		     "illegal xattr request %s (only user namespace supported)",
-		     ea_name);
-		/* BB what if no namespace prefix? */
-		/* Should we just pass them to server, except for
-		system and perhaps security prefixes? */
-	} else {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto remove_ea_exit;
-
-		ea_name += 5; /* skip past user. prefix */
-		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, NULL,
-			(__u16)0, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+	/* make sure size is set to zero for remove requests */
+	if (!value)
+		size = 0;
+
+	if (size > MAX_EA_VALUE_SIZE) {
+		cFYI(1, "size of EA value too large");
+		rc = -EOPNOTSUPP;
+		goto out_free_path;
 	}
-remove_ea_exit:
+
+	rc = CIFSSMBSetEA(xid, cifs_sb->tcon, full_path, name, value, size,
+			  cifs_sb->local_nls,
+			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+out_free_path:
 	kfree(full_path);
+out_free_xid:
 	FreeXid(xid);
-#endif
 	return rc;
 }
 
-int cifs_setxattr(struct dentry *direntry, const char *ea_name,
-		  const void *ea_value, size_t value_size, int flags)
+static int
+cifs_xattr_get(struct dentry *dentry, const char *name,
+		void *value, size_t size, int type)
 {
-	int rc = -EOPNOTSUPP;
-#ifdef CONFIG_CIFS_XATTR
-	int xid;
-	struct cifs_sb_info *cifs_sb;
-	struct cifsTconInfo *pTcon;
-	struct super_block *sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_inode->i_sb);
 	char *full_path;
+	ssize_t rc;
+	int xid;
 
-	if (direntry == NULL)
-		return -EIO;
-	if (direntry->d_inode == NULL)
-		return -EIO;
-	sb = direntry->d_inode->i_sb;
-	if (sb == NULL)
-		return -EIO;
-	xid = GetXid();
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+		return -EOPNOTSUPP;
 
-	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb->tcon;
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
 
-	full_path = build_path_from_dentry(direntry);
-	if (full_path == NULL) {
+	xid = GetXid();
+
+	full_path = build_path_from_dentry(dentry);
+	if (!full_path) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto out_free_xid;
 	}
-	/* return dos attributes as pseudo xattr */
-	/* return alt name if available as pseudo attr */
+	rc = CIFSSMBQAllEAs(xid, cifs_sb->tcon, full_path, name, value, size,
+			    cifs_sb->local_nls,
+			    cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
+	if (rc == -EINVAL)
+		rc = -EOPNOTSUPP;
 
-	/* if proc/fs/cifs/streamstoxattr is set then
-		search server for EAs or streams to
-		returns as xattrs */
-	if (value_size > MAX_EA_VALUE_SIZE) {
-		cFYI(1, "size of EA value too large");
-		kfree(full_path);
-		FreeXid(xid);
-		return -EOPNOTSUPP;
-	}
+	kfree(full_path);
+out_free_xid:
+	FreeXid(xid);
+	return rc;
+}
+
+static struct xattr_handler cifs_xattr_user_handler = {
+	.prefix	= XATTR_USER_PREFIX,
+	.get	= cifs_xattr_get,
+	.set	= cifs_xattr_set,
+};
+
+static struct xattr_handler cifs_xattr_os2_handler = {
+	.prefix	= CIFS_XATTR_OS2_PREFIX,
+	.get	= cifs_xattr_get,
+	.set	= cifs_xattr_set,
+};
 
-	if (ea_name == NULL) {
-		cFYI(1, "Null xattr names not supported");
-	} else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto set_ea_exit;
-		if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0)
-			cFYI(1, "attempt to set cifs inode metadata");
-
-		ea_name += 5; /* skip past user. prefix */
-		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
-			(__u16)value_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-	} else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto set_ea_exit;
-
-		ea_name += 4; /* skip past os2. prefix */
-		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
-			(__u16)value_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-	} else {
-		int temp;
-		temp = strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
-			strlen(POSIX_ACL_XATTR_ACCESS));
-		if (temp == 0) {
 #ifdef CONFIG_CIFS_POSIX
-			if (sb->s_flags & MS_POSIXACL)
-				rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
-					ea_value, (const int)value_size,
-					ACL_TYPE_ACCESS, cifs_sb->local_nls,
+static int
+cifs_xattr_acl_get(struct dentry *dentry, const char *name,
+		void *value, size_t size, int type)
+{
+	struct super_block *sb = dentry->d_inode->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifsTconInfo *tcon = cifs_sb->tcon;
+	ssize_t rc = -EOPNOTSUPP;
+	char *full_path;
+	int xid;
+
+	xid = GetXid();
+	if (strcmp(name, "") == 0) {
+		rc = -EINVAL;
+		goto out_free_xid;
+	}
+
+	full_path = build_path_from_dentry(dentry);
+	if (!full_path) {
+		rc = -ENOMEM;
+		goto out_free_xid;
+	}
+
+	if (sb->s_flags & MS_POSIXACL) {
+		rc = CIFSSMBGetPosixACL(xid, tcon, full_path, value, size,
+					type, cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
-			cFYI(1, "set POSIX ACL rc %d", rc);
-#else
-			cFYI(1, "set POSIX ACL not supported");
-#endif
-		} else if (strncmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
-				   strlen(POSIX_ACL_XATTR_DEFAULT)) == 0) {
-#ifdef CONFIG_CIFS_POSIX
-			if (sb->s_flags & MS_POSIXACL)
-				rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
-					ea_value, (const int)value_size,
-					ACL_TYPE_DEFAULT, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
+#ifdef CONFIG_CIFS_EXPERIMENTAL
+	} else if (type == ACL_TYPE_ACCESS && experimEnabled &&
+		   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)) {
+		struct cifs_ntsd *pacl = NULL;
+		int oplock = 0;
+		u32 buflen = 0;
+		u16 fid;
+
+		rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN, GENERIC_READ,
+				 0, &fid, &oplock, NULL, cifs_sb->local_nls,
+				 cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
-			cFYI(1, "set POSIX default ACL rc %d", rc);
-#else
-			cFYI(1, "set default POSIX ACL not supported");
-#endif
-		} else {
-			cFYI(1, "illegal xattr request %s (only user namespace"
-				" supported)", ea_name);
-		  /* BB what if no namespace prefix? */
-		  /* Should we just pass them to server, except for
-		  system and perhaps security prefixes? */
-		}
+		if (rc)
+			goto out;
+
+		rc = CIFSSMBGetCIFSACL(xid, tcon, fid, &pacl, &buflen);
+		CIFSSMBClose(xid, tcon, fid);
+#endif /* CONFIG_CIFS_EXPERIMENTAL */
 	}
 
-set_ea_exit:
+out:
+	if (rc == -EINVAL)
+		rc = -EOPNOTSUPP;
 	kfree(full_path);
+out_free_xid:
 	FreeXid(xid);
-#endif
 	return rc;
 }
 
-ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
-	void *ea_value, size_t buf_size)
+static int
+cifs_xattr_acl_set(struct dentry *dentry, const char *name,
+		const void *value, size_t size, int flags, int type)
 {
-	ssize_t rc = -EOPNOTSUPP;
-#ifdef CONFIG_CIFS_XATTR
-	int xid;
-	struct cifs_sb_info *cifs_sb;
-	struct cifsTconInfo *pTcon;
-	struct super_block *sb;
+	struct super_block *sb = dentry->d_inode->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifsTconInfo *tcon = cifs_sb->tcon;
+	int rc = -EOPNOTSUPP;
 	char *full_path;
+	int xid;
 
-	if (direntry == NULL)
-		return -EIO;
-	if (direntry->d_inode == NULL)
-		return -EIO;
-	sb = direntry->d_inode->i_sb;
-	if (sb == NULL)
-		return -EIO;
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
 
-	xid = GetXid();
+	/* we do not support removing ACLs */
+	if (!value)
+		return -EOPNOTSUPP;
 
-	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb->tcon;
+	xid = GetXid();
 
-	full_path = build_path_from_dentry(direntry);
-	if (full_path == NULL) {
+	full_path = build_path_from_dentry(dentry);
+	if (!full_path) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto out_free_xid;
 	}
-	/* return dos attributes as pseudo xattr */
-	/* return alt name if available as pseudo attr */
-	if (ea_name == NULL) {
-		cFYI(1, "Null xattr names not supported");
-	} else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto get_ea_exit;
-
-		if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0) {
-			cFYI(1, "attempt to query cifs inode metadata");
-			/* revalidate/getattr then populate from inode */
-		} /* BB add else when above is implemented */
-		ea_name += 5; /* skip past user. prefix */
-		rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
-			buf_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-	} else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto get_ea_exit;
-
-		ea_name += 4; /* skip past os2. prefix */
-		rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
-			buf_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-	} else if (strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
-			  strlen(POSIX_ACL_XATTR_ACCESS)) == 0) {
-#ifdef CONFIG_CIFS_POSIX
-		if (sb->s_flags & MS_POSIXACL)
-			rc = CIFSSMBGetPosixACL(xid, pTcon, full_path,
-				ea_value, buf_size, ACL_TYPE_ACCESS,
-				cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-		else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
-			__u16 fid;
-			int oplock = 0;
-			struct cifs_ntsd *pacl = NULL;
-			__u32 buflen = 0;
-			if (experimEnabled)
-				rc = CIFSSMBOpen(xid, pTcon, full_path,
-					FILE_OPEN, GENERIC_READ, 0, &fid,
-					&oplock, NULL, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
-			/* else rc is EOPNOTSUPP from above */
 
-			if (rc == 0) {
-				rc = CIFSSMBGetCIFSACL(xid, pTcon, fid, &pacl,
-						      &buflen);
-				CIFSSMBClose(xid, pTcon, fid);
-			}
-		}
-#endif /* EXPERIMENTAL */
-#else
-		cFYI(1, "query POSIX ACL not supported yet");
-#endif /* CONFIG_CIFS_POSIX */
-	} else if (strncmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
-			  strlen(POSIX_ACL_XATTR_DEFAULT)) == 0) {
-#ifdef CONFIG_CIFS_POSIX
-		if (sb->s_flags & MS_POSIXACL)
-			rc = CIFSSMBGetPosixACL(xid, pTcon, full_path,
-				ea_value, buf_size, ACL_TYPE_DEFAULT,
-				cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
-#else
-		cFYI(1, "query POSIX default ACL not supported yet");
-#endif
-	} else if (strncmp(ea_name,
-		  CIFS_XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) == 0) {
-		cFYI(1, "Trusted xattr namespace not supported yet");
-	} else if (strncmp(ea_name,
-		  CIFS_XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) == 0) {
-		cFYI(1, "Security xattr namespace not supported yet");
-	} else
-		cFYI(1,
-		    "illegal xattr request %s (only user namespace supported)",
-		     ea_name);
-
-	/* We could add an additional check for streams ie
-	    if proc/fs/cifs/streamstoxattr is set then
-		search server for EAs or streams to
-		returns as xattrs */
+	if (size > MAX_EA_VALUE_SIZE) {
+		cFYI(1, "size of EA value too large");
+		rc = -EOPNOTSUPP;
+		goto out_free_path;
+	}
 
-	if (rc == -EINVAL)
+	if (!(sb->s_flags & MS_POSIXACL)) {
 		rc = -EOPNOTSUPP;
+		goto out_free_path;
+	}
 
-get_ea_exit:
+	rc = CIFSSMBSetPosixACL(xid, tcon, full_path, value, size, type,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+out_free_path:
 	kfree(full_path);
+out_free_xid:
 	FreeXid(xid);
-#endif
 	return rc;
 }
 
-ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
+static struct xattr_handler cifs_xattr_acl_access_handler = {
+	.prefix	= POSIX_ACL_XATTR_ACCESS,
+	.flags	= ACL_TYPE_ACCESS,
+	.get	= cifs_xattr_acl_get,
+	.set	= cifs_xattr_acl_set,
+};
+
+static struct xattr_handler cifs_xattr_acl_default_handler = {
+	.prefix	= POSIX_ACL_XATTR_DEFAULT,
+	.flags	= ACL_TYPE_DEFAULT,
+	.get	= cifs_xattr_acl_get,
+	.set	= cifs_xattr_acl_set,
+};
+#endif /* CONFIG_CIFS_POSIX */
+
+ssize_t cifs_listxattr(struct dentry *dentry, char *data, size_t buf_size)
 {
-	ssize_t rc = -EOPNOTSUPP;
-#ifdef CONFIG_CIFS_XATTR
-	int xid;
-	struct cifs_sb_info *cifs_sb;
-	struct cifsTconInfo *pTcon;
-	struct super_block *sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_inode->i_sb);
 	char *full_path;
-
-	if (direntry == NULL)
-		return -EIO;
-	if (direntry->d_inode == NULL)
-		return -EIO;
-	sb = direntry->d_inode->i_sb;
-	if (sb == NULL)
-		return -EIO;
-
-	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb->tcon;
+	ssize_t rc;
+	int xid;
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 		return -EOPNOTSUPP;
 
 	xid = GetXid();
 
-	full_path = build_path_from_dentry(direntry);
+	full_path = build_path_from_dentry(dentry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto out_free_xid;
 	}
-	/* return dos attributes as pseudo xattr */
-	/* return alt name if available as pseudo attr */
 
-	/* if proc/fs/cifs/streamstoxattr is set then
-		search server for EAs or streams to
-		returns as xattrs */
-	rc = CIFSSMBQAllEAs(xid, pTcon, full_path, NULL, data,
+	rc = CIFSSMBQAllEAs(xid, cifs_sb->tcon, full_path, NULL, data,
 				buf_size, cifs_sb->local_nls,
 				cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 
 	kfree(full_path);
+out_free_xid:
 	FreeXid(xid);
-#endif
 	return rc;
 }
+
+const struct xattr_handler *cifs_xattr_handlers[] = {
+	&cifs_xattr_user_handler,
+	&cifs_xattr_os2_handler,
+#ifdef CONFIG_CIFS_POSIX
+	&cifs_xattr_acl_access_handler,
+	&cifs_xattr_acl_default_handler,
+#endif
+	NULL
+};
Index: linux-2.6/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.orig/fs/cifs/cifsfs.c	2010-06-29 16:58:41.652253975 +0200
+++ linux-2.6/fs/cifs/cifsfs.c	2010-06-29 16:59:11.108282611 +0200
@@ -35,6 +35,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/xattr.h>
 #include <linux/smp_lock.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
@@ -136,6 +137,9 @@ cifs_read_super(struct super_block *sb,
 	sb->s_magic = CIFS_MAGIC_NUMBER;
 	sb->s_op = &cifs_super_ops;
 	sb->s_bdi = &cifs_sb->bdi;
+#ifdef CONFIG_CIFS_XATTR
+	sb->s_xattr = cifs_xattr_handlers;
+#endif
 /*	if (cifs_sb->tcon->ses->server->maxBuf > MAX_CIFS_HDR_SIZE + 512)
 	    sb->s_blocksize =
 		cifs_sb->tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE; */
@@ -606,10 +610,10 @@ const struct inode_operations cifs_dir_i
 	.symlink = cifs_symlink,
 	.mknod   = cifs_mknod,
 #ifdef CONFIG_CIFS_XATTR
-	.setxattr = cifs_setxattr,
-	.getxattr = cifs_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
+	.removexattr = generic_removexattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = cifs_removexattr,
 #endif
 };
 
@@ -620,10 +624,10 @@ const struct inode_operations cifs_file_
 	.rename = cifs_rename,
 	.permission = cifs_permission,
 #ifdef CONFIG_CIFS_XATTR
-	.setxattr = cifs_setxattr,
-	.getxattr = cifs_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
+	.removexattr = generic_removexattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = cifs_removexattr,
 #endif
 };
 
@@ -636,10 +640,10 @@ const struct inode_operations cifs_symli
 	/* revalidate: cifs_revalidate,
 	   setattr:    cifs_notify_change, *//* BB do we need notify change */
 #ifdef CONFIG_CIFS_XATTR
-	.setxattr = cifs_setxattr,
-	.getxattr = cifs_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
+	.removexattr = generic_removexattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = cifs_removexattr,
 #endif
 };
 
Index: linux-2.6/fs/cifs/cifsfs.h
===================================================================
--- linux-2.6.orig/fs/cifs/cifsfs.h	2010-06-29 16:58:41.664254464 +0200
+++ linux-2.6/fs/cifs/cifsfs.h	2010-06-29 17:13:38.882284776 +0200
@@ -103,11 +103,10 @@ extern int cifs_readlink(struct dentry *
 			 int buflen);
 extern int cifs_symlink(struct inode *inode, struct dentry *direntry,
 			const char *symname);
-extern int	cifs_removexattr(struct dentry *, const char *);
-extern int 	cifs_setxattr(struct dentry *, const char *, const void *,
-			size_t, int);
-extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
+
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
+extern const struct xattr_handler *cifs_xattr_handlers[];
+
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
