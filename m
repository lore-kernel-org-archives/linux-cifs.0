From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] Compare prepaths when comparing superblocks
Date: Fri, 29 Jul 2016 22:38:20 +0100
Message-ID: <1469828301-9937-3-git-send-email-sprabhu@redhat.com>
References: <1469828301-9937-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	=?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469828301-9937-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The patch
fs/cifs: make share unaccessible at root level mountable
makes use of prepaths when any component of the underlying path is
inaccessible.

When mounting 2 separate shares having different prepaths but are other
wise similar in other respects, we end up sharing superblocks when we
shouldn't be doing so.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4546926..2e4f4ba 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2781,6 +2781,24 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 	return 1;
 }
 
+static int
+match_prepath(struct super_block *sb, struct cifs_mnt_data *mnt_data)
+{
+	struct cifs_sb_info *old = CIFS_SB(sb);
+	struct cifs_sb_info *new = mnt_data->cifs_sb;
+
+	if (old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) {
+		if (!(new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH))
+			return 0;
+		/* The prepath should be null terminated strings */
+		if (strcmp(new->prepath, old->prepath))
+			return 0;
+
+		return 1;
+	}
+	return 0;
+}
+
 int
 cifs_match_super(struct super_block *sb, void *data)
 {
@@ -2808,7 +2826,8 @@ cifs_match_super(struct super_block *sb, void *data)
 
 	if (!match_server(tcp_srv, volume_info) ||
 	    !match_session(ses, volume_info) ||
-	    !match_tcon(tcon, volume_info->UNC)) {
+	    !match_tcon(tcon, volume_info->UNC) ||
+	    !match_prepath(sb, mnt_data)) {
 		rc = 0;
 		goto out;
 	}
-- 
2.5.5
