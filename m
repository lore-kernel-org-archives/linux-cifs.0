From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: move file_lock off stack in cifs_push_posix_locks
Date: Mon, 23 Jul 2012 13:31:28 -0400
Message-ID: <1343064688-26053-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

struct file_lock is pretty large, so we really don't want that on the
stack in a potentially long call chain. Reorganize the arguments to
CIFSSMBPosixLock to eliminate the need for that.

Eliminate the get_flag and simply use a non-NULL pLockInfo to indicate
that this is a "get" operation. In order to do that, need to add a new
loff_t argument for the start_offset.

Reported-by: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    5 +++--
 fs/cifs/cifssmb.c   |   16 +++++++---------
 fs/cifs/file.c      |    8 +++-----
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 0a6cbfe..baa1b6d 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -386,8 +386,9 @@ extern int CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 			const bool waitFlag, const __u8 oplock_level);
 extern int CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
 			const __u16 smb_file_id, const __u32 netpid,
-			const int get_flag, const __u64 len, struct file_lock *,
-			const __u16 lock_type, const bool waitFlag);
+			const loff_t start_offset, const __u64 len,
+			struct file_lock *, const __u16 lock_type,
+			const bool waitFlag);
 extern int CIFSSMBTDis(const int xid, struct cifs_tcon *tcon);
 extern int CIFSSMBEcho(struct TCP_Server_Info *server);
 extern int CIFSSMBLogoff(const int xid, struct cifs_ses *ses);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 684a072..5659850 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2356,9 +2356,10 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 
 int
 CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
-		const __u16 smb_file_id, const __u32 netpid, const int get_flag,
-		const __u64 len, struct file_lock *pLockData,
-		const __u16 lock_type, const bool waitFlag)
+		const __u16 smb_file_id, const __u32 netpid,
+		const loff_t start_offset, const __u64 len,
+		struct file_lock *pLockData, const __u16 lock_type,
+		const bool waitFlag)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
 	struct smb_com_transaction2_sfi_rsp *pSMBr = NULL;
@@ -2372,9 +2373,6 @@ CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
 
 	cFYI(1, "Posix Lock");
 
-	if (pLockData == NULL)
-		return -EINVAL;
-
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -2395,7 +2393,7 @@ CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
 	pSMB->MaxDataCount = cpu_to_le16(1000); /* BB find max SMB from sess */
 	pSMB->SetupCount = 1;
 	pSMB->Reserved3 = 0;
-	if (get_flag)
+	if (pLockData)
 		pSMB->SubCommand = cpu_to_le16(TRANS2_QUERY_FILE_INFORMATION);
 	else
 		pSMB->SubCommand = cpu_to_le16(TRANS2_SET_FILE_INFORMATION);
@@ -2417,7 +2415,7 @@ CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
 		pSMB->Timeout = 0;
 
 	parm_data->pid = cpu_to_le32(netpid);
-	parm_data->start = cpu_to_le64(pLockData->fl_start);
+	parm_data->start = cpu_to_le64(start_offset);
 	parm_data->length = cpu_to_le64(len);  /* normalize negative numbers */
 
 	pSMB->DataOffset = cpu_to_le16(offset);
@@ -2441,7 +2439,7 @@ CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
 
 	if (rc) {
 		cFYI(1, "Send error in Posix Lock = %d", rc);
-	} else if (get_flag) {
+	} else if (pLockData) {
 		/* lock structure can be returned on get */
 		__u16 data_offset;
 		__u16 data_count;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index dd28caa..e9a8ac0 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1039,12 +1039,10 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 	unlock_flocks();
 
 	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
-		struct file_lock tmp_lock;
 		int stored_rc;
 
-		tmp_lock.fl_start = lck->offset;
 		stored_rc = CIFSSMBPosixLock(xid, tcon, lck->netfid, lck->pid,
-					     0, lck->length, &tmp_lock,
+					     lck->offset, lck->length, NULL,
 					     lck->type, 0);
 		if (stored_rc)
 			rc = stored_rc;
@@ -1159,7 +1157,7 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 		else
 			posix_lock_type = CIFS_WRLCK;
 		rc = CIFSSMBPosixLock(xid, tcon, netfid, current->tgid,
-				      1 /* get */, length, flock,
+				      flock->fl_start, length, flock,
 				      posix_lock_type, wait_flag);
 		return rc;
 	}
@@ -1353,7 +1351,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
 			posix_lock_type = CIFS_UNLCK;
 
 		rc = CIFSSMBPosixLock(xid, tcon, netfid, current->tgid,
-				      0 /* set */, length, flock,
+				      flock->fl_start, length, NULL,
 				      posix_lock_type, wait_flag);
 		goto out;
 	}
-- 
1.7.10.4
