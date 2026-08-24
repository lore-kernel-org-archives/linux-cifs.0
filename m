Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B351419FA2
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 12:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572969; cv=none; b=DyBAXMIKG9ZpnPHmrDQBTERj1nRYjsoNyoB/ECnxdCvi87VMAZjTs/hV/8k4A6bQsZxYyrxaKUoP7DAIgTdnFs49Lf5VrA97VP6B7fQlmcKIClmElFaW/Aq0W8uCkXlIKu2FYfOgOT7Et2BFBCyS2bAEng8Wcb1bPwlz/L+pfYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572969; c=relaxed/simple;
	bh=iURkUWmXNqdrO5vzPkm+gyumrPcUezjSMTqyZ65/fMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdiMnYzEViSF/vI9N/wU9hn4rI25uKJtUn2zqVzCFWgBGnW5hpYqRTg+vqCrq8Ad1QIk2jUcYMbWAnaf3jGAeKLePvBJThR5Bu0VaQCiiKWE9dEJeKAnM4Yi0bhbikzX0oAGOMnpysxAOPG+pV9lr5T05u/6v1Il79CvBrG9zxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ogn0/nYZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ogn0/nYZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787572966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t/Vnaq263uFXisfUC8xRe+FUG1J3lRybpMK7FQGmnfk=;
	b=Ogn0/nYZeiJ8WvVB9XxmLZFuwzW34PMp+Q+MvyeSwUFLqrbP+tmnFRn7eKqF1Revh5Gs7p
	SvxDOCWs3WJm4sAdTwgWY7Bd37VYik5H4FLXol6Tg07/CX/3BVCl0Fss56BZvuoiObnvRx
	FzT0osMX0v2RQZ9r1ZGrUrsqS8nSJS8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-aaniOsKqOiK68GyNTVbk6g-1; Mon,
 24 Aug 2026 08:02:42 -0400
X-MC-Unique: aaniOsKqOiK68GyNTVbk6g-1
X-Mimecast-MFC-AGG-ID: aaniOsKqOiK68GyNTVbk6g_1787572961
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A045B1830727;
	Mon, 24 Aug 2026 12:02:40 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B9DC81800605;
	Mon, 24 Aug 2026 12:02:37 +0000 (UTC)
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
Subject: [PATCH 2/3] netfs: Fix read progress reporting
Date: Mon, 24 Aug 2026 13:02:21 +0100
Message-ID: <20260824120224.504575-3-dhowells@redhat.com>
In-Reply-To: <20260824120224.504575-1-dhowells@redhat.com>
References: <20260824120224.504575-1-dhowells@redhat.com>
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
 fs/netfs/buffered_read.c     |  4 +++
 fs/netfs/internal.h          |  1 +
 fs/netfs/objects.c           | 32 ++++++++++++--------
 fs/netfs/read_collect.c      | 58 +++++++++++++++++++++++++++---------
 fs/netfs/read_single.c       |  2 ++
 include/linux/netfs.h        |  2 +-
 include/trace/events/netfs.h | 21 +++++++++++++
 7 files changed, 93 insertions(+), 27 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 7fdfa4f27e34..3c32ef41a27f 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -106,6 +106,9 @@ static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq,
 				folio_batch_release(&put_batch);
 				return added;
 			}
+
+			if (!rreq->progress_at)
+				netfs_read_set_unlock_at(rreq);
 			rreq->submitted += added;
 		}
 		folio_batch_release(&put_batch);
@@ -387,6 +390,7 @@ static int netfs_create_singular_buffer(struct netfs_io_request *rreq, struct fo
 	if (added < 0)
 		return added;
 	rreq->submitted = rreq->start + added;
+	rreq->progress_at = added;
 	return 0;
 }
 
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 420ee7b26580..f92281a611de 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -109,6 +109,7 @@ static inline void netfs_see_subrequest(struct netfs_io_subrequest *subreq,
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
index 23660a590124..723b479ef606 100644
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
+		if (slot >= folioq_nr_slots(folioq)) {
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
@@ -120,8 +149,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 
 	for (;;) {
 		struct folio *folio;
-		unsigned long long fpos, fend;
-		unsigned int order;
+		unsigned long long fpos = rreq->cleaned_to, fend;
 		size_t fsize;
 
 		if (*notes & COPY_TO_CACHE)
@@ -133,9 +161,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 			      rreq->debug_id, folio->index))
 			trace_netfs_folio(folio, netfs_folio_trace_not_locked);
 
-		order = folioq_folio_order(folioq, slot);
-		rreq->front_folio_order = order;
-		fsize = PAGE_SIZE << order;
+		fsize = folioq_folio_size(folioq, slot);
 		fpos = folio_pos(folio);
 		fend = fpos + fsize;
 
@@ -146,7 +172,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 			break;
 
 		netfs_unlock_read_folio(rreq, folioq, slot);
-		WRITE_ONCE(rreq->cleaned_to, fpos + fsize);
+		WRITE_ONCE(rreq->cleaned_to, fend);
 		*notes |= MADE_PROGRESS;
 
 		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
@@ -172,6 +198,8 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 	rreq->buffer.tail = folioq;
 done:
 	rreq->buffer.first_tail_slot = slot;
+
+	netfs_read_set_unlock_at(rreq);
 }
 
 /*
@@ -232,7 +260,7 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 		 * subreqs.
 		 */
 		if (notes & BUFFERED) {
-			size_t fsize = PAGE_SIZE << rreq->front_folio_order;
+			uoff_t unlock_at = rreq->start + rreq->progress_at;
 
 			/* Clear the tail of a short read. */
 			if (!(notes & HIT_PENDING) &&
@@ -257,7 +285,7 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 				transferred = front->len;
 				trace_netfs_rreq(rreq, netfs_rreq_trace_set_abandon);
 			}
-			if (front->start + transferred >= rreq->cleaned_to + fsize ||
+			if (front->start + transferred >= unlock_at ||
 			    test_bit(NETFS_SREQ_HIT_EOF, &front->flags))
 				netfs_read_unlock_folios(rreq, &notes);
 		} else {
@@ -477,20 +505,22 @@ void netfs_read_collection_worker(struct work_struct *work)
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
index f837a501008c..a8702bd52d3a 100644
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
index 082cb03c6131..8ec10c076875 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -786,6 +786,27 @@ TRACE_EVENT(netfs_folioq,
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

