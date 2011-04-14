From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: Handle cifs_idmap type of key to map a SID to either an uid or gid (try #15)
Date: Wed, 13 Apr 2011 22:17:08 -0500
Message-ID: <1302751028-18541-1-git-send-email-shirishpargaonkar@gmail.com>
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

An entry such as this

create  cifs.cifs_idmap   *       *               /usr/sbin/cifs.upcall %k

is needed in the file /etc/request-key.conf.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Makefile.am   |    2 +-
 cifs.upcall.c |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 67a0190..c9018ae 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -11,7 +11,7 @@ man_MANS = mount.cifs.8
 if CONFIG_CIFSUPCALL
 sbin_PROGRAMS = cifs.upcall
 cifs_upcall_SOURCES = cifs.upcall.c data_blob.c asn1.c spnego.c util.c
-cifs_upcall_LDADD = -ltalloc -lkeyutils $(KRB5_LDADD)
+cifs_upcall_LDADD = -ltalloc -lwbclient -lkeyutils $(KRB5_LDADD)
 man_MANS += cifs.upcall.8
 
 #
diff --git a/cifs.upcall.c b/cifs.upcall.c
index 479517c..68a8059 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -45,6 +45,13 @@
 #include <time.h>
 #include <netdb.h>
 #include <arpa/inet.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <limits.h>
+#include <wbclient.h>
 
 #include "util.h"
 #include "replace.h"
@@ -695,6 +702,103 @@ static int cifs_resolver(const key_serial_t key, const char *key_descr)
 	return 0;
 }
 
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
+
 /*
  * Older kernels sent IPv6 addresses without colons. Well, at least
  * they're fixed-length strings. Convert these addresses to have colon
@@ -833,6 +937,12 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
+	if ((strncmp(buf, "cifs.cifs_idmap", sizeof("cifs.cifs_idmap") - 1)
+			== 0)) {
+		rc = cifs_sid_resolver(key, buf);
+		goto out;
+	}
+
 	have = decode_key_description(buf, &arg);
 	SAFE_FREE(buf);
 	if ((have & DKD_MUSTHAVE_SET) != DKD_MUSTHAVE_SET) {
-- 
1.6.0.2
