Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E059A253355
	for <linux-cifs@vger.kernel.org>; Mon,  6 Oct 2025 19:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759777740; cv=none; b=P/ayEiPyAI26LnMJaXxOl2vPGE+7ciuYR1F184WbUUnRyvZI6XYBLoKeMTJ+eN4FzYSlO29V+3YgR5qLXaorBAyLJIzrChU6DXW8DiybcF8eGvvn9kAnev/YOOhnOXht5TLoyqbjvMGnKGvQcTlqmYPyNBoisGZJXC6Vg7jaMog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759777740; c=relaxed/simple;
	bh=FhIQ2BPtycKmamafwtMuB1uvpiwGeHc1nvYJbNixTJE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t/TeD8QORUOYpgH82E2HDZkLO7HimIGajSzP7UeUr2t5kA5szJNWJwjdAlZZcnw439jngTGxXFPVSYt6Wv8qVYs2hLA+oW9O0P73NHiFdxBguxqxW5o9SxkduOZc+jNtxpRWE5eaTxuYZjJe+UaqqmOW0wgv28ACy1+YOk3FFp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=9alnFmn2; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="9alnFmn2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=8hFdvqpNxGITrrYn7bCCOjkrRMREwuOJifUGySPGMHM=; b=9alnFmn2BrctcYZ2HX1anmpAmg
	8Nd3TO0cviRv/jNM60vW44EzQy/0CF85aTFdIHrulANJmDGfJlMfRCQCUUMbF8kxIV+0xGRExsHzS
	I+35XPh3anWD2gNzIROEnwHirVSiboNgth6X6CeGhgf8Xv5scEo+bsLyF5iJcvFyP0GaXXhnsz3Wj
	FhgaSZJ+cy9mGT76ljwaagxejVDBZ57CvZq81pyns12DOw8raRsrT93IYiLPsBMeqdGCo6eXo+N4V
	z9yNY2hQ4QPjMTZOvlUdkSG4jlZBSDmYrmujIZlNdPp60d/5rYGh4WT6KQWZVm1XVyhAbgJx5BalT
	1OscLYug==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1v5qZp-00000000qka-3DWw;
	Mon, 06 Oct 2025 16:08:54 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Frank Sorenson <sorenson@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 1/3] smb: client: fix missing timestamp updates with O_TRUNC
Date: Mon,  6 Oct 2025 16:08:52 -0300
Message-ID: <20251006190854.103483-1-pc@manguebit.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't call ->set_file_info() on open handle to prevent the server from
stopping [cm]time updates automatically as per MS-FSA 2.1.4.17.

Fix this by checking for ATTR_OPEN bit earlier in cifs_setattr() to
prevent ->set_file_info() from being called when opening a file with
O_TRUNC.  Do the truncation in ->open() instead.

This also saves two roundtrips when opening a file with O_TRUNC and
there are currently no open handles to be reused.

Before patch:

$ mount.cifs //srv/share /mnt -o ...
$ cd /mnt
$ exec 3>foo; stat -c 'old: %z %y' foo; sleep 2; echo test >&3; exec 3>&-; sleep 2; stat -c 'new: %z %y' foo
old: 2025-10-03 13:26:23.151030500 -0300 2025-10-03 13:26:23.151030500 -0300
new: 2025-10-03 13:26:23.151030500 -0300 2025-10-03 13:26:23.151030500 -0300

After patch:

$ mount.cifs //srv/share /mnt -o ...
$ cd /mnt
$ exec 3>foo; stat -c 'old: %z %y' foo; sleep 2; echo test >&3; exec 3>&-; sleep 2; stat -c 'new: %z %y' foo
$ exec 3>foo; stat -c 'old: %z %y' foo; sleep 2; echo test >&3; exec 3>&-; sleep 2; stat -c 'new: %z %y' foo
old: 2025-10-03 13:28:13.911933800 -0300 2025-10-03 13:28:13.911933800 -0300
new: 2025-10-03 13:28:26.647492700 -0300 2025-10-03 13:28:26.647492700 -0300

Reported-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifsglob.h |   5 ++
 fs/smb/client/file.c     |  94 +++++++++++++++++-------
 fs/smb/client/inode.c    | 152 ++++++++++++++++++++++-----------------
 3 files changed, 159 insertions(+), 92 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3ac254e123dc..8f6f567d7474 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1566,6 +1566,11 @@ struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file);
 void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_hdlr,
 		       bool offload);
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
+int cifs_file_flush(const unsigned int xid, struct inode *inode,
+		    struct cifsFileInfo *cfile);
+int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
+		       const char *full_path, struct cifsFileInfo *open_file,
+		       loff_t size);
 
 #define CIFS_CACHE_READ_FLG	1
 #define CIFS_CACHE_HANDLE_FLG	2
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index a5ed742afa00..ecbb63e66521 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -952,6 +952,66 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
 	}
 }
 
+int cifs_file_flush(const unsigned int xid, struct inode *inode,
+		    struct cifsFileInfo *cfile)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_tcon *tcon;
+	int rc;
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)
+		return 0;
+
+	if (cfile && (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE)) {
+		tcon = tlink_tcon(cfile->tlink);
+		return tcon->ses->server->ops->flush(xid, tcon,
+						     &cfile->fid);
+	}
+	rc = cifs_get_writable_file(CIFS_I(inode), FIND_WR_ANY, &cfile);
+	if (!rc) {
+		tcon = tlink_tcon(cfile->tlink);
+		rc = tcon->ses->server->ops->flush(xid, tcon, &cfile->fid);
+		cifsFileInfo_put(cfile);
+	} else if (rc == -EBADF) {
+		rc = 0;
+	}
+	return rc;
+}
+
+static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
+{
+	struct cifsInodeInfo *cinode = CIFS_I(d_inode(dentry));
+	struct inode *inode = d_inode(dentry);
+	struct cifsFileInfo *cfile = NULL;
+	struct TCP_Server_Info *server;
+	struct cifs_tcon *tcon;
+	int rc;
+
+	rc = filemap_write_and_wait(inode->i_mapping);
+	if (is_interrupt_error(rc))
+		return -ERESTARTSYS;
+	mapping_set_error(inode->i_mapping, rc);
+
+	cfile = find_writable_file(cinode, FIND_WR_FSUID_ONLY);
+	rc = cifs_file_flush(xid, inode, cfile);
+	if (!rc) {
+		if (cfile) {
+			tcon = tlink_tcon(cfile->tlink);
+			server = tcon->ses->server;
+			rc = server->ops->set_file_size(xid, tcon,
+							cfile, 0, false);
+		}
+		if (!rc) {
+			netfs_resize_file(&cinode->netfs, 0, true);
+			cifs_setsize(inode, 0);
+			inode->i_blocks = 0;
+		}
+	}
+	if (cfile)
+		cifsFileInfo_put(cfile);
+	return rc;
+}
+
 int cifs_open(struct inode *inode, struct file *file)
 
 {
@@ -1004,6 +1064,12 @@ int cifs_open(struct inode *inode, struct file *file)
 			file->f_op = &cifs_file_direct_ops;
 	}
 
+	if (file->f_flags & O_TRUNC) {
+		rc = cifs_do_truncate(xid, file_dentry(file));
+		if (rc)
+			goto out;
+	}
+
 	/* Get the cached handle as SMB2 close is deferred */
 	if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
 		rc = cifs_get_writable_path(tcon, full_path,
@@ -2685,13 +2751,10 @@ cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 		      int datasync)
 {
-	unsigned int xid;
-	int rc = 0;
-	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *server;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct inode *inode = file_inode(file);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	unsigned int xid;
+	int rc = 0;
 
 	rc = file_write_and_wait_range(file, start, end);
 	if (rc) {
@@ -2712,26 +2775,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 		}
 	}
 
-	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
-		server = tcon->ses->server;
-		if (server->ops->flush == NULL) {
-			rc = -ENOSYS;
-			goto strict_fsync_exit;
-		}
-
-		if ((OPEN_FMODE(smbfile->f_flags) & FMODE_WRITE) == 0) {
-			smbfile = find_writable_file(CIFS_I(inode), FIND_WR_ANY);
-			if (smbfile) {
-				rc = server->ops->flush(xid, tcon, &smbfile->fid);
-				cifsFileInfo_put(smbfile);
-			} else
-				cifs_dbg(FYI, "ignore fsync for file not open for write\n");
-		} else
-			rc = server->ops->flush(xid, tcon, &smbfile->fid);
-	}
-
-strict_fsync_exit:
+	rc = cifs_file_flush(xid, inode, smbfile);
 	free_xid(xid);
 	return rc;
 }
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 8bb544be401e..ce88bef4e44c 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3007,28 +3007,24 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 
 void cifs_setsize(struct inode *inode, loff_t offset)
 {
-	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
-
 	spin_lock(&inode->i_lock);
 	i_size_write(inode, offset);
 	spin_unlock(&inode->i_lock);
-
-	/* Cached inode must be refreshed on truncate */
-	cifs_i->time = 0;
+	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	truncate_pagecache(inode, offset);
 }
 
-static int
-cifs_set_file_size(struct inode *inode, struct iattr *attrs,
-		   unsigned int xid, const char *full_path, struct dentry *dentry)
+int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
+		       const char *full_path, struct cifsFileInfo *open_file,
+		       loff_t size)
 {
-	int rc;
-	struct cifsFileInfo *open_file;
-	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
+	struct inode *inode = d_inode(dentry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon = NULL;
 	struct TCP_Server_Info *server;
+	int rc = -EINVAL;
 
 	/*
 	 * To avoid spurious oplock breaks from server, in the case of
@@ -3039,19 +3035,25 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	 * writebehind data than the SMB timeout for the SetPathInfo
 	 * request would allow
 	 */
-	open_file = find_writable_file(cifsInode, FIND_WR_FSUID_ONLY);
-	if (open_file) {
+	if (open_file && (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE)) {
 		tcon = tlink_tcon(open_file->tlink);
 		server = tcon->ses->server;
-		if (server->ops->set_file_size)
-			rc = server->ops->set_file_size(xid, tcon, open_file,
-							attrs->ia_size, false);
-		else
-			rc = -ENOSYS;
-		cifsFileInfo_put(open_file);
-		cifs_dbg(FYI, "SetFSize for attrs rc = %d\n", rc);
-	} else
-		rc = -EINVAL;
+		rc = server->ops->set_file_size(xid, tcon,
+						open_file,
+						size, false);
+		cifs_dbg(FYI, "%s: set_file_size: rc = %d\n", __func__, rc);
+	} else {
+		open_file = find_writable_file(cifsInode, FIND_WR_FSUID_ONLY);
+		if (open_file) {
+			tcon = tlink_tcon(open_file->tlink);
+			server = tcon->ses->server;
+			rc = server->ops->set_file_size(xid, tcon,
+							open_file,
+							size, false);
+			cifs_dbg(FYI, "%s: set_file_size: rc = %d\n", __func__, rc);
+			cifsFileInfo_put(open_file);
+		}
+	}
 
 	if (!rc)
 		goto set_size_out;
@@ -3069,20 +3071,15 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	 * valid, writeable file handle for it was found or because there was
 	 * an error setting it by handle.
 	 */
-	if (server->ops->set_path_size)
-		rc = server->ops->set_path_size(xid, tcon, full_path,
-						attrs->ia_size, cifs_sb, false, dentry);
-	else
-		rc = -ENOSYS;
-	cifs_dbg(FYI, "SetEOF by path (setattrs) rc = %d\n", rc);
-
-	if (tlink)
-		cifs_put_tlink(tlink);
+	rc = server->ops->set_path_size(xid, tcon, full_path, size,
+					cifs_sb, false, dentry);
+	cifs_dbg(FYI, "%s: SetEOF by path (setattrs) rc = %d\n", __func__, rc);
+	cifs_put_tlink(tlink);
 
 set_size_out:
 	if (rc == 0) {
-		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
-		cifs_setsize(inode, attrs->ia_size);
+		netfs_resize_file(&cifsInode->netfs, size, true);
+		cifs_setsize(inode, size);
 		/*
 		 * i_blocks is not related to (i_size / i_blksize), but instead
 		 * 512 byte (2**9) size is required for calculating num blocks.
@@ -3090,15 +3087,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 		 * this is best estimate we have for blocks allocated for a file
 		 * Number of blocks must be rounded up so size 1 is not 0 blocks
 		 */
-		inode->i_blocks = (512 - 1 + attrs->ia_size) >> 9;
-
-		/*
-		 * The man page of truncate says if the size changed,
-		 * then the st_ctime and st_mtime fields for the file
-		 * are updated.
-		 */
-		attrs->ia_ctime = attrs->ia_mtime = current_time(inode);
-		attrs->ia_valid |= ATTR_CTIME | ATTR_MTIME;
+		inode->i_blocks = (512 - 1 + size) >> 9;
 	}
 
 	return rc;
@@ -3118,7 +3107,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	struct tcon_link *tlink;
 	struct cifs_tcon *pTcon;
 	struct cifs_unix_set_info_args *args = NULL;
-	struct cifsFileInfo *open_file;
+	struct cifsFileInfo *open_file = NULL;
 
 	cifs_dbg(FYI, "setattr_unix on file %pd attrs->ia_valid=0x%x\n",
 		 direntry, attrs->ia_valid);
@@ -3132,6 +3121,9 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	if (rc < 0)
 		goto out;
 
+	if (attrs->ia_valid & ATTR_FILE)
+		open_file = attrs->ia_file->private_data;
+
 	full_path = build_path_from_dentry(direntry, page);
 	if (IS_ERR(full_path)) {
 		rc = PTR_ERR(full_path);
@@ -3159,9 +3151,17 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	rc = 0;
 
 	if (attrs->ia_valid & ATTR_SIZE) {
-		rc = cifs_set_file_size(inode, attrs, xid, full_path, direntry);
+		rc = cifs_file_set_size(xid, direntry, full_path,
+					open_file, attrs->ia_size);
 		if (rc != 0)
 			goto out;
+		/*
+		 * The man page of truncate says if the size changed,
+		 * then the st_ctime and st_mtime fields for the file
+		 * are updated.
+		 */
+		attrs->ia_ctime = attrs->ia_mtime = current_time(inode);
+		attrs->ia_valid |= ATTR_CTIME | ATTR_MTIME;
 	}
 
 	/* skip mode change if it's just for clearing setuid/setgid */
@@ -3206,14 +3206,24 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		args->ctime = NO_CHANGE_64;
 
 	args->device = 0;
-	open_file = find_writable_file(cifsInode, FIND_WR_FSUID_ONLY);
-	if (open_file) {
-		u16 nfid = open_file->fid.netfid;
-		u32 npid = open_file->pid;
+	rc = -EINVAL;
+	if (open_file && (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE)) {
 		pTcon = tlink_tcon(open_file->tlink);
-		rc = CIFSSMBUnixSetFileInfo(xid, pTcon, args, nfid, npid);
-		cifsFileInfo_put(open_file);
+		rc = CIFSSMBUnixSetFileInfo(xid, pTcon, args,
+					    open_file->fid.netfid,
+					    open_file->pid);
 	} else {
+		open_file = find_writable_file(cifsInode, FIND_WR_FSUID_ONLY);
+		if (open_file) {
+			pTcon = tlink_tcon(open_file->tlink);
+			rc = CIFSSMBUnixSetFileInfo(xid, pTcon, args,
+						    open_file->fid.netfid,
+						    open_file->pid);
+			cifsFileInfo_put(open_file);
+		}
+	}
+
+	if (rc) {
 		tlink = cifs_sb_tlink(cifs_sb);
 		if (IS_ERR(tlink)) {
 			rc = PTR_ERR(tlink);
@@ -3221,8 +3231,8 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		}
 		pTcon = tlink_tcon(tlink);
 		rc = CIFSSMBUnixSetPathInfo(xid, pTcon, full_path, args,
-				    cifs_sb->local_nls,
-				    cifs_remap(cifs_sb));
+					    cifs_sb->local_nls,
+					    cifs_remap(cifs_sb));
 		cifs_put_tlink(tlink);
 	}
 
@@ -3264,8 +3274,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	struct inode *inode = d_inode(direntry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
-	struct cifsFileInfo *wfile;
-	struct cifs_tcon *tcon;
+	struct cifsFileInfo *cfile = NULL;
 	const char *full_path;
 	void *page = alloc_dentry_path();
 	int rc = -EACCES;
@@ -3285,6 +3294,9 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (rc < 0)
 		goto cifs_setattr_exit;
 
+	if (attrs->ia_valid & ATTR_FILE)
+		cfile = attrs->ia_file->private_data;
+
 	full_path = build_path_from_dentry(direntry, page);
 	if (IS_ERR(full_path)) {
 		rc = PTR_ERR(full_path);
@@ -3311,25 +3323,24 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 
 	rc = 0;
 
-	if ((attrs->ia_valid & ATTR_MTIME) &&
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
-		rc = cifs_get_writable_file(cifsInode, FIND_WR_ANY, &wfile);
-		if (!rc) {
-			tcon = tlink_tcon(wfile->tlink);
-			rc = tcon->ses->server->ops->flush(xid, tcon, &wfile->fid);
-			cifsFileInfo_put(wfile);
-			if (rc)
-				goto cifs_setattr_exit;
-		} else if (rc != -EBADF)
+	if (attrs->ia_valid & ATTR_MTIME) {
+		rc = cifs_file_flush(xid, inode, cfile);
+		if (rc)
 			goto cifs_setattr_exit;
-		else
-			rc = 0;
 	}
 
 	if (attrs->ia_valid & ATTR_SIZE) {
-		rc = cifs_set_file_size(inode, attrs, xid, full_path, direntry);
+		rc = cifs_file_set_size(xid, direntry, full_path,
+					cfile, attrs->ia_size);
 		if (rc != 0)
 			goto cifs_setattr_exit;
+		/*
+		 * The man page of truncate says if the size changed,
+		 * then the st_ctime and st_mtime fields for the file
+		 * are updated.
+		 */
+		attrs->ia_ctime = attrs->ia_mtime = current_time(inode);
+		attrs->ia_valid |= ATTR_CTIME | ATTR_MTIME;
 	}
 
 	if (attrs->ia_valid & ATTR_UID)
@@ -3459,6 +3470,13 @@ cifs_setattr(struct mnt_idmap *idmap, struct dentry *direntry,
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return -EIO;
+	/*
+	 * Avoid setting [cm]time with O_TRUNC to prevent the server from
+	 * disabling automatic timestamp updates as specified in
+	 * MS-FSA 2.1.4.17.
+	 */
+	if (attrs->ia_valid & ATTR_OPEN)
+		return 0;
 
 	do {
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-- 
2.51.0

