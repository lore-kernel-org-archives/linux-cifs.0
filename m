From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] cifs: extra sanity checking for cifs.idmap keys
Date: Fri, 19 Oct 2012 15:59:43 -0400
Message-ID: <1350676785-8525-2-git-send-email-jlayton@redhat.com>
References: <1350676785-8525-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350676785-8525-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we aren't so rigid about the length of the key being passed
in, we need to be a bit more rigorous about checking the length of
the actual data against the claimed length (a'la num_subauths field).

Check for the case where userspace sends us a seemingly valid key
with a num_subauths field that goes beyond the end of the array. If
that happens, return -EIO and invalidate the key.

Also change the other places where we check for malformed keys in this
code to invalidate the key as well.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 0c0a594..bd18723 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -197,6 +197,8 @@ id_to_sid(unsigned int cid, uint sidtype, struct cifs_sid *ssid)
 {
 	int rc;
 	struct key *sidkey;
+	struct cifs_sid *ksid;
+	unsigned int ksid_size;
 	char desc[3 + 10 + 1]; /* 3 byte prefix + 10 bytes for value + NULL */
 	const struct cred *saved_cred;
 
@@ -217,15 +219,28 @@ id_to_sid(unsigned int cid, uint sidtype, struct cifs_sid *ssid)
 		rc = -EIO;
 		cFYI(1, "%s: Downcall contained malformed key "
 			"(datalen=%hu)", __func__, sidkey->datalen);
-		goto out_key_put;
+		goto invalidate_key;
 	}
-	cifs_copy_sid(ssid, (struct cifs_sid *)sidkey->payload.data);
+
+	ksid = (struct cifs_sid *)sidkey->payload.data;
+	ksid_size = CIFS_SID_BASE_SIZE + (ksid->num_subauth * sizeof(__le32));
+	if (ksid_size > sidkey->datalen) {
+		rc = -EIO;
+		cFYI(1, "%s: Downcall contained malformed key (datalen=%hu, "
+			"ksid_size=%u)", __func__, sidkey->datalen, ksid_size);
+		goto invalidate_key;
+	}
+	cifs_copy_sid(ssid, ksid);
 	key_set_timeout(sidkey, cifs_idmap_cache_timeout);
 out_key_put:
 	key_put(sidkey);
 out_revert_creds:
 	revert_creds(saved_cred);
 	return rc;
+
+invalidate_key:
+	key_invalidate(sidkey);
+	goto out_key_put;
 }
 
 static int
@@ -271,6 +286,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		rc = -EIO;
 		cFYI(1, "%s: Downcall contained malformed key "
 			"(datalen=%hu)", __func__, sidkey->datalen);
+		key_invalidate(sidkey);
 		goto out_key_put;
 	}
 
-- 
1.7.11.7
