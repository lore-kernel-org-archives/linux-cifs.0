From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: Add mount options for backup intent and their manpages [try #2]
Date: Tue, 20 Sep 2011 13:26:06 -0500
Message-ID: <1316543166-12046-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Add mount options backupuid and backugid and their manpage contents.

These mount options are mutually excluisve to mount option  mulituser.

Check for either a valid uid/gid or valid user/group name.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 mount.cifs.8 |   14 ++++++++
 mount.cifs.c |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 108 insertions(+), 8 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 64a8b64..242d01d 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -282,6 +282,20 @@ See sections on
 for more information\&.
 .RE
 .PP
+backupuid
+.RS 4
+Allow access to files with the intent to back them up for a user\&.
+.sp
+This option works with the option cifsacl. It is mutually exclusive to the option multiuser. It restricts to an user, specified either as an uid or a user name, as an authenticated user at the server, access to files with the intent to back them up including their ACLs, who otherwise may not have access permissions but has "Backup files and directories user right" on them (e.g. by virtue of that authenticated user being part of the built-in group Backup Operators at the server).
+.RE
+.PP
+backupgid
+.RS 4
+Allow access to files with the intent to back them up for a group\&.
+.sp
+This option works with the option cifsacl. It is mutually exclusive to the option multiuser. It restricts to an user in a group, specified either as a gid or a group name, as an authenticated user at the server, access to files with the intent to back them up including their ACLs, who otherwise may not have access permissions but has "Backup files and directories user right" on them (e.g. by virtue of that authenticated user being part of the built-in group Backup Operators at the server).
+.RE
+.PP
 nocase
 .RS 4
 Request case insensitive path name matching (case sensitive is the default if the server suports it)\&.
diff --git a/mount.cifs.c b/mount.cifs.c
index 1e3d534..8ef7f44 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -158,6 +158,9 @@
 #define OPT_MAND       27
 #define OPT_NOMAND     28
 #define OPT_CRUID      29
+#define OPT_MULTIU     30
+#define OPT_BKUPUID    31
+#define OPT_BKUPGID    32
 
 
 /* struct for holding parsed mount info for use by privleged process */
@@ -843,6 +846,12 @@ static int parse_opt_token(const char *token)
 		return OPT_REMOUNT;
 	if (strncmp(token, "_netdev", 7) == 0)
 		return OPT_IGNORE;
+	if (strncmp(token, "multiuser", 9) == 0)
+		return OPT_MULTIU;
+	if (strncmp(token, "backupuid", 9) == 0)
+		return OPT_BKUPUID;
+	if (strncmp(token, "backupgid", 9) == 0)
+		return OPT_BKUPGID;
 
 	return OPT_ERROR;
 }
@@ -858,11 +867,14 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 	int out_len = 0;
 	int word_len;
 	int rc = 0;
+	int got_bkupuid = 0;
+	int got_bkupgid = 0;
+	int got_multiu = 0;
 	int got_uid = 0;
 	int got_cruid = 0;
 	int got_gid = 0;
-	uid_t uid, cruid = 0;
-	gid_t gid;
+	uid_t uid, cruid = 0, bkupuid;
+	gid_t gid, bkupgid;
 	char *ep;
 	struct passwd *pw;
 	struct group *gr;
@@ -1031,9 +1043,8 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 				goto nocopy;
 
 			got_uid = 1;
-			errno = 0;
 			uid = strtoul(value, &ep, 10);
-			if (errno == 0)
+			if (!strlen(ep))
 				goto nocopy;
 
 			pw = getpwnam(value);
@@ -1050,9 +1061,8 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 				goto nocopy;
 
 			got_cruid = 1;
-			errno = 0;
 			cruid = strtoul(value, &ep, 10);
-			if (errno == 0)
+			if (!strlen(ep))
 				goto nocopy;
 
 			pw = getpwnam(value);
@@ -1068,9 +1078,8 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 				goto nocopy;
 
 			got_gid = 1;
-			errno = 0;
 			gid = strtoul(value, &ep, 10);
-			if (errno == 0)
+			if (!strlen(ep))
 				goto nocopy;
 
 			gr = getgrnam(value);
@@ -1171,6 +1180,45 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			break;
 		case OPT_IGNORE:
 			goto nocopy;
+		case OPT_MULTIU:
+			got_multiu = 1;
+			break;
+		case OPT_BKUPUID:
+			if (!value || !*value)
+				goto nocopy;
+
+			got_bkupuid = 1;
+			bkupuid = strtoul(value, &ep, 10);
+			if (!strlen(ep))
+				goto nocopy;
+
+			pw = getpwnam(value);
+			if (pw == NULL) {
+				fprintf(stderr,
+					"bad user name \"%s\"\n", value);
+				return EX_USAGE;
+			}
+
+			bkupuid = pw->pw_uid;
+			goto nocopy;
+		case OPT_BKUPGID:
+			if (!value || !*value)
+				goto nocopy;
+
+			got_bkupgid = 1;
+			bkupgid = strtoul(value, &ep, 10);
+			if (!strlen(ep))
+				goto nocopy;
+
+			gr = getgrnam(value);
+			if (gr == NULL) {
+				fprintf(stderr,
+					"bad group name \"%s\"\n", value);
+				return EX_USAGE;
+			}
+
+			bkupgid = gr->gr_gid;
+			goto nocopy;
 		}
 
 		/* check size before copying option to buffer */
@@ -1246,6 +1294,44 @@ nocopy:
 		}
 		snprintf(out + out_len, word_len + 5, "gid=%s", txtbuf);
 	}
+	if ((got_bkupuid || got_bkupgid) && got_multiu) {
+		fprintf(stderr,
+		"Options backup id and multiuser are mutually exclusive\n");
+		return EX_USAGE;
+	}
+	/* special-case the uid and gid */
+	if (got_bkupuid) {
+		word_len = snprintf(txtbuf, sizeof(txtbuf), "%u", bkupuid);
+
+		/* comma + "uid=" + terminating NULL == 6 */
+		if (out_len + word_len + 6 > MAX_OPTIONS_LEN) {
+			fprintf(stderr, "Options string too long\n");
+			return EX_USAGE;
+		}
+
+		if (out_len) {
+			strlcat(out, ",", MAX_OPTIONS_LEN);
+			out_len++;
+		}
+		snprintf(out + out_len, word_len + 11, "backupuid=%s", txtbuf);
+		out_len = strlen(out);
+	}
+	if (got_bkupgid) {
+		word_len = snprintf(txtbuf, sizeof(txtbuf), "%u", bkupgid);
+
+		/* comma + "backkupgid=" + terminating NULL == 6 */
+		if (out_len + word_len + 6 > MAX_OPTIONS_LEN) {
+			fprintf(stderr, "Options string too long\n");
+			return EX_USAGE;
+		}
+
+		if (out_len) {
+			strlcat(out, ",", MAX_OPTIONS_LEN);
+			out_len++;
+		}
+		snprintf(out + out_len, word_len + 11, "backupgid=%s", txtbuf);
+	}
+
 	return 0;
 }
 
-- 
1.6.0.2
