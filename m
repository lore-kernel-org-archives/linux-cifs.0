Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1519630C142
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jun 2026 16:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780677392; cv=none; b=dyGZuC+rYIUhA1+b2mrW0QtFkIJaVte8cEbrSFD6FeRu0Ve86xtIB06L1ukdzvngAZIQS2Cr/S+o265ipSwa0rpsVyV3QynEAO4kstfI4lZ6YXXNwf3TEK0bdxsozie4DT0qAe2LYksRFbm7cHMNmc918F7aw6J+eLAyabCL8II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780677392; c=relaxed/simple;
	bh=MRPDnHgVBnpbo+AamCuKD0QfkgxzHSBsWTrF8zk1M7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Df+zKQBhyz6We6wfufN7rOrChQ7vlmZuRjQVo+hdHuVY2TFd+xntHrzKe9nm8T8KKwTUXU7aJVIOu9o9SYjZQ7CiusR9sMfQOL3OWRfiPuhVo2DO5YyWSyT+qPFdu4jr4WHW1bOvyMG1wn2zVu5enAdw2LN6PLb6PtJFcgnvTHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h3MXAMf1; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h3MXAMf1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780677384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HDF54vuiAmfmJoRJApwknwLrh2q6UWn7LVhTf8pUWRA=;
	b=h3MXAMf1Dr1NP69tIXlCpizWOav3XySDqUIyPuthQe+Mt9afyLyqm9WeclHmjth3eJ2CNt
	l+y2ocVpcB4v32F5tl4yYZYJe00TgvIeFFd/45N8eU6vYnVxu4iZ74ya9OxTBXyV3aTplP
	vzaw5DvQCvlJz9f9BFdfXUmTE1fjan4=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 1/3] smb/client: update i_blocks after contiguous writes
Date: Sat,  6 Jun 2026 00:35:17 +0800
Message-ID: <20260605163519.169916-2-huiwen.he@linux.dev>
In-Reply-To: <20260605163519.169916-1-huiwen.he@linux.dev>
References: <20260605163519.169916-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

When a lease allows CIFS to use cached inode attributes, getattr may
return the locally cached attributes instead of revalidating them from
the server. After local writes extend a file, the write path updates the
file size, but i_blocks can remain based on the old allocation size.

For example, while the file is still open after two contiguous writes,
the local block count can remain smaller than the written range:

        after first write:   st_size = 4096,  st_blocks = 7
        after second write:  st_size = 12288, st_blocks = 21
        after close:         st_size = 12288, st_blocks = 24

This can make a fully written file look sparse:

        i_blocks * 512 < i_size

and can cause swap activation to reject a valid write-created swapfile
as having holes. This results in xfstests skipping swap-related tests
on CIFS mounts:

	generic/472         [not run] swapfiles are not supported
	generic/494         [not run] swapfiles are not supported
	generic/497         [not run] swapfiles are not supported
	generic/569         [not run] swapfiles are not supported
	generic/636         [not run] swapfiles are not supported
	generic/643         [not run] swapfiles are not supported

Update the local i_blocks estimate after successful writes, but only
when the write starts at or before the currently known allocated range.
This lets sequential writes grow i_blocks while avoiding treating
write-past-EOF holes as allocated.

Skip the local estimate for files that are already marked sparse, since
their allocation needs to come from the server rather than from a
contiguous-write estimate.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsfs.c   |  4 ++--
 fs/smb/client/cifsfs.h   |  1 +
 fs/smb/client/cifsglob.h |  9 ++++---
 fs/smb/client/file.c     | 52 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index ce23924f01b3..6b97f7a91235 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1615,7 +1615,7 @@ const struct file_operations cifs_file_strict_ops = {
 
 const struct file_operations cifs_file_direct_ops = {
 	.read_iter = netfs_unbuffered_read_iter,
-	.write_iter = netfs_file_write_iter,
+	.write_iter = cifs_direct_write_iter,
 	.open = cifs_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
@@ -1671,7 +1671,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
 
 const struct file_operations cifs_file_direct_nobrl_ops = {
 	.read_iter = netfs_unbuffered_read_iter,
-	.write_iter = netfs_file_write_iter,
+	.write_iter = cifs_direct_write_iter,
 	.open = cifs_open,
 	.release = cifs_close,
 	.fsync = cifs_fsync,
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index c455b15f2778..c35074ce5aad 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -104,6 +104,7 @@ int cifs_closedir(struct inode *inode, struct file *file);
 ssize_t cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to);
 ssize_t cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from);
 ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from);
+ssize_t cifs_direct_write_iter(struct kiocb *iocb, struct iov_iter *from);
 ssize_t cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter);
 int cifs_flock(struct file *file, int cmd, struct file_lock *fl);
 int cifs_lock(struct file *file, int cmd, struct file_lock *flock);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 82e0adc1dabd..943b7cd2c096 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2387,9 +2387,12 @@ static inline int cifs_open_create_options(unsigned int oflags, int opts)
 }
 
 /*
- * The number of blocks is not related to (i_size / i_blksize), but instead
- * 512 byte (2**9) size is required for calculating num blocks.
+ * inode->i_blocks is counted in 512-byte units, independent of
+ * inode->i_blksize.
  */
-#define CIFS_INO_BLOCKS(size) DIV_ROUND_UP_ULL((u64)(size), 512)
+#define CIFS_INO_BLOCK_SIZE 512ULL
+#define CIFS_INO_BLOCKS(size) \
+	DIV_ROUND_UP_ULL((u64)(size), CIFS_INO_BLOCK_SIZE)
+#define CIFS_INO_BYTES(blocks) ((u64)(blocks) * CIFS_INO_BLOCK_SIZE)
 
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b60344125f27..58430ba51b10 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2514,6 +2514,42 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	return rc;
 }
 
+static void cifs_update_i_blocks_for_write(struct inode *inode, loff_t start,
+					     loff_t end)
+{
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	u64 allocated_end = CIFS_INO_BYTES(inode->i_blocks);
+	u64 blocks;
+
+	if (cinode->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
+		return;
+
+	/*
+	 * Grow the local estimate only across the currently known allocated
+	 * prefix. A write beyond that may leave a hole.
+	 */
+	if ((u64)start > allocated_end)
+		return;
+
+	blocks = CIFS_INO_BLOCKS(end);
+	if ((u64)inode->i_blocks < blocks)
+		inode->i_blocks = blocks;
+}
+
+static void cifs_update_i_blocks_after_write(struct kiocb *iocb,
+						ssize_t written)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	loff_t end = iocb->ki_pos;
+
+	if (written <= 0)
+		return;
+
+	spin_lock(&inode->i_lock);
+	cifs_update_i_blocks_for_write(inode, end - written, end);
+	spin_unlock(&inode->i_lock);
+}
+
 void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t result)
 {
 	struct netfs_io_request *wreq = wdata->rreq;
@@ -2532,6 +2568,8 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t
 			netfs_write_zero_point(inode, wrend);
 		if (wrend > ictx->_remote_i_size)
 			netfs_resize_file(ictx, wrend, true);
+		cifs_update_i_blocks_for_write(inode, wdata->subreq.start,
+						 wrend);
 
 		spin_unlock(&inode->i_lock);
 	}
@@ -2920,6 +2958,7 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	rc = netfs_buffered_write_iter_locked(iocb, from, NULL);
+	cifs_update_i_blocks_after_write(iocb, rc);
 
 out:
 	up_read(&cinode->lock_sem);
@@ -2949,6 +2988,7 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 		    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
 		    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
 			written = netfs_file_write_iter(iocb, from);
+			cifs_update_i_blocks_after_write(iocb, written);
 			goto out;
 		}
 		written = cifs_writev(iocb, from);
@@ -2961,6 +3001,7 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 	 * these pages but not on the region from pos to ppos+len-1.
 	 */
 	written = netfs_file_write_iter(iocb, from);
+	cifs_update_i_blocks_after_write(iocb, written);
 	if (CIFS_CACHE_READ(cinode)) {
 		/*
 		 * We have read level caching and we have just sent a write
@@ -2979,6 +3020,15 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 	return written;
 }
 
+ssize_t cifs_direct_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	ssize_t written;
+
+	written = netfs_file_write_iter(iocb, from);
+	cifs_update_i_blocks_after_write(iocb, written);
+	return written;
+}
+
 ssize_t cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	ssize_t rc;
@@ -3003,6 +3053,7 @@ ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (iocb->ki_filp->f_flags & O_DIRECT) {
 		written = netfs_unbuffered_write_iter(iocb, from);
+		cifs_update_i_blocks_after_write(iocb, written);
 		if (written > 0 && CIFS_CACHE_READ(cinode)) {
 			cifs_zap_mapping(inode);
 			cifs_dbg(FYI,
@@ -3018,6 +3069,7 @@ ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return written;
 
 	written = netfs_file_write_iter(iocb, from);
+	cifs_update_i_blocks_after_write(iocb, written);
 
 	if (!CIFS_CACHE_WRITE(CIFS_I(inode))) {
 		rc = filemap_fdatawrite(inode->i_mapping);
-- 
2.43.0

