From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] Move check for prefix path to within cifs_get_root()
Date: Fri, 29 Jul 2016 22:38:21 +0100
Message-ID: <1469828301-9937-4-git-send-email-sprabhu@redhat.com>
References: <1469828301-9937-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	=?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469828301-9937-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index cc9cdab..14ae4b8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -609,6 +609,9 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 	char *s, *p;
 	char sep;
 
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+		return dget(sb->s_root);
+
 	full_path = cifs_build_path_to_root(vol, cifs_sb,
 					    cifs_sb_master_tcon(cifs_sb));
 	if (full_path == NULL)
@@ -731,11 +734,7 @@ cifs_do_mount(struct file_system_type *fs_type,
 		sb->s_flags |= MS_ACTIVE;
 	}
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
-		root = dget(sb->s_root);
-	else
-		root = cifs_get_root(volume_info, sb);
-
+	root = cifs_get_root(volume_info, sb);
 	if (IS_ERR(root))
 		goto out_super;
 
-- 
2.5.5
