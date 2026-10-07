Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6303242A4;
	Wed,  7 Oct 2026 01:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335132; cv=none; b=ArpQ2e9deSg9C5lM4uEY9+WdF/ZHnY+oeJTBU/aSVv85i+nba1DVMcoPus/2eL9MKXfyQiEpBpi3IPVqWP+vkqU2+imnax4rr0KK62wAOYUorEIp0kd/VkCk1FoNxz3gu/ndcovu1WwxcmevZBHwLpqK1mTrQvVmpuNXkiD+4zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335132; c=relaxed/simple;
	bh=ia7j+NEGppCnVYgcSFDOz9m3neGQcMCEGrcjuGY/wh0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NIQfnieKx/A1Xkv/Ot/OYSKrg3hE9DZ4r+pqQlxm7S8J0EYI+d3VSviZIW5ckEMCOZs81DNAjssMnyb4aksez3Z3D2gBwY3OH30Ntb8e7pcN5w9YXYnAp8jg5x1U/I+xdWPfR3JBGsJ0iG0JTYCgpaO6beaAvPXx2iSgLaSHv/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEdchZNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEdchZNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0571F0089C;
	Wed,  7 Oct 2026 01:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335131;
	bh=5KJkGIiJUXqsGCMXxzcT6xybHSwsTz7Llo9tC01xbQg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SEdchZNh3Yg+bID1bcUlQvLZ4hDFy2wF5vF4oq+2Na5FY/JHFKTVAjtl0h9DY34XM
	 g3m7ekLwZUpm6BTsmWH4/RW2h8NKSW7MfPYWOj+HmeghEkU4x2Tki5u3CsiIAH1VK5
	 8hs+GJvGCN6cxgiaFfC4qY2PifB0ljrK50qL3f2k5toazKFLzGjdNytj/nWGCtmnZN
	 kFVxociwA6lod4AdfG8ufELUhFVFMdpmxI9NxljL2fK0+afeqws8tqpEG6lwjtkUbm
	 lFQBhYNAYbRnuQvmBSoMSB0LAmRIVLnZCM5k7aFmcTI7HxwYwpIIZZf5eZLxxRlRdz
	 0BAwaWq55+UyA==
Subject: Re: [PATCH net-next v16 15/15] quic: add packet parser base
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
Date: Wed, 07 Oct 2026 01:05:28 +0000
Message-ID: <179133512872.434549.11248338098140405125@kernel.org>
In-Reply-To: =?utf-8?q?=3C333607babf249e24fe90625d7abb7625b97c0b50=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C333607babf249e24fe90625d7abb7625b97c0b50=2E17912270?=
 =?utf-8?q?50=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 3 · Low: 4

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The permanent commit message (the part above '---') describes
  much less than the patch does, and some of it is wrong.
- [Medium] When PLPMTUD is disabled (paths->plpmtud_interval == 0, the
  default in this tree because nothing sets it),…
- [Medium] quic_packet_listen_process() replies to, and creates state
  for, long-header packets of any size.
- [Low] The kernel-doc for quic_listen_sock_lookup() in net/quic/socket.c
  says that when several listening sockets share the same address, port…
- [Low] The patch adds definitions that nothing in this commit uses.
- [Low] struct quic_packet in net/quic/packet.h documents `daddr` as
  'Dest address from received packet' and `saddr` as 'Source address…
- [Low] The header comment of quic_packet_deferred_work() (packet.c:776)
  reads 'Work function to process packets in the backlog queue', but the…

--

quic: add packet parser base

This commit adds the QUIC receive path. quic_packet_rcv() finds the
owning socket by connection ID, by address, or through the listener, then
passes the packet to quic_packet_process(). The patch also adds
listen-side Initial handling, request sockets, ALPN-based listener
switching through a per-socket work item, and ICMP Packet Too Big
handling through quic_packet_rcv_err() and quic_packet_rcv_err_pmtu().

> This patch uses 'quic_packet' to handle packing of QUIC packets on the
> receive (RX) path.

[ ... ]

> - quic_packet_get_alpn(): Parse the ALPN from a client Initial packet,
>   then locate the appropriate listener using the ALPN.

[ ... ]

> - quic_packet_rcv_err_pmtu(): Find the socket and update the PMTU via
>   quic_packet_mss_update().

[Severity: Medium]
Some parts of the commit message don't match the code.

Should "packing" in the first sentence be "parsing"?

quic_packet_get_alpn() installs the Initial keys, decrypts the packet and
parses the ALPN list. It doesn't look up a listener. The lookup and the
switch happen in quic_listen_sock_switch() in net/quic/socket.c.

For ICMP errors, the socket lookup is done in quic_packet_rcv_err(), not
in quic_packet_rcv_err_pmtu().

The message also leaves out much of what the patch adds:

  - quic_packet_listen_process(), with token verification and the
    Stateless Reset, Version Negotiation, Retry and CONNECTION_REFUSED
    triggers
  - struct quic_request_sock and quic_request_sock_lookup(),
    quic_request_sock_create() and quic_request_sock_backlog_tail(),
    which charge sk_ack_backlog and receive memory
  - the per-socket work_struct with deferred_list/backlog_list on
    quic_wq, and flush_work() in quic_packet_free()
  - quic_accept_sock_exists() and quic_listen_sock_switch()
  - quic_backlog_rcv() now processing packets instead of dropping them
  - the ALPN free moving from quic_destroy_sock() to quic_sock_destruct()

Most of this is described only in the changelog below the --- line, and
git am drops that part. Could the permanent commit message cover these
pieces?

> diff --git a/net/quic/packet.c b/net/quic/packet.c
> index 56d2b8df292a0..673f1cd491438 100644
> --- a/net/quic/packet.c
> +++ b/net/quic/packet.c
> @@ -14,6 +14,781 @@
>  
>  #define QUIC_HLEN		1
>  
> +#define QUIC_LONG_HLEN(dcid, scid) \
> +	(QUIC_HLEN + QUIC_VERSION_LEN + 1 + (dcid)->len + 1 + (scid)->len)

[Severity: Low]
This isn't a bug, but nothing in this patch uses QUIC_LONG_HLEN().

Two of the new struct quic_packet members are in a similar state.

backlog_list is described as "Packets waiting for crypto keys". It is
only initialized in quic_packet_init() and purged in quic_packet_free(),
and nothing enqueues to it yet.

quic_packet_listen_process() reads validate_peer_address, but nothing
ever sets it, so the token validation and Retry branch can't be reached:

	if (packet->validate_peer_address) {

The changelog says these are staged for the next patchset. Could they be
added together with the code that uses them? Failing that, could the
backlog_list comment describe what the field does today?

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
> +		if (dst)
> +			dst->ops->update_pmtu(dst, sk, NULL, info, true);
> +		quic_packet_mss_update(sk, info - packet->hlen);

[Severity: Medium]
Can a Packet Too Big that reports a larger MTU than the current path MTU
raise the MSS here?

info is only clamped to [QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU], and
quic_packet_mss_update() stores whatever it is given. The route layer
ignores increases:

net/ipv4/route.c:__ip_rt_update_pmtu() {
    ...
	old_mtu = ipv4_mtu(dst);
	if (old_mtu < mtu)
		return;
    ...
}

__ip6_rt_update_pmtu() also returns early when mtu >= dst6_mtu(dst).

Nothing in this tree sets plpmtud_interval, so this branch is the
default. A delayed or spoofed ICMP that arrives through quic_udp_err()
-> quic_packet_rcv() -> quic_packet_rcv_err() -> quic_packet_rcv_err_pmtu()
and claims 9000 on a 1500-byte path would set the MSS to 9000 - hlen.

The route is left unchanged, so the cached dst stays valid. Later
quic_packet_route() calls then get 1 back from quic_flow_route() and
never recompute the MSS from dst_mtu().

Would it be safer to re-read dst_mtu(dst) after update_pmtu(), or to only
ever lower the MSS, as tcp_v4_mtu_reduced() does?

[ ... ]

> +static int quic_packet_listen_process(struct sock *sk, struct sk_buff *skb,
> +				      gfp_t gfp)
> +{

[ ... ]

> +	if (!quic_packet_compatible_versions(version)) {
> +		/* rfc9000#section-6.1:
> +		 *
> +		 * If the version selected by the client is not acceptable to
> +		 * the server, the server responds with a Version Negotiation
> +		 * packet. This includes a list of versions that the server
> +		 * will accept.
> +		 */
> +		err = quic_packet_version_create_and_xmit(sk, gfp);
> +		consume_skb(skb);
> +		return err;
> +	}

[Severity: Medium]
Is a minimum datagram size check missing before this reply?

RFC 9000 sections 5.2.2 and 6.1 say a server MUST drop smaller packets
that specify an unsupported version. Section 14.1 says a server MUST
discard an Initial packet in a UDP datagram whose payload is smaller than
1200 bytes.

On the receive path nothing compares skb->len with QUIC_MIN_UDP_PAYLOAD.
quic_packet_rcv() and quic_packet_get_sock() only require
skb->len >= QUIC_HLEN.

Packets of any size can therefore reach the Version Negotiation reply
above, the Retry and refuse-close paths, and this call further down:

	req = quic_request_sock_create(sk, &odcid, retry, gfp);

When ALPN demux is disabled, the Length field isn't parsed at all. A
16-byte spoofed long-header Initial (8-byte DCID, empty SCID, empty
token) would allocate a quic_request_sock and call sk_acceptq_added().

Could a burst of these fill the accept queue, so that legitimate clients
hit sk_acceptq_is_full() and get CONNECTION_REFUSED?

Once the Version Negotiation and Retry builders are implemented, would
they also reply to spoofed sources for these small datagrams?

[ ... ]

> +/* Work function to process packets in the backlog queue. */
> +static void quic_packet_deferred_work(struct work_struct *work)
> +{

[ ... ]

> +	head = &quic_packet(sk)->deferred_list;

[Severity: Low]
This isn't a bug, but the comment says "backlog queue" while the function
drains deferred_list. struct quic_packet now has a separate backlog_list,
so should the comment say deferred list instead?

[ ... ]

> diff --git a/net/quic/packet.h b/net/quic/packet.h
> index cf0b97112d9b1..4a7bcf959e997 100644
> --- a/net/quic/packet.h
> +++ b/net/quic/packet.h
> @@ -14,6 +14,8 @@ struct quic_packet {
>  	union quic_addr daddr;    /* Dest address from received packet */
>  	union quic_addr saddr;    /* Source address from received packet */

[Severity: Low]
These comments seem reversed compared to how this patch fills the fields.

quic_get_msg_addrs() takes (skb, da, sa), and quic_packet_listen_process()
calls it like this:

	quic_get_msg_addrs(skb, &packet->saddr, &packet->daddr);

The inline comment there says "Read Destination address (packet->saddr)
and Source address (packet->daddr)".

So packet->saddr holds the received packet's destination (local) address
and packet->daddr holds its source (peer) address. The users,
quic_crypto_verify_token(), quic_accept_sock_exists() and
quic_listen_sock_switch(), all follow that convention.

Could the struct comments be changed to match?

[ ... ]

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index 0173416d0368a..be8dc30f8208a 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c

[ ... ]

> +/* Find the listening QUIC socket for an incoming packet.
> + *
> + * This function searches the QUIC socket table for a listening socket that
> + * matches the dest address and port, and the ALPN(s) if presented in the
> + * ClientHello.  If multiple listening sockets are bound to the same address,
> + * port, and ALPN(s) (e.g., via SO_REUSEPORT), this function selects a socket
> + * from the reuseport group.

[Severity: Low]
This isn't a bug, but the function body doesn't select from a reuseport
group.

It walks the hash chain with sk_nulls_for_each_rcu() and returns the
first specific-address match, or an ANY-address candidate. It never calls
reuseport_select_sock() or looks at sk_reuseport_cb.

The v16 changelog says reuseport_select_sock() moved to the next
patchset. Should this part of the comment move with it?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com
