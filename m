Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AEC258EC1
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186142; cv=none; b=JskAbk0c3ZiFyOKwy7sGZUcaanMcx5b3aM4kETxGHOxHvfVm6KgH/bDhvS66JC+5XQVIB7r2994NEalx+SZUOqmny3bm6GEKsvtPHdWbuw/saDnXUPBsmY7w+YTHIfWOdocRtg5IkoP6bM7t4K3+9DY7eKbEh6XiAin/pz4UIQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186142; c=relaxed/simple;
	bh=ZWRlTlULMlgQmy4zYCe/ilAxmmzK6RqK3epXm/pq+xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GovGzZ6l2zVD31xKIivWeQJc9COs4AayrBu/EYpUa6a5foIiZ1HUpqahutesEW9BMtcCQej9DyVfjJZiw2m1KdrhkVZ2ZaG0xE4Ft8yu78zMsoC+2P2k3ER0vorz8hWxUerGvbfbFthW8ezkJUTsIIFxZQke0L1ryqTjV+JtpYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S/iodL4n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S/iodL4n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HOVY75L14Dl93yhDO85IElKyNvCooLz7DO01WljhJr4=;
	b=S/iodL4nPQhN3ae3+o+InOkNjMZXR1CHX0OwRrKoLSv85a/rb+Pawd6rKDR4l/4J+X9hw1
	FnCSRJ19RMxAobzPzt/ObQg7JAYY5VP1hORTXO6t8do8TrAAckuYVD0ftNX2wZrTfmRra4
	3fa8FdQxYwCT9DlefEW6incs51miQ5c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-AGlo3YNMNeOFxIKZQy32Vg-1; Tue,
 19 May 2026 06:22:17 -0400
X-MC-Unique: AGlo3YNMNeOFxIKZQy32Vg-1
X-Mimecast-MFC-AGG-ID: AGlo3YNMNeOFxIKZQy32Vg_1779186135
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B64DE195609E;
	Tue, 19 May 2026 10:22:15 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 115E830002DC;
	Tue, 19 May 2026 10:22:11 +0000 (UTC)
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
	Eric Dumazet <edumazet@google.com>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [RFC PATCH 02/36] netfs: Add a facility to splice TCP receive buffers into a bvecq
Date: Tue, 19 May 2026 11:21:20 +0100
Message-ID: <20260519102158.592165-3-dhowells@redhat.com>
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

Add a function by which receive buffers can be spliced from a TCP socket
into a bvecq (bio_vec queue) allowing the caller to process the contained
data without holding the socket lock.  This is of particular interest
where, say, a network filesystem has to copy a lot of data from a TCP
socket from the response to a Read request - but holding the socket lock
prevents messages from being sent.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: Mina Almasry <almasrymina@google.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
cc: netdev@vger.kernel.org
---
 fs/netfs/Makefile     |   1 +
 fs/netfs/tcp_splice.c | 269 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/netfs.h |   6 +
 3 files changed, 276 insertions(+)
 create mode 100644 fs/netfs/tcp_splice.c

diff --git a/fs/netfs/Makefile b/fs/netfs/Makefile
index 421dd0be413b..9cfc3ccf46a0 100644
--- a/fs/netfs/Makefile
+++ b/fs/netfs/Makefile
@@ -20,6 +20,7 @@ netfs-y := \
 
 netfs-$(CONFIG_NETFS_PGPRIV2) += read_pgpriv2.o
 netfs-$(CONFIG_NETFS_STATS) += stats.o
+netfs-$(CONFIG_INET) += tcp_splice.o
 
 netfs-$(CONFIG_FSCACHE) += \
 	fscache_cache.o \
diff --git a/fs/netfs/tcp_splice.c b/fs/netfs/tcp_splice.c
new file mode 100644
index 000000000000..1ff312d5bfdc
--- /dev/null
+++ b/fs/netfs/tcp_splice.c
@@ -0,0 +1,269 @@
+/* Splice from TCP to a bvecq
+ *
+ * Copyright (C) 2025 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include "internal.h"
+#include <net/sock.h>
+#include <net/rps.h>
+#include <net/tcp.h>
+
+static struct page *linear_to_page(struct page *page, unsigned int *len,
+				   unsigned int *offset,
+				   struct sock *sk)
+{
+	struct page_frag *pfrag = sk_page_frag(sk);
+
+	if (!sk_page_frag_refill(sk, pfrag))
+		return NULL;
+
+	*len = min_t(unsigned int, *len, pfrag->size - pfrag->offset);
+
+	memcpy(page_address(pfrag->page) + pfrag->offset,
+	       page_address(page) + *offset, *len);
+	*offset = pfrag->offset;
+	pfrag->offset += *len;
+
+	return pfrag->page;
+}
+
+static bool bvecq_can_coalesce(const struct bvecq *bvecq,
+			       struct page *page,
+			       unsigned int offset)
+{
+	const struct bio_vec *bv = &bvecq->bv[bvecq->nr_slots - 1];
+
+	return bvecq->nr_slots > 0 &&
+		bv->bv_page == page &&
+		bv->bv_offset + bv->bv_len == offset;
+}
+
+/*
+ * Add {page,offset,length} into bvecq, if it has more capacity available.
+ */
+static bool bvecq_add_page(struct bvecq *bvecq, struct page *page,
+			   unsigned int *len, unsigned int offset, bool linear,
+			   struct sock *sk)
+{
+	if (unlikely(bvecq_is_full(bvecq)))
+		return true;
+
+	if (linear) {
+		page = linear_to_page(page, len, &offset, sk);
+		if (!page)
+			return true;
+	}
+	if (bvecq_can_coalesce(bvecq, page, offset)) {
+		unsigned int old_len = bvecq->bv[bvecq->nr_slots - 1].bv_len;
+
+		WRITE_ONCE(bvecq->bv[bvecq->nr_slots - 1].bv_len, old_len + *len);
+		return false;
+	}
+
+	get_page(page);
+	bvec_set_page(&bvecq->bv[bvecq->nr_slots], page, *len, offset);
+	bvecq->nr_slots++;
+	return false;
+}
+
+static bool bvecq_splice_segment(struct bvecq *bvecq,
+				 struct page *page, unsigned int poff,
+				 unsigned int plen, unsigned int *off,
+				 unsigned int *len, bool linear,
+				 struct sock *sk)
+{
+	if (!*len)
+		return true;
+
+	/* skip this segment if already processed */
+	if (*off >= plen) {
+		*off -= plen;
+		return false;
+	}
+
+	/* ignore any bits we already processed */
+	poff += *off;
+	plen -= *off;
+	*off = 0;
+
+	/* TODO: Splice in large pages as single bio_vecs. */
+	do {
+		unsigned int flen = umin(*len, plen);
+
+		if (bvecq_add_page(bvecq, page, &flen, poff, linear, sk))
+			return true;
+		poff += flen;
+		plen -= flen;
+		*len -= flen;
+	} while (*len && plen);
+
+	return false;
+}
+
+/*
+ * Map linear and fragment data from the skb to spd. It reports true if the
+ * pipe is full or if we already spliced the requested length.
+ */
+static bool bvecq_splice_bits_recursive(struct bvecq *bvecq, struct sk_buff *skb,
+					unsigned int *offset, unsigned int *len,
+					struct sock *sk)
+{
+	struct sk_buff *iter;
+	int seg;
+
+	/* map the linear part :
+	 * If skb->head_frag is set, this 'linear' part is backed by a
+	 * fragment, and if the head is not shared with any clones then
+	 * we can avoid a copy since we own the head portion of this page.
+	 */
+	if (bvecq_splice_segment(bvecq, virt_to_page(skb->data),
+				 (unsigned long) skb->data & (PAGE_SIZE - 1),
+				 skb_headlen(skb), offset, len,
+				 skb_head_is_locked(skb), sk))
+		return true;
+
+	/*
+	 * then map the fragments
+	 */
+	if (!skb_frags_readable(skb))
+		return false;
+
+	for (seg = 0; seg < skb_shinfo(skb)->nr_frags; seg++) {
+		const skb_frag_t *f = &skb_shinfo(skb)->frags[seg];
+
+		if (WARN_ON_ONCE(!skb_frag_page(f)))
+			return false;
+
+		if (bvecq_splice_segment(bvecq, skb_frag_page(f),
+					 skb_frag_off(f), skb_frag_size(f),
+					 offset, len, false, sk))
+			return true;
+	}
+
+	skb_walk_frags(skb, iter) {
+		if (*offset >= iter->len) {
+			*offset -= iter->len;
+			continue;
+		}
+		/* We only fail if the output has no room left, so no point in
+		 * going over the frag_list for the error case.
+		 */
+		if (bvecq_splice_bits_recursive(bvecq, iter, offset, len, sk))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Map data from the skb to a pipe. Should handle both the linear part,
+ * the fragments, and the frag list.
+ */
+static int tcp_splice_data_to_bvecq(read_descriptor_t *rd_desc, struct sk_buff *skb,
+				    unsigned int offset, size_t len)
+{
+	struct bvecq *bvecq = rd_desc->arg.data;
+	unsigned int tlen = umin(rd_desc->count, len);
+	unsigned int used;
+
+	bvecq_splice_bits_recursive(bvecq, skb, &offset, &tlen, skb->sk);
+	used = len - tlen;
+	rd_desc->count -= used;
+	return used;
+}
+
+/**
+ * netfs_tcp_splice_to_bvecq - splice data from TCP socket to a bvec queue
+ * @sock: The socket to splice from
+ * @bvecq: The bvec queue to splice to
+ * @len: The number of bytes to splice
+ *
+ * Read pages from the given socket and transfer them into a bvec queue.  Data
+ * segments are attached starting at the next available segment in the bvecq
+ * (from bvecq->nr_slots+1 up to bvecq->max_slots) and may extend the last
+ * segment used if contiguous with it.
+ */
+ssize_t netfs_tcp_splice_to_bvecq(struct socket *sock, struct bvecq *bvecq,
+				  size_t len)
+{
+	read_descriptor_t rd_desc = {
+		.arg.data = bvecq,
+		.count	  = len,
+	};
+	struct sock *sk = sock->sk;
+	ssize_t spliced = 0;
+	long timeo;
+	int ret = 0;
+
+	sock_rps_record_flow(sk);
+	if (unlikely(bvecq_is_full(bvecq)))
+		return -ENOBUFS;
+
+	lock_sock(sk);
+
+	timeo = sock_rcvtimeo(sk, true /* non-blocking */);
+	while (len) {
+		ret = tcp_read_sock(sk, &rd_desc, tcp_splice_data_to_bvecq);
+		if (ret < 0)
+			break;
+		if (!ret) {
+			if (spliced)
+				break;
+			if (sock_flag(sk, SOCK_DONE))
+				break;
+			if (sk->sk_err) {
+				ret = sock_error(sk);
+				break;
+			}
+			if (sk->sk_shutdown & RCV_SHUTDOWN)
+				break;
+			if (sk->sk_state == TCP_CLOSE) {
+				/*
+				 * This occurs when user tries to read
+				 * from never connected socket.
+				 */
+				ret = -ENOTCONN;
+				break;
+			}
+			if (!timeo) {
+				ret = -EAGAIN;
+				break;
+			}
+			/* if __tcp_splice_read() got nothing while we have
+			 * an skb in receive queue, we do not want to loop.
+			 * This might happen with URG data.
+			 */
+			if (!skb_queue_empty(&sk->sk_receive_queue))
+				break;
+			ret = sk_wait_data(sk, &timeo, NULL);
+			if (ret < 0)
+				break;
+			if (signal_pending(current)) {
+				ret = sock_intr_errno(timeo);
+				break;
+			}
+			continue;
+		}
+		len -= ret;
+		spliced += ret;
+
+		if (!len || !timeo || bvecq_is_full(bvecq))
+			break;
+		release_sock(sk);
+		lock_sock(sk);
+
+		if (sk->sk_err || sk->sk_state == TCP_CLOSE ||
+		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
+		    signal_pending(current))
+			break;
+	}
+
+	release_sock(sk);
+	return spliced ?: ret;
+}
+EXPORT_SYMBOL_GPL(netfs_tcp_splice_to_bvecq);
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 86bef8fec14b..8fd23653a911 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -23,6 +23,7 @@
 enum netfs_sreq_ref_trace;
 typedef struct mempool mempool_t;
 struct readahead_control;
+struct socket;
 struct netfs_io_request;
 struct netfs_io_subrequest;
 struct fscache_occupancy;
@@ -482,6 +483,11 @@ void netfs_end_io_write(struct inode *inode);
 int netfs_start_io_direct(struct inode *inode);
 void netfs_end_io_direct(struct inode *inode);
 
+/* TCP transport helper API. */
+#ifdef CONFIG_INET
+ssize_t netfs_tcp_splice_to_bvecq(struct socket *sock, struct bvecq *bvecq, size_t len);
+#endif
+
 /**
  * netfs_inode - Get the netfs inode context from the inode
  * @inode: The inode to query

