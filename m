From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 25/32] CIFS: Move building path to root to ops struct
Date: Fri, 13 Jul 2012 11:53:38 +0400
Message-ID: <1342166025-29377-26-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsfs.c    |    4 ++--
 fs/cifs/cifsglob.h  |   13 +++++++++++++
 fs/cifs/cifsproto.h |    3 ---
 fs/cifs/connect.c   |    2 +-
 fs/cifs/inode.c     |   32 --------------------------------
 fs/cifs/smb1ops.c   |   32 ++++++++++++++++++++++++++++++++
 6 files changed, 48 insertions(+), 38 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5cf9299..54d8b13 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -549,8 +549,8 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 	char *s, *p;
 	char sep;
 
-	full_path = cifs_build_path_to_root(vol, cifs_sb,
-					    cifs_sb_master_tcon(cifs_sb));
+	full_path = build_path_to_root(vol, cifs_sb,
+				       cifs_sb_master_tcon(cifs_sb));
 	if (full_path == NULL)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2b12345..340dce0 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -164,6 +164,7 @@ struct cifs_ses;
 struct cifs_tcon;
 struct dfs_info3_param;
 struct cifs_fattr;
+struct smb_vol;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
@@ -227,6 +228,9 @@ struct smb_version_operations {
 	int (*get_srv_inum)(const unsigned int, struct cifs_tcon *,
 			    struct cifs_sb_info *, const char *,
 			    u64 *uniqueid, FILE_ALL_INFO *);
+	/* build a full path to the root of the mount */
+	char * (*build_path_to_root)(struct smb_vol *, struct cifs_sb_info *,
+				     struct cifs_tcon *);
 };
 
 struct smb_version_values {
@@ -803,6 +807,15 @@ convert_delimiter(char *path, char delim)
 	}
 }
 
+static inline char *
+build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
+		   struct cifs_tcon *tcon)
+{
+	if (!vol->ops->build_path_to_root)
+		return NULL;
+	return vol->ops->build_path_to_root(vol, cifs_sb, tcon);
+}
+
 #ifdef CONFIG_CIFS_STATS
 #define cifs_stats_inc atomic_inc
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 644adce..8836c7b 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -57,9 +57,6 @@ extern int init_cifs_idmap(void);
 extern void exit_cifs_idmap(void);
 extern void cifs_destroy_idmaptrees(void);
 extern char *build_path_from_dentry(struct dentry *);
-extern char *cifs_build_path_to_root(struct smb_vol *vol,
-				     struct cifs_sb_info *cifs_sb,
-				     struct cifs_tcon *tcon);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 extern char *cifs_compose_mount_options(const char *sb_mountdata,
 		const char *fullpath, const struct dfs_info3_param *ref,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9c9ec77..d757427 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3683,7 +3683,7 @@ remote_path_check:
 			goto mount_fail_check;
 		}
 		/* build_path_to_root works only when we have a valid tcon */
-		full_path = cifs_build_path_to_root(volume_info, cifs_sb, tcon);
+		full_path = build_path_to_root(volume_info, cifs_sb, tcon);
 		if (full_path == NULL) {
 			rc = -ENOMEM;
 			goto mount_fail_check;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index df071fb..def1006 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -731,38 +731,6 @@ static const struct inode_operations cifs_ipc_inode_ops = {
 	.lookup = cifs_lookup,
 };
 
-char *cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
-			      struct cifs_tcon *tcon)
-{
-	int pplen = vol->prepath ? strlen(vol->prepath) : 0;
-	int dfsplen;
-	char *full_path = NULL;
-
-	/* if no prefix path, simply set path to the root of share to "" */
-	if (pplen == 0) {
-		full_path = kmalloc(1, GFP_KERNEL);
-		if (full_path)
-			full_path[0] = 0;
-		return full_path;
-	}
-
-	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
-		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
-	else
-		dfsplen = 0;
-
-	full_path = kmalloc(dfsplen + pplen + 1, GFP_KERNEL);
-	if (full_path == NULL)
-		return full_path;
-
-	if (dfsplen)
-		strncpy(full_path, tcon->treeName, dfsplen);
-	strncpy(full_path + dfsplen, vol->prepath, pplen);
-	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
-	full_path[dfsplen + pplen] = 0; /* add trailing null */
-	return full_path;
-}
-
 static int
 cifs_find_inode(struct inode *inode, void *opaque)
 {
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index fa21001..7195fad 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -489,6 +489,37 @@ cifs_get_srv_inum(const unsigned int xid, struct cifs_tcon *tcon,
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 }
 
+static char *
+cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
+			struct cifs_tcon *tcon)
+{
+	int pplen = vol->prepath ? strlen(vol->prepath) : 0;
+	int dfsplen;
+	char *full_path = NULL;
+
+	/* if no prefix path, simply set path to the root of share to "" */
+	if (pplen == 0) {
+		full_path = kzalloc(1, GFP_KERNEL);
+		return full_path;
+	}
+
+	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
+		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
+	else
+		dfsplen = 0;
+
+	full_path = kmalloc(dfsplen + pplen + 1, GFP_KERNEL);
+	if (full_path == NULL)
+		return full_path;
+
+	if (dfsplen)
+		strncpy(full_path, tcon->treeName, dfsplen);
+	strncpy(full_path + dfsplen, vol->prepath, pplen);
+	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
+	full_path[dfsplen + pplen] = 0; /* add trailing null */
+	return full_path;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -518,6 +549,7 @@ struct smb_version_operations smb1_operations = {
 	.is_path_accessible = cifs_is_path_accessible,
 	.query_path_info = cifs_query_path_info,
 	.get_srv_inum = cifs_get_srv_inum,
+	.build_path_to_root = cifs_build_path_to_root,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
