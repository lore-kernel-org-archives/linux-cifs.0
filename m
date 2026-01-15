Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26263ACF15
	for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768490163; cv=none; b=kAQ5N1yi0ulxr10yWLF5Votua0/FYmpEz99ekmN81OPEED9Pa9k6i/fbEywxZ8tvfpqZCvDrjBdVaibsR+X4N7phvu52suj2Xb88yCSqLj4jqSfIlqmDofRsZQh9XEJ075bTvLonUS7sUVg67ZQ7dfQ+q8csGkpZ/zUTQlfn5vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768490163; c=relaxed/simple;
	bh=dw2tFlinJ5BVpllomg/570NAjZ5aBzNuYjax9DYAWoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TM0+3akAqYKxfmyXC2nGafaoDNfDqw6ysWmWdIRrFwTPhJ7I8uJ14DTF+8S6IoUe3jf+Vy6HOxHoc93WarnOnXsGXBcyqXArFG6IDGm6Ff9iQRbOV2xc7cSJVFNVStVej6bEIJiggrA6bzWouDfXEmUElK2Z6TZIjXmnj9ZH6yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHN1RkOt; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHN1RkOt"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5014db8e268so15390031cf.1
        for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 07:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768490144; x=1769094944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HPOqFbv8f2bTTqLty8ZQt/CSVRabcURUaVYXzGaSWjc=;
        b=HHN1RkOt+iVpqK18cc5X25goFDqTa2whOwvZqqeY72XjburLcauXuX1en/9Ps7ylxB
         uXQAeBcCz0oPC1xTLXMXMqIesf013Ywq8HpH8XT9pDaqvXdP5cXqtl6gIkRVnlUU54ri
         49j7p5MASpv8g7urJXg5uAS+a2U6N5DyHW9N7yAwMn/NBm/BY4t3BzE9xQIl0DfIxL/N
         R/pahJkjBRgM02CO1en+jWN59KEeEay1b2w2YkW4tL8trAv5DZ4Zim8IyOYOn1EiwcY/
         wOeKdApHfClxyjTTVyTAjCqTs+o0x6hak4HLusFkoqAFWmhb60x+00+bDBDZepLEstIL
         gRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768490144; x=1769094944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HPOqFbv8f2bTTqLty8ZQt/CSVRabcURUaVYXzGaSWjc=;
        b=SVCYVEKiNlKZQ/efZAeQsrdjBXio0IFhoc199Pvjqa9mx1ffVoiPYnXk5/sgKpPmgh
         K7UI62Tew8qGaWsubmvQk203KqzDWvNvwG+trffOQdJeUchlFOzfskVkvgasVel+CF7W
         Nafu5NdgN2ZZ3VIb6kTOnTJB2PdjYJwT8DXWLfJPMaAwqdvWFf7PgltD4Syo/uXJbTxC
         WmpJxBYKTfXXwTJpYWjb0rMpDlDDLmj1dXvFXwzEHl6QOJBAqwubZwUCAEGWN+di7eYy
         CE4NN60H3MS1IKsdU919VLoEKEVS7mzKRqGbrl50woqDRQRBcx1zgHVEQet34zww8CZ6
         v8bA==
X-Forwarded-Encrypted: i=1; AJvYcCXI94UYYtXgQQK0xliD5oBDQwdkxCrIM3O/ASApa7/pAlsSuRB+L6EoQWkyXoJAyLr3PLriZEhsUWTL@vger.kernel.org
X-Gm-Message-State: AOJu0YzGfuRQQA+8iNe+gch1NqVgqg8r5OHO4YXO5z4FIvu9bebJDY/H
	dXDMJdhKGGuKkUrzhfQnsdbYzPmT1+QcTnfWlvFGbfZskAZbeZTTd1f3
X-Gm-Gg: AY/fxX5ieTMM83maFCDK9550PTTMxlMIw0TOJ/C9VvIHeOeG1PnTqAhf/ApBG7iI+o3
	WFp+M2YIklP10SgUH+iZ59fq7BnhXOc9WX86yn4Zj9mDD3SXMGYt91ff3zPmjXslaV9JTunzQ5v
	lnU18wUocOnYvUf3xbsDrnHr24OFHSANsrIP0GPYZGaz/gcpvZRyxD6Jn2Yz0+mKFOh+6Rh2Lzt
	K+ei+PKrH0yUW9En29IQwGgk2YzUSzJwObOgAjEUKi4ud4QdA6ZGI9Ru+h5wBbqpMImvs8v+hqs
	XBpSWMSY3NnQqldJCY3XLknBfXBZu6wKGgvfHLkRue2GdeTGrnu823R49n2MvfCuY0b/s3zyToc
	zE2Xf+D++JmhAb0LiD6ShbxZ9fh4UAyeLCwHF9oHQXpc31LWLBPHKnb1yDp9VyygXDeilTwo/8q
	a8kz2Pk4mbnMilRsuiExKmcD5rUIQ3HBYC0uIjQq5N7ZWDBHW6ybY=
X-Received: by 2002:a05:622a:28c:b0:4ed:da56:7a96 with SMTP id d75a77b69052e-501484b1218mr104138411cf.60.1768490142873;
        Thu, 15 Jan 2026 07:15:42 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770cc6edsm201030056d6.4.2026.01.15.07.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 07:15:42 -0800 (PST)
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
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next v7 06/16] quic: add stream management
Date: Thu, 15 Jan 2026 10:11:06 -0500
Message-ID: <e3f770ef8d9aba101e1f5dc2f2f72bb0d2a30b94.1768489876.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1768489876.git.lucien.xin@gmail.com>
References: <cover.1768489876.git.lucien.xin@gmail.com>
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
---
 net/quic/Makefile |   2 +-
 net/quic/socket.c |   5 +
 net/quic/socket.h |   8 +
 net/quic/stream.c | 400 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/stream.h | 119 ++++++++++++++
 5 files changed, 533 insertions(+), 1 deletion(-)
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
index b86989080184..d6f25669c693 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -41,6 +41,9 @@ static int quic_init_sock(struct sock *sk)
 	sk->sk_write_space = quic_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
 
+	if (quic_stream_init(quic_streams(sk)))
+		return -ENOMEM;
+
 	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sysctl_quic_wmem[1]));
 	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sysctl_quic_rmem[1]));
 
@@ -52,6 +55,8 @@ static int quic_init_sock(struct sock *sk)
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	quic_stream_free(quic_streams(sk));
+
 	quic_data_free(quic_ticket(sk));
 	quic_data_free(quic_token(sk));
 	quic_data_free(quic_alpn(sk));
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 7ee190af4454..0dfd3f8f3115 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -13,6 +13,7 @@
 
 #include "common.h"
 #include "family.h"
+#include "stream.h"
 
 #include "protocol.h"
 
@@ -34,6 +35,8 @@ struct quic_sock {
 	struct quic_data		ticket;
 	struct quic_data		token;
 	struct quic_data		alpn;
+
+	struct quic_stream_table	streams;
 };
 
 struct quic6_sock {
@@ -71,6 +74,11 @@ static inline struct quic_data *quic_alpn(const struct sock *sk)
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
index 000000000000..060280657c17
--- /dev/null
+++ b/net/quic/stream.c
@@ -0,0 +1,400 @@
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
+static bool quic_stream_id_local(s64 stream_id, u8 is_serv)
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
+static struct hlist_head *quic_stream_head(struct quic_stream_table *streams, s64 stream_id)
+{
+	return &streams->head[stream_id & (QUIC_STREAM_HT_SIZE - 1)];
+}
+
+struct quic_stream *quic_stream_find(struct quic_stream_table *streams, s64 stream_id)
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
+static void quic_stream_add(struct quic_stream_table *streams, struct quic_stream *stream)
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
+					      s64 max_stream_id, bool send, bool is_serv)
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
+	/* rfc9000#section-2.1: A stream ID that is used out of order results in all streams
+	 * of that type with lower-numbered stream IDs also being opened.
+	 */
+	while (stream_id <= max_stream_id) {
+		stream = kzalloc(sizeof(*stream), gfp);
+		if (!stream)
+			goto free;
+
+		stream->id = stream_id;
+		if (quic_stream_id_uni(stream_id)) {
+			if (send) {
+				stream->send.max_bytes = limits->max_stream_data_uni;
+			} else {
+				stream->recv.max_bytes = limits->max_stream_data_uni;
+				stream->recv.window = stream->recv.max_bytes;
+			}
+			hlist_add_head(&stream->node, &head);
+			stream_id += QUIC_STREAM_ID_STEP;
+			continue;
+		}
+
+		if (quic_stream_id_local(stream_id, is_serv)) {
+			stream->send.max_bytes = streams->send.max_stream_data_bidi_remote;
+			stream->recv.max_bytes = streams->recv.max_stream_data_bidi_local;
+		} else {
+			stream->send.max_bytes = streams->send.max_stream_data_bidi_local;
+			stream->recv.max_bytes = streams->recv.max_stream_data_bidi_remote;
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
+	/* Streams must be opened sequentially. Update the next stream ID so the correct
+	 * starting point is known if an out-of-order open is requested.  Note overflow
+	 * of next_uni/bidi_stream_id and streams_uni/bidi is impossible with u64.
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
+static bool quic_stream_id_closed(struct quic_stream_table *streams, s64 stream_id, bool send)
+{
+	struct quic_stream_limits *limits = send ? &streams->send : &streams->recv;
+
+	if (quic_stream_id_uni(stream_id))
+		return stream_id < limits->next_uni_stream_id;
+	return stream_id < limits->next_bidi_stream_id;
+}
+
+/* Check if a stream ID would exceed local (recv) or peer (send) limits. */
+bool quic_stream_id_exceeds(struct quic_stream_table *streams, s64 stream_id, bool send)
+{
+	u64 nstreams;
+
+	if (!send) {
+		/* recv.max_uni_stream_id is updated in quic_stream_max_streams_update()
+		 * already based on next_uni/bidi_stream_id, max_streams_uni/bidi, and
+		 * streams_uni/bidi, so only recv.max_uni_stream_id needs to be checked.
+		 */
+		if (quic_stream_id_uni(stream_id))
+			return stream_id > streams->recv.max_uni_stream_id;
+		return stream_id > streams->recv.max_bidi_stream_id;
+	}
+
+	if (quic_stream_id_uni(stream_id)) {
+		if (stream_id > streams->send.max_uni_stream_id)
+			return true;
+		stream_id -= streams->send.next_uni_stream_id;
+		nstreams = quic_stream_id_to_streams(stream_id);
+		return nstreams + streams->send.streams_uni > streams->send.max_streams_uni;
+	}
+
+	if (stream_id > streams->send.max_bidi_stream_id)
+		return true;
+	stream_id -= streams->send.next_bidi_stream_id;
+	nstreams = quic_stream_id_to_streams(stream_id);
+	return nstreams + streams->send.streams_bidi > streams->send.max_streams_bidi;
+}
+
+/* Get or create a send or recv stream by ID. Requires sock lock held. */
+struct quic_stream *quic_stream_get(struct quic_stream_table *streams, s64 stream_id, u32 flags,
+				    bool is_serv, bool send)
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
+/* Release or clean up a send or recv stream. This function updates stream counters and state
+ * when a send stream has either successfully sent all data or has been reset, or when a recv
+ * stream has either consumed all data or has been reset. Requires sock lock held.
+ */
+void quic_stream_put(struct quic_stream_table *streams, struct quic_stream *stream, bool is_serv,
+		     bool send)
+{
+	if (quic_stream_id_uni(stream->id)) {
+		if (send) {
+			/* For uni streams, decrement uni count and delete immediately. */
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
+		if (stream->recv.state != QUIC_STREAM_RECV_STATE_RECVD)
+			quic_stream_delete(stream);
+		return;
+	}
+
+	if (send) {
+		/* For bidi streams, only proceed if receive side is in a final state. */
+		if (stream->recv.state != QUIC_STREAM_RECV_STATE_RECVD &&
+		    stream->recv.state != QUIC_STREAM_RECV_STATE_READ &&
+		    stream->recv.state != QUIC_STREAM_RECV_STATE_RESET_RECVD)
+			return;
+	} else {
+		/* For bidi streams, only proceed if send side is in a final state. */
+		if (stream->send.state != QUIC_STREAM_SEND_STATE_RECVD &&
+		    stream->send.state != QUIC_STREAM_SEND_STATE_RESET_RECVD)
+			return;
+	}
+
+	if (quic_stream_id_local(stream->id, is_serv)) {
+		/* Local-initiated stream: mark send done and decrement send.bidi count. */
+		if (!stream->send.done) {
+			stream->send.done = 1;
+			streams->send.streams_bidi--;
+		}
+	} else {
+		/* Remote-initiated stream: mark recv done and decrement recv bidi count. */
+		if (!stream->recv.done) {
+			stream->recv.done = 1;
+			streams->recv.streams_bidi--;
+			streams->recv.bidi_pending = 1;
+		}
+	}
+
+	/* Delete stream if fully read or reset. */
+	if (stream->recv.state != QUIC_STREAM_RECV_STATE_RECVD)
+		quic_stream_delete(stream);
+}
+
+/* Updates the maximum allowed incoming stream IDs if any streams were recently closed.
+ * Recalculates the max_uni and max_bidi stream ID limits based on the number of open
+ * streams and whether any were marked for deletion.
+ *
+ * Returns true if either max_uni or max_bidi was updated, indicating that a
+ * MAX_STREAMS_UNI or MAX_STREAMS_BIDI frame should be sent to the peer.
+ */
+bool quic_stream_max_streams_update(struct quic_stream_table *streams, s64 *max_uni, s64 *max_bidi)
+{
+	if (streams->recv.uni_pending) {
+		streams->recv.max_uni_stream_id =
+			streams->recv.next_uni_stream_id - QUIC_STREAM_ID_STEP +
+			((streams->recv.max_streams_uni - streams->recv.streams_uni) <<
+			 QUIC_STREAM_TYPE_BITS);
+		*max_uni = quic_stream_id_to_streams(streams->recv.max_uni_stream_id);
+		streams->recv.uni_pending = 0;
+	}
+	if (streams->recv.bidi_pending) {
+		streams->recv.max_bidi_stream_id =
+			streams->recv.next_bidi_stream_id - QUIC_STREAM_ID_STEP +
+			((streams->recv.max_streams_bidi - streams->recv.streams_bidi) <<
+			 QUIC_STREAM_TYPE_BITS);
+		*max_bidi = quic_stream_id_to_streams(streams->recv.max_bidi_stream_id);
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
+void quic_stream_get_param(struct quic_stream_table *streams, struct quic_transport_param *p)
+{
+	struct quic_stream_limits *limits = p->remote ? &streams->send : &streams->recv;
+
+	p->max_stream_data_bidi_remote = limits->max_stream_data_bidi_remote;
+	p->max_stream_data_bidi_local = limits->max_stream_data_bidi_local;
+	p->max_stream_data_uni = limits->max_stream_data_uni;
+	p->max_streams_bidi = limits->max_streams_bidi;
+	p->max_streams_uni = limits->max_streams_uni;
+}
+
+/* Configure stream hashtable from transport parameters. */
+void quic_stream_set_param(struct quic_stream_table *streams, struct quic_transport_param *p,
+			   bool is_serv)
+{
+	struct quic_stream_limits *limits = p->remote ? &streams->send : &streams->recv;
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
+	limits->max_bidi_stream_id = quic_stream_streams_to_id(p->max_streams_bidi, bidi_type);
+	limits->next_bidi_stream_id = bidi_type;
+
+	limits->max_uni_stream_id = quic_stream_streams_to_id(p->max_streams_uni, uni_type);
+	limits->next_uni_stream_id = uni_type;
+}
diff --git a/net/quic/stream.h b/net/quic/stream.h
new file mode 100644
index 000000000000..abacb6424dec
--- /dev/null
+++ b/net/quic/stream.h
@@ -0,0 +1,119 @@
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
+ *   The least significant bit (0x01) of the stream ID identifies the initiator of the stream.
+ *   Client-initiated streams have even-numbered stream IDs (with the bit set to 0), and
+ *   server-initiated streams have odd-numbered stream IDs (with the bit set to 1).
+ *
+ *   The second least significant bit (0x02) of the stream ID distinguishes between bidirectional
+ *   streams (with the bit set to 0) and unidirectional streams (with the bit set to 1).
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
+	s64 id;				/* Stream ID as defined in RFC 9000 Section 2.1 */
+	struct {
+		/* Sending-side stream level flow control */
+		u64 last_max_bytes;	/* Maximum send offset advertised by peer at last update */
+		u64 max_bytes;		/* Current maximum offset we are allowed to send to */
+		u64 bytes;		/* Bytes already sent to peer */
+
+		u32 errcode;		/* Application error code to send in RESET_STREAM */
+		u32 frags;		/* Number of sent STREAM frames not yet acknowledged */
+		u8 state;		/* Send stream state, per rfc9000#section-3.1 */
+
+		u8 data_blocked:1;	/* True if flow control blocks sending more data */
+		u8 done:1;		/* True if application indicated end of stream (FIN sent) */
+	} send;
+	struct {
+		/* Receiving-side stream level flow control */
+		u64 max_bytes;		/* Maximum offset peer is allowed to send to */
+		u64 window;		/* Remaining receive window before advertise a new limit */
+		u64 bytes;		/* Bytes consumed by application from the stream */
+
+		u64 highest;		/* Highest received offset */
+		u64 offset;		/* Offset up to which data is in buffer or consumed */
+		u64 finalsz;		/* Final size of the stream if FIN received */
+
+		u32 frags;		/* Number of received STREAM frames pending reassembly */
+		u8 state;		/* Receive stream state, per rfc9000#section-3.2 */
+
+		u8 stop_sent:1;		/* True if STOP_SENDING has been sent */
+		u8 done:1;		/* True if FIN received and final size validated */
+	} recv;
+};
+
+struct quic_stream_limits {
+	/* Stream limit parameters defined in rfc9000#section-18.2 */
+	u64 max_stream_data_bidi_remote;	/* initial_max_stream_data_bidi_remote */
+	u64 max_stream_data_bidi_local;		/* initial_max_stream_data_bidi_local */
+	u64 max_stream_data_uni;		/* initial_max_stream_data_uni */
+	u64 max_streams_bidi;			/* initial_max_streams_bidi */
+	u64 max_streams_uni;			/* initial_max_streams_uni */
+
+	s64 next_bidi_stream_id;	/* Next bidi stream ID to open or accept */
+	s64 next_uni_stream_id;		/* Next uni stream ID to open or accept */
+	s64 max_bidi_stream_id;		/* Highest allowed bidi stream ID */
+	s64 max_uni_stream_id;		/* Highest allowed uni stream ID */
+	s64 active_stream_id;		/* Most recently opened stream ID */
+
+	u8 bidi_blocked:1;	/* STREAMS_BLOCKED_BIDI sent, awaiting ACK */
+	u8 uni_blocked:1;	/* STREAMS_BLOCKED_UNI sent, awaiting ACK */
+	u8 bidi_pending:1;	/* MAX_STREAMS_BIDI needs to be sent */
+	u8 uni_pending:1;	/* MAX_STREAMS_UNI needs to be sent */
+
+	u16 streams_bidi;	/* Number of open bidi streams */
+	u16 streams_uni;	/* Number of open uni streams */
+};
+
+struct quic_stream_table {
+	struct hlist_head *head;	/* Hash table storing all active streams */
+
+	struct quic_stream_limits send;	/* Limits advertised by peer */
+	struct quic_stream_limits recv;	/* Limits we advertise to peer */
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
+struct quic_stream *quic_stream_get(struct quic_stream_table *streams, s64 stream_id, u32 flags,
+				    bool is_serv, bool send);
+void quic_stream_put(struct quic_stream_table *streams, struct quic_stream *stream, bool is_serv,
+		     bool send);
+
+bool quic_stream_max_streams_update(struct quic_stream_table *streams, s64 *max_uni, s64 *max_bidi);
+bool quic_stream_id_exceeds(struct quic_stream_table *streams, s64 stream_id, bool send);
+struct quic_stream *quic_stream_find(struct quic_stream_table *streams, s64 stream_id);
+
+void quic_stream_get_param(struct quic_stream_table *streams, struct quic_transport_param *p);
+void quic_stream_set_param(struct quic_stream_table *streams, struct quic_transport_param *p,
+			   bool is_serv);
+void quic_stream_free(struct quic_stream_table *streams);
+int quic_stream_init(struct quic_stream_table *streams);
-- 
2.47.1

