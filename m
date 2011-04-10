From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/3] CIFS: Simplify mount code for further shared sb capability
Date: Sun, 10 Apr 2011 14:05:53 +0400
Message-ID: <1302429954-9927-2-git-send-email-piastry@etersoft.ru>
References: <1302429954-9927-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302429954-9927-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reorganize code to get mount option at first and when get a superblock.
This lets us use shared superblock model further for equal mounts.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c    |   53 ++++++++++++++++++++------------
 fs/cifs/cifsproto.h |    6 +++-
 fs/cifs/connect.c   |   83 +++++++++++++++++++++++++++++---------------------
 3 files changed, 86 insertions(+), 56 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c89a699..c40c1f4 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -109,7 +109,7 @@ cifs_sb_deactive(struct super_block *sb)
 }
 
 static int
-cifs_read_super(struct super_block *sb, void *data,
+cifs_read_super(struct super_block *sb, void *data, struct smb_vol *volume_info,
 		const char *devname, int silent)
 {
 	struct inode *inode;
@@ -133,23 +133,10 @@ cifs_read_super(struct super_block *sb, void *data,
 	}
 	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
 
-	/*
-	 * Copy mount params to sb for use in submounts. Better to do
-	 * the copy here and deal with the error before cleanup gets
-	 * complicated post-mount.
-	 */
-	if (data) {
-		cifs_sb->mountdata = kstrndup(data, PAGE_CACHE_SIZE,
-					      GFP_KERNEL);
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
@@ -571,23 +558,49 @@ cifs_do_mount(struct file_system_type *fs_type,
 {
 	int rc;
 	struct super_block *sb;
+	struct smb_vol *volume_info;
+	char *copied_data = NULL;
 
-	sb = sget(fs_type, NULL, set_anon_super, NULL);
+	/*
+	 * Copy mount params for use in submounts. Better to do
+	 * the copy here and deal with the error before cleanup gets
+	 * complicated post-mount.
+	 */
+	copied_data = kstrndup(data, PAGE_CACHE_SIZE,
+					      GFP_KERNEL);
+	if (copied_data == NULL)
+		return ERR_PTR(-ENOMEM);
 
 	cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
 
-	if (IS_ERR(sb))
+	rc = cifs_setup_volume_info(&volume_info, (char *)data, dev_name);
+	if (rc)
+		return ERR_PTR(rc);
+
+	sb = sget(fs_type, NULL, set_anon_super, NULL);
+	if (IS_ERR(sb)) {
+		cifs_cleanup_volume_info(&volume_info);
 		return ERR_CAST(sb);
+	}
+
+	if (sb->s_fs_info)
+		goto out;
 
 	sb->s_flags = flags;
 
-	rc = cifs_read_super(sb, data, dev_name, flags & MS_SILENT ? 1 : 0);
+	rc = cifs_read_super(sb, copied_data, volume_info, dev_name,
+			     flags & MS_SILENT ? 1 : 0);
 	if (rc) {
+		cifs_cleanup_volume_info(&volume_info);
 		deactivate_locked_super(sb);
 		return ERR_PTR(rc);
 	}
+
+out:
+	cifs_cleanup_volume_info(&volume_info);
 	sb->s_flags |= MS_ACTIVE;
 	return dget(sb->s_root);
+
 }
 
 static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 9985f99..3336c2d 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -146,8 +146,12 @@ extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
 extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
 				const char *);
 
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
index bf610ab..53b79e7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2752,8 +2752,8 @@ is_path_accessible(int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-static void
-cleanup_volume_info(struct smb_vol **pvolume_info)
+void
+cifs_cleanup_volume_info(struct smb_vol **pvolume_info)
 {
 	struct smb_vol *volume_info;
 
@@ -2859,40 +2859,13 @@ expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
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
@@ -2900,7 +2873,7 @@ try_mount_again:
 		goto out;
 	}
 
-	if (cifs_parse_mount_options(cifs_sb->mountdata, devname,
+	if (cifs_parse_mount_options(mount_data, devname,
 				     volume_info)) {
 		rc = -EINVAL;
 		goto out;
@@ -2933,6 +2906,47 @@ try_mount_again:
 			goto out;
 		}
 	}
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
+
 	cifs_sb->local_nls = volume_info->local_nls;
 
 	/* get a reference to a tcp session */
@@ -3106,7 +3120,6 @@ mount_fail_check:
 	password will be freed at unmount time) */
 out:
 	/* zero out password before freeing */
-	cleanup_volume_info(&volume_info);
 	FreeXid(xid);
 	return rc;
 }
-- 
1.7.1
