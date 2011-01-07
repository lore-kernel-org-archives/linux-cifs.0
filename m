From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/5] cifs.upcall: save off username field from key description
Date: Fri,  7 Jan 2011 09:11:43 -0500
Message-ID: <1294409505-2999-4-git-send-email-jlayton@samba.org>
References: <1294409505-2999-1-git-send-email-jlayton@samba.org>
Cc: niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294409505-2999-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index d83dddf..12df8cc 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -444,12 +444,14 @@ handle_krb5_mech(const char *oid, const char *principal, DATA_BLOB * secblob,
 #define DKD_HAVE_UID		0x10
 #define DKD_HAVE_PID		0x20
 #define DKD_HAVE_CREDUID	0x40
+#define DKD_HAVE_USERNAME	0x80
 #define DKD_MUSTHAVE_SET (DKD_HAVE_HOSTNAME|DKD_HAVE_VERSION|DKD_HAVE_SEC)
 
 struct decoded_args {
 	int ver;
 	char *hostname;
 	char *ip;
+	char *username;
 	uid_t uid;
 	uid_t creduid;
 	pid_t pid;
@@ -495,6 +497,20 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				return 1;
 			}
 			retval |= DKD_HAVE_IP;
+		} else if (strncmp(tkn, "user=", 5) == 0) {
+			if (pos == NULL)
+				len = strlen(tkn);
+			else
+				len = pos - tkn;
+
+			len -= 5;
+			SAFE_FREE(arg->username);
+			arg->username = strndup(tkn + 5, len);
+			if (arg->username == NULL) {
+				syslog(LOG_ERR, "Unable to allocate memory");
+				return 1;
+			}
+			retval |= DKD_HAVE_USERNAME;
 		} else if (strncmp(tkn, "pid=", 4) == 0) {
 			errno = 0;
 			arg->pid = strtol(tkn + 4, NULL, 0);
@@ -865,6 +881,7 @@ out:
 	SAFE_FREE(ccname);
 	SAFE_FREE(arg.hostname);
 	SAFE_FREE(arg.ip);
+	SAFE_FREE(arg.username);
 	SAFE_FREE(keydata);
 	return rc;
 }
-- 
1.7.3.4
