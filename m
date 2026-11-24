Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.32
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527231;
	b=OL3t728GbZIcG4JYJz206SR85225eHoXlKPubEJ+Z/8d8tTqv62GIMlHE19hqkj6QzLj
	 Ye9Z8Z7HGPV1QWI8wKa2auMN9Mxtj3ucSbc+llRqAPOdnPe9qFHA81OxWqqXXkr2XCZd+
	 gG4VfI/dyZPlwTUMJ6wF+1h3ePM4ReFdJqwWMIRg048XwgwAfhe4YvMt1aajPEWdmy6K8
	 zGRKZ+UHLMu6ei6cqqmKJIyEeYkChhjCgvRZ/vUjd0web0Tnh9Iq1t5lf16zNBKXq0wor
	 3eFi3a8WLLjngL6ahQCQz/xgIBVt21lVp2PSEzXxW9X8uL22/yPFza5v2EbQVTcFhNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527231;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Tw89vx+OifOo+5VNZiA+F3pyDNZVao5o60IiMpmo4FY=;
	b=Dw+ZahCCwV8kxtLS83q06DXYAFDnK2u5D7T5SLqRHKIU0hhyX6stbIV55I/ZOz90rTxC
	 rgZyQDS7GqeoH1PoIeEYe2debEAMwkVkgNWUxdPyi7h00CGlJ+LiRFwfldXtSCfB89+iY
	 Eknb1YjUbxTQ+UeCSuz3vBVu31IOHwUf/yoFfhyE0SIJNYPDe+aE0DBpk/KMOm+Ck9X39
	 Ze6oZcJiZYQ2QcwbSGnHWmoE3xd3hldbYQpQqceDzxkU8ZetjssEf4R2aqGFhlrQINV4Y
	 zuMVCepEPuoxvyf5RvCOUANLc/RTyltuMK4GX70CSs6nUN6XKHwvaIDBaKeJ9m8Rm0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IbLPDnmg;
	arc=none smtp.remote-ip=95.215.58.32
Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089AF606A33B
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 13:33:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 089AF606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IbLPDnmg
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BVwErX9fDWBYGSkb3De31XAysI9DwTvwsT449Emq5JU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795527228; v=1; x=1796132028;
 b=IbLPDnmgiIzI7ilKeR3N0vdgm8UN/zo5n1wx4Brht3Gi4oL3MdC+SOEcX1RpS+52Rk3QOYCo
 hgZnwEA84ocgELmAQpBkvClUvztuCgCgnLszwnRqaCCq/SUKCT9ZIaSQjIpruiUowk1BJjqslf9
 6KlutfCbBB/Q4/3oIdEv7+L8=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2cc7aee88a6dd40e;
	Tue, 24 Nov 2026 13:33:48 +0000
X-Mizu-Trace-ID: 2cc7aee88a6dd40e
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ksmbd: retain unsent READ pages on the TCP send queue
Date: Tue, 24 Nov 2026 21:33:30 +0800
Message-ID: <20261124133331.1186589-1-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124132554.1185817-1-huiwen.he@linux.dev>
References: <20261124132554.1185817-1-huiwen.he@linux.dev>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

When TCP accepts only part of a READ reply or an earlier reply is
already queued, ksmbd copies the unsent bytes into a queue entry.
TCP copies the payload again when the send worker runs.

Keep references to the unsent payload folios and store any remaining
header bytes in the queue entry. The worker sends the header first,
then passes the pages to TCP with MSG_SPLICE_PAGES. Charge each folio
in full against the queue limit and copy small tails that would keep
a large folio pinned.

Tested with fio sequential reads (16 jobs, QD32 per job) from a
4-vCPU virtio-net guest. The Xeon Gold 6430 host had 128 logical CPUs
and served a tmpfs share over SMB3.1.1. The "before" column includes
"ksmbd: send READ payloads with MSG_SPLICE_PAGES".

Channels  I/O       Throughput (MiB/s)        Host Gcycles/GiB
                   before   after change    before   after change
       1  4 KiB     284.2   281.6  -0.9%    28.576  28.265  -1.1%
       1  64 KiB   2501.8  2524.8  +0.9%     4.552   4.284  -5.9%
       1  256 KiB  3243.4  3414.6  +5.3%     4.511   3.497 -22.5%
       1  1 MiB    3145.6  3435.5  +9.2%     3.578   2.425 -32.2%
       4  4 KiB     454.2   454.9  +0.2%    24.338  24.377  +0.2%
       4  64 KiB   4337.1  4448.3  +2.6%     2.977   3.000  +0.8%
       4  256 KiB  6969.5  6938.8  -0.4%     1.932   1.916  -0.8%
       4  1 MiB    7705.3  8255.6  +7.1%     2.673   1.746 -34.7%

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
 fs/smb/server/transport_tcp.c | 171 +++++++++++++++++++++++++++++-----
 1 file changed, 149 insertions(+), 22 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index ae7957ec3e04..8456ad35a5dc 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -4,9 +4,11 @@
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
  */
 
+#include <linux/bvec.h>
 #include <linux/freezer.h>
 #include <linux/page_frag_cache.h>
 #include <linux/uio.h>
+#include <linux/vmalloc.h>
 
 #include "smb_common.h"
 #include "server.h"
@@ -35,9 +37,15 @@ struct tcp_tx {
 	struct list_head		list;
 	size_t			len;
 	size_t			offset;
+	size_t			charge;
 	unsigned long		deadline;
 	int			msg_flags;
-	u8			data[];
+	unsigned short		nr_vecs;
+	unsigned short		header_len;
+	union {
+		DECLARE_FLEX_ARRAY(u8, data);
+		DECLARE_FLEX_ARRAY(struct bio_vec, bvec);
+	};
 };
 
 struct tcp_transport {
@@ -478,12 +486,104 @@ static int ksmbd_tcp_read(struct ksmbd_transport *t, char *buf,
 	return ksmbd_tcp_readv(TCP_TRANS(t), &iov, 1, to_read, max_retries);
 }
 
-static bool ksmbd_tcp_tx_has_space(struct tcp_transport *t, size_t size)
+static bool ksmbd_tcp_tx_has_space(struct tcp_transport *t, size_t pdu_size,
+				   size_t charge)
 {
-	size_t limit = max_t(size_t, READ_ONCE(t->sock->sk->sk_sndbuf), size);
+	size_t limit = max_t(size_t, READ_ONCE(t->sock->sk->sk_sndbuf), pdu_size);
 
 	/* Allow one large response, but bound the retained response buffers. */
-	return READ_ONCE(t->tx_queued) <= limit - size;
+	return charge <= limit && READ_ONCE(t->tx_queued) <= limit - charge;
+}
+
+static void *ksmbd_tcp_tx_header(struct tcp_tx *msg)
+{
+	return msg->bvec + msg->nr_vecs;
+}
+
+static void ksmbd_tcp_free_tx(struct tcp_tx *msg)
+{
+	unsigned int i;
+
+	for (i = 0; i < msg->nr_vecs; i++)
+		folio_put(bvec_folio(&msg->bvec[i]));
+	kvfree(msg);
+}
+
+static struct tcp_tx *ksmbd_tcp_alloc_read_tx(struct tcp_transport *t,
+					      const struct ksmbd_transport_write *tx,
+					      size_t offset)
+{
+	struct kvec payload = tx->iov[2];
+	size_t remaining = tx->size - offset;
+	size_t payload_left = min(remaining, payload.iov_len);
+	size_t header_left = remaining - payload_left;
+	size_t charge = header_left;
+	struct tcp_tx *msg;
+	struct iov_iter iter;
+	unsigned int i, max_vecs;
+	unsigned short nr = 0;
+	bool vmapped;
+
+	if (payload_left < PAGE_SIZE)
+		return NULL;
+	payload.iov_base += payload.iov_len - payload_left;
+	payload.iov_len = payload_left;
+	vmapped = is_vmalloc_addr(payload.iov_base);
+	if (vmapped) {
+		max_vecs = DIV_ROUND_UP(offset_in_page(payload.iov_base) + payload_left,
+					PAGE_SIZE);
+		if (max_vecs > USHRT_MAX)
+			return NULL;
+	} else {
+		struct folio *folio = virt_to_folio(payload.iov_base);
+
+		/* A small unsent tail must not keep a much larger folio alive. */
+		charge += folio_size(folio);
+		if (get_order(payload_left) < folio_order(folio) ||
+		    !ksmbd_tcp_tx_has_space(t, tx->size, charge))
+			return NULL;
+		max_vecs = 1;
+	}
+
+	/* The unsent header follows the payload vectors in the queue entry. */
+	msg = kvmalloc(size_add(struct_size(msg, bvec, max_vecs), header_left),
+		       KSMBD_DEFAULT_GFP);
+	if (!msg)
+		return NULL;
+	if (vmapped) {
+		iov_iter_kvec(&iter, ITER_SOURCE, &payload, 1, payload_left);
+		if (iov_iter_extract_bvecs(&iter, msg->bvec, payload_left, &nr,
+					   max_vecs, 0, 0) != payload_left)
+			goto fail;
+		for (i = 0; i < nr; i++) {
+			struct folio *folio = bvec_folio(&msg->bvec[i]);
+
+			if (get_order(msg->bvec[i].bv_len) < folio_order(folio))
+				goto fail;
+			charge += folio_size(folio);
+		}
+		if (!ksmbd_tcp_tx_has_space(t, tx->size, charge))
+			goto fail;
+	} else {
+		bvec_set_virt(&msg->bvec[0], payload.iov_base, payload_left);
+		nr = 1;
+	}
+
+	msg->nr_vecs = nr;
+	if (header_left) {
+		iov_iter_kvec(&iter, ITER_SOURCE, tx->iov, 2, tx->size - tx->iov[2].iov_len);
+		iov_iter_advance(&iter, offset);
+		if (!copy_from_iter_full(ksmbd_tcp_tx_header(msg), header_left, &iter))
+			goto fail;
+	}
+	for (i = 0; i < nr; i++)
+		folio_get(bvec_folio(&msg->bvec[i]));
+	msg->header_len = header_left;
+	msg->charge = charge;
+	return msg;
+fail:
+	kvfree(msg);
+	return NULL;
 }
 
 static struct tcp_tx *ksmbd_tcp_alloc_tx(const struct ksmbd_transport_write *tx,
@@ -503,9 +603,9 @@ static struct tcp_tx *ksmbd_tcp_alloc_tx(const struct ksmbd_transport_write *tx,
 		kvfree(msg);
 		return NULL;
 	}
-	msg->len = remaining;
-	msg->offset = 0;
-	msg->msg_flags = tx->msg_flags;
+	msg->nr_vecs = 0;
+	msg->header_len = 0;
+	msg->charge = remaining;
 	return msg;
 }
 
@@ -515,7 +615,7 @@ static void ksmbd_tcp_purge_tx(struct tcp_transport *t)
 
 	list_for_each_entry_safe(msg, next, &t->tx_queue, list) {
 		list_del(&msg->list);
-		kvfree(msg);
+		ksmbd_tcp_free_tx(msg);
 	}
 	WRITE_ONCE(t->tx_queued, 0);
 }
@@ -526,6 +626,33 @@ static bool ksmbd_tcp_send_retry(int ret)
 		ret == -ENOMEM;
 }
 
+static int ksmbd_tcp_send_queued(struct tcp_transport *t, struct tcp_tx *msg)
+{
+	struct msghdr hdr = {
+		.msg_flags = MSG_NOSIGNAL | MSG_DONTWAIT | msg->msg_flags,
+	};
+	size_t offset = msg->offset;
+	struct kvec iov;
+
+	if (!msg->nr_vecs) {
+		iov.iov_base = msg->data;
+		iov.iov_len = msg->len;
+	} else if (offset < msg->header_len) {
+		iov.iov_base = ksmbd_tcp_tx_header(msg);
+		iov.iov_len = msg->header_len;
+		hdr.msg_flags = (hdr.msg_flags & ~MSG_EOR) | MSG_MORE;
+	} else {
+		hdr.msg_flags |= MSG_SPLICE_PAGES;
+		iov_iter_bvec(&hdr.msg_iter, ITER_SOURCE, msg->bvec, msg->nr_vecs,
+			      msg->len - msg->header_len);
+		iov_iter_advance(&hdr.msg_iter, offset - msg->header_len);
+		return sock_sendmsg(t->sock, &hdr);
+	}
+	iov_iter_kvec(&hdr.msg_iter, ITER_SOURCE, &iov, 1, iov.iov_len);
+	iov_iter_advance(&hdr.msg_iter, offset);
+	return sock_sendmsg(t->sock, &hdr);
+}
+
 static void ksmbd_tcp_tx_work(struct work_struct *work)
 {
 	struct tcp_transport *t = container_of(to_delayed_work(work),
@@ -538,13 +665,6 @@ static void ksmbd_tcp_tx_work(struct work_struct *work)
 	mutex_lock(&t->tx_lock);
 	while (!READ_ONCE(t->tx_stopped) && !list_empty(&t->tx_queue) && budget--) {
 		struct tcp_tx *msg = list_first_entry(&t->tx_queue, struct tcp_tx, list);
-		struct msghdr hdr = {
-			.msg_flags = MSG_NOSIGNAL | MSG_DONTWAIT | msg->msg_flags,
-		};
-		struct kvec iov = {
-			.iov_base = msg->data + msg->offset,
-			.iov_len = msg->len - msg->offset,
-		};
 
 		/* MSG_DONTWAIT bypasses sk_sndtimeo, including for retained PDUs. */
 		if (time_after_eq(jiffies, msg->deadline)) {
@@ -552,16 +672,18 @@ static void ksmbd_tcp_tx_work(struct work_struct *work)
 			failed = true;
 			break;
 		}
-		ret = kernel_sendmsg(t->sock, &hdr, &iov, 1, iov.iov_len);
+		ret = ksmbd_tcp_send_queued(t, msg);
 		if (ret > 0) {
 			msg->offset += ret;
 			t->tx_sent += ret;
 			if (msg->offset == msg->len) {
-				WRITE_ONCE(t->tx_queued, t->tx_queued - msg->len);
+				WRITE_ONCE(t->tx_queued, t->tx_queued - msg->charge);
 				list_del(&msg->list);
-				kvfree(msg);
+				ksmbd_tcp_free_tx(msg);
 				continue;
 			}
+			if (msg->offset == msg->header_len)
+				continue;
 		} else if (!ksmbd_tcp_send_retry(ret)) {
 			WRITE_ONCE(t->tx_stopped, true);
 			failed = true;
@@ -682,7 +804,7 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t,
 			mutex_unlock(&tt->tx_lock);
 			return -EPIPE;
 		}
-		if (ksmbd_tcp_tx_has_space(tt, tx->size))
+		if (ksmbd_tcp_tx_has_space(tt, tx->size, tx->size))
 			break;
 		mutex_unlock(&tt->tx_lock);
 		if (tx->msg_flags & MSG_DONTWAIT)
@@ -693,7 +815,7 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t,
 					READ_ONCE(tt->tx_stopped) ||
 					ksmbd_conn_exiting(t->conn) ||
 					ksmbd_conn_releasing(t->conn) ||
-					ksmbd_tcp_tx_has_space(tt, tx->size),
+					ksmbd_tcp_tx_has_space(tt, tx->size, tx->size),
 					timeout)) {
 			/* A queued PDU may already have a prefix in the socket. */
 			ksmbd_conn_abort(t->conn);
@@ -719,7 +841,9 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t,
 	}
 
 	/* The request buffers can be freed as soon as writev returns. */
-	msg = ksmbd_tcp_alloc_tx(tx, sent);
+	msg = tx->splice_read ? ksmbd_tcp_alloc_read_tx(tt, tx, sent) : NULL;
+	if (!msg)
+		msg = ksmbd_tcp_alloc_tx(tx, sent);
 	if (!msg) {
 		if (sent)
 			WRITE_ONCE(tt->tx_stopped, true);
@@ -728,9 +852,12 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t,
 			ksmbd_conn_abort(t->conn);
 		return -ENOMEM;
 	}
+	msg->len = tx->size - sent;
+	msg->offset = 0;
+	msg->msg_flags = tx->msg_flags;
 	msg->deadline = deadline;
 	list_add_tail(&msg->list, &tt->tx_queue);
-	WRITE_ONCE(tt->tx_queued, tt->tx_queued + msg->len);
+	WRITE_ONCE(tt->tx_queued, tt->tx_queued + msg->charge);
 	queue_delayed_work(system_dfl_wq, &tt->tx_work, 0);
 
 accepted:
-- 
2.43.0

