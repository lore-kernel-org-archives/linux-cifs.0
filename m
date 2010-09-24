From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: cifs_flush should wait for writeback to complete before proceeding
Date: Fri, 24 Sep 2010 08:59:13 -0400
Message-ID: <1285333153-9113-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's possible that the kernel will call cifs_close on a filp while there
is still dirty data attached to the inode. If it's the last writeable
filp for an inode, then we may have no way to flush this data to the
server.

Thus, simply doing a filemap_fdatawrite in the .flush operation isn't
sufficient. The client needs to wait for it to complete before
returning. OTOH, there's no real need to perform a flush on a
filehandle that's read-only.

What currently saves us on this is the fact that cifs_writepages is
basically synchronous. If and when we ever switch to an async writeback
model, this will need to be fixed, so we might as well go ahead and
fix it now.

When flushing a writable filp, wait for the writeback to complete before
returning to ensure that the filehandle stays around until the writeback
is complete.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 80856f1..8084a8d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1737,16 +1737,13 @@ int cifs_flush(struct file *file, fl_owner_t id)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int rc = 0;
 
-	/* Rather than do the steps manually:
-	   lock the inode for writing
-	   loop through pages looking for write behind data (dirty pages)
-	   coalesce into contiguous 16K (or smaller) chunks to write to server
-	   send to server (prefer in parallel)
-	   deal with writebehind errors
-	   unlock inode for writing
-	   filemapfdatawrite appears easier for the time being */
-
-	rc = filemap_fdatawrite(inode->i_mapping);
+	/*
+	 * if the file is writable, then flush any dirty data to ensure that
+	 * the filehandle isn't closed out before writeback completes.
+	 */
+	if (file->f_mode & FMODE_WRITE)
+		rc = filemap_write_and_wait(inode->i_mapping);
+
 	/* reset wb rc if we were able to write out dirty pages */
 	if (!rc) {
 		rc = CIFS_I(inode)->write_behind_rc;
-- 
1.7.2.3
