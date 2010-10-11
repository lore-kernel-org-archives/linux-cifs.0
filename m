From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/16] cifs: wait for writeback to complete in cifs_flush
Date: Mon, 11 Oct 2010 15:07:32 -0400
Message-ID: <1286824053-12084-16-git-send-email-jlayton@redhat.com>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286824053-12084-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The f_op->flush operation is the last chance to return a writeback
related error when closing a file. Ensure that we don't miss reporting
any errors by waiting for writeback to complete in cifs_flush before
proceeding.

There's no reason to do this when the file isn't open for write
however.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/file.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f286cb9..7887a39 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1683,20 +1683,13 @@ int cifs_flush(struct file *file, fl_owner_t id)
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
-	/* reset wb rc if we were able to write out dirty pages */
-	if (!rc) {
-		rc = CIFS_I(inode)->write_behind_rc;
-		CIFS_I(inode)->write_behind_rc = 0;
+	if (file->f_mode & FMODE_WRITE) {
+		rc = filemap_write_and_wait(inode->i_mapping);
+		/* reset wb rc if we were able to write out dirty pages */
+		if (!rc) {
+			rc = CIFS_I(inode)->write_behind_rc;
+			CIFS_I(inode)->write_behind_rc = 0;
+		}
 	}
 
 	cFYI(1, "Flush inode %p file %p rc %d", inode, file, rc);
-- 
1.7.2.3
