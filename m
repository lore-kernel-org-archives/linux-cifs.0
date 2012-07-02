From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: when server doesn't set CAP_LARGE_READ_X, cap default rsize at MaxBufferSize
Date: Mon,  2 Jul 2012 07:24:25 -0400
Message-ID: <1341228265-30401-1-git-send-email-jlayton@redhat.com>
Cc: dhdurgee-HInyCGIudOg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When the server doesn't advertise CAP_LARGE_READ_X, then MS-CIFS states
that you must cap the size of the read at the client's MaxBufferSize.
Unfortunately, testing with many older servers shows that they often
can't service a read larger than their own MaxBufferSize.

Since we can't assume what the server will do in this situation, we must
be conservative here for the default. When the server can't do large
reads, then assume that it can't satisfy any read larger than its
MaxBufferSize either.

Luckily almost all modern servers can do large reads, so this won't
affect them. This is really just for older win9x and OS/2 era servers.
Also, note that this patch just governs the default rsize. The admin can
always override this if he so chooses.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.2
Reported-by: David H. Durgee <dhdurgee-HInyCGIudOg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 402fe08..f0a1a24 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3508,18 +3508,15 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 	 * MS-CIFS indicates that servers are only limited by the client's
 	 * bufsize for reads, testing against win98se shows that it throws
 	 * INVALID_PARAMETER errors if you try to request too large a read.
+	 * OS/2 just sends back short reads.
 	 *
-	 * If the server advertises a MaxBufferSize of less than one page,
-	 * assume that it also can't satisfy reads larger than that either.
-	 *
-	 * FIXME: Is there a better heuristic for this?
+	 * If the server doesn't advertise CAP_LARGE_READ_X, then assume that
+	 * it can't handle a read request larger than its MaxBufferSize either.
 	 */
 	if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_READ_CAP))
 		defsize = CIFS_DEFAULT_IOSIZE;
 	else if (server->capabilities & CAP_LARGE_READ_X)
 		defsize = CIFS_DEFAULT_NON_POSIX_RSIZE;
-	else if (server->maxBuf >= PAGE_CACHE_SIZE)
-		defsize = CIFSMaxBufSize;
 	else
 		defsize = server->maxBuf - sizeof(READ_RSP);
 
-- 
1.7.7.6
