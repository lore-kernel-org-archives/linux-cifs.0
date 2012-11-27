From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 1/5] CIFS: Separate pushing posix locks and lock_sem handling
Date: Tue, 27 Nov 2012 10:50:24 +0400
Message-ID: <1353999029-3975-2-git-send-email-piastry@etersoft.ru>
References: <1353999029-3975-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353999029-3975-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index be0c3ea..54541a6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1047,9 +1047,8 @@ struct lock_to_push {
 };
 
 static int
-cifs_push_posix_locks(struct cifsFileInfo *cfile)
+cifs_push_posix_locks_locked(struct cifsFileInfo *cfile)
 {
-	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct file_lock *flock, **before;
 	unsigned int count = 0, i = 0;
@@ -1060,14 +1059,6 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 
 	xid = get_xid();
 
-	/* we are going to update can_cache_brlcks here - need a write access */
-	down_write(&cinode->lock_sem);
-	if (!cinode->can_cache_brlcks) {
-		up_write(&cinode->lock_sem);
-		free_xid(xid);
-		return rc;
-	}
-
 	lock_flocks();
 	cifs_for_each_lock(cfile->dentry->d_inode, before) {
 		if ((*before)->fl_flags & FL_POSIX)
@@ -1133,9 +1124,6 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 	}
 
 out:
-	cinode->can_cache_brlcks = false;
-	up_write(&cinode->lock_sem);
-
 	free_xid(xid);
 	return rc;
 err_out:
@@ -1147,6 +1135,24 @@ err_out:
 }
 
 static int
+cifs_push_posix_locks(struct cifsFileInfo *cfile)
+{
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
+	int rc = 0;
+
+	/* we are going to update can_cache_brlcks here - need a write access */
+	down_write(&cinode->lock_sem);
+	if (!cinode->can_cache_brlcks) {
+		up_write(&cinode->lock_sem);
+		return rc;
+	}
+	rc = cifs_push_posix_locks_locked(cfile);
+	cinode->can_cache_brlcks = false;
+	up_write(&cinode->lock_sem);
+	return rc;
+}
+
+static int
 cifs_push_locks(struct cifsFileInfo *cfile)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
-- 
1.7.10.4
