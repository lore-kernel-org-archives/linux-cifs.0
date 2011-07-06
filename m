From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] cifs: have cifs_cleanup_volume_info not take a double pointer
Date: Wed,  6 Jul 2011 08:10:37 -0400
Message-ID: <1309954239-17345-3-git-send-email-jlayton@redhat.com>
References: <1309954239-17345-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309954239-17345-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...as that makes for a cumbersome interface. Make it take a regular
smb_vol pointer and rely on the caller to zero it out if needed.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c    |    2 +-
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/connect.c   |   10 +++-------
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 35f9154..e11b831 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -713,7 +713,7 @@ cifs_do_mount(struct file_system_type *fs_type,
 out_super:
 	deactivate_locked_super(sb);
 out:
-	cifs_cleanup_volume_info(&volume_info);
+	cifs_cleanup_volume_info(volume_info);
 	return root;
 
 out_mountdata:
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 257f312..53b1b13 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -154,7 +154,7 @@ extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
 extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			       struct cifs_sb_info *cifs_sb);
 extern int cifs_match_super(struct super_block *, void *);
-extern void cifs_cleanup_volume_info(struct smb_vol **pvolume_info);
+extern void cifs_cleanup_volume_info(struct smb_vol *pvolume_info);
 extern int cifs_setup_volume_info(struct smb_vol **pvolume_info,
 				  char *mount_data, const char *devname);
 extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 44376ce..dd06407 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2831,14 +2831,11 @@ is_path_accessible(int xid, struct cifs_tcon *tcon,
 }
 
 void
-cifs_cleanup_volume_info(struct smb_vol **pvolume_info)
+cifs_cleanup_volume_info(struct smb_vol *volume_info)
 {
-	struct smb_vol *volume_info;
-
-	if (!pvolume_info || !*pvolume_info)
+	if (!volume_info)
 		return;
 
-	volume_info = *pvolume_info;
 	kfree(volume_info->username);
 	kzfree(volume_info->password);
 	kfree(volume_info->UNC);
@@ -2847,7 +2844,6 @@ cifs_cleanup_volume_info(struct smb_vol **pvolume_info)
 	kfree(volume_info->iocharset);
 	kfree(volume_info->prepath);
 	kfree(volume_info);
-	*pvolume_info = NULL;
 	return;
 }
 
@@ -2990,7 +2986,7 @@ int cifs_setup_volume_info(struct smb_vol **pvolume_info, char *mount_data,
 	*pvolume_info = volume_info;
 	return rc;
 out:
-	cifs_cleanup_volume_info(&volume_info);
+	cifs_cleanup_volume_info(volume_info);
 	return rc;
 }
 
-- 
1.7.6
