Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D346947F774;
	Thu, 20 Aug 2026 17:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247147; cv=none; b=CO1UESVL8RPa53zvovBu3IE3fGEil5Y9i+o6EYuP/6yfBVbtbc8ucgvw6PjaiOThVRYSf4FrUrukkq8Nft8aFSBQm2PZ66RqASChEb3je0JrQozGd4rGj0/TyoBlGnUeWLCDs5knnf3xPhFSdV0YyaWBnysyNjFK8zzl/IGZ8Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247147; c=relaxed/simple;
	bh=9gy4h4fLwf/fUUL6fojkFM6BjD+VY9tBxiSvD4zHwzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5AKuBC5KOLfWvfiPNO08lSbMQYl6OfticOpfddpSz0YeI3bm1uGBuDTYSEw1sRmy8490/jgPTuY+Q7bbarMpKKcvmB4Wja/4IqTF1vUl4snAIF0RZEwpZRerlOvDO+gT0V/A2o27GGbKDn/jpFJJBgmRAIsXOChawwGvt9KuEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpAqd1Ey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpAqd1Ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B8F1F000E9;
	Thu, 20 Aug 2026 17:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247145;
	bh=muV2YotFrVVRO0Z3hxL7x7jITM2JXVnXQB9rTHLJ24A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IpAqd1Ey5q9ygU/GCsEUY3pxy8YyCQni6lUJMtWfdChdjFowlOlfyeGtRLokrIetZ
	 yTdqEszXoT/3SjnF/0omp7nx8jPjme0sPyJJgTM2760NF5JrKrLFoTl0yJucdHQrFM
	 +B8+QLZScfczdKw2kG2khaldM5Pdf2STTgHv0Zk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Frank Sorenson <sorenson@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/220] smb: client: fix race with fallocate(2) and AIO+DIO
Date: Thu, 20 Aug 2026 16:55:55 +0200
Message-ID: <20260820145228.435544234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit dba9f997c9d9a1cade05d006ed0429a63a4eed32 ]

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
Fixes: 210627b0aca9 ("smb: client: fix missing timestamp updates with O_TRUNC")
Cc: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: fa724e235cfd ("cifs: add fscache_resize_cookie() to cifs_setsize()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c  |   22 +++++++++++++++++++---
 fs/smb/client/inode.c   |    1 +
 fs/smb/client/smb2ops.c |   18 ++++++------------
 3 files changed, 26 insertions(+), 15 deletions(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -359,11 +359,27 @@ static long cifs_fallocate(struct file *
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
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2965,6 +2965,7 @@ void cifs_setsize(struct inode *inode, l
 	/* Cached inode must be refreshed on truncate */
 	cifs_i->time = 0;
 	truncate_pagecache(inode, offset);
+	netfs_wait_for_outstanding_io(inode);
 }
 
 static int
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3315,7 +3315,6 @@ static long smb3_zero_range(struct file
 	trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 			      ses->Suid, offset, len);
 
-	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 
 	i_size = i_size_read(inode);
@@ -3333,6 +3332,7 @@ static long smb3_zero_range(struct file
 	 * first, otherwise the data may be inconsistent with the server.
 	 */
 	truncate_pagecache_range(inode, offset, offset + len - 1);
+	netfs_wait_for_outstanding_io(inode);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
 	rc = -EOPNOTSUPP;
@@ -3361,7 +3361,6 @@ static long smb3_zero_range(struct file
 
  zero_range_exit:
 	filemap_invalidate_unlock(inode->i_mapping);
-	inode_unlock(inode);
 	free_xid(xid);
 	if (rc)
 		trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,
@@ -3385,7 +3384,6 @@ static long smb3_punch_hole(struct file
 
 	xid = get_xid();
 
-	inode_lock(inode);
 	/* Need to make file sparse, if not already, before freeing range. */
 	/* Consider adding equivalent for compressed since it could also work */
 	rc = smb2_set_sparse(xid, tcon, cfile, inode, set_sparse);
@@ -3398,6 +3396,7 @@ static long smb3_punch_hole(struct file
 	 * caches first, otherwise the data may be inconsistent with the server.
 	 */
 	truncate_pagecache_range(inode, offset, offset + len - 1);
+	netfs_wait_for_outstanding_io(inode);
 
 	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
 
@@ -3432,7 +3431,6 @@ static long smb3_punch_hole(struct file
 unlock:
 	filemap_invalidate_unlock(inode->i_mapping);
 out:
-	inode_unlock(inode);
 	free_xid(xid);
 	return rc;
 }
@@ -3709,8 +3707,6 @@ static long smb3_collapse_range(struct f
 
 	xid = get_xid();
 
-	inode_lock(inode);
-
 	old_eof = i_size_read(inode);
 	if ((off >= old_eof) ||
 	    off + len >= old_eof) {
@@ -3725,6 +3721,7 @@ static long smb3_collapse_range(struct f
 
 	truncate_pagecache_range(inode, off, old_eof);
 	ictx->zero_point = old_eof;
+	netfs_wait_for_outstanding_io(inode);
 
 	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
 				  old_eof - off - len, off);
@@ -3745,8 +3742,7 @@ static long smb3_collapse_range(struct f
 	fscache_resize_cookie(cifs_inode_cookie(inode), new_eof);
 out_2:
 	filemap_invalidate_unlock(inode->i_mapping);
- out:
-	inode_unlock(inode);
+out:
 	free_xid(xid);
 	return rc;
 }
@@ -3763,8 +3759,6 @@ static long smb3_insert_range(struct fil
 
 	xid = get_xid();
 
-	inode_lock(inode);
-
 	old_eof = i_size_read(inode);
 	if (off >= old_eof) {
 		rc = -EINVAL;
@@ -3779,6 +3773,7 @@ static long smb3_insert_range(struct fil
 	if (rc < 0)
 		goto out_2;
 	truncate_pagecache_range(inode, off, old_eof);
+	netfs_wait_for_outstanding_io(inode);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, new_eof);
@@ -3801,8 +3796,7 @@ static long smb3_insert_range(struct fil
 	rc = 0;
 out_2:
 	filemap_invalidate_unlock(inode->i_mapping);
- out:
-	inode_unlock(inode);
+out:
 	free_xid(xid);
 	return rc;
 }


