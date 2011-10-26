From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 1/2] CIFS: Use the vfs brlock cache for posix locking in FL_POSIX case only
Date: Wed, 26 Oct 2011 23:26:47 +0400
Message-ID: <1319657208-15659-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and simplify the error handling.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a43856a..6bf14ed 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -920,6 +920,9 @@ cifs_posix_lock_test(struct file *file, struct file_lock *flock)
 	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
 	unsigned char saved_type = flock->fl_type;
 
+	if ((flock->fl_flags & FL_POSIX) == 0)
+		return 1;
+
 	mutex_lock(&cinode->lock_mutex);
 	posix_test_lock(file, flock);
 
@@ -936,12 +939,15 @@ static int
 cifs_posix_lock_set(struct file *file, struct file_lock *flock)
 {
 	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
-	int rc;
+	int rc = 1;
+
+	if ((flock->fl_flags & FL_POSIX) == 0)
+		return rc;
 
 	mutex_lock(&cinode->lock_mutex);
 	if (!cinode->can_cache_brlcks) {
 		mutex_unlock(&cinode->lock_mutex);
-		return 1;
+		return rc;
 	}
 	rc = posix_lock_file_wait(file, flock);
 	mutex_unlock(&cinode->lock_mutex);
@@ -1371,7 +1377,18 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 		rc = CIFSSMBPosixLock(xid, tcon, netfid, current->tgid,
 				      0 /* set */, length, flock,
 				      posix_lock_type, wait_flag);
-		goto out;
+		if (rc)
+			return rc;
+
+		if (flock->fl_flags & FL_POSIX) {
+			rc = posix_lock_file_wait(file, flock);
+			if (rc)
+				cERROR(1, "Error occurs in posix_lock_file_wait"
+					  " after we send the request to the "
+					  "server");
+		}
+
+		return rc;
 	}
 
 	if (lock) {
-- 
1.7.1
