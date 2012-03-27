From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v3 2/5] CIFS: Convert lock type to 32 bit variable
Date: Tue, 27 Mar 2012 15:38:36 +0400
Message-ID: <1332848319-6483-3-git-send-email-piastry@etersoft.ru>
References: <1332848319-6483-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332848319-6483-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to handle SMB2 lock type field further.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/file.c     |   13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 4e095ae..16b5b19 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -547,7 +547,7 @@ struct cifsLockInfo {
 	__u64 offset;
 	__u64 length;
 	__u32 pid;
-	__u8 type;
+	__u32 type;
 };
 
 /*
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cc54033..2e541f0 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -965,7 +965,8 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 			cur->OffsetHigh = cpu_to_le32((u32)(li->offset>>32));
 			if (++num == max_num) {
 				stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
-						       li->type, 0, num, buf);
+						       (__u8)li->type, 0, num,
+						       buf);
 				if (stored_rc)
 					rc = stored_rc;
 				cur = buf;
@@ -976,7 +977,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 
 		if (num) {
 			stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
-					       types[i], 0, num, buf);
+					       (__u8)types[i], 0, num, buf);
 			if (stored_rc)
 				rc = stored_rc;
 		}
@@ -1120,7 +1121,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 }
 
 static void
-cifs_read_flock(struct file_lock *flock, __u8 *type, int *lock, int *unlock,
+cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
 		bool *wait_flag)
 {
 	if (flock->fl_flags & FL_POSIX)
@@ -1164,7 +1165,7 @@ cifs_read_flock(struct file_lock *flock, __u8 *type, int *lock, int *unlock,
 }
 
 static int
-cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
+cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 	   bool wait_flag, bool posix_lck, int xid)
 {
 	int rc = 0;
@@ -1352,7 +1353,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 }
 
 static int
-cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
+cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
 	   bool wait_flag, bool posix_lck, int lock, int unlock, int xid)
 {
 	int rc = 0;
@@ -1423,7 +1424,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	struct cifsInodeInfo *cinode;
 	struct cifsFileInfo *cfile;
 	__u16 netfid;
-	__u8 type;
+	__u32 type;
 
 	rc = -EACCES;
 	xid = GetXid();
-- 
1.7.1
