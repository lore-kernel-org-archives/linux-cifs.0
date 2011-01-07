From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/5] cifs.upcall: clean up key description decoding routine
Date: Fri,  7 Jan 2011 09:11:42 -0500
Message-ID: <1294409505-2999-3-git-send-email-jlayton@samba.org>
References: <1294409505-2999-1-git-send-email-jlayton@samba.org>
Cc: niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294409505-2999-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and switch the code to using strndup. Check for allocation errors as
well, and fix some off-by-one bugs in the ones that decode strings.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 33b7e4c..d83dddf 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -473,10 +473,13 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 			else
 				len = pos - tkn;
 
-			len -= 4;
+			len -= 5;
 			SAFE_FREE(arg->hostname);
-			arg->hostname = calloc(sizeof(char), len);
-			strlcpy(arg->hostname, tkn + 5, len);
+			arg->hostname = strndup(tkn + 5, len);
+			if (arg->hostname == NULL) {
+				syslog(LOG_ERR, "Unable to allocate memory");
+				return 1;
+			}
 			retval |= DKD_HAVE_HOSTNAME;
 		} else if (!strncmp(tkn, "ip4=", 4) || !strncmp(tkn, "ip6=", 4)) {
 			if (pos == NULL)
@@ -484,10 +487,13 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 			else
 				len = pos - tkn;
 
-			len -= 3;
+			len -= 4;
 			SAFE_FREE(arg->ip);
-			arg->ip = calloc(sizeof(char), len);
-			strlcpy(arg->ip, tkn + 4, len);
+			arg->ip = strndup(tkn + 4, len);
+			if (arg->ip == NULL) {
+				syslog(LOG_ERR, "Unable to allocate memory");
+				return 1;
+			}
 			retval |= DKD_HAVE_IP;
 		} else if (strncmp(tkn, "pid=", 4) == 0) {
 			errno = 0;
@@ -496,9 +502,8 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				syslog(LOG_ERR, "Invalid pid format: %s",
 				       strerror(errno));
 				return 1;
-			} else {
-				retval |= DKD_HAVE_PID;
 			}
+			retval |= DKD_HAVE_PID;
 		} else if (strncmp(tkn, "sec=", 4) == 0) {
 			if (strncmp(tkn + 4, "krb5", 4) == 0) {
 				retval |= DKD_HAVE_SEC;
@@ -514,9 +519,8 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				syslog(LOG_ERR, "Invalid uid format: %s",
 				       strerror(errno));
 				return 1;
-			} else {
-				retval |= DKD_HAVE_UID;
 			}
+			retval |= DKD_HAVE_UID;
 		} else if (strncmp(tkn, "creduid=", 8) == 0) {
 			errno = 0;
 			arg->creduid = strtol(tkn + 8, NULL, 16);
@@ -524,9 +528,8 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				syslog(LOG_ERR, "Invalid creduid format: %s",
 				       strerror(errno));
 				return 1;
-			} else {
-				retval |= DKD_HAVE_CREDUID;
 			}
+			retval |= DKD_HAVE_CREDUID;
 		} else if (strncmp(tkn, "ver=", 4) == 0) {	/* if version */
 			errno = 0;
 			arg->ver = strtol(tkn + 4, NULL, 16);
@@ -534,9 +537,8 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				syslog(LOG_ERR, "Invalid version format: %s",
 				       strerror(errno));
 				return 1;
-			} else {
-				retval |= DKD_HAVE_VERSION;
 			}
+			retval |= DKD_HAVE_VERSION;
 		}
 		if (pos == NULL)
 			break;
-- 
1.7.3.4
