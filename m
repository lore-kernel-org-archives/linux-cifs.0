From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
Date: Mon, 22 Oct 2012 00:01:10 -0500
Message-ID: <1350882070-6620-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f5af252..26d65c7 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1251,6 +1251,7 @@ struct dfs_info3_param {
 #define CIFS_FATTR_DELETE_PENDING	0x2
 #define CIFS_FATTR_NEED_REVAL		0x4
 #define CIFS_FATTR_INO_COLLISION	0x8
+#define CIFS_FATTR_ALTDATASTR		0x10
 
 struct cifs_fattr {
 	u32		cf_flags;
@@ -1268,6 +1269,7 @@ struct cifs_fattr {
 	struct timespec	cf_atime;
 	struct timespec	cf_mtime;
 	struct timespec	cf_ctime;
+	char		*cf_private;
 };
 
 static inline void free_dfs_info_param(struct dfs_info3_param *param)
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index afdff79..201ec46 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -615,10 +615,12 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	char *buf = NULL;
+	char *altstr = NULL;
 	bool adjust_tz = false;
 	struct cifs_fattr fattr;
 	struct cifs_search_info *srchinf = NULL;
 
+	fattr.cf_private = NULL;
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
@@ -746,14 +748,34 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	}
 
 	if (!*inode) {
+		altstr = strchr(full_path, ':');
+		if (altstr) {
+			fattr.cf_private = kstrdup(altstr, GFP_KERNEL);
+			if (!fattr.cf_private) {
+				rc = -ENOMEM;
+				goto cgii_exit;
+			}
+			fattr.cf_flags |= CIFS_FATTR_ALTDATASTR;
+		}
+
 		*inode = cifs_iget(sb, &fattr);
-		if (!*inode)
+		if (*inode) {
+			if (altstr && !((*inode)->i_flags & S_PRIVATE)) {
+				(*inode)->i_private =
+					kstrdup(altstr, GFP_KERNEL);
+				if ((*inode)->i_private)
+					(*inode)->i_flags |= S_PRIVATE;
+				else
+					rc = -ENOMEM;
+			}
+		} else
 			rc = -ENOMEM;
 	} else {
 		cifs_fattr_to_inode(*inode, &fattr);
 	}
 
 cgii_exit:
+	kfree(fattr.cf_private);
 	kfree(buf);
 	cifs_put_tlink(tlink);
 	return rc;
@@ -784,6 +806,16 @@ cifs_find_inode(struct inode *inode, void *opaque)
 	if (S_ISDIR(inode->i_mode) && !hlist_empty(&inode->i_dentry))
 		fattr->cf_flags |= CIFS_FATTR_INO_COLLISION;
 
+	/* looking for an inode of a alternate data stream (full pathname) */
+	if (fattr->cf_flags & CIFS_FATTR_ALTDATASTR) {
+		if (!(inode->i_flags & S_PRIVATE)) {
+			return 0;
+		} else {
+			if (strcmp(inode->i_private, fattr->cf_private))
+				return 0;
+		}
+	}
+
 	return 1;
 }
 
