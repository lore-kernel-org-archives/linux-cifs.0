From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 5/7] cifs.idmap: don't use atoi to convert unsigned int to number
Date: Sat, 27 Oct 2012 07:20:20 -0400
Message-ID: <1351336822-16425-6-git-send-email-jlayton@samba.org>
References: <1351336822-16425-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351336822-16425-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

atoi() is for signed integers, and is deprecated in any case. Use
strtoul() instead and check the result carefully before using it.

Also add a log message when the string(s) can't be converted and
fix the signedness of the types in other log messages.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.idmap.c | 48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/cifs.idmap.c b/cifs.idmap.c
index 457d307..9639070 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -75,6 +75,30 @@ char *strget(const char *str, const char *substr)
 	return substrptr;
 }
 
+/*
+ * Convert a string representation of unsigned int into a numeric one. Also
+ * check for incomplete string conversion and overflow.
+ */
+static int
+str_to_uint(const char *src, unsigned int *dst)
+{
+	unsigned long tmp;
+	char *end;
+
+	errno = 0;
+	tmp = strtoul(src, &end, 0);
+
+	if (*end != '\0')
+		return EINVAL;
+	if (tmp == ULONG_MAX && errno == ERANGE)
+		return errno;
+	if (tmp > UINT_MAX)
+		return EOVERFLOW;
+
+	*dst = (unsigned int)tmp;
+	return 0;
+}
+
 static int
 cifs_idmap(const key_serial_t key, const char *key_descr)
 {
@@ -138,11 +162,17 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 
 	sidstr = strget(key_descr, "oi:");
 	if (sidstr) {
-		uid = atoi(sidstr);
-		syslog(LOG_DEBUG, "SID: %s, uid: %d", sidstr, uid);
+		rc = str_to_uint(sidstr, (unsigned int *)&uid);
+		if (rc) {
+			syslog(LOG_ERR, "Unable to convert %s to uid: %s",
+				sidstr, strerror(rc));
+			goto cifs_idmap_ret;
+		}
+
+		syslog(LOG_DEBUG, "SID: %s, uid: %u", sidstr, uid);
 		rc = wbcUidToSid(uid, &sid);
 		if (rc)
-			syslog(LOG_DEBUG, "uid %d to SID  error: %d", uid, rc);
+			syslog(LOG_DEBUG, "uid %u to SID  error: %d", uid, rc);
 		if (!rc) { /* SID has been mapped to a uid */
 			rc = keyctl_instantiate(key, &sid,
 					sizeof(struct wbcDomainSid), 0);
@@ -156,11 +186,17 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 
 	sidstr = strget(key_descr, "gi:");
 	if (sidstr) {
-		gid = atoi(sidstr);
-		syslog(LOG_DEBUG, "SID: %s, gid: %d", sidstr, gid);
+		rc = str_to_uint(sidstr, (unsigned int *)&gid);
+		if (rc) {
+			syslog(LOG_ERR, "Unable to convert %s to gid: %s",
+				sidstr, strerror(rc));
+			goto cifs_idmap_ret;
+		}
+
+		syslog(LOG_DEBUG, "SID: %s, gid: %u", sidstr, gid);
 		rc = wbcGidToSid(gid, &sid);
 		if (rc)
-			syslog(LOG_DEBUG, "gid %d to SID error: %d", gid, rc);
+			syslog(LOG_DEBUG, "gid %u to SID error: %d", gid, rc);
 		if (!rc) { /* SID has been mapped to a gid */
 			rc = keyctl_instantiate(key, &sid,
 					sizeof(struct wbcDomainSid), 0);
-- 
1.7.11.7
