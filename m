From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 01/10] CIFS: Improve byte-range locks handling
Date: Mon, 20 Aug 2012 22:42:51 +0400
Message-ID: <1345488180-5942-2-git-send-email-pshilovsky@samba.org>
References: <1345488180-5942-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345488180-5942-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now we need to lock/unlock a spinlock while processing brlock ops on
the inode. Move brlocks of a fid to a separate list and attach all
such lists to the inode. This let us not hold a spinlock.

SMB2 brlocking also needs this as the initial step before sorting brlocks
by pid inside the fid list due to the SMB2 protocol limitation that doesn't
allow to send a group of brlocks with different pids.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    1 +
 fs/cifs/cifsglob.h |   18 +++++++++---------
 fs/cifs/file.c     |   47 +++++++++++++++++++++++++++++++----------------
 3 files changed, 41 insertions(+), 25 deletions(-)

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
index b2bb941..93cd2e7 100644
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
index 18098c8..4452394 100644
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
@@ -340,11 +353,13 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
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
@@ -691,14 +706,15 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
 }
 
 static bool
-cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
+cifs_find_fid_lock_conflict(struct cifs_fid_locks *fdlocks, __u64 offset,
 			    __u64 length, __u8 type, struct cifsFileInfo *cur,
 			    struct cifsLockInfo **conf_lock)
 {
 	struct cifsLockInfo *li;
+	struct cifsFileInfo *cfile = fdlocks->cfile;
 	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
 
-	list_for_each_entry(li, &cfile->llist, llist) {
+	list_for_each_entry(li, &fdlocks->locks, llist) {
 		if (offset + length <= li->offset ||
 		    offset >= li->offset + li->length)
 			continue;
@@ -719,17 +735,15 @@ cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
 			__u8 type, struct cifsLockInfo **conf_lock)
 {
 	bool rc = false;
-	struct cifsFileInfo *fid, *tmp;
+	struct cifs_fid_locks *cur, *tmp;
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 
-	spin_lock(&cifs_file_list_lock);
-	list_for_each_entry_safe(fid, tmp, &cinode->openFileList, flist) {
-		rc = cifs_find_fid_lock_conflict(fid, offset, length, type,
+	list_for_each_entry_safe(cur, tmp, &cinode->llist, llist) {
+		rc = cifs_find_fid_lock_conflict(cur, offset, length, type,
 						 cfile, conf_lock);
 		if (rc)
 			break;
 	}
-	spin_unlock(&cifs_file_list_lock);
 
 	return rc;
 }
@@ -777,7 +791,7 @@ cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
 {
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	mutex_lock(&cinode->lock_mutex);
-	list_add_tail(&lock->llist, &cfile->llist);
+	list_add_tail(&lock->llist, &cfile->llist->locks);
 	mutex_unlock(&cinode->lock_mutex);
 }
 
@@ -803,7 +817,7 @@ try_again:
 	exist = cifs_find_lock_conflict(cfile, lock->offset, lock->length,
 					lock->type, &conf_lock);
 	if (!exist && cinode->can_cache_brlcks) {
-		list_add_tail(&lock->llist, &cfile->llist);
+		list_add_tail(&lock->llist, &cfile->llist->locks);
 		mutex_unlock(&cinode->lock_mutex);
 		return rc;
 	}
@@ -937,7 +951,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
-		list_for_each_entry_safe(li, tmp, &cfile->llist, llist) {
+		list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
 			if (li->type != types[i])
 				continue;
 			cur->Pid = cpu_to_le16(li->pid);
@@ -1279,7 +1293,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
-		list_for_each_entry_safe(li, tmp, &cfile->llist, llist) {
+		list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
 			if (flock->fl_start > li->offset ||
 			    (flock->fl_start + length) <
 			    (li->offset + li->length))
@@ -1320,7 +1334,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 					 * list to the head of the file's list.
 					 */
 					cifs_move_llist(&tmp_llist,
-							&cfile->llist);
+							&cfile->llist->locks);
 					rc = stored_rc;
 				} else
 					/*
@@ -1337,7 +1351,8 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 			stored_rc = cifs_lockv(xid, tcon, cfile->fid.netfid,
 					       types[i], num, 0, buf);
 			if (stored_rc) {
-				cifs_move_llist(&tmp_llist, &cfile->llist);
+				cifs_move_llist(&tmp_llist,
+						&cfile->llist->locks);
 				rc = stored_rc;
 			} else
 				cifs_free_llist(&tmp_llist);
-- 
1.7.1
