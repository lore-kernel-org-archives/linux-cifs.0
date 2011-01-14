From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: Fix oplock break handling
Date: Fri, 14 Jan 2011 20:52:41 +0300
Message-ID: <1295027561-24077-1-git-send-email-piastryyy@gmail.com>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When we get oplock break notification we should set the appropriate
value of OplockLevel field in oplock break acknowledge according to
the oplock level held by the client in this time. As we only can have
level II oplock or no oplock in the case of oplock break, we should be
aware only about clientCanCacheRead field in cifsInodeInfo structure.

Also fix bug connected with wrong interpretation of OplockLevel field
during oplock break notification processing.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/cifssmb.c   |    4 +++-
 fs/cifs/file.c      |   21 +++++++++++----------
 fs/cifs/misc.c      |    2 +-
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e6d1481..95d5dbb 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -347,7 +347,7 @@ extern int CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 			const __u16 netfid, const __u64 len,
 			const __u64 offset, const __u32 numUnlock,
 			const __u32 numLock, const __u8 lockType,
-			const bool waitFlag);
+			const bool waitFlag, const __u8 oplock_level);
 extern int CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 			const __u16 smb_file_id, const int get_flag,
 			const __u64 len, struct file_lock *,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 2f6795e..3652cc6 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1663,7 +1663,8 @@ int
 CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	    const __u16 smb_file_id, const __u64 len,
 	    const __u64 offset, const __u32 numUnlock,
-	    const __u32 numLock, const __u8 lockType, const bool waitFlag)
+	    const __u32 numLock, const __u8 lockType,
+	    const bool waitFlag, const __u8 oplock_level)
 {
 	int rc = 0;
 	LOCK_REQ *pSMB = NULL;
@@ -1691,6 +1692,7 @@ CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	pSMB->NumberOfLocks = cpu_to_le16(numLock);
 	pSMB->NumberOfUnlocks = cpu_to_le16(numUnlock);
 	pSMB->LockType = lockType;
+	pSMB->OplockLevel = oplock_level;
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = smb_file_id; /* netfid stays le */
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d843631..7e83cdb 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -726,12 +726,12 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 
 		/* BB we could chain these into one lock request BB */
 		rc = CIFSSMBLock(xid, tcon, netfid, length, pfLock->fl_start,
-				 0, 1, lockType, 0 /* wait flag */ );
+				 0, 1, lockType, 0 /* wait flag */, 0);
 		if (rc == 0) {
 			rc = CIFSSMBLock(xid, tcon, netfid, length,
 					 pfLock->fl_start, 1 /* numUnlock */ ,
 					 0 /* numLock */ , lockType,
-					 0 /* wait flag */ );
+					 0 /* wait flag */, 0);
 			pfLock->fl_type = F_UNLCK;
 			if (rc != 0)
 				cERROR(1, "Error unlocking previously locked "
@@ -748,13 +748,13 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 				rc = CIFSSMBLock(xid, tcon, netfid, length,
 					pfLock->fl_start, 0, 1,
 					lockType | LOCKING_ANDX_SHARED_LOCK,
-					0 /* wait flag */);
+					0 /* wait flag */, 0);
 				if (rc == 0) {
 					rc = CIFSSMBLock(xid, tcon, netfid,
 						length, pfLock->fl_start, 1, 0,
 						lockType |
 						LOCKING_ANDX_SHARED_LOCK,
-						0 /* wait flag */);
+						0 /* wait flag */, 0);
 					pfLock->fl_type = F_RDLCK;
 					if (rc != 0)
 						cERROR(1, "Error unlocking "
@@ -797,8 +797,8 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 
 		if (numLock) {
 			rc = CIFSSMBLock(xid, tcon, netfid, length,
-					pfLock->fl_start,
-					0, numLock, lockType, wait_flag);
+					 pfLock->fl_start, 0, numLock, lockType,
+					 wait_flag, 0);
 
 			if (rc == 0) {
 				/* For Windows locks we must store them. */
@@ -818,9 +818,9 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 						(pfLock->fl_start + length) >=
 						(li->offset + li->length)) {
 					stored_rc = CIFSSMBLock(xid, tcon,
-							netfid,
-							li->length, li->offset,
-							1, 0, li->type, false);
+							netfid, li->length,
+							li->offset, 1, 0,
+							li->type, false, 0);
 					if (stored_rc)
 						rc = stored_rc;
 					else {
@@ -2192,7 +2192,8 @@ void cifs_oplock_break(struct work_struct *work)
 	 */
 	if (!cfile->oplock_break_cancelled) {
 		rc = CIFSSMBLock(0, tlink_tcon(cfile->tlink), cfile->netfid, 0,
-				 0, 0, 0, LOCKING_ANDX_OPLOCK_RELEASE, false);
+				 0, 0, 0, LOCKING_ANDX_OPLOCK_RELEASE, false,
+				 cinode->clientCanCacheRead);
 		cFYI(1, "Oplock release rc = %d", rc);
 	}
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 43f1028..09bfcf0 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -571,7 +571,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				pCifsInode = CIFS_I(netfile->dentry->d_inode);
 
 				cifs_set_oplock_level(pCifsInode,
-						      pSMB->OplockLevel);
+					pSMB->OplockLevel ? OPLOCK_READ : 0);
 				/*
 				 * cifs_oplock_break_put() can't be called
 				 * from here.  Get reference after queueing
-- 
1.7.1
