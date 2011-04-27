From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: Handle cifs_idmap type of key to map a SID to either an uid or gid (try #17 repost)
Date: Wed, 27 Apr 2011 09:36:30 -0500
Message-ID: <1303914990-7804-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Handle cifs_idmap type of key. Extract a SID string from the description
and map it to either an uid or gid using winbind APIs.
If that fails (e.g. because winbind is not installed/running or winbind returns
an error), try to obtain uid of 'nobody' and gid of 'nogroup'.
And if that fails, kernel assigns uid and gid (from mount superblock).

Enable including winbind header files and idmapping code conditional
to winbind devel rpms (header and library).

An entry such as this

create  cifs.cifs_idmap   *       *               /usr/sbin/cifs.upcall %k

is needed in the file /etc/request-key.conf.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Makefile.am   |    2 +-
 cifs.upcall.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 configure.ac  |   35 +++++++++++++++++
 3 files changed, 152 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 67a0190..13b6c16 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -11,7 +11,7 @@ man_MANS = mount.cifs.8
 if CONFIG_CIFSUPCALL
 sbin_PROGRAMS = cifs.upcall
 cifs_upcall_SOURCES = cifs.upcall.c data_blob.c asn1.c spnego.c util.c
-cifs_upcall_LDADD = -ltalloc -lkeyutils $(KRB5_LDADD)
+cifs_upcall_LDADD = -ltalloc -lkeyutils $(KRB5_LDADD) $(WINB_LDADD)
 man_MANS += cifs.upcall.8
 
 #
diff --git a/cifs.upcall.c b/cifs.upcall.c
index 479517c..6c2088b 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -45,6 +45,15 @@
 #include <time.h>
 #include <netdb.h>
 #include <arpa/inet.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <limits.h>
+#ifdef HAVE_WBCLIENT_H
+#include <wbclient.h>
+#endif /* HAVE_WBCLIENT_H */
 
 #include "util.h"
 #include "replace.h"
@@ -653,7 +662,7 @@ static int cifs_resolver(const key_serial_t key, const char *key_descr)
 	const char *keyend = key_descr;
 	/* skip next 4 ';' delimiters to get to description */
 	for (c = 1; c <= 4; c++) {
-		keyend = index(keyend + 1, ';');
+		keyend = rindex(keyend + 1, ';');
 		if (!keyend) {
 			syslog(LOG_ERR, "invalid key description: %s",
 			       key_descr);
@@ -695,6 +704,105 @@ static int cifs_resolver(const key_serial_t key, const char *key_descr)
 	return 0;
 }
 
+#ifdef HAVE_LIBWBCLIENT
+static int
+cifs_sid_resolver(const key_serial_t key, const char *key_descr)
+{
+	int i;
+	uid_t uid = 0;
+	gid_t gid = 0;;
+	wbcErr rc = 1;
+	const char *keyend = key_descr;
+	struct wbcDomainSid sid;
+	struct passwd *pw;
+	struct group *gr;
+
+	/* skip next 4 ';' delimiters to get to description */
+	for (i = 1; i <= 4; ++i) {
+		keyend = index(keyend + 1, ';');
+		if (!keyend) {
+			syslog(LOG_ERR, "invalid key description: %s",
+			       key_descr);
+			return 1;
+		}
+	}
+	keyend++;
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
+	if (strncmp(keyend, "os", 2) == 0) {
+		keyend = index(keyend + 1, ':');
+		keyend++;
+		rc = wbcStringToSid(keyend, &sid);
+		if (rc)
+			syslog(LOG_DEBUG, "O strtosid: %s, rc: %d", keyend, rc);
+		else {
+			rc = wbcSidToUid(&sid, &uid);
+			if (rc)
+				syslog(LOG_DEBUG, "SID %s to uid wbc error: %d",
+						keyend, rc);
+		}
+		if (rc) { /* either of the two wbcSid functions failed */
+			pw = getpwnam("nobody");
+			if (!pw)
+				syslog(LOG_DEBUG, "SID %s to uid pw error: %d",
+					keyend, rc);
+			else {
+				uid = pw->pw_uid;
+				rc = 0;
+			}
+		}
+		if (!rc) { /* SID has been mapped to a uid */
+			rc = keyctl_instantiate(key, &uid, sizeof(uid_t), 0);
+			if (rc)
+				syslog(LOG_ERR, "%s: key inst: %s",
+					__func__, strerror(errno));
+		}
+	} else if (strncmp(keyend, "gs", 2) == 0) {
+		keyend = index(keyend + 1, ':');
+		keyend++;
+		rc = wbcStringToSid(keyend, &sid);
+		if (rc)
+			syslog(LOG_DEBUG, "O strtosid: %s, rc: %d", keyend, rc);
+		else {
+			rc = wbcSidToGid(&sid, &gid);
+			if (rc)
+				syslog(LOG_DEBUG, "SID %s to gid wbc error: %d",
+						keyend, rc);
+		}
+		if (rc) { /* either of the two wbcSid functions failed */
+			gr = getgrnam("nogroup");
+			if (!gr)
+				syslog(LOG_DEBUG, "SID %s to gid pw error: %d",
+						keyend, rc);
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
+	} else
+		syslog(LOG_DEBUG, "Invalid SID: %s", keyend);
+
+	return rc;
+}
+#endif /* HAVE_LIBWBCLIENT */
+
 /*
  * Older kernels sent IPv6 addresses without colons. Well, at least
  * they're fixed-length strings. Convert these addresses to have colon
@@ -832,6 +940,13 @@ int main(const int argc, char *const argv[])
 		rc = cifs_resolver(key, buf);
 		goto out;
 	}
+#ifdef HAVE_LIBWBCLIENT
+	if ((strncmp(buf, "cifs.cifs_idmap", sizeof("cifs.cifs_idmap") - 1)
+			== 0)) {
+		rc = cifs_sid_resolver(key, buf);
+		goto out;
+	}
+#endif /* HAVE_LIBWBCLIENT */
 
 	have = decode_key_description(buf, &arg);
 	SAFE_FREE(buf);
diff --git a/configure.ac b/configure.ac
index e0e2a60..45800bd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -89,6 +89,41 @@ if test $enable_cifsupcall != "no"; then
 	AC_SUBST(KRB5_LDADD)
 fi
 
+if test $enable_cifsupcall != "no"; then
+	AC_CHECK_LIB([wbclient], [wbcStringToSid],
+		[ WINB_LDADD='-lwbclient' ] [ AC_DEFINE(HAVE_LIBWBCLIENT, 1, ["define a var"]) ], AC_MSG_ERROR([no functioning wbclient library found!]))
+	AC_SUBST(WINB_LDADD)
+fi
+
+if test $enable_cifsupcall != "no"; then
+	AC_CHECK_HEADERS([stdbool.h])
+	AC_CHECK_HEADERS([stdio.h])
+	AC_CHECK_HEADERS([errno.h])
+	AC_CHECK_HEADERS([wbclient.h], , [AC_MSG_ERROR([wbclient.h not found, consider installing libwbclient-devel.])],
+[#ifdef HAVE_STDINT_H
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
+]
+)
+fi
+
+# Checks for typedefs, structures, and compiler characteristics.
 if test $enable_cifscreds = "yes"; then
 	AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])])
 fi
-- 
1.6.0.2
