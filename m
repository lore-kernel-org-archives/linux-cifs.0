From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/5] CIFS: Separate pushing mandatory locks and lock_sem handling
Date: Tue, 27 Nov 2012 10:50:25 +0400
Message-ID: <1353999029-3975-3-git-send-email-piastry@etersoft.ru>
References: <1353999029-3975-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353999029-3975-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c     |   39 ++++++++++-----------------------------
 fs/cifs/smb2file.c |   12 ------------
 2 files changed, 10 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 54541a6..cf67f8f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -954,7 +954,6 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	int rc = 0, stored_rc;
 	struct cifsLockInfo *li, *tmp;
 	struct cifs_tcon *tcon;
-	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	unsigned int num, max_num, max_buf;
 	LOCKING_ANDX_RANGE *buf, *cur;
 	int types[] = {LOCKING_ANDX_LARGE_FILES,
@@ -964,21 +963,12 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	xid = get_xid();
 	tcon = tlink_tcon(cfile->tlink);
 
-	/* we are going to update can_cache_brlcks here - need a write access */
-	down_write(&cinode->lock_sem);
-	if (!cinode->can_cache_brlcks) {
-		up_write(&cinode->lock_sem);
-		free_xid(xid);
-		return rc;
-	}
-
 	/*
 	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
 	 * and check it for zero before using.
 	 */
 	max_buf = tcon->ses->server->maxBuf;
 	if (!max_buf) {
-		up_write(&cinode->lock_sem);
 		free_xid(xid);
 		return -EINVAL;
 	}
@@ -987,7 +977,6 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 						sizeof(LOCKING_ANDX_RANGE);
 	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
 	if (!buf) {
-		up_write(&cinode->lock_sem);
 		free_xid(xid);
 		return -ENOMEM;
 	}
@@ -1024,9 +1013,6 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 		}
 	}
 
-	cinode->can_cache_brlcks = false;
-	up_write(&cinode->lock_sem);
-
 	kfree(buf);
 	free_xid(xid);
 	return rc;
@@ -1047,7 +1033,7 @@ struct lock_to_push {
 };
 
 static int
-cifs_push_posix_locks_locked(struct cifsFileInfo *cfile)
+cifs_push_posix_locks(struct cifsFileInfo *cfile)
 {
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct file_lock *flock, **before;
@@ -1135,9 +1121,11 @@ err_out:
 }
 
 static int
-cifs_push_posix_locks(struct cifsFileInfo *cfile)
+cifs_push_locks(struct cifsFileInfo *cfile)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	int rc = 0;
 
 	/* we are going to update can_cache_brlcks here - need a write access */
@@ -1146,24 +1134,17 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 		up_write(&cinode->lock_sem);
 		return rc;
 	}
-	rc = cifs_push_posix_locks_locked(cfile);
-	cinode->can_cache_brlcks = false;
-	up_write(&cinode->lock_sem);
-	return rc;
-}
-
-static int
-cifs_push_locks(struct cifsFileInfo *cfile)
-{
-	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
-	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
 	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
-		return cifs_push_posix_locks(cfile);
+		rc = cifs_push_posix_locks(cfile);
+	else
+		rc = tcon->ses->server->ops->push_mand_locks(cfile);
 
-	return tcon->ses->server->ops->push_mand_locks(cfile);
+	cinode->can_cache_brlcks = false;
+	up_write(&cinode->lock_sem);
+	return rc;
 }
 
 static void
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index bfe22e8..7dfb50c 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -260,13 +260,6 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	struct cifs_fid_locks *fdlocks;
 
 	xid = get_xid();
-	/* we are going to update can_cache_brlcks here - need a write access */
-	down_write(&cinode->lock_sem);
-	if (!cinode->can_cache_brlcks) {
-		up_write(&cinode->lock_sem);
-		free_xid(xid);
-		return rc;
-	}
 
 	/*
 	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
@@ -274,7 +267,6 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	 */
 	max_buf = tlink_tcon(cfile->tlink)->ses->server->maxBuf;
 	if (!max_buf) {
-		up_write(&cinode->lock_sem);
 		free_xid(xid);
 		return -EINVAL;
 	}
@@ -282,7 +274,6 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	max_num = max_buf / sizeof(struct smb2_lock_element);
 	buf = kzalloc(max_num * sizeof(struct smb2_lock_element), GFP_KERNEL);
 	if (!buf) {
-		up_write(&cinode->lock_sem);
 		free_xid(xid);
 		return -ENOMEM;
 	}
@@ -293,10 +284,7 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 			rc = stored_rc;
 	}
 
-	cinode->can_cache_brlcks = false;
 	kfree(buf);
-
-	up_write(&cinode->lock_sem);
 	free_xid(xid);
 	return rc;
 }
-- 
1.7.10.4
