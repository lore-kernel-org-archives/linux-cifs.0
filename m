From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [v2 PATCH 1/4] CIFS: Implement caching mechanism for mandatory brlocks
Date: Sat, 22 Oct 2011 15:33:29 +0400
Message-ID: <1319283212-19024-2-git-send-email-piastry@etersoft.ru>
References: <1319283212-19024-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319283212-19024-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we have an oplock and negotiate mandatory locking style we handle
all brlock requests on the client.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 +
 fs/cifs/file.c     |  206 +++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 197 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d153d0b..8238aa1 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -496,6 +496,8 @@ extern struct cifs_tcon *cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb);
  */
 struct cifsLockInfo {
 	struct list_head llist;	/* pointer to next cifsLockInfo */
+	struct list_head blist; /* pointer to locks blocked on this */
+	wait_queue_head_t block_q;
 	__u64 offset;
 	__u64 length;
 	__u32 pid;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a3b545f..34cbbee 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -275,11 +275,14 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	spin_unlock(&cifs_file_list_lock);
 
 	cifs_set_oplock_level(pCifsInode, oplock);
+	pCifsInode->can_cache_brlcks = pCifsInode->clientCanCacheAll;
 
 	file->private_data = pCifsFile;
 	return pCifsFile;
 }
 
+static void cifs_del_lock_waiters(struct cifsLockInfo *lock);
+
 /*
  * Release a reference on the file private data. This may involve closing
  * the filehandle out on the server. Must be called without holding
@@ -335,6 +338,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 		if (li->netfid != cifs_file->netfid)
 			continue;
 		list_del(&li->llist);
+		cifs_del_lock_waiters(li);
 		kfree(li);
 	}
 	mutex_unlock(&cifsi->lock_mutex);
@@ -640,24 +644,182 @@ int cifs_closedir(struct inode *inode, struct file *file)
 	return rc;
 }
 
-static int store_file_lock(struct cifsInodeInfo *cinode, __u64 len,
-			   __u64 offset, __u8 type, __u16 netfid)
+static struct cifsLockInfo *
+cifs_lock_init(__u64 len, __u64 offset, __u8 type, __u16 netfid)
 {
 	struct cifsLockInfo *li =
 		kmalloc(sizeof(struct cifsLockInfo), GFP_KERNEL);
-	if (li == NULL)
-		return -ENOMEM;
+	if (!li)
+		return li;
 	li->netfid = netfid;
 	li->offset = offset;
 	li->length = len;
 	li->type = type;
 	li->pid = current->tgid;
+	INIT_LIST_HEAD(&li->blist);
+	init_waitqueue_head(&li->block_q);
+	return li;
+}
+
+static void
+cifs_del_lock_waiters(struct cifsLockInfo *lock)
+{
+	struct cifsLockInfo *li, *tmp;
+	list_for_each_entry_safe(li, tmp, &lock->blist, blist) {
+		list_del_init(&li->blist);
+		wake_up(&li->block_q);
+	}
+}
+
+static bool
+cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
+			__u64 length, __u8 type, __u16 netfid,
+			struct cifsLockInfo **conf_lock)
+{
+	struct cifsLockInfo *li, *tmp;
+
+	list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
+		if (offset + length <= li->offset ||
+		    offset >= li->offset + li->length)
+			continue;
+		else if ((type & LOCKING_ANDX_SHARED_LOCK) &&
+			 ((netfid == li->netfid && current->tgid == li->pid) ||
+			  type == li->type))
+			continue;
+		else {
+			*conf_lock = li;
+			return true;
+		}
+	}
+	return false;
+}
+
+static int
+cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
+	       __u8 type, __u16 netfid, struct file_lock *flock)
+{
+	int rc = 0;
+	struct cifsLockInfo *conf_lock;
+	bool exist;
+
+	mutex_lock(&cinode->lock_mutex);
+
+	exist = cifs_find_lock_conflict(cinode, offset, length, type, netfid,
+					&conf_lock);
+	if (exist) {
+		flock->fl_start = conf_lock->offset;
+		flock->fl_end = conf_lock->offset + conf_lock->length - 1;
+		flock->fl_pid = conf_lock->pid;
+		if (conf_lock->type & LOCKING_ANDX_SHARED_LOCK)
+			flock->fl_type = F_RDLCK;
+		else
+			flock->fl_type = F_WRLCK;
+	} else if (!cinode->can_cache_brlcks)
+		rc = 1;
+	else
+		flock->fl_type = F_UNLCK;
+
+	mutex_unlock(&cinode->lock_mutex);
+	return rc;
+}
+
+static int
+cifs_lock_add(struct cifsInodeInfo *cinode, __u64 len, __u64 offset,
+	      __u8 type, __u16 netfid)
+{
+	struct cifsLockInfo *li;
+
+	li = cifs_lock_init(len, offset, type, netfid);
+	if (!li)
+		return -ENOMEM;
+
 	mutex_lock(&cinode->lock_mutex);
 	list_add_tail(&li->llist, &cinode->llist);
 	mutex_unlock(&cinode->lock_mutex);
 	return 0;
 }
 
+static int
+cifs_lock_add_if(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
+		 __u8 type, __u16 netfid, bool wait)
+{
+	struct cifsLockInfo *lock, *conf_lock;
+	bool exist;
+	int rc = 0;
+
+	lock = cifs_lock_init(length, offset, type, netfid);
+	if (!lock)
+		return -ENOMEM;
+
+try_again:
+	exist = false;
+	mutex_lock(&cinode->lock_mutex);
+
+	exist = cifs_find_lock_conflict(cinode, offset, length, type, netfid,
+					&conf_lock);
+	if (!exist && cinode->can_cache_brlcks) {
+		list_add_tail(&lock->llist, &cinode->llist);
+		mutex_unlock(&cinode->lock_mutex);
+		return rc;
+	}
+
+	if (!exist)
+		rc = 1;
+	else if (!wait)
+		rc = -EACCES;
+	else {
+		list_add_tail(&lock->blist, &conf_lock->blist);
+		mutex_unlock(&cinode->lock_mutex);
+		rc = wait_event_interruptible(lock->block_q,
+					(lock->blist.prev == &lock->blist) &&
+					(lock->blist.next == &lock->blist));
+		if (!rc)
+			goto try_again;
+		else {
+			mutex_lock(&cinode->lock_mutex);
+			list_del_init(&lock->blist);
+			mutex_unlock(&cinode->lock_mutex);
+		}
+	}
+
+	kfree(lock);
+	mutex_unlock(&cinode->lock_mutex);
+	return rc;
+}
+
+static int
+cifs_push_locks(struct cifsFileInfo *cfile)
+{
+	int xid, rc = 0, stored_rc;
+	struct cifsLockInfo *li, *tmp;
+	struct cifs_tcon *tcon;
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
+
+	xid = GetXid();
+	tcon = tlink_tcon(cfile->tlink);
+
+	mutex_lock(&cinode->lock_mutex);
+	if (!cinode->can_cache_brlcks) {
+		mutex_unlock(&cinode->lock_mutex);
+		FreeXid(xid);
+		return rc;
+	}
+
+	list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
+		stored_rc = CIFSSMBLock(xid, tcon, cfile->netfid,
+					li->pid, li->length, li->offset,
+					0, 1, li->type, 0, 0);
+		if (stored_rc)
+			rc = stored_rc;
+	}
+
+	cinode->can_cache_brlcks = false;
+	mutex_unlock(&cinode->lock_mutex);
+
+	FreeXid(xid);
+	return rc;
+}
+
 static void
 cifs_read_flock(struct file_lock *flock, __u8 *type, int *lock, int *unlock,
 		bool *wait_flag)
@@ -708,6 +870,7 @@ cifs_getlk(struct cifsFileInfo *cfile, struct file_lock *flock, __u8 type,
 {
 	int rc = 0;
 	__u64 length = 1 + flock->fl_end - flock->fl_start;
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	__u16 netfid = cfile->netfid;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 
@@ -723,6 +886,11 @@ cifs_getlk(struct cifsFileInfo *cfile, struct file_lock *flock, __u8 type,
 		return rc;
 	}
 
+	rc = cifs_lock_test(cinode, flock->fl_start, length, type, netfid,
+			    flock);
+	if (!rc)
+		return rc;
+
 	/* BB we could chain these into one lock request BB */
 	rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
 			 flock->fl_start, 0, 1, type, 0, 0);
@@ -790,12 +958,19 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 	}
 
 	if (lock) {
+		rc = cifs_lock_add_if(cinode, flock->fl_start, length,
+				      type, netfid, wait_flag);
+		if (rc < 0)
+			return rc;
+		else if (!rc)
+			goto out;
+
 		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
-				 flock->fl_start, 0, lock, type, wait_flag, 0);
+				 flock->fl_start, 0, 1, type, wait_flag, 0);
 		if (rc == 0) {
 			/* For Windows locks we must store them. */
-			rc = store_file_lock(cinode, length, flock->fl_start,
-					     type, netfid);
+			rc = cifs_lock_add(cinode, length, flock->fl_start,
+					   type, netfid);
 		}
 	} else if (unlock) {
 		/*
@@ -816,14 +991,19 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 			if (cfile->netfid != li->netfid)
 				continue;
 
-			stored_rc = CIFSSMBLock(xid, tcon, netfid,
-						current->tgid, li->length,
-						li->offset, 1, 0, li->type,
-						0, 0);
+			if (!cinode->can_cache_brlcks)
+				stored_rc = CIFSSMBLock(xid, tcon, netfid,
+							current->tgid,
+							li->length, li->offset,
+							1, 0, li->type, 0, 0);
+			else
+				stored_rc = 0;
+
 			if (stored_rc)
 				rc = stored_rc;
 			else {
 				list_del(&li->llist);
+				cifs_del_lock_waiters(li);
 				kfree(li);
 			}
 		}
@@ -2404,6 +2584,10 @@ void cifs_oplock_break(struct work_struct *work)
 		cFYI(1, "Oplock flush inode %p rc %d", inode, rc);
 	}
 
+	rc = cifs_push_locks(cfile);
+	if (rc)
+		cERROR(1, "Push locks rc = %d", rc);
+
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using
 	 * a now incorrect file handle is not a data integrity issue but do
-- 
1.7.1
