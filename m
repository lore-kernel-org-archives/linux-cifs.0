From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix undefined behavior when mount fails
Date: Wed, 25 May 2011 13:35:34 +0400
Message-ID: <1306316134-11736-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fix double kfree() calls on the same pointers and cleanup mount code.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c |   44 +++++++++++++++++---------------------------
 1 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 131afad..d1ed7f9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -104,29 +104,23 @@ cifs_sb_deactive(struct super_block *sb)
 }
 
 static int
-cifs_read_super(struct super_block *sb, struct cifs_sb_info *cifs_sb,
-		void *data, struct smb_vol *volume_info, const char *devname,
-		int silent)
+cifs_read_super(struct super_block *sb, struct smb_vol *volume_info,
+		const char *devname, int silent)
 {
 	struct inode *inode;
+	struct cifs_sb_info *cifs_sb;
 	int rc = 0;
 
-	/* BB should we make this contingent on mount parm? */
-	sb->s_flags |= MS_NODIRATIME | MS_NOATIME;
-	sb->s_fs_info = cifs_sb;
+	cifs_sb = CIFS_SB(sb);
 
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
 	cifs_sb->tlink_tree = RB_ROOT;
 
 	rc = bdi_setup_and_register(&cifs_sb->bdi, "cifs", BDI_CAP_MAP_COPY);
-	if (rc) {
-		kfree(cifs_sb);
+	if (rc)
 		return rc;
-	}
-	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
 
-	if (data)
-		cifs_sb->mountdata = data;
+	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
 
 	rc = cifs_mount(sb, cifs_sb, volume_info, devname);
 
@@ -179,15 +173,7 @@ out_no_root:
 	cifs_umount(sb, cifs_sb);
 
 out_mount_failed:
-	if (cifs_sb) {
-		if (cifs_sb->mountdata) {
-			kfree(cifs_sb->mountdata);
-			cifs_sb->mountdata = NULL;
-		}
-		unload_nls(cifs_sb->local_nls);
-		bdi_destroy(&cifs_sb->bdi);
-		kfree(cifs_sb);
-	}
+	bdi_destroy(&cifs_sb->bdi);
 	return rc;
 }
 
@@ -553,7 +539,6 @@ cifs_do_mount(struct file_system_type *fs_type,
 	struct cifs_sb_info *cifs_sb;
 	struct smb_vol *volume_info;
 	struct dentry *root;
-	char *copied_data = NULL;
 
 	cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
 
@@ -576,20 +561,23 @@ cifs_do_mount(struct file_system_type *fs_type,
 		goto out;
 	}
 
-	sb->s_flags = flags;
-
 	/*
 	 * Copy mount params for use in submounts. Better to do
 	 * the copy here and deal with the error before cleanup gets
 	 * complicated post-mount.
 	 */
-	copied_data = kstrndup(data, PAGE_SIZE, GFP_KERNEL);
-	if (copied_data == NULL) {
+	cifs_sb->mountdata = kstrndup(data, PAGE_SIZE, GFP_KERNEL);
+	if (cifs_sb->mountdata == NULL) {
 		root = ERR_PTR(-ENOMEM);
 		goto err_out;
 	}
 
-	rc = cifs_read_super(sb, cifs_sb, copied_data, volume_info, dev_name,
+	sb->s_flags = flags;
+	/* BB should we make this contingent on mount parm? */
+	sb->s_flags |= MS_NODIRATIME | MS_NOATIME;
+	sb->s_fs_info = cifs_sb;
+
+	rc = cifs_read_super(sb, volume_info, dev_name,
 			     flags & MS_SILENT ? 1 : 0);
 	if (rc) {
 		root = ERR_PTR(rc);
@@ -604,6 +592,8 @@ out:
 	return root;
 
 err_out:
+	kfree(cifs_sb->mountdata);
+	unload_nls(cifs_sb->local_nls);
 	kfree(cifs_sb);
 	deactivate_locked_super(sb);
 	cifs_cleanup_volume_info(&volume_info);
-- 
1.7.1
