From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 4/6] CIFS: Implement caching mechanism for posix brlocks
Date: Fri,  7 Oct 2011 17:10:22 +0400
Message-ID: <1317993024-15003-5-git-send-email-piastry@etersoft.ru>
References: <1317993024-15003-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1317993024-15003-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to handle all lock requests on the client in an exclusive oplock case.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsproto.h |    4 +-
 fs/cifs/cifssmb.c   |    8 ++--
 fs/cifs/file.c      |  150 +++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 147 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 0d57080..276def2 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -365,8 +365,8 @@ extern int CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 			const __u32 numLock, const __u8 lockType,
 			const bool waitFlag, const __u8 oplock_level);
 extern int CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
-			const __u16 smb_file_id, const int get_flag,
-			const __u64 len, struct file_lock *,
+			const __u16 smb_file_id, const __u32 netpid,
+			const int get_flag, const __u64 len, struct file_lock *,
 			const __u16 lock_type, const bool waitFlag);
 extern int CIFSSMBTDis(const int xid, struct cifs_tcon *tcon);
 extern int CIFSSMBEcho(struct TCP_Server_Info *server);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index b79d7fd..43b1843 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2035,9 +2035,9 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 
 int
 CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
-		const __u16 smb_file_id, const int get_flag, const __u64 len,
-		struct file_lock *pLockData, const __u16 lock_type,
-		const bool waitFlag)
+		const __u16 smb_file_id, const __u32 netpid, const int get_flag,
+		const __u64 len, struct file_lock *pLockData,
+		const __u16 lock_type, const bool waitFlag)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
 	struct smb_com_transaction2_sfi_rsp *pSMBr = NULL;
@@ -2095,7 +2095,7 @@ CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
 	} else
 		pSMB->Timeout = 0;
 
-	parm_data->pid = cpu_to_le32(current->tgid);
+	parm_data->pid = cpu_to_le32(netpid);
 	parm_data->start = cpu_to_le64(pLockData->fl_start);
 	parm_data->length = cpu_to_le64(len);  /* normalize negative numbers */
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8c13cd4..888227f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -778,7 +778,42 @@ try_again:
 }
 
 static int
-cifs_push_locks(struct cifsFileInfo *cfile)
+cifs_posix_lock_test(struct file *file, struct file_lock *flock)
+{
+	int rc = 0;
+	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
+	unsigned char saved_type = flock->fl_type;
+
+	mutex_lock(&cinode->lock_mutex);
+	posix_test_lock(file, flock);
+
+	if (flock->fl_type == F_UNLCK && !cinode->can_cache_brlcks) {
+		flock->fl_type = saved_type;
+		rc = 1;
+	}
+
+	mutex_unlock(&cinode->lock_mutex);
+	return rc;
+}
+
+static int
+cifs_posix_lock_set(struct file *file, struct file_lock *flock)
+{
+	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
+	int rc;
+
+	mutex_lock(&cinode->lock_mutex);
+	if (!cinode->can_cache_brlcks) {
+		mutex_unlock(&cinode->lock_mutex);
+		return 1;
+	}
+	rc = posix_lock_file_wait(file, flock);
+	mutex_unlock(&cinode->lock_mutex);
+	return rc;
+}
+
+static int
+cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 {
 	int xid, rc = 0, stored_rc;
 	struct cifsLockInfo *li, *tmp;
@@ -810,6 +845,91 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 	return rc;
 }
 
+/* copied from fs/locks.c with a name change */
+#define cifs_for_each_lock(inode, lockp) \
+	for (lockp = &inode->i_flock; *lockp != NULL; \
+	     lockp = &(*lockp)->fl_next)
+
+static int
+cifs_push_posix_locks(struct cifsFileInfo *cfile)
+{
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+	struct file_lock *flock, **before;
+	struct cifsLockInfo *lck, *tmp;
+	int rc = 0, xid, type;
+	__u64 length;
+	struct list_head locks_to_send;
+
+	xid = GetXid();
+
+	mutex_lock(&cinode->lock_mutex);
+	if (!cinode->can_cache_brlcks) {
+		mutex_unlock(&cinode->lock_mutex);
+		FreeXid(xid);
+		return rc;
+	}
+
+	INIT_LIST_HEAD(&locks_to_send);
+
+	lock_flocks();
+	cifs_for_each_lock(cfile->dentry->d_inode, before) {
+		flock = *before;
+		length = 1 + flock->fl_end - flock->fl_start;
+		if (flock->fl_type == F_RDLCK || flock->fl_type == F_SHLCK)
+			type = CIFS_RDLCK;
+		else
+			type = CIFS_WRLCK;
+
+		lck = cifs_lock_init(length, flock->fl_start, type,
+				     cfile->netfid);
+		if (!lck) {
+			rc = -ENOMEM;
+			goto send_locks;
+		}
+		lck->pid = flock->fl_pid;
+
+		list_add_tail(&lck->llist, &locks_to_send);
+	}
+
+send_locks:
+	unlock_flocks();
+
+	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
+		struct file_lock tmp_lock;
+		int stored_rc;
+
+		tmp_lock.fl_start = lck->offset;
+		stored_rc = CIFSSMBPosixLock(xid, tcon, lck->netfid, lck->pid,
+					     0, lck->length, &tmp_lock,
+					     lck->type, 0);
+		if (stored_rc)
+			rc = stored_rc;
+		list_del(&lck->llist);
+		kfree(lck);
+	}
+
+	cinode->can_cache_brlcks = false;
+	mutex_unlock(&cinode->lock_mutex);
+
+	FreeXid(xid);
+	return rc;
+}
+
+static int
+cifs_push_locks(struct cifsFileInfo *cfile)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+
+	if ((tcon->ses->capabilities & CAP_UNIX) &&
+	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
+	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+		return cifs_push_posix_locks(cfile);
+
+	return cifs_push_mandatory_locks(cfile);
+}
+
 static void
 cifs_read_flock(struct file_lock *flock, __u8 *type, int *lock, int *unlock,
 		bool *wait_flag)
@@ -855,24 +975,30 @@ cifs_read_flock(struct file_lock *flock, __u8 *type, int *lock, int *unlock,
 }
 
 static int
-cifs_getlk(struct cifsFileInfo *cfile, struct file_lock *flock, __u8 type,
+cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
 	   bool wait_flag, bool posix_lck, int xid)
 {
 	int rc = 0;
 	__u64 length = 1 + flock->fl_end - flock->fl_start;
+	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	__u16 netfid = cfile->netfid;
-	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 
 	if (posix_lck) {
 		int posix_lock_type;
+
+		rc = cifs_posix_lock_test(file, flock);
+		if (!rc)
+			return rc;
+
 		if (type & LOCKING_ANDX_SHARED_LOCK)
 			posix_lock_type = CIFS_RDLCK;
 		else
 			posix_lock_type = CIFS_WRLCK;
-		rc = CIFSSMBPosixLock(xid, tcon, netfid, 1 /* get */,
-				      length, flock, posix_lock_type,
-				      wait_flag);
+		rc = CIFSSMBPosixLock(xid, tcon, netfid, current->tgid,
+				      1 /* get */, length, flock,
+				      posix_lock_type, wait_flag);
 		return rc;
 	}
 
@@ -934,6 +1060,11 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 
 	if (posix_lck) {
 		int posix_lock_type;
+
+		rc = cifs_posix_lock_set(file, flock);
+		if (!rc || rc < 0)
+			return rc;
+
 		if (type & LOCKING_ANDX_SHARED_LOCK)
 			posix_lock_type = CIFS_RDLCK;
 		else
@@ -942,8 +1073,9 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 		if (unlock == 1)
 			posix_lock_type = CIFS_UNLCK;
 
-		rc = CIFSSMBPosixLock(xid, tcon, netfid, 0 /* set */, length,
-				      flock, posix_lock_type, wait_flag);
+		rc = CIFSSMBPosixLock(xid, tcon, netfid, current->tgid,
+				      0 /* set */, length, flock,
+				      posix_lock_type, wait_flag);
 		goto out;
 	}
 
@@ -1042,7 +1174,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	 * negative length which we can not accept over the wire.
 	 */
 	if (IS_GETLK(cmd)) {
-		rc = cifs_getlk(cfile, flock, type, wait_flag, posix_lck, xid);
+		rc = cifs_getlk(file, flock, type, wait_flag, posix_lck, xid);
 		FreeXid(xid);
 		return rc;
 	}
-- 
1.7.1
