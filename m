From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1 4/6] fs/cifs: add build_path_from_dentry_optional_prefix()
Date: Tue,  8 Nov 2016 17:33:24 +0100
Message-ID: <1478622806-19636-5-git-send-email-aaptel@suse.com>
References: <1478622806-19636-1-git-send-email-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478622806-19636-1-git-send-email-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

this function does the same thing as add build_path_from_dentry() but
takes a boolean parameter to decide whether or not to prefix the path
with the tree name.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/dir.c       | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index ced0e42..76fab56 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -61,6 +61,7 @@ extern void exit_cifs_idmap(void);
 extern int init_cifs_spnego(void);
 extern void exit_cifs_spnego(void);
 extern char *build_path_from_dentry(struct dentry *);
+extern char *build_path_from_dentry_optional_prefix(struct dentry *direntry, int prefix);
 extern char *cifs_build_path_to_root(struct smb_vol *vol,
 				     struct cifs_sb_info *cifs_sb,
 				     struct cifs_tcon *tcon);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 789ff1d..b92e676 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -79,7 +79,15 @@ cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 
 /* Note: caller must free return buffer */
 char *
-build_path_from_dentry(struct dentry *direntry)
+build_path_from_dentry(struct dentry *direntry) {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	return build_path_from_dentry_optional_prefix(direntry,
+						      tcon->Flags & SMB_SHARE_IS_IN_DFS);
+}
+
+char *
+build_path_from_dentry_optional_prefix(struct dentry *direntry, int prefix)
 {
 	struct dentry *temp;
 	int namelen;
@@ -92,7 +100,7 @@ build_path_from_dentry(struct dentry *direntry)
 	unsigned seq;
 
 	dirsep = CIFS_DIR_SEP(cifs_sb);
-	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
+	if (prefix)
 		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
 	else
 		dfsplen = 0;
-- 
2.1.4
