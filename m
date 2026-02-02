Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B2B36F417
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 14:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770042615; cv=none; b=PEVnwXFiLOXGZ+o1mCQfG7QgjmJa1p+JOruijmvsCEF+A1ZSd1cFvh/ywDkrf4HIN3GgNcw9kUGrAX6XYl9UUDXAkyIIE2XPR2exwqnIfYxwaAK3uYCv5jJT/Ff7RprRcpAmMZYVyRsnvPqxLkXyFuXURV+NGMOTIuOzeDEJ6yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770042615; c=relaxed/simple;
	bh=7ra2qHxbk+pp2eijWDv38j2nO3eSraDfnU+1ThG7/xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGnNqmopYGp89k0vfflDbGeXjUHvtUuJJkYLfRYAoBN8iCmD+x7GLi35bkznHd6vb1vZVVwTfmn8p43YdAmSHRzI+hkIv7B4ckeaRL/2QTQewhwXVp56pSn3WzIn702bkldDx/2qip7EuULsojt1tjdpBHE+8NPPWG7AIugp/2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bvorSbFE; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvorSbFE"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50335b926c2so38481791cf.2
        for <linux-cifs@vger.kernel.org>; Mon, 02 Feb 2026 06:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770042613; x=1770647413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P9vYF1V8F2yn3OyjZrpd951AkSDjjv4Zy9rBqw+mG3k=;
        b=bvorSbFEUSgh/tP+OlErAG+RQDQ73NOrpUw8GgYgxsuQBG67qExcBAlyAYVgy0PgJz
         q9zyrTCTZA55Tt8OILwMxJiAKYZJWxquhOWniFmJxoZ6wM6XCW4eUdUx82rzuFOUy6oo
         NZ4DRZfsWtU8i6DfdKUGtfifKbGPbzPvIo+BuemXu/cF0o/INZXJN+6qbJOznyMHLLpV
         jBtJ3LBljwEvq1lmVfc0dR7JEx2VqaSpUDxUrEnXvb+qGVM/PDuUe/0l71c8M+Ag8iGF
         m5XMvXvXSOILpbS5eeokYpeiz/tzZ2RAzMAt7pvxjG2Bq8oHgvCoOB4Q8v9rL7q+Gdtk
         lLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770042613; x=1770647413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P9vYF1V8F2yn3OyjZrpd951AkSDjjv4Zy9rBqw+mG3k=;
        b=susU3iw/beiKt4+mhf0S0QQHgDiiRouuAt8ph/FSc1CE3j9x2lNWBbe1qE3KqSENC6
         nH+7pPu2jjTNyFPMiZKtCkFVGGTmiMqvt4vRZxTMbN9zPrGvTTG6rXouSzu3NWcNc3s+
         QD+qZ/asNZlc2eBoJFKpj7/E5ctbsEJbNDEcFGFr6pxXqxCeVOrAidy2lLkFA3mOBhd8
         84ceBJ5PnRYRNtQcab/pLU8T7X43QUfl7ndKNd1hZPtZYrMbhAl6CKOldomRM/Jcpz3Q
         ty8w44ivTRPWgoGcYjNRZ219wwTwuqnt6tk18UizoTzI+/HAT0YHZX4iqqrN7ZtU47AX
         JNwA==
X-Forwarded-Encrypted: i=1; AJvYcCXGYi0sSj2dk7DUtQPktqDq+VtSkq3YwIgHVwVKgxOBv+94ZDuR+KihcvB1MHmYkcM1uRJmAK/YNRLd@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/wVDG6sJEauCOcq8ljzojpgn0fQgVHk0240n2uvZU9vUtKTgX
	7pDRollmrDHRYcBOnlexOLyFn9NYQD0Xzzr72qH8zfKm0np7htJ85UOf
X-Gm-Gg: AZuq6aKiiCrQ17XAuqSanq6G3/2hkUczNyZRnrcPjYmc8CNGZc0bQcPkLxds49qnqIW
	XmsGHcady7pKEI2QXgk/DCjzZGXRCSkdE6p3hw/Tn0HoPADBrUR1paYVCFeZ0gKYU0NMATUCkdz
	Zem8UlOSwUTuXEucdnyDlm+X5N71nHzcr56iqPWlc7OZdcJusrilqjMdaOUDQcYrUm6J8SEkQ4z
	lV/CqU5Ncz5VrhDfKk/9HDfIzzpBXh4/EZpUQmGRwstszK7HhRcmka5TVJAUr3XoblqUCuAye0e
	Nq0n5oUFZAX6llR/cS/EmpSN98o8h/2NSYsBijTyH2eHjQp9H8EiWQ4ozZVvQ9UclujVrc44LUs
	EFkFZh3Qg6jBidsjWcEMWBxIJoU5z0orxpB7sM425tL7dvoJJrJq+NfvQdmbWopbwC1TZHd44ok
	+2LuxisLOq+aqrvJ+Il8ysfoNuaeYG//h/LDrSbf/LSR4tucWpDYg=
X-Received: by 2002:a05:622a:1b8c:b0:4ee:1d84:306a with SMTP id d75a77b69052e-505d22a0dd9mr148389041cf.71.1770042612244;
        Mon, 02 Feb 2026 06:30:12 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50337ba3981sm106865171cf.16.2026.02.02.06.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 06:30:11 -0800 (PST)
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
Subject: [PATCH net-next v9 14/15] quic: add packet builder base
Date: Mon,  2 Feb 2026 09:27:40 -0500
Message-ID: <c8937e4562427905ac3c2657eb1a2e769633544a.1770042461.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1770042461.git.lucien.xin@gmail.com>
References: <cover.1770042461.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces 'quic_packet' to handle packing of QUIC packets on
the transmit (TX) path.

It provides functionality for frame packing and packet construction. The
packet configuration includes setting the path, calculating overhead,
and verifying routing. Frames are appended to the packet before it is
created with the queued frames.

Once assembled, the packet is encrypted, bundled, and sent out. There
is also support to flush the packet when no additional frames remain.
Functions to create application (short) and handshake (long) packets
are currently placeholders for future implementation.

- quic_packet_config(): Set the path, compute overhead, and verify routing.

- quic_packet_create_and_xmit(): Create and send the packet with the queued
  frames.

- quic_packet_xmit(): Encrypt, bundle, and send out the packet.

- quic_packet_flush(): Send the packet if there's nothing left to bundle.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
v3:
  - Adjust global connection and listen socket hashtable operations
    based on the new hashtable type.
  - Introduce quic_packet_backlog_schedule() to enqueue Initial packets
    to quic_net.backlog_list and defer their decryption for ALPN demux
    to quic_packet_backlog_work() on quic_net.work, since
    quic_crypto_initial_keys_install()/crypto_aead_setkey() must run
    in process context.
v4:
  - Update quic_(listen_)sock_lookup() to support lockless socket
    lookup using hlist_nulls_node APIs.
  - Use quic_wq for QUIC packet backlog processing work.
v5:
  - Rename quic_packet_create() to quic_packet_create_and_xmit()
    (suggested by Paolo).
  - Move the packet parser base code to a separate patch, keeping only
    the packet builder base in this patch (suggested by Paolo).
  - Change sent_time timestamp from u32 to u64 to improve accuracy.
v8:
  - Remove the dependency on struct quic_frame by returning NULL in
    quic_packet_handshake/app_create() and dropping quic_packet_tail()
    and struct quic_packet_sent. This effectively strips out patch 14
    (suggested by Paolo).
v9:
  - Warn on oversized header length in quic_packet_config() (suggested by
    Paolo).
  - Factor bundle initialization into a common 'init' goto label in
    quic_packet_bundle() (suggested by Paolo).
  - Clarify comment for packet->ipfragok in quic_packet_config().
---
 net/quic/Makefile |   2 +-
 net/quic/packet.c | 257 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/packet.h | 107 +++++++++++++++++++
 net/quic/socket.c |   1 +
 net/quic/socket.h |   8 ++
 5 files changed, 374 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/packet.c
 create mode 100644 net/quic/packet.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 2ccf01ad9e22..0f903f4a7ff1 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IP_QUIC) += quic.o
 
 quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o \
-	  cong.o pnspace.o crypto.o timer.o
+	  cong.o pnspace.o crypto.o timer.o packet.o
diff --git a/net/quic/packet.c b/net/quic/packet.c
new file mode 100644
index 000000000000..cf64a6aaa795
--- /dev/null
+++ b/net/quic/packet.c
@@ -0,0 +1,257 @@
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
+#include "socket.h"
+
+#define QUIC_HLEN		1
+
+/* Make these fixed for easy coding. */
+#define QUIC_PACKET_NUMBER_LEN	QUIC_PN_MAX_LEN
+#define QUIC_PACKET_LENGTH_LEN	4
+
+static struct sk_buff *quic_packet_handshake_create(struct sock *sk)
+{
+	return NULL;
+}
+
+static int quic_packet_number_check(struct sock *sk)
+{
+	return 0;
+}
+
+static struct sk_buff *quic_packet_app_create(struct sock *sk)
+{
+	return NULL;
+}
+
+/* Update the MSS and inform congestion control. */
+void quic_packet_mss_update(struct sock *sk, u32 mss)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_cong *cong = quic_cong(sk);
+
+	packet->mss[0] = (u16)mss;
+	quic_cong_set_mss(cong, packet->mss[0] - packet->taglen[0]);
+}
+
+/* Perform routing for the QUIC packet on the specified path, update header length and MSS
+ * accordingly, reset path and start PMTU timer.
+ */
+int quic_packet_route(struct sock *sk)
+{
+	struct quic_path_group *paths = quic_paths(sk);
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_config *c = quic_config(sk);
+	union quic_addr *sa, *da;
+	u32 pmtu;
+	int err;
+
+	da = quic_path_daddr(paths, packet->path);
+	sa = quic_path_saddr(paths, packet->path);
+	err = quic_flow_route(sk, da, sa, &paths->fl);
+	if (err)
+		return err;
+
+	packet->hlen = quic_encap_len(da);
+	pmtu = min_t(u32, dst_mtu(__sk_dst_get(sk)), QUIC_PATH_MAX_PMTU);
+	quic_packet_mss_update(sk, pmtu - packet->hlen);
+
+	quic_path_pl_reset(paths);
+	quic_timer_reset(sk, QUIC_TIMER_PMTU, c->plpmtud_probe_interval);
+	return 0;
+}
+
+/* Configure the QUIC packet header and routing based on encryption level and path. */
+int quic_packet_config(struct sock *sk, u8 level, u8 path)
+{
+	struct quic_conn_id_set *dest = quic_dest(sk), *source = quic_source(sk);
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_config *c = quic_config(sk);
+	u32 hlen = QUIC_HLEN;
+
+	/* If packet already has data, no need to reconfigure. */
+	if (!quic_packet_empty(packet))
+		return 0;
+
+	packet->ack_eliciting = 0;
+	packet->frame_len = 0;
+	packet->ipfragok = 0;
+	packet->padding = 0;
+	packet->frames = 0;
+	hlen += QUIC_PACKET_NUMBER_LEN; /* Packet number length. */
+	hlen += quic_conn_id_choose(dest, path)->len; /* DCID length. */
+	if (level) {
+		hlen += 1; /* Length byte for DCID. */
+		hlen += 1 + quic_conn_id_active(source)->len; /* Length byte + SCID length. */
+		if (level == QUIC_CRYPTO_INITIAL) /* Include token for Initial packets. */
+			hlen += quic_var_len(quic_token(sk)->len) + quic_token(sk)->len;
+		hlen += QUIC_VERSION_LEN; /* Version length. */
+		hlen += QUIC_PACKET_LENGTH_LEN; /* Packet length field length. */
+		/* Allow fragmentation for handshake packets before PLPMTUD probing starts.
+		 * MTU discovery does not rely on ICMP Packet Too Big once PLPMTUD is enabled.
+		 */
+		packet->ipfragok = !!c->plpmtud_probe_interval;
+	}
+	packet->level = level;
+	packet->len = (u16)hlen;
+	packet->overhead = (u8)hlen;
+	DEBUG_NET_WARN_ON_ONCE(hlen > 255);
+
+	if (packet->path != path) { /* If the path changed, update and reset routing cache. */
+		packet->path = path;
+		__sk_dst_reset(sk);
+	}
+
+	/* Perform routing and MSS update for the configured packet. */
+	if (quic_packet_route(sk) < 0)
+		return -1;
+	return 0;
+}
+
+static void quic_packet_encrypt_done(struct sk_buff *skb, int err)
+{
+	/* Free it for now, future patches will implement the actual deferred transmission logic. */
+	kfree_skb(skb);
+}
+
+/* Coalescing Packets. */
+static int quic_packet_bundle(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_skb_cb *head_cb, *cb = QUIC_SKB_CB(skb);
+	struct quic_packet *packet = quic_packet(sk);
+	struct sk_buff *p;
+
+	if (!packet->head) /* First packet to bundle: initialize the head. */
+		goto init;
+
+	/* If bundling would exceed MSS, flush the current bundle. */
+	if (packet->head->len + skb->len >= packet->mss[0]) {
+		quic_packet_flush(sk);
+		goto init;
+	}
+	/* Bundle it and update metadata for the aggregate skb. */
+	p = packet->head;
+	head_cb = QUIC_SKB_CB(p);
+	if (head_cb->last == p)
+		skb_shinfo(p)->frag_list = skb;
+	else
+		head_cb->last->next = skb;
+	p->data_len += skb->len;
+	p->truesize += skb->truesize;
+	p->len += skb->len;
+	head_cb->last = skb;
+	head_cb->ecn |= cb->ecn;  /* Merge ECN flags. */
+
+out:
+	/* rfc9000#section-12.2:
+	 *   Packets with a short header (Section 17.3) do not contain a Length field and so
+	 *   cannot be followed by other packets in the same UDP datagram.
+	 *
+	 * so Return 1 to flush if it is a Short header packet.
+	 */
+	return !cb->level;
+init:
+	packet->head = skb;
+	cb->last = skb;
+	goto out;
+}
+
+/* Transmit a QUIC packet, possibly encrypting and bundling it. */
+int quic_packet_xmit(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct net *net = sock_net(sk);
+	int err;
+
+	/* Skip encryption if taglen == 0 (e.g., disable_1rtt_encryption). */
+	if (!packet->taglen[quic_hdr(skb)->form])
+		goto xmit;
+
+	cb->crypto_done = quic_packet_encrypt_done;
+	/* Associate skb with sk to ensure sk is valid during async encryption completion. */
+	WARN_ON(!skb_set_owner_sk_safe(skb, sk));
+	err = quic_crypto_encrypt(quic_crypto(sk, packet->level), skb);
+	if (err) {
+		if (err != -EINPROGRESS) {
+			QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCDROP);
+			kfree_skb(skb);
+			return err;
+		}
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCBACKLOGS);
+		return err;
+	}
+	if (!cb->resume) /* Encryption completes synchronously. */
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCFASTPATHS);
+
+xmit:
+	if (quic_packet_bundle(sk, skb))
+		quic_packet_flush(sk);
+	return 0;
+}
+
+/* Create and transmit a new QUIC packet. */
+int quic_packet_create_and_xmit(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct sk_buff *skb;
+	int err;
+
+	err = quic_packet_number_check(sk);
+	if (err)
+		goto err;
+
+	if (packet->level)
+		skb = quic_packet_handshake_create(sk);
+	else
+		skb = quic_packet_app_create(sk);
+	if (!skb) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	err = quic_packet_xmit(sk, skb);
+	if (err && err != -EINPROGRESS)
+		goto err;
+
+	/* Return 1 if at least one ACK-eliciting (non-PING) frame was sent. */
+	return !!packet->frames;
+err:
+	pr_debug("%s: err: %d\n", __func__, err);
+	return 0;
+}
+
+/* Flush any coalesced/bundled QUIC packets. */
+void quic_packet_flush(struct sock *sk)
+{
+	struct quic_path_group *paths = quic_paths(sk);
+	struct quic_packet *packet = quic_packet(sk);
+
+	if (packet->head) {
+		quic_lower_xmit(sk, packet->head,
+				quic_path_daddr(paths, packet->path), &paths->fl);
+		packet->head = NULL;
+	}
+}
+
+void quic_packet_init(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+
+	INIT_LIST_HEAD(&packet->frame_list);
+	packet->taglen[0] = QUIC_TAG_LEN;
+	packet->taglen[1] = QUIC_TAG_LEN;
+	packet->mss[0] = QUIC_TAG_LEN;
+	packet->mss[1] = QUIC_TAG_LEN;
+
+	packet->version = QUIC_VERSION_V1;
+}
diff --git a/net/quic/packet.h b/net/quic/packet.h
new file mode 100644
index 000000000000..ad1279cdb645
--- /dev/null
+++ b/net/quic/packet.h
@@ -0,0 +1,107 @@
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
+struct quic_packet {
+	struct quic_conn_id dcid;	/* Dest Connection ID from received packet */
+	struct quic_conn_id scid;	/* Source Connection ID from received packet */
+	union quic_addr daddr;		/* Dest address from received packet */
+	union quic_addr saddr;		/* Source address from received packet */
+
+	struct list_head frame_list;	/* List of frames to pack into packet for send */
+	struct sk_buff *head;		/* Head skb for packet bundling on send */
+	u16 frame_len;		/* Length of all ack-eliciting frames excluding PING */
+	u8 taglen[2];		/* Tag length for short and long packets */
+	u32 version;		/* QUIC version used/selected during handshake */
+	u8 errframe;		/* Frame type causing packet processing failure */
+	u8 overhead;		/* QUIC header length excluding frames */
+	u16 errcode;		/* Error code on packet processing failure */
+	u16 frames;		/* Number of ack-eliciting frames excluding PING */
+	u16 mss[2];		/* MSS for datagram and non-datagram packets */
+	u16 hlen;		/* UDP + IP header length for sending */
+	u16 len;		/* QUIC packet length excluding taglen for sending */
+
+	u8 ack_eliciting:1;	/* Packet contains ack-eliciting frames to send */
+	u8 ack_requested:1;	/* Packet contains ack-eliciting frames received */
+	u8 ack_immediate:1;	/* Send ACK immediately (skip ack_delay timer) */
+	u8 non_probing:1;	/* Packet has ack-eliciting frames excluding NEW_CONNECTION_ID */
+	u8 has_sack:1;		/* Packet has ACK frames received */
+	u8 ipfragok:1;		/* Allow IP fragmentation */
+	u8 padding:1;		/* Packet has padding frames */
+	u8 path:1;		/* Path identifier used to send this packet */
+	u8 level;		/* Encryption level used */
+};
+
+#define QUIC_PACKET_INITIAL_V1		0
+#define QUIC_PACKET_0RTT_V1		1
+#define QUIC_PACKET_HANDSHAKE_V1	2
+#define QUIC_PACKET_RETRY_V1		3
+
+#define QUIC_PACKET_INITIAL_V2		1
+#define QUIC_PACKET_0RTT_V2		2
+#define QUIC_PACKET_HANDSHAKE_V2	3
+#define QUIC_PACKET_RETRY_V2		0
+
+#define QUIC_PACKET_INITIAL		QUIC_PACKET_INITIAL_V1
+#define QUIC_PACKET_0RTT		QUIC_PACKET_0RTT_V1
+#define QUIC_PACKET_HANDSHAKE		QUIC_PACKET_HANDSHAKE_V1
+#define QUIC_PACKET_RETRY		QUIC_PACKET_RETRY_V1
+
+#define QUIC_VERSION_LEN		4
+
+static inline u8 quic_packet_taglen(struct quic_packet *packet)
+{
+	return packet->taglen[!!packet->level];
+}
+
+static inline void quic_packet_set_taglen(struct quic_packet *packet, u8 taglen)
+{
+	packet->taglen[0] = taglen;
+}
+
+static inline u32 quic_packet_mss(struct quic_packet *packet)
+{
+	return packet->mss[0] - packet->taglen[!!packet->level];
+}
+
+static inline u32 quic_packet_max_payload(struct quic_packet *packet)
+{
+	return packet->mss[0] - packet->overhead - packet->taglen[!!packet->level];
+}
+
+static inline u32 quic_packet_max_payload_dgram(struct quic_packet *packet)
+{
+	return packet->mss[1] - packet->overhead - packet->taglen[!!packet->level];
+}
+
+static inline int quic_packet_empty(struct quic_packet *packet)
+{
+	return list_empty(&packet->frame_list);
+}
+
+static inline void quic_packet_reset(struct quic_packet *packet)
+{
+	packet->level = 0;
+	packet->errcode = 0;
+	packet->errframe = 0;
+	packet->has_sack = 0;
+	packet->non_probing = 0;
+	packet->ack_requested = 0;
+	packet->ack_immediate = 0;
+}
+
+int quic_packet_config(struct sock *sk, u8 level, u8 path);
+
+int quic_packet_xmit(struct sock *sk, struct sk_buff *skb);
+int quic_packet_create_and_xmit(struct sock *sk);
+int quic_packet_route(struct sock *sk);
+
+void quic_packet_mss_update(struct sock *sk, u32 mss);
+void quic_packet_flush(struct sock *sk);
+void quic_packet_init(struct sock *sk);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index dde1d9becf06..f73d25cd16e9 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -48,6 +48,7 @@ static int quic_init_sock(struct sock *sk)
 	quic_cong_init(quic_cong(sk));
 
 	quic_timer_init(sk);
+	quic_packet_init(sk);
 
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 5e9b21430f42..c4a9980ea5f8 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -20,6 +20,8 @@
 #include "path.h"
 #include "cong.h"
 
+#include "packet.h"
+
 #include "protocol.h"
 #include "timer.h"
 
@@ -75,6 +77,7 @@ struct quic_sock {
 	struct quic_pnspace		space[QUIC_PNSPACE_MAX];
 	struct quic_crypto		crypto[QUIC_CRYPTO_MAX];
 
+	struct quic_packet		packet;
 	struct quic_timer		timers[QUIC_TIMER_MAX];
 };
 
@@ -153,6 +156,11 @@ static inline struct quic_crypto *quic_crypto(const struct sock *sk, u8 level)
 	return &quic_sk(sk)->crypto[level];
 }
 
+static inline struct quic_packet *quic_packet(const struct sock *sk)
+{
+	return &quic_sk(sk)->packet;
+}
+
 static inline void *quic_timer(const struct sock *sk, u8 type)
 {
 	return (void *)&quic_sk(sk)->timers[type];
-- 
2.47.1

