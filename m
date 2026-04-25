Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A73B377EB0
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121755; cv=none; b=ALaDetB7Po+dMHuGtPXSo4yeVGV/yWyUuQIi1mMmZ+HS+y0JC8pc6hXMw/cWvKk5MZ07fjjMyz2marjjBpRrC7cs5XJT2A+WfbQe1zSTzDRc8fxbDShaWMtV9yPUT/eXnj33MhOesYJrl/FtOnQeplxLu2GyGa612PccRwEciTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121755; c=relaxed/simple;
	bh=1KoIBCFcMQ91u9YQHNcfhLNxmBFhoc/pzGFfmv8qQ40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIyUcctxAHTqH/x7lVoYakbbMBPvKIiHEc1GUO1Agknw/JC5VFDUebzLjSwgalwJRD4igWNq6u4bGdbL3Yst70m+T/PSePDvhJxL223BOLY6r86aCdEQgfYpZ4Oy3Sov9iSFPeTiLxIro2tV//xcvWzRTSBtNJ7G9Yiik806NjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SatClvly; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SatClvly"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VZqaO32isrbL7YSHZxjA1mAgSXu6lctELUawXNU8wL4=;
	b=SatClvlyIv+v33sepywT1L4jaZ531WgXXrwkHigo7hZY5SBANpm9SqtNVs+co/h2qmGi7b
	sbAPx+V5O9rWZHYcrI+cQ4fCoz+IxP/1by/nCHOUJSRk7VEcqrrE7T9O0rLvLmUTwC86uz
	g4Pl8g0AyFrVnvN6/GO3ayKWQNoD/QI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-358-LZOxW9O7M0yXMSMRAecKwQ-1; Sat,
 25 Apr 2026 08:55:48 -0400
X-MC-Unique: LZOxW9O7M0yXMSMRAecKwQ-1
X-Mimecast-MFC-AGG-ID: LZOxW9O7M0yXMSMRAecKwQ_1777121747
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 015991800464;
	Sat, 25 Apr 2026 12:55:47 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C91411800348;
	Sat, 25 Apr 2026 12:55:43 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v3 15/19] netfs: Fix potential for tearing in ->remote_i_size and ->zero_point
Date: Sat, 25 Apr 2026 13:54:19 +0100
Message-ID: <20260425125426.3855807-16-dhowells@redhat.com>
In-Reply-To: <20260425125426.3855807-1-dhowells@redhat.com>
References: <20260425125426.3855807-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Fix potential tearing in using ->remote_i_size and ->zero_point by copying
i_size_read() and i_size_write() and using the same seqcount as for i_size.

Fixes: 4058f742105e ("netfs: Keep track of the actual remote file size")
Fixes: 100ccd18bb41 ("netfs: Optimise away reads above the point at which there can be no data")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/9p/vfs_inode.c         |   2 +-
 fs/9p/vfs_inode_dotl.c    |   4 +-
 fs/afs/inode.c            |   8 +-
 fs/afs/write.c            |   2 +-
 fs/netfs/buffered_read.c  |   5 +-
 fs/netfs/buffered_write.c |   2 +-
 fs/netfs/direct_write.c   |   4 +-
 fs/netfs/misc.c           |  13 +-
 fs/netfs/write_collect.c  |   3 +-
 fs/smb/client/cifsfs.c    |  24 ++--
 fs/smb/client/cifssmb.c   |   2 +-
 fs/smb/client/file.c      |   9 +-
 fs/smb/client/inode.c     |   9 +-
 fs/smb/client/readdir.c   |   3 +-
 fs/smb/client/smb2ops.c   |  16 +--
 fs/smb/client/smb2pdu.c   |   2 +-
 include/linux/netfs.h     | 296 ++++++++++++++++++++++++++++++++++++--
 17 files changed, 345 insertions(+), 59 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index d1508b1fe109..b13156ac2f1f 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1141,7 +1141,7 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 	mode |= inode->i_mode & ~S_IALLUGO;
 	inode->i_mode = mode;
 
-	v9inode->netfs.remote_i_size = stat->length;
+	netfs_write_remote_i_size(&v9inode->netfs, stat->length);
 	if (!(flags & V9FS_STAT2INODE_KEEP_ISIZE))
 		v9fs_i_size_write(inode, stat->length);
 	/* not real number of blocks, but 512 byte ones ... */
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 71796a89bcf4..81d6150a8ae4 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -634,7 +634,7 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode,
 		mode |= inode->i_mode & ~S_IALLUGO;
 		inode->i_mode = mode;
 
-		v9inode->netfs.remote_i_size = stat->st_size;
+		netfs_write_remote_i_size(&v9inode->netfs, stat->st_size);
 		if (!(flags & V9FS_STAT2INODE_KEEP_ISIZE))
 			v9fs_i_size_write(inode, stat->st_size);
 		inode->i_blocks = stat->st_blocks;
@@ -664,7 +664,7 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode,
 		}
 		if (!(flags & V9FS_STAT2INODE_KEEP_ISIZE) &&
 		    stat->st_result_mask & P9_STATS_SIZE) {
-			v9inode->netfs.remote_i_size = stat->st_size;
+			netfs_write_remote_i_size(&v9inode->netfs, stat->st_size);
 			v9fs_i_size_write(inode, stat->st_size);
 		}
 		if (stat->st_result_mask & P9_STATS_BLOCKS)
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index a5173434f786..06e25e1b12df 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -343,11 +343,11 @@ static void afs_apply_status(struct afs_operation *op,
 		 * idea of what the size should be that's not the same as
 		 * what's on the server.
 		 */
-		vnode->netfs.remote_i_size = status->size;
+		netfs_write_remote_i_size(&vnode->netfs, status->size);
 		if (change_size || status->size > i_size_read(inode)) {
 			afs_set_i_size(vnode, status->size);
 			if (unexpected_jump)
-				vnode->netfs.zero_point = status->size;
+				netfs_write_zero_point(&vnode->netfs, status->size);
 			inode_set_ctime_to_ts(inode, t);
 			inode_set_atime_to_ts(inode, t);
 		}
@@ -709,7 +709,7 @@ int afs_getattr(struct mnt_idmap *idmap, const struct path *path,
 		 * it, but we need to give userspace the server's size.
 		 */
 		if (S_ISDIR(inode->i_mode))
-			stat->size = vnode->netfs.remote_i_size;
+			stat->size = netfs_read_remote_i_size(&vnode->netfs);
 	} while (read_seqretry(&vnode->cb_lock, seq));
 
 	return 0;
@@ -889,7 +889,7 @@ int afs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		 */
 		if (!(attr->ia_valid & (supported & ~ATTR_SIZE & ~ATTR_MTIME)) &&
 		    attr->ia_size < i_size &&
-		    attr->ia_size > vnode->netfs.remote_i_size) {
+		    attr->ia_size > netfs_read_remote_i_size(&vnode->netfs)) {
 			truncate_setsize(inode, attr->ia_size);
 			netfs_resize_file(&vnode->netfs, size, false);
 			fscache_resize_cookie(afs_vnode_cache(vnode),
diff --git a/fs/afs/write.c b/fs/afs/write.c
index fcfed9d24e0a..c087151c4bf9 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -142,7 +142,7 @@ static void afs_issue_write_worker(struct work_struct *work)
 	afs_begin_vnode_operation(op);
 
 	op->store.write_iter	= &subreq->io_iter;
-	op->store.i_size	= umax(pos + len, vnode->netfs.remote_i_size);
+	op->store.i_size	= umax(pos + len, netfs_read_remote_i_size(&vnode->netfs));
 	op->mtime		= inode_get_mtime(&vnode->netfs.inode);
 
 	afs_wait_for_operation(op);
diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index f94c7f3780e0..f1cbd6e10ad7 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -236,7 +236,8 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		source = netfs_cache_prepare_read(rreq, subreq, rreq->i_size);
 		subreq->source = source;
 		if (source == NETFS_DOWNLOAD_FROM_SERVER) {
-			unsigned long long zp = umin(ictx->zero_point, rreq->i_size);
+			unsigned long long zero_point = netfs_read_zero_point(ictx);
+			unsigned long long zp = umin(zero_point, rreq->i_size);
 			size_t len = subreq->len;
 
 			if (unlikely(rreq->origin == NETFS_READ_SINGLE))
@@ -252,7 +253,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 				pr_err("ZERO-LEN READ: R=%08x[%x] l=%zx/%zx s=%llx z=%llx i=%llx",
 				       rreq->debug_id, subreq->debug_index,
 				       subreq->len, size,
-				       subreq->start, ictx->zero_point, rreq->i_size);
+				       subreq->start, zero_point, rreq->i_size);
 				break;
 			}
 			subreq->len = len;
diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 0439a4c2e003..08d4304028ba 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -227,7 +227,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		 * server would just return a block of zeros or a short read if
 		 * we try to read it.
 		 */
-		if (fpos >= ctx->zero_point) {
+		if (fpos >= netfs_read_zero_point(ctx)) {
 			folio_zero_segment(folio, 0, offset);
 			copied = copy_folio_from_iter_atomic(folio, offset, part, iter);
 			if (unlikely(copied == 0))
diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index f9ab69de3e29..96c1dad04168 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -376,8 +376,8 @@ ssize_t netfs_unbuffered_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (ret < 0)
 		goto out;
 	end = iocb->ki_pos + iov_iter_count(from);
-	if (end > ictx->zero_point)
-		ictx->zero_point = end;
+	if (end > netfs_read_zero_point(ictx))
+		netfs_write_zero_point(ictx, end);
 
 	fscache_invalidate(netfs_i_cookie(ictx), NULL, i_size_read(inode),
 			   FSCACHE_INVAL_DIO_WRITE);
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 8b457124b0e3..1f09733e50a8 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -221,8 +221,8 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 		unsigned long long fpos = folio_pos(folio), end;
 
 		end = umin(fpos + flen, i_size);
-		if (fpos < i_size && end > ctx->zero_point)
-			ctx->zero_point = end;
+		if (fpos < i_size && end > netfs_read_zero_point(ctx))
+			netfs_write_zero_point(ctx, end);
 	}
 
 	folio_wait_private_2(folio); /* [DEPRECATED] */
@@ -297,14 +297,15 @@ EXPORT_SYMBOL(netfs_invalidate_folio);
 bool netfs_release_folio(struct folio *folio, gfp_t gfp)
 {
 	struct netfs_inode *ctx = netfs_inode(folio_inode(folio));
-	unsigned long long end;
+	unsigned long long remote_i_size, zero_point, end;
 
 	if (folio_test_dirty(folio))
 		return false;
 
-	end = umin(folio_next_pos(folio), ctx->remote_i_size);
-	if (end > ctx->zero_point)
-		ctx->zero_point = end;
+	netfs_read_sizes(ctx, &remote_i_size, &zero_point);
+	end = umin(folio_next_pos(folio), remote_i_size);
+	if (end > zero_point)
+		netfs_write_zero_point(ctx, end);
 
 	if (folio_test_private(folio))
 		return false;
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index b194447f4b11..4718e5174d65 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -69,8 +69,7 @@ int netfs_folio_written_back(struct folio *folio)
 		unsigned long long fend;
 
 		fend = folio_pos(folio) + finfo->dirty_offset + finfo->dirty_len;
-		if (fend > ictx->zero_point)
-			ictx->zero_point = fend;
+		netfs_push_back_zero_point(ictx, fend);
 
 		folio_detach_private(folio);
 		group = finfo->netfs_group;
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 9f76b0347fa9..ffd898ae516c 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -434,7 +434,8 @@ cifs_alloc_inode(struct super_block *sb)
 	spin_lock_init(&cifs_inode->writers_lock);
 	cifs_inode->writers = 0;
 	cifs_inode->netfs.inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
-	cifs_inode->netfs.remote_i_size = 0;
+	cifs_inode->netfs._remote_i_size = 0;
+	cifs_inode->netfs._zero_point = 0;
 	cifs_inode->uniqueid = 0;
 	cifs_inode->createtime = 0;
 	cifs_inode->epoch = 0;
@@ -1303,7 +1304,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	struct cifsFileInfo *smb_file_src = src_file->private_data;
 	struct cifsFileInfo *smb_file_target = dst_file->private_data;
 	struct cifs_tcon *target_tcon, *src_tcon;
-	unsigned long long destend, fstart, fend, old_size, new_size;
+	unsigned long long destend, fstart, fend, old_size, new_size, zero_point;
 	unsigned int xid;
 	int rc;
 
@@ -1347,7 +1348,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	 * Advance the EOF marker after the flush above to the end of the range
 	 * if it's short of that.
 	 */
-	if (src_cifsi->netfs.remote_i_size < off + len) {
+	if (netfs_read_remote_i_size(&src_cifsi->netfs) < off + len) {
 		rc = cifs_precopy_set_eof(src_inode, src_cifsi, src_tcon, xid, off + len);
 		if (rc < 0)
 			goto unlock;
@@ -1368,9 +1369,10 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	rc = cifs_flush_folio(target_inode, destend, &fstart, &fend, false);
 	if (rc)
 		goto unlock;
-	if (fend > target_cifsi->netfs.zero_point)
-		target_cifsi->netfs.zero_point = fend + 1;
-	old_size = target_cifsi->netfs.remote_i_size;
+
+	netfs_read_sizes(&target_cifsi->netfs, &old_size, &zero_point);
+	if (fend > zero_point)
+		netfs_write_zero_point(&target_cifsi->netfs, fend + 1);
 
 	/* Discard all the folios that overlap the destination region. */
 	cifs_dbg(FYI, "about to discard pages %llx-%llx\n", fstart, fend);
@@ -1402,8 +1404,8 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 					rc = -EINVAL;
 			}
 		}
-		if (rc == 0 && new_size > target_cifsi->netfs.zero_point)
-			target_cifsi->netfs.zero_point = new_size;
+		if (rc == 0)
+			netfs_push_back_zero_point(&target_cifsi->netfs, new_size);
 	}
 
 	/* force revalidate of size and timestamps of target file now
@@ -1474,7 +1476,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	 * Advance the EOF marker after the flush above to the end of the range
 	 * if it's short of that.
 	 */
-	if (src_cifsi->netfs.remote_i_size < off + len) {
+	if (netfs_read_remote_i_size(&src_cifsi->netfs) < off + len) {
 		rc = cifs_precopy_set_eof(src_inode, src_cifsi, src_tcon, xid, off + len);
 		if (rc < 0)
 			goto unlock;
@@ -1502,8 +1504,8 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 			fscache_resize_cookie(cifs_inode_cookie(target_inode),
 					      i_size_read(target_inode));
 		}
-		if (rc > 0 && destoff + rc > target_cifsi->netfs.zero_point)
-			target_cifsi->netfs.zero_point = destoff + rc;
+		if (rc > 0)
+			netfs_push_back_zero_point(&target_cifsi->netfs, destoff + rc);
 	}
 
 	file_accessed(src_file);
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 3990a9012264..102dd9dde760 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1538,7 +1538,7 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	} else {
 		size_t trans = rdata->subreq.transferred + rdata->got_bytes;
 		if (trans < rdata->subreq.len &&
-		    rdata->subreq.start + trans >= ictx->remote_i_size) {
+		    rdata->subreq.start + trans >= netfs_read_remote_i_size(ictx)) {
 			rdata->result = 0;
 			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 		} else if (rdata->got_bytes > 0) {
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 664a2c223089..55639823437b 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2518,16 +2518,19 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t
 {
 	struct netfs_io_request *wreq = wdata->rreq;
 	struct netfs_inode *ictx = netfs_inode(wreq->inode);
+	unsigned long long remote_i_size, zero_point;
 	loff_t wrend;
 
 	if (result > 0) {
+		netfs_read_sizes(ictx, &remote_i_size, &zero_point);
+
 		wrend = wdata->subreq.start + wdata->subreq.transferred + result;
 
-		if (wrend > ictx->zero_point &&
+		if (wrend > zero_point &&
 		    (wdata->rreq->origin == NETFS_UNBUFFERED_WRITE ||
 		     wdata->rreq->origin == NETFS_DIO_WRITE))
-			ictx->zero_point = wrend;
-		if (wrend > ictx->remote_i_size)
+			netfs_write_zero_point(ictx, wrend);
+		if (wrend > remote_i_size)
 			netfs_resize_file(ictx, wrend, true);
 	}
 
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 16a5310155d5..c5a1e37ce55a 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -119,7 +119,7 @@ cifs_revalidate_cache(struct inode *inode, struct cifs_fattr *fattr)
 	fattr->cf_mtime = timestamp_truncate(fattr->cf_mtime, inode);
 	mtime = inode_get_mtime(inode);
 	if (timespec64_equal(&mtime, &fattr->cf_mtime) &&
-	    cifs_i->netfs.remote_i_size == fattr->cf_eof) {
+	    netfs_read_remote_i_size(&cifs_i->netfs) == fattr->cf_eof) {
 		cifs_dbg(FYI, "%s: inode %llu is unchanged\n",
 			 __func__, cifs_i->uniqueid);
 		return;
@@ -174,7 +174,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 		return -ESTALE;
 	}
 	if (inode_state_read_once(inode) & I_NEW)
-		CIFS_I(inode)->netfs.zero_point = fattr->cf_eof;
+		netfs_write_zero_point(&CIFS_I(inode)->netfs, fattr->cf_eof);
 
 	cifs_revalidate_cache(inode, fattr);
 
@@ -212,7 +212,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 	else
 		clear_bit(CIFS_INO_DELETE_PENDING, &cifs_i->flags);
 
-	cifs_i->netfs.remote_i_size = fattr->cf_eof;
+	netfs_write_remote_i_size(&cifs_i->netfs, fattr->cf_eof);
 	/*
 	 * Can't safely change the file size here if the client is writing to
 	 * it due to potential races.
@@ -2772,7 +2772,8 @@ cifs_revalidate_mapping(struct inode *inode)
 		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RW_CACHE)
 			goto skip_invalidate;
 
-		cifs_inode->netfs.zero_point = cifs_inode->netfs.remote_i_size;
+		netfs_write_zero_point(&cifs_inode->netfs,
+				       netfs_read_remote_i_size(&cifs_inode->netfs));
 		rc = filemap_invalidate_inode(inode, true, 0, LLONG_MAX);
 		if (rc) {
 			cifs_dbg(VFS, "%s: invalidate inode %p failed with rc %d\n",
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index be22bbc4a65a..d88682e89ec0 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -143,7 +143,8 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 						fattr->cf_rdev = inode->i_rdev;
 						fattr->cf_uid = inode->i_uid;
 						fattr->cf_gid = inode->i_gid;
-						fattr->cf_eof = CIFS_I(inode)->netfs.remote_i_size;
+						fattr->cf_eof =
+							netfs_read_remote_i_size(&CIFS_I(inode)->netfs);
 						fattr->cf_symlink_target = NULL;
 					} else {
 						CIFS_I(inode)->time = 0;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7f346ee50289..98638ac17b7b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3404,7 +3404,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	filemap_invalidate_lock(inode->i_mapping);
 
 	i_size = i_size_read(inode);
-	remote_size = ictx->remote_i_size;
+	remote_size = netfs_read_remote_i_size(ictx);
 	if (offset + len >= remote_size && offset < i_size) {
 		unsigned long long top = umin(offset + len, i_size);
 
@@ -3439,8 +3439,8 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 		if (rc >= 0) {
 			truncate_setsize(inode, new_size);
 			netfs_resize_file(&cifsi->netfs, new_size, true);
-			if (offset < cifsi->netfs.zero_point)
-				cifsi->netfs.zero_point = offset;
+			if (offset < netfs_read_zero_point(&cifsi->netfs))
+				netfs_write_zero_point(&cifsi->netfs, offset);
 			fscache_resize_cookie(cifs_inode_cookie(inode), new_size);
 		}
 	}
@@ -3506,13 +3506,13 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	 * EOF update will end up in the wrong place.
 	 */
 	i_size = i_size_read(inode);
-	remote_i_size = netfs_inode(inode)->remote_i_size;
+	remote_i_size = netfs_read_remote_i_size(netfs_inode(inode));
 	if (end > remote_i_size && i_size > remote_i_size) {
 		unsigned long long extend_to = umin(end, i_size);
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, extend_to);
 		if (rc >= 0)
-			netfs_inode(inode)->remote_i_size = extend_to;
+			netfs_write_remote_i_size(netfs_inode(inode), extend_to);
 	}
 
 unlock:
@@ -3794,7 +3794,7 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 		goto out_2;
 
 	truncate_pagecache_range(inode, off, old_eof);
-	ictx->zero_point = old_eof;
+	netfs_write_zero_point(ictx, old_eof);
 	netfs_wait_for_outstanding_io(inode);
 
 	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
@@ -3812,7 +3812,7 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 
 	truncate_setsize(inode, new_eof);
 	netfs_resize_file(&cifsi->netfs, new_eof, true);
-	ictx->zero_point = new_eof;
+	netfs_write_zero_point(ictx, new_eof);
 	fscache_resize_cookie(cifs_inode_cookie(inode), new_eof);
 out_2:
 	filemap_invalidate_unlock(inode->i_mapping);
@@ -3861,7 +3861,7 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	rc = smb2_copychunk_range(xid, cfile, cfile, off, count, off + len);
 	if (rc < 0)
 		goto out_2;
-	cifsi->netfs.zero_point = new_eof;
+	netfs_write_zero_point(&cifsi->netfs, new_eof);
 
 	rc = smb3_zero_data(file, tcon, off, len, xid);
 	if (rc < 0)
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index cb61051f9af3..368472589fe6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4708,7 +4708,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	} else {
 		size_t trans = rdata->subreq.transferred + rdata->got_bytes;
 		if (trans < rdata->subreq.len &&
-		    rdata->subreq.start + trans >= ictx->remote_i_size) {
+		    rdata->subreq.start + trans >= netfs_read_remote_i_size(ictx)) {
 			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 			rdata->result = 0;
 		}
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 62a528f90666..6896d8c160ec 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -62,8 +62,8 @@ struct netfs_inode {
 	struct fscache_cookie	*cache;
 #endif
 	struct mutex		wb_lock;	/* Writeback serialisation */
-	loff_t			remote_i_size;	/* Size of the remote file */
-	loff_t			zero_point;	/* Size after which we assume there's no data
+	loff_t			_remote_i_size;	/* Size of the remote file */
+	loff_t			_zero_point;	/* Size after which we assume there's no data
 						 * on the server */
 	atomic_t		io_count;	/* Number of outstanding reqs */
 	unsigned long		flags;
@@ -474,6 +474,257 @@ static inline struct netfs_inode *netfs_inode(struct inode *inode)
 	return container_of(inode, struct netfs_inode, inode);
 }
 
+/**
+ * netfs_read_remote_i_size - Read remote_i_size safely
+ * @ictx: The inode context to access
+ *
+ * Read remote_i_size safely without the potential for tearing on 32-bit
+ * arches.
+ *
+ * NOTE: in a 32bit arch with a preemptable kernel and an UP compile the
+ * i_size_read/write must be atomic with respect to the local cpu (unlike with
+ * preempt disabled), but they don't need to be atomic with respect to other
+ * cpus like in true SMP (so they need either to either locally disable irq
+ * around the read or for example on x86 they can be still implemented as a
+ * cmpxchg8b without the need of the lock prefix).  For SMP compiles and 64bit
+ * archs it makes no difference if preempt is enabled or not.
+ */
+static inline unsigned long long netfs_read_remote_i_size(const struct netfs_inode *ictx)
+{
+	unsigned long long remote_i_size;
+
+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	const struct inode *inode = &ictx->inode;
+	unsigned int seq;
+
+	do {
+		seq = read_seqcount_begin(&inode->i_size_seqcount);
+		remote_i_size = ictx->_remote_i_size;
+	} while (read_seqcount_retry(&inode->i_size_seqcount, seq));
+#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
+	preempt_disable();
+	remote_i_size = ictx->_remote_i_size;
+	preempt_enable();
+#else
+	/* Pairs with smp_store_release() in netfs_write_remote_i_size() */
+	remote_i_size = smp_load_acquire(&ictx->_remote_i_size);
+#endif
+	return remote_i_size;
+}
+
+/*
+ * netfs_write_remote_i_size - Set remote_i_size safely
+ * @ictx: The inode context to access
+ * @remote_i_size: The new value for the size of the file on the server
+ *
+ * Set remote_i_size safely without the potential for tearing on 32-bit arches.
+ *
+ * NOTE: unlike netfs_read_remote_i_size(), netfs_write_remote_i_size() does
+ * need locking around it (normally i_rwsem), otherwise on 32bit/SMP an update
+ * of i_size_seqcount can be lost, resulting in subsequent i_size_read() calls
+ * spinning forever.
+ */
+static inline void netfs_write_remote_i_size(struct netfs_inode *ictx,
+					     unsigned long long remote_i_size)
+{
+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	struct inode *inode = &ictx->inode;
+
+	preempt_disable();
+	write_seqcount_begin(&inode->i_size_seqcount);
+	ictx->_remote_i_size = remote_i_size;
+	write_seqcount_end(&inode->i_size_seqcount);
+	preempt_enable();
+#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
+	preempt_disable();
+	ictx->_remote_i_size = remote_i_size;
+	preempt_enable();
+#else
+	/*
+	 * Pairs with smp_load_acquire() in netfs_read_remote_i_size() to
+	 * ensure changes related to inode size (such as page contents) are
+	 * visible before we see the changed inode size.
+	 */
+	smp_store_release(&ictx->_remote_i_size, remote_i_size);
+#endif
+}
+
+/**
+ * netfs_read_zero_point - Read zero_point safely
+ * @ictx: The inode context to access
+ *
+ * Read zero_point safely without the potential for tearing on 32-bit
+ * arches.
+ *
+ * NOTE: in a 32bit arch with a preemptable kernel and an UP compile the
+ * i_size_read/write must be atomic with respect to the local cpu (unlike with
+ * preempt disabled), but they don't need to be atomic with respect to other
+ * cpus like in true SMP (so they need either to either locally disable irq
+ * around the read or for example on x86 they can be still implemented as a
+ * cmpxchg8b without the need of the lock prefix).  For SMP compiles and 64bit
+ * archs it makes no difference if preempt is enabled or not.
+ */
+static inline unsigned long long netfs_read_zero_point(const struct netfs_inode *ictx)
+{
+	unsigned long long zero_point;
+
+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	const struct inode *inode = &ictx->inode;
+	unsigned int seq;
+
+	do {
+		seq = read_seqcount_begin(&inode->i_size_seqcount);
+		zero_point = ictx->_zero_point;
+	} while (read_seqcount_retry(&inode->i_size_seqcount, seq));
+#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
+	preempt_disable();
+	zero_point = ictx->_zero_point;
+	preempt_enable();
+#else
+	/* Pairs with smp_store_release() in netfs_write_zero_point() */
+	zero_point = smp_load_acquire(&ictx->_zero_point);
+#endif
+	return zero_point;
+}
+
+/*
+ * netfs_write_zero_point - Set zero_point safely
+ * @ictx: The inode context to access
+ * @zero_point: The new value for the point beyond which the server has no data
+ *
+ * Set zero_point safely without the potential for tearing on 32-bit arches.
+ *
+ * NOTE: unlike netfs_read_zero_point(), netfs_write_zero_point() does need
+ * locking around it (normally i_rwsem), otherwise on 32bit/SMP an update of
+ * i_size_seqcount can be lost, resulting in subsequent read calls spinning
+ * forever.
+ */
+static inline void netfs_write_zero_point(struct netfs_inode *ictx,
+					  unsigned long long zero_point)
+{
+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	struct inode *inode = &ictx->inode;
+
+	preempt_disable();
+	write_seqcount_begin(&inode->i_size_seqcount);
+	ictx->_zero_point = zero_point;
+	write_seqcount_end(&inode->i_size_seqcount);
+	preempt_enable();
+#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
+	preempt_disable();
+	ictx->_zero_point = zero_point;
+	preempt_enable();
+#else
+	/*
+	 * Pairs with smp_load_acquire() in netfs_read_zero_point() to
+	 * ensure changes related to inode size (such as page contents) are
+	 * visible before we see the changed inode size.
+	 */
+	smp_store_release(&ictx->_zero_point, zero_point);
+#endif
+}
+
+/**
+ * netfs_push_back_zero_point - Push back the zero point if unknown data now beyond it
+ * ictx: The inode context to access
+ * to: The end of a new region of unknown data
+ *
+ * Move back the zero_point if we cause a region of unknown data to appear
+ * beyond it (such as doing a copy_file_range).
+ */
+static inline void netfs_push_back_zero_point(struct netfs_inode *ictx,
+					      unsigned long long to)
+{
+	if (to > netfs_read_zero_point(ictx))
+		netfs_write_zero_point(ictx, to);
+}
+
+/**
+ * netfs_read_sizes - Read remote_i_size and zero_point safely
+ * @ictx: The inode context to access
+ * @remote_i_size: Where to return the size of the file on the server
+ * @zero_point: Where to return the the point beyond which the server has no data
+ *
+ * Read remote_i_size and zero_point safely without the potential for tearing
+ * on 32-bit arches.
+ *
+ * NOTE: in a 32bit arch with a preemptable kernel and an UP compile the
+ * i_size_read/write must be atomic with respect to the local cpu (unlike with
+ * preempt disabled), but they don't need to be atomic with respect to other
+ * cpus like in true SMP (so they need either to either locally disable irq
+ * around the read or for example on x86 they can be still implemented as a
+ * cmpxchg8b without the need of the lock prefix).  For SMP compiles and 64bit
+ * archs it makes no difference if preempt is enabled or not.
+ */
+static inline void netfs_read_sizes(const struct netfs_inode *ictx,
+				    unsigned long long *remote_i_size,
+				    unsigned long long *zero_point)
+{
+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	const struct inode *inode = &ictx->inode;
+	unsigned int seq;
+
+	do {
+		seq = read_seqcount_begin(&inode->i_size_seqcount);
+		*remote_i_size = ictx->_remote_i_size;
+		*zero_point = ictx->_zero_point;
+	} while (read_seqcount_retry(&inode->i_size_seqcount, seq));
+#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
+	preempt_disable();
+	*remote_i_size = ictx->_remote_i_size;
+	*zero_point = ictx->_zero_point;
+	preempt_enable();
+#else
+	/* Pairs with smp_store_release() in netfs_write_zero_point() */
+	*remote_i_size = smp_load_acquire(&ictx->_remote_i_size);
+	*zero_point = smp_load_acquire(&ictx->_zero_point);
+#endif
+}
+
+/*
+ * netfs_write_sizes - Set remote_i_size and zero_point safely
+ * @ictx: The inode context to access
+ * @remote_i_size: The new value for the size of the file on the server
+ * @zero_point: The new value for the point beyond which the server has no data
+ *
+ * Set both remote_i_size and zero_point safely without the potential for
+ * tearing on 32-bit arches.
+ *
+ * NOTE: unlike netfs_read_zero_point(), netfs_write_zero_point() does need
+ * locking around it (normally i_rwsem), otherwise on 32bit/SMP an update of
+ * i_size_seqcount can be lost, resulting in subsequent read calls spinning
+ * forever.
+ */
+static inline void netfs_write_sizes(struct netfs_inode *ictx,
+				     unsigned long long remote_i_size,
+				     unsigned long long zero_point)
+{
+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	struct inode *inode = &ictx->inode;
+
+	preempt_disable();
+	write_seqcount_begin(&inode->i_size_seqcount);
+	ictx->_remote_i_size = remote_i_size;
+	ictx->_zero_point = zero_point;
+	write_seqcount_end(&inode->i_size_seqcount);
+	preempt_enable();
+#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
+	preempt_disable();
+	ictx->_remote_i_size = remote_i_size;
+	ictx->_zero_point = zero_point;
+	preempt_enable();
+#else
+	/*
+	 * Pairs with smp_load_acquire() in netfs_read_remote_i_size and
+	 * netfs_read_zero_point() to ensure changes related to inode size
+	 * (such as page contents) are visible before we see the changed inode
+	 * size.
+	 */
+	smp_store_release(&ictx->_remote_i_size, remote_i_size);
+	smp_store_release(&ictx->_zero_point, zero_point);
+#endif
+}
+
 /**
  * netfs_inode_init - Initialise a netfslib inode context
  * @ctx: The netfs inode to initialise
@@ -488,8 +739,8 @@ static inline void netfs_inode_init(struct netfs_inode *ctx,
 				    bool use_zero_point)
 {
 	ctx->ops = ops;
-	ctx->remote_i_size = i_size_read(&ctx->inode);
-	ctx->zero_point = LLONG_MAX;
+	ctx->_remote_i_size = i_size_read(&ctx->inode);
+	ctx->_zero_point = LLONG_MAX;
 	ctx->flags = 0;
 	atomic_set(&ctx->io_count, 0);
 #if IS_ENABLED(CONFIG_FSCACHE)
@@ -498,7 +749,7 @@ static inline void netfs_inode_init(struct netfs_inode *ctx,
 	mutex_init(&ctx->wb_lock);
 	/* ->releasepage() drives zero_point */
 	if (use_zero_point) {
-		ctx->zero_point = ctx->remote_i_size;
+		ctx->_zero_point = ctx->_remote_i_size;
 		mapping_set_release_always(ctx->inode.i_mapping);
 	}
 }
@@ -511,13 +762,40 @@ static inline void netfs_inode_init(struct netfs_inode *ctx,
  *
  * Inform the netfs lib that a file got resized so that it can adjust its state.
  */
-static inline void netfs_resize_file(struct netfs_inode *ctx, loff_t new_i_size,
+static inline void netfs_resize_file(struct netfs_inode *ictx,
+				     unsigned long long new_i_size,
 				     bool changed_on_server)
 {
+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	struct inode *inode = &ictx->inode;
+
+	preempt_disable();
+	write_seqcount_begin(&inode->i_size_seqcount);
+	if (changed_on_server)
+		ictx->_remote_i_size = new_i_size;
+	if (new_i_size < ictx->_zero_point)
+		ictx->_zero_point = new_i_size;
+	write_seqcount_end(&inode->i_size_seqcount);
+	preempt_enable();
+#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
+	preempt_disable();
 	if (changed_on_server)
-		ctx->remote_i_size = new_i_size;
-	if (new_i_size < ctx->zero_point)
-		ctx->zero_point = new_i_size;
+		ictx->_remote_i_size = new_i_size;
+	if (new_i_size < ictx->_zero_point)
+		ictx->_zero_point = new_i_size;
+	preempt_enable();
+#else
+	/*
+	 * Pairs with smp_load_acquire() in netfs_read_remote_i_size and
+	 * netfs_read_zero_point() to ensure changes related to inode size
+	 * (such as page contents) are visible before we see the changed inode
+	 * size.
+	 */
+	if (changed_on_server)
+		smp_store_release(&ictx->_remote_i_size, new_i_size);
+	if (new_i_size < ictx->_zero_point)
+		smp_store_release(&ictx->_zero_point, new_i_size);
+#endif
 }
 
 /**

