Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445413;
	b=kMtmkWo5Yu27bhX3Y/b2iPc4AzAwvPyulL4/tyaVGLl/Q0WfcwcOwV5RiymjcOOG5Emu
	 iwBeWDHR3s1Er1VzLLWMX4uTwybifwOifu3MQerjxKzFIsgsRcJgaz8Hsq1FtMtckQnNM
	 nurwP4xQfiDE4QZYUgJ8Saix7JT8goyqmnFNgqP+LL5sKTpe/bBbe3tzZKUAf1La2vggJ
	 r9H12mfh2nwvBRhq6y8OV46aHcVnb9RmnYJepfokZBezzaKcZNlMHG8VQ2AGfcgzeT81n
	 FKUlYNQkP+jTNf/U7ldnvF9g5X3nmqz4SvGOi5HCTe9vPHItqG273nNALWra+Rxr0AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445413;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=UuICSS5DMo4Gcw0hAWTDJJ5h4bUS85wyXSJnINw8FnE=;
	b=aSe763eP1Pv4KRW4qFZKeIJLJrXVwjU2oeMBmv7PvEpkJ6XVz/uC/7xeZyPVBrpHtVE0
	 N1MtJy/JMdO7PXgx60Xt6DeOQ3cn2+syM87YwazjijSa2g5f1ZQEi5VCEEXIzv4v4Mqq4
	 KnA2p4UI0eTh3cm+Tg0BmTb/BD8I/1y2y28utkZq2h5MdIwyG6nRAnZsZrUb3vIfBWdSA
	 yplkzhp+RLZZAKyi3mGKsNIH7oUXQjRCPPHQFAFjwEUVeX5GnBFKTn9tOGapW3/TzavPh
	 1Yh+jT0/62o3Bj+UyzAtAt3TpWWMsW95o3BZ2DRvuYgtzLADWBxi2Y7rulzabDm2arg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X6BYdnTv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63506606A319;
	Mon, 19 Oct 2026 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X6BYdnTv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88A01F000C9;
	Mon, 19 Oct 2026 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792445412;
	bh=UuICSS5DMo4Gcw0hAWTDJJ5h4bUS85wyXSJnINw8FnE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=X6BYdnTvC6C15mHDkX22cBjEl6SoM5OpsD1FPrncIRLgN2Y7ja0uoYw6CPQrHHlEQ
	 cV2fGLklVZXA7zmRbtdkOhRn29swKPDzzh3I5d/3lMuT005nTO9lXJ3N49RWNpUAoE
	 mid7bcvLFFQ8YQCcRGxfHueccbAcZqn4jFY85UJfggmQ/tKMSLQ5cgcf4YEIkTKKMF
	 taTnKv155x3+a+xP3fk2RArbEUHBL+7kIUrH1eWiX5PgzbuIu9l6yxtaK4euEQjZDA
	 0RIXXvXy9cbipOpnmKDyiPVKmVjgBFVsNA36wEPI5iFxBuZDoOmdJ6IsMIPGA+pgeO
	 64S7a2B3ujdVA==
Subject: Re: [PATCH net-next v17 15/15] quic: add packet parser base
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org,
 linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev,
 chuck.lever@oracle.com, jlayton@kernel.org, steved@redhat.com, hare@suse.de,
 aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org,
 mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com,
 jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net,
 marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com,
 mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Date: Mon, 19 Oct 2026 21:30:10 +0000
Message-ID: <179244541026.3135.1595523596507400028@kernel.org>
In-Reply-To: =?utf-8?q?=3C47ec29f97f3986e6b9cb5b07f109dcae340916e6=2E1792164?=
 =?utf-8?q?438=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C47ec29f97f3986e6b9cb5b07f109dcae340916e6=2E17921644?=
 =?utf-8?q?38=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
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

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 4

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] When PLPMTUD is disabled, ICMP Packet Too Big messages never
  lower the MSS.
- [Medium] quic_accept_sock_exists() (net/quic/socket.c) passes an skb to
  an accept socket's sk_backlog_rcv() while atomic: local_bh_disable()…
- [Low] quic_packet_get_connid() rejects any connection ID longer than
  QUIC_CONN_ID_MAX_LEN (20) regardless of version.
- [Low] quic_request_sock_backlog_tail() calls __sk_rmem_schedule(sk,
  len) before skb_set_owner_r().
- [Low] quic_packet_deferred_work() drains deferred_list while holding
  lock_sock(sk) and never calls cond_resched(): `while ((skb =…
- [Low] quic_packet_get_alpn() prints the u32 field alpn->len (struct
  quic_data in net/quic/common.h) with %d: `pr_debug("%s: alpn_len:…

--

quic: add packet parser base

This patch adds the QUIC receive path. Sockets are looked up by
connection ID and address, and packets are dispatched by socket state.
Listen sockets handle client Initial packets (request sockets, ALPN
demux, deferred work), and ICMP Packet Too Big errors update the path
MTU.

> diff --git a/net/quic/packet.c b/net/quic/packet.c
> index 56d2b8df292a0..a2f836cc22d70 100644
> --- a/net/quic/packet.c
> +++ b/net/quic/packet.c
> @@ -14,6 +14,801 @@

[ ... ]

> +/* Extracts a QUIC Connection ID from a buffer in the long header packet. */
> +static int quic_packet_get_connid(struct quic_conn_id *connid, u8 **pp,
> +				  u32 *plen)
> +{
> +	u64 len;
> +
> +	if (!quic_get_int(pp, plen, &len, 1) ||
> +	    len > *plen || len > QUIC_CONN_ID_MAX_LEN)
> +		return -EINVAL;

[Severity: Low]
Should the 20-byte connection ID limit be applied before we know the
version is supported?

quic_packet_get_long_header() is called from quic_packet_get_sock() and
from quic_packet_listen_process(). Both calls happen before the
!quic_packet_compatible_versions(version) branch that sends Version
Negotiation.

So a long-header packet with an unknown version and a CID longer than
20 bytes is dropped as an invalid header, and no Version Negotiation is
sent.

RFC 9000 section 17.2 limits CIDs to 20 bytes only for version 1.
Sections 5.2.2 and 6.1 say a server SHOULD be able to read longer CIDs
from other versions so that it can send Version Negotiation.

[ ... ]

> +/* Process PMTU reduction event on a QUIC socket. */
> +void quic_packet_rcv_err_pmtu(struct sock *sk)
> +{

[ ... ]

> +	info = clamp(paths->mtu_info, QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);
> +	/* If PLPMTUD is not enabled, update MSS using route and ICMP info. */
> +	if (!paths->plpmtud_interval) {
> +		if (quic_packet_route(sk))
> +			return;
> +
> +		dst = __sk_dst_get(sk);
> +		if (dst) {
> +			dst->ops->update_pmtu(dst, sk, NULL, info, true);
> +			/* Re-read actual MTU after update_pmtu, which may have
> +			 * rejected the increase. Only use values accepted by
> +			 * route layer to prevent spoofed ICMP from raising MSS.
> +			 */
> +			info = clamp(dst_mtu(dst), QUIC_PATH_MIN_PMTU,
> +				     QUIC_PATH_MAX_PMTU);
> +		}
> +		quic_packet_mss_update(sk, info - packet->hlen);

[Severity: High]
Does this ever lower the MSS when PLPMTUD is disabled?

With skb == NULL, ip_rt_update_pmtu() builds its flow key through
ip_rt_build_flow_key()->build_sk_flow_key(), which takes the
destination from the socket:

net/ipv4/route.c:build_sk_flow_key() {
    ...
	__be32 daddr = inet->inet_daddr;
    ...
}

When there is no packet header, __ip6_rt_update_pmtu() does the same
with sk->sk_v6_daddr.

Nothing in net/quic sets inet_daddr or sk_v6_daddr, and ip6_dst_store()
is called with daddr_set false. The exception would then be created for
0.0.0.0 or :: instead of the peer.

Even with the right key there is a second problem. When
update_or_create_fnhe() creates a new exception, it only marks the
cached routes obsolete:

	WRITE_ONCE(rt->dst.obsolete, DST_OBSOLETE_KILL);

It does not change their MTU. The IPv6 path inserts a new RTF_CACHE
route and leaves the old dst unchanged.

So re-reading dst_mtu(dst) on the same cached dst would return the old
MTU, and quic_packet_mss_update() keeps the old MSS.

If that's right, the v17 change to re-read the MTU after update_pmtu()
makes the ICMP-driven reduction a no-op. plpmtud_interval is 0 by
default, so a path whose PMTU is below the local MTU could stall:
full-size DF packets are dropped and the PTBs are ignored.

For comparison, SCTP temporarily sets the socket daddr around
update_pmtu() (to_sk_daddr()), and inet_csk_update_pmtu() re-checks the
dst with __sk_dst_check() afterwards. Is something similar needed here?

[ ... ]

> +	pr_debug("%s: alpn_len: %d\n", __func__, alpn->len);

[Severity: Low]
This isn't a bug, but alpn->len is a u32 in struct quic_data, so %u
would match it. The v16 changelog made the same fix in quic_packet_rcv().

[ ... ]

> +/* Work function to process packets in the deferred list. */
> +static void quic_packet_deferred_work(struct work_struct *work)
> +{
> +	struct quic_sock *qs = container_of(work, struct quic_sock, work);
> +	struct sock *sk = &qs->inet.sk;
> +	struct sk_buff_head *head;
> +	struct sk_buff *skb;
> +
> +	lock_sock(sk);
> +	head = &quic_packet(sk)->deferred_list;
> +	while ((skb = __skb_dequeue(head)) != NULL)
> +		quic_packet_process(sk, skb, GFP_KERNEL);

[Severity: Low]
Was the cond_resched() from the v12 changelog lost in the v15 rework?
The v12 entry reads:

  "Call cond_resched() in the loop inside quic_packet_backlog_work()."

Each iteration here can run synchronous AEAD decryption (cb->sync = 1),
GFP_KERNEL allocations and token verification, all under lock_sock().

On the quic_listen_sock_switch() path, the listener lock is dropped and
re-taken in the middle of this loop. Under sustained traffic, packets
processed from the socket backlog in that window can keep adding to
deferred_list, so the loop keeps running.

> +	release_sock(sk);
> +	sock_put(sk);
> +}

[ ... ]

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index 0173416d0368a..c75d2dcaba9d4 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c
> @@ -24,6 +24,319 @@ static void quic_enter_memory_pressure(struct sock *sk)

[ ... ]

> +int quic_request_sock_backlog_tail(struct sock *sk,
> +				   struct quic_request_sock *req,
> +				   struct sk_buff *skb)
> +{
> +	u32 limit = sk->sk_rcvbuf / sk->sk_max_ack_backlog;
> +	int len = skb->truesize;
> +
> +	limit =  max_t(u32, limit, QUIC_MIN_UDP_PAYLOAD * 4);
> +	if (req->blen + len > limit || !__sk_rmem_schedule(sk, len, false)) {
> +		QUIC_INC_STATS(sock_net(sk), QUIC_MIB_PKT_RCVDROP);
> +		kfree_skb(skb);
> +		return -ENOBUFS;
> +	}
> +
> +	QUIC_SKB_CB(skb)->backlog = 1;
> +	skb_set_owner_r(skb, sk);

[Severity: Low]
Can this push sk_forward_alloc negative when the skb is already charged
to this listener?

Consider a second Initial packet for the same connection that was
deferred through quic_packet_deferred_schedule(). Its destructor is
already sock_rfree, and in quic_packet_listen_process() it takes this
path, which skips skb_set_owner_sk_safe():

	req = quic_request_sock_lookup(sk);
	if (req) /* If request sock already exists, enqueue packet directly. */
		goto out;

In quic_request_sock_backlog_tail(), __sk_rmem_schedule() reserves the
memory first. skb_set_owner_r() then orphans the skb
(sock_rfree()->sk_mem_uncharge()->sk_mem_reclaim()) and charges it
again.

The reclaim can return the pages that were just reserved, so the
sk_mem_charge() that follows can leave sk_forward_alloc below zero.

For example, start with forward_alloc 2000 and truesize 2304:

  schedule adds a page:      6096
  uncharge:                  8400
  reclaim leaves:            208
  charge leaves:             -2096

Would orphaning the skb before the __sk_rmem_schedule() check avoid
this?

> +	__skb_queue_tail(&req->backlog_list, skb);
> +	req->blen += len;

[ ... ]

> +	/* Look up accepted socket matching packet addresses and DCID. */
> +	local_bh_disable();
> +	sk = quic_sock_lookup(skb, &packet->daddr, &packet->saddr,
> +			      quic_path_usock(quic_paths(sk), 0),
> +			      &packet->dcid);
> +	if (!sk)
> +		goto out;
> +
> +	/* Found a matching accept socket. Process packet with this socket. */
> +	skb_orphan(skb);
> +	bh_lock_sock_nested(sk);
> +	if (sock_owned_by_user(sk)) {
> +		/* Socket is busy (owned by user context): queue to backlog. */
> +		if (sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf))) {
> +			QUIC_INC_STATS(sock_net(sk), QUIC_MIB_PKT_RCVDROP);
> +			kfree_skb(skb);
> +		}
> +	} else {
> +		/* Socket not busy: process immediately. */
> +		sk->sk_backlog_rcv(sk, skb); /* quic_backlog_rcv(). */
> +	}

[Severity: Medium]
Should cb->backlog and cb->sync be cleared before the skb is handed to
the accept socket here?

When this runs from quic_packet_deferred_work(), the skb came off
deferred_list with cb->backlog = 1. An skb that went through
quic_listen_sock_switch() also has cb->sync = 1 and cb->resume = 1, set
by quic_packet_get_alpn().

The call path here is atomic:

quic_packet_deferred_work()
  quic_packet_process()
    quic_packet_listen_process()
      quic_accept_sock_exists()
        local_bh_disable()
        bh_lock_sock_nested(accept_sk)
        accept_sk->sk_backlog_rcv()
          quic_packet_process(..., GFP_ATOMIC)

Elsewhere the patch treats cb->backlog as meaning the context can sleep,
for example in quic_packet_deferred_schedule():

	if (cb->backlog)
		return 0;

quic_crypto_decrypt() also checks !cb->backlog before doing a key
update, and cb->sync forces a blocking crypto wait.

The handshake and app handlers are still stubs in this patch. Once they
are filled in, could these leftover flags make them sleep while holding
the spinlock with BH disabled?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1792164438.git.lucien.xin%40gmail.com
