From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2 2/6] CIFS: add build_path_from_dentry_optional_prefix()
Date: Thu, 23 Feb 2017 15:43:30 +0100
Message-ID: <20170223144334.22320-3-aaptel@suse.com>
References: <20170223144334.22320-1-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170223144334.22320-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

this function does the same thing as add build_path_from_dentry() but
takes a boolean parameter to decide whether or not to prefix the path
with the tree name.

we cannot rely on tcon->Flags & SMB_SHARE_IS_IN_DFS for SMB2 as smb2
code never sets tcon->Flags but it sets tcon->share_flags and it seems
the SMB_SHARE_IS_IN_DFS has different semantics in SMB2: the prefix
shouldn't be added everytime it was in SMB1.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifs_dfs_ref.c |  4 +++-
 fs/cifs/cifsproto.h    |  2 ++
 fs/cifs/dir.c          | 13 ++++++++++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index ec9dbbc..8a9ebfd 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -302,7 +302,9 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	 * gives us the latter, so we must adjust the result.
 	 */
 	mnt = ERR_PTR(-ENOMEM);
-	full_path = build_path_from_dentry(mntpt);
+
+	/* always use tree name prefix */
+	full_path = build_path_from_dentry_optional_prefix(mntpt, true);
 	if (full_path == NULL)
 		goto cdda_exit;
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c097830..9ee46c1 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -61,6 +61,8 @@ extern void exit_cifs_idmap(void);
 extern int init_cifs_spnego(void);
 extern void exit_cifs_spnego(void);
 extern char *build_path_from_dentry(struct dentry *);
+extern char *build_path_from_dentry_optional_prefix(struct dentry *direntry,
+						    bool prefix);
 extern char *cifs_build_path_to_root(struct smb_vol *vol,
 				     struct cifs_sb_info *cifs_sb,
 				     struct cifs_tcon *tcon,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 2c227a9..56366e9 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -81,6 +81,17 @@ cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 char *
 build_path_from_dentry(struct dentry *direntry)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	bool prefix = tcon->Flags & SMB_SHARE_IS_IN_DFS;
+
+	return build_path_from_dentry_optional_prefix(direntry,
+						      prefix);
+}
+
+char *
+build_path_from_dentry_optional_prefix(struct dentry *direntry, bool prefix)
+{
 	struct dentry *temp;
 	int namelen;
 	int dfsplen;
@@ -92,7 +103,7 @@ build_path_from_dentry(struct dentry *direntry)
 	unsigned seq;
 
 	dirsep = CIFS_DIR_SEP(cifs_sb);
-	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
+	if (prefix)
 		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
 	else
 		dfsplen = 0;
-- 
2.10.2
