From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/2] CIFS: Convert lock type to 32 bit variable
Date: Sat, 31 Mar 2012 00:25:02 +0400
Message-ID: <1333139102-8265-2-git-send-email-piastry@etersoft.ru>
References: <1333139102-8265-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1333139102-8265-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to handle SMB2 lock type field further.

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/file.c     |   13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index de1a80d..cd7cf2b 100644
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
index f258373..a39f73f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -912,7 +912,8 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 			cur->OffsetHigh = cpu_to_le32((u32)(li->offset>>32));
 			if (++num == max_num) {
 				stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
-						       li->type, 0, num, buf);
+						       (__u8)li->type, 0, num,
+						       buf);
 				if (stored_rc)
 					rc = stored_rc;
 				cur = buf;
@@ -923,7 +924,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 
 		if (num) {
 			stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
-					       types[i], 0, num, buf);
+					       (__u8)types[i], 0, num, buf);
 			if (stored_rc)
 				rc = stored_rc;
 		}
@@ -1067,7 +1068,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 }
 
 static void
-cifs_read_flock(struct file_lock *flock, __u8 *type, int *lock, int *unlock,
+cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
 		bool *wait_flag)
 {
 	if (flock->fl_flags & FL_POSIX)
@@ -1111,7 +1112,7 @@ cifs_read_flock(struct file_lock *flock, __u8 *type, int *lock, int *unlock,
 }
 
 static int
-cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
+cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 	   bool wait_flag, bool posix_lck, int xid)
 {
 	int rc = 0;
@@ -1299,7 +1300,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 }
 
 static int
-cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
+cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
 	   bool wait_flag, bool posix_lck, int lock, int unlock, int xid)
 {
 	int rc = 0;
@@ -1370,7 +1371,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	struct cifsInodeInfo *cinode;
 	struct cifsFileInfo *cfile;
 	__u16 netfid;
-	__u8 type;
+	__u32 type;
 
 	rc = -EACCES;
 	xid = GetXid();
-- 
1.7.1
