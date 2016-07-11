From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Add MF-Symlinks support for SMB 2.0
Date: Mon, 11 Jul 2016 16:53:20 +0100
Message-ID: <1468252400-6814-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We should be able to use the same helper functions used for SMB 2.1 and
later versions.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3525ed7..527d1ac 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1515,6 +1515,8 @@ struct smb_version_operations smb20_operations = {
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
 	.query_symlink = smb2_query_symlink,
+	.query_mf_symlink = smb3_query_mf_symlink,
+	.create_mf_symlink = smb3_create_mf_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
-- 
2.5.5
