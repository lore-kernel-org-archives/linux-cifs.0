From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: deprecate the DOMAIN/username%password username syntax
Date: Tue,  7 Aug 2012 11:11:53 -0400
Message-ID: <1344352313-8630-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

mount.cifs has in the past allowed users to specify a username using
the above syntax, which would populate the domain and password fields
with the different pieces.

Unfortunately, there are cases where it is legit to have a '/' in a
username. krb5 SPNs generally contain a '/' and we have no clear way
to distinguish between the two.

I don't see any real value in keeping that syntax allowed. It's no
easier than specifying "pass=" and "domain=" on the command line. Ditto
for credential files.

Begin the transition away from that syntax by adding a warning message
that support for it will be removed in 5.9.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 |  4 +++-
 mount.cifs.c | 14 ++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index f6a66bf..b2a0936 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -56,7 +56,9 @@ user=\fIarg\fR
 .RS 4
 specifies the username to connect as\&. If this is not given, then the environment variable
 \fIUSER\fR
-is used\&. This option can also take the form "user%password" or "workgroup/user" or "workgroup/user%password" to allow the password and workgroup to be specified as part of the username\&.
+is used\&.
+.PP
+Earlier versions of mount.cifs also allowed one to specify the username in a "user%password" or "workgroup/user" or "workgroup/user%password" to allow the password and workgroup to be specified as part of the username. Support for those alternate username formats is now deprecated and should no longer be used. Users should use the discrete "pass=" and "dom=" to specify the username.
 .if n \{\
 .sp
 .\}
diff --git a/mount.cifs.c b/mount.cifs.c
index 330e528..ef5b43f 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -45,6 +45,7 @@
 #include <libgen.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
+#include <stdbool.h>
 #ifdef HAVE_SYS_FSUID_H
 #include <sys/fsuid.h>
 #endif /* HAVE_SYS_FSUID_H */
@@ -320,15 +321,22 @@ static int set_password(struct parsed_mount_info *parsed_info, const char *src)
  *
  * ...obviously the only required component is "username". The source string
  * is modified in the process, but it should remain unchanged at the end.
+ *
+ * NOTE: the above syntax does not allow for usernames that have slashes in
+ * them, as some krb5 usernames do. Support for the above syntax will be
+ * removed in a later version of cifs-utils. Users should use separate options
+ * instead of overloading this info into the username.
  */
 static int parse_username(char *rawuser, struct parsed_mount_info *parsed_info)
 {
 	char *user, *password, slash;
 	int rc = 0;
+	bool warn = false;
 
 	/* everything after first % sign is a password */
 	password = strchr(rawuser, '%');
 	if (password) {
+		warn = true;
 		rc = set_password(parsed_info, password + 1);
 		if (rc)
 			return rc;
@@ -342,6 +350,7 @@ static int parse_username(char *rawuser, struct parsed_mount_info *parsed_info)
 
 	/* everything before that slash is a domain */
 	if (user) {
+		warn = true;
 		slash = *user;
 		*user = '\0';
 		strlcpy(parsed_info->domain, rawuser,
@@ -356,6 +365,11 @@ static int parse_username(char *rawuser, struct parsed_mount_info *parsed_info)
 	if (password)
 		*password = '%';
 
+	if (warn)
+		fprintf(stderr, "WARNING: The DOMAIN/username%%password syntax "
+				"for usernames is deprecated and will be "
+				"removed in version 5.9 of cifs-utils.\n");
+
 	return 0;
 }
 
-- 
1.7.11.2
