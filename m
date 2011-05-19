From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/7] cifs: clean up wsize negotiation and allow for larger wsize
Date: Thu, 19 May 2011 16:22:58 -0400
Message-ID: <1305836578-26333-8-git-send-email-jlayton@redhat.com>
References: <1305836578-26333-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305836578-26333-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we can handle larger wsizes in writepages, fix up the
negotiation of the wsize to allow for that. find_get_pages only seems to
give out a max of 256 pages at a time, so that gives us a reasonable
default of 1M for the wsize.

If the server however does not support large writes via POSIX
extensions, then we cap the wsize to (128k - PAGE_CACHE_SIZE). That
gives us a size that goes up to the max frame size specified in RFC1001.

Finally, if CAP_LARGE_WRITE_AND_X isn't set, then further cap it to the
largest size allowed by the protocol (USHRT_MAX).

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   69 +++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 49 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccb3ff8..490fb68 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2633,23 +2633,6 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
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
@@ -2727,6 +2710,53 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 			   "mount option supported");
 }
 
+/*
+ * When the server supports very large writes via POSIX extensions, we can
+ * allow up to 2^24 - PAGE_CACHE_SIZE.
+ *
+ * Note that this might make for "interesting" allocation problems during
+ * writeback however (as we have to allocate an array of pointers for the
+ * pages). A 16M write means ~32kb page array with PAGE_CACHE_SIZE == 4096.
+ */
+#define CIFS_MAX_WSIZE ((1<<24) - PAGE_CACHE_SIZE)
+
+/*
+ * When the server doesn't allow large posix writes, default to a wsize of
+ * 128k - PAGE_CACHE_SIZE -- one page less than the largest frame size
+ * described in RFC1001. This allows space for the header without going over
+ * that by default.
+ */
+#define CIFS_MAX_RFC1001_WSIZE (128 * 1024 - PAGE_CACHE_SIZE)
+
+/*
+ * The default wsize is 1M. find_get_pages seems to return a maximum of 256
+ * pages in a single call. With PAGE_CACHE_SIZE == 4k, this means we can fill
+ * a single wsize request with a single call.
+ */
+#define CIFS_DEFAULT_WSIZE (1024 * 1024)
+
+static unsigned int
+cifs_negotiate_wsize(struct cifsTconInfo *tcon, struct smb_vol *pvolume_info)
+{
+	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	unsigned int wsize = pvolume_info->wsize ? pvolume_info->wsize :
+				CIFS_DEFAULT_WSIZE;
+
+	/* can server support 24-bit write sizes? (via UNIX extensions) */
+	if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
+		wsize = min_t(unsigned int, wsize, CIFS_MAX_RFC1001_WSIZE);
+
+	/* no CAP_LARGE_WRITE_X? Limit it to 16 bits */
+	if (!(server->capabilities & CAP_LARGE_WRITE_X))
+		wsize = min_t(unsigned int, wsize, USHRT_MAX);
+
+	/* hard limit of CIFS_MAX_WSIZE */
+	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
+
+	return wsize;
+}
+
 static int
 is_path_accessible(int xid, struct cifsTconInfo *tcon,
 		   struct cifs_sb_info *cifs_sb, const char *full_path)
@@ -2988,13 +3018,12 @@ try_mount_again:
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
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	/*
-- 
1.7.4.4
