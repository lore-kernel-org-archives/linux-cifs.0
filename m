From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Add support of Alternate Data Streams
Date: Mon,  3 Sep 2012 18:06:06 -0500
Message-ID: <1346713566-31140-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Add support of Alternate Data Streams (ads).
For the support, we need to add additional (desired) access flags
to the generic ones that cifs client does currently.
The ads files have a : in the name, so that is used to differentiate
and add additional desired access.
One operations that does not work is Rename (0x7).


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/dir.c   |   12 ++++++++++--
 fs/cifs/file.c  |   45 ++++++++++++++++++++++++++++++++++-----------
 fs/cifs/inode.c |   14 ++++++++++++++
 3 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index cbe709a..8f8d546 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -245,10 +245,18 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	}
 
 	desiredAccess = 0;
-	if (OPEN_FMODE(oflags) & FMODE_READ)
+	if (OPEN_FMODE(oflags) & FMODE_READ) {
 		desiredAccess |= GENERIC_READ; /* is this too little? */
-	if (OPEN_FMODE(oflags) & FMODE_WRITE)
+		if (strstr(full_path, ":"))
+			desiredAccess |= FILE_READ_DATA | FILE_READ_EA |
+				FILE_READ_ATTRIBUTES | READ_CONTROL;
+	}
+	if (OPEN_FMODE(oflags) & FMODE_WRITE) {
 		desiredAccess |= GENERIC_WRITE;
+		if (strstr(full_path, ":"))
+			desiredAccess |= FILE_WRITE_DATA | FILE_APPEND_DATA |
+					FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES;
+	}
 
 	disposition = FILE_OVERWRITE_IF;
 	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9154192..80f35f8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -43,22 +43,41 @@
 #include "cifs_fs_sb.h"
 #include "fscache.h"
 
-static inline int cifs_convert_flags(unsigned int flags)
-{
-	if ((flags & O_ACCMODE) == O_RDONLY)
-		return GENERIC_READ;
-	else if ((flags & O_ACCMODE) == O_WRONLY)
-		return GENERIC_WRITE;
-	else if ((flags & O_ACCMODE) == O_RDWR) {
+static inline int cifs_convert_flags(char *full_path, unsigned int flags)
+{
+	int daccess = 0;
+
+	if ((flags & O_ACCMODE) == O_RDONLY) {
+		daccess = GENERIC_READ;
+		if (strstr(full_path, ":"))
+			daccess |= FILE_READ_DATA | FILE_READ_EA |
+				FILE_READ_ATTRIBUTES | READ_CONTROL;
+		return daccess;
+	} else if ((flags & O_ACCMODE) == O_WRONLY) {
+		daccess = GENERIC_WRITE;
+		if (strstr(full_path, ":"))
+			daccess |= FILE_WRITE_DATA | FILE_APPEND_DATA |
+				FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES;
+		return daccess;
+	} else if ((flags & O_ACCMODE) == O_RDWR) {
 		/* GENERIC_ALL is too much permission to request
 		   can cause unnecessary access denied on create */
 		/* return GENERIC_ALL; */
-		return (GENERIC_READ | GENERIC_WRITE);
+		daccess = GENERIC_READ | GENERIC_WRITE;
+		if (strstr(full_path, ":"))
+			daccess |= FILE_READ_DATA | FILE_WRITE_DATA |
+				FILE_APPEND_DATA | FILE_READ_EA |
+				FILE_WRITE_EA | FILE_READ_ATTRIBUTES |
+				FILE_WRITE_ATTRIBUTES | READ_CONTROL;
+		return daccess;
 	}
 
-	return (READ_CONTROL | FILE_WRITE_ATTRIBUTES | FILE_READ_ATTRIBUTES |
+	daccess = READ_CONTROL | FILE_WRITE_ATTRIBUTES | FILE_READ_ATTRIBUTES |
 		FILE_WRITE_EA | FILE_APPEND_DATA | FILE_WRITE_DATA |
-		FILE_READ_DATA);
+		FILE_READ_DATA;
+
+	return daccess;
+
 }
 
 static u32 cifs_posix_convert_flags(unsigned int flags)
@@ -149,6 +168,8 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 		goto posix_open_ret; /* caller does not need info */
 
 	cifs_unix_basic_to_fattr(&fattr, presp_data, cifs_sb);
+	if (strstr(full_path, ":"))
+		fattr.cf_flags |= S_PRIVATE;
 
 	/* get new inode and set it up */
 	if (*pinode == NULL) {
@@ -158,6 +179,8 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 			rc = -ENOMEM;
 			goto posix_open_ret;
 		}
+		if (strstr(full_path, ":"))
+			(*pinode)->i_flags |= S_PRIVATE;
 	} else {
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
@@ -178,7 +201,7 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 	int create_options = CREATE_NOT_DIR;
 	FILE_ALL_INFO *buf;
 
-	desiredAccess = cifs_convert_flags(f_flags);
+	desiredAccess = cifs_convert_flags(full_path, f_flags);
 
 /*********************************************************************
  *  open flag mapping table:
@@ -538,7 +561,7 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
 		   in the reconnect path it is important to retry hard */
 	}
 
-	desiredAccess = cifs_convert_flags(pCifsFile->f_flags);
+	desiredAccess = cifs_convert_flags(full_path, pCifsFile->f_flags);
 
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 7354877..0bde128 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -351,12 +351,17 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 			cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
 	}
 
+	if (strstr(full_path, ":"))
+		fattr.cf_flags |= S_PRIVATE;
+
 	if (*pinode == NULL) {
 		/* get new inode */
 		cifs_fill_uniqueid(sb, &fattr);
 		*pinode = cifs_iget(sb, &fattr);
 		if (!*pinode)
 			rc = -ENOMEM;
+		if (strstr(full_path, ":"))
+			(*pinode)->i_flags |= S_PRIVATE;
 	} else {
 		/* we already have inode, update it */
 		cifs_fattr_to_inode(*pinode, &fattr);
@@ -713,10 +718,15 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 			cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
 	}
 
+	if (strstr(full_path, ":"))
+		fattr.cf_flags |= S_PRIVATE;
+
 	if (!*inode) {
 		*inode = cifs_iget(sb, &fattr);
 		if (!*inode)
 			rc = -ENOMEM;
+		if (strstr(full_path, ":"))
+			(*inode)->i_flags |= S_PRIVATE;
 	} else {
 		cifs_fattr_to_inode(*inode, &fattr);
 	}
@@ -748,6 +758,10 @@ cifs_find_inode(struct inode *inode, void *opaque)
 	if ((inode->i_mode & S_IFMT) != (fattr->cf_mode & S_IFMT))
 		return 0;
 
+	/* don't match inode with different flags */
+	if ((inode->i_flags & S_PRIVATE) != (fattr->cf_flags & S_PRIVATE))
+		return 0;
+
 	/* if it's not a directory or has no dentries, then flag it */
 	if (S_ISDIR(inode->i_mode) && !hlist_empty(&inode->i_dentry))
 		fattr->cf_flags |= CIFS_FATTR_INO_COLLISION;
-- 
1.6.0.2
