From: Peng Haitao <penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] setcifsacl.c: fix a bug of goto setcifsacl_facenum_ret
Date: Fri, 12 Apr 2013 16:58:49 +0800
Message-ID: <1365757129-25076-1-git-send-email-penght@cn.fujitsu.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

setcifsacl_facenum_ret: is called only if attrlen is equal to -1.

Signed-off-by: Peng Haitao <penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 setcifsacl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 67dd29c..4b38459 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -822,9 +822,10 @@ cifsacl:
 		goto setcifsacl_action_ret;
 
 	attrlen = setxattr(filename, ATTRNAME, ntsdptr, bufsize, 0);
-	if (attrlen == -1)
+	if (attrlen == -1) {
 		printf("%s: setxattr error: %s\n", __func__, strerror(errno));
-	goto setcifsacl_facenum_ret;
+		goto setcifsacl_facenum_ret;
+	}
 
 	exit_plugin(plugin_handle);
 	return 0;
-- 
1.8.1.4
