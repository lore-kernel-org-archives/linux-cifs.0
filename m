Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E36288C08
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 08:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674280; cv=none; b=p39FLIa6eWLlCXOt9TnNRF82YBtLMmnQl/yutWSwLPNEPA4G31uw/XFqgQqknmxyJOvp56aFra/Tmz40hsGLmw6Qtbi1b/4hVW+Wic8xfdWG46OaIEpDBWZOhISOVqetrazJOg0KsQ9o5SbpnnLivBzL8wB1eBe5qeNJsStDcWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674280; c=relaxed/simple;
	bh=/KQmIgTJOCbv3hSfJO6jdQBY7LkyB0snaK0Rln8lc44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+xPhwKmG3/Q/9rQcVBYeLFrzvamQGhIIpPT28S/iVmoIdJKuQESg/UYRbPmzF8vsFMOU9zhUyLrHN/+oVRKPnPhHhPTStrNfEWGEh5qzX/ej+YiSw4U5z+KqhRV2W/vs14FiFfH0957mnivqRRM3/HM96zGIlIXxvU1lI2HMDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cFFRJWYP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cFFRJWYP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776674278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ftIxL41sEcAmEulwDX61ztIHIDAalQGRDwa5IsOQFo=;
	b=cFFRJWYPpCX542CjY+AOYwlimH1drmZsLKitYLdn2uA21zTbKkNSN7f6dNwl3O+i7wh8oB
	efjZLEZdqbdUaUreAa1Yh4FfPUZULrKRVkK6DG70B8F7DL8AHqGmrQP1wHBoWnlJE631ZS
	F3Dl3kUYDiGM1hcSotV6pbJNndBjai0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404--ZYaFUxaOtG8rCXPe9qVwg-1; Mon,
 20 Apr 2026 04:37:51 -0400
X-MC-Unique: -ZYaFUxaOtG8rCXPe9qVwg-1
X-Mimecast-MFC-AGG-ID: -ZYaFUxaOtG8rCXPe9qVwg_1776674269
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D09631800578;
	Mon, 20 Apr 2026 08:37:49 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6AB753000C20;
	Mon, 20 Apr 2026 08:37:46 +0000 (UTC)
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
Subject: [PATCH 07/11] netfs: Fix folio->private handling in netfs_perform_write()
Date: Mon, 20 Apr 2026 09:36:58 +0100
Message-ID: <20260420083705.1009074-8-dhowells@redhat.com>
In-Reply-To: <20260420083705.1009074-1-dhowells@redhat.com>
References: <20260420083705.1009074-1-dhowells@redhat.com>
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
 fs/netfs/buffered_write.c    | 77 +++++++++++++++++++++---------------
 include/trace/events/netfs.h |  2 +
 2 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index de82eb6ed473..0ca8e922790d 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -13,12 +13,6 @@
 #include <linux/pagevec.h>
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
@@ -158,6 +152,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		size_t offset;	/* Offset into pagecache folio */
 		size_t part;	/* Bytes to write to folio */
 		size_t copied;	/* Bytes copied from user */
+		void *priv;
 
 		offset = pos & (max_chunk - 1);
 		part = min(max_chunk - offset, iov_iter_count(iter));
@@ -213,8 +208,9 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		finfo = netfs_folio_info(folio);
 		group = netfs_folio_group(folio);
 
-		if (unlikely(group != netfs_group) &&
-		    group != NETFS_FOLIO_COPY_TO_CACHE)
+		if (unlikely(group) &&
+		    group != NETFS_FOLIO_COPY_TO_CACHE &&
+		    group != netfs_group)
 			goto flush_content;
 
 		if (folio_test_uptodate(folio)) {
@@ -238,24 +234,22 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -271,8 +265,10 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -306,6 +302,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			goto copied;
 		}
 
+		/* Do a streaming write on a folio that has nothing in it yet. */
 		if (!finfo) {
 			ret = -EIO;
 			if (WARN_ON(folio_get_private(folio)))
@@ -314,10 +311,8 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -346,7 +341,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			finfo->dirty_len += copied;
 			if (finfo->dirty_offset == 0 && finfo->dirty_len == flen) {
 				trace = netfs_streaming_cont_filled_page;
-				goto folio_now_filled;
+				goto mark_uptodate;
 			}
 			trace = netfs_streaming_write_cont;
 			goto copied;
@@ -362,13 +357,33 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
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

