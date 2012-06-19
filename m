From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 13/22] CIFS: Move is_path_accessible to ops struct
Date: Tue, 19 Jun 2012 16:40:02 +0400
Message-ID: <1340109611-7210-14-git-send-email-pshilovsky@samba.org>
References: <1340109611-7210-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340109611-7210-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    3 +++
 fs/cifs/connect.c  |   31 ++++++-------------------------
 fs/cifs/smb1ops.c  |   25 +++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 4f82900..7f5cb14 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -215,6 +215,9 @@ struct smb_version_operations {
 			     const struct nls_table *, int);
 	/* informational QFS call */
 	void (*qfs_tcon)(const int, struct cifs_tcon *);
+	/* check if a path is accessible or not */
+	int (*is_path_accessible)(const int, struct cifs_tcon *,
+				  struct cifs_sb_info *, const char *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3f6b66a..a1f301f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3385,30 +3385,6 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 	return rsize;
 }
 
-static int
-is_path_accessible(int xid, struct cifs_tcon *tcon,
-		   struct cifs_sb_info *cifs_sb, const char *full_path)
-{
-	int rc;
-	FILE_ALL_INFO *pfile_info;
-
-	pfile_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
-	if (pfile_info == NULL)
-		return -ENOMEM;
-
-	rc = CIFSSMBQPathInfo(xid, tcon, full_path, pfile_info,
-			      0 /* not legacy */, cifs_sb->local_nls,
-			      cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
-
-	if (rc == -EOPNOTSUPP || rc == -EINVAL)
-		rc = SMBQueryInformation(xid, tcon, full_path, pfile_info,
-				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				  CIFS_MOUNT_MAP_SPECIAL_CHR);
-	kfree(pfile_info);
-	return rc;
-}
-
 static void
 cleanup_volume_info_contents(struct smb_vol *volume_info)
 {
@@ -3686,13 +3662,18 @@ remote_path_check:
 
 	/* check if a whole path is not remote */
 	if (!rc && tcon) {
+		if (!server->ops->is_path_accessible) {
+			rc = -ENOSYS;
+			goto mount_fail_check;
+		}
 		/* build_path_to_root works only when we have a valid tcon */
 		full_path = cifs_build_path_to_root(volume_info, cifs_sb, tcon);
 		if (full_path == NULL) {
 			rc = -ENOMEM;
 			goto mount_fail_check;
 		}
-		rc = is_path_accessible(xid, tcon, cifs_sb, full_path);
+		rc = server->ops->is_path_accessible(xid, tcon, cifs_sb,
+						     full_path);
 		if (rc != 0 && rc != -EREMOTE) {
 			kfree(full_path);
 			goto mount_fail_check;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 00cae9e..554ecba 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -428,6 +428,30 @@ cifs_qfs_tcon(const int xid, struct cifs_tcon *tcon)
 	CIFSSMBQFSAttributeInfo(xid, tcon);
 }
 
+int
+cifs_is_path_accessible(const int xid, struct cifs_tcon *tcon,
+			struct cifs_sb_info *cifs_sb, const char *full_path)
+{
+	int rc;
+	FILE_ALL_INFO *file_info;
+
+	file_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+	if (file_info == NULL)
+		return -ENOMEM;
+
+	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
+			      0 /* not legacy */, cifs_sb->local_nls,
+			      cifs_sb->mnt_cifs_flags &
+				CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+	if (rc == -EOPNOTSUPP || rc == -EINVAL)
+		rc = SMBQueryInformation(xid, tcon, full_path, file_info,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+				  CIFS_MOUNT_MAP_SPECIAL_CHR);
+	kfree(file_info);
+	return rc;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -454,6 +478,7 @@ struct smb_version_operations smb1_operations = {
 	.tree_disconnect = CIFSSMBTDis,
 	.get_dfs_refer = cifs_get_dfs_refer,
 	.qfs_tcon = cifs_qfs_tcon,
+	.is_path_accessible = cifs_is_path_accessible,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
