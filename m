From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/2] CIFS: Simplify setlk error handling for mandatory locking
Date: Wed, 26 Oct 2011 23:26:48 +0400
Message-ID: <1319657208-15659-2-git-send-email-piastry@etersoft.ru>
References: <1319657208-15659-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319657208-15659-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and do a trivial cleanup for getlk.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   99 +++++++++++++++++++++++++++-----------------------------
 1 files changed, 48 insertions(+), 51 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6bf14ed..3ad89ec 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -771,20 +771,20 @@ int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
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
@@ -798,7 +798,7 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
 }
 
 static bool
-cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
+__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
 			__u64 length, __u8 type, __u16 netfid,
 			struct cifsLockInfo **conf_lock)
 {
@@ -820,6 +820,14 @@ cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
 	return false;
 }
 
+static bool
+cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
+			struct cifsLockInfo **conf_lock)
+{
+	return __cifs_find_lock_conflict(cinode, lock->offset, lock->length,
+					 lock->type, lock->netfid, conf_lock);
+}
+
 static int
 cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
 	       __u8 type, __u16 netfid, struct file_lock *flock)
@@ -830,8 +838,8 @@ cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
 
 	mutex_lock(&cinode->lock_mutex);
 
-	exist = cifs_find_lock_conflict(cinode, offset, length, type, netfid,
-					&conf_lock);
+	exist = __cifs_find_lock_conflict(cinode, offset, length, type, netfid,
+					  &conf_lock);
 	if (exist) {
 		flock->fl_start = conf_lock->offset;
 		flock->fl_end = conf_lock->offset + conf_lock->length - 1;
@@ -849,40 +857,27 @@ cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
 	return rc;
 }
 
-static int
-cifs_lock_add(struct cifsInodeInfo *cinode, __u64 len, __u64 offset,
-	      __u8 type, __u16 netfid)
+static void
+cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock)
 {
-	struct cifsLockInfo *li;
-
-	li = cifs_lock_init(len, offset, type, netfid);
-	if (!li)
-		return -ENOMEM;
-
 	mutex_lock(&cinode->lock_mutex);
-	list_add_tail(&li->llist, &cinode->llist);
+	list_add_tail(&lock->llist, &cinode->llist);
 	mutex_unlock(&cinode->lock_mutex);
-	return 0;
 }
 
 static int
-cifs_lock_add_if(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
-		 __u8 type, __u16 netfid, bool wait)
+cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
+		 bool wait)
 {
-	struct cifsLockInfo *lock, *conf_lock;
+	struct cifsLockInfo *conf_lock;
 	bool exist;
 	int rc = 0;
 
-	lock = cifs_lock_init(length, offset, type, netfid);
-	if (!lock)
-		return -ENOMEM;
-
 try_again:
 	exist = false;
 	mutex_lock(&cinode->lock_mutex);
 
-	exist = cifs_find_lock_conflict(cinode, offset, length, type, netfid,
-					&conf_lock);
+	exist = cifs_find_lock_conflict(cinode, lock, &conf_lock);
 	if (!exist && cinode->can_cache_brlcks) {
 		list_add_tail(&lock->llist, &cinode->llist);
 		mutex_unlock(&cinode->lock_mutex);
@@ -908,7 +903,6 @@ try_again:
 		}
 	}
 
-	kfree(lock);
 	mutex_unlock(&cinode->lock_mutex);
 	return rc;
 }
@@ -1060,7 +1054,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 		else
 			type = CIFS_WRLCK;
 
-		lck = cifs_lock_init(length, flock->fl_start, type,
+		lck = cifs_lock_init(flock->fl_start, length, type,
 				     cfile->netfid);
 		if (!lck) {
 			rc = -ENOMEM;
@@ -1197,14 +1191,12 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
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
@@ -1222,8 +1214,7 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
 	} else
 		flock->fl_type = F_WRLCK;
 
-	rc = 0;
-	return rc;
+	return 0;
 }
 
 static void
@@ -1392,20 +1383,26 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 	}
 
 	if (lock) {
-		rc = cifs_lock_add_if(cinode, flock->fl_start, length,
-				      type, netfid, wait_flag);
+		struct cifsLockInfo *lock;
+
+		lock = cifs_lock_init(flock->fl_start, length, type, netfid);
+		if (!lock)
+			return -ENOMEM;
+
+		rc = cifs_lock_add_if(cinode, lock, wait_flag);
 		if (rc < 0)
-			return rc;
-		else if (!rc)
+			kfree(lock);
+		if (rc <= 0)
 			goto out;
 
 		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
 				 flock->fl_start, 0, 1, type, wait_flag, 0);
-		if (rc == 0) {
-			/* For Windows locks we must store them. */
-			rc = cifs_lock_add(cinode, length, flock->fl_start,
-					   type, netfid);
+		if (rc) {
+			kfree(lock);
+			goto out;
 		}
+
+		cifs_lock_add(cinode, lock);
 	} else if (unlock)
 		rc = cifs_unlock_range(cfile, flock, xid);
 
-- 
1.7.1
