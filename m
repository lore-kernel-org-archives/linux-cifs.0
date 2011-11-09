From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: lower default wsize when unix extensions are not used
Date: Wed,  9 Nov 2011 13:37:23 -0500
Message-ID: <1320863843-29406-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org,
	piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We've had some reports of servers (namely, the Solaris in-kernel CIFS
server) that don't deal properly with writes that are "too large" even
though they set CAP_LARGE_WRITE_ANDX. Change the default to better
mirror what windows clients do.

Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Reported-by: Nick Davis <phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d6a972d..bf82f88 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2912,18 +2912,33 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 #define CIFS_DEFAULT_IOSIZE (1024 * 1024)
 
 /*
- * Windows only supports a max of 60k reads. Default to that when posix
- * extensions aren't in force.
+ * Windows only supports a max of 60kb reads and 65535 byte writes. Default to
+ * those values when posix extensions aren't in force. In actuality here, we
+ * use 65536 to allow for a write that is a multiple of 4k. Most servers seem
+ * to be ok with the extra byte even though Windows doesn't send writes that
+ * are that large.
+ *
+ * Citation:
+ *
+ * http://blogs.msdn.com/b/openspecification/archive/2009/04/10/smb-maximum-transmit-buffer-size-and-performance-tuning.aspx
  */
 #define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
+#define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
 
 static unsigned int
 cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 {
 	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
 	struct TCP_Server_Info *server = tcon->ses->server;
-	unsigned int wsize = pvolume_info->wsize ? pvolume_info->wsize :
-				CIFS_DEFAULT_IOSIZE;
+	unsigned int wsize;
+
+	/* start with specified wsize, or default */
+	if (pvolume_info->wsize)
+		wsize = pvolume_info->wsize;
+	else if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
+		wsize = CIFS_DEFAULT_IOSIZE;
+	else
+		wsize = CIFS_DEFAULT_NON_POSIX_WSIZE;
 
 	/* can server support 24-bit write sizes? (via UNIX extensions) */
 	if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
-- 
1.7.6.4
