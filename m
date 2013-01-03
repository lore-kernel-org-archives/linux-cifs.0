From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: remove support for "complex" usernames from mount.cifs
Date: Thu,  3 Jan 2013 06:54:15 -0500
Message-ID: <1357214055-24911-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In commit 569cfcb3a, we added a warning of the removal for support for
username= options in the form of DOMAIN/username%password. This patch
removes that support as promised prior to the 5.9 release.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c | 111 +++++------------------------------------------------------
 1 file changed, 9 insertions(+), 102 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 869af35..c7c3055 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -316,65 +316,6 @@ static int set_password(struct parsed_mount_info *parsed_info, const char *src)
 	return 0;
 }
 
-/*
- * Parse a username string into parsed_mount_info fields. The format is:
- *
- * DOMAIN\username%password
- *
- * ...obviously the only required component is "username". The source string
- * is modified in the process, but it should remain unchanged at the end.
- *
- * NOTE: the above syntax does not allow for usernames that have slashes in
- * them, as some krb5 usernames do. Support for the above syntax will be
- * removed in a later version of cifs-utils. Users should use separate options
- * instead of overloading this info into the username.
- */
-static int parse_username(char *rawuser, struct parsed_mount_info *parsed_info)
-{
-	char *user, *password, slash;
-	int rc = 0;
-	bool warn = false;
-
-	/* everything after first % sign is a password */
-	password = strchr(rawuser, '%');
-	if (password) {
-		warn = true;
-		rc = set_password(parsed_info, password + 1);
-		if (rc)
-			return rc;
-		*password = '\0';
-	}
-
-	/* everything after first '/' or '\' is a username */
-	user = strchr(rawuser, '/');
-	if (!user)
-		user = strchr(rawuser, '\\');
-
-	/* everything before that slash is a domain */
-	if (user) {
-		warn = true;
-		slash = *user;
-		*user = '\0';
-		strlcpy(parsed_info->domain, rawuser,
-			sizeof(parsed_info->domain));
-		*(user++) = slash;
-	} else {
-		user = rawuser;
-	}
-
-	strlcpy(parsed_info->username, user, sizeof(parsed_info->username));
-	parsed_info->got_user = 1;
-	if (password)
-		*password = '%';
-
-	if (warn)
-		fprintf(stderr, "WARNING: The DOMAIN/username%%password syntax "
-				"for usernames is deprecated and will be "
-				"removed in version 5.9 of cifs-utils.\n");
-
-	return 0;
-}
-
 #ifdef HAVE_LIBCAP_NG
 static int
 drop_capabilities(int parent)
@@ -590,8 +531,7 @@ parsing_err:
 }
 
 static int open_cred_file(char *file_name,
-			struct parsed_mount_info *parsed_info,
-			char **saved_username)
+			struct parsed_mount_info *parsed_info)
 {
 	char *line_buf = NULL;
 	char *temp_val = NULL;
@@ -640,11 +580,8 @@ static int open_cred_file(char *file_name,
 		/* parse next token */
 		switch (parse_cred_line(line_buf + i, &temp_val)) {
 		case CRED_USER:
-			*saved_username = strdup(temp_val);
-			if (!*saved_username) {
-				i = EX_SYSERR;
-				goto return_i;
-			}
+			strlcpy(parsed_info->username, temp_val,
+				sizeof(parsed_info->domain));
 			break;
 		case CRED_PASS:
 			i = set_password(parsed_info, temp_val);
@@ -834,8 +771,6 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 	char *ep;
 	struct passwd *pw;
 	struct group *gr;
-	char *saved_username = NULL;
-	bool krb5_auth = false;
 	/*
 	 * max 32-bit uint in decimal is 4294967295 which is 10 chars wide
 	 * +1 for NULL, and +1 for good measure
@@ -895,19 +830,9 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 					return EX_USAGE;
 				}
 			} else {
-				/* domain/username%password  + NULL term. */
-				const size_t max = MAX_DOMAIN_SIZE +
-						   MAX_USERNAME_SIZE +
-						   MOUNT_PASSWD_SIZE + 2 + 1;
-				if (strnlen(value, max) >= max) {
-					fprintf(stderr, "username too long\n");
-					return EX_USAGE;
-				}
-				saved_username = strdup(value);
-				if (!saved_username) {
-					fprintf(stderr, "Unable to allocate memory!\n");
-					return EX_SYSERR;
-				}
+				strlcpy(parsed_info->username, value,
+					sizeof(parsed_info->username));
+				parsed_info->got_user = 1;
 				goto nocopy;
 			}
 
@@ -928,12 +853,9 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 
 		case OPT_SEC:
 			if (value) {
-				if (!strncmp(value, "none", 4)) {
-					parsed_info->got_password = 1;
-				} else if (!strncmp(value, "krb5", 4)) {
+				if (!strncmp(value, "none", 4) ||
+				    !strncmp(value, "krb5", 4))
 					parsed_info->got_password = 1;
-					krb5_auth = true;
-				}
 			}
 			break;
 
@@ -989,7 +911,7 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 					"invalid credential file name specified\n");
 				return EX_USAGE;
 			}
-			rc = open_cred_file(value, parsed_info, &saved_username);
+			rc = open_cred_file(value, parsed_info);
 			if (rc) {
 				fprintf(stderr,
 					"error %d (%s) opening credential file %s\n",
@@ -1201,21 +1123,6 @@ nocopy:
 		data = next_keyword;
 	}
 
-	if (saved_username) {
-		if (krb5_auth) {
-			strlcpy(parsed_info->username, saved_username,
-				sizeof(parsed_info->username));
-			parsed_info->got_user = 1;
-		} else {
-			rc = parse_username(saved_username, parsed_info);
-			free(saved_username);
-			if (rc) {
-				fprintf(stderr, "Unable to parse username!\n");
-				return rc;
-			}
-		}
-	}
-
 
 	/* special-case the uid and gid */
 	if (got_uid) {
-- 
1.7.11.7
