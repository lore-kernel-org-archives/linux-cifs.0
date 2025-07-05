Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EEB1FBE8C;
	Sat,  5 Jul 2025 19:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751744337; cv=none; b=nEMsFQb0EXGrnixrYdpsfnelG1kRyG1rZGooBYZhYNf8U2hN6oJgY8ujmfSmhBe9Y2Lk0S1aW+vVPL4iyYuF3nOMkXO6F19Wcr1Yo8Cj0Ze4zSDBpOLYeSUU5pNb+AWwUgI1R2S5nuyQhzKT4M5OPl+JmwKProEuE3tmp4ifxDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751744337; c=relaxed/simple;
	bh=iEN7+m5Q8csUKbKOO5stb5QeGRVwsm7oc2iKj4Vb4Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tu/G24/AVoOpRg7lFXlOqmBsm3tXwvRfWr5C5G/kiphhLbpioX44MBwCKwlZXyZ8UWAj/h9fwNy0ryCx/aNYQCcgF1IzR/u3Gmq9HYOV8jc7vpA8vRK5stFFuhcwowA7KKnYKzMMXw5VjdAckx82vcsf70bQdrciUY/hiDuxVUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEnoBByg; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEnoBByg"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6facc3b9559so33909546d6.0;
        Sat, 05 Jul 2025 12:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751744333; x=1752349133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aSsEfC/rMFg79sFc5I07VfiPNlL/JePZnZ93943srUU=;
        b=HEnoBBygfvsZLdLLFJeMW9xkg/9lP/rIkHehx0Hs7DZ4MdJKF7Q8xKQDOQORYZpuEe
         3gj3PLuPYLPrBEeZGNIFvll876rFy0cgJnyPJSl0KZ0ppLxb28UoWf4GMLyHOLAIrTST
         OlPV6hi16dAOCM9UQQ1+BIXFP7bnJx2+S7COiuCFuVIgE5NSPRL+75Kf8Hy0IrrbMN7H
         QWH8h3m9WKw2QK4HuqD0j3WNNRUdSkKL0iq/6JzOU4YC6ht68cyBpYbCn2jg7b8lD/QK
         AmtLNmFMoVI7A6F2Kh86T3lTIV2m+K3aP4DupGmjoDUUftejevTWrMJqdrDhLYzJeYFW
         gquQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751744333; x=1752349133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aSsEfC/rMFg79sFc5I07VfiPNlL/JePZnZ93943srUU=;
        b=KVq7bptdbnq2qNx0DLsk89GJqO/OT7MjsQtyMJPEFacYXS1dkYPx1djPCl+RqUnrIN
         SPM+1DIlbMzELjq/SvTJgwzoWJjkdcL+3gIwHUpXg4+IJEsyIFkcC5K05nD8PhJmZvQw
         e/dHzMLx55Z69ZE5PAQATi8IdHsin68gsb04wVFkFyyVrRHKeLO/nLQkwh/J58pX+/a8
         ROQeZKSKXtMm8POimn1O8XI6Y1C7/ygHQ3shrRehfKRGQWvewz9l77f+5RpELXKgkDKx
         FEkQT6JEqyqjq3IQpe1NhcdX75FehVjRzM2J0wF5REGUhMxOubR88xtRbOvQVaSItcMr
         F3Ag==
X-Forwarded-Encrypted: i=1; AJvYcCWD1Zwk+AR0lUD91TyijYi7+60lb8cSuJjluU/BwdHWKxJ6NZmUF7QebefCyrh4OCLGEBdbnRAywW7E@vger.kernel.org
X-Gm-Message-State: AOJu0YyZE+anCtoxzGcjEZIjOoJ9qmdtEiGHURIM7WPkzhjAC+saTCNw
	VAQb9z+BeogpBKwlIM25hFpIPgjXf1FK6uggLXx4GasHZKOQMEMmA1O/ATgI1XkohWY=
X-Gm-Gg: ASbGncuAlwmIXl38YjeJ4xNDtMaKE2CdMswXlnwP92k6tlNVjXIQbWAnMJWiFMA2E6Q
	ngxB0uVItcwsa78DsbU4hG1MbosRttvdY7OEhSH9tbYTUmI9RDKkPFdA8oy4mFrDCIK6A/2ZlWS
	OUdrII3rEqykrA6djjcjCiC9zEZOGFzU5Ki9OtcrePgoLX35EAyrW15kIOFMfDib8JDtZo8rIgg
	ULctG6vwdXkc+9LlZPzNXaWkEhxOKHU1unAsbhgH3QIVdZLXWRhQcz+y887oinDyYkmuh3L0t4u
	pXBl2JjlewTIUaagGAhfcGuDJEl8rmSjYwhqmDpL8izbGRUvFt1taOyKRmU5DjW9QdARp3Zm2tf
	wgLmAv/4+QI9K2GluC0JGgFRMATI=
X-Google-Smtp-Source: AGHT+IHEIRomHET9OQ4X3e3jyslwvT7ZPfFDbVqsPk2W81ICStM+/TUDDKM58hlYWHswb1WkLdSe2Q==
X-Received: by 2002:a05:6214:e4b:b0:6fa:cc39:90 with SMTP id 6a1803df08f44-702c6d7a772mr89264336d6.29.1751744332863;
        Sat, 05 Jul 2025 12:38:52 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d6019csm32999146d6.106.2025.07.05.12.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 12:38:52 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next 06/15] quic: add stream management
Date: Sat,  5 Jul 2025 15:31:45 -0400
Message-ID: <778a261dd001e6b1f90a9c0aead58303ac41c215.1751743914.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1751743914.git.lucien.xin@gmail.com>
References: <cover.1751743914.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces 'struct quic_stream_table' for managing QUIC streams,
each represented by 'struct quic_stream'.

It implements mechanisms for acquiring and releasing streams on both the
send and receive paths, ensuring efficient lifecycle management during
transmission and reception.

- quic_stream_send_get(): Acquire a send-side stream by ID and flags
  during TX path.

- quic_stream_recv_get(): Acquire a receive-side stream by ID during
  RX path.

- quic_stream_send_put(): Release a send-side stream when sending is
  done.

- quic_stream_recv_put(): Release a receive-side stream when receiving
  is done.

It includes logic to detect when stream ID limits are reached and when
control frames should be sent to update or request limits from the peer.

- quic_stream_id_send_exceeds(): Determines whether a
  STREAMS_BLOCKED_UNI/BIDI frame should be sent to the peer.

- quic_stream_max_streams_update(): Determines whether a
  MAX_STREAMS_UNI/BIDI frame should be sent to the peer.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/quic/Makefile |   2 +-
 net/quic/socket.c |   5 +
 net/quic/socket.h |   8 +
 net/quic/stream.c | 549 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/stream.h | 135 ++++++++++++
 5 files changed, 698 insertions(+), 1 deletion(-)
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
index da0fded4d79c..3357acecc9d6 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -42,6 +42,9 @@ static int quic_init_sock(struct sock *sk)
 	sk->sk_write_space = quic_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
 
+	if (quic_stream_init(quic_streams(sk)))
+		return -ENOMEM;
+
 	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sysctl_quic_wmem[1]));
 	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sysctl_quic_rmem[1]));
 
@@ -55,6 +58,8 @@ static int quic_init_sock(struct sock *sk)
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	quic_stream_free(quic_streams(sk));
+
 	quic_data_free(quic_ticket(sk));
 	quic_data_free(quic_token(sk));
 	quic_data_free(quic_alpn(sk));
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 2b9eb5aeb7a4..43ffc55a8a61 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -16,6 +16,7 @@
 
 #include "common.h"
 #include "family.h"
+#include "stream.h"
 
 #include "protocol.h"
 
@@ -37,6 +38,8 @@ struct quic_sock {
 	struct quic_data		ticket;
 	struct quic_data		token;
 	struct quic_data		alpn;
+
+	struct quic_stream_table	streams;
 };
 
 struct quic6_sock {
@@ -74,6 +77,11 @@ static inline struct quic_data *quic_alpn(const struct sock *sk)
 	return &quic_sk(sk)->alpn;
 }
 
+static inline struct quic_stream_table *quic_streams(const struct sock *sk)
+{
+	return &quic_sk(sk)->streams;
+}
+
 static inline bool quic_is_establishing(struct sock *sk)
 {
 	return sk->sk_state == QUIC_SS_ESTABLISHING;
diff --git a/net/quic/stream.c b/net/quic/stream.c
new file mode 100644
index 000000000000..f0558ee8d645
--- /dev/null
+++ b/net/quic/stream.c
@@ -0,0 +1,549 @@
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
+/* Check if a stream ID is valid for sending. */
+static bool quic_stream_id_send(s64 stream_id, bool is_serv)
+{
+	u8 type = (stream_id & QUIC_STREAM_TYPE_MASK);
+
+	if (is_serv) {
+		if (type == QUIC_STREAM_TYPE_CLIENT_UNI)
+			return false;
+	} else if (type == QUIC_STREAM_TYPE_SERVER_UNI) {
+		return false;
+	}
+	return true;
+}
+
+/* Check if a stream ID is valid for receiving. */
+static bool quic_stream_id_recv(s64 stream_id, bool is_serv)
+{
+	u8 type = (stream_id & QUIC_STREAM_TYPE_MASK);
+
+	if (is_serv) {
+		if (type == QUIC_STREAM_TYPE_SERVER_UNI)
+			return false;
+	} else if (type == QUIC_STREAM_TYPE_CLIENT_UNI) {
+		return false;
+	}
+	return true;
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
+struct quic_stream *quic_stream_find(struct quic_stream_table *streams, s64 stream_id)
+{
+	struct quic_hash_head *head = quic_stream_head(&streams->ht, stream_id);
+	struct quic_stream *stream;
+
+	hlist_for_each_entry(stream, &head->head, node) {
+		if (stream->id == stream_id)
+			break;
+	}
+	return stream;
+}
+
+static void quic_stream_add(struct quic_stream_table *streams, struct quic_stream *stream)
+{
+	struct quic_hash_head *head;
+
+	head = quic_stream_head(&streams->ht, stream->id);
+	hlist_add_head(&stream->node, &head->head);
+}
+
+static void quic_stream_delete(struct quic_stream *stream)
+{
+	hlist_del_init(&stream->node);
+	kfree(stream);
+}
+
+/* Create and register new streams for sending. */
+static struct quic_stream *quic_stream_send_create(struct quic_stream_table *streams,
+						   s64 max_stream_id, u8 is_serv)
+{
+	struct quic_stream *stream;
+	s64 stream_id;
+
+	stream_id = streams->send.next_bidi_stream_id;
+	if (quic_stream_id_uni(max_stream_id))
+		stream_id = streams->send.next_uni_stream_id;
+
+	/* rfc9000#section-2.1: A stream ID that is used out of order results in all streams
+	 * of that type with lower-numbered stream IDs also being opened.
+	 */
+	while (stream_id <= max_stream_id) {
+		stream = kzalloc(sizeof(*stream), GFP_KERNEL);
+		if (!stream)
+			return NULL;
+
+		stream->id = stream_id;
+		if (quic_stream_id_uni(stream_id)) {
+			stream->send.max_bytes = streams->send.max_stream_data_uni;
+
+			if (streams->send.next_uni_stream_id < stream_id + QUIC_STREAM_ID_STEP)
+				streams->send.next_uni_stream_id = stream_id + QUIC_STREAM_ID_STEP;
+			streams->send.streams_uni++;
+
+			quic_stream_add(streams, stream);
+			stream_id += QUIC_STREAM_ID_STEP;
+			continue;
+		}
+
+		if (streams->send.next_bidi_stream_id < stream_id + QUIC_STREAM_ID_STEP)
+			streams->send.next_bidi_stream_id = stream_id + QUIC_STREAM_ID_STEP;
+		streams->send.streams_bidi++;
+
+		if (quic_stream_id_local(stream_id, is_serv)) {
+			stream->send.max_bytes = streams->send.max_stream_data_bidi_remote;
+			stream->recv.max_bytes = streams->recv.max_stream_data_bidi_local;
+		} else {
+			stream->send.max_bytes = streams->send.max_stream_data_bidi_local;
+			stream->recv.max_bytes = streams->recv.max_stream_data_bidi_remote;
+		}
+		stream->recv.window = stream->recv.max_bytes;
+
+		quic_stream_add(streams, stream);
+		stream_id += QUIC_STREAM_ID_STEP;
+	}
+	return stream;
+}
+
+/* Create and register new streams for receiving. */
+static struct quic_stream *quic_stream_recv_create(struct quic_stream_table *streams,
+						   s64 max_stream_id, u8 is_serv)
+{
+	struct quic_stream *stream;
+	s64 stream_id;
+
+	stream_id = streams->recv.next_bidi_stream_id;
+	if (quic_stream_id_uni(max_stream_id))
+		stream_id = streams->recv.next_uni_stream_id;
+
+	/* rfc9000#section-2.1: A stream ID that is used out of order results in all streams
+	 * of that type with lower-numbered stream IDs also being opened.
+	 */
+	while (stream_id <= max_stream_id) {
+		stream = kzalloc(sizeof(*stream), GFP_ATOMIC);
+		if (!stream)
+			return NULL;
+
+		stream->id = stream_id;
+		if (quic_stream_id_uni(stream_id)) {
+			stream->recv.window = streams->recv.max_stream_data_uni;
+			stream->recv.max_bytes = stream->recv.window;
+
+			if (streams->recv.next_uni_stream_id < stream_id + QUIC_STREAM_ID_STEP)
+				streams->recv.next_uni_stream_id = stream_id + QUIC_STREAM_ID_STEP;
+			streams->recv.streams_uni++;
+
+			quic_stream_add(streams, stream);
+			stream_id += QUIC_STREAM_ID_STEP;
+			continue;
+		}
+
+		if (streams->recv.next_bidi_stream_id < stream_id + QUIC_STREAM_ID_STEP)
+			streams->recv.next_bidi_stream_id = stream_id + QUIC_STREAM_ID_STEP;
+		streams->recv.streams_bidi++;
+
+		if (quic_stream_id_local(stream_id, is_serv)) {
+			stream->send.max_bytes = streams->send.max_stream_data_bidi_remote;
+			stream->recv.max_bytes = streams->recv.max_stream_data_bidi_local;
+		} else {
+			stream->send.max_bytes = streams->send.max_stream_data_bidi_local;
+			stream->recv.max_bytes = streams->recv.max_stream_data_bidi_remote;
+		}
+		stream->recv.window = stream->recv.max_bytes;
+
+		quic_stream_add(streams, stream);
+		stream_id += QUIC_STREAM_ID_STEP;
+	}
+	return stream;
+}
+
+/* Check if a send stream ID is already closed. */
+static bool quic_stream_id_send_closed(struct quic_stream_table *streams, s64 stream_id)
+{
+	if (quic_stream_id_uni(stream_id)) {
+		if (stream_id < streams->send.next_uni_stream_id)
+			return true;
+	} else {
+		if (stream_id < streams->send.next_bidi_stream_id)
+			return true;
+	}
+	return false;
+}
+
+/* Check if a receive stream ID is already closed. */
+static bool quic_stream_id_recv_closed(struct quic_stream_table *streams, s64 stream_id)
+{
+	if (quic_stream_id_uni(stream_id)) {
+		if (stream_id < streams->recv.next_uni_stream_id)
+			return true;
+	} else {
+		if (stream_id < streams->recv.next_bidi_stream_id)
+			return true;
+	}
+	return false;
+}
+
+/* Check if a receive stream ID exceeds would exceed local's limits. */
+static bool quic_stream_id_recv_exceeds(struct quic_stream_table *streams, s64 stream_id)
+{
+	if (quic_stream_id_uni(stream_id)) {
+		if (stream_id > streams->recv.max_uni_stream_id)
+			return true;
+	} else {
+		if (stream_id > streams->recv.max_bidi_stream_id)
+			return true;
+	}
+	return false;
+}
+
+/* Check if a send stream ID would exceed peer's limits. */
+bool quic_stream_id_send_exceeds(struct quic_stream_table *streams, s64 stream_id)
+{
+	u64 nstreams;
+
+	if (quic_stream_id_uni(stream_id)) {
+		if (stream_id > streams->send.max_uni_stream_id)
+			return true;
+	} else {
+		if (stream_id > streams->send.max_bidi_stream_id)
+			return true;
+	}
+
+	if (quic_stream_id_uni(stream_id)) {
+		stream_id -= streams->send.next_uni_stream_id;
+		nstreams = quic_stream_id_to_streams(stream_id);
+		if (nstreams + streams->send.streams_uni > streams->send.max_streams_uni)
+			return true;
+	} else {
+		stream_id -= streams->send.next_bidi_stream_id;
+		nstreams = quic_stream_id_to_streams(stream_id);
+		if (nstreams + streams->send.streams_bidi > streams->send.max_streams_bidi)
+			return true;
+	}
+	return false;
+}
+
+/* Get or create a send stream by ID. */
+struct quic_stream *quic_stream_send_get(struct quic_stream_table *streams, s64 stream_id,
+					 u32 flags, bool is_serv)
+{
+	struct quic_stream *stream;
+
+	if (!quic_stream_id_send(stream_id, is_serv))
+		return ERR_PTR(-EINVAL);
+
+	stream = quic_stream_find(streams, stream_id);
+	if (stream) {
+		if ((flags & MSG_STREAM_NEW) &&
+		    stream->send.state != QUIC_STREAM_SEND_STATE_READY)
+			return ERR_PTR(-EINVAL);
+		return stream;
+	}
+
+	if (quic_stream_id_send_closed(streams, stream_id))
+		return ERR_PTR(-ENOSTR);
+
+	if (!(flags & MSG_STREAM_NEW))
+		return ERR_PTR(-EINVAL);
+
+	if (quic_stream_id_send_exceeds(streams, stream_id))
+		return ERR_PTR(-EAGAIN);
+
+	stream = quic_stream_send_create(streams, stream_id, is_serv);
+	if (!stream)
+		return ERR_PTR(-ENOSTR);
+	streams->send.active_stream_id = stream_id;
+	return stream;
+}
+
+/* Get or create a receive stream by ID. */
+struct quic_stream *quic_stream_recv_get(struct quic_stream_table *streams, s64 stream_id,
+					 bool is_serv)
+{
+	struct quic_stream *stream;
+
+	if (!quic_stream_id_recv(stream_id, is_serv))
+		return ERR_PTR(-EINVAL);
+
+	stream = quic_stream_find(streams, stream_id);
+	if (stream)
+		return stream;
+
+	if (quic_stream_id_local(stream_id, is_serv)) {
+		if (quic_stream_id_send_closed(streams, stream_id))
+			return ERR_PTR(-ENOSTR);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (quic_stream_id_recv_closed(streams, stream_id))
+		return ERR_PTR(-ENOSTR);
+
+	if (quic_stream_id_recv_exceeds(streams, stream_id))
+		return ERR_PTR(-EAGAIN);
+
+	stream = quic_stream_recv_create(streams, stream_id, is_serv);
+	if (!stream)
+		return ERR_PTR(-ENOSTR);
+	if (quic_stream_id_send(stream_id, is_serv))
+		streams->send.active_stream_id = stream_id;
+	return stream;
+}
+
+/* Release or clean up a send stream. This function updates stream counters and state when
+ * a send stream has either successfully sent all data or has been reset.
+ */
+void quic_stream_send_put(struct quic_stream_table *streams, struct quic_stream *stream,
+			  bool is_serv)
+{
+	if (quic_stream_id_uni(stream->id)) {
+		/* For unidirectional streams, decrement uni count and delete immediately. */
+		streams->send.streams_uni--;
+		quic_stream_delete(stream);
+		return;
+	}
+
+	/* For bidi streams, only proceed if receive side is in a final state. */
+	if (stream->recv.state != QUIC_STREAM_RECV_STATE_RECVD &&
+	    stream->recv.state != QUIC_STREAM_RECV_STATE_READ &&
+	    stream->recv.state != QUIC_STREAM_RECV_STATE_RESET_RECVD)
+		return;
+
+	if (quic_stream_id_local(stream->id, is_serv)) {
+		/* Local-initiated stream: mark send done and decrement send.bidi count. */
+		if (!stream->send.done) {
+			stream->send.done = 1;
+			streams->send.streams_bidi--;
+		}
+		goto out;
+	}
+	/* Remote-initiated stream: mark recv done and decrement recv bidi count. */
+	if (!stream->recv.done) {
+		stream->recv.done = 1;
+		streams->recv.streams_bidi--;
+		streams->recv.bidi_pending = 1;
+	}
+out:
+	/* Delete stream if fully read or no data received. */
+	if (stream->recv.state == QUIC_STREAM_RECV_STATE_READ || !stream->recv.offset)
+		quic_stream_delete(stream);
+}
+
+/* Release or clean up a receive stream. This function updates stream counters and state when
+ * the receive side has either consumed all data or has been reset.
+ */
+void quic_stream_recv_put(struct quic_stream_table *streams, struct quic_stream *stream,
+			  bool is_serv)
+{
+	if (quic_stream_id_uni(stream->id)) {
+		/* For uni streams, decrement uni count and mark done. */
+		if (!stream->recv.done) {
+			stream->recv.done = 1;
+			streams->recv.streams_uni--;
+			streams->recv.uni_pending = 1;
+		}
+		goto out;
+	}
+
+	/* For bidi streams, only proceed if send side is in a final state. */
+	if (stream->send.state != QUIC_STREAM_SEND_STATE_RECVD &&
+	    stream->send.state != QUIC_STREAM_SEND_STATE_RESET_RECVD)
+		return;
+
+	if (quic_stream_id_local(stream->id, is_serv)) {
+		/* Local-initiated stream: mark send done and decrement send.bidi count. */
+		if (!stream->send.done) {
+			stream->send.done = 1;
+			streams->send.streams_bidi--;
+		}
+		goto out;
+	}
+	/* Remote-initiated stream: mark recv done and decrement recv bidi count. */
+	if (!stream->recv.done) {
+		stream->recv.done = 1;
+		streams->recv.streams_bidi--;
+		streams->recv.bidi_pending = 1;
+	}
+out:
+	/* Delete stream if fully read or no data received. */
+	if (stream->recv.state == QUIC_STREAM_RECV_STATE_READ || !stream->recv.offset)
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
+	struct quic_hash_table *ht = &streams->ht;
+	struct quic_hash_head *head;
+	int i, size = QUIC_HT_SIZE;
+
+	head = kmalloc_array(size, sizeof(*head), GFP_KERNEL);
+	if (!head)
+		return -ENOMEM;
+	for (i = 0; i < size; i++)
+		INIT_HLIST_HEAD(&head[i].head);
+	ht->size = size;
+	ht->hash = head;
+	return 0;
+}
+
+void quic_stream_free(struct quic_stream_table *streams)
+{
+	struct quic_hash_table *ht = &streams->ht;
+	struct quic_hash_head *head;
+	struct quic_stream *stream;
+	struct hlist_node *tmp;
+	int i;
+
+	for (i = 0; i < ht->size; i++) {
+		head = &ht->hash[i];
+		hlist_for_each_entry_safe(stream, tmp, &head->head, node) {
+			hlist_del_init(&stream->node);
+			kfree(stream);
+		}
+	}
+	kfree(ht->hash);
+}
+
+/* Populate transport parameters from stream hash table. */
+void quic_stream_get_param(struct quic_stream_table *streams, struct quic_transport_param *p,
+			   bool is_serv)
+{
+	if (p->remote) {
+		p->max_stream_data_bidi_remote = streams->send.max_stream_data_bidi_remote;
+		p->max_stream_data_bidi_local = streams->send.max_stream_data_bidi_local;
+		p->max_stream_data_uni = streams->send.max_stream_data_uni;
+		p->max_streams_bidi = streams->send.max_streams_bidi;
+		p->max_streams_uni = streams->send.max_streams_uni;
+		return;
+	}
+
+	p->max_stream_data_bidi_remote = streams->recv.max_stream_data_bidi_remote;
+	p->max_stream_data_bidi_local = streams->recv.max_stream_data_bidi_local;
+	p->max_stream_data_uni = streams->recv.max_stream_data_uni;
+	p->max_streams_bidi = streams->recv.max_streams_bidi;
+	p->max_streams_uni = streams->recv.max_streams_uni;
+}
+
+/* Configure stream hashtable from transport parameters. */
+void quic_stream_set_param(struct quic_stream_table *streams, struct quic_transport_param *p,
+			   bool is_serv)
+{
+	u8 type;
+
+	if (p->remote) {
+		streams->send.max_stream_data_bidi_local = p->max_stream_data_bidi_local;
+		streams->send.max_stream_data_bidi_remote = p->max_stream_data_bidi_remote;
+		streams->send.max_stream_data_uni = p->max_stream_data_uni;
+		streams->send.max_streams_bidi = p->max_streams_bidi;
+		streams->send.max_streams_uni = p->max_streams_uni;
+		streams->send.active_stream_id = -1;
+
+		if (is_serv) {
+			type = QUIC_STREAM_TYPE_SERVER_BIDI;
+			streams->send.max_bidi_stream_id =
+				quic_stream_streams_to_id(p->max_streams_bidi, type);
+			streams->send.next_bidi_stream_id = type;
+
+			type = QUIC_STREAM_TYPE_SERVER_UNI;
+			streams->send.max_uni_stream_id =
+				quic_stream_streams_to_id(p->max_streams_uni, type);
+			streams->send.next_uni_stream_id = type;
+			return;
+		}
+
+		type = QUIC_STREAM_TYPE_CLIENT_BIDI;
+		streams->send.max_bidi_stream_id =
+			quic_stream_streams_to_id(p->max_streams_bidi, type);
+		streams->send.next_bidi_stream_id = type;
+
+		type = QUIC_STREAM_TYPE_CLIENT_UNI;
+		streams->send.max_uni_stream_id =
+			quic_stream_streams_to_id(p->max_streams_uni, type);
+		streams->send.next_uni_stream_id = type;
+		return;
+	}
+
+	streams->recv.max_stream_data_bidi_local = p->max_stream_data_bidi_local;
+	streams->recv.max_stream_data_bidi_remote = p->max_stream_data_bidi_remote;
+	streams->recv.max_stream_data_uni = p->max_stream_data_uni;
+	streams->recv.max_streams_bidi = p->max_streams_bidi;
+	streams->recv.max_streams_uni = p->max_streams_uni;
+
+	if (is_serv) {
+		type = QUIC_STREAM_TYPE_CLIENT_BIDI;
+		streams->recv.max_bidi_stream_id =
+			quic_stream_streams_to_id(p->max_streams_bidi, type);
+		streams->recv.next_bidi_stream_id = type;
+
+		type = QUIC_STREAM_TYPE_CLIENT_UNI;
+		streams->recv.max_uni_stream_id =
+			quic_stream_streams_to_id(p->max_streams_uni, type);
+		streams->recv.next_uni_stream_id = type;
+		return;
+	}
+
+	type = QUIC_STREAM_TYPE_SERVER_BIDI;
+	streams->recv.max_bidi_stream_id =
+		quic_stream_streams_to_id(p->max_streams_bidi, type);
+	streams->recv.next_bidi_stream_id = type;
+
+	type = QUIC_STREAM_TYPE_SERVER_UNI;
+	streams->recv.max_uni_stream_id =
+		quic_stream_streams_to_id(p->max_streams_uni, type);
+	streams->recv.next_uni_stream_id = type;
+}
diff --git a/net/quic/stream.h b/net/quic/stream.h
new file mode 100644
index 000000000000..4f570fdc55f2
--- /dev/null
+++ b/net/quic/stream.h
@@ -0,0 +1,135 @@
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
+		u8 stop_sent:1;		/* True if STOP_SENDING has been sent, not acknowledged */
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
+		u8 done:1;		/* True if FIN received and final size validated */
+	} recv;
+};
+
+struct quic_stream_table {
+	struct quic_hash_table ht;	/* Hash table storing all active streams */
+
+	struct {
+		/* Parameters received from peer, defined in rfc9000#section-18.2 */
+		u64 max_stream_data_bidi_remote;	/* initial_max_stream_data_bidi_remote */
+		u64 max_stream_data_bidi_local;		/* initial_max_stream_data_bidi_local */
+		u64 max_stream_data_uni;		/* initial_max_stream_data_uni */
+		u64 max_streams_bidi;			/* initial_max_streams_bidi */
+		u64 max_streams_uni;			/* initial_max_streams_uni */
+
+		s64 next_bidi_stream_id;	/* Next bidi stream ID to be opened */
+		s64 next_uni_stream_id;		/* Next uni stream ID to be opened */
+		s64 max_bidi_stream_id;		/* Highest allowed bidi stream ID */
+		s64 max_uni_stream_id;		/* Highest allowed uni stream ID */
+		s64 active_stream_id;		/* Most recently opened stream ID */
+
+		u8 bidi_blocked:1;	/* True if STREAMS_BLOCKED_BIDI was sent and not ACKed */
+		u8 uni_blocked:1;	/* True if STREAMS_BLOCKED_UNI was sent and not ACKed */
+		u16 streams_bidi;	/* Number of currently active bidi streams */
+		u16 streams_uni;	/* Number of currently active uni streams */
+	} send;
+	struct {
+		 /* Our advertised limits to the peer, per rfc9000#section-18.2 */
+		u64 max_stream_data_bidi_remote;	/* initial_max_stream_data_bidi_remote */
+		u64 max_stream_data_bidi_local;		/* initial_max_stream_data_bidi_local */
+		u64 max_stream_data_uni;		/* initial_max_stream_data_uni */
+		u64 max_streams_bidi;			/* initial_max_streams_bidi */
+		u64 max_streams_uni;			/* initial_max_streams_uni */
+
+		s64 next_bidi_stream_id;	/* Next expected bidi stream ID from peer */
+		s64 next_uni_stream_id;		/* Next expected uni stream ID from peer */
+		s64 max_bidi_stream_id;		/* Current allowed bidi stream ID range */
+		s64 max_uni_stream_id;		/* Current allowed uni stream ID range */
+
+		u8 bidi_pending:1;	/* True if MAX_STREAMS_BIDI needs to be sent */
+		u8 uni_pending:1;	/* True if MAX_STREAMS_UNI needs to be sent */
+		u16 streams_bidi;	/* Number of currently open bidi streams */
+		u16 streams_uni;	/* Number of currently open uni streams */
+	} recv;
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
+struct quic_stream *quic_stream_send_get(struct quic_stream_table *streams, s64 stream_id,
+					 u32 flags, bool is_serv);
+struct quic_stream *quic_stream_recv_get(struct quic_stream_table *streams, s64 stream_id,
+					 bool is_serv);
+void quic_stream_send_put(struct quic_stream_table *streams, struct quic_stream *stream,
+			  bool is_serv);
+void quic_stream_recv_put(struct quic_stream_table *streams, struct quic_stream *stream,
+			  bool is_serv);
+
+bool quic_stream_max_streams_update(struct quic_stream_table *streams, s64 *max_uni, s64 *max_bidi);
+struct quic_stream *quic_stream_find(struct quic_stream_table *streams, s64 stream_id);
+bool quic_stream_id_send_exceeds(struct quic_stream_table *streams, s64 stream_id);
+
+void quic_stream_get_param(struct quic_stream_table *streams, struct quic_transport_param *p,
+			   bool is_serv);
+void quic_stream_set_param(struct quic_stream_table *streams, struct quic_transport_param *p,
+			   bool is_serv);
+void quic_stream_free(struct quic_stream_table *streams);
+int quic_stream_init(struct quic_stream_table *streams);
-- 
2.47.1

