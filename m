From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix potential buffer overrun when composing a new options string
Date: Thu, 23 May 2013 16:37:24 -0400
Message-ID: <1369341444-23493-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Consider the case where we have a very short ip= string in the original
mount options, and when we chase a referral we end up with a very long
IPv6 address. Be sure to allow for that possibility when estimating the
size of the string to allocate.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_dfs_ref.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 8e33ec6..8e5a181 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/fs.h>
+#include <linux/inet.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifsfs.h"
@@ -150,7 +151,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	 * assuming that we have 'unc=' and 'ip=' in
 	 * the original sb_mountdata
 	 */
-	md_len = strlen(sb_mountdata) + rc + strlen(ref->node_name) + 12;
+	md_len = strlen(sb_mountdata) + rc + strlen(ref->node_name) + 12 +
+			INET6_ADDRSTRLEN;
 	mountdata = kzalloc(md_len+1, GFP_KERNEL);
 	if (mountdata == NULL) {
 		rc = -ENOMEM;
-- 
1.8.1.4
