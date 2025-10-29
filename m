Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB68A3546EE
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 14:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761748798; cv=none; b=Z/NXTVONgHSB/FQFGBbvR7dirD2cHF+PVQ9Py9qqvN2gITPkLJQ6fY/pDwBdUXuM//iV1xAeYyr1JPivu/sri8u8bT9Z4j+3oPH8bq2j2E/Q9/aRFNBUxg1AwaBnSOJEbk/kBZ/ASLaK7DMtp+gbtnbNh2OJrpUSJziILF06gww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761748798; c=relaxed/simple;
	bh=2+5r0LqyFOyFqXfm1D5oi+MtfMgD393FvIAYsWyfJ/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S51IC8XtTfVpj0CqSwOsFX51bau0IDXxuQoWEnnrNe8HMhv2RfEtmp1hsK+yhVPoyYpgqIInCbdInRncMlV58LX6C+s4SW305aRAodiw+zyj08E73mRsxJYTMHeOBin1qnD6buD9nPgNBt7nHu/Pfhr6EHFlsYrUgCcPEpNKDPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R749Ov9s; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R749Ov9s"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4e896e91368so81543601cf.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 07:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761748794; x=1762353594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPhLkGC5mmvk3qZlT9se82+9VbI3B02J1InWEVgQGcE=;
        b=R749Ov9s1pNPpvFgHlLvgdguKeaQxJVc+w+74FuWmO9/N3i33eqWAyGjacUC0ZmMDY
         8UXUi9fJIC6qjp350ya8KQzLpIY/0ZevEN8jfcf4zcvmRfs/ghljHxOXaInqEIO20It6
         0idIXapETY3N0vaCIca/i/BoA1axHgCdPEo/ViAenb+LXbIOofKX3TpmVSSY/mXrBhff
         1To6ZcNfL+npGZuHs6tQ/2HbA0FHKqJq1MiYrb+oDktmcNC9p5J5HXtt92qoOyL0SAWN
         OhdiPQ0C/NbuHaf8IyvbghNvrjz0Xwoe7QywjMRZ1PPADlKlP+nb5BEX/Ofc3h1hmMjK
         dHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761748794; x=1762353594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPhLkGC5mmvk3qZlT9se82+9VbI3B02J1InWEVgQGcE=;
        b=KDw97uF39x58XBlHreMyNR50Zc6owv+GRuSimo8J8GlgKOi04WaA5OZ/aLFg9R3tE/
         aX8+ujRE2MtU0zYsiqqL44bHRh/UJzSSrFjAEDTXVMPFkX0kDqJs7S954xPCF8vc22oN
         hDoq2HfWpL9iJfibvUlJUQ2qcS8m3/V66KcBNrPWyZZgXdlMwYCVU/FyO49eSKEra+I4
         21VN5RkdYPlH51LFqMbTeR9tejf8eVPd9Df9/UikWz+M5A7QqrCrxYUbyb3+iAtTvkwn
         zefxQpHzxOk6h4JdJ1ZhC5J14bs/hiZLZV7mKuoXgvjFGABUQf6gNUO+C40/5UaudkNb
         WENw==
X-Forwarded-Encrypted: i=1; AJvYcCXHd8ClNLGDvGBN/vDVuI+D8RiEvaPh2fOR3pPn+k0KpWn2fpIcW43y6mTN3xnPScQ6To4uGDRHyRBr@vger.kernel.org
X-Gm-Message-State: AOJu0YwnsQXQzZB6hB87obQjbZ9ay5dMKloqWkIbVW36ZGwmQorlaCPb
	4LlUq9DWWjs8g3GxJWS7kTGqrLXTpAh/F1Vxj7VQrDIONq8IS0SZNywx
X-Gm-Gg: ASbGnct/DavpszdjBzbRqpuOLpEnTTUSNv2oyaSH3qcaDNnmZT69VT55utFk9WhbZyw
	7Qs6ep39ZUOV2d+9G7QZOQgyqM6RKUb6uoPx9Vv2ApjjUIuhm14TrdGSy3Yv59Hs2eygrrpO3/n
	yQWMJETg2qaXolmUyqlU0Tyjp6vNyWYZJXh9UCPXmHAGmgQppNzzMoMzeNuayrZmaUvwOszLASo
	S+gNPRFo87F7yv57rIt3U7VrDQLp8d+w2jWMHQAiERqxYdL7vssnHbm0iPVZlXluICiqSm1TRxc
	7+AdQawEvj+oLvZgL+DejkC+t7jG5mV0o7TtjaQiShdT0IhOo+n6ISLe5S5mGcJG8DvhUsYogAa
	KIgAldddvIwjq8y4HLVQ3Dp7ZpQlVocO7n0AC42LhpSAK4HnWVZhFba6NDVLp6u/VG3qFI2k6Vg
	Dizr5TMCc4daWk/orJXVhpnHi8kiZ4BtICoMu8LbjoLj8gEIk/hdw=
X-Google-Smtp-Source: AGHT+IEidloAkLzoawrKiQIZOrEn7/eGD3feqaWEsfnoBDVvdQNeGH6y+Gy8jMzvrRdcUM4uFw0Qgw==
X-Received: by 2002:a05:622a:1103:b0:4ec:f410:2470 with SMTP id d75a77b69052e-4ed15c4d35emr40583611cf.71.1761748793183;
        Wed, 29 Oct 2025 07:39:53 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48a8bc4sm99556176d6.7.2025.10.29.07.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 07:39:52 -0700 (PDT)
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
	Benjamin Coddington <bcodding@redhat.com>,
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
Subject: [PATCH net-next v4 15/15] quic: add packet builder and parser base
Date: Wed, 29 Oct 2025 10:35:57 -0400
Message-ID: <c9b7d644059fcd181a710ef2aff089e002133046.1761748557.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1761748557.git.lucien.xin@gmail.com>
References: <cover.1761748557.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch introduces 'quic_packet' to handle packing and unpacking of
QUIC packets on both the transmit (TX) and receive (RX) paths.

On the TX path, it provides functionality for frame packing and packet
construction. The packet configuration includes setting the path,
calculating overhead, and verifying routing. Frames are appended to the
packet before it is created with the queued frames.

Once assembled, the packet is encrypted, bundled, and sent out. There
is also support to flush the packet when no additional frames remain.
Functions to create application (short) and handshake (long) packets
are currently placeholders for future implementation.

- quic_packet_config(): Set the path, compute overhead, and verify routing.

- quic_packet_tail(): Append a frame to the packet for transmission.

- quic_packet_create(): Create the packet with the queued frames.

- quic_packet_xmit(): Encrypt, bundle, and send out the packet.

- quic_packet_flush(): Send the packet if there's nothing left to bundle.

On the RX side, the patch introduces mechanisms to parse the ALPN from
client Initial packets to determine the correct listener socket. Received
packets are then routed and processed accordingly. Similar to the TX path,
handling for application and handshake packets is not yet implemented.

- quic_packet_parse_alpn()`: Parse the ALPN from a client Initial packet,
  then locate the appropriate listener using the ALPN.

- quic_packet_rcv(): Locate the appropriate socket to handle the packet
  via quic_packet_process().

- quic_packet_process()`: Process the received packet.

In addition to packet flow, this patch adds support for ICMP-based MTU
updates by locating the relevant socket and updating the stored PMTU
accordingly.

- quic_packet_rcv_err_pmtu(): Find the socket and update the PMTU via
  quic_packet_mss_update().

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
---
 net/quic/Makefile   |   2 +-
 net/quic/packet.c   | 956 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/packet.h   | 130 ++++++
 net/quic/protocol.c |   6 +
 net/quic/protocol.h |   4 +
 net/quic/socket.c   | 135 +++++++
 net/quic/socket.h   |  12 +
 7 files changed, 1244 insertions(+), 1 deletion(-)
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
index 000000000000..d5860ce60899
--- /dev/null
+++ b/net/quic/packet.c
@@ -0,0 +1,956 @@
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
+#define QUIC_LONG_HLEN(dcid, scid) \
+	(QUIC_HLEN + QUIC_VERSION_LEN + 1 + (dcid)->len + 1 + (scid)->len)
+
+#define QUIC_VERSION_NUM	2
+
+/* Supported QUIC versions and their compatible versions. Used for Compatible Version
+ * Negotiation in rfc9368#section-2.3.
+ */
+static u32 quic_versions[QUIC_VERSION_NUM][4] = {
+	/* Version,	Compatible Versions */
+	{ QUIC_VERSION_V1,	QUIC_VERSION_V2,	QUIC_VERSION_V1,	0 },
+	{ QUIC_VERSION_V2,	QUIC_VERSION_V2,	QUIC_VERSION_V1,	0 },
+};
+
+/* Get the compatible version list for a given QUIC version. */
+u32 *quic_packet_compatible_versions(u32 version)
+{
+	u8 i;
+
+	for (i = 0; i < QUIC_VERSION_NUM; i++)
+		if (version == quic_versions[i][0])
+			return quic_versions[i];
+	return NULL;
+}
+
+/* Convert version-specific type to internal standard packet type. */
+static u8 quic_packet_version_get_type(u32 version, u8 type)
+{
+	if (version == QUIC_VERSION_V1)
+		return type;
+
+	switch (type) {
+	case QUIC_PACKET_INITIAL_V2:
+		return QUIC_PACKET_INITIAL;
+	case QUIC_PACKET_0RTT_V2:
+		return QUIC_PACKET_0RTT;
+	case QUIC_PACKET_HANDSHAKE_V2:
+		return QUIC_PACKET_HANDSHAKE;
+	case QUIC_PACKET_RETRY_V2:
+		return QUIC_PACKET_RETRY;
+	default:
+		return -1;
+	}
+	return -1;
+}
+
+/* Parse QUIC version and connection IDs (DCID and SCID) from a Long header packet buffer. */
+static int quic_packet_get_version_and_connid(struct quic_conn_id *dcid, struct quic_conn_id *scid,
+					      u32 *version, u8 **pp, u32 *plen)
+{
+	u64 len, v;
+
+	*pp += QUIC_HLEN;
+	*plen -= QUIC_HLEN;
+
+	if (!quic_get_int(pp, plen, &v, QUIC_VERSION_LEN))
+		return -EINVAL;
+	*version = v;
+
+	if (!quic_get_int(pp, plen, &len, 1) ||
+	    len > *plen || len > QUIC_CONN_ID_MAX_LEN)
+		return -EINVAL;
+	quic_conn_id_update(dcid, *pp, len);
+	*plen -= len;
+	*pp += len;
+
+	if (!quic_get_int(pp, plen, &len, 1) ||
+	    len > *plen || len > QUIC_CONN_ID_MAX_LEN)
+		return -EINVAL;
+	quic_conn_id_update(scid, *pp, len);
+	*plen -= len;
+	*pp += len;
+	return 0;
+}
+
+/* Change the QUIC version for the connection.
+ *
+ * Frees existing initial crypto keys and installs new initial keys compatible with the new
+ * version.
+ */
+static int quic_packet_version_change(struct sock *sk, struct quic_conn_id *dcid, u32 version)
+{
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+
+	if (quic_crypto_initial_keys_install(crypto, dcid, version, quic_is_serv(sk)))
+		return -1;
+
+	quic_packet(sk)->version = version;
+	return 0;
+}
+
+/* Select the best compatible QUIC version from offered list.
+ *
+ * Considers the local preferred version, currently chosen version, and versions offered by
+ * the peer. Selects the best compatible version based on client/server role and updates the
+ * connection version accordingly.
+ */
+int quic_packet_select_version(struct sock *sk, u32 *versions, u8 count)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_config *c = quic_config(sk);
+	u8 i, pref_found = 0, ch_found = 0;
+	u32 preferred, chosen, best = 0;
+
+	preferred = c->version ?: QUIC_VERSION_V1;
+	chosen = packet->version;
+
+	for (i = 0; i < count; i++) {
+		if (!quic_packet_compatible_versions(versions[i]))
+			continue;
+		if (preferred == versions[i])
+			pref_found = 1;
+		if (chosen == versions[i])
+			ch_found = 1;
+		if (best < versions[i]) /* Track highest offered version. */
+			best = versions[i];
+	}
+
+	if (!pref_found && !ch_found && !best)
+		return -1;
+
+	if (quic_is_serv(sk)) { /* Server prefers preferred version if offered, else chosen. */
+		if (pref_found)
+			best = preferred;
+		else if (ch_found)
+			best = chosen;
+	} else { /* Client prefers chosen version, else preferred. */
+		if (ch_found)
+			best = chosen;
+		else if (pref_found)
+			best = preferred;
+	}
+
+	if (packet->version == best)
+		return 0;
+
+	/* Change to selected best version. */
+	return quic_packet_version_change(sk, &quic_paths(sk)->orig_dcid, best);
+}
+
+/* Extracts a QUIC token from a buffer in the Client Initial packet. */
+static int quic_packet_get_token(struct quic_data *token, u8 **pp, u32 *plen)
+{
+	u64 len;
+
+	if (!quic_get_var(pp, plen, &len) || len > *plen)
+		return -EINVAL;
+	quic_data(token, *pp, len);
+	*plen -= len;
+	*pp += len;
+	return 0;
+}
+
+/* Process PMTU reduction event on a QUIC socket. */
+void quic_packet_rcv_err_pmtu(struct sock *sk)
+{
+	struct quic_path_group *paths = quic_paths(sk);
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_config *c = quic_config(sk);
+	u32 pathmtu, info, taglen;
+	struct dst_entry *dst;
+	bool reset_timer;
+
+	if (!ip_sk_accept_pmtu(sk))
+		return;
+
+	info = clamp(paths->mtu_info, QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);
+	/* If PLPMTUD is not enabled, update MSS using the route and ICMP info. */
+	if (!c->plpmtud_probe_interval) {
+		if (quic_packet_route(sk) < 0)
+			return;
+
+		dst = __sk_dst_get(sk);
+		dst->ops->update_pmtu(dst, sk, NULL, info, true);
+		quic_packet_mss_update(sk, info - packet->hlen);
+		return;
+	}
+	/* PLPMTUD is enabled: adjust to smaller PMTU, subtract headers and AEAD tag.  Also
+	 * notify the QUIC path layer for possible state changes and probing.
+	 */
+	taglen = quic_packet_taglen(packet);
+	info = info - packet->hlen - taglen;
+	pathmtu = quic_path_pl_toobig(paths, info, &reset_timer);
+	if (reset_timer)
+		quic_timer_reset(sk, QUIC_TIMER_PMTU, c->plpmtud_probe_interval);
+	if (pathmtu)
+		quic_packet_mss_update(sk, pathmtu + taglen);
+}
+
+/* Handle ICMP Toobig packet and update QUIC socket path MTU. */
+static int quic_packet_rcv_err(struct sk_buff *skb)
+{
+	union quic_addr daddr, saddr;
+	struct sock *sk = NULL;
+	int ret = 0;
+	u32 info;
+
+	/* All we can do is lookup the matching QUIC socket by addresses. */
+	quic_get_msg_addrs(skb, &saddr, &daddr);
+	sk = quic_sock_lookup(skb, &daddr, &saddr, NULL);
+	if (!sk)
+		return -ENOENT;
+
+	bh_lock_sock(sk);
+	if (quic_is_listen(sk))
+		goto out;
+
+	if (quic_get_mtu_info(skb, &info))
+		goto out;
+
+	ret = 1; /* Success: update socket path MTU info. */
+	quic_paths(sk)->mtu_info = info;
+	if (sock_owned_by_user(sk)) {
+		/* Socket is in use by userspace context.  Defer MTU processing to later via
+		 * tasklet.  Ensure the socket is not dropped before deferral.
+		 */
+		if (!test_and_set_bit(QUIC_MTU_REDUCED_DEFERRED, &sk->sk_tsq_flags))
+			sock_hold(sk);
+		goto out;
+	}
+	/* Otherwise, process the MTU reduction now. */
+	quic_packet_rcv_err_pmtu(sk);
+out:
+	bh_unlock_sock(sk);
+	sock_put(sk);
+	return ret;
+}
+
+#define QUIC_PACKET_BACKLOG_MAX		4096
+
+/* Queue a packet for later processing when sleeping is allowed. */
+static int quic_packet_backlog_schedule(struct net *net, struct sk_buff *skb)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct quic_net *qn = quic_net(net);
+
+	if (cb->backlog)
+		return 0;
+
+	if (skb_queue_len_lockless(&qn->backlog_list) >= QUIC_PACKET_BACKLOG_MAX) {
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVDROP);
+		kfree_skb(skb);
+		return -1;
+	}
+
+	cb->backlog = 1;
+	skb_queue_tail(&qn->backlog_list, skb);
+	queue_work(quic_wq, &qn->work);
+	return 1;
+}
+
+#define TLS_MT_CLIENT_HELLO	1
+#define TLS_EXT_alpn		16
+
+/*  TLS Client Hello Msg:
+ *
+ *    uint16 ProtocolVersion;
+ *    opaque Random[32];
+ *    uint8 CipherSuite[2];
+ *
+ *    struct {
+ *        ExtensionType extension_type;
+ *        opaque extension_data<0..2^16-1>;
+ *    } Extension;
+ *
+ *    struct {
+ *        ProtocolVersion legacy_version = 0x0303;
+ *        Random rand;
+ *        opaque legacy_session_id<0..32>;
+ *        CipherSuite cipher_suites<2..2^16-2>;
+ *        opaque legacy_compression_methods<1..2^8-1>;
+ *        Extension extensions<8..2^16-1>;
+ *    } ClientHello;
+ */
+
+#define TLS_CH_RANDOM_LEN	32
+#define TLS_CH_VERSION_LEN	2
+
+/* Extract ALPN data from a TLS ClientHello message.
+ *
+ * Parses the TLS ClientHello handshake message to find the ALPN (Application Layer Protocol
+ * Negotiation) TLS extension. It validates the TLS ClientHello structure, including version,
+ * random, session ID, cipher suites, compression methods, and extensions. Once the ALPN
+ * extension is found, the ALPN protocols list is extracted and stored in @alpn.
+ *
+ * Return: 0 on success or no ALPN found, a negative error code on failed parsing.
+ */
+static int quic_packet_get_alpn(struct quic_data *alpn, u8 *p, u32 len)
+{
+	int err = -EINVAL, found = 0;
+	u64 length, type;
+
+	/* Verify handshake message type (ClientHello) and its length. */
+	if (!quic_get_int(&p, &len, &type, 1) || type != TLS_MT_CLIENT_HELLO)
+		return err;
+	if (!quic_get_int(&p, &len, &length, 3) ||
+	    length < TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN)
+		return err;
+	if (len > (u32)length) /* Limit len to handshake message length if larger. */
+		len = length;
+	/* Skip legacy_version (2 bytes) + random (32 bytes). */
+	p += TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN;
+	len -= TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN;
+	/* legacy_session_id_len must be zero (QUIC requirement). */
+	if (!quic_get_int(&p, &len, &length, 1) || length)
+		return err;
+
+	/* Skip cipher_suites (2 bytes length + variable data). */
+	if (!quic_get_int(&p, &len, &length, 2) || length > (u64)len)
+		return err;
+	len -= length;
+	p += length;
+
+	/* Skip legacy_compression_methods (1 byte length + variable data). */
+	if (!quic_get_int(&p, &len, &length, 1) || length > (u64)len)
+		return err;
+	len -= length;
+	p += length;
+
+	if (!quic_get_int(&p, &len, &length, 2)) /* Read TLS extensions length (2 bytes). */
+		return err;
+	if (len > (u32)length) /* Limit len to extensions length if larger. */
+		len = length;
+	while (len > 4) { /* Iterate over extensions to find ALPN (type TLS_EXT_alpn). */
+		if (!quic_get_int(&p, &len, &type, 2))
+			break;
+		if (!quic_get_int(&p, &len, &length, 2))
+			break;
+		if (len < (u32)length) /* Incomplete TLS extensions. */
+			return 0;
+		if (type == TLS_EXT_alpn) { /* Found ALPN extension. */
+			len = length;
+			found = 1;
+			break;
+		}
+		/* Skip non-ALPN extensions. */
+		p += length;
+		len -= length;
+	}
+	if (!found) { /* no ALPN extension found: set alpn->len = 0 and alpn->data = p. */
+		quic_data(alpn, p, 0);
+		return 0;
+	}
+
+	/* Parse ALPN protocols list length (2 bytes). */
+	if (!quic_get_int(&p, &len, &length, 2) || length > (u64)len)
+		return err;
+	quic_data(alpn, p, length); /* Store ALPN protocols list in alpn->data. */
+	len = length;
+	while (len) { /* Validate ALPN protocols list format. */
+		if (!quic_get_int(&p, &len, &length, 1) || length > (u64)len) {
+			/* Malformed ALPN entry: set alpn->len = 0 and alpn->data = NULL. */
+			quic_data(alpn, NULL, 0);
+			return err;
+		}
+		len -= length;
+		p += length;
+	}
+	pr_debug("%s: alpn_len: %d\n", __func__, alpn->len);
+	return 0;
+}
+
+/* Parse ALPN from a QUIC Initial packet.
+ *
+ * This function processes a QUIC Initial packet to extract the ALPN from the TLS ClientHello
+ * message inside the QUIC CRYPTO frame. It verifies packet type, version compatibility,
+ * decrypts the packet payload, and locates the CRYPTO frame to parse the TLS ClientHello.
+ * Finally, it calls quic_packet_get_alpn() to extract the ALPN extension data.
+ *
+ * Return: 0 on success or no ALPN found, a negative error code on failed parsing.
+ */
+static int quic_packet_parse_alpn(struct sk_buff *skb, struct quic_data *alpn)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct net *net = sock_net(skb->sk);
+	u8 *p = skb->data, *data, type;
+	struct quic_conn_id dcid, scid;
+	u32 len = skb->len, version;
+	struct quic_crypto *crypto;
+	struct quic_data token;
+	u64 offset, length;
+	int err = -EINVAL;
+
+	if (!sysctl_quic_alpn_demux)
+		return 0;
+	if (quic_packet_get_version_and_connid(&dcid, &scid, &version, &p, &len))
+		return err;
+	if (!quic_packet_compatible_versions(version))
+		return 0;
+	/* Only parse Initial packets. */
+	type = quic_packet_version_get_type(version, quic_hshdr(skb)->type);
+	if (type != QUIC_PACKET_INITIAL)
+		return 0;
+	if (quic_packet_get_token(&token, &p, &len))
+		return err;
+	if (!quic_get_var(&p, &len, &length) || length > (u64)len)
+		return err;
+	if (!cb->backlog) {
+		quic_packet_backlog_schedule(net, skb_get(skb));
+		return err;
+	}
+	cb->length = (u16)length;
+	/* Copy skb data for restoring in case of decrypt failure. */
+	data = kmemdup(skb->data, skb->len, GFP_ATOMIC);
+	if (!data)
+		return -ENOMEM;
+
+	/* Install initial keys for packet decryption to crypto. */
+	crypto = &quic_net(net)->crypto;
+	err = quic_crypto_initial_keys_install(crypto, &dcid, version, 1);
+	if (err)
+		goto out;
+	cb->number_offset = (u16)(p - skb->data);
+	err = quic_crypto_decrypt(crypto, skb);
+	if (err) {
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_DECDROP);
+		/* Restore original data on decrypt failure. */
+		memcpy(skb->data, data, skb->len);
+		goto out;
+	}
+
+	QUIC_INC_STATS(net, QUIC_MIB_PKT_DECFASTPATHS);
+	cb->resume = 1; /* Mark this packet as already decrypted. */
+
+	/* Find the QUIC CRYPTO frame. */
+	p += cb->number_len;
+	len = cb->length - cb->number_len - QUIC_TAG_LEN;
+	for (; len && !(*p); p++, len--) /* Skip the padding frame. */
+		;
+	if (!len-- || *p++ != QUIC_FRAME_CRYPTO)
+		goto out;
+	if (!quic_get_var(&p, &len, &offset) || offset)
+		goto out;
+	if (!quic_get_var(&p, &len, &length) || length > (u64)len)
+		goto out;
+
+	/* Parse the TLS CLIENT_HELLO message. */
+	err = quic_packet_get_alpn(alpn, p, length);
+
+out:
+	kfree(data);
+	return err;
+}
+
+/* Extract the Destination Connection ID (DCID) from a QUIC Long header packet. */
+int quic_packet_get_dcid(struct quic_conn_id *dcid, struct sk_buff *skb)
+{
+	u32 plen = skb->len;
+	u8 *p = skb->data;
+	u64 len;
+
+	if (plen < QUIC_HLEN + QUIC_VERSION_LEN)
+		return -EINVAL;
+	plen -= (QUIC_HLEN + QUIC_VERSION_LEN);
+	p += (QUIC_HLEN + QUIC_VERSION_LEN);
+
+	if (!quic_get_int(&p, &plen, &len, 1) ||
+	    len > plen || len > QUIC_CONN_ID_MAX_LEN)
+		return -EINVAL;
+	quic_conn_id_update(dcid, p, len);
+	return 0;
+}
+
+/* Lookup listening socket for Client Initial packet (in process context). */
+static struct sock *quic_packet_get_listen_sock(struct sk_buff *skb)
+{
+	union quic_addr daddr, saddr;
+	struct quic_data alpns = {};
+	struct sock *sk;
+
+	quic_get_msg_addrs(skb, &daddr, &saddr);
+
+	if (quic_packet_parse_alpn(skb, &alpns))
+		return NULL;
+
+	local_bh_disable();
+	sk = quic_listen_sock_lookup(skb, &daddr, &saddr, &alpns);
+	local_bh_enable();
+
+	return sk;
+}
+
+/* Determine the QUIC socket associated with an incoming packet. */
+static struct sock *quic_packet_get_sock(struct sk_buff *skb)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct net *net = sock_net(skb->sk);
+	struct quic_conn_id dcid, *conn_id;
+	union quic_addr daddr, saddr;
+	struct quic_data alpns = {};
+	struct sock *sk = NULL;
+
+	if (skb->len < QUIC_HLEN)
+		return NULL;
+
+	if (!quic_hdr(skb)->form) { /* Short header path. */
+		if (skb->len < QUIC_HLEN + QUIC_CONN_ID_DEF_LEN)
+			return NULL;
+		/* Fast path: look up QUIC connection by fixed-length DCID
+		 * (Currently, only source CIDs of size QUIC_CONN_ID_DEF_LEN are used).
+		 */
+		conn_id = quic_conn_id_lookup(net, skb->data + QUIC_HLEN,
+					      QUIC_CONN_ID_DEF_LEN);
+		if (conn_id) {
+			cb->seqno = quic_conn_id_number(conn_id);
+			return quic_conn_id_sk(conn_id); /* Return associated socket. */
+		}
+
+		/* Fallback: listener socket lookup
+		 * (May be used to send a stateless reset from a listen socket).
+		 */
+		quic_get_msg_addrs(skb, &daddr, &saddr);
+		sk = quic_listen_sock_lookup(skb, &daddr, &saddr, &alpns);
+		if (sk)
+			return sk;
+		/* Final fallback: address-based connection lookup
+		 * (May be used to receive a stateless reset).
+		 */
+		return quic_sock_lookup(skb, &daddr, &saddr, NULL);
+	}
+
+	/* Long header path. */
+	if (quic_packet_get_dcid(&dcid, skb))
+		return NULL;
+	/* Fast path: look up QUIC connection by parsed DCID. */
+	conn_id = quic_conn_id_lookup(net, dcid.data, dcid.len);
+	if (conn_id) {
+		cb->seqno = quic_conn_id_number(conn_id);
+		return quic_conn_id_sk(conn_id); /* Return associated socket. */
+	}
+
+	/* Fallback: address + DCID lookup
+	 * (May be used for 0-RTT or a follow-up Client Initial packet).
+	 */
+	quic_get_msg_addrs(skb, &daddr, &saddr);
+	sk = quic_sock_lookup(skb, &daddr, &saddr, &dcid);
+	if (sk)
+		return sk;
+	/* Final fallback: listener socket lookup
+	 * (Used for receiving the first Client Initial packet).
+	 */
+	if (quic_packet_parse_alpn(skb, &alpns))
+		return NULL;
+	return quic_listen_sock_lookup(skb, &daddr, &saddr, &alpns);
+}
+
+/* Entry point for processing received QUIC packets. */
+int quic_packet_rcv(struct sk_buff *skb, u8 err)
+{
+	struct net *net = sock_net(skb->sk);
+	struct sock *sk;
+
+	if (unlikely(err))
+		return quic_packet_rcv_err(skb);
+
+	skb_pull(skb, skb_transport_offset(skb));
+
+	/* Look up socket from socket or connection IDs hash tables. */
+	sk = quic_packet_get_sock(skb);
+	if (!sk)
+		goto err;
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		/* Socket is busy (owned by user context): queue to backlog. */
+		if (sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf))) {
+			QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVDROP);
+			bh_unlock_sock(sk);
+			sock_put(sk);
+			goto err;
+		}
+		QUIC_SKB_CB(skb)->backlog = 1;
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVBACKLOGS);
+	} else {
+		/* Socket not busy: process immediately. */
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVFASTPATHS);
+		sk->sk_backlog_rcv(sk, skb); /* quic_packet_process(). */
+	}
+	bh_unlock_sock(sk);
+	sock_put(sk);
+	return 0;
+
+err:
+	kfree_skb(skb);
+	return -EINVAL;
+}
+
+static int quic_packet_listen_process(struct sock *sk, struct sk_buff *skb)
+{
+	kfree_skb(skb);
+	return -EOPNOTSUPP;
+}
+
+static int quic_packet_handshake_process(struct sock *sk, struct sk_buff *skb)
+{
+	kfree_skb(skb);
+	return -EOPNOTSUPP;
+}
+
+static int quic_packet_app_process(struct sock *sk, struct sk_buff *skb)
+{
+	kfree_skb(skb);
+	return -EOPNOTSUPP;
+}
+
+int quic_packet_process(struct sock *sk, struct sk_buff *skb)
+{
+	if (quic_is_closed(sk)) {
+		kfree_skb(skb);
+		return 0;
+	}
+
+	if (quic_is_listen(sk))
+		return quic_packet_listen_process(sk, skb);
+
+	if (quic_hdr(skb)->form)
+		return quic_packet_handshake_process(sk, skb);
+
+	return quic_packet_app_process(sk, skb);
+}
+
+/* Work function to process packets in the backlog queue. */
+void quic_packet_backlog_work(struct work_struct *work)
+{
+	struct quic_net *qn = container_of(work, struct quic_net, work);
+	struct sk_buff *skb;
+	struct sock *sk;
+
+	skb = skb_dequeue(&qn->backlog_list);
+	while (skb) {
+		sk = quic_packet_get_listen_sock(skb);
+		if (!sk)
+			continue;
+
+		lock_sock(sk);
+		quic_packet_process(sk, skb);
+		release_sock(sk);
+		sock_put(sk);
+
+		skb = skb_dequeue(&qn->backlog_list);
+	}
+}
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
+int quic_packet_create(struct sock *sk)
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
index 000000000000..b2e2a48b1486
--- /dev/null
+++ b/net/quic/packet.h
@@ -0,0 +1,130 @@
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
+	u32 sent_time;		/* Time when packet was sent */
+	u16 frame_len;		/* Combined length of all frames held */
+	u16 frames;		/* Number of frames held */
+
+	s64 number;		/* Packet number */
+	u8  level;		/* Packet number space */
+	u8  ecn:2;		/* ECN bits */
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
+int quic_packet_process(struct sock *sk, struct sk_buff *skb);
+int quic_packet_config(struct sock *sk, u8 level, u8 path);
+
+int quic_packet_xmit(struct sock *sk, struct sk_buff *skb);
+int quic_packet_create(struct sock *sk);
+int quic_packet_route(struct sock *sk);
+
+void quic_packet_mss_update(struct sock *sk, u32 mss);
+void quic_packet_flush(struct sock *sk);
+void quic_packet_init(struct sock *sk);
+
+int quic_packet_get_dcid(struct quic_conn_id *dcid, struct sk_buff *skb);
+int quic_packet_select_version(struct sock *sk, u32 *versions, u8 count);
+u32 *quic_packet_compatible_versions(u32 version);
+
+void quic_packet_backlog_work(struct work_struct *work);
+void quic_packet_rcv_err_pmtu(struct sock *sk);
+int quic_packet_rcv(struct sk_buff *skb, u8 err);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index aabbbd9361f1..8de09b57f0e5 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -273,6 +273,9 @@ static int __net_init quic_net_init(struct net *net)
 		return err;
 	}
 
+	INIT_WORK(&qn->work, quic_packet_backlog_work);
+	skb_queue_head_init(&qn->backlog_list);
+
 #ifdef CONFIG_PROC_FS
 	err = quic_net_proc_init(net);
 	if (err) {
@@ -291,6 +294,8 @@ static void __net_exit quic_net_exit(struct net *net)
 #ifdef CONFIG_PROC_FS
 	quic_net_proc_exit(net);
 #endif
+	skb_queue_purge(&qn->backlog_list);
+	cancel_work_sync(&qn->work);
 	quic_crypto_free(&qn->crypto);
 	free_percpu(qn->stat);
 	qn->stat = NULL;
@@ -340,6 +345,7 @@ static __init int quic_init(void)
 	sysctl_quic_wmem[1] = 16 * 1024;
 	sysctl_quic_wmem[2] = max(64 * 1024, max_share);
 
+	quic_path_init(quic_packet_rcv);
 	quic_crypto_init();
 
 	quic_frame_cachep = kmem_cache_create("quic_frame", sizeof(struct quic_frame),
diff --git a/net/quic/protocol.h b/net/quic/protocol.h
index 91b28554dccf..402fd310b606 100644
--- a/net/quic/protocol.h
+++ b/net/quic/protocol.h
@@ -50,6 +50,10 @@ struct quic_net {
 	struct proc_dir_entry *proc_net;	/* procfs entry for dumping QUIC socket stats */
 #endif
 	struct quic_crypto crypto;	/* Context for decrypting Initial packets for ALPN */
+
+	/* Queue of packets deferred for processing in process context */
+	struct sk_buff_head backlog_list;
+	struct work_struct work;	/* Work scheduled to drain and process backlog_list */
 };
 
 struct quic_net *quic_net(struct net *net);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 497ad30c51d3..1e12db4b4327 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -24,6 +24,134 @@ static void quic_enter_memory_pressure(struct sock *sk)
 	WRITE_ONCE(quic_memory_pressure, 1);
 }
 
+/* Lookup a connected QUIC socket based on address and dest connection ID.
+ *
+ * This function searches the established (non-listening) QUIC socket table for a socket that
+ * matches the source and dest addresses and, optionally, the dest connection ID (DCID). The
+ * value returned by quic_path_orig_dcid() might be the original dest connection ID from the
+ * ClientHello or the Source Connection ID from a Retry packet before.
+ *
+ * The DCID is provided from a handshake packet when searching by source connection ID fails,
+ * such as when the peer has not yet received server's response and updated the DCID.
+ *
+ * Return: A pointer to the matching connected socket, or NULL if no match is found.
+ */
+struct sock *quic_sock_lookup(struct sk_buff *skb, union quic_addr *sa, union quic_addr *da,
+			      struct quic_conn_id *dcid)
+{
+	struct net *net = sock_net(skb->sk);
+	struct quic_path_group *paths;
+	struct hlist_nulls_node *node;
+	struct quic_shash_head *head;
+	struct sock *sk = NULL, *tmp;
+	unsigned int hash;
+
+	hash = quic_sock_hash(net, sa, da);
+	head = quic_sock_head(hash);
+
+	rcu_read_lock();
+begin:
+	sk_nulls_for_each_rcu(tmp, node, &head->head) {
+		if (net != sock_net(tmp))
+			continue;
+		paths = quic_paths(tmp);
+		if (quic_cmp_sk_addr(tmp, quic_path_saddr(paths, 0), sa) &&
+		    quic_cmp_sk_addr(tmp, quic_path_daddr(paths, 0), da) &&
+		    quic_path_usock(paths, 0) == skb->sk &&
+		    (!dcid || !quic_conn_id_cmp(quic_path_orig_dcid(paths), dcid))) {
+			sk = tmp;
+			break;
+		}
+	}
+	/* If the nulls value we got at the end of the iteration is different from the expected
+	 * one, we must restart the lookup as the list was modified concurrently.
+	 */
+	if (!sk && get_nulls_value(node) != hash)
+		goto begin;
+
+	if (sk && unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+		sk = NULL;
+	rcu_read_unlock();
+	return sk;
+}
+
+/* Find the listening QUIC socket for an incoming packet.
+ *
+ * This function searches the QUIC socket table for a listening socket that matches the dest
+ * address and port, and the ALPN(s) if presented in the ClientHello.  If multiple listening
+ * sockets are bound to the same address, port, and ALPN(s) (e.g., via SO_REUSEPORT), this
+ * function selects a socket from the reuseport group.
+ *
+ * Return: A pointer to the matching listening socket, or NULL if no match is found.
+ */
+struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa, union quic_addr *da,
+				     struct quic_data *alpns)
+{
+	struct net *net = sock_net(skb->sk);
+	struct hlist_nulls_node *node;
+	struct sock *sk = NULL, *tmp;
+	struct quic_shash_head *head;
+	struct quic_data alpn;
+	union quic_addr *a;
+	u32 hash, len;
+	u64 length;
+	u8 *p;
+
+	hash = quic_listen_sock_hash(net, ntohs(sa->v4.sin_port));
+	head = quic_listen_sock_head(hash);
+
+	rcu_read_lock();
+begin:
+	if (!alpns->len) { /* No ALPN entries present or failed to parse the ALPNs. */
+		sk_nulls_for_each_rcu(tmp, node, &head->head) {
+			/* If alpns->data != NULL, TLS parsing succeeded but no ALPN was found.
+			 * In this case, only match sockets that have no ALPN set.
+			 */
+			a = quic_path_saddr(quic_paths(tmp), 0);
+			if (net == sock_net(tmp) && quic_cmp_sk_addr(tmp, a, sa) &&
+			    quic_path_usock(quic_paths(tmp), 0) == skb->sk &&
+			    (!alpns->data || !quic_alpn(tmp)->len)) {
+				sk = tmp;
+				if (!quic_is_any_addr(a)) /* Prefer specific address match. */
+					break;
+			}
+		}
+		goto out;
+	}
+
+	/* ALPN present: loop through each ALPN entry. */
+	for (p = alpns->data, len = alpns->len; len; len -= length, p += length) {
+		quic_get_int(&p, &len, &length, 1);
+		quic_data(&alpn, p, length);
+		sk_nulls_for_each_rcu(tmp, node, &head->head) {
+			a = quic_path_saddr(quic_paths(tmp), 0);
+			if (net == sock_net(tmp) && quic_cmp_sk_addr(tmp, a, sa) &&
+			    quic_path_usock(quic_paths(tmp), 0) == skb->sk &&
+			    quic_data_has(quic_alpn(tmp), &alpn)) {
+				sk = tmp;
+				if (!quic_is_any_addr(a))
+					break;
+			}
+		}
+		if (sk)
+			break;
+	}
+out:
+	/* If the nulls value we got at the end of the iteration is different from the expected
+	 * one, we must restart the lookup as the list was modified concurrently.
+	 */
+	if (!sk && get_nulls_value(node) != hash)
+		goto begin;
+
+	if (sk && sk->sk_reuseport)
+		sk = reuseport_select_sock(sk, quic_addr_hash(net, da), skb, 1);
+
+	if (sk && unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+		sk = NULL;
+	rcu_read_unlock();
+	return sk;
+}
+
 static void quic_write_space(struct sock *sk)
 {
 	struct socket_wq *wq;
@@ -48,6 +176,7 @@ static int quic_init_sock(struct sock *sk)
 	quic_cong_init(quic_cong(sk));
 
 	quic_timer_init(sk);
+	quic_packet_init(sk);
 
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
@@ -217,6 +346,10 @@ static void quic_release_cb(struct sock *sk)
 		nflags = flags & ~QUIC_DEFERRED_ALL;
 	} while (!try_cmpxchg(&sk->sk_tsq_flags, &flags, nflags));
 
+	if (flags & QUIC_F_MTU_REDUCED_DEFERRED) {
+		quic_packet_rcv_err_pmtu(sk);
+		__sock_put(sk);
+	}
 	if (flags & QUIC_F_LOSS_DEFERRED) {
 		quic_timer_loss_handler(sk);
 		__sock_put(sk);
@@ -266,6 +399,7 @@ struct proto quic_prot = {
 	.accept		=  quic_accept,
 	.hash		=  quic_hash,
 	.unhash		=  quic_unhash,
+	.backlog_rcv	=  quic_packet_process,
 	.release_cb	=  quic_release_cb,
 	.no_autobind	=  true,
 	.obj_size	=  sizeof(struct quic_sock),
@@ -296,6 +430,7 @@ struct proto quicv6_prot = {
 	.accept		=  quic_accept,
 	.hash		=  quic_hash,
 	.unhash		=  quic_unhash,
+	.backlog_rcv	=  quic_packet_process,
 	.release_cb	=  quic_release_cb,
 	.no_autobind	=  true,
 	.obj_size	= sizeof(struct quic6_sock),
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 138ea839fb7b..ce8adfe2eff9 100644
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
@@ -200,3 +207,8 @@ static inline void quic_set_state(struct sock *sk, int state)
 	inet_sk_set_state(sk, state);
 	sk->sk_state_change(sk);
 }
+
+struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa, union quic_addr *da,
+				     struct quic_data *alpns);
+struct sock *quic_sock_lookup(struct sk_buff *skb, union quic_addr *sa, union quic_addr *da,
+			      struct quic_conn_id *dcid);
-- 
2.47.1

