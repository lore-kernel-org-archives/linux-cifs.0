Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B75372EF0;
	Tue,  7 Apr 2026 19:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775591898; cv=none; b=YSCCziArtWT6qNiD2qm8BFfp6XwF0YAqkl6MXxms1MJKzAD9HqK1Ln2+DAPHUy5UyaQSCj9jyjqHDrKw9ZHi+CV5kwjsk+jg4MNjIYy/+H7MO2InSRqEJknl0a2XMETvixt5uf4okyveY92W9SlcS1hwcYr2CzYWoJVW55CiXk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775591898; c=relaxed/simple;
	bh=FizXOSEqjmAWOwEANCTElM3AuVE1DtiNbQ0yLT74FkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UowabQjZelVTVLACN/dVaQMVEnLFTt8fVw2xEtEyQ7zkGqo4MkGbYteRKjwM5HyqsM3GKA8+PaDL8W4XBVgtKJhEplH79+fcpmTTuCawcNleUA9F4JtrijEI9afJFpb5JjMFOOmi8PHZi+uHnlqVz56o9HhwuBaGCI981g0vwpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=cG5RWHPL; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="cG5RWHPL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=9eZN4csDmok/p+i32Hrz/nO359KHdZ9eF7XFjc0+Wr4=; b=cG5RWHPLVzEW+44TFDKnHhntaA
	sKpevBPwsTbnfYBmszhhk1T7r6U2rWjWyxFK2nq/IxZGTyr3S7hyQpKQR2TFmijNy8XudGrtr1Z60
	PlACFQTHc9OBi+hc4XqVSHlAQXKL5yfXmZZpMsEhcOhE/bm1pdVzQn7JO+SXhtCQqBSBG5Ndh7o2h
	Sj2/DdAb8pFoeM662qsVvL5KTlEpK35+0zSt4MApEmVrykN6mlgM6TzMM0viT7JK+GfBcRmJpIhcJ
	z53uutuFLMUZheW17gmytAk7OFqNjVy2z/TS9eEP7MBXy4dWesnIX+Eb3S7SO7KqFXRdfCdFnVaec
	eAL78W2A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1wACYt-00000002NG6-0Pms;
	Tue, 07 Apr 2026 16:58:11 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: viro@zeniv.linux.org.uk,
	smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 2/2] smb: client: add support for O_TMPFILE
Date: Tue,  7 Apr 2026 16:58:10 -0300
Message-ID: <20260407195810.993862-2-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260407195810.993862-1-pc@manguebit.org>
References: <20260407195810.993862-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement O_TMPFILE support for SMB2+ in the CIFS client.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
---
v1 -> v2:
  * handling of CIFS_INO_TMPFILE bit can be done locklessly, so no
    spinlock required.
  * added a very simple documentation on expected dentry states to
    cifs_atomic_open(), cifs_create and cifs_tmpfile().

 fs/smb/client/cifsfs.c    |   4 +
 fs/smb/client/cifsfs.h    |  19 ++
 fs/smb/client/cifsglob.h  |  23 ++-
 fs/smb/client/cifsproto.h |   3 +-
 fs/smb/client/dir.c       | 313 ++++++++++++++++++++++++-----
 fs/smb/client/file.c      |  53 +++--
 fs/smb/client/inode.c     |   3 +-
 fs/smb/client/link.c      |   1 +
 fs/smb/client/smb2inode.c | 400 ++++++++++++++------------------------
 9 files changed, 492 insertions(+), 327 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 32d0305a1239..f4bed8d4a072 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -124,6 +124,9 @@ MODULE_PARM_DESC(dir_cache_timeout, "Number of seconds to cache directory conten
 /* Module-wide total cached dirents (in bytes) across all tcons */
 atomic64_t cifs_dircache_bytes_used = ATOMIC64_INIT(0);
 
+atomic_t cifs_sillycounter;
+atomic_t cifs_tmpcounter;
+
 /*
  * Write-only module parameter to drop all cached directory entries across
  * all CIFS mounts. Echo a non-zero value to trigger.
@@ -1199,6 +1202,7 @@ MODULE_ALIAS("smb3");
 const struct inode_operations cifs_dir_inode_ops = {
 	.create = cifs_create,
 	.atomic_open = cifs_atomic_open,
+	.tmpfile = cifs_tmpfile,
 	.lookup = cifs_lookup,
 	.getattr = cifs_getattr,
 	.unlink = cifs_unlink,
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index e320d39b01f5..64c7a4c6ac83 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -13,6 +13,9 @@
 
 #define ROOT_I 2
 
+extern atomic_t cifs_sillycounter;
+extern atomic_t cifs_tmpcounter;
+
 /*
  * ino_t is 32-bits on 32-bit arch. We have to squash the 64-bit value down
  * so that it will fit. We use hash_64 to convert the value to 31 bits, and
@@ -53,6 +56,8 @@ int cifs_create(struct mnt_idmap *idmap, struct inode *inode,
 		struct dentry *direntry, umode_t mode, bool excl);
 int cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		     struct file *file, unsigned int oflags, umode_t mode);
+int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+		 struct file *file, umode_t mode);
 struct dentry *cifs_lookup(struct inode *parent_dir_inode,
 			   struct dentry *direntry, unsigned int flags);
 int cifs_unlink(struct inode *dir, struct dentry *dentry);
@@ -142,6 +147,20 @@ struct smb3_fs_context;
 struct dentry *cifs_smb3_do_mount(struct file_system_type *fs_type, int flags,
 				  struct smb3_fs_context *old_ctx);
 
+char *cifs_silly_fullpath(struct dentry *dentry);
+
+#define CIFS_TMPNAME_PREFIX        ".__smbfile_tmp"
+#define CIFS_TMPNAME_PREFIX_LEN    ((int)sizeof(CIFS_TMPNAME_PREFIX) - 1)
+#define CIFS_TMPNAME_COUNTER_LEN   ((int)sizeof(cifs_tmpcounter) * 2)
+#define CIFS_TMPNAME_LEN \
+	(CIFS_TMPNAME_PREFIX_LEN + CIFS_TMPNAME_COUNTER_LEN)
+
+#define CIFS_SILLYNAME_PREFIX	    ".__smbfile_silly"
+#define CIFS_SILLYNAME_PREFIX_LEN  ((int)sizeof(CIFS_SILLYNAME_PREFIX) - 1)
+#define CIFS_SILLYNAME_COUNTER_LEN ((int)sizeof(cifs_sillycounter) * 2)
+#define CIFS_SILLYNAME_LEN \
+	(CIFS_SILLYNAME_PREFIX_LEN + CIFS_SILLYNAME_COUNTER_LEN)
+
 #ifdef CONFIG_CIFS_NFSD_EXPORT
 extern const struct export_operations cifs_export_ops;
 #endif /* CONFIG_CIFS_NFSD_EXPORT */
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 709e96e07791..ccfde157d3be 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1534,9 +1534,16 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 #define CIFS_CACHE_RW_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG)
 #define CIFS_CACHE_RHW_FLG	(CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FLG)
 
-/*
- * One of these for each file inode
- */
+enum cifs_inode_flags {
+	CIFS_INODE_PENDING_OPLOCK_BREAK,	/* oplock break in progress */
+	CIFS_INODE_PENDING_WRITERS,		/* Writes in progress */
+	CIFS_INODE_FLAG_UNUSED,			/* Unused flag */
+	CIFS_INO_DELETE_PENDING,		/* delete pending on server */
+	CIFS_INO_INVALID_MAPPING,		/* pagecache is invalid */
+	CIFS_INO_LOCK,				/* lock bit for synchronization */
+	CIFS_INO_TMPFILE,			/* for O_TMPFILE inodes */
+	CIFS_INO_CLOSE_ON_LOCK,			/* Not to defer the close when lock is set */
+};
 
 struct cifsInodeInfo {
 	struct netfs_inode netfs; /* Netfslib context and vfs inode */
@@ -1554,13 +1561,6 @@ struct cifsInodeInfo {
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned int oplock;		/* oplock/lease level we have */
 	__u16 epoch;		/* used to track lease state changes */
-#define CIFS_INODE_PENDING_OPLOCK_BREAK   (0) /* oplock break in progress */
-#define CIFS_INODE_PENDING_WRITERS	  (1) /* Writes in progress */
-#define CIFS_INODE_FLAG_UNUSED		  (2) /* Unused flag */
-#define CIFS_INO_DELETE_PENDING		  (3) /* delete pending on server */
-#define CIFS_INO_INVALID_MAPPING	  (4) /* pagecache is invalid */
-#define CIFS_INO_LOCK			  (5) /* lock bit for synchronization */
-#define CIFS_INO_CLOSE_ON_LOCK            (7) /* Not to defer the close when lock is set */
 	unsigned long flags;
 	spinlock_t writers_lock;
 	unsigned int writers;		/* Number of writers on this inode */
@@ -2259,6 +2259,7 @@ struct smb2_compound_vars {
 	struct kvec qi_iov;
 	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
 	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
+	struct kvec hl_iov[SMB2_SET_INFO_IOV_SIZE];
 	struct kvec unlink_iov[SMB2_SET_INFO_IOV_SIZE];
 	struct kvec rename_iov[SMB2_SET_INFO_IOV_SIZE];
 	struct kvec close_iov;
@@ -2383,6 +2384,8 @@ static inline int cifs_open_create_options(unsigned int oflags, int opts)
 		opts |= CREATE_WRITE_THROUGH;
 	if (oflags & O_DIRECT)
 		opts |= CREATE_NO_BUFFER;
+	if (oflags & O_TMPFILE)
+		opts |= CREATE_DELETE_ON_CLOSE;
 	return opts;
 }
 
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 884bfa1cf0b4..c24c50d732e6 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -141,7 +141,8 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 			     unsigned int find_flags, unsigned int open_flags,
 			     struct cifsFileInfo **ret_file);
-int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name, int flags,
+int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
+			   struct inode *inode, int flags,
 			   struct cifsFileInfo **ret_file);
 struct cifsFileInfo *__find_readable_file(struct cifsInodeInfo *cifs_inode,
 					  unsigned int find_flags,
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 6d2378eeb7f6..67f9f956c211 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -172,20 +172,44 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
 	return 0;
 }
 
+static char *alloc_parent_path(struct dentry *dentry, size_t namelen)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry);
+	void *page = alloc_dentry_path();
+	const char *path;
+	size_t size;
+	char *npath;
+
+	path = build_path_from_dentry(dentry->d_parent, page);
+	if (IS_ERR(path)) {
+		npath = ERR_CAST(path);
+		goto out;
+	}
+
+	size = strlen(path) + namelen + 2;
+	npath = kmalloc(size, GFP_KERNEL);
+	if (!npath)
+		npath = ERR_PTR(-ENOMEM);
+	else
+		scnprintf(npath, size, "%s%c", path, CIFS_DIR_SEP(cifs_sb));
+out:
+	free_dentry_path(page);
+	return npath;
+}
 
 /* Inode operations in similar order to how they appear in Linux file fs.h */
-
-static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
-			  struct tcon_link *tlink, unsigned int oflags, umode_t mode, __u32 *oplock,
-			  struct cifs_fid *fid, struct cifs_open_info_data *buf)
+static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
+			    const char *full_path, unsigned int xid,
+			    struct tcon_link *tlink, unsigned int oflags,
+			    umode_t mode, __u32 *oplock, struct cifs_fid *fid,
+			    struct cifs_open_info_data *buf,
+			    struct inode **inode)
 {
 	int rc = -ENOENT;
 	int create_options = CREATE_NOT_DIR;
 	int desired_access;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dir);
 	struct cifs_tcon *tcon = tlink_tcon(tlink);
-	const char *full_path;
-	void *page = alloc_dentry_path();
 	struct inode *newinode = NULL;
 	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	int disposition;
@@ -199,21 +223,15 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	if (tcon->ses->server->oplocks)
 		*oplock = REQ_OPLOCK;
 
-	full_path = build_path_from_dentry(direntry, page);
-	if (IS_ERR(full_path)) {
-		rc = PTR_ERR(full_path);
-		goto out;
-	}
-
 	/* If we're caching, we need to be able to fill in around partial writes. */
-	if (cifs_fscache_enabled(inode) && (oflags & O_ACCMODE) == O_WRONLY)
+	if (cifs_fscache_enabled(dir) && (oflags & O_ACCMODE) == O_WRONLY)
 		rdwr_for_fscache = 1;
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (tcon->unix_ext && cap_unix(tcon->ses) && !tcon->broken_posix_open &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
-		rc = cifs_posix_open(full_path, &newinode, inode->i_sb, mode,
+		rc = cifs_posix_open(full_path, &newinode, dir->i_sb, mode,
 				     oflags, oplock, &fid->netfid, xid);
 		switch (rc) {
 		case 0:
@@ -225,8 +243,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 			if (S_ISDIR(newinode->i_mode)) {
 				CIFSSMBClose(xid, tcon, fid->netfid);
 				iput(newinode);
-				rc = -EISDIR;
-				goto out;
+				return -EISDIR;
 			}
 
 			if (!S_ISREG(newinode->i_mode)) {
@@ -269,7 +286,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 			break;
 
 		default:
-			goto out;
+			return rc;
 		}
 		/*
 		 * fallthrough to retry, using older open call, this is case
@@ -287,26 +304,30 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 		desired_access |= GENERIC_WRITE;
 	if (rdwr_for_fscache == 1)
 		desired_access |= GENERIC_READ;
+	if (oflags & O_TMPFILE)
+		desired_access |= DELETE;
 
 	disposition = FILE_OVERWRITE_IF;
-	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+	if (oflags & O_CREAT) {
+		if (oflags & O_EXCL)
+			disposition = FILE_CREATE;
+		else if (oflags & O_TRUNC)
+			disposition = FILE_OVERWRITE_IF;
+		else
+			disposition = FILE_OPEN_IF;
+	} else if (oflags & O_TMPFILE) {
 		disposition = FILE_CREATE;
-	else if ((oflags & (O_CREAT | O_TRUNC)) == (O_CREAT | O_TRUNC))
-		disposition = FILE_OVERWRITE_IF;
-	else if ((oflags & O_CREAT) == O_CREAT)
-		disposition = FILE_OPEN_IF;
-	else
+	} else {
 		cifs_dbg(FYI, "Create flag not set in create function\n");
+	}
 
 	/*
 	 * BB add processing to set equivalent of mode - e.g. via CreateX with
 	 * ACLs
 	 */
 
-	if (!server->ops->open) {
-		rc = -ENOSYS;
-		goto out;
-	}
+	if (!server->ops->open)
+		return -EOPNOTSUPP;
 
 	create_options |= cifs_open_create_options(oflags, create_options);
 	/*
@@ -358,10 +379,10 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 			rdwr_for_fscache = 2;
 			goto retry_open;
 		}
-		goto out;
+		return rc;
 	}
 	if (rdwr_for_fscache == 2)
-		cifs_invalidate_cache(inode, FSCACHE_INVAL_DIO_WRITE);
+		cifs_invalidate_cache(dir, FSCACHE_INVAL_DIO_WRITE);
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	/*
@@ -379,8 +400,8 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 
 		if (sbflags & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
-			if (inode->i_mode & S_ISGID)
-				args.gid = inode->i_gid;
+			if (dir->i_mode & S_ISGID)
+				args.gid = dir->i_gid;
 			else
 				args.gid = current_fsgid();
 		} else {
@@ -402,14 +423,14 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 cifs_create_get_file_info:
 	/* server might mask mode so we have to query for it */
 	if (tcon->unix_ext)
-		rc = cifs_get_inode_info_unix(&newinode, full_path, inode->i_sb,
+		rc = cifs_get_inode_info_unix(&newinode, full_path, dir->i_sb,
 					      xid);
 	else {
 #else
 	{
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 		/* TODO: Add support for calling POSIX query info here, but passing in fid */
-		rc = cifs_get_inode_info(&newinode, full_path, buf, inode->i_sb, xid, fid);
+		rc = cifs_get_inode_info(&newinode, full_path, buf, dir->i_sb, xid, fid);
 		if (newinode) {
 			if (server->ops->set_lease_key)
 				server->ops->set_lease_key(newinode, fid);
@@ -418,8 +439,8 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 					newinode->i_mode = mode;
 				if (sbflags & CIFS_MOUNT_SET_UID) {
 					newinode->i_uid = current_fsuid();
-					if (inode->i_mode & S_ISGID)
-						newinode->i_gid = inode->i_gid;
+					if (dir->i_mode & S_ISGID)
+						newinode->i_gid = dir->i_gid;
 					else
 						newinode->i_gid = current_fsgid();
 				}
@@ -436,17 +457,13 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 		goto out_err;
 	}
 
-	if (newinode)
-		if (S_ISDIR(newinode->i_mode)) {
-			rc = -EISDIR;
-			goto out_err;
-		}
+	if (newinode && S_ISDIR(newinode->i_mode)) {
+		rc = -EISDIR;
+		goto out_err;
+	}
 
 	d_drop(direntry);
-	d_add(direntry, newinode);
-
-out:
-	free_dentry_path(page);
+	*inode = newinode;
 	return rc;
 
 out_err:
@@ -454,9 +471,41 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 		server->ops->close(xid, tcon, fid);
 	if (newinode)
 		iput(newinode);
-	goto out;
+	return rc;
 }
 
+static int cifs_do_create(struct inode *dir, struct dentry *direntry,
+			  unsigned int xid, struct tcon_link *tlink,
+			  unsigned int oflags, umode_t mode,
+			  __u32 *oplock, struct cifs_fid *fid,
+			  struct cifs_open_info_data *buf)
+{
+	void *page = alloc_dentry_path();
+	const char *full_path;
+	struct inode *inode;
+	int rc;
+
+	full_path = build_path_from_dentry(direntry, page);
+	if (IS_ERR(full_path)) {
+		rc = PTR_ERR(full_path);
+	} else {
+		rc = __cifs_do_create(dir, direntry, full_path, xid,
+				      tlink, oflags, mode, oplock,
+				      fid, buf, &inode);
+		if (!rc)
+			d_add(direntry, inode);
+	}
+	free_dentry_path(page);
+	return rc;
+}
+
+
+/*
+ * Look up, create and open a CIFS file.
+ *
+ * The initial dentry state is in-lookup or hashed-negative.  On success, dentry
+ * will become hashed-positive by calling d_drop() & d_add(), respectively.
+ */
 int
 cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		 struct file *file, unsigned int oflags, umode_t mode)
@@ -569,6 +618,12 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	return rc;
 }
 
+/*
+ * Create a CIFS file.
+ *
+ * The initial dentry state is hashed-negative.  On success, dentry will become
+ * hashed-positive by calling d_drop() & d_add(), respectively.
+ */
 int cifs_create(struct mnt_idmap *idmap, struct inode *inode,
 		struct dentry *direntry, umode_t mode, bool excl)
 {
@@ -959,6 +1014,172 @@ static int cifs_ci_compare(const struct dentry *dentry,
 	return 0;
 }
 
+static int set_hidden_attr(const unsigned int xid,
+			   struct TCP_Server_Info *server,
+			   struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct cifsInodeInfo *cinode = CIFS_I(d_inode(dentry));
+	FILE_BASIC_INFO fi = {
+		.Attributes = cpu_to_le32(cinode->cifsAttrs |
+					  ATTR_HIDDEN),
+	};
+	void *page = alloc_dentry_path();
+	const char *full_path;
+	int rc;
+
+	full_path = build_path_from_dentry(dentry, page);
+	if (IS_ERR(full_path))
+		rc = PTR_ERR(full_path);
+	else
+		rc =  server->ops->set_file_info(d_inode(dentry),
+						 full_path, &fi, xid);
+	free_dentry_path(page);
+	return rc;
+}
+
+/*
+ * Create a hidden temporary CIFS file with delete-on-close bit set.
+ *
+ * The initial dentry state is unhashed-negative.  On success, dentry will
+ * become unhashed-positive by calling d_drop() & d_instantiate(), respectively.
+ */
+int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+		 struct file *file, umode_t mode)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dir);
+	size_t size = CIFS_TMPNAME_LEN + 1;
+	int retries = 0, max_retries = 16;
+	struct TCP_Server_Info *server;
+	struct cifs_pending_open open;
+	struct cifsFileInfo *cfile;
+	struct cifs_fid fid = {};
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	unsigned int sbflags;
+	struct inode *inode;
+	char *path, *name;
+	unsigned int xid;
+	__u32 oplock;
+	int rc;
+
+	if (unlikely(cifs_forced_shutdown(cifs_sb)))
+		return smb_EIO(smb_eio_trace_forced_shutdown);
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
+
+	xid = get_xid();
+
+	if (server->vals->protocol_id < SMB20_PROT_ID) {
+		cifs_dbg(VFS | ONCE, "O_TMPFILE is supported only in SMB2+\n");
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (server->ops->new_lease_key)
+		server->ops->new_lease_key(&fid);
+	cifs_add_pending_open(&fid, tlink, &open);
+
+	path = alloc_parent_path(dentry, size - 1);
+	if (IS_ERR(path)) {
+		cifs_del_pending_open(&open);
+		rc = PTR_ERR(path);
+		goto out;
+	}
+
+	name = path + strlen(path);
+	do {
+		scnprintf(name, size,
+			  CIFS_TMPNAME_PREFIX "%0*x",
+			  CIFS_TMPNAME_COUNTER_LEN,
+			  atomic_inc_return(&cifs_tmpcounter));
+		rc = __cifs_do_create(dir, dentry, path, xid, tlink,
+				      file->f_flags, mode, &oplock,
+				      &fid, NULL, &inode);
+		if (!rc) {
+			set_nlink(inode, 0);
+			mark_inode_dirty(inode);
+			d_mark_tmpfile_name(file, &QSTR_LEN(name, size - 1));
+			d_instantiate(dentry, inode);
+			break;
+		}
+	} while (unlikely(rc == -EEXIST) && ++retries < max_retries);
+
+	kfree(path);
+	if (rc) {
+		cifs_del_pending_open(&open);
+		goto out;
+	}
+
+	rc = finish_open(file, dentry, generic_file_open);
+	if (rc)
+		goto err_open;
+
+	sbflags = cifs_sb_flags(cifs_sb);
+	if ((file->f_flags & O_DIRECT) && (sbflags & CIFS_MOUNT_STRICT_IO)) {
+		if (sbflags & CIFS_MOUNT_NO_BRL)
+			file->f_op = &cifs_file_direct_nobrl_ops;
+		else
+			file->f_op = &cifs_file_direct_ops;
+	}
+
+	cfile = cifs_new_fileinfo(&fid, file, tlink, oplock, NULL);
+	if (!cfile) {
+		rc = -ENOMEM;
+		goto err_open;
+	}
+
+	rc = set_hidden_attr(xid, server, file);
+	if (rc)
+		goto out;
+
+	fscache_use_cookie(cifs_inode_cookie(file_inode(file)),
+			   file->f_mode & FMODE_WRITE);
+out:
+	cifs_put_tlink(tlink);
+	free_xid(xid);
+	return rc;
+err_open:
+	cifs_del_pending_open(&open);
+	if (server->ops->close)
+		server->ops->close(xid, tcon, &fid);
+	goto out;
+}
+
+char *cifs_silly_fullpath(struct dentry *dentry)
+{
+	unsigned char name[CIFS_SILLYNAME_LEN + 1];
+	int retries = 0, max_retries = 16;
+	size_t namesize = sizeof(name);
+	struct dentry *sdentry = NULL;
+	char *path;
+
+	do {
+		dput(sdentry);
+		scnprintf(name, namesize,
+			  CIFS_SILLYNAME_PREFIX "%0*x",
+			  CIFS_SILLYNAME_COUNTER_LEN,
+			  atomic_inc_return(&cifs_sillycounter));
+		sdentry = lookup_noperm(&QSTR(name), dentry->d_parent);
+		if (IS_ERR(sdentry))
+			return ERR_CAST(sdentry);
+		if (d_is_negative(sdentry)) {
+			dput(sdentry);
+			path = alloc_parent_path(dentry, CIFS_SILLYNAME_LEN);
+			if (!IS_ERR(path))
+				strcat(path, name);
+			return path;
+		}
+	} while (++retries < max_retries);
+	dput(sdentry);
+	return ERR_PTR(-EBUSY);
+}
+
 const struct dentry_operations cifs_ci_dentry_ops = {
 	.d_revalidate = cifs_d_revalidate,
 	.d_hash = cifs_ci_hash,
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index a69e05f86d7e..5d5b49468aff 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -406,22 +406,29 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	 */
 }
 
-static inline int cifs_convert_flags(unsigned int flags, int rdwr_for_fscache)
+static inline int cifs_convert_flags(unsigned int oflags, int rdwr_for_fscache)
 {
-	if ((flags & O_ACCMODE) == O_RDONLY)
-		return GENERIC_READ;
-	else if ((flags & O_ACCMODE) == O_WRONLY)
-		return rdwr_for_fscache == 1 ? (GENERIC_READ | GENERIC_WRITE) : GENERIC_WRITE;
-	else if ((flags & O_ACCMODE) == O_RDWR) {
+	int flags = 0;
+
+	if (oflags & O_TMPFILE)
+		flags |= DELETE;
+
+	if ((oflags & O_ACCMODE) == O_RDONLY)
+		return flags | GENERIC_READ;
+	if ((oflags & O_ACCMODE) == O_WRONLY) {
+		return flags | (rdwr_for_fscache == 1 ?
+				(GENERIC_READ | GENERIC_WRITE) : GENERIC_WRITE);
+	}
+	if ((oflags & O_ACCMODE) == O_RDWR) {
 		/* GENERIC_ALL is too much permission to request
 		   can cause unnecessary access denied on create */
 		/* return GENERIC_ALL; */
-		return (GENERIC_READ | GENERIC_WRITE);
+		return flags | GENERIC_READ | GENERIC_WRITE;
 	}
 
-	return (READ_CONTROL | FILE_WRITE_ATTRIBUTES | FILE_READ_ATTRIBUTES |
-		FILE_WRITE_EA | FILE_APPEND_DATA | FILE_WRITE_DATA |
-		FILE_READ_DATA);
+	return flags | READ_CONTROL | FILE_WRITE_ATTRIBUTES |
+		FILE_READ_ATTRIBUTES | FILE_WRITE_EA | FILE_APPEND_DATA |
+		FILE_WRITE_DATA | FILE_READ_DATA;
 }
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
@@ -696,6 +703,7 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	cfile->f_flags = file->f_flags;
 	cfile->invalidHandle = false;
 	cfile->deferred_close_scheduled = false;
+	cfile->status_file_deleted = file->f_flags & O_TMPFILE;
 	cfile->tlink = cifs_get_tlink(tlink);
 	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
 	INIT_WORK(&cfile->put, cifsFileInfo_put_work);
@@ -727,6 +735,8 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 
 	/* if readable file instance put first in list*/
 	spin_lock(&cinode->open_file_lock);
+	if (file->f_flags & O_TMPFILE)
+		set_bit(CIFS_INO_TMPFILE, &cinode->flags);
 	fid->purge_cache = false;
 	server->ops->set_fid(cfile, fid, oplock);
 
@@ -2578,13 +2588,12 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 			     struct cifsFileInfo **ret_file)
 {
 	struct cifsFileInfo *open_file, *inv_file = NULL;
+	bool fsuid_only, with_delete;
 	struct cifs_sb_info *cifs_sb;
 	bool any_available = false;
-	int rc = -EBADF;
 	unsigned int refind = 0;
-	bool fsuid_only = find_flags & FIND_FSUID_ONLY;
-	bool with_delete = find_flags & FIND_WITH_DELETE;
 	*ret_file = NULL;
+	int rc = -EBADF;
 
 	/*
 	 * Having a null inode here (because mapping->host was set to zero by
@@ -2598,8 +2607,13 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 		return rc;
 	}
 
+	if (test_bit(CIFS_INO_TMPFILE, &cifs_inode->flags))
+		find_flags = FIND_ANY;
+
 	cifs_sb = CIFS_SB(cifs_inode);
 
+	with_delete = find_flags & FIND_WITH_DELETE;
+	fsuid_only = find_flags & FIND_FSUID_ONLY;
 	/* only filter by fsuid on multiuser mounts */
 	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
@@ -2683,16 +2697,19 @@ find_writable_file(struct cifsInodeInfo *cifs_inode, int flags)
 	return cfile;
 }
 
-int
-cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
-		       int flags,
-		       struct cifsFileInfo **ret_file)
+int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
+			   struct inode *inode, int flags,
+			   struct cifsFileInfo **ret_file)
 {
 	struct cifsFileInfo *cfile;
-	void *page = alloc_dentry_path();
+	void *page;
 
 	*ret_file = NULL;
 
+	if (inode)
+		return cifs_get_writable_file(CIFS_I(inode), flags, ret_file);
+
+	page = alloc_dentry_path();
 	spin_lock(&tcon->open_file_lock);
 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 		struct cifsInodeInfo *cinode;
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 888f9e35f14b..24040909d184 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2690,7 +2690,8 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct cached_fid *cfid = NULL;
 
-	if (test_bit(CIFS_INO_DELETE_PENDING, &cifs_i->flags))
+	if (test_bit(CIFS_INO_DELETE_PENDING, &cifs_i->flags) ||
+	    test_bit(CIFS_INO_TMPFILE, &cifs_i->flags))
 		return false;
 	if (cifs_i->time == 0)
 		return true;
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 434e8fe74080..dd127917a340 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -503,6 +503,7 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 	if (d_really_is_positive(old_file)) {
 		cifsInode = CIFS_I(d_inode(old_file));
 		if (rc == 0) {
+			clear_bit(CIFS_INO_TMPFILE, &cifsInode->flags);
 			spin_lock(&d_inode(old_file)->i_lock);
 			inc_nlink(d_inode(old_file));
 			spin_unlock(&d_inode(old_file)->i_lock);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 364bdcff9c9d..5b056d67fcef 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -164,6 +164,27 @@ static int check_wsl_eas(struct kvec *rsp_iov)
 	return 0;
 }
 
+/*
+ * If @cfile is NULL, then need to account for trailing CLOSE request in the
+ * compound chain.
+ */
+static void set_next_compound(struct cifs_tcon *tcon,
+			      struct cifsFileInfo *cfile,
+			      int i, int num_cmds,
+			      struct smb_rqst *rqst, int *num_rqst)
+{
+	int k = !cfile ? 1 : 0;
+
+	if (i + 1 < num_cmds + k)
+		smb2_set_next_command(tcon, &rqst[*num_rqst]);
+	if (i + k > 0)
+		smb2_set_related(&rqst[*num_rqst]);
+	(*num_rqst)++;
+}
+
+#define COMP_PID(cfile) ((cfile) ? (cfile)->fid.persistent_fid : COMPOUND_FID)
+#define COMP_VID(cfile) ((cfile) ? (cfile)->fid.volatile_fid : COMPOUND_FID)
+
 /*
  * note: If cfile is passed, the reference to it is dropped here.
  * So make sure that you do not reuse cfile after return from this func.
@@ -284,32 +305,16 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			rqst[num_rqst].rq_iov = &vars->qi_iov;
 			rqst[num_rqst].rq_nvec = 1;
 
-			if (cfile) {
-				rc = SMB2_query_info_init(tcon, server,
-							  &rqst[num_rqst],
-							  cfile->fid.persistent_fid,
-							  cfile->fid.volatile_fid,
-							  FILE_ALL_INFORMATION,
-							  SMB2_O_INFO_FILE, 0,
-							  sizeof(struct smb2_file_all_info) +
-							  PATH_MAX * 2, 0, NULL);
-			} else {
-				rc = SMB2_query_info_init(tcon, server,
-							  &rqst[num_rqst],
-							  COMPOUND_FID,
-							  COMPOUND_FID,
-							  FILE_ALL_INFORMATION,
-							  SMB2_O_INFO_FILE, 0,
-							  sizeof(struct smb2_file_all_info) +
-							  PATH_MAX * 2, 0, NULL);
-			}
-			if (!rc && (!cfile || num_rqst > 1)) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			} else if (rc) {
+			rc = SMB2_query_info_init(tcon, server,
+						  &rqst[num_rqst],
+						  COMP_PID(cfile), COMP_VID(cfile),
+						  FILE_ALL_INFORMATION,
+						  SMB2_O_INFO_FILE, 0,
+						  sizeof(struct smb2_file_all_info) +
+						  PATH_MAX * 2, 0, NULL);
+			if (rc)
 				goto finished;
-			}
-			num_rqst++;
+			set_next_compound(tcon, cfile, i, num_cmds, rqst, &num_rqst);
 			trace_smb3_query_info_compound_enter(xid, tcon->tid,
 							     ses->Suid, full_path);
 			break;
@@ -317,35 +322,18 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			rqst[num_rqst].rq_iov = &vars->qi_iov;
 			rqst[num_rqst].rq_nvec = 1;
 
-			if (cfile) {
-				/* TBD: fix following to allow for longer SIDs */
-				rc = SMB2_query_info_init(tcon, server,
-							  &rqst[num_rqst],
-							  cfile->fid.persistent_fid,
-							  cfile->fid.volatile_fid,
-							  SMB_FIND_FILE_POSIX_INFO,
-							  SMB2_O_INFO_FILE, 0,
-							  sizeof(struct smb311_posix_qinfo) +
-							  (PATH_MAX * 2) +
-							  (sizeof(struct smb_sid) * 2), 0, NULL);
-			} else {
-				rc = SMB2_query_info_init(tcon, server,
-							  &rqst[num_rqst],
-							  COMPOUND_FID,
-							  COMPOUND_FID,
-							  SMB_FIND_FILE_POSIX_INFO,
-							  SMB2_O_INFO_FILE, 0,
-							  sizeof(struct smb311_posix_qinfo) +
-							  (PATH_MAX * 2) +
-							  (sizeof(struct smb_sid) * 2), 0, NULL);
-			}
-			if (!rc && (!cfile || num_rqst > 1)) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			} else if (rc) {
+			/* TBD: fix following to allow for longer SIDs */
+			rc = SMB2_query_info_init(tcon, server,
+						  &rqst[num_rqst],
+						  COMP_PID(cfile), COMP_VID(cfile),
+						  SMB_FIND_FILE_POSIX_INFO,
+						  SMB2_O_INFO_FILE, 0,
+						  sizeof(struct smb311_posix_qinfo) +
+						  (PATH_MAX * 2) +
+						  (sizeof(struct smb_sid) * 2), 0, NULL);
+			if (rc)
 				goto finished;
-			}
-			num_rqst++;
+			set_next_compound(tcon, cfile, i, num_cmds, rqst, &num_rqst);
 			trace_smb3_posix_query_info_compound_enter(xid, tcon->tid,
 								   ses->Suid, full_path);
 			break;
@@ -363,32 +351,15 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			size[0] = 1; /* sizeof __u8 See MS-FSCC section 2.4.11 */
 			data[0] = &delete_pending[0];
 
-			if (cfile) {
-				rc = SMB2_set_info_init(tcon, server,
-							&rqst[num_rqst],
-							cfile->fid.persistent_fid,
-							cfile->fid.volatile_fid,
-							current->tgid,
-							FILE_DISPOSITION_INFORMATION,
-							SMB2_O_INFO_FILE, 0,
-							data, size);
-			} else {
-				rc = SMB2_set_info_init(tcon, server,
-							&rqst[num_rqst],
-							COMPOUND_FID,
-							COMPOUND_FID,
-							current->tgid,
-							FILE_DISPOSITION_INFORMATION,
-							SMB2_O_INFO_FILE, 0,
-							data, size);
-			}
-			if (!rc && (!cfile || num_rqst > 1)) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			} else if (rc) {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						COMP_PID(cfile), COMP_VID(cfile),
+						current->tgid, FILE_DISPOSITION_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+			if (rc)
 				goto finished;
-			}
-			num_rqst++;
+			set_next_compound(tcon, cfile, i, num_cmds, rqst, &num_rqst);
 			trace_smb3_unlink_enter(xid, tcon->tid, ses->Suid, full_path);
 			break;
 		case SMB2_OP_SET_EOF:
@@ -398,32 +369,15 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			size[0] = in_iov[i].iov_len;
 			data[0] = in_iov[i].iov_base;
 
-			if (cfile) {
-				rc = SMB2_set_info_init(tcon, server,
-							&rqst[num_rqst],
-							cfile->fid.persistent_fid,
-							cfile->fid.volatile_fid,
-							current->tgid,
-							FILE_END_OF_FILE_INFORMATION,
-							SMB2_O_INFO_FILE, 0,
-							data, size);
-			} else {
-				rc = SMB2_set_info_init(tcon, server,
-							&rqst[num_rqst],
-							COMPOUND_FID,
-							COMPOUND_FID,
-							current->tgid,
-							FILE_END_OF_FILE_INFORMATION,
-							SMB2_O_INFO_FILE, 0,
-							data, size);
-			}
-			if (!rc && (!cfile || num_rqst > 1)) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			} else if (rc) {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						COMP_PID(cfile), COMP_VID(cfile),
+						current->tgid, FILE_END_OF_FILE_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+			if (rc)
 				goto finished;
-			}
-			num_rqst++;
+			set_next_compound(tcon, cfile, i, num_cmds, rqst, &num_rqst);
 			trace_smb3_set_eof_enter(xid, tcon->tid, ses->Suid, full_path);
 			break;
 		case SMB2_OP_SET_INFO:
@@ -433,28 +387,14 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			size[0] = in_iov[i].iov_len;
 			data[0] = in_iov[i].iov_base;
 
-			if (cfile) {
-				rc = SMB2_set_info_init(tcon, server,
-							&rqst[num_rqst],
-							cfile->fid.persistent_fid,
-							cfile->fid.volatile_fid, current->tgid,
-							FILE_BASIC_INFORMATION,
-							SMB2_O_INFO_FILE, 0, data, size);
-			} else {
-				rc = SMB2_set_info_init(tcon, server,
-							&rqst[num_rqst],
-							COMPOUND_FID,
-							COMPOUND_FID, current->tgid,
-							FILE_BASIC_INFORMATION,
-							SMB2_O_INFO_FILE, 0, data, size);
-			}
-			if (!rc && (!cfile || num_rqst > 1)) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			} else if (rc) {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						COMP_PID(cfile), COMP_VID(cfile),
+						current->tgid, FILE_BASIC_INFORMATION,
+						SMB2_O_INFO_FILE, 0, data, size);
+			if (rc)
 				goto finished;
-			}
-			num_rqst++;
+			set_next_compound(tcon, cfile, i, num_cmds, rqst, &num_rqst);
 			trace_smb3_set_info_compound_enter(xid, tcon->tid,
 							   ses->Suid, full_path);
 			break;
@@ -474,31 +414,19 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			size[1] = len + 2 /* null */;
 			data[1] = in_iov[i].iov_base;
 
-			if (cfile) {
-				rc = SMB2_set_info_init(tcon, server,
-							&rqst[num_rqst],
-							cfile->fid.persistent_fid,
-							cfile->fid.volatile_fid,
-							current->tgid, FILE_RENAME_INFORMATION,
-							SMB2_O_INFO_FILE, 0, data, size);
-			} else {
-				rc = SMB2_set_info_init(tcon, server,
-							&rqst[num_rqst],
-							COMPOUND_FID, COMPOUND_FID,
-							current->tgid, FILE_RENAME_INFORMATION,
-							SMB2_O_INFO_FILE, 0, data, size);
-			}
-			if (!rc && (!cfile || num_rqst > 1)) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			} else if (rc) {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						COMP_PID(cfile), COMP_VID(cfile),
+						current->tgid, FILE_RENAME_INFORMATION,
+						SMB2_O_INFO_FILE, 0, data, size);
+
+			if (rc)
 				goto finished;
-			}
-			num_rqst++;
+			set_next_compound(tcon, cfile, i, num_cmds, rqst, &num_rqst);
 			trace_smb3_rename_enter(xid, tcon->tid, ses->Suid, full_path);
 			break;
 		case SMB2_OP_HARDLINK:
-			rqst[num_rqst].rq_iov = &vars->si_iov[0];
+			rqst[num_rqst].rq_iov = vars->hl_iov;
 			rqst[num_rqst].rq_nvec = 2;
 
 			len = in_iov[i].iov_len;
@@ -514,41 +442,27 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			data[1] = in_iov[i].iov_base;
 
 			rc = SMB2_set_info_init(tcon, server,
-						&rqst[num_rqst], COMPOUND_FID,
-						COMPOUND_FID, current->tgid,
-						FILE_LINK_INFORMATION,
+						&rqst[num_rqst],
+						COMP_PID(cfile), COMP_VID(cfile),
+						current->tgid, FILE_LINK_INFORMATION,
 						SMB2_O_INFO_FILE, 0, data, size);
 			if (rc)
 				goto finished;
-			smb2_set_next_command(tcon, &rqst[num_rqst]);
-			smb2_set_related(&rqst[num_rqst++]);
+			set_next_compound(tcon, cfile, i, num_cmds, rqst, &num_rqst);
 			trace_smb3_hardlink_enter(xid, tcon->tid, ses->Suid, full_path);
 			break;
 		case SMB2_OP_SET_REPARSE:
 			rqst[num_rqst].rq_iov = vars->io_iov;
 			rqst[num_rqst].rq_nvec = ARRAY_SIZE(vars->io_iov);
 
-			if (cfile) {
-				rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
-						     cfile->fid.persistent_fid,
-						     cfile->fid.volatile_fid,
-						     FSCTL_SET_REPARSE_POINT,
-						     in_iov[i].iov_base,
-						     in_iov[i].iov_len, 0);
-			} else {
-				rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
-						     COMPOUND_FID, COMPOUND_FID,
-						     FSCTL_SET_REPARSE_POINT,
-						     in_iov[i].iov_base,
-						     in_iov[i].iov_len, 0);
-			}
-			if (!rc && (!cfile || num_rqst > 1)) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			} else if (rc) {
+			rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
+					     COMP_PID(cfile), COMP_VID(cfile),
+					     FSCTL_SET_REPARSE_POINT,
+					     in_iov[i].iov_base,
+					     in_iov[i].iov_len, 0);
+			if (rc)
 				goto finished;
-			}
-			num_rqst++;
+			set_next_compound(tcon, cfile, i, num_cmds, rqst, &num_rqst);
 			trace_smb3_set_reparse_compound_enter(xid, tcon->tid,
 							      ses->Suid, full_path);
 			break;
@@ -556,25 +470,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			rqst[num_rqst].rq_iov = vars->io_iov;
 			rqst[num_rqst].rq_nvec = ARRAY_SIZE(vars->io_iov);
 
-			if (cfile) {
-				rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
-						     cfile->fid.persistent_fid,
-						     cfile->fid.volatile_fid,
-						     FSCTL_GET_REPARSE_POINT,
-						     NULL, 0, CIFSMaxBufSize);
-			} else {
-				rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
-						     COMPOUND_FID, COMPOUND_FID,
-						     FSCTL_GET_REPARSE_POINT,
-						     NULL, 0, CIFSMaxBufSize);
-			}
-			if (!rc && (!cfile || num_rqst > 1)) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			} else if (rc) {
+			rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
+					     COMP_PID(cfile), COMP_VID(cfile),
+					     FSCTL_GET_REPARSE_POINT,
+					     NULL, 0, CIFSMaxBufSize);
+			if (rc)
 				goto finished;
-			}
-			num_rqst++;
+			set_next_compound(tcon, cfile, i, num_cmds, rqst, &num_rqst);
 			trace_smb3_get_reparse_compound_enter(xid, tcon->tid,
 							      ses->Suid, full_path);
 			break;
@@ -582,34 +484,17 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			rqst[num_rqst].rq_iov = &vars->ea_iov;
 			rqst[num_rqst].rq_nvec = 1;
 
-			if (cfile) {
-				rc = SMB2_query_info_init(tcon, server,
-							  &rqst[num_rqst],
-							  cfile->fid.persistent_fid,
-							  cfile->fid.volatile_fid,
-							  FILE_FULL_EA_INFORMATION,
-							  SMB2_O_INFO_FILE, 0,
-							  SMB2_WSL_MAX_QUERY_EA_RESP_SIZE,
-							  sizeof(wsl_query_eas),
-							  (void *)wsl_query_eas);
-			} else {
-				rc = SMB2_query_info_init(tcon, server,
-							  &rqst[num_rqst],
-							  COMPOUND_FID,
-							  COMPOUND_FID,
-							  FILE_FULL_EA_INFORMATION,
-							  SMB2_O_INFO_FILE, 0,
-							  SMB2_WSL_MAX_QUERY_EA_RESP_SIZE,
-							  sizeof(wsl_query_eas),
-							  (void *)wsl_query_eas);
-			}
-			if (!rc && (!cfile || num_rqst > 1)) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			} else if (rc) {
+			rc = SMB2_query_info_init(tcon, server,
+						  &rqst[num_rqst],
+						  COMP_PID(cfile), COMP_VID(cfile),
+						  FILE_FULL_EA_INFORMATION,
+						  SMB2_O_INFO_FILE, 0,
+						  SMB2_WSL_MAX_QUERY_EA_RESP_SIZE,
+						  sizeof(wsl_query_eas),
+						  (void *)wsl_query_eas);
+			if (rc)
 				goto finished;
-			}
-			num_rqst++;
+			set_next_compound(tcon, cfile, i, num_cmds, rqst, &num_rqst);
 			trace_smb3_query_wsl_ea_compound_enter(xid, tcon->tid,
 							       ses->Suid, full_path);
 			break;
@@ -1156,7 +1041,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 	cifs_i = CIFS_I(inode);
 	dosattrs = cifs_i->cifsAttrs | ATTR_READONLY;
 	data.Attributes = cpu_to_le32(dosattrs);
-	cifs_get_writable_path(tcon, name, FIND_ANY, &cfile);
+	cifs_get_writable_path(tcon, name, inode, FIND_ANY, &cfile);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name, FILE_WRITE_ATTRIBUTES,
 			     FILE_CREATE, CREATE_NOT_FILE, ACL_NO_MODE);
 	tmprc = smb2_compound_op(xid, tcon, cifs_sb, name,
@@ -1332,17 +1217,20 @@ int smb2_rename_path(const unsigned int xid,
 		     const char *from_name, const char *to_name,
 		     struct cifs_sb_info *cifs_sb)
 {
+	struct inode *inode = source_dentry ? d_inode(source_dentry) : NULL;
 	struct cifsFileInfo *cfile;
 	__u32 co = file_create_options(source_dentry);
 
 	drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
-	cifs_get_writable_path(tcon, from_name, FIND_WITH_DELETE, &cfile);
+	cifs_get_writable_path(tcon, from_name, inode,
+			       FIND_WITH_DELETE, &cfile);
 
 	int rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
 				  co, DELETE, SMB2_OP_RENAME, cfile, source_dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease");
-		cifs_get_writable_path(tcon, from_name, FIND_WITH_DELETE, &cfile);
+		cifs_get_writable_path(tcon, from_name, inode,
+				       FIND_WITH_DELETE, &cfile);
 		rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
 				  co, DELETE, SMB2_OP_RENAME, cfile, NULL);
 	}
@@ -1355,11 +1243,32 @@ int smb2_create_hardlink(const unsigned int xid,
 			 const char *from_name, const char *to_name,
 			 struct cifs_sb_info *cifs_sb)
 {
+	struct inode *inode = source_dentry ? d_inode(source_dentry) : NULL;
 	__u32 co = file_create_options(source_dentry);
+	struct cifsFileInfo *cfile;
 
+	if (inode) {
+		struct cifsInodeInfo *cinode = CIFS_I(inode);
+		FILE_BASIC_INFO fi;
+		__le32 attrs;
+		int rc;
+
+		if (!test_bit(CIFS_INO_TMPFILE, &CIFS_I(inode)->flags))
+			goto out;
+
+		attrs = cpu_to_le32(cinode->cifsAttrs & ~ATTR_HIDDEN);
+		fi = (FILE_BASIC_INFO){ .Attributes = attrs, };
+		rc = smb2_set_file_info(inode, from_name, &fi, xid);
+		if (rc)
+			return rc;
+	}
+
+out:
+	cifs_get_writable_path(tcon, from_name, inode,
+			       FIND_WITH_DELETE, &cfile);
 	return smb2_set_path_attr(xid, tcon, from_name, to_name,
 				  cifs_sb, co, FILE_READ_ATTRIBUTES,
-				  SMB2_OP_HARDLINK, NULL, NULL);
+				  SMB2_OP_HARDLINK, cfile, NULL);
 }
 
 int
@@ -1368,15 +1277,16 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifs_sb_info *cifs_sb, bool set_alloc,
 		   struct dentry *dentry)
 {
-	struct cifs_open_parms oparms;
-	struct cifsFileInfo *cfile;
-	struct kvec in_iov;
+	struct inode *inode = dentry ? d_inode(dentry) : NULL;
 	__le64 eof = cpu_to_le64(size);
+	struct cifs_open_parms oparms;
+	struct cifsFileInfo *cfile;
+	struct kvec in_iov;
 	int rc;
 
 	in_iov.iov_base = &eof;
 	in_iov.iov_len = sizeof(eof);
-	cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
+	cifs_get_writable_path(tcon, full_path, inode, FIND_ANY, &cfile);
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_DATA,
 			     FILE_OPEN, 0, ACL_NO_MODE);
@@ -1386,7 +1296,8 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 			      cfile, NULL, NULL, dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease");
-		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path,
+				       inode, FIND_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb,
 				      full_path, &oparms, &in_iov,
 				      &(int){SMB2_OP_SET_EOF}, 1,
@@ -1416,7 +1327,8 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 	    (buf->LastWriteTime == 0) && (buf->ChangeTime == 0)) {
 		if (buf->Attributes == 0)
 			goto out; /* would be a no op, no sense sending this */
-		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path,
+				       inode, FIND_ANY, &cfile);
 	}
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_ATTRIBUTES,
@@ -1475,7 +1387,7 @@ struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 
 	if (tcon->posix_extensions) {
 		cmds[1] = SMB2_OP_POSIX_QUERY_INFO;
-		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path, NULL, FIND_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
 				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
 		if (!rc) {
@@ -1484,7 +1396,7 @@ struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 		}
 	} else {
 		cmds[1] = SMB2_OP_QUERY_INFO;
-		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path, NULL, FIND_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
 				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
 		if (!rc) {
@@ -1566,8 +1478,8 @@ int smb2_rename_pending_delete(const char *full_path,
 			       struct dentry *dentry,
 			       const unsigned int xid)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(d_inode(dentry)->i_sb);
 	struct cifsInodeInfo *cinode = CIFS_I(d_inode(dentry));
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry);
 	__le16 *utf16_path __free(kfree) = NULL;
 	__u32 co = file_create_options(dentry);
 	int cmds[] = {
@@ -1579,14 +1491,10 @@ int smb2_rename_pending_delete(const char *full_path,
 	char *to_name __free(kfree) = NULL;
 	__u32 attrs = cinode->cifsAttrs;
 	struct cifs_open_parms oparms;
-	static atomic_t sillycounter;
 	struct cifsFileInfo *cfile;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
 	struct kvec iov[2];
-	const char *ppath;
-	void *page;
-	size_t len;
 	int rc;
 
 	tlink = cifs_sb_tlink(cifs_sb);
@@ -1594,25 +1502,14 @@ int smb2_rename_pending_delete(const char *full_path,
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 
-	page = alloc_dentry_path();
-
-	ppath = build_path_from_dentry(dentry->d_parent, page);
-	if (IS_ERR(ppath)) {
-		rc = PTR_ERR(ppath);
+	to_name = cifs_silly_fullpath(dentry);
+	if (IS_ERR(to_name)) {
+		rc = PTR_ERR(to_name);
+		to_name = NULL;
 		goto out;
 	}
 
-	len = strlen(ppath) + strlen("/.__smb1234") + 1;
-	to_name = kmalloc(len, GFP_KERNEL);
-	if (!to_name) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	scnprintf(to_name, len, "%s%c.__smb%04X", ppath, CIFS_DIR_SEP(cifs_sb),
-		  atomic_inc_return(&sillycounter) & 0xffff);
-
-	utf16_path = utf16_smb2_path(cifs_sb, to_name, len);
+	utf16_path = utf16_smb2_path(cifs_sb, to_name, strlen(to_name));
 	if (!utf16_path) {
 		rc = -ENOMEM;
 		goto out;
@@ -1635,12 +1532,14 @@ int smb2_rename_pending_delete(const char *full_path,
 	iov[1].iov_base = utf16_path;
 	iov[1].iov_len = sizeof(*utf16_path) * UniStrlen((wchar_t *)utf16_path);
 
-	cifs_get_writable_path(tcon, full_path, FIND_WITH_DELETE, &cfile);
+	cifs_get_writable_path(tcon, full_path, d_inode(dentry),
+			       FIND_WITH_DELETE, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms, iov,
 			      cmds, num_cmds, cfile, NULL, NULL, dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease\n");
-		cifs_get_writable_path(tcon, full_path, FIND_WITH_DELETE, &cfile);
+		cifs_get_writable_path(tcon, full_path, d_inode(dentry),
+				       FIND_WITH_DELETE, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms, iov,
 				      cmds, num_cmds, cfile, NULL, NULL, NULL);
 	}
@@ -1653,6 +1552,5 @@ int smb2_rename_pending_delete(const char *full_path,
 	}
 out:
 	cifs_put_tlink(tlink);
-	free_dentry_path(page);
 	return rc;
 }
-- 
2.53.0

