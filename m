Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481602C0303;
	Wed, 30 Sep 2026 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728769; cv=none; b=otun31JrcGdzgZJ3qErhm08hBEjh5hlc4lTxBljP1fuwdQXU6mTd8iR2jGboXmVBfNkRfA+6SkS1CfHaLrMfxhMl38hGD9sAPytu1glq2Yj2Oy5iqob6bsEi5+cn6PLQS/9zP5OUqBk7FNLeU79Xs48tae0eszGtMprGMaxowhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728769; c=relaxed/simple;
	bh=zXXmJ//fAUP5wYkoabvPC659fyQh6j2GY616lAVsWXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULi1GF84kLBwBJbYn+tcxMFh6+BSDcey1RKKFS2T3d4Qx/nxmsNcnWc8pstqRAv55EwBx2wm4SxSDOIWX0ebHr+vdxmD9yGNAf+fOhon9RF3vgNBirMNg/eWKJNDtOojZQ7/08Mtj2GqiZClEHgzmLaG7b4OwDK/7yA1rGioZqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=xhUG6NCo; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="xhUG6NCo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=BpEOs9luKJgPY84UQheuVHbfERcOG1ON3nUkmcu9ApY=; b=xhUG6NCosZG0Q47I7n7ejyAV+x
	5NY2HCK1nh5EsO3ewK0PHm49cOmQxgIowQb8t3lpIk1kHHOYAjXEIgCfsjX1RL1sGjU0VZpOdSkHJ
	gQNlIm7M2wzUjV2k2v204h2NKM3E6ub9OrYkGg3Dbc9/YZ19Sj1aOE+aK+GwtRYVq/btOOO/T/ai8
	TJXWlW9/Ruwz7/I7HIOrX9H4IJ9cF8Pa2LBb+Jn3muphkjkcbXY1Le15UoCstOr1xJyVqIVbBll5m
	/dGzx/5p5MUkK1/CZqya9BVH9PFVyEAbD37sBKxUltCFndqXJk1cNNjYd4evFKoGiscqmw5DcRrFh
	Drwc3XWQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBiLl-00000002aDO-3RWA;
	Tue, 29 Sep 2026 21:39:09 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 02/15] smb: client: clear post-EOF pagecache when extending a file via truncate
Date: Tue, 29 Sep 2026 21:38:55 -0300
Message-ID: <20260930003908.1703770-3-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930003908.1703770-1-pc@manguebit.org>
References: <20260930003908.1703770-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_setsize() relied on pagecache_isize_extended() to zero the tail of
the folio straddling the old EOF, but that helper is a no-op on CIFS
(i_blkbits is 14), so data dirtied past EOF through an mmap survived
and became visible once the file was extended.

Use netfs_clear_stale_post_isize() instead, called after i_size is
updated since cifs_setsize() callers hold i_rwsem exclusively for the
whole resize.  truncate_pagecache() is then called as in
truncate_setsize(): a no-op on extend, and it drops the pagecache
beyond the new EOF on shrink.

Also thread old_size as an explicit parameter through cifs_setsize()
and cifs_resize_file_locked(), captured by each caller before its own
resize RPC.  This closes a race where a concurrent stat() could adopt
the RPC's already-updated server size via is_size_safe_to_change()
before cifs_setsize() reads old_size itself.

Closes: https://sashiko.dev/#/patchset/20260921230755.1133425-1-pc%40manguebit.org
Fixes: c510edb9734a ("cifs: call pagecache_isize_extended() in cifs_setsize() when extending")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsfs.h  |  5 +++--
 fs/smb/client/file.c    |  3 ++-
 fs/smb/client/inode.c   | 22 ++++++++++++++--------
 fs/smb/client/smb2ops.c | 10 ++++++----
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 0c85daa8386e..e3d820c9778b 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -146,8 +146,9 @@ ssize_t cifs_file_copychunk_range(unsigned int xid, struct file *src_file,
 				  unsigned int flags);
 
 long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg);
-void cifs_setsize(struct inode *inode, loff_t offset);
-void cifs_resize_file_locked(struct inode *inode, loff_t offset);
+void cifs_setsize(struct inode *inode, loff_t old_size, loff_t offset);
+void cifs_resize_file_locked(struct inode *inode, loff_t old_size,
+			     loff_t offset);
 
 struct fs_context;
 struct smb3_fs_context;
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 0d428517f454..4bcb87610897 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1017,6 +1017,7 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 	if (!rc) {
 		if (cfile) {
 			struct netfs_inode *ictx = netfs_inode(inode);
+			loff_t old_size = i_size_read(inode);
 
 			tcon = tlink_tcon(cfile->tlink);
 			server = tcon->ses->server;
@@ -1025,7 +1026,7 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 							cfile, 0, false);
 			if (!rc) {
 				netfs_resize_file(&cinode->netfs, 0, true);
-				cifs_setsize(inode, 0);
+				cifs_setsize(inode, old_size, 0);
 				cifs_invalidate_cache(inode, 0);
 			}
 			netfs_wb_end(ictx);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1fe0ef0a95db..5062474991cf 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3053,15 +3053,12 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 	return -EOPNOTSUPP;
 }
 
-void cifs_setsize(struct inode *inode, loff_t offset)
+void cifs_setsize(struct inode *inode, loff_t old_size, loff_t offset)
 {
-	loff_t old_size;
 	u64 blocks = CIFS_INO_BLOCKS(offset);
 
 	spin_lock(&inode->i_lock);
-	old_size = i_size_read(inode);
 	i_size_write(inode, offset);
-
 	/*
 	 * Extending EOF does not allocate the intervening range. Only clamp
 	 * i_blocks on shrink; allocation growth comes from writes or from the
@@ -3071,20 +3068,28 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 		inode->i_blocks = blocks;
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+
+	/*
+	 * Zero the tail of the folio straddling the old EOF so data dirtied
+	 * past EOF through an mmap isn't exposed.  truncate_pagecache() then
+	 * drops any pagecache beyond the new EOF, as in truncate_setsize().
+	 */
 	if (offset > old_size)
-		pagecache_isize_extended(inode, old_size, offset);
+		netfs_clear_stale_post_isize(inode, old_size, offset);
+
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
 }
 
-void cifs_resize_file_locked(struct inode *inode, loff_t offset)
+void cifs_resize_file_locked(struct inode *inode, loff_t old_size,
+			     loff_t offset)
 {
 	struct fscache_cookie *cookie = cifs_inode_cookie(inode);
 
 	lockdep_assert_held_write(&inode->i_rwsem);
 
 	netfs_resize_file(netfs_inode(inode), offset, true);
-	cifs_setsize(inode, offset);
+	cifs_setsize(inode, old_size, offset);
 
 	if (!cookie)
 		return;
@@ -3101,6 +3106,7 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
+	loff_t old_size = i_size_read(inode);
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon = NULL;
 	struct TCP_Server_Info *server;
@@ -3159,7 +3165,7 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 
 set_size_out:
 	if (rc == 0)
-		cifs_resize_file_locked(inode, size);
+		cifs_resize_file_locked(inode, old_size, size);
 
 	return rc;
 }
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index aa142420dae2..1ada1c0a728d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2287,6 +2287,7 @@ smb2_duplicate_extents(const unsigned int xid,
 	struct duplicate_extents_to_file dup_ext_buf;
 	struct timespec64 ts;
 	struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
+	loff_t old_size;
 	u64 asize;
 
 	/* server fileays advertise duplicate extent support with this flag */
@@ -2305,11 +2306,12 @@ smb2_duplicate_extents(const unsigned int xid,
 			       trgtfile->fid.volatile_fid, tcon->tid,
 			       tcon->ses->Suid, src_off, dest_off, len);
 	inode = d_inode(trgtfile->dentry);
-	if (i_size_read(inode) < dest_off + len) {
+	old_size = i_size_read(inode);
+	if (old_size < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
-		cifs_resize_file_locked(inode, dest_off + len);
+		cifs_resize_file_locked(inode, old_size, dest_off + len);
 	}
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid,
@@ -3883,7 +3885,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 			}
 
 			new_eof = off + len;
-			cifs_resize_file_locked(inode, new_eof);
+			cifs_resize_file_locked(inode, old_eof, new_eof);
 
 			qrc = SMB2_query_info(xid, tcon,
 					      cfile->fid.persistent_fid,
@@ -3931,7 +3933,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		if (rc)
 			goto out;
 
-		cifs_resize_file_locked(inode, new_eof);
+		cifs_resize_file_locked(inode, old_eof, new_eof);
 
 		qrc = SMB2_query_info(xid, tcon,
 				      cfile->fid.persistent_fid,
-- 
2.55.0

