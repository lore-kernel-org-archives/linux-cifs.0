From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/15] cifs: add routines to build sessions and tcons on the fly
Date: Mon, 20 Sep 2010 16:01:41 -0700
Message-ID: <1285023704-2159-13-git-send-email-jlayton@redhat.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285023704-2159-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch is rather large, but it's a bit difficult to do piecemeal...

For non-multiuser mounts, everything will basically work as it does
today. A call to cifs_sb_tlink will return the "master" tcon link.

Turn the tcon pointer in the cifs_sb into a radix tree that uses the
fsuid of the process as a key. The value is a new "tcon_link" struct
that contains info about a tcon that's under construction.

When a new process needs a tcon, it'll call cifs_sb_tcon. That will
then look up the tcon_link in the radix tree. If it exists and is
valid, it's returned.

If it doesn't exist, then we stuff a new tcon_link into the tree and
mark it as pending and then go and try to build the session/tcon.
If that works, the tcon pointer in the tcon_link is updated and the
pending flag is cleared.

If the construction fails, then we set the tcon pointer to an ERR_PTR
and clear the pending flag.

If the radix tree is searched and the tcon_link is marked pending
then we go to sleep and wait for the pending flag to be cleared.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    7 +-
 fs/cifs/cifsglob.h   |   32 +++----
 fs/cifs/connect.c    |  270 ++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 281 insertions(+), 28 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index e04e692..ae027c2 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -15,6 +15,8 @@
  *   the GNU Lesser General Public License for more details.
  *
  */
+#include <linux/radix-tree.h>
+
 #ifndef _CIFS_FS_SB_H
 #define _CIFS_FS_SB_H
 
@@ -40,8 +42,9 @@
 #define CIFS_MOUNT_MULTIUSER	0x20000 /* multiuser mount */
 
 struct cifs_sb_info {
-	struct cifsTconInfo *ptcon;	/* primary mount */
-	struct list_head nested_tcon_q;
+	struct radix_tree_root tlink_tree;
+#define CIFS_TLINK_MASTER_TAG		0	/* tcon is "master" (mount) tcon */
+	spinlock_t tlink_tree_lock;
 	struct nls_table *local_nls;
 	unsigned int rsize;
 	unsigned int wsize;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0f27584..6420247 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -345,33 +345,31 @@ struct cifsTconInfo {
  * "get" on the container.
  */
 struct tcon_link {
-	spinlock_t		tl_lock;
-	u32			tl_count;
-	u64			tl_time;
+	unsigned long		tl_index;
+	unsigned long		tl_flags;
+#define TCON_LINK_MASTER	0
+#define TCON_LINK_PENDING	1
+#define TCON_LINK_IN_TREE	2
+	unsigned long		tl_time;
+	atomic_t		tl_count;
 	struct cifsTconInfo	*tl_tcon;
 };
 
-static inline struct tcon_link *
-cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
-{
-	return (struct tcon_link *)cifs_sb->ptcon;
-}
+extern struct tcon_link *cifs_sb_tlink(struct cifs_sb_info *cifs_sb);
 
 static inline struct cifsTconInfo *
 tlink_tcon(struct tcon_link *tlink)
 {
-	return (struct cifsTconInfo *)tlink;
+	return tlink->tl_tcon;
 }
 
-static inline void
-cifs_put_tlink(struct tcon_link *tlink)
-{
-	return;
-}
+extern void cifs_put_tlink(struct tcon_link *tlink);
 
 static inline struct tcon_link *
 cifs_get_tlink(struct tcon_link *tlink)
 {
+	if (tlink && !IS_ERR(tlink))
+		atomic_inc(&tlink->tl_count);
 	return tlink;
 }
 
@@ -481,11 +479,7 @@ CIFS_SB(struct super_block *sb)
 }
 
 /* This function is always expected to succeed */
-static inline struct cifsTconInfo *
-cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb)
-{
-	return cifs_sb->ptcon;
-}
+extern struct cifsTconInfo *cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb);
 
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7a6ec04..3e2b069 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -110,6 +110,9 @@ struct smb_vol {
 	struct nls_table *local_nls;
 };
 
+#define TLINK_ERROR_EXPIRE	(1 * HZ)
+
+
 static int ipv4_connect(struct TCP_Server_Info *server);
 static int ipv6_connect(struct TCP_Server_Info *server);
 
@@ -1981,6 +1984,23 @@ out_fail:
 	return ERR_PTR(rc);
 }
 
+void
+cifs_put_tlink(struct tcon_link *tlink)
+{
+	if (!tlink || IS_ERR(tlink))
+		return;
+
+	if (!atomic_dec_and_test(&tlink->tl_count) ||
+	    test_bit(TCON_LINK_IN_TREE, &tlink->tl_flags)) {
+		tlink->tl_time = jiffies;
+		return;
+	}
+
+	if (!IS_ERR(tlink_tcon(tlink)))
+		cifs_put_tcon(tlink_tcon(tlink));
+	kfree(tlink);
+	return;
+}
 
 int
 get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *old_path,
@@ -2663,6 +2683,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 	struct TCP_Server_Info *srvTcp;
 	char   *full_path;
 	char *mount_data = mount_data_global;
+	struct tcon_link *tlink;
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	struct dfs_info3_param *referrals = NULL;
 	unsigned int num_referrals = 0;
@@ -2674,6 +2695,7 @@ try_mount_again:
 	pSesInfo = NULL;
 	srvTcp = NULL;
 	full_path = NULL;
+	tlink = NULL;
 
 	xid = GetXid();
 
@@ -2749,8 +2771,6 @@ try_mount_again:
 		goto remote_path_check;
 	}
 
-	cifs_sb->ptcon = tcon;
-
 	/* do not care if following two calls succeed - informational */
 	if (!tcon->ipc) {
 		CIFSSMBQFSDeviceInfo(xid, tcon);
@@ -2859,6 +2879,35 @@ remote_path_check:
 #endif
 	}
 
+	if (rc)
+		goto mount_fail_check;
+
+	/* now, hang the tcon off of the superblock */
+	tlink = kzalloc(sizeof *tlink, GFP_KERNEL);
+	if (tlink == NULL) {
+		rc = -ENOMEM;
+		goto mount_fail_check;
+	}
+
+	tlink->tl_index = pSesInfo->linux_uid;
+	tlink->tl_tcon = tcon;
+	tlink->tl_time = jiffies;
+	set_bit(TCON_LINK_MASTER, &tlink->tl_flags);
+	set_bit(TCON_LINK_IN_TREE, &tlink->tl_flags);
+
+	rc = radix_tree_preload(GFP_KERNEL);
+	if (rc == -ENOMEM) {
+		kfree(tlink);
+		goto mount_fail_check;
+	}
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	radix_tree_insert(&cifs_sb->tlink_tree, pSesInfo->linux_uid, tlink);
+	radix_tree_tag_set(&cifs_sb->tlink_tree, pSesInfo->linux_uid,
+			   CIFS_TLINK_MASTER_TAG);
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+	radix_tree_preload_end();
+
 mount_fail_check:
 	/* on error free sesinfo and tcon struct if needed */
 	if (rc) {
@@ -3045,19 +3094,34 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 int
 cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 {
-	int rc = 0;
+	int i, ret;
 	char *tmp;
-	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct tcon_link *tlink[8];
+	unsigned long index = 0;
+
+	do {
+		spin_lock(&cifs_sb->tlink_tree_lock);
+		ret = radix_tree_gang_lookup(&cifs_sb->tlink_tree,
+					     (void **)tlink, index,
+					     ARRAY_SIZE(tlink));
+		for (i = 0; i < ret; i++) {
+			cifs_get_tlink(tlink[i]);
+			clear_bit(TCON_LINK_IN_TREE, &tlink[i]->tl_flags);
+			radix_tree_delete(&cifs_sb->tlink_tree,
+							tlink[i]->tl_index);
+		}
+		spin_unlock(&cifs_sb->tlink_tree_lock);
 
-	cifs_put_tcon(tcon);
+		for (i = 0; i < ret; i++)
+			cifs_put_tlink(tlink[i]);
+	} while (ret != 0);
 
-	cifs_sb->ptcon = NULL;
 	tmp = cifs_sb->prepath;
 	cifs_sb->prepathlen = 0;
 	cifs_sb->prepath = NULL;
 	kfree(tmp);
 
-	return rc;
+	return 0;
 }
 
 int cifs_negotiate_protocol(unsigned int xid, struct cifsSesInfo *ses)
@@ -3118,3 +3182,195 @@ int cifs_setup_session(unsigned int xid, struct cifsSesInfo *ses,
 	return rc;
 }
 
+struct cifsTconInfo *
+cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
+{
+	struct cifsTconInfo *master_tcon = cifs_sb_master_tcon(cifs_sb);
+	struct cifsSesInfo *ses;
+	struct cifsTconInfo *tcon = NULL;
+	struct smb_vol *vol_info;
+
+	vol_info = kzalloc(sizeof(*vol_info), GFP_KERNEL);
+	if (vol_info == NULL) {
+		tcon = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	vol_info->username = kzalloc(MAX_USERNAME_SIZE + 1, GFP_KERNEL);
+	if (vol_info->username == NULL) {
+		tcon = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	snprintf(vol_info->username, MAX_USERNAME_SIZE, "krb50x%x", fsuid);
+	vol_info->local_nls = cifs_sb->local_nls;
+	vol_info->linux_uid = fsuid;
+	vol_info->cred_uid = fsuid;
+	vol_info->UNC = master_tcon->treeName;
+	vol_info->retry = master_tcon->retry;
+	vol_info->nocase = master_tcon->nocase;
+	vol_info->local_lease = master_tcon->local_lease;
+	vol_info->no_linux_ext = !master_tcon->unix_ext;
+
+	/* FIXME: allow for other secFlg settings */
+	vol_info->secFlg = CIFSSEC_MUST_KRB5;
+
+	/* get a reference for the same TCP session */
+	write_lock(&cifs_tcp_ses_lock);
+	++master_tcon->ses->server->srv_count;
+	write_unlock(&cifs_tcp_ses_lock);
+
+	ses = cifs_get_smb_ses(master_tcon->ses->server, vol_info);
+	if (IS_ERR(ses)) {
+		tcon = (struct cifsTconInfo *) ses;
+		cifs_put_tcp_session(master_tcon->ses->server);
+		goto out;
+	}
+
+	tcon = cifs_get_tcon(ses, vol_info);
+	if (IS_ERR(tcon)) {
+		cifs_put_smb_ses(ses);
+		goto out;
+	}
+
+	if (ses->capabilities & CAP_UNIX)
+		reset_cifs_unix_caps(0, tcon, NULL, vol_info);
+out:
+	kfree(vol_info->username);
+	kfree(vol_info);
+
+	return tcon;
+}
+
+static struct tcon_link *
+cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb)
+{
+	struct tcon_link *tlink;
+	unsigned int ret;
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	ret = radix_tree_gang_lookup_tag(&cifs_sb->tlink_tree, (void **)&tlink,
+					0, 1, CIFS_TLINK_MASTER_TAG);
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	/* the master tcon should always be present */
+	if (ret == 0)
+		BUG();
+
+	return tlink;
+}
+
+struct cifsTconInfo *
+cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb)
+{
+	return tlink_tcon(cifs_sb_master_tlink(cifs_sb));
+}
+
+static int
+cifs_sb_tcon_pending_wait(void *unused)
+{
+	schedule();
+	return signal_pending(current) ? -ERESTARTSYS : 0;
+}
+
+/*
+ * Find or construct an appropriate tcon given a cifs_sb and the fsuid of the
+ * current task.
+ *
+ * If the superblock doesn't refer to a multiuser mount, then just return
+ * the master tcon for the mount.
+ *
+ * First, search the radix tree for an existing tcon for this fsuid. If one
+ * exists, then check to see if it's pending construction. If it is then wait
+ * for construction to complete. Once it's no longer pending, check to see if
+ * it failed and either return an error or retry construction, depending on
+ * the timeout.
+ *
+ * If one doesn't exist then insert a new tcon_link struct into the tree and
+ * try to construct a new one.
+ */
+struct tcon_link *
+cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
+{
+	int ret;
+	unsigned long fsuid = (unsigned long) current_fsuid();
+	struct tcon_link *tlink, *newtlink;
+
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+		return cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	tlink = radix_tree_lookup(&cifs_sb->tlink_tree, fsuid);
+	if (tlink)
+		cifs_get_tlink(tlink);
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	if (tlink == NULL) {
+		newtlink = kzalloc(sizeof(*tlink), GFP_KERNEL);
+		if (newtlink == NULL)
+			return ERR_PTR(-ENOMEM);
+		newtlink->tl_index = fsuid;
+		newtlink->tl_tcon = ERR_PTR(-EACCES);
+		set_bit(TCON_LINK_PENDING, &newtlink->tl_flags);
+		set_bit(TCON_LINK_IN_TREE, &newtlink->tl_flags);
+		cifs_get_tlink(newtlink);
+
+		ret = radix_tree_preload(GFP_KERNEL);
+		if (ret != 0) {
+			kfree(newtlink);
+			return ERR_PTR(ret);
+		}
+
+		spin_lock(&cifs_sb->tlink_tree_lock);
+		/* was one inserted after previous search? */
+		tlink = radix_tree_lookup(&cifs_sb->tlink_tree, fsuid);
+		if (tlink) {
+			cifs_get_tlink(tlink);
+			spin_unlock(&cifs_sb->tlink_tree_lock);
+			radix_tree_preload_end();
+			kfree(newtlink);
+			goto wait_for_construction;
+		}
+		ret = radix_tree_insert(&cifs_sb->tlink_tree, fsuid, newtlink);
+		spin_unlock(&cifs_sb->tlink_tree_lock);
+		radix_tree_preload_end();
+		if (ret) {
+			kfree(newtlink);
+			return ERR_PTR(ret);
+		}
+		tlink = newtlink;
+	} else {
+wait_for_construction:
+		ret = wait_on_bit(&tlink->tl_flags, TCON_LINK_PENDING,
+				  cifs_sb_tcon_pending_wait,
+				  TASK_INTERRUPTIBLE);
+		if (ret) {
+			cifs_put_tlink(tlink);
+			return ERR_PTR(ret);
+		}
+
+		/* if it's good, return it */
+		if (!IS_ERR(tlink->tl_tcon))
+			return tlink;
+
+		/* return error if we tried this already recently */
+		if (time_before(jiffies, tlink->tl_time + TLINK_ERROR_EXPIRE)) {
+			cifs_put_tlink(tlink);
+			return ERR_PTR(-EACCES);
+		}
+
+		if (test_and_set_bit(TCON_LINK_PENDING, &tlink->tl_flags))
+			goto wait_for_construction;
+	}
+
+	tlink->tl_tcon = cifs_construct_tcon(cifs_sb, fsuid);
+	clear_bit(TCON_LINK_PENDING, &tlink->tl_flags);
+	wake_up_bit(&tlink->tl_flags, TCON_LINK_PENDING);
+
+	if (IS_ERR(tlink->tl_tcon)) {
+		cifs_put_tlink(tlink);
+		return ERR_PTR(-EACCES);
+	}
+
+	return tlink;
+}
-- 
1.7.2.3
