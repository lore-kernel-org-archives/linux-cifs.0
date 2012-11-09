From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/2] setcifsacl: don't freely cast between wbcDomainSid and cifs_sid
Date: Fri,  9 Nov 2012 07:04:26 -0500
Message-ID: <1352462666-10910-2-git-send-email-jlayton@samba.org>
References: <1352462666-10910-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352462666-10910-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since they are not necessarily aligned the same and potentially store
their fields with different endianness. Copy from the wbcDomainSid
to the cifs_sid as appropriate.

Also rename the same function in cifs.idmap.c for consistency.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.idmap.c |  6 +++---
 setcifsacl.c | 35 ++++++++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/cifs.idmap.c b/cifs.idmap.c
index 24bec00..792ea58 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -106,7 +106,7 @@ str_to_uint(const char *src, unsigned int *dst)
  * wsid to the csid, while converting the subauthority fields to LE.
  */
 static void
-convert_sid(struct cifs_sid *csid, struct wbcDomainSid *wsid)
+wsid_to_csid(struct cifs_sid *csid, struct wbcDomainSid *wsid)
 {
 	int i;
 
@@ -196,7 +196,7 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 			struct cifs_sid csid;
 
 			/* SID has been mapped to a uid */
-			convert_sid(&csid, &sid);
+			wsid_to_csid(&csid, &sid);
 			rc = keyctl_instantiate(key, &csid,
 					sizeof(struct cifs_sid), 0);
 			if (rc)
@@ -224,7 +224,7 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 			struct cifs_sid csid;
 
 			/* SID has been mapped to a gid */
-			convert_sid(&csid, &sid);
+			wsid_to_csid(&csid, &sid);
 			rc = keyctl_instantiate(key, &csid,
 					sizeof(struct cifs_sid), 0);
 			if (rc)
diff --git a/setcifsacl.c b/setcifsacl.c
index 30d5905..cd46045 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -379,20 +379,38 @@ build_fetched_aces_err:
 	return NULL;
 }
 
+/*
+ * Winbind keeps wbcDomainSid fields in host-endian. Copy fields from the
+ * wsid to the csid, while converting the subauthority fields to LE.
+ */
+static void
+wsid_to_csid(struct cifs_sid *csid, struct wbcDomainSid *wsid)
+{
+	int i;
+
+	csid->revision = wsid->sid_rev_num;
+	csid->num_subauth = wsid->num_auths;
+	for (i = 0; i < NUM_AUTHS; i++)
+		csid->authority[i] = wsid->id_auth[i];
+	for (i = 0; i < wsid->num_auths; i++)
+		csid->sub_auth[i] = htole32(wsid->sub_auths[i]);
+}
+
 static int
-verify_ace_sid(char *sidstr, struct cifs_sid *sid)
+verify_ace_sid(char *sidstr, struct cifs_sid *csid)
 {
 	int i;
 	wbcErr rc;
 	char *name, *domain;
 	enum wbcSidType type;
+	struct wbcDomainSid wsid;
 
 	name = strchr(sidstr, '\\');
 	if (!name) {
 		/* might be a raw string representation of SID */
-		rc = wbcStringToSid(sidstr, (struct wbcDomainSid *)sid);
+		rc = wbcStringToSid(sidstr, &wsid);
 		if (WBC_ERROR_IS_OK(rc))
-			goto fix_endianness;
+			goto convert_sid;
 
 		domain = "";
 		name = sidstr;
@@ -402,20 +420,15 @@ verify_ace_sid(char *sidstr, struct cifs_sid *sid)
 		++name;
 	}
 
-	rc = wbcLookupName(domain, name, (struct wbcDomainSid *)sid, &type);
+	rc = wbcLookupName(domain, name, &wsid, &type);
 	if (!WBC_ERROR_IS_OK(rc)) {
 		printf("%s: Error converting %s\\%s to SID: %s\n",
 			__func__, domain, name, wbcErrorString(rc));
 		return rc;
 	}
 
-fix_endianness:
-	/*
-	 * Winbind keeps wbcDomainSid fields in host-endian. So, we must
-	 * convert that to little endian since the server will expect that.
-	 */
-	for (i = 0; i < sid->num_subauth; i++)
-		sid->sub_auth[i] = htole32(sid->sub_auth[i]);
+convert_sid:
+	wsid_to_csid(csid, &wsid);
 	return 0;
 }
 
-- 
1.8.0
