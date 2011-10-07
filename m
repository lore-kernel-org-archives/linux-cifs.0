From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 1/6] CIFS: Simplify byte range locking code
Date: Fri,  7 Oct 2011 17:10:19 +0400
Message-ID: <1317993024-15003-2-git-send-email-piastry@etersoft.ru>
References: <1317993024-15003-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1317993024-15003-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Split cifs_lock into several functions and let CIFSSMBLock get pid
as an argument.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    1 +
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/cifssmb.c   |    4 +-
 fs/cifs/file.c      |  370 ++++++++++++++++++++++++++++-----------------------
 4 files changed, 205 insertions(+), 172 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 95dad9d..84b0dd1 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -487,6 +487,7 @@ struct cifsLockInfo {
 	struct list_head llist;	/* pointer to next cifsLockInfo */
 	__u64 offset;
 	__u64 length;
+	__u32 pid;
 	__u8 type;
 };
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 8df28e9..0d57080 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -360,7 +360,7 @@ extern int CIFSGetSrvInodeNumber(const int xid, struct cifs_tcon *tcon,
 			int remap_special_chars);
 
 extern int CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
-			const __u16 netfid, const __u64 len,
+			const __u16 netfid, const __u32 netpid, const __u64 len,
 			const __u64 offset, const __u32 numUnlock,
 			const __u32 numLock, const __u8 lockType,
 			const bool waitFlag, const __u8 oplock_level);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index aac37d9..b79d7fd 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1965,7 +1965,7 @@ CIFSSMBWrite2(const int xid, struct cifs_io_parms *io_parms,
 
 int
 CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
-	    const __u16 smb_file_id, const __u64 len,
+	    const __u16 smb_file_id, const __u32 netpid, const __u64 len,
 	    const __u64 offset, const __u32 numUnlock,
 	    const __u32 numLock, const __u8 lockType,
 	    const bool waitFlag, const __u8 oplock_level)
@@ -2001,7 +2001,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 	pSMB->Fid = smb_file_id; /* netfid stays le */
 
 	if ((numLock != 0) || (numUnlock != 0)) {
-		pSMB->Locks[0].Pid = cpu_to_le16(current->tgid);
+		pSMB->Locks[0].Pid = cpu_to_le16(netpid);
 		/* BB where to store pid high? */
 		pSMB->Locks[0].LengthLow = cpu_to_le32((u32)len);
 		pSMB->Locks[0].LengthHigh = cpu_to_le32((u32)(len>>32));
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9f41a10..90e1720 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -631,8 +631,8 @@ int cifs_closedir(struct inode *inode, struct file *file)
 	return rc;
 }
 
-static int store_file_lock(struct cifsFileInfo *fid, __u64 len,
-				__u64 offset, __u8 lockType)
+static int store_file_lock(struct cifsFileInfo *cfile, __u64 len,
+			   __u64 offset, __u8 type, __u16 netfid)
 {
 	struct cifsLockInfo *li =
 		kmalloc(sizeof(struct cifsLockInfo), GFP_KERNEL);
@@ -640,210 +640,241 @@ static int store_file_lock(struct cifsFileInfo *fid, __u64 len,
 		return -ENOMEM;
 	li->offset = offset;
 	li->length = len;
-	li->type = lockType;
-	mutex_lock(&fid->lock_mutex);
-	list_add(&li->llist, &fid->llist);
-	mutex_unlock(&fid->lock_mutex);
+	li->type = type;
+	li->pid = current->tgid;
+	mutex_lock(&cfile->lock_mutex);
+	list_add_tail(&li->llist, &cfile->llist);
+	mutex_unlock(&cfile->lock_mutex);
 	return 0;
 }
 
-int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
+static void
+cifs_read_flock(struct file_lock *flock, __u8 *type, int *lock, int *unlock,
+		bool *wait_flag)
 {
-	int rc, xid;
-	__u32 numLock = 0;
-	__u32 numUnlock = 0;
-	__u64 length;
-	bool wait_flag = false;
-	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *tcon;
-	__u16 netfid;
-	__u8 lockType = LOCKING_ANDX_LARGE_FILES;
-	bool posix_locking = 0;
-
-	length = 1 + pfLock->fl_end - pfLock->fl_start;
-	rc = -EACCES;
-	xid = GetXid();
-
-	cFYI(1, "Lock parm: 0x%x flockflags: "
-		 "0x%x flocktype: 0x%x start: %lld end: %lld",
-		cmd, pfLock->fl_flags, pfLock->fl_type, pfLock->fl_start,
-		pfLock->fl_end);
-
-	if (pfLock->fl_flags & FL_POSIX)
+	if (flock->fl_flags & FL_POSIX)
 		cFYI(1, "Posix");
-	if (pfLock->fl_flags & FL_FLOCK)
+	if (flock->fl_flags & FL_FLOCK)
 		cFYI(1, "Flock");
-	if (pfLock->fl_flags & FL_SLEEP) {
+	if (flock->fl_flags & FL_SLEEP) {
 		cFYI(1, "Blocking lock");
-		wait_flag = true;
+		*wait_flag = true;
 	}
-	if (pfLock->fl_flags & FL_ACCESS)
+	if (flock->fl_flags & FL_ACCESS)
 		cFYI(1, "Process suspended by mandatory locking - "
-			 "not implemented yet");
-	if (pfLock->fl_flags & FL_LEASE)
+			"not implemented yet");
+	if (flock->fl_flags & FL_LEASE)
 		cFYI(1, "Lease on file - not implemented yet");
-	if (pfLock->fl_flags &
+	if (flock->fl_flags &
 	    (~(FL_POSIX | FL_FLOCK | FL_SLEEP | FL_ACCESS | FL_LEASE)))
-		cFYI(1, "Unknown lock flags 0x%x", pfLock->fl_flags);
+		cFYI(1, "Unknown lock flags 0x%x", flock->fl_flags);
 
-	if (pfLock->fl_type == F_WRLCK) {
+	*type = LOCKING_ANDX_LARGE_FILES;
+	if (flock->fl_type == F_WRLCK) {
 		cFYI(1, "F_WRLCK ");
-		numLock = 1;
-	} else if (pfLock->fl_type == F_UNLCK) {
+		*lock = 1;
+	} else if (flock->fl_type == F_UNLCK) {
 		cFYI(1, "F_UNLCK");
-		numUnlock = 1;
-		/* Check if unlock includes more than
-		one lock range */
-	} else if (pfLock->fl_type == F_RDLCK) {
+		*unlock = 1;
+		/* Check if unlock includes more than one lock range */
+	} else if (flock->fl_type == F_RDLCK) {
 		cFYI(1, "F_RDLCK");
-		lockType |= LOCKING_ANDX_SHARED_LOCK;
-		numLock = 1;
-	} else if (pfLock->fl_type == F_EXLCK) {
+		*type |= LOCKING_ANDX_SHARED_LOCK;
+		*lock = 1;
+	} else if (flock->fl_type == F_EXLCK) {
 		cFYI(1, "F_EXLCK");
-		numLock = 1;
-	} else if (pfLock->fl_type == F_SHLCK) {
+		*lock = 1;
+	} else if (flock->fl_type == F_SHLCK) {
 		cFYI(1, "F_SHLCK");
-		lockType |= LOCKING_ANDX_SHARED_LOCK;
-		numLock = 1;
+		*type |= LOCKING_ANDX_SHARED_LOCK;
+		*lock = 1;
 	} else
 		cFYI(1, "Unknown type of lock");
+}
 
-	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	tcon = tlink_tcon(((struct cifsFileInfo *)file->private_data)->tlink);
-	netfid = ((struct cifsFileInfo *)file->private_data)->netfid;
-
-	if ((tcon->ses->capabilities & CAP_UNIX) &&
-	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
-		posix_locking = 1;
-	/* BB add code here to normalize offset and length to
-	account for negative length which we can not accept over the
-	wire */
-	if (IS_GETLK(cmd)) {
-		if (posix_locking) {
-			int posix_lock_type;
-			if (lockType & LOCKING_ANDX_SHARED_LOCK)
-				posix_lock_type = CIFS_RDLCK;
-			else
-				posix_lock_type = CIFS_WRLCK;
-			rc = CIFSSMBPosixLock(xid, tcon, netfid, 1 /* get */,
-					length, pfLock, posix_lock_type,
-					wait_flag);
-			FreeXid(xid);
-			return rc;
-		}
-
-		/* BB we could chain these into one lock request BB */
-		rc = CIFSSMBLock(xid, tcon, netfid, length, pfLock->fl_start,
-				 0, 1, lockType, 0 /* wait flag */, 0);
-		if (rc == 0) {
-			rc = CIFSSMBLock(xid, tcon, netfid, length,
-					 pfLock->fl_start, 1 /* numUnlock */ ,
-					 0 /* numLock */ , lockType,
-					 0 /* wait flag */, 0);
-			pfLock->fl_type = F_UNLCK;
-			if (rc != 0)
-				cERROR(1, "Error unlocking previously locked "
-					   "range %d during test of lock", rc);
-			rc = 0;
-
-		} else {
-			/* if rc == ERR_SHARING_VIOLATION ? */
-			rc = 0;
+static int
+cifs_getlk(struct cifsFileInfo *cfile, struct file_lock *flock, __u8 type,
+	   bool wait_flag, bool posix_lck, int xid)
+{
+	int rc = 0;
+	__u64 length = 1 + flock->fl_end - flock->fl_start;
+	__u16 netfid = cfile->netfid;
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 
-			if (lockType & LOCKING_ANDX_SHARED_LOCK) {
-				pfLock->fl_type = F_WRLCK;
-			} else {
-				rc = CIFSSMBLock(xid, tcon, netfid, length,
-					pfLock->fl_start, 0, 1,
-					lockType | LOCKING_ANDX_SHARED_LOCK,
-					0 /* wait flag */, 0);
-				if (rc == 0) {
-					rc = CIFSSMBLock(xid, tcon, netfid,
-						length, pfLock->fl_start, 1, 0,
-						lockType |
-						LOCKING_ANDX_SHARED_LOCK,
-						0 /* wait flag */, 0);
-					pfLock->fl_type = F_RDLCK;
-					if (rc != 0)
-						cERROR(1, "Error unlocking "
-						"previously locked range %d "
-						"during test of lock", rc);
-					rc = 0;
-				} else {
-					pfLock->fl_type = F_WRLCK;
-					rc = 0;
-				}
-			}
-		}
+	if (posix_lck) {
+		int posix_lock_type;
+		if (type & LOCKING_ANDX_SHARED_LOCK)
+			posix_lock_type = CIFS_RDLCK;
+		else
+			posix_lock_type = CIFS_WRLCK;
+		rc = CIFSSMBPosixLock(xid, tcon, netfid, 1 /* get */,
+				      length, flock, posix_lock_type,
+				      wait_flag);
+		return rc;
+	}
 
-		FreeXid(xid);
+	/* BB we could chain these into one lock request BB */
+	rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
+			 flock->fl_start, 0, 1, type, 0, 0);
+	if (rc == 0) {
+		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid,
+				 length, flock->fl_start, 1, 0,
+				 type, 0, 0);
+		flock->fl_type = F_UNLCK;
+		if (rc != 0)
+			cERROR(1, "Error unlocking previously locked "
+				   "range %d during test of lock", rc);
+		rc = 0;
 		return rc;
 	}
 
-	if (!numLock && !numUnlock) {
-		/* if no lock or unlock then nothing
-		to do since we do not know what it is */
-		FreeXid(xid);
-		return -EOPNOTSUPP;
+	if (type & LOCKING_ANDX_SHARED_LOCK) {
+		flock->fl_type = F_WRLCK;
+		rc = 0;
+		return rc;
 	}
 
-	if (posix_locking) {
+	rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
+			 flock->fl_start, 0, 1,
+			 type | LOCKING_ANDX_SHARED_LOCK, 0, 0);
+	if (rc == 0) {
+		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid,
+				 length, flock->fl_start, 1, 0,
+				 type | LOCKING_ANDX_SHARED_LOCK,
+				 0, 0);
+		flock->fl_type = F_RDLCK;
+		if (rc != 0)
+			cERROR(1, "Error unlocking previously locked "
+				  "range %d during test of lock", rc);
+	} else
+		flock->fl_type = F_WRLCK;
+
+	rc = 0;
+	return rc;
+}
+
+static int
+cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
+	   bool wait_flag, bool posix_lck, int lock, int unlock, int xid)
+{
+	int rc = 0;
+	__u64 length = 1 + flock->fl_end - flock->fl_start;
+	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+	__u16 netfid = cfile->netfid;
+
+	if (posix_lck) {
 		int posix_lock_type;
-		if (lockType & LOCKING_ANDX_SHARED_LOCK)
+		if (type & LOCKING_ANDX_SHARED_LOCK)
 			posix_lock_type = CIFS_RDLCK;
 		else
 			posix_lock_type = CIFS_WRLCK;
 
-		if (numUnlock == 1)
+		if (unlock == 1)
 			posix_lock_type = CIFS_UNLCK;
 
-		rc = CIFSSMBPosixLock(xid, tcon, netfid, 0 /* set */,
-				      length, pfLock, posix_lock_type,
-				      wait_flag);
-	} else {
-		struct cifsFileInfo *fid = file->private_data;
-
-		if (numLock) {
-			rc = CIFSSMBLock(xid, tcon, netfid, length,
-					 pfLock->fl_start, 0, numLock, lockType,
-					 wait_flag, 0);
-
-			if (rc == 0) {
-				/* For Windows locks we must store them. */
-				rc = store_file_lock(fid, length,
-						pfLock->fl_start, lockType);
-			}
-		} else if (numUnlock) {
-			/* For each stored lock that this unlock overlaps
-			   completely, unlock it. */
-			int stored_rc = 0;
-			struct cifsLockInfo *li, *tmp;
+		rc = CIFSSMBPosixLock(xid, tcon, netfid, 0 /* set */, length,
+				      flock, posix_lock_type, wait_flag);
+		goto out;
+	}
 
-			rc = 0;
-			mutex_lock(&fid->lock_mutex);
-			list_for_each_entry_safe(li, tmp, &fid->llist, llist) {
-				if (pfLock->fl_start <= li->offset &&
-						(pfLock->fl_start + length) >=
-						(li->offset + li->length)) {
-					stored_rc = CIFSSMBLock(xid, tcon,
-							netfid, li->length,
-							li->offset, 1, 0,
-							li->type, false, 0);
-					if (stored_rc)
-						rc = stored_rc;
-					else {
-						list_del(&li->llist);
-						kfree(li);
-					}
-				}
+	if (lock) {
+		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
+				 flock->fl_start, 0, lock, type, wait_flag, 0);
+		if (rc == 0) {
+			/* For Windows locks we must store them. */
+			rc = store_file_lock(cfile, length, flock->fl_start,
+					     type, netfid);
+		}
+	} else if (unlock) {
+		/*
+		 * For each stored lock that this unlock overlaps completely,
+		 * unlock it.
+		 */
+		int stored_rc = 0;
+		struct cifsLockInfo *li, *tmp;
+
+		mutex_lock(&cfile->lock_mutex);
+		list_for_each_entry_safe(li, tmp, &cfile->llist, llist) {
+			if (flock->fl_start > li->offset ||
+			    (flock->fl_start + length) <
+			    (li->offset + li->length))
+				continue;
+			if (current->tgid != li->pid)
+				continue;
+
+			stored_rc = CIFSSMBLock(xid, tcon, netfid,
+						current->tgid, li->length,
+						li->offset, 1, 0, li->type,
+						0, 0);
+			if (stored_rc)
+				rc = stored_rc;
+			else {
+				list_del(&li->llist);
+				kfree(li);
 			}
-			mutex_unlock(&fid->lock_mutex);
 		}
+		mutex_unlock(&cfile->lock_mutex);
+	}
+out:
+	if (flock->fl_flags & FL_POSIX)
+		posix_lock_file_wait(file, flock);
+	return rc;
+}
+
+int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
+{
+	int rc, xid;
+	int lock = 0, unlock = 0;
+	bool wait_flag = false;
+	bool posix_lck = false;
+	struct cifs_sb_info *cifs_sb;
+	struct cifs_tcon *tcon;
+	struct cifsInodeInfo *cinode;
+	struct cifsFileInfo *cfile;
+	__u16 netfid;
+	__u8 type;
+
+	rc = -EACCES;
+	xid = GetXid();
+
+	cFYI(1, "Lock parm: 0x%x flockflags: 0x%x flocktype: 0x%x start: %lld "
+		"end: %lld", cmd, flock->fl_flags, flock->fl_type,
+		flock->fl_start, flock->fl_end);
+
+	cifs_read_flock(flock, &type, &lock, &unlock, &wait_flag);
+
+	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	cfile = (struct cifsFileInfo *)file->private_data;
+	tcon = tlink_tcon(cfile->tlink);
+	netfid = cfile->netfid;
+	cinode = CIFS_I(file->f_path.dentry->d_inode);
+
+	if ((tcon->ses->capabilities & CAP_UNIX) &&
+	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
+	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+		posix_lck = true;
+	/*
+	 * BB add code here to normalize offset and length to account for
+	 * negative length which we can not accept over the wire.
+	 */
+	if (IS_GETLK(cmd)) {
+		rc = cifs_getlk(cfile, flock, type, wait_flag, posix_lck, xid);
+		FreeXid(xid);
+		return rc;
+	}
+
+	if (!lock && !unlock) {
+		/*
+		 * if no lock or unlock then nothing to do since we do not
+		 * know what it is
+		 */
+		FreeXid(xid);
+		return -EOPNOTSUPP;
 	}
 
-	if (pfLock->fl_flags & FL_POSIX)
-		posix_lock_file_wait(file, pfLock);
+	rc = cifs_setlk(file, flock, type, wait_flag, posix_lck, lock, unlock,
+			xid);
 	FreeXid(xid);
 	return rc;
 }
@@ -2415,8 +2446,9 @@ void cifs_oplock_break(struct work_struct *work)
 	 * disconnected since oplock already released by the server
 	 */
 	if (!cfile->oplock_break_cancelled) {
-		rc = CIFSSMBLock(0, tlink_tcon(cfile->tlink), cfile->netfid, 0,
-				 0, 0, 0, LOCKING_ANDX_OPLOCK_RELEASE, false,
+		rc = CIFSSMBLock(0, tlink_tcon(cfile->tlink), cfile->netfid,
+				 current->tgid, 0, 0, 0, 0,
+				 LOCKING_ANDX_OPLOCK_RELEASE, false,
 				 cinode->clientCanCacheRead ? 1 : 0);
 		cFYI(1, "Oplock release rc = %d", rc);
 	}
-- 
1.7.1
