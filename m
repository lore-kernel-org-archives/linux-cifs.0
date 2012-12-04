From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/6] mount.cifs: treat uid=,gid=,cruid= options as name before assuming they're a number
Date: Tue,  4 Dec 2012 10:16:39 -0500
Message-ID: <1354634204-21602-2-git-send-email-jlayton@samba.org>
References: <1354634204-21602-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354634204-21602-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sergio Conrad reported a problem trying to set up an autofs map to do
a krb5 mount. In his environment, many users have usernames that are
comprised entirely of numbers. While that's a bit odd, POSIX apparently
allows for it.

The current code assumes that when a numeric argument is passed to one
of the above options, that it's a uid or gid. Instead, try to treat the
argument as a user or group name first, and only try to treat it as a
number if that fails.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c | 50 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index a9632b4..9760d1f 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1003,57 +1003,55 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 				goto nocopy;
 
 			got_uid = 1;
+			pw = getpwnam(value);
+			if (pw) {
+				uid = pw->pw_uid;
+				goto nocopy;
+			}
+
 			errno = 0;
 			uid = strtoul(value, &ep, 10);
 			if (errno == 0 && *ep == '\0')
 				goto nocopy;
 
-			pw = getpwnam(value);
-			if (pw == NULL) {
-				fprintf(stderr, "bad user name \"%s\"\n", value);
-				return EX_USAGE;
-			}
-
-			uid = pw->pw_uid;
-			goto nocopy;
-
+			fprintf(stderr, "bad option uid=\"%s\"\n", value);
+			return EX_USAGE;
 		case OPT_CRUID:
 			if (!value || !*value)
 				goto nocopy;
 
 			got_cruid = 1;
+			pw = getpwnam(value);
+			if (pw) {
+				cruid = pw->pw_uid;
+				goto nocopy;
+			}
+
 			errno = 0;
 			cruid = strtoul(value, &ep, 10);
 			if (errno == 0 && *ep == '\0')
 				goto nocopy;
 
-			pw = getpwnam(value);
-			if (pw == NULL) {
-				fprintf(stderr, "bad user name \"%s\"\n", value);
-				return EX_USAGE;
-			}
-			cruid = pw->pw_uid;
-			goto nocopy;
-
+			fprintf(stderr, "bad option: cruid=\"%s\"\n", value);
+			return EX_USAGE;
 		case OPT_GID:
 			if (!value || !*value)
 				goto nocopy;
 
 			got_gid = 1;
+			gr = getgrnam(value);
+			if (gr) {
+				gid = gr->gr_gid;
+				goto nocopy;
+			}
+
 			errno = 0;
 			gid = strtoul(value, &ep, 10);
 			if (errno == 0 && *ep == '\0')
 				goto nocopy;
 
-			gr = getgrnam(value);
-			if (gr == NULL) {
-				fprintf(stderr, "bad group name \"%s\"\n", value);
-				return EX_USAGE;
-			}
-
-			gid = gr->gr_gid;
-			goto nocopy;
-
+			fprintf(stderr, "bad option: gid=\"%s\"\n", value);
+			return EX_USAGE;
 		/* fmask fall through to file_mode */
 		case OPT_FMASK:
 			fprintf(stderr,
-- 
1.7.11.7
