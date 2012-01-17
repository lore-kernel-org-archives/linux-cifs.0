From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 1/4] keys: add a "logon" key type
Date: Tue, 17 Jan 2012 16:42:24 -0500
Message-ID: <1326836547-7011-2-git-send-email-jlayton@redhat.com>
References: <1326836547-7011-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1326836547-7011-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
prevents the payload from ever being visible from userspace. This
key type also vets the description to ensure that it's "qualified"
by checking to ensure that it has a ':' in it that is preceded by
other characters.

Acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/keys/user-type.h     |    3 ++-
 security/keys/internal.h     |    1 +
 security/keys/key.c          |    1 +
 security/keys/user_defined.c |   37 +++++++++++++++++++++++++++++++++++++
 4 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/include/keys/user-type.h b/include/keys/user-type.h
index c37c342..bc9ec1d 100644
--- a/include/keys/user-type.h
+++ b/include/keys/user-type.h
@@ -17,7 +17,7 @@
 
 /*****************************************************************************/
 /*
- * the payload for a key of type "user"
+ * the payload for a key of type "user" or "logon"
  * - once filled in and attached to a key:
  *   - the payload struct is invariant may not be changed, only replaced
  *   - the payload must be read with RCU procedures or with the key semaphore
@@ -33,6 +33,7 @@ struct user_key_payload {
 };
 
 extern struct key_type key_type_user;
+extern struct key_type key_type_logon;
 
 extern int user_instantiate(struct key *key, const void *data, size_t datalen);
 extern int user_update(struct key *key, const void *data, size_t datalen);
diff --git a/security/keys/internal.h b/security/keys/internal.h
index c7a7cae..65647f8 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -33,6 +33,7 @@
 
 extern struct key_type key_type_dead;
 extern struct key_type key_type_user;
+extern struct key_type key_type_logon;
 
 /*****************************************************************************/
 /*
diff --git a/security/keys/key.c b/security/keys/key.c
index 4f64c72..7ada801 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -999,6 +999,7 @@ void __init key_init(void)
 	list_add_tail(&key_type_keyring.link, &key_types_list);
 	list_add_tail(&key_type_dead.link, &key_types_list);
 	list_add_tail(&key_type_user.link, &key_types_list);
+	list_add_tail(&key_type_logon.link, &key_types_list);
 
 	/* record the root user tracking */
 	rb_link_node(&root_key_user.node,
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 69ff52c..6e1a627 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -18,6 +18,8 @@
 #include <asm/uaccess.h>
 #include "internal.h"
 
+static int logon_vet_description(const char *desc);
+
 /*
  * user defined keys take an arbitrary string as the description and an
  * arbitrary blob of data as the payload
@@ -36,6 +38,24 @@ struct key_type key_type_user = {
 EXPORT_SYMBOL_GPL(key_type_user);
 
 /*
+ * This key type is essentially the same as key_type_user, but it does
+ * not define a .read op. This is suitable for storing username and
+ * password pairs in the keyring that you do not want to be readable
+ * from userspace.
+ */
+struct key_type key_type_logon = {
+	.name			= "logon",
+	.instantiate		= user_instantiate,
+	.update			= user_update,
+	.match			= user_match,
+	.revoke			= user_revoke,
+	.destroy		= user_destroy,
+	.describe		= user_describe,
+	.vet_description	= logon_vet_description,
+};
+EXPORT_SYMBOL_GPL(key_type_logon);
+
+/*
  * instantiate a user defined key
  */
 int user_instantiate(struct key *key, const void *data, size_t datalen)
@@ -189,3 +209,20 @@ long user_read(const struct key *key, char __user *buffer, size_t buflen)
 }
 
 EXPORT_SYMBOL_GPL(user_read);
+
+/* Vet the description for a "logon" key */
+static int logon_vet_description(const char *desc)
+{
+	char *p;
+
+	/* require a "qualified" description string */
+	p = strchr(desc, ':');
+	if (!p)
+		return -EINVAL;
+
+	/* also reject description with ':' as first char */
+	if (p == desc)
+		return -EINVAL;
+
+	return 0;
+}
-- 
1.7.7.5
