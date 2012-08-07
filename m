From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: handle username= differently depending on sec= option
Date: Tue,  7 Aug 2012 12:33:47 -0400
Message-ID: <1344357227-9683-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch is intended as a temporary workaround for krb5 users that need
to specify usernames with '/' in them. I intend to remove this hack from
mount.cifs once the legacy username handling code is removed.

The idea here is to save off the raw username string while we're parsing
options. If the mount options specify "sec=krb5" or "sec=krb5i" then
we'll not do the legacy username parsing and will instead just pass in
the username string as-is.

Obviously, this is a nasty hack and we don't really want to carry this
in perpetuity, so this can go away once the "legacy" username parsing
has gone away.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c | 45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index ef5b43f..f843bb4 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -588,7 +588,8 @@ parsing_err:
 }
 
 static int open_cred_file(char *file_name,
-			struct parsed_mount_info *parsed_info)
+			struct parsed_mount_info *parsed_info,
+			char **saved_username)
 {
 	char *line_buf = NULL;
 	char *temp_val = NULL;
@@ -637,9 +638,11 @@ static int open_cred_file(char *file_name,
 		/* parse next token */
 		switch (parse_cred_line(line_buf + i, &temp_val)) {
 		case CRED_USER:
-			i = parse_username(temp_val, parsed_info);
-			if (i)
+			*saved_username = strdup(temp_val);
+			if (!*saved_username) {
+				i = EX_SYSERR;
 				goto return_i;
+			}
 			break;
 		case CRED_PASS:
 			i = set_password(parsed_info, temp_val);
@@ -827,6 +830,8 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 	char *ep;
 	struct passwd *pw;
 	struct group *gr;
+	char *saved_username = NULL;
+	bool krb5_auth = false;
 	/*
 	 * max 32-bit uint in decimal is 4294967295 which is 10 chars wide
 	 * +1 for NULL, and +1 for good measure
@@ -894,11 +899,10 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 					fprintf(stderr, "username too long\n");
 					return EX_USAGE;
 				}
-				rc = parse_username(value, parsed_info);
-				if (rc) {
-					fprintf(stderr,
-						"problem parsing username\n");
-					return rc;
+				saved_username = strdup(value);
+				if (!saved_username) {
+					fprintf(stderr, "Unable to allocate memory!\n");
+					return EX_SYSERR;
 				}
 				goto nocopy;
 			}
@@ -920,9 +924,12 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 
 		case OPT_SEC:
 			if (value) {
-				if (!strncmp(value, "none", 4) ||
-				    !strncmp(value, "krb5", 4))
+				if (!strncmp(value, "none", 4)) {
+					parsed_info->got_password = 1;
+				} else if (!strncmp(value, "krb5", 4)) {
 					parsed_info->got_password = 1;
+					krb5_auth = true;
+				}
 			}
 			break;
 
@@ -978,7 +985,7 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 					"invalid credential file name specified\n");
 				return EX_USAGE;
 			}
-			rc = open_cred_file(value, parsed_info);
+			rc = open_cred_file(value, parsed_info, &saved_username);
 			if (rc) {
 				fprintf(stderr,
 					"error %d (%s) opening credential file %s\n",
@@ -1197,6 +1204,22 @@ nocopy:
 		data = next_keyword;
 	}
 
+	if (saved_username) {
+		if (krb5_auth) {
+			strlcpy(parsed_info->username, saved_username,
+				sizeof(parsed_info->username));
+			parsed_info->got_user = 1;
+		} else {
+			rc = parse_username(saved_username, parsed_info);
+			free(saved_username);
+			if (rc) {
+				fprintf(stderr, "Unable to parse username!\n");
+				return rc;
+			}
+		}
+	}
+
+
 	/* special-case the uid and gid */
 	if (got_uid) {
 		word_len = snprintf(txtbuf, sizeof(txtbuf), "%u", uid);
-- 
1.7.11.2
