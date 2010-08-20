From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/15] cifs: add cifs_sb_master_tcon and convert some callers to use it
Date: Fri, 20 Aug 2010 15:32:03 -0400
Message-ID: <1282332731-17444-8-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

At mount time, we'll always need to create a tcon that will serve as a
template for others that are associated with the mount. This tcon is
known as the "master" tcon.

In some cases, we'll need to use that tcon regardless of who's accessing
the mount. Add an accessor function for the master tcon and go ahead and
switch the appropriate places to use it.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    6 +++---
 fs/cifs/cifsglob.h |    7 +++++++
 fs/cifs/connect.c  |    4 ++--
 fs/cifs/dir.c      |   10 +++++-----
 fs/cifs/fscache.c  |   12 ++++++------
 fs/cifs/inode.c    |   29 ++++++++++++++++-------------
 fs/cifs/misc.c     |    2 +-
 fs/cifs/readdir.c  |    4 ++--
 8 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index dd28d18..f1ae8df 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -221,7 +221,7 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
+	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 	int rc = -EOPNOTSUPP;
 	int xid;
 
@@ -365,7 +365,7 @@ static int
 cifs_show_options(struct seq_file *s, struct vfsmount *m)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(m->mnt_sb);
-	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
+	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 
 	seq_printf(s, ",unc=%s", tcon->treeName);
 	if (tcon->ses->userName)
@@ -436,7 +436,7 @@ static void cifs_umount_begin(struct super_block *sb)
 	if (cifs_sb == NULL)
 		return;
 
-	tcon = cifs_sb_tcon(cifs_sb);
+	tcon = cifs_sb_master_tcon(cifs_sb);
 
 	read_lock(&cifs_tcp_ses_lock);
 	if ((tcon->tc_count > 1) || (tcon->tidStatus == CifsExiting)) {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9aad04e..2f1b008 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -417,6 +417,13 @@ cifs_sb_tcon(struct cifs_sb_info *cifs_sb)
 	return cifs_sb->ptcon;
 }
 
+/* This function is always expected to succeed */
+static inline struct cifsTconInfo *
+cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb)
+{
+	return cifs_sb->ptcon;
+}
+
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6998e50..2fd2fe9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2953,9 +2953,9 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 {
 	int rc = 0;
 	char *tmp;
+	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 
-	if (cifs_sb_tcon(cifs_sb))
-		cifs_put_tcon(cifs_sb_tcon(cifs_sb));
+	cifs_put_tcon(tcon);
 
 	cifs_sb->ptcon = NULL;
 	tmp = cifs_sb->prepath;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index c8aab86..bb5505f 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -54,18 +54,18 @@ build_path_from_dentry(struct dentry *direntry)
 	int dfsplen;
 	char *full_path;
 	char dirsep;
-	struct cifs_sb_info *cifs_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
+	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 
 	if (direntry == NULL)
 		return NULL;  /* not much we can do if dentry is freed and
 		we need to reopen the file after it was closed implicitly
 		when the server crashed */
 
-	cifs_sb = CIFS_SB(direntry->d_sb);
 	dirsep = CIFS_DIR_SEP(cifs_sb);
 	pplen = cifs_sb->prepathlen;
-	if (cifs_sb_tcon(cifs_sb) && (cifs_sb_tcon(cifs_sb)->Flags & SMB_SHARE_IS_IN_DFS))
-		dfsplen = strnlen(cifs_sb_tcon(cifs_sb)->treeName, MAX_TREE_SIZE + 1);
+	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
+		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
 	else
 		dfsplen = 0;
 cifs_bp_rename_retry:
@@ -117,7 +117,7 @@ cifs_bp_rename_retry:
 	/* BB test paths to Windows with '/' in the midst of prepath */
 
 	if (dfsplen) {
-		strncpy(full_path, cifs_sb_tcon(cifs_sb)->treeName, dfsplen);
+		strncpy(full_path, tcon->treeName, dfsplen);
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
 			int i;
 			for (i = 0; i < dfsplen; i++) {
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index ec4318b0..a2ad94e 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -62,15 +62,15 @@ static void cifs_fscache_enable_inode_cookie(struct inode *inode)
 {
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 
 	if (cifsi->fscache)
 		return;
 
-	cifsi->fscache = fscache_acquire_cookie(cifs_sb_tcon(cifs_sb)->fscache,
-				&cifs_fscache_inode_object_def,
-				cifsi);
-	cFYI(1, "CIFS: got FH cookie (0x%p/0x%p)",
-			cifs_sb_tcon(cifs_sb)->fscache, cifsi->fscache);
+	cifsi->fscache = fscache_acquire_cookie(tcon->fscache,
+				&cifs_fscache_inode_object_def, cifsi);
+	cFYI(1, "CIFS: got FH cookie (0x%p/0x%p)", tcon->fscache,
+				cifsi->fscache);
 }
 
 void cifs_fscache_release_inode_cookie(struct inode *inode)
@@ -118,7 +118,7 @@ void cifs_fscache_reset_inode_cookie(struct inode *inode)
 		fscache_relinquish_cookie(cifsi->fscache, 1);
 
 		cifsi->fscache = fscache_acquire_cookie(
-					cifs_sb_tcon(cifs_sb)->fscache,
+					cifs_sb_master_tcon(cifs_sb)->fscache,
 					&cifs_fscache_inode_object_def,
 					cifsi);
 		cFYI(1, "CIFS: new cookie 0x%p oldcookie 0x%p",
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 304ce87..80ce0ce 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -52,7 +52,7 @@ static void cifs_set_ops(struct inode *inode, const bool is_dfs_referral)
 
 
 		/* check if server can support readpages */
-		if (cifs_sb_tcon(cifs_sb)->ses->server->maxBuf <
+		if (cifs_sb_master_tcon(cifs_sb)->ses->server->maxBuf <
 				PAGE_CACHE_SIZE + MAX_CIFS_HDR_SIZE)
 			inode->i_data.a_ops = &cifs_addr_ops_smallbuf;
 		else
@@ -469,6 +469,8 @@ static void
 cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 		       struct cifs_sb_info *cifs_sb, bool adjust_tz)
 {
+	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
+
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_cifsattrs = le32_to_cpu(info->Attributes);
 	if (info->DeletePending)
@@ -483,8 +485,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
 
 	if (adjust_tz) {
-		fattr->cf_ctime.tv_sec += cifs_sb_tcon(cifs_sb)->ses->server->timeAdj;
-		fattr->cf_mtime.tv_sec += cifs_sb_tcon(cifs_sb)->ses->server->timeAdj;
+		fattr->cf_ctime.tv_sec += tcon->ses->server->timeAdj;
+		fattr->cf_mtime.tv_sec += tcon->ses->server->timeAdj;
 	}
 
 	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
@@ -685,6 +687,7 @@ char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb)
 	int pplen = cifs_sb->prepathlen;
 	int dfsplen;
 	char *full_path = NULL;
+	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 
 	/* if no prefix path, simply set path to the root of share to "" */
 	if (pplen == 0) {
@@ -694,8 +697,8 @@ char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb)
 		return full_path;
 	}
 
-	if (cifs_sb_tcon(cifs_sb) && (cifs_sb_tcon(cifs_sb)->Flags & SMB_SHARE_IS_IN_DFS))
-		dfsplen = strnlen(cifs_sb_tcon(cifs_sb)->treeName, MAX_TREE_SIZE + 1);
+	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
+		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
 	else
 		dfsplen = 0;
 
@@ -704,7 +707,7 @@ char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb)
 		return full_path;
 
 	if (dfsplen) {
-		strncpy(full_path, cifs_sb_tcon(cifs_sb)->treeName, dfsplen);
+		strncpy(full_path, tcon->treeName, dfsplen);
 		/* switch slash direction in prepath depending on whether
 		 * windows or posix style path names
 		 */
@@ -823,18 +826,18 @@ retry_iget5_locked:
 struct inode *cifs_root_iget(struct super_block *sb, unsigned long ino)
 {
 	int xid;
-	struct cifs_sb_info *cifs_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct inode *inode = NULL;
 	long rc;
 	char *full_path;
+	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 
-	cifs_sb = CIFS_SB(sb);
 	full_path = cifs_build_path_to_root(cifs_sb);
 	if (full_path == NULL)
 		return ERR_PTR(-ENOMEM);
 
 	xid = GetXid();
-	if (cifs_sb_tcon(cifs_sb)->unix_ext)
+	if (tcon->unix_ext)
 		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
 	else
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
@@ -845,10 +848,10 @@ struct inode *cifs_root_iget(struct super_block *sb, unsigned long ino)
 
 #ifdef CONFIG_CIFS_FSCACHE
 	/* populate tcon->resource_id */
-	cifs_sb_tcon(cifs_sb)->resource_id = CIFS_I(inode)->uniqueid;
+	tcon->resource_id = CIFS_I(inode)->uniqueid;
 #endif
 
-	if (rc && cifs_sb_tcon(cifs_sb)->ipc) {
+	if (rc && tcon->ipc) {
 		cFYI(1, "ipc connection - fake read inode");
 		inode->i_mode |= S_IFDIR;
 		inode->i_nlink = 2;
@@ -1653,7 +1656,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 		 "jiffies %ld", full_path, inode, inode->i_count.counter,
 		 dentry, dentry->d_time, jiffies);
 
-	if (cifs_sb_tcon(CIFS_SB(sb))->unix_ext)
+	if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
 		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
 	else
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
@@ -2079,7 +2082,7 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 {
 	struct inode *inode = direntry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsTconInfo *pTcon = cifs_sb_tcon(cifs_sb);
+	struct cifsTconInfo *pTcon = cifs_sb_master_tcon(cifs_sb);
 
 	if (pTcon->unix_ext)
 		return cifs_setattr_unix(direntry, attrs);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index c5cbfdb..252f276 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -729,6 +729,6 @@ cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
 			   "properly. Hardlinks will not be recognized on this "
 			   "mount. Consider mounting with the \"noserverino\" "
 			   "option to silence this message.",
-			   cifs_sb_tcon(cifs_sb)->treeName);
+			   cifs_sb_master_tcon(cifs_sb)->treeName);
 	}
 }
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 89f907e..0992115 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -102,7 +102,7 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 		return NULL;
 	}
 
-	if (cifs_sb_tcon(CIFS_SB(sb))->nocase)
+	if (cifs_sb_master_tcon(CIFS_SB(sb))->nocase)
 		dentry->d_op = &cifs_ci_dentry_ops;
 	else
 		dentry->d_op = &cifs_dentry_ops;
@@ -172,7 +172,7 @@ static void
 cifs_std_info_to_fattr(struct cifs_fattr *fattr, FIND_FILE_STANDARD_INFO *info,
 		       struct cifs_sb_info *cifs_sb)
 {
-	int offset = cifs_sb_tcon(cifs_sb)->ses->server->timeAdj;
+	int offset = cifs_sb_master_tcon(cifs_sb)->ses->server->timeAdj;
 
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_atime = cnvrtDosUnixTm(info->LastAccessDate,
-- 
1.7.2.1
