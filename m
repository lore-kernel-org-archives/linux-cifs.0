From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/2] mount.cifs: add cruid= mount option
Date: Wed, 12 Jan 2011 15:26:36 -0500
Message-ID: <1294863996-7678-2-git-send-email-jlayton@samba.org>
References: <1294863996-7678-1-git-send-email-jlayton@samba.org>
Cc: walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org, metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294863996-7678-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Allow admins to pass in a username for the cruid= mount option.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 |    5 +++++
 mount.cifs.c |   40 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 5f82ac9..469440d 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -120,6 +120,11 @@ forceuid
 instructs the client to ignore any uid provided by the server for files and directories and to always assign the owner to be the value of the uid= option\&. See the section on FILE AND DIRECTORY OWNERSHIP AND PERMISSIONS below for more information\&.
 .RE
 .PP
+cruid=\fIarg\fR
+.RS 4
+sets the uid of the owner of the credentials cache\&. This is primarily useful with sec=krb5\&. The default is the real uid of the process performing the mount\&. Setting this parameter directs the upcall to look for a credentials cache owned by that user\&.
+.RE
+.PP
 gid=\fIarg\fR
 .RS 4
 sets the gid that will own all files or directories on the mounted filesystem when the server does not provide ownership information\&. It may be specified as either a groupname or a numeric gid\&. When not specified, the default is gid 0\&. The mount\&.cifs helper must be at version 1\&.10 or higher to support specifying the gid in non\-numeric form\&. See the section on FILE AND DIRECTORY OWNERSHIP AND PERMISSIONS below for more information\&.
diff --git a/mount.cifs.c b/mount.cifs.c
index 8fccf44..41da67e 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -157,6 +157,7 @@
 #define OPT_REMOUNT    26
 #define OPT_MAND       27
 #define OPT_NOMAND     28
+#define OPT_CRUID      29
 
 
 /* struct for holding parsed mount info for use by privleged process */
@@ -802,6 +803,8 @@ static int parse_opt_token(const char *token)
 		return OPT_CRED;
 	if (strncmp(token, "uid", 3) == 0)
 		return OPT_UID;
+	if (strncmp(token, "cruid", 5) == 0)
+		return OPT_CRUID;
 	if (strncmp(token, "gid", 3) == 0)
 		return OPT_GID;
 	if (strncmp(token, "fmask", 5) == 0)
@@ -856,8 +859,9 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 	int word_len;
 	int rc = 0;
 	int got_uid = 0;
+	int got_cruid = 0;
 	int got_gid = 0;
-	uid_t uid;
+	uid_t uid, cruid;
 	gid_t gid;
 	char txtbuf[12];
 	char *ep;
@@ -1036,6 +1040,23 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			uid = pw->pw_uid;
 			goto nocopy;
 
+		case OPT_CRUID:
+			if (!value || !*value)
+				goto nocopy;
+
+			got_cruid = 1;
+			cruid = strtoul(value, &ep, 10);
+			if (errno != EINVAL && *ep == '\0')
+				goto nocopy;
+
+			pw = getpwnam(value);
+			if (pw == NULL) {
+				fprintf(stderr, "bad user name \"%s\"\n", value);
+				return EX_USAGE;
+			}
+			cruid = pw->pw_uid;
+			goto nocopy;
+
 		case OPT_GID:
 			if (!value || !*value)
 				goto nocopy;
@@ -1187,6 +1208,22 @@ nocopy:
 		snprintf(out + out_len, word_len + 5, "uid=%s", txtbuf);
 		out_len = strlen(out);
 	}
+	if (got_cruid) {
+		word_len = snprintf(txtbuf, sizeof(txtbuf), "%u", cruid);
+
+		/* comma + "cruid=" + terminating NULL == 6 */
+		if (out_len + word_len + 8 > MAX_OPTIONS_LEN) {
+			fprintf(stderr, "Options string too long\n");
+			return EX_USAGE;
+		}
+
+		if (out_len) {
+			strlcat(out, ",", MAX_OPTIONS_LEN);
+			out_len++;
+		}
+		snprintf(out + out_len, word_len + 7, "cruid=%s", txtbuf);
+		out_len = strlen(out);
+	}
 	if (got_gid) {
 		word_len = snprintf(txtbuf, sizeof(txtbuf), "%u", gid);
 
@@ -1202,7 +1239,6 @@ nocopy:
 		}
 		snprintf(out + out_len, word_len + 5, "gid=%s", txtbuf);
 	}
-
 	return 0;
 }
 
-- 
1.7.3.4
