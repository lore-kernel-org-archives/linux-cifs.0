From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 15/17] getcifsacl: fix endianness before handing off SID to winbind
Date: Sat,  3 Nov 2012 08:50:32 -0400
Message-ID: <1351947034-18876-16-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

winbind expects SIDs to be expressed in host-endian. Convert them
from little-endian before asking winbind to convert them to names.

Also use the WBC_ERROR_IS_OK() macro to check the return code.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index 083705c..f7e6d4f 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -171,6 +171,19 @@ print_ace_type(uint8_t acetype, int raw)
 	}
 }
 
+/*
+ * Winbind keeps wbcDomainSid fields in host-endian. So, we must convert from
+ * little endian here so that winbind will understand correctly.
+ */
+static void
+convert_sid_endianness(struct wbcDomainSid *sid)
+{
+	int i;
+
+	for (i = 0; i < sid->num_subauth; i++)
+		sid->sub_auth[i] = le32toh(sid->sub_auths[i]);
+}
+
 static void
 print_sid(struct wbcDomainSid *sidptr, int raw)
 {
@@ -182,11 +195,13 @@ print_sid(struct wbcDomainSid *sidptr, int raw)
 	char *sidname = NULL;
 	enum wbcSidType sntype;
 
+	convert_sid_endianness(sidptr);
+
 	if (raw)
 		goto print_sid_raw;
 
 	rc = wbcLookupSid(sidptr, &domain_name, &sidname, &sntype);
-	if (!rc) {
+	if (WBC_ERROR_IS_OK(rc)) {
 		printf("%s", domain_name);
 		if (strlen(domain_name))
 			printf("%c", '\\');
@@ -202,7 +217,7 @@ print_sid_raw:
 		if (sidptr->id_auth[i])
 			printf("-%d", sidptr->id_auth[i]);
 	for (i = 0; i < num_auths; i++)
-		printf("-%u", le32toh(sidptr->sub_auths[i]));
+		printf("-%u", sidptr->sub_auths[i]);
 }
 
 static void
-- 
1.7.11.7
