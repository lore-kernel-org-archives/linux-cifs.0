From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Add shared superblock capability
Date: Wed,  6 Apr 2011 18:03:33 +0400
Message-ID: <1302098613-7586-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now we can share super block if server, session, tree connect and
mount options match requested ones.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c    |   51 ++++++----
 fs/cifs/cifsglob.h  |    1 +
 fs/cifs/cifsproto.h |    8 +-
 fs/cifs/connect.c   |  277 +++++++++++++++++++++++++++++++++++++--------------
 4 files changed, 242 insertions(+), 95 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index fb6a2ad..4425bfc 100644
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
@@ -141,21 +141,11 @@ cifs_read_super(struct super_block *sb, void *data,
 	 * complex operation (mount), and in case of fail
 	 * just exit instead of doing mount and attempting
 	 * undo it if this copy fails?*/
-	if (data) {
-		int len = strlen(data);
-		cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
-		if (cifs_sb->mountdata == NULL) {
-			bdi_destroy(&cifs_sb->bdi);
-			kfree(sb->s_fs_info);
-			sb->s_fs_info = NULL;
-			return -ENOMEM;
-		}
-		strncpy(cifs_sb->mountdata, data, len + 1);
-		cifs_sb->mountdata[len] = '\0';
-	}
+	if (data)
+		cifs_sb->mountdata = data;
 #endif
 
-	rc = cifs_mount(sb, cifs_sb, data, devname);
+	rc = cifs_mount(sb, cifs_sb, volume_info, devname);
 
 	if (rc) {
 		if (!silent)
@@ -581,23 +571,46 @@ cifs_do_mount(struct file_system_type *fs_type,
 {
 	int rc;
 	struct super_block *sb;
-
-	sb = sget(fs_type, NULL, set_anon_super, NULL);
-
+	struct smb_vol *volume_info;
+	char *copied_data = NULL;
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	int len = strlen(data);
+	copied_data = kzalloc(len + 1, GFP_KERNEL);
+	if (copied_data == NULL)
+		return ERR_PTR(-ENOMEM);
+	strncpy(copied_data, data, len + 1);
+	copied_data[len] = '\0';
+#endif
 	cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
 
-	if (IS_ERR(sb))
+	rc = cifs_setup_volume_info(&volume_info, (char *)data, dev_name);
+	if (rc)
+		return ERR_PTR(rc);
+
+	sb = sget(fs_type, cifs_match_super, set_anon_super, volume_info);
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
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ccbac61..f3279bf 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -444,6 +444,7 @@ cifs_get_tlink(struct tcon_link *tlink)
 /* This function is always expected to succeed */
 extern struct cifs_tcon *cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb);
 
+extern struct tcon_link *cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb);
 /*
  * This info hangs off the cifsFileInfo structure, pointed to by llist.
  * This is used to track byte stream locks on the file
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 76c4dc7..3336c2d 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -146,8 +146,12 @@ extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
 extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
 				const char *);
 
-extern int cifs_mount(struct super_block *, struct cifs_sb_info *, char *,
-			const char *);
+extern int cifs_match_super(struct super_block *, void *);
+extern void cifs_cleanup_volume_info(struct smb_vol **pvolume_info);
+extern int cifs_setup_volume_info(struct smb_vol **pvolume_info,
+				  char *mount_data, const char *devname);
+extern int cifs_mount(struct super_block *, struct cifs_sb_info *,
+		      struct smb_vol *, const char *);
 extern int cifs_umount(struct super_block *, struct cifs_sb_info *);
 extern void cifs_dfs_release_automount_timer(void);
 void cifs_proc_init(void);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 94e60c5..c2431d0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1603,32 +1603,41 @@ match_security(struct TCP_Server_Info *server, struct smb_vol *vol)
 	return true;
 }
 
-static struct TCP_Server_Info *
-cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
+static int match_server(struct TCP_Server_Info *server, struct sockaddr *addr,
+			 struct smb_vol *vol)
 {
-	struct TCP_Server_Info *server;
-
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
-			continue;
+	if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
+		return 0;
 
-		if (!match_address(server, addr,
-				   (struct sockaddr *)&vol->srcaddr))
-			continue;
+	if (!match_address(server, addr,
+			   (struct sockaddr *)&vol->srcaddr))
+		return 0;
 
 #ifdef CONFIG_CIFS_SMB2
-		if ((server->is_smb2 == true) && (vol->use_smb2 == false))
-			continue;
+	if ((server->is_smb2 == true) && (vol->use_smb2 == false))
+		return 0;
 
-		if ((server->is_smb2 == false) && (vol->use_smb2 == true))
-			continue;
+	if ((server->is_smb2 == false) && (vol->use_smb2 == true))
+		return 0;
 #endif /* CONFIG_CIFS_SMB2 */
 
-		if (!match_port(server, addr))
-			continue;
+	if (!match_port(server, addr))
+		return 0;
 
-		if (!match_security(server, vol))
+	if (!match_security(server, vol))
+		return 0;
+
+	return 1;
+}
+
+static struct TCP_Server_Info *
+cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
+{
+	struct TCP_Server_Info *server;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		if (!match_server(server, addr, vol))
 			continue;
 
 		++server->srv_count;
@@ -1828,6 +1837,30 @@ out_err:
 	return ERR_PTR(rc);
 }
 
+static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
+{
+	switch (ses->server->secType) {
+	case Kerberos:
+		if (vol->cred_uid != ses->cred_uid)
+			return 0;
+		break;
+	default:
+		/* anything else takes username/password */
+		if (ses->user_name == NULL)
+			return 0;
+		if (strncmp(ses->user_name, vol->username,
+			    MAX_USERNAME_SIZE))
+			return 0;
+		if (strlen(vol->username) != 0 &&
+		    ses->password != NULL &&
+		    strncmp(ses->password,
+			    vol->password ? vol->password : "",
+			    MAX_PASSWORD_SIZE))
+			return 0;
+	}
+	return 1;
+}
+
 static struct cifs_ses *
 cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 {
@@ -1835,25 +1868,8 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-		switch (server->secType) {
-		case Kerberos:
-			if (vol->cred_uid != ses->cred_uid)
-				continue;
-			break;
-		default:
-			/* anything else takes username/password */
-			if (ses->user_name == NULL)
-				continue;
-			if (strncmp(ses->user_name, vol->username,
-				    MAX_USERNAME_SIZE))
-				continue;
-			if (strlen(vol->username) != 0 &&
-			    ses->password != NULL &&
-			    strncmp(ses->password,
-				    vol->password ? vol->password : "",
-				    MAX_PASSWORD_SIZE))
-				continue;
-		}
+		if (!match_session(ses, vol))
+			continue;
 		++ses->ses_count;
 		spin_unlock(&cifs_tcp_ses_lock);
 		return ses;
@@ -1996,6 +2012,15 @@ get_ses_fail:
 	return ERR_PTR(rc);
 }
 
+static int match_tcon(struct cifs_tcon *tcon, const char *unc)
+{
+	if (tcon->tidStatus == CifsExiting)
+		return 0;
+	if (strncmp(tcon->treeName, unc, MAX_TREE_SIZE))
+		return 0;
+	return 1;
+}
+
 static struct cifs_tcon *
 cifs_find_tcon(struct cifs_ses *ses, const char *unc)
 {
@@ -2005,11 +2030,8 @@ cifs_find_tcon(struct cifs_ses *ses, const char *unc)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &ses->tcon_list) {
 		tcon = list_entry(tmp, struct cifs_tcon, tcon_list);
-		if (tcon->tidStatus == CifsExiting)
-			continue;
-		if (strncmp(tcon->treeName, unc, MAX_TREE_SIZE))
+		if (!match_tcon(tcon, unc))
 			continue;
-
 		++tcon->tc_count;
 		spin_unlock(&cifs_tcp_ses_lock);
 		return tcon;
@@ -2136,6 +2158,101 @@ cifs_put_tlink(struct tcon_link *tlink)
 	return;
 }
 
+static void setup_cifs_sb(struct smb_vol *vol, struct cifs_sb_info *sb);
+
+static const u32 ACTUAL_MOUNT_FLAGS = CIFS_MOUNT_NO_PERM | CIFS_MOUNT_SET_UID |
+	CIFS_MOUNT_SERVER_INUM | CIFS_MOUNT_DIRECT_IO | CIFS_MOUNT_NO_XATTR |
+	CIFS_MOUNT_MAP_SPECIAL_CHR | CIFS_MOUNT_UNX_EMUL | CIFS_MOUNT_NO_BRL |
+	CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_OVERR_UID | CIFS_MOUNT_OVERR_GID |
+	CIFS_MOUNT_DYNPERM | CIFS_MOUNT_NOPOSIXBRL | CIFS_MOUNT_NOSSYNC |
+	CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | CIFS_MOUNT_MULTIUSER |
+	CIFS_MOUNT_STRICT_IO;
+
+static int
+compare_mount_options(struct super_block *sb, struct smb_vol *vol)
+{
+	struct cifs_sb_info *old = CIFS_SB(sb), new;
+
+	setup_cifs_sb(vol, &new);
+
+	cFYI(1, "before mount option check");
+	cFYI(1, "%d %d", old->mnt_cifs_flags, new.mnt_cifs_flags);
+
+	if ((old->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS) !=
+	    (new.mnt_cifs_flags & ACTUAL_MOUNT_FLAGS))
+		return 0;
+	cFYI(1, "flags == flags");
+
+	if (old->rsize != new.rsize || old->wsize != new.wsize)
+		return 0;
+
+	if (old->mnt_uid != new.mnt_uid || old->mnt_gid != new.mnt_gid)
+		return 0;
+
+	if (old->mnt_file_mode != new.mnt_file_mode ||
+	    old->mnt_dir_mode != new.mnt_dir_mode)
+		return 0;
+
+	if (old->prepathlen != new.prepathlen ||
+	    strncmp(old->prepath, new.prepath, old->prepathlen))
+		return 0;
+
+	if (strcmp(old->local_nls->charset, vol->local_nls->charset))
+		return 0;
+
+	cFYI(1, "size == size");
+	if (old->actimeo != new.actimeo)
+		return 0;
+
+	cFYI(1, "time == time");
+	return 1;
+}
+
+int
+cifs_match_super(struct super_block *sb, void *data)
+{
+	struct smb_vol *volume_info = (struct smb_vol *) data;
+	struct TCP_Server_Info *tcp_srv;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
+	struct sockaddr_storage addr;
+	int rc = 0;
+
+	memset(&addr, 0, sizeof(struct sockaddr_storage));
+
+	spin_lock(&cifs_tcp_ses_lock);
+	cifs_sb = CIFS_SB(sb);
+	tlink = cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
+	if (IS_ERR(tlink))
+		goto out;
+	tcon = tlink_tcon(tlink);
+	ses = tcon->ses;
+	tcp_srv = ses->server;
+
+	if (!volume_info->UNCip || !volume_info->UNC)
+		goto out;
+
+	rc = cifs_fill_sockaddr((struct sockaddr *)&addr,
+				volume_info->UNCip,
+				strlen(volume_info->UNCip),
+				volume_info->port);
+	if (!rc)
+		goto out;
+
+	if (!match_server(tcp_srv, (struct sockaddr *)&addr, volume_info) ||
+	    !match_session(ses, volume_info) ||
+	    !match_tcon(tcon, volume_info->UNC))
+		rc = 0;
+
+	rc = compare_mount_options(sb, volume_info);
+out:
+	cifs_put_tlink(tlink);
+	spin_unlock(&cifs_tcp_ses_lock);
+	return rc;
+}
+
 int
 get_dfs_path(int xid, struct cifs_ses *pSesInfo, const char *old_path,
 	     const struct nls_table *nls_codepage, unsigned int *pnum_referrals,
@@ -2695,8 +2812,8 @@ is_path_accessible(int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-static void
-cleanup_volume_info(struct smb_vol **pvolume_info)
+void
+cifs_cleanup_volume_info(struct smb_vol **pvolume_info)
 {
 	struct smb_vol *volume_info;
 
@@ -2744,33 +2861,13 @@ build_unc_path_to_root(const struct smb_vol *volume_info,
 }
 #endif
 
-int
-cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
-		char *mount_data_global, const char *devname)
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
-	char *mount_data = mount_data_global;
-	struct tcon_link *tlink;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	struct dfs_info3_param *referrals = NULL;
-	unsigned int num_referrals = 0;
-	int referral_walks_count = 0;
-try_mount_again:
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
@@ -2810,6 +2907,41 @@ try_mount_again:
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
+	int rc;
+	int xid;
+	struct cifs_ses *pSesInfo;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *srvTcp;
+	char   *full_path;
+	char *mount_data = NULL;
+	struct tcon_link *tlink;
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	struct dfs_info3_param *referrals = NULL;
+	unsigned int num_referrals = 0;
+	int referral_walks_count = 0;
+try_mount_again:
+#endif
+	rc = 0;
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
@@ -2920,8 +3052,7 @@ remote_path_check:
 		if (!rc && num_referrals > 0) {
 			char *fake_devname = NULL;
 
-			if (mount_data != mount_data_global)
-				kfree(mount_data);
+			kfree(mount_data);
 
 			mount_data = cifs_compose_mount_options(
 					cifs_sb->mountdata, full_path + 1,
@@ -2942,7 +3073,7 @@ remote_path_check:
 			else if (pSesInfo)
 				cifs_put_smb_ses(pSesInfo);
 
-			cleanup_volume_info(&volume_info);
+			cifs_cleanup_volume_info(&volume_info);
 			referral_walks_count++;
 			FreeXid(xid);
 			goto try_mount_again;
@@ -2979,8 +3110,7 @@ remote_path_check:
 mount_fail_check:
 	/* on error free sesinfo and tcon struct if needed */
 	if (rc) {
-		if (mount_data != mount_data_global)
-			kfree(mount_data);
+		kfree(mount_data);
 		/* If find_unc succeeded then rc == 0 so we can not end */
 		/* up accidently freeing someone elses tcon struct */
 		if (tcon)
@@ -2998,7 +3128,6 @@ mount_fail_check:
 	password will be freed at unmount time) */
 out:
 	/* zero out password before freeing */
-	cleanup_volume_info(&volume_info);
 	FreeXid(xid);
 	return rc;
 }
@@ -3338,7 +3467,7 @@ out:
 	return tcon;
 }
 
-static inline struct tcon_link *
+inline struct tcon_link *
 cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb)
 {
 	return cifs_sb->master_tlink;
-- 
1.7.1
