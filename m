From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 4/5] cifs.upcall: debug logging for the key description parser
Date: Fri,  7 Jan 2011 09:11:44 -0500
Message-ID: <1294409505-2999-5-git-send-email-jlayton@samba.org>
References: <1294409505-2999-1-git-send-email-jlayton@samba.org>
Cc: niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294409505-2999-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 12df8cc..3dbcd6e 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -483,6 +483,7 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				return 1;
 			}
 			retval |= DKD_HAVE_HOSTNAME;
+			syslog(LOG_DEBUG, "host=%s", arg->hostname);
 		} else if (!strncmp(tkn, "ip4=", 4) || !strncmp(tkn, "ip6=", 4)) {
 			if (pos == NULL)
 				len = strlen(tkn);
@@ -497,6 +498,7 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				return 1;
 			}
 			retval |= DKD_HAVE_IP;
+			syslog(LOG_DEBUG, "ip=%s", arg->ip);
 		} else if (strncmp(tkn, "user=", 5) == 0) {
 			if (pos == NULL)
 				len = strlen(tkn);
@@ -511,6 +513,7 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				return 1;
 			}
 			retval |= DKD_HAVE_USERNAME;
+			syslog(LOG_DEBUG, "user=%s", arg->username);
 		} else if (strncmp(tkn, "pid=", 4) == 0) {
 			errno = 0;
 			arg->pid = strtol(tkn + 4, NULL, 0);
@@ -519,6 +522,7 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				       strerror(errno));
 				return 1;
 			}
+			syslog(LOG_DEBUG, "pid=%u", arg->pid);
 			retval |= DKD_HAVE_PID;
 		} else if (strncmp(tkn, "sec=", 4) == 0) {
 			if (strncmp(tkn + 4, "krb5", 4) == 0) {
@@ -528,6 +532,7 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				retval |= DKD_HAVE_SEC;
 				arg->sec = MS_KRB5;
 			}
+			syslog(LOG_DEBUG, "sec=%d", arg->sec);
 		} else if (strncmp(tkn, "uid=", 4) == 0) {
 			errno = 0;
 			arg->uid = strtol(tkn + 4, NULL, 16);
@@ -537,6 +542,7 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				return 1;
 			}
 			retval |= DKD_HAVE_UID;
+			syslog(LOG_DEBUG, "uid=%u", arg->uid);
 		} else if (strncmp(tkn, "creduid=", 8) == 0) {
 			errno = 0;
 			arg->creduid = strtol(tkn + 8, NULL, 16);
@@ -546,6 +552,7 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				return 1;
 			}
 			retval |= DKD_HAVE_CREDUID;
+			syslog(LOG_DEBUG, "creduid=%u", arg->creduid);
 		} else if (strncmp(tkn, "ver=", 4) == 0) {	/* if version */
 			errno = 0;
 			arg->ver = strtol(tkn + 4, NULL, 16);
@@ -555,6 +562,7 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				return 1;
 			}
 			retval |= DKD_HAVE_VERSION;
+			syslog(LOG_DEBUG, "ver=%d", arg->ver);
 		}
 		if (pos == NULL)
 			break;
-- 
1.7.3.4
