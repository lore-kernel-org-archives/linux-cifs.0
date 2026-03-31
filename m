Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320C740DFB9;
	Tue, 31 Mar 2026 01:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774919329; cv=none; b=cN+rd645OYJpHr2DAZYZ2hP1X1/px0TlzTMHRJNktL2pxAV+Aru1tJg9amFcH0WZ+9mg8y6bkbeTEQMbEVQJLiohfNdCDuZD1hQAqa7YFvm4jTLl7DFFqCYbnq7W8tQQ21drNHTxz8ZIVGpDjM3hlFsZAMUdQfDNz73BGTcQoow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774919329; c=relaxed/simple;
	bh=1+rliyUDsoLF2Y7E6JRPapneCTxo+HzPePpwuqmD/CE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KYMmgQocJEBHRtw3vCKgCbxKfvjfIWH19r5Wp3mqPJ0rVQAZocw2jb+2mG2iLsbvaie3zw8RdEycrd1hTlRd+ktNztBisd4irxpoeoSQbdvQ5PvkpRzGW5GeGgJ5YRakdXFDJjsctbrdcJO6dz1txYJLq0DWAtXI1MRYpeLaz48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=lE/G1Asl; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="lE/G1Asl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=6t0am4ulTFKjcvXWFOBnNOkHwLBIpUEmxwdYhRPBL9w=; b=lE/G1Aslvc8VwrJc8DcoyFijNx
	+zOR/EMNWgzJWw/GA1c5y9my8umhzKuROA7EF2R3KLTNPqVekA3YxIrjbZcydIS/Vf3eKGWx6KkXg
	yuM7xC+sii7gh2IJKOwJLRv/kSUhqdvTfpzBgprI7kMrM9l/baCMiKFo8pLFjmFzaPFH/8QeAbi8A
	lF68YnpmTldB1+xxp6sEe6RH+Bi5H3ijRT0xO5L3nNwgobwNRWh/P0eN2hcGSlyJo7/sVEecyeX/B
	rgjYbo2X4n5OUMZY2P0BTFcOywAj7tNTtoVlRJhY4BbkN1b5oX3v8SNl2/usl0cYLJUC3hO4f5/vM
	qbQEYnFA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w7Nau-00000001vQ1-3RZS;
	Mon, 30 Mar 2026 22:08:36 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: add support for O_TMPFILE
Date: Mon, 30 Mar 2026 22:08:36 -0300
Message-ID: <20260331010836.1397616-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
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
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cached_dir.c |   3 +
 fs/smb/client/cifsfs.c     |   4 +
 fs/smb/client/cifsfs.h     |  19 ++
 fs/smb/client/cifsglob.h   |  23 ++-
 fs/smb/client/cifsproto.h  |   3 +-
 fs/smb/client/cifssmb.c    |   3 +
 fs/smb/client/dir.c        | 279 +++++++++++++++++++++----
 fs/smb/client/file.c       |  29 ++-
 fs/smb/client/inode.c      |   3 +-
 fs/smb/client/link.c       |  18 +-
 fs/smb/client/smb2inode.c  | 404 ++++++++++++++-----------------------
 11 files changed, 480 insertions(+), 308 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 04bb95091f49..fee16d50e996 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -477,6 +477,9 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cached_fid *cfid = NULL;
 	int rc;
 
+	if (!name)
+		return;
+
 	rc = open_cached_dir(xid, tcon, name, cifs_sb, true, &cfid);
 	if (rc) {
 		cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
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
index e320d39b01f5..d82ab7ce1064 100644
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
 
+char *cifs_silly_filename(struct dentry *dentry);
+char *cifs_tmpfile_name(struct dentry *dentry);
+
+#define CIFS_TMPFILE_PREFIX		"%c.smb%04X__"
+#define CIFS_TMPFILE_PREFIX_LEN	sizeof(".smb1234__")
+
+#define CIFS_SILLY_FILENAME_SUFFIX	"silly"
+#define CIFS_SILLY_FILENAME_SIZE \
+	(CIFS_TMPFILE_PREFIX_LEN + sizeof(CIFS_SILLY_FILENAME_SUFFIX))
+
+#define CIFS_TMP_FILENAME_SUFFIX	"tmp"
+#define CIFS_TMP_FILENAME_SIZE \
+	(CIFS_TMPFILE_PREFIX_LEN + sizeof(CIFS_TMP_FILENAME_SUFFIX))
+
 #ifdef CONFIG_CIFS_NFSD_EXPORT
 extern const struct export_operations cifs_export_ops;
 #endif /* CONFIG_CIFS_NFSD_EXPORT */
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 709e96e07791..2a6af454095c 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1534,9 +1534,16 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 #define CIFS_CACHE_RW_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG)
 #define CIFS_CACHE_RHW_FLG	(CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FLG)
 
-/*
- * One of these for each file inode
- */
+enum cifs_inode_flags {
+	CIFS_INODE_PENDING_OPLOCK_BREAK = 0,	/* oplock break in progress */
+	CIFS_INODE_PENDING_WRITERS,		/* Writes in progress */
+	CIFS_INODE_FLAG_UNUSED,			/* Unused flag */
+	CIFS_INO_DELETE_PENDING,		/* delete pending on server */
+	CIFS_INO_INVALID_MAPPING,		/* pagecache is invalid */
+	CIFS_INO_LOCK,				/* lock bit for synchronization */
+	CIFS_INO_CLOSE_ON_LOCK,			/* Not to defer the close when lock is set */
+	CIFS_INO_TMPFILE,			/* for O_TMPFILE inodes */
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
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 3990a9012264..0bffb6b9dce8 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2715,6 +2715,9 @@ CIFSUnixCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
 
 	cifs_dbg(FYI, "In Create Hard link Unix style\n");
 createHardLinkRetry:
+	if (!fromName)
+		return -EBADF;
+
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
 	if (rc < 0)
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 6d2378eeb7f6..c107c25d0709 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -175,17 +175,17 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
 
 /* Inode operations in similar order to how they appear in Linux file fs.h */
 
-static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
-			  struct tcon_link *tlink, unsigned int oflags, umode_t mode, __u32 *oplock,
-			  struct cifs_fid *fid, struct cifs_open_info_data *buf)
+static int __cifs_do_create(struct file *file, struct inode *inode,
+			    struct dentry *direntry, const char *full_path,
+			    unsigned int xid, struct tcon_link *tlink,
+			    unsigned int oflags, umode_t mode, __u32 *oplock,
+			    struct cifs_fid *fid, struct cifs_open_info_data *buf)
 {
 	int rc = -ENOENT;
 	int create_options = CREATE_NOT_DIR;
 	int desired_access;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
 	struct cifs_tcon *tcon = tlink_tcon(tlink);
-	const char *full_path;
-	void *page = alloc_dentry_path();
 	struct inode *newinode = NULL;
 	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	int disposition;
@@ -199,11 +199,6 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	if (tcon->ses->server->oplocks)
 		*oplock = REQ_OPLOCK;
 
-	full_path = build_path_from_dentry(direntry, page);
-	if (IS_ERR(full_path)) {
-		rc = PTR_ERR(full_path);
-		goto out;
-	}
 
 	/* If we're caching, we need to be able to fill in around partial writes. */
 	if (cifs_fscache_enabled(inode) && (oflags & O_ACCMODE) == O_WRONLY)
@@ -225,8 +220,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 			if (S_ISDIR(newinode->i_mode)) {
 				CIFSSMBClose(xid, tcon, fid->netfid);
 				iput(newinode);
-				rc = -EISDIR;
-				goto out;
+				return -EISDIR;
 			}
 
 			if (!S_ISREG(newinode->i_mode)) {
@@ -269,7 +263,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 			break;
 
 		default:
-			goto out;
+			return rc;
 		}
 		/*
 		 * fallthrough to retry, using older open call, this is case
@@ -287,26 +281,30 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
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
@@ -358,7 +356,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 			rdwr_for_fscache = 2;
 			goto retry_open;
 		}
-		goto out;
+		return rc;
 	}
 	if (rdwr_for_fscache == 2)
 		cifs_invalidate_cache(inode, FSCACHE_INVAL_DIO_WRITE);
@@ -436,17 +434,19 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
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
+	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	if (oflags & O_TMPFILE) {
+		set_nlink(newinode, 1);
+		d_tmpfile(file, newinode);
+	} else {
+		d_add(direntry, newinode);
+	}
 	return rc;
 
 out_err:
@@ -454,7 +454,49 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 		server->ops->close(xid, tcon, fid);
 	if (newinode)
 		iput(newinode);
-	goto out;
+	return rc;
+}
+
+static int create_tmpfile(struct inode *inode, struct file *file,
+			  unsigned int xid, struct tcon_link *tlink,
+			  umode_t mode, __u32 *oplock, struct cifs_fid *fid)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	char *path __free(kfree) = NULL;
+	int rc;
+
+	path = cifs_tmpfile_name(dentry);
+	if (IS_ERR(path)) {
+		rc =  PTR_ERR(path);
+		path = NULL;
+		return rc;
+	}
+
+	return __cifs_do_create(file, inode, dentry, path, xid, tlink,
+				file->f_flags, mode, oplock, fid, NULL);
+}
+
+static int create_file(struct inode *inode, struct dentry *direntry,
+		       unsigned int xid, struct tcon_link *tlink,
+		       unsigned int oflags, umode_t mode,
+		       __u32 *oplock, struct cifs_fid *fid,
+		       struct cifs_open_info_data *buf)
+{
+	void *page = alloc_dentry_path();
+	const char *path;
+	int rc;
+
+	path = build_path_from_dentry(direntry, page);
+	if (IS_ERR(path)) {
+		rc =  PTR_ERR(path);
+		goto out_free_path;
+	}
+
+	rc = __cifs_do_create(NULL, inode, direntry, path, xid,
+			      tlink, oflags, mode, oplock, fid, buf);
+out_free_path:
+	free_dentry_path(page);
+	return rc;
 }
 
 int
@@ -523,8 +565,8 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 
 	cifs_add_pending_open(&fid, tlink, &open);
 
-	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid, &buf);
+	rc = create_file(inode, direntry, xid, tlink,
+			 oflags, mode, &oplock, &fid, &buf);
 	if (rc) {
 		cifs_del_pending_open(&open);
 		goto out;
@@ -608,7 +650,8 @@ int cifs_create(struct mnt_idmap *idmap, struct inode *inode,
 	if (server->ops->new_lease_key)
 		server->ops->new_lease_key(&fid);
 
-	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode, &oplock, &fid, &buf);
+	rc = create_file(inode, direntry, xid, tlink,
+			 oflags, mode, &oplock, &fid, &buf);
 	if (!rc && server->ops->close)
 		server->ops->close(xid, tcon, &fid);
 
@@ -959,6 +1002,168 @@ static int cifs_ci_compare(const struct dentry *dentry,
 	return 0;
 }
 
+static int set_hidden_attr(const unsigned int xid,
+			   struct TCP_Server_Info *server,
+			   struct file *file)
+{
+	struct cifsInodeInfo *cinode = CIFS_I(file_inode(file));
+	FILE_BASIC_INFO fi = {
+		.Attributes = cpu_to_le32(cinode->cifsAttrs |
+					  ATTR_HIDDEN),
+	};
+
+	return server->ops->set_file_info(file_inode(file), NULL, &fi, xid);
+}
+
+int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+		 struct file *file, umode_t mode)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dir);
+	struct TCP_Server_Info *server;
+	struct cifs_pending_open open;
+	struct cifsFileInfo *cfile;
+	struct cifs_fid fid = {};
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	unsigned int sbflags;
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
+	rc = create_tmpfile(dir, file, xid, tlink, mode, &oplock, &fid);
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
+		goto err_close;
+
+	fscache_use_cookie(cifs_inode_cookie(file_inode(file)),
+			   file->f_mode & FMODE_WRITE);
+out:
+	cifs_put_tlink(tlink);
+	free_xid(xid);
+	return rc;
+err_open:
+	cifs_del_pending_open(&open);
+err_close:
+	if (server->ops->close)
+		server->ops->close(xid, tcon, &fid);
+	goto out;
+}
+
+static char *tmp_fullpath(struct dentry *dentry,
+			  const unsigned char *name, size_t namesize)
+{
+	char *page = alloc_dentry_path();
+	const char *path;
+	char *npath;
+	size_t len;
+
+	path = build_path_from_dentry(dentry->d_parent, page);
+	if (IS_ERR(path)) {
+		npath = ERR_CAST(path);
+		goto out;
+	}
+
+	len = strlen(path) + namesize;
+	npath = kmalloc(len, GFP_KERNEL);
+	if (npath)
+		scnprintf(npath, len, "%s%s", path, name);
+	else
+		npath = ERR_PTR(-ENOMEM);
+out:
+	free_dentry_path(page);
+	return npath;
+}
+
+char *cifs_silly_filename(struct dentry *dentry)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry);
+	unsigned char name[CIFS_SILLY_FILENAME_SIZE];
+	size_t namesize = sizeof(name);
+	struct dentry *sdentry = NULL;
+
+	do {
+		dput(sdentry);
+		scnprintf(name, namesize,
+			  CIFS_TMPFILE_PREFIX "%s",
+			  CIFS_DIR_SEP(cifs_sb),
+			  atomic_inc_return(&cifs_sillycounter) & 0xffff,
+			  CIFS_SILLY_FILENAME_SUFFIX);
+		sdentry = lookup_noperm(&QSTR(name + 1), dentry->d_parent);
+		if (IS_ERR(sdentry))
+			return ERR_PTR(-EBUSY);
+	} while (!d_is_negative(sdentry));
+	dput(sdentry);
+	return tmp_fullpath(dentry, name, namesize);
+}
+
+char *cifs_tmpfile_name(struct dentry *dentry)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry);
+	unsigned char name[CIFS_TMP_FILENAME_SIZE];
+	size_t namesize = sizeof(name);
+	struct dentry *sdentry = NULL;
+
+	do {
+		dput(sdentry);
+		scnprintf(name, namesize,
+			  CIFS_TMPFILE_PREFIX "%s",
+			  CIFS_DIR_SEP(cifs_sb),
+			  atomic_inc_return(&cifs_tmpcounter) & 0xffff,
+			  CIFS_TMP_FILENAME_SUFFIX);
+		sdentry = lookup_noperm_unlocked(&QSTR(name + 1),
+						 dentry->d_parent);
+		if (IS_ERR(sdentry))
+			return ERR_PTR(-EBUSY);
+	} while (!d_is_negative(sdentry));
+	dput(sdentry);
+	return tmp_fullpath(dentry, name, namesize);
+}
+
 const struct dentry_operations cifs_ci_dentry_ops = {
 	.d_revalidate = cifs_d_revalidate,
 	.d_hash = cifs_ci_hash,
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index a69e05f86d7e..0d1fda84a89e 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -696,6 +696,7 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	cfile->f_flags = file->f_flags;
 	cfile->invalidHandle = false;
 	cfile->deferred_close_scheduled = false;
+	cfile->status_file_deleted = file->f_flags & O_TMPFILE;
 	cfile->tlink = cifs_get_tlink(tlink);
 	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
 	INIT_WORK(&cfile->put, cifsFileInfo_put_work);
@@ -715,6 +716,8 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 
 	cifs_down_write(&cinode->lock_sem);
 	list_add(&fdlocks->llist, &cinode->llist);
+	if (file->f_flags & O_TMPFILE)
+		set_bit(CIFS_INO_TMPFILE, &cinode->flags);
 	up_write(&cinode->lock_sem);
 
 	spin_lock(&tcon->open_file_lock);
@@ -2605,6 +2608,15 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 		fsuid_only = false;
 
 	spin_lock(&cifs_inode->open_file_lock);
+	if (test_bit(CIFS_INO_TMPFILE, &cifs_inode->flags)) {
+		*ret_file = list_first_entry_or_null(&cifs_inode->openFileList,
+						     struct cifsFileInfo,
+						     flist);
+		if (*ret_file)
+			cifsFileInfo_get(*ret_file);
+		spin_unlock(&cifs_inode->open_file_lock);
+		return *ret_file ? 0 : -EBADF;
+	}
 refind_writable:
 	if (refind > MAX_REOPEN_ATT) {
 		spin_unlock(&cifs_inode->open_file_lock);
@@ -2683,16 +2695,23 @@ find_writable_file(struct cifsInodeInfo *cifs_inode, int flags)
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
+
 	struct cifsFileInfo *cfile;
-	void *page = alloc_dentry_path();
+	void *page;
 
 	*ret_file = NULL;
 
+	if (!name) {
+		if (WARN_ON_ONCE(!inode))
+			return -EBADF;
+		return cifs_get_writable_file(CIFS_I(inode), flags, ret_file);
+	}
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
index 434e8fe74080..50daf6bb0551 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -444,7 +444,7 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 	int rc = -EACCES;
 	unsigned int xid;
 	const char *from_name, *to_name;
-	void *page1, *page2;
+	void *page1 = NULL, *page2 = NULL;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
@@ -460,14 +460,25 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 	tcon = tlink_tcon(tlink);
 
 	xid = get_xid();
+
+	if (d_really_is_positive(old_file)) {
+		cifsInode = CIFS_I(d_inode(old_file));
+		guard(spinlock)(&cifsInode->open_file_lock);
+		if (test_bit(CIFS_INO_TMPFILE, &cifsInode->flags)) {
+			from_name = NULL;
+			goto tmpfile;
+		}
+	}
+
 	page1 = alloc_dentry_path();
-	page2 = alloc_dentry_path();
-
 	from_name = build_path_from_dentry(old_file, page1);
 	if (IS_ERR(from_name)) {
 		rc = PTR_ERR(from_name);
 		goto cifs_hl_exit;
 	}
+
+tmpfile:
+	page2 = alloc_dentry_path();
 	to_name = build_path_from_dentry(direntry, page2);
 	if (IS_ERR(to_name)) {
 		rc = PTR_ERR(to_name);
@@ -503,6 +514,7 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 	if (d_really_is_positive(old_file)) {
 		cifsInode = CIFS_I(d_inode(old_file));
 		if (rc == 0) {
+			clear_bit(CIFS_INO_TMPFILE, &cifsInode->flags);
 			spin_lock(&d_inode(old_file)->i_lock);
 			inc_nlink(d_inode(old_file));
 			spin_unlock(&d_inode(old_file)->i_lock);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 364bdcff9c9d..44d660a9c67e 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -164,6 +164,27 @@ static int check_wsl_eas(struct kvec *rsp_iov)
 	return 0;
 }
 
+/*
+ * If @cfile is NULL, then need to account for extra open and close requests in
+ * the compound chain.
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
@@ -226,6 +247,10 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	/* We already have a handle so we can skip the open */
 	if (cfile)
 		goto after_open;
+	if (WARN_ON_ONCE(!full_path)) {
+		rc = -EINVAL;
+		goto finished;
+	}
 
 	/* Open */
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
@@ -284,32 +309,16 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -317,35 +326,18 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -363,32 +355,15 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -398,32 +373,15 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -433,28 +391,14 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -474,31 +418,19 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -514,41 +446,27 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -556,25 +474,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -582,34 +488,17 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -1156,7 +1045,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 	cifs_i = CIFS_I(inode);
 	dosattrs = cifs_i->cifsAttrs | ATTR_READONLY;
 	data.Attributes = cpu_to_le32(dosattrs);
-	cifs_get_writable_path(tcon, name, FIND_ANY, &cfile);
+	cifs_get_writable_path(tcon, name, inode, FIND_ANY, &cfile);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name, FILE_WRITE_ATTRIBUTES,
 			     FILE_CREATE, CREATE_NOT_FILE, ACL_NO_MODE);
 	tmprc = smb2_compound_op(xid, tcon, cifs_sb, name,
@@ -1332,17 +1221,20 @@ int smb2_rename_path(const unsigned int xid,
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
@@ -1355,11 +1247,32 @@ int smb2_create_hardlink(const unsigned int xid,
 			 const char *from_name, const char *to_name,
 			 struct cifs_sb_info *cifs_sb)
 {
+	struct inode *inode = source_dentry ? d_inode(source_dentry) : NULL;
 	__u32 co = file_create_options(source_dentry);
+	struct cifsFileInfo *cfile;
 
+	if (inode && !from_name) {
+		struct cifsInodeInfo *cinode = CIFS_I(inode);
+		FILE_BASIC_INFO fi;
+		__u32 attrs;
+
+		scoped_guard(spinlock, &cinode->open_file_lock) {
+			if (!test_bit(CIFS_INO_TMPFILE, &CIFS_I(inode)->flags))
+				goto no_tmpfile;
+			attrs = cinode->cifsAttrs;
+		}
+		fi = (FILE_BASIC_INFO) {
+			.Attributes = cpu_to_le32(attrs & ~ATTR_HIDDEN),
+		};
+		smb2_set_file_info(inode, NULL, &fi, xid);
+	}
+
+no_tmpfile:
+	cifs_get_writable_path(tcon, from_name, inode,
+			       FIND_WITH_DELETE, &cfile);
 	return smb2_set_path_attr(xid, tcon, from_name, to_name,
 				  cifs_sb, co, FILE_READ_ATTRIBUTES,
-				  SMB2_OP_HARDLINK, NULL, NULL);
+				  SMB2_OP_HARDLINK, cfile, NULL);
 }
 
 int
@@ -1368,15 +1281,16 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -1386,7 +1300,8 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 			      cfile, NULL, NULL, dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease");
-		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path,
+				       inode, FIND_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb,
 				      full_path, &oparms, &in_iov,
 				      &(int){SMB2_OP_SET_EOF}, 1,
@@ -1416,7 +1331,8 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 	    (buf->LastWriteTime == 0) && (buf->ChangeTime == 0)) {
 		if (buf->Attributes == 0)
 			goto out; /* would be a no op, no sense sending this */
-		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path,
+				       inode, FIND_ANY, &cfile);
 	}
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_ATTRIBUTES,
@@ -1475,7 +1391,7 @@ struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 
 	if (tcon->posix_extensions) {
 		cmds[1] = SMB2_OP_POSIX_QUERY_INFO;
-		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path, NULL, FIND_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
 				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
 		if (!rc) {
@@ -1484,7 +1400,7 @@ struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 		}
 	} else {
 		cmds[1] = SMB2_OP_QUERY_INFO;
-		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path, NULL, FIND_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
 				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
 		if (!rc) {
@@ -1566,8 +1482,8 @@ int smb2_rename_pending_delete(const char *full_path,
 			       struct dentry *dentry,
 			       const unsigned int xid)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(d_inode(dentry)->i_sb);
 	struct cifsInodeInfo *cinode = CIFS_I(d_inode(dentry));
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry);
 	__le16 *utf16_path __free(kfree) = NULL;
 	__u32 co = file_create_options(dentry);
 	int cmds[] = {
@@ -1579,14 +1495,10 @@ int smb2_rename_pending_delete(const char *full_path,
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
@@ -1594,25 +1506,14 @@ int smb2_rename_pending_delete(const char *full_path,
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 
-	page = alloc_dentry_path();
-
-	ppath = build_path_from_dentry(dentry->d_parent, page);
-	if (IS_ERR(ppath)) {
-		rc = PTR_ERR(ppath);
+	to_name = cifs_silly_filename(dentry);
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
@@ -1635,12 +1536,14 @@ int smb2_rename_pending_delete(const char *full_path,
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
@@ -1653,6 +1556,5 @@ int smb2_rename_pending_delete(const char *full_path,
 	}
 out:
 	cifs_put_tlink(tlink);
-	free_dentry_path(page);
 	return rc;
 }
-- 
2.53.0

