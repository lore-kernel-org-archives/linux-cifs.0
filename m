From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/6] CIFS: Move byte range lock list from fd to inode
Date: Fri,  7 Oct 2011 17:10:20 +0400
Message-ID: <1317993024-15003-3-git-send-email-piastry@etersoft.ru>
References: <1317993024-15003-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1317993024-15003-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that let us do local lock checks before requesting to the server.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    3 ++-
 fs/cifs/cifsglob.h |    7 ++++---
 fs/cifs/file.c     |   30 +++++++++++++++++-------------
 3 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f93eb94..14201fb 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -940,7 +940,8 @@ cifs_init_once(void *inode)
 	struct cifsInodeInfo *cifsi = inode;
 
 	inode_init_once(&cifsi->vfs_inode);
-	INIT_LIST_HEAD(&cifsi->lockList);
+	INIT_LIST_HEAD(&cifsi->llist);
+	mutex_init(&cifsi->lock_mutex);
 }
 
 static int
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 84b0dd1..865db31 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -489,6 +489,7 @@ struct cifsLockInfo {
 	__u64 length;
 	__u32 pid;
 	__u8 type;
+	__u16 netfid;
 };
 
 /*
@@ -521,8 +522,6 @@ struct cifsFileInfo {
 	struct dentry *dentry;
 	unsigned int f_flags;
 	struct tcon_link *tlink;
-	struct mutex lock_mutex;
-	struct list_head llist; /* list of byte range locks we have. */
 	bool invalidHandle:1;	/* file closed via session abend */
 	bool oplock_break_cancelled:1;
 	int count;		/* refcount protected by cifs_file_list_lock */
@@ -555,7 +554,9 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
  */
 
 struct cifsInodeInfo {
-	struct list_head lockList;
+	struct list_head llist;		/* brlocks for this inode */
+	bool can_cache_brlcks;
+	struct mutex lock_mutex;	/* protect two fields above */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 90e1720..aec848a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -258,8 +258,6 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	pCifsFile->invalidHandle = false;
 	pCifsFile->tlink = cifs_get_tlink(tlink);
 	mutex_init(&pCifsFile->fh_mutex);
-	mutex_init(&pCifsFile->lock_mutex);
-	INIT_LIST_HEAD(&pCifsFile->llist);
 	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
 
 	spin_lock(&cifs_file_list_lock);
@@ -327,12 +325,14 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	/* Delete any outstanding lock records. We'll lose them when the file
 	 * is closed anyway.
 	 */
-	mutex_lock(&cifs_file->lock_mutex);
-	list_for_each_entry_safe(li, tmp, &cifs_file->llist, llist) {
+	mutex_lock(&cifsi->lock_mutex);
+	list_for_each_entry_safe(li, tmp, &cifsi->llist, llist) {
+		if (li->netfid != cifs_file->netfid)
+			continue;
 		list_del(&li->llist);
 		kfree(li);
 	}
-	mutex_unlock(&cifs_file->lock_mutex);
+	mutex_unlock(&cifsi->lock_mutex);
 
 	cifs_put_tlink(cifs_file->tlink);
 	dput(cifs_file->dentry);
@@ -631,20 +631,21 @@ int cifs_closedir(struct inode *inode, struct file *file)
 	return rc;
 }
 
-static int store_file_lock(struct cifsFileInfo *cfile, __u64 len,
+static int store_file_lock(struct cifsInodeInfo *cinode, __u64 len,
 			   __u64 offset, __u8 type, __u16 netfid)
 {
 	struct cifsLockInfo *li =
 		kmalloc(sizeof(struct cifsLockInfo), GFP_KERNEL);
 	if (li == NULL)
 		return -ENOMEM;
+	li->netfid = netfid;
 	li->offset = offset;
 	li->length = len;
 	li->type = type;
 	li->pid = current->tgid;
-	mutex_lock(&cfile->lock_mutex);
-	list_add_tail(&li->llist, &cfile->llist);
-	mutex_unlock(&cfile->lock_mutex);
+	mutex_lock(&cinode->lock_mutex);
+	list_add_tail(&li->llist, &cinode->llist);
+	mutex_unlock(&cinode->lock_mutex);
 	return 0;
 }
 
@@ -761,6 +762,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 	__u64 length = 1 + flock->fl_end - flock->fl_start;
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
 	__u16 netfid = cfile->netfid;
 
 	if (posix_lck) {
@@ -783,7 +785,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 				 flock->fl_start, 0, lock, type, wait_flag, 0);
 		if (rc == 0) {
 			/* For Windows locks we must store them. */
-			rc = store_file_lock(cfile, length, flock->fl_start,
+			rc = store_file_lock(cinode, length, flock->fl_start,
 					     type, netfid);
 		}
 	} else if (unlock) {
@@ -794,14 +796,16 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 		int stored_rc = 0;
 		struct cifsLockInfo *li, *tmp;
 
-		mutex_lock(&cfile->lock_mutex);
-		list_for_each_entry_safe(li, tmp, &cfile->llist, llist) {
+		mutex_lock(&cinode->lock_mutex);
+		list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
 			if (flock->fl_start > li->offset ||
 			    (flock->fl_start + length) <
 			    (li->offset + li->length))
 				continue;
 			if (current->tgid != li->pid)
 				continue;
+			if (cfile->netfid != li->netfid)
+				continue;
 
 			stored_rc = CIFSSMBLock(xid, tcon, netfid,
 						current->tgid, li->length,
@@ -814,7 +818,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 				kfree(li);
 			}
 		}
-		mutex_unlock(&cfile->lock_mutex);
+		mutex_unlock(&cinode->lock_mutex);
 	}
 out:
 	if (flock->fl_flags & FL_POSIX)
-- 
1.7.1
