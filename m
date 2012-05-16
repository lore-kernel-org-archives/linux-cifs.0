From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v4 4/5] CIFS: Separate protocol specific part from getlk
Date: Wed, 16 May 2012 13:57:33 +0400
Message-ID: <1337162254-13121-5-git-send-email-piastry@etersoft.ru>
References: <1337162254-13121-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337162254-13121-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 ++
 fs/cifs/file.c     |   52 ++++++++++++++++++++++++++++++----------------------
 fs/cifs/smb1ops.c  |    7 +++++++
 3 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6943448..b6e97f8 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -156,10 +156,12 @@ enum smb_version {
 
 struct mid_q_entry;
 struct TCP_Server_Info;
+struct cifsFileInfo;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
 			   struct mid_q_entry *);
+	bool (*compare_fids)(struct cifsFileInfo *, struct cifsFileInfo *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ac71f85..9c2d85d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -671,7 +671,7 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
 
 static bool
 cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
-			    __u64 length, __u8 type, __u16 netfid,
+			    __u64 length, __u8 type, struct cifsFileInfo *cur,
 			    struct cifsLockInfo **conf_lock)
 {
 	struct cifsLockInfo *li;
@@ -682,8 +682,8 @@ cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
 		    offset >= li->offset + li->length)
 			continue;
 		else if ((type & server->vals->shared_lock_type) &&
-			 ((netfid == cfile->netfid && current->tgid == li->pid)
-			 || type == li->type))
+			 ((server->ops->compare_fids(cur, cfile) &&
+			   current->tgid == li->pid) || type == li->type))
 			continue;
 		else {
 			*conf_lock = li;
@@ -694,17 +694,17 @@ cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
 }
 
 static bool
-cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
-			__u64 length, __u8 type, __u16 netfid,
-			struct cifsLockInfo **conf_lock)
+cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
+			__u8 type, struct cifsLockInfo **conf_lock)
 {
 	bool rc = false;
 	struct cifsFileInfo *fid, *tmp;
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 
 	spin_lock(&cifs_file_list_lock);
 	list_for_each_entry_safe(fid, tmp, &cinode->openFileList, flist) {
 		rc = cifs_find_fid_lock_conflict(fid, offset, length, type,
-						 netfid, conf_lock);
+						 cfile, conf_lock);
 		if (rc)
 			break;
 	}
@@ -732,8 +732,8 @@ cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
 
 	mutex_lock(&cinode->lock_mutex);
 
-	exist = cifs_find_lock_conflict(cinode, offset, length, type,
-					cfile->netfid, &conf_lock);
+	exist = cifs_find_lock_conflict(cfile, offset, length, type,
+					&conf_lock);
 	if (exist) {
 		flock->fl_start = conf_lock->offset;
 		flock->fl_end = conf_lock->offset + conf_lock->length - 1;
@@ -779,8 +779,8 @@ try_again:
 	exist = false;
 	mutex_lock(&cinode->lock_mutex);
 
-	exist = cifs_find_lock_conflict(cinode, lock->offset, lock->length,
-					lock->type, cfile->netfid, &conf_lock);
+	exist = cifs_find_lock_conflict(cfile, lock->offset, lock->length,
+					lock->type, &conf_lock);
 	if (!exist && cinode->can_cache_brlcks) {
 		list_add_tail(&lock->llist, &cfile->llist);
 		mutex_unlock(&cinode->lock_mutex);
@@ -1117,6 +1117,15 @@ cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
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
@@ -1149,12 +1158,11 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
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
@@ -1167,13 +1175,13 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 		return 0;
 	}
 
-	rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
-			 flock->fl_start, 0, 1,
-			 type | server->vals->shared_lock_type, 0, 0);
+	rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length,
+				 type | server->vals->shared_lock_type, 1, 0,
+				 false);
 	if (rc == 0) {
-		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid,
-				 length, flock->fl_start, 1, 0,
-				 type | server->vals->shared_lock_type, 0, 0);
+		rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length,
+					 type | server->vals->shared_lock_type,
+					 0, 1, false);
 		flock->fl_type = F_RDLCK;
 		if (rc != 0)
 			cERROR(1, "Error unlocking previously locked "
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index af48a8b..7565587 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -60,8 +60,15 @@ send_nt_cancel(struct TCP_Server_Info *server, void *buf,
 	return rc;
 }
 
+static inline bool
+cifs_compare_fids(struct cifsFileInfo *ob1, struct cifsFileInfo *ob2)
+{
+	return ob1->netfid == ob2->netfid;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
+	.compare_fids = cifs_compare_fids,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
