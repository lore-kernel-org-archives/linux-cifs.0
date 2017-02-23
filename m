From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2 6/6] CIFS: enable get_dfs_refer for SMB2+
Date: Thu, 23 Feb 2017 15:43:34 +0100
Message-ID: <20170223144334.22320-7-aaptel@suse.com>
References: <20170223144334.22320-1-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170223144334.22320-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add the newly defined operation to the relevant structures.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/smb2ops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 2563fe8..1537cc8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2326,6 +2326,7 @@ struct smb_version_operations smb20_operations = {
 	.clone_range = smb2_clone_range,
 	.wp_retry_size = smb2_wp_retry_size,
 	.dir_needs_close = smb2_dir_needs_close,
+	.get_dfs_refer = smb2_get_dfs_refer,
 };
 
 struct smb_version_operations smb21_operations = {
@@ -2407,6 +2408,7 @@ struct smb_version_operations smb21_operations = {
 	.wp_retry_size = smb2_wp_retry_size,
 	.dir_needs_close = smb2_dir_needs_close,
 	.enum_snapshots = smb3_enum_snapshots,
+	.get_dfs_refer = smb2_get_dfs_refer,
 };
 
 struct smb_version_operations smb30_operations = {
@@ -2498,6 +2500,7 @@ struct smb_version_operations smb30_operations = {
 	.free_transform_rq = smb3_free_transform_rq,
 	.is_transform_hdr = smb3_is_transform_hdr,
 	.receive_transform = smb3_receive_transform,
+	.get_dfs_refer = smb2_get_dfs_refer,
 };
 
 #ifdef CONFIG_CIFS_SMB311
@@ -2590,6 +2593,7 @@ struct smb_version_operations smb311_operations = {
 	.free_transform_rq = smb3_free_transform_rq,
 	.is_transform_hdr = smb3_is_transform_hdr,
 	.receive_transform = smb3_receive_transform,
+	.get_dfs_refer = smb2_get_dfs_refer,
 };
 #endif /* CIFS_SMB311 */
 
-- 
2.10.2
