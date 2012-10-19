From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/9] cifs: remove uneeded __KERNEL__ block from cifsacl.h
Date: Fri, 19 Oct 2012 08:20:45 -0400
Message-ID: <1350649250-5343-5-git-send-email-jlayton@redhat.com>
References: <1350649250-5343-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350649250-5343-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and make those symbols static in cifsacl.c. Nothing outside
of that file refers to them.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c | 4 ++--
 fs/cifs/cifsacl.h | 5 -----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 9adcdb5..42b3fe9 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -42,7 +42,7 @@ static const struct cifs_sid sid_authusers = {
 /* group users */
 static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
 
-const struct cred *root_cred;
+static const struct cred *root_cred;
 
 static void
 shrink_idmap_tree(struct rb_root *root, int nr_to_scan, int *nr_rem,
@@ -187,7 +187,7 @@ cifs_idmap_key_destroy(struct key *key)
 	kfree(key->payload.data);
 }
 
-struct key_type cifs_idmap_key_type = {
+static struct key_type cifs_idmap_key_type = {
 	.name        = "cifs.idmap",
 	.instantiate = cifs_idmap_key_instantiate,
 	.destroy     = cifs_idmap_key_destroy,
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 8b980cd..249c94f 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -109,9 +109,4 @@ struct cifs_sid_id {
 	struct cifs_sid sid;
 };
 
-#ifdef __KERNEL__
-extern struct key_type cifs_idmap_key_type;
-extern const struct cred *root_cred;
-#endif /* KERNEL */
-
 #endif /* _CIFSACL_H */
-- 
1.7.11.7
