Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913B233A9EE
	for <linux-cifs@vger.kernel.org>; Mon,  5 Jan 2026 14:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767622125; cv=none; b=k7Qx2Z057AAWSRU5ZMBOEaxEgOBwm0y5WmOxhbKPCy9/Xdzzm/1nkwgPIOm2kSARM6Ve8AIxTrEr8ZSRHP7JCwqMy9rL5iprpknhrqNS80b5Tct74xdeJHg+QuWwpLrEKJW6xAaa9CJQfExHwVwKd9tgYzX/Kn2YIMTPCYZUmQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767622125; c=relaxed/simple;
	bh=UjY1qfAlGIm9BZaLhEQ9tDVHvZXEYCuYEr2LM5Iv0nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZXnvHFkB4LzCHsJxbwUcKHTZps4dd4gmqQ6OyS+loPM49fXbu0BbqFv+M8OTMbmnj4AfyOPXNLAEnOFhMbeEcdrQQiSqlOIzYke3rrAzH8G2uwlVG+ZBGrwrni0FMs3v1FGINQRCbSrEItYY3H2eHPJiFfHZeeEySckLxU1j2xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PMdoH6Nq; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PMdoH6Nq"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88a3bba9fd4so160678496d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 05 Jan 2026 06:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767622114; x=1768226914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcXQDX9utiE4yE1plGTDORj2uFFQtwgI0WcuWjtYoug=;
        b=PMdoH6NqhqBY4IO20XE3wyNNBwjQcYOfwUOF2zRcJ7UfFfuR2FyHpVqR5fKhW9E+Se
         VPAvxXlIiXoK9mM+fUUnk+sRVNChYoQfS7g0m3D3il///JuYmFAiwXlCT46qA/w3RJsw
         rhKOP+sMvDSfe/ZZy6CDCEiqlyfLGKNyg2n3o4zss6pCAXutr+//csaO+G6WDPzz752v
         VJm5G2+wJmCswPZ0Cx+K+ndwP2us/0m9+jmaw9mCfefdxBdbh2JW+mityMgvKimPwkBk
         d9qovix7GjdITO5pBoeKxHCche4oXmzJJSC0LbEQLdPVRsqP95VKIOZv4/mMLqg2v8cD
         HNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767622114; x=1768226914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IcXQDX9utiE4yE1plGTDORj2uFFQtwgI0WcuWjtYoug=;
        b=CFavLHWaeytsWqNO3nYIGKXDAdZ7vHfbq4k+567R0gSWyIUnbcOcmnycnz5mXISeX1
         HmrhFc2hhbgRXbRBWroLBFGEFaOAIBXWsQ2kksW1++vyIA0E85h8zbMZj4N01UdW4fx1
         Ie5g2ihJyl90ABZ++I9CSGHhmHhhoyC8sx/uSSKzxExpaRfMmdZXgrRYHtNQ3CZE+IpA
         L8jCcI25tk8uUDoezVzI17i6gQN5sF4fkEvBb2iaZllaSGVJUg6vmBrpgbx/sb2rGcYA
         ASMDz2POhxc02tadR42IT2xdM+yiar+mUf5GF/fwFwIc3W2HZZxrofqqjMToSsSgAInD
         6h6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwPKthXF8CCgPD8wAuAF8Jgb1h51dYWDzQgLez24T1Trjd55+t4xOzHs7va9lQF5+Lh5NpUwr79tUX@vger.kernel.org
X-Gm-Message-State: AOJu0YyAdYqWqMTNs9E9coKuHwz420wkbgA6r/GPRdwvM+Rl0AaBptIL
	sCD3bH2SRAIIIntsAc5IHi0GxAoa+Ub9zrpgjPhAT+efe01qny2svJ9C
X-Gm-Gg: AY/fxX7XWBeHt2d1V8gn8nYqO3/ZE87Y637lxajY3KnvKxT2MmeNIIWgd5wDoSUtXDP
	zpykqFgTh8m3bc8kCkfeHRttI7EbPkezdSh4wyY4OwilGenaVEh4YEb5dCKXbAvR2hzwRrAQ6Pm
	jM6cnCTVzddROsiDF/3aq+R5KbIiG1eqXqW7DoPWIl+davDh+yTzvJ45EHK//mz26+zBjVixX7T
	oWUKMGjWAwauWXbFI+wecbf51y5ylhT8Psg5VXvqprnpkLilQaJhSGCQf9hTlezEPwWk5qODooz
	hYOMDs5EAqx2dgcJCGedc69vqXaIGoZGRDIy4VVSH3EmFbcZAwTpiZ/9qV8MwMKqxMKDoHdY70Q
	abOIa1IGxANpunzcw36SRREBvuUnivE2C2iOSm25GI1nmpCSVD1IB5dnqKkZKSG2CnKxJquRBDz
	q7h67NseprGZY9mCt1HHO5UZj/4mefgMhlqGKBxltOXgBaU4NW1oM=
X-Google-Smtp-Source: AGHT+IEh60ifEQ4skXCUIIIHphMvL8bP01mKTOAAJ814wAmq2DX4dMYWg2cjvZX7H5LYHqPwKpvV4A==
X-Received: by 2002:a05:6214:469e:b0:884:6f86:e08c with SMTP id 6a1803df08f44-88d8271aeb3mr823781116d6.21.1767622113799;
        Mon, 05 Jan 2026 06:08:33 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac64a47esm368957221cf.24.2026.01.05.06.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 06:08:33 -0800 (PST)
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
Subject: [PATCH net-next v6 15/16] quic: add packet builder base
Date: Mon,  5 Jan 2026 09:04:41 -0500
Message-ID: <2594c0e223de422661d0e1cb51021c7de6e2b536.1767621882.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1767621882.git.lucien.xin@gmail.com>
References: <cover.1767621882.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

- quic_packet_tail(): Append a frame to the packet for transmission.

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
---
 net/quic/Makefile |   2 +-
 net/quic/packet.c | 313 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/packet.h | 121 ++++++++++++++++++
 net/quic/socket.c |   1 +
 net/quic/socket.h |   7 ++
 5 files changed, 443 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/packet.c
 create mode 100644 net/quic/packet.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 645ee470c95e..4a43052eb441 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IP_QUIC) += quic.o
 
 quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o \
-	  cong.o pnspace.o crypto.o timer.o frame.o
+	  cong.o pnspace.o crypto.o timer.o frame.o packet.o
diff --git a/net/quic/packet.c b/net/quic/packet.c
new file mode 100644
index 000000000000..348e760aa197
--- /dev/null
+++ b/net/quic/packet.c
@@ -0,0 +1,313 @@
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
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_frame *frame, *next;
+
+	/* Free all frames for now, and future patches will implement the actual creation logic. */
+	list_for_each_entry_safe(frame, next, &packet->frame_list, list) {
+		list_del(&frame->list);
+		quic_frame_put(frame);
+	}
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
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_frame *frame, *next;
+
+	/* Free all frames for now, and future patches will implement the actual creation logic. */
+	list_for_each_entry_safe(frame, next, &packet->frame_list, list) {
+		list_del(&frame->list);
+		quic_frame_put(frame);
+	}
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
+		/* Allow fragmentation if PLPMTUD is enabled, as it no longer relies on ICMP
+		 * Toobig messages to discover the path MTU.
+		 */
+		packet->ipfragok = !!c->plpmtud_probe_interval;
+	}
+	packet->level = level;
+	packet->len = (u16)hlen;
+	packet->overhead = (u8)hlen;
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
+	if (!packet->head) { /* First packet to bundle: initialize the head. */
+		packet->head = skb;
+		cb->last = skb;
+		goto out;
+	}
+
+	/* If bundling would exceed MSS, flush the current bundle. */
+	if (packet->head->len + skb->len >= packet->mss[0]) {
+		quic_packet_flush(sk);
+		packet->head = skb;
+		cb->last = skb;
+		goto out;
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
+/* Append a frame to the tail of the current QUIC packet. */
+int quic_packet_tail(struct sock *sk, struct quic_frame *frame)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	u8 taglen;
+
+	/* Reject frame if it doesn't match the packet's encryption level or path, or if
+	 * padding is already in place (no further frames should be added).
+	 */
+	if (frame->level != (packet->level % QUIC_CRYPTO_EARLY) ||
+	    frame->path != packet->path || packet->padding)
+		return 0;
+
+	/* Check if frame would exceed the current datagram MSS (excluding AEAD tag). */
+	taglen = quic_packet_taglen(packet);
+	if (packet->len + frame->len > packet->mss[frame->dgram] - taglen) {
+		/* If some data has already been added to the packet, bail out. */
+		if (packet->len != packet->overhead)
+			return 0;
+		/* Otherwise, allow IP fragmentation for this packet unless it’s a PING probe. */
+		if (!quic_frame_ping(frame->type))
+			packet->ipfragok = 1;
+	}
+	if (frame->padding)
+		packet->padding = frame->padding;
+
+	/* Track frames that require retransmission if lost (i.e., ACK-eliciting and non-PING). */
+	if (frame->ack_eliciting) {
+		packet->ack_eliciting = 1;
+		if (!quic_frame_ping(frame->type)) {
+			packet->frames++;
+			packet->frame_len += frame->len;
+		}
+	}
+
+	list_move_tail(&frame->list, &packet->frame_list);
+	packet->len += frame->len;
+	return frame->len;
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
index 000000000000..85efeba6199b
--- /dev/null
+++ b/net/quic/packet.h
@@ -0,0 +1,121 @@
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
+struct quic_packet_sent {
+	struct list_head list;	/* Link in sent packet list for ACK tracking */
+	u64 sent_time;		/* Timestamp when packet was sent */
+	s64 number;		/* Packet number */
+	u8  level;		/* Packet number space */
+	u8  ecn:2;		/* ECN bits */
+
+	u16 frame_len;		/* Combined length of all frames held */
+	u16 frames;		/* Number of frames held */
+
+	struct quic_frame *frame_array[];	/* Array of pointers to held frames */
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
+int quic_packet_tail(struct sock *sk, struct quic_frame *frame);
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
index 0a6e59f85d32..f3a2b11fb251 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -48,6 +48,7 @@ static int quic_init_sock(struct sock *sk)
 	quic_cong_init(quic_cong(sk));
 
 	quic_timer_init(sk);
+	quic_packet_init(sk);
 
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
diff --git a/net/quic/socket.h b/net/quic/socket.h
index eeb510e0a09b..a463b80a76fc 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -20,6 +20,7 @@
 #include "path.h"
 #include "cong.h"
 
+#include "packet.h"
 #include "frame.h"
 
 #include "protocol.h"
@@ -77,6 +78,7 @@ struct quic_sock {
 	struct quic_pnspace		space[QUIC_PNSPACE_MAX];
 	struct quic_crypto		crypto[QUIC_CRYPTO_MAX];
 
+	struct quic_packet		packet;
 	struct quic_timer		timers[QUIC_TIMER_MAX];
 };
 
@@ -155,6 +157,11 @@ static inline struct quic_crypto *quic_crypto(const struct sock *sk, u8 level)
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

