From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/3] cifs: Add idmap key and related functions (try #3)
Date: Fri, 21 Jan 2011 15:44:20 -0600
Message-ID: <1295646260-21875-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

A new type of key, cifs_idmap_key_type, is used.

Keys are instantiated and searched using credential of the root by
overriding and restoring the credentials of the caller requesting the key.
Once a SID is mapped, it is stored along with the mapped id, in one
of the rb trees and key is released.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c   |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsacl.h   |    5 +++
 fs/cifs/cifsfs.c    |    6 +++
 fs/cifs/cifsproto.h |    2 +
 fs/cifs/connect.c   |   12 ++++++
 5 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 1e7636b..8ad2e71 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -23,6 +23,10 @@
 
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/keyctl.h>
+#include <linux/key-type.h>
+#include <keys/user-type.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsacl.h"
@@ -50,6 +54,96 @@ static const struct cifs_sid sid_authusers = {
 /* group users */
 static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
 
+const struct cred *root_cred;
+
+static int
+cifs_idmap_key_instantiate(struct key *key, const void *data, size_t datalen)
+{
+	char *payload;
+
+	payload = kmalloc(datalen, GFP_KERNEL);
+	if (!payload)
+		return -ENOMEM;
+
+	memcpy(payload, data, datalen);
+	key->payload.data = payload;
+	return 0;
+}
+
+static inline void
+cifs_idmap_key_destroy(struct key *key)
+{
+	kfree(key->payload.data);
+}
+
+struct key_type cifs_idmap_key_type = {
+	.name        = "cifs.cifs_idmap",
+	.instantiate = cifs_idmap_key_instantiate,
+	.destroy     = cifs_idmap_key_destroy,
+	.describe    = user_describe,
+	.match       = user_match,
+};
+
+int
+init_cifs_idmap(void)
+{
+	struct cred *cred;
+	struct key *keyring;
+	int ret;
+
+	cFYI(1, "Registering the %s key type\n", cifs_idmap_key_type.name);
+
+	/* create an override credential set with a special thread keyring in
+	 * which DNS requests are cached
+	 *
+	 * this is used to prevent malicious redirections from being installed
+	 * with add_key().
+	 */
+	cred = prepare_kernel_cred(NULL);
+	if (!cred)
+		return -ENOMEM;
+
+	keyring = key_alloc(&key_type_keyring, ".cifs_idmap", 0, 0, cred,
+			    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
+			    KEY_USR_VIEW | KEY_USR_READ,
+			    KEY_ALLOC_NOT_IN_QUOTA);
+	if (IS_ERR(keyring)) {
+		ret = PTR_ERR(keyring);
+		goto failed_put_cred;
+	}
+
+	ret = key_instantiate_and_link(keyring, NULL, 0, NULL, NULL);
+	if (ret < 0)
+		goto failed_put_key;
+
+	ret = register_key_type(&cifs_idmap_key_type);
+	if (ret < 0)
+		goto failed_put_key;
+
+	/* instruct request_key() to use this special keyring as a cache for
+	 * the results it looks up */
+	cred->thread_keyring = keyring;
+	cred->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
+	root_cred = cred;
+
+	cFYI(1, "DNS resolver keyring: %d\n", key_serial(keyring));
+	return 0;
+
+failed_put_key:
+	key_put(keyring);
+failed_put_cred:
+	put_cred(cred);
+	return ret;
+}
+
+void
+exit_cifs_idmap(void)
+{
+	key_revoke(root_cred->thread_keyring);
+	unregister_key_type(&cifs_idmap_key_type);
+	put_cred(root_cred);
+	cFYI(1, "Unregistered %s key type\n", cifs_idmap_key_type.name);
+}
 
 int match_sid(struct cifs_sid *ctsid)
 {
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 6c26e7f..3851883 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -80,6 +80,11 @@ struct cifs_sid_id {
 	unsigned long id;
 } __attribute__((packed));
 
+#ifdef __KERNEL__
+extern struct key_type cifs_idmap_key_type;
+extern const struct cred *root_cred;
+#endif /* KERNEL */
+
 extern int match_sid(struct cifs_sid *);
 extern int compare_sids(const struct cifs_sid *, const struct cifs_sid *);
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 36182e3..08563cb 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1039,11 +1039,16 @@ init_cifs(void)
 	rc = register_key_type(&cifs_spnego_key_type);
 	if (rc)
 		goto out_unregister_filesystem;
+	rc = init_cifs_idmap();
+	if (rc)
+		goto out_unregister_keytype;
 #endif
 
 	return 0;
 
 #ifdef CONFIG_CIFS_UPCALL
+out_unregister_keytype:
+	unregister_key_type(&cifs_spnego_key_type);
 out_unregister_filesystem:
 	unregister_filesystem(&cifs_fs_type);
 #endif
@@ -1070,6 +1075,7 @@ exit_cifs(void)
 	cifs_dfs_release_automount_timer();
 #endif
 #ifdef CONFIG_CIFS_UPCALL
+	exit_cifs_idmap();
 	unregister_key_type(&cifs_spnego_key_type);
 #endif
 	unregister_filesystem(&cifs_fs_type);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 982895f..d311019 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -53,6 +53,8 @@ do {								\
 	cFYI(1, "CIFS VFS: leaving %s (xid = %d) rc = %d",	\
 	     __func__, curr_xid, (int)rc);			\
 } while (0)
+extern int init_cifs_idmap(void);
+extern void exit_cifs_idmap(void);
 extern char *build_path_from_dentry(struct dentry *);
 extern char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb,
 					struct cifsTconInfo *tcon);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 18d3c77..ac6f536 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3099,6 +3099,18 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
+	root = &cifs_sb->uidtree;
+	spin_lock(&cifs_sb->siduidlock);
+	while ((node = rb_first(root)))
+		rb_erase(node, root);
+	spin_unlock(&cifs_sb->siduidlock);
+
+	root = &cifs_sb->gidtree;
+	spin_lock(&cifs_sb->sidgidlock);
+	while ((node = rb_first(root)))
+		rb_erase(node, root);
+	spin_unlock(&cifs_sb->sidgidlock);
+
 	tmp = cifs_sb->prepath;
 	cifs_sb->prepathlen = 0;
 	cifs_sb->prepath = NULL;
-- 
1.6.0.2
