Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2724B3F7A83;
	Mon, 21 Sep 2026 23:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032084; cv=none; b=F4aKLjDdOlH6+3zM6aCzvdA+JMhZJZKkI4+d7ub1GpCjK830SvnV1/Sx3tiAJSPp8gg2CGrNIOtPESbAYgeRox2brZOxFLZ7N23lzaNZZUwQMmU8BAKmuCqlMVuxTvIwRJllyB5U5AYs1uKRfSsXRZmDLoXyWFqwooGSLWKBdGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032084; c=relaxed/simple;
	bh=3E2czqa1IIrMULAPsMjpN93QZhoXZsuN7RXrjIvPSMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LetkiRrtqiaFWqvfdzwJdwVhwF9gYeqt9XAs6OBkvYGNT3ybeU5G+AYSYrOcqZk4yg8mtOeDWj6Nh661/dXgW5qLpi5FiaZCkNBsmJNR6CxYa7CYVv+zyeKfbjMrRl1xZnIhRx8dNzkK3QRzDPg0vf4tXq+YXrA9xG8rD/kY4Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=5aS0v+Op; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="5aS0v+Op"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=pPsqk4ON7+2tH0/DPwQsP8pQslk6kIx+ftH09NyJLkE=; b=5aS0v+Op40GMC6oUbYD6/bf1ht
	VAxao8wMu5R5LHghlkBbS9VT4CbnQLyqmQuyUTD0R2PvVpgCxqhwtpt36QKPG7UjA+CLqA8oqbpsj
	jC5Gewx0FLEj5ywxiogdF7upQipO3DV5lnTzSTCBCs6r/fM66NUZwyC2gBsSljGFHApqpjnQFiaI3
	Zw2uy2wwdKyXlXztIzi0dV7fHlK8kk6PmjWqGZ5HssCUr22zyDgPeFKXKol1iCSp5jRWsK0oYxWiX
	XRTIWo67aYYH5cI3Mcz94o6Rp+z77vH32a2h5XV+BMJ2oOBM3WhgLXAwgwCs3pEHjRvCsb8Q2TeaI
	aT39bNsg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x8n76-00000001xox-1XOz;
	Mon, 21 Sep 2026 20:07:56 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/5] netfs: clear post-EOF pagecache when extending a file via write
Date: Mon, 21 Sep 2026 20:07:51 -0300
Message-ID: <20260921230755.1133425-1-pc@manguebit.org>
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

truncate_pagecache() can't be used here: it must be called with the
i_rwsem held exclusively, but these write paths only hold it shared,
and it would block unconditionally, breaking IOCB_NOWAIT.

Export the helper so filesystems can clear the same stale data from
their own truncate paths.

Closes: https://sashiko.dev/#/patchset/20260921154957.903891-1-pc%40manguebit.org
Fixes: 938e13a73b24 ("netfs: Implement buffered write API")
Fixes: 153a9961b551 ("netfs: Implement unbuffered/DIO write support")
Reviewed-by: David Howells <dhowells@redhat.com>
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
 Documentation/filesystems/netfs_library.rst | 18 ++++++++
 fs/netfs/buffered_write.c                   |  9 ++++
 fs/netfs/direct_write.c                     |  9 ++++
 fs/netfs/misc.c                             | 51 +++++++++++++++++++++
 include/linux/netfs.h                       |  2 +
 5 files changed, 89 insertions(+)

diff --git a/Documentation/filesystems/netfs_library.rst b/Documentation/filesystems/netfs_library.rst
index ddd799df6ce3..58b0adacc2f3 100644
--- a/Documentation/filesystems/netfs_library.rst
+++ b/Documentation/filesystems/netfs_library.rst
@@ -451,6 +451,24 @@ one.
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
+	int netfs_clear_stale_post_eof(struct inode *inode, unsigned long long from,
+				       unsigned long long to, bool nowait);
+
+This zeroes any such data within the ``[from, to)`` hole to be made, where @from
+is the current EOF.  Only the folio straddling @from can hold data written past
+the EOF through an mmap, as pages wholly beyond the EOF can't be faulted in, so
+the zeroing is limited to that folio and clamped to the top of the hole.  The
+folio is zeroed rather than dropped so that a concurrent extending write can't
+lose data.  If @nowait is set, it returns ``-EAGAIN`` rather than blocking.
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
index f5c1c463f4ff..b9ca24b3dfda 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/swap.h>
+#include <linux/rmap.h>
 #include "internal.h"
 
 /**
@@ -582,3 +583,53 @@ void netfs_wait_for_put_ra_refs(struct netfs_io_request *rreq)
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
+ * that a concurrent extending write can't lose data.
+ *
+ * Return: 0 on success, or -EAGAIN if @nowait is set and the folio would need
+ * to be waited on.
+ */
+int netfs_clear_stale_post_eof(struct inode *inode, unsigned long long from,
+			       unsigned long long to, bool nowait)
+{
+	struct address_space *mapping = inode->i_mapping;
+	fgf_t fgp = FGP_LOCK;
+	struct folio *folio;
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
+	if (folio_mkclean(folio))
+		folio_mark_dirty(folio);
+
+	if (folio_test_uptodate(folio)) {
+		size_t end = umin(to - folio_pos(folio), folio_size(folio));
+		size_t offset = offset_in_folio(folio, from);
+
+		folio_zero_segment(folio, offset, end);
+	}
+
+	folio_unlock(folio);
+	folio_put(folio);
+	return 0;
+}
+EXPORT_SYMBOL(netfs_clear_stale_post_eof);
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index b4dd32863dd4..2981290b9a77 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -397,6 +397,8 @@ ssize_t netfs_unbuffered_write_iter(struct kiocb *iocb, struct iov_iter *from);
 ssize_t netfs_unbuffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *iter,
 					   struct netfs_group *netfs_group);
 ssize_t netfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from);
+int netfs_clear_stale_post_eof(struct inode *inode, unsigned long long from,
+			       unsigned long long to, bool nowait);
 
 /* Single, monolithic object read/write API. */
 void netfs_single_mark_inode_dirty(struct inode *inode);
-- 
2.55.0

