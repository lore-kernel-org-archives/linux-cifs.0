Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D12778F29;
	Mon,  7 Sep 2026 01:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788743001; cv=none; b=L/eVE3jvVMe85cRcWX2Ru8Xa0uudL4bQ03lD462IY1W3JIF3I701WBht3sdwsD8IdmUxoCXIhPOQqNKnsDgriqt5XR585JCqelB+QJgkH4LSG2mFdNCAsamh85kecf88zgRxrCzLsR2SI/Xi2nVncXceLYzZZM6rc/uvEd+M3VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788743001; c=relaxed/simple;
	bh=X7nnYnwRzB9eOYcbx31Is/jJEKdGevWobdFdjD3Ql44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzGztHtwW3Kub6CErSmYnxGxqTkP3VfwtoMCh+NprcBi+UW6futh7vHdNiPr56of73wxVxvmTPe+oM3ww0E8h2owCBpTUFoLkiE31cVcU1tIk4xMb6nQlo2M/jvZ2bgqG8I8XrOOeJv4zdtELsGXMZzzG1nQYnBaQGj+UF32jh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQYWF+3H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQYWF+3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554F81F00A3A;
	Mon,  7 Sep 2026 01:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788742996;
	bh=8j/RRnX02chxZktJTkvZ6vPzJwa9MqHWU9ssKaR8WgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQYWF+3HQdJqgWNxMMGvPxTSMh6V/unzmFecoQMsY7kLMC0DsfPGcQ6QE70AoG0Nw
	 IJWtW1v7DqSpb5PHcAZli6+mN/YOB2kuesGWjLTd1B4qlmDUzHCkNfvRHSSQJyWEIJ
	 8uZ+STFnsPE+13yBVwxxNUdwzcs73Ir5cCdKWLXJWVI4XAZrGNTyfJJTrVEUYW+rNf
	 pUZu+MD+As2csWMh/tzJwQ8LeGzkNPB2KKD3Q309WsXdDnqOCsf5p7bmm0EzDBqjgI
	 o5FkPAiDO+URK7SiwB1foCOyNHS6deqUJxTwL+wYGwRSEDc1NW5Bp8KbBxQL2PJF+4
	 FIF7C8Cya2vKw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y 1/2] smb: client: fix generic/694 due to wrong ->i_blocks
Date: Sun,  6 Sep 2026 21:03:12 -0400
Message-ID: <20260907010313.1949936-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090359-ahoy-outage-a083@gregkh>
References: <2026090359-ahoy-outage-a083@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 23b5df09c27aec13962b30d32a4167ebdd043f8e ]

When updating ->i_size, make sure to always update ->i_blocks as well
until we query new allocation size from the server.

generic/694 was failing because smb3_simple_falloc() was missing the
update of ->i_blocks after calling cifs_setsize().  So, fix this by
updating ->i_blocks directly in cifs_setsize(), so all places that
call it doesn't need to worry about updating ->i_blocks later.

Reported-by: Shyam Prasad N <sprasad@microsoft.com>
Closes: https://lore.kernel.org/r/CANT5p=rqgRwaADB=b_PhJkqXjtfq3SFv41SSTXSVEHnuh871pA@mail.gmail.com
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

[ sashal: Reduced backport -- upstream 23b5df09c27ae touches 4 file(s), this
  backport carries 4. Not backported here:
  fs/smb/client/file.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 32a7af68df73 ("cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie() under i_rwsem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.h   |   6 +-
 fs/smb/client/cifsglob.h |   6 ++
 fs/smb/client/inode.c    |  28 ++++------
 fs/smb/client/smb2ops.c  | 116 ++++++++++++++++++++++++++++-----------
 4 files changed, 104 insertions(+), 52 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 71b720dbb2ce3..0935d2168fa65 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -128,14 +128,14 @@ extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
 # define cifs_listxattr NULL
 #endif
 
+extern int cifs_truncate_page(struct address_space *mapping, loff_t from);
 extern ssize_t cifs_file_copychunk_range(unsigned int xid,
 					struct file *src_file, loff_t off,
 					struct file *dst_file, loff_t destoff,
 					size_t len, unsigned int flags);
 
-extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
-extern void cifs_setsize(struct inode *inode, loff_t offset);
-extern int cifs_truncate_page(struct address_space *mapping, loff_t from);
+long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg);
+void cifs_setsize(struct inode *inode, loff_t offset);
 
 struct smb3_fs_context;
 extern struct dentry *cifs_smb3_do_mount(struct file_system_type *fs_type,
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3f9c03828cd4f..a9da551514ba4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2284,4 +2284,10 @@ static inline int cifs_open_create_options(unsigned int oflags, int opts)
 	return opts;
 }
 
+/*
+ * The number of blocks is not related to (i_size / i_blksize), but instead
+ * 512 byte (2**9) size is required for calculating num blocks.
+ */
+#define CIFS_INO_BLOCKS(size) DIV_ROUND_UP_ULL((u64)(size), 512)
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index b67b316538b83..a37abb0311253 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -235,13 +235,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 	 */
 	if (is_size_safe_to_change(cifs_i, fattr->cf_eof, from_readdir)) {
 		i_size_write(inode, fattr->cf_eof);
-
-		/*
-		 * i_blocks is not related to (i_size / i_blksize),
-		 * but instead 512 byte (2**9) size is required for
-		 * calculating num blocks.
-		 */
-		inode->i_blocks = (512 - 1 + fattr->cf_bytes) >> 9;
+		inode->i_blocks = CIFS_INO_BLOCKS(fattr->cf_bytes);
 	}
 
 	if (S_ISLNK(fattr->cf_mode) && fattr->cf_symlink_target) {
@@ -2960,6 +2954,11 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 
 	spin_lock(&inode->i_lock);
 	i_size_write(inode, offset);
+	/*
+	 * Until we can query the server for actual allocation size,
+	 * this is best estimate we have for blocks allocated for a file.
+	 */
+	inode->i_blocks = CIFS_INO_BLOCKS(offset);
 	spin_unlock(&inode->i_lock);
 
 	/* Cached inode must be refreshed on truncate */
@@ -2974,6 +2973,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 		   unsigned int xid, const char *full_path, struct dentry *dentry)
 {
 	int rc;
+	loff_t size = attrs->ia_size;
 	struct cifsFileInfo *open_file;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
@@ -3032,17 +3032,11 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 
 set_size_out:
 	if (rc == 0) {
-		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
-		cifs_setsize(inode, attrs->ia_size);
-		/*
-		 * i_blocks is not related to (i_size / i_blksize), but instead
-		 * 512 byte (2**9) size is required for calculating num blocks.
-		 * Until we can query the server for actual allocation size,
-		 * this is best estimate we have for blocks allocated for a file
-		 * Number of blocks must be rounded up so size 1 is not 0 blocks
-		 */
-		inode->i_blocks = (512 - 1 + attrs->ia_size) >> 9;
+		netfs_resize_file(&cifsInode->netfs, size, true);
+		cifs_setsize(inode, size);
+	}
 
+	if (rc == 0) {
 		/*
 		 * The man page of truncate says if the size changed,
 		 * then the st_ctime and st_mtime fields for the file
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e99b8e1f66d4f..f933dfb74fd9e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1506,6 +1506,7 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct smb2_file_network_open_info file_inf;
 	struct inode *inode;
+	u64 asize;
 	int rc;
 
 	rc = __SMB2_close(xid, tcon, cfile->fid.persistent_fid,
@@ -1529,14 +1530,9 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 		inode_set_atime_to_ts(inode,
 				      cifs_NTtimeToUnix(file_inf.LastAccessTime));
 
-	/*
-	 * i_blocks is not related to (i_size / i_blksize),
-	 * but instead 512 byte (2**9) size is required for
-	 * calculating num blocks.
-	 */
-	if (le64_to_cpu(file_inf.AllocationSize) > 4096)
-		inode->i_blocks =
-			(512 - 1 + le64_to_cpu(file_inf.AllocationSize)) >> 9;
+	asize = le64_to_cpu(file_inf.AllocationSize);
+	if (asize > 4096)
+		inode->i_blocks = CIFS_INO_BLOCKS(asize);
 
 	/* End of file and Attributes should not have to be updated on close */
 	spin_unlock(&inode->i_lock);
@@ -2118,14 +2114,6 @@ smb2_duplicate_extents(const unsigned int xid,
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
-
-		/*
-		 * Although also could set plausible allocation size (i_blocks)
-		 * here in addition to setting the file size, in reflink
-		 * it is likely that the target file is sparse. Its allocation
-		 * size will be queried on next revalidate, but it is important
-		 * to make sure that file's cached size is updated immediately
-		 */
 		netfs_resize_file(netfs_inode(inode), dest_off + len, true);
 		cifs_setsize(inode, dest_off + len);
 	}
@@ -3442,7 +3430,7 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 					     char *buf)
 {
 	struct cifs_io_parms io_parms = {0};
-	int nbytes;
+	unsigned int nbytes;
 	int rc = 0;
 	struct kvec iov[2];
 
@@ -3463,9 +3451,10 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 		rc = SMB2_write(xid, &io_parms, &nbytes, iov, 1);
 		if (rc)
 			break;
+		if (!nbytes)
+			return -EIO;
 		if (nbytes > len)
 			return -EINVAL;
-		buf += nbytes;
 		off += nbytes;
 		len -= nbytes;
 	}
@@ -3478,12 +3467,25 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 				       loff_t off, loff_t len)
 {
 	struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
+	struct inode *inode = d_inode(cfile->dentry);
 	u32 out_data_len;
 	char *buf = NULL;
 	u64 range_start, range_len, range_end;
 	loff_t l;
 	int rc;
 
+	buf = kvzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (off >= i_size_read(inode)) {
+		rc = smb3_simple_fallocate_write_range(xid, tcon, cfile,
+						       off, len, buf);
+		goto out;
+	}
+
 	in_data.file_offset = cpu_to_le64(off);
 	in_data.length = cpu_to_le64(len);
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
@@ -3495,12 +3497,6 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kvzalloc(1024 * 1024, GFP_KERNEL);
-	if (buf == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	tmp_data = out_data;
 	while (len) {
 		/*
@@ -3575,18 +3571,22 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	long rc = -EOPNOTSUPP;
 	unsigned int xid;
-	loff_t new_eof;
+	loff_t old_eof, new_eof;
+	struct smb2_file_all_info file_inf;
+	u64 asize;
+	int qrc;
 
 	xid = get_xid();
 
 	inode = d_inode(cfile->dentry);
 	cifsi = CIFS_I(inode);
+	old_eof = i_size_read(inode);
 
 	trace_smb3_falloc_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 				tcon->ses->Suid, off, len);
 	/* if file not oplocked can't be sure whether asking to extend size */
 	if (!CIFS_CACHE_READ(cifsi))
-		if (keep_size == false) {
+		if (!keep_size) {
 			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
 				tcon->tid, tcon->ses->Suid, off, len, rc);
 			free_xid(xid);
@@ -3596,23 +3596,75 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * Extending the file
 	 */
-	if ((keep_size == false) && i_size_read(inode) < off + len) {
+	if (!keep_size && old_eof < off + len) {
 		rc = inode_newsize_ok(inode, off + len);
 		if (rc)
 			goto out;
 
+		/*
+		 * A small range at or beyond EOF can be allocated by writing
+		 * zeroes.  For off > old_eof, this preserves the intervening
+		 * hole instead of allocating from offset 0.
+		 */
+		if (off > old_eof ||
+		    (off == old_eof && old_eof != 0 &&
+		     (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE))) {
+			if (len > 1024 * 1024) {
+				rc = -EOPNOTSUPP;
+				goto out;
+			}
+
+			rc = smb3_simple_fallocate_range(xid, tcon, cfile,
+							 off, len);
+			if (rc) {
+				spin_lock(&inode->i_lock);
+				cifsi->time = 0;
+				spin_unlock(&inode->i_lock);
+				goto out;
+			}
+
+			new_eof = off + len;
+			netfs_resize_file(&cifsi->netfs, new_eof, true);
+			cifs_setsize(inode, new_eof);
+
+			qrc = SMB2_query_info(xid, tcon,
+					      cfile->fid.persistent_fid,
+					      cfile->fid.volatile_fid, &file_inf);
+			spin_lock(&inode->i_lock);
+			if (qrc == 0) {
+				asize = le64_to_cpu(file_inf.AllocationSize);
+				inode->i_blocks = CIFS_INO_BLOCKS(asize);
+			} else {
+				cifsi->time = 0;
+			}
+			spin_unlock(&inode->i_lock);
+			goto out;
+		}
+
 		if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 
 		new_eof = off + len;
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_eof);
-		if (rc == 0) {
-			netfs_resize_file(&cifsi->netfs, new_eof, true);
-			cifs_setsize(inode, new_eof);
-			cifs_truncate_page(inode->i_mapping, inode->i_size);
-			truncate_setsize(inode, new_eof);
+		if (rc)
+			goto out;
+
+		netfs_resize_file(&cifsi->netfs, new_eof, true);
+		cifs_setsize(inode, new_eof);
+
+		qrc = SMB2_query_info(xid, tcon,
+				      cfile->fid.persistent_fid,
+				      cfile->fid.volatile_fid, &file_inf);
+		spin_lock(&inode->i_lock);
+		if (qrc == 0) {
+			asize = le64_to_cpu(file_inf.AllocationSize);
+			if (asize >= new_eof)
+				inode->i_blocks = CIFS_INO_BLOCKS(asize);
+		} else {
+			cifsi->time = 0;
 		}
+		spin_unlock(&inode->i_lock);
 		goto out;
 	}
 
-- 
2.53.0

