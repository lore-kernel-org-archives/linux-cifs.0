From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: fix argument count check
Date: Fri,  9 Nov 2012 06:07:16 -0500
Message-ID: <1352459236-8826-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The argv < 3 check could return true if you pass in some option flags.
If you don't provide any further arguments then you might just walk
off the end of the argv array. The values past the end aren't
guaranteed to be NULL in that case.

Fix the check to just look at whether there are 2 more arguments after
the getopt processing is done.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 9cf58a5..a9632b4 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -2071,7 +2071,7 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (argc < 3 || argv[optind] == NULL || argv[optind + 1] == NULL) {
+	if (argc < optind + 2) {
 		rc = mount_usage(stderr);
 		goto mount_exit;
 	}
-- 
1.7.11.7
