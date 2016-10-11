From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] CIFS: Fix tcon and file locking
Date: Tue, 11 Oct 2016 15:34:05 -0700
Message-ID: <1476225247-30177-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

This fix is supposed to be squashed into
"Clarify locking of cifs file and tcon structures and make more granular".

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/file.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1e7c625..20801dc 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -318,14 +318,14 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 		oplock = 0;
 	}
 
+	spin_lock(&tcon->open_file_lock);
 	if (fid->pending_open->oplock != CIFS_OPLOCK_NO_CHANGE && oplock)
 		oplock = fid->pending_open->oplock;
-	cifs_del_pending_open(fid->pending_open);
+	list_del(&fid->pending_open->olist);
 
 	fid->purge_cache = false;
 	server->ops->set_fid(cfile, fid, oplock);
 
-	spin_lock(&tcon->open_file_lock);
 	list_add(&cfile->tlist, &tcon->openFileList);
 
 	/* if readable file instance put first in list*/
@@ -354,7 +354,7 @@ cifsFileInfo_get(struct cifsFileInfo *cifs_file)
 /*
  * Release a reference on the file private data. This may involve closing
  * the filehandle out on the server. Must be called without holding
- * cifs_file->file_info_lock.
+ * tcon->open_file_lock and cifs_file->file_info_lock.
  */
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 {
@@ -369,11 +369,15 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	struct cifs_pending_open open;
 	bool oplock_break_cancelled;
 
+	spin_lock(&tcon->open_file_lock);
+
 	spin_lock(&cifs_file->file_info_lock);
 	if (--cifs_file->count > 0) {
 		spin_unlock(&cifs_file->file_info_lock);
+		spin_unlock(&tcon->open_file_lock);
 		return;
 	}
+	spin_unlock(&cifs_file->file_info_lock);
 
 	if (server->ops->get_lease_key)
 		server->ops->get_lease_key(inode, &fid);
@@ -397,7 +401,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 			set_bit(CIFS_INO_INVALID_MAPPING, &cifsi->flags);
 		cifs_set_oplock_level(cifsi, 0);
 	}
-	spin_unlock(&cifs_file->file_info_lock);
+
+	spin_unlock(&tcon->open_file_lock);
 
 	oplock_break_cancelled = cancel_work_sync(&cifs_file->oplock_break);
 
@@ -1765,7 +1770,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 			if (!open_file->invalidHandle) {
 				/* found a good file */
 				/* lock it so it will not be closed on us */
-				cifsFileInfo_get_locked(open_file);
+				cifsFileInfo_get(open_file);
 				spin_unlock(&tcon->open_file_lock);
 				return open_file;
 			} /* else might as well continue, and look for
@@ -1819,7 +1824,7 @@ refind_writable:
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
-				cifsFileInfo_get_locked(open_file);
+				cifsFileInfo_get(open_file);
 				spin_unlock(&tcon->open_file_lock);
 				return open_file;
 			} else {
@@ -1836,9 +1841,7 @@ refind_writable:
 
 	if (inv_file) {
 		any_available = false;
-		spin_lock(&inv_file->file_info_lock);
-		cifsFileInfo_get_locked(inv_file);
-		spin_unlock(&inv_file->file_info_lock);
+		cifsFileInfo_get(inv_file);
 	}
 
 	spin_unlock(&tcon->open_file_lock);
-- 
2.7.4
