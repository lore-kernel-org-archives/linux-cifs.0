From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: allow cifs_max_pending to be readable under /sys/module/cifs/parameters
Date: Wed, 19 Oct 2011 15:31:16 -0400
Message-ID: <1319052676-11587-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b0a2e16..fa67245 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -74,7 +74,7 @@ module_param(cifs_min_small, int, 0);
 MODULE_PARM_DESC(cifs_min_small, "Small network buffers in pool. Default: 30 "
 				 "Range: 2 to 256");
 unsigned int cifs_max_pending = CIFS_MAX_REQ;
-module_param(cifs_max_pending, int, 0);
+module_param(cifs_max_pending, int, 0444);
 MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
 				   "Default: 50 Range: 2 to 256");
 unsigned short echo_retries = 5;
-- 
1.7.6.4
