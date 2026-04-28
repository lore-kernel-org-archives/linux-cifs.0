Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E83451062
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 13:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382331; cv=none; b=LkJjYW7k8rYHixmzaqtTd1WN/Ze6qx9Xa3yB8U/ChrNKs22b/8psOnICUC6fYfdHhVPWpiEGYyEhtN3+kgocnDYz3q0xn90HEfRHJRyGXN1XWqb3A6tVY3M1n1QP+EL6IVHzbL7t/2pJ8rsq7aBxFGmsJqRWcEoN/W/tqeG+YZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382331; c=relaxed/simple;
	bh=PCEywMo+0ucWp3/WX+0dExm5VhO3M/QAe8pTFnnhHEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qzay3722r9gpMRuz9Owe876ShJo1v3Tk9wgA4KAQZKKMACpE09/mrMo33QpTqpIZkIpUfqDVReMqVW81QpT0PRgwzXJ5oNBnLeHlrv81ZJi91saloWPDEAa4R4b+b/Qfa0St56s+TXIReb1fKkNWAgt2lXG269sAi7pKpZm7bXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W+s95epj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W+s95epj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777382328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uhi8kKMsF6kc+1iDdDV2ShwjmP4JKPaFHP00k+w/m/Q=;
	b=W+s95epjgywIAx5A4VWC3gg3KX6tYRSd2+WP7LPZdyijD+JcT4dc+6jqvo5kKzkBAlFJ4w
	Ei2A4gsls6vfshiforl1ByyuDL7utLgei2O5Q05g7kvDJpKetxCb2iTB6hvWMKbu3CP9iy
	trV9Iuo6hN3nZY71XUrFiHJM4mz9IlU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-4-4frwHBOLyANWMlho6SWw-1; Tue,
 28 Apr 2026 09:18:40 -0400
X-MC-Unique: 4-4frwHBOLyANWMlho6SWw-1
X-Mimecast-MFC-AGG-ID: 4-4frwHBOLyANWMlho6SWw_1777382319
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8774E191FE8F;
	Tue, 28 Apr 2026 13:18:07 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 81D681800348;
	Tue, 28 Apr 2026 13:18:04 +0000 (UTC)
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
Subject: [PATCH v5 01/24] netfs: Fix cancellation of a DIO and single read subrequests
Date: Tue, 28 Apr 2026 14:17:31 +0100
Message-ID: <20260428131756.922303-2-dhowells@redhat.com>
In-Reply-To: <20260428131756.922303-1-dhowells@redhat.com>
References: <20260428131756.922303-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

When the preparation of a new subrequest for a read fails, if the
subrequest has already been added to the stream->subrequests list, it can't
simply be put and abandoned as the collector may see it.  Also, if it
hasn't been queued yet, it has two outstanding refs that both need to be
put.  Both DIO read and single-read dispatch fail at this; further, both
differ in the order they do things to the way buffered read works.

Fix cancellation of both DIO-read and single-read subrequests that failed
preparation by the following steps:

 (1) Harmonise all three reads (buffered, dio, single) to queue the subreq
     before prepping it.

 (2) Make all three call netfs_queue_read() to do the queuing.

 (3) Set NETFS_RREQ_ALL_QUEUED independently of the queuing as we don't
     know the length of the subreq at this point.

 (4) In all cases, set the error and NETFS_SREQ_FAILED flag on the subreq
     and then call netfs_read_subreq_terminated() to deal with it.  This
     will pass responsibility off to the collector for dealing with it.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Closes: https://sashiko.dev/#/patchset/20260425125426.3855807-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c | 33 ++++++++++++-------------------
 fs/netfs/direct_read.c   | 42 +++++++++++++---------------------------
 fs/netfs/internal.h      |  3 +++
 fs/netfs/read_collect.c  | 11 +++++++++++
 fs/netfs/read_single.c   | 23 ++++++++++------------
 5 files changed, 49 insertions(+), 63 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index a8c0d86118c5..286c93fc681e 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -156,9 +156,8 @@ static void netfs_read_cache_to_pagecache(struct netfs_io_request *rreq,
 			netfs_cache_read_terminated, subreq);
 }
 
-static void netfs_queue_read(struct netfs_io_request *rreq,
-			     struct netfs_io_subrequest *subreq,
-			     bool last_subreq)
+void netfs_queue_read(struct netfs_io_request *rreq,
+		      struct netfs_io_subrequest *subreq)
 {
 	struct netfs_io_stream *stream = &rreq->io_streams[0];
 
@@ -178,11 +177,6 @@ static void netfs_queue_read(struct netfs_io_request *rreq,
 		}
 	}
 
-	if (last_subreq) {
-		smp_wmb(); /* Write lists before ALL_QUEUED. */
-		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
-	}
-
 	spin_unlock(&rreq->lock);
 }
 
@@ -233,6 +227,8 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		subreq->start	= start;
 		subreq->len	= size;
 
+		netfs_queue_read(rreq, subreq);
+
 		source = netfs_cache_prepare_read(rreq, subreq, rreq->i_size);
 		subreq->source = source;
 		if (source == NETFS_DOWNLOAD_FROM_SERVER) {
@@ -253,6 +249,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 				       rreq->debug_id, subreq->debug_index,
 				       subreq->len, size,
 				       subreq->start, ictx->zero_point, rreq->i_size);
+				netfs_cancel_read(subreq, ret);
 				break;
 			}
 			subreq->len = len;
@@ -261,12 +258,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 			if (rreq->netfs_ops->prepare_read) {
 				ret = rreq->netfs_ops->prepare_read(subreq);
 				if (ret < 0) {
-					subreq->error = ret;
-					/* Not queued - release both refs. */
-					netfs_put_subrequest(subreq,
-							     netfs_sreq_trace_put_cancel);
-					netfs_put_subrequest(subreq,
-							     netfs_sreq_trace_put_cancel);
+					netfs_cancel_read(subreq, ret);
 					break;
 				}
 				trace_netfs_sreq(subreq, netfs_sreq_trace_prepare);
@@ -295,17 +287,16 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		slice = netfs_prepare_read_iterator(subreq, ractl);
 		if (slice < 0) {
 			ret = slice;
-			subreq->error = ret;
-			trace_netfs_sreq(subreq, netfs_sreq_trace_cancel);
-			/* Not queued - release both refs. */
-			netfs_put_subrequest(subreq, netfs_sreq_trace_put_cancel);
-			netfs_put_subrequest(subreq, netfs_sreq_trace_put_cancel);
+			netfs_cancel_read(subreq, ret);
 			break;
 		}
-		size -= slice;
 		start += slice;
+		size -= slice;
+		if (size <= 0) {
+			smp_wmb(); /* Write lists before ALL_QUEUED. */
+			set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+		}
 
-		netfs_queue_read(rreq, subreq, size <= 0);
 		netfs_issue_read(rreq, subreq);
 		cond_resched();
 	} while (size > 0);
diff --git a/fs/netfs/direct_read.c b/fs/netfs/direct_read.c
index f72e6da88cca..6a8fb0d55e04 100644
--- a/fs/netfs/direct_read.c
+++ b/fs/netfs/direct_read.c
@@ -45,12 +45,11 @@ static void netfs_prepare_dio_read_iterator(struct netfs_io_subrequest *subreq)
  * Perform a read to a buffer from the server, slicing up the region to be read
  * according to the network rsize.
  */
-static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
+static void netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 {
-	struct netfs_io_stream *stream = &rreq->io_streams[0];
 	unsigned long long start = rreq->start;
 	ssize_t size = rreq->len;
-	int ret = 0;
+	int ret;
 
 	do {
 		struct netfs_io_subrequest *subreq;
@@ -58,7 +57,10 @@ static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 
 		subreq = netfs_alloc_subrequest(rreq);
 		if (!subreq) {
-			ret = -ENOMEM;
+			/* Stash the error in the request if there's not
+			 * already an error set.
+			 */
+			cmpxchg(&rreq->error, 0, -ENOMEM);
 			break;
 		}
 
@@ -66,25 +68,13 @@ static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 		subreq->start	= start;
 		subreq->len	= size;
 
-		__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
-
-		spin_lock(&rreq->lock);
-		list_add_tail(&subreq->rreq_link, &stream->subrequests);
-		if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
-			if (!stream->active) {
-				stream->collected_to = subreq->start;
-				/* Store list pointers before active flag */
-				smp_store_release(&stream->active, true);
-			}
-		}
-		trace_netfs_sreq(subreq, netfs_sreq_trace_added);
-		spin_unlock(&rreq->lock);
+		netfs_queue_read(rreq, subreq);
 
 		netfs_stat(&netfs_n_rh_download);
 		if (rreq->netfs_ops->prepare_read) {
 			ret = rreq->netfs_ops->prepare_read(subreq);
 			if (ret < 0) {
-				netfs_put_subrequest(subreq, netfs_sreq_trace_put_cancel);
+				netfs_cancel_read(subreq, ret);
 				break;
 			}
 		}
@@ -113,8 +103,6 @@ static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 		netfs_wake_collector(rreq);
 	}
-
-	return ret;
 }
 
 /*
@@ -137,21 +125,17 @@ static ssize_t netfs_unbuffered_read(struct netfs_io_request *rreq, bool sync)
 	// TODO: Use bounce buffer if requested
 
 	inode_dio_begin(rreq->inode);
+	netfs_dispatch_unbuffered_reads(rreq);
 
-	ret = netfs_dispatch_unbuffered_reads(rreq);
-
-	if (!rreq->submitted) {
-		netfs_put_request(rreq, netfs_rreq_trace_put_no_submit);
-		inode_dio_end(rreq->inode);
-		ret = 0;
-		goto out;
-	}
+	/* The collector will get run, even if we don't manage to submit any
+	 * subreqs, so we shouldn't call inode_dio_end() here.
+	 */
 
 	if (sync)
 		ret = netfs_wait_for_read(rreq);
 	else
 		ret = -EIOCBQUEUED;
-out:
+
 	_leave(" = %zd", ret);
 	return ret;
 }
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index d436e20d3418..645996ecfc80 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -23,6 +23,8 @@
 /*
  * buffered_read.c
  */
+void netfs_queue_read(struct netfs_io_request *rreq,
+		      struct netfs_io_subrequest *subreq);
 void netfs_cache_read_terminated(void *priv, ssize_t transferred_or_error);
 int netfs_prefetch_for_write(struct file *file, struct folio *folio,
 			     size_t offset, size_t len);
@@ -108,6 +110,7 @@ static inline void netfs_see_subrequest(struct netfs_io_subrequest *subreq,
  */
 bool netfs_read_collection(struct netfs_io_request *rreq);
 void netfs_read_collection_worker(struct work_struct *work);
+void netfs_cancel_read(struct netfs_io_subrequest *subreq, int error);
 void netfs_cache_read_terminated(void *priv, ssize_t transferred_or_error);
 
 /*
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index e5f6665b3341..d2d902f46627 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -575,6 +575,17 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
 }
 EXPORT_SYMBOL(netfs_read_subreq_terminated);
 
+/*
+ * Cancel a read subrequest due to preparation failure.
+ */
+void netfs_cancel_read(struct netfs_io_subrequest *subreq, int error)
+{
+	trace_netfs_sreq(subreq, netfs_sreq_trace_cancel);
+	subreq->error = error;
+	__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+	netfs_read_subreq_terminated(subreq);
+}
+
 /*
  * Handle termination of a read from the cache.
  */
diff --git a/fs/netfs/read_single.c b/fs/netfs/read_single.c
index d0e23bc42445..8833550d2eb6 100644
--- a/fs/netfs/read_single.c
+++ b/fs/netfs/read_single.c
@@ -89,7 +89,6 @@ static void netfs_single_read_cache(struct netfs_io_request *rreq,
  */
 static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 {
-	struct netfs_io_stream *stream = &rreq->io_streams[0];
 	struct netfs_io_subrequest *subreq;
 	int ret = 0;
 
@@ -102,14 +101,7 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 	subreq->len	= rreq->len;
 	subreq->io_iter	= rreq->buffer.iter;
 
-	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
-
-	spin_lock(&rreq->lock);
-	list_add_tail(&subreq->rreq_link, &stream->subrequests);
-	trace_netfs_sreq(subreq, netfs_sreq_trace_added);
-	/* Store list pointers before active flag */
-	smp_store_release(&stream->active, true);
-	spin_unlock(&rreq->lock);
+	netfs_queue_read(rreq, subreq);
 
 	netfs_single_cache_prepare_read(rreq, subreq);
 	switch (subreq->source) {
@@ -121,10 +113,14 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 				goto cancel;
 		}
 
+		smp_wmb(); /* Write lists before ALL_QUEUED. */
+		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 		rreq->netfs_ops->issue_read(subreq);
 		rreq->submitted += subreq->len;
 		break;
 	case NETFS_READ_FROM_CACHE:
+		smp_wmb(); /* Write lists before ALL_QUEUED. */
+		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 		trace_netfs_sreq(subreq, netfs_sreq_trace_submit);
 		netfs_single_read_cache(rreq, subreq);
 		rreq->submitted += subreq->len;
@@ -134,14 +130,15 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 		pr_warn("Unexpected single-read source %u\n", subreq->source);
 		WARN_ON_ONCE(true);
 		ret = -EIO;
-		break;
+		goto cancel;
 	}
 
-	smp_wmb(); /* Write lists before ALL_QUEUED. */
-	set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 	return ret;
 cancel:
-	netfs_put_subrequest(subreq, netfs_sreq_trace_put_cancel);
+	netfs_cancel_read(subreq, ret);
+	smp_wmb(); /* Write lists before ALL_QUEUED. */
+	set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+	netfs_wake_collector(rreq);
 	return ret;
 }
 

