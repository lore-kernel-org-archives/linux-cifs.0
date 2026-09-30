Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D07194C96;
	Wed, 30 Sep 2026 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728764; cv=none; b=Y0vMRTv+A5rQ+imvQxQnLGfOEpKQZ2RkMvOzkBibGMuW5M7h4Trovt2i5aXFNIypXoQ7TO7bhgd9Y5UCuGnlAUuHtqaszTdBn86Eeg+A4HK+BejsZ/YYovGXuKN7hBUC+BoLmgt9ET+DSU4lNy+S/l37XEMuCZRflDiygZmnlQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728764; c=relaxed/simple;
	bh=mdGc48Y9zpyB0M2b1z83G7yZ2RN9fKGO5JdwbkY8nHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rpayb3zGjRLXzBfBaJXL+kstJKHwMUkZP2fCswsj5Pm5vmBecYl04Fbpevy51YUBtAqc32QXW92OgmHok1YRUCXPd91c58yP9bI06zkfVSK0shkKlXzVu0REbw7Jp444F2/PUiZgEbd6u5jtF3+1BRv9ghbQhT/1OPgVA4CjaSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Hogklheu; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Hogklheu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=DXMHEDcgiej1uNIYyLqLgR3j/aO04v/jwi2HhehxI9I=; b=Hogklheu7ump2OeEIauhLvVb8r
	rO764tdGEW5EIje+cdXKu1biyKr5ZtCz3suucpudHjP7tnL7DvUOPbxXRA8vQsYPciq83GdEe7JFa
	RAqy9efVGnGGKH9C2w+RczNbki52mXv3aLYDGngHC+wKVibSL/WLJMAqwrEMjfcqR9MECnWXI5O28
	MTOcPpn88cIFY+7nN850RWz6Xf8+jUcvRXesLNjt0A8VojyOKStuYUVrOPptWZaIkeNXbbMowZBOQ
	kpo0oym77NzbCJy8PcvzSzTI/aBbJzkVq526WzGdoMddWnylaMOw8YGcdwTlBpkHatMNcfNdn6+Lz
	QEqp0apg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBiLl-00000002aDJ-1zaG;
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
Subject: [PATCH v2 01/15] netfs: clear post-EOF pagecache when extending a file via write
Date: Tue, 29 Sep 2026 21:38:54 -0300
Message-ID: <20260930003908.1703770-2-pc@manguebit.org>
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

Fix netfs to erase the contents of a hole created after the EOF by an
ordinary write if dirty data has been previously left there by writes
through an mmapped region.  Neither the buffered nor the unbuffered/DIO
write path clears that stale pagecache.

Zero the tail of the folio straddling the EOF before an extending
write.  That is the only folio that can hold data written past the EOF
through an mmap, as pages wholly beyond the EOF can't be faulted in.
The folio is zeroed rather than dropped so a concurrent extending write
can't lose data.

Both write paths downgrade the i_rwsem to shared, so extending writes
can run concurrently and the i_size read by the caller may be stale by
the time the folio is locked.  Re-read i_size under the folio lock and
clamp the zeroed range up to it, so a racing write that already put
data into the folio isn't clobbered.

Wait for any writeback on the folio to finish before zeroing it so that
the pagecache isn't modified while it may still be read by the transport
during transmission.  Honour IOCB_NOWAIT by returning -EAGAIN rather
than blocking on the folio lock, on writeback, or in folio_mkclean()'s
rmap walk when the folio is mapped.

truncate_pagecache() can't be used here: it must be called with the
i_rwsem held exclusively, but these write paths only hold it shared,
and it would block unconditionally, breaking IOCB_NOWAIT.

Callers that hold i_rwsem exclusively for the whole resize (truncate,
setattr, fallocate, clone) exclude any genuine concurrent buffered
writer, so staleness can instead be decided from the folio's dirty
state, as pagecache_isize_extended() already does for filesystems that
serialise writes against truncate/setattr via a single i_rwsem.
Export netfs_clear_stale_post_isize() helper to handle such case.

The helper is required by the CIFS client to fix generic/363.

Closes: https://sashiko.dev/#/patchset/20260921230755.1133425-1-pc%40manguebit.org
Fixes: 938e13a73b24 ("netfs: Implement buffered write API")
Fixes: 153a9961b551 ("netfs: Implement unbuffered/DIO write support")
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
 Documentation/filesystems/netfs_library.rst | 26 ++++++
 fs/netfs/buffered_write.c                   |  9 ++
 fs/netfs/direct_write.c                     |  9 ++
 fs/netfs/internal.h                         |  2 +
 fs/netfs/misc.c                             | 99 +++++++++++++++++++++
 include/linux/netfs.h                       |  2 +
 6 files changed, 147 insertions(+)

diff --git a/Documentation/filesystems/netfs_library.rst b/Documentation/filesystems/netfs_library.rst
index ddd799df6ce3..a9de281db8ee 100644
--- a/Documentation/filesystems/netfs_library.rst
+++ b/Documentation/filesystems/netfs_library.rst
@@ -451,6 +451,32 @@ one.
 The inode should be marked ``NETFS_ICTX_SINGLE_NO_UPLOAD`` if this API is to be
 used.  The writeback function requires the buffer to be of ITER_FOLIOQ type.
 
+Clearing Stale Post-EOF Pagecache
+---------------------------------
+
+When a file is extended, data left in the pagecache past the old EOF by a write
+through an mmap must not be exposed as file content.  Netfslib clears this on
+its own write paths, and exports a helper so a filesystem can do the same from
+a resize path (truncate, setattr, fallocate and the like) that holds the
+inode's ``i_rwsem`` exclusively across the whole resize::
+
+	void netfs_clear_stale_post_isize(struct inode *inode, uoff_t from,
+					  uoff_t to);
+
+This zeroes any such data within the ``[from, to)`` hole to be made, where
+@from is the old EOF and @to is the new one, and the caller must have already
+updated ``i_size`` to @to before calling it.  Only the folio straddling @from
+can hold data written past the EOF through an mmap, as pages wholly beyond the
+EOF can't be faulted in, so the zeroing is limited to that folio.  The folio is
+zeroed rather than dropped so that a concurrent extending write can't lose
+data.
+
+This overlaps with ``pagecache_isize_extended()`` but can't reuse it: that
+helper is keyed on a sub-page block size and is a no-op when the block size is
+``>= PAGE_SIZE`` (as on network filesystems), and it doesn't wait for
+writeback.  As both address the same problem, a change to one should probably
+be reflected in the other to keep them in sync.
+
 High-Level VM API
 ==================
 
diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 2cdb68e6b16f..ecf119b4f916 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -469,6 +469,7 @@ ssize_t netfs_buffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *fr
 					 struct netfs_group *netfs_group)
 {
 	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
 	ssize_t ret;
 
 	trace_netfs_write_iter(iocb, from);
@@ -481,6 +482,14 @@ ssize_t netfs_buffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *fr
 	if (ret)
 		return ret;
 
+	if (iocb->ki_pos > i_size_read(inode)) {
+		ret = netfs_clear_stale_pre_isize(inode, i_size_read(inode),
+						  iocb->ki_pos,
+						  iocb->ki_flags & IOCB_NOWAIT);
+		if (ret)
+			return ret;
+	}
+
 	return netfs_perform_write(iocb, from, netfs_group);
 }
 EXPORT_SYMBOL(netfs_buffered_write_iter_locked);
diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index 2361277416c7..8be74706d85e 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -359,6 +359,15 @@ ssize_t netfs_unbuffered_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ret = file_update_time(file);
 	if (ret < 0)
 		goto out;
+
+	if (iocb->ki_pos > i_size_read(inode)) {
+		ret = netfs_clear_stale_pre_isize(inode, i_size_read(inode),
+						  iocb->ki_pos,
+						  iocb->ki_flags & IOCB_NOWAIT);
+		if (ret < 0)
+			goto out;
+	}
+
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		/* We could block if there are any pages in the range. */
 		ret = -EAGAIN;
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index c79c8e69d60c..786af76da98c 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -80,6 +80,8 @@ ssize_t netfs_wait_for_write(struct netfs_io_request *rreq);
 void netfs_wait_for_paused_read(struct netfs_io_request *rreq);
 void netfs_wait_for_paused_write(struct netfs_io_request *rreq);
 void netfs_wait_for_put_ra_refs(struct netfs_io_request *rreq);
+int netfs_clear_stale_pre_isize(struct inode *inode, uoff_t from,
+				uoff_t to, bool nowait);
 
 /*
  * objects.c
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index f5c1c463f4ff..523057390d6f 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/swap.h>
+#include <linux/rmap.h>
 #include "internal.h"
 
 /**
@@ -582,3 +583,101 @@ void netfs_wait_for_put_ra_refs(struct netfs_io_request *rreq)
 	trace_netfs_rreq(rreq, netfs_rreq_trace_waited_put_ra_refs);
 	finish_wait(&rreq->waitq, &myself);
 }
+
+/**
+ * netfs_clear_stale_isize - Clear stale pagecache in a to-be-created hole
+ * @inode: The inode to act upon.
+ * @from: The base of the hole to be made.
+ * @to: The top of the hole to be made.
+ * @nowait: True to return -EAGAIN rather than block.
+ * @exclusive: True if the caller holds i_rwsem exclusively for the resize.
+ *
+ * Zero any data left in the pagecache within the [@from, @to) hole by a
+ * write through an mmap so that it isn't exposed as file content once the
+ * file is extended.  Only the uptodate folio straddling @from can hold such
+ * data as pages wholly beyond the EOF can't be faulted in, so the zeroing
+ * is limited to that folio.  The folio is zeroed rather than dropped so
+ * that a concurrent extending write can't lose data.
+ *
+ * If @exclusive is false, @from is re-read from i_size and used to clamp
+ * the zeroed range, for callers that may race with another writer also
+ * extending the file (eg. multiple buffered writes extending the same file
+ * under a shared i_rwsem).  If @exclusive is true, for callers that hold
+ * i_rwsem exclusively across the whole resize and have already updated
+ * i_size to @to, staleness is decided from the folio's dirty state instead:
+ * since no genuine concurrent buffered writer can be racing, a lockless
+ * stat() adopting a server-confirmed size mid-resize has no data behind it
+ * and never dirties the folio, so it can't fool this check into skipping
+ * the zeroing the way it could fool the @exclusive false clamp.
+ *
+ * pagecache_isize_extended() can't be reused here: it is keyed on a
+ * sub-page block size (a no-op when the block size is >= PAGE_SIZE, as on
+ * network filesystems), runs after i_size is updated, can't honour
+ * @nowait, and doesn't wait for writeback.  Keep the two in sync if either
+ * is changed.
+ *
+ * Return: 0 on success, or -EAGAIN if @nowait is set and the folio is
+ * mapped or under writeback and so can't be cleaned without blocking.
+ */
+static int netfs_clear_stale_isize(struct inode *inode, uoff_t from,
+				   uoff_t to, bool nowait, bool exclusive)
+{
+	struct address_space *mapping = inode->i_mapping;
+	fgf_t fgp = FGP_LOCK;
+	struct folio *folio;
+	int ret;
+
+	if (from >= to)
+		return 0;
+
+	if (nowait)
+		fgp |= FGP_NOWAIT;
+
+	folio = __filemap_get_folio(mapping, from >> PAGE_SHIFT, fgp, 0);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio) == -EAGAIN ? -EAGAIN : 0;
+
+	ret = 0;
+	if (nowait && (folio_mapped(folio) || folio_test_writeback(folio))) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	folio_wait_writeback(folio);
+
+	if (folio_mkclean(folio))
+		folio_mark_dirty(folio);
+
+	if (folio_test_uptodate(folio) &&
+	    (!exclusive || folio_test_dirty(folio))) {
+		uoff_t fpos = folio_pos(folio);
+
+		if (!exclusive)
+			from = umax(from, i_size_read(inode));
+		if (from < to && from < fpos + folio_size(folio)) {
+			size_t end = umin(to - fpos, folio_size(folio));
+			size_t offset = from - fpos;
+
+			folio_zero_segment(folio, offset, end);
+		}
+	}
+out:
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+}
+
+/* Clear stale pagecache before an extending buffered/DIO write. */
+int netfs_clear_stale_pre_isize(struct inode *inode, uoff_t from,
+				uoff_t to, bool nowait)
+{
+	return netfs_clear_stale_isize(inode, from, to, nowait, false);
+}
+
+/* Clear stale pagecache when extending a file under an exclusive resize. */
+void netfs_clear_stale_post_isize(struct inode *inode, uoff_t from,
+				  uoff_t to)
+{
+	netfs_clear_stale_isize(inode, from, to, false, true);
+}
+EXPORT_SYMBOL(netfs_clear_stale_post_isize);
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index b4dd32863dd4..fe6275e55fc2 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -397,6 +397,8 @@ ssize_t netfs_unbuffered_write_iter(struct kiocb *iocb, struct iov_iter *from);
 ssize_t netfs_unbuffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *iter,
 					   struct netfs_group *netfs_group);
 ssize_t netfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from);
+void netfs_clear_stale_post_isize(struct inode *inode, uoff_t from,
+				  uoff_t to);
 
 /* Single, monolithic object read/write API. */
 void netfs_single_mark_inode_dirty(struct inode *inode);
-- 
2.55.0

