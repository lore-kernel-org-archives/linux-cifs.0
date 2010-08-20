From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/15] cifs: add function to get a tcon from cifs_sb
Date: Fri, 20 Aug 2010 15:32:01 -0400
Message-ID: <1282332731-17444-6-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When we convert cifs to do multiple sessions per mount, we'll need more
than one tcon per superblock. At that point "cifs_sb->tcon" will make
no sense. Add a new accessor function that gets a tcon given a cifs_sb.
For now, it just returns cifs_sb->tcon. Later it'll do more.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_dfs_ref.c |    2 +-
 fs/cifs/cifsacl.c      |   16 +++++++-------
 fs/cifs/cifsfs.c       |   11 ++-------
 fs/cifs/cifsglob.h     |    6 +++++
 fs/cifs/connect.c      |    4 +-
 fs/cifs/dir.c          |   20 +++++++++---------
 fs/cifs/file.c         |    4 +-
 fs/cifs/fscache.c      |    7 +++--
 fs/cifs/inode.c        |   49 ++++++++++++++++++++++++-----------------------
 fs/cifs/link.c         |    6 ++--
 fs/cifs/misc.c         |    2 +-
 fs/cifs/readdir.c      |    8 +++---
 fs/cifs/xattr.c        |    8 +++---
 13 files changed, 73 insertions(+), 70 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index d6ced7a..f1e13ea 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -316,7 +316,7 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 	nd->path.dentry = dget(dentry);
 
 	cifs_sb = CIFS_SB(dentry->d_inode->i_sb);
-	ses = cifs_sb->tcon->ses;
+	ses = cifs_sb_tcon(cifs_sb)->ses;
 
 	if (!ses) {
 		rc = -EINVAL;
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 85d7cf7..32f2449 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -559,7 +559,7 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
 	int xid, rc;
 
 	xid = GetXid();
-	rc = CIFSSMBGetCIFSACL(xid, cifs_sb->tcon, fid, &pntsd, pacllen);
+	rc = CIFSSMBGetCIFSACL(xid, cifs_sb_tcon(cifs_sb), fid, &pntsd, pacllen);
 	FreeXid(xid);
 
 
@@ -577,7 +577,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 
 	xid = GetXid();
 
-	rc = CIFSSMBOpen(xid, cifs_sb->tcon, path, FILE_OPEN, READ_CONTROL, 0,
+	rc = CIFSSMBOpen(xid, cifs_sb_tcon(cifs_sb), path, FILE_OPEN, READ_CONTROL, 0,
 			 &fid, &oplock, NULL, cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
@@ -585,10 +585,10 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 		goto out;
 	}
 
-	rc = CIFSSMBGetCIFSACL(xid, cifs_sb->tcon, fid, &pntsd, pacllen);
+	rc = CIFSSMBGetCIFSACL(xid, cifs_sb_tcon(cifs_sb), fid, &pntsd, pacllen);
 	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
 
-	CIFSSMBClose(xid, cifs_sb->tcon, fid);
+	CIFSSMBClose(xid, cifs_sb_tcon(cifs_sb), fid);
  out:
 	FreeXid(xid);
 	return pntsd;
@@ -618,7 +618,7 @@ static int set_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb, __u16 fid,
 	int xid, rc;
 
 	xid = GetXid();
-	rc = CIFSSMBSetCIFSACL(xid, cifs_sb->tcon, fid, pnntsd, acllen);
+	rc = CIFSSMBSetCIFSACL(xid, cifs_sb_tcon(cifs_sb), fid, pnntsd, acllen);
 	FreeXid(xid);
 
 	cFYI(DBG2, "SetCIFSACL rc = %d", rc);
@@ -634,7 +634,7 @@ static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
 
 	xid = GetXid();
 
-	rc = CIFSSMBOpen(xid, cifs_sb->tcon, path, FILE_OPEN, WRITE_DAC, 0,
+	rc = CIFSSMBOpen(xid, cifs_sb_tcon(cifs_sb), path, FILE_OPEN, WRITE_DAC, 0,
 			 &fid, &oplock, NULL, cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
@@ -642,10 +642,10 @@ static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
 		goto out;
 	}
 
-	rc = CIFSSMBSetCIFSACL(xid, cifs_sb->tcon, fid, pnntsd, acllen);
+	rc = CIFSSMBSetCIFSACL(xid, cifs_sb_tcon(cifs_sb), fid, pnntsd, acllen);
 	cFYI(DBG2, "SetCIFSACL rc = %d", rc);
 
-	CIFSSMBClose(xid, cifs_sb->tcon, fid);
+	CIFSSMBClose(xid, cifs_sb_tcon(cifs_sb), fid);
  out:
 	FreeXid(xid);
 	return rc;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8f097bf..dd28d18 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -136,9 +136,6 @@ cifs_read_super(struct super_block *sb, void *data,
 	sb->s_magic = CIFS_MAGIC_NUMBER;
 	sb->s_op = &cifs_super_ops;
 	sb->s_bdi = &cifs_sb->bdi;
-/*	if (cifs_sb->tcon->ses->server->maxBuf > MAX_CIFS_HDR_SIZE + 512)
-	    sb->s_blocksize =
-		cifs_sb->tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE; */
 	sb->s_blocksize = CIFS_MAX_MSGSIZE;
 	sb->s_blocksize_bits = 14;	/* default 2**14 = CIFS_MAX_MSGSIZE */
 	inode = cifs_root_iget(sb, ROOT_I);
@@ -224,7 +221,7 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifsTconInfo *tcon = cifs_sb->tcon;
+	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
 	int rc = -EOPNOTSUPP;
 	int xid;
 
@@ -368,7 +365,7 @@ static int
 cifs_show_options(struct seq_file *s, struct vfsmount *m)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(m->mnt_sb);
-	struct cifsTconInfo *tcon = cifs_sb->tcon;
+	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
 
 	seq_printf(s, ",unc=%s", tcon->treeName);
 	if (tcon->ses->userName)
@@ -439,9 +436,7 @@ static void cifs_umount_begin(struct super_block *sb)
 	if (cifs_sb == NULL)
 		return;
 
-	tcon = cifs_sb->tcon;
-	if (tcon == NULL)
-		return;
+	tcon = cifs_sb_tcon(cifs_sb);
 
 	read_lock(&cifs_tcp_ses_lock);
 	if ((tcon->tc_count > 1) || (tcon->tidStatus == CifsExiting)) {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6bd88b9..5e142aa 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -411,6 +411,12 @@ CIFS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+static inline struct cifsTconInfo *
+cifs_sb_tcon(struct cifs_sb_info *cifs_sb)
+{
+	return cifs_sb->tcon;
+}
+
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 446e248..be6b7a2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2954,8 +2954,8 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 	int rc = 0;
 	char *tmp;
 
-	if (cifs_sb->tcon)
-		cifs_put_tcon(cifs_sb->tcon);
+	if (cifs_sb_tcon(cifs_sb))
+		cifs_put_tcon(cifs_sb_tcon(cifs_sb));
 
 	cifs_sb->tcon = NULL;
 	tmp = cifs_sb->prepath;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index e5dc1e8..c8aab86 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -64,8 +64,8 @@ build_path_from_dentry(struct dentry *direntry)
 	cifs_sb = CIFS_SB(direntry->d_sb);
 	dirsep = CIFS_DIR_SEP(cifs_sb);
 	pplen = cifs_sb->prepathlen;
-	if (cifs_sb->tcon && (cifs_sb->tcon->Flags & SMB_SHARE_IS_IN_DFS))
-		dfsplen = strnlen(cifs_sb->tcon->treeName, MAX_TREE_SIZE + 1);
+	if (cifs_sb_tcon(cifs_sb) && (cifs_sb_tcon(cifs_sb)->Flags & SMB_SHARE_IS_IN_DFS))
+		dfsplen = strnlen(cifs_sb_tcon(cifs_sb)->treeName, MAX_TREE_SIZE + 1);
 	else
 		dfsplen = 0;
 cifs_bp_rename_retry:
@@ -117,7 +117,7 @@ cifs_bp_rename_retry:
 	/* BB test paths to Windows with '/' in the midst of prepath */
 
 	if (dfsplen) {
-		strncpy(full_path, cifs_sb->tcon->treeName, dfsplen);
+		strncpy(full_path, cifs_sb_tcon(cifs_sb)->treeName, dfsplen);
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
 			int i;
 			for (i = 0; i < dfsplen; i++) {
@@ -153,7 +153,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 	pCifsFile->pfile = file;
 	pCifsFile->invalidHandle = false;
 	pCifsFile->closePend = false;
-	pCifsFile->tcon = cifs_sb->tcon;
+	pCifsFile->tcon = cifs_sb_tcon(cifs_sb);
 	mutex_init(&pCifsFile->fh_mutex);
 	mutex_init(&pCifsFile->lock_mutex);
 	INIT_LIST_HEAD(&pCifsFile->llist);
@@ -161,7 +161,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
 
 	write_lock(&GlobalSMBSeslock);
-	list_add(&pCifsFile->tlist, &cifs_sb->tcon->openFileList);
+	list_add(&pCifsFile->tlist, &cifs_sb_tcon(cifs_sb)->openFileList);
 	pCifsInode = CIFS_I(newinode);
 	if (pCifsInode) {
 		/* if readable file instance put first in list*/
@@ -228,7 +228,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 		posix_flags |= SMB_O_DIRECT;
 
 	mode &= ~current_umask();
-	rc = CIFSPOSIXCreate(xid, cifs_sb->tcon, posix_flags, mode,
+	rc = CIFSPOSIXCreate(xid, cifs_sb_tcon(cifs_sb), posix_flags, mode,
 			pnetfid, presp_data, poplock, full_path,
 			cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
@@ -301,7 +301,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	tcon = cifs_sb->tcon;
+	tcon = cifs_sb_tcon(cifs_sb);
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
@@ -376,7 +376,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
 		create_options |= CREATE_OPTION_READONLY;
 
-	if (cifs_sb->tcon->ses->capabilities & CAP_NT_SMBS)
+	if (tcon->ses->capabilities & CAP_NT_SMBS)
 		rc = CIFSSMBOpen(xid, tcon, full_path, disposition,
 			 desiredAccess, create_options,
 			 &fileHandle, &oplock, buf, cifs_sb->local_nls,
@@ -507,7 +507,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb);
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
@@ -634,7 +634,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	/* check whether path exists */
 
 	cifs_sb = CIFS_SB(parent_dir_inode->i_sb);
-	pTcon = cifs_sb->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb);
 
 	/*
 	 * Don't allow the separator character in a path component.
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 56a2d98..30acc6d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -235,7 +235,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	tcon = cifs_sb->tcon;
+	tcon = cifs_sb_tcon(cifs_sb);
 
 	pCifsInode = CIFS_I(file->f_path.dentry->d_inode);
 
@@ -345,7 +345,7 @@ int cifs_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	if (cifs_sb->tcon->ses->capabilities & CAP_NT_SMBS)
+	if (tcon->ses->capabilities & CAP_NT_SMBS)
 		rc = CIFSSMBOpen(xid, tcon, full_path, disposition,
 			 desiredAccess, CREATE_NOT_DIR, &netfid, &oplock, buf,
 			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index 9f3f5c4..ec4318b0 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -66,11 +66,11 @@ static void cifs_fscache_enable_inode_cookie(struct inode *inode)
 	if (cifsi->fscache)
 		return;
 
-	cifsi->fscache = fscache_acquire_cookie(cifs_sb->tcon->fscache,
+	cifsi->fscache = fscache_acquire_cookie(cifs_sb_tcon(cifs_sb)->fscache,
 				&cifs_fscache_inode_object_def,
 				cifsi);
 	cFYI(1, "CIFS: got FH cookie (0x%p/0x%p)",
-			cifs_sb->tcon->fscache, cifsi->fscache);
+			cifs_sb_tcon(cifs_sb)->fscache, cifsi->fscache);
 }
 
 void cifs_fscache_release_inode_cookie(struct inode *inode)
@@ -117,7 +117,8 @@ void cifs_fscache_reset_inode_cookie(struct inode *inode)
 		/* retire the current fscache cache and get a new one */
 		fscache_relinquish_cookie(cifsi->fscache, 1);
 
-		cifsi->fscache = fscache_acquire_cookie(cifs_sb->tcon->fscache,
+		cifsi->fscache = fscache_acquire_cookie(
+					cifs_sb_tcon(cifs_sb)->fscache,
 					&cifs_fscache_inode_object_def,
 					cifsi);
 		cFYI(1, "CIFS: new cookie 0x%p oldcookie 0x%p",
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index dca2ec2..304ce87 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -52,7 +52,7 @@ static void cifs_set_ops(struct inode *inode, const bool is_dfs_referral)
 
 
 		/* check if server can support readpages */
-		if (cifs_sb->tcon->ses->server->maxBuf <
+		if (cifs_sb_tcon(cifs_sb)->ses->server->maxBuf <
 				PAGE_CACHE_SIZE + MAX_CIFS_HDR_SIZE)
 			inode->i_data.a_ops = &cifs_addr_ops_smallbuf;
 		else
@@ -315,7 +315,8 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 	struct cifsTconInfo *tcon;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	tcon = cifs_sb->tcon;
+	tcon = cifs_sb_tcon(cifs_sb);
+
 	cFYI(1, "Getting info on %s", full_path);
 
 	/* could have done a find first instead but this returns more info */
@@ -353,7 +354,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 	int rc;
 	int oplock = 0;
 	__u16 netfid;
-	struct cifsTconInfo *pTcon = cifs_sb->tcon;
+	struct cifsTconInfo *pTcon = cifs_sb_tcon(cifs_sb);
 	char buf[24];
 	unsigned int bytes_read;
 	char *pbuf;
@@ -442,7 +443,7 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
 	char ea_value[4];
 	__u32 mode;
 
-	rc = CIFSSMBQAllEAs(xid, cifs_sb->tcon, path, "SETFILEBITS",
+	rc = CIFSSMBQAllEAs(xid, cifs_sb_tcon(cifs_sb), path, "SETFILEBITS",
 			    ea_value, 4 /* size of buf */, cifs_sb->local_nls,
 			    cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
@@ -482,8 +483,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
 
 	if (adjust_tz) {
-		fattr->cf_ctime.tv_sec += cifs_sb->tcon->ses->server->timeAdj;
-		fattr->cf_mtime.tv_sec += cifs_sb->tcon->ses->server->timeAdj;
+		fattr->cf_ctime.tv_sec += cifs_sb_tcon(cifs_sb)->ses->server->timeAdj;
+		fattr->cf_mtime.tv_sec += cifs_sb_tcon(cifs_sb)->ses->server->timeAdj;
 	}
 
 	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
@@ -560,7 +561,7 @@ int cifs_get_inode_info(struct inode **pinode,
 	bool adjustTZ = false;
 	struct cifs_fattr fattr;
 
-	pTcon = cifs_sb->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb);
 	cFYI(1, "Getting info on %s", full_path);
 
 	if ((pfindData == NULL) && (*pinode != NULL)) {
@@ -693,8 +694,8 @@ char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb)
 		return full_path;
 	}
 
-	if (cifs_sb->tcon && (cifs_sb->tcon->Flags & SMB_SHARE_IS_IN_DFS))
-		dfsplen = strnlen(cifs_sb->tcon->treeName, MAX_TREE_SIZE + 1);
+	if (cifs_sb_tcon(cifs_sb) && (cifs_sb_tcon(cifs_sb)->Flags & SMB_SHARE_IS_IN_DFS))
+		dfsplen = strnlen(cifs_sb_tcon(cifs_sb)->treeName, MAX_TREE_SIZE + 1);
 	else
 		dfsplen = 0;
 
@@ -703,7 +704,7 @@ char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb)
 		return full_path;
 
 	if (dfsplen) {
-		strncpy(full_path, cifs_sb->tcon->treeName, dfsplen);
+		strncpy(full_path, cifs_sb_tcon(cifs_sb)->treeName, dfsplen);
 		/* switch slash direction in prepath depending on whether
 		 * windows or posix style path names
 		 */
@@ -833,7 +834,7 @@ struct inode *cifs_root_iget(struct super_block *sb, unsigned long ino)
 		return ERR_PTR(-ENOMEM);
 
 	xid = GetXid();
-	if (cifs_sb->tcon->unix_ext)
+	if (cifs_sb_tcon(cifs_sb)->unix_ext)
 		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
 	else
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
@@ -844,10 +845,10 @@ struct inode *cifs_root_iget(struct super_block *sb, unsigned long ino)
 
 #ifdef CONFIG_CIFS_FSCACHE
 	/* populate tcon->resource_id */
-	cifs_sb->tcon->resource_id = CIFS_I(inode)->uniqueid;
+	cifs_sb_tcon(cifs_sb)->resource_id = CIFS_I(inode)->uniqueid;
 #endif
 
-	if (rc && cifs_sb->tcon->ipc) {
+	if (rc && cifs_sb_tcon(cifs_sb)->ipc) {
 		cFYI(1, "ipc connection - fake read inode");
 		inode->i_mode |= S_IFDIR;
 		inode->i_nlink = 2;
@@ -930,7 +931,7 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, int xid,
 		goto set_via_filehandle;
 	}
 
-	pTcon = cifs_sb->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb);
 
 	/*
 	 * NT4 apparently returns success on this call, but it doesn't
@@ -992,7 +993,7 @@ cifs_rename_pending_delete(char *full_path, struct dentry *dentry, int xid)
 	struct inode *inode = dentry->d_inode;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsTconInfo *tcon = cifs_sb->tcon;
+	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
 	__u32 dosattr, origattr;
 	FILE_BASIC_INFO *info_buf = NULL;
 
@@ -1103,7 +1104,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	struct cifsInodeInfo *cifs_inode;
 	struct super_block *sb = dir->i_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifsTconInfo *tcon = cifs_sb->tcon;
+	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
 	struct iattr *attrs = NULL;
 	__u32 dosattr = 0, origattr = 0;
 
@@ -1205,7 +1206,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb);
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
@@ -1386,7 +1387,7 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb);
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
@@ -1427,7 +1428,7 @@ cifs_do_rename(int xid, struct dentry *from_dentry, const char *fromPath,
 		struct dentry *to_dentry, const char *toPath)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(from_dentry->d_sb);
-	struct cifsTconInfo *pTcon = cifs_sb->tcon;
+	struct cifsTconInfo *pTcon = cifs_sb_tcon(cifs_sb);
 	__u16 srcfid;
 	int oplock, rc;
 
@@ -1478,7 +1479,7 @@ int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 	int xid, rc, tmprc;
 
 	cifs_sb = CIFS_SB(source_dir->i_sb);
-	tcon = cifs_sb->tcon;
+	tcon = cifs_sb_tcon(cifs_sb);
 
 	xid = GetXid();
 
@@ -1652,7 +1653,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 		 "jiffies %ld", full_path, inode, inode->i_count.counter,
 		 dentry, dentry->d_time, jiffies);
 
-	if (CIFS_SB(sb)->tcon->unix_ext)
+	if (cifs_sb_tcon(CIFS_SB(sb))->unix_ext)
 		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
 	else
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
@@ -1747,7 +1748,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 
 	if (rc != 0) {
 		if (pTcon == NULL)
-			pTcon = cifs_sb->tcon;
+			pTcon = cifs_sb_tcon(cifs_sb);
 
 		/* Set file size by pathname rather than by handle
 		   either because no valid, writeable file handle for
@@ -1893,7 +1894,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		rc = CIFSSMBUnixSetFileInfo(xid, pTcon, args, nfid, npid);
 		cifsFileInfo_put(open_file);
 	} else {
-		pTcon = cifs_sb->tcon;
+		pTcon = cifs_sb_tcon(cifs_sb);
 		rc = CIFSSMBUnixSetPathInfo(xid, pTcon, full_path, args,
 				    cifs_sb->local_nls,
 				    cifs_sb->mnt_cifs_flags &
@@ -2078,7 +2079,7 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 {
 	struct inode *inode = direntry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsTconInfo *pTcon = cifs_sb->tcon;
+	struct cifsTconInfo *pTcon = cifs_sb_tcon(cifs_sb);
 
 	if (pTcon->unix_ext)
 		return cifs_setattr_unix(direntry, attrs);
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 473ca80..1ceeb8c 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -44,7 +44,7 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 	xid = GetXid();
 
 	cifs_sb_target = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb_target->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb_target);
 
 /* No need to check for cross device links since server will do that
    BB note DFS case in future though (when we may have to check) */
@@ -113,7 +113,7 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 	char *full_path = NULL;
 	char *target_path = NULL;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsTconInfo *tcon = cifs_sb->tcon;
+	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
 
 	xid = GetXid();
 
@@ -168,7 +168,7 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb);
 
 	full_path = build_path_from_dentry(direntry);
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 3ccadc1..c5cbfdb 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -729,6 +729,6 @@ cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
 			   "properly. Hardlinks will not be recognized on this "
 			   "mount. Consider mounting with the \"noserverino\" "
 			   "option to silence this message.",
-			   cifs_sb->tcon->treeName);
+			   cifs_sb_tcon(cifs_sb)->treeName);
 	}
 }
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index f0b57da..89f907e 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -102,7 +102,7 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 		return NULL;
 	}
 
-	if (CIFS_SB(sb)->tcon->nocase)
+	if (cifs_sb_tcon(CIFS_SB(sb))->nocase)
 		dentry->d_op = &cifs_ci_dentry_ops;
 	else
 		dentry->d_op = &cifs_dentry_ops;
@@ -172,7 +172,7 @@ static void
 cifs_std_info_to_fattr(struct cifs_fattr *fattr, FIND_FILE_STANDARD_INFO *info,
 		       struct cifs_sb_info *cifs_sb)
 {
-	int offset = cifs_sb->tcon->ses->server->timeAdj;
+	int offset = cifs_sb_tcon(cifs_sb)->ses->server->timeAdj;
 
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_atime = cnvrtDosUnixTm(info->LastAccessDate,
@@ -200,7 +200,7 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
 	int len;
 	int oplock = 0;
 	int rc;
-	struct cifsTconInfo *ptcon = cifs_sb->tcon;
+	struct cifsTconInfo *ptcon = cifs_sb_tcon(cifs_sb);
 	char *tmpbuffer;
 
 	rc = CIFSSMBOpen(xid, ptcon, full_path, FILE_OPEN, GENERIC_READ,
@@ -242,7 +242,7 @@ static int initiate_cifs_search(const int xid, struct file *file)
 	cifsFile = file->private_data;
 	cifsFile->invalidHandle = true;
 	cifsFile->srch_inf.endOfSearch = false;
-	cifsFile->tcon = cifs_sb->tcon;
+	cifsFile->tcon = cifs_sb_tcon(cifs_sb);
 	pTcon = cifsFile->tcon;
 	if (pTcon == NULL)
 		return -EINVAL;
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index a150920..41f95bf 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -61,7 +61,7 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb);
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
@@ -116,7 +116,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb);
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
@@ -224,7 +224,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb);
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
@@ -346,7 +346,7 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 		return -EIO;
 
 	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb->tcon;
+	pTcon = cifs_sb_tcon(cifs_sb);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 		return -EOPNOTSUPP;
-- 
1.7.2.1
