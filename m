Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2871B2E7185
	for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 03:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774410581; cv=none; b=WQT3SeA/ad90NjgGs3fX9PMZTvnv84KenklkwQH6t27GdOjs/aWtUIMfUJh/Ib7H1iAm6fG4KWjXxU88EmUbXjiU79vOFTN8Kzt0CLfm4TyQl2zcEkzBjEvcEQ994FwjrWYCw+e4fVFY14dIKnMd/ahMQH6JHi9cdP0JL6OpFnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774410581; c=relaxed/simple;
	bh=/hCh8Zx3/BY8jF+1KwPgEwsvzaT5gDv5mdxJ/lR9gsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LKXs39vdS36rF4PsbDa583E2eq3QU1YHqS8YPT3NFH8LYjpQo/BgwjQXPbcgsQvJ1xjoLHAavM1xqQi12iKxpK8kwEqtn+SJ5V+yfwgTr2T/UDWRTYZvlaYO6jqDpDtLptAGRtTWlG8u+1112JUtqonGbbu0g2FADWBMeK6fLno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ilMwRZO3; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilMwRZO3"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-506bcb23a78so46741891cf.3
        for <linux-cifs@vger.kernel.org>; Tue, 24 Mar 2026 20:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774410578; x=1775015378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8FJEIVV5+/NFJkyakwv2PtRYAzHhtS8a7PnuVSByDsY=;
        b=ilMwRZO3hFoLimIxliqZcRIPGOuqczWrxERFVbjOJi5CbimP1cn6v6atJ45rXCmDJO
         VXxqfYzSk4TKCwxzwTxQWgkQkwc//j04Z5MzvElOZpgmDqob5VrCxhK/WNbFC1n/rCrf
         xROZg7EXcSG2Rhq10nGljKtrS40N62HlIemLHDKraHMGErPCMFqItccbnPSVOxmyQTq8
         YtTkJ9Zi69jkVqsdk0iAZOyFtS965d+C9BIdwJ6VMT+JCqH0oS3jNXhoN32irXyt1fa0
         ttaGyejE8b4osmfZH3Ep1J2DowdiW2mN2QY9te0ruc/G3I0FuC+5U9iIpU74YmOf2Cmb
         ia6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774410578; x=1775015378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8FJEIVV5+/NFJkyakwv2PtRYAzHhtS8a7PnuVSByDsY=;
        b=Mj3htpZ+KY0uwuRHmyqUX/lGNzH9OGoCn4Z8F2/yPqK72XfdD+KNBJjiAGSoaopoQP
         NPXIADNNSe0SdTFLAfteJJYLkpNoqPGmfqgDvVxIYX3DLQwRySdt8LzMGO+Dv5adrTEY
         3IR0uF4BAcJseEe/NKQ9fnY+5zaFMk2Ks2REIxjOMhjpGalBVsW4aIEKLarGckKpfCgM
         51TbE/2QwgT5zYsG5wph5C0z0Uih6VX8cZws9wFI06BHGzIQYIddw7zuUhdt06kATEy8
         pHZHNKehJTQoNbaR2PC+W8eWCXa/AyjAYVk2BGA5p3m2pt2YWQiMGdb/ZW43fDDrCB+V
         yBLA==
X-Forwarded-Encrypted: i=1; AJvYcCVPaa+8gVNm6SYrWeJy51/O/1LM74+0Kcuj79JwrGbkOx4J9WjBCLnDkex/sgn3ELHQC1yZ7mF8mTbG@vger.kernel.org
X-Gm-Message-State: AOJu0YyQsOG/yBgx6VCB25NL8MRja7VCEjwJzthvRIrXlV70xShWK0ay
	dtp9yLIXxp0B9Ke/c0YOVv7IS86xQYFfIjL30ljMrgNG5bY8u6ikavme
X-Gm-Gg: ATEYQzyy2WPQJyG7BxIiOvoK+PJfOT3D8NvAgTkGjh1DYSx7R0NNR5KOqgKVaq//Wl8
	+JsnY0bjxHjrm2NIraET2cN5KzGyX7UK9vXKnRb5SOBlAJIGA8mbk3ufVa4OIrTuKIg+kSZuqK/
	8lnIRlcFgKEVCyWLhMALNYyo8PdHsp+7O3YFQsqrmCfUMf6z751LZk9gNHNK3TdMx9LtcvN8VpF
	oxAK73v6BglMG54q+IQw8HYgVap9bX5wIjAcPOpvlXReWk9RkVAMnaM+vdFWp20qDeKRxDp/AdM
	X/60MBBOmljk2co6NYgpoVNOjVF3YBzrcHvRHYG6iK41yGAij1di3voyGYIV4SJq1UGcCI3TZ1s
	+SjVH4ZAQ9RW0aGfM9LhE/cJ9HAZQ+6uSsf9VpBlOvwsMDuwlrJvxKstS06+phvqwSaSWP4FvEA
	6Vscy+ePfkh8womgYdnz0tbKIA5088Az2/GyRCQQgP+wuwyFhsyP7+Bi/RrpkRg/F2egvLjzkfl
	8IDIcncvIqZwwRKLUywiZ7axS/Le7oDsbC5OqIKvZ1F59Ixp+5teTSrQ+9+hdjJHQ==
X-Received: by 2002:a05:622a:1393:b0:50b:29f0:299c with SMTP id d75a77b69052e-50b80e8c042mr31675151cf.60.1774410577844;
        Tue, 24 Mar 2026 20:49:37 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36cb2e29sm150093001cf.1.2026.03.24.20.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 20:49:37 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	quic@lists.linux.dev
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	Thomas Dreibholz <dreibh@simula.no>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	"Marc E . Fiuczynski" <marc@fiuczynski.com>
Subject: [PATCH net-next v11 06/15] quic: add stream management
Date: Tue, 24 Mar 2026 23:47:11 -0400
Message-ID: <91c6fd0a44eb15a98f945171ead8062badb89a60.1774410440.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1774410440.git.lucien.xin@gmail.com>
References: <cover.1774410440.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch introduces 'struct quic_stream_table' for managing QUIC streams,
each represented by 'struct quic_stream'.

It implements mechanisms for acquiring and releasing streams on both the
send and receive paths, ensuring efficient lifecycle management during
transmission and reception.

- quic_stream_get(): Acquire a send-side stream by ID and flags during
  TX path, or a receive-side stream by ID during RX path.

- quic_stream_put(): Release a send-side stream when sending is done,
  or a receive-side stream when receiving is done.

It includes logic to detect when stream ID limits are reached and when
control frames should be sent to update or request limits from the peer.

- quic_stream_id_exceeds(): Check a stream ID would exceed local (recv)
  or peer (send) limits.

- quic_stream_max_streams_update(): Determines whether a
  MAX_STREAMS_UNI/BIDI frame should be sent to the peer.

Note stream hash table is per socket, the operations on it are always
protected by the sock lock.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
v3:
  - Merge send/recv stream helpers into unified functions to reduce code:
    * quic_stream_id_send/recv() → quic_stream_id_valid()
    * quic_stream_id_send/recv_closed() → quic_stream_id_closed()
    * quic_stream_id_send/recv_exceeds() → quic_stream_id_exceeds()
    (pointed out by Paolo).
  - Clarify in changelog that stream hash table is always protected by sock
    lock (suggested by Paolo).
  - quic_stream_init/free(): adjust for new hashtable type; call
    quic_stream_delete() in quic_stream_free() to avoid open-coded logic.
  - Receiving streams: delete stream only when fully read or reset, instead
    of when no data was received. Prevents freeing a stream while a FIN
    with no data is still queued.
v4:
  - Replace struct quic_shash_table with struct hlist_head for the
    stream hashtable. Since they are protected by the socket lock,
    no per-chain lock is needed.
  - Initialize stream to NULL in stream creation functions to avoid
    warnings from Smatch (reported by Simon).
  - Allocate send streams with GFP_KERNEL_ACCOUNT and receive streams
    with GFP_ATOMIC | __GFP_ACCOUNT for memory accounting (suggested
    by Paolo).
v5:
  - Introduce struct quic_stream_limits to merge quic_stream_send_create()
    and quic_stream_recv_create(), and to simplify quic_stream_get_param()
    (suggested by Paolo).
  - Annotate the sock-lock requirement for quic_stream_send/recv_get()
    and quic_stream_send/recv_put() (notied by Paolo).
  - Add quic_stream_bidi_put() to deduplicate the common logic between
    quic_stream_send_put() and quic_stream_recv_put().
  - Remove the unnecessary check when incrementing
    streams->send.next_bidi/uni_stream_id in quic_stream_create().
  - Remove the unused 'is_serv' parameter from quic_stream_get_param().
v7:
  - Free the allocated streams on error path in quic_stream_create() (noted
    by Paolo).
  - Merge quic_stream_send_get/put() and quic_stream_recv_get/put() helpers
    to quic_stream_get/put() (suggested by Paolo).
  - Add more comments in quic_stream_id_exceeds() and quic_stream_create().
v8:
  - Replace bitfields with plain u8 in struct quic_stream_limits and struct
    quic_stream (suggested by Paolo).
v9:
  - Fix grammar in the comment for quic_stream::send.window.
v10:
  - Move quic_stream_init() to after sock_prot_inuse_add() ensure counters
    are incremented before any early return paths in quic_init_sock(),
    preventing underflow in quic_destroy_sock() (noted by AI review).
  - Initialize the output parameters '*max_uni' and '*max_bidi' to 0 at the
    start of quic_stream_max_streams_update()
  - Use 'stream->recv.state > QUIC_STREAM_RECV_STATE_RECVD' instead of '!='
    for clearer intent.
  - Simplify some state checks in quic_stream_put() by using range
    comparisons (> or <) instead of multiple != conditions.
  - streams_uni/bidi are u16 type, and their overflow is already prevented
    by QUIC_MAX_STREAMS indirectly. Update comment in quic_stream_create().
  - Replace open-coded kzalloc(sizeof(*stream)) with kzalloc_obj(*stream)
    in quic_stream_create().
v11:
  - Set maximum line length to 80 characters.
  - Change is_serv parameter type to bool in quic_stream_id_local().
---
 net/quic/Makefile |   2 +-
 net/quic/socket.c |   5 +
 net/quic/socket.h |   8 +
 net/quic/stream.c | 444 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/stream.h | 133 ++++++++++++++
 5 files changed, 591 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/stream.c
 create mode 100644 net/quic/stream.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 13bf4a4e5442..094e9da5d739 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_IP_QUIC) += quic.o
 
-quic-y := common.o family.o protocol.o socket.o
+quic-y := common.o family.o protocol.o socket.o stream.o
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 8dc2cb7628db..0006668551f4 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -45,11 +45,16 @@ static int quic_init_sock(struct sock *sk)
 	sk_sockets_allocated_inc(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 
+	if (quic_stream_init(quic_streams(sk)))
+		return -ENOMEM;
+
 	return 0;
 }
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	quic_stream_free(quic_streams(sk));
+
 	quic_data_free(quic_ticket(sk));
 	quic_data_free(quic_token(sk));
 	quic_data_free(quic_alpn(sk));
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 61df0c5867be..e76737b9b74b 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -13,6 +13,7 @@
 
 #include "common.h"
 #include "family.h"
+#include "stream.h"
 
 #include "protocol.h"
 
@@ -33,6 +34,8 @@ struct quic_sock {
 	struct quic_data		ticket;
 	struct quic_data		token;
 	struct quic_data		alpn;
+
+	struct quic_stream_table	streams;
 };
 
 struct quic6_sock {
@@ -65,6 +68,11 @@ static inline struct quic_data *quic_alpn(const struct sock *sk)
 	return &quic_sk(sk)->alpn;
 }
 
+static inline struct quic_stream_table *quic_streams(const struct sock *sk)
+{
+	return &quic_sk(sk)->streams;
+}
+
 static inline bool quic_is_serv(const struct sock *sk)
 {
 	return !!sk->sk_max_ack_backlog;
diff --git a/net/quic/stream.c b/net/quic/stream.c
new file mode 100644
index 000000000000..4d980f9b03ce
--- /dev/null
+++ b/net/quic/stream.c
@@ -0,0 +1,444 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Initialization/cleanup for QUIC protocol support.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include <linux/quic.h>
+
+#include "common.h"
+#include "stream.h"
+
+/* Check if a stream ID is valid for sending or receiving. */
+static bool quic_stream_id_valid(s64 stream_id, bool is_serv, bool send)
+{
+	u8 type = (stream_id & QUIC_STREAM_TYPE_MASK);
+
+	if (send) {
+		if (is_serv)
+			return type != QUIC_STREAM_TYPE_CLIENT_UNI;
+		return type != QUIC_STREAM_TYPE_SERVER_UNI;
+	}
+	if (is_serv)
+		return type != QUIC_STREAM_TYPE_SERVER_UNI;
+	return type != QUIC_STREAM_TYPE_CLIENT_UNI;
+}
+
+/* Check if a stream ID was initiated locally. */
+static bool quic_stream_id_local(s64 stream_id, bool is_serv)
+{
+	return is_serv ^ !(stream_id & QUIC_STREAM_TYPE_SERVER_MASK);
+}
+
+/* Check if a stream ID represents a unidirectional stream. */
+static bool quic_stream_id_uni(s64 stream_id)
+{
+	return stream_id & QUIC_STREAM_TYPE_UNI_MASK;
+}
+
+#define QUIC_STREAM_HT_SIZE	64
+
+static struct hlist_head *quic_stream_head(struct quic_stream_table *streams,
+					   s64 stream_id)
+{
+	return &streams->head[stream_id & (QUIC_STREAM_HT_SIZE - 1)];
+}
+
+struct quic_stream *quic_stream_find(struct quic_stream_table *streams,
+				     s64 stream_id)
+{
+	struct hlist_head *head = quic_stream_head(streams, stream_id);
+	struct quic_stream *stream;
+
+	hlist_for_each_entry(stream, head, node) {
+		if (stream->id == stream_id)
+			break;
+	}
+	return stream;
+}
+
+static void quic_stream_add(struct quic_stream_table *streams,
+			    struct quic_stream *stream)
+{
+	struct hlist_head *head;
+
+	head = quic_stream_head(streams, stream->id);
+	hlist_add_head(&stream->node, head);
+}
+
+static void quic_stream_delete(struct quic_stream *stream)
+{
+	hlist_del_init(&stream->node);
+	kfree(stream);
+}
+
+/* Create and register new streams for sending or receiving. */
+static struct quic_stream *quic_stream_create(struct quic_stream_table *streams,
+					      s64 max_stream_id, bool send,
+					      bool is_serv)
+{
+	struct quic_stream_limits *limits = &streams->send;
+	struct quic_stream *pos, *stream = NULL;
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
+	struct hlist_node *tmp;
+	HLIST_HEAD(head);
+	s64 stream_id;
+	u32 count = 0;
+
+	if (!send) {
+		limits = &streams->recv;
+		gfp = GFP_ATOMIC | __GFP_ACCOUNT;
+	}
+	stream_id = limits->next_bidi_stream_id;
+	if (quic_stream_id_uni(max_stream_id))
+		stream_id = limits->next_uni_stream_id;
+
+	/* rfc9000#section-2.1: A stream ID that is used out of order results in
+	 * all streams of that type with lower-numbered stream IDs also being
+	 * opened.
+	 */
+	while (stream_id <= max_stream_id) {
+		stream = kzalloc_obj(*stream, gfp);
+		if (!stream)
+			goto free;
+
+		stream->id = stream_id;
+		if (quic_stream_id_uni(stream_id)) {
+			if (send) {
+				stream->send.max_bytes =
+					limits->max_stream_data_uni;
+			} else {
+				stream->recv.max_bytes =
+					limits->max_stream_data_uni;
+				stream->recv.window = stream->recv.max_bytes;
+			}
+			hlist_add_head(&stream->node, &head);
+			stream_id += QUIC_STREAM_ID_STEP;
+			continue;
+		}
+
+		if (quic_stream_id_local(stream_id, is_serv)) {
+			stream->send.max_bytes =
+				streams->send.max_stream_data_bidi_remote;
+			stream->recv.max_bytes =
+				streams->recv.max_stream_data_bidi_local;
+		} else {
+			stream->send.max_bytes =
+				streams->send.max_stream_data_bidi_local;
+			stream->recv.max_bytes =
+				streams->recv.max_stream_data_bidi_remote;
+		}
+		stream->recv.window = stream->recv.max_bytes;
+		hlist_add_head(&stream->node, &head);
+		stream_id += QUIC_STREAM_ID_STEP;
+	}
+
+	hlist_for_each_entry_safe(pos, tmp, &head, node) {
+		hlist_del_init(&pos->node);
+		quic_stream_add(streams, pos);
+		count++;
+	}
+
+	/* Streams must be opened sequentially. Update the next stream ID so the
+	 * correct starting point is known if an out-of-order open is requested.
+	 * Note overflow of next_uni/bidi_stream_id is impossible with s64.
+	 */
+	if (quic_stream_id_uni(stream_id)) {
+		limits->next_uni_stream_id = stream_id;
+		limits->streams_uni += count;
+		return stream;
+	}
+
+	limits->next_bidi_stream_id = stream_id;
+	limits->streams_bidi += count;
+	return stream;
+
+free:
+	hlist_for_each_entry_safe(pos, tmp, &head, node) {
+		hlist_del_init(&pos->node);
+		kfree(pos);
+	}
+	return NULL;
+}
+
+/* Check if a send or receive stream ID is already closed. */
+static bool quic_stream_id_closed(struct quic_stream_table *streams,
+				  s64 stream_id, bool send)
+{
+	struct quic_stream_limits *limits = send ? &streams->send :
+						   &streams->recv;
+
+	if (quic_stream_id_uni(stream_id))
+		return stream_id < limits->next_uni_stream_id;
+	return stream_id < limits->next_bidi_stream_id;
+}
+
+/* Check if a stream ID would exceed local (recv) or peer (send) limits. */
+bool quic_stream_id_exceeds(struct quic_stream_table *streams, s64 stream_id,
+			    bool send)
+{
+	u64 nstreams;
+
+	if (!send) {
+		/* recv.max_uni_stream_id is updated in
+		 * quic_stream_max_streams_update() already based on
+		 * next_uni/bidi_stream_id, max_streams_uni/bidi, and
+		 * streams_uni/bidi, so only recv.max_uni_stream_id needs to be
+		 * checked.
+		 */
+		if (quic_stream_id_uni(stream_id))
+			return stream_id > streams->recv.max_uni_stream_id;
+
+		return stream_id > streams->recv.max_bidi_stream_id;
+	}
+
+	if (quic_stream_id_uni(stream_id)) {
+		if (stream_id > streams->send.max_uni_stream_id)
+			return true;
+		stream_id -= streams->send.next_uni_stream_id;
+		nstreams = quic_stream_id_to_streams(stream_id);
+
+		return nstreams + streams->send.streams_uni >
+		       streams->send.max_streams_uni;
+	}
+
+	if (stream_id > streams->send.max_bidi_stream_id)
+		return true;
+	stream_id -= streams->send.next_bidi_stream_id;
+	nstreams = quic_stream_id_to_streams(stream_id);
+
+	return nstreams + streams->send.streams_bidi >
+	       streams->send.max_streams_bidi;
+}
+
+/* Get or create a send or recv stream by ID. Requires sock lock held. */
+struct quic_stream *quic_stream_get(struct quic_stream_table *streams,
+				    s64 stream_id, u32 flags, bool is_serv,
+				    bool send)
+{
+	struct quic_stream *stream;
+
+	if (!quic_stream_id_valid(stream_id, is_serv, send))
+		return ERR_PTR(-EINVAL);
+
+	stream = quic_stream_find(streams, stream_id);
+	if (stream) {
+		if (send && (flags & MSG_QUIC_STREAM_NEW) &&
+		    stream->send.state != QUIC_STREAM_SEND_STATE_READY)
+			return ERR_PTR(-EINVAL);
+		return stream;
+	}
+
+	if (!send && quic_stream_id_local(stream_id, is_serv)) {
+		if (quic_stream_id_closed(streams, stream_id, !send))
+			return ERR_PTR(-ENOSTR);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (quic_stream_id_closed(streams, stream_id, send))
+		return ERR_PTR(-ENOSTR);
+
+	if (send && !(flags & MSG_QUIC_STREAM_NEW))
+		return ERR_PTR(-EINVAL);
+
+	if (quic_stream_id_exceeds(streams, stream_id, send))
+		return ERR_PTR(-EAGAIN);
+
+	stream = quic_stream_create(streams, stream_id, send, is_serv);
+	if (!stream)
+		return ERR_PTR(-ENOSTR);
+
+	if (send || quic_stream_id_valid(stream_id, is_serv, !send))
+		streams->send.active_stream_id = stream_id;
+
+	return stream;
+}
+
+/* Release or clean up a send or recv stream. This function updates stream
+ * counters and state when a send stream has either successfully sent all data
+ * or has been reset, or when a recv stream has either consumed all data or has
+ * been reset. Requires sock lock held.
+ */
+void quic_stream_put(struct quic_stream_table *streams,
+		     struct quic_stream *stream, bool is_serv, bool send)
+{
+	if (quic_stream_id_uni(stream->id)) {
+		if (send) {
+			/* For uni streams, decrement uni count and delete
+			 * immediately.
+			 */
+			streams->send.streams_uni--;
+			quic_stream_delete(stream);
+			return;
+		}
+		/* For uni streams, decrement uni count and mark done. */
+		if (!stream->recv.done) {
+			stream->recv.done = 1;
+			streams->recv.streams_uni--;
+			streams->recv.uni_pending = 1;
+		}
+		/* Delete stream if fully read or reset. */
+		if (stream->recv.state > QUIC_STREAM_RECV_STATE_RECVD)
+			quic_stream_delete(stream);
+		return;
+	}
+
+	if (send) {
+		/* For bidi streams, only proceed if receive side is in a final
+		 * state.
+		 */
+		if (stream->recv.state < QUIC_STREAM_RECV_STATE_RECVD)
+			return;
+	} else {
+		/* For bidi streams, only proceed if send side is in a final
+		 * state.
+		 */
+		if (stream->send.state != QUIC_STREAM_SEND_STATE_RECVD &&
+		    stream->send.state != QUIC_STREAM_SEND_STATE_RESET_RECVD)
+			return;
+	}
+
+	if (quic_stream_id_local(stream->id, is_serv)) {
+		/* Local-initiated stream: mark send done and decrement
+		 * send.bidi count.
+		 */
+		if (!stream->send.done) {
+			stream->send.done = 1;
+			streams->send.streams_bidi--;
+		}
+	} else {
+		/* Remote-initiated stream: mark recv done and decrement recv
+		 * bidi count.
+		 */
+		if (!stream->recv.done) {
+			stream->recv.done = 1;
+			streams->recv.streams_bidi--;
+			streams->recv.bidi_pending = 1;
+		}
+	}
+
+	/* Delete stream if fully read or reset. */
+	if (stream->recv.state > QUIC_STREAM_RECV_STATE_RECVD)
+		quic_stream_delete(stream);
+}
+
+/* Updates the maximum allowed incoming stream IDs if any streams were recently
+ * closed.  Recalculates the max_uni and max_bidi stream ID limits based on the
+ * number of open streams and whether any were marked for deletion.
+ *
+ * Returns true if either max_uni or max_bidi was updated, indicating that a
+ * MAX_STREAMS_UNI or MAX_STREAMS_BIDI frame should be sent to the peer.
+ */
+bool quic_stream_max_streams_update(struct quic_stream_table *streams,
+				    s64 *max_uni, s64 *max_bidi)
+{
+	s64 max, rem;
+
+	*max_uni = 0;
+	*max_bidi = 0;
+	if (streams->recv.uni_pending) {
+		rem = streams->recv.max_streams_uni - streams->recv.streams_uni;
+		max = streams->recv.next_uni_stream_id - QUIC_STREAM_ID_STEP +
+		      (rem << QUIC_STREAM_TYPE_BITS);
+
+		streams->recv.max_uni_stream_id = max;
+		*max_uni = quic_stream_id_to_streams(max);
+		streams->recv.uni_pending = 0;
+	}
+	if (streams->recv.bidi_pending) {
+		rem = streams->recv.max_streams_bidi -
+		      streams->recv.streams_bidi;
+		max = streams->recv.next_bidi_stream_id - QUIC_STREAM_ID_STEP +
+			(rem << QUIC_STREAM_TYPE_BITS);
+
+		streams->recv.max_bidi_stream_id = max;
+		*max_bidi = quic_stream_id_to_streams(max);
+		streams->recv.bidi_pending = 0;
+	}
+
+	return *max_uni || *max_bidi;
+}
+
+int quic_stream_init(struct quic_stream_table *streams)
+{
+	struct hlist_head *head;
+	int i;
+
+	head = kmalloc_array(QUIC_STREAM_HT_SIZE, sizeof(*head), GFP_KERNEL);
+	if (!head)
+		return -ENOMEM;
+	for (i = 0; i < QUIC_STREAM_HT_SIZE; i++)
+		INIT_HLIST_HEAD(&head[i]);
+	streams->head = head;
+	return 0;
+}
+
+void quic_stream_free(struct quic_stream_table *streams)
+{
+	struct quic_stream *stream;
+	struct hlist_head *head;
+	struct hlist_node *tmp;
+	int i;
+
+	if (!streams->head)
+		return;
+
+	for (i = 0; i < QUIC_STREAM_HT_SIZE; i++) {
+		head = &streams->head[i];
+		hlist_for_each_entry_safe(stream, tmp, head, node)
+			quic_stream_delete(stream);
+	}
+	kfree(streams->head);
+}
+
+/* Populate transport parameters from stream hash table. */
+void quic_stream_get_param(struct quic_stream_table *streams,
+			   struct quic_transport_param *p)
+{
+	struct quic_stream_limits *limits = p->remote ? &streams->send :
+							&streams->recv;
+
+	p->max_stream_data_bidi_remote = limits->max_stream_data_bidi_remote;
+	p->max_stream_data_bidi_local = limits->max_stream_data_bidi_local;
+	p->max_stream_data_uni = limits->max_stream_data_uni;
+	p->max_streams_bidi = limits->max_streams_bidi;
+	p->max_streams_uni = limits->max_streams_uni;
+}
+
+/* Configure stream hashtable from transport parameters. */
+void quic_stream_set_param(struct quic_stream_table *streams,
+			   struct quic_transport_param *p, bool is_serv)
+{
+	struct quic_stream_limits *limits = p->remote ? &streams->send :
+							&streams->recv;
+	u8 bidi_type, uni_type;
+
+	limits->max_stream_data_bidi_local = p->max_stream_data_bidi_local;
+	limits->max_stream_data_bidi_remote = p->max_stream_data_bidi_remote;
+	limits->max_stream_data_uni = p->max_stream_data_uni;
+	limits->max_streams_bidi = p->max_streams_bidi;
+	limits->max_streams_uni = p->max_streams_uni;
+	limits->active_stream_id = -1;
+
+	if (p->remote ^ is_serv) {
+		bidi_type = QUIC_STREAM_TYPE_CLIENT_BIDI;
+		uni_type = QUIC_STREAM_TYPE_CLIENT_UNI;
+	} else {
+		bidi_type = QUIC_STREAM_TYPE_SERVER_BIDI;
+		uni_type = QUIC_STREAM_TYPE_SERVER_UNI;
+	}
+
+	limits->max_bidi_stream_id =
+		quic_stream_streams_to_id(p->max_streams_bidi, bidi_type);
+	limits->next_bidi_stream_id = bidi_type;
+
+	limits->max_uni_stream_id =
+		quic_stream_streams_to_id(p->max_streams_uni, uni_type);
+	limits->next_uni_stream_id = uni_type;
+}
diff --git a/net/quic/stream.h b/net/quic/stream.h
new file mode 100644
index 000000000000..435ae1246e05
--- /dev/null
+++ b/net/quic/stream.h
@@ -0,0 +1,133 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#define QUIC_DEF_STREAMS	100
+#define QUIC_MAX_STREAMS	4096ULL
+
+/*
+ * rfc9000#section-2.1:
+ *
+ *   The least significant bit (0x01) of the stream ID identifies the initiator
+ *   of the stream.  Client-initiated streams have even-numbered stream IDs
+ *   (with the bit set to 0), and server-initiated streams have odd-numbered
+ *   stream IDs (with the bit set to 1).
+ *
+ *   The second least significant bit (0x02) of the stream ID distinguishes
+ *   between bidirectional streams (with the bit set to 0) and unidirectional
+ *   streams (with the bit set to 1).
+ */
+#define QUIC_STREAM_TYPE_BITS	2
+#define QUIC_STREAM_ID_STEP	BIT(QUIC_STREAM_TYPE_BITS)
+
+#define QUIC_STREAM_TYPE_CLIENT_BIDI	0x00
+#define QUIC_STREAM_TYPE_SERVER_BIDI	0x01
+#define QUIC_STREAM_TYPE_CLIENT_UNI	0x02
+#define QUIC_STREAM_TYPE_SERVER_UNI	0x03
+
+struct quic_stream {
+	struct hlist_node node;
+	s64 id; /* Stream ID as defined in RFC 9000 Section 2.1 */
+	struct {
+		/* Sending-side stream level flow control */
+		u64 last_max_bytes; /* Max send offset advertised by peer */
+		u64 max_bytes;      /* Max offset allowed to send */
+		u64 bytes;          /* Bytes already sent to peer */
+
+		u32 errcode; /* App error code for RESET_STREAM */
+		u32 frags;   /* STREAM frames sent but not yet acked */
+		u8 state;    /* Send stream state, per rfc9000#section-3.1 */
+
+		u8 data_blocked; /* True if flow control blocks sending */
+		u8 done;         /* True if FIN has been sent */
+	} send;
+	struct {
+		/* Receiving-side stream level flow control */
+		u64 max_bytes; /* Max offset peer can send */
+		u64 window;    /* Remaining receive window */
+		u64 bytes;     /* Bytes consumed by app */
+
+		u64 highest; /* Highest received offset */
+		u64 offset;  /* Data buffered or consumed */
+		u64 finalsz; /* Final stream size if FIN received */
+
+		u32 frags; /* STREAM frames pending reassembly */
+		u8 state;  /* Receive stream state, per rfc9000#section-3.2 */
+
+		u8 stop_sent; /* True if STOP_SENDING has been sent */
+		u8 done;      /* True if all data has been received or read */
+	} recv;
+};
+
+struct quic_stream_limits {
+	/* Stream limit parameters defined in rfc9000#section-18.2:
+	 *
+	 * - initial_max_stream_data_bidi_remote
+	 * - initial_max_stream_data_bidi_local
+	 * - initial_max_stream_data_uni
+	 * - initial_max_streams_bidi
+	 * - initial_max_streams_uni
+	 */
+	u64 max_stream_data_bidi_remote;
+	u64 max_stream_data_bidi_local;
+	u64 max_stream_data_uni;
+	u64 max_streams_bidi;
+	u64 max_streams_uni;
+
+	s64 next_bidi_stream_id; /* Next bidi stream ID to open or accept */
+	s64 next_uni_stream_id;  /* Next uni stream ID to open or accept */
+	s64 max_bidi_stream_id;  /* Highest allowed bidi stream ID */
+	s64 max_uni_stream_id;   /* Highest allowed uni stream ID */
+	s64 active_stream_id;    /* Most recently opened stream ID */
+
+	u8 bidi_blocked;  /* STREAMS_BLOCKED_BIDI sent, awaiting ACK */
+	u8 uni_blocked;   /* STREAMS_BLOCKED_UNI sent, awaiting ACK */
+	u8 bidi_pending;  /* MAX_STREAMS_BIDI needs to be sent */
+	u8 uni_pending;   /* MAX_STREAMS_UNI needs to be sent */
+
+	u16 streams_bidi; /* Number of open bidi streams */
+	u16 streams_uni;  /* Number of open uni streams */
+};
+
+struct quic_stream_table {
+	struct hlist_head *head; /* Hash table storing all active streams */
+
+	struct quic_stream_limits send; /* Limits advertised by peer */
+	struct quic_stream_limits recv; /* Limits we advertise to peer */
+};
+
+static inline u64 quic_stream_id_to_streams(s64 stream_id)
+{
+	return (u64)(stream_id >> QUIC_STREAM_TYPE_BITS) + 1;
+}
+
+static inline s64 quic_stream_streams_to_id(u64 streams, u8 type)
+{
+	return (s64)((streams - 1) << QUIC_STREAM_TYPE_BITS) | type;
+}
+
+struct quic_stream *quic_stream_get(struct quic_stream_table *streams,
+				    s64 stream_id, u32 flags, bool is_serv,
+				    bool send);
+void quic_stream_put(struct quic_stream_table *streams,
+		     struct quic_stream *stream, bool is_serv, bool send);
+
+bool quic_stream_max_streams_update(struct quic_stream_table *streams,
+				    s64 *max_uni, s64 *max_bidi);
+bool quic_stream_id_exceeds(struct quic_stream_table *streams,
+			    s64 stream_id, bool send);
+struct quic_stream *quic_stream_find(struct quic_stream_table *streams,
+				     s64 stream_id);
+
+void quic_stream_get_param(struct quic_stream_table *streams,
+			   struct quic_transport_param *p);
+void quic_stream_set_param(struct quic_stream_table *streams,
+			   struct quic_transport_param *p, bool is_serv);
+void quic_stream_free(struct quic_stream_table *streams);
+int quic_stream_init(struct quic_stream_table *streams);
-- 
2.47.1

