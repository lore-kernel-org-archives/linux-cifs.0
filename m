From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: fix test for strtoul failure in mount.cifs
Date: Fri, 15 Apr 2011 07:25:53 -0400
Message-ID: <1302866753-7887-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It currently test to see if errno == -EINVAL and whether the endptr
is '\0'. That's not correct however. What we really want it to do is
check to see if any error occurred by setting errno to 0 before the
conversion. If one did, then try to treat the value as a name.

Also fix a bogus compiler warning about cruid being uninitialized.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 29b0d4c..9d7e107 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -861,7 +861,7 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 	int got_uid = 0;
 	int got_cruid = 0;
 	int got_gid = 0;
-	uid_t uid, cruid;
+	uid_t uid, cruid = 0;
 	gid_t gid;
 	char *ep;
 	struct passwd *pw;
@@ -1031,8 +1031,9 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 				goto nocopy;
 
 			got_uid = 1;
+			errno = 0;
 			uid = strtoul(value, &ep, 10);
-			if (errno != EINVAL && *ep == '\0')
+			if (errno == 0)
 				goto nocopy;
 
 			pw = getpwnam(value);
@@ -1049,8 +1050,9 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 				goto nocopy;
 
 			got_cruid = 1;
+			errno = 0;
 			cruid = strtoul(value, &ep, 10);
-			if (errno != EINVAL && *ep == '\0')
+			if (errno == 0)
 				goto nocopy;
 
 			pw = getpwnam(value);
@@ -1066,8 +1068,9 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 				goto nocopy;
 
 			got_gid = 1;
+			errno = 0;
 			gid = strtoul(value, &ep, 10);
-			if (errno != EINVAL && *ep == '\0')
+			if (errno == 0)
 				goto nocopy;
 
 			gr = getgrnam(value);
-- 
1.7.4.4
