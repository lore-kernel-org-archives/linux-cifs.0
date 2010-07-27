From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: handle the "mand" and "nomand" mount options (try #2)
Date: Tue, 27 Jul 2010 07:42:14 -0400
Message-ID: <1280230934-20830-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

These are filesystem-independent mount options that get passed to
mount.cifs too. Handle them appropriately by enabling and disabling
MS_MANDLOCK and not handing them off to the kernel.

Also, don't set MS_MANDLOCK by default. There's no reason to ask the
kernel to enforce mandatory locking by default. This also matches
up better with the way that "mand" is set in the mtab.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 27d267c..5a05caa 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -160,6 +160,8 @@
 #define OPT_RO         24
 #define OPT_RW         25
 #define OPT_REMOUNT    26
+#define OPT_MAND       27
+#define OPT_NOMAND     28
 
 
 /* struct for holding parsed mount info for use by privleged process */
@@ -823,6 +825,10 @@ static int parse_opt_token(const char *token)
 		return OPT_NO_DEV;
 	if (strncmp(token, "nobrl", 5) == 0 || strncmp(token, "nolock", 6) == 0)
 		return OPT_NO_LOCK;
+	if (strncmp(token, "mand", 4) == 0)
+		return OPT_MAND;
+	if (strncmp(token, "nomand", 6) == 0)
+		return OPT_NOMAND;
 	if (strncmp(token, "dev", 3) == 0)
 		return OPT_DEV;
 	if (strncmp(token, "noexec", 6) == 0)
@@ -1109,6 +1115,12 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 		case OPT_NO_LOCK:
 			*filesys_flags &= ~MS_MANDLOCK;
 			break;
+		case OPT_MAND:
+			*filesys_flags |= MS_MANDLOCK;
+			goto nocopy;
+		case OPT_NOMAND:
+			*filesys_flags &= ~MS_MANDLOCK;
+			goto nocopy;
 		case OPT_DEV:
 			*filesys_flags &= ~MS_NODEV;
 			break;
@@ -1735,8 +1747,6 @@ int main(int argc, char **argv)
 		return EX_SYSERR;
 	}
 
-	parsed_info->flags = MS_MANDLOCK;
-
 	/* add sharename in opts string as unc= parm */
 	while ((c = getopt_long(argc, argv, "?fhno:rvVw",
 				longopts, NULL)) != -1) {
-- 
1.7.1.1
