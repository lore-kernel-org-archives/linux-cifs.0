From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: Create new binary cifs.idmap for sid to uid/gid mapping (try #3)
Date: Mon, 23 May 2011 07:26:49 -0500
Message-ID: <1306153609-28511-1-git-send-email-shirishppargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Handle cifs.idmap type of key. Extract a SID string from the description
and map it to either an uid or gid using winbind APIs.
If that fails (e.g. because winbind is not installed/running or winbind returns
an error), try to obtain uid of 'nobody' and gid of 'nogroup'.
And if that fails, kernel assigns uid and gid (from mount superblock).

Enable including winbind header files and idmapping code conditional
to winbind devel rpms (header and library).

An entry such as this

create  cifs.idmap   *       *               /usr/sbin/cifs.idmap %k

is needed in the file /etc/request-key.conf.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Makefile.am      |   11 +++-
 aclocal/idmap.m4 |   45 +++++++++++
 cifs.idmap.c     |  221 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cifs.upcall.c    |    1 -
 configure.ac     |   20 +++++-
 5 files changed, 294 insertions(+), 4 deletions(-)
 create mode 100644 aclocal/idmap.m4
 create mode 100644 cifs.idmap.c

diff --git a/Makefile.am b/Makefile.am
index 67a0190..c6eeb22 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -8,8 +8,10 @@ mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD)
 
 man_MANS = mount.cifs.8
 
+sbin_PROGRAMS =
+
 if CONFIG_CIFSUPCALL
-sbin_PROGRAMS = cifs.upcall
+sbin_PROGRAMS += cifs.upcall
 cifs_upcall_SOURCES = cifs.upcall.c data_blob.c asn1.c spnego.c util.c
 cifs_upcall_LDADD = -ltalloc -lkeyutils $(KRB5_LDADD)
 man_MANS += cifs.upcall.8
@@ -30,3 +32,10 @@ bin_PROGRAMS = cifscreds
 cifscreds_SOURCES = cifscreds.c resolve_host.c util.c
 cifscreds_LDADD = -lkeyutils
 endif
+
+if CONFIG_CIFSIDMAP
+sbin_PROGRAMS += cifs.idmap
+cifs_idmap_SOURCES = cifs.idmap.c
+cifs_idmap_LDADD = -lkeyutils $(WINB_LDADD)
+endif
+
diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
new file mode 100644
index 0000000..211d372
--- /dev/null
+++ b/aclocal/idmap.m4
@@ -0,0 +1,45 @@
+dnl Headers needed by wbclient.h
+dnl
+AC_DEFUN([AC_WBCH_COMPL],[
+[
+#ifdef HAVE_STDINT_H
+#include <stdint.h>
+#endif
+]
+[#ifdef HAVE_STDBOOL_H
+#include <stdbool.h>
+#endif
+]
+[#ifdef HAVE_STDIO_H
+#include <stdio.h>
+#endif
+]
+[#ifdef HAVE_STDLIB_H
+#include <stdlib.h>
+#endif
+]
+[#ifdef HAVE_ERRNO_H
+#include <errno.h>
+#endif
+]])
+
+dnl Check for wbclient.h header and libwbclietn.so
+dnl
+AC_DEFUN([AC_TEST_WBCHL],[
+if test $enable_cifsidmap != "no"; then
+	AC_CHECK_HEADERS([wbclient.h], , [
+				if test "$enable_cifsidmap" = "yes"; then
+					AC_MSG_ERROR([wbclient.h not found, consider installing libwbclient-devel.])
+				else
+					AC_MSG_WARN([wbclient.h not found, consider installing libwbclient-devel. Disabling cifs.idmap.])
+					enable_cifsidmap="no"
+				fi
+			], [ AC_WBCH_COMPL ])
+fi
+
+if test $enable_cifsidmap != "no"; then
+	AC_CHECK_LIB([wbclient], [wbcStringToSid],
+		[ WINB_LDADD='-lwbclient' ] [ AC_DEFINE(HAVE_LIBWBCLIENT, 1, ["Define var have_libwbclient"]) ], [AC_MSG_ERROR([No functioning wbclient library found!])])
+	AC_SUBST(WINB_LDADD)
+fi
+])
diff --git a/cifs.idmap.c b/cifs.idmap.c
new file mode 100644
index 0000000..7788bf2
--- /dev/null
+++ b/cifs.idmap.c
@@ -0,0 +1,221 @@
+/*
+* CIFS idmap helper.
+* Copyright (C) Shirish Pargaonkar (shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org) 2011
+*
+* Used by /sbin/request-key.conf for handling
+* cifs upcall for SID to uig/gid and uid/gid to SID mapping.
+* You should have keyutils installed and add
+* this lines to /etc/request-key.conf file:
+
+    create cifs.idmap * * /usr/local/sbin/cifs.idmap %k
+
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License as published by
+* the Free Software Foundation; either version 2 of the License, or
+* (at your option) any later version.
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+* GNU General Public License for more details.
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*/
+
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif /* HAVE_CONFIG_H */
+
+#include <string.h>
+#include <getopt.h>
+#include <syslog.h>
+#include <dirent.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <keyutils.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <limits.h>
+#include <wbclient.h>
+
+static const char *prog = "cifs.idmap";
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: %s key_serial\n", prog);
+}
+
+char *strget(const char *str, char *substr)
+{
+	int len, sublen, retlen;
+	char *retstr, *substrptr;
+
+	sublen = strlen(substr);
+	substrptr = strstr(str, substr);
+	if (substrptr) {
+		len = strlen(substrptr);
+		substrptr += sublen;
+
+		retlen = len - sublen;
+		if (retlen > 0) {
+			retstr = malloc(retlen + 1);
+			if (retstr) {
+				strncpy(retstr, substrptr, retlen);
+				return retstr;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static int
+cifs_idmap(const key_serial_t key, const char *key_descr)
+{
+	uid_t uid = 0;
+	gid_t gid = 0;;
+	wbcErr rc = 1;
+	char *sidstr = NULL;
+	struct wbcDomainSid sid;
+	struct passwd *pw;
+	struct group *gr;
+
+	/*
+	 * Use winbind to convert received string to a SID and lookup
+	 * name and map that SID to an uid.  If either of these
+	 * function calls return with an error,  use system calls to obtain
+	 * uid of user "nobody". If winbind fails to map a SID to an UID
+	 * and there is no user named "nobody", return error to the
+	 * upcall caller. Otherwise instanticate a key using that uid.
+	 *
+	 * The same applies to SID and gid mapping.  Instead of a
+	 * user "nobody", user "nogroup" is looked up if winbind
+	 * fails to map a SID to a gid.
+	 */
+	sidstr = strget(key_descr, "os:");
+	if (sidstr) {
+		rc = wbcStringToSid(sidstr, &sid);
+		if (rc)
+			syslog(LOG_DEBUG, "Invalid owner string: %s, rc: %d",
+				key_descr, rc);
+		else {
+			rc = wbcSidToUid(&sid, &uid);
+			if (rc)
+				syslog(LOG_DEBUG, "SID %s to uid wbc error: %d",
+						key_descr, rc);
+		}
+		if (rc) { /* either of the two wbcSid functions failed */
+			pw = getpwnam("nobody");
+			if (!pw)
+				syslog(LOG_DEBUG, "SID %s to uid pw error: %d",
+					key_descr, rc);
+			else {
+				uid = pw->pw_uid;
+				rc = 0;
+			}
+		}
+		if (!rc) { /* SID has been mapped to an uid */
+			rc = keyctl_instantiate(key, &uid, sizeof(uid_t), 0);
+			if (rc)
+				syslog(LOG_ERR, "%s: key inst: %s",
+					__func__, strerror(errno));
+		}
+
+		goto cifs_idmap_ret;
+	}
+
+	sidstr = strget(key_descr, "gs:");
+	if (sidstr) {
+		rc = wbcStringToSid(sidstr, &sid);
+		if (rc)
+			syslog(LOG_DEBUG, "Invalid group string: %s, rc: %d",
+					key_descr, rc);
+		else {
+			rc = wbcSidToGid(&sid, &gid);
+			if (rc)
+				syslog(LOG_DEBUG, "SID %s to gid wbc error: %d",
+						key_descr, rc);
+		}
+		if (rc) { /* either of the two wbcSid functions failed */
+			gr = getgrnam("nogroup");
+			if (!gr)
+				syslog(LOG_DEBUG, "SID %s to gid pw error: %d",
+						key_descr, rc);
+			else {
+				gid = gr->gr_gid;
+				rc = 0;
+			}
+		}
+		if (!rc) { /* SID has been mapped to a gid */
+			rc = keyctl_instantiate(key, &gid, sizeof(gid_t), 0);
+			if (rc)
+				syslog(LOG_ERR, "%s: key inst: %s",
+						__func__, strerror(errno));
+		}
+
+		goto cifs_idmap_ret;
+	}
+
+	syslog(LOG_DEBUG, "Invalid key: %s", key_descr);
+
+cifs_idmap_ret:
+	if (sidstr)
+		free(sidstr);
+
+	return rc;
+}
+
+int main(const int argc, char *const argv[])
+{
+	int c;
+	long rc = 1;
+	key_serial_t key = 0;
+	char *buf;
+
+	openlog(prog, 0, LOG_DAEMON);
+
+	while ((c = getopt_long(argc, argv, "v", NULL, NULL)) != -1) {
+		switch (c) {
+		case 'v':
+			printf("version: %s\n", VERSION);
+			goto out;
+		default:
+			syslog(LOG_ERR, "unknown option: %c", c);
+			goto out;
+		}
+	}
+
+	/* is there a key? */
+	if (argc <= optind) {
+		usage();
+		goto out;
+	}
+
+	/* get key and keyring values */
+	errno = 0;
+	key = strtol(argv[optind], NULL, 10);
+	if (errno != 0) {
+		key = 0;
+		syslog(LOG_ERR, "Invalid key format: %s", strerror(errno));
+		goto out;
+	}
+
+	rc = keyctl_describe_alloc(key, &buf);
+	if (rc == -1) {
+		syslog(LOG_ERR, "keyctl_describe_alloc failed: %s",
+		       strerror(errno));
+		rc = 1;
+		goto out;
+	}
+
+	syslog(LOG_DEBUG, "key description: %s", buf);
+
+	if ((strncmp(buf, "cifs.idmap", sizeof("cifs.idmap") - 1) == 0))
+		rc = cifs_idmap(key, buf);
+out:
+	return rc;
+}
diff --git a/cifs.upcall.c b/cifs.upcall.c
index 479517c..de92092 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -749,7 +749,6 @@ static int ip_to_fqdn(const char *addrstr, char *host, size_t hostlen)
 
 static void usage(void)
 {
-	syslog(LOG_INFO, "Usage: %s [-t] [-v] [-l] key_serial", prog);
 	fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_serial\n", prog);
 }
 
diff --git a/configure.ac b/configure.ac
index e0e2a60..906bc2d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -22,13 +22,19 @@ AC_ARG_ENABLE(cifscreds,
 	enable_cifscreds=$enableval,
 	enable_cifscreds="no")
 
+AC_ARG_ENABLE(cifsidmap,
+	[AC_HELP_STRING([--enable-cifsidmap],
+			[Create cifs.idmap binary @<:@default=yes@:>@])],
+	enable_cifsidmap=$enableval,
+	enable_cifsidmap="maybe")
+
 # Checks for programs.
 AC_PROG_CC
 AC_PROG_SED
 AC_GNU_SOURCE
 
 # Checks for header files.
-AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdlib.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
+AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
 
 if test $enable_cifsupcall != "no"; then
 	AC_CHECK_HEADERS([krb5.h krb5/krb5.h])
@@ -72,7 +78,7 @@ if test $enable_cifsupcall != "no"; then
 				fi
 			])
 fi
-if test $enable_cifsupcall != "no"; then
+if test $enable_cifsupcall != "no" -o $enable_cifsidmap != "no"; then
 	AC_CHECK_HEADERS([keyutils.h], , [
 				if test "$enable_cifsupcall" = "yes"; then
 					AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])
@@ -80,6 +86,12 @@ if test $enable_cifsupcall != "no"; then
 					AC_MSG_WARN([keyutils.h not found, consider installing keyutils-libs-devel. Disabling cifs.upcall.])
 					enable_cifsupcall="no"
 				fi
+				if test "$enable_cifsidmap" = "yes"; then
+					AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])
+				else
+					AC_MSG_WARN([keyutils.h not found, consider installing keyutils-libs-devel. Disabling cifs.idmap.])
+					enable_cifsidmap="no"
+				fi
 			])
 fi
 if test $enable_cifsupcall != "no"; then
@@ -89,6 +101,9 @@ if test $enable_cifsupcall != "no"; then
 	AC_SUBST(KRB5_LDADD)
 fi
 
+# checks for wbclient.h and libwbclient.so library
+AC_TEST_WBCHL
+
 if test $enable_cifscreds = "yes"; then
 	AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])])
 fi
@@ -140,6 +155,7 @@ LIBS=$cu_saved_libs
 
 AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
 AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" = "yes"])
+AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
 
 LIBCAP_NG_PATH
 
-- 
1.6.0.2
