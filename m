From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/2] getcifsacl: don't freely cast between wbcDomainSid and cifs_sid
Date: Fri,  9 Nov 2012 07:04:25 -0500
Message-ID: <1352462666-10910-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

While they are very similar, the cifs_sid is "packed" and the
wbcDomainSid isn't. There are also aliasing problems with gcc in
some cases. Instead of trying to cast and fix endianness in place,
make a separate copy instead.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index b76c8ec..626f83c 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -173,16 +173,20 @@ print_ace_type(uint8_t acetype, int raw)
 }
 
 /*
- * Winbind keeps wbcDomainSid fields in host-endian. So, we must convert from
- * little endian here so that winbind will understand correctly.
+ * Winbind keeps wbcDomainSid fields in host-endian. Copy fields from the
+ * csid to the wsid, while converting the subauthority fields from LE.
  */
 static void
-convert_sid_endianness(struct cifs_sid *sid)
+csid_to_wsid(struct wbcDomainSid *wsid, const struct cifs_sid *csid)
 {
 	int i;
 
-	for (i = 0; i < sid->num_subauth; i++)
-		sid->sub_auth[i] = le32toh(sid->sub_auth[i]);
+	wsid->sid_rev_num = csid->revision;
+	wsid->num_auths = csid->num_subauth;
+	for (i = 0; i < NUM_AUTHS; i++)
+		wsid->id_auth[i] = csid->authority[i];
+	for (i = 0; i < csid->num_subauth; i++)
+		wsid->sub_auths[i] = le32toh(csid->sub_auth[i]);
 }
 
 static void
@@ -194,14 +198,14 @@ print_sid(struct cifs_sid *sidptr, int raw)
 	char *sidname = NULL;
 	enum wbcSidType sntype;
 	unsigned long long id_auth_val;
+	struct wbcDomainSid wsid;
 
-	convert_sid_endianness(sidptr);
+	csid_to_wsid(&wsid, sidptr);
 
 	if (raw)
 		goto print_sid_raw;
 
-	rc = wbcLookupSid((struct wbcDomainSid *)sidptr, &domain_name,
-				&sidname, &sntype);
+	rc = wbcLookupSid(&wsid, &domain_name, &sidname, &sntype);
 	if (WBC_ERROR_IS_OK(rc)) {
 		printf("%s", domain_name);
 		if (strlen(domain_name))
@@ -211,14 +215,14 @@ print_sid(struct cifs_sid *sidptr, int raw)
 	}
 
 print_sid_raw:
-	printf("S-%hhu", sidptr->revision);
+	printf("S-%hhu", wsid.sid_rev_num);
 
-	id_auth_val = (unsigned long long)sidptr->authority[5];
-	id_auth_val += (unsigned long long)sidptr->authority[4] << 8;
-	id_auth_val += (unsigned long long)sidptr->authority[3] << 16;
-	id_auth_val += (unsigned long long)sidptr->authority[2] << 24;
-	id_auth_val += (unsigned long long)sidptr->authority[1] << 32;
-	id_auth_val += (unsigned long long)sidptr->authority[0] << 48;
+	id_auth_val = (unsigned long long)wsid.id_auth[5];
+	id_auth_val += (unsigned long long)wsid.id_auth[4] << 8;
+	id_auth_val += (unsigned long long)wsid.id_auth[3] << 16;
+	id_auth_val += (unsigned long long)wsid.id_auth[2] << 24;
+	id_auth_val += (unsigned long long)wsid.id_auth[1] << 32;
+	id_auth_val += (unsigned long long)wsid.id_auth[0] << 48;
 
 	/*
 	 * MS-DTYP states that if the authority is >= 2^32, then it should be
@@ -229,8 +233,8 @@ print_sid_raw:
 	else
 		printf("-0x%llx", id_auth_val);
 
-	for (i = 0; i < sidptr->num_subauth; i++)
-		printf("-%u", sidptr->sub_auth[i]);
+	for (i = 0; i < wsid.num_auths; i++)
+		printf("-%u", wsid.sub_auths[i]);
 }
 
 static void
-- 
1.8.0
