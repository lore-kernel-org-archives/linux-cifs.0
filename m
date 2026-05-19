Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CF83A9DA7
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186150; cv=none; b=jcbNFQFyJgEp3RAzvwLzYhzPNpqc/+2HRAOM7lX4d6pCywolTrb3w0QIex9+lzHJCuP4popJ/pMNEBpxVOjHOw++Bpk2zHnx7NFDw/hZkyCXb5b/k51raYmT20SAZEi6obHguvUDxHUnPFr8/GIEKqZEULy5LOYPptMC4UutO4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186150; c=relaxed/simple;
	bh=lFZfb2qmDYwykTp1Cpfrowdt41V2O4lMCoFNJlEa/1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pI2vrRYS7PwTkkEj4k/OC4R+laCtq2rQ755+pjyffAl79rTzw9QRKtn/PaAWYdwEFellwAeXFaTy55fOCHUCtJ9FiqtT7NvubCpfYNg3sU3rUNwBgqgCNQDhwihZuIvoyI6jZmTveV8Kx0fgoFbTb3cAOuSY2+34yQRhTqt6GmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZbJjEEOw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZbJjEEOw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w3lFbu81yUMfAe2aK/cD8XDhTc8jRvOyQBk6lCpA3vE=;
	b=ZbJjEEOwElXJ2W8lkAMLv9qK/haQ4ULm7lZquDvbwb1lZmnwyD2BfdFkj9BGimxIQaGW+y
	4MZcpnFXZtpzXaCb8om6c7ZVnO7JyEgJEjtlaQ1dWltsOyvY6RCiNLl303A5vmCGOZ4zYw
	KTs2fhf3jeqNX9wv7BlliaeeLNYJQt8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-Lll8fd_AOLCNN6wpcVkHow-1; Tue,
 19 May 2026 06:22:22 -0400
X-MC-Unique: Lll8fd_AOLCNN6wpcVkHow-1
X-Mimecast-MFC-AGG-ID: Lll8fd_AOLCNN6wpcVkHow_1779186141
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5D4919560AD;
	Tue, 19 May 2026 10:22:20 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 663C430002DC;
	Tue, 19 May 2026 10:22:17 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 03/36] netfs: Add some TCP receive queue helpers
Date: Tue, 19 May 2026 11:21:21 +0100
Message-ID: <20260519102158.592165-4-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Add some helpers to splice buffers from a TCP receive queue to a private
queue from where they can be processed without the need to hold the socket
lock.  This is particularly significant if a large amount of data is being
copied, say for a read-data RPC call.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/Makefile            |   5 +-
 fs/netfs/rxqueue.c           | 532 +++++++++++++++++++++++++++++++++++
 include/linux/netfs.h        |  31 ++
 include/trace/events/netfs.h |  28 ++
 4 files changed, 595 insertions(+), 1 deletion(-)
 create mode 100644 fs/netfs/rxqueue.c

diff --git a/fs/netfs/Makefile b/fs/netfs/Makefile
index 9cfc3ccf46a0..66e642650a5f 100644
--- a/fs/netfs/Makefile
+++ b/fs/netfs/Makefile
@@ -20,7 +20,10 @@ netfs-y := \
 
 netfs-$(CONFIG_NETFS_PGPRIV2) += read_pgpriv2.o
 netfs-$(CONFIG_NETFS_STATS) += stats.o
-netfs-$(CONFIG_INET) += tcp_splice.o
+
+netfs-$(CONFIG_INET) += \
+	rxqueue.o \
+	tcp_splice.o
 
 netfs-$(CONFIG_FSCACHE) += \
 	fscache_cache.o \
diff --git a/fs/netfs/rxqueue.c b/fs/netfs/rxqueue.c
new file mode 100644
index 000000000000..e40c4e23a9af
--- /dev/null
+++ b/fs/netfs/rxqueue.c
@@ -0,0 +1,532 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Receive buffer handling.  Move memory copy outside of the socket lock.
+ *
+ * Copyright (C) 2026 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include <linux/delay.h>
+#include "internal.h"
+
+/*
+ * Get a ref on an Rx page.
+ */
+static void netfs_get_rx_page(struct bio_vec *bv)
+{
+	get_page(bv->bv_page);
+}
+
+/*
+ * Drop a ref on an Rx page.
+ */
+static void netfs_put_rx_page(struct bio_vec *bv)
+{
+	put_page(bv->bv_page);
+}
+
+/*
+ * netfs_alloc_rx_bvecq - Allocate a receive buffer.
+ * nr_bv: Number of slots to allocate
+ *
+ * Allocate a receive buffer with the specified number of slots.  This function
+ * will not fail, though it has no upper bound on the time taken to succeed.
+ *
+ * Return: The new buffer.
+ */
+struct bvecq *netfs_alloc_rx_bvecq(unsigned int nr_bv)
+{
+	struct bvecq *bq;
+
+	for (;;) {
+		bq = bvecq_alloc_one(nr_bv, GFP_NOFS);
+		if (bq)
+			return bq;
+		msleep(50);
+	}
+}
+EXPORT_SYMBOL(netfs_alloc_rx_bvecq);
+
+/**
+ * netfs_put_rx_bvecq - Put a receive buffer chain
+ * @bq: The head buffer to put
+ *
+ * Put a ref on the first buffer segment in a bvecq chain and if that reaches
+ * zero, destroy it, move on to the next buffer and repeat the put.
+ */
+void netfs_put_rx_bvecq(struct bvecq *bq)
+{
+	struct bvecq *next;
+
+	for (; bq; bq = next) {
+		if (!refcount_dec_and_test(&bq->ref))
+			break;
+		for (int seg = 0; seg < bq->nr_slots; seg++)
+			if (bq->bv[seg].bv_page)
+				netfs_put_rx_page(&bq->bv[seg]);
+		next = bq->next;
+		kfree(bq);
+	}
+}
+EXPORT_SYMBOL(netfs_put_rx_bvecq);
+
+/**
+ * netfs_rxqueue_read_iter - Read data from a queue to an iterator
+ * @rxq: The receive queue to read
+ * @dest: The buffer to fill
+ * @skip: The amount of data in the queue to skip over
+ * @amount: The amount of data to read
+ *
+ * Copy data from the receive queue to an iterator.  The data doesn't have to
+ * lie at the beginning of the buffer, but the initial unwanted data can be
+ * skipped over.
+ *
+ * Note that this does not discard any data from the queue.
+ *
+ * Return: The amount of data copied.  0 is returned on failure or if @amount
+ * is 0.
+ */
+size_t netfs_rxqueue_read_iter(const struct netfs_rxqueue *rxq,
+			       struct iov_iter *dest, size_t skip, size_t amount)
+{
+	const struct bvecq *from = rxq->take_from;
+	unsigned int slot = rxq->take_slot;
+	size_t qsize = rxq->qsize, copied = 0;
+
+	if (WARN(amount > iov_iter_count(dest),
+		 "MSG=%x %zx > %zx",
+		 rxq->msg_id, amount, iov_iter_count(dest)))
+		amount = iov_iter_count(dest);
+
+	if (skip > rxq->pdu_remain) {
+		pr_warn("Rx over-skip %zx > %x\n", skip, rxq->pdu_remain);
+		return 0;
+	}
+	if (amount > rxq->pdu_remain - skip) {
+		pr_warn("Rx over-read %zx+%zx > %x\n",
+			skip, amount, rxq->pdu_remain);
+		amount = rxq->pdu_remain - skip;
+		if (amount == 0)
+			return 0;
+	}
+	if (amount > qsize)
+		amount = qsize;
+
+	skip += rxq->take_offset;
+
+	while (copied < amount) {
+		if (slot >= from->nr_slots) {
+			slot = 0;
+			from = from->next;
+			if (!from)
+				break;
+		}
+
+		const struct bio_vec *bv = &from->bv[slot];
+		size_t blen = bv->bv_len;
+
+		if (skip >= blen) {
+			skip -= blen;
+			slot++;
+			continue;
+		}
+
+		size_t part = umin(blen - skip, amount - copied), got;
+
+		trace_netfs_rxq_read(rxq, slot, skip, part, copied);
+
+		got = copy_page_to_iter(bv->bv_page,
+					bv->bv_offset + skip, part, dest);
+		if (WARN_ON(got != part)) {
+			bvecq_dump(rxq->take_from);
+			return 0;
+		}
+
+		copied += part;
+		skip = 0;
+		slot++;
+	}
+
+	if (amount != copied)
+		pr_warn("Failed to fully read %zx/%zx %x %pSR\n",
+			copied, amount, rxq->qsize, __builtin_return_address(0));
+	return copied;
+}
+EXPORT_SYMBOL(netfs_rxqueue_read_iter);
+
+/**
+ * netfs_rxqueue_read - Read data from a queue to a flat buffer
+ * @rxq: The receive queue to read
+ * @buffer: The buffer to fill
+ * @skip: The amount of data in the queue to skip over
+ * @amount: The amount of data to read
+ *
+ * Copy data from the receive queue to a flat buffer.  The data doesn't have to
+ * lie at the beginning of the buffer, but the initial unwanted data can be
+ * skipped over.
+ *
+ * Note that this does not discard any data from the queue.
+ *
+ * Return: The amount of data copied.  0 is returned on failure or if @amount
+ * is 0.
+ */
+size_t netfs_rxqueue_read(const struct netfs_rxqueue *rxq,
+			  void *buffer, size_t skip, size_t amount)
+{
+	struct iov_iter iter;
+	struct kvec kv = { .iov_base = buffer, .iov_len = amount };
+
+	iov_iter_kvec(&iter, ITER_DEST, &kv, 1, amount);
+	return netfs_rxqueue_read_iter(rxq, &iter, skip, amount);
+}
+EXPORT_SYMBOL(netfs_rxqueue_read);
+
+/**
+ * netfs_rxqueue_discard - Discard data from a queue
+ * @rxq: The receive queue to modify
+ * @amount: The amount of data to discard
+ *
+ * Discard the specified amount of data from @rxq.  This may free pages and
+ * bvecq segments.  In the event that the last bvecq is entirely cleared, it
+ * will be refurbished and prepared for future refilling.
+ */
+void netfs_rxqueue_discard(struct netfs_rxqueue *rxq, size_t amount)
+{
+	struct bvecq *from = rxq->take_from, *dead;
+	unsigned int offset = rxq->take_offset;
+	unsigned int slot = rxq->take_slot;
+	size_t qsize = rxq->qsize;
+
+	if (amount > rxq->pdu_remain) {
+		pr_warn("Rx over discard %zx > %x\n", amount, rxq->pdu_remain);
+		amount = rxq->pdu_remain;
+	}
+
+	rxq->pdu_remain -= amount;
+
+	for (;;) {
+		if (slot >= from->nr_slots) {
+			slot = 0;
+			offset = 0;
+			if (!from->next) {
+				/* Refurbish the final bvecq.  add_to is NULL
+				 * for a queue excerpt.
+				 */
+				if (!rxq->add_to) {
+					netfs_put_rx_bvecq(from);
+					from = NULL;
+					break;
+				}
+
+				WARN_ON_ONCE(from != rxq->add_to);
+				from->nr_slots = 0;
+				rxq->add_to = from;
+				break;
+			}
+			dead = from;
+			from = dead->next;
+			from->prev = NULL;
+			dead->next = NULL;
+			netfs_put_rx_bvecq(dead);
+		}
+
+		if (!amount)
+			break;
+
+		struct bio_vec *bv = &from->bv[slot];
+
+		if (offset < bv->bv_len) {
+			size_t part = umin(umin(bv->bv_len - offset, amount), qsize);
+			offset += part;
+			amount -= part;
+			qsize -= part;
+			if (offset < bv->bv_len)
+				break;
+		}
+
+		if (!WARN_ON_ONCE(!bv->bv_page))
+			netfs_put_rx_page(bv);
+		bv->bv_page = NULL;
+		bv->bv_offset = 0;
+		bv->bv_len = 0;
+		slot++;
+		offset = 0;
+	}
+
+	if (amount > 0)
+		pr_warn("Failed to fully discard %zx %zx %pSR\n",
+			amount, qsize, __builtin_return_address(0));
+
+	rxq->take_from = from;
+	rxq->take_slot = slot;
+	rxq->take_offset = offset;
+	rxq->qsize = qsize;
+}
+EXPORT_SYMBOL(netfs_rxqueue_discard);
+
+/**
+ * netfs_rxqueue_count - Count the number of segs holding the specified data
+ * @rxq: The receive queue to assess
+ * @amount: The amount of data desired
+ *
+ * Count the number of segments in the receive queue that the requested amount
+ * of data spans.
+ *
+ * Return: Segment count; 0 is returned if there is in sufficient data.
+ */
+unsigned int netfs_rxqueue_count(const struct netfs_rxqueue *rxq, size_t amount)
+{
+	const struct bvecq *from = rxq->take_from;
+	unsigned int offset = rxq->take_offset;
+	unsigned int count = 0;
+	unsigned int slot = rxq->take_slot;
+
+	while (amount > 0) {
+		if (slot >= from->nr_slots) {
+			if (WARN_ON_ONCE(!from->next))
+				return 0;
+			from = from->next;
+			slot = 0;
+			offset = 0;
+		}
+
+		const struct bio_vec *bv = &from->bv[slot];
+
+		if (offset < bv->bv_len) {
+			count++;
+			if (bv->bv_len - offset >= amount)
+				return count;
+			amount -= bv->bv_len - offset;
+		}
+
+		slot++;
+		offset = 0;
+	}
+
+	return count;
+}
+EXPORT_SYMBOL(netfs_rxqueue_count);
+
+/*
+ * Append (part of) a segment to a bvec queue and get/transfer a page count.
+ * If we use up to the end of the source segment, we steal the page ref and
+ * clear the segment.
+ */
+static void netfs_bvecq_append_seg(struct bvecq **pdestq, struct bio_vec *sv,
+				   size_t offset, size_t len)
+{
+	struct bvecq *destq = *pdestq;
+	struct bio_vec *dv;
+
+	if (bvecq_is_full(destq)) {
+		destq = destq->next;
+		*pdestq = destq;
+	}
+	dv = &destq->bv[destq->nr_slots++];
+	*dv = *sv;
+	if (offset > 0) {
+		dv->bv_offset += offset;
+		dv->bv_len -= offset;
+	}
+	if (len < dv->bv_len) {
+		dv->bv_len = len;
+		netfs_get_rx_page(dv);
+	} else {
+		sv->bv_page = NULL;
+		sv->bv_offset = 0;
+		sv->bv_len = 0;
+	}
+}
+
+/**
+ * netfs_rxqueue_decant - Decant data segs to a private queue
+ * @rxq: The receive queue to decant from
+ * @amount: The amount of data received
+ *
+ * Decant data from the receive queue to a private queue.  This prevents the
+ * receive queue keeping the buffers pinned.
+ *
+ * Return: A bvecq chain, with ref, holding the decanted data or NULL if out of
+ * memory.
+ */
+struct bvecq *netfs_rxqueue_decant(struct netfs_rxqueue *rxq, size_t amount)
+{
+	struct bvecq *head_bq = NULL, *pbq, *destq;
+	struct bvecq *from = rxq->take_from;
+	unsigned int need_segs;
+	unsigned int offset = rxq->take_offset;
+	unsigned int slot = rxq->take_slot;
+	size_t qsize = rxq->qsize;
+
+	if (amount > rxq->pdu_remain) {
+		pr_warn("Rx over decant %zx > %x\n",
+			amount, rxq->pdu_remain);
+		amount = rxq->pdu_remain;
+	}
+
+	/* Count the number of segments in the queue for this PDU and then
+	 * allocate sufficient bvecq capacity to hold the whole PDU.
+	 */
+	need_segs = netfs_rxqueue_count(rxq, amount);
+	while (need_segs > 0) {
+		struct bvecq *b;
+		unsigned int max_bv = (PAGE_SIZE - sizeof(*b)) / sizeof(b->bv[0]);
+		unsigned int nr_bv = umin(need_segs, max_bv);
+
+		need_segs -= nr_bv;
+		b = netfs_alloc_rx_bvecq(nr_bv);
+		if (!b)
+			goto nomem;
+		b->prev = pbq;
+		if (head_bq)
+			pbq->next = b;
+		else
+			head_bq = b;
+		pbq = b;
+	}
+
+	rxq->pdu_remain -= amount;
+	destq = head_bq;
+	for (;;) {
+		if (slot >= from->nr_slots) {
+			struct bvecq *dead;
+
+			slot = 0;
+			offset = 0;
+			if (!from->next) {
+				/* Refurbish the final bvecq. */
+				WARN_ON_ONCE(from != rxq->add_to);
+				from->nr_slots = 0;
+				rxq->add_to = from;
+				break;
+			}
+			dead = from;
+			from = dead->next;
+			from->prev = NULL;
+			dead->next = NULL;
+			netfs_put_rx_bvecq(dead);
+		}
+
+		if (!amount)
+			break;
+
+		struct bio_vec *bv = &from->bv[slot];
+
+		if (offset < bv->bv_len) {
+			size_t part = umin(umin(bv->bv_len - offset, amount), qsize);
+			netfs_bvecq_append_seg(&destq, bv, offset, part);
+			offset += part;
+			amount -= part;
+			qsize -= part;
+			if (offset < bv->bv_len)
+				break;
+		}
+
+		if (WARN_ON_ONCE(bv->bv_page)) {
+			netfs_put_rx_page(bv);
+			bv->bv_page = NULL;
+			bv->bv_offset = 0;
+			bv->bv_len = 0;
+		}
+		slot++;
+		offset = 0;
+	}
+
+	rxq->take_from = from;
+	rxq->take_slot = slot;
+	rxq->take_offset = offset;
+	rxq->qsize = qsize;
+	return head_bq;
+
+nomem:
+	netfs_put_rx_bvecq(head_bq);
+	return NULL;
+}
+EXPORT_SYMBOL(netfs_rxqueue_decant);
+
+/**
+ * netfs_rxqueue_tcp_refill - Refill receive queue by TCP splice
+ * @tcp_sock: The TCP socket to splice data from
+ * @rxq: The Rx queue to splice into
+ * @min_size: The amount of data we're interested in
+ *
+ * Refill the receive queue by splicing network receive buffer segments from a
+ * TCP socket, but don't wait for data.  The caller must do any waiting
+ * required.
+ *
+ * Note that whilst the peer may send PDUs in separate TCP packets, it's
+ * possible that the local NIC may join them back together if doing receive
+ * offload.
+ */
+int netfs_rxqueue_tcp_refill(struct socket *tcp_sock, struct netfs_rxqueue *rxq,
+			     size_t min_size)
+{
+	struct bvecq *add_to = rxq->add_to;
+	size_t qsize = rxq->qsize;
+	int rc = 0;
+
+	if (!rxq->refillable) {
+		WARN_ON(min_size > qsize);
+		return 0;
+	}
+	if (qsize >= min_size && min_size > 0)
+		return 0;
+
+	do {
+		if (!add_to || bvecq_is_full(add_to)) {
+			struct bvecq *b;
+			unsigned int nr_bv = (2048 - sizeof(*add_to)) / sizeof(add_to->bv[0]);
+
+			b = netfs_alloc_rx_bvecq(nr_bv);
+			b->prev = add_to;
+			if (!add_to)
+				rxq->take_from = b;
+			else
+				add_to->next = b;
+			add_to = b;
+		}
+
+		rc = netfs_tcp_splice_to_bvecq(tcp_sock, add_to, INT_MAX);
+		//trace_smb3_tcp_splice(rc);
+		if (rc < 0)
+			break;
+
+		qsize += rc;
+		rc = 0;
+	} while (qsize < min_size);
+
+	rxq->add_to = add_to;
+	rxq->qsize = qsize;
+	return rc;
+}
+EXPORT_SYMBOL(netfs_rxqueue_tcp_refill);
+
+/**
+ * netfs_rxqueue_tcp_consume - Receive and discard data from a receive queue
+ * @tcp_sock: The TCP socket that's the data source
+ * @rxq: The Rx queue to discard from
+ * @amount: The amount of data to discard
+ *
+ * Consume received data by receiving it if it's not already queued and then
+ * discarding it.  This function does no waiting, so the caller must do the
+ * waiting and repeatedly call it until the desired amount of data is consumed.
+ */
+int netfs_rxqueue_tcp_consume(struct socket *tcp_sock, struct netfs_rxqueue *rxq,
+			      size_t amount)
+{
+	while (amount) {
+		size_t part = umin(amount, rxq->qsize);
+		int rc;
+
+		amount -= part;
+		netfs_rxqueue_discard(rxq, part);
+
+		if (!amount)
+			break;
+
+		rc = netfs_rxqueue_tcp_refill(tcp_sock, rxq, 1);
+		if (rc < 0)
+			return rc;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(netfs_rxqueue_tcp_consume);
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 8fd23653a911..9f5168994a95 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -422,6 +422,22 @@ struct netfs_cache_ops {
 			      enum netfs_cache_collect block_type);
 };
 
+/*
+ * (An excerpt from) a receive queue.  Data buffers can be spliced out of, say,
+ * a TCP socket into a sequence of these and then a variety of helpers used
+ * to manipulate them and extract data.
+ */
+struct netfs_rxqueue {
+	struct bvecq		*add_to;	/* Where to add data to the Rx queue */
+	struct bvecq		*take_from;	/* Where to take data from the Rx queue */
+	unsigned int		take_offset;	/* Current offset in rx_take_slot */
+	unsigned short		take_slot;	/* Current slot in rx_take_from */
+	bool			refillable;	/* T if refillable; F if excerpt */
+	unsigned int		qsize;		/* Amount of data in rx_queue */
+	unsigned int		pdu_remain;	/* Amount of current PDU left */
+	unsigned int		msg_id;		/* ID to log in tracepoints as MSG=xx */
+};
+
 /* High-level read API. */
 ssize_t netfs_unbuffered_read_iter_locked(struct kiocb *iocb, struct iov_iter *iter);
 ssize_t netfs_unbuffered_read_iter(struct kiocb *iocb, struct iov_iter *iter);
@@ -483,6 +499,21 @@ void netfs_end_io_write(struct inode *inode);
 int netfs_start_io_direct(struct inode *inode);
 void netfs_end_io_direct(struct inode *inode);
 
+/* Receive queue API. */
+struct bvecq *netfs_alloc_rx_bvecq(unsigned int nr_bv);
+void netfs_put_rx_bvecq(struct bvecq *bq);
+size_t netfs_rxqueue_read_iter(const struct netfs_rxqueue *rxq,
+			       struct iov_iter *dest, size_t skip, size_t amount);
+size_t netfs_rxqueue_read(const struct netfs_rxqueue *rxq,
+			  void *buffer, size_t skip, size_t amount);
+void netfs_rxqueue_discard(struct netfs_rxqueue *rxq, size_t amount);
+unsigned int netfs_rxqueue_count(const struct netfs_rxqueue *rxq, size_t amount);
+struct bvecq *netfs_rxqueue_decant(struct netfs_rxqueue *rxq, size_t amount);
+int netfs_rxqueue_tcp_refill(struct socket *tcp_sock, struct netfs_rxqueue *rxq,
+			     size_t min_size);
+int netfs_rxqueue_tcp_consume(struct socket *tcp_sock, struct netfs_rxqueue *rxq,
+			      size_t amount);
+
 /* TCP transport helper API. */
 #ifdef CONFIG_INET
 ssize_t netfs_tcp_splice_to_bvecq(struct socket *sock, struct bvecq *bvecq, size_t len);
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index fbd000399b26..96a2c1f3880e 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -855,6 +855,34 @@ TRACE_EVENT(netfs_bv_slot,
 		      __entry->pfn, __entry->offset, __entry->offset + __entry->len)
 	    );
 
+TRACE_EVENT(netfs_rxq_read,
+	    TP_PROTO(const struct netfs_rxqueue *rxq, unsigned int slot,
+		     size_t skip, size_t part, size_t copied),
+
+	    TP_ARGS(rxq, slot, skip, part, copied),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,	msg_id)
+		    __field(unsigned int,	slot)
+		    __field(unsigned int,	skip)
+		    __field(unsigned int,	part)
+		    __field(unsigned int,	copied)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->msg_id	= rxq->msg_id;
+		    __entry->slot	= slot;
+		    __entry->skip	= skip;
+		    __entry->part	= part;
+		    __entry->copied	= copied;
+			   ),
+
+	    TP_printk("MSG=%08x [%02x] b=%04x-%04x c=%04x",
+		      __entry->msg_id, __entry->slot,
+		      __entry->skip, __entry->skip + __entry->part,
+		      __entry->copied)
+	    );
+
 #undef EM
 #undef E_
 #endif /* _TRACE_NETFS_H */

