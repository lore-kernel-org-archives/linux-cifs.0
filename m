From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 16/17] getcifsacl: don't use wbcDomainSid internally
Date: Sat,  3 Nov 2012 08:50:33 -0400
Message-ID: <1351947034-18876-17-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use our own cifs_sid instead and cast it to a wbcDomainSid before
handing it off to winbind.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index f7e6d4f..1bcbd58 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -176,16 +176,16 @@ print_ace_type(uint8_t acetype, int raw)
  * little endian here so that winbind will understand correctly.
  */
 static void
-convert_sid_endianness(struct wbcDomainSid *sid)
+convert_sid_endianness(struct cifs_sid *sid)
 {
 	int i;
 
 	for (i = 0; i < sid->num_subauth; i++)
-		sid->sub_auth[i] = le32toh(sid->sub_auths[i]);
+		sid->sub_auth[i] = le32toh(sid->sub_auth[i]);
 }
 
 static void
-print_sid(struct wbcDomainSid *sidptr, int raw)
+print_sid(struct cifs_sid *sidptr, int raw)
 {
 	int i;
 	int num_auths;
@@ -200,7 +200,8 @@ print_sid(struct wbcDomainSid *sidptr, int raw)
 	if (raw)
 		goto print_sid_raw;
 
-	rc = wbcLookupSid(sidptr, &domain_name, &sidname, &sntype);
+	rc = wbcLookupSid((struct wbcDomainSid *)sidptr, &domain_name,
+				&sidname, &sntype);
 	if (WBC_ERROR_IS_OK(rc)) {
 		printf("%s", domain_name);
 		if (strlen(domain_name))
@@ -210,14 +211,14 @@ print_sid(struct wbcDomainSid *sidptr, int raw)
 	}
 
 print_sid_raw:
-	num_auths = sidptr->num_auths;
+	num_auths = sidptr->num_subauth;
 	printf("S");
-	printf("-%d", sidptr->sid_rev_num);
+	printf("-%d", sidptr->revision);
 	for (i = 0; i < num_auth; ++i)
-		if (sidptr->id_auth[i])
-			printf("-%d", sidptr->id_auth[i]);
+		if (sidptr->authority[i])
+			printf("-%d", sidptr->authority[i]);
 	for (i = 0; i < num_auths; i++)
-		printf("-%u", sidptr->sub_auths[i]);
+		printf("-%u", sidptr->sub_auth[i]);
 }
 
 static void
@@ -232,7 +233,7 @@ print_ace(struct cifs_ace *pace, char *end_of_acl, int raw)
 		return;
 
 	printf("ACL:");
-	print_sid((struct wbcDomainSid *)&pace->sid, raw);
+	print_sid((struct cifs_sid *)&pace->sid, raw);
 	printf(":");
 	print_ace_type(pace->type, raw);
 	printf("/");
@@ -276,14 +277,14 @@ parse_dacl(struct cifs_ctrl_acl *pdacl, char *end_of_acl, int raw)
 }
 
 static int
-parse_sid(struct wbcDomainSid *psid, char *end_of_acl, char *title, int raw)
+parse_sid(struct cifs_sid *psid, char *end_of_acl, char *title, int raw)
 {
 	if (end_of_acl < (char *)psid + 8)
 		return -EINVAL;
 
 	if (title)
 		printf("%s:", title);
-	print_sid((struct wbcDomainSid *)psid, raw);
+	print_sid((struct cifs_sid *)psid, raw);
 	printf("\n");
 
 	return 0;
@@ -295,15 +296,15 @@ parse_sec_desc(struct cifs_ntsd *pntsd, ssize_t acl_len, int raw)
 	int rc;
 	uint32_t dacloffset;
 	char *end_of_acl = ((char *)pntsd) + acl_len;
-	struct wbcDomainSid *owner_sid_ptr, *group_sid_ptr;
+	struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
 	struct cifs_ctrl_acl *dacl_ptr; /* no need for SACL ptr */
 
 	if (pntsd == NULL)
 		return -EIO;
 
-	owner_sid_ptr = (struct wbcDomainSid *)((char *)pntsd +
+	owner_sid_ptr = (struct cifs_sid *)((char *)pntsd +
 				le32toh(pntsd->osidoffset));
-	group_sid_ptr = (struct wbcDomainSid *)((char *)pntsd +
+	group_sid_ptr = (struct cifs_sid *)((char *)pntsd +
 				le32toh(pntsd->gsidoffset));
 	dacloffset = le32toh(pntsd->dacloffset);
 	dacl_ptr = (struct cifs_ctrl_acl *)((char *)pntsd + dacloffset);
-- 
1.7.11.7
