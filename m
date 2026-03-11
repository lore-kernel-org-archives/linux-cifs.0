Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B943E6DC6
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 18:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773252059; cv=none; b=GkzjDb/k0SnXOFqHjJYtO+1/mWg44EARtY5k+nT3Q99aF2vxSyFdsSlT45DZycZslvyptb27RDSXmjTlyrR8iY+UFvmMj2j2yhUi9d95wD0Fv8NQhNFkOOlDys9I6Xa19IZgGzZnYnrrWcdnNvMipKydsQbJpIuJgvHcPtt3Euw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773252059; c=relaxed/simple;
	bh=/1Cri2S9QTpV5oy+D9UgyC3FZrDJYHNlgowVcQw4Rqo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kkiQOSMYolo3MhiqV7P43Nsg7BM1X1Rben7+KhgSRe6FVgFVBWX8/i2ySR74UFKlQqz2caeLC0Tc2eZ2myw8rcgZAsXXc8M/lh5MF6mJn5y5zEvXmTwZqyIK3YVxtnqMKI3mqHCliNg2pPlJah2fbRz0awBspNQTfLclHWaZSOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=LPfD2cLw; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="LPfD2cLw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9b2l4Y+MOPrRg0W28rIWJ7YLXdY5Wfjpb8bEI8m8wm0=; b=LPfD2cLwfEW7XOJp5JesxWSpfN
	RAYdjbGblb0MI0SqpJ+yjkluzBjK5w6z7VZsZM9DIXIdri4tW2tN8MgETiDiC8GWwRQ1oMxR3wuwT
	hEJcITI//tyKWYsBPOnK6Q2DPitxUAdI8uv3jvIeD2AKKx2g72G3e9woaJMJATUsveUAqMzHb54ZJ
	p24ONtJCM0L8LXgOLLBqw0D7r3GdBuhZwpo3DwDkSuaHbKZvINHWiwV8WglRC62MJygyT16r5BqgR
	aKCEHDil/lAbGfA54fU1uwVn7Zbx3RdZO7xb4YPV/TDq8Lkmi34NzkNDJHCmnkELK2K/Lk8AvAK99
	M6uzv8vA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w0NrZ-00000000ijP-04At;
	Wed, 11 Mar 2026 15:00:53 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2] smb: client: fix open handle lookup in cifs_open()
Date: Wed, 11 Mar 2026 15:00:52 -0300
Message-ID: <20260311180052.643713-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When looking up open handles to be re-used in cifs_open(), calling
cifs_get_{writable,readable}_path() is wrong as it will look up for
the first matching open handle, and if @file->f_flags doesn't match,
it will ignore the remaining open handles in
cifsInodeInfo::openFileList that might potentially match
@file->f_flags.

For writable and readable handles, fix this by calling
__cifs_get_writable_file() and __find_readable_file(), respectively,
with FIND_OPEN_FLAGS set.

With the patch, the following program ends up with two opens instead
of three sent over the wire.

```
  #define _GNU_SOURCE
  #include <unistd.h>
  #include <string.h>
  #include <fcntl.h>

  int main(int argc, char *argv[])
  {
          int fd;

          fd = open("/mnt/1/foo", O_CREAT | O_WRONLY | O_TRUNC, 0664);
          close(fd);
          fd = open("/mnt/1/foo", O_DIRECT | O_WRONLY);
          close(fd);
          fd = open("/mnt/1/foo", O_WRONLY);
          close(fd);
          fd = open("/mnt/1/foo", O_DIRECT | O_WRONLY);
          close(fd);
          return 0;
  }
```

```
$ mount.cifs //srv/share /mnt/1 -o ...
$ gcc test.c && ./a.out
```

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
v1 -> v2:
 - fix typo: defeered -> deferred
 - fix missing pending delete checks for readable handles

 fs/smb/client/cifsacl.c   |   2 +-
 fs/smb/client/cifsfs.c    |   2 +-
 fs/smb/client/cifsglob.h  |  12 ++---
 fs/smb/client/cifsproto.h |  26 +++++++--
 fs/smb/client/file.c      | 111 ++++++++++++++++++++++----------------
 fs/smb/client/inode.c     |   6 +--
 fs/smb/client/smb1ops.c   |   2 +-
 fs/smb/client/smb2inode.c |  22 ++++----
 fs/smb/client/smb2ops.c   |   4 +-
 9 files changed, 112 insertions(+), 75 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index f4cb3018a358..c920039d733c 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1489,7 +1489,7 @@ struct smb_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
 	struct cifsFileInfo *open_file = NULL;
 
 	if (inode)
-		open_file = find_readable_file(CIFS_I(inode), true);
+		open_file = find_readable_file(CIFS_I(inode), FIND_FSUID_ONLY);
 	if (!open_file)
 		return get_cifs_acl_by_path(cifs_sb, path, pacllen, info);
 
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index b6e3db993cc6..32d0305a1239 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1269,7 +1269,7 @@ static int cifs_precopy_set_eof(struct inode *src_inode, struct cifsInodeInfo *s
 	struct cifsFileInfo *writeable_srcfile;
 	int rc = -EINVAL;
 
-	writeable_srcfile = find_writable_file(src_cifsi, FIND_WR_FSUID_ONLY);
+	writeable_srcfile = find_writable_file(src_cifsi, FIND_FSUID_ONLY);
 	if (writeable_srcfile) {
 		if (src_tcon->ses->server->ops->set_file_size)
 			rc = src_tcon->ses->server->ops->set_file_size(
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index bb0fe4b60240..7877d327dbb0 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1885,12 +1885,12 @@ static inline bool is_replayable_error(int error)
 }
 
 
-/* cifs_get_writable_file() flags */
-enum cifs_writable_file_flags {
-	FIND_WR_ANY			= 0U,
-	FIND_WR_FSUID_ONLY		= (1U << 0),
-	FIND_WR_WITH_DELETE		= (1U << 1),
-	FIND_WR_NO_PENDING_DELETE	= (1U << 2),
+enum cifs_find_flags {
+	FIND_ANY		= 0U,
+	FIND_FSUID_ONLY		= (1U << 0),
+	FIND_WITH_DELETE	= (1U << 1),
+	FIND_NO_PENDING_DELETE	= (1U << 2),
+	FIND_OPEN_FLAGS		= (1U << 3),
 };
 
 #define   MID_FREE 0
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 800a7e418c32..884bfa1cf0b4 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -138,12 +138,14 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata,
 				      ssize_t result);
 struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 					int flags);
-int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
-			   struct cifsFileInfo **ret_file);
+int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
+			     unsigned int find_flags, unsigned int open_flags,
+			     struct cifsFileInfo **ret_file);
 int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name, int flags,
 			   struct cifsFileInfo **ret_file);
-struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
-					bool fsuid_only);
+struct cifsFileInfo *__find_readable_file(struct cifsInodeInfo *cifs_inode,
+					  unsigned int find_flags,
+					  unsigned int open_flags);
 int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 			   struct cifsFileInfo **ret_file);
 int cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *inode,
@@ -596,4 +598,20 @@ static inline void cifs_sg_set_buf(struct sg_table *sgtable,
 	}
 }
 
+static inline int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
+					 unsigned int find_flags,
+					 struct cifsFileInfo **ret_file)
+{
+	find_flags &= ~FIND_OPEN_FLAGS;
+	return __cifs_get_writable_file(cifs_inode, find_flags, 0, ret_file);
+}
+
+static inline struct cifsFileInfo *
+find_readable_file(struct cifsInodeInfo *cinode, unsigned int find_flags)
+{
+	find_flags &= ~FIND_OPEN_FLAGS;
+	find_flags |= FIND_NO_PENDING_DELETE;
+	return __find_readable_file(cinode, find_flags, 0);
+}
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 13dda87f7711..27f61fe7e4e2 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -255,7 +255,7 @@ static void cifs_begin_writeback(struct netfs_io_request *wreq)
 	struct cifs_io_request *req = container_of(wreq, struct cifs_io_request, rreq);
 	int ret;
 
-	ret = cifs_get_writable_file(CIFS_I(wreq->inode), FIND_WR_ANY, &req->cfile);
+	ret = cifs_get_writable_file(CIFS_I(wreq->inode), FIND_ANY, &req->cfile);
 	if (ret) {
 		cifs_dbg(VFS, "No writable handle in writepages ret=%d\n", ret);
 		return;
@@ -956,7 +956,7 @@ int cifs_file_flush(const unsigned int xid, struct inode *inode,
 		return tcon->ses->server->ops->flush(xid, tcon,
 						     &cfile->fid);
 	}
-	rc = cifs_get_writable_file(CIFS_I(inode), FIND_WR_ANY, &cfile);
+	rc = cifs_get_writable_file(CIFS_I(inode), FIND_ANY, &cfile);
 	if (!rc) {
 		tcon = tlink_tcon(cfile->tlink);
 		rc = tcon->ses->server->ops->flush(xid, tcon, &cfile->fid);
@@ -981,7 +981,7 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 		return -ERESTARTSYS;
 	mapping_set_error(inode->i_mapping, rc);
 
-	cfile = find_writable_file(cinode, FIND_WR_FSUID_ONLY);
+	cfile = find_writable_file(cinode, FIND_FSUID_ONLY);
 	rc = cifs_file_flush(xid, inode, cfile);
 	if (!rc) {
 		if (cfile) {
@@ -1061,32 +1061,29 @@ int cifs_open(struct inode *inode, struct file *file)
 
 	/* Get the cached handle as SMB2 close is deferred */
 	if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
-		rc = cifs_get_writable_path(tcon, full_path,
-					    FIND_WR_FSUID_ONLY |
-					    FIND_WR_NO_PENDING_DELETE,
-					    &cfile);
+		rc = __cifs_get_writable_file(CIFS_I(inode),
+					      FIND_FSUID_ONLY |
+					      FIND_NO_PENDING_DELETE |
+					      FIND_OPEN_FLAGS,
+					      file->f_flags, &cfile);
 	} else {
-		rc = cifs_get_readable_path(tcon, full_path, &cfile);
+		cfile = __find_readable_file(CIFS_I(inode),
+					     FIND_NO_PENDING_DELETE |
+					     FIND_OPEN_FLAGS,
+					     file->f_flags);
+		rc = cfile ? 0 : -ENOENT;
 	}
 	if (rc == 0) {
-		unsigned int oflags = file->f_flags & ~(O_CREAT|O_EXCL|O_TRUNC);
-		unsigned int cflags = cfile->f_flags & ~(O_CREAT|O_EXCL|O_TRUNC);
-
-		if (cifs_convert_flags(oflags, 0) == cifs_convert_flags(cflags, 0) &&
-		    (oflags & (O_SYNC|O_DIRECT)) == (cflags & (O_SYNC|O_DIRECT))) {
-			file->private_data = cfile;
-			spin_lock(&CIFS_I(inode)->deferred_lock);
-			cifs_del_deferred_close(cfile);
-			spin_unlock(&CIFS_I(inode)->deferred_lock);
-			goto use_cache;
-		}
-		_cifsFileInfo_put(cfile, true, false);
-	} else {
-		/* hard link on the defeered close file */
-		rc = cifs_get_hardlink_path(tcon, inode, file);
-		if (rc)
-			cifs_close_deferred_file(CIFS_I(inode));
+		file->private_data = cfile;
+		spin_lock(&CIFS_I(inode)->deferred_lock);
+		cifs_del_deferred_close(cfile);
+		spin_unlock(&CIFS_I(inode)->deferred_lock);
+		goto use_cache;
 	}
+	/* hard link on the deferred close file */
+	rc = cifs_get_hardlink_path(tcon, inode, file);
+	if (rc)
+		cifs_close_deferred_file(CIFS_I(inode));
 
 	if (server->oplocks)
 		oplock = REQ_OPLOCK;
@@ -2512,10 +2509,33 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t
 	netfs_write_subrequest_terminated(&wdata->subreq, result);
 }
 
-struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
-					bool fsuid_only)
+static bool open_flags_match(struct cifsInodeInfo *cinode,
+			     unsigned int oflags, unsigned int cflags)
+{
+	struct inode *inode = &cinode->netfs.inode;
+	int crw = 0, orw = 0;
+
+	oflags &= ~(O_CREAT | O_EXCL | O_TRUNC);
+	cflags &= ~(O_CREAT | O_EXCL | O_TRUNC);
+
+	if (cifs_fscache_enabled(inode)) {
+		if (OPEN_FMODE(cflags) & FMODE_WRITE)
+			crw = 1;
+		if (OPEN_FMODE(oflags) & FMODE_WRITE)
+			orw = 1;
+	}
+	if (cifs_convert_flags(oflags, orw) != cifs_convert_flags(cflags, crw))
+		return false;
+
+	return (oflags & (O_SYNC | O_DIRECT)) == (cflags & (O_SYNC | O_DIRECT));
+}
+
+struct cifsFileInfo *__find_readable_file(struct cifsInodeInfo *cifs_inode,
+					  unsigned int find_flags,
+					  unsigned int open_flags)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode);
+	bool fsuid_only = find_flags & FIND_FSUID_ONLY;
 	struct cifsFileInfo *open_file = NULL;
 
 	/* only filter by fsuid on multiuser mounts */
@@ -2529,6 +2549,13 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
 		if (fsuid_only && !uid_eq(open_file->uid, current_fsuid()))
 			continue;
+		if ((find_flags & FIND_NO_PENDING_DELETE) &&
+		    open_file->status_file_deleted)
+			continue;
+		if ((find_flags & FIND_OPEN_FLAGS) &&
+		    !open_flags_match(cifs_inode, open_flags,
+				      open_file->f_flags))
+			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_READ) {
 			if ((!open_file->invalidHandle)) {
 				/* found a good file */
@@ -2547,17 +2574,17 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 }
 
 /* Return -EBADF if no handle is found and general rc otherwise */
-int
-cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
-		       struct cifsFileInfo **ret_file)
+int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
+			     unsigned int find_flags, unsigned int open_flags,
+			     struct cifsFileInfo **ret_file)
 {
 	struct cifsFileInfo *open_file, *inv_file = NULL;
 	struct cifs_sb_info *cifs_sb;
 	bool any_available = false;
 	int rc = -EBADF;
 	unsigned int refind = 0;
-	bool fsuid_only = flags & FIND_WR_FSUID_ONLY;
-	bool with_delete = flags & FIND_WR_WITH_DELETE;
+	bool fsuid_only = find_flags & FIND_FSUID_ONLY;
+	bool with_delete = find_flags & FIND_WITH_DELETE;
 	*ret_file = NULL;
 
 	/*
@@ -2591,9 +2618,13 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
 			continue;
 		if (with_delete && !(open_file->fid.access & DELETE))
 			continue;
-		if ((flags & FIND_WR_NO_PENDING_DELETE) &&
+		if ((find_flags & FIND_NO_PENDING_DELETE) &&
 		    open_file->status_file_deleted)
 			continue;
+		if ((find_flags & FIND_OPEN_FLAGS) &&
+		    !open_flags_match(cifs_inode, open_flags,
+				      open_file->f_flags))
+			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
@@ -2710,17 +2741,7 @@ cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 		cinode = CIFS_I(d_inode(cfile->dentry));
 		spin_unlock(&tcon->open_file_lock);
 		free_dentry_path(page);
-		*ret_file = find_readable_file(cinode, 0);
-		if (*ret_file) {
-			spin_lock(&cinode->open_file_lock);
-			if ((*ret_file)->status_file_deleted) {
-				spin_unlock(&cinode->open_file_lock);
-				cifsFileInfo_put(*ret_file);
-				*ret_file = NULL;
-			} else {
-				spin_unlock(&cinode->open_file_lock);
-			}
-		}
+		*ret_file = find_readable_file(cinode, FIND_ANY);
 		return *ret_file ? 0 : -ENOENT;
 	}
 
@@ -2792,7 +2813,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		}
 
 		if ((OPEN_FMODE(smbfile->f_flags) & FMODE_WRITE) == 0) {
-			smbfile = find_writable_file(CIFS_I(inode), FIND_WR_ANY);
+			smbfile = find_writable_file(CIFS_I(inode), FIND_ANY);
 			if (smbfile) {
 				rc = server->ops->flush(xid, tcon, &smbfile->fid);
 				cifsFileInfo_put(smbfile);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 3e844c55ab8a..143fa2e665ed 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2997,7 +2997,7 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 		}
 	}
 
-	cfile = find_readable_file(cifs_i, false);
+	cfile = find_readable_file(cifs_i, FIND_ANY);
 	if (cfile == NULL)
 		return -EINVAL;
 
@@ -3050,7 +3050,7 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 						size, false);
 		cifs_dbg(FYI, "%s: set_file_size: rc = %d\n", __func__, rc);
 	} else {
-		open_file = find_writable_file(cifsInode, FIND_WR_FSUID_ONLY);
+		open_file = find_writable_file(cifsInode, FIND_FSUID_ONLY);
 		if (open_file) {
 			tcon = tlink_tcon(open_file->tlink);
 			server = tcon->ses->server;
@@ -3219,7 +3219,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 					    open_file->fid.netfid,
 					    open_file->pid);
 	} else {
-		open_file = find_writable_file(cifsInode, FIND_WR_FSUID_ONLY);
+		open_file = find_writable_file(cifsInode, FIND_FSUID_ONLY);
 		if (open_file) {
 			pTcon = tlink_tcon(open_file->tlink);
 			rc = CIFSSMBUnixSetFileInfo(xid, pTcon, args,
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 9643eca0cb70..9694117050a6 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -960,7 +960,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	struct cifs_tcon *tcon;
 
 	/* if the file is already open for write, just use that fileid */
-	open_file = find_writable_file(cinode, FIND_WR_FSUID_ONLY);
+	open_file = find_writable_file(cinode, FIND_FSUID_ONLY);
 
 	if (open_file) {
 		fid.netfid = open_file->fid.netfid;
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 5280c5c869ad..364bdcff9c9d 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1156,7 +1156,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 	cifs_i = CIFS_I(inode);
 	dosattrs = cifs_i->cifsAttrs | ATTR_READONLY;
 	data.Attributes = cpu_to_le32(dosattrs);
-	cifs_get_writable_path(tcon, name, FIND_WR_ANY, &cfile);
+	cifs_get_writable_path(tcon, name, FIND_ANY, &cfile);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name, FILE_WRITE_ATTRIBUTES,
 			     FILE_CREATE, CREATE_NOT_FILE, ACL_NO_MODE);
 	tmprc = smb2_compound_op(xid, tcon, cifs_sb, name,
@@ -1336,14 +1336,13 @@ int smb2_rename_path(const unsigned int xid,
 	__u32 co = file_create_options(source_dentry);
 
 	drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
-	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
+	cifs_get_writable_path(tcon, from_name, FIND_WITH_DELETE, &cfile);
 
 	int rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
 				  co, DELETE, SMB2_OP_RENAME, cfile, source_dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease");
-		cifs_get_writable_path(tcon, from_name,
-				       FIND_WR_WITH_DELETE, &cfile);
+		cifs_get_writable_path(tcon, from_name, FIND_WITH_DELETE, &cfile);
 		rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
 				  co, DELETE, SMB2_OP_RENAME, cfile, NULL);
 	}
@@ -1377,7 +1376,7 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 
 	in_iov.iov_base = &eof;
 	in_iov.iov_len = sizeof(eof);
-	cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+	cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_DATA,
 			     FILE_OPEN, 0, ACL_NO_MODE);
@@ -1387,7 +1386,7 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 			      cfile, NULL, NULL, dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease");
-		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb,
 				      full_path, &oparms, &in_iov,
 				      &(int){SMB2_OP_SET_EOF}, 1,
@@ -1417,7 +1416,7 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 	    (buf->LastWriteTime == 0) && (buf->ChangeTime == 0)) {
 		if (buf->Attributes == 0)
 			goto out; /* would be a no op, no sense sending this */
-		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
 	}
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_ATTRIBUTES,
@@ -1476,7 +1475,7 @@ struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 
 	if (tcon->posix_extensions) {
 		cmds[1] = SMB2_OP_POSIX_QUERY_INFO;
-		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
 				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
 		if (!rc) {
@@ -1485,7 +1484,7 @@ struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 		}
 	} else {
 		cmds[1] = SMB2_OP_QUERY_INFO;
-		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+		cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
 				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
 		if (!rc) {
@@ -1636,13 +1635,12 @@ int smb2_rename_pending_delete(const char *full_path,
 	iov[1].iov_base = utf16_path;
 	iov[1].iov_len = sizeof(*utf16_path) * UniStrlen((wchar_t *)utf16_path);
 
-	cifs_get_writable_path(tcon, full_path, FIND_WR_WITH_DELETE, &cfile);
+	cifs_get_writable_path(tcon, full_path, FIND_WITH_DELETE, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms, iov,
 			      cmds, num_cmds, cfile, NULL, NULL, dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease\n");
-		cifs_get_writable_path(tcon, full_path,
-				       FIND_WR_WITH_DELETE, &cfile);
+		cifs_get_writable_path(tcon, full_path, FIND_WITH_DELETE, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms, iov,
 				      cmds, num_cmds, cfile, NULL, NULL, NULL);
 	}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7f2d3459cbf9..cd7b751e923d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3352,7 +3352,7 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
 	struct cifsFileInfo *open_file = NULL;
 
 	if (inode && !(info & SACL_SECINFO))
-		open_file = find_readable_file(CIFS_I(inode), true);
+		open_file = find_readable_file(CIFS_I(inode), FIND_FSUID_ONLY);
 	if (!open_file || (info & SACL_SECINFO))
 		return get_smb2_acl_by_path(cifs_sb, path, pacllen, info);
 
@@ -3898,7 +3898,7 @@ static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, loff_t offs
 	 * some servers (Windows2016) will not reflect recent writes in
 	 * QUERY_ALLOCATED_RANGES until SMB2_flush is called.
 	 */
-	wrcfile = find_writable_file(cifsi, FIND_WR_ANY);
+	wrcfile = find_writable_file(cifsi, FIND_ANY);
 	if (wrcfile) {
 		filemap_write_and_wait(inode->i_mapping);
 		smb2_flush_file(xid, tcon, &wrcfile->fid);
-- 
2.53.0

