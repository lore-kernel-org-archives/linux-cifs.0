From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] cifs: Add idmap key and related data structures and functions (try #17)
Date: Thu, 21 Apr 2011 09:15:40 -0500
Message-ID: <1303395340-26664-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Define (global) data structures to store ids, uids and gids, to which a
SID maps.  There are two separate trees, one for SID/uid and another one
for SID/gid.

A new type of key, cifs_idmap_key_type, is used.

Keys are instantiated and searched using credential of the root by
overriding and restoring the credentials of the caller requesting the key.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c   |  138 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsfs.c    |    7 +++
 fs/cifs/cifsglob.h  |    5 ++
 fs/cifs/cifsproto.h |    3 +
 4 files changed, 153 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index a0d11ea..061fc3a 100644
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
@@ -50,6 +54,140 @@ static const struct cifs_sid sid_authusers = {
 /* group users */
 static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
 
+static const struct cred *root_cred;
+
+/*
+ * Run idmap cache shrinker.
+ */
+static int
+cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
+{
+	/* Use a pruning scheme in a subsequent patch instead */
+	cifs_destroy_idmaptrees();
+	return 0;
+}
+
+static struct shrinker cifs_shrinker = {
+	.shrink = cifs_idmap_shrinker,
+	.seeks = DEFAULT_SEEKS,
+};
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
+static
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
+	 * which requests are cached
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
+	spin_lock_init(&siduidlock);
+	uidtree = RB_ROOT;
+	spin_lock_init(&sidgidlock);
+	gidtree = RB_ROOT;
+
+	register_shrinker(&cifs_shrinker);
+
+	cFYI(1, "cifs idmap keyring: %d\n", key_serial(keyring));
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
+	unregister_shrinker(&cifs_shrinker);
+	cFYI(1, "Unregistered %s key type\n", cifs_idmap_key_type.name);
+}
+
+void
+cifs_destroy_idmaptrees(void)
+{
+	struct rb_root *root;
+	struct rb_node *node;
+
+	root = &uidtree;
+	spin_lock(&siduidlock);
+	while ((node = rb_first(root)))
+		rb_erase(node, root);
+	spin_unlock(&siduidlock);
+
+	root = &gidtree;
+	spin_lock(&sidgidlock);
+	while ((node = rb_first(root)))
+		rb_erase(node, root);
+	spin_unlock(&sidgidlock);
+}
 
 int match_sid(struct cifs_sid *ctsid)
 {
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 30fc505..665bf1d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1040,11 +1040,16 @@ init_cifs(void)
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
@@ -1071,6 +1076,8 @@ exit_cifs(void)
 	cifs_dfs_release_automount_timer();
 #endif
 #ifdef CONFIG_CIFS_UPCALL
+	cifs_destroy_idmaptrees();
+	exit_cifs_idmap();
 	unregister_key_type(&cifs_spnego_key_type);
 #endif
 	unregister_filesystem(&cifs_fs_type);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 108a1e9..76b4517 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -833,6 +833,11 @@ GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
 /* reconnect after this many failed echo attempts */
 GLOBAL_EXTERN unsigned short echo_retries;
 
+GLOBAL_EXTERN struct rb_root uidtree;
+GLOBAL_EXTERN struct rb_root gidtree;
+GLOBAL_EXTERN spinlock_t siduidlock;
+GLOBAL_EXTERN spinlock_t sidgidlock;
+
 void cifs_oplock_break(struct work_struct *work);
 void cifs_oplock_break_get(struct cifsFileInfo *cfile);
 void cifs_oplock_break_put(struct cifsFileInfo *cfile);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 0e4e057..7c1ed01 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -53,6 +53,9 @@ do {								\
 	cFYI(1, "CIFS VFS: leaving %s (xid = %d) rc = %d",	\
 	     __func__, curr_xid, (int)rc);			\
 } while (0)
+extern int init_cifs_idmap(void);
+extern void exit_cifs_idmap(void);
+extern void cifs_destroy_idmaptrees(void);
 extern char *build_path_from_dentry(struct dentry *);
 extern char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb,
 					struct cifsTconInfo *tcon);
-- 
1.6.0.2
