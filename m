From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 10/15] cifs: have cifsFileInfo hold a reference to a tlink rather than tcon pointer
Date: Fri, 20 Aug 2010 15:32:06 -0400
Message-ID: <1282332731-17444-11-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

cifsFileInfo needs a pointer to a tcon, but it doesn't currently hold a
reference to it. Change it to keep a pointer to a tcon_link instead and
hold a reference to it.

That will keep the tcon from being freed until the file is closed.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsfs.c    |    3 ++-
 fs/cifs/cifsglob.h  |   45 ++++++++++++++++++++++++++-------------------
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/dir.c       |   10 +++++-----
 fs/cifs/file.c      |   31 ++++++++++++++++---------------
 fs/cifs/inode.c     |   12 ++++++------
 fs/cifs/ioctl.c     |    2 +-
 fs/cifs/link.c      |    1 -
 fs/cifs/readdir.c   |    4 ++--
 9 files changed, 59 insertions(+), 51 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f1ae8df..c6b8776 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -576,7 +576,8 @@ static int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
 	    ((arg == F_WRLCK) &&
 		(CIFS_I(inode)->clientCanCacheAll)))
 		return generic_setlease(file, arg, lease);
-	else if (cfile->tcon->local_lease && !CIFS_I(inode)->clientCanCacheRead)
+	else if (tlink_tcon(cfile->tlink)->local_lease &&
+		 !CIFS_I(inode)->clientCanCacheRead)
 		/* If the server claims to support oplock on this
 		   file, then we still need to check oplock even
 		   if the local_lease mount option is set, but there
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9323587..cdd3d7a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -320,6 +320,30 @@ struct tcon_link {
 	struct cifsTconInfo	*tl_tcon;
 };
 
+static inline struct tcon_link *
+cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
+{
+	return (struct tcon_link *)cifs_sb->ptcon;
+}
+
+static inline struct cifsTconInfo *
+tlink_tcon(struct tcon_link *tlink)
+{
+	return (struct cifsTconInfo *)tlink;
+}
+
+static inline void
+cifs_put_tlink(struct tcon_link *tlink)
+{
+	return;
+}
+
+static inline struct tcon_link *
+cifs_get_tlink(struct tcon_link *tlink)
+{
+	return tlink;
+}
+
 /*
  * This info hangs off the cifsFileInfo structure, pointed to by llist.
  * This is used to track byte stream locks on the file
@@ -361,7 +385,7 @@ struct cifsFileInfo {
 	struct file *pfile; /* needed for writepage */
 	struct inode *pInode; /* needed for oplock break */
 	struct vfsmount *mnt;
-	struct cifsTconInfo *tcon;
+	struct tcon_link *tlink;
 	struct mutex lock_mutex;
 	struct list_head llist; /* list of byte range locks we have. */
 	bool closePend:1;	/* file is marked to close */
@@ -383,6 +407,7 @@ static inline void cifsFileInfo_get(struct cifsFileInfo *cifs_file)
 static inline void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 {
 	if (atomic_dec_and_test(&cifs_file->count)) {
+		cifs_put_tlink(cifs_file->tlink);
 		iput(cifs_file->pInode);
 		kfree(cifs_file);
 	}
@@ -424,24 +449,6 @@ CIFS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
-static inline struct tcon_link *
-cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
-{
-	return (struct tcon_link *)cifs_sb->ptcon;
-}
-
-static inline struct cifsTconInfo *
-tlink_tcon(struct tcon_link *tlink)
-{
-	return (struct cifsTconInfo *)tlink;
-}
-
-static inline void
-cifs_put_tlink(struct tcon_link *tlink)
-{
-	return;
-}
-
 /* This function is always expected to succeed */
 static inline struct cifsTconInfo *
 cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb)
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b7a0e33..493bca8 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -106,7 +106,7 @@ extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 
 extern struct cifsFileInfo *cifs_new_fileinfo(struct inode *newinode,
 				__u16 fileHandle, struct file *file,
-				struct vfsmount *mnt, struct cifsTconInfo *tcon,
+				struct vfsmount *mnt, struct tcon_link *tlink,
 				unsigned int oflags);
 extern int cifs_posix_open(char *full_path, struct inode **pinode,
 				struct super_block *sb,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 4675d08..bea578f 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -132,7 +132,7 @@ cifs_bp_rename_retry:
 
 struct cifsFileInfo *
 cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
-		  struct vfsmount *mnt, struct cifsTconInfo *tcon,
+		  struct vfsmount *mnt, struct tcon_link *tlink,
 		  unsigned int oflags)
 {
 	int oplock = 0;
@@ -153,7 +153,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
 	pCifsFile->pfile = file;
 	pCifsFile->invalidHandle = false;
 	pCifsFile->closePend = false;
-	pCifsFile->tcon = tcon;
+	pCifsFile->tlink = cifs_get_tlink(tlink);
 	mutex_init(&pCifsFile->fh_mutex);
 	mutex_init(&pCifsFile->lock_mutex);
 	INIT_LIST_HEAD(&pCifsFile->llist);
@@ -161,7 +161,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
 	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
 
 	write_lock(&GlobalSMBSeslock);
-	list_add(&pCifsFile->tlist, &tcon->openFileList);
+	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
 	pCifsInode = CIFS_I(newinode);
 	if (pCifsInode) {
 		/* if readable file instance put first in list*/
@@ -487,7 +487,7 @@ cifs_create_set_dentry:
 		}
 
 		pfile_info = cifs_new_fileinfo(newinode, fileHandle, filp,
-					       nd->path.mnt, tcon, oflags);
+					       nd->path.mnt, tlink, oflags);
 		if (pfile_info == NULL) {
 			fput(filp);
 			CIFSSMBClose(xid, tcon, fileHandle);
@@ -761,7 +761,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			}
 
 			cfile = cifs_new_fileinfo(newInode, fileHandle, filp,
-						  nd->path.mnt, pTcon,
+						  nd->path.mnt, tlink,
 						  nd->intent.open.flags);
 			if (cfile == NULL) {
 				fput(filp);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d257206..1ac808b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -283,7 +283,7 @@ int cifs_open(struct inode *inode, struct file *file)
 
 			pCifsFile = cifs_new_fileinfo(inode, netfid, file,
 							file->f_path.mnt,
-							tcon, oflags);
+							tlink, oflags);
 			if (pCifsFile == NULL) {
 				CIFSSMBClose(xid, tcon, netfid);
 				rc = -ENOMEM;
@@ -376,7 +376,7 @@ int cifs_open(struct inode *inode, struct file *file)
 		goto out;
 
 	pCifsFile = cifs_new_fileinfo(inode, netfid, file, file->f_path.mnt,
-				      tcon, file->f_flags);
+				      tlink, file->f_flags);
 	if (pCifsFile == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -468,7 +468,7 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
 	}
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	tcon = pCifsFile->tcon;
+	tcon = tlink_tcon(pCifsFile->tlink);
 
 /* can not grab rename sem here because various ops, including
    those that already have the rename sem can end up causing writepage
@@ -582,7 +582,7 @@ int cifs_close(struct inode *inode, struct file *file)
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = pSMBFile->tcon;
+	pTcon = tlink_tcon(pSMBFile->tlink);
 	if (pSMBFile) {
 		struct cifsLockInfo *li, *tmp;
 		write_lock(&GlobalSMBSeslock);
@@ -660,7 +660,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 	xid = GetXid();
 
 	if (pCFileStruct) {
-		struct cifsTconInfo *pTcon = pCFileStruct->tcon;
+		struct cifsTconInfo *pTcon = tlink_tcon(pCFileStruct->tlink);
 
 		cFYI(1, "Freeing private data in close dir");
 		write_lock(&GlobalSMBSeslock);
@@ -684,6 +684,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 			else
 				cifs_buf_release(ptmp);
 		}
+		cifs_put_tlink(pCFileStruct->tlink);
 		kfree(file->private_data);
 		file->private_data = NULL;
 	}
@@ -770,7 +771,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 		cFYI(1, "Unknown type of lock");
 
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	tcon = ((struct cifsFileInfo *)file->private_data)->tcon;
+	tcon = tlink_tcon(((struct cifsFileInfo *)file->private_data)->tlink);
 
 	if (file->private_data == NULL) {
 		rc = -EBADF;
@@ -970,7 +971,7 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 		return -EBADF;
 
 	open_file = file->private_data;
-	pTcon = open_file->tcon;
+	pTcon = tlink_tcon(open_file->tlink);
 
 	rc = generic_write_checks(file, poffset, &write_size, 0);
 	if (rc)
@@ -1071,7 +1072,7 @@ static ssize_t cifs_write(struct file *file, const char *write_data,
 	if (file->private_data == NULL)
 		return -EBADF;
 	open_file = file->private_data;
-	pTcon = open_file->tcon;
+	pTcon = tlink_tcon(open_file->tlink);
 
 	xid = GetXid();
 
@@ -1393,7 +1394,7 @@ static int cifs_writepages(struct address_space *mapping,
 		return generic_writepages(mapping, wbc);
 	}
 
-	tcon = open_file->tcon;
+	tcon = tlink_tcon(open_file->tlink);
 	if (!experimEnabled && tcon->ses->server->secMode &
 			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
 		cifsFileInfo_put(open_file);
@@ -1664,7 +1665,7 @@ int cifs_fsync(struct file *file, int datasync)
 	if (rc == 0) {
 		rc = CIFS_I(inode)->write_behind_rc;
 		CIFS_I(inode)->write_behind_rc = 0;
-		tcon = smbfile->tcon;
+		tcon = tlink_tcon(smbfile->tlink);
 		if (!rc && tcon && smbfile &&
 		   !(CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
 			rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
@@ -1756,7 +1757,7 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 		return rc;
 	}
 	open_file = file->private_data;
-	pTcon = open_file->tcon;
+	pTcon = tlink_tcon(open_file->tlink);
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
@@ -1837,7 +1838,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 		return rc;
 	}
 	open_file = file->private_data;
-	pTcon = open_file->tcon;
+	pTcon = tlink_tcon(open_file->tlink);
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
@@ -1973,7 +1974,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	}
 	open_file = file->private_data;
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	pTcon = open_file->tcon;
+	pTcon = tlink_tcon(open_file->tlink);
 
 	/*
 	 * Reads as many pages as possible from fscache. Returns -ENOBUFS
@@ -2337,8 +2338,8 @@ void cifs_oplock_break(struct work_struct *work)
 	 * disconnected since oplock already released by the server
 	 */
 	if (!cfile->closePend && !cfile->oplock_break_cancelled) {
-		rc = CIFSSMBLock(0, cfile->tcon, cfile->netfid, 0, 0, 0, 0,
-				 LOCKING_ANDX_OPLOCK_RELEASE, false);
+		rc = CIFSSMBLock(0, tlink_tcon(cfile->tlink), cfile->netfid, 0,
+				 0, 0, 0, LOCKING_ANDX_OPLOCK_RELEASE, false);
 		cFYI(1, "Oplock release rc = %d", rc);
 	}
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index fc0ae26..c0bf0dc 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -289,7 +289,7 @@ int cifs_get_file_info_unix(struct file *filp)
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsFileInfo *cfile = filp->private_data;
-	struct cifsTconInfo *tcon = cfile->tcon;
+	struct cifsTconInfo *tcon = tlink_tcon(cfile->tlink);
 
 	xid = GetXid();
 	rc = CIFSSMBUnixQFileInfo(xid, tcon, cfile->netfid, &find_data);
@@ -540,7 +540,7 @@ int cifs_get_file_info(struct file *filp)
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsFileInfo *cfile = filp->private_data;
-	struct cifsTconInfo *tcon = cfile->tcon;
+	struct cifsTconInfo *tcon = tlink_tcon(cfile->tlink);
 
 	xid = GetXid();
 	rc = CIFSSMBQFileInfo(xid, tcon, cfile->netfid, &find_data);
@@ -959,7 +959,7 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, int xid,
 	if (open_file) {
 		netfid = open_file->netfid;
 		netpid = open_file->pid;
-		pTcon = open_file->tcon;
+		pTcon = tlink_tcon(open_file->tlink);
 		goto set_via_filehandle;
 	}
 
@@ -1688,7 +1688,7 @@ int cifs_revalidate_file(struct file *filp)
 	if (!cifs_inode_needs_reval(inode))
 		goto check_inval;
 
-	if (cfile->tcon->unix_ext)
+	if (tlink_tcon(cfile->tlink)->unix_ext)
 		rc = cifs_get_file_info_unix(filp);
 	else
 		rc = cifs_get_file_info(filp);
@@ -1809,7 +1809,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	if (open_file) {
 		__u16 nfid = open_file->netfid;
 		__u32 npid = open_file->pid;
-		pTcon = open_file->tcon;
+		pTcon = tlink_tcon(open_file->tlink);
 		rc = CIFSSMBSetFileSize(xid, pTcon, attrs->ia_size, nfid,
 					npid, false);
 		cifsFileInfo_put(open_file);
@@ -1974,7 +1974,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	if (open_file) {
 		u16 nfid = open_file->netfid;
 		u32 npid = open_file->pid;
-		pTcon = open_file->tcon;
+		pTcon = tlink_tcon(open_file->tlink);
 		rc = CIFSSMBUnixSetFileInfo(xid, pTcon, args, nfid, npid);
 		cifsFileInfo_put(open_file);
 	} else {
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index cc70a61..077bf75 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -38,7 +38,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	struct cifs_sb_info *cifs_sb;
 #ifdef CONFIG_CIFS_POSIX
 	struct cifsFileInfo *pSMBFile = filep->private_data;
-	struct cifsTconInfo *tcon = pSMBFile->tcon;
+	struct cifsTconInfo *tcon = tlink_tcon(pSMBFile->tlink);
 	__u64	ExtAttrBits = 0;
 	__u64	ExtAttrMask = 0;
 	__u64   caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 48de03c..696d213 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -56,7 +56,6 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 		goto cifs_hl_exit;
 	}
 
-/*	if (cifs_sb_target->tcon->ses->capabilities & CAP_UNIX)*/
 	if (pTcon->unix_ext)
 		rc = CIFSUnixCreateHardLink(xid, pTcon, fromName, toName,
 					    cifs_sb->local_nls,
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 42b11ef..573c5cb 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -246,7 +246,7 @@ static int initiate_cifs_search(const int xid, struct file *file)
 	cifsFile = file->private_data;
 	cifsFile->invalidHandle = true;
 	cifsFile->srch_inf.endOfSearch = false;
-	cifsFile->tcon = pTcon;
+	cifsFile->tlink = cifs_get_tlink(tlink);
 
 	full_path = build_path_from_dentry(file->f_path.dentry);
 	if (full_path == NULL) {
@@ -830,7 +830,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 			CIFSFindClose(xid, pTcon, cifsFile->netfid);
 		} */
 
-		pTcon = cifsFile->tcon;
+		pTcon = tlink_tcon(cifsFile->tlink);
 		rc = find_cifs_entry(xid, pTcon, file,
 				&current_entry, &num_to_fill);
 		if (rc) {
-- 
1.7.2.1

