From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/15] cifs: fix handling of signing with writepages (try #5)
Date: Wed, 22 Sep 2010 14:23:05 -0700
Message-ID: <1285190586-10750-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Get a reference to the file early so we can eventually base the decision
about signing on the correct tcon. If that doesn't work for some reason,
then fall back to generic_writepages. That's just as likely to fail, but
it simplifies the error handling.

In truth, I'm not sure how that could occur anyway, so maybe a NULL
open_file here ought to be a BUG()?

After that, we drop the reference to the open_file and then we re-get
one prior to each WriteAndX call. This helps ensure that the filehandle
isn't held open any longer than necessary and that open files are
reclaimed prior to each write call.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |   70 ++++++++++++++++++++++++++++++-------------------------
 1 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 84979fc..e099b50 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1353,6 +1353,15 @@ static int cifs_writepages(struct address_space *mapping,
 	int scanned = 0;
 	int xid, long_op;
 
+	/*
+	 * BB: Is this meaningful for a non-block-device file system?
+	 * If it is, we should test it again after we do I/O
+	 */
+	if (wbc->nonblocking && bdi_write_congested(bdi)) {
+		wbc->encountered_congestion = 1;
+		return 0;
+	}
+
 	cifs_sb = CIFS_SB(mapping->host->i_sb);
 
 	/*
@@ -1362,26 +1371,28 @@ static int cifs_writepages(struct address_space *mapping,
 	if (cifs_sb->wsize < PAGE_CACHE_SIZE)
 		return generic_writepages(mapping, wbc);
 
-	if ((cifs_sb->tcon->ses) && (cifs_sb->tcon->ses->server))
-		if (cifs_sb->tcon->ses->server->secMode &
-				(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
-			if (!experimEnabled)
-				return generic_writepages(mapping, wbc);
-
 	iov = kmalloc(32 * sizeof(struct kvec), GFP_KERNEL);
 	if (iov == NULL)
 		return generic_writepages(mapping, wbc);
 
-
 	/*
-	 * BB: Is this meaningful for a non-block-device file system?
-	 * If it is, we should test it again after we do I/O
+	 * if there's no open file, then this is likely to fail too,
+	 * but it'll at least handle the return. Maybe it should be
+	 * a BUG() instead?
 	 */
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
+	open_file = find_writable_file(CIFS_I(mapping->host));
+	if (!open_file) {
 		kfree(iov);
-		return 0;
+		return generic_writepages(mapping, wbc);
+	}
+
+	tcon = open_file->tcon;
+	if (!experimEnabled && tcon->ses->server->secMode &
+			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
+		cifsFileInfo_put(open_file);
+		return generic_writepages(mapping, wbc);
 	}
+	cifsFileInfo_put(open_file);
 
 	xid = GetXid();
 
@@ -1486,38 +1497,33 @@ retry:
 				break;
 		}
 		if (n_iov) {
-			/* Search for a writable handle every time we call
-			 * CIFSSMBWrite2.  We can't rely on the last handle
-			 * we used to still be valid
-			 */
 			open_file = find_writable_file(CIFS_I(mapping->host));
 			if (!open_file) {
 				cERROR(1, "No writable handles for inode");
 				rc = -EBADF;
 			} else {
-				tcon = open_file->tcon;
 				long_op = cifs_write_timeout(cifsi, offset);
-				rc = CIFSSMBWrite2(xid, tcon,
-						   open_file->netfid,
+				rc = CIFSSMBWrite2(xid, tcon, open_file->netfid,
 						   bytes_to_write, offset,
 						   &bytes_written, iov, n_iov,
 						   long_op);
 				cifsFileInfo_put(open_file);
-				cifs_update_eof(cifsi, offset, bytes_written);
+			}
 
-				if (rc || bytes_written < bytes_to_write) {
-					cERROR(1, "Write2 ret %d, wrote %d",
-						  rc, bytes_written);
-					/* BB what if continued retry is
-					   requested via mount flags? */
-					if (rc == -ENOSPC)
-						set_bit(AS_ENOSPC, &mapping->flags);
-					else
-						set_bit(AS_EIO, &mapping->flags);
-				} else {
-					cifs_stats_bytes_written(tcon, bytes_written);
-				}
+			if (rc || bytes_written < bytes_to_write) {
+				cERROR(1, "Write2 ret %d, wrote %d",
+					  rc, bytes_written);
+				/* BB what if continued retry is
+				   requested via mount flags? */
+				if (rc == -ENOSPC)
+					set_bit(AS_ENOSPC, &mapping->flags);
+				else
+					set_bit(AS_EIO, &mapping->flags);
+			} else {
+				cifs_update_eof(cifsi, offset, bytes_written);
+				cifs_stats_bytes_written(tcon, bytes_written);
 			}
+
 			for (i = 0; i < n_iov; i++) {
 				page = pvec.pages[first + i];
 				/* Should we also set page error on
-- 
1.7.3
