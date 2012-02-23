From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: fix tests for strtoul success
Date: Thu, 23 Feb 2012 10:40:35 -0500
Message-ID: <1330011635-20907-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Cc: ksquizza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The current test just looks to see if errno was 0 after the conversion
but we need to do a bit more. According to the strtoul manpage:

    If there were no digits at all, strtoul() stores the original value
    of nptr in *endptr (and returns 0).

So, if you pass in a string of letters, strtoul will return 0, but
won't actually have converted anything. Luckily, in most cases, /bin/mount
papers over this bug by doing uid/gid conversions itself before calling
mount.cifs.

Fix this by also checking to ensure that strtoul() converted the entire
string in addition to checking that it didn't set errno. While we're at
it, fix the test in backupuid/backupgid options as well which doesn't
currently check whether errno got set.

Reported-by: Kyle Squizzato <ksquizza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index a46a22c..824cd3a 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1032,7 +1032,7 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			got_uid = 1;
 			errno = 0;
 			uid = strtoul(value, &ep, 10);
-			if (errno == 0)
+			if (errno == 0 && *ep == '\0')
 				goto nocopy;
 
 			pw = getpwnam(value);
@@ -1051,7 +1051,7 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			got_cruid = 1;
 			errno = 0;
 			cruid = strtoul(value, &ep, 10);
-			if (errno == 0)
+			if (errno == 0 && *ep == '\0')
 				goto nocopy;
 
 			pw = getpwnam(value);
@@ -1069,7 +1069,7 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			got_gid = 1;
 			errno = 0;
 			gid = strtoul(value, &ep, 10);
-			if (errno == 0)
+			if (errno == 0 && *ep == '\0')
 				goto nocopy;
 
 			gr = getgrnam(value);
@@ -1175,8 +1175,9 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 				goto nocopy;
 
 			got_bkupuid = 1;
+			errno = 0;
 			bkupuid = strtoul(value, &ep, 10);
-			if (!strlen(ep))
+			if (errno == 0 && *ep == '\0')
 				goto nocopy;
 
 			pw = getpwnam(value);
@@ -1193,8 +1194,9 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 				goto nocopy;
 
 			got_bkupgid = 1;
+			errno = 0;
 			bkupgid = strtoul(value, &ep, 10);
-			if (!strlen(ep))
+			if (errno == 0 && *ep == '\0')
 				goto nocopy;
 
 			gr = getgrnam(value);
-- 
1.7.7.6
