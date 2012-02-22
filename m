From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Do not kmalloc under the flocks spinlock
Date: Wed, 22 Feb 2012 12:10:55 +0300
Message-ID: <1329901855-11683-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reorganize the code to make the memory already allocated before
spinlock'ed loop.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   49 ++++++++++++++++++++++++++++++++-----------------
 1 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b5e38b1..aa2581e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -926,10 +926,10 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct file_lock *flock, **before;
-	struct cifsLockInfo *lck, *tmp;
+	struct cifsLockInfo *lcks, *lck;
+	unsigned int count = 0, i = 0;
 	int rc = 0, xid, type;
 	__u64 length;
-	struct list_head locks_to_send;
 
 	xid = GetXid();
 
@@ -940,7 +940,19 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 		return rc;
 	}
 
-	INIT_LIST_HEAD(&locks_to_send);
+	lock_flocks();
+	cifs_for_each_lock(cfile->dentry->d_inode, before)
+		count++;
+	unlock_flocks();
+
+	/*
+	 * We can safely allocate count locks, because the hold lock_mutex.
+	 * Allocate (count + 1) * 2 locks to be more safe.
+	 */
+	count = (count + 1) * 2;
+	lcks = kmalloc(count * sizeof(struct cifsLockInfo), GFP_KERNEL);
+	if (!lcks)
+		goto out;
 
 	lock_flocks();
 	cifs_for_each_lock(cfile->dentry->d_inode, before) {
@@ -950,35 +962,38 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 			type = CIFS_RDLCK;
 		else
 			type = CIFS_WRLCK;
-
-		lck = cifs_lock_init(flock->fl_start, length, type,
-				     cfile->netfid);
-		if (!lck) {
-			rc = -ENOMEM;
-			goto send_locks;
-		}
+		lck = &lcks[i];
 		lck->pid = flock->fl_pid;
-
-		list_add_tail(&lck->llist, &locks_to_send);
+		lck->netfid = cfile->netfid;
+		lck->length = length;
+		lck->type = type;
+		lck->offset = flock->fl_start;
+		i++;
+		if (i == count)
+			break;
 	}
-
-send_locks:
 	unlock_flocks();
 
-	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
+	if (i == count)
+		cERROR(1, "Can't push all brlocks!");
+
+	count = i;
+
+	for (i = 0; i < count; i++) {
 		struct file_lock tmp_lock;
 		int stored_rc;
 
+		lck = &lcks[i];
 		tmp_lock.fl_start = lck->offset;
 		stored_rc = CIFSSMBPosixLock(xid, tcon, lck->netfid, lck->pid,
 					     0, lck->length, &tmp_lock,
 					     lck->type, 0);
 		if (stored_rc)
 			rc = stored_rc;
-		list_del(&lck->llist);
-		kfree(lck);
 	}
 
+	kfree(lcks);
+out:
 	cinode->can_cache_brlcks = false;
 	mutex_unlock(&cinode->lock_mutex);
 
-- 
1.7.1
