From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [v3 3/4] CIFS: Migrate from prefixpath logic
Date: Wed, 25 May 2011 23:12:28 +0400
Message-ID: <1306350749-28975-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now we point superblock to a server share root and set a root dentry
appropriately. This let us share superblock between mounts like
//server/sharename/foo/bar and //server/sharename/foo further.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    2 -
 fs/cifs/cifsfs.c     |  103 +++++++++++++++++++++++++++++++++++++++-
 fs/cifs/cifsglob.h   |   75 +++++++++++++++++++++++++++++
 fs/cifs/cifsproto.h  |    5 +-
 fs/cifs/connect.c    |  128 ++------------------------------------------------
 fs/cifs/dir.c        |    7 +--
 fs/cifs/inode.c      |   19 ++-----
 7 files changed, 191 insertions(+), 148 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index a9d5692..c96b44b 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -56,8 +56,6 @@ struct cifs_sb_info {
 	mode_t	mnt_file_mode;
 	mode_t	mnt_dir_mode;
 	unsigned int mnt_cifs_flags;
-	int	prepathlen;
-	char   *prepath; /* relative path under the share to mount to */
 	char   *mountdata; /* options received at mount time or via DFS refs */
 	struct backing_dev_info bdi;
 	struct delayed_work prune_tlinks;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d1ed7f9..b7dbb26 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -415,8 +415,6 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 		seq_printf(s, ",nocase");
 	if (tcon->retry)
 		seq_printf(s, ",hard");
-	if (cifs_sb->prepath)
-		seq_printf(s, ",prepath=%s", cifs_sb->prepath);
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
 		seq_printf(s, ",posixpaths");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)
@@ -530,6 +528,100 @@ static const struct super_operations cifs_super_ops = {
 #endif
 };
 
+/*
+ * Get root dentry from superblock according to prefix path mount option.
+ * Return dentry with refcount + 1 on success and NULL otherwise.
+ */
+static struct dentry *
+cifs_get_root(struct smb_vol *vol, struct super_block *sb)
+{
+	int xid, rc;
+	struct inode *inode;
+	struct qstr name;
+	struct dentry *dparent = NULL, *dchild = NULL, *alias;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	unsigned int i, full_len, len;
+	char *full_path = NULL, *pstart;
+	char sep;
+
+	full_path = cifs_build_path_to_root(vol, cifs_sb,
+					    cifs_sb_master_tcon(cifs_sb));
+	if (full_path == NULL)
+		return NULL;
+
+	cFYI(1, "Get root dentry for %s", full_path);
+
+	xid = GetXid();
+	sep = CIFS_DIR_SEP(cifs_sb);
+	dparent = dget(sb->s_root);
+	full_len = strlen(full_path);
+	full_path[full_len] = sep;
+	pstart = full_path + 1;
+
+	for (i = 1, len = 0; i <= full_len; i++) {
+		if (full_path[i] != sep || !len) {
+			len++;
+			continue;
+		}
+
+		full_path[i] = 0;
+		cFYI(1, "get dentry for %s", pstart);
+
+		name.name = pstart;
+		name.len = len;
+		name.hash = full_name_hash(pstart, len);
+		dchild = d_lookup(dparent, &name);
+		if (dchild == NULL) {
+			cFYI(1, "not exists");
+			dchild = d_alloc(dparent, &name);
+			if (dchild == NULL) {
+				dput(dparent);
+				dparent = NULL;
+				goto out;
+			}
+		}
+
+		cFYI(1, "get inode");
+		if (dchild->d_inode == NULL) {
+			cFYI(1, "not exists");
+			inode = NULL;
+			if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
+				rc = cifs_get_inode_info_unix(&inode, full_path,
+							      sb, xid);
+			else
+				rc = cifs_get_inode_info(&inode, full_path,
+							 NULL, sb, xid, NULL);
+			if (rc) {
+				dput(dchild);
+				dput(dparent);
+				dparent = NULL;
+				goto out;
+			}
+			alias = d_materialise_unique(dchild, inode);
+			if (alias != NULL) {
+				dput(dchild);
+				if (IS_ERR(alias)) {
+					dput(dparent);
+					dparent = NULL;
+					goto out;
+				}
+				dchild = alias;
+			}
+		}
+		cFYI(1, "parent %p, child %p", dparent, dchild);
+
+		dput(dparent);
+		dparent = dchild;
+		len = 0;
+		pstart = full_path + i + 1;
+		full_path[i] = sep;
+	}
+out:
+	_FreeXid(xid);
+	kfree(full_path);
+	return dparent;
+}
+
 static struct dentry *
 cifs_do_mount(struct file_system_type *fs_type,
 	      int flags, const char *dev_name, void *data)
@@ -586,7 +678,12 @@ cifs_do_mount(struct file_system_type *fs_type,
 
 	sb->s_flags |= MS_ACTIVE;
 
-	root = dget(sb->s_root);
+	root = cifs_get_root(volume_info, sb);
+	if (root == NULL) {
+		kfree(copied_data);
+		goto err_out;
+	}
+	cFYI(1, "dentry root is: %p", root);
 out:
 	cifs_cleanup_volume_info(&volume_info);
 	return root;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index fd877c1..f57387a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -155,6 +155,61 @@ struct cifs_cred {
  *****************************************************************
  */
 
+struct smb_vol {
+	char *username;
+	char *password;
+	char *domainname;
+	char *UNC;
+	char *UNCip;
+	char *iocharset;  /* local code page for mapping to and from Unicode */
+	char source_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* clnt nb name */
+	char target_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* srvr nb name */
+	uid_t cred_uid;
+	uid_t linux_uid;
+	gid_t linux_gid;
+	mode_t file_mode;
+	mode_t dir_mode;
+	unsigned secFlg;
+	bool retry:1;
+	bool intr:1;
+	bool setuids:1;
+	bool override_uid:1;
+	bool override_gid:1;
+	bool dynperm:1;
+	bool noperm:1;
+	bool no_psx_acl:1; /* set if posix acl support should be disabled */
+	bool cifs_acl:1;
+	bool no_xattr:1;   /* set if xattr (EA) support should be disabled*/
+	bool server_ino:1; /* use inode numbers from server ie UniqueId */
+	bool direct_io:1;
+	bool strict_io:1; /* strict cache behavior */
+	bool remap:1;      /* set to remap seven reserved chars in filenames */
+	bool posix_paths:1; /* unset to not ask for posix pathnames. */
+	bool no_linux_ext:1;
+	bool sfu_emul:1;
+	bool nullauth:1;   /* attempt to authenticate with null user */
+	bool nocase:1;     /* request case insensitive filenames */
+	bool nobrl:1;      /* disable sending byte range locks to srv */
+	bool mand_lock:1;  /* send mandatory not posix byte range lock reqs */
+	bool seal:1;       /* request transport encryption on share */
+	bool nodfs:1;      /* Do not request DFS, even if available */
+	bool local_lease:1; /* check leases only on local system, not remote */
+	bool noblocksnd:1;
+	bool noautotune:1;
+	bool nostrictsync:1; /* do not force expensive SMBflush on every sync */
+	bool fsc:1;	/* enable fscache */
+	bool mfsymlinks:1; /* use Minshall+French Symlinks */
+	bool multiuser:1;
+	unsigned int rsize;
+	unsigned int wsize;
+	bool sockopt_tcp_nodelay:1;
+	unsigned short int port;
+	unsigned long actimeo; /* attribute cache timeout (jiffies) */
+	char *prepath;
+	struct sockaddr_storage srcaddr; /* allow binding to a local IP */
+	struct nls_table *local_nls;
+};
+
 struct TCP_Server_Info {
 	struct list_head tcp_ses_list;
 	struct list_head smb_ses_list;
@@ -509,6 +564,26 @@ static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 		return '\\';
 }
 
+static inline void
+convert_delimiter(char *path, char delim)
+{
+	int i;
+	char old_delim;
+
+	if (path == NULL)
+		return;
+
+	if (delim == '/')
+		old_delim = '\\';
+	else
+		old_delim = '/';
+
+	for (i = 0; path[i] != '\0'; i++) {
+		if (path[i] == old_delim)
+			path[i] = delim;
+	}
+}
+
 #ifdef CONFIG_CIFS_STATS
 #define cifs_stats_inc atomic_inc
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index fdc0dc2..6154b5c 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -57,8 +57,9 @@ extern int init_cifs_idmap(void);
 extern void exit_cifs_idmap(void);
 extern void cifs_destroy_idmaptrees(void);
 extern char *build_path_from_dentry(struct dentry *);
-extern char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb,
-					struct cifsTconInfo *tcon);
+extern char *cifs_build_path_to_root(struct smb_vol *vol,
+				     struct cifs_sb_info *cifs_sb,
+				     struct cifsTconInfo *tcon);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 extern char *cifs_compose_mount_options(const char *sb_mountdata,
 		const char *fullpath, const struct dfs_info3_param *ref,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6070ba6..6d567b6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -57,61 +57,6 @@
 
 extern mempool_t *cifs_req_poolp;
 
-struct smb_vol {
-	char *username;
-	char *password;
-	char *domainname;
-	char *UNC;
-	char *UNCip;
-	char *iocharset;  /* local code page for mapping to and from Unicode */
-	char source_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* clnt nb name */
-	char target_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* srvr nb name */
-	uid_t cred_uid;
-	uid_t linux_uid;
-	gid_t linux_gid;
-	mode_t file_mode;
-	mode_t dir_mode;
-	unsigned secFlg;
-	bool retry:1;
-	bool intr:1;
-	bool setuids:1;
-	bool override_uid:1;
-	bool override_gid:1;
-	bool dynperm:1;
-	bool noperm:1;
-	bool no_psx_acl:1; /* set if posix acl support should be disabled */
-	bool cifs_acl:1;
-	bool no_xattr:1;   /* set if xattr (EA) support should be disabled*/
-	bool server_ino:1; /* use inode numbers from server ie UniqueId */
-	bool direct_io:1;
-	bool strict_io:1; /* strict cache behavior */
-	bool remap:1;      /* set to remap seven reserved chars in filenames */
-	bool posix_paths:1; /* unset to not ask for posix pathnames. */
-	bool no_linux_ext:1;
-	bool sfu_emul:1;
-	bool nullauth:1;   /* attempt to authenticate with null user */
-	bool nocase:1;     /* request case insensitive filenames */
-	bool nobrl:1;      /* disable sending byte range locks to srv */
-	bool mand_lock:1;  /* send mandatory not posix byte range lock reqs */
-	bool seal:1;       /* request transport encryption on share */
-	bool nodfs:1;      /* Do not request DFS, even if available */
-	bool local_lease:1; /* check leases only on local system, not remote */
-	bool noblocksnd:1;
-	bool noautotune:1;
-	bool nostrictsync:1; /* do not force expensive SMBflush on every sync */
-	bool fsc:1;	/* enable fscache */
-	bool mfsymlinks:1; /* use Minshall+French Symlinks */
-	bool multiuser:1;
-	unsigned int rsize;
-	unsigned int wsize;
-	bool sockopt_tcp_nodelay:1;
-	unsigned short int port;
-	unsigned long actimeo; /* attribute cache timeout (jiffies) */
-	char *prepath;
-	struct sockaddr_storage srcaddr; /* allow binding to a local IP */
-	struct nls_table *local_nls;
-};
-
 /* FIXME: should these be tunable? */
 #define TLINK_ERROR_EXPIRE	(1 * HZ)
 #define TLINK_IDLE_EXPIRE	(600 * HZ)
@@ -2566,12 +2511,6 @@ void reset_cifs_unix_caps(int xid, struct cifsTconInfo *tcon,
 					CIFS_MOUNT_POSIX_PATHS;
 		}
 
-		/* We might be setting the path sep back to a different
-		form if we are reconnecting and the server switched its
-		posix path capability for this share */
-		if (sb && (CIFS_SB(sb)->prepathlen > 0))
-			CIFS_SB(sb)->prepath[0] = CIFS_DIR_SEP(CIFS_SB(sb));
-
 		if (sb && (CIFS_SB(sb)->rsize > 127 * 1024)) {
 			if ((cap & CIFS_UNIX_LARGE_READ_CAP) == 0) {
 				CIFS_SB(sb)->rsize = 127 * 1024;
@@ -2612,26 +2551,6 @@ void reset_cifs_unix_caps(int xid, struct cifsTconInfo *tcon,
 	}
 }
 
-static void
-convert_delimiter(char *path, char delim)
-{
-	int i;
-	char old_delim;
-
-	if (path == NULL)
-		return;
-
-	if (delim == '/')
-		old_delim = '\\';
-	else
-		old_delim = '/';
-
-	for (i = 0; path[i] != '\0'; i++) {
-		if (path[i] == old_delim)
-			path[i] = delim;
-	}
-}
-
 void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			struct cifs_sb_info *cifs_sb)
 {
@@ -2669,18 +2588,6 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 		/* Windows ME may prefer this */
 		cFYI(1, "readsize set to minimum: 2048");
 	}
-	/* calculate prepath */
-	cifs_sb->prepath = pvolume_info->prepath;
-	if (cifs_sb->prepath) {
-		cifs_sb->prepathlen = strlen(cifs_sb->prepath);
-		/* we can not convert the / to \ in the path
-		separators in the prefixpath yet because we do not
-		know (until reset_cifs_unix_caps is called later)
-		whether POSIX PATH CAP is available. We normalize
-		the / to \ after reset_cifs_unix_caps is called */
-		pvolume_info->prepath = NULL;
-	} else
-		cifs_sb->prepathlen = 0;
 	cifs_sb->mnt_uid = pvolume_info->linux_uid;
 	cifs_sb->mnt_gid = pvolume_info->linux_gid;
 	cifs_sb->mnt_file_mode = pvolume_info->file_mode;
@@ -2797,24 +2704,13 @@ build_unc_path_to_root(const struct smb_vol *volume_info,
 	char *full_path;
 
 	int unc_len = strnlen(volume_info->UNC, MAX_TREE_SIZE + 1);
-	full_path = kmalloc(unc_len + cifs_sb->prepathlen + 1, GFP_KERNEL);
+	full_path = kmalloc(unc_len + 1, GFP_KERNEL);
 	if (full_path == NULL)
 		return ERR_PTR(-ENOMEM);
 
 	strncpy(full_path, volume_info->UNC, unc_len);
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
-		int i;
-		for (i = 0; i < unc_len; i++) {
-			if (full_path[i] == '\\')
-				full_path[i] = '/';
-		}
-	}
-
-	if (cifs_sb->prepathlen)
-		strncpy(full_path + unc_len, cifs_sb->prepath,
-				cifs_sb->prepathlen);
-
-	full_path[unc_len + cifs_sb->prepathlen] = 0; /* add trailing null */
+	full_path[unc_len] = 0; /* add trailing null */
+	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
 	return full_path;
 }
 
@@ -3006,10 +2902,6 @@ try_mount_again:
 	else
 		tcon->unix_ext = 0; /* server does not support them */
 
-	/* convert forward to back slashes in prepath here if needed */
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) == 0)
-		convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb));
-
 	if ((tcon->unix_ext == 0) && (cifs_sb->rsize > (1024 * 127))) {
 		cifs_sb->rsize = 1024 * 127;
 		cFYI(DBG2, "no very large read support, rsize now 127K");
@@ -3040,10 +2932,10 @@ remote_path_check:
 	}
 #endif
 
-	/* check if a whole path (including prepath) is not remote */
+	/* check if a whole path is not remote */
 	if (!rc && tcon) {
 		/* build_path_to_root works only when we have a valid tcon */
-		full_path = cifs_build_path_to_root(cifs_sb, tcon);
+		full_path = cifs_build_path_to_root(volume_info, cifs_sb, tcon);
 		if (full_path == NULL) {
 			rc = -ENOMEM;
 			goto mount_fail_check;
@@ -3069,10 +2961,6 @@ remote_path_check:
 			rc = -ELOOP;
 			goto mount_fail_check;
 		}
-		/* convert forward to back slashes in prepath here if needed */
-		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) == 0)
-			convert_delimiter(cifs_sb->prepath,
-					CIFS_DIR_SEP(cifs_sb));
 
 		rc = expand_dfs_referral(xid, pSesInfo, volume_info, cifs_sb,
 					 true);
@@ -3298,7 +3186,6 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 	struct rb_root *root = &cifs_sb->tlink_tree;
 	struct rb_node *node;
 	struct tcon_link *tlink;
-	char *tmp;
 
 	cancel_delayed_work_sync(&cifs_sb->prune_tlinks);
 
@@ -3315,11 +3202,6 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
-	tmp = cifs_sb->prepath;
-	cifs_sb->prepathlen = 0;
-	cifs_sb->prepath = NULL;
-	kfree(tmp);
-
 	return 0;
 }
 
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 9ea65cf..c33446d 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -50,7 +50,6 @@ build_path_from_dentry(struct dentry *direntry)
 {
 	struct dentry *temp;
 	int namelen;
-	int pplen;
 	int dfsplen;
 	char *full_path;
 	char dirsep;
@@ -63,13 +62,12 @@ build_path_from_dentry(struct dentry *direntry)
 		when the server crashed */
 
 	dirsep = CIFS_DIR_SEP(cifs_sb);
-	pplen = cifs_sb->prepathlen;
 	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
 		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
 	else
 		dfsplen = 0;
 cifs_bp_rename_retry:
-	namelen = pplen + dfsplen;
+	namelen = dfsplen;
 	for (temp = direntry; !IS_ROOT(temp);) {
 		namelen += (1 + temp->d_name.len);
 		temp = temp->d_parent;
@@ -100,7 +98,7 @@ cifs_bp_rename_retry:
 			return NULL;
 		}
 	}
-	if (namelen != pplen + dfsplen) {
+	if (namelen != dfsplen) {
 		cERROR(1, "did not end path lookup where expected namelen is %d",
 			namelen);
 		/* presumably this is only possible if racing with a rename
@@ -126,7 +124,6 @@ cifs_bp_rename_retry:
 			}
 		}
 	}
-	strncpy(full_path + dfsplen, CIFS_SB(direntry->d_sb)->prepath, pplen);
 	return full_path;
 }
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index de02ed5..791d85e 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -735,10 +735,10 @@ static const struct inode_operations cifs_ipc_inode_ops = {
 	.lookup = cifs_lookup,
 };
 
-char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb,
-				struct cifsTconInfo *tcon)
+char *cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
+			      struct cifsTconInfo *tcon)
 {
-	int pplen = cifs_sb->prepathlen;
+	int pplen = vol->prepath ? strlen(vol->prepath) : 0;
 	int dfsplen;
 	char *full_path = NULL;
 
@@ -772,7 +772,7 @@ char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb,
 			}
 		}
 	}
-	strncpy(full_path + dfsplen, cifs_sb->prepath, pplen);
+	strncpy(full_path + dfsplen, vol->prepath, pplen);
 	full_path[dfsplen + pplen] = 0; /* add trailing null */
 	return full_path;
 }
@@ -884,19 +884,13 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct inode *inode = NULL;
 	long rc;
-	char *full_path;
 	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 
-	full_path = cifs_build_path_to_root(cifs_sb, tcon);
-	if (full_path == NULL)
-		return ERR_PTR(-ENOMEM);
-
 	xid = GetXid();
 	if (tcon->unix_ext)
-		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
+		rc = cifs_get_inode_info_unix(&inode, "", sb, xid);
 	else
-		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
-						xid, NULL);
+		rc = cifs_get_inode_info(&inode, "", NULL, sb, xid, NULL);
 
 	if (!inode) {
 		inode = ERR_PTR(rc);
@@ -922,7 +916,6 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	}
 
 out:
-	kfree(full_path);
 	/* can not call macro FreeXid here since in a void func
 	 * TODO: This is no longer true
 	 */
-- 
1.7.1
