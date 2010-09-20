From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/15] cifs: make various routines use the cifsFileInfo->tcon pointer
Date: Mon, 20 Sep 2010 16:01:31 -0700
Message-ID: <1285023704-2159-3-git-send-email-jlayton@redhat.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285023704-2159-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...where it's available and appropriate.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c  |    4 ++--
 fs/cifs/file.c    |   39 ++++++++++++++++-----------------------
 fs/cifs/inode.c   |   22 ++++++++++++++++------
 fs/cifs/ioctl.c   |   17 +++--------------
 fs/cifs/readdir.c |   19 ++++++++-----------
 5 files changed, 45 insertions(+), 56 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a90b59b..3f2a373 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -591,6 +591,7 @@ static int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
 	/* note that this is called by vfs setlease with the BKL held
 	   although I doubt that BKL is needed here in cifs */
 	struct inode *inode = file->f_path.dentry->d_inode;
+	struct cifsFileInfo *cfile = file->private_data;
 
 	if (!(S_ISREG(inode->i_mode)))
 		return -EINVAL;
@@ -601,8 +602,7 @@ static int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
 	    ((arg == F_WRLCK) &&
 		(CIFS_I(inode)->clientCanCacheAll)))
 		return generic_setlease(file, arg, lease);
-	else if (CIFS_SB(inode->i_sb)->tcon->local_lease &&
-			!CIFS_I(inode)->clientCanCacheRead)
+	else if (cfile->tcon->local_lease && !CIFS_I(inode)->clientCanCacheRead)
 		/* If the server claims to support oplock on this
 		   file, then we still need to check oplock even
 		   if the local_lease mount option is set, but there
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 60061b9..84979fc 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -461,7 +461,7 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
 	}
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	tcon = cifs_sb->tcon;
+	tcon = pCifsFile->tcon;
 
 /* can not grab rename sem here because various ops, including
    those that already have the rename sem can end up causing writepage
@@ -575,7 +575,7 @@ int cifs_close(struct inode *inode, struct file *file)
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb->tcon;
+	pTcon = pSMBFile->tcon;
 	if (pSMBFile) {
 		struct cifsLockInfo *li, *tmp;
 		write_lock(&GlobalSMBSeslock);
@@ -653,11 +653,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 	xid = GetXid();
 
 	if (pCFileStruct) {
-		struct cifsTconInfo *pTcon;
-		struct cifs_sb_info *cifs_sb =
-			CIFS_SB(file->f_path.dentry->d_sb);
-
-		pTcon = cifs_sb->tcon;
+		struct cifsTconInfo *pTcon = pCFileStruct->tcon;
 
 		cFYI(1, "Freeing private data in close dir");
 		write_lock(&GlobalSMBSeslock);
@@ -767,7 +763,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 		cFYI(1, "Unknown type of lock");
 
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	tcon = cifs_sb->tcon;
+	tcon = ((struct cifsFileInfo *)file->private_data)->tcon;
 
 	if (file->private_data == NULL) {
 		rc = -EBADF;
@@ -960,14 +956,14 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 
-	pTcon = cifs_sb->tcon;
-
 	/* cFYI(1, " write %d bytes to offset %lld of %s", write_size,
 	   *poffset, file->f_path.dentry->d_name.name); */
 
 	if (file->private_data == NULL)
 		return -EBADF;
+
 	open_file = file->private_data;
+	pTcon = open_file->tcon;
 
 	rc = generic_write_checks(file, poffset, &write_size, 0);
 	if (rc)
@@ -1062,14 +1058,13 @@ static ssize_t cifs_write(struct file *file, const char *write_data,
 
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 
-	pTcon = cifs_sb->tcon;
-
 	cFYI(1, "write %zd bytes to offset %lld of %s", write_size,
 	   *poffset, file->f_path.dentry->d_name.name);
 
 	if (file->private_data == NULL)
 		return -EBADF;
 	open_file = file->private_data;
+	pTcon = open_file->tcon;
 
 	xid = GetXid();
 
@@ -1284,7 +1279,6 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	int rc = -EFAULT;
 	int bytes_written = 0;
 	struct cifs_sb_info *cifs_sb;
-	struct cifsTconInfo *pTcon;
 	struct inode *inode;
 	struct cifsFileInfo *open_file;
 
@@ -1293,7 +1287,6 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 
 	inode = page->mapping->host;
 	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb->tcon;
 
 	offset += (loff_t)from;
 	write_data = kmap(page);
@@ -1352,6 +1345,7 @@ static int cifs_writepages(struct address_space *mapping,
 	int nr_pages;
 	__u64 offset = 0;
 	struct cifsFileInfo *open_file;
+	struct cifsTconInfo *tcon;
 	struct cifsInodeInfo *cifsi = CIFS_I(mapping->host);
 	struct page *page;
 	struct pagevec pvec;
@@ -1501,8 +1495,9 @@ retry:
 				cERROR(1, "No writable handles for inode");
 				rc = -EBADF;
 			} else {
+				tcon = open_file->tcon;
 				long_op = cifs_write_timeout(cifsi, offset);
-				rc = CIFSSMBWrite2(xid, cifs_sb->tcon,
+				rc = CIFSSMBWrite2(xid, tcon,
 						   open_file->netfid,
 						   bytes_to_write, offset,
 						   &bytes_written, iov, n_iov,
@@ -1520,8 +1515,7 @@ retry:
 					else
 						set_bit(AS_EIO, &mapping->flags);
 				} else {
-					cifs_stats_bytes_written(cifs_sb->tcon,
-								 bytes_written);
+					cifs_stats_bytes_written(tcon, bytes_written);
 				}
 			}
 			for (i = 0; i < n_iov; i++) {
@@ -1665,7 +1659,7 @@ int cifs_fsync(struct file *file, int datasync)
 	if (rc == 0) {
 		rc = CIFS_I(inode)->write_behind_rc;
 		CIFS_I(inode)->write_behind_rc = 0;
-		tcon = CIFS_SB(inode->i_sb)->tcon;
+		tcon = smbfile->tcon;
 		if (!rc && tcon && smbfile &&
 		   !(CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
 			rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
@@ -1750,7 +1744,6 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 
 	xid = GetXid();
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	pTcon = cifs_sb->tcon;
 
 	if (file->private_data == NULL) {
 		rc = -EBADF;
@@ -1758,6 +1751,7 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 		return rc;
 	}
 	open_file = file->private_data;
+	pTcon = open_file->tcon;
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
@@ -1831,7 +1825,6 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 
 	xid = GetXid();
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	pTcon = cifs_sb->tcon;
 
 	if (file->private_data == NULL) {
 		rc = -EBADF;
@@ -1839,6 +1832,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 		return rc;
 	}
 	open_file = file->private_data;
+	pTcon = open_file->tcon;
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
@@ -1974,7 +1968,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	}
 	open_file = file->private_data;
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	pTcon = cifs_sb->tcon;
+	pTcon = open_file->tcon;
 
 	/*
 	 * Reads as many pages as possible from fscache. Returns -ENOBUFS
@@ -2312,7 +2306,6 @@ void cifs_oplock_break(struct work_struct *work)
 						  oplock_break);
 	struct inode *inode = cfile->pInode;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->mnt->mnt_sb);
 	int rc, waitrc = 0;
 
 	if (inode && S_ISREG(inode->i_mode)) {
@@ -2339,7 +2332,7 @@ void cifs_oplock_break(struct work_struct *work)
 	 * disconnected since oplock already released by the server
 	 */
 	if (!cfile->closePend && !cfile->oplock_break_cancelled) {
-		rc = CIFSSMBLock(0, cifs_sb->tcon, cfile->netfid, 0, 0, 0, 0,
+		rc = CIFSSMBLock(0, cfile->tcon, cfile->netfid, 0, 0, 0, 0,
 				 LOCKING_ANDX_OPLOCK_RELEASE, false);
 		cFYI(1, "Oplock release rc = %d", rc);
 	}
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 6e7ddd1..5b75865 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -288,8 +288,8 @@ int cifs_get_file_info_unix(struct file *filp)
 	struct cifs_fattr fattr;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsTconInfo *tcon = cifs_sb->tcon;
 	struct cifsFileInfo *cfile = filp->private_data;
+	struct cifsTconInfo *tcon = cfile->tcon;
 
 	xid = GetXid();
 	rc = CIFSSMBUnixQFileInfo(xid, tcon, cfile->netfid, &find_data);
@@ -523,8 +523,8 @@ int cifs_get_file_info(struct file *filp)
 	struct cifs_fattr fattr;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsTconInfo *tcon = cifs_sb->tcon;
 	struct cifsFileInfo *cfile = filp->private_data;
+	struct cifsTconInfo *tcon = cfile->tcon;
 
 	xid = GetXid();
 	rc = CIFSSMBQFileInfo(xid, tcon, cfile->netfid, &find_data);
@@ -897,7 +897,7 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, int xid,
 	struct cifsFileInfo *open_file;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsTconInfo *pTcon = cifs_sb->tcon;
+	struct cifsTconInfo *pTcon;
 	FILE_BASIC_INFO	info_buf;
 
 	if (attrs == NULL)
@@ -940,9 +940,12 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, int xid,
 	if (open_file) {
 		netfid = open_file->netfid;
 		netpid = open_file->pid;
+		pTcon = open_file->tcon;
 		goto set_via_filehandle;
 	}
 
+	pTcon = cifs_sb->tcon;
+
 	/*
 	 * NT4 apparently returns success on this call, but it doesn't
 	 * really work.
@@ -1617,11 +1620,12 @@ int cifs_revalidate_file(struct file *filp)
 {
 	int rc = 0;
 	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct cifsFileInfo *cfile = (struct cifsFileInfo *) filp->private_data;
 
 	if (!cifs_inode_needs_reval(inode))
 		goto check_inval;
 
-	if (CIFS_SB(inode->i_sb)->tcon->unix_ext)
+	if (cfile->tcon->unix_ext)
 		rc = cifs_get_file_info_unix(filp);
 	else
 		rc = cifs_get_file_info(filp);
@@ -1726,7 +1730,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	struct cifsFileInfo *open_file;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsTconInfo *pTcon = cifs_sb->tcon;
+	struct cifsTconInfo *pTcon = NULL;
 
 	/*
 	 * To avoid spurious oplock breaks from server, in the case of
@@ -1741,6 +1745,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	if (open_file) {
 		__u16 nfid = open_file->netfid;
 		__u32 npid = open_file->pid;
+		pTcon = open_file->tcon;
 		rc = CIFSSMBSetFileSize(xid, pTcon, attrs->ia_size, nfid,
 					npid, false);
 		cifsFileInfo_put(open_file);
@@ -1755,6 +1760,9 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 		rc = -EINVAL;
 
 	if (rc != 0) {
+		if (pTcon == NULL)
+			pTcon = cifs_sb->tcon;
+
 		/* Set file size by pathname rather than by handle
 		   either because no valid, writeable file handle for
 		   it was found or because there was an error setting
@@ -1804,7 +1812,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	struct inode *inode = direntry->d_inode;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsTconInfo *pTcon = cifs_sb->tcon;
+	struct cifsTconInfo *pTcon;
 	struct cifs_unix_set_info_args *args = NULL;
 	struct cifsFileInfo *open_file;
 
@@ -1895,9 +1903,11 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	if (open_file) {
 		u16 nfid = open_file->netfid;
 		u32 npid = open_file->pid;
+		pTcon = open_file->tcon;
 		rc = CIFSSMBUnixSetFileInfo(xid, pTcon, args, nfid, npid);
 		cifsFileInfo_put(open_file);
 	} else {
+		pTcon = cifs_sb->tcon;
 		rc = CIFSSMBUnixSetPathInfo(xid, pTcon, full_path, args,
 				    cifs_sb->local_nls,
 				    cifs_sb->mnt_cifs_flags &
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 9d38a71..cc70a61 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -37,11 +37,11 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	int xid;
 	struct cifs_sb_info *cifs_sb;
 #ifdef CONFIG_CIFS_POSIX
+	struct cifsFileInfo *pSMBFile = filep->private_data;
+	struct cifsTconInfo *tcon = pSMBFile->tcon;
 	__u64	ExtAttrBits = 0;
 	__u64	ExtAttrMask = 0;
-	__u64   caps;
-	struct cifsTconInfo *tcon;
-	struct cifsFileInfo *pSMBFile = filep->private_data;
+	__u64   caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
 #endif /* CONFIG_CIFS_POSIX */
 
 	xid = GetXid();
@@ -50,17 +50,6 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 
-#ifdef CONFIG_CIFS_POSIX
-	tcon = cifs_sb->tcon;
-	if (tcon)
-		caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
-	else {
-		rc = -EIO;
-		FreeXid(xid);
-		return -EIO;
-	}
-#endif /* CONFIG_CIFS_POSIX */
-
 	switch (command) {
 		case CIFS_IOC_CHECKUMOUNT:
 			cFYI(1, "User unmount attempted");
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index db3fc51..5490d5c 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -229,22 +229,21 @@ static int initiate_cifs_search(const int xid, struct file *file)
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
 
-	if (file->private_data == NULL) {
+	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	if (cifs_sb == NULL)
+		return -EINVAL;
+
+	if (file->private_data == NULL)
 		file->private_data =
 			kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
-	}
 
 	if (file->private_data == NULL)
 		return -ENOMEM;
 	cifsFile = file->private_data;
 	cifsFile->invalidHandle = true;
 	cifsFile->srch_inf.endOfSearch = false;
-
-	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	if (cifs_sb == NULL)
-		return -EINVAL;
-
-	pTcon = cifs_sb->tcon;
+	cifsFile->tcon = cifs_sb->tcon;
+	pTcon = cifsFile->tcon;
 	if (pTcon == NULL)
 		return -EINVAL;
 
@@ -787,9 +786,6 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	pTcon = cifs_sb->tcon;
-	if (pTcon == NULL)
-		return -EINVAL;
 
 	switch ((int) file->f_pos) {
 	case 0:
@@ -839,6 +835,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 			CIFSFindClose(xid, pTcon, cifsFile->netfid);
 		} */
 
+		pTcon = cifsFile->tcon;
 		rc = find_cifs_entry(xid, pTcon, file,
 				&current_entry, &num_to_fill);
 		if (rc) {
-- 
1.7.2.3
