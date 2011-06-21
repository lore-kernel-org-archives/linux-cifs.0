From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix wsize negotiation to respect max buffer size and active signing
Date: Tue, 21 Jun 2011 08:08:17 -0400
Message-ID: <1308658097-14805-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

According to Hongwei Sun's blog posting here:

    http://blogs.msdn.com/b/openspecification/archive/2009/04/10/smb-maximum-transmit-buffer-size-and-performance-tuning.aspx

CAP_LARGE_WRITEX is ignored when signing is active. Also, the maximum
size for a write without CAP_LARGE_WRITEX should be the maxBuf that
the server sent in the NEGOTIATE request.

Fix the wsize negotiation to take this into account. While we're at it,
alter the other wsize definitions to use sizeof(WRITE_REQ) to allow for
slightly larger amounts of data to potentially be written per request.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b15b5b0..f9a59b8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2754,21 +2754,21 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 
 /*
  * When the server supports very large writes via POSIX extensions, we can
- * allow up to 2^24 - PAGE_CACHE_SIZE.
+ * allow up to 2^24 (16M) minus the size of a WRITE_AND_X header not including
+ * the RFC1001 length.
  *
  * Note that this might make for "interesting" allocation problems during
  * writeback however (as we have to allocate an array of pointers for the
  * pages). A 16M write means ~32kb page array with PAGE_CACHE_SIZE == 4096.
  */
-#define CIFS_MAX_WSIZE ((1<<24) - PAGE_CACHE_SIZE)
+#define CIFS_MAX_WSIZE ((1<<24) - sizeof(WRITE_REQ) + 4)
 
 /*
  * When the server doesn't allow large posix writes, default to a wsize of
- * 128k - PAGE_CACHE_SIZE -- one page less than the largest frame size
- * described in RFC1001. This allows space for the header without going over
- * that by default.
+ * 128k minus the size of the WRITE_AND_X header. That allows for a write up
+ * to the maximum size described by RFC1001.
  */
-#define CIFS_MAX_RFC1001_WSIZE (128 * 1024 - PAGE_CACHE_SIZE)
+#define CIFS_MAX_RFC1001_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
 
 /*
  * The default wsize is 1M. find_get_pages seems to return a maximum of 256
@@ -2789,9 +2789,15 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 	if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
 		wsize = min_t(unsigned int, wsize, CIFS_MAX_RFC1001_WSIZE);
 
-	/* no CAP_LARGE_WRITE_X? Limit it to 16 bits */
-	if (!(server->capabilities & CAP_LARGE_WRITE_X))
-		wsize = min_t(unsigned int, wsize, USHRT_MAX);
+	/*
+	 * no CAP_LARGE_WRITE_X or signing enabled? Limit to max buffer
+	 * offered by the server, minus the size of the WRITEX header, not
+	 * including the 4 byte RFC1001 length.
+	 */
+	if (!(server->capabilities & CAP_LARGE_WRITE_X) ||
+	    (server->sec_mode & (SECMODE_SIGN_ENABLED|SECMODE_SIGN_REQUIRED)))
+		wsize = min_t(unsigned int, wsize,
+				server->maxBuf - sizeof(WRITE_REQ) + 4);
 
 	/* hard limit of CIFS_MAX_WSIZE */
 	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
-- 
1.7.5.4
