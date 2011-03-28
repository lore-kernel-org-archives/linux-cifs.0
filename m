From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: [PATCH 4/4] Simplify handling of submount options in cifs_mount.
Date: Mon, 28 Mar 2011 12:19:29 +0200
Message-ID: <0f8960e4c1ab9567047959bf23af8d6893a52cad.1301492580.git.seanius@seanius.net>
References: <258c7d7b9e8dbd73829c701e6494f91bfa707cb3.1301492580.git.seanius@seanius.net>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <258c7d7b9e8dbd73829c701e6494f91bfa707cb3.1301492580.git.seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

With CONFIG_DFS_UPCALL enabled, maintain the submount options in
cifs_sb->mountdata, simplifying the code just a bit as well as making
corner-case allocation problems less likely.

Signed-off-by: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
---
 fs/cifs/connect.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 776a9e5..d8e300e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2756,9 +2756,9 @@ build_unc_path_to_root(const struct smb_vol *volume_info,
 /*
  * Perform a dfs referral query for a share and (optionally) prefix
  *
- * If a referral is found, mount_data will be set to point at a newly
- * allocated string containing updated options for the submount.
- * Otherwise it will be left untouched.
+ * If a referral is found, cifs_sb->mountdata will be (re-)allocated
+ * to a string containing updated options for the submount.  Otherwise it
+ * will be left untouched.
  *
  * Returns the rc from get_dfs_path to the caller, which can be used to
  * determine whether there were referrals.
@@ -2766,7 +2766,7 @@ build_unc_path_to_root(const struct smb_vol *volume_info,
 static int
 expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
 		    struct smb_vol *volume_info, struct cifs_sb_info *cifs_sb,
-		    char **mount_data, int check_prefix)
+		    int check_prefix)
 {
 	int rc;
 	unsigned int num_referrals = 0;
@@ -2794,11 +2794,14 @@ expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
 		free_dfs_info_array(referrals, num_referrals);
 		kfree(fake_devname);
 
+		if (cifs_sb->mountdata != NULL)
+			kfree(cifs_sb->mountdata);
+
 		if (IS_ERR(mdata)) {
 			rc = PTR_ERR(mdata);
 			mdata = NULL;
 		}
-		*mount_data = mdata;
+		cifs_sb->mountdata = mdata;
 	}
 	kfree(full_path);
 	return rc;
@@ -2821,6 +2824,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	int referral_walks_count = 0;
 try_mount_again:
+	mount_data = cifs_sb->mountdata;
 
 	/* cleanup activities if we're chasing a referral */
 	if (referral_walks_count) {
@@ -2954,7 +2958,7 @@ remote_path_check:
 	 */
 	if (referral_walks_count == 0) {
 		int refrc = expand_dfs_referral(xid, pSesInfo, volume_info,
-						cifs_sb, &mount_data, false);
+						cifs_sb, false);
 		if (!refrc) {
 			referral_walks_count++;
 			goto try_mount_again;
@@ -2996,17 +3000,13 @@ remote_path_check:
 			convert_delimiter(cifs_sb->prepath,
 					CIFS_DIR_SEP(cifs_sb));
 
-		if (mount_data != mount_data_global)
-			kfree(mount_data);
-
 		rc = expand_dfs_referral(xid, pSesInfo, volume_info, cifs_sb,
-					 &mount_data, true);
+					 true);
 
 		if (!rc) {
 			referral_walks_count++;
 			goto try_mount_again;
 		}
-		mount_data = NULL;
 		goto mount_fail_check;
 #else /* No DFS support, return error on mount */
 		rc = -EOPNOTSUPP;
@@ -3040,8 +3040,6 @@ remote_path_check:
 mount_fail_check:
 	/* on error free sesinfo and tcon struct if needed */
 	if (rc) {
-		if (mount_data != NULL && mount_data != mount_data_global)
-			kfree(mount_data);
 		/* If find_unc succeeded then rc == 0 so we can not end */
 		/* up accidently freeing someone elses tcon struct */
 		if (tcon)
-- 
1.7.2.3
