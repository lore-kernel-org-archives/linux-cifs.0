From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] keys: add a "secret" key type
Date: Fri,  6 Jan 2012 08:11:21 -0500
Message-ID: <1325855483-8846-2-git-send-email-jlayton@redhat.com>
References: <1325855483-8846-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325855483-8846-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

For CIFS, we want to be able to store NTLM credentials (aka username
and password) in the keyring. We do not, however want to allow users
to fetch those keys back out of the keyring since that would be a
security risk.

Unfortunately, due to the nuances of key permission bits, it's not
possible to do this. We need to grant search permissions so the kernel
can find these keys, but that also implies permissions to read the
payload.

Resolve this by adding a new key_type. This key type is essentially
the same as key_type_user, but does not define a .read op. This
prevents the payload from ever being visible from userspace.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/keys/user-type.h     |    3 ++-
 security/keys/internal.h     |    1 +
 security/keys/key.c          |    1 +
 security/keys/user_defined.c |   17 +++++++++++++++++
 4 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/include/keys/user-type.h b/include/keys/user-type.h
index c37c342..41b5515 100644
--- a/include/keys/user-type.h
+++ b/include/keys/user-type.h
@@ -17,7 +17,7 @@
 
 /*****************************************************************************/
 /*
- * the payload for a key of type "user"
+ * the payload for a key of type "user" or "secret"
  * - once filled in and attached to a key:
  *   - the payload struct is invariant may not be changed, only replaced
  *   - the payload must be read with RCU procedures or with the key semaphore
@@ -33,6 +33,7 @@ struct user_key_payload {
 };
 
 extern struct key_type key_type_user;
+extern struct key_type key_type_secret;
 
 extern int user_instantiate(struct key *key, const void *data, size_t datalen);
 extern int user_update(struct key *key, const void *data, size_t datalen);
diff --git a/security/keys/internal.h b/security/keys/internal.h
index c7a7cae..2784e07 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -33,6 +33,7 @@
 
 extern struct key_type key_type_dead;
 extern struct key_type key_type_user;
+extern struct key_type key_type_secret;
 
 /*****************************************************************************/
 /*
diff --git a/security/keys/key.c b/security/keys/key.c
index 4414abd..3d1d79d 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -996,6 +996,7 @@ void __init key_init(void)
 	list_add_tail(&key_type_keyring.link, &key_types_list);
 	list_add_tail(&key_type_dead.link, &key_types_list);
 	list_add_tail(&key_type_user.link, &key_types_list);
+	list_add_tail(&key_type_secret.link, &key_types_list);
 
 	/* record the root user tracking */
 	rb_link_node(&root_key_user.node,
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 69ff52c..e25782f 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -36,6 +36,23 @@ struct key_type key_type_user = {
 EXPORT_SYMBOL_GPL(key_type_user);
 
 /*
+ * This key type is essentially the same as key_type_user, but it does
+ * not define a .read op. This is suitable for storing information in
+ * the keyring that you do not want to be readable from userspace. For
+ * instance, passwords or secret encryption keys.
+ */
+struct key_type key_type_secret = {
+	.name		= "secret",
+	.instantiate	= user_instantiate,
+	.update		= user_update,
+	.match		= user_match,
+	.revoke		= user_revoke,
+	.destroy	= user_destroy,
+	.describe	= user_describe,
+};
+EXPORT_SYMBOL_GPL(key_type_secret);
+
+/*
  * instantiate a user defined key
  */
 int user_instantiate(struct key *key, const void *data, size_t datalen)
-- 
1.7.7.4
