From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 04/15] cifs: fix handling of signing with writepages
Date: Fri, 20 Aug 2010 15:32:00 -0400
Message-ID: <1282332731-17444-5-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Get a reference to the file early so we can eventually base the decision
about signing on the correct tcon. If that doesn't work for some reason,
then fall back to generic_writepages. That's just as likely to fail, but
it simplifies the error handling.

In truth, I'm not sure how that could occur anyway, so maybe a NULL
open_file here ought to be a BUG()?

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/file.c |   82 +++++++++++++++++++++++++++----------------------------
 1 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8d98aaa..56a2d98 100644
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
@@ -1362,25 +1371,26 @@ static int cifs_writepages(struct address_space *mapping,
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
 
 	xid = GetXid();
@@ -1486,37 +1496,24 @@ retry:
 				break;
 		}
 		if (n_iov) {
-			/* Search for a writable handle every time we call
-			 * CIFSSMBWrite2.  We can't rely on the last handle
-			 * we used to still be valid
-			 */
-			open_file = find_writable_file(CIFS_I(mapping->host));
-			if (!open_file) {
-				cERROR(1, "No writable handles for inode");
-				rc = -EBADF;
+			long_op = cifs_write_timeout(cifsi, offset);
+			rc = CIFSSMBWrite2(xid, tcon, open_file->netfid,
+					   bytes_to_write, offset,
+					   &bytes_written, iov, n_iov,
+					   long_op);
+			cifs_update_eof(cifsi, offset, bytes_written);
+
+			if (rc || bytes_written < bytes_to_write) {
+				cERROR(1, "Write2 ret %d, wrote %d",
+					  rc, bytes_written);
+				/* BB what if continued retry is
+				   requested via mount flags? */
+				if (rc == -ENOSPC)
+					set_bit(AS_ENOSPC, &mapping->flags);
+				else
+					set_bit(AS_EIO, &mapping->flags);
 			} else {
-				tcon = open_file->tcon;
-				long_op = cifs_write_timeout(cifsi, offset);
-				rc = CIFSSMBWrite2(xid, tcon,
-						   open_file->netfid,
-						   bytes_to_write, offset,
-						   &bytes_written, iov, n_iov,
-						   long_op);
-				cifsFileInfo_put(open_file);
-				cifs_update_eof(cifsi, offset, bytes_written);
-
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
+				cifs_stats_bytes_written(tcon, bytes_written);
 			}
 			for (i = 0; i < n_iov; i++) {
 				page = pvec.pages[first + i];
@@ -1553,6 +1550,7 @@ retry:
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 
+	cifsFileInfo_put(open_file);
 	FreeXid(xid);
 	kfree(iov);
 	return rc;
-- 
1.7.2.1

