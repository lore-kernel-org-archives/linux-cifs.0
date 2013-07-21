From: scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: Correct max string lengths v2
Date: Sun, 21 Jul 2013 16:21:08 -0400
Message-ID: <1374438068-2868-1-git-send-email-scott.lovenberg@gmail.com>
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org,
	sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The max size of the username, domain, and password strings are now
consistent with the kernel and Microsoft's documentation.

Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 AUTHORS      |  2 ++
 mount.cifs.c | 23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/AUTHORS b/AUTHORS
index 2807079..2f6a14d 100644
--- a/AUTHORS
+++ b/AUTHORS
@@ -5,5 +5,7 @@ Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
 Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+
 
 ...and others.
diff --git a/mount.cifs.c b/mount.cifs.c
index 3b2b89e..77ea0f8 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -84,21 +84,30 @@
 #define MTAB_OPTIONS_LEN 220
 
 /*
- * Maximum length of "share" portion of a UNC. I have no idea if this is at
- * all valid. According to MSDN, the typical max length of any component is
- * 255, so use that here.
+ * Max share name, username, password and domain sizes match the kernel's
+ * allowances for these string sizes which in turn match Microsoft's
+ * documentation.
  */
+
+/* Max length of the share name portion of a UNC. Share names over 80
+ * characters cannot be accessed via commandline in Windows 2000/XP. */
 #define MAX_SHARE_LEN 256
 
-/* max length of username (somewhat made up here) */
-#define MAX_USERNAME_SIZE 32
+/* Max user name length. */
+#define MAX_USERNAME_SIZE 256
+
+/* Max domain size. */
+#define MAX_DOMAIN_SIZE 256
+
+/* Max password size. */
+#define MOUNT_PASSWD_SIZE 512
+
+
 
 #ifndef SAFE_FREE
 #define SAFE_FREE(x) do { if ((x) != NULL) {free(x); x = NULL; } } while (0)
 #endif
 
-#define MOUNT_PASSWD_SIZE 128
-#define MAX_DOMAIN_SIZE 64
 
 /*
  * mount.cifs has been the subject of many "security" bugs that have arisen
-- 
1.8.1.4
