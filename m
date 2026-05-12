Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D46939061E
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 12:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589377; cv=none; b=Eouy6sC5aWZ2Az/o/e9TBdDUUMmIng3xkY72lCsgojrVNVVuFT0uyF4LWIYfwkum+HMfoVtexE5GZ5jYFD0K8XkhszKW4pEhxUb/UlcYCQAiaYFEAAJVEoxCfptacm+RHLpBgUo9uJPGnlsmQSrHC+o6qwsKHAIyEsoiByo3C6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589377; c=relaxed/simple;
	bh=p7M15g/pqOgNeM7S9MzYcPJd9rsS/t6nLEIo139sIpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdZwwr5XODv8tzMKQQmyL1wOPy+/dwxflzv1sHx1YVXOP46Wbid4BzcjxoZg++JzUnlQD7MSip3EaFfFjDqAE0zpf58Cx/MuFeKTz8YefxDwerqTUN0NCMzeO8tQuMz1BD6BLW3ghIrTZ0c34DQM8tDT3TvIBCMZLipHw9N5XNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S7IoJuU6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S7IoJuU6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778589356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rqEzWYiIRtiBd1dMSoVp7vbDbR95NMuV0PgzLr562oQ=;
	b=S7IoJuU6fCkfzYLK2I9Xzcw3xD5wnchoLIeNdA2x3OX00bgtCpNY9jyr5KneBSjd8wR7Hz
	ehxoy8vbnn4DnUP14yDhMjUUs4bZqI+IIU5xGOP4dMVyxFKpH2VqorfVMQ+GS8NTu+piko
	o3DJoObQMd7+rYJ8r8PXt9r2X0hQmII=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-537-M2RYgA4DOEmUxAzXq3C8aw-1; Tue,
 12 May 2026 08:35:53 -0400
X-MC-Unique: M2RYgA4DOEmUxAzXq3C8aw-1
X-Mimecast-MFC-AGG-ID: M2RYgA4DOEmUxAzXq3C8aw_1778589351
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1B4218002CF;
	Tue, 12 May 2026 12:35:51 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.83])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DFE1E30001BE;
	Tue, 12 May 2026 12:35:48 +0000 (UTC)
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
Subject: [PATCH v6 21/24] netfs: Fix folio->private handling in netfs_perform_write()
Date: Tue, 12 May 2026 13:33:58 +0100
Message-ID: <20260512123404.719402-22-dhowells@redhat.com>
In-Reply-To: <20260512123404.719402-1-dhowells@redhat.com>
References: <20260512123404.719402-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Under some circumstances, netfs_perform_write() doesn't correctly
manipulate folio->private between NULL, NETFS_FOLIO_COPY_TO_CACHE, pointing
to a group and pointing to a netfs_folio struct, leading to potential
multiple attachments of private data with associated folio ref leaks and
also leaks of netfs_folio structs or netfs_group refs.

Fix this by consolidating the place at which a folio is marked uptodate in
one place and having that look at what's attached to folio->private and
decide how to clean it up and then set the new group.  Also, the content
shouldn't be flushed if group is NULL, even if a group is specified in the
netfs_group parameter, as that would be the case for a new folio.  A
filesystem should always specify netfs_group or never specify netfs_group.

The Sashiko auto-review tool noted that it was theoretically possible that
the fpos >= ctx->zero_point section might leak if it modified a streaming
write folio.  This is unlikely, but with a network filesystem, third party
changes can happen.  It also pointed out that __netfs_set_group() would
leak if called multiple times on the same folio from the "whole folio
modify section".

Fixes: 8f52de0077ba ("netfs: Reduce number of conditional branches in netfs_perform_write()")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_write.c    | 134 +++++++++++++++++++++--------------
 include/trace/events/netfs.h |   1 +
 2 files changed, 82 insertions(+), 53 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index f79fb5996540..6bde3320bcec 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -12,24 +12,6 @@
 #include <linux/slab.h>
 #include "internal.h"
 
-static void __netfs_set_group(struct folio *folio, struct netfs_group *netfs_group)
-{
-	if (netfs_group)
-		folio_attach_private(folio, netfs_get_group(netfs_group));
-}
-
-static void netfs_set_group(struct folio *folio, struct netfs_group *netfs_group)
-{
-	void *priv = folio_get_private(folio);
-
-	if (unlikely(priv != netfs_group)) {
-		if (netfs_group && (!priv || priv == NETFS_FOLIO_COPY_TO_CACHE))
-			folio_attach_private(folio, netfs_get_group(netfs_group));
-		else if (!netfs_group && priv == NETFS_FOLIO_COPY_TO_CACHE)
-			folio_detach_private(folio);
-	}
-}
-
 /*
  * Grab a folio for writing and lock it.  Attempt to allocate as large a folio
  * as possible to hold as much of the remaining length as possible in one go.
@@ -157,6 +139,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		size_t offset;	/* Offset into pagecache folio */
 		size_t part;	/* Bytes to write to folio */
 		size_t copied;	/* Bytes copied from user */
+		void *priv;
 
 		offset = pos & (max_chunk - 1);
 		part = min(max_chunk - offset, iov_iter_count(iter));
@@ -202,6 +185,25 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			goto error_folio_unlock;
 		}
 
+		finfo = netfs_folio_info(folio);
+		group = netfs_folio_group(folio);
+
+		/* If the requested group differs from the group set on the
+		 * page, then we need to flush out the folio if it has a group
+		 * set (ie. is non-NULL).  Note that COPY_TO_CACHE is a special
+		 * case, being a netfs annotation rather than an actual group.
+		 *
+		 * The filesystem isn't permitted to mix writes with groups and
+		 * writes without groups as the NULL group is used to indicate
+		 * that no group is set.
+		 */
+		if (unlikely(group != netfs_group) &&
+		    group != NETFS_FOLIO_COPY_TO_CACHE &&
+		    group) {
+			WARN_ON_ONCE(!netfs_group);
+			goto flush_content;
+		}
+
 		/* Decide how we should modify a folio.  We might be attempting
 		 * to do write-streaming, as we don't want to a local RMW cycle
 		 * if we can avoid it.  If we're doing local caching or content
@@ -209,22 +211,14 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		 * file is open readably, then we let ->read_folio() fill in
 		 * the gaps.
 		 */
-		finfo = netfs_folio_info(folio);
-		group = netfs_folio_group(folio);
-
-		if (unlikely(group != netfs_group) &&
-		    group != NETFS_FOLIO_COPY_TO_CACHE)
-			goto flush_content;
-
 		if (folio_test_uptodate(folio)) {
 			if (mapping_writably_mapped(mapping))
 				flush_dcache_folio(folio);
 			copied = copy_folio_from_iter_atomic(folio, offset, part, iter);
 			if (unlikely(copied == 0))
 				goto copy_failed;
-			netfs_set_group(folio, netfs_group);
 			trace = netfs_folio_is_uptodate;
-			goto copied;
+			goto copied_uptodate;
 		}
 
 		/* If the page is above the zero-point then we assume that the
@@ -237,24 +231,22 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (unlikely(copied == 0))
 				goto copy_failed;
 			folio_zero_segment(folio, offset + copied, flen);
-			__netfs_set_group(folio, netfs_group);
-			folio_mark_uptodate(folio);
-			trace = netfs_modify_and_clear;
-			goto copied;
+			if (finfo)
+				trace = netfs_modify_and_clear_rm_finfo;
+			else
+				trace = netfs_modify_and_clear;
+			goto mark_uptodate;
 		}
 
 		/* See if we can write a whole folio in one go. */
 		if (!maybe_trouble && offset == 0 && part >= flen) {
 			copied = copy_folio_from_iter_atomic(folio, offset, part, iter);
 			if (likely(copied == part)) {
-				if (finfo) {
+				if (finfo)
 					trace = netfs_whole_folio_modify_filled;
-					goto folio_now_filled;
-				}
-				__netfs_set_group(folio, netfs_group);
-				folio_mark_uptodate(folio);
-				trace = netfs_whole_folio_modify;
-				goto copied;
+				else
+					trace = netfs_whole_folio_modify;
+				goto mark_uptodate;
 			}
 			if (copied == 0)
 				goto copy_failed;
@@ -272,7 +264,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			finfo->dirty_len += finfo->dirty_offset;
 			if (finfo->dirty_len == flen) {
 				trace = netfs_whole_folio_modify_filled_efault;
-				goto folio_now_filled;
+				goto mark_uptodate;
 			}
 			if (copied > finfo->dirty_len)
 				finfo->dirty_len = copied;
@@ -300,11 +292,11 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			copied = copy_folio_from_iter_atomic(folio, offset, part, iter);
 			if (unlikely(copied == 0))
 				goto copy_failed;
-			netfs_set_group(folio, netfs_group);
 			trace = netfs_just_prefetch;
-			goto copied;
+			goto copied_uptodate;
 		}
 
+		/* Do a streaming write on a folio that has nothing in it yet. */
 		if (!finfo) {
 			ret = -EIO;
 			if (WARN_ON(folio_get_private(folio)))
@@ -313,10 +305,8 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (unlikely(copied == 0))
 				goto copy_failed;
 			if (offset == 0 && copied == flen) {
-				__netfs_set_group(folio, netfs_group);
-				folio_mark_uptodate(folio);
 				trace = netfs_streaming_filled_page;
-				goto copied;
+				goto mark_uptodate;
 			}
 
 			finfo = kzalloc_obj(*finfo);
@@ -345,7 +335,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			finfo->dirty_len += copied;
 			if (finfo->dirty_offset == 0 && finfo->dirty_len == flen) {
 				trace = netfs_streaming_cont_filled_page;
-				goto folio_now_filled;
+				goto mark_uptodate;
 			}
 			trace = netfs_streaming_write_cont;
 			goto copied;
@@ -361,13 +351,36 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			goto out;
 		continue;
 
-	folio_now_filled:
-		if (finfo->netfs_group)
-			folio_change_private(folio, finfo->netfs_group);
-		else
-			folio_detach_private(folio);
+		/* Mark a folio as being up to data when we've filled it
+		 * completely.  If the folio has a group attached, then it must
+		 * be the same group, otherwise we should have flushed it out
+		 * above.  We have to get rid of the netfs_folio struct if
+		 * there was one.
+		 */
+	mark_uptodate:
 		folio_mark_uptodate(folio);
-		kfree(finfo);
+
+	copied_uptodate:
+		priv = folio_get_private(folio);
+		if (likely(priv == netfs_group)) {
+			/* Already set correctly; no change required. */
+		} else if (priv == NETFS_FOLIO_COPY_TO_CACHE) {
+			if (!netfs_group)
+				folio_detach_private(folio);
+			else
+				folio_change_private(folio, netfs_get_group(netfs_group));
+		} else if (!priv) {
+			folio_attach_private(folio, netfs_get_group(netfs_group));
+		} else {
+			WARN_ON_ONCE(!finfo);
+			if (netfs_group)
+				/* finfo->netfs_group has a ref */
+				folio_change_private(folio, netfs_group);
+			else
+				folio_detach_private(folio);
+			kfree(finfo);
+		}
+
 	copied:
 		trace_netfs_folio(folio, trace);
 		flush_dcache_folio(folio);
@@ -530,6 +543,7 @@ vm_fault_t netfs_page_mkwrite(struct vm_fault *vmf, struct netfs_group *netfs_gr
 	struct inode *inode = file_inode(file);
 	struct netfs_inode *ictx = netfs_inode(inode);
 	vm_fault_t ret = VM_FAULT_NOPAGE;
+	void *priv;
 	int err;
 
 	_enter("%lx", folio->index);
@@ -550,7 +564,9 @@ vm_fault_t netfs_page_mkwrite(struct vm_fault *vmf, struct netfs_group *netfs_gr
 	}
 
 	group = netfs_folio_group(folio);
-	if (group != netfs_group && group != NETFS_FOLIO_COPY_TO_CACHE) {
+	if (group &&
+	    group != netfs_group &&
+	    group != NETFS_FOLIO_COPY_TO_CACHE) {
 		folio_unlock(folio);
 		err = filemap_fdatawrite_range(mapping,
 					       folio_pos(folio),
@@ -572,7 +588,19 @@ vm_fault_t netfs_page_mkwrite(struct vm_fault *vmf, struct netfs_group *netfs_gr
 		trace_netfs_folio(folio, netfs_folio_trace_mkwrite_plus);
 	else
 		trace_netfs_folio(folio, netfs_folio_trace_mkwrite);
-	netfs_set_group(folio, netfs_group);
+
+	priv = folio_get_private(folio);
+	if (priv != netfs_group) {
+		if (!netfs_group && priv == NETFS_FOLIO_COPY_TO_CACHE)
+			folio_detach_private(folio);
+		else if (netfs_group && priv == NETFS_FOLIO_COPY_TO_CACHE)
+			folio_change_private(folio, netfs_get_group(netfs_group));
+		else if (netfs_group && !priv)
+			folio_attach_private(folio, netfs_get_group(netfs_group));
+		else
+			WARN_ON_ONCE(1);
+	}
+
 	file_update_time(file);
 	set_bit(NETFS_ICTX_MODIFIED_ATTR, &ictx->flags);
 	if (ictx->ops->post_modify)
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index aa9940ba307b..082cb03c6131 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -181,6 +181,7 @@
 	EM(netfs_whole_folio_modify_filled,	"mod-whole-f+")	\
 	EM(netfs_whole_folio_modify_filled_efault, "mod-whole-f+!") \
 	EM(netfs_modify_and_clear,		"mod-n-clear")	\
+	EM(netfs_modify_and_clear_rm_finfo,	"mod-n-clear+")	\
 	EM(netfs_streaming_write,		"mod-streamw")	\
 	EM(netfs_streaming_write_cont,		"mod-streamw+")	\
 	EM(netfs_flush_content,			"flush")	\

