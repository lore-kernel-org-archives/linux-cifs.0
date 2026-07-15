Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BF74CA297
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 20:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784147549; cv=none; b=Nu1TBNciHMjihZ58Ofm1gJSeRPTX3+J+EtFbvZx+1PowfYfJP/aJFAaWvmD4DP4TjZ4GWkOq5zyXsMt6QHtoWJwVg5cdejoPJ79qRVc9+yUT2TIfXqCf1wEkzPmoSqcQ66sjiUZJjsphIgXrPHDLEDPS/4qYHjrxQfu+xcFkCqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784147549; c=relaxed/simple;
	bh=a3OsmXWj6dhxqvbauwLvaj19ucaAWAr2LdW2CN8aqWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjDWVzUiuqVQ8fnN3Bp/NmwWuYdopff9AojHqdqXf5asaVF5OE61kAfoOxBvU6cghH5UqWHV8SMRCKrPblTFbYfEq6B/DWEkRdjXSf+Of8xUGxPUzugIcGE6Vse/IqZeq1eLex5iuE/3h/sLswckHuB5Ut8q+lcoyJeFvXJLQ4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M1UXqpCV; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M1UXqpCV"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51a868b6962so58268231cf.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 13:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784147545; x=1784752345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+b0lX+dUWhSUUZwUtmrCK9+5tajItFwSKFuA4KP0WDw=;
        b=M1UXqpCVEaMOwfEzaFB0d12wDlrFT64dAzh30XPH1DgJqMIGkJe1nMn/y98iy8PAO3
         o6PPzrlb3sLim6C56m8Vp67VyWzSb5LsvEKvZZqvNvDaZvShhThmi36BZVHtcxNdQx7h
         PdepPiJtNubi3mohVxiKdIkkJ/ro5XKIPwzN397iE0G6sXlAP5PkPGQWTsOxbYwo2k+0
         ilOPkF3jXOYi2WCn+hZoXdZTmRD3jY0/TVbB4g7DC6Br6uurMdyHZf0jt9NkSFMQndSD
         Bl0R59QhjtoBdm0eyEPtcME0cxWEuy3PguQxiU0f7B3PpL1yx/oJM05aMGk6wxafsUH9
         PFeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784147545; x=1784752345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+b0lX+dUWhSUUZwUtmrCK9+5tajItFwSKFuA4KP0WDw=;
        b=h7M4RhiNipSA3SPeu1MInq1HFyEr5xa+M/2Gcac4QyZlSzH/X+cn1m5zbzozwj8j+A
         vzI2ZmdII565Rkw3O8p2JD0tmDQKd+znIuZD5y+7Ctt6MoGRhCCizbFxmnffob2Ph597
         0ETI9Mu2DoHF9bm4/0VglIOnxICHokhiBsTyS6TZPAcU+SqB5bgv8IB861UOPEFyo0P+
         vqYD98IjWga/KXKLMDRGWHh4Z8aRDJ9aCI8qm120B/VKwru8tY6TNg5WfZzShaS8Xo3C
         FS4HAVIWFI0QlUY+RMB2zrTXxLKGr58+wIjeYzQ/oiT1l2u65g2sgoQe0k5h0QX8UESL
         5KCQ==
X-Forwarded-Encrypted: i=1; AHgh+RqEKGPmzLEfy/ceAF1pCvRVIF8dGwfmh3/cLH4v+kZRRAzlVWmPj2NWmskath0m3Ij4+0ZahZee+Y1p@vger.kernel.org
X-Gm-Message-State: AOJu0YyZFiQjcq6Z8lybIhTM5aSGfjUcjDuzTwRdHVLVrurODARE/iR7
	nBk/yuShq1bVyxQnsxnxvQFDVxk8wMm7CE5Rezw0BOBawb2gvx3NEg02
X-Gm-Gg: AfdE7clNs2TwEysKwiN6cpSoq/0ZYHLPP++kayWKZUR7YJz0H1gV0t2VswPmFscHLf5
	0r8dVyv/a+eZxUA5T0dgs2qJmKjLk/fQ82KW+5G1UFZChSuET3WaOSwM0cU9YIOSGPRmZfwi1wB
	KemZkAlzUp387IsvUgjz+/0k0dnYNza3uAAxpYAHAYktNZw7iEm6Ml9sN1j2iIhdhjj8oGR8Ach
	iy/oI/CHisfG+A4XSabtq5zmmuioE6pd3zsWBoHz5f7AqxlBbWoPsi69dFPKvFL31qtIDcxPmvE
	ehbX7UiIbezgWMykqRCpnXlSd/+5WVYTEogTDWBiPGvN0LABPwUOABAM6cLc/4Z0JwofSMnUaBC
	j2eK1CqpOanBWwB/COGtsfY4ukKyH+SJkqyOHyo9XO5sqoCVm1eH12NvSz8jOsXkYbCIXeGjvJ5
	YjP+DByRTMG4YxA01XMGmfy5NJDX63auDqoXtZHCpfRu+j2gB3FHpzmqFKMkC5MqX+vtA9So8wt
	PSyB1Xitx3925AasfClPxmXc2RNDlFUxLoyzMZ0z1Oqh90qq42p0To=
X-Received: by 2002:ac8:5cd4:0:b0:51c:7b11:41a8 with SMTP id d75a77b69052e-51e4f22ecbcmr47800111cf.85.1784147544470;
        Wed, 15 Jul 2026 13:32:24 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd248e666sm201326506d6.0.2026.07.15.13.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 13:32:23 -0700 (PDT)
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
Subject: [PATCH net-next v14 15/15] quic: add packet parser base
Date: Wed, 15 Jul 2026 16:27:18 -0400
Message-ID: <ad7907c5a92819feb17dcc53ff9d07944f5c4d0e.1784147238.git.lucien.xin@gmail.com>
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
  - Note for AI reviews: the cast length in quic_packet_parse_alpn()
    is safe, as there is a prior check if (length > (u16)len); len is
    skb->len, which cannot exceed U16_MAX for UDP packet with QUIC.
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
  - Use qn->backlog_list.lock in quic_packet_backlog_schedule() to
    prevent a TOCTOU race between the head->qlen check and its update in
    __skb_queue_tail().
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
v11:
  - Note for AI review: refcount increments in quic_listen_sock_lookup()
    and quic_sock_lookup() are left unchanged due to code complexity.
  - Set maximum line length to 80 characters.
  - Do not mark backlog packets as sleepable (cb->backlog = 1) in
    sk_add_backlog path; Replace spin_(un)lock() with spin_(un)lock_bh()
    in quic_packet_backlog_schedule().
  - Return -ENOBUFS instead of -1 in quic_packet_backlog_schedule().
  - Change err parameter type from u8 to bool (icmp) in quic_packet_rcv().
  - Propagate errors from quic_packet_get_sock() and sk_add_backlog() in
    quic_packet_rcv().
  - Propagate errors from quic_packet_get_dcid() and
    quic_packet_parse_alpn() in quic_packet_get_sock() via ERR_PTR().
  - Propagate errors from quic_packet_parse_alpn() in
    quic_packet_get_listen_sock() via ERR_PTR().
  - Propagate errors from quic_packet_get_version_and_connid() and
    quic_packet_get_token() in quic_packet_parse_alpn().
  - Do not hold skb when calling quic_packet_backlog_schedule() in
    quic_packet_parse_alpn(); do not free skb when returning
    -EINPROGRESS from quic_packet_get_sock() in quic_packet_rcv().
  - Move the quic_packet_rcv() declaration from packet.h to path.h,
    as it's only called in path.c (noted by AI review).
  - Merge quic_packet_get_dcid() and quic_packet_get_version_and_connid()
    into quic_packet_get_long_header() and extract quic_packet_get_connid()
    (noted by AI review).
v12:
  - Check quic_is_closed() in quic_packet_rcv_err_pmtu().
  - Remove the ip_sk_accept_pmtu() check from quic_packet_rcv_err_pmtu(),
    and check quic_sk_accept_pmtu() in quic_packet_rcv_err().
  - Call cond_resched() in the loop inside quic_packet_backlog_work().
  - Update the comment for the get_nulls_value(node) check in
    quic_sock_lookup(), and remove the unnecessary get_nulls_value(node)
    check and add comment for it in quic_listen_sock_lookup().
  - Improve matching order: specific address > ANY address (same family) >
    ANY address (different family) in quic_listen_sock_lookup().
  - Defer quic_alpn destruction from quic_destroy_sock() to
    quic_sock_destruct(), as it may still be accessed in
    quic_listen_sock_lookup() under rcu_read_lock().
  - Initialize dcid/scid variables at declaration in quic_packet_get_sock()
    and quic_packet_parse_alpn().
  - Set packet->level before calling quic_packet_taglen() in
    quic_packet_rcv_err_pmtu().
  - Set cb->sync to 1 to ensure decryption runs in sync mode.
v13:
  - Add comment explaining why ALPN free is deferred in
    quic_sock_destruct().
  - Improve loop boundary check while parsing ALPN extensions in
    quic_packet_get_alpn().
v14:
  - Pass gfp flags to quic_packet_process(), quic_packet_app_process(),
    quic_packet_handshake_process(), and quic_packet_listen_process()
    for allocations in subsequent patches.
  - Define quic_backlog_rcv() as .backlog_rcv() and pass GFP_ATOMIC to
    quic_packet_process().
  - Pass GFP_KERNEL to quic_packet_process() in
    quic_packet_backlog_work().
  - Move the exts++ check to the beginning of the while loop in
    quic_packet_get_alpn() (noted by Sashiko AI review).
---
 net/quic/packet.c   | 611 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/packet.h   |   8 +
 net/quic/path.c     |   4 +-
 net/quic/path.h     |   2 +
 net/quic/protocol.c |   5 +
 net/quic/protocol.h |   4 +
 net/quic/socket.c   | 163 +++++++++++-
 net/quic/socket.h   |   7 +
 8 files changed, 801 insertions(+), 3 deletions(-)

diff --git a/net/quic/packet.c b/net/quic/packet.c
index f83b2c54a45a..57808cc5d95d 100644
--- a/net/quic/packet.c
+++ b/net/quic/packet.c
@@ -14,6 +14,617 @@
 
 #define QUIC_HLEN		1
 
+#define QUIC_LONG_HLEN(dcid, scid) \
+	(QUIC_HLEN + QUIC_VERSION_LEN + 1 + (dcid)->len + 1 + (scid)->len)
+
+#define QUIC_VERSION_NUM	2
+
+/* Supported QUIC versions and their compatible versions. Used for Compatible
+ * Version Negotiation in rfc9368#section-2.3.
+ */
+static u32 quic_versions[QUIC_VERSION_NUM][4] = {
+	/* Version,	Compatible Versions */
+	{ QUIC_VERSION_V1, QUIC_VERSION_V2, QUIC_VERSION_V1, 0 },
+	{ QUIC_VERSION_V2, QUIC_VERSION_V2, QUIC_VERSION_V1, 0 },
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
+/* Extracts a QUIC Connection ID from a buffer in the long header packet. */
+static int quic_packet_get_connid(struct quic_conn_id *connid, u8 **pp,
+				  u32 *plen)
+{
+	u64 len;
+
+	if (!quic_get_int(pp, plen, &len, 1) ||
+	    len > *plen || len > QUIC_CONN_ID_MAX_LEN)
+		return -EINVAL;
+
+	quic_conn_id_update(connid, *pp, len);
+	*plen -= len;
+	*pp += len;
+	return 0;
+}
+
+/* Parse QUIC version and connection IDs (DCID and SCID) from a Long header
+ * packet buffer.
+ */
+static int quic_packet_get_long_header(struct quic_conn_id *dcid,
+				       struct quic_conn_id *scid, u32 *version,
+				       u8 **pp, u32 *plen)
+{
+	int err;
+	u64 v;
+
+	*pp += QUIC_HLEN;
+	*plen -= QUIC_HLEN;
+
+	if (!quic_get_int(pp, plen, &v, QUIC_VERSION_LEN))
+		return -EINVAL;
+	if (version)
+		*version = v;
+
+	err = quic_packet_get_connid(dcid, pp, plen);
+	if (err)
+		return err;
+	if (!scid)
+		return 0;
+	return quic_packet_get_connid(scid, pp, plen);
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
+	if (quic_is_closed(sk))
+		return;
+
+	info = clamp(paths->mtu_info, QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);
+	/* If PLPMTUD is not enabled, update MSS using route and ICMP info. */
+	if (!paths->plpmtud_interval) {
+		if (quic_packet_route(sk))
+			return;
+
+		dst = __sk_dst_get(sk);
+		if (dst)
+			dst->ops->update_pmtu(dst, sk, NULL, info, true);
+		quic_packet_mss_update(sk, info - packet->hlen);
+		return;
+	}
+	/* PLPMTUD is enabled: adjust to smaller PMTU, subtract headers and
+	 * AEAD tag.  Also notify the QUIC path layer for possible state
+	 * changes and probing.
+	 */
+	packet->level = QUIC_CRYPTO_APP;
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
+	/* ICMP embeds the original outgoing QUIC packet, so saddr/daddr are
+	 * reversed when parsed. Only address-based socket lookup is possible
+	 * in this case.
+	 */
+	quic_get_msg_addrs(skb, &saddr, &daddr);
+	sk = quic_sock_lookup(skb, &daddr, &saddr, sk, NULL);
+	if (!sk)
+		return -ENOENT;
+
+	if (quic_get_mtu_info(skb, &info) || !quic_sk_accept_pmtu(sk, skb)) {
+		sock_put(sk);
+		return 0;
+	}
+
+	/* Success: update socket path MTU info. */
+	bh_lock_sock(sk);
+	quic_paths(sk)->mtu_info = info;
+	if (sock_owned_by_user(sk)) {
+		/* Socket locked by userspace. Defer MTU processing via
+		 * release_cb. Hold socket reference to prevent it being
+		 * freed before deferral.
+		 */
+		if (!test_and_set_bit(QUIC_MTU_REDUCED_DEFERRED,
+				      &sk->sk_tsq_flags))
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
+	spin_lock_bh(&head->lock);
+	if (head->qlen >= QUIC_PACKET_BACKLOG_MAX) {
+		spin_unlock_bh(&head->lock);
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVDROP);
+		kfree_skb(skb);
+		return -ENOBUFS;
+	}
+	cb->backlog = 1;
+	__skb_queue_tail(head, skb);
+	spin_unlock_bh(&head->lock);
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
+ * Parses the TLS ClientHello handshake message to find the ALPN (Application
+ * Layer Protocol Negotiation) TLS extension. It validates the TLS ClientHello
+ * structure, including version, random, session ID, cipher suites, compression
+ * methods, and extensions. Once the ALPN extension is found, the ALPN
+ * protocols list is extracted and stored in @alpn.
+ *
+ * Return: 0 on success or no ALPN found, a negative error code on failed
+ * parsing.
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
+	if (len > (u32)length) /* Cap len to handshake msg length. */
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
+	/* Read TLS extensions length (2 bytes). */
+	if (!quic_get_int(&p, &len, &length, 2))
+		return err;
+	if (len > (u32)length) /* Limit len to extensions length if larger. */
+		len = length;
+	while (len >= 4) { /* Scan extensions for ALPN (TLS_EXT_alpn). */
+		if (exts++ >= TLS_MAX_EXTENSIONS)
+			return err;
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
+	}
+	if (!found) { /* No ALPN ext: set alpn->len = 0 and alpn->data = p. */
+		quic_data(alpn, p, 0);
+		return 0;
+	}
+
+	/* Parse ALPN protocols list length (2 bytes). */
+	if (!quic_get_int(&p, &len, &length, 2) || length > (u64)len)
+		return err;
+	quic_data(alpn, p, length); /* Store ALPN list in alpn->data. */
+	len = length;
+	while (len) { /* Validate ALPN protocols list format. */
+		if (!quic_get_int(&p, &len, &length, 1) || length > (u64)len) {
+			/* Bad ALPN: set alpn->len = 0, alpn->data = NULL. */
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
+ * This function processes a QUIC Initial packet to extract the ALPN from the
+ * TLS ClientHello message inside the QUIC CRYPTO frame. It verifies packet
+ * type, version compatibility, decrypts the packet payload, and locates the
+ * CRYPTO frame to parse the TLS ClientHello.  Finally, it calls
+ * quic_packet_get_alpn() to extract the ALPN extension data.
+ *
+ * Return: 0 on success or no ALPN found, a negative error code on failed
+ * parsing.
+ */
+static int quic_packet_parse_alpn(struct sk_buff *skb, struct quic_data *alpn)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct quic_conn_id dcid = {}, scid = {};
+	struct net *net = sock_net(skb->sk);
+	u32 len = skb->len, version;
+	struct quic_crypto *crypto;
+	u8 *p = skb->data, type;
+	struct quic_data token;
+	u64 offset, length;
+	int err;
+
+	if (!static_branch_unlikely(&quic_alpn_demux_key))
+		return 0;
+	err = quic_packet_get_long_header(&dcid, &scid, &version, &p, &len);
+	if (err)
+		return err;
+	if (!quic_packet_compatible_versions(version))
+		return 0;
+	/* Only parse Initial packets. */
+	type = quic_packet_version_get_type(version, quic_hshdr(skb)->type);
+	if (type != QUIC_PACKET_INITIAL)
+		return 0;
+	err = quic_packet_get_token(&token, &p, &len);
+	if (err)
+		return err;
+	if (!quic_get_var(&p, &len, &length) || length > (u64)len)
+		return -EINVAL;
+	if (quic_packet_backlog_schedule(net, skb))
+		return -EINPROGRESS;
+	cb->length = (u16)length;
+
+	/* Install initial keys for packet decryption to crypto. */
+	crypto = &quic_net(net)->crypto;
+	err = quic_crypto_initial_keys_install(crypto, &dcid, version, 1);
+	if (err)
+		return err;
+	cb->number_offset = (u16)(p - skb->data);
+	cb->sync = 1;
+	err = quic_crypto_decrypt(crypto, skb, GFP_KERNEL);
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
+/* Lookup listening socket for Client Initial packet (in process context). */
+static struct sock *quic_packet_get_listen_sock(struct sk_buff *skb)
+{
+	union quic_addr daddr, saddr;
+	struct quic_data alpns = {};
+	struct sock *sk;
+	int err;
+
+	quic_get_msg_addrs(skb, &daddr, &saddr);
+
+	err = quic_packet_parse_alpn(skb, &alpns);
+	if (err)
+		return ERR_PTR(err);
+
+	sk = quic_listen_sock_lookup(skb, &daddr, &saddr, &alpns);
+	if (!sk)
+		return ERR_PTR(-ENOENT);
+	return sk;
+}
+
+/* Determine the QUIC socket associated with an incoming packet. */
+static struct sock *quic_packet_get_sock(struct sk_buff *skb)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct quic_conn_id dcid = {}, *conn_id;
+	struct net *net = sock_net(skb->sk);
+	union quic_addr daddr, saddr;
+	struct quic_data alpns = {};
+	struct sock *sk = NULL;
+	u32 len = skb->len;
+	u8 *p = skb->data;
+	int err;
+
+	if (skb->len < QUIC_HLEN)
+		return ERR_PTR(-EINVAL);
+
+	if (quic_hdr(skb)->form == QUIC_PACKET_FORM_SHORT) {
+		/* Short header path. */
+		if (skb->len < QUIC_HLEN + QUIC_CONN_ID_DEF_LEN)
+			return ERR_PTR(-EINVAL);
+		/* Fast path: look up QUIC connection by fixed-length DCID
+		 * (Currently, only QUIC_CONN_ID_DEF_LEN-length SCIDs are used).
+		 */
+		conn_id = quic_conn_id_lookup(net, skb->data + QUIC_HLEN,
+					      QUIC_CONN_ID_DEF_LEN);
+		if (conn_id) {
+			cb->seqno = quic_conn_id_number(conn_id);
+			/* Return associated socket. */
+			return quic_conn_id_sk(conn_id);
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
+		sk = quic_sock_lookup(skb, &daddr, &saddr, skb->sk, NULL);
+		if (!sk)
+			return ERR_PTR(-ENOENT);
+		return sk;
+	}
+
+	/* Long header path. */
+	err = quic_packet_get_long_header(&dcid, NULL, NULL, &p, &len);
+	if (err)
+		return ERR_PTR(err);
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
+	err = quic_packet_parse_alpn(skb, &alpns);
+	if (err)
+		return ERR_PTR(err);
+	sk = quic_listen_sock_lookup(skb, &daddr, &saddr, &alpns);
+	if (!sk)
+		return ERR_PTR(-ENOENT);
+	return sk;
+}
+
+/* Entry point for processing received QUIC packets. */
+int quic_packet_rcv(struct sock *sk, struct sk_buff *skb, bool icmp)
+{
+	struct net *net = sock_net(sk);
+	int err;
+
+	if (unlikely(icmp))
+		return quic_packet_rcv_err(sk, skb);
+
+	/* Save the UDP socket to skb->sk for later QUIC socket lookup. */
+	if (skb_linearize(skb) || !skb_set_owner_sk_safe(skb, sk)) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	/* Look up socket from socket or connection IDs hash tables. */
+	sk = quic_packet_get_sock(skb);
+	if (IS_ERR(sk)) {
+		err = PTR_ERR(sk);
+		if (err == -EINPROGRESS)
+			return 0;
+		goto err;
+	}
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		/* Socket is busy (owned by user context): queue to backlog. */
+		err = sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf));
+		if (err) {
+			bh_unlock_sock(sk);
+			sock_put(sk);
+			goto err;
+		}
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVBACKLOGS);
+	} else {
+		/* Socket not busy: process immediately. */
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVFASTPATHS);
+		sk->sk_backlog_rcv(sk, skb); /* quic_backlog_rcv(). */
+	}
+	bh_unlock_sock(sk);
+	sock_put(sk);
+	return 0;
+err:
+	pr_debug("%s: failed, len: %d, err: %d\n", __func__, skb->len, err);
+	QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVDROP);
+	kfree_skb(skb);
+	return err;
+}
+
+static int quic_packet_listen_process(struct sock *sk, struct sk_buff *skb,
+				      gfp_t gfp)
+{
+	kfree_skb(skb);
+	return -EOPNOTSUPP;
+}
+
+static int quic_packet_handshake_process(struct sock *sk, struct sk_buff *skb,
+					 gfp_t gfp)
+{
+	kfree_skb(skb);
+	return -EOPNOTSUPP;
+}
+
+static int quic_packet_app_process(struct sock *sk, struct sk_buff *skb,
+				   gfp_t gfp)
+{
+	kfree_skb(skb);
+	return -EOPNOTSUPP;
+}
+
+int quic_packet_process(struct sock *sk, struct sk_buff *skb, gfp_t gfp)
+{
+	if (quic_is_closed(sk)) {
+		kfree_skb(skb);
+		return 0;
+	}
+
+	if (quic_is_listen(sk))
+		return quic_packet_listen_process(sk, skb, gfp);
+
+	if (quic_hdr(skb)->form == QUIC_PACKET_FORM_LONG)
+		return quic_packet_handshake_process(sk, skb, gfp);
+
+	return quic_packet_app_process(sk, skb, gfp);
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
+		if (IS_ERR(sk)) {
+			QUIC_INC_STATS(sock_net(skb->sk), QUIC_MIB_PKT_RCVDROP);
+			kfree_skb(skb);
+			continue;
+		}
+
+		lock_sock(sk);
+		quic_packet_process(sk, skb, GFP_KERNEL);
+		release_sock(sk);
+		sock_put(sk);
+		cond_resched();
+	}
+}
+
 /* Make these fixed for easy coding. */
 #define QUIC_PACKET_NUMBER_LEN	QUIC_PN_MAX_LEN
 #define QUIC_PACKET_LENGTH_LEN	4
diff --git a/net/quic/packet.h b/net/quic/packet.h
index 18b89f505121..fefc54058441 100644
--- a/net/quic/packet.h
+++ b/net/quic/packet.h
@@ -54,6 +54,8 @@ struct quic_packet {
 
 #define QUIC_VERSION_LEN		4
 
+#define QUIC_ALPN_MAX_LEN		128
+
 #define QUIC_PACKET_MSS_NORMAL		0
 #define QUIC_PACKET_MSS_DGRAM		1
 
@@ -101,6 +103,7 @@ static inline void quic_packet_reset(struct quic_packet *packet)
 	packet->ack_immediate = 0;
 }
 
+int quic_packet_process(struct sock *sk, struct sk_buff *skb, gfp_t gfp);
 u16 quic_packet_overhead(struct sock *sk, u8 level, u8 path);
 int quic_packet_config(struct sock *sk, u8 level, u8 path);
 
@@ -110,3 +113,8 @@ int quic_packet_route(struct sock *sk);
 void quic_packet_mss_update(struct sock *sk, u32 mss);
 void quic_packet_flush(struct sock *sk);
 void quic_packet_init(struct sock *sk);
+
+u32 *quic_packet_compatible_versions(u32 version);
+
+void quic_packet_backlog_work(struct work_struct *work);
+void quic_packet_rcv_err_pmtu(struct sock *sk);
diff --git a/net/quic/path.c b/net/quic/path.c
index 03058c38f992..f197ae1c556c 100644
--- a/net/quic/path.c
+++ b/net/quic/path.c
@@ -27,14 +27,14 @@ static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
 
 	skb_pull(skb, sizeof(struct udphdr));
 	skb_dst_force(skb);
-	kfree_skb(skb);
+	quic_packet_rcv(sk, skb, false);
 	/* .encap_rcv must return 0 if skb was either consumed or dropped. */
 	return 0;
 }
 
 static int quic_udp_err(struct sock *sk, struct sk_buff *skb)
 {
-	return 0;
+	return quic_packet_rcv(sk, skb, true);
 }
 
 static void quic_udp_sock_put_work(struct work_struct *work)
diff --git a/net/quic/path.h b/net/quic/path.h
index c08d0aa3a9e3..a7eedfa2f022 100644
--- a/net/quic/path.h
+++ b/net/quic/path.h
@@ -167,6 +167,8 @@ quic_path_orig_dcid(struct quic_path_group *paths)
 	return paths->retry ? &paths->retry_dcid : &paths->orig_dcid;
 }
 
+int quic_packet_rcv(struct sock *sk, struct sk_buff *skb, bool icmp);
+
 bool quic_path_detect_alt(struct quic_path_group *paths, union quic_addr *sa,
 			  union quic_addr *da, struct sock *sk);
 int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 path);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index 83267a785ae7..1ad95f9c9250 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -245,6 +245,9 @@ static int __net_init quic_net_init(struct net *net)
 		return err;
 	}
 
+	INIT_WORK(&qn->work, quic_packet_backlog_work);
+	skb_queue_head_init(&qn->backlog_list);
+
 #if IS_ENABLED(CONFIG_PROC_FS)
 	err = quic_net_proc_init(net);
 	if (err) {
@@ -263,6 +266,8 @@ static void __net_exit quic_net_exit(struct net *net)
 #if IS_ENABLED(CONFIG_PROC_FS)
 	quic_net_proc_exit(net);
 #endif
+	disable_work_sync(&qn->work);
+	skb_queue_purge(&qn->backlog_list);
 	quic_crypto_free(&qn->crypto);
 	free_percpu(qn->stat);
 	qn->stat = NULL;
diff --git a/net/quic/protocol.h b/net/quic/protocol.h
index b8584e72ff14..25001aaaad4a 100644
--- a/net/quic/protocol.h
+++ b/net/quic/protocol.h
@@ -51,6 +51,10 @@ struct quic_net {
 #endif
 	/* Context for decrypting Initial packets for ALPN */
 	struct quic_crypto crypto;
+
+	/* Queue of packets deferred for processing in process context */
+	struct sk_buff_head backlog_list;
+	struct work_struct work; /* Work to drain/process backlog_list */
 };
 
 struct quic_net *quic_net(struct net *net);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 8f348d7c678b..ce1c86c0da3e 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -24,6 +24,154 @@ static void quic_enter_memory_pressure(struct sock *sk)
 	WRITE_ONCE(quic_memory_pressure, 1);
 }
 
+/* Lookup a connected QUIC socket based on address and dest connection ID.
+ *
+ * This function searches the established (non-listening) QUIC socket table for
+ * a socket that matches the source and dest addresses and, optionally, the
+ * dest connection ID (DCID). The value returned by quic_path_orig_dcid() might
+ * be the original dest connection ID from the ClientHello or the Source
+ * Connection ID from a Retry packet before.
+ *
+ * The DCID is provided from a handshake packet when searching by source
+ * connection ID fails, such as when the peer has not yet received server's
+ * response and updated the DCID.
+ *
+ * Return: A pointer to the matching connected socket, or NULL if no match is
+ * found.
+ */
+struct sock *quic_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
+			      union quic_addr *da, struct sock *usk,
+			      struct quic_conn_id *dcid)
+{
+	struct net *net = sock_net(usk);
+	struct quic_path_group *paths;
+	struct hlist_nulls_node *node;
+	struct quic_shash_head *head;
+	struct sock *sk = NULL, *tmp;
+	struct quic_conn_id *odcid;
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
+		odcid = quic_path_orig_dcid(paths);
+		if (quic_cmp_sk_addr(tmp, quic_path_saddr(paths, 0), sa) &&
+		    quic_cmp_sk_addr(tmp, quic_path_daddr(paths, 0), da) &&
+		    quic_path_usock(paths, 0) == usk &&
+		    (!dcid || !quic_conn_id_cmp(odcid, dcid))) {
+			sk = tmp;
+			break;
+		}
+	}
+	/* If the final nulls value differs from the expected one, restart the
+	 * lookup as the node may have been rehashed (e.g., due to connection
+	 * migration).
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
+ * This function searches the QUIC socket table for a listening socket that
+ * matches the dest address and port, and the ALPN(s) if presented in the
+ * ClientHello.  If multiple listening sockets are bound to the same address,
+ * port, and ALPN(s) (e.g., via SO_REUSEPORT), this function selects a socket
+ * from the reuseport group.
+ *
+ * Return: A pointer to the matching listening socket, or NULL if no match is
+ * found.
+ */
+struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
+				     union quic_addr *da,
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
+	if (!alpns->len) { /* No ALPNs or parse failed */
+		sk_nulls_for_each_rcu(tmp, node, &head->head) {
+			/* If alpns->data != NULL, TLS parsing succeeded but no
+			 * ALPN was found.  In this case, only match sockets
+			 * that have no ALPN set.
+			 */
+			a = quic_path_saddr(quic_paths(tmp), 0);
+			if (net == sock_net(tmp) &&
+			    quic_cmp_sk_addr(tmp, a, sa) &&
+			    quic_path_usock(quic_paths(tmp), 0) == skb->sk &&
+			    (!alpns->data || !quic_alpn(tmp)->len)) {
+				if (!quic_is_any_addr(a)) {
+					sk = tmp;
+					break; /* Prefer specific addr match. */
+				}
+				/* Prefer ipv4 ANY over ipv6 ANY for v4 addr. */
+				if (!sk || a->sa.sa_family == sa->sa.sa_family)
+					sk = tmp;
+			}
+		}
+		/* No need to check get_nulls_value(node) != hash for !sk, as
+		 * hashtable size is fixed and a listen sk can not rehashed.
+		 */
+		goto out;
+	}
+
+	/* ALPN present: loop through each ALPN entry. */
+	for (p = alpns->data, len = alpns->len; len;
+	     len -= length, p += length) {
+		quic_get_int(&p, &len, &length, 1);
+		quic_data(&alpn, p, length);
+		sk_nulls_for_each_rcu(tmp, node, &head->head) {
+			a = quic_path_saddr(quic_paths(tmp), 0);
+			if (net == sock_net(tmp) &&
+			    quic_cmp_sk_addr(tmp, a, sa) &&
+			    quic_path_usock(quic_paths(tmp), 0) == skb->sk &&
+			    quic_data_has(quic_alpn(tmp), &alpn)) {
+				if (!quic_is_any_addr(a)) {
+					sk = tmp;
+					break;
+				}
+				if (!sk || a->sa.sa_family == sa->sa.sa_family)
+					sk = tmp;
+			}
+		}
+		/* No need to check get_nulls_value(node) != hash for !sk, as
+		 * hashtable size is fixed and a listen sk can not rehashed.
+		 */
+		if (sk)
+			break;
+	}
+out:
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
 	__poll_t mask = EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
@@ -48,6 +196,9 @@ static void quic_sock_destruct(struct sock *sk)
 	for (i = 0; i < QUIC_CRYPTO_MAX; i++)
 		quic_crypto_free(quic_crypto(sk, i));
 
+	/* Deferred ALPN free for RCU readers in quic_listen_sock_lookup(). */
+	quic_data_free(quic_alpn(sk));
+
 	quic_sk_destruct(sk);
 }
 
@@ -100,7 +251,6 @@ static void quic_destroy_sock(struct sock *sk)
 
 	quic_data_free(quic_ticket(sk));
 	quic_data_free(quic_token(sk));
-	quic_data_free(quic_alpn(sk));
 
 	sk_sockets_allocated_dec(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
@@ -227,6 +377,10 @@ static void quic_release_cb(struct sock *sk)
 		nflags = flags & ~QUIC_DEFERRED_ALL;
 	} while (!try_cmpxchg(&sk->sk_tsq_flags, &flags, nflags));
 
+	if (flags & QUIC_F_MTU_REDUCED_DEFERRED) {
+		quic_packet_rcv_err_pmtu(sk);
+		__sock_put(sk);
+	}
 	if (flags & QUIC_F_LOSS_DEFERRED) {
 		quic_timer_loss_handler(sk);
 		__sock_put(sk);
@@ -259,6 +413,11 @@ static void quic_shutdown(struct sock *sk, int how)
 	quic_set_state(sk, QUIC_SS_CLOSED);
 }
 
+static int quic_backlog_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	return quic_packet_process(sk, skb, GFP_ATOMIC);
+}
+
 struct proto quic_prot = {
 	.name		=  "QUIC",
 	.owner		=  THIS_MODULE,
@@ -276,6 +435,7 @@ struct proto quic_prot = {
 	.accept		=  quic_accept,
 	.hash		=  quic_hash,
 	.unhash		=  quic_unhash,
+	.backlog_rcv	=  quic_backlog_rcv,
 	.release_cb	=  quic_release_cb,
 	.no_autobind	=  true,
 	.obj_size	=  sizeof(struct quic_sock),
@@ -306,6 +466,7 @@ struct proto quicv6_prot = {
 	.accept		=  quic_accept,
 	.hash		=  quic_hash,
 	.unhash		=  quic_unhash,
+	.backlog_rcv	=  quic_backlog_rcv,
 	.release_cb	=  quic_release_cb,
 	.no_autobind	=  true,
 	.obj_size	= sizeof(struct quic6_sock),
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 1efc76ec2033..3c1bea767be9 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -200,3 +200,10 @@ static inline void quic_set_state(struct sock *sk, int state)
 	inet_sk_set_state(sk, state);
 	sk->sk_state_change(sk);
 }
+
+struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
+				     union quic_addr *da,
+				     struct quic_data *alpns);
+struct sock *quic_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
+			      union quic_addr *da, struct sock *usk,
+			      struct quic_conn_id *dcid);
-- 
2.47.1

