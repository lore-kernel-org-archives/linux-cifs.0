From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: [PATCH v4 6/6] cifs: Unconditionally copy mount options to superblock info
Date: Wed, 6 Apr 2011 16:26:45 +0200
Message-ID: <1302100005-1848-6-git-send-email-seanius@seanius.net>
References: <1302100005-1848-1-git-send-email-seanius@seanius.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302100005-1848-1-git-send-email-seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Previously mount options were copied and updated in the cifs_sb_info
struct only when CONFIG_CIFS_DFS_UPCALL was enabled.  Making this
information generally available allows us to remove a number of ifdefs,
extra function params, and temporary variables.

Signed-off-by: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    4 +---
 fs/cifs/cifsfs.c     |    8 +-------
 fs/cifs/cifsproto.h  |    2 +-
 fs/cifs/connect.c    |    8 +++-----
 4 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 1ef54ab..adecd36 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -60,9 +60,7 @@ struct cifs_sb_info {
 	unsigned int mnt_cifs_flags;
 	int	prepathlen;
 	char   *prepath; /* relative path under the share to mount to */
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	char   *mountdata; /* mount options received at mount time */
-#endif
+	char   *mountdata; /* options received at mount time or via DFS refs */
 	struct backing_dev_info bdi;
 	struct delayed_work prune_tlinks;
 };
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index cf8a610..c89a699 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -133,7 +133,6 @@ cifs_read_super(struct super_block *sb, void *data,
 	}
 	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
 
-#ifdef CONFIG_CIFS_DFS_UPCALL
 	/*
 	 * Copy mount params to sb for use in submounts. Better to do
 	 * the copy here and deal with the error before cleanup gets
@@ -149,9 +148,8 @@ cifs_read_super(struct super_block *sb, void *data,
 			return -ENOMEM;
 		}
 	}
-#endif
 
-	rc = cifs_mount(sb, cifs_sb, data, devname);
+	rc = cifs_mount(sb, cifs_sb, devname);
 
 	if (rc) {
 		if (!silent)
@@ -203,12 +201,10 @@ out_no_root:
 
 out_mount_failed:
 	if (cifs_sb) {
-#ifdef CONFIG_CIFS_DFS_UPCALL
 		if (cifs_sb->mountdata) {
 			kfree(cifs_sb->mountdata);
 			cifs_sb->mountdata = NULL;
 		}
-#endif
 		unload_nls(cifs_sb->local_nls);
 		bdi_destroy(&cifs_sb->bdi);
 		kfree(cifs_sb);
@@ -232,12 +228,10 @@ cifs_put_super(struct super_block *sb)
 	rc = cifs_umount(sb, cifs_sb);
 	if (rc)
 		cERROR(1, "cifs_umount failed with return code %d", rc);
-#ifdef CONFIG_CIFS_DFS_UPCALL
 	if (cifs_sb->mountdata) {
 		kfree(cifs_sb->mountdata);
 		cifs_sb->mountdata = NULL;
 	}
-#endif
 
 	unload_nls(cifs_sb->local_nls);
 	bdi_destroy(&cifs_sb->bdi);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 76c4dc7f..9985f99 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -146,7 +146,7 @@ extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
 extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
 				const char *);
 
-extern int cifs_mount(struct super_block *, struct cifs_sb_info *, char *,
+extern int cifs_mount(struct super_block *, struct cifs_sb_info *,
 			const char *);
 extern int cifs_umount(struct super_block *, struct cifs_sb_info *);
 extern void cifs_dfs_release_automount_timer(void);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8d2529c..3ab54a0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2839,7 +2839,7 @@ expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
 
 int
 cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
-		char *mount_data_global, const char *devname)
+		const char *devname)
 {
 	int rc;
 	int xid;
@@ -2848,13 +2848,10 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *srvTcp;
 	char   *full_path;
-	char *mount_data = mount_data_global;
 	struct tcon_link *tlink;
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	int referral_walks_count = 0;
 try_mount_again:
-	mount_data = cifs_sb->mountdata;
-
 	/* cleanup activities if we're chasing a referral */
 	if (referral_walks_count) {
 		if (tcon)
@@ -2881,7 +2878,8 @@ try_mount_again:
 		goto out;
 	}
 
-	if (cifs_parse_mount_options(mount_data, devname, volume_info)) {
+	if (cifs_parse_mount_options(cifs_sb->mountdata, devname,
+				     volume_info)) {
 		rc = -EINVAL;
 		goto out;
 	}
-- 
1.7.4.1
