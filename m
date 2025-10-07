Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A24220E31C
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 19:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759865017; cv=none; b=BlyeJQ0GMG1KSX/q6lTcmPj1Lk9pfmHG+X2+E/SiRN1sOkP7WXuRk+f/eYiRA5fLf6iY2JXiEau1QuxEQC/ebBBcJupW0eGZQ8xmwCHHNfggBbbGapDplzCmpG3T+rJZ0VV/31lz5cDgfDq3d6eO7r8RGUaT09dfsv//hoYWGyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759865017; c=relaxed/simple;
	bh=2QLXb7bNkeWm+V5WTvED4MLjtFTGX16zSXWvrP65CQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNgm4rAzgtcX884T5nmQVWYpdfrvHW6sfYa9vlW4GY/6k+S0JcO5fubej3qNWR5gdxhchwHgXWEgWZ9scwGDP14ylf9Ojrwx4Lw43SgpXvBW//USgosPU9AXz0s7UgFO+mUIVzp37ZpzA6Ah9JmIdElFbOJPpcnuiuVjFYUlNy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=O5Prn/oK; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="O5Prn/oK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=psdhGCxRBHsCfXUTdXo1uDDLOpsm6N69q3vYyP2p0io=; b=O5Prn/oKTZ79ODiT7Ue2QylNs4
	oFWYSastFNiHvxlpGjQ4DV9BUYUhUbdvZAl3zhqHDqRj/8krULW/JuYvh9HpjSTaLrVgklZhTFxyV
	4giy0Rzr8vg3EU85tCupAI2Wo/k63+HuDVLEuvRobrEtP7OVcayV70B9yIFCSjN1Kbkfzgq9jBrpY
	RKiWIEaCjOMpXSxdb/CU27ZiAZaYwG6UiGnOlKARdA+fSi9+aGyJk0ocuDY9RpUVXlI1lDV4L0r9Q
	LKPSusAn2Cdg4/EFKpqWQEVbjh7hGKL9vvWAnQn/9roKkgpBFoNtBrLHr2eGfjfwyVr2JIViL4RHB
	7IQeeX0g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1v6DHR-00000000twi-2ZYa;
	Tue, 07 Oct 2025 16:23:26 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Frank Sorenson <sorenson@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v3 4/4] smb: client: fix race with fallocate(2) and AIO+DIO
Date: Tue,  7 Oct 2025 16:23:25 -0300
Message-ID: <20251007192326.234467-4-pc@manguebit.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251007192326.234467-1-pc@manguebit.org>
References: <20251007192326.234467-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AIO+DIO may extend the file size, hence we need to make sure ->i_size
is stable across the entire fallocate(2) operation, otherwise it would
become a truncate and then inode size reduced back down when it
finishes.

Fix this by calling netfs_wait_for_outstanding_io() right after
acquiring ->i_rwsem exclusively in cifs_fallocate() and then guarantee
a stable ->i_size across fallocate(2).

Also call netfs_wait_for_outstanding_io() after truncating pagecache
to avoid any potential races with writeback.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifsfs.c  | 22 +++++++++++++++++++---
 fs/smb/client/inode.c   |  1 +
 fs/smb/client/smb2ops.c | 18 ++++++------------
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 1775c2b7528f..05b1fa76e8cc 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -392,11 +392,27 @@ static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)
 	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct TCP_Server_Info *server = tcon->ses->server;
+	struct inode *inode = file_inode(file);
+	int rc;
 
-	if (server->ops->fallocate)
-		return server->ops->fallocate(file, tcon, mode, off, len);
+	if (!server->ops->fallocate)
+		return -EOPNOTSUPP;
 
-	return -EOPNOTSUPP;
+	rc = inode_lock_killable(inode);
+	if (rc)
+		return rc;
+
+	netfs_wait_for_outstanding_io(inode);
+
+	rc = file_modified(file);
+	if (rc)
+		goto out_unlock;
+
+	rc = server->ops->fallocate(file, tcon, mode, off, len);
+
+out_unlock:
+	inode_unlock(inode);
+	return rc;
 }
 
 static int cifs_permission(struct mnt_idmap *idmap,
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index fbfd5b556815..239dd84a336f 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3012,6 +3012,7 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	truncate_pagecache(inode, offset);
+	netfs_wait_for_outstanding_io(inode);
 }
 
 int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 80114292e2c9..6226dc787860 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3367,7 +3367,6 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 			      ses->Suid, offset, len);
 
-	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 
 	i_size = i_size_read(inode);
@@ -3385,6 +3384,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	 * first, otherwise the data may be inconsistent with the server.
 	 */
 	truncate_pagecache_range(inode, offset, offset + len - 1);
+	netfs_wait_for_outstanding_io(inode);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
 	rc = -EOPNOTSUPP;
@@ -3413,7 +3413,6 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 
  zero_range_exit:
 	filemap_invalidate_unlock(inode->i_mapping);
-	inode_unlock(inode);
 	free_xid(xid);
 	if (rc)
 		trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,
@@ -3437,7 +3436,6 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 
 	xid = get_xid();
 
-	inode_lock(inode);
 	/* Need to make file sparse, if not already, before freeing range. */
 	/* Consider adding equivalent for compressed since it could also work */
 	if (!smb2_set_sparse(xid, tcon, cfile, inode, set_sparse)) {
@@ -3451,6 +3449,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	 * caches first, otherwise the data may be inconsistent with the server.
 	 */
 	truncate_pagecache_range(inode, offset, offset + len - 1);
+	netfs_wait_for_outstanding_io(inode);
 
 	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
 
@@ -3485,7 +3484,6 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 unlock:
 	filemap_invalidate_unlock(inode->i_mapping);
 out:
-	inode_unlock(inode);
 	free_xid(xid);
 	return rc;
 }
@@ -3749,8 +3747,6 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 
 	xid = get_xid();
 
-	inode_lock(inode);
-
 	old_eof = i_size_read(inode);
 	if ((off >= old_eof) ||
 	    off + len >= old_eof) {
@@ -3765,6 +3761,7 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 
 	truncate_pagecache_range(inode, off, old_eof);
 	ictx->zero_point = old_eof;
+	netfs_wait_for_outstanding_io(inode);
 
 	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
 				  old_eof - off - len, off);
@@ -3785,8 +3782,7 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	fscache_resize_cookie(cifs_inode_cookie(inode), new_eof);
 out_2:
 	filemap_invalidate_unlock(inode->i_mapping);
- out:
-	inode_unlock(inode);
+out:
 	free_xid(xid);
 	return rc;
 }
@@ -3803,8 +3799,6 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 
 	xid = get_xid();
 
-	inode_lock(inode);
-
 	old_eof = i_size_read(inode);
 	if (off >= old_eof) {
 		rc = -EINVAL;
@@ -3819,6 +3813,7 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	if (rc < 0)
 		goto out_2;
 	truncate_pagecache_range(inode, off, old_eof);
+	netfs_wait_for_outstanding_io(inode);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, new_eof);
@@ -3841,8 +3836,7 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	rc = 0;
 out_2:
 	filemap_invalidate_unlock(inode->i_mapping);
- out:
-	inode_unlock(inode);
+out:
 	free_xid(xid);
 	return rc;
 }
-- 
2.51.0

