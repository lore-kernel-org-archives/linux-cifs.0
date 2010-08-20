From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/15] cifs: add refcounted and timestamped container for holding tcons
Date: Fri, 20 Aug 2010 15:32:05 -0400
Message-ID: <1282332731-17444-10-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Eventually, we'll need to track the use of tcons on a per-sb basis, so that
we know when it's ok to tear them down. Begin this conversion by adding a
new "tcon_link" struct and accessors that get it. For now, the core data
structures are untouched -- cifs_sb still just points to a single tcon and
the pointers are just cast to deal with the accessor functions. A later
patch will flesh this out.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_dfs_ref.c |   21 ++++---
 fs/cifs/cifsacl.c      |   42 ++++++++++---
 fs/cifs/cifsglob.h     |   29 ++++++++-
 fs/cifs/dir.c          |   65 +++++++++++++++-----
 fs/cifs/file.c         |    9 +++-
 fs/cifs/inode.c        |  157 +++++++++++++++++++++++++++++++++++++-----------
 fs/cifs/link.c         |   54 +++++++++++------
 fs/cifs/readdir.c      |   34 ++++++-----
 fs/cifs/xattr.c        |   60 ++++++++++++-------
 9 files changed, 343 insertions(+), 128 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index f1e13ea..f4aab6f 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -306,6 +306,7 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 	int xid, i;
 	int rc = 0;
 	struct vfsmount *mnt = ERR_PTR(-ENOENT);
+	struct tcon_link *tlink;
 
 	cFYI(1, "in %s", __func__);
 	BUG_ON(IS_ROOT(dentry));
@@ -315,14 +316,6 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 	dput(nd->path.dentry);
 	nd->path.dentry = dget(dentry);
 
-	cifs_sb = CIFS_SB(dentry->d_inode->i_sb);
-	ses = cifs_sb_tcon(cifs_sb)->ses;
-
-	if (!ses) {
-		rc = -EINVAL;
-		goto out_err;
-	}
-
 	/*
 	 * The MSDFS spec states that paths in DFS referral requests and
 	 * responses must be prefixed by a single '\' character instead of
@@ -335,10 +328,20 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 		goto out_err;
 	}
 
-	rc = get_dfs_path(xid, ses , full_path + 1, cifs_sb->local_nls,
+	cifs_sb = CIFS_SB(dentry->d_inode->i_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
+		goto out_err;
+	}
+	ses = tlink_tcon(tlink)->ses;
+
+	rc = get_dfs_path(xid, ses, full_path + 1, cifs_sb->local_nls,
 		&num_referrals, &referrals,
 		cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 
+	cifs_put_tlink(tlink);
+
 	for (i = 0; i < num_referrals; i++) {
 		int len;
 		dump_referral(referrals+i);
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 32f2449..2647ea4 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -557,11 +557,16 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
 {
 	struct cifs_ntsd *pntsd = NULL;
 	int xid, rc;
+	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
+
+	if (IS_ERR(tlink))
+		return NULL;
 
 	xid = GetXid();
-	rc = CIFSSMBGetCIFSACL(xid, cifs_sb_tcon(cifs_sb), fid, &pntsd, pacllen);
+	rc = CIFSSMBGetCIFSACL(xid, tlink_tcon(tlink), fid, &pntsd, pacllen);
 	FreeXid(xid);
 
+	cifs_put_tlink(tlink);
 
 	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
 	return pntsd;
@@ -574,10 +579,16 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 	int oplock = 0;
 	int xid, rc;
 	__u16 fid;
+	struct cifsTconInfo *tcon;
+	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
+
+	if (IS_ERR(tlink))
+		return NULL;
 
+	tcon = tlink_tcon(tlink);
 	xid = GetXid();
 
-	rc = CIFSSMBOpen(xid, cifs_sb_tcon(cifs_sb), path, FILE_OPEN, READ_CONTROL, 0,
+	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, READ_CONTROL, 0,
 			 &fid, &oplock, NULL, cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
@@ -585,11 +596,12 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 		goto out;
 	}
 
-	rc = CIFSSMBGetCIFSACL(xid, cifs_sb_tcon(cifs_sb), fid, &pntsd, pacllen);
+	rc = CIFSSMBGetCIFSACL(xid, tcon, fid, &pntsd, pacllen);
 	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
 
-	CIFSSMBClose(xid, cifs_sb_tcon(cifs_sb), fid);
+	CIFSSMBClose(xid, tcon, fid);
  out:
+	cifs_put_tlink(tlink);
 	FreeXid(xid);
 	return pntsd;
 }
@@ -616,10 +628,15 @@ static int set_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb, __u16 fid,
 		struct cifs_ntsd *pnntsd, u32 acllen)
 {
 	int xid, rc;
+	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
+
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
 
 	xid = GetXid();
-	rc = CIFSSMBSetCIFSACL(xid, cifs_sb_tcon(cifs_sb), fid, pnntsd, acllen);
+	rc = CIFSSMBSetCIFSACL(xid, tlink_tcon(tlink), fid, pnntsd, acllen);
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 
 	cFYI(DBG2, "SetCIFSACL rc = %d", rc);
 	return rc;
@@ -631,10 +648,16 @@ static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
 	int oplock = 0;
 	int xid, rc;
 	__u16 fid;
+	struct cifsTconInfo *tcon;
+	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
 
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+
+	tcon = tlink_tcon(tlink);
 	xid = GetXid();
 
-	rc = CIFSSMBOpen(xid, cifs_sb_tcon(cifs_sb), path, FILE_OPEN, WRITE_DAC, 0,
+	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, WRITE_DAC, 0,
 			 &fid, &oplock, NULL, cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
@@ -642,12 +665,13 @@ static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
 		goto out;
 	}
 
-	rc = CIFSSMBSetCIFSACL(xid, cifs_sb_tcon(cifs_sb), fid, pnntsd, acllen);
+	rc = CIFSSMBSetCIFSACL(xid, tcon, fid, pnntsd, acllen);
 	cFYI(DBG2, "SetCIFSACL rc = %d", rc);
 
-	CIFSSMBClose(xid, cifs_sb_tcon(cifs_sb), fid);
- out:
+	CIFSSMBClose(xid, tcon, fid);
+out:
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2f1b008..9323587 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -308,6 +308,19 @@ struct cifsTconInfo {
 };
 
 /*
+ * This is a refcounted and timestamped container for a tcon pointer. The
+ * container holds a tcon reference. It is considered safe to free one of
+ * these when the tl_count goes to 0. The tl_time is the time of the last
+ * "get" on the container.
+ */
+struct tcon_link {
+	spinlock_t		tl_lock;
+	u32			tl_count;
+	u64			tl_time;
+	struct cifsTconInfo	*tl_tcon;
+};
+
+/*
  * This info hangs off the cifsFileInfo structure, pointed to by llist.
  * This is used to track byte stream locks on the file
  */
@@ -411,10 +424,22 @@ CIFS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+static inline struct tcon_link *
+cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
+{
+	return (struct tcon_link *)cifs_sb->ptcon;
+}
+
 static inline struct cifsTconInfo *
-cifs_sb_tcon(struct cifs_sb_info *cifs_sb)
+tlink_tcon(struct tcon_link *tlink)
 {
-	return cifs_sb->ptcon;
+	return (struct cifsTconInfo *)tlink;
+}
+
+static inline void
+cifs_put_tlink(struct tcon_link *tlink)
+{
+	return;
 }
 
 /* This function is always expected to succeed */
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 110c701..4675d08 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -138,7 +138,6 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
 	int oplock = 0;
 	struct cifsFileInfo *pCifsFile;
 	struct cifsInodeInfo *pCifsInode;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(mnt->mnt_sb);
 
 	pCifsFile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
 	if (pCifsFile == NULL)
@@ -195,7 +194,8 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 	__u32 posix_flags = 0;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_fattr fattr;
-	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
+	struct tcon_link *tlink;
+	struct cifsTconInfo *tcon;
 
 	cFYI(1, "posix open %s", full_path);
 
@@ -230,10 +230,20 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 		posix_flags |= SMB_O_DIRECT;
 
 	mode &= ~current_umask();
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
+		goto posix_open_ret;
+	}
+
+	tcon = tlink_tcon(tlink);
 	rc = CIFSPOSIXCreate(xid, tcon, posix_flags, mode, pnetfid, presp_data,
 			     poplock, full_path, cifs_sb->local_nls,
 			     cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
+	cifs_put_tlink(tlink);
+
 	if (rc)
 		goto posix_open_ret;
 
@@ -294,6 +304,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	int desiredAccess = GENERIC_READ | GENERIC_WRITE;
 	__u16 fileHandle;
 	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
 	struct cifsTconInfo *tcon;
 	char *full_path = NULL;
 	FILE_ALL_INFO *buf = NULL;
@@ -303,13 +314,12 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	tcon = cifs_sb_tcon(cifs_sb);
-
-	full_path = build_path_from_dentry(direntry);
-	if (full_path == NULL) {
-		rc = -ENOMEM;
-		goto cifs_create_out;
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		FreeXid(xid);
+		return PTR_ERR(tlink);
 	}
+	tcon = tlink_tcon(tlink);
 
 	if (oplockEnabled)
 		oplock = REQ_OPLOCK;
@@ -319,6 +329,12 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	else
 		oflags = FMODE_READ | SMB_O_CREAT;
 
+	full_path = build_path_from_dentry(direntry);
+	if (full_path == NULL) {
+		rc = -ENOMEM;
+		goto cifs_create_out;
+	}
+
 	if (tcon->unix_ext && (tcon->ses->capabilities & CAP_UNIX) &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
@@ -484,6 +500,7 @@ cifs_create_set_dentry:
 cifs_create_out:
 	kfree(buf);
 	kfree(full_path);
+	cifs_put_tlink(tlink);
 	FreeXid(xid);
 	return rc;
 }
@@ -494,6 +511,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 	int rc = -EPERM;
 	int xid;
 	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	char *full_path = NULL;
 	struct inode *newinode = NULL;
@@ -506,10 +524,14 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 	if (!old_valid_dev(device_number))
 		return -EINVAL;
 
-	xid = GetXid();
-
 	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb_tcon(cifs_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+
+	pTcon = tlink_tcon(tlink);
+
+	xid = GetXid();
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
@@ -609,6 +631,7 @@ mknod_out:
 	kfree(full_path);
 	kfree(buf);
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
@@ -622,6 +645,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	__u16 fileHandle = 0;
 	bool posix_open = false;
 	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	struct cifsFileInfo *cfile;
 	struct inode *newInode = NULL;
@@ -636,7 +660,12 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	/* check whether path exists */
 
 	cifs_sb = CIFS_SB(parent_dir_inode->i_sb);
-	pTcon = cifs_sb_tcon(cifs_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		FreeXid(xid);
+		return (struct dentry *)tlink;
+	}
+	pTcon = tlink_tcon(tlink);
 
 	/*
 	 * Don't allow the separator character in a path component.
@@ -647,8 +676,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		for (i = 0; i < direntry->d_name.len; i++)
 			if (direntry->d_name.name[i] == '\\') {
 				cFYI(1, "Invalid file name");
-				FreeXid(xid);
-				return ERR_PTR(-EINVAL);
+				rc = -EINVAL;
+				goto lookup_out;
 			}
 	}
 
@@ -658,7 +687,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	 */
 	if (nd && (nd->flags & LOOKUP_EXCL)) {
 		d_instantiate(direntry, NULL);
-		return NULL;
+		rc = 0;
+		goto lookup_out;
 	}
 
 	/* can not grab the rename sem here since it would
@@ -666,8 +696,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	in which we already have the sb rename sem */
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
-		FreeXid(xid);
-		return ERR_PTR(-ENOMEM);
+		rc = -ENOMEM;
+		goto lookup_out;
 	}
 
 	if (direntry->d_inode != NULL) {
@@ -762,6 +792,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 
 lookup_out:
 	kfree(full_path);
+	cifs_put_tlink(tlink);
 	FreeXid(xid);
 	return ERR_PTR(rc);
 }
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a4a0134..d257206 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -224,6 +224,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	__u32 oplock;
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *tcon;
+	struct tcon_link *tlink;
 	struct cifsFileInfo *pCifsFile = NULL;
 	struct cifsInodeInfo *pCifsInode;
 	char *full_path = NULL;
@@ -235,7 +236,12 @@ int cifs_open(struct inode *inode, struct file *file)
 	xid = GetXid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	tcon = cifs_sb_tcon(cifs_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		FreeXid(xid);
+		return PTR_ERR(tlink);
+	}
+	tcon = tlink_tcon(tlink);
 
 	pCifsInode = CIFS_I(file->f_path.dentry->d_inode);
 
@@ -402,6 +408,7 @@ out:
 	kfree(buf);
 	kfree(full_path);
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 80ce0ce..fc0ae26 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -313,16 +313,21 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 	FILE_UNIX_BASIC_INFO find_data;
 	struct cifs_fattr fattr;
 	struct cifsTconInfo *tcon;
+	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	tcon = cifs_sb_tcon(cifs_sb);
-
 	cFYI(1, "Getting info on %s", full_path);
 
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
 	/* could have done a find first instead but this returns more info */
 	rc = CIFSSMBUnixQPathInfo(xid, tcon, full_path, &find_data,
 				  cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
+	cifs_put_tlink(tlink);
 
 	if (!rc) {
 		cifs_unix_basic_to_fattr(&fattr, &find_data, cifs_sb);
@@ -354,7 +359,8 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 	int rc;
 	int oplock = 0;
 	__u16 netfid;
-	struct cifsTconInfo *pTcon = cifs_sb_tcon(cifs_sb);
+	struct tcon_link *tlink;
+	struct cifsTconInfo *tcon;
 	char buf[24];
 	unsigned int bytes_read;
 	char *pbuf;
@@ -373,7 +379,12 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 		return -EINVAL;	 /* EOPNOTSUPP? */
 	}
 
-	rc = CIFSSMBOpen(xid, pTcon, path, FILE_OPEN, GENERIC_READ,
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, GENERIC_READ,
 			 CREATE_NOT_DIR, &netfid, &oplock, NULL,
 			 cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags &
@@ -381,7 +392,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 	if (rc == 0) {
 		int buf_type = CIFS_NO_BUFFER;
 			/* Read header */
-		rc = CIFSSMBRead(xid, pTcon, netfid,
+		rc = CIFSSMBRead(xid, tcon, netfid,
 				 24 /* length */, 0 /* offset */,
 				 &bytes_read, &pbuf, &buf_type);
 		if ((rc == 0) && (bytes_read >= 8)) {
@@ -423,8 +434,9 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 			fattr->cf_dtype = DT_REG;
 			rc = -EOPNOTSUPP; /* or some unknown SFU type */
 		}
-		CIFSSMBClose(xid, pTcon, netfid);
+		CIFSSMBClose(xid, tcon, netfid);
 	}
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
@@ -442,11 +454,19 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
 	ssize_t rc;
 	char ea_value[4];
 	__u32 mode;
+	struct tcon_link *tlink;
+	struct cifsTconInfo *tcon;
 
-	rc = CIFSSMBQAllEAs(xid, cifs_sb_tcon(cifs_sb), path, "SETFILEBITS",
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	rc = CIFSSMBQAllEAs(xid, tcon, path, "SETFILEBITS",
 			    ea_value, 4 /* size of buf */, cifs_sb->local_nls,
 			    cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
+	cifs_put_tlink(tlink);
 	if (rc < 0)
 		return (int)rc;
 	else if (rc > 3) {
@@ -558,26 +578,33 @@ int cifs_get_inode_info(struct inode **pinode,
 {
 	int rc = 0, tmprc;
 	struct cifsTconInfo *pTcon;
+	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	char *buf = NULL;
 	bool adjustTZ = false;
 	struct cifs_fattr fattr;
 
-	pTcon = cifs_sb_tcon(cifs_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	pTcon = tlink_tcon(tlink);
+
 	cFYI(1, "Getting info on %s", full_path);
 
 	if ((pfindData == NULL) && (*pinode != NULL)) {
 		if (CIFS_I(*pinode)->clientCanCacheRead) {
 			cFYI(1, "No need to revalidate cached inode sizes");
-			return rc;
+			goto cgii_exit;
 		}
 	}
 
 	/* if file info not passed in then get it from server */
 	if (pfindData == NULL) {
 		buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
-		if (buf == NULL)
-			return -ENOMEM;
+		if (buf == NULL) {
+			rc = -ENOMEM;
+			goto cgii_exit;
+		}
 		pfindData = (FILE_ALL_INFO *)buf;
 
 		/* could do find first instead but this returns more info */
@@ -675,6 +702,7 @@ int cifs_get_inode_info(struct inode **pinode,
 
 cgii_exit:
 	kfree(buf);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
@@ -887,6 +915,7 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, int xid,
 	struct cifsFileInfo *open_file;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink = NULL;
 	struct cifsTconInfo *pTcon;
 	FILE_BASIC_INFO	info_buf;
 
@@ -934,7 +963,13 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, int xid,
 		goto set_via_filehandle;
 	}
 
-	pTcon = cifs_sb_tcon(cifs_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
+		tlink = NULL;
+		goto out;
+	}
+	pTcon = tlink_tcon(tlink);
 
 	/*
 	 * NT4 apparently returns success on this call, but it doesn't
@@ -979,6 +1014,8 @@ set_via_filehandle:
 	else
 		cifsFileInfo_put(open_file);
 out:
+	if (tlink != NULL)
+		cifs_put_tlink(tlink);
 	return rc;
 }
 
@@ -996,10 +1033,16 @@ cifs_rename_pending_delete(char *full_path, struct dentry *dentry, int xid)
 	struct inode *inode = dentry->d_inode;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
+	struct tcon_link *tlink;
+	struct cifsTconInfo *tcon;
 	__u32 dosattr, origattr;
 	FILE_BASIC_INFO *info_buf = NULL;
 
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
 	rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN,
 			 DELETE|FILE_WRITE_ATTRIBUTES, CREATE_NOT_DIR,
 			 &netfid, &oplock, NULL, cifs_sb->local_nls,
@@ -1068,6 +1111,7 @@ out_close:
 	CIFSSMBClose(xid, tcon, netfid);
 out:
 	kfree(info_buf);
+	cifs_put_tlink(tlink);
 	return rc;
 
 	/*
@@ -1107,12 +1151,18 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	struct cifsInodeInfo *cifs_inode;
 	struct super_block *sb = dir->i_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
+	struct tcon_link *tlink;
+	struct cifsTconInfo *tcon;
 	struct iattr *attrs = NULL;
 	__u32 dosattr = 0, origattr = 0;
 
 	cFYI(1, "cifs_unlink, dir=0x%p, dentry=0x%p", dir, dentry);
 
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
 	xid = GetXid();
 
 	/* Unlink can be called from rename so we can not take the
@@ -1120,8 +1170,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	full_path = build_path_from_dentry(dentry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto unlink_out;
 	}
 
 	if ((tcon->ses->capabilities & CAP_UNIX) &&
@@ -1187,10 +1236,11 @@ out_reval:
 	dir->i_ctime = dir->i_mtime = current_fs_time(sb);
 	cifs_inode = CIFS_I(dir);
 	CIFS_I(dir)->time = 0;	/* force revalidate of dir as well */
-
+unlink_out:
 	kfree(full_path);
 	kfree(attrs);
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
@@ -1199,6 +1249,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 	int rc = 0, tmprc;
 	int xid;
 	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	char *full_path = NULL;
 	struct inode *newinode = NULL;
@@ -1206,16 +1257,18 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 
 	cFYI(1, "In cifs_mkdir, mode = 0x%x inode = 0x%p", mode, inode);
 
-	xid = GetXid();
-
 	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb_tcon(cifs_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	pTcon = tlink_tcon(tlink);
+
+	xid = GetXid();
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto mkdir_out;
 	}
 
 	if ((pTcon->ses->capabilities & CAP_UNIX) &&
@@ -1373,6 +1426,7 @@ mkdir_get_info:
 mkdir_out:
 	kfree(full_path);
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
@@ -1381,6 +1435,7 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 	int rc = 0;
 	int xid;
 	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	char *full_path = NULL;
 	struct cifsInodeInfo *cifsInode;
@@ -1389,18 +1444,23 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 
 	xid = GetXid();
 
-	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb_tcon(cifs_sb);
-
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto rmdir_exit;
+	}
+
+	cifs_sb = CIFS_SB(inode->i_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
+		goto rmdir_exit;
 	}
+	pTcon = tlink_tcon(tlink);
 
 	rc = CIFSSMBRmDir(xid, pTcon, full_path, cifs_sb->local_nls,
 			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	cifs_put_tlink(tlink);
 
 	if (!rc) {
 		drop_nlink(inode);
@@ -1421,6 +1481,7 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 	direntry->d_inode->i_ctime = inode->i_ctime = inode->i_mtime =
 		current_fs_time(inode->i_sb);
 
+rmdir_exit:
 	kfree(full_path);
 	FreeXid(xid);
 	return rc;
@@ -1431,10 +1492,16 @@ cifs_do_rename(int xid, struct dentry *from_dentry, const char *fromPath,
 		struct dentry *to_dentry, const char *toPath)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(from_dentry->d_sb);
-	struct cifsTconInfo *pTcon = cifs_sb_tcon(cifs_sb);
+	struct tcon_link *tlink;
+	struct cifsTconInfo *pTcon;
 	__u16 srcfid;
 	int oplock, rc;
 
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	pTcon = tlink_tcon(tlink);
+
 	/* try path-based rename first */
 	rc = CIFSSMBRename(xid, pTcon, fromPath, toPath, cifs_sb->local_nls,
 			   cifs_sb->mnt_cifs_flags &
@@ -1446,11 +1513,11 @@ cifs_do_rename(int xid, struct dentry *from_dentry, const char *fromPath,
 	 * rename by filehandle to various Windows servers.
 	 */
 	if (rc == 0 || rc != -ETXTBSY)
-		return rc;
+		goto do_rename_exit;
 
 	/* open-file renames don't work across directories */
 	if (to_dentry->d_parent != from_dentry->d_parent)
-		return rc;
+		goto do_rename_exit;
 
 	/* open the file to be renamed -- we need DELETE perms */
 	rc = CIFSSMBOpen(xid, pTcon, fromPath, FILE_OPEN, DELETE,
@@ -1466,7 +1533,8 @@ cifs_do_rename(int xid, struct dentry *from_dentry, const char *fromPath,
 
 		CIFSSMBClose(xid, pTcon, srcfid);
 	}
-
+do_rename_exit:
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
@@ -1476,13 +1544,17 @@ int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 	char *fromName = NULL;
 	char *toName = NULL;
 	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
 	struct cifsTconInfo *tcon;
 	FILE_UNIX_BASIC_INFO *info_buf_source = NULL;
 	FILE_UNIX_BASIC_INFO *info_buf_target;
 	int xid, rc, tmprc;
 
 	cifs_sb = CIFS_SB(source_dir->i_sb);
-	tcon = cifs_sb_tcon(cifs_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
 
 	xid = GetXid();
 
@@ -1558,6 +1630,7 @@ cifs_rename_exit:
 	kfree(fromName);
 	kfree(toName);
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
@@ -1720,6 +1793,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	struct cifsFileInfo *open_file;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink = NULL;
 	struct cifsTconInfo *pTcon = NULL;
 
 	/*
@@ -1750,8 +1824,12 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 		rc = -EINVAL;
 
 	if (rc != 0) {
-		if (pTcon == NULL)
-			pTcon = cifs_sb_tcon(cifs_sb);
+		if (pTcon == NULL) {
+			tlink = cifs_sb_tlink(cifs_sb);
+			if (IS_ERR(tlink))
+				return PTR_ERR(tlink);
+			pTcon = tlink_tcon(tlink);
+		}
 
 		/* Set file size by pathname rather than by handle
 		   either because no valid, writeable file handle for
@@ -1782,6 +1860,8 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 				CIFSSMBClose(xid, pTcon, netfid);
 			}
 		}
+		if (tlink)
+			cifs_put_tlink(tlink);
 	}
 
 	if (rc == 0) {
@@ -1802,6 +1882,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	struct inode *inode = direntry->d_inode;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	struct cifs_unix_set_info_args *args = NULL;
 	struct cifsFileInfo *open_file;
@@ -1897,11 +1978,17 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		rc = CIFSSMBUnixSetFileInfo(xid, pTcon, args, nfid, npid);
 		cifsFileInfo_put(open_file);
 	} else {
-		pTcon = cifs_sb_tcon(cifs_sb);
+		tlink = cifs_sb_tlink(cifs_sb);
+		if (IS_ERR(tlink)) {
+			rc = PTR_ERR(tlink);
+			goto out;
+		}
+		pTcon = tlink_tcon(tlink);
 		rc = CIFSSMBUnixSetPathInfo(xid, pTcon, full_path, args,
 				    cifs_sb->local_nls,
 				    cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
+		cifs_put_tlink(tlink);
 	}
 
 	if (rc)
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 1ceeb8c..48de03c 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -37,17 +37,17 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 	int xid;
 	char *fromName = NULL;
 	char *toName = NULL;
-	struct cifs_sb_info *cifs_sb_target;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	struct cifsInodeInfo *cifsInode;
 
-	xid = GetXid();
-
-	cifs_sb_target = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb_tcon(cifs_sb_target);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	pTcon = tlink_tcon(tlink);
 
-/* No need to check for cross device links since server will do that
-   BB note DFS case in future though (when we may have to check) */
+	xid = GetXid();
 
 	fromName = build_path_from_dentry(old_file);
 	toName = build_path_from_dentry(direntry);
@@ -59,13 +59,13 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 /*	if (cifs_sb_target->tcon->ses->capabilities & CAP_UNIX)*/
 	if (pTcon->unix_ext)
 		rc = CIFSUnixCreateHardLink(xid, pTcon, fromName, toName,
-					    cifs_sb_target->local_nls,
-					    cifs_sb_target->mnt_cifs_flags &
+					    cifs_sb->local_nls,
+					    cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 	else {
 		rc = CIFSCreateHardLink(xid, pTcon, fromName, toName,
-					cifs_sb_target->local_nls,
-					cifs_sb_target->mnt_cifs_flags &
+					cifs_sb->local_nls,
+					cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 		if ((rc == -EIO) || (rc == -EINVAL))
 			rc = -EOPNOTSUPP;
@@ -101,6 +101,7 @@ cifs_hl_exit:
 	kfree(fromName);
 	kfree(toName);
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
@@ -113,10 +114,19 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 	char *full_path = NULL;
 	char *target_path = NULL;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
+	struct tcon_link *tlink = NULL;
+	struct cifsTconInfo *tcon;
 
 	xid = GetXid();
 
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
+		tlink = NULL;
+		goto out;
+	}
+	tcon = tlink_tcon(tlink);
+
 	/*
 	 * For now, we just handle symlinks with unix extensions enabled.
 	 * Eventually we should handle NTFS reparse points, and MacOS
@@ -151,6 +161,8 @@ out:
 	}
 
 	FreeXid(xid);
+	if (tlink)
+		cifs_put_tlink(tlink);
 	nd_set_link(nd, target_path);
 	return NULL;
 }
@@ -160,22 +172,25 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 {
 	int rc = -EOPNOTSUPP;
 	int xid;
-	struct cifs_sb_info *cifs_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	char *full_path = NULL;
 	struct inode *newinode = NULL;
 
 	xid = GetXid();
 
-	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb_tcon(cifs_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
+		goto symlink_exit;
+	}
+	pTcon = tlink_tcon(tlink);
 
 	full_path = build_path_from_dentry(direntry);
-
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto symlink_exit;
 	}
 
 	cFYI(1, "Full path: %s", full_path);
@@ -208,8 +223,9 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 			d_instantiate(direntry, newinode);
 		}
 	}
-
+symlink_exit:
 	kfree(full_path);
+	cifs_put_tlink(tlink);
 	FreeXid(xid);
 	return rc;
 }
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 0992115..42b11ef 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -224,33 +224,35 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
 static int initiate_cifs_search(const int xid, struct file *file)
 {
 	int rc = 0;
-	char *full_path;
+	char *full_path = NULL;
 	struct cifsFileInfo *cifsFile;
-	struct cifs_sb_info *cifs_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 
-	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	if (cifs_sb == NULL)
-		return -EINVAL;
-
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	pTcon = tlink_tcon(tlink);
+	
 	if (file->private_data == NULL)
 		file->private_data =
 			kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
+	if (file->private_data == NULL) {
+		rc = -ENOMEM;
+		goto error_exit;
+	}
 
-	if (file->private_data == NULL)
-		return -ENOMEM;
 	cifsFile = file->private_data;
 	cifsFile->invalidHandle = true;
 	cifsFile->srch_inf.endOfSearch = false;
-	cifsFile->tcon = cifs_sb_tcon(cifs_sb);
-	pTcon = cifsFile->tcon;
-	if (pTcon == NULL)
-		return -EINVAL;
+	cifsFile->tcon = pTcon;
 
 	full_path = build_path_from_dentry(file->f_path.dentry);
-
-	if (full_path == NULL)
-		return -ENOMEM;
+	if (full_path == NULL) {
+		rc = -ENOMEM;
+		goto error_exit;
+	}
 
 	cFYI(1, "Full path: %s start at: %lld", full_path, file->f_pos);
 
@@ -283,7 +285,9 @@ ffirst_retry:
 		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
 		goto ffirst_retry;
 	}
+error_exit:
 	kfree(full_path);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 41f95bf..a264b74 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -47,9 +47,10 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
 #ifdef CONFIG_CIFS_XATTR
 	int xid;
 	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	struct super_block *sb;
-	char *full_path;
+	char *full_path = NULL;
 
 	if (direntry == NULL)
 		return -EIO;
@@ -58,16 +59,19 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
 	sb = direntry->d_inode->i_sb;
 	if (sb == NULL)
 		return -EIO;
-	xid = GetXid();
 
 	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb_tcon(cifs_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	pTcon = tlink_tcon(tlink);
+
+	xid = GetXid();
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto remove_ea_exit;
 	}
 	if (ea_name == NULL) {
 		cFYI(1, "Null xattr names not supported");
@@ -91,6 +95,7 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
 remove_ea_exit:
 	kfree(full_path);
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 #endif
 	return rc;
 }
@@ -102,6 +107,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 #ifdef CONFIG_CIFS_XATTR
 	int xid;
 	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	struct super_block *sb;
 	char *full_path;
@@ -113,16 +119,19 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 	sb = direntry->d_inode->i_sb;
 	if (sb == NULL)
 		return -EIO;
-	xid = GetXid();
 
 	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb_tcon(cifs_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	pTcon = tlink_tcon(tlink);
+
+	xid = GetXid();
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto set_ea_exit;
 	}
 	/* return dos attributes as pseudo xattr */
 	/* return alt name if available as pseudo attr */
@@ -132,9 +141,8 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 		returns as xattrs */
 	if (value_size > MAX_EA_VALUE_SIZE) {
 		cFYI(1, "size of EA value too large");
-		kfree(full_path);
-		FreeXid(xid);
-		return -EOPNOTSUPP;
+		rc = -EOPNOTSUPP;
+		goto set_ea_exit;
 	}
 
 	if (ea_name == NULL) {
@@ -198,6 +206,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 set_ea_exit:
 	kfree(full_path);
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 #endif
 	return rc;
 }
@@ -209,6 +218,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 #ifdef CONFIG_CIFS_XATTR
 	int xid;
 	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	struct super_block *sb;
 	char *full_path;
@@ -221,16 +231,18 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 	if (sb == NULL)
 		return -EIO;
 
-	xid = GetXid();
-
 	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb_tcon(cifs_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	pTcon = tlink_tcon(tlink);
+
+	xid = GetXid();
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto get_ea_exit;
 	}
 	/* return dos attributes as pseudo xattr */
 	/* return alt name if available as pseudo attr */
@@ -323,6 +335,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 get_ea_exit:
 	kfree(full_path);
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 #endif
 	return rc;
 }
@@ -333,6 +346,7 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 #ifdef CONFIG_CIFS_XATTR
 	int xid;
 	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	struct super_block *sb;
 	char *full_path;
@@ -346,18 +360,20 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 		return -EIO;
 
 	cifs_sb = CIFS_SB(sb);
-	pTcon = cifs_sb_tcon(cifs_sb);
-
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 		return -EOPNOTSUPP;
 
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	pTcon = tlink_tcon(tlink);
+
 	xid = GetXid();
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto list_ea_exit;
 	}
 	/* return dos attributes as pseudo xattr */
 	/* return alt name if available as pseudo attr */
@@ -370,8 +386,10 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 				cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 
+list_ea_exit:
 	kfree(full_path);
 	FreeXid(xid);
+	cifs_put_tlink(tlink);
 #endif
 	return rc;
 }
-- 
1.7.2.1
