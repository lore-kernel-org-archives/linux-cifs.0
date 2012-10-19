From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] cifs: fix hardcoded default security descriptor length
Date: Fri, 19 Oct 2012 15:59:44 -0400
Message-ID: <1350676785-8525-3-git-send-email-jlayton@redhat.com>
References: <1350676785-8525-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350676785-8525-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It was hardcoded to 192 bytes, which was not enough when the max number
of subauthorities went to 15. Redefine this constant in terms of sizeof
the structs involved, and rename it for better clarity.

While we're at it, remove a couple more unused constants from cifsacl.h.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c |  2 +-
 fs/cifs/cifsacl.h | 11 ++++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index bd18723..664abc3 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1016,7 +1016,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 	 * memory for the smb header, set security descriptor request security
 	 * descriptor parameters, and secuirty descriptor itself
 	 */
-	secdesclen = max_t(u32, secdesclen, DEFSECDESCLEN);
+	secdesclen = max_t(u32, secdesclen, DEFAULT_SEC_DESC_LEN);
 	pnntsd = kmalloc(secdesclen, GFP_KERNEL);
 	if (!pnntsd) {
 		cERROR(1, "Unable to allocate security descriptor");
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 46cd444..a445405 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -25,9 +25,6 @@
 
 #define NUM_AUTHS (6)	/* number of authority fields */
 #define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fields */
-#define NUM_WK_SIDS 7 /* number of well known sids */
-#define SIDNAMELENGTH 20 /* long enough for the ones we care about */
-#define DEFSECDESCLEN 192 /* sec desc len contaiting a dacl with three aces */
 
 #define READ_BIT        0x4
 #define WRITE_BIT       0x2
@@ -43,6 +40,14 @@
 #define SIDGROUP 2
 
 /*
+ * Security Descriptor length containing DACL with 3 ACEs (one each for
+ * owner, group and world).
+ */
+#define DEFAULT_SEC_DESC_LEN (sizeof(struct cifs_ntsd) + \
+			      sizeof(struct cifs_acl) + \
+			      (sizeof(struct cifs_ace) * 3))
+
+/*
  * Maximum size of a string representation of a SID:
  *
  * The fields are unsigned values in decimal. So:
-- 
1.7.11.7
