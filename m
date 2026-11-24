Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483269;
	b=fOPEpAJhO2xTXo2Dj1pMNrEeeFXouErKNkiDvSToNhO0asoUYEB0CxJ5Mj4JwlD4vQv7
	 dRmmdj1MqrZJOKxXomHIP8azHo/HuNv9fzb/IRiJaVtRKmU5+EkmKIIJ9QH0mHZODoUnR
	 zOQAKMNY9OEM8YAeFR8z8B5t59Fwymf5/0c4nPlhM1+cYbsUPdmLtCC0ZEaNKdfEHHiU0
	 NlN/nm10HeHyuABDId4hC34ToagyZRSyK671XaRoqRrGAIv9VH3qou2wKsbMvu/0qZjNa
	 tJ37ObCpqQBdwW95IM79UAg+YZbwhG1qYWpj7+1XNhZ7LDZvJItYQoy7S5g5cCB177Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483269;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=lsgJbmq9xKAEYd+A+T8Qq8tXEzdvo3g7s2dCZbJ+4cg=;
	b=M0boh1ZOhnumx2T6keKBM9x4HagrUd3PV20PA6Bi93vU4Ph1q2w9xMX5XQtFOTsRtca2
	 Sxk/LB1Mvg/uOYY3uZrvL2Qg7Xw3Apro/yiAG42v44xWRDPAFBdVMzdczidUkLLNM43zE
	 lbW6xzYeg22CZYD7oqd8WmTtE0bA1wXnund4b+og4V2JqnUIG3w1Mo1vPKHPClJk111XR
	 oRJijBDfBSSsTWnd9bjaG7tXxShtDypCXMUWsBULGg0ojF9ZBl+BKRR4sycmBoLsu35np
	 ka86KeV97uWgIl91rdj2l40GA303Y5T++G2TheMwWOO97JeMbW739odCvphT+90/hNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JceiwOb6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D014F606A321;
	Tue, 24 Nov 2026 01:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JceiwOb6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC1B1F000D1;
	Tue, 24 Nov 2026 01:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483269;
	bh=lsgJbmq9xKAEYd+A+T8Qq8tXEzdvo3g7s2dCZbJ+4cg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JceiwOb6FS71vK1l84Mwo8qnobrgFQPAPGgPk21Mk+dCRVUdDN03P/X66qyO1HFxc
	 /zOQEqLCDYcq1gTmQAIpJxHqj7dJV8cCEGwcWjdR52hDJeKgOaXLsuGHeBHLUMS9l2
	 lTS/8KVb5Im9s1tVWkbpCzPOiSP48hi/jk//pl7SJGQOwkTzZKJ1sOSsk1OTxz9cmi
	 qyDRH5m0DwkHzPb/qaBDhQLLrheDB6EC4f4deD1/GXxc1ln4qC/rh7auasqVKqcH7C
	 t9qDJx3aaQT3lkvpAwhuiP5LHbG/RLHNvPOPCpHme8O1ysHQBLVHSB+OYgvQTJX5LF
	 FmxR5tIMPU9lg==
Subject: Re: [PATCH net-next v19 04/15] quic: provide family ops for address
 and protocol
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, jamie.bainbridge@gmail.com, linux-cifs@vger.kernel.org,
 pc@manguebit.org, linkinjeon@kernel.org, tom@talpey.com,
 kernel-tls-handshake@lists.linux.dev, cel@kernel.org, jlayton@kernel.org,
 steved@redhat.com, hare@suse.de, aahringo@redhat.com, dhowells@redhat.com,
 matttbe@kernel.org, mail@johnericson.me, xiyou.wangcong@gmail.com,
 alibuda@linux.alibaba.com, jbaron@akamai.com, illiliti@protonmail.com,
 sd@queasysnail.net, marcelo.leitner@gmail.com, daniel@haxx.se,
 andrew.gospodarek@broadcom.com, mef@scarletmail.rutgers.edu, paul@jakma.org,
 kuniyu@google.com
Date: Tue, 24 Nov 2026 01:21:06 +0000
Message-ID: <179548326686.3135.1885327270671072036@kernel.org>
In-Reply-To: <e33f69fbe24e60c4f624c08279553be2888558ff.1795393691.git.lucien.xin@gmail.com>
References: <e33f69fbe24e60c4f624c08279553be2888558ff.1795393691.git.lucien.xin@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 3 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_flow_route() in net/quic/family.c returns -EINVAL
  whenever `sa->sa.sa_family` is non-zero and differs from…
- [Medium] quic_v4_flow_route() in net/quic/family.c accepts any route
  returned by ip_route_output_flow() and passes it straight to…
- [Medium] When the selected IPv6 source is link-local,
  quic_v6_flow_route() in net/quic/family.c runs `sa->v6.sin6_scope_id =…
- [Low] The commit message does not mention three user-visible behaviour
  changes.

--

quic: provide family ops for address and protocol

This patch adds net/quic/family.{c,h} with IPv4/IPv6 helpers for routing,
transmit, address parsing and comparison, and UDP tunnel socket
configuration. It also wires quic_inet_getname(), quic_setsockopt() and
quic_getsockopt() to these helpers.

> quic: provide family ops for address and protocol
>
> Introduce QUIC address and protocol family operations to handle IPv4/IPv6
> specifics consistently. The new family.{c,h} provide helpers for routing,
> skb transmit handling, address parsing and comparison and UDP socket config
> initializing etc.

[Severity: Low]
This isn't a bug, but the commit message describes only internal helpers.
The patch also changes user-visible behaviour on QUIC sockets.

quic_inet_getname() used to return -EOPNOTSUPP. It now calls
quic_get_sk_addr(), so getsockname() and getpeername() return real
addresses through inet_getname() or inet6_getname().

quic_setsockopt() and quic_getsockopt() used to return -EOPNOTSUPP for any
level other than SOL_QUIC. They now pass the call to ip_setsockopt() or
ipv6_setsockopt(), and to ip_getsockopt() or ipv6_getsockopt(). With
CONFIG_NETFILTER the call can also reach nf_setsockopt() or
nf_getsockopt(). For unknown levels the error changes from -EOPNOTSUPP to
-ENOPROTOOPT.

SOL_IP and SOL_IPV6 options set this way change state that the new helpers
read: inet_sk(sk)->tos, uc_ttl, np->tclass, SNDFLOW and ipv6_only_sock().

Could the commit message mention these changes? The subject also still
says "family ops", but v3 replaced the ops abstraction with if/else
helpers.

> diff --git a/net/quic/family.c b/net/quic/family.c
> new file mode 100644
> index 0000000000000..73f3b955e13c4
> --- /dev/null
> +++ b/net/quic/family.c

[ ... ]

> +static int quic_v4_flow_route(struct sock *sk, union quic_addr *da,
> +			      union quic_addr *sa, struct flowi *fl)
> +{

[ ... ]

> +	security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
> +	rt = ip_route_output_flow(sock_net(sk), fl4, sk);
> +	if (IS_ERR(rt))
> +		return PTR_ERR(rt);
> +
> +	if (quic_v4_is_any_addr(sa)) {
> +		sa->v4.sin_family = AF_INET;
> +		sa->v4.sin_addr.s_addr = fl4->saddr;
> +	}
> +	sk_setup_caps(sk, &rt->dst);

[Severity: Medium]
Should quic_v4_flow_route() reject RTCF_BROADCAST and RTCF_MULTICAST
routes before caching the dst?

Other IPv4 socket types check rt->rt_flags at this point. For example,
__ip4_datagram_connect() does:

	if ((rt->rt_flags & RTCF_BROADCAST) && !sock_flag(sk, SOCK_BROADCAST)) {
		ip_rt_put(rt);
		err = -EACCES;
		goto out;
	}

raw_sendmsg() has the same check. tcp_v4_connect() returns -ENETUNREACH
for both RTCF_MULTICAST and RTCF_BROADCAST.

Without such a check, a QUIC socket can cache and send on a broadcast
route (255.255.255.255 or a subnet-directed broadcast) without
SO_BROADCAST.

On the server side, the reply destination comes from the source address
of a received packet. With rp_filter=0, the kernel default, a spoofed
source equal to the local subnet broadcast (e.g. 192.168.1.255) gets past
ip_route_input_slow() and fib_validate_source().

Would the server's replies then go out as link-layer broadcasts to every
host on the LAN? That multiplies the 3x anti-amplification budget by the
number of hosts. A userspace QUIC server on a UDP socket would get -EACCES
from sendto() in this case.

> +	return 0;
> +}
> +
> +static int quic_v6_flow_route(struct sock *sk, union quic_addr *da,
> +			      union quic_addr *sa, struct flowi *fl)
> +{

[ ... ]

> +	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, NULL);
> +	if (IS_ERR(dst))
> +		return PTR_ERR(dst);
> +
> +	if (quic_v6_is_any_addr(sa)) {
> +		sa->v6.sin6_family = AF_INET6;
> +		sa->v6.sin6_addr = fl6->saddr;
> +		if ((ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_LINKLOCAL))
> +			sa->v6.sin6_scope_id = dst->dev->ifindex;

[Severity: Medium]
Is it safe to dereference dst->dev here without rcu_read_lock()?

This code runs in preemptible process context, under lock_sock() through
quic_packet_route(). A dst reference does not pin the original
net_device. On unregister, dst_dev_put() does:

	rcu_assign_pointer(dst->dev_rcu, blackhole_netdev);
	netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
			   GFP_ATOMIC);

That drops the reference on the old device. This reader is not inside an
RCU read-side section, so the synchronize_net() calls during unregister
do not wait for it.

If the task is preempted after loading dst->dev but before reading
->ifindex, can it read freed net_device memory? Even in the harmless
case, it could store blackhole_netdev's ifindex as the scope ID.

include/net/dst.h provides dst_dev() and dst_dev_rcu() for this.
sk_setup_caps() on the IPv4 path reads the device through dst_dev_rcu()
under rcu_read_lock().

> +	}
> +	ip6_dst_store(sk, dst, false, false);
> +	return 0;
> +}

[ ... ]

> +int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa,
> +		    struct flowi *fl)
> +{
> +	if (sa->sa.sa_family && da->sa.sa_family != sa->sa.sa_family)
> +		return -EINVAL;

[Severity: Medium]
Does this check reject a valid dual-stack setup?

An AF_INET6 '::' source (a socket bound to the IPv6 wildcard) with an
AF_INET destination fails here. quic_v6_cmp_sk_addr() accepts that same
pairing on receive:

	if (a->sa.sa_family != addr->sa.sa_family) {
		if (ipv6_only_sock(sk) || a->sa.sa_family == AF_INET)
			return false;
		return quic_is_any_addr(a);
	}

So a stored AF_INET6 '::' address matches AF_INET traffic on receive, but
routing refuses the same combination on transmit.

Suppose the later bind() and connect() code stores a bound [::] source
as-is. Would a client bound to [::]:port that connects to an IPv4 peer
then fail in quic_packet_route()->quic_flow_route() with -EINVAL? The v14
changelog says IPv4-mapped addresses are converted to AF_INET, so the
peer address would arrive here as AF_INET. Plain UDP allows this on a
dual-stack socket.

Dropping the check alone would not fix it. quic_v4_flow_route() reads
sa->v4.sin_addr, which overlays sin6_flowinfo, so an IPv6-wildcard sa
would need to be treated as IPv4 ANY.

The v15 changelog shows the family mismatch check is intentional. Was the
dual-stack wildcard case considered?

> +
> +	return quic_af_ipv4(da) ? quic_v4_flow_route(sk, da, sa, fl) :
> +				  quic_v6_flow_route(sk, da, sa, fl);
> +}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795393690.git.lucien.xin%40gmail.com
