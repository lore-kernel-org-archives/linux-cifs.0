Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D501F39C63E
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121763; cv=none; b=Bz+5hh4Y4aVNEtO7nYC0Dh1Gagh4Vw5bTMWJzk/qOUjqzgHmXS0FaeyGUYSvSO8h6EGxoWz2w7RPaCBHMEx7ftV/+mm/Wq+huE5a9t3HvfRs5INO6k7YS+ITGfK/vvqQzjT2H/5kE5u3HNZeqxHJYkFi0WMKxWM3v0B2G8KeRoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121763; c=relaxed/simple;
	bh=5ISMkGKNoZx7CCpTebv8PWFiif0nSO2252s6L20Gm9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhMK+jehJVl1l/kLaATFVvnNhLFgbez0n1uu7bxBuwccidJZBXbNpoFSL2VQDRaRYp6kZqG8Nr7XxaS0XHT2Ky+cy0CSwX2AaaiED+gUCAMB+brYHd5pYzEV93QQDRjYTDg1IPbUTB2RFWD4Q8JDJLd4FmurJhR72GUzzNeqamQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=awinhnkn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="awinhnkn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kGNOdLG+r8cO2/J2gGfuyvyMT5Ixtk3iTE5O/NcMFjA=;
	b=awinhnkngtTx3DYGv9v96I/2PwLJ4TsPnzuUuUZ+uzf3/DJKJnZj0h/6sgRgGpV41RFkQk
	XbPGBbBuguZQDQ3odw9BwuWx7swcl1XVRO5BIr+oojnixYzHWeslM39j7iTKSNbIB68Z3Y
	BeTB1yuNkK2P64RcCuZbrBcvhxG27zk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-110-7CyjIUyZM8i-NFPYXkIfiQ-1; Sat,
 25 Apr 2026 08:55:57 -0400
X-MC-Unique: 7CyjIUyZM8i-NFPYXkIfiQ-1
X-Mimecast-MFC-AGG-ID: 7CyjIUyZM8i-NFPYXkIfiQ_1777121756
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FD93180034F;
	Sat, 25 Apr 2026 12:55:56 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6AFF2300757C;
	Sat, 25 Apr 2026 12:55:53 +0000 (UTC)
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
Subject: [PATCH v3 17/19] netfs: Fix missing barriers when accessing stream->subrequests locklessly
Date: Sat, 25 Apr 2026 13:54:21 +0100
Message-ID: <20260425125426.3855807-18-dhowells@redhat.com>
In-Reply-To: <20260425125426.3855807-1-dhowells@redhat.com>
References: <20260425125426.3855807-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The list of subrequests attached to stream->subrequests is accessed without
locks by netfs_collect_read_results() and netfs_collect_write_results(),
but they access subreq->flags without taking a barrier after getting the
subreq pointer from the list.  Relatedly, the functions that build the list
don't use any sort of write barrier when constructing the list to make sure
that the NETFS_SREQ_IN_PROGRESS flag is perceived to be set first if no
lock is taken.

Fix this by:

 (1) Add a new list_add_tail_release() function that uses a release barrier
     to set the pointer to the new member of the list.

 (2) Add a new list_first_entry_acquire() function that uses an acquire
     barrier to read the pointer to the first member in a list (or return
     NULL).

 (3) Use list_add_tail_release() when adding a subreq to ->subrequests.

 (4) Make direct-read and read-single use netfs_queue_read() so that they
     share the relevant bit of code with buffered-read.

 (5) Use list_first_entry_acquire() when initially accessing the front of
     the list (when an item is removed, the pointer to the new front iterm
     is obtained under the same lock).

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Link: https://sashiko.dev/#/patchset/20260326104544.509518-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c |  9 +++++----
 fs/netfs/direct_read.c   | 15 +--------------
 fs/netfs/internal.h      |  3 +++
 fs/netfs/read_collect.c  |  4 +++-
 fs/netfs/read_single.c   | 12 +-----------
 fs/netfs/write_collect.c |  4 +++-
 fs/netfs/write_issue.c   |  3 ++-
 include/linux/list.h     | 37 +++++++++++++++++++++++++++++++++++++
 8 files changed, 55 insertions(+), 32 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 2de849bd780f..7e7dacded8f7 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -156,9 +156,9 @@ static void netfs_read_cache_to_pagecache(struct netfs_io_request *rreq,
 			netfs_cache_read_terminated, subreq);
 }
 
-static void netfs_queue_read(struct netfs_io_request *rreq,
-			     struct netfs_io_subrequest *subreq,
-			     bool last_subreq)
+void netfs_queue_read(struct netfs_io_request *rreq,
+		      struct netfs_io_subrequest *subreq,
+		      bool last_subreq)
 {
 	struct netfs_io_stream *stream = &rreq->io_streams[0];
 
@@ -169,7 +169,8 @@ static void netfs_queue_read(struct netfs_io_request *rreq,
 	 * remove entries off of the front.
 	 */
 	spin_lock(&rreq->lock);
-	list_add_tail(&subreq->rreq_link, &stream->subrequests);
+	/* Write IN_PROGRESS before pointer to new subreq */
+	list_add_tail_release(&subreq->rreq_link, &stream->subrequests);
 	if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
 		if (!stream->active) {
 			stream->collected_to = subreq->start;
diff --git a/fs/netfs/direct_read.c b/fs/netfs/direct_read.c
index f72e6da88cca..69a1a1e26143 100644
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
@@ -66,19 +65,7 @@ static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
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
+		netfs_queue_read(rreq, subreq, false);
 
 		netfs_stat(&netfs_n_rh_download);
 		if (rreq->netfs_ops->prepare_read) {
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index d436e20d3418..964479335ff7 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -23,6 +23,9 @@
 /*
  * buffered_read.c
  */
+void netfs_queue_read(struct netfs_io_request *rreq,
+		      struct netfs_io_subrequest *subreq,
+		      bool last_subreq);
 void netfs_cache_read_terminated(void *priv, ssize_t transferred_or_error);
 int netfs_prefetch_for_write(struct file *file, struct folio *folio,
 			     size_t offset, size_t len);
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index eae067e3eaa5..5847796b54ec 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -205,8 +205,10 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 	 * in progress.  The issuer thread may be adding stuff to the tail
 	 * whilst we're doing this.
 	 */
-	front = list_first_entry_or_null(&stream->subrequests,
+	front = list_first_entry_acquire(&stream->subrequests,
 					 struct netfs_io_subrequest, rreq_link);
+	/* Read first subreq pointer before IN_PROGRESS flag. */
+
 	while (front) {
 		size_t transferred;
 
diff --git a/fs/netfs/read_single.c b/fs/netfs/read_single.c
index d0e23bc42445..30e184caadb2 100644
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
+	netfs_queue_read(rreq, subreq, true);
 
 	netfs_single_cache_prepare_read(rreq, subreq);
 	switch (subreq->source) {
@@ -137,8 +129,6 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 		break;
 	}
 
-	smp_wmb(); /* Write lists before ALL_QUEUED. */
-	set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 	return ret;
 cancel:
 	netfs_put_subrequest(subreq, netfs_sreq_trace_put_cancel);
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 4718e5174d65..f0cafa1d5835 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -227,8 +227,10 @@ static void netfs_collect_write_results(struct netfs_io_request *wreq)
 		if (!smp_load_acquire(&stream->active))
 			continue;
 
-		front = list_first_entry_or_null(&stream->subrequests,
+		front = list_first_entry_acquire(&stream->subrequests,
 						 struct netfs_io_subrequest, rreq_link);
+		/* Read first subreq pointer before IN_PROGRESS flag. */
+
 		while (front) {
 			trace_netfs_collect_sreq(wreq, front);
 			//_debug("sreq [%x] %llx %zx/%zx",
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 2db688f94125..b0e9690bb90c 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -204,7 +204,8 @@ void netfs_prepare_write(struct netfs_io_request *wreq,
 	 * remove entries off of the front.
 	 */
 	spin_lock(&wreq->lock);
-	list_add_tail(&subreq->rreq_link, &stream->subrequests);
+	/* Write IN_PROGRESS before pointer to new subreq */
+	list_add_tail_release(&subreq->rreq_link, &stream->subrequests);
 	if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
 		if (!stream->active) {
 			stream->collected_to = subreq->start;
diff --git a/include/linux/list.h b/include/linux/list.h
index 00ea8e5fb88b..5af356efd725 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -191,6 +191,29 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
 	__list_add(new, head->prev, head);
 }
 
+/**
+ * list_add_tail_release - add a new entry with release barrier
+ * @new: new entry to be added
+ * @head: list head to add it before
+ *
+ * Insert a new entry before the specified head, using a release barrier to set
+ * the ->next pointer that points to it.  This is useful for implementing
+ * queues, in particular one that the elements will be walked through forwards
+ * locklessly.
+ */
+static inline void list_add_tail_release(struct list_head *new,
+					 struct list_head *head)
+{
+	struct list_head *prev = head->prev;
+
+	if (__list_add_valid(new, prev, head)) {
+		new->next = head;
+		new->prev = prev;
+		head->prev = new;
+		smp_store_release(&prev->next, new);
+	}
+}
+
 /*
  * Delete a list entry by making the prev/next entries
  * point to each other.
@@ -644,6 +667,20 @@ static inline void list_splice_tail_init(struct list_head *list,
 	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
 })
 
+/**
+ * list_first_entry_acquire - get the first element from a list with barrier
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Note that if the list is empty, it returns NULL.
+ */
+#define list_first_entry_acquire(ptr, type, member) ({ \
+	struct list_head *head__ = (ptr); \
+	struct list_head *pos__ = smp_load_acquire(&head__->next); \
+	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
+})
+
 /**
  * list_last_entry_or_null - get the last element from a list
  * @ptr:	the list head to take the element from.

