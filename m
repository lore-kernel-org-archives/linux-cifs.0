Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4390B3976A9
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121752; cv=none; b=UYpcwncGOjap3jcT+9j/2OU5Wt6Ue/DhBkbcVr0SEX4m4vVrVlOLcLVCU3LV/yNm+szcGIyQBhPG72qgNMA12mMRXI3RMY8c8iAP25j0kcQIR84os+6GwjnJ39F1HUyqXEpCV82Eaqfi4Z3Jc3/I3tHYpXvyDOIkem0E1DpNwuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121752; c=relaxed/simple;
	bh=DRDJmYHK2ygS9wWeSeTfVKgUxwyN0xYD1MJVVOt5lpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvmmgwXaBIoiQjn8ohs6S+SZ9I3/KLcVz+9SOeqajSclY2LeKjQ7LeHzSYbqbsyTpPukxrU1EXwFuKQ1Yf8JIyWF7paeus1/tv5LXMpkNQqxiLRUBkAnZus+GrS3tIshoLuwv+BUV67syeux1dB2Wrr4W1ZLQbrqp8rt/6DFaio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SMVJlzmo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SMVJlzmo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+HCNdbgI96Ai70MhVVTZqmH4nl/dl7bHmAA/USf8Fc=;
	b=SMVJlzmo074/67126zbcjKw8DL9NHq4KO+uWMyZ8bowV13NZk8muDY7ouFTsA9bm7jlOWH
	T1lUwXsrfmxX5xltRDvmk5YBvaDNZnHJQGZcOtDhJLnusFh6MRF3lUnTxy35CnWjTLD51u
	b2n5FcYJsvwxcNKdnvW3V1LlwIM039A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-6NAkiPYJNwigtP-mOOAp-A-1; Sat,
 25 Apr 2026 08:55:43 -0400
X-MC-Unique: 6NAkiPYJNwigtP-mOOAp-A-1
X-Mimecast-MFC-AGG-ID: 6NAkiPYJNwigtP-mOOAp-A_1777121742
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 301DF195609F;
	Sat, 25 Apr 2026 12:55:42 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3F52E1800351;
	Sat, 25 Apr 2026 12:55:39 +0000 (UTC)
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
Subject: [PATCH v3 14/19] netfs: Fix folio->private handling in netfs_perform_write()
Date: Sat, 25 Apr 2026 13:54:18 +0100
Message-ID: <20260425125426.3855807-15-dhowells@redhat.com>
In-Reply-To: <20260425125426.3855807-1-dhowells@redhat.com>
References: <20260425125426.3855807-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
 fs/netfs/buffered_write.c    | 77 +++++++++++++++++++++---------------
 include/trace/events/netfs.h |  2 +
 2 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index c7b49b38a710..0439a4c2e003 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -12,12 +12,6 @@
 #include <linux/slab.h>
 #include "internal.h"
 
-static void __netfs_set_group(struct folio *folio, struct netfs_group *netfs_group)
-{
-	if (netfs_group)
-		folio_attach_private(folio, netfs_get_group(netfs_group));
-}
-
 static void netfs_set_group(struct folio *folio, struct netfs_group *netfs_group)
 {
 	void *priv = folio_get_private(folio);
@@ -157,6 +151,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		size_t offset;	/* Offset into pagecache folio */
 		size_t part;	/* Bytes to write to folio */
 		size_t copied;	/* Bytes copied from user */
+		void *priv;
 
 		offset = pos & (max_chunk - 1);
 		part = min(max_chunk - offset, iov_iter_count(iter));
@@ -212,8 +207,9 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		finfo = netfs_folio_info(folio);
 		group = netfs_folio_group(folio);
 
-		if (unlikely(group != netfs_group) &&
-		    group != NETFS_FOLIO_COPY_TO_CACHE)
+		if (unlikely(group) &&
+		    group != NETFS_FOLIO_COPY_TO_CACHE &&
+		    group != netfs_group)
 			goto flush_content;
 
 		if (folio_test_uptodate(folio)) {
@@ -237,24 +233,22 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -270,8 +264,10 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			 * accept the partial write.
 			 */
 			finfo->dirty_len += finfo->dirty_offset;
-			if (finfo->dirty_len == flen)
-				goto folio_now_filled;
+			if (finfo->dirty_len == flen) {
+				trace = netfs_whole_folio_modify_filled_efault;
+				goto mark_uptodate;
+			}
 			if (copied > finfo->dirty_len)
 				finfo->dirty_len = copied;
 			finfo->dirty_offset = 0;
@@ -303,6 +299,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			goto copied;
 		}
 
+		/* Do a streaming write on a folio that has nothing in it yet. */
 		if (!finfo) {
 			ret = -EIO;
 			if (WARN_ON(folio_get_private(folio)))
@@ -311,10 +308,8 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -343,7 +338,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			finfo->dirty_len += copied;
 			if (finfo->dirty_offset == 0 && finfo->dirty_len == flen) {
 				trace = netfs_streaming_cont_filled_page;
-				goto folio_now_filled;
+				goto mark_uptodate;
 			}
 			trace = netfs_streaming_write_cont;
 			goto copied;
@@ -359,13 +354,33 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
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
 		folio_mark_uptodate(folio);
-		kfree(finfo);
 	copied:
 		trace_netfs_folio(folio, trace);
 		flush_dcache_folio(folio);
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 67f6d56c94ce..1f5e3a5af08a 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -179,7 +179,9 @@
 	EM(netfs_whole_folio_modify,		"mod-whole-f")	\
 	EM(netfs_whole_folio_modify_efault,	"mod-whole-f!")	\
 	EM(netfs_whole_folio_modify_filled,	"mod-whole-f+")	\
+	EM(netfs_whole_folio_modify_filled_efault, "mod-whole-f+!")	\
 	EM(netfs_modify_and_clear,		"mod-n-clear")	\
+	EM(netfs_modify_and_clear_rm_finfo,	"mod-n-clear+")	\
 	EM(netfs_streaming_write,		"mod-streamw")	\
 	EM(netfs_streaming_write_cont,		"mod-streamw+")	\
 	EM(netfs_flush_content,			"flush")	\

