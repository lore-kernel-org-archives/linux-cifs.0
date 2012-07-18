From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 11/45] CIFS: Move open code to ops struct
Date: Wed, 18 Jul 2012 19:48:27 +0400
Message-ID: <1342626541-29872-12-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    7 +++++
 fs/cifs/cifsproto.h |    7 +++--
 fs/cifs/dir.c       |   17 +++++++------
 fs/cifs/file.c      |   63 ++++++++++++++++++++++++--------------------------
 fs/cifs/smb1ops.c   |   29 +++++++++++++++++++++++
 5 files changed, 79 insertions(+), 44 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 01ee8d2..c4375d8 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -171,6 +171,7 @@ struct cifs_tcon;
 struct dfs_info3_param;
 struct cifs_fattr;
 struct smb_vol;
+struct cifs_fid;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
@@ -262,6 +263,12 @@ struct smb_version_operations {
 	/* open, rename and delete file */
 	int (*rename_pending_delete)(const char *, struct dentry *,
 				     const unsigned int);
+	/* open a file for non-posix mounts */
+	int (*open)(const unsigned int, struct cifs_tcon *, const char *, int,
+		    int, int, struct cifs_fid *, __u32 *, FILE_ALL_INFO *,
+		    struct cifs_sb_info *);
+	/* set fid protocol-specific info */
+	void (*set_fid)(struct cifsFileInfo *, struct cifs_fid *, __u32);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e9349af..80b0e40 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -121,9 +121,10 @@ extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 				      int offset);
 extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
 
-extern struct cifsFileInfo *cifs_new_fileinfo(__u16 fileHandle,
-				struct file *file, struct tcon_link *tlink,
-				__u32 oplock);
+extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
+					      struct file *file,
+					      struct tcon_link *tlink,
+					      __u32 oplock);
 extern int cifs_posix_open(char *full_path, struct inode **inode,
 			   struct super_block *sb, int mode,
 			   unsigned int f_flags, __u32 *oplock, __u16 *netfid,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index cbe709a..eebffaf 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -384,11 +384,12 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	unsigned int xid;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
-	__u16 fileHandle;
+	struct cifs_fid fid;
 	__u32 oplock;
-	struct cifsFileInfo *pfile_info;
+	struct cifsFileInfo *file_info;
 
-	/* Posix open is only called (at lookup time) for file create now.  For
+	/*
+	 * Posix open is only called (at lookup time) for file create now. For
 	 * opens (rather than creates), because we do not know if it is a file
 	 * or directory yet, and current Samba no longer allows us to do posix
 	 * open on dirs, we could end up wasting an open call on what turns out
@@ -422,20 +423,20 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	tcon = tlink_tcon(tlink);
 
 	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fileHandle, opened);
+			    &oplock, &fid.netfid, opened);
 
 	if (rc)
 		goto out;
 
 	rc = finish_open(file, direntry, generic_file_open, opened);
 	if (rc) {
-		CIFSSMBClose(xid, tcon, fileHandle);
+		CIFSSMBClose(xid, tcon, fid.netfid);
 		goto out;
 	}
 
-	pfile_info = cifs_new_fileinfo(fileHandle, file, tlink, oplock);
-	if (pfile_info == NULL) {
-		CIFSSMBClose(xid, tcon, fileHandle);
+	file_info = cifs_new_fileinfo(&fid, file, tlink, oplock);
+	if (file_info == NULL) {
+		CIFSSMBClose(xid, tcon, fid.netfid);
 		rc = -ENOMEM;
 	}
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f542574..3f4b4ba 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -169,16 +169,19 @@ posix_open_ret:
 
 static int
 cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
-	     struct cifs_tcon *tcon, unsigned int f_flags, __u32 *poplock,
-	     __u16 *pnetfid, unsigned int xid)
+	     struct cifs_tcon *tcon, unsigned int f_flags, __u32 *oplock,
+	     struct cifs_fid *fid, unsigned int xid)
 {
 	int rc;
-	int desiredAccess;
+	int desired_access;
 	int disposition;
 	int create_options = CREATE_NOT_DIR;
 	FILE_ALL_INFO *buf;
 
-	desiredAccess = cifs_convert_flags(f_flags);
+	if (!tcon->ses->server->ops->open)
+		return -ENOSYS;
+
+	desired_access = cifs_convert_flags(f_flags);
 
 /*********************************************************************
  *  open flag mapping table:
@@ -215,16 +218,9 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
-	if (tcon->ses->capabilities & CAP_NT_SMBS)
-		rc = CIFSSMBOpen(xid, tcon, full_path, disposition,
-			 desiredAccess, create_options, pnetfid, poplock, buf,
-			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
-				 & CIFS_MOUNT_MAP_SPECIAL_CHR);
-	else
-		rc = SMBLegacyOpen(xid, tcon, full_path, disposition,
-			desiredAccess, CREATE_NOT_DIR, pnetfid, poplock, buf,
-			cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
-				& CIFS_MOUNT_MAP_SPECIAL_CHR);
+	rc = tcon->ses->server->ops->open(xid, tcon, full_path, disposition,
+					  desired_access, create_options, fid,
+					  oplock, buf, cifs_sb);
 
 	if (rc)
 		goto out;
@@ -234,7 +230,7 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 					      xid);
 	else
 		rc = cifs_get_inode_info(&inode, full_path, buf, inode->i_sb,
-					 xid, pnetfid);
+					 xid, &fid->netfid);
 
 out:
 	kfree(buf);
@@ -242,7 +238,7 @@ out:
 }
 
 struct cifsFileInfo *
-cifs_new_fileinfo(__u16 fileHandle, struct file *file,
+cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 		  struct tcon_link *tlink, __u32 oplock)
 {
 	struct dentry *dentry = file->f_path.dentry;
@@ -255,7 +251,6 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 		return cfile;
 
 	cfile->count = 1;
-	cfile->fid.netfid = fileHandle;
 	cfile->pid = current->tgid;
 	cfile->uid = current_fsuid();
 	cfile->dentry = dget(dentry);
@@ -265,6 +260,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	mutex_init(&cfile->fh_mutex);
 	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
 	INIT_LIST_HEAD(&cfile->llist);
+	tlink_tcon(tlink)->ses->server->ops->set_fid(cfile, fid, oplock);
 
 	spin_lock(&cifs_file_list_lock);
 	list_add(&cfile->tlist, &(tlink_tcon(tlink)->openFileList));
@@ -275,9 +271,6 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 		list_add_tail(&cfile->flist, &cinode->openFileList);
 	spin_unlock(&cifs_file_list_lock);
 
-	cifs_set_oplock_level(cinode, oplock);
-	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
-
 	file->private_data = cfile;
 	return cfile;
 }
@@ -355,10 +348,10 @@ int cifs_open(struct inode *inode, struct file *file)
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
-	struct cifsFileInfo *pCifsFile = NULL;
+	struct cifsFileInfo *cfile = NULL;
 	char *full_path = NULL;
 	bool posix_open_ok = false;
-	__u16 netfid;
+	struct cifs_fid fid;
 
 	xid = get_xid();
 
@@ -390,7 +383,7 @@ int cifs_open(struct inode *inode, struct file *file)
 		/* can not refresh inode info since size could be stale */
 		rc = cifs_posix_open(full_path, &inode, inode->i_sb,
 				cifs_sb->mnt_file_mode /* ignored */,
-				file->f_flags, &oplock, &netfid, xid);
+				file->f_flags, &oplock, &fid.netfid, xid);
 		if (rc == 0) {
 			cFYI(1, "posix open succeeded");
 			posix_open_ok = true;
@@ -406,20 +399,22 @@ int cifs_open(struct inode *inode, struct file *file)
 		} else if ((rc != -EIO) && (rc != -EREMOTE) &&
 			 (rc != -EOPNOTSUPP)) /* path not found or net err */
 			goto out;
-		/* else fallthrough to retry open the old way on network i/o
-		   or DFS errors */
+		/*
+		 * Else fallthrough to retry open the old way on network i/o
+		 * or DFS errors.
+		 */
 	}
 
 	if (!posix_open_ok) {
 		rc = cifs_nt_open(full_path, inode, cifs_sb, tcon,
-				  file->f_flags, &oplock, &netfid, xid);
+				  file->f_flags, &oplock, &fid, xid);
 		if (rc)
 			goto out;
 	}
 
-	pCifsFile = cifs_new_fileinfo(netfid, file, tlink, oplock);
-	if (pCifsFile == NULL) {
-		CIFSSMBClose(xid, tcon, netfid);
+	cfile = cifs_new_fileinfo(&fid, file, tlink, oplock);
+	if (cfile == NULL) {
+		CIFSSMBClose(xid, tcon, fid.netfid);
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -427,8 +422,10 @@ int cifs_open(struct inode *inode, struct file *file)
 	cifs_fscache_set_inode_cookie(inode, file);
 
 	if ((oplock & CIFS_CREATE_ACTION) && !posix_open_ok && tcon->unix_ext) {
-		/* time to set mode which we can not set earlier due to
-		   problems creating new read-only files */
+		/*
+		 * Time to set mode which we can not set earlier due to
+		 * problems creating new read-only files.
+		 */
 		struct cifs_unix_set_info_args args = {
 			.mode	= inode->i_mode,
 			.uid	= NO_CHANGE_64,
@@ -438,8 +435,8 @@ int cifs_open(struct inode *inode, struct file *file)
 			.mtime	= NO_CHANGE_64,
 			.device	= 0,
 		};
-		CIFSSMBUnixSetFileInfo(xid, tcon, &args, netfid,
-					pCifsFile->pid);
+		CIFSSMBUnixSetFileInfo(xid, tcon, &args, fid.netfid,
+				       cfile->pid);
 	}
 
 out:
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index b170da0..907b308 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -607,6 +607,33 @@ cifs_mkdir_setinfo(struct inode *inode, const char *full_path,
 		cifsInode->cifsAttrs = dosattrs;
 }
 
+static int
+cifs_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
+	       int disposition, int desired_access, int create_options,
+	       struct cifs_fid *fid, __u32 *oplock, FILE_ALL_INFO *buf,
+	       struct cifs_sb_info *cifs_sb)
+{
+	if (!(tcon->ses->capabilities & CAP_NT_SMBS))
+		return SMBLegacyOpen(xid, tcon, path, disposition,
+				     desired_access, CREATE_NOT_DIR,
+				     &fid->netfid, oplock, buf,
+				     cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
+						& CIFS_MOUNT_MAP_SPECIAL_CHR);
+	return CIFSSMBOpen(xid, tcon, path, disposition, desired_access,
+			   create_options, &fid->netfid, oplock, buf,
+			   cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+}
+
+static void
+cifs_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
+{
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
+	cfile->fid.netfid = fid->netfid;
+	cifs_set_oplock_level(cinode, oplock);
+	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -646,6 +673,8 @@ struct smb_version_operations smb1_operations = {
 	.rmdir = CIFSSMBRmDir,
 	.unlink = CIFSSMBDelFile,
 	.rename_pending_delete = cifs_rename_pending_delete,
+	.open = cifs_open_file,
+	.set_fid = cifs_set_fid,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
