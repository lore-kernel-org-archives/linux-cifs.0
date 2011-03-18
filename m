From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: [PATCH] Fix Bug#31092: Unable to mount DFS filesystems from Windows 2008 servers
Date: Fri, 18 Mar 2011 10:02:07 +0100
Message-ID: <20110321082927.8ECF830009@cobija.connexer.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Windows 2008 CIFS servers do not always return PATH_NOT_COVERED when
attempting to access a DFS share.  Therefore, when checking for remote
shares, unconditionally ask for a DFS referral for the UNC (w/out prepath)
before continuing with previous behavior of attempting to access the UNC +
prepath and checking for PATH_NOT_COVERED.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=31092
---
 fs/cifs/connect.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8d6c17a..e3a9fd7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2825,6 +2825,56 @@ try_mount_again:
 			       (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
 
 remote_path_check:
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	/*
+	 * Perform an unconditional check for whether there are
+	 * DFS referrals for this path (without prefix), to provide
+	 * some limited support for domain DFS referrals on w2k8
+	 */
+	if (referral_walks_count == 0) {
+		cFYI(1, "Getting referral for: %s", volume_info->UNC);
+		rc = get_dfs_path(xid, pSesInfo , volume_info->UNC + 1,
+			cifs_sb->local_nls, &num_referrals, &referrals,
+			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+		if (!rc && num_referrals > 0) {
+			char *fake_devname = NULL;
+
+			full_path = build_unc_path_to_root(volume_info,
+							   cifs_sb);
+			if (IS_ERR(full_path)) {
+				rc = PTR_ERR(full_path);
+				goto mount_fail_check;
+			}
+
+			if (mount_data != mount_data_global)
+				kfree(mount_data);
+
+			mount_data = cifs_compose_mount_options(
+					cifs_sb->mountdata, full_path + 1,
+					referrals, &fake_devname);
+
+			free_dfs_info_array(referrals, num_referrals);
+			kfree(fake_devname);
+
+			if (IS_ERR(mount_data)) {
+				rc = PTR_ERR(mount_data);
+				mount_data = NULL;
+				goto mount_fail_check;
+			}
+
+			if (tcon)
+				cifs_put_tcon(tcon);
+			else if (pSesInfo)
+				cifs_put_smb_ses(pSesInfo);
+
+			cleanup_volume_info(&volume_info);
+			referral_walks_count++;
+			FreeXid(xid);
+			goto try_mount_again;
+		}
+	}
+#endif
+
 	/* check if a whole path (including prepath) is not remote */
 	if (!rc && cifs_sb->prepathlen && tcon) {
 		/* build_path_to_root works only when we have a valid tcon */
-- 
1.7.2.3
