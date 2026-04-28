Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC91347276B
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 13:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382351; cv=none; b=CWteT6rBe3okmWsrFtUDn8BHIYcqQFSzH+/EvZcnSbLTwLmQvYheBFg4rxxK07kHWj5WD08eIU30jNco3TSfA0/3vXcwvXRVFSHCP//tUcMnfI4A6+Y/nXQX5t0vpW3RzzBeWegHbnGBc9/W2gaQ0UCoS6De4xaXeNhKQaihkC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382351; c=relaxed/simple;
	bh=eC23EDiq5qIGKq4ga5PcDMq7oBfvyAuTD3k4pCVIMa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2nLu+Im+9xFZNVolVy+Fy5U6hensM+aWpdRp+bRN402hrfJwYiWcdUQqkUIwjfhBu3O3HjVZJXTebNUqkl/tn6kmvVCo9VGMl1mCaWoRzBpbccwCLDzsPs3ftlzMNBuwcQqLtybPIdpqp7e8uEU701eqH1cQlhL8nEM4tgcpas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YzVF/04o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YzVF/04o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777382348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i68buiFPTMRi+TuWqayB/dF5laOKYLtNXEY9ZJMxAJg=;
	b=YzVF/04oxR0+M7QyMEZCsDYKsUeyhcKmkoxrHZ+LxXGhQzDUOZPhRmtKEpNUBTqKcyvxtH
	S6OornuP5TylfCjP01dQkW3k/NG1MSd+lazAdvSKsKe5MIgTy+19xRpBUtXc/8K+eoo+w7
	Lo3G+xfZePkfg2XSrKbeVVZFG5KMjKs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-138-S5GolzNdN86Oer4dIiRNcw-1; Tue,
 28 Apr 2026 09:19:05 -0400
X-MC-Unique: S5GolzNdN86Oer4dIiRNcw-1
X-Mimecast-MFC-AGG-ID: S5GolzNdN86Oer4dIiRNcw_1777382344
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3732C1805A01;
	Tue, 28 Apr 2026 13:18:17 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4B33C196B8FC;
	Tue, 28 Apr 2026 13:18:14 +0000 (UTC)
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
Subject: [PATCH v5 03/24] netfs: Fix missing barriers when accessing stream->subrequests locklessly
Date: Tue, 28 Apr 2026 14:17:33 +0100
Message-ID: <20260428131756.922303-4-dhowells@redhat.com>
In-Reply-To: <20260428131756.922303-1-dhowells@redhat.com>
References: <20260428131756.922303-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The list of subrequests attached to stream->subrequests is accessed without
locks by netfs_collect_read_results() and netfs_collect_write_results(),
and then they access subreq->flags without taking a barrier after getting
the subreq pointer from the list.  Relatedly, the functions that build the
list don't use any sort of write barrier when constructing the list to make
sure that the NETFS_SREQ_IN_PROGRESS flag is perceived to be set first if
no lock is taken.

Fix this by:

 (1) Add a new list_add_tail_release() function that uses a release barrier
     to set the pointer to the new member of the list.

 (2) Add a new list_first_entry_or_null_acquire() function that uses an
     acquire barrier to read the pointer to the first member in a list (or
     return NULL).

 (3) Use list_add_tail_release() when adding a subreq to ->subrequests.

 (4) Use list_first_entry_or_null_acquire() when initially accessing the
     front of the list (when an item is removed, the pointer to the new
     front iterm is obtained under the same lock).

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Link: https://sashiko.dev/#/patchset/20260326104544.509518-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c |  3 ++-
 fs/netfs/misc.c          |  1 +
 fs/netfs/read_collect.c  |  6 ++++--
 fs/netfs/write_collect.c |  6 ++++--
 fs/netfs/write_issue.c   |  3 ++-
 include/linux/list.h     | 37 +++++++++++++++++++++++++++++++++++++
 6 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 286c93fc681e..7ec11893552d 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -168,7 +168,8 @@ void netfs_queue_read(struct netfs_io_request *rreq,
 	 * remove entries off of the front.
 	 */
 	spin_lock(&rreq->lock);
-	list_add_tail(&subreq->rreq_link, &stream->subrequests);
+	/* Write IN_PROGRESS before pointer to new subreq */
+	list_add_tail_release(&subreq->rreq_link, &stream->subrequests);
 	if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
 		if (!stream->active) {
 			stream->collected_to = subreq->start;
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 6df89c92b10b..21357907b7ee 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -356,6 +356,7 @@ void netfs_wait_for_in_progress_stream(struct netfs_io_request *rreq,
 	DEFINE_WAIT(myself);
 
 	list_for_each_entry(subreq, &stream->subrequests, rreq_link) {
+		smp_rmb(); /* Read ->next before IN_PROGRESS. */
 		if (!netfs_check_subreq_in_progress(subreq))
 			continue;
 
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index d2d902f46627..3c9b847885c2 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -205,8 +205,10 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 	 * in progress.  The issuer thread may be adding stuff to the tail
 	 * whilst we're doing this.
 	 */
-	front = list_first_entry_or_null(&stream->subrequests,
-					 struct netfs_io_subrequest, rreq_link);
+	front = list_first_entry_or_null_acquire(&stream->subrequests,
+						 struct netfs_io_subrequest, rreq_link);
+	/* Read first subreq pointer before IN_PROGRESS flag. */
+
 	while (front) {
 		size_t transferred;
 
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index b194447f4b11..7fbf50907a7f 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -228,8 +228,10 @@ static void netfs_collect_write_results(struct netfs_io_request *wreq)
 		if (!smp_load_acquire(&stream->active))
 			continue;
 
-		front = list_first_entry_or_null(&stream->subrequests,
-						 struct netfs_io_subrequest, rreq_link);
+		front = list_first_entry_or_null_acquire(&stream->subrequests,
+							 struct netfs_io_subrequest, rreq_link);
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
index 00ea8e5fb88b..09d979976b3b 100644
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
+ * list_first_entry_or_null_acquire - get the first element from a list with barrier
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Note that if the list is empty, it returns NULL.
+ */
+#define list_first_entry_or_null_acquire(ptr, type, member) ({ \
+	struct list_head *head__ = (ptr); \
+	struct list_head *pos__ = smp_load_acquire(&head__->next); \
+	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
+})
+
 /**
  * list_last_entry_or_null - get the last element from a list
  * @ptr:	the list head to take the element from.

