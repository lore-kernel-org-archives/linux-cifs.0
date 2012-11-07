From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/2] cifs.idmap: fix up some compile-time warnings
Date: Wed,  7 Nov 2012 09:52:57 -0500
Message-ID: <1352299977-32701-2-git-send-email-jlayton@samba.org>
References: <1352299977-32701-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352299977-32701-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Get rid of some unused variables, and fix a strict-aliasing problem by
copying the SID data to a new place instead of converting the
endianness in-place.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.idmap.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/cifs.idmap.c b/cifs.idmap.c
index 4109ca0..24bec00 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -60,7 +60,7 @@ static void usage(void)
 
 char *strget(const char *str, const char *substr)
 {
-	int len, sublen, retlen;
+	int sublen;
 	char *substrptr;
 
 	/* find the prefix */
@@ -102,16 +102,20 @@ str_to_uint(const char *src, unsigned int *dst)
 }
 
 /*
- * Winbind keeps wbcDomainSid fields in host-endian. So, we must convert it
- * to little endian since the kernel will expect that.
+ * Winbind keeps wbcDomainSid fields in host-endian. Copy fields from the
+ * wsid to the csid, while converting the subauthority fields to LE.
  */
 static void
-convert_sid_endianness(struct cifs_sid *sid)
+convert_sid(struct cifs_sid *csid, struct wbcDomainSid *wsid)
 {
 	int i;
 
-	for (i = 0; i < sid->num_subauth; i++)
-		sid->sub_auth[i] = htole32(sid->sub_auth[i]);
+	csid->revision = wsid->sid_rev_num;
+	csid->num_subauth = wsid->num_auths;
+	for (i = 0; i < NUM_AUTHS; i++)
+		csid->authority[i] = wsid->id_auth[i];
+	for (i = 0; i < wsid->num_auths; i++)
+		csid->sub_auth[i] = htole32(wsid->sub_auths[i]);
 }
 
 static int
@@ -189,10 +193,12 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 		if (rc)
 			syslog(LOG_DEBUG, "uid %u to SID  error: %d", uid, rc);
 		if (!rc) {
+			struct cifs_sid csid;
+
 			/* SID has been mapped to a uid */
-			convert_sid_endianness((struct cifs_sid *)&sid);
-			rc = keyctl_instantiate(key, &sid,
-					sizeof(struct wbcDomainSid), 0);
+			convert_sid(&csid, &sid);
+			rc = keyctl_instantiate(key, &csid,
+					sizeof(struct cifs_sid), 0);
 			if (rc)
 				syslog(LOG_ERR, "%s: key inst: %s",
 					__func__, strerror(errno));
@@ -215,10 +221,12 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 		if (rc)
 			syslog(LOG_DEBUG, "gid %u to SID error: %d", gid, rc);
 		if (!rc) {
+			struct cifs_sid csid;
+
 			/* SID has been mapped to a gid */
-			convert_sid_endianness((struct cifs_sid *)&sid);
-			rc = keyctl_instantiate(key, &sid,
-					sizeof(struct wbcDomainSid), 0);
+			convert_sid(&csid, &sid);
+			rc = keyctl_instantiate(key, &csid,
+					sizeof(struct cifs_sid), 0);
 			if (rc)
 				syslog(LOG_ERR, "%s: key inst: %s",
 					__func__, strerror(errno));
-- 
1.7.12.1
