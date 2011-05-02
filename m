From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/8] cifs: clean up wsize negotiation and allow for larger wsize
Date: Mon,  2 May 2011 10:04:28 -0400
Message-ID: <1304345069-2441-8-git-send-email-jlayton@redhat.com>
References: <1304345069-2441-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304345069-2441-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we can handle larger wsizes in writepages, fix up the
negotiation of the wsize to allow for that. Make the code default to a
wsize of (128k - PAGE_CACHE_SIZE). That gives us a size that goes up to
the max frame size specified in RFC1001.

If CAP_LARGE_WRITE_AND_X isn't set, then set that down to a the largest
size allowed by the protocol (USHRT_MAX), or the specified wsize,
whichever is smaller.

If a larger wsize is specified, then check to make sure the server
supports the POSIX extension that allows it to ignore the 128k limit. If
it doesn't then set it to the default value.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   60 +++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4667cfa..b5e4b75 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2614,23 +2614,6 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 	else /* default */
 		cifs_sb->rsize = CIFSMaxBufSize;
 
-	if (pvolume_info->wsize > PAGEVEC_SIZE * PAGE_CACHE_SIZE) {
-		cERROR(1, "wsize %d too large, using 4096 instead",
-			  pvolume_info->wsize);
-		cifs_sb->wsize = 4096;
-	} else if (pvolume_info->wsize)
-		cifs_sb->wsize = pvolume_info->wsize;
-	else
-		cifs_sb->wsize = min_t(const int,
-					PAGEVEC_SIZE * PAGE_CACHE_SIZE,
-					127*1024);
-		/* old default of CIFSMaxBufSize was too small now
-		   that SMB Write2 can send multiple pages in kvec.
-		   RFC1001 does not describe what happens when frame
-		   bigger than 128K is sent so use that as max in
-		   conjunction with 52K kvec constraint on arch with 4K
-		   page size  */
-
 	if (cifs_sb->rsize < 2048) {
 		cifs_sb->rsize = 2048;
 		/* Windows ME may prefer this */
@@ -2708,6 +2691,44 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 			   "mount option supported");
 }
 
+/*
+ * default to a wsize of 128k - PAGE_CACHE_SIZE -- one page less than the
+ * largest frame size described in RFC1001. This allows space for the header
+ * without going over that by default.
+ */
+#define CIFS_MAX_RFC1001_WSIZE (128 * 1024 - PAGE_CACHE_SIZE)
+
+/*
+ * It's possible to increase the wsize by setting the wsize parm directly
+ * up to a hard limit of 2^24 - PAGE_CACHE_SIZE. That might make for
+ * "interesting" allocation problems during writeback however (as we have to
+ * allocate an array of pointers for the pages). A 16M write means ~32kb
+ * page array with PAGE_CACHE_SIZE == 4096.
+ */
+#define CIFS_MAX_WSIZE ((1<<24) - PAGE_CACHE_SIZE)
+
+static unsigned int
+cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
+{
+	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	unsigned int wsize = pvolume_info->wsize ? pvolume_info->wsize :
+				CIFS_MAX_RFC1001_WSIZE;
+
+	/* no CAP_LARGE_WRITE_X? Limit it to 16 bits */
+	if (!(server->capabilities & CAP_LARGE_WRITE_X))
+		wsize = min_t(unsigned int, wsize, USHRT_MAX);
+
+	/* can server support 24-bit write sizes? (via UNIX extensions) */
+	if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
+		wsize = min_t(unsigned int, wsize, CIFS_MAX_RFC1001_WSIZE);
+
+	/* hard limit of CIFS_MAX_WSIZE */
+	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
+
+	return wsize;
+}
+
 static int
 is_path_accessible(int xid, struct cifs_tcon *tcon,
 		   struct cifs_sb_info *cifs_sb, const char *full_path)
@@ -2898,13 +2919,12 @@ try_mount_again:
 		cifs_sb->rsize = 1024 * 127;
 		cFYI(DBG2, "no very large read support, rsize now 127K");
 	}
-	if (!(tcon->ses->capabilities & CAP_LARGE_WRITE_X))
-		cifs_sb->wsize = min(cifs_sb->wsize,
-			       (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
 	if (!(tcon->ses->capabilities & CAP_LARGE_READ_X))
 		cifs_sb->rsize = min(cifs_sb->rsize,
 			       (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
 
+	cifs_sb->wsize = cifs_negotiate_wsize(tcon, volume_info);
+
 remote_path_check:
 	/* check if a whole path (including prepath) is not remote */
 	if (!rc && tcon) {
-- 
1.7.4.4
