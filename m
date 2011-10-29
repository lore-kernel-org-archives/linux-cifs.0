From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 3/3] CIFS: Cleanup byte-range locking code style
Date: Sat, 29 Oct 2011 17:17:59 +0400
Message-ID: <1319894279-7723-3-git-send-email-piastry@etersoft.ru>
References: <1319894279-7723-1-git-send-email-piastry@etersoft.ru>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319894279-7723-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reorder parms of cifs_lock_init, trivially simplify getlk code and
remove extra {} in cifs_lock_add_if.

Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   43 +++++++++++++++++++------------------------
 1 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d9cc07f..cf0b153 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -645,20 +645,20 @@ int cifs_closedir(struct inode *inode, struct file *file)
 }
 
 static struct cifsLockInfo *
-cifs_lock_init(__u64 len, __u64 offset, __u8 type, __u16 netfid)
+cifs_lock_init(__u64 offset, __u64 length, __u8 type, __u16 netfid)
 {
-	struct cifsLockInfo *li =
+	struct cifsLockInfo *lock =
 		kmalloc(sizeof(struct cifsLockInfo), GFP_KERNEL);
-	if (!li)
-		return li;
-	li->netfid = netfid;
-	li->offset = offset;
-	li->length = len;
-	li->type = type;
-	li->pid = current->tgid;
-	INIT_LIST_HEAD(&li->blist);
-	init_waitqueue_head(&li->block_q);
-	return li;
+	if (!lock)
+		return lock;
+	lock->offset = offset;
+	lock->length = length;
+	lock->type = type;
+	lock->netfid = netfid;
+	lock->pid = current->tgid;
+	INIT_LIST_HEAD(&lock->blist);
+	init_waitqueue_head(&lock->block_q);
+	return lock;
 }
 
 static void
@@ -770,10 +770,8 @@ try_again:
 					(lock->blist.next == &lock->blist));
 		if (!rc)
 			goto try_again;
-		else {
-			mutex_lock(&cinode->lock_mutex);
-			list_del_init(&lock->blist);
-		}
+		mutex_lock(&cinode->lock_mutex);
+		list_del_init(&lock->blist);
 	}
 
 	mutex_unlock(&cinode->lock_mutex);
@@ -927,7 +925,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 		else
 			type = CIFS_WRLCK;
 
-		lck = cifs_lock_init(length, flock->fl_start, type,
+		lck = cifs_lock_init(flock->fl_start, length, type,
 				     cfile->netfid);
 		if (!lck) {
 			rc = -ENOMEM;
@@ -1064,14 +1062,12 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
 		if (rc != 0)
 			cERROR(1, "Error unlocking previously locked "
 				   "range %d during test of lock", rc);
-		rc = 0;
-		return rc;
+		return 0;
 	}
 
 	if (type & LOCKING_ANDX_SHARED_LOCK) {
 		flock->fl_type = F_WRLCK;
-		rc = 0;
-		return rc;
+		return 0;
 	}
 
 	rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
@@ -1089,8 +1085,7 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
 	} else
 		flock->fl_type = F_WRLCK;
 
-	rc = 0;
-	return rc;
+	return 0;
 }
 
 static void
@@ -1250,7 +1245,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 	if (lock) {
 		struct cifsLockInfo *lock;
 
-		lock = cifs_lock_init(length, flock->fl_start, type, netfid);
+		lock = cifs_lock_init(flock->fl_start, length, type, netfid);
 		if (!lock)
 			return -ENOMEM;
 
-- 
1.7.1
