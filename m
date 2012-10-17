From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/7] cifs: make cifs_copy_sid handle a source sid with variable size subauth arrays
Date: Wed, 17 Oct 2012 14:08:57 -0400
Message-ID: <1350497343-7155-2-git-send-email-jlayton@redhat.com>
References: <1350497343-7155-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350497343-7155-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and lift the restriction in id_to_sid upcall that the size must be
at least as big as a full cifs_sid.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c | 10 ++++++++--
 fs/cifs/cifsacl.h |  3 +++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 5a312eb..141a944 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -277,8 +277,14 @@ compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
 static void
 cifs_copy_sid(struct cifs_sid *dst, const struct cifs_sid *src)
 {
-	memcpy(dst, src, sizeof(*dst));
+	int i;
+
+	dst->revision = src->revision;
 	dst->num_subauth = min_t(u8, src->num_subauth, NUM_SUBAUTHS);
+	for (i = 0; i < NUM_AUTHS; ++i)
+		dst->authority[i] = src->authority[i];
+	for (i = 0; i < dst->num_subauth; ++i)
+		dst->sub_auth[i] = src->sub_auth[i];
 }
 
 static void
@@ -427,7 +433,7 @@ id_to_sid(unsigned long cid, uint sidtype, struct cifs_sid *ssid)
 		if (IS_ERR(sidkey)) {
 			rc = -EINVAL;
 			cFYI(1, "%s: Can't map and id to a SID", __func__);
-		} else if (sidkey->datalen < sizeof(struct cifs_sid)) {
+		} else if (sidkey->datalen < CIFS_SID_BASE_SIZE) {
 			rc = -EIO;
 			cFYI(1, "%s: Downcall contained malformed key "
 				"(datalen=%hu)", __func__, sidkey->datalen);
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 18c7521..7e52f19 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -64,6 +64,9 @@ struct cifs_sid {
 	__le32 sub_auth[NUM_SUBAUTHS]; /* sub_auth[num_subauth] */
 } __attribute__((packed));
 
+/* size of a struct cifs_sid, sans sub_auth array */
+#define CIFS_SID_BASE_SIZE (1 + 1 + NUM_AUTHS)
+
 struct cifs_acl {
 	__le16 revision; /* revision level */
 	__le16 size;
-- 
1.7.11.7
