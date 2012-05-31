From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/2] CIFS: Fix possible wrong memory allocation
Date: Thu, 31 May 2012 14:44:03 +0400
Message-ID: <1338461044-6896-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

when cifs_reconnect sets maxBuf to 0 and we try to calculate a size
of memory we need to store locks.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 253170d..de8abb6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -876,7 +876,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	struct cifsLockInfo *li, *tmp;
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
-	unsigned int num, max_num;
+	unsigned int num, max_num, max_buf;
 	LOCKING_ANDX_RANGE *buf, *cur;
 	int types[] = {LOCKING_ANDX_LARGE_FILES,
 		       LOCKING_ANDX_SHARED_LOCK | LOCKING_ANDX_LARGE_FILES};
@@ -892,8 +892,19 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 		return rc;
 	}
 
-	max_num = (tcon->ses->server->maxBuf - sizeof(struct smb_hdr)) /
-		  sizeof(LOCKING_ANDX_RANGE);
+	/*
+	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
+	 * and check it for zero before using.
+	 */
+	max_buf = tcon->ses->server->maxBuf;
+	if (!max_buf) {
+		mutex_unlock(&cinode->lock_mutex);
+		FreeXid(xid);
+		return -EINVAL;
+	}
+
+	max_num = (max_buf - sizeof(struct smb_hdr)) /
+						sizeof(LOCKING_ANDX_RANGE);
 	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
 	if (!buf) {
 		mutex_unlock(&cinode->lock_mutex);
@@ -1218,7 +1229,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 	int types[] = {LOCKING_ANDX_LARGE_FILES,
 		       LOCKING_ANDX_SHARED_LOCK | LOCKING_ANDX_LARGE_FILES};
 	unsigned int i;
-	unsigned int max_num, num;
+	unsigned int max_num, num, max_buf;
 	LOCKING_ANDX_RANGE *buf, *cur;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
@@ -1228,8 +1239,16 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 
 	INIT_LIST_HEAD(&tmp_llist);
 
-	max_num = (tcon->ses->server->maxBuf - sizeof(struct smb_hdr)) /
-		  sizeof(LOCKING_ANDX_RANGE);
+	/*
+	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
+	 * and check it for zero before using.
+	 */
+	max_buf = tcon->ses->server->maxBuf;
+	if (!max_buf)
+		return -EINVAL;
+
+	max_num = (max_buf - sizeof(struct smb_hdr)) /
+						sizeof(LOCKING_ANDX_RANGE);
 	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-- 
1.7.1
