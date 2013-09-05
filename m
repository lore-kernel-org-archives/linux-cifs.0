From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/8] CIFS: Replace clientCanCache* bools with an integer
Date: Fri,  6 Sep 2013 00:14:58 +0400
Message-ID: <1378412103-29047-4-git-send-email-pshilovsky@samba.org>
References: <1378412103-29047-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378412103-29047-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that prepare the code to handle different types of SMB2 leases.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsfs.c   |   33 +++++++++++++++++----------------
 fs/cifs/cifsglob.h |   10 ++++++++--
 fs/cifs/file.c     |   28 ++++++++++++++--------------
 fs/cifs/inode.c    |    8 ++++----
 fs/cifs/misc.c     |   12 ++++--------
 fs/cifs/smb1ops.c  |    4 ++--
 fs/cifs/smb2file.c |   20 ++++++++++----------
 fs/cifs/smb2misc.c |    6 +++---
 fs/cifs/smb2ops.c  |    4 ++--
 9 files changed, 64 insertions(+), 61 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d70e551f..ab88efe 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -733,7 +733,7 @@ static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
 
-	if (CIFS_I(inode)->clientCanCacheAll)
+	if (CIFS_CACHE_WRITE(CIFS_I(inode)))
 		return written;
 
 	rc = filemap_fdatawrite(inode->i_mapping);
@@ -758,7 +758,7 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int whence)
 		 * We need to be sure that all dirty pages are written and the
 		 * server has the newest file length.
 		 */
-		if (!CIFS_I(inode)->clientCanCacheRead && inode->i_mapping &&
+		if (!CIFS_CACHE_READ(CIFS_I(inode)) && inode->i_mapping &&
 		    inode->i_mapping->nrpages != 0) {
 			rc = filemap_fdatawait(inode->i_mapping);
 			if (rc) {
@@ -782,8 +782,10 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int whence)
 
 static int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
 {
-	/* note that this is called by vfs setlease with i_lock held
-	   to protect *lease from going away */
+	/*
+	 * Note that this is called by vfs setlease with i_lock held to
+	 * protect *lease from going away.
+	 */
 	struct inode *inode = file_inode(file);
 	struct cifsFileInfo *cfile = file->private_data;
 
@@ -791,20 +793,19 @@ static int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
 		return -EINVAL;
 
 	/* check if file is oplocked */
-	if (((arg == F_RDLCK) &&
-		(CIFS_I(inode)->clientCanCacheRead)) ||
-	    ((arg == F_WRLCK) &&
-		(CIFS_I(inode)->clientCanCacheAll)))
+	if (((arg == F_RDLCK) && CIFS_CACHE_READ(CIFS_I(inode))) ||
+	    ((arg == F_WRLCK) && CIFS_CACHE_WRITE(CIFS_I(inode))))
 		return generic_setlease(file, arg, lease);
 	else if (tlink_tcon(cfile->tlink)->local_lease &&
-		 !CIFS_I(inode)->clientCanCacheRead)
-		/* If the server claims to support oplock on this
-		   file, then we still need to check oplock even
-		   if the local_lease mount option is set, but there
-		   are servers which do not support oplock for which
-		   this mount option may be useful if the user
-		   knows that the file won't be changed on the server
-		   by anyone else */
+		 !CIFS_CACHE_READ(CIFS_I(inode)))
+		/*
+		 * If the server claims to support oplock on this file, then we
+		 * still need to check oplock even if the local_lease mount
+		 * option is set, but there are servers which do not support
+		 * oplock for which this mount option may be useful if the user
+		 * knows that the file won't be changed on the server by anyone
+		 * else.
+		 */
 		return generic_setlease(file, arg, lease);
 	else
 		return -EAGAIN;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ec6c3fb..30f91e1 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1035,6 +1035,13 @@ cifsFileInfo_get_locked(struct cifsFileInfo *cifs_file)
 struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file);
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 
+#define CIFS_CACHE_READ_FLG	1
+#define CIFS_CACHE_HANDLE_FLG	2
+#define CIFS_CACHE_WRITE_FLG	4
+
+#define CIFS_CACHE_READ(cinode) (cinode->oplock & CIFS_CACHE_READ_FLG)
+#define CIFS_CACHE_WRITE(cinode) (cinode->oplock & CIFS_CACHE_WRITE_FLG)
+
 /*
  * One of these for each file inode
  */
@@ -1046,8 +1053,7 @@ struct cifsInodeInfo {
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
-	bool clientCanCacheRead;	/* read oplock */
-	bool clientCanCacheAll;		/* read and writebehind oplock */
+	unsigned int oplock;		/* oplock/lease level we have */
 	bool delete_pending;		/* DELETE_ON_CLOSE is set */
 	bool invalid_mapping;		/* pagecache is invalid */
 	unsigned long time;		/* jiffies of last update of inode */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7e36ae3..d933539 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1524,12 +1524,12 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 		 * read won't conflict with non-overlapted locks due to
 		 * pagereading.
 		 */
-		if (!CIFS_I(inode)->clientCanCacheAll &&
-					CIFS_I(inode)->clientCanCacheRead) {
+		if (!CIFS_CACHE_WRITE(CIFS_I(inode)) &&
+					CIFS_CACHE_READ(CIFS_I(inode))) {
 			cifs_invalidate_mapping(inode);
 			cifs_dbg(FYI, "Set no oplock for inode=%p due to mand locks\n",
 				 inode);
-			CIFS_I(inode)->clientCanCacheRead = false;
+			CIFS_I(inode)->oplock = 0;
 		}
 
 		rc = server->ops->mand_lock(xid, cfile, flock->fl_start, length,
@@ -2213,7 +2213,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	cifs_dbg(FYI, "Sync file - name: %s datasync: 0x%x\n",
 		 file->f_path.dentry->d_name.name, datasync);
 
-	if (!CIFS_I(inode)->clientCanCacheRead) {
+	if (!CIFS_CACHE_READ(CIFS_I(inode))) {
 		rc = cifs_invalidate_mapping(inode);
 		if (rc) {
 			cifs_dbg(FYI, "rc: %d during invalidate phase\n", rc);
@@ -2577,7 +2577,7 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	ssize_t written;
 
-	if (cinode->clientCanCacheAll) {
+	if (CIFS_CACHE_WRITE(cinode)) {
 		if (cap_unix(tcon->ses) &&
 		(CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability))
 		    && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
@@ -2591,7 +2591,7 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 	 * these pages but not on the region from pos to ppos+len-1.
 	 */
 	written = cifs_user_writev(iocb, iov, nr_segs, pos);
-	if (written > 0 && cinode->clientCanCacheRead) {
+	if (written > 0 && CIFS_CACHE_READ(cinode)) {
 		/*
 		 * Windows 7 server can delay breaking level2 oplock if a write
 		 * request comes - break it on the client to prevent reading
@@ -2600,7 +2600,7 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 		cifs_invalidate_mapping(inode);
 		cifs_dbg(FYI, "Set no oplock for inode=%p after a write operation\n",
 			 inode);
-		cinode->clientCanCacheRead = false;
+		cinode->oplock = 0;
 	}
 	return written;
 }
@@ -2957,7 +2957,7 @@ cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
 	 * on pages affected by this read but not on the region from pos to
 	 * pos+len-1.
 	 */
-	if (!cinode->clientCanCacheRead)
+	if (!CIFS_CACHE_READ(cinode))
 		return cifs_user_readv(iocb, iov, nr_segs, pos);
 
 	if (cap_unix(tcon->ses) &&
@@ -3093,7 +3093,7 @@ int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
 
 	xid = get_xid();
 
-	if (!CIFS_I(inode)->clientCanCacheRead) {
+	if (!CIFS_CACHE_READ(CIFS_I(inode))) {
 		rc = cifs_invalidate_mapping(inode);
 		if (rc)
 			return rc;
@@ -3526,7 +3526,7 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
 	 * is, when the page lies beyond the EOF, or straddles the EOF
 	 * and the write will cover all of the existing data.
 	 */
-	if (CIFS_I(mapping->host)->clientCanCacheRead) {
+	if (CIFS_CACHE_READ(CIFS_I(mapping->host))) {
 		i_size = i_size_read(mapping->host);
 		if (page_start >= i_size ||
 		    (offset == 0 && (pos + len) >= i_size)) {
@@ -3609,20 +3609,20 @@ void cifs_oplock_break(struct work_struct *work)
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	int rc = 0;
 
-	if (!cinode->clientCanCacheAll && cinode->clientCanCacheRead &&
+	if (!CIFS_CACHE_WRITE(cinode) && CIFS_CACHE_READ(cinode) &&
 						cifs_has_mand_locks(cinode)) {
 		cifs_dbg(FYI, "Reset oplock to None for inode=%p due to mand locks\n",
 			 inode);
-		cinode->clientCanCacheRead = false;
+		cinode->oplock = 0;
 	}
 
 	if (inode && S_ISREG(inode->i_mode)) {
-		if (cinode->clientCanCacheRead)
+		if (CIFS_CACHE_READ(cinode))
 			break_lease(inode, O_RDONLY);
 		else
 			break_lease(inode, O_WRONLY);
 		rc = filemap_fdatawrite(inode->i_mapping);
-		if (cinode->clientCanCacheRead == 0) {
+		if (!CIFS_CACHE_READ(cinode)) {
 			rc = filemap_fdatawait(inode->i_mapping);
 			mapping_set_error(inode->i_mapping, rc);
 			cifs_invalidate_mapping(inode);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ec0f342..e3bb647 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -101,7 +101,7 @@ cifs_revalidate_cache(struct inode *inode, struct cifs_fattr *fattr)
 	}
 
 	/* don't bother with revalidation if we have an oplock */
-	if (cifs_i->clientCanCacheRead) {
+	if (CIFS_CACHE_READ(cifs_i)) {
 		cifs_dbg(FYI, "%s: inode %llu is oplocked\n",
 			 __func__, cifs_i->uniqueid);
 		return;
@@ -650,7 +650,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	cifs_dbg(FYI, "Getting info on %s\n", full_path);
 
 	if ((data == NULL) && (*inode != NULL)) {
-		if (CIFS_I(*inode)->clientCanCacheRead) {
+		if (CIFS_CACHE_READ(CIFS_I(*inode))) {
 			cifs_dbg(FYI, "No need to revalidate cached inode sizes\n");
 			goto cgii_exit;
 		}
@@ -1661,7 +1661,7 @@ cifs_inode_needs_reval(struct inode *inode)
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
-	if (cifs_i->clientCanCacheRead)
+	if (CIFS_CACHE_READ(cifs_i))
 		return false;
 
 	if (!lookupCacheEnabled)
@@ -1804,7 +1804,7 @@ int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	 * We need to be sure that all dirty pages are written and the server
 	 * has actual ctime, mtime and file length.
 	 */
-	if (!CIFS_I(inode)->clientCanCacheRead && inode->i_mapping &&
+	if (!CIFS_CACHE_READ(CIFS_I(inode)) && inode->i_mapping &&
 	    inode->i_mapping->nrpages != 0) {
 		rc = filemap_fdatawait(inode->i_mapping);
 		if (rc) {
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index f7d4b22..0d67d46 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -545,19 +545,15 @@ void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 	oplock &= 0xF;
 
 	if (oplock == OPLOCK_EXCLUSIVE) {
-		cinode->clientCanCacheAll = true;
-		cinode->clientCanCacheRead = true;
+		cinode->oplock = CIFS_CACHE_WRITE_FLG | CIFS_CACHE_READ_FLG;
 		cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
 			 &cinode->vfs_inode);
 	} else if (oplock == OPLOCK_READ) {
-		cinode->clientCanCacheAll = false;
-		cinode->clientCanCacheRead = true;
+		cinode->oplock = CIFS_CACHE_READ_FLG;
 		cifs_dbg(FYI, "Level II Oplock granted on inode %p\n",
 			 &cinode->vfs_inode);
-	} else {
-		cinode->clientCanCacheAll = false;
-		cinode->clientCanCacheRead = false;
-	}
+	} else
+		cinode->oplock = 0;
 }
 
 bool
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 8fe19c9..6fd0677 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -700,7 +700,7 @@ cifs_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	cfile->fid.netfid = fid->netfid;
 	cifs_set_oplock_level(cinode, oplock);
-	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
+	cinode->can_cache_brlcks = CIFS_CACHE_WRITE(cinode);
 }
 
 static void
@@ -837,7 +837,7 @@ cifs_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
 {
 	return CIFSSMBLock(0, tcon, fid->netfid, current->tgid, 0, 0, 0, 0,
 			   LOCKING_ANDX_OPLOCK_RELEASE, false,
-			   cinode->clientCanCacheRead ? 1 : 0);
+			   CIFS_CACHE_READ(cinode) ? 1 : 0);
 }
 
 static int
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 020245d..4564787 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -40,21 +40,21 @@ smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 	oplock &= 0xFF;
 	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
 		return;
-	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE ||
-	    oplock == SMB2_OPLOCK_LEVEL_BATCH) {
-		cinode->clientCanCacheAll = true;
-		cinode->clientCanCacheRead = true;
+	if (oplock == SMB2_OPLOCK_LEVEL_BATCH) {
+		cinode->oplock = CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG |
+				 CIFS_CACHE_HANDLE_FLG;
+		cifs_dbg(FYI, "Batch Oplock granted on inode %p\n",
+			 &cinode->vfs_inode);
+	} else if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
+		cinode->oplock = CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG;
 		cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
 			 &cinode->vfs_inode);
 	} else if (oplock == SMB2_OPLOCK_LEVEL_II) {
-		cinode->clientCanCacheAll = false;
-		cinode->clientCanCacheRead = true;
+		cinode->oplock = CIFS_CACHE_READ_FLG;
 		cifs_dbg(FYI, "Level II Oplock granted on inode %p\n",
 			 &cinode->vfs_inode);
-	} else {
-		cinode->clientCanCacheAll = false;
-		cinode->clientCanCacheRead = false;
-	}
+	} else
+		cinode->oplock = 0;
 }
 
 int
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 314bd60..8d1a889 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -380,9 +380,9 @@ cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
 __le32
 smb2_get_lease_state(struct cifsInodeInfo *cinode)
 {
-	if (cinode->clientCanCacheAll)
+	if (CIFS_CACHE_WRITE(cinode))
 		return SMB2_LEASE_WRITE_CACHING | SMB2_LEASE_READ_CACHING;
-	else if (cinode->clientCanCacheRead)
+	else if (CIFS_CACHE_READ(cinode))
 		return SMB2_LEASE_READ_CACHING;
 	return 0;
 }
@@ -576,7 +576,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 				cifs_dbg(FYI, "file id match, oplock break\n");
 				cinode = CIFS_I(cfile->dentry->d_inode);
 
-				if (!cinode->clientCanCacheAll &&
+				if (!CIFS_CACHE_WRITE(cinode) &&
 				    rsp->OplockLevel == SMB2_OPLOCK_LEVEL_NONE)
 					cfile->oplock_break_cancelled = true;
 				else
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 91b9e54..96c9d3d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -380,7 +380,7 @@ smb2_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
 	cfile->fid.persistent_fid = fid->persistent_fid;
 	cfile->fid.volatile_fid = fid->volatile_fid;
 	smb2_set_oplock_level(cinode, oplock);
-	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
+	cinode->can_cache_brlcks = CIFS_CACHE_WRITE(cinode);
 }
 
 static void
@@ -531,7 +531,7 @@ smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
 
 	return SMB2_oplock_break(0, tcon, fid->persistent_fid,
 				 fid->volatile_fid,
-				 cinode->clientCanCacheRead ? 1 : 0);
+				 CIFS_CACHE_READ(cinode) ? 1 : 0);
 }
 
 static int
-- 
1.7.10.4
