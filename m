From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 6/7] CIFS: Turn lock mutex into rw semaphore
Date: Fri, 31 Aug 2012 13:41:27 +0400
Message-ID: <1346406088-4537-7-git-send-email-pshilovsky@etersoft.ru>
References: <1346406088-4537-1-git-send-email-pshilovsky@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346406088-4537-1-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and allow several processes to walk through the lock list and read
can_cache_brlcks value if they are not going to modify them.

Signed-off-by: Pavel Shilovsky <pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    2 +-
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/file.c     |   60 ++++++++++++++++++++++++++-------------------------
 fs/cifs/smb2file.c |   15 +++++++------
 4 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e958d94..4cd68c7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -937,7 +937,7 @@ cifs_init_once(void *inode)
 	struct cifsInodeInfo *cifsi = inode;
 
 	inode_init_once(&cifsi->vfs_inode);
-	mutex_init(&cifsi->lock_mutex);
+	init_rwsem(&cifsi->lock_sem);
 }
 
 static int
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d3c7271..e2492e1 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1000,7 +1000,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 struct cifsInodeInfo {
 	bool can_cache_brlcks;
 	struct list_head llist;	/* locks helb by this inode */
-	struct mutex lock_mutex;	/* protect the fields above */
+	struct rw_semaphore lock_sem;	/* protect the fields above */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index affa001..daeb817 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -260,9 +260,9 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	INIT_LIST_HEAD(&fdlocks->locks);
 	fdlocks->cfile = cfile;
 	cfile->llist = fdlocks;
-	mutex_lock(&cinode->lock_mutex);
+	down_write(&cinode->lock_sem);
 	list_add(&fdlocks->llist, &cinode->llist);
-	mutex_unlock(&cinode->lock_mutex);
+	up_write(&cinode->lock_sem);
 
 	cfile->count = 1;
 	cfile->pid = current->tgid;
@@ -351,7 +351,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	 * Delete any outstanding lock records. We'll lose them when the file
 	 * is closed anyway.
 	 */
-	mutex_lock(&cifsi->lock_mutex);
+	down_write(&cifsi->lock_sem);
 	list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, llist) {
 		list_del(&li->llist);
 		cifs_del_lock_waiters(li);
@@ -359,7 +359,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	}
 	list_del(&cifs_file->llist->llist);
 	kfree(cifs_file->llist);
-	mutex_unlock(&cifsi->lock_mutex);
+	up_write(&cifsi->lock_sem);
 
 	cifs_put_tlink(cifs_file->tlink);
 	dput(cifs_file->dentry);
@@ -762,7 +762,7 @@ cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
 	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
 	bool exist;
 
-	mutex_lock(&cinode->lock_mutex);
+	down_read(&cinode->lock_sem);
 
 	exist = cifs_find_lock_conflict(cfile, offset, length, type,
 					&conf_lock);
@@ -779,7 +779,7 @@ cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
 	else
 		flock->fl_type = F_UNLCK;
 
-	mutex_unlock(&cinode->lock_mutex);
+	up_read(&cinode->lock_sem);
 	return rc;
 }
 
@@ -787,9 +787,9 @@ static void
 cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
 {
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
-	mutex_lock(&cinode->lock_mutex);
+	down_write(&cinode->lock_sem);
 	list_add_tail(&lock->llist, &cfile->llist->locks);
-	mutex_unlock(&cinode->lock_mutex);
+	up_write(&cinode->lock_sem);
 }
 
 /*
@@ -809,13 +809,13 @@ cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *lock,
 
 try_again:
 	exist = false;
-	mutex_lock(&cinode->lock_mutex);
+	down_write(&cinode->lock_sem);
 
 	exist = cifs_find_lock_conflict(cfile, lock->offset, lock->length,
 					lock->type, &conf_lock);
 	if (!exist && cinode->can_cache_brlcks) {
 		list_add_tail(&lock->llist, &cfile->llist->locks);
-		mutex_unlock(&cinode->lock_mutex);
+		up_write(&cinode->lock_sem);
 		return rc;
 	}
 
@@ -825,17 +825,17 @@ try_again:
 		rc = -EACCES;
 	else {
 		list_add_tail(&lock->blist, &conf_lock->blist);
-		mutex_unlock(&cinode->lock_mutex);
+		up_write(&cinode->lock_sem);
 		rc = wait_event_interruptible(lock->block_q,
 					(lock->blist.prev == &lock->blist) &&
 					(lock->blist.next == &lock->blist));
 		if (!rc)
 			goto try_again;
-		mutex_lock(&cinode->lock_mutex);
+		down_write(&cinode->lock_sem);
 		list_del_init(&lock->blist);
 	}
 
-	mutex_unlock(&cinode->lock_mutex);
+	up_write(&cinode->lock_sem);
 	return rc;
 }
 
@@ -856,7 +856,7 @@ cifs_posix_lock_test(struct file *file, struct file_lock *flock)
 	if ((flock->fl_flags & FL_POSIX) == 0)
 		return 1;
 
-	mutex_lock(&cinode->lock_mutex);
+	down_read(&cinode->lock_sem);
 	posix_test_lock(file, flock);
 
 	if (flock->fl_type == F_UNLCK && !cinode->can_cache_brlcks) {
@@ -864,7 +864,7 @@ cifs_posix_lock_test(struct file *file, struct file_lock *flock)
 		rc = 1;
 	}
 
-	mutex_unlock(&cinode->lock_mutex);
+	up_read(&cinode->lock_sem);
 	return rc;
 }
 
@@ -884,14 +884,14 @@ cifs_posix_lock_set(struct file *file, struct file_lock *flock)
 		return rc;
 
 try_again:
-	mutex_lock(&cinode->lock_mutex);
+	down_write(&cinode->lock_sem);
 	if (!cinode->can_cache_brlcks) {
-		mutex_unlock(&cinode->lock_mutex);
+		up_write(&cinode->lock_sem);
 		return rc;
 	}
 
 	rc = posix_lock_file(file, flock, NULL);
-	mutex_unlock(&cinode->lock_mutex);
+	up_write(&cinode->lock_sem);
 	if (rc == FILE_LOCK_DEFERRED) {
 		rc = wait_event_interruptible(flock->fl_wait, !flock->fl_next);
 		if (!rc)
@@ -918,9 +918,10 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	xid = get_xid();
 	tcon = tlink_tcon(cfile->tlink);
 
-	mutex_lock(&cinode->lock_mutex);
+	/* we are going to update can_cache_brlcks here - need a write access */
+	down_write(&cinode->lock_sem);
 	if (!cinode->can_cache_brlcks) {
-		mutex_unlock(&cinode->lock_mutex);
+		up_write(&cinode->lock_sem);
 		free_xid(xid);
 		return rc;
 	}
@@ -931,7 +932,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	 */
 	max_buf = tcon->ses->server->maxBuf;
 	if (!max_buf) {
-		mutex_unlock(&cinode->lock_mutex);
+		up_write(&cinode->lock_sem);
 		free_xid(xid);
 		return -EINVAL;
 	}
@@ -940,7 +941,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 						sizeof(LOCKING_ANDX_RANGE);
 	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
 	if (!buf) {
-		mutex_unlock(&cinode->lock_mutex);
+		up_write(&cinode->lock_sem);
 		free_xid(xid);
 		return -ENOMEM;
 	}
@@ -978,7 +979,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	}
 
 	cinode->can_cache_brlcks = false;
-	mutex_unlock(&cinode->lock_mutex);
+	up_write(&cinode->lock_sem);
 
 	kfree(buf);
 	free_xid(xid);
@@ -1013,9 +1014,10 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 
 	xid = get_xid();
 
-	mutex_lock(&cinode->lock_mutex);
+	/* we are going to update can_cache_brlcks here - need a write access */
+	down_write(&cinode->lock_sem);
 	if (!cinode->can_cache_brlcks) {
-		mutex_unlock(&cinode->lock_mutex);
+		up_write(&cinode->lock_sem);
 		free_xid(xid);
 		return rc;
 	}
@@ -1031,7 +1033,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 
 	/*
 	 * Allocating count locks is enough because no FL_POSIX locks can be
-	 * added to the list while we are holding cinode->lock_mutex that
+	 * added to the list while we are holding cinode->lock_sem that
 	 * protects locking operations of this inode.
 	 */
 	for (; i < count; i++) {
@@ -1086,7 +1088,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 
 out:
 	cinode->can_cache_brlcks = false;
-	mutex_unlock(&cinode->lock_mutex);
+	up_write(&cinode->lock_sem);
 
 	free_xid(xid);
 	return rc;
@@ -1278,7 +1280,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 	if (!buf)
 		return -ENOMEM;
 
-	mutex_lock(&cinode->lock_mutex);
+	down_write(&cinode->lock_sem);
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
@@ -1348,7 +1350,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 		}
 	}
 
-	mutex_unlock(&cinode->lock_mutex);
+	up_write(&cinode->lock_sem);
 	kfree(buf);
 	return rc;
 }
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 181e13d..0ddd617 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -135,7 +135,7 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 
 	cur = buf;
 
-	mutex_lock(&cinode->lock_mutex);
+	down_write(&cinode->lock_sem);
 	list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
 		if (flock->fl_start > li->offset ||
 		    (flock->fl_start + length) <
@@ -196,7 +196,7 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 		} else
 			cifs_free_llist(&tmp_llist);
 	}
-	mutex_unlock(&cinode->lock_mutex);
+	up_write(&cinode->lock_sem);
 
 	kfree(buf);
 	return rc;
@@ -253,9 +253,10 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	struct cifs_fid_locks *fdlocks;
 
 	xid = get_xid();
-	mutex_lock(&cinode->lock_mutex);
+	/* we are going to update can_cache_brlcks here - need a write access */
+	down_write(&cinode->lock_sem);
 	if (!cinode->can_cache_brlcks) {
-		mutex_unlock(&cinode->lock_mutex);
+		up_write(&cinode->lock_sem);
 		free_xid(xid);
 		return rc;
 	}
@@ -266,7 +267,7 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	 */
 	max_buf = tlink_tcon(cfile->tlink)->ses->server->maxBuf;
 	if (!max_buf) {
-		mutex_unlock(&cinode->lock_mutex);
+		up_write(&cinode->lock_sem);
 		free_xid(xid);
 		return -EINVAL;
 	}
@@ -274,7 +275,7 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	max_num = max_buf / sizeof(struct smb2_lock_element);
 	buf = kzalloc(max_num * sizeof(struct smb2_lock_element), GFP_KERNEL);
 	if (!buf) {
-		mutex_unlock(&cinode->lock_mutex);
+		up_write(&cinode->lock_sem);
 		free_xid(xid);
 		return -ENOMEM;
 	}
@@ -288,7 +289,7 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	cinode->can_cache_brlcks = false;
 	kfree(buf);
 
-	mutex_unlock(&cinode->lock_mutex);
+	up_write(&cinode->lock_sem);
 	free_xid(xid);
 	return rc;
 }
-- 
1.7.1
