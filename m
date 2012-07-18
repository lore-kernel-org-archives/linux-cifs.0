From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 10/45] CIFS: Replace netfid with cifs_fid struct in cifsFileInfo
Date: Wed, 18 Jul 2012 19:48:26 +0400
Message-ID: <1342626541-29872-11-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is help us to extend the code for future protocols that can use
another fid mechanism (as SMB2 that has it divided into two parts:
persistent and violatile).

Also rename variables and refactor the code around the changes.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsacl.c  |    2 +-
 fs/cifs/cifsglob.h |    6 ++-
 fs/cifs/cifssmb.c  |    4 +-
 fs/cifs/file.c     |  116 ++++++++++++++++++++++++++--------------------------
 fs/cifs/inode.c    |   10 ++--
 fs/cifs/ioctl.c    |   13 ++++--
 fs/cifs/misc.c     |    2 +-
 fs/cifs/readdir.c  |   10 ++--
 fs/cifs/smb1ops.c  |    2 +-
 9 files changed, 87 insertions(+), 78 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index f8c8464..d98a7c3 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1222,7 +1222,7 @@ struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
 	if (!open_file)
 		return get_cifs_acl_by_path(cifs_sb, path, pacllen);
 
-	pntsd = get_cifs_acl_by_fid(cifs_sb, open_file->netfid, pacllen);
+	pntsd = get_cifs_acl_by_fid(cifs_sb, open_file->fid.netfid, pacllen);
 	cifsFileInfo_put(open_file);
 	return pntsd;
 }
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bd53d97..01ee8d2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -746,6 +746,10 @@ struct cifs_search_info {
 	bool smallBuf:1; /* so we know which buf_release function to call */
 };
 
+struct cifs_fid {
+	__u16 netfid;
+};
+
 struct cifsFileInfo {
 	struct list_head tlist;	/* pointer to next fid owned by tcon */
 	struct list_head flist;	/* next fid (file instance) for this inode */
@@ -755,7 +759,7 @@ struct cifsFileInfo {
 				 */
 	unsigned int uid;	/* allows finding which FileInfo structure */
 	__u32 pid;		/* process id who opened file */
-	__u16 netfid;		/* file id from remote */
+	struct cifs_fid fid;	/* file id from remote */
 	/* BB add lock scope info here if needed */ ;
 	/* lock scope id (0 if none) */
 	struct dentry *dentry;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 395f3e2..2936875 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1627,7 +1627,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	smb->hdr.PidHigh = cpu_to_le16((__u16)(rdata->pid >> 16));
 
 	smb->AndXCommand = 0xFF;	/* none */
-	smb->Fid = rdata->cfile->netfid;
+	smb->Fid = rdata->cfile->fid.netfid;
 	smb->OffsetLow = cpu_to_le32(rdata->offset & 0xFFFFFFFF);
 	if (wct == 12)
 		smb->OffsetHigh = cpu_to_le32(rdata->offset >> 32);
@@ -2079,7 +2079,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	smb->hdr.PidHigh = cpu_to_le16((__u16)(wdata->pid >> 16));
 
 	smb->AndXCommand = 0xFF;	/* none */
-	smb->Fid = wdata->cfile->netfid;
+	smb->Fid = wdata->cfile->fid.netfid;
 	smb->OffsetLow = cpu_to_le32(wdata->offset & 0xFFFFFFFF);
 	if (wct == 14)
 		smb->OffsetHigh = cpu_to_le32(wdata->offset >> 32);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1712794..f542574 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -247,39 +247,39 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	struct cifsInodeInfo *pCifsInode = CIFS_I(inode);
-	struct cifsFileInfo *pCifsFile;
-
-	pCifsFile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
-	if (pCifsFile == NULL)
-		return pCifsFile;
-
-	pCifsFile->count = 1;
-	pCifsFile->netfid = fileHandle;
-	pCifsFile->pid = current->tgid;
-	pCifsFile->uid = current_fsuid();
-	pCifsFile->dentry = dget(dentry);
-	pCifsFile->f_flags = file->f_flags;
-	pCifsFile->invalidHandle = false;
-	pCifsFile->tlink = cifs_get_tlink(tlink);
-	mutex_init(&pCifsFile->fh_mutex);
-	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
-	INIT_LIST_HEAD(&pCifsFile->llist);
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	struct cifsFileInfo *cfile;
+
+	cfile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
+	if (cfile == NULL)
+		return cfile;
+
+	cfile->count = 1;
+	cfile->fid.netfid = fileHandle;
+	cfile->pid = current->tgid;
+	cfile->uid = current_fsuid();
+	cfile->dentry = dget(dentry);
+	cfile->f_flags = file->f_flags;
+	cfile->invalidHandle = false;
+	cfile->tlink = cifs_get_tlink(tlink);
+	mutex_init(&cfile->fh_mutex);
+	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
+	INIT_LIST_HEAD(&cfile->llist);
 
 	spin_lock(&cifs_file_list_lock);
-	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
+	list_add(&cfile->tlist, &(tlink_tcon(tlink)->openFileList));
 	/* if readable file instance put first in list*/
 	if (file->f_mode & FMODE_READ)
-		list_add(&pCifsFile->flist, &pCifsInode->openFileList);
+		list_add(&cfile->flist, &cinode->openFileList);
 	else
-		list_add_tail(&pCifsFile->flist, &pCifsInode->openFileList);
+		list_add_tail(&cfile->flist, &cinode->openFileList);
 	spin_unlock(&cifs_file_list_lock);
 
-	cifs_set_oplock_level(pCifsInode, oplock);
-	pCifsInode->can_cache_brlcks = pCifsInode->clientCanCacheAll;
+	cifs_set_oplock_level(cinode, oplock);
+	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
 
-	file->private_data = pCifsFile;
-	return pCifsFile;
+	file->private_data = cfile;
+	return cfile;
 }
 
 static void cifs_del_lock_waiters(struct cifsLockInfo *lock);
@@ -327,7 +327,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 		unsigned int xid;
 		int rc;
 		xid = get_xid();
-		rc = CIFSSMBClose(xid, tcon, cifs_file->netfid);
+		rc = CIFSSMBClose(xid, tcon, cifs_file->fid.netfid);
 		free_xid(xid);
 	}
 
@@ -552,7 +552,7 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
 	}
 
 reopen_success:
-	pCifsFile->netfid = netfid;
+	pCifsFile->fid.netfid = netfid;
 	pCifsFile->invalidHandle = false;
 	mutex_unlock(&pCifsFile->fh_mutex);
 	pCifsInode = CIFS_I(inode);
@@ -600,39 +600,37 @@ int cifs_closedir(struct inode *inode, struct file *file)
 {
 	int rc = 0;
 	unsigned int xid;
-	struct cifsFileInfo *pCFileStruct = file->private_data;
-	char *ptmp;
+	struct cifsFileInfo *cfile = file->private_data;
+	char *tmp;
 
 	cFYI(1, "Closedir inode = 0x%p", inode);
 
 	xid = get_xid();
 
-	if (pCFileStruct) {
-		struct cifs_tcon *pTcon = tlink_tcon(pCFileStruct->tlink);
+	if (cfile) {
+		struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 
 		cFYI(1, "Freeing private data in close dir");
 		spin_lock(&cifs_file_list_lock);
-		if (!pCFileStruct->srch_inf.endOfSearch &&
-		    !pCFileStruct->invalidHandle) {
-			pCFileStruct->invalidHandle = true;
+		if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
+			cfile->invalidHandle = true;
 			spin_unlock(&cifs_file_list_lock);
-			rc = CIFSFindClose(xid, pTcon, pCFileStruct->netfid);
-			cFYI(1, "Closing uncompleted readdir with rc %d",
-				 rc);
+			rc = CIFSFindClose(xid, tcon, cfile->fid.netfid);
+			cFYI(1, "Closing uncompleted readdir with rc %d", rc);
 			/* not much we can do if it fails anyway, ignore rc */
 			rc = 0;
 		} else
 			spin_unlock(&cifs_file_list_lock);
-		ptmp = pCFileStruct->srch_inf.ntwrk_buf_start;
-		if (ptmp) {
+		tmp = cfile->srch_inf.ntwrk_buf_start;
+		if (tmp) {
 			cFYI(1, "closedir free smb buf in srch struct");
-			pCFileStruct->srch_inf.ntwrk_buf_start = NULL;
-			if (pCFileStruct->srch_inf.smallBuf)
-				cifs_small_buf_release(ptmp);
+			cfile->srch_inf.ntwrk_buf_start = NULL;
+			if (cfile->srch_inf.smallBuf)
+				cifs_small_buf_release(tmp);
 			else
-				cifs_buf_release(ptmp);
+				cifs_buf_release(tmp);
 		}
-		cifs_put_tlink(pCFileStruct->tlink);
+		cifs_put_tlink(cfile->tlink);
 		kfree(file->private_data);
 		file->private_data = NULL;
 	}
@@ -923,7 +921,8 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 			cur->OffsetLow = cpu_to_le32((u32)li->offset);
 			cur->OffsetHigh = cpu_to_le32((u32)(li->offset>>32));
 			if (++num == max_num) {
-				stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
+				stored_rc = cifs_lockv(xid, tcon,
+						       cfile->fid.netfid,
 						       (__u8)li->type, 0, num,
 						       buf);
 				if (stored_rc)
@@ -935,7 +934,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 		}
 
 		if (num) {
-			stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
+			stored_rc = cifs_lockv(xid, tcon, cfile->fid.netfid,
 					       (__u8)types[i], 0, num, buf);
 			if (stored_rc)
 				rc = stored_rc;
@@ -1029,7 +1028,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 			type = CIFS_WRLCK;
 		lck = list_entry(el, struct lock_to_push, llist);
 		lck->pid = flock->fl_pid;
-		lck->netfid = cfile->netfid;
+		lck->netfid = cfile->fid.netfid;
 		lck->length = length;
 		lck->type = type;
 		lck->offset = flock->fl_start;
@@ -1130,7 +1129,7 @@ static int
 cifs_mandatory_lock(unsigned int xid, struct cifsFileInfo *cfile, __u64 offset,
 		    __u64 length, __u32 type, int lock, int unlock, bool wait)
 {
-	return CIFSSMBLock(xid, tlink_tcon(cfile->tlink), cfile->netfid,
+	return CIFSSMBLock(xid, tlink_tcon(cfile->tlink), cfile->fid.netfid,
 			   current->tgid, length, offset, unlock, lock,
 			   (__u8)type, wait, 0);
 }
@@ -1144,7 +1143,7 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
-	__u16 netfid = cfile->netfid;
+	__u16 netfid = cfile->fid.netfid;
 
 	if (posix_lck) {
 		int posix_lock_type;
@@ -1288,7 +1287,8 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 			 */
 			list_move(&li->llist, &tmp_llist);
 			if (++num == max_num) {
-				stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
+				stored_rc = cifs_lockv(xid, tcon,
+						       cfile->fid.netfid,
 						       li->type, num, 0, buf);
 				if (stored_rc) {
 					/*
@@ -1311,7 +1311,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 				cur++;
 		}
 		if (num) {
-			stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
+			stored_rc = cifs_lockv(xid, tcon, cfile->fid.netfid,
 					       types[i], num, 0, buf);
 			if (stored_rc) {
 				cifs_move_llist(&tmp_llist, &cfile->llist);
@@ -1336,7 +1336,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
-	__u16 netfid = cfile->netfid;
+	__u16 netfid = cfile->fid.netfid;
 
 	if (posix_lck) {
 		int posix_lock_type;
@@ -1416,7 +1416,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 			tcon->ses->server);
 
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	netfid = cfile->netfid;
+	netfid = cfile->fid.netfid;
 	cinode = CIFS_I(file->f_path.dentry->d_inode);
 
 	if (cap_unix(tcon->ses) &&
@@ -1507,7 +1507,7 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
 			/* iov[0] is reserved for smb header */
 			iov[1].iov_base = (char *)write_data + total_written;
 			iov[1].iov_len = len;
-			io_parms.netfid = open_file->netfid;
+			io_parms.netfid = open_file->fid.netfid;
 			io_parms.pid = pid;
 			io_parms.tcon = pTcon;
 			io_parms.offset = *poffset;
@@ -2071,7 +2071,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 
 	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
-		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
+		rc = CIFSSMBFlush(xid, tcon, smbfile->fid.netfid);
 
 	free_xid(xid);
 	mutex_unlock(&inode->i_mutex);
@@ -2099,7 +2099,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 
 	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
-		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
+		rc = CIFSSMBFlush(xid, tcon, smbfile->fid.netfid);
 
 	free_xid(xid);
 	mutex_unlock(&inode->i_mutex);
@@ -2795,7 +2795,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 				if (rc != 0)
 					break;
 			}
-			io_parms.netfid = open_file->netfid;
+			io_parms.netfid = open_file->fid.netfid;
 			io_parms.pid = pid;
 			io_parms.tcon = tcon;
 			io_parms.offset = *poffset;
@@ -3369,7 +3369,7 @@ void cifs_oplock_break(struct work_struct *work)
 	 * disconnected since oplock already released by the server
 	 */
 	if (!cfile->oplock_break_cancelled) {
-		rc = CIFSSMBLock(0, tlink_tcon(cfile->tlink), cfile->netfid,
+		rc = CIFSSMBLock(0, tlink_tcon(cfile->tlink), cfile->fid.netfid,
 				 current->tgid, 0, 0, 0, 0,
 				 LOCKING_ANDX_OPLOCK_RELEASE, false,
 				 cinode->clientCanCacheRead ? 1 : 0);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 9685eb1..1eeb6a0 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -298,7 +298,7 @@ int cifs_get_file_info_unix(struct file *filp)
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 
 	xid = get_xid();
-	rc = CIFSSMBUnixQFileInfo(xid, tcon, cfile->netfid, &find_data);
+	rc = CIFSSMBUnixQFileInfo(xid, tcon, cfile->fid.netfid, &find_data);
 	if (!rc) {
 		cifs_unix_basic_to_fattr(&fattr, &find_data, cifs_sb);
 	} else if (rc == -EREMOTE) {
@@ -566,7 +566,7 @@ int cifs_get_file_info(struct file *filp)
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 
 	xid = get_xid();
-	rc = CIFSSMBQFileInfo(xid, tcon, cfile->netfid, &find_data);
+	rc = CIFSSMBQFileInfo(xid, tcon, cfile->fid.netfid, &find_data);
 	switch (rc) {
 	case 0:
 		cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false);
@@ -932,7 +932,7 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
 	 */
 	open_file = find_writable_file(cifsInode, true);
 	if (open_file) {
-		netfid = open_file->netfid;
+		netfid = open_file->fid.netfid;
 		netpid = open_file->pid;
 		pTcon = tlink_tcon(open_file->tlink);
 		goto set_via_filehandle;
@@ -1887,7 +1887,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	 */
 	open_file = find_writable_file(cifsInode, true);
 	if (open_file) {
-		__u16 nfid = open_file->netfid;
+		__u16 nfid = open_file->fid.netfid;
 		__u32 npid = open_file->pid;
 		pTcon = tlink_tcon(open_file->tlink);
 		rc = CIFSSMBSetFileSize(xid, pTcon, attrs->ia_size, nfid,
@@ -2061,7 +2061,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	args->device = 0;
 	open_file = find_writable_file(cifsInode, true);
 	if (open_file) {
-		u16 nfid = open_file->netfid;
+		u16 nfid = open_file->fid.netfid;
 		u32 npid = open_file->pid;
 		pTcon = tlink_tcon(open_file->tlink);
 		rc = CIFSSMBUnixSetFileInfo(xid, pTcon, args, nfid, npid);
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index ae082a6..5b3481b 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -75,8 +75,9 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			tcon = tlink_tcon(pSMBFile->tlink);
 			caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
 			if (CIFS_UNIX_EXTATTR_CAP & caps) {
-				rc = CIFSGetExtAttr(xid, tcon, pSMBFile->netfid,
-					&ExtAttrBits, &ExtAttrMask);
+				rc = CIFSGetExtAttr(xid, tcon,
+						    pSMBFile->fid.netfid,
+						    &ExtAttrBits, &ExtAttrMask);
 				if (rc == 0)
 					rc = put_user(ExtAttrBits &
 						FS_FL_USER_VISIBLE,
@@ -94,8 +95,12 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 					rc = -EFAULT;
 					break;
 				}
-				/* rc= CIFSGetExtAttr(xid,tcon,pSMBFile->netfid,
-					extAttrBits, &ExtAttrMask);*/
+				/*
+				 * rc = CIFSGetExtAttr(xid, tcon,
+				 *		       pSMBFile->fid.netfid,
+				 *		       extAttrBits,
+				 *		       &ExtAttrMask);
+				 */
 			}
 			cFYI(1, "set flags not implemented yet");
 			break;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index ce41fee..a921b07 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -466,7 +466,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 			list_for_each(tmp2, &tcon->openFileList) {
 				netfile = list_entry(tmp2, struct cifsFileInfo,
 						     tlist);
-				if (pSMB->Fid != netfile->netfid)
+				if (pSMB->Fid != netfile->fid.netfid)
 					continue;
 
 				cFYI(1, "file id match, oplock break");
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index d87f826..9e76e3b 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -279,7 +279,7 @@ ffirst_retry:
 		search_flags |= CIFS_SEARCH_BACKUP_SEARCH;
 
 	rc = CIFSFindFirst(xid, tcon, full_path, cifs_sb->local_nls,
-		&cifsFile->netfid, search_flags, &cifsFile->srch_inf,
+		&cifsFile->fid.netfid, search_flags, &cifsFile->srch_inf,
 		cifs_sb->mnt_cifs_flags &
 			CIFS_MOUNT_MAP_SPECIAL_CHR, CIFS_DIR_SEP(cifs_sb));
 	if (rc == 0)
@@ -545,7 +545,7 @@ static int find_cifs_entry(const unsigned int xid, struct cifs_tcon *pTcon,
 		    !cifsFile->invalidHandle) {
 			cifsFile->invalidHandle = true;
 			spin_unlock(&cifs_file_list_lock);
-			CIFSFindClose(xid, pTcon, cifsFile->netfid);
+			CIFSFindClose(xid, pTcon, cifsFile->fid.netfid);
 		} else
 			spin_unlock(&cifs_file_list_lock);
 		if (cifsFile->srch_inf.ntwrk_buf_start) {
@@ -577,8 +577,8 @@ static int find_cifs_entry(const unsigned int xid, struct cifs_tcon *pTcon,
 	while ((index_to_find >= cifsFile->srch_inf.index_of_last_entry) &&
 	      (rc == 0) && !cifsFile->srch_inf.endOfSearch) {
 		cFYI(1, "calling findnext2");
-		rc = CIFSFindNext(xid, pTcon, cifsFile->netfid, search_flags,
-				  &cifsFile->srch_inf);
+		rc = CIFSFindNext(xid, pTcon, cifsFile->fid.netfid,
+				  search_flags, &cifsFile->srch_inf);
 		/* FindFirst/Next set last_entry to NULL on malformed reply */
 		if (cifsFile->srch_inf.last_entry)
 			cifs_save_resume_key(cifsFile->srch_inf.last_entry,
@@ -781,7 +781,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 			}
 		} /* else {
 			cifsFile->invalidHandle = true;
-			CIFSFindClose(xid, pTcon, cifsFile->netfid);
+			CIFSFindClose(xid, pTcon, cifsFile->fid.netfid);
 		} */
 
 		pTcon = tlink_tcon(cifsFile->tlink);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 725fa61..b170da0 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -63,7 +63,7 @@ send_nt_cancel(struct TCP_Server_Info *server, void *buf,
 static bool
 cifs_compare_fids(struct cifsFileInfo *ob1, struct cifsFileInfo *ob2)
 {
-	return ob1->netfid == ob2->netfid;
+	return ob1->fid.netfid == ob2->fid.netfid;
 }
 
 static unsigned int
-- 
1.7.1
