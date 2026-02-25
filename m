Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1402296BD1
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 02:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771986960; cv=none; b=NvFmzhMFA6b3ulPUMsx2+kmSe2kBjPwUUHTNtCF8v5a9iU38lWA5R8yKNfeDKd+nexTG2+Qg/usJq9djYWoXiIhmXyWCRvBvpkofDpAtcWOsWNaWsA+/zr/bH3vtCOtmP39rhSgwwyboPyggl8kMZUa00bl1qiBE2bxWy8DpJFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771986960; c=relaxed/simple;
	bh=QElLQRpIUnAep0n7/4TfJ650i2ko4+f/7YctuqkZAxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkh2sYeDnq1eiYEum9VUtPiNfNgVPdjC7VepNQCiAGMFaNBDCpBHjuSQ2IQd0crqG+mee7lqoyWZu7dP5Dzic9CVRwq81aV8QMaUdxJUFNDGeLEATwXvB3aXCUnBryrlG/UaLwyCXivVrKoY+L5cNuh7NcWwsqjdy4DsZhmKpvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hwSNB8dn; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwSNB8dn"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-899b676b5d2so5179376d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 24 Feb 2026 18:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771986956; x=1772591756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FpZ/2725cRjqKypDQChxQ7vBxxCxsJGEBKt/3z4F5A=;
        b=hwSNB8dnE3ik+BJF6URhpF5Za38npHmGvqVxagG+2rnBiipij523P2N79nlKYUlZ10
         d05B4t4Y4gl2VDU+q5J1YrpF+oa/sInhQ8YJWgLnq1t4rAgmg9eFIWiO9yKF1JHV2l9d
         AWoOVBSwMrZNJ/ZM4+Y9cVsGIGxefqCs0SYNlpHmU/G9VE66OTtJyn7LZMi0S4hkwj67
         kHbCmN2qLRy6q+Dagg5iXO9HE36qN7WtdCy1uflGFBAE6UZ+9+DgT4z3+rs0vXaxjFvM
         C9gN57OXuxmPYiu9/PVqcCo7aLvy+a/OeVw7h6IYZ7fziAn/S/3onDGQLajEjuVxlNuL
         9ssA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771986956; x=1772591756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9FpZ/2725cRjqKypDQChxQ7vBxxCxsJGEBKt/3z4F5A=;
        b=B+RVY0h3CR6Ryo8wUEfjg+fZ4vwPHXL9q6mGV++xLEQqTky6EKrHJnM2OtTXVzPpkb
         b7C1KaeHnL9P6wtLTINJRI7ARbZMqEehW+6Jq7y5mWy6KO7fzvzgmvAJJIc1qfooYiKo
         L6/CG3ezRTGHatIA7G9oueqxYwFS7Wh8hgDZXRawTIOeK3//zf0amjSsRcIqXX5K+Lnd
         3xbQzU7HFCPWDXqRwpipUvgzuFaurzfBDm0TCHbi39041s7K/yYMj+oSEvhxb1MIORG4
         5bWxZ2PSjT/xsMzIjVXJyBxuGeJiaRw+VtT4+vidCGA6X9lINHRwYoEOzm83uKyV5vV5
         1F7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVFF7kcrjMi8sfJf/J2E8kiPpig+53knBnQJ/vj6De8ePSJysJ4W86n7B1WmCcpdJPVBL47pf2Sjk0f@vger.kernel.org
X-Gm-Message-State: AOJu0YxqiG6jhIFV0T1KY3phGJCl+z1zp7laX0aIjV0Es5LPyq7+viBb
	LfygBMVgJuojYo99PDCbHI9uDHC/39HHcTWzm0DKNRbgZ+sTwean9Nae
X-Gm-Gg: ATEYQzzKQVAcB8W0yAE501KRbhtW/nJDkq1YV2Jp+2tvaUlNTZ56Tzbz0ktap0S1CV4
	l85ZoHwz78yzHKuRskKJkTc6uKVgJmS39Qb9IiW2bg8/kXW2YMj0cdtwaoW6n33lVFNag4MlDoc
	eygFWl5HPJhi4oHukcsQ/p41wKTOd5/AlDnaNlR5J7uFgUHh9e+jqxD+lg7KGlr/Wx9iASoKv3B
	yVofsInCZ+9xVg8VvyvfTkYCBJCiIMXx0BBTzwehjpDPeEq3IOFuh50ifrFZ7JCp8bMSYBV/kIM
	WfM9oGqOij7DI5nNgyDU7ohRlXIpQjyxrE8oVdejweH0ooG05Vm/QePlLQdtKGDa4/dX709fGqU
	n5GAkwd2wHYTF6k14URL2a6LCyOph+3pWDkg1DslA6ZBtOFQmd9UL5kSk9qelCCCJeRinr9HWQZ
	S9p/mKDxiILdviAMJV3CTyjDtbVqH46yxrjhsghOc+lxk+gdEx5OkqZe0hisZeBCMRkdeHKzc6a
	cfe1SlMimA0Hj2qmvgVxSx6UelBXoAJxMxBxuXWPzZbJEfwtD6WSrZsWm4AfDRaXA==
X-Received: by 2002:a05:6214:629:b0:892:70a5:3bfc with SMTP id 6a1803df08f44-899b8c856f2mr10193086d6.63.1771986955327;
        Tue, 24 Feb 2026 18:35:55 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8997e62f453sm112363586d6.36.2026.02.24.18.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 18:35:54 -0800 (PST)
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
Subject: [PATCH net-next v10 15/15] quic: add packet parser base
Date: Tue, 24 Feb 2026 21:34:21 -0500
Message-ID: <08a63705058aff77dd54fb388870f0bca6036c95.1771986861.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1771986861.git.lucien.xin@gmail.com>
References: <cover.1771986861.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch uses 'quic_packet' to handle packing of QUIC packets on the
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
v9:
  - Remove local_bh_disable() in quic_packet_get_listen_sock() as it's now
    using rcu_read_lock instead of spin_sock in quic_listen_sock_lookup()
    (noted by Paolo).
v10:
  - Return QUIC_PACKET_INVALID (instead of -1) for invalid packet types in
    quic_packet_version_get_type().
  - Update the comment to clarify in quic_packet_rcv_err() that ICMP errors
    embed the original QUIC packet, reversing src/dst addrs when parsed.
  - Use qn->backlog_list.lock in quic_packet_backlog_schedule() to prevent
    TOCTOU.
  - Add check 'len < TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN' before parsing
    ClientHello in quic_packet_get_alpn().
  - Add more limits in quic_packet_get_alpn() to improve robustness against
    malformed TLS ClientHello messages.
  - Move skb_queue_purge() to after disable_work_sync() in quic_net_exit()
    for clarity and to satisfy AI review.
  - quic_sock.config.plpmtud_probe_interval has been moved to
    quic_path_group.plpmtud_interval, so update its usage in
    quic_packet_rcv_err_pmtu() accordingly.
  - Remove quic_packet_select_version() and quic_packet_version_change();
    they will be reintroduced later when needed in the next patch series.
---
 net/quic/packet.c   | 577 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/packet.h   |  10 +
 net/quic/path.c     |   6 +-
 net/quic/protocol.c |   5 +
 net/quic/protocol.h |   4 +
 net/quic/socket.c   | 134 ++++++++++
 net/quic/socket.h   |   5 +
 7 files changed, 739 insertions(+), 2 deletions(-)

diff --git a/net/quic/packet.c b/net/quic/packet.c
index a56edc745bb1..a23ce99a6656 100644
--- a/net/quic/packet.c
+++ b/net/quic/packet.c
@@ -14,6 +14,583 @@
 
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
+		return QUIC_PACKET_INVALID;
+	}
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
+	u32 pathmtu, info, taglen;
+	struct dst_entry *dst;
+	bool reset_timer;
+
+	if (!ip_sk_accept_pmtu(sk))
+		return;
+
+	info = clamp(paths->mtu_info, QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);
+	/* If PLPMTUD is not enabled, update MSS using the route and ICMP info. */
+	if (!paths->plpmtud_interval) {
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
+		quic_timer_reset(sk, QUIC_TIMER_PMTU, paths->plpmtud_interval);
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
+	/* ICMP embeds the original outgoing QUIC packet, so saddr/daddr are reversed when
+	 * parsed. Only address-based socket lookup is possible in this case.
+	 */
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
+	struct sk_buff_head *head;
+
+	if (cb->backlog)
+		return 0;
+
+	head = &qn->backlog_list;
+	spin_lock(&head->lock);
+	if (head->qlen >= QUIC_PACKET_BACKLOG_MAX) {
+		spin_unlock(&head->lock);
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVDROP);
+		kfree_skb(skb);
+		return -1;
+	}
+	cb->backlog = 1;
+	__skb_queue_tail(head, skb);
+	spin_unlock(&head->lock);
+
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
+#define TLS_MAX_EXTENSIONS	128
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
+	int err = -EINVAL, found = 0, exts = 0;
+	u64 length, type;
+
+	/* Verify handshake message type (ClientHello) and its length. */
+	if (!quic_get_int(&p, &len, &type, 1) || type != TLS_MT_CLIENT_HELLO)
+		return err;
+	if (!quic_get_int(&p, &len, &length, 3) ||
+	    len < TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN ||
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
+			if (length > QUIC_ALPN_MAX_LEN)
+				return err;
+			len = length;
+			found = 1;
+			break;
+		}
+		/* Skip non-ALPN extensions. */
+		p += length;
+		len -= length;
+		if (exts++ >= TLS_MAX_EXTENSIONS)
+			return err;
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
+
+	quic_get_msg_addrs(skb, &daddr, &saddr);
+
+	if (quic_packet_parse_alpn(skb, &alpns))
+		return NULL;
+
+	return quic_listen_sock_lookup(skb, &daddr, &saddr, &alpns);
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
index 8c23be386207..b925e9ab148d 100644
--- a/net/quic/packet.h
+++ b/net/quic/packet.h
@@ -57,6 +57,8 @@ struct quic_packet {
 
 #define QUIC_VERSION_LEN		4
 
+#define QUIC_ALPN_MAX_LEN		128
+
 static inline u8 quic_packet_taglen(struct quic_packet *packet)
 {
 	return packet->taglen[!!packet->level];
@@ -98,6 +100,7 @@ static inline void quic_packet_reset(struct quic_packet *packet)
 	packet->ack_immediate = 0;
 }
 
+int quic_packet_process(struct sock *sk, struct sk_buff *skb);
 int quic_packet_config(struct sock *sk, u8 level, u8 path);
 
 int quic_packet_xmit(struct sock *sk, struct sk_buff *skb);
@@ -107,3 +110,10 @@ int quic_packet_route(struct sock *sk);
 void quic_packet_mss_update(struct sock *sk, u32 mss);
 void quic_packet_flush(struct sock *sk);
 void quic_packet_init(struct sock *sk);
+
+int quic_packet_get_dcid(struct quic_conn_id *dcid, struct sk_buff *skb);
+u32 *quic_packet_compatible_versions(u32 version);
+
+int quic_packet_rcv(struct sock *sk, struct sk_buff *skb, u8 err);
+void quic_packet_backlog_work(struct work_struct *work);
+void quic_packet_rcv_err_pmtu(struct sock *sk);
diff --git a/net/quic/path.c b/net/quic/path.c
index 9414c4f813c5..655f38af4107 100644
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
index 11a122d84ccb..f1a754556d8d 100644
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
+	disable_work_sync(&qn->work);
+	skb_queue_purge(&qn->backlog_list);
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
index 4607f3ae8a7b..006c5b2747fe 100644
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
@@ -205,6 +333,10 @@ static void quic_release_cb(struct sock *sk)
 		nflags = flags & ~QUIC_DEFERRED_ALL;
 	} while (!try_cmpxchg(&sk->sk_tsq_flags, &flags, nflags));
 
+	if (flags & QUIC_F_MTU_REDUCED_DEFERRED) {
+		quic_packet_rcv_err_pmtu(sk);
+		__sock_put(sk);
+	}
 	if (flags & QUIC_F_LOSS_DEFERRED) {
 		quic_timer_loss_handler(sk);
 		__sock_put(sk);
@@ -254,6 +386,7 @@ struct proto quic_prot = {
 	.accept		=  quic_accept,
 	.hash		=  quic_hash,
 	.unhash		=  quic_unhash,
+	.backlog_rcv	=  quic_packet_process,
 	.release_cb	=  quic_release_cb,
 	.no_autobind	=  true,
 	.obj_size	=  sizeof(struct quic_sock),
@@ -284,6 +417,7 @@ struct proto quicv6_prot = {
 	.accept		=  quic_accept,
 	.hash		=  quic_hash,
 	.unhash		=  quic_unhash,
+	.backlog_rcv	=  quic_packet_process,
 	.release_cb	=  quic_release_cb,
 	.no_autobind	=  true,
 	.obj_size	= sizeof(struct quic6_sock),
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 1efc76ec2033..34dbdfd2dedc 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -200,3 +200,8 @@ static inline void quic_set_state(struct sock *sk, int state)
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

