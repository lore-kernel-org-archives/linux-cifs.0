From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: [PATCH 2/2] Consolidate and extract similar DFS referral expansion code in cifs_mount
Date: Fri, 25 Mar 2011 10:20:43 +0100
Message-ID: <de9908cf62bd6be5640f7cd0dcaf13aad12c3c53.1301063020.git.sean.finney@sonyericsson.com>
References: <c28ea395ebc40d7f886a4f0cccc0cf50c66946fa.1301063020.git.sean.finney@sonyericsson.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c28ea395ebc40d7f886a4f0cccc0cf50c66946fa.1301063020.git.sean.finney-9i8gj6P76NcrvcF+QRKbHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The logic behind the expansion of DFS referrals is now extracted from
cifs_mount into a new static function, expand_dfs_referral.
---
 fs/cifs/connect.c |  152 ++++++++++++++++++++++++++--------------------------
 1 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7e4ca38..da0156d 100644
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
+	ref_path = (check_prefix)?(full_path + 1):(volume_info->UNC + 1);
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
@@ -2876,49 +2936,17 @@ try_mount_again:
 remote_path_check:
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	/*
-	 * Perform an unconditional check for whether there are
-	 * DFS referrals for this path (without prefix), to provide
-	 * some limited support for domain DFS referrals on w2k8
+	 * Perform an unconditional check for whether there are DFS
+	 * referrals for this path without prefix, to provide support
+	 * for DFS referrals from w2k8 servers which don't seem to respond
+	 * with PATH_NOT_COVERED to requests that include the prefix.
+	 * Chase the referral if found, otherwise continue normally.
 	 */
 	if (referral_walks_count == 0) {
-		cFYI(1, "Getting referral for: %s", volume_info->UNC);
-		rc = get_dfs_path(xid, pSesInfo , volume_info->UNC + 1,
-			cifs_sb->local_nls, &num_referrals, &referrals,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-		if (!rc && num_referrals > 0) {
-			char *fake_devname = NULL;
-
-			full_path = build_unc_path_to_root(volume_info,
-							   cifs_sb);
-			if (IS_ERR(full_path)) {
-				rc = PTR_ERR(full_path);
-				goto mount_fail_check;
-			}
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
-
-			if (IS_ERR(mount_data)) {
-				rc = PTR_ERR(mount_data);
-				mount_data = NULL;
-				goto mount_fail_check;
-			}
-
-			if (tcon)
-				cifs_put_tcon(tcon);
-			else if (pSesInfo)
-				cifs_put_smb_ses(pSesInfo);
-
-			cleanup_volume_info(&volume_info);
+		int refrc = expand_dfs_referral(xid, pSesInfo, volume_info,
+						cifs_sb, &mount_data, false);
+		if (!refrc) {
 			referral_walks_count++;
-			FreeXid(xid);
 			goto try_mount_again;
 		}
 	}
@@ -2957,46 +2985,18 @@ remote_path_check:
 		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) == 0)
 			convert_delimiter(cifs_sb->prepath,
 					CIFS_DIR_SEP(cifs_sb));
-		full_path = build_unc_path_to_root(volume_info, cifs_sb);
-		if (IS_ERR(full_path)) {
-			rc = PTR_ERR(full_path);
-			goto mount_fail_check;
-		}
-
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
+		goto mount_fail_check;
 #else /* No DFS support, return error on mount */
 		rc = -EOPNOTSUPP;
 #endif
-- 
1.7.2.3
