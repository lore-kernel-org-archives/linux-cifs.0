From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 12/17] CIFS: Move locks to file structure
Date: Sat,  3 Mar 2012 12:49:06 +0300
Message-ID: <1330768147-23019-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    1 -
 fs/cifs/cifsglob.h |    3 +-
 fs/cifs/file.c     |   98 ++++++++++++++++++++++++++++++++--------------------
 3 files changed, 61 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a9b483b..62413f9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -940,7 +940,6 @@ cifs_init_once(void *inode)
 	struct cifsInodeInfo *cifsi = inode;
 
 	inode_init_once(&cifsi->vfs_inode);
-	INIT_LIST_HEAD(&cifsi->llist);
 	mutex_init(&cifsi->lock_mutex);
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8755724..c2a4ab2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -553,7 +553,6 @@ struct cifsLockInfo {
 	__u64 length;
 	__u32 pid;
 	__u8 type;
-	__u16 netfid;
 };
 
 /*
@@ -578,6 +577,7 @@ struct cifs_search_info {
 struct cifsFileInfo {
 	struct list_head tlist;	/* pointer to next fid owned by tcon */
 	struct list_head flist;	/* next fid (file instance) for this inode */
+	struct list_head llist;	/* brlocks held by this fid */
 	unsigned int uid;	/* allows finding which FileInfo structure */
 	__u32 pid;		/* process id who opened file */
 	__u16 netfid;		/* file id from remote */
@@ -618,7 +618,6 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
  */
 
 struct cifsInodeInfo {
-	struct list_head llist;		/* brlocks for this inode */
 	bool can_cache_brlcks;
 	struct mutex lock_mutex;	/* protect two fields above */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1852b72..60fc618 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -264,6 +264,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	pCifsFile->tlink = cifs_get_tlink(tlink);
 	mutex_init(&pCifsFile->fh_mutex);
 	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
+	INIT_LIST_HEAD(&pCifsFile->llist);
 
 	spin_lock(&cifs_file_list_lock);
 	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
@@ -334,9 +335,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	 * is closed anyway.
 	 */
 	mutex_lock(&cifsi->lock_mutex);
-	list_for_each_entry_safe(li, tmp, &cifsi->llist, llist) {
-		if (li->netfid != cifs_file->netfid)
-			continue;
+	list_for_each_entry_safe(li, tmp, &cifs_file->llist, llist) {
 		list_del(&li->llist);
 		cifs_del_lock_waiters(li);
 		kfree(li);
@@ -645,7 +644,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 }
 
 static struct cifsLockInfo *
-cifs_lock_init(__u64 offset, __u64 length, __u8 type, __u16 netfid)
+cifs_lock_init(__u64 offset, __u64 length, __u8 type)
 {
 	struct cifsLockInfo *lock =
 		kmalloc(sizeof(struct cifsLockInfo), GFP_KERNEL);
@@ -654,7 +653,6 @@ cifs_lock_init(__u64 offset, __u64 length, __u8 type, __u16 netfid)
 	lock->offset = offset;
 	lock->length = length;
 	lock->type = type;
-	lock->netfid = netfid;
 	lock->pid = current->tgid;
 	INIT_LIST_HEAD(&lock->blist);
 	init_waitqueue_head(&lock->block_q);
@@ -672,19 +670,19 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
 }
 
 static bool
-__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
-			__u64 length, __u8 type, __u16 netfid,
-			struct cifsLockInfo **conf_lock)
+__cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
+			      __u64 length, __u8 type, __u16 netfid,
+			      struct cifsLockInfo **conf_lock)
 {
 	struct cifsLockInfo *li, *tmp;
 
-	list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
+	list_for_each_entry_safe(li, tmp, &cfile->llist, llist) {
 		if (offset + length <= li->offset ||
 		    offset >= li->offset + li->length)
 			continue;
 		else if ((type & LOCKING_ANDX_SHARED_LOCK) &&
-			 ((netfid == li->netfid && current->tgid == li->pid) ||
-			  type == li->type))
+			 ((netfid == cfile->netfid && current->tgid == li->pid)
+			 || type == li->type))
 			continue;
 		else {
 			*conf_lock = li;
@@ -695,11 +693,36 @@ __cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
 }
 
 static bool
+__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
+			  __u64 length, __u8 type, __u16 netfid,
+			  struct cifsLockInfo **conf_lock)
+{
+	bool rc;
+	struct cifsFileInfo *fid, *tmp;
+
+	spin_lock(&cifs_file_list_lock);
+	list_for_each_entry_safe(fid, tmp, &cinode->openFileList, flist) {
+		cifsFileInfo_get(fid);
+		spin_unlock(&cifs_file_list_lock);
+		rc = __cifs_find_fid_lock_conflict(fid, offset, length, type,
+						   netfid, conf_lock);
+		cifsFileInfo_put(fid);
+		if (rc)
+			return rc;
+		spin_lock(&cifs_file_list_lock);
+	}
+	spin_unlock(&cifs_file_list_lock);
+
+	return false;
+}
+
+static bool
 cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
-			struct cifsLockInfo **conf_lock)
+			__u16 netfid, struct cifsLockInfo **conf_lock)
 {
+
 	return __cifs_find_lock_conflict(cinode, lock->offset, lock->length,
-					 lock->type, lock->netfid, conf_lock);
+					 lock->type, netfid, conf_lock);
 }
 
 /*
@@ -710,17 +733,18 @@ cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
  * the server or 1 otherwise.
  */
 static int
-cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
-	       __u8 type, __u16 netfid, struct file_lock *flock)
+cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
+	       __u8 type, struct file_lock *flock)
 {
 	int rc = 0;
 	struct cifsLockInfo *conf_lock;
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	bool exist;
 
 	mutex_lock(&cinode->lock_mutex);
 
-	exist = __cifs_find_lock_conflict(cinode, offset, length, type, netfid,
-					  &conf_lock);
+	exist = __cifs_find_lock_conflict(cinode, offset, length, type,
+					  cfile->netfid, &conf_lock);
 	if (exist) {
 		flock->fl_start = conf_lock->offset;
 		flock->fl_end = conf_lock->offset + conf_lock->length - 1;
@@ -739,10 +763,11 @@ cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
 }
 
 static void
-cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock)
+cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
 {
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	mutex_lock(&cinode->lock_mutex);
-	list_add_tail(&lock->llist, &cinode->llist);
+	list_add_tail(&lock->llist, &cfile->llist);
 	mutex_unlock(&cinode->lock_mutex);
 }
 
@@ -753,10 +778,11 @@ cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock)
  * 3) -EACCESS, if there is a lock that prevents us and wait is false.
  */
 static int
-cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
+cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *lock,
 		 bool wait)
 {
 	struct cifsLockInfo *conf_lock;
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	bool exist;
 	int rc = 0;
 
@@ -764,9 +790,10 @@ try_again:
 	exist = false;
 	mutex_lock(&cinode->lock_mutex);
 
-	exist = cifs_find_lock_conflict(cinode, lock, &conf_lock);
+	exist = cifs_find_lock_conflict(cinode, lock, cfile->netfid,
+					&conf_lock);
 	if (!exist && cinode->can_cache_brlcks) {
-		list_add_tail(&lock->llist, &cinode->llist);
+		list_add_tail(&lock->llist, &cfile->llist);
 		mutex_unlock(&cinode->lock_mutex);
 		return rc;
 	}
@@ -880,7 +907,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
-		list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
+		list_for_each_entry_safe(li, tmp, &cfile->llist, llist) {
 			if (li->type != types[i])
 				continue;
 			cur->Pid = cpu_to_le16(li->pid);
@@ -1091,7 +1118,6 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
 	__u64 length = 1 + flock->fl_end - flock->fl_start;
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
-	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	__u16 netfid = cfile->netfid;
 
 	if (posix_lck) {
@@ -1111,8 +1137,7 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
 		return rc;
 	}
 
-	rc = cifs_lock_test(cinode, flock->fl_start, length, type, netfid,
-			    flock);
+	rc = cifs_lock_test(cfile, flock->fl_start, length, type, flock);
 	if (!rc)
 		return rc;
 
@@ -1199,15 +1224,13 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
-		list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
+		list_for_each_entry_safe(li, tmp, &cfile->llist, llist) {
 			if (flock->fl_start > li->offset ||
 			    (flock->fl_start + length) <
 			    (li->offset + li->length))
 				continue;
 			if (current->tgid != li->pid)
 				continue;
-			if (cfile->netfid != li->netfid)
-				continue;
 			if (types[i] != li->type)
 				continue;
 			if (!cinode->can_cache_brlcks) {
@@ -1220,7 +1243,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 					cpu_to_le32((u32)(li->offset>>32));
 				/*
 				 * We need to save a lock here to let us add
-				 * it again to the inode list if the unlock
+				 * it again to the file's list if the unlock
 				 * range request fails on the server.
 				 */
 				list_move(&li->llist, &tmp_llist);
@@ -1234,10 +1257,10 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 						 * We failed on the unlock range
 						 * request - add all locks from
 						 * the tmp list to the head of
-						 * the inode list.
+						 * the file's list.
 						 */
 						cifs_move_llist(&tmp_llist,
-								&cinode->llist);
+								&cfile->llist);
 						rc = stored_rc;
 					} else
 						/*
@@ -1252,7 +1275,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 			} else {
 				/*
 				 * We can cache brlock requests - simply remove
-				 * a lock from the inode list.
+				 * a lock from the file's list.
 				 */
 				list_del(&li->llist);
 				cifs_del_lock_waiters(li);
@@ -1263,7 +1286,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 			stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
 					       types[i], num, 0, buf);
 			if (stored_rc) {
-				cifs_move_llist(&tmp_llist, &cinode->llist);
+				cifs_move_llist(&tmp_llist, &cfile->llist);
 				rc = stored_rc;
 			} else
 				cifs_free_llist(&tmp_llist);
@@ -1283,7 +1306,6 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 	__u64 length = 1 + flock->fl_end - flock->fl_start;
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
-	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
 	__u16 netfid = cfile->netfid;
 
 	if (posix_lck) {
@@ -1310,11 +1332,11 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 	if (lock) {
 		struct cifsLockInfo *lock;
 
-		lock = cifs_lock_init(flock->fl_start, length, type, netfid);
+		lock = cifs_lock_init(flock->fl_start, length, type);
 		if (!lock)
 			return -ENOMEM;
 
-		rc = cifs_lock_add_if(cinode, lock, wait_flag);
+		rc = cifs_lock_add_if(cfile, lock, wait_flag);
 		if (rc < 0)
 			kfree(lock);
 		if (rc <= 0)
@@ -1327,7 +1349,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 			goto out;
 		}
 
-		cifs_lock_add(cinode, lock);
+		cifs_lock_add(cfile, lock);
 	} else if (unlock)
 		rc = cifs_unlock_range(cfile, flock, xid);
 
-- 
1.7.1
