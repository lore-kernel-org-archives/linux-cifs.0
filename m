From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Fix match_prepath()
Date: Wed, 26 Apr 2017 14:05:46 +0100
Message-ID: <20170426130546.4493-1-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Incorrect return value for shares not using the prefix patch means that
we will never match superblocks for these shares.

Fixes: commit c1d8b24d1819 ("Compare prepaths when comparing superblocks")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d82467c..d95744d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2912,16 +2912,14 @@ match_prepath(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
+	bool old_set = old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
+	bool new_set = new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
 
-	if (old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) {
-		if (!(new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH))
-			return 0;
-		/* The prepath should be null terminated strings */
-		if (strcmp(new->prepath, old->prepath))
-			return 0;
-
+	if (old_set && new_set && !strcmp(new->prepath, old->prepath))
 		return 1;
-	}
+	else if (!old_set && !new_set)
+		return 1;
+
 	return 0;
 }
 
-- 
2.9.3
