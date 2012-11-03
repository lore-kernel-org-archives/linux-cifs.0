From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 08/17] setcifsacl: fix endianness on SIDs provided by winbind routines
Date: Sat,  3 Nov 2012 08:50:25 -0400
Message-ID: <1351947034-18876-9-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Winbind keeps SID fields in host-endian format, but setcifsacl doesn't
currently account for that. Make sure that when we get a valid SID
from wbc that we convert the subauth fields to little-endian, which
the server will expect. The other fields are single bytes and don't
need conversion.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 4c09345..612796b 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -396,7 +396,7 @@ build_fetched_aces_ret:
 static int
 verify_ace_sid(char *sidstr, struct cifs_sid *sid)
 {
-	int rc;
+	int rc, i;
 	char *lstr;
 	struct passwd *winpswdptr;
 
@@ -409,7 +409,7 @@ verify_ace_sid(char *sidstr, struct cifs_sid *sid)
 	/* Check if it is a (raw) SID (string) */
 	rc = wbcStringToSid(lstr, (struct wbcDomainSid *)sid);
 	if (!rc)
-		return rc;
+		goto fix_endianness;
 
 	/* Check if it a name (string) which can be resolved to a SID*/
 	rc = wbcGetpwnam(lstr, &winpswdptr);
@@ -423,6 +423,13 @@ verify_ace_sid(char *sidstr, struct cifs_sid *sid)
 		return rc;
 	}
 
+fix_endianness:
+	/*
+	 * Winbind keeps wbcDomainSid fields in host-endian. So, we must
+	 * convert that to little endian since the server will expect that.
+	 */
+	for (i = 0; i < sid->num_subauth; i++)
+		sid->sub_auth[i] = htole32(sid->sub_auth[i]);
 	return 0;
 }
 
-- 
1.7.11.7
