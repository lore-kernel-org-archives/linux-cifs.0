From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 09/17] cifs.idmap: fix endianness on SIDs before sending to kernel
Date: Sat,  3 Nov 2012 08:50:26 -0400
Message-ID: <1351947034-18876-10-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Winbind keeps wbcDomainSids in host-endian format. They must be
converted to little-endian before we can ship them off to the
kernel.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.idmap.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/cifs.idmap.c b/cifs.idmap.c
index d2ccbb1..4109ca0 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -42,6 +42,8 @@
 #include <limits.h>
 #include <wbclient.h>
 
+#include "cifsacl.h"
+
 static const char *prog = "cifs.idmap";
 
 static const struct option long_options[] = {
@@ -99,6 +101,19 @@ str_to_uint(const char *src, unsigned int *dst)
 	return 0;
 }
 
+/*
+ * Winbind keeps wbcDomainSid fields in host-endian. So, we must convert it
+ * to little endian since the kernel will expect that.
+ */
+static void
+convert_sid_endianness(struct cifs_sid *sid)
+{
+	int i;
+
+	for (i = 0; i < sid->num_subauth; i++)
+		sid->sub_auth[i] = htole32(sid->sub_auth[i]);
+}
+
 static int
 cifs_idmap(const key_serial_t key, const char *key_descr)
 {
@@ -173,7 +188,9 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 		rc = wbcUidToSid(uid, &sid);
 		if (rc)
 			syslog(LOG_DEBUG, "uid %u to SID  error: %d", uid, rc);
-		if (!rc) { /* SID has been mapped to a uid */
+		if (!rc) {
+			/* SID has been mapped to a uid */
+			convert_sid_endianness((struct cifs_sid *)&sid);
 			rc = keyctl_instantiate(key, &sid,
 					sizeof(struct wbcDomainSid), 0);
 			if (rc)
@@ -197,7 +214,9 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 		rc = wbcGidToSid(gid, &sid);
 		if (rc)
 			syslog(LOG_DEBUG, "gid %u to SID error: %d", gid, rc);
-		if (!rc) { /* SID has been mapped to a gid */
+		if (!rc) {
+			/* SID has been mapped to a gid */
+			convert_sid_endianness((struct cifs_sid *)&sid);
 			rc = keyctl_instantiate(key, &sid,
 					sizeof(struct wbcDomainSid), 0);
 			if (rc)
-- 
1.7.11.7
