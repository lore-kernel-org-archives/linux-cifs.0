From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: RFC: Attach locks to cifsFileInfo instead of cifsInodeInfo
Date: Thu, 17 Nov 2011 16:31:24 +0000
Message-ID: <1321547488.1690.122.camel@sprabhu.fab.redhat.com>
References: <1320696342.1690.19.camel@sprabhu.fab.redhat.com>
	 <CAKywueTSqckM1iVsrEu47RwBA3GnpfZU17QrrNineJBVOcZdvQ@mail.gmail.com>
	 <1320751612.2941.10.camel@localhost>
	 <CAKywueQ65EgLz9iDd2exq85jBMGrBFLiq=mq2dOY9poy3_1h0g@mail.gmail.com>
	 <1320773203.1690.35.camel@sprabhu.fab.redhat.com>
	 <CAKywueSRYxizd+mKw8p93Os0Aqij+R2Dh=2hu6JuJ+bv7S+uWw@mail.gmail.com>
	 <1321020680.1690.57.camel@sprabhu.fab.redhat.com>
	 <CAKywueQwM49dfne1L_d4WVa3zENdshbuuiZ9tVzv=BiF171_8w@mail.gmail.com>
	 <1321276715.1690.78.camel@sprabhu.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321276715.1690.78.camel-yuq4rhG59MBosH8Q1Ye95IGKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel,

I've made some changes to the locking code which makes it easier to
unlock all locks on an inode. This fixes the earlier problem where
unlock  requests would only process the locks for that open file
instance while ignoring the locks on other open file instances for that
inode.

However we still have one major issue. In case of unlocks, the current
code will only return locks which are completely within the range
specified by the unlock command. If we get an unlock request which
divides a  brlock into 2, we ignore the unlock request for that brlock.
This will result in a situation where the application finds a lock on a
part of the file it expected to be unlocked. Should we check for these
cases and return an EFAULT in cases where the unlock request will not
completely unlock the entire range?

Sachin Prabhu

---- 

Attach locks to cifsFileInfo instead of cifsInodeInfo

Locks in CIFS are attached to an open file instances ie. all
lock/unlock requests made to the file server should contain the fileid
which represents the open file instance. Grouping all brlocks according
to the fileid therefore makes it easier to process especially when
multiple lock or unlock requests for a file are to be made.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8f1fe32..8a71b0d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -949,7 +949,6 @@ cifs_init_once(void *inode)
 	struct cifsInodeInfo *cifsi = inode;
 
 	inode_init_once(&cifsi->vfs_inode);
-	INIT_LIST_HEAD(&cifsi->llist);
 	mutex_init(&cifsi->lock_mutex);
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8238aa1..409d932 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -527,6 +527,7 @@ struct cifs_search_info {
 struct cifsFileInfo {
 	struct list_head tlist;	/* pointer to next fid owned by tcon */
 	struct list_head flist;	/* next fid (file instance) for this inode */
+	struct list_head llist;	/* brlocks for this file */
 	unsigned int uid;	/* allows finding which FileInfo structure */
 	__u32 pid;		/* process id who opened file */
 	__u16 netfid;		/* file id from remote */
@@ -567,9 +568,9 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
  */
 
 struct cifsInodeInfo {
-	struct list_head llist;		/* brlocks for this inode */
 	bool can_cache_brlcks;
-	struct mutex lock_mutex;	/* protect two fields above */
+	struct mutex lock_mutex;	/* protect cifsFileInfo->llist
+					   & cifsInodeInfo->can_cache_brlcks */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cf0b153..3f6b169 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -264,6 +264,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	pCifsFile->tlink = cifs_get_tlink(tlink);
 	mutex_init(&pCifsFile->fh_mutex);
 	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
+	INIT_LIST_HEAD(&pCifsFile->llist);
 
 	spin_lock(&cifs_file_list_lock);
 	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
@@ -333,15 +334,11 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	/* Delete any outstanding lock records. We'll lose them when the file
 	 * is closed anyway.
 	 */
-	mutex_lock(&cifsi->lock_mutex);
-	list_for_each_entry_safe(li, tmp, &cifsi->llist, llist) {
-		if (li->netfid != cifs_file->netfid)
-			continue;
+	list_for_each_entry_safe(li, tmp, &cifs_file->llist, llist) {
 		list_del(&li->llist);
 		cifs_del_lock_waiters(li);
 		kfree(li);
 	}
-	mutex_unlock(&cifsi->lock_mutex);
 
 	cifs_put_tlink(cifs_file->tlink);
 	dput(cifs_file->dentry);
@@ -672,47 +669,82 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
 }
 
 static bool
-__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
-			__u64 length, __u8 type, __u16 netfid,
-			struct cifsLockInfo **conf_lock)
+__cifs_find_lock_conflict_file(struct cifsFileInfo *cifs_file, __u64 offset,
+			       __u64 length, __u8 type,
+			       struct cifsLockInfo **conf_lock)
 {
-	struct cifsLockInfo *li, *tmp;
+	struct cifsLockInfo *li;
 
-	list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
+	list_for_each_entry(li, &cifs_file->llist, llist) {
+		/* Check if range matches */
 		if (offset + length <= li->offset ||
 		    offset >= li->offset + li->length)
 			continue;
-		else if ((type & LOCKING_ANDX_SHARED_LOCK) &&
-			 ((netfid == li->netfid && current->tgid == li->pid) ||
-			  type == li->type))
-			continue;
-		else {
-			*conf_lock = li;
-			return true;
+		/* Is the request for a shared lock */
+		if (type == LOCKING_ANDX_SHARED_LOCK) {
+			/* Does this process already posses a lock? */
+			if (current->tgid == li->pid)
+				return false;
+			/* Is the existing lock a shared lock too? */
+			if (li->type == LOCKING_ANDX_SHARED_LOCK)
+				return false;
 		}
+		/* We have found a conflicting lock */
+		*conf_lock = li;
+		return true;
+	}
+	return false;
+}
+
+static bool
+__cifs_find_lock_conflict(struct cifsFileInfo *cifs_file, __u64 offset,
+			  __u64 length, __u8 type,
+			  struct cifsLockInfo **conf_lock)
+{
+	struct cifsFileInfo *file, *tmp;
+	bool rc;
+	struct cifsInodeInfo *cifs_inode = CIFS_I(cifs_file->dentry->d_inode);
+
+	/* We need to check across every open instance of the inode */
+	spin_lock(&cifs_file_list_lock);
+	list_for_each_entry_safe(file, tmp, &cifs_inode->openFileList, flist) {
+		cifsFileInfo_get(file);
+		spin_unlock(&cifs_file_list_lock);
+
+		rc = __cifs_find_lock_conflict_file(file, offset, length,
+						    type, conf_lock);
+		if (rc)
+			return true;
+
+		cifsFileInfo_put(file);
+		spin_lock(&cifs_file_list_lock);
 	}
+	spin_unlock(&cifs_file_list_lock);
+
 	return false;
 }
 
 static bool
-cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
+cifs_find_lock_conflict(struct cifsFileInfo *cifs_file,
+			struct cifsLockInfo *lock,
 			struct cifsLockInfo **conf_lock)
 {
-	return __cifs_find_lock_conflict(cinode, lock->offset, lock->length,
-					 lock->type, lock->netfid, conf_lock);
+	return __cifs_find_lock_conflict(cifs_file, lock->offset, lock->length,
+					 lock->type, conf_lock);
 }
 
 static int
-cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
-	       __u8 type, __u16 netfid, struct file_lock *flock)
+cifs_lock_test(struct cifsFileInfo *cifs_file, __u64 offset, __u64 length,
+	       __u8 type, struct file_lock *flock)
 {
 	int rc = 0;
 	struct cifsLockInfo *conf_lock;
 	bool exist;
+	struct cifsInodeInfo *cinode = CIFS_I(cifs_file->dentry->d_inode);
 
 	mutex_lock(&cinode->lock_mutex);
 
-	exist = __cifs_find_lock_conflict(cinode, offset, length, type, netfid,
+	exist = __cifs_find_lock_conflict(cifs_file, offset, length, type,
 					  &conf_lock);
 	if (exist) {
 		flock->fl_start = conf_lock->offset;
@@ -732,18 +764,21 @@ cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
 }
 
 static void
-cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock)
+cifs_lock_add(struct cifsFileInfo *cifs_file, struct cifsLockInfo *lock)
 {
+	struct cifsInodeInfo *cinode = CIFS_I(cifs_file->dentry->d_inode);
+
 	mutex_lock(&cinode->lock_mutex);
-	list_add_tail(&lock->llist, &cinode->llist);
+	list_add_tail(&lock->llist, &cifs_file->llist);
 	mutex_unlock(&cinode->lock_mutex);
 }
 
 static int
-cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
+cifs_lock_add_if(struct cifsFileInfo *cifs_file, struct cifsLockInfo *lock,
 		 bool wait)
 {
 	struct cifsLockInfo *conf_lock;
+	struct cifsInodeInfo *cinode = CIFS_I(cifs_file->dentry->d_inode);
 	bool exist;
 	int rc = 0;
 
@@ -751,9 +786,9 @@ try_again:
 	exist = false;
 	mutex_lock(&cinode->lock_mutex);
 
-	exist = cifs_find_lock_conflict(cinode, lock, &conf_lock);
+	exist = cifs_find_lock_conflict(cifs_file, lock, &conf_lock);
 	if (!exist && cinode->can_cache_brlcks) {
-		list_add_tail(&lock->llist, &cinode->llist);
+		list_add_tail(&lock->llist, &cifs_file->llist);
 		mutex_unlock(&cinode->lock_mutex);
 		return rc;
 	}
@@ -823,7 +858,7 @@ static int
 cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 {
 	int xid, rc = 0, stored_rc;
-	struct cifsLockInfo *li, *tmp;
+	struct cifsLockInfo *li;
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	unsigned int num, max_num;
@@ -854,7 +889,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
-		list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
+		list_for_each_entry(li, &cfile->llist, llist) {
 			if (li->type != types[i])
 				continue;
 			cur->Pid = cpu_to_le16(li->pid);
@@ -865,8 +900,10 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 			if (++num == max_num) {
 				stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
 						       li->type, 0, num, buf);
-				if (stored_rc)
+				if (stored_rc) {
+					cERROR(1, "Error while syncing locks");
 					rc = stored_rc;
+				}
 				cur = buf;
 				num = 0;
 			} else
@@ -876,8 +913,10 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 		if (num) {
 			stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
 					       types[i], 0, num, buf);
-			if (stored_rc)
+			if (stored_rc) {
+				cERROR(1, "Error while syncing locks");
 				rc = stored_rc;
+			}
 		}
 	}
 
@@ -1026,7 +1065,6 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
 	__u64 length = 1 + flock->fl_end - flock->fl_start;
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
-	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	__u16 netfid = cfile->netfid;
 
 	if (posix_lck) {
@@ -1046,8 +1084,7 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
 		return rc;
 	}
 
-	rc = cifs_lock_test(cinode, flock->fl_start, length, type, netfid,
-			    flock);
+	rc = cifs_lock_test(cfile, flock->fl_start, length, type, flock);
 	if (!rc)
 		return rc;
 
@@ -1108,7 +1145,8 @@ cifs_free_llist(struct list_head *llist)
 }
 
 static int
-cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
+cifs_unlock_range_file(struct cifsFileInfo *cfile, struct file_lock *flock,
+		       int xid)
 {
 	int rc = 0, stored_rc;
 	int types[] = {LOCKING_ANDX_LARGE_FILES,
@@ -1134,15 +1172,11 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
-		list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
+		list_for_each_entry_safe(li, tmp, &cfile->llist, llist) {
 			if (flock->fl_start > li->offset ||
 			    (flock->fl_start + length) <
 			    (li->offset + li->length))
 				continue;
-			if (current->tgid != li->pid)
-				continue;
-			if (cfile->netfid != li->netfid)
-				continue;
 			if (types[i] != li->type)
 				continue;
 			if (!cinode->can_cache_brlcks) {
@@ -1172,7 +1206,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 						 * the inode list.
 						 */
 						cifs_move_llist(&tmp_llist,
-								&cinode->llist);
+								&cfile->llist);
 						rc = stored_rc;
 					} else
 						/*
@@ -1198,7 +1232,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 			stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
 					       types[i], num, 0, buf);
 			if (stored_rc) {
-				cifs_move_llist(&tmp_llist, &cinode->llist);
+				cifs_move_llist(&tmp_llist, &cfile->llist);
 				rc = stored_rc;
 			} else
 				cifs_free_llist(&tmp_llist);
@@ -1211,6 +1245,30 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 }
 
 static int
+cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
+{
+	struct cifsFileInfo *file, *tmp;
+	struct cifsInodeInfo *cifs_inode = CIFS_I(cfile->dentry->d_inode);
+	int rc = 0;
+
+	spin_lock(&cifs_file_list_lock);
+	list_for_each_entry_safe(file, tmp, &cifs_inode->openFileList, flist) {
+		if (file->pid != current->pid)
+			continue;
+		cifsFileInfo_get(file);
+		spin_unlock(&cifs_file_list_lock);
+		rc = cifs_unlock_range_file(file, flock, xid);
+		if (rc < 0)
+			cFYI(1, "VFS is out of sync with lock on server!");
+		cifsFileInfo_put(file);
+		spin_lock(&cifs_file_list_lock);
+	}
+	spin_unlock(&cifs_file_list_lock);
+
+	return rc;
+}
+
+static int
 cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 	   bool wait_flag, bool posix_lck, int lock, int unlock, int xid)
 {
@@ -1218,7 +1276,6 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 	__u64 length = 1 + flock->fl_end - flock->fl_start;
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
-	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
 	__u16 netfid = cfile->netfid;
 
 	if (posix_lck) {
@@ -1249,7 +1306,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 		if (!lock)
 			return -ENOMEM;
 
-		rc = cifs_lock_add_if(cinode, lock, wait_flag);
+		rc = cifs_lock_add_if(cfile, lock, wait_flag);
 		if (rc < 0)
 			kfree(lock);
 		if (rc <= 0)
@@ -1262,7 +1319,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 			goto out;
 		}
 
-		cifs_lock_add(cinode, lock);
+		cifs_lock_add(cfile, lock);
 	} else if (unlock)
 		rc = cifs_unlock_range(cfile, flock, xid);
 
