From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 13/17] setcifsacl: fix verify_ace_sid
Date: Sat,  3 Nov 2012 08:50:30 -0400
Message-ID: <1351947034-18876-14-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The current method of trying to convert a name to a password struct and
then back to a SID is just weird. It also doesn't seem to work correctly.

Instead, look for a '\\' in the string. If there isn't one then try to
convert it directly to a SID.

If there is a '\\' or the direct-to-SID conversion didn't work, then
use wbcLookupName to do the conversion directly to a SID instead.

Also, fix the error handling. These routines return a wbcErr, so we
should use their macros to check whether it worked or not.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 54d8cbc..9f748c1 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -396,30 +396,30 @@ build_fetched_aces_ret:
 static int
 verify_ace_sid(char *sidstr, struct cifs_sid *sid)
 {
-	int rc, i;
-	char *lstr;
-	struct passwd *winpswdptr;
-
-	lstr = strstr(sidstr, "\\"); /* everything before | */
-	if (lstr)
-		++lstr;
-	else
-		lstr = sidstr;
-
-	/* Check if it is a (raw) SID (string) */
-	rc = wbcStringToSid(lstr, (struct wbcDomainSid *)sid);
-	if (!rc)
-		goto fix_endianness;
-
-	/* Check if it a name (string) which can be resolved to a SID*/
-	rc = wbcGetpwnam(lstr, &winpswdptr);
-	if (rc) {
-		printf("%s: Invalid user name: %s\n", __func__, sidstr);
-		return rc;
-	}
-	rc = wbcUidToSid(winpswdptr->pw_uid, (struct wbcDomainSid *)sid);
-	if (rc) {
-		printf("%s: Invalid user: %s\n", __func__, sidstr);
+	int i;
+	wbcErr rc;
+	char *name, *domain;
+	enum wbcSidType type;
+
+	name = strchr(sidstr, '\\');
+	if (!name) {
+		/* might be a raw string representation of SID */
+		rc = wbcStringToSid(sidstr, (struct wbcDomainSid *)sid);
+		if (WBC_ERROR_IS_OK(rc))
+			goto fix_endianness;
+
+		domain = "";
+		name = sidstr;
+	} else {
+		domain = sidstr;
+		*name = '\0';
+		++name;
+	}
+
+	rc = wbcLookupName(domain, name, (struct wbcDomainSid *)sid, &type);
+	if (!WBC_ERROR_IS_OK(rc)) {
+		printf("%s: Error converting %s\\%s to SID: %s\n",
+			__func__, domain, name, wbcErrorString(rc));
 		return rc;
 	}
 
-- 
1.7.11.7
