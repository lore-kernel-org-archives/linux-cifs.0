From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] cifs: factor smb_vol allocation out of cifs_setup_volume_info
Date: Wed,  6 Jul 2011 08:10:38 -0400
Message-ID: <1309954239-17345-4-git-send-email-jlayton@redhat.com>
References: <1309954239-17345-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309954239-17345-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c    |    6 ++--
 fs/cifs/cifsproto.h |    4 +-
 fs/cifs/connect.c   |   56 +++++++++++++++++++++++++-------------------------
 3 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e11b831..3e29899 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -649,9 +649,9 @@ cifs_do_mount(struct file_system_type *fs_type,
 
 	cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
 
-	rc = cifs_setup_volume_info(&volume_info, (char *)data, dev_name);
-	if (rc)
-		return ERR_PTR(rc);
+	volume_info = cifs_get_volume_info((char *)data, dev_name);
+	if (IS_ERR(volume_info))
+		return ERR_CAST(volume_info);
 
 	cifs_sb = kzalloc(sizeof(struct cifs_sb_info), GFP_KERNEL);
 	if (cifs_sb == NULL) {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 53b1b13..8df28e9 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -155,8 +155,8 @@ extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			       struct cifs_sb_info *cifs_sb);
 extern int cifs_match_super(struct super_block *, void *);
 extern void cifs_cleanup_volume_info(struct smb_vol *pvolume_info);
-extern int cifs_setup_volume_info(struct smb_vol **pvolume_info,
-				  char *mount_data, const char *devname);
+extern struct smb_vol *cifs_get_volume_info(char *mount_data,
+					    const char *devname);
 extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
 extern void cifs_umount(struct cifs_sb_info *);
 extern void cifs_dfs_release_automount_timer(void);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index dd06407..46cc0ad 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2931,33 +2931,20 @@ expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
 }
 #endif
 
-int cifs_setup_volume_info(struct smb_vol **pvolume_info, char *mount_data,
-			   const char *devname)
+static int
+cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
+			const char *devname)
 {
-	struct smb_vol *volume_info;
 	int rc = 0;
 
-	*pvolume_info = NULL;
-
-	volume_info = kzalloc(sizeof(struct smb_vol), GFP_KERNEL);
-	if (!volume_info) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	if (cifs_parse_mount_options(mount_data, devname,
-				     volume_info)) {
-		rc = -EINVAL;
-		goto out;
-	}
+	if (cifs_parse_mount_options(mount_data, devname, volume_info))
+		return -EINVAL;
 
 	if (volume_info->nullauth) {
 		cFYI(1, "null user");
 		volume_info->username = kzalloc(1, GFP_KERNEL);
-		if (volume_info->username == NULL) {
-			rc = -ENOMEM;
-			goto out;
-		}
+		if (volume_info->username == NULL)
+			return -ENOMEM;
 	} else if (volume_info->username) {
 		/* BB fixme parse for domain name here */
 		cFYI(1, "Username: %s", volume_info->username);
@@ -2965,8 +2952,7 @@ int cifs_setup_volume_info(struct smb_vol **pvolume_info, char *mount_data,
 		cifserror("No username specified");
 	/* In userspace mount helper we can get user name from alternate
 	   locations such as env variables and files on disk */
-		rc = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/* this is needed for ASCII cp to Unicode converts */
@@ -2978,18 +2964,32 @@ int cifs_setup_volume_info(struct smb_vol **pvolume_info, char *mount_data,
 		if (volume_info->local_nls == NULL) {
 			cERROR(1, "CIFS mount error: iocharset %s not found",
 				 volume_info->iocharset);
-			rc = -ELIBACC;
-			goto out;
+			return -ELIBACC;
 		}
 	}
 
-	*pvolume_info = volume_info;
-	return rc;
-out:
-	cifs_cleanup_volume_info(volume_info);
 	return rc;
 }
 
+struct smb_vol *
+cifs_get_volume_info(char *mount_data, const char *devname)
+{
+	int rc;
+	struct smb_vol *volume_info;
+
+	volume_info = kzalloc(sizeof(struct smb_vol), GFP_KERNEL);
+	if (!volume_info)
+		return ERR_PTR(-ENOMEM);
+
+	rc = cifs_setup_volume_info(volume_info, mount_data, devname);
+	if (rc) {
+		cifs_cleanup_volume_info(volume_info);
+		volume_info = ERR_PTR(rc);
+	}
+
+	return volume_info;
+}
+
 int
 cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 {
-- 
1.7.6
