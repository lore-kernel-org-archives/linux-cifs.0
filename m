From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/16] cifs: fix flags handling in cifs_posix_open
Date: Mon, 11 Oct 2010 15:07:21 -0400
Message-ID: <1286824053-12084-5-git-send-email-jlayton@redhat.com>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286824053-12084-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The way flags are passed and converted for cifs_posix_open is rather
non-sensical. Some callers call cifs_posix_convert_flags on the flags
before they pass them to cifs_posix_open, whereas some don't. Two flag
conversion steps is just confusing though.

Change the function instead to clearly expect input in f_flags format,
and fix the callers to pass that in. Then, have cifs_posix_open call
cifs_convert_posix_flags to do the conversion. Move cifs_posix_open to
file.c as well so we can keep cifs_convert_posix_flags as a static
function.

Fix it also to not ignore O_CREAT, O_EXCL and O_TRUNC, and instead have
cifs_reopen_file mask those bits off before calling cifs_posix_open.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/dir.c       |   99 +++------------------------------------------
 fs/cifs/file.c      |  113 +++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 95 insertions(+), 119 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7f416ab..4f7edba 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -111,7 +111,7 @@ extern struct cifsFileInfo *cifs_new_fileinfo(struct inode *newinode,
 				unsigned int oflags, __u32 oplock);
 extern int cifs_posix_open(char *full_path, struct inode **pinode,
 				struct super_block *sb,
-				int mode, int oflags,
+				int mode, unsigned int f_flags,
 				__u32 *poplock, __u16 *pnetfid, int xid);
 void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr);
 extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index c205ec9..8c1af71 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -181,93 +181,6 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
 	return pCifsFile;
 }
 
-int cifs_posix_open(char *full_path, struct inode **pinode,
-			struct super_block *sb, int mode, int oflags,
-			__u32 *poplock, __u16 *pnetfid, int xid)
-{
-	int rc;
-	FILE_UNIX_BASIC_INFO *presp_data;
-	__u32 posix_flags = 0;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifs_fattr fattr;
-	struct tcon_link *tlink;
-	struct cifsTconInfo *tcon;
-
-	cFYI(1, "posix open %s", full_path);
-
-	presp_data = kzalloc(sizeof(FILE_UNIX_BASIC_INFO), GFP_KERNEL);
-	if (presp_data == NULL)
-		return -ENOMEM;
-
-/* So far cifs posix extensions can only map the following flags.
-   There are other valid fmode oflags such as FMODE_LSEEK, FMODE_PREAD, but
-   so far we do not seem to need them, and we can treat them as local only */
-	if ((oflags & (FMODE_READ | FMODE_WRITE)) ==
-		(FMODE_READ | FMODE_WRITE))
-		posix_flags = SMB_O_RDWR;
-	else if (oflags & FMODE_READ)
-		posix_flags = SMB_O_RDONLY;
-	else if (oflags & FMODE_WRITE)
-		posix_flags = SMB_O_WRONLY;
-	if (oflags & O_CREAT)
-		posix_flags |= SMB_O_CREAT;
-	if (oflags & O_EXCL)
-		posix_flags |= SMB_O_EXCL;
-	if (oflags & O_TRUNC)
-		posix_flags |= SMB_O_TRUNC;
-	/* be safe and imply O_SYNC for O_DSYNC */
-	if (oflags & O_DSYNC)
-		posix_flags |= SMB_O_SYNC;
-	if (oflags & O_DIRECTORY)
-		posix_flags |= SMB_O_DIRECTORY;
-	if (oflags & O_NOFOLLOW)
-		posix_flags |= SMB_O_NOFOLLOW;
-	if (oflags & O_DIRECT)
-		posix_flags |= SMB_O_DIRECT;
-
-	mode &= ~current_umask();
-
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink)) {
-		rc = PTR_ERR(tlink);
-		goto posix_open_ret;
-	}
-
-	tcon = tlink_tcon(tlink);
-	rc = CIFSPOSIXCreate(xid, tcon, posix_flags, mode, pnetfid, presp_data,
-			     poplock, full_path, cifs_sb->local_nls,
-			     cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
-	cifs_put_tlink(tlink);
-
-	if (rc)
-		goto posix_open_ret;
-
-	if (presp_data->Type == cpu_to_le32(-1))
-		goto posix_open_ret; /* open ok, caller does qpathinfo */
-
-	if (!pinode)
-		goto posix_open_ret; /* caller does not need info */
-
-	cifs_unix_basic_to_fattr(&fattr, presp_data, cifs_sb);
-
-	/* get new inode and set it up */
-	if (*pinode == NULL) {
-		cifs_fill_uniqueid(sb, &fattr);
-		*pinode = cifs_iget(sb, &fattr);
-		if (!*pinode) {
-			rc = -ENOMEM;
-			goto posix_open_ret;
-		}
-	} else {
-		cifs_fattr_to_inode(*pinode, &fattr);
-	}
-
-posix_open_ret:
-	kfree(presp_data);
-	return rc;
-}
-
 static void setup_cifs_dentry(struct cifsTconInfo *tcon,
 			      struct dentry *direntry,
 			      struct inode *newinode)
@@ -321,9 +234,9 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 		oplock = REQ_OPLOCK;
 
 	if (nd && (nd->flags & LOOKUP_OPEN))
-		oflags = nd->intent.open.flags;
+		oflags = nd->intent.open.file->f_flags;
 	else
-		oflags = FMODE_READ | SMB_O_CREAT;
+		oflags = O_RDONLY | O_CREAT;
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
@@ -359,9 +272,9 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 		/* if the file is going to stay open, then we
 		   need to set the desired access properly */
 		desiredAccess = 0;
-		if (oflags & FMODE_READ)
+		if (OPEN_FMODE(oflags) & FMODE_READ)
 			desiredAccess |= GENERIC_READ; /* is this too little? */
-		if (oflags & FMODE_WRITE)
+		if (OPEN_FMODE(oflags) & FMODE_WRITE)
 			desiredAccess |= GENERIC_WRITE;
 
 		if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
@@ -716,11 +629,11 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	if (pTcon->unix_ext) {
 		if (nd && !(nd->flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY)) &&
 		     (nd->flags & LOOKUP_OPEN) && !pTcon->broken_posix_open &&
-		     (nd->intent.open.flags & O_CREAT)) {
+		     (nd->intent.open.file->f_flags & O_CREAT)) {
 			rc = cifs_posix_open(full_path, &newInode,
 					parent_dir_inode->i_sb,
 					nd->intent.open.create_mode,
-					nd->intent.open.flags, &oplock,
+					nd->intent.open.file->f_flags, &oplock,
 					&fileHandle, xid);
 			/*
 			 * The check below works around a bug in POSIX
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c10f085..b1ca6a4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -60,34 +60,32 @@ static inline int cifs_convert_flags(unsigned int flags)
 		FILE_READ_DATA);
 }
 
-static inline fmode_t cifs_posix_convert_flags(unsigned int flags)
+static u32 cifs_posix_convert_flags(unsigned int flags)
 {
-	fmode_t posix_flags = 0;
+	u32 posix_flags = 0;
 
 	if ((flags & O_ACCMODE) == O_RDONLY)
-		posix_flags = FMODE_READ;
+		posix_flags = SMB_O_RDONLY;
 	else if ((flags & O_ACCMODE) == O_WRONLY)
-		posix_flags = FMODE_WRITE;
-	else if ((flags & O_ACCMODE) == O_RDWR) {
-		/* GENERIC_ALL is too much permission to request
-		   can cause unnecessary access denied on create */
-		/* return GENERIC_ALL; */
-		posix_flags = FMODE_READ | FMODE_WRITE;
-	}
-	/* can not map O_CREAT or O_EXCL or O_TRUNC flags when
-	   reopening a file.  They had their effect on the original open */
-	if (flags & O_APPEND)
-		posix_flags |= (fmode_t)O_APPEND;
+		posix_flags = SMB_O_WRONLY;
+	else if ((flags & O_ACCMODE) == O_RDWR)
+		posix_flags = SMB_O_RDWR;
+
+	if (flags & O_CREAT)
+		posix_flags |= SMB_O_CREAT;
+	if (flags & O_EXCL)
+		posix_flags |= SMB_O_EXCL;
+	if (flags & O_TRUNC)
+		posix_flags |= SMB_O_TRUNC;
+	/* be safe and imply O_SYNC for O_DSYNC */
 	if (flags & O_DSYNC)
-		posix_flags |= (fmode_t)O_DSYNC;
-	if (flags & __O_SYNC)
-		posix_flags |= (fmode_t)__O_SYNC;
+		posix_flags |= SMB_O_SYNC;
 	if (flags & O_DIRECTORY)
-		posix_flags |= (fmode_t)O_DIRECTORY;
+		posix_flags |= SMB_O_DIRECTORY;
 	if (flags & O_NOFOLLOW)
-		posix_flags |= (fmode_t)O_NOFOLLOW;
+		posix_flags |= SMB_O_NOFOLLOW;
 	if (flags & O_DIRECT)
-		posix_flags |= (fmode_t)O_DIRECT;
+		posix_flags |= SMB_O_DIRECT;
 
 	return posix_flags;
 }
@@ -159,6 +157,68 @@ client_can_cache:
 	return rc;
 }
 
+int cifs_posix_open(char *full_path, struct inode **pinode,
+			struct super_block *sb, int mode, unsigned int f_flags,
+			__u32 *poplock, __u16 *pnetfid, int xid)
+{
+	int rc;
+	FILE_UNIX_BASIC_INFO *presp_data;
+	__u32 posix_flags = 0;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_fattr fattr;
+	struct tcon_link *tlink;
+	struct cifsTconInfo *tcon;
+
+	cFYI(1, "posix open %s", full_path);
+
+	presp_data = kzalloc(sizeof(FILE_UNIX_BASIC_INFO), GFP_KERNEL);
+	if (presp_data == NULL)
+		return -ENOMEM;
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
+		goto posix_open_ret;
+	}
+
+	tcon = tlink_tcon(tlink);
+	mode &= ~current_umask();
+
+	posix_flags = cifs_posix_convert_flags(f_flags);
+	rc = CIFSPOSIXCreate(xid, tcon, posix_flags, mode, pnetfid, presp_data,
+			     poplock, full_path, cifs_sb->local_nls,
+			     cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
+	cifs_put_tlink(tlink);
+
+	if (rc)
+		goto posix_open_ret;
+
+	if (presp_data->Type == cpu_to_le32(-1))
+		goto posix_open_ret; /* open ok, caller does qpathinfo */
+
+	if (!pinode)
+		goto posix_open_ret; /* caller does not need info */
+
+	cifs_unix_basic_to_fattr(&fattr, presp_data, cifs_sb);
+
+	/* get new inode and set it up */
+	if (*pinode == NULL) {
+		cifs_fill_uniqueid(sb, &fattr);
+		*pinode = cifs_iget(sb, &fattr);
+		if (!*pinode) {
+			rc = -ENOMEM;
+			goto posix_open_ret;
+		}
+	} else {
+		cifs_fattr_to_inode(*pinode, &fattr);
+	}
+
+posix_open_ret:
+	kfree(presp_data);
+	return rc;
+}
+
 int cifs_open(struct inode *inode, struct file *file)
 {
 	int rc = -EACCES;
@@ -205,12 +265,10 @@ int cifs_open(struct inode *inode, struct file *file)
 	    (tcon->ses->capabilities & CAP_UNIX) &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
-		int oflags = (int) cifs_posix_convert_flags(file->f_flags);
-		oflags |= SMB_O_CREAT;
 		/* can not refresh inode info since size could be stale */
 		rc = cifs_posix_open(full_path, &inode, inode->i_sb,
 				cifs_sb->mnt_file_mode /* ignored */,
-				oflags, &oplock, &netfid, xid);
+				file->f_flags, &oplock, &netfid, xid);
 		if (rc == 0) {
 			cFYI(1, "posix open succeeded");
 
@@ -426,8 +484,13 @@ reopen_error_exit:
 	if (tcon->unix_ext && (tcon->ses->capabilities & CAP_UNIX) &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
-		int oflags = (int) cifs_posix_convert_flags(file->f_flags);
-		/* can not refresh inode info since size could be stale */
+
+		/*
+		 * O_CREAT, O_EXCL and O_TRUNC already had their effect on the
+		 * original open. Must mask them off for a reopen.
+		 */
+		unsigned int oflags = file->f_flags & ~(O_CREAT|O_EXCL|O_TRUNC);
+
 		rc = cifs_posix_open(full_path, NULL, inode->i_sb,
 				cifs_sb->mnt_file_mode /* ignored */,
 				oflags, &oplock, &netfid, xid);
-- 
1.7.2.3
