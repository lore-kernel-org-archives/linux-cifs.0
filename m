Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4823469FC
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777304816; cv=none; b=Dc5MopIEU+K5ejIn/+FkxEEvV4cD/zZI440urTGs2Jft6pNsmok4nC6ioljpg2oanCuvjgVH0oo/HXqaRQ4o7PjevSmbjeEOwhL6uEDHp3IDW0vJNAbpqWbRxmzVBktNFp1JdYIDP0KBZQQ7cTAl3WIq1+RZo2FpfQ5OFFxkC2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777304816; c=relaxed/simple;
	bh=MBV+gcvxIoEEQ+AAmirehOHfdTWrL3EvsI56zQBg4Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlOgp1SDXdvKy1N9Wujpr8wAfpGr8EwvU0stubvqcv+9NoM1J6xQX6ZutiKGOxKcvEsqYBTb+oA05HGc7Vajup8bH7oUdwzX/O0f5Rv7FfiUQ2T1Kvbxo/rgl2hjBXayPxloaI2F5nsZcJhIypDpAz2jXWulnKJ3p0mVDGvYSDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XZiNVdrr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XZiNVdrr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777304814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u9RMsSgh/DXZPAvKktBs27mDcdJgglZsfz7/ceNESHA=;
	b=XZiNVdrrz7uQ/PxIIyTQ/E/X/XlAaPQXE9E53gqWVXDVRchGzpQVg9yKFEtYFezlwkDTav
	eYkT00WXb6KjjQ1p85Bbm7uBtfd/h3Z5iMLN4tvEbVYNIbTgea6t8X95pP9GvEcAuWJJjx
	ZXVj6PI8cppYtjFJDK4E44it2zosE2s=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-2k7FS481MReU8Yefq02IXA-1; Mon,
 27 Apr 2026 11:46:51 -0400
X-MC-Unique: 2k7FS481MReU8Yefq02IXA-1
X-Mimecast-MFC-AGG-ID: 2k7FS481MReU8Yefq02IXA_1777304809
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90C2918002C0;
	Mon, 27 Apr 2026 15:46:49 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DD1CF1800446;
	Mon, 27 Apr 2026 15:46:46 +0000 (UTC)
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
Subject: [PATCH v4 01/22] netfs: Fix cancellation of a DIO and single read subrequests
Date: Mon, 27 Apr 2026 16:46:16 +0100
Message-ID: <20260427154639.180684-2-dhowells@redhat.com>
In-Reply-To: <20260427154639.180684-1-dhowells@redhat.com>
References: <20260427154639.180684-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
 fs/netfs/buffered_read.c | 26 +++++++++++---------------
 fs/netfs/direct_read.c   | 19 ++++---------------
 fs/netfs/internal.h      |  2 ++
 fs/netfs/read_single.c   | 20 ++++++++------------
 4 files changed, 25 insertions(+), 42 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index a8c0d86118c5..2c51c55a9b15 100644
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
@@ -262,11 +258,8 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 				ret = rreq->netfs_ops->prepare_read(subreq);
 				if (ret < 0) {
 					subreq->error = ret;
-					/* Not queued - release both refs. */
-					netfs_put_subrequest(subreq,
-							     netfs_sreq_trace_put_cancel);
-					netfs_put_subrequest(subreq,
-							     netfs_sreq_trace_put_cancel);
+					__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+					netfs_read_subreq_terminated(subreq);
 					break;
 				}
 				trace_netfs_sreq(subreq, netfs_sreq_trace_prepare);
@@ -302,10 +295,13 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 			netfs_put_subrequest(subreq, netfs_sreq_trace_put_cancel);
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
index f72e6da88cca..4fd5cfa690cf 100644
--- a/fs/netfs/direct_read.c
+++ b/fs/netfs/direct_read.c
@@ -47,7 +47,6 @@ static void netfs_prepare_dio_read_iterator(struct netfs_io_subrequest *subreq)
  */
 static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 {
-	struct netfs_io_stream *stream = &rreq->io_streams[0];
 	unsigned long long start = rreq->start;
 	ssize_t size = rreq->len;
 	int ret = 0;
@@ -66,25 +65,15 @@ static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
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
+				__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+				subreq->error = ret;
+				netfs_read_subreq_terminated(subreq);
 				break;
 			}
 		}
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index d436e20d3418..24fefa1b179d 100644
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
diff --git a/fs/netfs/read_single.c b/fs/netfs/read_single.c
index d0e23bc42445..432c7456a1b6 100644
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
@@ -137,11 +133,11 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 		break;
 	}
 
-	smp_wmb(); /* Write lists before ALL_QUEUED. */
-	set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 	return ret;
 cancel:
-	netfs_put_subrequest(subreq, netfs_sreq_trace_put_cancel);
+	__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+	subreq->error = ret;
+	netfs_read_subreq_terminated(subreq);
 	return ret;
 }
 

