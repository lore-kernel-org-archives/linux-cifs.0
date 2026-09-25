Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2184B128D;
	Fri, 25 Sep 2026 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347062; cv=none; b=JSOsz2BkVrBWxYLH8WMOFWNKmIhPe+vhcMIEu2kw+OQjR4/7qg2GB7gzLG0VW3T/81gk6LkSM2Lk26FToBiNfozC841JbjxGDiyadvHLb9ax+Z6/pO95JPz2s4fB01axL9JQf2sueAi8amhIZbf4yKrDE++YlzDa7GwnnLVWQjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347062; c=relaxed/simple;
	bh=ZAEkSP68XwElgLNNx1oNEAhNsUF0EbKgiLkhPoWugek=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GvVbTL7bzYNfyGyq4AZ52MPKl4waTJd16f1kakQpE8IJfLWa2/Y81oWK/QcAcQkD5ajy7aEmk4qusJWjsa9SLkjQ4QdOkufV99FXORXiVrcE1byShNnzZXqB6rG1xIP1fS4y6+1gMXAEl3BS8DzUHoVNFTDWPtPJ+vJv9BbiXLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Pj9riksj; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Pj9riksj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=/7f2QYQHZzdOYM2nxGXZc0zTiz68a4AMqeLAuSztYIU=; b=Pj9riksjvUru5PBqnhQx479Glb
	sKy54N8A+ZCh5gpXE534o8t0g5ZADEpBh1WOJoLFCaKbV/8f5lH8pN1lozF5oKH6WisQ7Eeb6udGd
	gJkhBArlLMlL5oMDAw2Q0dOH4ncwlbBpYW0FPo6Ma1nWYy7oeKmWhvlg0CT0+fHKSLeTCdgCQXRqN
	LsAwzXf0WX81efzAX3GFwzm+bmvmLgogzwmtV4HC0ojOapZBdU269wWTdyU69nybi0TK0BDgQ+msG
	+VpoW6KmMenN60J734HAdz/t00cppr8JErMUqPaOCX5SXrisu4h+CMwqsWpB4kvpY+I/TV0nIig/F
	eXMb6JXg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xA739-00000002GxF-2VKJ;
	Fri, 25 Sep 2026 11:37:19 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/5] netfs: clear post-EOF pagecache when extending a file via write
Date: Fri, 25 Sep 2026 11:37:15 -0300
Message-ID: <20260925143719.2889518-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
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

Export the helper so filesystems can clear the same stale data from
their own truncate paths.

This helper is required by the CIFS client to fix generic/363.

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

v1 -> v2:
- Add netfs_clear_stale_post_eof() to zero (rather than drop via
  truncate_pagecache()) the folio straddling the EOF; add Documentation.
v2 -> v3:
- Wait for writeback and honour IOCB_NOWAIT (-EAGAIN when the folio is
  mapped or under writeback); re-read i_size under the folio lock and
  clamp the zeroed range to it.
- Use uoff_t for the offset params; expand doc/kerneldoc on why
  pagecache_isize_extended() can't be reused.  Dropped Dave's R-b as the
  code changed.

 Documentation/filesystems/netfs_library.rst | 25 ++++++++
 fs/netfs/buffered_write.c                   |  9 +++
 fs/netfs/direct_write.c                     |  9 +++
 fs/netfs/misc.c                             | 71 +++++++++++++++++++++
 include/linux/netfs.h                       |  2 +
 5 files changed, 116 insertions(+)

diff --git a/Documentation/filesystems/netfs_library.rst b/Documentation/filesystems/netfs_library.rst
index ddd799df6ce3..f2f22076168c 100644
--- a/Documentation/filesystems/netfs_library.rst
+++ b/Documentation/filesystems/netfs_library.rst
@@ -451,6 +451,31 @@ one.
 The inode should be marked ``NETFS_ICTX_SINGLE_NO_UPLOAD`` if this API is to be
 used.  The writeback function requires the buffer to be of ITER_FOLIOQ type.
 
+Clearing Stale Post-EOF Pagecache
+---------------------------------
+
+When a file is extended, data left in the pagecache past the old EOF by a write
+through an mmap must not be exposed as file content.  Netfslib clears this on
+its own write paths, and exports a helper so a filesystem can do the same from,
+for instance, its truncate or fallocate paths::
+
+	int netfs_clear_stale_post_eof(struct inode *inode, uoff_t from,
+				       uoff_t to, bool nowait);
+
+This zeroes any such data within the ``[from, to)`` hole to be made, where @from
+is the current EOF.  Only the folio straddling @from can hold data written past
+the EOF through an mmap, as pages wholly beyond the EOF can't be faulted in, so
+the zeroing is limited to that folio and clamped to the top of the hole.  The
+folio is zeroed rather than dropped so that a concurrent extending write can't
+lose data.  If @nowait is set, it returns ``-EAGAIN`` rather than blocking.
+
+This overlaps with ``pagecache_isize_extended()`` but can't reuse it: that
+helper is keyed on a sub-page block size and is a no-op when the block size is
+``>= PAGE_SIZE`` (as on network filesystems), it runs after ``i_size`` has been
+updated, it can't honour a non-blocking caller, and it doesn't wait for
+writeback.  As both address the same problem, a change to one should probably be
+reflected in the other to keep them in sync.
+
 High-Level VM API
 ==================
 
diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 2cdb68e6b16f..cc0561f77bd0 100644
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
+		ret = netfs_clear_stale_post_eof(inode, i_size_read(inode),
+						 iocb->ki_pos,
+						 iocb->ki_flags & IOCB_NOWAIT);
+		if (ret)
+			return ret;
+	}
+
 	return netfs_perform_write(iocb, from, netfs_group);
 }
 EXPORT_SYMBOL(netfs_buffered_write_iter_locked);
diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index 2361277416c7..36c36bc6c9d2 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -359,6 +359,15 @@ ssize_t netfs_unbuffered_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ret = file_update_time(file);
 	if (ret < 0)
 		goto out;
+
+	if (iocb->ki_pos > i_size_read(inode)) {
+		ret = netfs_clear_stale_post_eof(inode, i_size_read(inode),
+						 iocb->ki_pos,
+						 iocb->ki_flags & IOCB_NOWAIT);
+		if (ret < 0)
+			goto out;
+	}
+
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		/* We could block if there are any pages in the range. */
 		ret = -EAGAIN;
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index f5c1c463f4ff..d93d8571c090 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/swap.h>
+#include <linux/rmap.h>
 #include "internal.h"
 
 /**
@@ -582,3 +583,73 @@ void netfs_wait_for_put_ra_refs(struct netfs_io_request *rreq)
 	trace_netfs_rreq(rreq, netfs_rreq_trace_waited_put_ra_refs);
 	finish_wait(&rreq->waitq, &myself);
 }
+
+/**
+ * netfs_clear_stale_post_eof - Clear stale pagecache in a to-be-created hole
+ * @inode: The inode to act upon.
+ * @from: The base of the hole to be made (the current EOF).
+ * @to: The top of the hole to be made.
+ * @nowait: True to return -EAGAIN rather than block.
+ *
+ * Before extending a file, zero any data left in the pagecache within the
+ * [@from, @to) hole by a write through an mmap so that it isn't exposed as file
+ * content once the file is extended.  Only the uptodate folio straddling @from
+ * can hold such data as pages wholly beyond the EOF can't be faulted in, so the
+ * zeroing is limited to that folio.  The folio is zeroed rather than dropped so
+ * that a concurrent extending write can't lose data, and the zeroed range is
+ * clamped to the current EOF so it can't clobber data written by such a write.
+ *
+ * pagecache_isize_extended() can't be reused here: it is keyed on a sub-page
+ * block size (a no-op when the block size is >= PAGE_SIZE, as on network
+ * filesystems), runs after i_size is updated, can't honour @nowait, and
+ * doesn't wait for writeback.  Keep the two in sync if either is changed.
+ *
+ * Return: 0 on success, or -EAGAIN if @nowait is set and the folio is mapped
+ * or under writeback and so can't be cleaned without blocking.
+ */
+int netfs_clear_stale_post_eof(struct inode *inode, uoff_t from,
+			       uoff_t to, bool nowait)
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
+	if (folio_test_uptodate(folio)) {
+		uoff_t fpos = folio_pos(folio);
+
+		from = umax(from, i_size_read(inode));
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
+EXPORT_SYMBOL(netfs_clear_stale_post_eof);
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index b4dd32863dd4..c7b2ac404853 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -397,6 +397,8 @@ ssize_t netfs_unbuffered_write_iter(struct kiocb *iocb, struct iov_iter *from);
 ssize_t netfs_unbuffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *iter,
 					   struct netfs_group *netfs_group);
 ssize_t netfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from);
+int netfs_clear_stale_post_eof(struct inode *inode, uoff_t from,
+			       uoff_t to, bool nowait);
 
 /* Single, monolithic object read/write API. */
 void netfs_single_mark_inode_dirty(struct inode *inode);

base-commit: e66cf1625ec4a3fe68346119f371def713fd0a4d
-- 
2.55.0

