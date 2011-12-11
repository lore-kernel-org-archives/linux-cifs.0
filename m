From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 01/16] util: move getusername to util.c
Date: Sun, 11 Dec 2011 11:34:08 -0500
Message-ID: <1323621263-14452-2-git-send-email-jlayton@samba.org>
References: <1323621263-14452-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323621263-14452-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |   11 -----------
 util.c       |   13 +++++++++++++
 util.h       |    1 +
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 147f7fc..ced9f4e 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -361,17 +361,6 @@ static int set_password(struct parsed_mount_info *parsed_info, const char *src)
 	return 0;
 }
 
-/* caller frees username if necessary */
-static char *getusername(uid_t uid)
-{
-	char *username = NULL;
-	struct passwd *password = getpwuid(uid);
-
-	if (password)
-		username = password->pw_name;
-	return username;
-}
-
 /*
  * Parse a username string into parsed_mount_info fields. The format is:
  *
diff --git a/util.c b/util.c
index 41c6784..80d5a80 100644
--- a/util.c
+++ b/util.c
@@ -24,6 +24,7 @@
 
 #include <sys/types.h>
 #include <string.h>
+#include <pwd.h>
 
 /* glibc doesn't have strlcpy, strlcat. Ensure we do. JRA. We
  * don't link to libreplace so need them here. */
@@ -69,3 +70,15 @@ size_t strlcat(char *d, const char *s, size_t bufsize)
 }
 #endif
 
+/* caller frees username if necessary */
+char *
+getusername(uid_t uid)
+{
+	char *username = NULL;
+	struct passwd *password = getpwuid(uid);
+
+	if (password)
+		username = password->pw_name;
+	return username;
+}
+
diff --git a/util.h b/util.h
index 7a44faf..d3ca015 100644
--- a/util.h
+++ b/util.h
@@ -28,5 +28,6 @@
 size_t strlcpy(char *d, const char *s, size_t bufsize);
 size_t strlcat(char *d, const char *s, size_t bufsize);
 
+char *getusername(uid_t uid);
 #endif /* _LIBUTIL_H */
 
-- 
1.7.7.3
