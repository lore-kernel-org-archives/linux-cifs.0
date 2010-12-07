From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] cifs: remove export_ops code
Date: Tue,  7 Dec 2010 09:23:52 -0500
Message-ID: <1291731835-1120-2-git-send-email-jlayton@redhat.com>
References: <1291731835-1120-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291731835-1120-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Stubs for this code were added under the CONFIG_CIFS_EXPERIMENTAL tag in
2007, but were never completed. The upshot -- anyone who turns on
CONFIG_CIFS_EXPERIMENTAL gets a filesystem that pretends to allow exporting
via nfsd. Trying to actually use it will just get you an error once
nfsd tries to walk into the directory.

Remove this code since it's unfinished. We can reintroduce it once someone
spends time on it and makes it usable.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/Makefile |    2 +-
 fs/cifs/cifsfs.c |    7 -----
 fs/cifs/cifsfs.h |    4 ---
 fs/cifs/export.c |   67 ------------------------------------------------------
 4 files changed, 1 insertions(+), 79 deletions(-)
 delete mode 100644 fs/cifs/export.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 43b19dd..ee8a33c 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_CIFS) += cifs.o
 cifs-y := cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o inode.o \
 	  link.o misc.o netmisc.o smbdes.o smbencrypt.o transport.o asn1.o \
 	  md4.o md5.o cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
-	  readdir.o ioctl.o sess.o export.o
+	  readdir.o ioctl.o sess.o
 
 cifs-$(CONFIG_CIFS_ACL) += cifsacl.o
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index db28c28..48582b7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -174,13 +174,6 @@ cifs_read_super(struct super_block *sb, void *data,
 		goto out_no_root;
 	}
 
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
-		cFYI(1, "export ops supported");
-		sb->s_export_op = &cifs_export_ops;
-	}
-#endif /* EXPERIMENTAL */
-
 	return 0;
 
 out_no_root:
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 897b2b2..1d6d021 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -108,9 +108,5 @@ extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-extern const struct export_operations cifs_export_ops;
-#endif /* EXPERIMENTAL */
-
 #define CIFS_VERSION   "1.68"
 #endif				/* _CIFSFS_H */
diff --git a/fs/cifs/export.c b/fs/cifs/export.c
deleted file mode 100644
index 993f820..0000000
--- a/fs/cifs/export.c
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- *   fs/cifs/export.c
- *
- *   Copyright (C) International Business Machines  Corp., 2007
- *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
- *
- *   Common Internet FileSystem (CIFS) client
- *
- *   Operations related to support for exporting files via NFSD
- *
- *   This library is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU Lesser General Public License as published
- *   by the Free Software Foundation; either version 2.1 of the License, or
- *   (at your option) any later version.
- *
- *   This library is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- *   the GNU Lesser General Public License for more details.
- *
- *   You should have received a copy of the GNU Lesser General Public License
- *   along with this library; if not, write to the Free Software
- *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
- /*
-  * See Documentation/filesystems/nfs/Exporting
-  * and examples in fs/exportfs
-  *
-  * Since cifs is a network file system, an "fsid" must be included for
-  * any nfs exports file entries which refer to cifs paths.  In addition
-  * the cifs mount must be mounted with the "serverino" option (ie use stable
-  * server inode numbers instead of locally generated temporary ones).
-  * Although cifs inodes do not use generation numbers (have generation number
-  * of zero) - the inode number alone should be good enough for simple cases
-  * in which users want to export cifs shares with NFS. The decode and encode
-  * could be improved by using a new routine which expects 64 bit inode numbers
-  * instead of the default 32 bit routines in fs/exportfs
-  *
-  */
-
-#include <linux/fs.h>
-#include <linux/exportfs.h>
-#include "cifsglob.h"
-#include "cifs_debug.h"
-#include "cifsfs.h"
-
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-static struct dentry *cifs_get_parent(struct dentry *dentry)
-{
-	/* BB need to add code here eventually to enable export via NFSD */
-	cFYI(1, "get parent for %p", dentry);
-	return ERR_PTR(-EACCES);
-}
-
-const struct export_operations cifs_export_ops = {
-	.get_parent = cifs_get_parent,
-/*	Following five export operations are unneeded so far and can default:
-	.get_dentry =
-	.get_name =
-	.find_exported_dentry =
-	.decode_fh =
-	.encode_fs =  */
-};
-
-#endif /* EXPERIMENTAL */
-
-- 
1.7.3.2
