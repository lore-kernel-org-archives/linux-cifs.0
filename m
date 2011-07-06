From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] cifs: fix expand_dfs_referral
Date: Wed,  6 Jul 2011 08:10:39 -0400
Message-ID: <1309954239-17345-5-git-send-email-jlayton@redhat.com>
References: <1309954239-17345-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309954239-17345-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Regression introduced in commit 724d9f1cfba.

Prior to that, expand_dfs_referral would regenerate the mount data string
and then call cifs_parse_mount_options to re-parse it (klunky, but it
worked). The above commit moved cifs_parse_mount_options out of cifs_mount,
so the re-parsing of the new mount options no longer occurred. Fix it by
making expand_dfs_referral re-parse the mount options.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 46cc0ad..c254411 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -65,6 +65,8 @@ static int ip_connect(struct TCP_Server_Info *server);
 static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
 static void cifs_prune_tlinks(struct work_struct *work);
+static int cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
+					const char *devname);
 
 /*
  * cifs tcp session reconnection
@@ -2830,12 +2832,9 @@ is_path_accessible(int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-void
-cifs_cleanup_volume_info(struct smb_vol *volume_info)
+static void
+cleanup_volume_info_contents(struct smb_vol *volume_info)
 {
-	if (!volume_info)
-		return;
-
 	kfree(volume_info->username);
 	kzfree(volume_info->password);
 	kfree(volume_info->UNC);
@@ -2843,10 +2842,18 @@ cifs_cleanup_volume_info(struct smb_vol *volume_info)
 	kfree(volume_info->domainname);
 	kfree(volume_info->iocharset);
 	kfree(volume_info->prepath);
+}
+
+void
+cifs_cleanup_volume_info(struct smb_vol *volume_info)
+{
+	if (!volume_info)
+		return;
+	cleanup_volume_info_contents(volume_info);
 	kfree(volume_info);
-	return;
 }
 
+
 #ifdef CONFIG_CIFS_DFS_UPCALL
 /* build_path_to_root returns full path to root when
  * we do not have an exiting connection (tcon) */
@@ -2915,15 +2922,18 @@ expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
 						   &fake_devname);
 
 		free_dfs_info_array(referrals, num_referrals);
-		kfree(fake_devname);
-
-		if (cifs_sb->mountdata != NULL)
-			kfree(cifs_sb->mountdata);
 
 		if (IS_ERR(mdata)) {
 			rc = PTR_ERR(mdata);
 			mdata = NULL;
+		} else {
+			cleanup_volume_info_contents(volume_info);
+			memset(volume_info, '\0', sizeof(*volume_info));
+			rc = cifs_setup_volume_info(volume_info, mdata,
+							fake_devname);
 		}
+		kfree(fake_devname);
+		kfree(cifs_sb->mountdata);
 		cifs_sb->mountdata = mdata;
 	}
 	kfree(full_path);
-- 
1.7.6
