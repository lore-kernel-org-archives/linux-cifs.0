Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177EA411F81
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 13:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785157701; cv=none; b=WXE/3tufzCdpwL0AUxxVQKMT86p8PTI/mK6EVoU0y9Qk8+tds0Tj0qDz9teZM2AaryMPe17Ua5Tkf4PuaBncEwZ1iH9wLIAdJh0s85RCFfgtETl9qe0qflq7syE47ntejqbI9qRQc/cFwDIjU61or4RxJiRQz5zSWndmIshcn24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785157701; c=relaxed/simple;
	bh=2wnQl3dDQRldsvBPML7JtFnhEAD1rjFdBRvGQQvPI30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGTfo477qWopJSAyBzPkuK51UPmI6wU/hI0W8Yf1+Gl5Zw8Cct8L6xw3WoEkrG3FEjAWZqwkAca/RTLLk4ZITr+mrAkFxRttSgSJ1TQ5NLIa7lk0EF5QqManflNmZT+sNvN1d7zVUmwrUr3JT9VetAjfL1HfG5F+WEGSkg/rEg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fzRZAVmE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fzRZAVmE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785157698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JEjFOgu+/acrb321tynAnZZWtqfZT79BXOE4gL4kLO0=;
	b=fzRZAVmEFIDr/F7qMdvcWnWuMk3KgTfiNYxz6e7fYio8JuUb/N/cCmd8UBxm51QCrdNPhB
	uGuO338fF7I8lGY1biB54oR51W9ZQvgJS0rjXhNP1TaGPv51CL8WUgCDTJbe9AxcA1s5vs
	kYSHlWLgILC6fwCB9gCSBv3ILK6N9Jg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-656-XvklwJSBPeKNTHthq13cuQ-1; Mon,
 27 Jul 2026 09:08:14 -0400
X-MC-Unique: XvklwJSBPeKNTHthq13cuQ-1
X-Mimecast-MFC-AGG-ID: XvklwJSBPeKNTHthq13cuQ_1785157693
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADB1E1801A0E;
	Mon, 27 Jul 2026 13:08:12 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E39EA30010C8;
	Mon, 27 Jul 2026 13:08:08 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Christoph Hellwig <hch@infradead.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+0da43efa72f88bd3a8af@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 4/4] netfs: Fix folio_queue ENOMEM in writeback by adding a mempool
Date: Mon, 27 Jul 2026 14:07:15 +0100
Message-ID: <20260727130716.1099906-5-dhowells@redhat.com>
In-Reply-To: <20260727130716.1099906-1-dhowells@redhat.com>
References: <20260727130716.1099906-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Fix the handling of folio_queue allocation failure in writeback by adding a
mempool and passing in gfp_t flags to the rolling buffer functions that
allocate memory, using the mempool if gfp != GFP_KERNEL.

This is then extended upwards and the gfp to be used for a request is stored
in the netfs_io_request struct and is then used for both requests and
subrequests, eliminating the sleeping loops there.

The failure caused:

    folio != NULL
    WARNING: fs/netfs/write_issue.c:603 at netfs_writepages+0x883/0xa10 fs/netfs/write_issue.c:603, CPU#3: syz.0.17/5919

Fixes: cd0277ed0c18 ("netfs: Use new folio_queue data type and iterator instead of xarray iter")
Reported-by: syzbot+0da43efa72f88bd3a8af@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0da43efa72f88bd3a8af
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: syzbot+0da43efa72f88bd3a8af@syzkaller.appspotmail.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Yun Zhou <yun.zhou@windriver.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c       |  6 +++---
 fs/netfs/internal.h            |  1 +
 fs/netfs/main.c                |  7 +++++++
 fs/netfs/objects.c             | 31 +++++++++++++++++++------------
 fs/netfs/read_pgpriv2.c        |  2 +-
 fs/netfs/rolling_buffer.c      | 21 ++++++++++++---------
 fs/netfs/write_issue.c         | 10 +++++-----
 include/linux/netfs.h          |  1 +
 include/linux/rolling_buffer.h |  6 +++---
 9 files changed, 52 insertions(+), 33 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 3d86414ee40f..7fdfa4f27e34 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -361,7 +361,7 @@ void netfs_readahead(struct readahead_control *ractl)
 	netfs_rreq_expand(rreq, ractl);
 
 	rreq->submitted = rreq->start;
-	if (rolling_buffer_init(&rreq->buffer, rreq->debug_id, ITER_DEST) < 0)
+	if (rolling_buffer_init(&rreq->buffer, rreq->debug_id, ITER_DEST, rreq->gfp) < 0)
 		goto cleanup_free;
 	netfs_read_to_pagecache(rreq, ractl);
 
@@ -380,10 +380,10 @@ static int netfs_create_singular_buffer(struct netfs_io_request *rreq, struct fo
 {
 	ssize_t added;
 
-	if (rolling_buffer_init(&rreq->buffer, rreq->debug_id, ITER_DEST) < 0)
+	if (rolling_buffer_init(&rreq->buffer, rreq->debug_id, ITER_DEST, rreq->gfp) < 0)
 		return -ENOMEM;
 
-	added = rolling_buffer_append(&rreq->buffer, folio, rollbuf_flags);
+	added = rolling_buffer_append(&rreq->buffer, folio, rollbuf_flags, rreq->gfp);
 	if (added < 0)
 		return added;
 	rreq->submitted = rreq->start + added;
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index d889caa401dc..420ee7b26580 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -43,6 +43,7 @@ extern struct list_head netfs_io_requests;
 extern spinlock_t netfs_proc_lock;
 extern mempool_t netfs_request_pool;
 extern mempool_t netfs_subrequest_pool;
+extern mempool_t netfs_folioq_pool;
 
 #ifdef CONFIG_PROC_FS
 static inline void netfs_proc_add_rreq(struct netfs_io_request *rreq)
diff --git a/fs/netfs/main.c b/fs/netfs/main.c
index 73da6c9f5777..927badf3989d 100644
--- a/fs/netfs/main.c
+++ b/fs/netfs/main.c
@@ -28,6 +28,7 @@ static struct kmem_cache *netfs_request_slab;
 static struct kmem_cache *netfs_subrequest_slab;
 mempool_t netfs_request_pool;
 mempool_t netfs_subrequest_pool;
+mempool_t netfs_folioq_pool;
 
 #ifdef CONFIG_PROC_FS
 LIST_HEAD(netfs_io_requests);
@@ -108,6 +109,9 @@ static int __init netfs_init(void)
 {
 	int ret = -ENOMEM;
 
+	if (mempool_init_kmalloc_pool(&netfs_folioq_pool, 100, sizeof(struct folio_queue)) < 0)
+		goto error_folioq_pool;
+
 	netfs_request_slab = kmem_cache_create("netfs_request",
 					       sizeof(struct netfs_io_request), 0,
 					       SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT,
@@ -160,6 +164,8 @@ static int __init netfs_init(void)
 error_reqpool:
 	kmem_cache_destroy(netfs_request_slab);
 error_req:
+	mempool_exit(&netfs_folioq_pool);
+error_folioq_pool:
 	return ret;
 }
 fs_initcall(netfs_init);
@@ -172,5 +178,6 @@ static void __exit netfs_exit(void)
 	kmem_cache_destroy(netfs_subrequest_slab);
 	mempool_exit(&netfs_request_pool);
 	kmem_cache_destroy(netfs_request_slab);
+	mempool_exit(&netfs_folioq_pool);
 }
 module_exit(netfs_exit);
diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index b8c4918d3dcd..29d8eab06dec 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -7,7 +7,6 @@
 
 #include <linux/slab.h>
 #include <linux/mempool.h>
-#include <linux/delay.h>
 #include "internal.h"
 
 static void netfs_free_request(struct work_struct *work);
@@ -26,17 +25,23 @@ struct netfs_io_request *netfs_alloc_request(struct address_space *mapping,
 	struct netfs_io_request *rreq;
 	mempool_t *mempool = ctx->ops->request_pool ?: &netfs_request_pool;
 	struct kmem_cache *cache = mempool->pool_data;
+	gfp_t gfp = GFP_KERNEL;
 	int ret;
 
-	for (;;) {
-		rreq = mempool_alloc(mempool, GFP_KERNEL);
-		if (rreq)
-			break;
-		msleep(10);
+	/* Writeback is part of memory reclaim and must not fail due to ENOMEM. */
+	if (origin == NETFS_WRITEBACK || origin == NETFS_WRITEBACK_SINGLE) {
+		gfp = GFP_NOFS; /* Allows use of mempools. */
+
+		rreq = mempool_alloc(mempool, gfp);
+	} else {
+		rreq = mempool->alloc(gfp, mempool->pool_data);
+		if (!rreq)
+			return ERR_PTR(-ENOMEM);
 	}
 
 	memset(rreq, 0, kmem_cache_size(cache));
 	INIT_WORK(&rreq->cleanup_work, netfs_free_request);
+	rreq->gfp	= gfp;
 	rreq->start	= start;
 	rreq->len	= len;
 	rreq->origin	= origin;
@@ -200,12 +205,14 @@ struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq
 	mempool_t *mempool = rreq->netfs_ops->subrequest_pool ?: &netfs_subrequest_pool;
 	struct kmem_cache *cache = mempool->pool_data;
 
-	for (;;) {
-		subreq = mempool_alloc(rreq->netfs_ops->subrequest_pool ?: &netfs_subrequest_pool,
-				       GFP_KERNEL);
-		if (subreq)
-			break;
-		msleep(10);
+	if (rreq->gfp == GFP_KERNEL) {
+		subreq = mempool->alloc(rreq->gfp, mempool->pool_data);
+		if (!subreq)
+			return ERR_PTR(-ENOMEM);
+	} else {
+		subreq = mempool_alloc(mempool, rreq->gfp);
+		if (!subreq)
+			return NULL;
 	}
 
 	memset(subreq, 0, kmem_cache_size(cache));
diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index 7eacc58abadb..c31190993b76 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -53,7 +53,7 @@ static void netfs_pgpriv2_copy_folio(struct netfs_io_request *creq, struct folio
 	trace_netfs_folio(folio, netfs_folio_trace_store_copy);
 
 	/* Attach the folio to the rolling buffer. */
-	if (rolling_buffer_append(&creq->buffer, folio, 0) < 0) {
+	if (rolling_buffer_append(&creq->buffer, folio, 0, creq->gfp) < 0) {
 		folio_end_private_2(folio);
 		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &creq->flags);
 		return;
diff --git a/fs/netfs/rolling_buffer.c b/fs/netfs/rolling_buffer.c
index a17fbf9853a4..c7f107764bda 100644
--- a/fs/netfs/rolling_buffer.c
+++ b/fs/netfs/rolling_buffer.c
@@ -27,7 +27,10 @@ struct folio_queue *netfs_folioq_alloc(unsigned int rreq_id, gfp_t gfp,
 {
 	struct folio_queue *fq;
 
-	fq = kmalloc_obj(*fq, gfp);
+	if (gfp == GFP_KERNEL)
+		fq = netfs_folioq_pool.alloc(gfp, netfs_folioq_pool.pool_data);
+	else
+		fq = mempool_alloc(&netfs_folioq_pool, gfp);
 	if (fq) {
 		netfs_stat(&netfs_n_folioq);
 		folioq_init(fq, rreq_id);
@@ -50,7 +53,7 @@ void netfs_folioq_free(struct folio_queue *folioq,
 {
 	trace_netfs_folioq(folioq, trace);
 	netfs_stat_d(&netfs_n_folioq);
-	kfree(folioq);
+	mempool_free(folioq, &netfs_folioq_pool);
 }
 EXPORT_SYMBOL(netfs_folioq_free);
 
@@ -60,11 +63,11 @@ EXPORT_SYMBOL(netfs_folioq_free);
  * consumer.
  */
 int rolling_buffer_init(struct rolling_buffer *roll, unsigned int rreq_id,
-			unsigned int direction)
+			unsigned int direction, gfp_t gfp)
 {
 	struct folio_queue *fq;
 
-	fq = netfs_folioq_alloc(rreq_id, GFP_NOFS, netfs_trace_folioq_rollbuf_init);
+	fq = netfs_folioq_alloc(rreq_id, gfp, netfs_trace_folioq_rollbuf_init);
 	if (!fq)
 		return -ENOMEM;
 
@@ -77,14 +80,14 @@ int rolling_buffer_init(struct rolling_buffer *roll, unsigned int rreq_id,
 /*
  * Add another folio_queue to a rolling buffer if there's no space left.
  */
-int rolling_buffer_make_space(struct rolling_buffer *roll)
+int rolling_buffer_make_space(struct rolling_buffer *roll, gfp_t gfp)
 {
 	struct folio_queue *fq, *head = roll->head;
 
 	if (!folioq_full(head))
 		return 0;
 
-	fq = netfs_folioq_alloc(head->rreq_id, GFP_NOFS, netfs_trace_folioq_make_space);
+	fq = netfs_folioq_alloc(head->rreq_id, gfp, netfs_trace_folioq_make_space);
 	if (!fq)
 		return -ENOMEM;
 	fq->prev = head;
@@ -122,7 +125,7 @@ ssize_t rolling_buffer_load_from_ra(struct rolling_buffer *roll,
 	int nr, ix, to;
 	ssize_t size = 0;
 
-	if (rolling_buffer_make_space(roll) < 0)
+	if (rolling_buffer_make_space(roll, GFP_KERNEL) < 0)
 		return -ENOMEM;
 
 	fq = roll->head;
@@ -153,12 +156,12 @@ ssize_t rolling_buffer_load_from_ra(struct rolling_buffer *roll,
  * Append a folio to the rolling buffer.
  */
 ssize_t rolling_buffer_append(struct rolling_buffer *roll, struct folio *folio,
-			      unsigned int flags)
+			      unsigned int flags, gfp_t gfp)
 {
 	ssize_t size = folio_size(folio);
 	int slot;
 
-	if (rolling_buffer_make_space(roll) < 0)
+	if (rolling_buffer_make_space(roll, gfp) < 0)
 		return -ENOMEM;
 
 	slot = folioq_append(roll->head, folio);
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 14efe4cb9393..2d9cfcd43658 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -108,7 +108,7 @@ struct netfs_io_request *netfs_create_write_req(struct address_space *mapping,
 	ictx = netfs_inode(wreq->inode);
 	if (is_cacheable)
 		fscache_begin_write_operation(&wreq->cache_resources, netfs_i_cookie(ictx));
-	if (rolling_buffer_init(&wreq->buffer, wreq->debug_id, ITER_SOURCE) < 0)
+	if (rolling_buffer_init(&wreq->buffer, wreq->debug_id, ITER_SOURCE, wreq->gfp) < 0)
 		goto nomem;
 
 	wreq->cleaned_to = wreq->start;
@@ -167,7 +167,7 @@ void netfs_prepare_write(struct netfs_io_request *wreq,
 	 */
 	if (iov_iter_is_folioq(wreq_iter) &&
 	    wreq_iter->folioq_slot >= folioq_nr_slots(wreq_iter->folioq))
-		rolling_buffer_make_space(&wreq->buffer);
+		rolling_buffer_make_space(&wreq->buffer, wreq->gfp);
 
 	subreq = netfs_alloc_subrequest(wreq);
 	subreq->source		= stream->source;
@@ -334,7 +334,7 @@ static int netfs_write_folio(struct netfs_io_request *wreq,
 
 	_enter("");
 
-	if (rolling_buffer_make_space(&wreq->buffer) < 0)
+	if (rolling_buffer_make_space(&wreq->buffer, wreq->gfp) < 0)
 		return -ENOMEM;
 
 	/* netfs_perform_write() may shift i_size around the page or from out
@@ -436,7 +436,7 @@ static int netfs_write_folio(struct netfs_io_request *wreq,
 	}
 
 	/* Attach the folio to the rolling buffer. */
-	rolling_buffer_append(&wreq->buffer, folio, 0);
+	rolling_buffer_append(&wreq->buffer, folio, 0, wreq->gfp);
 
 	/* Move the submission point forward to allow for write-streaming data
 	 * not starting at the front of the page.  We don't do write-streaming
@@ -749,7 +749,7 @@ static int netfs_write_folio_single(struct netfs_io_request *wreq,
 
 	/* Attach the folio to the rolling buffer. */
 	folio_get(folio);
-	ret = rolling_buffer_append(&wreq->buffer, folio, NETFS_ROLLBUF_PUT_MARK);
+	ret = rolling_buffer_append(&wreq->buffer, folio, NETFS_ROLLBUF_PUT_MARK, wreq->gfp);
 	if (ret < 0) {
 		folio_put(folio);
 		return ret;
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 1bc120d61c5b..d0b62d53eea9 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -255,6 +255,7 @@ struct netfs_io_request {
 	unsigned long long	cleaned_to;	/* Position we've cleaned folios to */
 	unsigned long long	abandon_to;	/* Position to abandon folios to */
 	const struct folio	*no_unlock_folio; /* Don't unlock this folio after read */
+	gfp_t			gfp;		/* GFP flags to use */
 	unsigned int		direct_bv_count; /* Number of elements in direct_bv[] */
 	unsigned int		debug_id;
 	unsigned int		rsize;		/* Maximum read size (0 for none) */
diff --git a/include/linux/rolling_buffer.h b/include/linux/rolling_buffer.h
index ac15b1ffdd83..9e5dad29669c 100644
--- a/include/linux/rolling_buffer.h
+++ b/include/linux/rolling_buffer.h
@@ -43,13 +43,13 @@ struct rolling_buffer_snapshot {
 #define ROLLBUF_MARK_2	BIT(1)
 
 int rolling_buffer_init(struct rolling_buffer *roll, unsigned int rreq_id,
-			unsigned int direction);
-int rolling_buffer_make_space(struct rolling_buffer *roll);
+			unsigned int direction, gfp_t gfp);
+int rolling_buffer_make_space(struct rolling_buffer *roll, gfp_t gfp);
 ssize_t rolling_buffer_load_from_ra(struct rolling_buffer *roll,
 				    struct readahead_control *ractl,
 				    struct folio_batch *put_batch);
 ssize_t rolling_buffer_append(struct rolling_buffer *roll, struct folio *folio,
-			      unsigned int flags);
+			      unsigned int flags, gfp_t gfp);
 struct folio_queue *rolling_buffer_delete_spent(struct rolling_buffer *roll);
 void rolling_buffer_clear(struct rolling_buffer *roll);
 

