From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs-utils: fix some sparse warnings
Date: Thu, 18 Jul 2013 13:33:05 -0400
Message-ID: <1374168785-10876-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.idmap.c   |  3 ++-
 cifs.upcall.c  |  4 ++--
 cifscreds.c    |  6 +++---
 cifsidmap.h    | 27 ++++++++++-----------------
 idmap_plugin.c |  1 +
 mount.cifs.c   |  6 +++---
 mtab.c         |  2 +-
 replace.h      |  4 ----
 util.c         |  1 +
 util.h         |  6 +++---
 10 files changed, 26 insertions(+), 34 deletions(-)

diff --git a/cifs.idmap.c b/cifs.idmap.c
index 788d369..cbc01c5 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -60,7 +60,8 @@ static void usage(void)
 	fprintf(stderr, "Usage: %s [-h] [-v] [-t timeout] key_serial\n", prog);
 }
 
-char *strget(const char *str, const char *substr)
+static char *
+strget(const char *str, const char *substr)
 {
 	int sublen;
 	char *substrptr;
diff --git a/cifs.upcall.c b/cifs.upcall.c
index c16bdfd..20b562f 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -244,7 +244,7 @@ init_cc_from_keytab(const char *keytab_name, const char *user)
 	if (ccname == NULL)
 		syslog(LOG_ERR, "Unable to allocate memory");
 icfk_cleanup:
-	my_creds.client = 0;
+	my_creds.client = (krb5_principal)0;
 	krb5_free_cred_contents(context, &my_creds);
 
 	if (me)
@@ -808,7 +808,7 @@ static void usage(void)
 	fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb5.conf] [-t] [-v] [-l] key_serial\n", prog);
 }
 
-const struct option long_options[] = {
+static const struct option long_options[] = {
 	{"krb5conf", 1, NULL, 'k'},
 	{"legacy-uid", 0, NULL, 'l'},
 	{"trust-dns", 0, NULL, 't'},
diff --git a/cifscreds.c b/cifscreds.c
index bb35c02..60be4e5 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -75,9 +75,9 @@ static int cifscreds_clear(struct cmdarg *arg);
 static int cifscreds_clearall(struct cmdarg *arg);
 static int cifscreds_update(struct cmdarg *arg);
 
-const char *thisprogram;
+static const char *thisprogram;
 
-struct command commands[] = {
+static struct command commands[] = {
 	{ cifscreds_add,	"add",		"[-u username] [-d] <host|domain>" },
 	{ cifscreds_clear,	"clear",	"[-u username] [-d] <host|domain>" },
 	{ cifscreds_clearall,	"clearall",	"" },
@@ -85,7 +85,7 @@ struct command commands[] = {
 	{ NULL, "", NULL }
 };
 
-struct option longopts[] = {
+static struct option longopts[] = {
 	{"username", 1, NULL, 'u'},
 	{"domain", 0, NULL, 'd' },
 	{NULL, 0, NULL, 0}
diff --git a/cifsidmap.h b/cifsidmap.h
index 3c074ae..664b84f 100644
--- a/cifsidmap.h
+++ b/cifsidmap.h
@@ -70,9 +70,8 @@ struct cifs_uxid {
  * and in subsequent idmapping functions. On any error, the plugin
  * should point *errmsg at a string describing that error. Returns 0
  * on success and non-zero on error.
- *
- * int cifs_idmap_init_plugin(void **handle, const char **errmsg);
  */
+extern int cifs_idmap_init_plugin(void **handle, const char **errmsg);
 
 /**
  * cifs_idmap_exit_plugin - Destroy an idmapping context
@@ -82,9 +81,8 @@ struct cifs_uxid {
  * this function to destroy any context that was created during the
  * init_plugin. The handle passed back in was the one given by the init
  * routine.
- *
- * void cifs_idmap_exit_plugin(void *handle);
  */
+extern void cifs_idmap_exit_plugin(void *handle);
 
 /**
  * cifs_idmap_sid_to_str - convert cifs_sid to a string
@@ -98,10 +96,9 @@ struct cifs_uxid {
  * success and non-zero on error. On error, the errmsg pointer passed
  * in to the init_plugin function should point to an error string. The
  * caller will not free the error string.
- *
- * int cifs_idmap_sid_to_str(void *handle, const struct cifs_sid *sid,
- * 				char **name);
  */
+extern int cifs_idmap_sid_to_str(void *handle, const struct cifs_sid *sid,
+					char **name);
 
 /**
  * cifs_idmap_str_to_sid - convert string to struct cifs_sid
@@ -114,10 +111,9 @@ struct cifs_uxid {
  * allocated. Returns 0 on success and non-zero on error. On error, the
  * plugin should reset the errmsg pointer passed to the init_plugin
  * function to an error string. The caller will not free the error string.
- *
- * int cifs_idmap_str_to_sid(void *handle, const char *name,
- * 				struct cifs_sid *sid);
  */
+extern int cifs_idmap_str_to_sid(void *handle, const char *name,
+				struct cifs_sid *sid);
 
 /**
  * cifs_idmap_sids_to_ids - convert struct cifs_sids to struct cifs_uxids
@@ -136,10 +132,9 @@ struct cifs_uxid {
  * On any error, the plugin should reset the errmsg pointer passed to the
  * init_plugin function to an error string. The caller will not free the error
  * string.
- *
- * int cifs_idmap_sids_to_ids(void *handle, const struct cifs_sid *sid,
- * 				const size_t num, struct cifs_uxid *cuxid);
  */
+extern int cifs_idmap_sids_to_ids(void *handle, const struct cifs_sid *sid,
+				const size_t num, struct cifs_uxid *cuxid);
 
 /**
  * cifs_idmap_ids_to_sids - convert uid to struct cifs_sid
@@ -157,9 +152,7 @@ struct cifs_uxid {
  * On any error, the plugin should reset the errmsg pointer passed to the
  * init_plugin function to an error string. The caller will not free the error
  * string.
- *
- * int cifs_idmap_ids_to_sids(void *handle, const struct cifs_uxid *cuxid,
- * 				const size_t num, struct cifs_sid *sid);
  */
-
+extern int cifs_idmap_ids_to_sids(void *handle, const struct cifs_uxid *cuxid,
+				const size_t num, struct cifs_sid *sid);
 #endif /* _CIFSIDMAP_H */
diff --git a/idmap_plugin.c b/idmap_plugin.c
index 19050ec..8fcb846 100644
--- a/idmap_plugin.c
+++ b/idmap_plugin.c
@@ -26,6 +26,7 @@
 #include <sys/types.h>
 
 #include "cifsidmap.h"
+#include "idmap_plugin.h"
 
 const char *plugin_errmsg;
 static void *plugin;
diff --git a/mount.cifs.c b/mount.cifs.c
index 3b2b89e..12f1b8e 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -182,8 +182,8 @@ struct parsed_mount_info {
 	unsigned int nofail:1;
 };
 
-const char *thisprogram;
-const char *cifs_fstype = "cifs";
+static const char *thisprogram;
+static const char *cifs_fstype = "cifs";
 
 static int parse_unc(const char *unc_name, struct parsed_mount_info *parsed_info);
 
@@ -1899,7 +1899,7 @@ int main(int argc, char **argv)
 		thisprogram = "mount.cifs";
 
 	/* allocate parsed_info as shared anonymous memory range */
-	parsed_info = mmap(0, sizeof(*parsed_info), PROT_READ | PROT_WRITE,
+	parsed_info = mmap((void *)0, sizeof(*parsed_info), PROT_READ | PROT_WRITE,
 			   MAP_ANONYMOUS | MAP_SHARED, -1, 0);
 	if (parsed_info == (struct parsed_mount_info *) -1) {
 		parsed_info = NULL;
diff --git a/mtab.c b/mtab.c
index 3d42ac0..7b365b3 100644
--- a/mtab.c
+++ b/mtab.c
@@ -62,7 +62,7 @@ setlkw_timeout (int sig __attribute__((unused))) {
 }
 
 /* use monotonic time for timeouts */
-struct timeval
+static struct timeval
 mono_time(void) {
 	struct timeval ret;
 #if defined(HAVE_CLOCK_GETTIME) && defined(CLOCK_MONOTONIC)
diff --git a/replace.h b/replace.h
index a9fdf7e..03d2937 100644
--- a/replace.h
+++ b/replace.h
@@ -124,10 +124,6 @@ extern char *sys_errlist[];
 #define strerror(i) sys_errlist[i]
 #endif
 
-#ifndef HAVE_ERRNO_DECL
-extern int errno;
-#endif
-
 #ifndef HAVE_STRDUP
 #define strdup rep_strdup
 char *rep_strdup(const char *s);
diff --git a/util.c b/util.c
index 80d5a80..546f284 100644
--- a/util.c
+++ b/util.c
@@ -25,6 +25,7 @@
 #include <sys/types.h>
 #include <string.h>
 #include <pwd.h>
+#include "util.h"
 
 /* glibc doesn't have strlcpy, strlcat. Ensure we do. JRA. We
  * don't link to libreplace so need them here. */
diff --git a/util.h b/util.h
index d3ca015..2864130 100644
--- a/util.h
+++ b/util.h
@@ -25,9 +25,9 @@
 #ifndef _LIBUTIL_H
 #define _LIBUTIL_H
 
-size_t strlcpy(char *d, const char *s, size_t bufsize);
-size_t strlcat(char *d, const char *s, size_t bufsize);
+extern size_t strlcpy(char *d, const char *s, size_t bufsize);
+extern size_t strlcat(char *d, const char *s, size_t bufsize);
 
-char *getusername(uid_t uid);
+extern char *getusername(uid_t uid);
 #endif /* _LIBUTIL_H */
 
-- 
1.8.3.1
