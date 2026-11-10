Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349795;
	b=2XEL2JbUnoE6lHJ11tMQxqrSxzhfKX1sqs3vCgubIQAtU6+A/phePWVTb56vLA2p1H6d
	 BWj6AixDkSMthQ8RCS+6U4QS/bJGnpxqo30fSDglFsWaAnkdJJWgSIFPpzVXBpOg+7fUg
	 JI9a6mSW9JltUrv+IAyb4TeNVlcA5+nAEs8MbNceAf7eP2jGhTD+tdI/cFVOse/pLYO/x
	 OWyjH02Zz0B3IRoQS0BOuwPSdw0TpK/yJn2wStKu4vlvzEF5ip6ym/SRwpwytxzEMC7QL
	 yWR3/0IiTOa5NZop5T3ru0+YZW1vc1i3TvqXGMThLsD5qvh+CtOzbxtecfVzBQCPQ6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349795;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=l5X9Rmeh++p/8mS1Mvx0ILZgLGNbSGsLLaS3fu5Inpc=;
	b=oyqNDp3hITftZ+coHE8kGU9it+UV7hcxFelirloo2YyTS6WiScwxt6ZYK4lOh4oD3KoL
	 p1Nvqy7vf9ejFByQ3MchO35T2fes9vkjl0AlnRkfQStpH/MBAs7Du2WsbHDmoetLPLwOE
	 Sd6hQobvctneFQaPa5pysN2eMH7uWT2UYNsZTBM01xXG0XIevcJy1B9tgROsbklPO0fSp
	 /+D7cqPCCCR1a3L847lpy/HzCFbzAPDEBWJwo4y6WFOU80YGZeyy/X/J71QC2DggUHczn
	 UvL2bppQe9aiXWh3YHW5qPH27RxXhux8SOiKle75+DMbDaTsqK7gbdWOhpDm8tbUc1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mj17zAe9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87538606A335;
	Tue, 10 Nov 2026 22:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mj17zAe9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A99F1F008A6;
	Tue, 10 Nov 2026 22:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349795;
	bh=l5X9Rmeh++p/8mS1Mvx0ILZgLGNbSGsLLaS3fu5Inpc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Mj17zAe9qlOK92UtZA461e4+MC0yK7vHQ2pJfaGtqkGSIPQWH/nC3MP6EboXt6j5+
	 2itQ18fTT111g3q9CEHO1OuwBaQFoylyBAyeN90EOYUQT8LGBjgiFXDcWgDGEsWGmp
	 UKKPmV7Vk77iisxnfe979O/9O8q0OTMEt3YMm7NrYGTRtAikyj9tr4CJr/e3cLDzbZ
	 t2+8DAcBtcjpS9k3vN3VfW6e+Z4iRkAn5MepfzgF8zGenKIFLKGpZuKpAsrh+Ldar4
	 ic1ASKg1doh3N/P6ZeDro8NwQAeGoTKzwS43gXcOVV5rvWYEzooIkEotcBKYgyYf1v
	 BfBbmINTAz/5w==
Subject: Re: [PATCH net-next v18 15/15] quic: add packet parser base
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org,
 linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev,
 cel@kernel.org, jlayton@kernel.org, steved@redhat.com, hare@suse.de,
 aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org,
 mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com,
 jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net,
 marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com,
 mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Date: Tue, 10 Nov 2026 22:29:53 +0000
Message-ID: <179434979306.994134.6060137114649514335@kernel.org>
In-Reply-To: <b5da5ee6e67a5839f513fc895f84315fe96042ac.1794241656.git.lucien.xin@gmail.com>
References: <b5da5ee6e67a5839f513fc895f84315fe96042ac.1794241656.git.lucien.xin@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] An ICMP Packet Too Big has no effect when PLPMTUD is disabled.
- [Medium] In quic_packet_listen_process() (net/quic/packet.c:749-766),
  the new request is published before its first packet is queued, and…
- [Medium] quic_packet_rcv_err() accepts an ICMP PTB/Frag-Needed based
  only on the quoted IP addresses and UDP ports.
- [Low] The comment on `struct quic_skb_cb::backlog`
  (net/quic/common.h:71, `u8 backlog:1; /* Enqueued into backlog list…
- [Low] In quic_listen_sock_lookup() (net/quic/socket.c:248-249), the
  comment says "Address specificity always takes precedence over ALPN…

--

quic: add packet parser base

This patch adds the QUIC receive path packet parser. It looks up sockets
by connection ID, address and ALPN, dispatches packets by socket state,
and handles client Initial packets on listen sockets with request
sockets. It also adds ICMP Packet Too Big handling to update the path
MTU, and a per-socket workqueue for packets that need a sleepable
context.

> diff --git a/net/quic/packet.c b/net/quic/packet.c
> index b6f76681b6902..9579a65317d0b 100644
> --- a/net/quic/packet.c
> +++ b/net/quic/packet.c
> @@ -14,6 +14,804 @@

[ ... ]

> +/* Process PMTU reduction event on a QUIC socket. */
> +void quic_packet_rcv_err_pmtu(struct sock *sk)
> +{
> +	struct quic_path_group *paths = quic_paths(sk);
> +	struct quic_packet *packet = quic_packet(sk);
> +	u32 pathmtu, info, taglen;
> +	struct dst_entry *dst;
> +	bool reset_timer;
> +
> +	if (quic_is_closed(sk))
> +		return;
> +
> +	info = clamp(paths->mtu_info, QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);
> +	/* If PLPMTUD is not enabled, update MSS using route and ICMP info. */
> +	if (!paths->plpmtud_interval) {
> +		/* Ensure we have a dst cached for update_pmtu().
> +		 * ICMP errors apply to the main path (path 0). Use
> +		 * quic_packet_config() to reset dst cache if path changed.
> +		 */
> +		if (quic_packet_config(sk, QUIC_CRYPTO_APP, 0))
> +			return;
> +
> +		dst = __sk_dst_get(sk);
> +		if (dst) {
> +			dst->ops->update_pmtu(dst, sk, NULL, info, true);
> +			/* Invalidate cached dst. Next quic_packet_route()
> +			 * during transmission will pick up the updated MTU
> +			 * from the newly created route exception and call
> +			 * quic_packet_mss_update().
> +			 */
> +			__sk_dst_reset(sk);
> +		}
> +		return;
> +	}

[Severity: High]
Does this update_pmtu() call ever reach the peer's route? With a NULL
skb, the routing layer builds the flow key from the socket's inet
fields.

For IPv4, ip_rt_update_pmtu()->ip_rt_build_flow_key()->build_sk_flow_key():

net/ipv4/route.c:build_sk_flow_key() {
    ...
	__be32 daddr = inet->inet_daddr;
    ...
}

For IPv6, __ip6_rt_update_pmtu() with iph == NULL:

net/ipv6/route.c:__ip6_rt_update_pmtu() {
    ...
		daddr = &sk->sk_v6_daddr;
		saddr = &inet6_sk(sk)->saddr;
    ...
}

As far as I can tell, nothing in net/quic/ sets inet_daddr, inet_saddr,
sk_v6_daddr or the IPv6 saddr. Instead, quic_v4_flow_route() and
quic_v6_flow_route() fill a private flowi from the path addresses:

	fl4->daddr = da->v4.sin_addr.s_addr;

That means the exception gets created for 0.0.0.0 (IPv4, through
fib_lookup() and update_or_create_fnhe(), and only if a default route
matches) or for :: (IPv6). It is never created for the real peer.

After __sk_dst_reset(), the next quic_packet_route() looks up the peer
route again, gets the old dst_mtu(), and calls quic_packet_mss_update()
with the same value as before.

plpmtud_interval doesn't appear to be set anywhere in net/quic/ yet, so
every socket takes this branch. packet->ipfragok is also 0 here, so DF
packets keep getting dropped at the smaller-MTU hop.

Would this leave the connection in a PMTU black hole? The commit message
says:

  "When PLPMTUD is disabled, update the MSS using the MTU accepted by
  the routing layer"

Other callers that pass a NULL skb make sure the socket daddr is valid
first. For example, SCTP's sctp_transport_update_pmtu() sets it
temporarily with pf->to_sk_daddr().

The ICMP skb in quic_packet_rcv_err() also carries the quoted inner IP
header. ipv4_sk_update_pmtu() and ip6_sk_update_pmtu() use that header
to build a correct key, but it isn't passed down here.

There is also a side effect. The IPv4 case can create a stray fnhe for
0.0.0.0 on the default nexthop, which marks its cached routes stale. The
IPv6 case can insert an RTF_CACHE exception for ::.

> +	/* PLPMTUD is enabled: adjust to smaller PMTU, subtract headers and
> +	 * AEAD tag.  Also notify the QUIC path layer for possible state
> +	 * changes and probing.
> +	 */
> +	packet->level = QUIC_CRYPTO_APP;
> +	taglen = quic_packet_taglen(packet);
> +	info = info - packet->hlen - taglen;
> +	pathmtu = quic_path_pl_toobig(paths, info, &reset_timer);
> +	if (reset_timer)
> +		quic_timer_reset(sk, QUIC_TIMER_PMTU, paths->plpmtud_interval);
> +	if (pathmtu)
> +		quic_packet_mss_update(sk, pathmtu + taglen);
> +}
> +
> +/* Handle ICMP Toobig packet and update QUIC socket path MTU. */
> +static int quic_packet_rcv_err(struct sock *sk, struct sk_buff *skb)
> +{
> +	union quic_addr daddr, saddr;
> +	u32 info;
> +
> +	/* ICMP embeds the original outgoing QUIC packet, so saddr/daddr are
> +	 * reversed compared to incoming packets. Only address-based socket
> +	 * lookup is possible in this case.
> +	 */
> +	quic_get_msg_addrs(skb, &daddr, &saddr);
> +	sk = quic_sock_lookup(skb, &saddr, &daddr, sk, NULL);
> +	if (!sk)
> +		return -ENOENT;
> +
> +	if (quic_get_mtu_info(skb, &info) || !quic_sk_accept_pmtu(sk, skb)) {
> +		sock_put(sk);
> +		return 0;
> +	}

[Severity: Medium]
Should the quoted QUIC DCID be checked before this ICMP is trusted? The
lookup passes dcid == NULL, so the socket is matched only on the quoted
IP addresses and UDP ports. quic_get_mtu_info() and quic_sk_accept_pmtu()
only look at the ICMP type and the pmtudisc setting.

The quoted QUIC header follows the UDP header in the ICMP payload. RFC
9000 section 14.2.1 recommends validating it when possible.

quic_packet_rcv_err_pmtu() also does this:

	info = clamp(paths->mtu_info, QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);

That raises claims below 1200 bytes up to 1200 instead of ignoring them.
The same RFC section says such messages must be ignored.

With PLPMTUD enabled, a spoofed claim such as 68 becomes roughly
1136-1156 once hlen and taglen are subtracted. That is above
QUIC_MIN_PLPMTU, so quic_path_pl_toobig() moves a path in the search or
complete state back to the base 1200-byte PMTU, and
quic_packet_mss_update() shrinks the MSS. Without the clamp, 68 - 44 = 24
would have been ignored.

Without PLPMTUD, the clamped 1200 is passed to update_pmtu(). That is a
no-op for the peer today only because of the flow key issue above. Once
that is fixed, the same spoofed ICMP would install a 1200-byte exception
toward the peer.

Could an off-path attacker who guesses the 4-tuple (the server port plus
a 16-bit client port) use this to keep forcing a connection down to
1200-byte datagrams?

[ ... ]

> +static int quic_packet_deferred_schedule(struct sk_buff *skb)
> +{
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	struct sock *sk = skb->sk;
> +	int len = skb->truesize;
> +
> +	if (cb->backlog)
> +		return 0;
> +
> +	if (sk_rmem_alloc_get(sk) + len > sk->sk_rcvbuf ||
> +	    !__sk_rmem_schedule(sk, len, false)) {
> +		QUIC_INC_STATS(sock_net(sk), QUIC_MIB_PKT_RCVDROP);
> +		kfree_skb(skb);
> +		return -ENOBUFS;
> +	}
> +	cb->backlog = 1;

[Severity: Low]
This isn't a bug, but the comment on this field in net/quic/common.h no
longer matches how the field is used:

	u8 backlog:1;    /* Enqueued into backlog list */

Here the bit is set when the skb goes onto deferred_list for the
workqueue, and the check above reads it as "already in a sleepable
context". quic_accept_sock_exists() clears it right before a possible
sk_add_backlog(). quic_crypto_decrypt() reads it as:

	if (!cb->backlog) /* Key update requires process context. */

Could the comment say that the bit means the skb is being processed from
a process-context queue where sleeping is allowed?

> +	skb_set_owner_r(skb, sk);
> +	__skb_queue_tail(&quic_packet(sk)->deferred_list, skb);

[ ... ]

> +	/* Add request sock for this new QUIC connection. */
> +	req = quic_request_sock_create(sk, &odcid, retry, gfp);
> +	if (IS_ERR(req)) {
> +		if (quic_packet_deferred_schedule(skb))
> +			return 0;
> +		/* rfc9000#section-5.2.2:
> +		 *
> +		 * If a server refuses to accept a new connection, it SHOULD
> +		 * send an Initial packet containing a CONNECTION_CLOSE frame
> +		 * with error code CONNECTION_REFUSED.
> +		 */
> +		errcode = QUIC_TRANSPORT_ERROR_CONNECTION_REFUSED;
> +		quic_packet_refuse_close_create_and_xmit(sk, errcode);
> +		consume_skb(skb);
> +		return PTR_ERR(req);
> +	}
> +out:
> +	/* Queue the skb on this request sock's backlog. */
> +	return quic_request_sock_backlog_tail(sk, req, skb);
> +}

[Severity: Medium]
What happens to the new request if queueing its first packet fails? By
this point quic_request_sock_create() has already published it:

net/quic/socket.c:quic_request_sock_create() {
    ...
	list_add_tail(&req->list, quic_reqs(sk));
	sk_acceptq_added(sk);
	sk->sk_data_ready(sk);
    ...
}

quic_request_sock_backlog_tail() can fail on that very first packet:

net/quic/socket.c:quic_request_sock_backlog_tail() {
    ...
	if (req->blen + len > limit || !__sk_rmem_schedule(sk, len, false)) {
		QUIC_INC_STATS(sock_net(sk), QUIC_MIB_PKT_RCVDROP);
		kfree_skb(skb);
		return -ENOBUFS;
	}
    ...
}

limit is max(sk_rcvbuf / sk_max_ack_backlog, QUIC_MIN_UDP_PAYLOAD * 4).
Any skb with a truesize above 4800 bytes fails that check, for example
on a driver that uses a whole page per packet on a 64K page system. The
rmem schedule can also fail under memory pressure.

On this error path, req is not removed with list_del() or freed,
sk_acceptq_removed() is not called, and accept() has already been woken.

Does this leave a request with an empty backlog_list (no Client Initial)
holding an accept queue slot?

The only way it recovers is if a retransmitted Initial matches it in
quic_request_sock_lookup() and gets queued successfully. A spoofing peer
never retransmits. In the truesize case, every retransmit fails the same
check, so the connection can never be established.

[ ... ]

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index f7792236752b0..338af1a184df0 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c
> @@ -24,6 +24,323 @@ static void quic_enter_memory_pressure(struct sock *sk)

[ ... ]

> +struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
> +				     union quic_addr *da, struct sock *usk,
> +				     struct quic_data *alpns)
> +{

[ ... ]

> +	rcu_read_lock();
> +	/* Iterate sockets, checking ALPN requirements. Address specificity
> +	 * always takes precedence over ALPN preference order.
> +	 */
> +	sk_nulls_for_each_rcu(tmp, node, &head->head) {
> +		bool alpn_match = false;

[ ... ]

> +		if (alpn_match) {
> +			if (!quic_is_any_addr(a)) {
> +				/* Specific address - best match. */
> +				sk = tmp;
> +				goto out;
> +			}
> +			/* ANY address - keep as candidate. */
> +			if (!sk || a->sa.sa_family == sa->sa.sa_family)
> +				sk = tmp;
> +		}
> +	}

[Severity: Low]
This isn't a bug, but the comment suggests the client's ALPN preference
order is used as a secondary criterion, and the loop doesn't seem to do
that. alpn_match is a plain boolean, and which client ALPN matched is
not recorded.

Among specific-address listeners, the first match in the hash chain wins
through goto out. Among same-family wildcard-address listeners, each
later match replaces the candidate, so the last one wins.

For example, if the client offers "smb,h3" and listeners A (h3) and B
(smb) are bound to the same address, the choice depends on bind/listen
order and not on the client's preference.

Could the comment be updated, or could the preference ordering be
restored? It seems to have been dropped when the two lookups were merged
in v15.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794241654.git.lucien.xin%40gmail.com
