From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/3] cifs: fix SID binary to string conversion
Date: Tue, 30 Oct 2012 14:53:35 -0400
Message-ID: <1351623215-13048-1-git-send-email-jlayton@redhat.com>
References: <1350676785-8525-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350676785-8525-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The authority fields are supposed to be represented by a single 48-bit
big-endian value. It's also supposed to represent the value as hex if
it's equal to or greater than 2^32. This is documented in MS-DTYP,
section 2.4.2.1.

Also, fix up the max string length to account for this fix.

Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c | 25 +++++++++++++++++++------
 fs/cifs/cifsacl.h |  8 +++++---
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index c15699b..6c8ea82 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -94,6 +94,7 @@ sid_to_key_str(struct cifs_sid *sidptr, unsigned int type)
 	int i, len;
 	unsigned int saval;
 	char *sidstr, *strptr;
+	unsigned long long id_auth_val;
 
 	/* 3 bytes for prefix */
 	sidstr = kmalloc(3 + SID_STRING_BASE_SIZE +
@@ -107,12 +108,24 @@ sid_to_key_str(struct cifs_sid *sidptr, unsigned int type)
 			sidptr->revision);
 	strptr += len;
 
-	for (i = 0; i < NUM_AUTHS; ++i) {
-		if (sidptr->authority[i]) {
-			len = sprintf(strptr, "-%hhu", sidptr->authority[i]);
-			strptr += len;
-		}
-	}
+	/* The authority field is a single 48-bit number */
+	id_auth_val = (unsigned long long)sidptr->authority[5];
+	id_auth_val += (unsigned long long)sidptr->authority[4] << 8;
+	id_auth_val += (unsigned long long)sidptr->authority[3] << 16;
+	id_auth_val += (unsigned long long)sidptr->authority[2] << 24;
+	id_auth_val += (unsigned long long)sidptr->authority[1] << 32;
+	id_auth_val += (unsigned long long)sidptr->authority[0] << 48;
+
+        /*
+	 * MS-DTYP states that if the authority is >= 2^32, then it should be
+	 * expressed as a hex value.
+	 */
+	if (id_auth_val <= UINT_MAX)
+		len = sprintf(strptr, "-%llu", id_auth_val);
+	else
+		len = sprintf(strptr, "-0x%llx", id_auth_val);
+
+	strptr += len;
 
 	for (i = 0; i < sidptr->num_subauth; ++i) {
 		saval = le32_to_cpu(sidptr->sub_auth[i]);
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index a445405..4f38848 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -55,12 +55,14 @@
  * u8:  max 3 bytes in decimal
  * u32: max 10 bytes in decimal
  *
- * "S-" + 3 bytes for version field + 4 bytes for each authority field (3 bytes
- * per number + 1 for '-') + NULL terminator.
+ * "S-" + 3 bytes for version field + 15 for authority field + NULL terminator
+ *
+ * For authority field, max is when all 6 values are non-zero and it must be
+ * represented in hex. So "-0x" + 12 hex digits.
  *
  * Add 11 bytes for each subauthority field (10 bytes each + 1 for '-')
  */
-#define SID_STRING_BASE_SIZE (2 + 3 + (4 * NUM_AUTHS) + 1)
+#define SID_STRING_BASE_SIZE (2 + 3 + 15 + 1)
 #define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string */
 
 struct cifs_ntsd {
-- 
1.7.11.7
