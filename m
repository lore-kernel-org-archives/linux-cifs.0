From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: handle cifs_acl type of key to map a SID to either an uid or gid and return it
Date: Tue,  7 Dec 2010 11:11:16 -0600
Message-ID: <1291741876-22770-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Handle cifs_acl type of key. Extract a SID string from the description
and map it to either an uid or gid using winbind APIs and return that id.
If an SID can't be mapped, id stays 0 i.e. that of the root.


An entry such as this

create  cifs.cifs_acl   *       *               /usr/sbin/cifs.upcall %k

is needed in the file /etc/request-key.conf.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 cifs.upcall.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 9b1436e..17ef57e 100644
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
@@ -544,6 +551,66 @@ static int cifs_resolver(const key_serial_t key, const char *key_descr)
 	return 0;
 }
 
+static int
+cifs_sid_resolver(const key_serial_t key, const char *key_descr)
+{
+	int i;
+	uid_t uid = 0;
+	gid_t gid = 0;;
+	wbcErr rc;
+	const char *keyend = key_descr;
+	struct wbcDomainSid sid;
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
+	if (strncmp(keyend, "os", 2) == 0) {
+		keyend = index(keyend + 1, ':');
+		keyend++;
+		rc = wbcStringToSid(keyend, &sid);
+		if (!rc) {
+			rc = wbcSidToUid(&sid, &uid);
+			if (!rc) {
+				rc = keyctl_instantiate(key, &uid,
+							sizeof(uid_t), 0);
+				if (rc)
+					syslog(LOG_ERR, "%s: key inst: %s",
+						__func__, strerror(errno));
+			} else
+				syslog(LOG_DEBUG, "OwnerSID to uid: %s, rc: %d",
+						keyend, rc);
+		} else
+			syslog(LOG_DEBUG, "O strtosid: %s, rc: %d", keyend, rc);
+	} else if (strncmp(keyend, "gs", 2) == 0) {
+		keyend = index(keyend + 1, ':');
+		keyend++;
+		rc = wbcStringToSid(keyend, &sid);
+		if (!rc) {
+			rc = wbcSidToGid(&sid, &gid);
+			if (!rc) {
+				rc = keyctl_instantiate(key, &gid,
+							sizeof(gid_t), 0);
+				if (rc)
+					syslog(LOG_ERR, "%s: key inst: %s",
+						__func__, strerror(errno));
+			} else
+				syslog(LOG_DEBUG, "GroupSID to gid: %s, rc: %d",
+						keyend, rc);
+		} else
+			syslog(LOG_DEBUG, "O strtosid: %s, rc: %d", keyend, rc);
+	} else
+		syslog(LOG_DEBUG, "Invalid SID");
+	return 0;
+}
+
 /*
  * Older kernels sent IPv6 addresses without colons. Well, at least
  * they're fixed-length strings. Convert these addresses to have colon
@@ -679,6 +746,11 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
+	if ((strncmp(buf, "cifs.cifs_acl", sizeof("cifs.cifs_acl") - 1) == 0)) {
+		rc = cifs_sid_resolver(key, buf);
+		goto out;
+	}
+
 	memset(&arg, 0, sizeof(arg));
 
 	have = decode_key_description(buf, &arg);
-- 
1.6.0.2
