From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 6/9] cifs: avoid extra allocation for small cifs.idmap keys
Date: Tue,  6 Nov 2012 16:14:19 -0500
Message-ID: <1352236459-18787-1-git-send-email-jlayton@redhat.com>
References: <1350649250-5343-7-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350649250-5343-7-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The cifs.idmap keytype always allocates memory to hold the payload from
userspace. In the common case where we're translating a SID to a UID or
GID, we're allocating memory to hold something that's less than or equal
to the size of a pointer.

When the payload is the same size as a pointer or smaller, just store
it in the payload.value union member instead. That saves us an extra
allocation on the sid_to_id upcall.

Note that we have to take extra care to check the datalen when we
go to dereference the .data pointer in the union, but the callers
now check that as a matter of course anyway.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index f4508ee..751d34b 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -49,6 +49,20 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
 	char *payload;
 
+	/*
+	 * If the payload is less than or equal to the size of a pointer, then
+	 * an allocation here is wasteful. Just copy the data directly to the
+	 * payload.value union member instead.
+	 *
+	 * With this however, you must check the datalen before trying to
+	 * dereference payload.data!
+	 */
+	if (prep->datalen <= sizeof(void *)) {
+		key->payload.value = 0;
+		memcpy(&key->payload.value, prep->data, prep->datalen);
+		key->datalen = prep->datalen;
+		return 0;
+	}
 	payload = kmalloc(prep->datalen, GFP_KERNEL);
 	if (!payload)
 		return -ENOMEM;
@@ -62,7 +76,8 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 static inline void
 cifs_idmap_key_destroy(struct key *key)
 {
-	kfree(key->payload.data);
+	if (key->datalen > sizeof(void *))
+		kfree(key->payload.data);
 }
 
 static struct key_type cifs_idmap_key_type = {
@@ -245,7 +260,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	 * probably a safe assumption but might be better to check based on
 	 * sidtype.
 	 */
-	if (sidkey->datalen < sizeof(uid_t)) {
+	if (sidkey->datalen != sizeof(uid_t)) {
 		rc = -EIO;
 		cFYI(1, "%s: Downcall contained malformed key "
 			"(datalen=%hu)", __func__, sidkey->datalen);
@@ -253,9 +268,9 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	}
 
 	if (sidtype == SIDOWNER)
-		fuid = *(uid_t *)sidkey->payload.value;
+		memcpy(&fuid, &sidkey->payload.value, sizeof(uid_t));
 	else
-		fgid = *(gid_t *)sidkey->payload.value;
+		memcpy(&fgid, &sidkey->payload.value, sizeof(gid_t));
 
 out_key_put:
 	key_put(sidkey);
-- 
1.7.11.7
