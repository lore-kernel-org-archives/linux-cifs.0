From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/7] CIFS: Remove spinlock dependence in brlock processing
Date: Fri, 31 Aug 2012 13:41:22 +0400
Message-ID: <1346406088-4537-2-git-send-email-pshilovsky@etersoft.ru>
References: <1346406088-4537-1-git-send-email-pshilovsky@etersoft.ru>
Cc: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346406088-4537-1-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Now we need to lock/unlock a spinlock while processing brlock ops
on the inode. Move brlocks of a fid to a separate list and attach
all such lists to the inode. This let us not hold a spinlock.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    1 +
 fs/cifs/cifsglob.h |   18 ++++++------
 fs/cifs/file.c     |   73 ++++++++++++++++++++++++++++++---------------------
 3 files changed, 53 insertions(+), 39 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 3a3e2fe..e958d94 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -233,6 +233,7 @@ cifs_alloc_inode(struct super_block *sb)
 	   to zero by the VFS */
 /*	cifs_inode->vfs_inode.i_flags = S_NOATIME | S_NOCMTIME;*/
 	INIT_LIST_HEAD(&cifs_inode->openFileList);
+	INIT_LIST_HEAD(&cifs_inode->llist);
 	return &cifs_inode->vfs_inode;
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 004672f..b2eb577 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -890,13 +890,16 @@ struct cifs_fid {
 #endif
 };
 
+struct cifs_fid_locks {
+	struct list_head llist;
+	struct cifsFileInfo *cfile;	/* fid that owns locks */
+	struct list_head locks;		/* locks held by fid above */
+};
+
 struct cifsFileInfo {
 	struct list_head tlist;	/* pointer to next fid owned by tcon */
 	struct list_head flist;	/* next fid (file instance) for this inode */
-	struct list_head llist;	/*
-				 * brlocks held by this fid, protected by
-				 * lock_mutex from cifsInodeInfo structure
-				 */
+	struct cifs_fid_locks *llist;	/* brlocks held by this fid */
 	unsigned int uid;	/* allows finding which FileInfo structure */
 	__u32 pid;		/* process id who opened file */
 	struct cifs_fid fid;	/* file id from remote */
@@ -988,11 +991,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 
 struct cifsInodeInfo {
 	bool can_cache_brlcks;
-	struct mutex lock_mutex;	/*
-					 * protect the field above and llist
-					 * from every cifsFileInfo structure
-					 * from openFileList
-					 */
+	struct list_head llist;	/* locks helb by this inode */
+	struct mutex lock_mutex;	/* protect the fields above */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d9dacca..6787b7f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -245,11 +245,25 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	struct inode *inode = dentry->d_inode;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifsFileInfo *cfile;
+	struct cifs_fid_locks *fdlocks;
 
 	cfile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
 	if (cfile == NULL)
 		return cfile;
 
+	fdlocks = kzalloc(sizeof(struct cifs_fid_locks), GFP_KERNEL);
+	if (!fdlocks) {
+		kfree(cfile);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&fdlocks->locks);
+	fdlocks->cfile = cfile;
+	cfile->llist = fdlocks;
+	mutex_lock(&cinode->lock_mutex);
+	list_add(&fdlocks->llist, &cinode->llist);
+	mutex_unlock(&cinode->lock_mutex);
+
 	cfile->count = 1;
 	cfile->pid = current->tgid;
 	cfile->uid = current_fsuid();
@@ -257,9 +271,8 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	cfile->f_flags = file->f_flags;
 	cfile->invalidHandle = false;
 	cfile->tlink = cifs_get_tlink(tlink);
-	mutex_init(&cfile->fh_mutex);
 	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
-	INIT_LIST_HEAD(&cfile->llist);
+	mutex_init(&cfile->fh_mutex);
 	tlink_tcon(tlink)->ses->server->ops->set_fid(cfile, fid, oplock);
 
 	spin_lock(&cifs_file_list_lock);
@@ -336,15 +349,18 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 		free_xid(xid);
 	}
 
-	/* Delete any outstanding lock records. We'll lose them when the file
+	/*
+	 * Delete any outstanding lock records. We'll lose them when the file
 	 * is closed anyway.
 	 */
 	mutex_lock(&cifsi->lock_mutex);
-	list_for_each_entry_safe(li, tmp, &cifs_file->llist, llist) {
+	list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, llist) {
 		list_del(&li->llist);
 		cifs_del_lock_waiters(li);
 		kfree(li);
 	}
+	list_del(&cifs_file->llist->llist);
+	kfree(cifs_file->llist);
 	mutex_unlock(&cifsi->lock_mutex);
 
 	cifs_put_tlink(cifs_file->tlink);
@@ -691,25 +707,24 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
 }
 
 static bool
-cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
-			    __u64 length, __u8 type, struct cifsFileInfo *cur,
+cifs_find_fid_lock_conflict(struct cifs_fid_locks *fdlocks, __u64 offset,
+			    __u64 length, __u8 type, struct cifsFileInfo *cfile,
 			    struct cifsLockInfo **conf_lock)
 {
 	struct cifsLockInfo *li;
+	struct cifsFileInfo *cur_cfile = fdlocks->cfile;
 	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
 
-	list_for_each_entry(li, &cfile->llist, llist) {
+	list_for_each_entry(li, &fdlocks->locks, llist) {
 		if (offset + length <= li->offset ||
 		    offset >= li->offset + li->length)
 			continue;
-		else if ((type & server->vals->shared_lock_type) &&
-			 ((server->ops->compare_fids(cur, cfile) &&
-			   current->tgid == li->pid) || type == li->type))
+		if ((type & server->vals->shared_lock_type) &&
+		    ((server->ops->compare_fids(cfile, cur_cfile) &&
+		     current->tgid == li->pid) || type == li->type))
 			continue;
-		else {
-			*conf_lock = li;
-			return true;
-		}
+		*conf_lock = li;
+		return true;
 	}
 	return false;
 }
@@ -719,17 +734,15 @@ cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
 			__u8 type, struct cifsLockInfo **conf_lock)
 {
 	bool rc = false;
-	struct cifsFileInfo *fid, *tmp;
+	struct cifs_fid_locks *cur;
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 
-	spin_lock(&cifs_file_list_lock);
-	list_for_each_entry_safe(fid, tmp, &cinode->openFileList, flist) {
-		rc = cifs_find_fid_lock_conflict(fid, offset, length, type,
+	list_for_each_entry(cur, &cinode->llist, llist) {
+		rc = cifs_find_fid_lock_conflict(cur, offset, length, type,
 						 cfile, conf_lock);
 		if (rc)
 			break;
 	}
-	spin_unlock(&cifs_file_list_lock);
 
 	return rc;
 }
@@ -777,7 +790,7 @@ cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
 {
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	mutex_lock(&cinode->lock_mutex);
-	list_add_tail(&lock->llist, &cfile->llist);
+	list_add_tail(&lock->llist, &cfile->llist->locks);
 	mutex_unlock(&cinode->lock_mutex);
 }
 
@@ -803,7 +816,7 @@ try_again:
 	exist = cifs_find_lock_conflict(cfile, lock->offset, lock->length,
 					lock->type, &conf_lock);
 	if (!exist && cinode->can_cache_brlcks) {
-		list_add_tail(&lock->llist, &cfile->llist);
+		list_add_tail(&lock->llist, &cfile->llist->locks);
 		mutex_unlock(&cinode->lock_mutex);
 		return rc;
 	}
@@ -937,7 +950,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
-		list_for_each_entry_safe(li, tmp, &cfile->llist, llist) {
+		list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
 			if (li->type != types[i])
 				continue;
 			cur->Pid = cpu_to_le16(li->pid);
@@ -1279,7 +1292,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
-		list_for_each_entry_safe(li, tmp, &cfile->llist, llist) {
+		list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
 			if (flock->fl_start > li->offset ||
 			    (flock->fl_start + length) <
 			    (li->offset + li->length))
@@ -1320,7 +1333,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 					 * list to the head of the file's list.
 					 */
 					cifs_move_llist(&tmp_llist,
-							&cfile->llist);
+							&cfile->llist->locks);
 					rc = stored_rc;
 				} else
 					/*
@@ -1337,7 +1350,8 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 			stored_rc = cifs_lockv(xid, tcon, cfile->fid.netfid,
 					       types[i], num, 0, buf);
 			if (stored_rc) {
-				cifs_move_llist(&tmp_llist, &cfile->llist);
+				cifs_move_llist(&tmp_llist,
+						&cfile->llist->locks);
 				rc = stored_rc;
 			} else
 				cifs_free_llist(&tmp_llist);
@@ -1350,7 +1364,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 }
 
 static int
-cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
+cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 	   bool wait_flag, bool posix_lck, int lock, int unlock,
 	   unsigned int xid)
 {
@@ -1359,7 +1373,6 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
-	__u16 netfid = cfile->fid.netfid;
 
 	if (posix_lck) {
 		int posix_lock_type;
@@ -1376,9 +1389,9 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
 		if (unlock == 1)
 			posix_lock_type = CIFS_UNLCK;
 
-		rc = CIFSSMBPosixLock(xid, tcon, netfid, current->tgid,
-				      flock->fl_start, length, NULL,
-				      posix_lock_type, wait_flag);
+		rc = CIFSSMBPosixLock(xid, tcon, cfile->fid.netfid,
+				      current->tgid, flock->fl_start, length,
+				      NULL, posix_lock_type, wait_flag);
 		goto out;
 	}
 
-- 
1.7.1
