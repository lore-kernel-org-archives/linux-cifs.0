Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5425199E89;
	Wed,  7 Oct 2026 01:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335107; cv=none; b=hZ/ED+uAX6FAerxZy1lWdrPAEPcmWYUcUpLC/ycbqc69UC1/BdKhNNftuZggMPxhgx28CZgLE9sYq94tyo0FcEJLhIjJhu0DDpCINO31AKtSfPU3OGWFx79ST3qEl4CLT+M0I4XhA1YXqaC/hClg5RayiP3PMnCFZdTTj9HWXKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335107; c=relaxed/simple;
	bh=ku6XWV2uOWzb6+BmdFwfpIVkPQr8J7/JqX16jFeXTmU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kqG25yUwB4dHRHo/d1QJL9iycJivG86rCG9eMqnd/DRl1mftz6QxgS5rXH6ID2ryTGTtqmVFq+jf1BcRxT9mHsI6itOUkTr+InUW1TXncvbC9wPxMK/cCbilto8Im5VnWWtQFeYfAMmQCTRC5NtfWXN2SlYYZ1WqIDir6V3+FNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbwtd7SC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbwtd7SC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900E11F0089B;
	Wed,  7 Oct 2026 01:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335105;
	bh=7pKGzS9zy5h9qLYDkH+KCZR1TfkZYVHRxwSdnhTAYAA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nbwtd7SClRswzH9H5nGfv9sSZbmWcozgRVV0wGIHfr1aRW0VZZxH190T9cfrk+Z9E
	 TD6naUSJYcQmdYmI0ieG81ui0R13XfIwRQIFE3X2EENsW2Lec2BIKUXAIyl83aypwa
	 4ZRPvKTHRYG7poludz4GTtIQ6XJvLnFITqG1QhaDABq/2fcSmZ7u8T76T5IplW57ou
	 kqeRNryrVRuG6Vhm/QuQftHjLyBcHStaQAdTX4TLkQHbekwvxR6amzC2cS4svv0xAb
	 uwKIKSS0A+mCX8a4DCc81r+RakqcDOHV/gM8QYqbZSvKOaBSevt5UecKQYD0qjMyRt
	 4pIJbtzcAQJ4A==
Subject: Re: [PATCH net-next v16 04/15] quic: provide family ops for address
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
Date: Wed, 07 Oct 2026 01:05:03 +0000
Message-ID: <179133510313.434549.8082953410374436828@kernel.org>
In-Reply-To: =?utf-8?q?=3Cfff91f2c9ae1bdbbf76aa46c618b440c896d131f=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Cfff91f2c9ae1bdbbf76aa46c618b440c896d131f=2E17912270?=
 =?utf-8?q?50=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] An unprivileged sticky IPv6 routing header makes the route
  lookup and the transmitted packet disagree, so packets go to the real…
- [Medium] IP_TTL and IPV6_UNICAST_HOPS are accepted but ignored on
  transmit.
- [Low] The commit message leaves out user-visible changes and describes
  the code inaccurately.
- [Low] IP_OPTIONS is accepted and stored but never sent.

--

quic: provide family ops for address and protocol

This commit adds net/quic/family.{c,h} with IPv4/IPv6 helpers for route
lookup, UDP tunnel transmit, address parsing and comparison, and UDP port
config setup. It also connects quic_inet_getname() and the setsockopt()
and getsockopt() levels other than SOL_QUIC to the inet and inet6 code.

> Introduce QUIC address and protocol family operations to handle IPv4/IPv6
> specifics consistently, similar to SCTP. The new quic_family.{c,h} provide
> helpers for routing, skb transmit handling, address parsing and comparison
> and UDP socket config initializing etc.

[Severity: Low]
This isn't a bug, but the patch creates net/quic/family.{c,h}, not
quic_family.{c,h}.

The wording "family operations ... similar to SCTP" looks left over from
before v3. That version replaced the ops abstraction with if statements.

Could the message also mention the changes userspace can see?
quic_inet_getname() used to return -EOPNOTSUPP. It now returns real
addresses through inet_getname() or inet6_getname().

quic_setsockopt() and quic_getsockopt() now send every level other than
SOL_QUIC to ip_setsockopt()/ipv6_setsockopt() and
ip_getsockopt()/ipv6_getsockopt(). All SOL_IP and SOL_IPV6 options can
now be set on QUIC sockets. An unknown level also returns -ENOPROTOOPT
now, where it used to return -EOPNOTSUPP.

> diff --git a/net/quic/family.c b/net/quic/family.c
> new file mode 100644
> index 0000000000000..f5d859b337b10
> --- /dev/null
> +++ b/net/quic/family.c
> @@ -0,0 +1,449 @@

[ ... ]

> +static int quic_v6_flow_route(struct sock *sk, union quic_addr *da,
> +			      union quic_addr *sa, struct flowi *fl)
> +{
> +	struct ipv6_pinfo *np = inet6_sk(sk);

[ ... ]

> +	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
> +
> +	rcu_read_lock();
> +	final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
> +	rcu_read_unlock();
> +
> +	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
> +	if (IS_ERR(dst))
> +		return PTR_ERR(dst);

[Severity: High]
Can a sticky routing header make the route lookup disagree with the packet
that is actually sent?

quic_common_setsockopt() now passes SOL_IPV6 to ipv6_setsockopt(). That
lets an unprivileged user set IPV6_RTHDR, because ipv6_set_opt_hdr() only
requires CAP_NET_RAW for the other option headers:

net/ipv6/ipv6_sockglue.c:ipv6_set_opt_hdr() {
    ...
	/* hop-by-hop / destination options are privileged option */
	if (optname != IPV6_RTHDR && !sockopt_ns_capable(net->user_ns, CAP_NET_RAW))
		return -EPERM;
    ...
}

Suppose np->opt holds a type-4 SRH or a type-2 routing header. Then
fl6_update_dst() replaces fl6->daddr with a segment Y that the user picks.
ip6_dst_lookup_flow() looks up a route for Y and then puts the real
destination X back into fl6->daddr. ip6_dst_store() caches that dst.

quic_v6_lower_xmit() then calls udp_tunnel6_xmit_skb(). That helper builds
a plain IPv6 header addressed to X and never adds the np->opt extension
headers:

net/ipv6/ip6_udp_tunnel.c:udp_tunnel6_xmit_skb() {
    ...
	ip6h->nexthdr     = IPPROTO_UDP;
	ip6h->hop_limit   = ttl;
	ip6h->daddr	  = *daddr;
	ip6h->saddr	  = *saddr;

	ip6tunnel_xmit(sk, skb, dev, ip6cb_flags);
}

Doesn't this send packets to X using the device, gateway and MTU of the
route for Y? Neighbour discovery for X would then run on Y's link. Local
route policy for X, such as prohibit, blackhole, unreachable or policy
routes, would also be bypassed.

UDP and SCTP avoid this because they pass opt to
ip6_append_data()/ip6_xmit(), which put the routing header on the wire.

The transmit path is only connected in the next patchset. This code is
the same at the end of this series.

Should fl6_update_dst() be dropped here, since the tunnel transmit cannot
send extension headers? Alternatively, should QUIC sockets reject sticky
routing headers?

[ ... ]

> +static void quic_v4_lower_xmit(struct sock *sk, struct sk_buff *skb,
> +			       struct flowi *fl)
> +{

[ ... ]

> +	if (cb->ecn)
> +		tos = (tos & ~INET_ECN_MASK) | cb->ecn;
> +	ttl = (u8)ip4_dst_hoplimit(dst);

[Severity: Medium]
Are IP_TTL and IPV6_UNICAST_HOPS silently ignored here?

Through quic_common_setsockopt(), setsockopt(SOL_IP, IP_TTL) stores its
value in inet->uc_ttl. setsockopt(SOL_IPV6, IPV6_UNICAST_HOPS) stores its
value in np->hop_limit. Both calls succeed, and getsockopt(IP_TTL) returns
the stored value.

However, this function always takes the TTL from the route.
quic_v6_lower_xmit() does the same:

	ttl = (u8)ip6_dst_hoplimit(dst);

UDP and SCTP apply these options through ip_select_ttl() and
ip6_sk_dst_hoplimit(). These functions already apply IP_TOS and
IPV6_TCLASS through inet_sk(sk)->tos and inet6_sk(sk)->tclass.

Should the hop limit use the socket setting as well?

> +	udp_tunnel_xmit_skb((struct rtable *)dst, sk, skb, fl4->saddr,
> +			    fl4->daddr, tos, ttl, df, fl4->fl4_sport,
> +			    fl4->fl4_dport, false, false, 0);
> +}

[Severity: Low]
What happens to IP_OPTIONS on a PF_INET QUIC socket?

ip_setsockopt(IP_OPTIONS) parses the options and stores them in
inet->inet_opt, and getsockopt(IP_OPTIONS) returns them.

udp_tunnel_xmit_skb() ends up in iptunnel_xmit(). That function never
reads inet->inet_opt and builds a header with no options:

net/ipv4/ip_tunnel_core.c:iptunnel_xmit() {
    ...
	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
    ...
	iph->ihl	=	sizeof(struct iphdr) >> 2;
    ...
}

Options such as Record Route or Timestamp are reported as set, but they
never appear in any packet. quic_encap_len() also reserves no room for
them.

Should QUIC sockets reject IP_OPTIONS?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com
