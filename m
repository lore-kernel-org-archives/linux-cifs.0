From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1 6/6] fs/cifs: enable get_dfs_refer operation for smb2+
Date: Tue,  8 Nov 2016 17:33:26 +0100
Message-ID: <1478622806-19636-7-git-send-email-aaptel@suse.com>
References: <1478622806-19636-1-git-send-email-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478622806-19636-1-git-send-email-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/smb2ops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 677579b..1712d42 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1829,6 +1829,7 @@ struct smb_version_operations smb20_operations = {
 	.clone_range = smb2_clone_range,
 	.wp_retry_size = smb2_wp_retry_size,
 	.dir_needs_close = smb2_dir_needs_close,
+	.get_dfs_refer = smb2_get_dfs_refer,
 };
 
 struct smb_version_operations smb21_operations = {
@@ -1910,6 +1911,7 @@ struct smb_version_operations smb21_operations = {
 	.wp_retry_size = smb2_wp_retry_size,
 	.dir_needs_close = smb2_dir_needs_close,
 	.enum_snapshots = smb3_enum_snapshots,
+	.get_dfs_refer = smb2_get_dfs_refer,
 };
 
 struct smb_version_operations smb30_operations = {
@@ -1997,6 +1999,7 @@ struct smb_version_operations smb30_operations = {
 	.dir_needs_close = smb2_dir_needs_close,
 	.fallocate = smb3_fallocate,
 	.enum_snapshots = smb3_enum_snapshots,
+	.get_dfs_refer = smb2_get_dfs_refer,
 };
 
 #ifdef CONFIG_CIFS_SMB311
@@ -2085,6 +2088,7 @@ struct smb_version_operations smb311_operations = {
 	.dir_needs_close = smb2_dir_needs_close,
 	.fallocate = smb3_fallocate,
 	.enum_snapshots = smb3_enum_snapshots,
+	.get_dfs_refer = smb2_get_dfs_refer,
 };
 #endif /* CIFS_SMB311 */
 
-- 
2.1.4
