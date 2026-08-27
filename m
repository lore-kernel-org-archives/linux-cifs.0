Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E0343B6C1
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 09:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787823569; cv=none; b=cLwOkUOUPffKB+9WBJaFHGQ03mg77zwTwntjHdggJuUmLEb0t8H5IfHjfdDdaLhhiI65CDaOl9Ch7hNEa5/O/+5rB+Q9lbJLoL2L//EFzdxeAnLmO2Z1fvZElTCDpE5K0+RVxClORmH5RcvpfDnFvuIFtUeGba3SDyav0EP6jAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787823569; c=relaxed/simple;
	bh=enMiTh7ajQJDRkBDW3/xeNSf2AzA38c8MZQEyZKKMKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmVQH4jCVcW0uNJqlstu25Gsf24D+eaMITnOKWkIMjIWZEORu23GAdyG8RAA1+Oz6mtqjN5q2o+Deo96f/zDu3zo9gL+V2KMpUyANCmM7rzWzq38yWpv5iiN6T+mvisD6KLATFJldLTLQNaObOT7rUoybuWqqHD+q5UrMVwPzHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OChB3RHn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OChB3RHn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787823558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u3E4rlqJ8DWtsJPMhxO6MmP2nf33NlSqugS9DB0Zuf8=;
	b=OChB3RHn9t22x1GkfxMku7kuaeW9yjPp9XvdBlJ9fhz7MDt1IA/RXSf9mwglD4gpOjlel0
	TBfWXARsWotNepYdQdcPz+xGLVmVztD7HE9eNbzcMDb91dIMCZf19xgAZfAr1AmTGtCtPJ
	Poyn61L2XlpKzjjUk9FqmJba7tbMEKo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-BRu3Mo4bN4K9PLAYtjhPdg-1; Thu,
 27 Aug 2026 05:39:14 -0400
X-MC-Unique: BRu3Mo4bN4K9PLAYtjhPdg-1
X-Mimecast-MFC-AGG-ID: BRu3Mo4bN4K9PLAYtjhPdg_1787823553
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 97DEE18009C0;
	Thu, 27 Aug 2026 09:39:12 +0000 (UTC)
Received: from warthog.com (unknown [10.22.88.47])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D82343000223;
	Thu, 27 Aug 2026 09:39:09 +0000 (UTC)
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
Subject: [PATCH v3 08/10] netfs: Mark folios with COPY_TO_CACHE whilst issuing subreqs
Date: Thu, 27 Aug 2026 10:38:23 +0100
Message-ID: <20260827093828.1956211-9-dhowells@redhat.com>
In-Reply-To: <20260827093828.1956211-1-dhowells@redhat.com>
References: <20260827093828.1956211-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Mark folios with COPY_TO_CACHE whilst issuing subreqs rather than when
collecting them.  This means that the collector thread doesn't have to try
and keep track of which subreqs contribute to which folios - and thus which
folios will need to be copied to the cache because at least one byte wasn't
in the cache.  Instead, this is marked on the folios up front and the
collector need only consider the folios.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c     | 62 +++++++++++++++++++++++++++++++++++-
 fs/netfs/read_collect.c      | 40 ++++++++++-------------
 fs/netfs/read_pgpriv2.c      | 13 +++++---
 include/linux/netfs.h        |  2 +-
 include/trace/events/netfs.h |  6 ++--
 5 files changed, 90 insertions(+), 33 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 303fdce54fba..20f358209730 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -211,6 +211,55 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
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
@@ -218,9 +267,11 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
  */
 static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 {
+	struct folio_queue *fq = rreq->buffer.tail;
 	unsigned long long start = rreq->start;
+	unsigned int offset;
 	ssize_t size = rreq->len;
-	int ret = 0;
+	int ret = 0, slot = 0;
 
 	do {
 		struct netfs_io_subrequest *subreq;
@@ -308,6 +359,15 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 			set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 		}
 
+		if (fq) {
+			/* See if the cache indicated this should be cached. */
+			bool copy = test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
+
+			if (copy)
+				set_bit(NETFS_RREQ_WRITE_TO_CACHE, &rreq->flags);
+			netfs_mark_copy_to_cache(rreq, &fq, &slot, &offset, slice, copy);
+		}
+
 		netfs_issue_read(rreq, subreq);
 		netfs_maybe_bulk_drop_ra_refs(rreq);
 
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index edf7cea7e2f9..4e298b690219 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -19,7 +19,6 @@
 #define MADE_PROGRESS	0x04	/* Made progress cleaning up a stream or the folio set */
 #define BUFFERED	0x08	/* The pagecache needs cleaning up */
 #define NEED_RETRY	0x10	/* A front op requests retrying */
-#define COPY_TO_CACHE	0x40	/* Need to copy subrequest to cache */
 #define ABANDON_SREQ	0x80	/* Need to abandon untransferred part of subrequest */
 
 /*
@@ -55,30 +54,31 @@ static void netfs_unlock_read_folio(struct netfs_io_request *rreq,
 	folio_mark_uptodate(folio);
 
 	if (!test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
-		finfo = netfs_folio_info(folio);
-		if (finfo) {
-			trace_netfs_folio(folio, netfs_folio_trace_filled_gaps);
-			if (finfo->netfs_group)
-				folio_change_private(folio, finfo->netfs_group);
-			else
-				folio_detach_private(folio);
-			kfree(finfo);
-		}
-
-		if (test_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags)) {
-			if (!WARN_ON_ONCE(folio_get_private(folio) != NULL)) {
-				trace_netfs_folio(folio, netfs_folio_trace_copy_to_cache);
-				folio_attach_private(folio, NETFS_FOLIO_COPY_TO_CACHE);
+		if (folio_get_private(folio) == NETFS_FOLIO_COPY_TO_CACHE)  {
+			if (test_bit(NETFS_RREQ_WRITE_TO_CACHE, &rreq->flags)) {
+				trace_netfs_folio(folio, netfs_folio_trace_sched_copy);
 				folio_mark_dirty(folio);
+			} else {
+				trace_netfs_folio(folio, netfs_folio_trace_cancel_copy);
+				folio_detach_private(folio);
 			}
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
+		if (test_bit(NETFS_RREQ_WRITE_TO_CACHE, &rreq->flags))
 			netfs_pgpriv2_copy_to_cache(rreq, folio);
 	}
 
@@ -131,9 +131,6 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		unsigned int order;
 		size_t fsize;
 
-		if (*notes & COPY_TO_CACHE)
-			set_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
-
 		folio = folioq_folio(folioq, slot);
 		if (WARN_ONCE(!folio_test_locked(folio),
 			      "R=%08x: folio %lx is not locked\n",
@@ -156,8 +153,6 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		WRITE_ONCE(rreq->cleaned_to, fpos + fsize);
 		*notes |= MADE_PROGRESS;
 
-		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
-
 		/* Clean up the head folioq.  If we clear an entire folioq, then
 		 * we can get rid of it provided it's not also the tail folioq
 		 * being filled by the issuer.
@@ -255,9 +250,6 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 			stream->collected_to = front->start + transferred;
 			rreq->collected_to = stream->collected_to;
 
-			if (test_bit(NETFS_SREQ_COPY_TO_CACHE, &front->flags))
-				notes |= COPY_TO_CACHE;
-
 			if (test_bit(NETFS_SREQ_FAILED, &front->flags)) {
 				rreq->abandon_to = front->start + front->len;
 				front->transferred = front->len;
diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index c31190993b76..fb57fc45b3fd 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -55,7 +55,7 @@ static void netfs_pgpriv2_copy_folio(struct netfs_io_request *creq, struct folio
 	/* Attach the folio to the rolling buffer. */
 	if (rolling_buffer_append(&creq->buffer, folio, 0, creq->gfp) < 0) {
 		folio_end_private_2(folio);
-		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &creq->flags);
+		clear_bit(NETFS_RREQ_WRITE_TO_CACHE, &creq->flags);
 		return;
 	}
 
@@ -122,7 +122,7 @@ static struct netfs_io_request *netfs_pgpriv2_begin_copy_to_cache(
 	netfs_put_failed_request(creq);
 cancel:
 	rreq->copy_to_cache = ERR_PTR(-ENOBUFS);
-	clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
+	clear_bit(NETFS_RREQ_WRITE_TO_CACHE, &rreq->flags);
 	return ERR_PTR(-ENOBUFS);
 }
 
@@ -136,11 +136,14 @@ void netfs_pgpriv2_copy_to_cache(struct netfs_io_request *rreq, struct folio *fo
 
 	if (!creq)
 		creq = netfs_pgpriv2_begin_copy_to_cache(rreq, folio);
-	if (IS_ERR(creq))
+	if (IS_ERR(creq)) {
+		clear_bit(NETFS_RREQ_WRITE_TO_CACHE, &rreq->flags);
 		return;
+	}
 
-	trace_netfs_folio(folio, netfs_folio_trace_copy_to_cache);
-	folio_start_private_2(folio);
+	trace_netfs_folio(folio, netfs_folio_trace_pgpriv2_copy);
+	if (WARN_ON_ONCE(!folio_test_private_2(folio)))
+		return;
 	netfs_pgpriv2_copy_folio(creq, folio);
 }
 
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 5c538d0c5d79..49fea3a30611 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -275,7 +275,7 @@ struct netfs_io_request {
 #define NETFS_RREQ_SHORT_TRANSFER	5	/* Set if we have a short transfer */
 #define NETFS_RREQ_OFFLOAD_COLLECTION	8	/* Offload collection to workqueue */
 #define NETFS_RREQ_NO_UNLOCK_FOLIO	9	/* Don't unlock no_unlock_folio on completion */
-#define NETFS_RREQ_FOLIO_COPY_TO_CACHE	10	/* Copy current folio to cache from read */
+#define NETFS_RREQ_WRITE_TO_CACHE	10	/* Need to write to the cache */
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

