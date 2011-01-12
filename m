From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/2] mount.cifs: clean up handling of uid= and gid=
Date: Wed, 12 Jan 2011 15:26:35 -0500
Message-ID: <1294863996-7678-1-git-send-email-jlayton@samba.org>
Cc: walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org, metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The handling of these options is quite convoluted. Change it so that
these options are stored as numbers and then appended to the option
strings.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |   94 +++++++++++++++++++++++++++++----------------------------
 1 files changed, 48 insertions(+), 46 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index df92d79..8fccf44 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -857,19 +857,24 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 	int rc = 0;
 	int got_uid = 0;
 	int got_gid = 0;
-	char user[32];
-	char group[32];
+	uid_t uid;
+	gid_t gid;
+	char txtbuf[12];
+	char *ep;
+	struct passwd *pw;
+	struct group *gr;
 
 	/* make sure we're starting from beginning */
 	out[0] = '\0';
 
 	/* BB fixme check for separator override BB */
-	if (getuid()) {
+	uid = getuid();
+	if (uid != 0)
 		got_uid = 1;
-		snprintf(user, sizeof(user), "%u", getuid());
+
+	gid = getgid();
+	if (gid != 0)
 		got_gid = 1;
-		snprintf(group, sizeof(group), "%u", getgid());
-	}
 
 	if (!data)
 		return EX_USAGE;
@@ -1014,43 +1019,39 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			break;
 
 		case OPT_UID:
-			if (value && *value) {
-				got_uid = 1;
-				if (!isdigit(*value)) {
-					struct passwd *pw;
-
-					if (!(pw = getpwnam(value))) {
-						fprintf(stderr,
-							"bad user name \"%s\"\n",
-							value);
-						return EX_USAGE;
-					}
-					snprintf(user, sizeof(user), "%u",
-						 pw->pw_uid);
-				}
-				else
-					strlcpy(user, value, sizeof(user));
+			if (!value || !*value)
+				goto nocopy;
+
+			got_uid = 1;
+			uid = strtoul(value, &ep, 10);
+			if (errno != EINVAL && *ep == '\0')
+				goto nocopy;
+
+			pw = getpwnam(value);
+			if (pw == NULL) {
+				fprintf(stderr, "bad user name \"%s\"\n", value);
+				return EX_USAGE;
 			}
+
+			uid = pw->pw_uid;
 			goto nocopy;
 
 		case OPT_GID:
-			if (value && *value) {
-				got_gid = 1;
-				if (!isdigit(*value)) {
-					struct group *gr;
-
-					if (!(gr = getgrnam(value))) {
-						fprintf(stderr,
-							"bad group name \"%s\"\n",
-							value);
-						return EX_USAGE;
-					}
-					snprintf(group, sizeof(group), "%u",
-						 gr->gr_gid);
-				}
-				else
-					strlcpy(group, value, sizeof(group));
+			if (!value || !*value)
+				goto nocopy;
+
+			got_gid = 1;
+			gid = strtoul(value, &ep, 10);
+			if (errno != EINVAL && *ep == '\0')
+				goto nocopy;
+
+			gr = getgrnam(value);
+			if (gr == NULL) {
+				fprintf(stderr, "bad group name \"%s\"\n", value);
+				return EX_USAGE;
 			}
+
+			gid = gr->gr_gid;
 			goto nocopy;
 
 		/* fmask fall through to file_mode */
@@ -1171,34 +1172,35 @@ nocopy:
 
 	/* special-case the uid and gid */
 	if (got_uid) {
-		word_len = strlen(user);
+		word_len = snprintf(txtbuf, sizeof(txtbuf), "%u", uid);
 
+		/* comma + "uid=" + terminating NULL == 6 */
 		if (out_len + word_len + 6 > MAX_OPTIONS_LEN) {
 			fprintf(stderr, "Options string too long\n");
 			return EX_USAGE;
 		}
 
 		if (out_len) {
-			strlcat(out, ",", out_len + word_len + 6);
+			strlcat(out, ",", MAX_OPTIONS_LEN);
 			out_len++;
 		}
-		snprintf(out + out_len, word_len + 5, "uid=%s", user);
+		snprintf(out + out_len, word_len + 5, "uid=%s", txtbuf);
 		out_len = strlen(out);
 	}
 	if (got_gid) {
-		word_len = strlen(group);
+		word_len = snprintf(txtbuf, sizeof(txtbuf), "%u", gid);
 
-		if (out_len + 1 + word_len + 6 > MAX_OPTIONS_LEN) {
+		/* comma + "gid=" + terminating NULL == 6 */
+		if (out_len + word_len + 6 > MAX_OPTIONS_LEN) {
 			fprintf(stderr, "Options string too long\n");
 			return EX_USAGE;
 		}
 
 		if (out_len) {
-			strlcat(out, ",", out_len + word_len + 6);
+			strlcat(out, ",", MAX_OPTIONS_LEN);
 			out_len++;
 		}
-		snprintf(out + out_len, word_len + 5, "gid=%s", group);
-		out_len = strlen(out);
+		snprintf(out + out_len, word_len + 5, "gid=%s", txtbuf);
 	}
 
 	return 0;
-- 
1.7.3.4
