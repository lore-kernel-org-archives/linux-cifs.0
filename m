From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 3/5] CIFS: Implement cifs_relock_file
Date: Tue, 27 Nov 2012 10:50:26 +0400
Message-ID: <1353999029-3975-4-git-send-email-piastry@etersoft.ru>
References: <1353999029-3975-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353999029-3975-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that reacquires byte-range locks when a file is reopened.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cf67f8f..a18c9eb 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -508,16 +508,36 @@ out:
 	return rc;
 }
 
+static int cifs_push_posix_locks(struct cifsFileInfo *cfile);
+
 /*
  * Try to reacquire byte range locks that were released when session
- * to server was lost
+ * to server was lost.
  */
-static int cifs_relock_file(struct cifsFileInfo *cifsFile)
+static int
+cifs_relock_file(struct cifsFileInfo *cfile)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	int rc = 0;
 
-	/* BB list all locks open on this file and relock */
+	/* we are going to update can_cache_brlcks here - need a write access */
+	down_write(&cinode->lock_sem);
+	if (cinode->can_cache_brlcks) {
+		/* can cache locks - no need to push them */
+		up_write(&cinode->lock_sem);
+		return rc;
+	}
+
+	if (cap_unix(tcon->ses) &&
+	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
+	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+		rc = cifs_push_posix_locks(cfile);
+	else
+		rc = tcon->ses->server->ops->push_mand_locks(cfile);
 
+	up_write(&cinode->lock_sem);
 	return rc;
 }
 
-- 
1.7.10.4
