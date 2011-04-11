From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: [PATCH v5 1/6] cifs: Extract DFS referral expansion logic to separate function
Date: Mon, 11 Apr 2011 15:19:30 +0200
Message-ID: <1302527975-16549-1-git-send-email-seanius@seanius.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
To: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The logic behind the expansion of DFS referrals is now extracted from
cifs_mount into a new static function, expand_dfs_referral.  This will
reduce duplicate code in upcoming commits.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
---
 fs/cifs/connect.c |  105 +++++++++++++++++++++++++++++++++++------------------
 1 files changed, 69 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 94e60c5..c89d871 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2742,6 +2742,57 @@ build_unc_path_to_root(const struct smb_vol *volume_info,
 	full_path[unc_len + cifs_sb->prepathlen] = 0; /* add trailing null */
 	return full_path;
 }
+
+/*
+ * Perform a dfs referral query for a share and (optionally) prefix
+ *
+ * If a referral is found, mount_data will be set to point at a newly
+ * allocated string containing updated options for the submount.
+ * Otherwise it will be left untouched.
+ *
+ * Returns the rc from get_dfs_path to the caller, which can be used to
+ * determine whether there were referrals.
+ */
+static int
+expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
+		    struct smb_vol *volume_info, struct cifs_sb_info *cifs_sb,
+		    char **mount_data, int check_prefix)
+{
+	int rc;
+	unsigned int num_referrals = 0;
+	struct dfs_info3_param *referrals = NULL;
+	char *full_path = NULL, *ref_path = NULL, *mdata = NULL;
+
+	full_path = build_unc_path_to_root(volume_info, cifs_sb);
+	if (IS_ERR(full_path))
+		return PTR_ERR(full_path);
+
+	/* For DFS paths, skip the first '\' of the UNC */
+	ref_path = check_prefix ? full_path + 1 : volume_info->UNC + 1;
+
+	rc = get_dfs_path(xid, pSesInfo , ref_path, cifs_sb->local_nls,
+			  &num_referrals, &referrals,
+			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+	if (!rc && num_referrals > 0) {
+		char *fake_devname = NULL;
+
+		mdata = cifs_compose_mount_options(cifs_sb->mountdata,
+						   full_path + 1, referrals,
+						   &fake_devname);
+
+		free_dfs_info_array(referrals, num_referrals);
+		kfree(fake_devname);
+
+		if (IS_ERR(mdata)) {
+			rc = PTR_ERR(mdata);
+			mdata = NULL;
+		}
+		*mount_data = mdata;
+	}
+	kfree(full_path);
+	return rc;
+}
 #endif
 
 int
@@ -2758,10 +2809,19 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 	char *mount_data = mount_data_global;
 	struct tcon_link *tlink;
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	struct dfs_info3_param *referrals = NULL;
-	unsigned int num_referrals = 0;
 	int referral_walks_count = 0;
 try_mount_again:
+
+	/* cleanup activities if we're chasing a referral */
+	if (referral_walks_count) {
+		if (tcon)
+			cifs_put_tcon(tcon);
+		else if (pSesInfo)
+			cifs_put_smb_ses(pSesInfo);
+
+		cleanup_volume_info(&volume_info);
+		FreeXid(xid);
+	}
 #endif
 	rc = 0;
 	tcon = NULL;
@@ -2907,46 +2967,19 @@ remote_path_check:
 		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) == 0)
 			convert_delimiter(cifs_sb->prepath,
 					CIFS_DIR_SEP(cifs_sb));
-		full_path = build_unc_path_to_root(volume_info, cifs_sb);
-		if (IS_ERR(full_path)) {
-			rc = PTR_ERR(full_path);
-			goto mount_fail_check;
-		}
 
-		cFYI(1, "Getting referral for: %s", full_path);
-		rc = get_dfs_path(xid, pSesInfo , full_path + 1,
-			cifs_sb->local_nls, &num_referrals, &referrals,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-		if (!rc && num_referrals > 0) {
-			char *fake_devname = NULL;
-
-			if (mount_data != mount_data_global)
-				kfree(mount_data);
-
-			mount_data = cifs_compose_mount_options(
-					cifs_sb->mountdata, full_path + 1,
-					referrals, &fake_devname);
-
-			free_dfs_info_array(referrals, num_referrals);
-			kfree(fake_devname);
-			kfree(full_path);
-
-			if (IS_ERR(mount_data)) {
-				rc = PTR_ERR(mount_data);
-				mount_data = NULL;
-				goto mount_fail_check;
-			}
+		if (mount_data != mount_data_global)
+			kfree(mount_data);
 
-			if (tcon)
-				cifs_put_tcon(tcon);
-			else if (pSesInfo)
-				cifs_put_smb_ses(pSesInfo);
+		rc = expand_dfs_referral(xid, pSesInfo, volume_info, cifs_sb,
+					 &mount_data, true);
 
-			cleanup_volume_info(&volume_info);
+		if (!rc) {
 			referral_walks_count++;
-			FreeXid(xid);
 			goto try_mount_again;
 		}
+		mount_data = NULL;
+		goto mount_fail_check;
 #else /* No DFS support, return error on mount */
 		rc = -EOPNOTSUPP;
 #endif
-- 
1.7.4.1
