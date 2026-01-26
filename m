Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECE232AACD
	for <linux-cifs@vger.kernel.org>; Mon, 26 Jan 2026 14:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769439205; cv=none; b=b9cZQ+b4Tce460o0G4+8GYxxHi8Y9xxLU7efZWELTC9YZf9F/j2o1OIR7QshRnhv4rj+Oax1hYkKIPceVoZ4SDXpGqDB4vF1IS8dzv8JqABl6R4FKQIVnD0FmhdLiXmxKb5KeQM/1Mt3D2QG7XK4fUCXVRd6QQVlZv3PJJStJX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769439205; c=relaxed/simple;
	bh=nkB9M65CDG/yuLN0kyBdLpSFK8dVOGCW87Gw7mT/GFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXYOFcC89ouNvM4TXeJCasgxlHhjVobZxWAGbYo8VRVphoxoqFnYSTmxgbkTGt1BcZ3ukwjBsyQQF1zkKv4EnXA0/+CgEbyEqBSKZxvqRBqqoyWE3Q9KNEAwqRVFPfqLTFM2IqV3G04ihJnNXZDTOeoPl1UJhWr+aNSjYMrTppQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ITyoflNH; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ITyoflNH"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8c655e0ee70so583594685a.3
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jan 2026 06:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769439202; x=1770044002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rr6hP0mBuDVKlChZL94Kj3BwzKnBVlw3vwzih5h9Oic=;
        b=ITyoflNHyI8udcE0++6aMEGrooe2mzYBrlTxC2xmmaUYbJu9Iz6lf6q6vranoZMjRl
         fDUPnm2FKGq2oOp1LGclJ6jmFwbN4DpBp7kH/P7unfI0wYMwhq/W0IuIP6LsXtj0jNhV
         Bkt0e7NRaTRQr+SEIu4UC2vCg9xUohdk3bfk9J+XqrLiC0XX5OvZwDUjB8QTNTp6OObL
         Yc/8w30VYCMl42aQ2zw/FwhE/uRbtkIyyeCbPj7F8IM9z7YLd2XWo5gkhgHmNyn/m60r
         TK8LN82b2xpNKM2HUiaszc3ciD8tVcgJBinmldfq8N6olFf8Ao9zKB6rm/G03KE5bt3n
         rEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769439202; x=1770044002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rr6hP0mBuDVKlChZL94Kj3BwzKnBVlw3vwzih5h9Oic=;
        b=BwbUe7MFZSPOABRg1dcPalJfrWNJIW+cR95AU3aDWLw4fRCfUfQl/rPstleyBgWDfE
         t5ZVw8MdbR18JO4k2jczFLhzuxTXkmijIql7YvRUgtzSNDrdFA7mIwM/MQOmJ9LugwMr
         +KMCaR9GxJ0EiRhX8EyOmfNlNsOefJE1Tfig8FlV0vd6tp1TTl26Fc9hV/nnnUi/GxBM
         qg1aNgNrz6FVKDpYx2acRffS83rOJIB0/+NqlXE0zv8+5UfKG5nTIhQ6q5Q/WYAs+BaG
         6Nt4QVjf8tyLqJ4TuufW86f2wuAlhVjyreJvXoHIBuATETxbIYIaExf7kb7hWAF0fo/n
         jOzA==
X-Forwarded-Encrypted: i=1; AJvYcCUjsgtvXg3pezzBB50CgaUmdZAlUXNNpAv3IC08UGpwPGz7OA1zkUGgkL7dGM0s2UMVo8obkIHRXAm4@vger.kernel.org
X-Gm-Message-State: AOJu0YyLHthjj92jaT02T0F1ca2HKVR7W8zO19CGm/xMl+BwGF/tywPp
	g7TUgYkzUbdBU1WTDVvK9PdgoMg7MGrHxsN8XjArQaLEwfiE2gob4xaw
X-Gm-Gg: AZuq6aKOKRXch1iyzOM+hDzcdKcmi6i/g5wdvUm8gFIi1Fb9Q6uEQ15PqJqT/i1iuqV
	HbrgCQqHfUAC8Mm5pzJb8TAdqCKLZUK01Z8XMNQ5siojrkFTqhtCtYkU+C9wDy8BI43+MXRGE0F
	dZAAHXsjcYGbTxDLO1zXQtpoOWRTlhXZpHxdAlKsoR5SQm5C9zcqxmsXslM6Dg+OkJ1ieqDSb4x
	/LWgfvuCKD8uQw2CztzFqMBg0epCxWh4KjpKbHFsKQnG4D7bCbRtq/J9+adu7GOlaX05jl/RjJy
	5ttfUckXQ1NzeRigoxyZac0oBr/w0qhm8dYXRDq8huQMsvGH9iQT4q3YDgtg9QDMvRq96E0UCg/
	saL0VSAHMrPXG3Qn0iatbV0eSOiBY3YZIdVBHVUBXpOOBN+ifjEU5+4zzfMugZH3U0TTOJBpXNY
	YUP95UuI5faAl0WaBegMbKA5dSuc0ReSFVXPxlfzP8i/7nz3qDVxankuG0bGzVHw==
X-Received: by 2002:a05:620a:400b:b0:8c6:de6f:899c with SMTP id af79cd13be357-8c6f95e7137mr517144385a.2.1769439201727;
        Mon, 26 Jan 2026 06:53:21 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6e37d2422sm1018611585a.18.2026.01.26.06.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 06:53:21 -0800 (PST)
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
Subject: [PATCH net-next v8 15/15] quic: add packet parser base
Date: Mon, 26 Jan 2026 09:51:13 -0500
Message-ID: <46f93cbee41da1e1f7b7f408b17915fd93b39ec1.1769439073.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1769439073.git.lucien.xin@gmail.com>
References: <cover.1769439073.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch usess 'quic_packet' to handle packing of QUIC packets on the
receive (RX) path.

It introduces mechanisms to parse the ALPN from client Initial packets
to determine the correct listener socket. Received packets are then
routed and processed accordingly. Similar to the TX path, handling for
application and handshake packets is not yet implemented.

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
v5:
  - In quic_packet_rcv_err(), remove the unnecessary quic_is_listen()
    check and move quic_get_mtu_info() out of sock lock (suggested
    by Paolo).
  - Replace cancel_work_sync() to disable_work_sync() (suggested by
    Paolo).
v6:
  - Fix the loop using skb_dequeue() in quic_packet_backlog_work(), and
    kfree_skb() when sk is not found (reported by AI Reviews).
  - Remove skb_pull() from quic_packet_rcv(), since it is now handled
    in quic_path_rcv().
  - Note for AI reviews: add if (dst) check in quic_packet_rcv_err_pmtu(),
    although quic_packet_route() >= 0 already guarantees it is not NULL.
  - Note for AI reviews: it is safe to do *plen -= QUIC_HLEN in
    quic_packet_get_version_and_connid(), since quic_packet_get_sock()
    already checks if (skb->len < QUIC_HLEN).
  - Note for AI reviews: cb->length - cb->number_len - QUIC_TAG_LEN
    cannot underflow, because quic_crypto_header_decrypt() already checks
    if (cb->length < QUIC_PN_MAX_LEN + QUIC_SAMPLE_LEN).
  - Note for AI reviews: the cast (u16)length in quic_packet_parse_alpn()
    is safe, as there is a prior check if (length > (u16)len); len is
    skb->len, which cannot exceed U16_MAX.
  - Note for AI reviews: it's correct to do if (flags &
    QUIC_F_MTU_REDUCED_DEFERRED) in quic_release_cb(), since
    QUIC_MTU_REDUCED_DEFERRED is the bit used with test_and_set_bit().
  - Note for AI reviews: move skb_cb->backlog = 1 before adding skb to
    backlog, although it's safe to write skb_cb after adding to backlog
    with sk_lock.slock, as skb dequeue from backlog requires sk_lock.slock.
v7:
  - Pass udp sk to quic_packet_rcv(), quic_packet_rcv_err() and
    quic_sock_lookup().
  - Move the call to skb_linearize() and skb_set_owner_sk_safe() to
    .quic_path_rcv()/quic_packet_rcv().
v8:
  - Replace the global ALPN demultiplexing sysctl with the static key in
    quic_packet_parse_alpn() (noted by Stefan).
  - Refetch skb->data after decrypt in ALPN parsing, as skb_cow_data()
    may reallocate the skb data buffer (reported by Syzkaller).
  - The indirect quic_path_rcv has been removed and call quic_packet_rcv()
    directly via extern.
  - Do not restore skb data when QUIC Initial decryption fails, as the
    caller will free the skb for this failure anyway.
  - With patch 14 removed, define a temporary QUIC_FRAME_CRYPTO ID when
    parsing the ALPN.
---
 net/quic/packet.c   | 636 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/packet.h   |   9 +
 net/quic/path.c     |   6 +-
 net/quic/protocol.c |   5 +
 net/quic/protocol.h |   4 +
 net/quic/socket.c   | 134 ++++++++++
 net/quic/socket.h   |   5 +
 7 files changed, 797 insertions(+), 2 deletions(-)

diff --git a/net/quic/packet.c b/net/quic/packet.c
index da121653a937..f823b55534a8 100644
--- a/net/quic/packet.c
+++ b/net/quic/packet.c
@@ -14,6 +14,642 @@
 
 #define QUIC_HLEN		1
 
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
+		if (dst)
+			dst->ops->update_pmtu(dst, sk, NULL, info, true);
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
+static int quic_packet_rcv_err(struct sock *sk, struct sk_buff *skb)
+{
+	union quic_addr daddr, saddr;
+	u32 info;
+
+	/* All we can do is lookup the matching QUIC socket by addresses. */
+	quic_get_msg_addrs(skb, &saddr, &daddr);
+	sk = quic_sock_lookup(skb, &daddr, &saddr, sk, NULL);
+	if (!sk)
+		return -ENOENT;
+
+	if (quic_get_mtu_info(skb, &info)) {
+		sock_put(sk);
+		return 0;
+	}
+
+	/* Success: update socket path MTU info. */
+	bh_lock_sock(sk);
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
+	return 1;
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
+#define QUIC_FRAME_CRYPTO	0x06
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
+	struct quic_conn_id dcid, scid;
+	u32 len = skb->len, version;
+	struct quic_crypto *crypto;
+	u8 *p = skb->data, type;
+	struct quic_data token;
+	u64 offset, length;
+	int err = -EINVAL;
+
+	if (!static_branch_unlikely(&quic_alpn_demux_key))
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
+	if (!cb->backlog) { /* skb_get() needed as caller will free skb on this path. */
+		quic_packet_backlog_schedule(net, skb_get(skb));
+		return -EINPROGRESS;
+	}
+	cb->length = (u16)length;
+
+	/* Install initial keys for packet decryption to crypto. */
+	crypto = &quic_net(net)->crypto;
+	err = quic_crypto_initial_keys_install(crypto, &dcid, version, 1);
+	if (err)
+		return err;
+	cb->number_offset = (u16)(p - skb->data);
+	err = quic_crypto_decrypt(crypto, skb);
+	if (err) {
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_DECDROP);
+		return err;
+	}
+
+	QUIC_INC_STATS(net, QUIC_MIB_PKT_DECFASTPATHS);
+	cb->resume = 1; /* Mark this packet as already decrypted. */
+
+	/* Find the QUIC CRYPTO frame. */
+	p = skb->data + cb->number_offset + cb->number_len;
+	len = cb->length - cb->number_len - QUIC_TAG_LEN;
+	for (; len && !(*p); p++, len--) /* Skip the padding frame. */
+		;
+	if (!len-- || *p++ != QUIC_FRAME_CRYPTO)
+		return 0;
+	if (!quic_get_var(&p, &len, &offset) || offset)
+		return 0;
+	if (!quic_get_var(&p, &len, &length) || length > (u64)len)
+		return 0;
+
+	/* Parse the TLS CLIENT_HELLO message. */
+	return quic_packet_get_alpn(alpn, p, length);
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
+		return quic_sock_lookup(skb, &daddr, &saddr, skb->sk, NULL);
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
+	sk = quic_sock_lookup(skb, &daddr, &saddr, skb->sk, &dcid);
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
+int quic_packet_rcv(struct sock *sk, struct sk_buff *skb, u8 err)
+{
+	struct net *net = sock_net(sk);
+
+	if (unlikely(err))
+		return quic_packet_rcv_err(sk, skb);
+
+	/* Save the UDP socket to skb->sk for later QUIC socket lookup. */
+	if (skb_linearize(skb) || !skb_set_owner_sk_safe(skb, sk)) {
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVDROP);
+		goto err;
+	}
+
+	/* Look up socket from socket or connection IDs hash tables. */
+	sk = quic_packet_get_sock(skb);
+	if (!sk)
+		goto err;
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		/* Socket is busy (owned by user context): queue to backlog. */
+		QUIC_SKB_CB(skb)->backlog = 1;
+		if (sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf))) {
+			QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVDROP);
+			bh_unlock_sock(sk);
+			sock_put(sk);
+			goto err;
+		}
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
+	struct sk_buff_head *head = &qn->backlog_list;
+	struct sk_buff *skb;
+	struct sock *sk;
+
+	while ((skb = skb_dequeue(head)) != NULL) {
+		sk = quic_packet_get_listen_sock(skb);
+		if (!sk) {
+			kfree_skb(skb);
+			continue;
+		}
+
+		lock_sock(sk);
+		quic_packet_process(sk, skb);
+		release_sock(sk);
+		sock_put(sk);
+	}
+}
+
 /* Make these fixed for easy coding. */
 #define QUIC_PACKET_NUMBER_LEN	QUIC_PN_MAX_LEN
 #define QUIC_PACKET_LENGTH_LEN	4
diff --git a/net/quic/packet.h b/net/quic/packet.h
index ad1279cdb645..e909fa3ff009 100644
--- a/net/quic/packet.h
+++ b/net/quic/packet.h
@@ -96,6 +96,7 @@ static inline void quic_packet_reset(struct quic_packet *packet)
 	packet->ack_immediate = 0;
 }
 
+int quic_packet_process(struct sock *sk, struct sk_buff *skb);
 int quic_packet_config(struct sock *sk, u8 level, u8 path);
 
 int quic_packet_xmit(struct sock *sk, struct sk_buff *skb);
@@ -105,3 +106,11 @@ int quic_packet_route(struct sock *sk);
 void quic_packet_mss_update(struct sock *sk, u32 mss);
 void quic_packet_flush(struct sock *sk);
 void quic_packet_init(struct sock *sk);
+
+int quic_packet_get_dcid(struct quic_conn_id *dcid, struct sk_buff *skb);
+int quic_packet_select_version(struct sock *sk, u32 *versions, u8 count);
+u32 *quic_packet_compatible_versions(u32 version);
+
+int quic_packet_rcv(struct sock *sk, struct sk_buff *skb, u8 err);
+void quic_packet_backlog_work(struct work_struct *work);
+void quic_packet_rcv_err_pmtu(struct sock *sk);
diff --git a/net/quic/path.c b/net/quic/path.c
index 9556607a009e..19f9af068341 100644
--- a/net/quic/path.c
+++ b/net/quic/path.c
@@ -17,6 +17,8 @@
 #include "family.h"
 #include "path.h"
 
+extern int quic_packet_rcv(struct sock *sk, struct sk_buff *skb, u8 err);
+
 static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	memset(skb->cb, 0, sizeof(skb->cb));
@@ -25,13 +27,13 @@ static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
 
 	skb_pull(skb, sizeof(struct udphdr));
 	skb_dst_force(skb);
-	kfree_skb(skb);
+	quic_packet_rcv(sk, skb, 0);
 	return 0; /* .encap_rcv must return 0 if skb was either consumed or dropped. */
 }
 
 static int quic_udp_err(struct sock *sk, struct sk_buff *skb)
 {
-	return 0;
+	return quic_packet_rcv(sk, skb, 1);
 }
 
 static void quic_udp_sock_put_work(struct work_struct *work)
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index 4823f22f8c87..c7a705966323 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -265,6 +265,9 @@ static int __net_init quic_net_init(struct net *net)
 		return err;
 	}
 
+	INIT_WORK(&qn->work, quic_packet_backlog_work);
+	skb_queue_head_init(&qn->backlog_list);
+
 #if IS_ENABLED(CONFIG_PROC_FS)
 	err = quic_net_proc_init(net);
 	if (err) {
@@ -283,6 +286,8 @@ static void __net_exit quic_net_exit(struct net *net)
 #if IS_ENABLED(CONFIG_PROC_FS)
 	quic_net_proc_exit(net);
 #endif
+	skb_queue_purge(&qn->backlog_list);
+	disable_work_sync(&qn->work);
 	quic_crypto_free(&qn->crypto);
 	free_percpu(qn->stat);
 	qn->stat = NULL;
diff --git a/net/quic/protocol.h b/net/quic/protocol.h
index 850f43806688..6793255604c6 100644
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
index f73d25cd16e9..8232e677d96b 100644
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
+			      struct sock *usk, struct quic_conn_id *dcid)
+{
+	struct net *net = sock_net(usk);
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
+		    quic_path_usock(paths, 0) == usk &&
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
@@ -208,6 +336,10 @@ static void quic_release_cb(struct sock *sk)
 		nflags = flags & ~QUIC_DEFERRED_ALL;
 	} while (!try_cmpxchg(&sk->sk_tsq_flags, &flags, nflags));
 
+	if (flags & QUIC_F_MTU_REDUCED_DEFERRED) {
+		quic_packet_rcv_err_pmtu(sk);
+		__sock_put(sk);
+	}
 	if (flags & QUIC_F_LOSS_DEFERRED) {
 		quic_timer_loss_handler(sk);
 		__sock_put(sk);
@@ -257,6 +389,7 @@ struct proto quic_prot = {
 	.accept		=  quic_accept,
 	.hash		=  quic_hash,
 	.unhash		=  quic_unhash,
+	.backlog_rcv	=  quic_packet_process,
 	.release_cb	=  quic_release_cb,
 	.no_autobind	=  true,
 	.obj_size	=  sizeof(struct quic_sock),
@@ -287,6 +420,7 @@ struct proto quicv6_prot = {
 	.accept		=  quic_accept,
 	.hash		=  quic_hash,
 	.unhash		=  quic_unhash,
+	.backlog_rcv	=  quic_packet_process,
 	.release_cb	=  quic_release_cb,
 	.no_autobind	=  true,
 	.obj_size	= sizeof(struct quic6_sock),
diff --git a/net/quic/socket.h b/net/quic/socket.h
index c4a9980ea5f8..ba230a0af750 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -206,3 +206,8 @@ static inline void quic_set_state(struct sock *sk, int state)
 	inet_sk_set_state(sk, state);
 	sk->sk_state_change(sk);
 }
+
+struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa, union quic_addr *da,
+				     struct quic_data *alpns);
+struct sock *quic_sock_lookup(struct sk_buff *skb, union quic_addr *sa, union quic_addr *da,
+			      struct sock *usk, struct quic_conn_id *dcid);
-- 
2.47.1

