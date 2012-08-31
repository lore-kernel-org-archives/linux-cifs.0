From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/7] CIFS: Move brlock code to ops struct
Date: Fri, 31 Aug 2012 13:41:23 +0400
Message-ID: <1346406088-4537-3-git-send-email-pshilovsky@etersoft.ru>
References: <1346406088-4537-1-git-send-email-pshilovsky@etersoft.ru>
Cc: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346406088-4537-1-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    8 ++++++++
 fs/cifs/cifsproto.h |    3 +++
 fs/cifs/file.c      |   42 +++++++++++++++++-------------------------
 fs/cifs/smb1ops.c   |   12 ++++++++++++
 4 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b2eb577..d3c7271 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -353,6 +353,14 @@ struct smb_version_operations {
 	/* query remote filesystem */
 	int (*queryfs)(const unsigned int, struct cifs_tcon *,
 		       struct kstatfs *);
+	/* send mandatory brlock to the server */
+	int (*mand_lock)(const unsigned int, struct cifsFileInfo *, __u64,
+			 __u64, __u32, int, int, bool);
+	/* unlock range of mandatory locks */
+	int (*mand_unlock_range)(struct cifsFileInfo *, struct file_lock *,
+				 const unsigned int);
+	/* push brlocks from the cache to the server */
+	int (*push_mand_locks)(struct cifsFileInfo *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 3b628f2..a7e238f 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -124,6 +124,9 @@ extern u64 cifs_UnixTimeToNT(struct timespec);
 extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 				      int offset);
 extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
+extern int cifs_unlock_range(struct cifsFileInfo *cfile,
+			     struct file_lock *flock, const unsigned int xid);
+extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
 
 extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
 					      struct file *file,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6787b7f..fc65f07 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -903,7 +903,7 @@ try_again:
 	return rc;
 }
 
-static int
+int
 cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 {
 	unsigned int xid;
@@ -1111,7 +1111,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		return cifs_push_posix_locks(cfile);
 
-	return cifs_push_mandatory_locks(cfile);
+	return tcon->ses->server->ops->push_mand_locks(cfile);
 }
 
 static void
@@ -1162,15 +1162,6 @@ cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
 }
 
 static int
-cifs_mandatory_lock(unsigned int xid, struct cifsFileInfo *cfile, __u64 offset,
-		    __u64 length, __u32 type, int lock, int unlock, bool wait)
-{
-	return CIFSSMBLock(xid, tlink_tcon(cfile->tlink), cfile->fid.netfid,
-			   current->tgid, length, offset, unlock, lock,
-			   (__u8)type, wait, 0);
-}
-
-static int
 cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 	   bool wait_flag, bool posix_lck, unsigned int xid)
 {
@@ -1203,11 +1194,11 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 		return rc;
 
 	/* BB we could chain these into one lock request BB */
-	rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length, type,
-				 1, 0, false);
+	rc = server->ops->mand_lock(xid, cfile, flock->fl_start, length, type,
+				    1, 0, false);
 	if (rc == 0) {
-		rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length,
-					 type, 0, 1, false);
+		rc = server->ops->mand_lock(xid, cfile, flock->fl_start, length,
+					    type, 0, 1, false);
 		flock->fl_type = F_UNLCK;
 		if (rc != 0)
 			cERROR(1, "Error unlocking previously locked "
@@ -1220,13 +1211,14 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 		return 0;
 	}
 
-	rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length,
-				 type | server->vals->shared_lock_type, 1, 0,
-				 false);
+	type &= ~server->vals->exclusive_lock_type;
+
+	rc = server->ops->mand_lock(xid, cfile, flock->fl_start, length,
+				    type | server->vals->shared_lock_type,
+				    1, 0, false);
 	if (rc == 0) {
-		rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length,
-					 type | server->vals->shared_lock_type,
-					 0, 1, false);
+		rc = server->ops->mand_lock(xid, cfile, flock->fl_start, length,
+			type | server->vals->shared_lock_type, 0, 1, false);
 		flock->fl_type = F_RDLCK;
 		if (rc != 0)
 			cERROR(1, "Error unlocking previously locked "
@@ -1256,7 +1248,7 @@ cifs_free_llist(struct list_head *llist)
 	}
 }
 
-static int
+int
 cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 		  unsigned int xid)
 {
@@ -1408,8 +1400,8 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 		if (rc <= 0)
 			goto out;
 
-		rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length,
-					 type, 1, 0, wait_flag);
+		rc = server->ops->mand_lock(xid, cfile, flock->fl_start, length,
+					    type, 1, 0, wait_flag);
 		if (rc) {
 			kfree(lock);
 			goto out;
@@ -1417,7 +1409,7 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 
 		cifs_lock_add(cfile, lock);
 	} else if (unlock)
-		rc = cifs_unlock_range(cfile, flock, xid);
+		rc = server->ops->mand_unlock_range(cfile, flock, xid);
 
 out:
 	if (flock->fl_flags & FL_POSIX)
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index ed7f955..5fb0fe5 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -899,6 +899,15 @@ cifs_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static int
+cifs_mand_lock(const unsigned int xid, struct cifsFileInfo *cfile, __u64 offset,
+	       __u64 length, __u32 type, int lock, int unlock, bool wait)
+{
+	return CIFSSMBLock(xid, tlink_tcon(cfile->tlink), cfile->fid.netfid,
+			   current->tgid, length, offset, unlock, lock,
+			   (__u8)type, wait, 0);
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -960,6 +969,9 @@ struct smb_version_operations smb1_operations = {
 	.calc_smb_size = smbCalcSize,
 	.oplock_response = cifs_oplock_response,
 	.queryfs = cifs_queryfs,
+	.mand_lock = cifs_mand_lock,
+	.mand_unlock_range = cifs_unlock_range,
+	.push_mand_locks = cifs_push_mandatory_locks,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
