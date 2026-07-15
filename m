Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DE3472785
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 20:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784147546; cv=none; b=c4vguXXQDKZ1qm05K/CRfhzYWdRFVYdBela54J/IQQNH8W+LLfmMctC7r9RJEMet5bj3Mry93Q4zFkVOBrojHuaHvZ5V2oHjgNvDcUpNUoZW5XYbAa2/Nirb8l9YTBAmkrZ1MfU18w8+isvG/37IbtzqzAXFIQ1S5vRiQATl6gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784147546; c=relaxed/simple;
	bh=jEJGpye/Ls/ZUQHynuJEHK9JD6O2yeYNI22BLrYyhT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDA8+FSek7twkuBbjQH2QFWJ+DIeMt+VkM0sqwq1Px1WjDf/qjd5ViSvhDTGjgprAhKotgz0p87gfuEZfNMuWGHtTl+6WRCW3JR/Bu3CkiqM5jcf9zVWk6SSaN0BUTrT/P+08GQ5o8ZCl2eNVDlUFPbmfYm3SUwkzh/q72tWHQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=br0iYf/E; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="br0iYf/E"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c0a81d286so6741051cf.1
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 13:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784147543; x=1784752343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4nEReGga9Cl2BLoAkhE+Pryb9MjGUYrQfag74UsIwak=;
        b=br0iYf/EuMEVumGrtonv0tNDJ3P6BV9bOG5GKc/hcUKzfUbqY2NsWIa0bYmSsDcx48
         6NeZvsRBWU5yZBDmWt5XCkx7ZWiv7xU3ejGjCaE8QmqsiykIKtFuZFQh4UJybXFCoTFe
         wVQN7NXjHDfAlBuQVBPmmWHypXWJ/4hZb9bwmyH+OjNQAcW0F3BdoO8DXlpIrHANszKd
         K6KaWlHZ60mzCOgXtv+S6ypxk2eRUKVJ72nYil0tI9Op0rY7bPWieE4uT0+k9Yzpqale
         vPSXplknR39ph4dCKtXlLXNUdWxmKCCT5HBMITXzHsRENepdtorntfEZamdGv/wt7rxr
         ejkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784147543; x=1784752343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4nEReGga9Cl2BLoAkhE+Pryb9MjGUYrQfag74UsIwak=;
        b=T2kkhfRT7SgkYNjXjZLPnrACrUu4DavUGWZtdQ/YKEXkc4msVk8SgYENiDy1oJ3iwV
         hDdpE6uY8cH58WVQbeP94lkaKW+AVXraudv/A8T8xOURrGLz0Nse1inpo74rqDsdW6a1
         9X4AgCYijrmQbVfDONe7smi+iAwX3kn4TOHZTDPxfw3SIpbqNVFld8Wp1hadvLiDjCGw
         0kSYFpqAYLQ/gGmohIK6H2zc1/fdA3eh7QJyKjw3ikZn/DKniUaqv9sAL/plo6L+d6Oe
         K55j2/lHTlNkaAAZxz4SWsFYDF0uSbOXKc831A0w6jF3n+ozhwdGEmUpxF5tZO5zGEBr
         IGVQ==
X-Forwarded-Encrypted: i=1; AHgh+RrHZnPi2xuxb0qR5g+GjeRWvOtnRhdGmBNBljGSWAXocA/p88q1XITFytHVpqasoKslbmJEM/W34f/a@vger.kernel.org
X-Gm-Message-State: AOJu0YzNeKHRboUfWV0hKGARZ5em8TSueUef0TFF9hQeTu9XqCHcABVc
	22BV6qqGdhSlpqBDBVJnqIpeU1qOGbibpopimq3ZleaPSfxKrgGUZhET
X-Gm-Gg: AfdE7clp5fdMmMeibg69NIwc4P439muVo6DEa8yp6af91BXdeXHS70tWqak2HxjX3QQ
	8/G4JUDQtJDhNMBbR8WZvuoCAhr03Haa/jJzdoCTqJGP5Jtd4gp+xp0xoNqzf/qCaYsOVb74+53
	Xa6yoHZmv7wnZKRw4w0sBh8W6dADTSAGAQiGOqA3Qr1GOij1JaSvEJGQmTDAcmiB7YRkQeE3nbD
	8RcKfJPIDlfYS43UH29uO098yVe7CVyH9Fb1ybT4Ya+v57cSfb5xq2Ny/zsKjr0DLKDL6zU8Xgd
	C9uefwZXVoZioHiOi2Dy8K6cfxX7RUGgw3Pq2YnYecHUHz08pL3sX646WDuI9cmbMjK0x9ZZmbD
	qlu2h5/hy1k87A3GyHm7GLglbslxtCxCKs2ghd4CfvTvLMduLc+bxSIE+dpwPW7TNh2DpuuBhbe
	ize9qyf40ckS5xr0lk3QlD20eXVX+GwgHmGWsfXezeHho7dVEusXrEd5zQFHEhHTy8cKYAPapTL
	fhCnKDR7yI1++T7ZlCRUGtVCEtGxuI4iDov8GEtgMAt0+8qFYOWE0w=
X-Received: by 2002:a05:622a:1115:b0:517:63df:91a5 with SMTP id d75a77b69052e-51f62bdd8cdmr11265631cf.19.1784147543072;
        Wed, 15 Jul 2026 13:32:23 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd248e666sm201326506d6.0.2026.07.15.13.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 13:32:22 -0700 (PDT)
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
	mef@scarletmail.rutgers.edu,
	paul@jakma.org
Subject: [PATCH net-next v14 14/15] quic: add packet builder base
Date: Wed, 15 Jul 2026 16:27:17 -0400
Message-ID: <78fb889d5e9dab5f93e40c978ee7cdc6fcea0f6a.1784147238.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1784147238.git.lucien.xin@gmail.com>
References: <cover.1784147238.git.lucien.xin@gmail.com>
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
v10:
  - Set MSS to QUIC_MIN_UDP_PAYLOAD in quic_packet_init(); it serves only
    as a default for procfs dumps before a connection exists.
  - Introduce QUIC_PACKET_INVALID as a return value for invalid packet
    types used in the later patch.
  - quic_sock.config.plpmtud_probe_interval has been moved to
    quic_path_group.plpmtud_interval, so update its usage in
    quic_packet_route() and quic_packet_config() accordingly.
v11:
  - Set maximum line length to 80 characters.
  - Change return type of quic_packet_empty() to bool.
  - Propagate errors from quic_packet_route() in quic_packet_config()
    (noted by AI review).
  - Use quic_packet_taglen() instead of open-coded logic in
    quic_packet_mss(), quic_packet_max_payload(), and
    quic_packet_max_payload_dgram() (noted by AI review).
  - Replace some magic numbers with QUIC_PACKET_FORM_SHORT/LONG and
    QUIC_PACKET_MSS_NORMAL/DGRAM (noted by Paolo).
  - Use WARN_ON_ONCE() instead of WARN_ON() in quic_packet_xmit().
    skb_set_owner_w/r() cannot be used here because it performs memory
    accounting, which is not desired in this context (noted by Paolo).
v12:
  - Set the minimum PMTU to 1200 in quic_packet_route().
  - Increase overhead in struct packet from u8 to u16, update the related
    cast and remove DEBUG_NET_WARN_ON_ONCE() in quic_packet_config().
  - Fix the MSS-based bundling size check and call skb_orphan() before
    bundling the skb in quic_packet_bundle().
  - Remove the quic_packet_xmit() declaration and mark it static.
  - Extract quic_packet_overhead() from quic_packet_config().
  - Change quic_packet_create_and_xmit() to return 0 on success and an
    error code on failure.
  - Remove errframe, errcode, frame_len, and ack_requested from struct
    quic_packet as they are no longer used, and update
    quic_packet_reset() accordingly.
  - Move ack_eliciting reset from quic_packet_config() to
    quic_packet_reset(), as it will only be used on the RX path.
  - Add padding as u16 in struct quic_packet to represent total padding
    bytes appended after frames.
  - Add path_validating in struct quic_packet for TX path to indicate
    whether a path_validating frame is included in the packet, and reset
    it in quic_packet_config().
  - Move version and padding fields up in struct quic_packet for better
    layout.
  - Fix the comment for len, frames, ack_eliciting, non_probing and
    has_sack in struct quic_packet.
  - Include taglen when updating the mss in struct quic_cong.
v14:
  - Pass gfp flags to quic_packet_handshake_create(),
    quic_packet_app_create(), quic_packet_number_check(),
    quic_packet_xmit(), and quic_packet_create_and_xmit()
    for allocations in subsequent patches.
---
 net/quic/Makefile |   2 +-
 net/quic/packet.c | 279 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/packet.h | 112 +++++++++++++++++++
 net/quic/socket.c |   1 +
 net/quic/socket.h |   8 ++
 5 files changed, 401 insertions(+), 1 deletion(-)
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
index 000000000000..f83b2c54a45a
--- /dev/null
+++ b/net/quic/packet.c
@@ -0,0 +1,279 @@
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
+static struct sk_buff *quic_packet_handshake_create(struct sock *sk, gfp_t gfp)
+{
+	return NULL;
+}
+
+static int quic_packet_number_check(struct sock *sk, gfp_t gfp)
+{
+	return 0;
+}
+
+static struct sk_buff *quic_packet_app_create(struct sock *sk, gfp_t gfp)
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
+	packet->mss[QUIC_PACKET_MSS_NORMAL] = (u16)mss;
+	quic_cong_set_mss(cong, packet->mss[QUIC_PACKET_MSS_NORMAL]);
+}
+
+/* Perform routing for the QUIC packet on the specified path, update header
+ * length and MSS accordingly, reset path and start PMTU timer.
+ */
+int quic_packet_route(struct sock *sk)
+{
+	struct quic_path_group *paths = quic_paths(sk);
+	struct quic_packet *packet = quic_packet(sk);
+	union quic_addr *sa, *da;
+	u32 pmtu;
+	int err;
+
+	da = quic_path_daddr(paths, packet->path);
+	sa = quic_path_saddr(paths, packet->path);
+	err = quic_flow_route(sk, da, sa, &paths->fl);
+	if (err)
+		return err < 0 ? err : 0;
+
+	packet->hlen = quic_encap_len(da);
+	pmtu = clamp(dst_mtu(__sk_dst_get(sk)),
+		     QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);
+	quic_packet_mss_update(sk, pmtu - packet->hlen);
+
+	quic_path_pl_reset(paths);
+	quic_timer_reset(sk, QUIC_TIMER_PMTU, paths->plpmtud_interval);
+	return 0;
+}
+
+/* Return QUIC packet header overhead for the given level and path. Includes
+ * packet number, connection IDs, and for long headers also version, length,
+ * and Initial token (if present). Excludes payload.
+ */
+u16 quic_packet_overhead(struct sock *sk, u8 level, u8 path)
+{
+	struct quic_conn_id_set *source = quic_source(sk);
+	struct quic_conn_id_set *dest = quic_dest(sk);
+	u16 len = QUIC_HLEN;
+
+	len += QUIC_PACKET_NUMBER_LEN; /* Packet number length. */
+	len += quic_conn_id_choose(dest, path)->len; /* DCID length. */
+	if (level == QUIC_CRYPTO_APP)
+		return len;
+
+	len += 1; /* Length byte for DCID. */
+	/* Length byte + SCID length. */
+	len += 1 + quic_conn_id_active(source)->len;
+	/* Include token for Initial packets. */
+	if (level == QUIC_CRYPTO_INITIAL)
+		len += quic_var_len(quic_token(sk)->len) + quic_token(sk)->len;
+	len += QUIC_VERSION_LEN; /* Version length. */
+	len += QUIC_PACKET_LENGTH_LEN; /* Packet length field. */
+
+	return len;
+}
+
+/* Configure the QUIC packet header and routing based on encryption level and
+ * path.
+ */
+int quic_packet_config(struct sock *sk, u8 level, u8 path)
+{
+	struct quic_packet *packet = quic_packet(sk);
+
+	/* If packet already has data, no need to reconfigure. */
+	if (!quic_packet_empty(packet))
+		return 0;
+
+	packet->path_validating = 0;
+	packet->ipfragok = 0;
+	packet->padding = 0;
+	packet->frames = 0;
+
+	packet->level = level;
+	packet->overhead = quic_packet_overhead(sk, level, path);
+	packet->len = packet->overhead + quic_packet_taglen(packet);
+
+	/* Allow fragmentation for handshake packets before PLPMTUD probing
+	 * starts. MTU discovery does not rely on ICMP Packet Too Big once
+	 * PLPMTUD is enabled.
+	 */
+	packet->ipfragok = level && !!quic_paths(sk)->plpmtud_interval;
+
+	if (packet->path != path) {
+		/* Path changed; update and reset routing cache */
+		packet->path = path;
+		__sk_dst_reset(sk);
+	}
+
+	/* Perform routing and MSS update for the configured packet. */
+	return quic_packet_route(sk);
+}
+
+static void quic_packet_encrypt_done(struct sk_buff *skb, int err)
+{
+	/* Free it for now, future patches will implement the actual deferred
+	 * transmission logic.
+	 */
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
+	if (packet->head->len + skb->len >
+	    packet->mss[QUIC_PACKET_MSS_NORMAL]) {
+		quic_packet_flush(sk);
+		goto init;
+	}
+	/* Bundle it and update metadata for the aggregate skb. */
+	skb_orphan(skb);
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
+	/* rfc9000#section-12.2: Packets with a short header (Section 17.3) do
+	 * not contain a Length field and so cannot be followed by other
+	 * packets in the same UDP datagram.
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
+static int quic_packet_xmit(struct sock *sk, struct sk_buff *skb, gfp_t gfp)
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
+	/* Associate skb with sk to ensure sk is valid during async encryption
+	 * completion.
+	 */
+	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
+	err = quic_crypto_encrypt(quic_crypto(sk, packet->level), skb, gfp);
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
+int quic_packet_create_and_xmit(struct sock *sk, gfp_t gfp)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct sk_buff *skb;
+	int err;
+
+	err = quic_packet_number_check(sk, gfp);
+	if (err)
+		goto err;
+
+	if (packet->level)
+		skb = quic_packet_handshake_create(sk, gfp);
+	else
+		skb = quic_packet_app_create(sk, gfp);
+	if (!skb) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	err = quic_packet_xmit(sk, skb, gfp);
+	if (err && err != -EINPROGRESS)
+		goto err;
+
+	return 0;
+err:
+	pr_debug("%s: err: %d\n", __func__, err);
+	return err;
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
+				quic_path_daddr(paths, packet->path),
+				&paths->fl);
+		packet->head = NULL;
+	}
+}
+
+void quic_packet_init(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+
+	INIT_LIST_HEAD(&packet->frame_list);
+	packet->taglen[QUIC_PACKET_FORM_SHORT] = QUIC_TAG_LEN;
+	packet->taglen[QUIC_PACKET_FORM_LONG] = QUIC_TAG_LEN;
+	packet->mss[QUIC_PACKET_MSS_NORMAL] = QUIC_MIN_UDP_PAYLOAD;
+	packet->mss[QUIC_PACKET_MSS_DGRAM] = QUIC_MIN_UDP_PAYLOAD;
+
+	packet->version = QUIC_VERSION_V1;
+}
diff --git a/net/quic/packet.h b/net/quic/packet.h
new file mode 100644
index 000000000000..18b89f505121
--- /dev/null
+++ b/net/quic/packet.h
@@ -0,0 +1,112 @@
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
+	struct quic_conn_id dcid; /* Dest Conn ID from received packet */
+	struct quic_conn_id scid; /* Source Conn ID from received packet */
+	union quic_addr daddr;    /* Dest address from received packet */
+	union quic_addr saddr;    /* Source address from received packet */
+
+	struct list_head frame_list; /* Frames to pack into packet for send */
+	struct sk_buff *head;        /* Head skb for packet bundling on send */
+	u32 version;   /* QUIC version used/selected during handshake */
+	u16 overhead;  /* QUIC header length excluding frames */
+	u8 taglen[2];  /* Tag length for short and long packets */
+	u16 padding;   /* Total padding bytes to append after frames */
+	u16 frames;    /* Number of ack-eliciting frames */
+	u16 mss[2];    /* MSS for datagram and non-datagram packets */
+	u16 hlen;      /* UDP + IP header length for sending */
+	u16 len;       /* QUIC packet length including taglen for sending */
+
+	u8 path_validating:1; /* Packet contains path_validating frames */
+	u8 ack_eliciting:1;   /* Packet contains ack-eliciting frames */
+	u8 ack_immediate:1;   /* Send ACK immediately (skip ack_delay timer) */
+	u8 non_probing:1;     /* Packet contains non-probing frames */
+	u8 has_sack:1;        /* Packet contains ACK frames */
+	u8 ipfragok:1;        /* Allow IP fragmentation */
+	u8 path:1;            /* Path identifier used to send this packet */
+	u8 level;             /* Encryption level used */
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
+#define QUIC_PACKET_INVALID		0xff
+
+#define QUIC_VERSION_LEN		4
+
+#define QUIC_PACKET_MSS_NORMAL		0
+#define QUIC_PACKET_MSS_DGRAM		1
+
+#define QUIC_PACKET_FORM_SHORT		0
+#define QUIC_PACKET_FORM_LONG		1
+
+static inline u8 quic_packet_taglen(struct quic_packet *packet)
+{
+	return packet->taglen[packet->level != QUIC_CRYPTO_APP];
+}
+
+static inline void quic_packet_set_taglen(struct quic_packet *packet, u8 taglen)
+{
+	packet->taglen[QUIC_PACKET_FORM_SHORT] = taglen;
+}
+
+static inline u32 quic_packet_mss(struct quic_packet *packet)
+{
+	return packet->mss[QUIC_PACKET_MSS_NORMAL] - quic_packet_taglen(packet);
+}
+
+static inline u32 quic_packet_max_payload(struct quic_packet *packet)
+{
+	return packet->mss[QUIC_PACKET_MSS_NORMAL] - packet->overhead -
+	       quic_packet_taglen(packet);
+}
+
+static inline u32 quic_packet_max_payload_dgram(struct quic_packet *packet)
+{
+	return packet->mss[QUIC_PACKET_MSS_DGRAM] - packet->overhead -
+	       quic_packet_taglen(packet);
+}
+
+static inline bool quic_packet_empty(struct quic_packet *packet)
+{
+	return list_empty(&packet->frame_list);
+}
+
+static inline void quic_packet_reset(struct quic_packet *packet)
+{
+	packet->level = 0;
+	packet->has_sack = 0;
+	packet->non_probing = 0;
+	packet->ack_eliciting = 0;
+	packet->ack_immediate = 0;
+}
+
+u16 quic_packet_overhead(struct sock *sk, u8 level, u8 path);
+int quic_packet_config(struct sock *sk, u8 level, u8 path);
+
+int quic_packet_create_and_xmit(struct sock *sk, gfp_t gfp);
+int quic_packet_route(struct sock *sk);
+
+void quic_packet_mss_update(struct sock *sk, u32 mss);
+void quic_packet_flush(struct sock *sk);
+void quic_packet_init(struct sock *sk);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 08a1b2f64ef3..8f348d7c678b 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -68,6 +68,7 @@ static int quic_init_sock(struct sock *sk)
 	quic_cong_init(quic_cong(sk));
 
 	quic_timer_init(sk);
+	quic_packet_init(sk);
 
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
diff --git a/net/quic/socket.h b/net/quic/socket.h
index c5654fdc06b5..1efc76ec2033 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -20,6 +20,8 @@
 #include "path.h"
 #include "cong.h"
 
+#include "packet.h"
+
 #include "protocol.h"
 #include "timer.h"
 
@@ -74,6 +76,7 @@ struct quic_sock {
 	struct quic_pnspace		space[QUIC_PNSPACE_MAX];
 	struct quic_crypto		crypto[QUIC_CRYPTO_MAX];
 
+	struct quic_packet		packet;
 	struct quic_timer		timers[QUIC_TIMER_MAX];
 };
 
@@ -147,6 +150,11 @@ static inline struct quic_crypto *quic_crypto(const struct sock *sk, u8 level)
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

