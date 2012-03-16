From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 2/6] CIFS: Fix VFS locks usage
Date: Fri, 16 Mar 2012 18:17:48 +0300
Message-ID: <1331911072-1078-3-git-send-email-piastry@etersoft.ru>
References: <1331911072-1078-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331911072-1078-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Surround VFS posix_lock_file_wait calls with CIFS lock_mutex
where it needs.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 17dae68..eeb1ba5 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -669,6 +669,21 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
 	}
 }
 
+/*
+ * Copied from fs/locks.c with small changes.
+ * Remove waiter from blocker's block list.
+ * When blocker ends up pointing to itself then the list is empty.
+ */
+static void
+cifs_locks_delete_block(struct file_lock *waiter)
+{
+	lock_flocks();
+	list_del_init(&waiter->fl_block);
+	list_del_init(&waiter->fl_link);
+	waiter->fl_next = NULL;
+	unlock_flocks();
+}
+
 static bool
 __cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
 			      __u64 length, __u8 type, __u16 netfid,
@@ -847,6 +862,39 @@ cifs_posix_lock_test(struct file *file, struct file_lock *flock)
 	return rc;
 }
 
+/* Called with locked lock_mutex, return with unlocked. */
+static int
+cifs_posix_lock_file_wait_locked(struct file *file, struct file_lock *flock)
+{
+	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
+	int rc;
+
+	while (true) {
+		rc = posix_lock_file(file, flock, NULL);
+		mutex_unlock(&cinode->lock_mutex);
+		if (rc != FILE_LOCK_DEFERRED)
+			break;
+		rc = wait_event_interruptible(flock->fl_wait, !flock->fl_next);
+		if (!rc) {
+			mutex_lock(&cinode->lock_mutex);
+			continue;
+		}
+		cifs_locks_delete_block(flock);
+		break;
+	}
+	return rc;
+}
+
+static int
+cifs_posix_lock_file_wait(struct file *file, struct file_lock *flock)
+{
+	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
+
+	mutex_unlock(&cinode->lock_mutex);
+	/* lock_mutex will be released by the function below */
+	return cifs_posix_lock_file_wait_locked(file, flock);
+}
+
 /*
  * Set the byte-range lock (posix style). Returns:
  * 1) 0, if we set the lock and don't need to request to the server;
@@ -867,9 +915,9 @@ cifs_posix_lock_set(struct file *file, struct file_lock *flock)
 		mutex_unlock(&cinode->lock_mutex);
 		return rc;
 	}
-	rc = posix_lock_file_wait(file, flock);
-	mutex_unlock(&cinode->lock_mutex);
-	return rc;
+
+	/* lock_mutex will be released by the function below */
+	return cifs_posix_lock_file_wait_locked(file, flock);
 }
 
 static int
@@ -1359,7 +1407,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 
 out:
 	if (flock->fl_flags & FL_POSIX)
-		posix_lock_file_wait(file, flock);
+		cifs_posix_lock_file_wait(file, flock);
 	return rc;
 }
 
-- 
1.7.1
