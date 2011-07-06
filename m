From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] cifs: fix build_unc_path_to_root to account for a prefixpath
Date: Wed,  6 Jul 2011 08:10:36 -0400
Message-ID: <1309954239-17345-2-git-send-email-jlayton@redhat.com>
References: <1309954239-17345-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309954239-17345-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Regression introduced by commit f87d39d9513.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 545e854..44376ce 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2855,19 +2855,28 @@ cifs_cleanup_volume_info(struct smb_vol **pvolume_info)
 /* build_path_to_root returns full path to root when
  * we do not have an exiting connection (tcon) */
 static char *
-build_unc_path_to_root(const struct smb_vol *volume_info,
+build_unc_path_to_root(const struct smb_vol *vol,
 		const struct cifs_sb_info *cifs_sb)
 {
-	char *full_path;
+	char *full_path, *pos;
+	unsigned int pplen = vol->prepath ? strlen(vol->prepath) : 0;
+	unsigned int unc_len = strnlen(vol->UNC, MAX_TREE_SIZE + 1);
 
-	int unc_len = strnlen(volume_info->UNC, MAX_TREE_SIZE + 1);
-	full_path = kmalloc(unc_len + 1, GFP_KERNEL);
+	full_path = kmalloc(unc_len + pplen + 1, GFP_KERNEL);
 	if (full_path == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	strncpy(full_path, volume_info->UNC, unc_len);
-	full_path[unc_len] = 0; /* add trailing null */
+	strncpy(full_path, vol->UNC, unc_len);
+	pos = full_path + unc_len;
+
+	if (pplen) {
+		strncpy(pos, vol->prepath, pplen);
+		pos += pplen;
+	}
+
+	*pos = '\0'; /* add trailing null */
 	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
+	cFYI(1, "%s: full_path=%s", __func__, full_path);
 	return full_path;
 }
 
-- 
1.7.6
