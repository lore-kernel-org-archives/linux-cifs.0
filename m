From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2] CIFS: Fix VFS lock usage for oplocked files
Date: Wed, 28 Mar 2012 13:54:49 +0400
Message-ID: <1332928489-12455-1-git-send-email-piastry@etersoft.ru>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We can deadlock if we have a write oplock and two processes
use the same file handle. In this case the first process can't
unlock its lock if another process blocked on the lock in the
same time.

Fix this by removing lock_mutex protection from waiting on a
blocked lock and protect only posix_lock_file call.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c     |   16 ++++++++++++++--
 fs/locks.c         |    3 ++-
 include/linux/fs.h |    5 +++++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 460d87b..89e4feb 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -840,8 +840,20 @@ cifs_posix_lock_set(struct file *file, struct file_lock *flock)
 		mutex_unlock(&cinode->lock_mutex);
 		return rc;
 	}
-	rc = posix_lock_file_wait(file, flock);
-	mutex_unlock(&cinode->lock_mutex);
+
+	while (true) {
+		rc = posix_lock_file(file, flock, NULL);
+		mutex_unlock(&cinode->lock_mutex);
+		if (rc != FILE_LOCK_DEFERRED)
+			break;
+		rc = wait_event_interruptible(flock->fl_wait, !flock->fl_next);
+		if (rc) {
+			locks_delete_block(flock);
+			break;
+		}
+		mutex_lock(&cinode->lock_mutex);
+	}
+
 	return rc;
 }
 
diff --git a/fs/locks.c b/fs/locks.c
index 637694b..0d68f1f 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -510,12 +510,13 @@ static void __locks_delete_block(struct file_lock *waiter)
 
 /*
  */
-static void locks_delete_block(struct file_lock *waiter)
+void locks_delete_block(struct file_lock *waiter)
 {
 	lock_flocks();
 	__locks_delete_block(waiter);
 	unlock_flocks();
 }
+EXPORT_SYMBOL(locks_delete_block);
 
 /* Insert waiter into blocker's block list.
  * We use a circular list so that processes can be easily woken up in
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fa63f1b..d8fd8df 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1211,6 +1211,7 @@ extern int vfs_setlease(struct file *, long, struct file_lock **);
 extern int lease_modify(struct file_lock **, int);
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
+extern void locks_delete_block(struct file_lock *waiter);
 extern void lock_flocks(void);
 extern void unlock_flocks(void);
 #else /* !CONFIG_FILE_LOCKING */
@@ -1355,6 +1356,10 @@ static inline int lock_may_write(struct inode *inode, loff_t start,
 	return 1;
 }
 
+static inline void locks_delete_block(struct file_lock *waiter)
+{
+}
+
 static inline void lock_flocks(void)
 {
 }
-- 
1.7.1
