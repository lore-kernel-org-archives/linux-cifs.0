From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 5/8] treewide: Eliminate SAFE_FREE
Date: Fri, 24 Feb 2017 09:27:47 -0500
Message-ID: <20170224142750.4151-6-jlayton@samba.org>
References: <20170224142750.4151-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, ssorce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170224142750.4151-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It just frees and then zeroes out the pointer. That's of dubious
value in the places where it's currently being used. Just use
free() instead.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c | 22 ++++++++++------------
 mount.cifs.c  | 16 +++++-----------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index cfc926cd9d09..15e1e0f91c22 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -82,8 +82,6 @@ typedef enum _sectype {
 #define KRB5_KEY_DATA_CAST      krb5_octet
 #endif
 
-#define SAFE_FREE(x) do { if ((x) != NULL) {free(x); x = NULL; } } while (0)
-
 #ifdef HAVE_LIBCAP_NG
 static int
 trim_capabilities(bool need_environ)
@@ -162,7 +160,7 @@ static char *cifs_krb5_principal_get_realm(krb5_principal principal)
 #if !defined(HAVE_KRB5_FREE_UNPARSED_NAME)
 static void krb5_free_unparsed_name(krb5_context context, char *val)
 {
-	SAFE_FREE(val);
+	free(val);
 }
 #endif
 
@@ -650,7 +648,7 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				len = pos - tkn;
 
 			len -= 5;
-			SAFE_FREE(arg->hostname);
+			free(arg->hostname);
 			arg->hostname = strndup(tkn + 5, len);
 			if (arg->hostname == NULL) {
 				syslog(LOG_ERR, "Unable to allocate memory");
@@ -665,7 +663,7 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				len = pos - tkn;
 
 			len -= 4;
-			SAFE_FREE(arg->ip);
+			free(arg->ip);
 			arg->ip = strndup(tkn + 4, len);
 			if (arg->ip == NULL) {
 				syslog(LOG_ERR, "Unable to allocate memory");
@@ -680,7 +678,7 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 				len = pos - tkn;
 
 			len -= 5;
-			SAFE_FREE(arg->username);
+			free(arg->username);
 			arg->username = strndup(tkn + 5, len);
 			if (arg->username == NULL) {
 				syslog(LOG_ERR, "Unable to allocate memory");
@@ -968,7 +966,7 @@ int main(const int argc, char *const argv[])
 	}
 
 	have = decode_key_description(buf, &arg);
-	SAFE_FREE(buf);
+	free(buf);
 	if ((have & DKD_MUSTHAVE_SET) != DKD_MUSTHAVE_SET) {
 		syslog(LOG_ERR, "unable to get necessary params from key "
 		       "description (0x%x)", have);
@@ -1207,11 +1205,11 @@ out:
 		krb5_cc_close(context, ccache);
 	if (context)
 		krb5_free_context(context);
-	SAFE_FREE(arg.hostname);
-	SAFE_FREE(arg.ip);
-	SAFE_FREE(arg.username);
-	SAFE_FREE(keydata);
-	SAFE_FREE(env_cachename);
+	free(arg.hostname);
+	free(arg.ip);
+	free(arg.username);
+	free(keydata);
+	free(env_cachename);
 	syslog(LOG_DEBUG, "Exit status %ld", rc);
 	return rc;
 }
diff --git a/mount.cifs.c b/mount.cifs.c
index b2bcb7f16b9f..13b71ef50303 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -61,6 +61,7 @@
 #include "mount.h"
 #include "util.h"
 #include "resolve_host.h"
+#include "data_blob.h"
 
 #ifndef MS_MOVE 
 #define MS_MOVE 8192 
@@ -101,13 +102,6 @@
 /* Max password size. */
 #define MOUNT_PASSWD_SIZE 512
 
-
-
-#ifndef SAFE_FREE
-#define SAFE_FREE(x) do { if ((x) != NULL) {free(x); x = NULL; } } while (0)
-#endif
-
-
 /*
  * mount.cifs has been the subject of many "security" bugs that have arisen
  * because of users and distributions installing it as a setuid root program
@@ -621,7 +615,7 @@ return_i:
 	/* make sure passwords are scrubbed from memory */
 	if (line_buf != NULL)
 		memset(line_buf, 0, line_buf_size);
-	SAFE_FREE(line_buf);
+	free(line_buf);
 	return i;
 }
 
@@ -1516,7 +1510,7 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
 		rc = EX_FILEIO;
 	}
 	unlock_mtab();
-	SAFE_FREE(mountent.mnt_opts);
+	free(mountent.mnt_opts);
 add_mtab_exit:
 	toggle_dac_capability(1, 0);
 	sigprocmask(SIG_SETMASK, &oldmask, NULL);
@@ -2152,7 +2146,7 @@ mount_exit:
 		memset(parsed_info->password, 0, sizeof(parsed_info->password));
 		munmap(parsed_info, sizeof(*parsed_info));
 	}
-	SAFE_FREE(options);
-	SAFE_FREE(orgoptions);
+	free(options);
+	free(orgoptions);
 	return rc;
 }
-- 
2.9.3
