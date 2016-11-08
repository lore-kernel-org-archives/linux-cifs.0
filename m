From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1 5/6] fs/cifs: always use tree name prefix for DFS resolving
Date: Tue,  8 Nov 2016 17:33:25 +0100
Message-ID: <1478622806-19636-6-git-send-email-aaptel@suse.com>
References: <1478622806-19636-1-git-send-email-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478622806-19636-1-git-send-email-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

for some reason the tcon used in build_path_from_dentry for that mount
point doesn't have the the "IN DFS" flag set so the prefix was not
always added even though it is required in this case.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifs_dfs_ref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index ec9dbbc..141a418 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -302,7 +302,7 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	 * gives us the latter, so we must adjust the result.
 	 */
 	mnt = ERR_PTR(-ENOMEM);
-	full_path = build_path_from_dentry(mntpt);
+	full_path = build_path_from_dentry_optional_prefix(mntpt, 1 /* always use tree name prefix */);
 	if (full_path == NULL)
 		goto cdda_exit;
 
-- 
2.1.4
