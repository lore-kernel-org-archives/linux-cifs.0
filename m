From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix the conflict between rwpidforward and rw mount options
Date: Sat, 27 Aug 2011 20:18:40 +0400
Message-ID: <1314461920-6116-1-git-send-email-piastry@etersoft.ru>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Both these options are started with "rw" - that's why the first one
isn't switched on even if it is specified. Fix this by adding a length
check for "rw" option check.

Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/connect.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 633c246..f4af4cc 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1298,7 +1298,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			/* ignore */
 		} else if (strnicmp(data, "guest", 5) == 0) {
 			/* ignore */
-		} else if (strnicmp(data, "rw", 2) == 0) {
+		} else if (strnicmp(data, "rw", 2) == 0 && strlen(data) == 2) {
 			/* ignore */
 		} else if (strnicmp(data, "ro", 2) == 0) {
 			/* ignore */
@@ -1401,7 +1401,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			vol->server_ino = 1;
 		} else if (strnicmp(data, "noserverino", 9) == 0) {
 			vol->server_ino = 0;
-		} else if (strnicmp(data, "rwpidforward", 4) == 0) {
+		} else if (strnicmp(data, "rwpidforward", 12) == 0) {
 			vol->rwpidforward = 1;
 		} else if (strnicmp(data, "cifsacl", 7) == 0) {
 			vol->cifs_acl = 1;
-- 
1.7.1
