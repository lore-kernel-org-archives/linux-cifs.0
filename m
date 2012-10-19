From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cifs: deal with id_to_sid embedded sid reply corner case
Date: Fri, 19 Oct 2012 15:59:45 -0400
Message-ID: <1350676785-8525-4-git-send-email-jlayton@redhat.com>
References: <1350676785-8525-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350676785-8525-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A SID could potentially be embedded inside of payload.value if there are
no subauthorities, and the arch has 8 byte pointers. Allow for that
possibility there.

While we're at it, rephrase the "embedding" check in terms of
key->payload to allow for the possibility that the union might change
size in the future.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 664abc3..bbe7928 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -63,7 +63,7 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 	 * With this however, you must check the datalen before trying to
 	 * dereference payload.data!
 	 */
-	if (prep->datalen <= sizeof(void *)) {
+	if (prep->datalen <= sizeof(key->payload)) {
 		key->payload.value = 0;
 		memcpy(&key->payload.value, prep->data, prep->datalen);
 		key->datalen = prep->datalen;
@@ -82,7 +82,7 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 static inline void
 cifs_idmap_key_destroy(struct key *key)
 {
-	if (key->datalen > sizeof(void *))
+	if (key->datalen > sizeof(key->payload))
 		kfree(key->payload.data);
 }
 
@@ -222,7 +222,15 @@ id_to_sid(unsigned int cid, uint sidtype, struct cifs_sid *ssid)
 		goto invalidate_key;
 	}
 
-	ksid = (struct cifs_sid *)sidkey->payload.data;
+	/*
+	 * A sid is usually too large to be embedded in payload.value, but if
+	 * there are no subauthorities and the host has 8-byte pointers, then
+	 * it could be.
+	 */
+	ksid = sidkey->datalen <= sizeof(sidkey->payload) ?
+		(struct cifs_sid *)&sidkey->payload.value :
+		(struct cifs_sid *)sidkey->payload.data;
+
 	ksid_size = CIFS_SID_BASE_SIZE + (ksid->num_subauth * sizeof(__le32));
 	if (ksid_size > sidkey->datalen) {
 		rc = -EIO;
@@ -230,6 +238,7 @@ id_to_sid(unsigned int cid, uint sidtype, struct cifs_sid *ssid)
 			"ksid_size=%u)", __func__, sidkey->datalen, ksid_size);
 		goto invalidate_key;
 	}
+
 	cifs_copy_sid(ssid, ksid);
 	key_set_timeout(sidkey, cifs_idmap_cache_timeout);
 out_key_put:
-- 
1.7.11.7
