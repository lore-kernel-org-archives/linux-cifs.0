From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cifs: ignore the "mand", "nomand" and "_netdev" mount options
Date: Mon, 26 Jul 2010 10:29:58 -0400
Message-ID: <1280154598-29628-2-git-send-email-jlayton@redhat.com>
References: <1280154598-29628-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280154598-29628-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

These are all handled by the userspace mount programs, but older versions
of mount.cifs also handed them off to the kernel. Ignore them.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d91a608..85a994c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1264,6 +1264,12 @@ cifs_parse_mount_options(char *options, const char *devname,
 		} else if ((strnicmp(data, "nocase", 6) == 0) ||
 			   (strnicmp(data, "ignorecase", 10)  == 0)) {
 			vol->nocase = 1;
+		} else if (strnicmp(data, "mand", 4) == 0) {
+			/* ignore */
+		} else if (strnicmp(data, "nomand", 6) == 0) {
+			/* ignore */
+		} else if (strnicmp(data, "_netdev", 7) == 0) {
+			/* ignore */
 		} else if (strnicmp(data, "brl", 3) == 0) {
 			vol->nobrl =  0;
 		} else if ((strnicmp(data, "nobrl", 5) == 0) ||
-- 
1.7.1.1
