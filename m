From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 14/17] CIFS: Convert lock type to 32 bit variable
Date: Sat,  3 Mar 2012 12:37:15 +0300
Message-ID: <1330767438-19469-15-git-send-email-piastry@etersoft.ru>
References: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330767438-19469-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to handle SMB2 lock type field further.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h |    3 +--
 fs/cifs/file.c     |   13 +++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e5179d4..0097973 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -552,8 +552,7 @@ struct cifsLockInfo {
 	__u64 offset;
 	__u64 length;
 	__u32 pid;
-	__u8 type;
-	__u16 netfid;
+	__u32 type;
 };
 
 /*
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 69b8050..469bf2d 100644
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
@@ -1115,7 +1116,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 }
 
 static void
-cifs_read_flock(struct file_lock *flock, __u8 *type, int *lock, int *unlock,
+cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
 		bool *wait_flag)
 {
 	if (flock->fl_flags & FL_POSIX)
@@ -1159,7 +1160,7 @@ cifs_read_flock(struct file_lock *flock, __u8 *type, int *lock, int *unlock,
 }
 
 static int
-cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
+cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 	   bool wait_flag, bool posix_lck, int xid)
 {
 	int rc = 0;
@@ -1347,7 +1348,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 }
 
 static int
-cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
+cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
 	   bool wait_flag, bool posix_lck, int lock, int unlock, int xid)
 {
 	int rc = 0;
@@ -1418,7 +1419,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	struct cifsInodeInfo *cinode;
 	struct cifsFileInfo *cfile;
 	__u16 netfid;
-	__u8 type;
+	__u32 type;
 
 	rc = -EACCES;
 	xid = GetXid();
-- 
1.7.1
