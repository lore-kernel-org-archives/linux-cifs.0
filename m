From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: Create dedicated keyring for spnego operations
Date: Fri, 22 Apr 2016 15:58:33 -0400
Message-ID: <1461355113-30510-1-git-send-email-sprabhu@redhat.com>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Scott Mayhew <smayhew-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The session key is the default keyring set for request_key operations.
This session key is revoked when the user owning the session logs out.
Any long running daemon processes started by this session ends up with
revoked session keyring which prevents these processes from using the
request_key mechanism from obtaining the krb5 keys.

The problem has been reported by a large number of autofs users. The
problem is also seen with multiuser mounts where the share may be used
by processes run by a user who has since logged out. A reproducer using
automount is available on the Red Hat bz.

The patch creates a new keyring which is used to cache cifs spnego
upcalls.

Red Hat bz: 1267754

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Scott Mayhew <smayhew-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_spnego.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsfs.c      |  4 +--
 fs/cifs/cifsproto.h   |  2 ++
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 6908080..248ab43 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -24,11 +24,14 @@
 #include <linux/string.h>
 #include <keys/user-type.h>
 #include <linux/key-type.h>
+#include <linux/keyctl.h>
 #include <linux/inet.h>
 #include "cifsglob.h"
 #include "cifs_spnego.h"
 #include "cifs_debug.h"
 
+static const struct cred *spnego_cred;
+
 /* create a new cifs key */
 static int
 cifs_spnego_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
@@ -102,6 +105,7 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
 	size_t desc_len;
 	struct key *spnego_key;
 	const char *hostname = server->hostname;
+	const struct cred *saved_cred;
 
 	/* length of fields (with semicolons): ver=0xyz ip4=ipaddress
 	   host=hostname sec=mechanism uid=0xFF user=username */
@@ -163,7 +167,9 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
 	sprintf(dp, ";pid=0x%x", current->pid);
 
 	cifs_dbg(FYI, "key description = %s\n", description);
+	saved_cred = override_creds(spnego_cred);
 	spnego_key = request_key(&cifs_spnego_key_type, description, "");
+	revert_creds(saved_cred);
 
 #ifdef CONFIG_CIFS_DEBUG2
 	if (cifsFYI && !IS_ERR(spnego_key)) {
@@ -177,3 +183,64 @@ out:
 	kfree(description);
 	return spnego_key;
 }
+
+int
+init_cifs_spnego(void)
+{
+	struct cred *cred;
+	struct key *keyring;
+	int ret;
+
+	cifs_dbg(FYI, "Registering the %s key type\n",
+		 cifs_spnego_key_type.name);
+
+	/*
+	 * Create an override credential set with special thread keyring for
+	 * spnego upcalls.
+	 */
+
+	cred = prepare_kernel_cred(NULL);
+	if (!cred)
+		return -ENOMEM;
+
+	keyring = keyring_alloc(".cifs_spnego",
+				GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
+				(KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				KEY_USR_VIEW | KEY_USR_READ,
+				KEY_ALLOC_NOT_IN_QUOTA, NULL);
+	if (IS_ERR(keyring)) {
+		ret = PTR_ERR(keyring);
+		goto failed_put_cred;
+	}
+
+	ret = register_key_type(&cifs_spnego_key_type);
+	if (ret < 0)
+		goto failed_put_key;
+
+	/*
+	 * instruct request_key() to use this special keyring as a cache for
+	 * the results it looks up
+	 */
+	set_bit(KEY_FLAG_ROOT_CAN_CLEAR, &keyring->flags);
+	cred->thread_keyring = keyring;
+	cred->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
+	spnego_cred = cred;
+
+	cifs_dbg(FYI, "cifs spnego keyring: %d\n", key_serial(keyring));
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
+exit_cifs_spnego(void)
+{
+	key_revoke(spnego_cred->thread_keyring);
+	unregister_key_type(&cifs_spnego_key_type);
+	put_cred(spnego_cred);
+	cifs_dbg(FYI, "Unregistered %s key type\n", cifs_spnego_key_type.name);
+}
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8920156..9852044 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1307,7 +1307,7 @@ init_cifs(void)
 		goto out_destroy_mids;
 
 #ifdef CONFIG_CIFS_UPCALL
-	rc = register_key_type(&cifs_spnego_key_type);
+	rc = init_cifs_spnego();
 	if (rc)
 		goto out_destroy_request_bufs;
 #endif /* CONFIG_CIFS_UPCALL */
@@ -1330,7 +1330,7 @@ out_init_cifs_idmap:
 out_register_key_type:
 #endif
 #ifdef CONFIG_CIFS_UPCALL
-	unregister_key_type(&cifs_spnego_key_type);
+	exit_cifs_spnego();
 out_destroy_request_bufs:
 #endif
 	cifs_destroy_request_bufs();
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index eed7ff5..ca618b0 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -60,6 +60,8 @@ do {								\
 } while (0)
 extern int init_cifs_idmap(void);
 extern void exit_cifs_idmap(void);
+extern int init_cifs_spnego(void);
+extern int exit_cifs_spnego(void);
 extern char *build_path_from_dentry(struct dentry *);
 extern char *cifs_build_path_to_root(struct smb_vol *vol,
 				     struct cifs_sb_info *cifs_sb,
-- 
2.5.5
