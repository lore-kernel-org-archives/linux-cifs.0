Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEB7471437
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 13:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664111; cv=none; b=VNXYzu4hDga8XD8TYKP6AcpzHH2/Hyfd2N8la9llVTofOqUJA/XDRtI1ubqtiYMn99qRKvE6AnsKLdbSBqWNuhbGYnu5C4Fk8DlXpWeLDZFNqFHyPU1W7VtEMj/NhOi62WojUpyKOKxMe53bUMvEiQhUIVU44lcTgX8cfCUwu9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664111; c=relaxed/simple;
	bh=TZIaDz2dLWeGDWLilArCDOaTIeHYHVdTLBE5S9fIPZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImIfUaSmOw21AbUNRo8EFLmsmmiv/Km19bvTSLxQuG4dG7Z1XiAMitvDTCz8qCxoe9tXCLNa6Xy05YPylP38wkr7MuTHzKVQj+zozTu6/Sh4M9XTYS9E4gvJvSvqht1UJfTj5nCQS610Nea+vJeASyvFZoBkxs3v5+cRW7VxrKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VuFezs9+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VuFezs9+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787664101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sw0E+cs1TZCBxJfCLdoN86ZS+WFKAcczQoxjTe7v77A=;
	b=VuFezs9+QGFaSrvCw0CKEwMxgiXTOEOzNcJfV5jxx5l2KEwLBctlHbReC2bvU5gYmtymVF
	SWYNCinLbSiQaymgglFz1LQkPOHqEZpKhpK5MBsoMObSWotcr2Ujp6n7YUJSnrLA9fnAWG
	ol/3AoNwexGMCS/07zEsd1tU9f1y5yk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-280-6iwVOOfPPCi8TbpMpm9duQ-1; Tue,
 25 Aug 2026 09:21:37 -0400
X-MC-Unique: 6iwVOOfPPCi8TbpMpm9duQ-1
X-Mimecast-MFC-AGG-ID: 6iwVOOfPPCi8TbpMpm9duQ_1787664092
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5C1C195DBAA;
	Tue, 25 Aug 2026 13:21:32 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 081981800346;
	Tue, 25 Aug 2026 13:21:29 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/9] netfs: Fix read progress reporting
Date: Tue, 25 Aug 2026 14:20:42 +0100
Message-ID: <20260825132045.1000787-9-dhowells@redhat.com>
In-Reply-To: <20260825132045.1000787-1-dhowells@redhat.com>
References: <20260825132045.1000787-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

For really big read RPC ops that span multiple folios, netfslib allows the
filesystem to give progress notifications to wake up the collector thread
to do a collection of folios that have now been fetched, even if the RPC is
still ongoing, thereby allowing the application to make progress.

This works by taking the current rreq->cleaned_to value (which indicates
which folios have been unlocked) and adding the stashed size of the next
folio to it.  cleaned_to, however, is subject to 64-bit tearing on a 32-bit
arch.

Fix this by stashing the next progress notification point as a size_t
(which won't tear) to be added to rreq->start (which won't change), with
the collector thread calculating that from cleaned_to plus the next folio
size.

Further, however, if the folios are small, the collector thread gets
constantly woken up - which has a negative performance impact on the
system.

Fix that too by setting a minimum trigger of 256KiB or the size of the
folio at the front of the queue, whichever is larger.

Also, make sure rreq->cleaned_to is initialised up front, along with
rreq->collected_to and stream->collected_to.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Link: https://sashiko.dev/#/patchset/20260804100224.2748935-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c     |  2 ++
 fs/netfs/internal.h          |  1 +
 fs/netfs/objects.c           | 32 ++++++++++++--------
 fs/netfs/read_collect.c      | 58 +++++++++++++++++++++++++++---------
 fs/netfs/read_single.c       |  2 ++
 include/linux/netfs.h        |  2 +-
 include/trace/events/netfs.h | 21 +++++++++++++
 7 files changed, 91 insertions(+), 27 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 303fdce54fba..a2a9d8c083f9 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -383,6 +383,7 @@ void netfs_readahead(struct readahead_control *ractl)
 
 	rreq->submitted = rreq->start + added;
 	rreq->cleaned_to = rreq->start;
+	netfs_read_set_unlock_at(rreq);
 
 	netfs_read_to_pagecache(rreq);
 	netfs_maybe_bulk_drop_ra_refs(rreq);
@@ -408,6 +409,7 @@ static int netfs_create_singular_buffer(struct netfs_io_request *rreq, struct fo
 	if (added < 0)
 		return added;
 	rreq->submitted = rreq->start + added;
+	rreq->progress_at = added;
 	return 0;
 }
 
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index bd8b2d633f96..c734cad7063e 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -110,6 +110,7 @@ static inline void netfs_see_subrequest(struct netfs_io_subrequest *subreq,
 /*
  * read_collect.c
  */
+void netfs_read_set_unlock_at(struct netfs_io_request *rreq);
 bool netfs_read_collection(struct netfs_io_request *rreq);
 void netfs_read_collection_worker(struct work_struct *work);
 void netfs_cancel_read(struct netfs_io_subrequest *subreq, int error);
diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index 01461a74642d..7f6a3e912602 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -41,24 +41,32 @@ struct netfs_io_request *netfs_alloc_request(struct address_space *mapping,
 
 	memset(rreq, 0, kmem_cache_size(cache));
 	INIT_WORK(&rreq->cleanup_work, netfs_free_request);
-	rreq->gfp	= gfp;
-	rreq->start	= start;
-	rreq->len	= len;
-	rreq->origin	= origin;
-	rreq->netfs_ops	= ctx->ops;
-	rreq->mapping	= mapping;
-	rreq->inode	= inode;
-	rreq->i_size	= i_size_read(inode);
-	rreq->debug_id	= atomic_inc_return(&debug_ids);
-	rreq->wsize	= INT_MAX;
+	rreq->gfp		= gfp;
+	rreq->start		= start;
+	rreq->collected_to	= start;
+	rreq->cleaned_to	= start;
+	rreq->len		= len;
+	rreq->progress_at	= 0;
+	rreq->origin		= origin;
+	rreq->netfs_ops		= ctx->ops;
+	rreq->mapping		= mapping;
+	rreq->inode		= inode;
+	rreq->i_size		= i_size_read(inode);
+	rreq->debug_id		= atomic_inc_return(&debug_ids);
+	rreq->wsize		= INT_MAX;
 	rreq->io_streams[0].sreq_max_len = ULONG_MAX;
 	rreq->io_streams[0].sreq_max_segs = 0;
 	spin_lock_init(&rreq->lock);
-	INIT_LIST_HEAD(&rreq->io_streams[0].subrequests);
-	INIT_LIST_HEAD(&rreq->io_streams[1].subrequests);
 	init_waitqueue_head(&rreq->waitq);
 	refcount_set(&rreq->ref, 2);
 
+	for (int s = 0; s < NR_IO_STREAMS; s++) {
+		struct netfs_io_stream *stream = &rreq->io_streams[s];
+
+		INIT_LIST_HEAD(&stream->subrequests);
+		stream->collected_to = rreq->start;
+	}
+
 	if (origin == NETFS_READAHEAD ||
 	    origin == NETFS_READPAGE ||
 	    origin == NETFS_READ_GAPS ||
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index edf7cea7e2f9..8ba162cf568b 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -94,6 +94,35 @@ static void netfs_unlock_read_folio(struct netfs_io_request *rreq,
 	folioq_clear(folioq, slot);
 }
 
+/*
+ * Determine how much to gather before unlocking more folios.
+ */
+void netfs_read_set_unlock_at(struct netfs_io_request *rreq)
+{
+	struct folio_queue *folioq = rreq->buffer.tail;
+	unsigned int slot = rreq->buffer.first_tail_slot;
+	size_t cleaned_to = rreq->cleaned_to - rreq->start;
+	size_t progress_at = cleaned_to;
+	size_t minimum = 256 * 1024;
+
+	while (progress_at < rreq->len) {
+		if (slot >= folioq_count(folioq)) {
+			folioq = folioq->next;
+			if (!folioq)
+				break;
+			slot = 0;
+		}
+
+		progress_at += folioq_folio_size(folioq, slot);
+		if (progress_at - cleaned_to >= minimum)
+			break;
+		slot++;
+	}
+
+	WRITE_ONCE(rreq->progress_at, progress_at);
+	trace_netfs_read_progress_at(rreq);
+}
+
 /*
  * Unlock any folios we've finished with.
  */
@@ -112,7 +141,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 	if (slot >= folioq_nr_slots(folioq)) {
 		folioq = rolling_buffer_delete_spent(&rreq->buffer);
 		if (!folioq) {
-			rreq->front_folio_order = 0;
+			WRITE_ONCE(rreq->progress_at, ULONG_MAX);
 			return;
 		}
 		slot = 0;
@@ -127,8 +156,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 
 	for (;;) {
 		struct folio *folio;
-		unsigned long long fpos, fend;
-		unsigned int order;
+		unsigned long long fpos = rreq->cleaned_to, fend;
 		size_t fsize;
 
 		if (*notes & COPY_TO_CACHE)
@@ -140,9 +168,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 			      rreq->debug_id, folio->index))
 			trace_netfs_folio(folio, netfs_folio_trace_not_locked);
 
-		order = folioq_folio_order(folioq, slot);
-		rreq->front_folio_order = order;
-		fsize = PAGE_SIZE << order;
+		fsize = folioq_folio_size(folioq, slot);
 		fpos = folio_pos(folio);
 		fend = fpos + fsize;
 
@@ -153,7 +179,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 			break;
 
 		netfs_unlock_read_folio(rreq, folioq, slot);
-		WRITE_ONCE(rreq->cleaned_to, fpos + fsize);
+		WRITE_ONCE(rreq->cleaned_to, fend);
 		*notes |= MADE_PROGRESS;
 
 		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
@@ -179,6 +205,8 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 	rreq->buffer.tail = folioq;
 done:
 	rreq->buffer.first_tail_slot = slot;
+
+	netfs_read_set_unlock_at(rreq);
 }
 
 /*
@@ -239,7 +267,7 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 		 * subreqs.
 		 */
 		if (notes & BUFFERED) {
-			size_t fsize = PAGE_SIZE << rreq->front_folio_order;
+			uoff_t unlock_at = rreq->start + rreq->progress_at;
 
 			/* Clear the tail of a short read. */
 			if (!(notes & HIT_PENDING) &&
@@ -264,7 +292,7 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 				transferred = front->len;
 				trace_netfs_rreq(rreq, netfs_rreq_trace_set_abandon);
 			}
-			if (front->start + transferred >= rreq->cleaned_to + fsize ||
+			if (front->start + transferred >= unlock_at ||
 			    test_bit(NETFS_SREQ_HIT_EOF, &front->flags))
 				netfs_read_unlock_folios(rreq, &notes);
 		} else {
@@ -484,20 +512,22 @@ void netfs_read_collection_worker(struct work_struct *work)
 void netfs_read_subreq_progress(struct netfs_io_subrequest *subreq)
 {
 	struct netfs_io_request *rreq = subreq->rreq;
-	struct netfs_io_stream *stream = &rreq->io_streams[0];
-	size_t fsize = PAGE_SIZE << rreq->front_folio_order;
-
-	trace_netfs_sreq(subreq, netfs_sreq_trace_progress);
+	struct netfs_io_stream *stream = &rreq->io_streams[subreq->stream_nr];
+	size_t progress_at = READ_ONCE(rreq->progress_at);
+	uoff_t update_at = rreq->start + progress_at;
+	uoff_t transferred_to = subreq->start + subreq->transferred;
 
 	/* If we are at the head of the queue, wake up the collector,
 	 * getting a ref to it if we were the ones to do so.
 	 */
-	if (subreq->start + subreq->transferred > rreq->cleaned_to + fsize &&
+	if (progress_at != ULONG_MAX &&
+	    transferred_to >= update_at &&
 	    (rreq->origin == NETFS_READAHEAD ||
 	     rreq->origin == NETFS_READPAGE ||
 	     rreq->origin == NETFS_READ_FOR_WRITE) &&
 	    list_is_first(&subreq->rreq_link, &stream->subrequests)
 	    ) {
+		trace_netfs_sreq(subreq, netfs_sreq_trace_progress);
 		__set_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
 		netfs_wake_collector(rreq);
 	}
diff --git a/fs/netfs/read_single.c b/fs/netfs/read_single.c
index 8833550d2eb6..de67ac41548d 100644
--- a/fs/netfs/read_single.c
+++ b/fs/netfs/read_single.c
@@ -170,6 +170,8 @@ ssize_t netfs_read_single(struct inode *inode, struct file *file, struct iov_ite
 	if (IS_ERR(rreq))
 		return PTR_ERR(rreq);
 
+	rreq->progress_at = rreq->len;
+
 	ret = netfs_single_begin_cache_read(rreq, ictx);
 	if (ret == -ENOMEM || ret == -EINTR || ret == -ERESTARTSYS)
 		goto cleanup_free;
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 5c538d0c5d79..1cf2ef3ce18b 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -246,6 +246,7 @@ struct netfs_io_request {
 	unsigned long long	submitted;	/* Amount submitted for I/O so far */
 	unsigned long long	len;		/* Length of the request */
 	size_t			transferred;	/* Amount to be indicated as transferred */
+	size_t			progress_at;	/* Report read progress when hit this much read */
 	long			error;		/* 0 or error that occurred */
 	unsigned long long	i_size;		/* Size of the file */
 	unsigned long long	start;		/* Start position */
@@ -262,7 +263,6 @@ struct netfs_io_request {
 	atomic_t		subreq_counter;	/* Next subreq->debug_index */
 	unsigned int		nr_group_rel;	/* Number of refs to release on ->group */
 	spinlock_t		lock;		/* Lock for queuing subreqs */
-	unsigned char		front_folio_order; /* Order (size) of front folio */
 	enum netfs_io_origin	origin;		/* Origin of the request */
 	bool			direct_bv_unpin; /* T if direct_bv[] must be unpinned */
 	refcount_t		ref;
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 9bda9302be90..b5da315274ad 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -789,6 +789,27 @@ TRACE_EVENT(netfs_folioq,
 		      __print_symbolic(__entry->trace, netfs_folioq_traces))
 	    );
 
+TRACE_EVENT(netfs_read_progress_at,
+	    TP_PROTO(const struct netfs_io_request *rreq),
+
+	    TP_ARGS(rreq),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,	rreq)
+		    __field(size_t,		progress_at)
+		    __field(size_t,		cleaned_to)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->rreq	= rreq->debug_id;
+		    __entry->cleaned_to	= rreq->cleaned_to - rreq->start;
+		    __entry->progress_at = rreq->progress_at;
+			   ),
+
+	    TP_printk("R=%08x cln=%zx prg=%zx",
+		      __entry->rreq, __entry->cleaned_to, __entry->progress_at)
+	    );
+
 #undef EM
 #undef E_
 #endif /* _TRACE_NETFS_H */

