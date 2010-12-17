From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/18] cifs: don't fail writepages on -EAGAIN errors
Date: Fri, 17 Dec 2010 10:08:00 -0500
Message-ID: <1292598497-29796-2-git-send-email-jlayton@redhat.com>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If CIFSSMBWrite2 returns -EAGAIN, then the error should be considered
temporary. CIFS should retry the write instead of setting an error on
the mapping and returning.

For WB_SYNC_ALL, just retry the write immediately. In the WB_SYNC_NONE
case, call redirty_page_for_writeback on all of the pages that didn't
get written out and then move on.

Also, fix up the handling of a short write with a successful return
code. MS-CIFS says that 0 bytes_written means ENOSPC or EFBIG. It
doesn't mention what a short, but non-zero write means, so for now
treat it as we would an -EAGAIN return.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |   49 +++++++++++++++++++++++++++++++++++++------------
 1 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4007e60..400c948 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1377,6 +1377,7 @@ retry:
 				break;
 		}
 		if (n_iov) {
+retry_write:
 			open_file = find_writable_file(CIFS_I(mapping->host),
 							false);
 			if (!open_file) {
@@ -1389,31 +1390,55 @@ retry:
 						   &bytes_written, iov, n_iov,
 						   long_op);
 				cifsFileInfo_put(open_file);
-				cifs_update_eof(cifsi, offset, bytes_written);
 			}
 
-			if (rc || bytes_written < bytes_to_write) {
-				cERROR(1, "Write2 ret %d, wrote %d",
-					  rc, bytes_written);
-				mapping_set_error(mapping, rc);
-			} else {
+			cFYI(1, "Write2 rc=%d, wrote=%u", rc, bytes_written);
+
+			/*
+			 * For now, treat a short write as if nothing got
+			 * written. A zero length write however indicates
+			 * ENOSPC or EFBIG. We have no way to know which
+			 * though, so call it ENOSPC for now. EFBIG would
+			 * get translated to AS_EIO anyway.
+			 *
+			 * FIXME: make it take into account the data that did
+			 *	  get written
+			 */
+			if (rc == 0) {
+				if (bytes_written == 0)
+					rc = -ENOSPC;
+				else if (bytes_written < bytes_to_write)
+					rc = -EAGAIN;
+			}
+
+			/* retry on data-integrity flush */
+			if (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN)
+				goto retry_write;
+
+			/* fix the stats and EOF */
+			if (bytes_written > 0) {
 				cifs_stats_bytes_written(tcon, bytes_written);
+				cifs_update_eof(cifsi, offset, bytes_written);
 			}
 
 			for (i = 0; i < n_iov; i++) {
 				page = pvec.pages[first + i];
-				/* Should we also set page error on
-				success rc but too little data written? */
-				/* BB investigate retry logic on temporary
-				server crash cases and how recovery works
-				when page marked as error */
-				if (rc)
+				/* on retryable write error, redirty page */
+				if (rc == -EAGAIN)
+					redirty_page_for_writepage(wbc, page);
+				else if (rc != 0)
 					SetPageError(page);
 				kunmap(page);
 				unlock_page(page);
 				end_page_writeback(page);
 				page_cache_release(page);
 			}
+
+			if (rc != -EAGAIN)
+				mapping_set_error(mapping, rc);
+			else
+				rc = 0;
+
 			if ((wbc->nr_to_write -= n_iov) <= 0)
 				done = 1;
 			index = next;
-- 
1.7.3.3
