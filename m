From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: Add mount options for backup intent and their manpages (try #7)
Date: Sat,  8 Oct 2011 15:39:45 -0500
Message-ID: <1318106385-8247-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Add mount options backupuid and backugid and their manpage contents.
Check for either a valid uid/gid or valid user/group name.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mount.cifs.8 |   40 ++++++++++++++++++++++++++++
 mount.cifs.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 81ebdbe..9391294 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -282,6 +282,20 @@ See sections on
 for more information\&.
 .RE
 .PP
+backupuid
+.RS 4
+Restrict access to files, with the backup intent, to a user\&.
+.sp
+See section \fIACCESSING FILES WITH BACKUP INTENT\fR for more details
+.RE
+.PP
+backupgid
+.RS 4
+Restrict Allow access to files, with the backup intent, to a group\&.
+.sp
+See section \fIACCESSING FILES WITH BACKUP INTENT\fR for more details
+.RE
+.PP
 nocase
 .RS 4
 Request case insensitive path name matching (case sensitive is the default if the server suports it)\&.
@@ -590,6 +604,32 @@ The mapping between a CIFS/NTFS ACL and POSIX file permission bits is imperfect
 .\}
 If either upcall to cifs.idmap is not setup correctly or winbind is not configured and running, ID mapping will fail. In that case uid and gid will default to either to those values of the share or to the values of uid and/or gid mount options if specified.
 .RE
+.SH "ACCESSING FILES WITH BACKUP INTENT"
+.PP
+For an user on the server, desired access to a file is determined by the permissions and rights associated with that file.  This is typically accomplished using owenrship and ACL.  For a user who does not have access rights to a file, it is still possible to access that file for a specific or a targeted purpose by granting special rights.  One of the specific purposes is to access a file with the intent to either backup or restore i.e. backup intent.  The right to access a file with the backup intent can typically be granted by making that user a part of the built-in group Backup Operators.  Thus, when this user attempts to open a file with the backup intent, open request is sent by setting the bit FILE_OPEN_FOR_BACKUP_INTENT as one of the CreateOptions.
+
+As an example, on a Windows server, a user named testuser, cannot open this file with such a security descriptor.
+.PP
+REVISION:0x1
+.sp 0
+CONTROL:0x9404
+.sp 0
+OWNER:Administrator
+.sp 0
+GROUP:Domain Users
+.sp 0
+ACL:Administrator:ALLOWED/0x0/FULL
+.PP
+But the user testuser, if it becomes part of the group Backup Operators, can open the file with the backup intent.
+
+Any user on the client side who can authenticate as such a user on the server,
+can access the files with the backup intent. But it is desirable and preferable for security reasons amongst many, to restrict this special right.
+
+The mount option backupuid is used to restrict this special right to a user which is specified by either a name or an id.
+.sp 0
+The mount option backupgid is used to restrict this special right to the users in a group which is specified by either a name or an id.
+.sp 0
+These two mount options can be used together.
 .SH "FILE AND DIRECTORY OWNERSHIP AND PERMISSIONS"
 .PP
 The core CIFS protocol does not provide unix ownership information or mode for files and directories\&. Because of this, files and directories will generally appear to be owned by whatever values the uid= or gid= options are set, and will have permissions set to the default file_mode and dir_mode for the mount\&. Attempting to change these values via chmod/chown will return success but have no effect\&.
diff --git a/mount.cifs.c b/mount.cifs.c
index 1e3d534..d6cb755 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -158,6 +158,8 @@
 #define OPT_MAND       27
 #define OPT_NOMAND     28
 #define OPT_CRUID      29
+#define OPT_BKUPUID    30
+#define OPT_BKUPGID    31
 
 
 /* struct for holding parsed mount info for use by privleged process */
@@ -843,6 +845,10 @@ static int parse_opt_token(const char *token)
 		return OPT_REMOUNT;
 	if (strncmp(token, "_netdev", 7) == 0)
 		return OPT_IGNORE;
+	if (strncmp(token, "backupuid", 9) == 0)
+		return OPT_BKUPUID;
+	if (strncmp(token, "backupgid", 9) == 0)
+		return OPT_BKUPGID;
 
 	return OPT_ERROR;
 }
@@ -858,11 +864,13 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 	int out_len = 0;
 	int word_len;
 	int rc = 0;
+	int got_bkupuid = 0;
+	int got_bkupgid = 0;
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
@@ -906,6 +914,8 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			value = equals + 1;
 		}
 
+		ep = NULL;
+
 		switch(parse_opt_token(data)) {
 		case OPT_USERS:
 			if (!value || !*value) {
@@ -1171,6 +1181,42 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			break;
 		case OPT_IGNORE:
 			goto nocopy;
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
@@ -1246,6 +1292,38 @@ nocopy:
 		}
 		snprintf(out + out_len, word_len + 5, "gid=%s", txtbuf);
 	}
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
