From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cifs: ensure that we always do cifsFileInfo_get under the spinlock
Date: Wed, 25 Jul 2012 14:48:34 -0400
Message-ID: <1343242114-12809-1-git-send-email-jlayton@redhat.com>
References: <1342799330-2919-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342799330-2919-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The readpages bug is a regression that was introduced in 6993f74a5.
This also fixes a couple of similar bugs in the uncached read and write
codepaths.

Also, prevent this sort of thing in the future by having cifsFileInfo_get
take the spinlock itself, and adding a _locked variant for use in places
that are already holding the lock. The _put code has always done that
so this makes for a less confusing interface.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |  6 +++---
 fs/cifs/file.c     | 17 ++++++++++++-----
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bcdf4d4..497da5c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -765,13 +765,13 @@ struct cifs_io_parms {
  * Take a reference on the file private data. Must be called with
  * cifs_file_list_lock held.
  */
-static inline
-struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file)
+static inline void
+cifsFileInfo_get_locked(struct cifsFileInfo *cifs_file)
 {
 	++cifs_file->count;
-	return cifs_file;
 }
 
+struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file);
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 
 /*
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 07e9d41..9154192 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -284,6 +284,15 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 
 static void cifs_del_lock_waiters(struct cifsLockInfo *lock);
 
+struct cifsFileInfo *
+cifsFileInfo_get(struct cifsFileInfo *cifs_file)
+{
+	spin_lock(&cifs_file_list_lock);
+	cifsFileInfo_get_locked(cifs_file);
+	spin_unlock(&cifs_file_list_lock);
+	return cifs_file;
+}
+
 /*
  * Release a reference on the file private data. This may involve closing
  * the filehandle out on the server. Must be called without holding
@@ -1562,7 +1571,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 			if (!open_file->invalidHandle) {
 				/* found a good file */
 				/* lock it so it will not be closed on us */
-				cifsFileInfo_get(open_file);
+				cifsFileInfo_get_locked(open_file);
 				spin_unlock(&cifs_file_list_lock);
 				return open_file;
 			} /* else might as well continue, and look for
@@ -1614,7 +1623,7 @@ refind_writable:
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
-				cifsFileInfo_get(open_file);
+				cifsFileInfo_get_locked(open_file);
 				spin_unlock(&cifs_file_list_lock);
 				return open_file;
 			} else {
@@ -1631,7 +1640,7 @@ refind_writable:
 
 	if (inv_file) {
 		any_available = false;
-		cifsFileInfo_get(inv_file);
+		cifsFileInfo_get_locked(inv_file);
 	}
 
 	spin_unlock(&cifs_file_list_lock);
@@ -3082,8 +3091,6 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 			break;
 		}
 
-		spin_lock(&cifs_file_list_lock);
-		spin_unlock(&cifs_file_list_lock);
 		rdata->cfile = cifsFileInfo_get(open_file);
 		rdata->mapping = mapping;
 		rdata->offset = offset;
-- 
1.7.11.2
