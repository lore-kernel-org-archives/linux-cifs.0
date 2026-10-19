Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445393;
	b=VZAW6Xpoi9dKX/89881g5ZhUaiDuA7OREfdoWajVR3ByljDsFRckQUiMKjSyiVW1F3dg
	 WiqnoakfYijkMshlOke4Ek2KKwxZf9556hk/IeN40ZSxWEDSxEoD60G4UcuifQjC1YqU8
	 Id8NmIt04Cx6GPsOyu4kFKpAHV8YOyOIwiLii7cNBI922jyonWymPyjDelCu/4Wc9LOuI
	 wqH5ChUx1bYZX3dsFap7hD2lUPZemVoS/2+CgonLunUGpCPmL+5SUaH0mnrnIRaJTkPdv
	 4tjzY7pJzJtBhdTf6WFih9pxX8xmFmjuJPIOpMxWWY7U9ZPBZJwk4PA+tEvKD023a2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445393;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=odS2zyccxmV+JZ7Tq4Ok5FJ8aGGiNb2b8pM1e9hYks8=;
	b=KCa1h+FULaqBJ/47bLR2TUTQnUXAhLBIyQde0OPtoAFmY3IAM7M9+xaxgQGDBULwNHhv
	 j0f+QP1r+gXbphLiRKnoGGjrabLAhnUeOFPozRXBAOwSvmBCaq5d1RgV3J7JO3UZK3KuZ
	 yrD8vZ1Zs9S//5472tBycrU4jRRNhuBqYA4SzZY+ATHZy+qeV2wNVP1XtU+jf8/xD5870
	 sh4M0DCbYfE8ESmkbo0VCgA4DNTcCKHvO6c+2AQ6TmpD8umOhVIfI/yBqQSz6UcJQ0ZFd
	 lJnv7aPxsMQwhZGqRfLqH9/ZZCdRaMGBsyfh+qp9rS0q4kpkbhd4xr8HBayePy4vW+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eGUTpIKp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519C8606A31A;
	Mon, 19 Oct 2026 21:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eGUTpIKp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAEA1F000C4;
	Mon, 19 Oct 2026 21:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792445392;
	bh=odS2zyccxmV+JZ7Tq4Ok5FJ8aGGiNb2b8pM1e9hYks8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=eGUTpIKplpR8zHtdrOIfnNPYBYscYCnGi97uW9YAcReWe5sLyWWrg3ovcd8yhAKd9
	 91HHkpugkt63XLSmgbeLoN41Dwdq71nk08GNxccJ+toQkVC1s1M1NRFZI3xMd0pV3w
	 HEiDtz8GLXK2HXG8y27IZLvtOLUrIMPolhnvX+2pOylJSjtERXFlnajPxvisLC5wC4
	 Li4Ap/v7vqj6gUrzzvCv+hWtO9p3KdzMto95aqe8X+PWH7T7XQrYB8u73FcBGUVsaD
	 dI/yrFE5AGyIoLo9XMjN+dVjZHbNNeicw2WMDlCb9wc88GmiKdOn21CFKxi509OTG8
	 bGT0dg32cxFAw==
Subject: Re: [PATCH net-next v17 04/15] quic: provide family ops for address
 and protocol
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
Date: Mon, 19 Oct 2026 21:29:50 +0000
Message-ID: <179244539028.3135.8632269420764172979@kernel.org>
In-Reply-To: =?utf-8?q?=3C89a17e38fca0c84eb23ccde147942e44034ce05b=2E1792164?=
 =?utf-8?q?438=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C89a17e38fca0c84eb23ccde147942e44034ce05b=2E17921644?=
 =?utf-8?q?38=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_common_setsockopt() (net/quic/family.c:416) passes every
  SOL_IP/SOL_IPV6 option to the core IP stack without filtering.
- [Low] The commit message describes the patch as only adding
  family.{c,h} helpers (routing, transmit, address parsing and…
- [Low] When routing picks a link-local source for a wildcard sa,
  quic_v6_flow_route() (net/quic/family.c:131) sets…

--

quic: provide family ops for address and protocol

This patch adds net/quic/family.{c,h} with IPv4/IPv6 helpers for routing,
UDP tunnel transmit, address parsing and comparison, and UDP socket config
setup. It also connects quic_inet_getname() to quic_get_sk_addr(), and sends
setsockopt/getsockopt calls for any level other than SOL_QUIC to the
IP/IPv6 handlers.

> Introduce QUIC address and protocol family operations to handle IPv4/IPv6
> specifics consistently. The new family.{c,h} provide helpers for routing,
> skb transmit handling, address parsing and comparison and UDP socket config
> initializing etc.

[Severity: Low]
This isn't a bug, but the commit message only talks about new helpers. The
patch also changes three socket entry points that userspace can see.

quic_inet_getname() in net/quic/protocol.c used to return -EOPNOTSUPP. It
now calls quic_get_sk_addr(), so getsockname() and getpeername() return
real addresses. IPv4-mapped results on AF_INET6 sockets are also rewritten
to sockaddr_in.

quic_setsockopt() and quic_getsockopt() in net/quic/socket.c now pass every
level other than SOL_QUIC to ip_setsockopt()/ipv6_setsockopt() and
ip_getsockopt()/ipv6_getsockopt(). That makes the full SOL_IP and SOL_IPV6
option sets reachable on QUIC sockets.

The errno for unknown levels changes as well. setsockopt() now returns
-ENOPROTOOPT. getsockopt() returns -EOPNOTSUPP from do_ip_getsockopt() on
IPv4 sockets and -ENOPROTOOPT from ipv6_getsockopt() on IPv6 sockets.

Could the commit message mention these changes?

> diff --git a/net/quic/family.c b/net/quic/family.c
> new file mode 100644
> index 0000000000000..dc41a0ae07086
> --- /dev/null
> +++ b/net/quic/family.c
> @@ -0,0 +1,441 @@

[ ... ]

> +static int quic_v6_flow_route(struct sock *sk, union quic_addr *da,
> +			      union quic_addr *sa, struct flowi *fl)
> +{

[ ... ]

> +	fl6->flowi6_proto = IPPROTO_UDP;
> +	fl6->flowi6_oif = quic_get_dev_if(sk, da);

[ ... ]

> +	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, NULL);
> +	if (IS_ERR(dst))
> +		return PTR_ERR(dst);
> +
> +	if (quic_v6_is_any_addr(sa)) {
> +		sa->v6.sin6_family = AF_INET6;
> +		sa->v6.sin6_addr = fl6->saddr;
> +		if ((ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_LINKLOCAL))
> +			sa->v6.sin6_scope_id = fl6->flowi6_oif;

[Severity: Low]
Is fl6->flowi6_oif the right value to store as the scope id here?

It holds the oif requested before the lookup, which is
quic_get_dev_if(sk, da). The ip6_dst_lookup_flow()->ip6_dst_lookup_tail()
path doesn't appear to write the chosen egress device back into it.

On the fib6 rules path, l3mdev_update_flow() can also clear it when the oif
is an L3 master:

	if (netif_is_l3_master(dev))
		fl->flowi_oif = 0;

The IPv4 side is different. ip_route_output_flow() sets
flp4->flowi4_oif = rt->dst.dev->ifindex after the lookup.

Two cases can store a link-local source with sin6_scope_id == 0: an unbound
socket with a link-local destination that has no scope, or routing picking
a link-local source.

After that, quic_get_dev_if(sk, sa) falls back to sk->sk_bound_dev_if (0).
quic_v6_udp_conf_init() then asks to bind a link-local local_ip6 with
bind_ifindex 0, which __inet6_bind() rejects. The link-local scope check in
quic_v6_cmp_sk_addr() is also skipped, because one side's scope is 0.

Would dst_dev(dst)->ifindex record the real egress interface instead?

> +	}
> +	ip6_dst_store(sk, dst, false, false);
> +	return 0;
> +}

[ ... ]

> +int quic_common_setsockopt(struct sock *sk, int level, int optname,
> +			   sockptr_t optval, unsigned int optlen)
> +{
> +	return quic_pf_ipv4(sk) ?
> +	       ip_setsockopt(sk, level, optname, optval, optlen) :
> +	       ipv6_setsockopt(sk, level, optname, optval, optlen);
> +}

[Severity: Medium]
This passes every SOL_IP and SOL_IPV6 option to the core IP stack. The
QUIC route and transmit helpers above only use part of the resulting
socket state: tos/tclass, uc_ttl/hop_limit, pmtudisc, SNDFLOW flow labels,
sk_bound_dev_if, mark and uid.

Can setsockopt() then report success for options that never take effect on
QUIC traffic? Some examples follow.

IP_OPTIONS sets inet->inet_opt. However, quic_v4_lower_xmit() goes through
udp_tunnel_xmit_skb()->iptunnel_xmit(), which always builds a header with
no options:

net/ipv4/ip_tunnel_core.c:iptunnel_xmit() {
    ...
	iph->ihl	=	sizeof(struct iphdr) >> 2;
    ...
}

quic_v4_flow_route() also does no source route handling.

IPV6_RTHDR, IPV6_HOPOPTS and IPV6_DSTOPTS set np->opt, but
udp_tunnel6_xmit_skb() never adds extension headers. The v17 changelog
notes this when it drops fl6_update_dst(), yet these options are still
accepted.

IP_UNICAST_IF (inet->uc_index) and IPV6_UNICAST_IF (np->ucast_oif) are
ignored, because quic_get_dev_if() only looks at the link-local scope id
and sk_bound_dev_if. UDP does use ucast_oif in udpv6_sendmsg():

	fl6->flowi6_oif = READ_ONCE(np->ucast_oif);

The sticky IPV6_PKTINFO (np->sticky_pktinfo) and IP_TRANSPARENT are not
checked either.

Would an allow-list in quic_common_setsockopt() make sense, returning
-EOPNOTSUPP for options the QUIC path can't honour, as MPTCP does?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1792164438.git.lucien.xin%40gmail.com
