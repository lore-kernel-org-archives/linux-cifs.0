From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix types on module parameters
Date: Fri, 19 Oct 2012 08:14:52 -0400
Message-ID: <1350648892-5182-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Most of these are unsigned ints, so we should be passing "uint" to
module_param. Also, get rid of the extra "(bool)" in the description
of enable_oplocks.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e7931cc..07a8ab52 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -64,24 +64,23 @@ unsigned int global_secflags = CIFSSEC_DEF;
 unsigned int sign_CIFS_PDUs = 1;
 static const struct super_operations cifs_super_ops;
 unsigned int CIFSMaxBufSize = CIFS_MAX_MSGSIZE;
-module_param(CIFSMaxBufSize, int, 0);
+module_param(CIFSMaxBufSize, uint, 0);
 MODULE_PARM_DESC(CIFSMaxBufSize, "Network buffer size (not including header). "
 				 "Default: 16384 Range: 8192 to 130048");
 unsigned int cifs_min_rcv = CIFS_MIN_RCV_POOL;
-module_param(cifs_min_rcv, int, 0);
+module_param(cifs_min_rcv, uint, 0);
 MODULE_PARM_DESC(cifs_min_rcv, "Network buffers in pool. Default: 4 Range: "
 				"1 to 64");
 unsigned int cifs_min_small = 30;
-module_param(cifs_min_small, int, 0);
+module_param(cifs_min_small, uint, 0);
 MODULE_PARM_DESC(cifs_min_small, "Small network buffers in pool. Default: 30 "
 				 "Range: 2 to 256");
 unsigned int cifs_max_pending = CIFS_MAX_REQ;
-module_param(cifs_max_pending, int, 0444);
+module_param(cifs_max_pending, uint, 0444);
 MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
 				   "Default: 32767 Range: 2 to 32767.");
 module_param(enable_oplocks, bool, 0644);
-MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool). Default:"
-				 "y/Y/1");
+MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
 
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
-- 
1.7.11.7
