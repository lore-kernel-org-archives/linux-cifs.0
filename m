From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2] CIFS: Do not kmalloc under the flocks spinlock
Date: Sat, 17 Mar 2012 09:45:35 +0300
Message-ID: <1331966735-3080-1-git-send-email-piastry@etersoft.ru>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit d5751469f210d2149cc2159ffff66cbeef6da3f2 upstream.

Reorganize the code to make the memory already allocated before
spinlock'ed loop.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |   70 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 57 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4dd9283..8e02dbd 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -920,16 +920,26 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	for (lockp = &inode->i_flock; *lockp != NULL; \
 	     lockp = &(*lockp)->fl_next)
 
+struct lock_to_push {
+	struct list_head llist;
+	__u64 offset;
+	__u64 length;
+	__u32 pid;
+	__u16 netfid;
+	__u8 type;
+};
+
 static int
 cifs_push_posix_locks(struct cifsFileInfo *cfile)
 {
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct file_lock *flock, **before;
-	struct cifsLockInfo *lck, *tmp;
+	unsigned int count = 0, i = 0;
 	int rc = 0, xid, type;
+	struct list_head locks_to_send, *el;
+	struct lock_to_push *lck, *tmp;
 	__u64 length;
-	struct list_head locks_to_send;
 
 	xid = GetXid();
 
@@ -940,29 +950,56 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 		return rc;
 	}
 
+	lock_flocks();
+	cifs_for_each_lock(cfile->dentry->d_inode, before) {
+		if ((*before)->fl_flags & FL_POSIX)
+			count++;
+	}
+	unlock_flocks();
+
 	INIT_LIST_HEAD(&locks_to_send);
 
+	/*
+	 * Allocating count locks is enough because no FL_POSIX locks can be
+	 * added to the list while we are holding cinode->lock_mutex that
+	 * protects locking operations of this inode.
+	 */
+	for (; i < count; i++) {
+		lck = kmalloc(sizeof(struct lock_to_push), GFP_KERNEL);
+		if (!lck) {
+			rc = -ENOMEM;
+			goto err_out;
+		}
+		list_add_tail(&lck->llist, &locks_to_send);
+	}
+
+	el = locks_to_send.next;
 	lock_flocks();
 	cifs_for_each_lock(cfile->dentry->d_inode, before) {
 		flock = *before;
+		if ((flock->fl_flags & FL_POSIX) == 0)
+			continue;
+		if (el == &locks_to_send) {
+			/*
+			 * The list ended. We don't have enough allocated
+			 * structures - something is really wrong.
+			 */
+			cERROR(1, "Can't push all brlocks!");
+			break;
+		}
 		length = 1 + flock->fl_end - flock->fl_start;
 		if (flock->fl_type == F_RDLCK || flock->fl_type == F_SHLCK)
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
+		lck = list_entry(el, struct lock_to_push, llist);
 		lck->pid = flock->fl_pid;
-
-		list_add_tail(&lck->llist, &locks_to_send);
+		lck->netfid = cfile->netfid;
+		lck->length = length;
+		lck->type = type;
+		lck->offset = flock->fl_start;
+		el = el->next;
 	}
-
-send_locks:
 	unlock_flocks();
 
 	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
@@ -979,11 +1016,18 @@ send_locks:
 		kfree(lck);
 	}
 
+out:
 	cinode->can_cache_brlcks = false;
 	mutex_unlock(&cinode->lock_mutex);
 
 	FreeXid(xid);
 	return rc;
+err_out:
+	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
+		list_del(&lck->llist);
+		kfree(lck);
+	}
+	goto out;
 }
 
 static int
-- 
1.7.1
