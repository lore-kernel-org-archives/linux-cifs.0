From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/4] CIFS: Simplify mount code for further shared sb capability
Date: Fri, 15 Apr 2011 11:01:54 +0400
Message-ID: <1302850916-13947-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reorganize code to get mount option at first and when get a superblock.
This lets us use shared superblock model further for equal mounts.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c    |   88 ++++++++++++++++++++++++++++++++------------------
 fs/cifs/cifsproto.h |    8 ++++-
 fs/cifs/connect.c   |   89 ++++++++++++++++++++++++++++----------------------
 3 files changed, 114 insertions(+), 71 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 9cfbfd2..3227db6 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -109,19 +109,16 @@ cifs_sb_deactive(struct super_block *sb)
 }
 
 static int
-cifs_read_super(struct super_block *sb, void *data,
-		const char *devname, int silent)
+cifs_read_super(struct super_block *sb, struct cifs_sb_info *cifs_sb,
+		void *data, struct smb_vol *volume_info, const char *devname,
+		int silent)
 {
 	struct inode *inode;
-	struct cifs_sb_info *cifs_sb;
 	int rc = 0;
 
 	/* BB should we make this contingent on mount parm? */
 	sb->s_flags |= MS_NODIRATIME | MS_NOATIME;
-	sb->s_fs_info = kzalloc(sizeof(struct cifs_sb_info), GFP_KERNEL);
-	cifs_sb = CIFS_SB(sb);
-	if (cifs_sb == NULL)
-		return -ENOMEM;
+	sb->s_fs_info = cifs_sb;
 
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
 	cifs_sb->tlink_tree = RB_ROOT;
@@ -133,22 +130,10 @@ cifs_read_super(struct super_block *sb, void *data,
 	}
 	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
 
-	/*
-	 * Copy mount params to sb for use in submounts. Better to do
-	 * the copy here and deal with the error before cleanup gets
-	 * complicated post-mount.
-	 */
-	if (data) {
-		cifs_sb->mountdata = kstrndup(data, PAGE_SIZE, GFP_KERNEL);
-		if (cifs_sb->mountdata == NULL) {
-			bdi_destroy(&cifs_sb->bdi);
-			kfree(sb->s_fs_info);
-			sb->s_fs_info = NULL;
-			return -ENOMEM;
-		}
-	}
+	if (data)
+		cifs_sb->mountdata = data;
 
-	rc = cifs_mount(sb, cifs_sb, devname);
+	rc = cifs_mount(sb, cifs_sb, volume_info, devname);
 
 	if (rc) {
 		if (!silent)
@@ -566,27 +551,68 @@ static const struct super_operations cifs_super_ops = {
 
 static struct dentry *
 cifs_do_mount(struct file_system_type *fs_type,
-	    int flags, const char *dev_name, void *data)
+	      int flags, const char *dev_name, void *data)
 {
 	int rc;
 	struct super_block *sb;
-
-	sb = sget(fs_type, NULL, set_anon_super, NULL);
+	struct cifs_sb_info *cifs_sb;
+	struct smb_vol *volume_info;
+	struct dentry *root;
+	char *copied_data = NULL;
 
 	cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
 
-	if (IS_ERR(sb))
-		return ERR_CAST(sb);
+	rc = cifs_setup_volume_info(&volume_info, (char *)data, dev_name);
+	if (rc)
+		return ERR_PTR(rc);
+
+	cifs_sb = kzalloc(sizeof(struct cifs_sb_info), GFP_KERNEL);
+	if (cifs_sb == NULL) {
+		root = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	cifs_setup_cifs_sb(volume_info, cifs_sb);
+
+	sb = sget(fs_type, NULL, set_anon_super, NULL);
+	if (IS_ERR(sb)) {
+		kfree(cifs_sb);
+		root = ERR_CAST(sb);
+		goto out;
+	}
 
 	sb->s_flags = flags;
 
-	rc = cifs_read_super(sb, data, dev_name, flags & MS_SILENT ? 1 : 0);
+	/*
+	 * Copy mount params for use in submounts. Better to do
+	 * the copy here and deal with the error before cleanup gets
+	 * complicated post-mount.
+	 */
+	copied_data = kstrndup(data, PAGE_SIZE, GFP_KERNEL);
+	if (copied_data == NULL) {
+		root = ERR_PTR(-ENOMEM);
+		goto err_out;
+	}
+
+	rc = cifs_read_super(sb, cifs_sb, copied_data, volume_info, dev_name,
+			     flags & MS_SILENT ? 1 : 0);
 	if (rc) {
-		deactivate_locked_super(sb);
-		return ERR_PTR(rc);
+		root = ERR_PTR(rc);
+		goto err_out;
 	}
+
 	sb->s_flags |= MS_ACTIVE;
-	return dget(sb->s_root);
+
+	root = dget(sb->s_root);
+out:
+	cifs_cleanup_volume_info(&volume_info);
+	return root;
+
+err_out:
+	kfree(cifs_sb);
+	deactivate_locked_super(sb);
+	cifs_cleanup_volume_info(&volume_info);
+	return root;
 }
 
 static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 9985f99..ffd16c8 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -146,8 +146,14 @@ extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
 extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
 				const char *);
 
+extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
+			       struct cifs_sb_info *cifs_sb);
+extern int cifs_match_super(struct super_block *, void *);
+extern void cifs_cleanup_volume_info(struct smb_vol **pvolume_info);
+extern int cifs_setup_volume_info(struct smb_vol **pvolume_info,
+				  char *mount_data, const char *devname);
 extern int cifs_mount(struct super_block *, struct cifs_sb_info *,
-			const char *);
+		      struct smb_vol *, const char *);
 extern int cifs_umount(struct super_block *, struct cifs_sb_info *);
 extern void cifs_dfs_release_automount_timer(void);
 void cifs_proc_init(void);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 990c3e0..0b41f75 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2626,8 +2626,8 @@ convert_delimiter(char *path, char delim)
 	}
 }
 
-static void setup_cifs_sb(struct smb_vol *pvolume_info,
-			  struct cifs_sb_info *cifs_sb)
+void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
+			struct cifs_sb_info *cifs_sb)
 {
 	INIT_DELAYED_WORK(&cifs_sb->prune_tlinks, cifs_prune_tlinks);
 
@@ -2683,6 +2683,7 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
 
 	cifs_sb->actimeo = pvolume_info->actimeo;
+	cifs_sb->local_nls = pvolume_info->local_nls;
 
 	if (pvolume_info->noperm)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
@@ -2754,8 +2755,8 @@ is_path_accessible(int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-static void
-cleanup_volume_info(struct smb_vol **pvolume_info)
+void
+cifs_cleanup_volume_info(struct smb_vol **pvolume_info)
 {
 	struct smb_vol *volume_info;
 
@@ -2861,40 +2862,13 @@ expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
 }
 #endif
 
-int
-cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
-		const char *devname)
+int cifs_setup_volume_info(struct smb_vol **pvolume_info, char *mount_data,
+			   const char *devname)
 {
-	int rc;
-	int xid;
 	struct smb_vol *volume_info;
-	struct cifs_ses *pSesInfo;
-	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *srvTcp;
-	char   *full_path;
-	struct tcon_link *tlink;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	int referral_walks_count = 0;
-try_mount_again:
-	/* cleanup activities if we're chasing a referral */
-	if (referral_walks_count) {
-		if (tcon)
-			cifs_put_tcon(tcon);
-		else if (pSesInfo)
-			cifs_put_smb_ses(pSesInfo);
-
-		cleanup_volume_info(&volume_info);
-		FreeXid(xid);
-	}
-#endif
-	rc = 0;
-	tcon = NULL;
-	pSesInfo = NULL;
-	srvTcp = NULL;
-	full_path = NULL;
-	tlink = NULL;
+	int rc = 0;
 
-	xid = GetXid();
+	*pvolume_info = NULL;
 
 	volume_info = kzalloc(sizeof(struct smb_vol), GFP_KERNEL);
 	if (!volume_info) {
@@ -2902,7 +2876,7 @@ try_mount_again:
 		goto out;
 	}
 
-	if (cifs_parse_mount_options(cifs_sb->mountdata, devname,
+	if (cifs_parse_mount_options(mount_data, devname,
 				     volume_info)) {
 		rc = -EINVAL;
 		goto out;
@@ -2935,7 +2909,46 @@ try_mount_again:
 			goto out;
 		}
 	}
-	cifs_sb->local_nls = volume_info->local_nls;
+
+	*pvolume_info = volume_info;
+	return rc;
+out:
+	cifs_cleanup_volume_info(&volume_info);
+	return rc;
+}
+
+int
+cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
+	   struct smb_vol *volume_info, const char *devname)
+{
+	int rc = 0;
+	int xid;
+	struct cifs_ses *pSesInfo;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *srvTcp;
+	char   *full_path;
+	struct tcon_link *tlink;
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	int referral_walks_count = 0;
+try_mount_again:
+	/* cleanup activities if we're chasing a referral */
+	if (referral_walks_count) {
+		if (tcon)
+			cifs_put_tcon(tcon);
+		else if (pSesInfo)
+			cifs_put_smb_ses(pSesInfo);
+
+		cifs_cleanup_volume_info(&volume_info);
+		FreeXid(xid);
+	}
+#endif
+	tcon = NULL;
+	pSesInfo = NULL;
+	srvTcp = NULL;
+	full_path = NULL;
+	tlink = NULL;
+
+	xid = GetXid();
 
 	/* get a reference to a tcp session */
 	srvTcp = cifs_get_tcp_session(volume_info);
@@ -2952,7 +2965,6 @@ try_mount_again:
 		goto mount_fail_check;
 	}
 
-	setup_cifs_sb(volume_info, cifs_sb);
 	if (pSesInfo->capabilities & CAP_LARGE_FILES)
 		sb->s_maxbytes = MAX_LFS_FILESIZE;
 	else
@@ -3108,7 +3120,6 @@ mount_fail_check:
 	password will be freed at unmount time) */
 out:
 	/* zero out password before freeing */
-	cleanup_volume_info(&volume_info);
 	FreeXid(xid);
 	return rc;
 }
-- 
1.7.1
