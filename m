From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Fix regression which breaks DFS mounting
Date: Tue,  6 Sep 2016 13:22:34 +0100
Message-ID: <1473164554-8062-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Patch a6b5058 results in -EREMOTE returned by is_path_accessible() in
cifs_mount() to be ignored which breaks DFS mounting.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7ae0328..9878943 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3661,14 +3661,16 @@ remote_path_check:
 			goto mount_fail_check;
 		}
 
-		rc = cifs_are_all_path_components_accessible(server,
+		if (rc != -EREMOTE) {
+			rc = cifs_are_all_path_components_accessible(server,
 							     xid, tcon, cifs_sb,
 							     full_path);
-		if (rc != 0) {
-			cifs_dbg(VFS, "cannot query dirs between root and final path, "
-				 "enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
-			cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
-			rc = 0;
+			if (rc != 0) {
+				cifs_dbg(VFS, "cannot query dirs between root and final path, "
+					 "enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
+				cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+				rc = 0;
+			}
 		}
 		kfree(full_path);
 	}
-- 
2.5.5
