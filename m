Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B165A4756CB
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 13:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787838234; cv=none; b=XMF0p+btMG92gm9bFYp+zOFA7sfI5+kozA6SBDLg4IfKWsbN1qnU/ZvRHytjkFcXakaGOW63nQeYRh9gnpbbIsp4/wAo4zNGLduFzwjJyDSrb4qIIWEdHvEQ7XMq/FdOsKDNddBtVSscc5X39J9m9Sg4AlucwICvXDsfyBAZZcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787838234; c=relaxed/simple;
	bh=Yl/ZJh+3Psc+1DNGg2+MOGLRRNee16kloe3LE5AXueQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olatNRMQIyzLkKIAXs3D6qkD0uQLKJbAd2JDMEFVF0yLXBiEHOv6bx/2E7UxCKHmxcn94L55P1O+71dIsFQj8FxO5OP8QquztEjMNwi1bS7ZCysmGr3oAXWXNiTc2NGoEqMGeyH8JPz1fVkG9v117jLZH8gGx1dZvU6O9eb2S70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eXJIcaK4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eXJIcaK4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787838226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ba/IvlZYTqtQmrVqBAZRpLdnEkK4DVMXNxD+HrUDFj0=;
	b=eXJIcaK4VtdnC7JuYZ58Z/GwfQ4OInzF2bKV+1qbbyJIeUObi/K7Ejf+wehIVFVj43ohp1
	oNcfcDAZMrc+EwdhgBNDtjSxu6V0JpEmu+NaNE7k5wYQn0FKYSHXFbeCJzNrZKu4xO6ME6
	U1CcPbiizS7Bik4VYs0ZhcilxlXspcw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-iXnNCPd4NvKf-DrzHFunqA-1; Thu,
 27 Aug 2026 09:43:43 -0400
X-MC-Unique: iXnNCPd4NvKf-DrzHFunqA-1
X-Mimecast-MFC-AGG-ID: iXnNCPd4NvKf-DrzHFunqA_1787838222
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3634195DE3B;
	Thu, 27 Aug 2026 13:43:41 +0000 (UTC)
Received: from warthog.com (unknown [10.22.88.47])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 91B353000223;
	Thu, 27 Aug 2026 13:43:38 +0000 (UTC)
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
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH v4 08/10] netfs: Mark folios with COPY_TO_CACHE whilst issuing subreqs
Date: Thu, 27 Aug 2026 14:43:01 +0100
Message-ID: <20260827134304.2075713-9-dhowells@redhat.com>
In-Reply-To: <20260827134304.2075713-1-dhowells@redhat.com>
References: <20260827134304.2075713-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Mark folios with NETFS_FOLIO_COPY_TO_CACHE whilst issuing subreqs rather than
when collecting them.  This means that the collector thread doesn't have to
try and keep track of which subreqs contribute to which folios - and thus
which folios will need to be copied to the cache because at least one byte
wasn't in the cache.  Instead, this is marked on the folios up front and the
collector need only consider the folios.

For PG_private_2-using filesystems, PG_private_2 is set instead of
NETFS_FOLIO_COPY_TO_CACHE, but otherwise it works the same.

The NETFS_RREQ_COPY_TO_CACHE is replaced with NETFS_RREQ_CANCEL_CACHING, which
is now set if caching fails somewhere, thereby causing the collection thread
to cancel the copy-to-cache marks on the remaining folios.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c     | 61 +++++++++++++++++++++++++++++++-
 fs/netfs/internal.h          |  1 +
 fs/netfs/read_collect.c      | 67 ++++++++++++++++++++++--------------
 fs/netfs/read_pgpriv2.c      | 15 ++++----
 fs/netfs/read_retry.c        |  6 +++-
 include/linux/netfs.h        |  2 +-
 include/trace/events/netfs.h |  6 ++--
 7 files changed, 121 insertions(+), 37 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 303fdce54fba..16d4db776f6a 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -211,6 +211,56 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
 	}
 }
 
+/*
+ * Mark folios that we want to copy to the cache.  For filesystems that use
+ * netfslib fully, we set folio->private to NETFS_FOLIO_COPY_TO_CACHE;
+ * otherwise we set the deprecated PG_private_2.
+ */
+static void netfs_mark_copy_to_cache(struct netfs_io_request *rreq,
+				     struct folio_queue **fq,
+				     unsigned int *offset,
+				     int *slot,
+				     size_t len,
+				     bool copy)
+{
+	while (len > 0) {
+		struct folio *folio;
+		size_t fsize, overlap;
+
+		if (!*fq)
+			break;
+		if (*slot >= folioq_count(*fq)) {
+			*fq = (*fq)->next;
+			*slot = 0;
+			*offset = 0;
+			continue;
+		}
+
+		/* Determine how much the subreq overlaps the folio, if at all. */
+		fsize = folioq_folio_size(*fq, *slot);
+		overlap = min(len, fsize - *offset);
+
+		if (overlap > 0 && copy) {
+			folio = folioq_folio(*fq, *slot);
+			if (unlikely(test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags))) {
+				if (!folio_test_private_2(folio))
+					folio_start_private_2(folio);
+			} else {
+				if (!folio_get_private(folio))
+					folio_attach_private(folio, NETFS_FOLIO_COPY_TO_CACHE);
+			}
+			trace_netfs_folio(folio, netfs_folio_trace_mark_copy);
+		}
+
+		len -= overlap;
+		*offset += overlap;
+		if (*offset >= fsize) {
+			*slot += 1;
+			*offset = 0;
+		}
+	}
+}
+
 /*
  * Perform a read to the pagecache from a series of sources of different types,
  * slicing up the region to be read according to available cache blocks and
@@ -218,9 +268,11 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
  */
 static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 {
+	struct folio_queue *fq = rreq->buffer.tail;
 	unsigned long long start = rreq->start;
+	unsigned int offset = 0;
 	ssize_t size = rreq->len;
-	int ret = 0;
+	int ret = 0, slot = 0;
 
 	do {
 		struct netfs_io_subrequest *subreq;
@@ -308,6 +360,13 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 			set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 		}
 
+		if (fq) {
+			/* See if the cache indicated this should be cached. */
+			bool copy = test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
+
+			netfs_mark_copy_to_cache(rreq, &fq, &slot, &offset, slice, copy);
+		}
+
 		netfs_issue_read(rreq, subreq);
 		netfs_maybe_bulk_drop_ra_refs(rreq);
 
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index bd8b2d633f96..dfe7939f35f3 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -110,6 +110,7 @@ static inline void netfs_see_subrequest(struct netfs_io_subrequest *subreq,
 /*
  * read_collect.c
  */
+void netfs_cancel_copy_to_cache(struct netfs_io_request *rreq, struct folio *folio);
 bool netfs_read_collection(struct netfs_io_request *rreq);
 void netfs_read_collection_worker(struct work_struct *work);
 void netfs_cancel_read(struct netfs_io_subrequest *subreq, int error);
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index edf7cea7e2f9..12a786be1ea2 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -19,7 +19,6 @@
 #define MADE_PROGRESS	0x04	/* Made progress cleaning up a stream or the folio set */
 #define BUFFERED	0x08	/* The pagecache needs cleaning up */
 #define NEED_RETRY	0x10	/* A front op requests retrying */
-#define COPY_TO_CACHE	0x40	/* Need to copy subrequest to cache */
 #define ABANDON_SREQ	0x80	/* Need to abandon untransferred part of subrequest */
 
 /*
@@ -34,6 +33,30 @@ static void netfs_clear_unread(struct netfs_io_subrequest *subreq)
 		__set_bit(NETFS_SREQ_HIT_EOF, &subreq->flags);
 }
 
+/*
+ * Cancel the copy-to-cache mark on a folio.
+ */
+void netfs_cancel_copy_to_cache(struct netfs_io_request *rreq, struct folio *folio)
+{
+	if (!test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
+		if (folio_get_private(folio) == NETFS_FOLIO_COPY_TO_CACHE) {
+			folio_detach_private(folio);
+			trace_netfs_folio(folio, netfs_folio_trace_cancel_copy);
+		} else if (netfs_folio_group(folio) == NETFS_FOLIO_COPY_TO_CACHE)  {
+			struct netfs_folio *finfo = netfs_folio_info(folio);
+
+			finfo->netfs_group = NULL;
+			trace_netfs_folio(folio, netfs_folio_trace_cancel_copy);
+		}
+	} else {
+		// TODO: Use of PG_private_2 is deprecated.
+		if (folio_test_private_2(folio)) {
+			folio_end_private_2(folio);
+			trace_netfs_folio(folio, netfs_folio_trace_cancel_copy);
+		}
+	}
+}
+
 /*
  * Flush, mark and unlock a folio that's now completely read.  If we want to
  * cache the folio, we set the group to NETFS_FOLIO_COPY_TO_CACHE, mark it
@@ -48,37 +71,37 @@ static void netfs_unlock_read_folio(struct netfs_io_request *rreq,
 
 	if (unlikely(folio_pos(folio) < rreq->abandon_to)) {
 		trace_netfs_folio(folio, netfs_folio_trace_abandon);
+		netfs_cancel_copy_to_cache(rreq, folio);
 		goto just_unlock;
 	}
 
 	flush_dcache_folio(folio);
 	folio_mark_uptodate(folio);
 
-	if (!test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
-		finfo = netfs_folio_info(folio);
-		if (finfo) {
-			trace_netfs_folio(folio, netfs_folio_trace_filled_gaps);
-			if (finfo->netfs_group)
-				folio_change_private(folio, finfo->netfs_group);
-			else
-				folio_detach_private(folio);
-			kfree(finfo);
-		}
+	if (unlikely(test_bit(NETFS_RREQ_CANCEL_CACHING, &rreq->flags)))
+		netfs_cancel_copy_to_cache(rreq, folio);
 
-		if (test_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags)) {
-			if (!WARN_ON_ONCE(folio_get_private(folio) != NULL)) {
-				trace_netfs_folio(folio, netfs_folio_trace_copy_to_cache);
-				folio_attach_private(folio, NETFS_FOLIO_COPY_TO_CACHE);
-				folio_mark_dirty(folio);
-			}
+	if (!test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
+		if (netfs_folio_group(folio) == NETFS_FOLIO_COPY_TO_CACHE)  {
+			trace_netfs_folio(folio, netfs_folio_trace_sched_copy);
+			folio_mark_dirty(folio);
 		} else {
+			finfo = netfs_folio_info(folio);
+			if (finfo) {
+				trace_netfs_folio(folio, netfs_folio_trace_filled_gaps);
+				if (finfo->netfs_group)
+					folio_change_private(folio, finfo->netfs_group);
+				else
+					folio_detach_private(folio);
+				kfree(finfo);
+			}
 			trace_netfs_folio(folio, netfs_folio_trace_read_done);
 		}
 
 		folioq_clear(folioq, slot);
 	} else {
 		// TODO: Use of PG_private_2 is deprecated.
-		if (test_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags))
+		if (folio_test_private_2(folio))
 			netfs_pgpriv2_copy_to_cache(rreq, folio);
 	}
 
@@ -131,9 +154,6 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		unsigned int order;
 		size_t fsize;
 
-		if (*notes & COPY_TO_CACHE)
-			set_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
-
 		folio = folioq_folio(folioq, slot);
 		if (WARN_ONCE(!folio_test_locked(folio),
 			      "R=%08x: folio %lx is not locked\n",
@@ -156,8 +176,6 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		WRITE_ONCE(rreq->cleaned_to, fpos + fsize);
 		*notes |= MADE_PROGRESS;
 
-		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
-
 		/* Clean up the head folioq.  If we clear an entire folioq, then
 		 * we can get rid of it provided it's not also the tail folioq
 		 * being filled by the issuer.
@@ -255,9 +273,6 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 			stream->collected_to = front->start + transferred;
 			rreq->collected_to = stream->collected_to;
 
-			if (test_bit(NETFS_SREQ_COPY_TO_CACHE, &front->flags))
-				notes |= COPY_TO_CACHE;
-
 			if (test_bit(NETFS_SREQ_FAILED, &front->flags)) {
 				rreq->abandon_to = front->start + front->len;
 				front->transferred = front->len;
diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index c31190993b76..a4b7bb88cbdb 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -54,8 +54,8 @@ static void netfs_pgpriv2_copy_folio(struct netfs_io_request *creq, struct folio
 
 	/* Attach the folio to the rolling buffer. */
 	if (rolling_buffer_append(&creq->buffer, folio, 0, creq->gfp) < 0) {
+		set_bit(NETFS_RREQ_CANCEL_CACHING, &creq->flags);
 		folio_end_private_2(folio);
-		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &creq->flags);
 		return;
 	}
 
@@ -122,13 +122,14 @@ static struct netfs_io_request *netfs_pgpriv2_begin_copy_to_cache(
 	netfs_put_failed_request(creq);
 cancel:
 	rreq->copy_to_cache = ERR_PTR(-ENOBUFS);
-	clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
+	set_bit(NETFS_RREQ_CANCEL_CACHING, &rreq->flags);
 	return ERR_PTR(-ENOBUFS);
 }
 
 /*
  * [DEPRECATED] Mark page as requiring copy-to-cache using PG_private_2 and add
- * it to the copy write request.
+ * it to the copy write request.  PG_private_2 should already be set on the
+ * folio.
  */
 void netfs_pgpriv2_copy_to_cache(struct netfs_io_request *rreq, struct folio *folio)
 {
@@ -136,11 +137,13 @@ void netfs_pgpriv2_copy_to_cache(struct netfs_io_request *rreq, struct folio *fo
 
 	if (!creq)
 		creq = netfs_pgpriv2_begin_copy_to_cache(rreq, folio);
-	if (IS_ERR(creq))
+	if (IS_ERR(creq)) {
+		set_bit(NETFS_RREQ_CANCEL_CACHING, &rreq->flags);
+		netfs_cancel_copy_to_cache(rreq, folio);
 		return;
+	}
 
-	trace_netfs_folio(folio, netfs_folio_trace_copy_to_cache);
-	folio_start_private_2(folio);
+	trace_netfs_folio(folio, netfs_folio_trace_pgpriv2_copy);
 	netfs_pgpriv2_copy_folio(creq, folio);
 }
 
diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index dd463a485139..4f6a36c6e214 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -303,7 +303,11 @@ void netfs_unlock_abandoned_read_pages(struct netfs_io_request *rreq)
 		for (int slot = 0; slot < folioq_count(p); slot++) {
 			struct folio *folio = folioq_folio(p, slot);
 
-			if (folio && !folioq_is_marked2(p, slot)) {
+			if (!folio)
+				continue;
+			netfs_cancel_copy_to_cache(rreq, folio);
+
+			if (!folioq_is_marked2(p, slot)) {
 				if (folio == rreq->no_unlock_folio &&
 				    test_bit(NETFS_RREQ_NO_UNLOCK_FOLIO,
 					     &rreq->flags)) {
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 5c538d0c5d79..9881f4afdc0c 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -275,7 +275,7 @@ struct netfs_io_request {
 #define NETFS_RREQ_SHORT_TRANSFER	5	/* Set if we have a short transfer */
 #define NETFS_RREQ_OFFLOAD_COLLECTION	8	/* Offload collection to workqueue */
 #define NETFS_RREQ_NO_UNLOCK_FOLIO	9	/* Don't unlock no_unlock_folio on completion */
-#define NETFS_RREQ_FOLIO_COPY_TO_CACHE	10	/* Copy current folio to cache from read */
+#define NETFS_RREQ_CANCEL_CACHING	10	/* Set to cancel caching */
 #define NETFS_RREQ_UPLOAD_TO_SERVER	11	/* Need to write to the server */
 #define NETFS_RREQ_USE_IO_ITER		12	/* Use ->io_iter rather than ->i_pages */
 #define NETFS_RREQ_NEED_PUT_RA_REFS	17	/* Need to put the folio refs RA gave us */
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 9bda9302be90..a22084813cb5 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -198,7 +198,6 @@
 	EM(netfs_folio_trace_clear_cc,		"clear-cc")	\
 	EM(netfs_folio_trace_clear_g,		"clear-g")	\
 	EM(netfs_folio_trace_clear_s,		"clear-s")	\
-	EM(netfs_folio_trace_copy_to_cache,	"mark-copy")	\
 	EM(netfs_folio_trace_end_copy,		"end-copy")	\
 	EM(netfs_folio_trace_filled_gaps,	"filled-gaps")	\
 	EM(netfs_folio_trace_invalidate_all,	"inval-all")	\
@@ -209,16 +208,19 @@
 	EM(netfs_folio_trace_kill_cc,		"kill-cc")	\
 	EM(netfs_folio_trace_kill_g,		"kill-g")	\
 	EM(netfs_folio_trace_kill_s,		"kill-s")	\
+	EM(netfs_folio_trace_mark_copy,		"mark-copy")	\
 	EM(netfs_folio_trace_mkwrite,		"mkwrite")	\
 	EM(netfs_folio_trace_mkwrite_plus,	"mkwrite+")	\
-	EM(netfs_folio_trace_not_under_wback,	"!wback")	\
 	EM(netfs_folio_trace_not_locked,	"!locked")	\
+	EM(netfs_folio_trace_not_under_wback,	"!wback")	\
+	EM(netfs_folio_trace_pgpriv2_copy,	"pgpriv2-copy")	\
 	EM(netfs_folio_trace_put,		"put")		\
 	EM(netfs_folio_trace_read,		"read")		\
 	EM(netfs_folio_trace_read_done,		"read-done")	\
 	EM(netfs_folio_trace_read_gaps,		"read-gaps")	\
 	EM(netfs_folio_trace_read_unlock,	"read-unlock")	\
 	EM(netfs_folio_trace_redirtied,		"redirtied")	\
+	EM(netfs_folio_trace_sched_copy,	"sched-copy")	\
 	EM(netfs_folio_trace_store,		"store")	\
 	EM(netfs_folio_trace_store_copy,	"store-copy")	\
 	EM(netfs_folio_trace_store_plus,	"store+")	\

