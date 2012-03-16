From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 5/6] CIFS: Separate protocol specific part from getlk
Date: Fri, 16 Mar 2012 18:17:51 +0300
Message-ID: <1331911072-1078-6-git-send-email-piastry@etersoft.ru>
References: <1331911072-1078-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331911072-1078-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   61 ++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0f69c76..86f112e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -708,9 +708,15 @@ unlock_lock_type(void)
 	return 0;
 }
 
+static inline bool
+compare_fids(struct cifsFileInfo *ob1, struct cifsFileInfo *ob2)
+{
+	return ob1->netfid == ob2->netfid;
+}
+
 static bool
 __cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
-			      __u64 length, __u8 type, __u16 netfid,
+			      __u64 length, __u8 type, struct cifsFileInfo *cur,
 			      struct cifsLockInfo **conf_lock)
 {
 	struct cifsLockInfo *li, *tmp;
@@ -720,7 +726,7 @@ __cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
 		    offset >= li->offset + li->length)
 			continue;
 		else if ((type & shared_lock_type()) &&
-			 ((netfid == cfile->netfid && current->tgid == li->pid)
+			 ((compare_fids(cur, cfile) && current->tgid == li->pid)
 			 || type == li->type))
 			continue;
 		else {
@@ -732,19 +738,20 @@ __cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
 }
 
 static bool
-__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
-			  __u64 length, __u8 type, __u16 netfid,
+__cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
+			  __u64 length, __u8 type,
 			  struct cifsLockInfo **conf_lock)
 {
 	bool rc;
 	struct cifsFileInfo *fid, *tmp;
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 
 	spin_lock(&cifs_file_list_lock);
 	list_for_each_entry_safe(fid, tmp, &cinode->openFileList, flist) {
 		cifsFileInfo_get(fid);
 		spin_unlock(&cifs_file_list_lock);
 		rc = __cifs_find_fid_lock_conflict(fid, offset, length, type,
-						   netfid, conf_lock);
+						   cfile, conf_lock);
 		cifsFileInfo_put(fid);
 		if (rc)
 			return rc;
@@ -756,12 +763,12 @@ __cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
 }
 
 static bool
-cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
-			__u16 netfid, struct cifsLockInfo **conf_lock)
+cifs_find_lock_conflict(struct cifsFileInfo *cfile, struct cifsLockInfo *lock,
+			struct cifsLockInfo **conf_lock)
 {
 
-	return __cifs_find_lock_conflict(cinode, lock->offset, lock->length,
-					 lock->type, netfid, conf_lock);
+	return __cifs_find_lock_conflict(cfile, lock->offset, lock->length,
+					 lock->type, conf_lock);
 }
 
 /*
@@ -782,8 +789,8 @@ cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
 
 	mutex_lock(&cinode->lock_mutex);
 
-	exist = __cifs_find_lock_conflict(cinode, offset, length, type,
-					  cfile->netfid, &conf_lock);
+	exist = __cifs_find_lock_conflict(cfile, offset, length, type,
+					  &conf_lock);
 	if (exist) {
 		flock->fl_start = conf_lock->offset;
 		flock->fl_end = conf_lock->offset + conf_lock->length - 1;
@@ -829,8 +836,7 @@ try_again:
 	exist = false;
 	mutex_lock(&cinode->lock_mutex);
 
-	exist = cifs_find_lock_conflict(cinode, lock, cfile->netfid,
-					&conf_lock);
+	exist = cifs_find_lock_conflict(cfile, lock, &conf_lock);
 	if (!exist && cinode->can_cache_brlcks) {
 		list_add_tail(&lock->llist, &cfile->llist);
 		mutex_unlock(&cinode->lock_mutex);
@@ -1191,6 +1197,15 @@ cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
 }
 
 static int
+cifs_mandatory_lock(int xid, struct cifsFileInfo *cfile, __u64 offset,
+		    __u64 length, __u32 type, int lock, int unlock, bool wait)
+{
+	return CIFSSMBLock(xid, tlink_tcon(cfile->tlink), cfile->netfid,
+			   current->tgid, length, offset, unlock, lock,
+			   (__u8)type, wait, 0);
+}
+
+static int
 cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 	   bool wait_flag, bool posix_lck, int xid)
 {
@@ -1222,12 +1237,11 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 		return rc;
 
 	/* BB we could chain these into one lock request BB */
-	rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
-			 flock->fl_start, 0, 1, type, 0, 0);
+	rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length, type,
+				 1, 0, false);
 	if (rc == 0) {
-		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid,
-				 length, flock->fl_start, 1, 0,
-				 type, 0, 0);
+		rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length,
+					 type, 0, 1, false);
 		flock->fl_type = F_UNLCK;
 		if (rc != 0)
 			cERROR(1, "Error unlocking previously locked "
@@ -1240,13 +1254,12 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 		return 0;
 	}
 
-	rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
-			 flock->fl_start, 0, 1,
-			 type | shared_lock_type(), 0, 0);
+	rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length,
+				 type | shared_lock_type(), 1, 0, false);
 	if (rc == 0) {
-		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid,
-				 length, flock->fl_start, 1, 0,
-				 type | shared_lock_type(), 0, 0);
+		rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length,
+					 type | shared_lock_type(), 0, 1,
+					 false);
 		flock->fl_type = F_RDLCK;
 		if (rc != 0)
 			cERROR(1, "Error unlocking previously locked "
-- 
1.7.1
