Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445402;
	b=gNWpx5m3HcT4Kz4QbYOfBwx1+ncU3QUnk7lnXh6qnO9HsTDyjHVDV2YnQlpyfxkWoj79
	 HO0/BsPU/BbuyxZ/YsQXRhYpj4U2afIMdFV24y+vpm90kbz37zwbGpzOPNiQOpdWgy0L5
	 FpNOF4OxJ1RTN6ZimRet4oj7lVl/EqSve/TELZfAIMuPdJcSUsz/DWe0VIk/MSusjRLDN
	 FrSNQnwZcxFCR52sH6F5VHZhNXlKzk+Pa+/9ozxz+ILGBr/f2soW0+sfDzlyT6KfTQaRy
	 5zEF7Bb8amgrKdwMPCYNMUODI+3cwZb+t+VD/aATJz4kyPudIrOmcAnhw/Bqur05jbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445402;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=zYWrixPm+QMNkzjCpnwk9/Rk+hqbPSVNxVQvHcB89o8=;
	b=d6uUkQRuQkeEllRtdpoxvtM8y19NLQGkH4Aan7z/RNDyebl1+jJOoIrxmYqLHOw+xkWF
	 j5Gy06JQQnVeTwc1zXWGEjC7PI6IMfrYtT74cEiTqJbcFGaekIwCMqKAqUSRd2U1s5g/U
	 VXs++ytZqvCmmdKxL701hX2njugl5VZFV9tJKRNNsYDx5xrA7wxRsvTIpydTELU3jIgFC
	 oWId676hfMiwbMh9MUby+sC5O23pAhxDqrcx1CWvWdq5DMJPu98iXmIOd14ztK+kjXy1V
	 WH+35WvPz0rph3G88k/UbiAOdn/Hhsbdvbyjyg6Mti1ISZlSG6clBDAFKThrJZw0wtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6VIF6hs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A07606A322;
	Mon, 19 Oct 2026 21:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6VIF6hs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170291F000C7;
	Mon, 19 Oct 2026 21:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792445401;
	bh=zYWrixPm+QMNkzjCpnwk9/Rk+hqbPSVNxVQvHcB89o8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=B6VIF6hseZ0ecdud3CbCjOez+ciHl0bolWQvLE/QgZNzvzJsedt+DSroOLl2EbKiq
	 WEzbVtRvFTD4ONxSJJ1lvoItgJFaZJkd/U9ntcHjQBJ6FOQ/l5Dbf9cLKMFNMhh+2a
	 Mr3SMT11wrJ0FqYQzk9whntkqf3orlpzSo2g8TC8aRsN85wxQQ/kXJz8B4A2Tvol6B
	 9EZhOIOq/5Uj4lL8bWElRQc7cm3ywekFjkLo+VfP17rDn6gQ1mIuU5E5wItP0FZ9ge
	 sF0NvNbpd2Fyw6/DEfqzHmcfdQi+vioshGAxXx877Z78Y076TMoZY3oXWOLzvp1V8B
	 pc/zG9cIV5crA==
Subject: Re: [PATCH net-next v17 08/15] quic: add path management
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
Date: Mon, 19 Oct 2026 21:29:58 +0000
Message-ID: <179244539859.3135.15973054396060254186@kernel.org>
In-Reply-To: =?utf-8?q?=3Cae36949f7685ef74318d3c742f02e1398db3b454=2E1792164?=
 =?utf-8?q?438=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Cae36949f7685ef74318d3c742f02e1398db3b454=2E17921644?=
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_udp_sock_create() in net/quic/path.c zero-initializes
  udp_conf and fills it with quic_udp_conf_init() ->…
- [Medium] IP_FREEBIND (and the IPv6 equivalent) set on a QUIC socket has
  no effect when a new UDP tunnel socket is created.

--

quic: add path management

This adds struct quic_path_group and struct quic_path to manage the
active and alternate paths of a QUIC connection. Each path is bound to a
kernel UDP tunnel socket, which can be shared and is tracked in a
per-port hash table. The patch also adds bind, unbind and swap helpers,
alternate path detection for migration, and basic PLPMTUD state handling.

> diff --git a/net/quic/path.c b/net/quic/path.c
> new file mode 100644
> index 0000000000000..ba7e2c952a36a
> --- /dev/null
> +++ b/net/quic/path.c
> @@ -0,0 +1,596 @@

[ ... ]

> +static struct quic_udp_sock *quic_udp_sock_create(struct sock *sk,
> +						  union quic_addr *a)
> +{
> +	struct udp_tunnel_sock_cfg tuncfg = {};
> +	struct udp_port_cfg udp_conf = {};
> +	struct net *net = sock_net(sk);
> +	struct quic_uhash_head *head;
> +	struct quic_udp_sock *us;
> +	struct socket *sock;
> +	int err;
> +
> +	us = kmalloc_obj(*us);
> +	if (!us)
> +		return ERR_PTR(-ENOMEM);
> +
> +	quic_udp_conf_init(sk, &udp_conf, a);

[Severity: Medium]
Should the tunnel socket take its IPV6_V6ONLY setting from the QUIC
socket that owns it?

quic_udp_conf_init()->quic_v6_udp_conf_init() fills in the family,
address, port, checksum flags and bind_ifindex. It never sets
conf->ipv6_v6only:

net/quic/family.c:quic_v6_udp_conf_init() {
	conf->family = AF_INET6;
	conf->local_ip6 = a->v6.sin6_addr;
	conf->local_udp_port = a->v6.sin6_port;
	conf->use_udp6_rx_checksums = true;
	conf->use_udp6_tx_checksums = true;
	conf->bind_ifindex = quic_get_dev_if(sk, a);
}

udp_sock_create6() applies v6only only when the config asks for it:

net/ipv6/ip6_udp_tunnel.c:udp_sock_create6() {
    ...
	if (cfg->ipv6_v6only) {
		err = ip6_sock_set_v6only(sock->sk);
    ...
}

As a result, the kernel UDP socket always gets the net.ipv6.bindv6only
default. An IPV6_V6ONLY value set on the QUIC socket through
quic_setsockopt()->ipv6_setsockopt() is ignored. A zero cfg value also
can't clear an inherited bindv6only=1.

With bindv6only=0, could an IPV6_V6ONLY QUIC socket bound to [::]:P get a
dual-stack tunnel? That tunnel would also hold IPv4 port P and could
cause unexpected EADDRINUSE for IPv4 binds.

With bindv6only=1, a QUIC socket that cleared IPV6_V6ONLY gets a v6-only
tunnel, and IPv4 UDP lookup skips ipv6_only sockets. Would IPv4 packets
for that dual-stack QUIC socket ever be delivered?

quic_udp_sock_lookup() also decides sharing through
quic_cmp_sk_addr(us->sk, ...), which checks ipv6_only_sock() on the
tunnel socket. A wrong v6only state would therefore also change which
QUIC sockets end up sharing a tunnel.

quic_path_bind() has no caller yet in this series, so this would only
show up once quic_bind() is wired in by the next patchset.

> +	err = udp_sock_create(net, &udp_conf, &sock);

[Severity: Medium]
Is IP_FREEBIND (or its IPv6 equivalent) on the QUIC socket honoured
when a new tunnel socket is created here?

struct udp_port_cfg has no freebind or transparent field.
udp_sock_create4() and udp_sock_create6() call kernel_bind() right after
sock_create_kern(), so FREEBIND can never be set on the new socket
before it is bound:

net/ipv6/ip6_udp_tunnel.c:udp_sock_create6() {
	err = sock_create_kern(net, AF_INET6, SOCK_DGRAM, 0, &sock);
    ...
	err = kernel_bind(sock, (struct sockaddr_unsized *)&udp6_addr,
			  sizeof(udp6_addr));
    ...
}

The bind path then calls inet_addr_valid_or_nonlocal() on the new tunnel
socket. That socket doesn't have FREEBIND set, so a nonlocal source
address would fail with -EADDRNOTAVAIL.

The QUIC socket accepts IP_FREEBIND through
quic_common_setsockopt()->ip_setsockopt(). quic_get_user_addr() in the
next patchset is described as honouring FREEBIND. Could bind validation
then accept the address, only for
quic_path_bind()->quic_udp_sock_create() to reject it?

It looks like only the netns-wide ip_nonlocal_bind sysctl would make a
nonlocal bind work here.

> +	if (err) {
> +		pr_debug("%s: failed to create udp sock\n", __func__);
> +		kfree(us);
> +		return ERR_PTR(err);
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1792164438.git.lucien.xin%40gmail.com
