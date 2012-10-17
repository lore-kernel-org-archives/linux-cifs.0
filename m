From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/7] cifs: redefine NUM_SUBAUTH constant from 5 to 15
Date: Wed, 17 Oct 2012 14:08:58 -0400
Message-ID: <1350497343-7155-3-git-send-email-jlayton@redhat.com>
References: <1350497343-7155-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350497343-7155-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

According to several places on the Internet and the samba winbind code,
this is hard limited to 15 in windows, not 5. This does balloon out
the allocation of each by 40 bytes, but I don't see any alternative.

Also, rename it to SID_MAX_SUB_AUTHORITIES to match the alleged name
of this constant in the windows header files

Finally, rename SIDLEN to SID_STRING_MAX, fix the value to reflect
the change to SID_MAX_SUB_AUTHORITIES and document how it was
determined.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c |  6 +++---
 fs/cifs/cifsacl.h | 19 ++++++++++++++++---
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 141a944..dd8d3df 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -280,7 +280,7 @@ cifs_copy_sid(struct cifs_sid *dst, const struct cifs_sid *src)
 	int i;
 
 	dst->revision = src->revision;
-	dst->num_subauth = min_t(u8, src->num_subauth, NUM_SUBAUTHS);
+	dst->num_subauth = min_t(u8, src->num_subauth, SID_MAX_SUB_AUTHORITIES);
 	for (i = 0; i < NUM_AUTHS; ++i)
 		dst->authority[i] = src->authority[i];
 	for (i = 0; i < dst->num_subauth; ++i)
@@ -383,7 +383,7 @@ id_to_sid(unsigned long cid, uint sidtype, struct cifs_sid *ssid)
 		if (!npsidid)
 			return -ENOMEM;
 
-		npsidid->sidstr = kmalloc(SIDLEN, GFP_KERNEL);
+		npsidid->sidstr = kmalloc(SID_STRING_MAX, GFP_KERNEL);
 		if (!npsidid->sidstr) {
 			kfree(npsidid);
 			return -ENOMEM;
@@ -500,7 +500,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		if (!npsidid)
 			return -ENOMEM;
 
-		npsidid->sidstr = kmalloc(SIDLEN, GFP_KERNEL);
+		npsidid->sidstr = kmalloc(SID_STRING_MAX, GFP_KERNEL);
 		if (!npsidid->sidstr) {
 			kfree(npsidid);
 			return -ENOMEM;
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 7e52f19..8b980cd 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -24,7 +24,7 @@
 
 
 #define NUM_AUTHS 6 /* number of authority fields */
-#define NUM_SUBAUTHS 5 /* number of sub authority fields */
+#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fields */
 #define NUM_WK_SIDS 7 /* number of well known sids */
 #define SIDNAMELENGTH 20 /* long enough for the ones we care about */
 #define DEFSECDESCLEN 192 /* sec desc len contaiting a dacl with three aces */
@@ -41,7 +41,20 @@
 
 #define SIDOWNER 1
 #define SIDGROUP 2
-#define SIDLEN 150 /* S- 1 revision- 6 authorities- max 5 sub authorities */
+
+/*
+ * Maximum size of a string representation of a SID:
+ *
+ * The fields are unsigned values in decimal. So:
+ *
+ * u8:  max 3 bytes in decimal
+ * u32: max 10 bytes in decimal
+ *
+ * "S-" + 3 bytes for version field + 4 bytes for each authority field (3 bytes
+ * per number + 1 for '-') + 11 bytes for each subauthority field (10 bytes
+ * per number + 1 for '-') + NULL terminator.
+ */
+#define SID_STRING_MAX (195)
 
 #define SID_ID_MAPPED 0
 #define SID_ID_PENDING 1
@@ -61,7 +74,7 @@ struct cifs_sid {
 	__u8 revision; /* revision level */
 	__u8 num_subauth;
 	__u8 authority[NUM_AUTHS];
-	__le32 sub_auth[NUM_SUBAUTHS]; /* sub_auth[num_subauth] */
+	__le32 sub_auth[SID_MAX_SUB_AUTHORITIES]; /* sub_auth[num_subauth] */
 } __attribute__((packed));
 
 /* size of a struct cifs_sid, sans sub_auth array */
-- 
1.7.11.7
