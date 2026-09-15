Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4F8411FB8;
	Tue, 15 Sep 2026 19:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501838; cv=none; b=eP+vWYV7/wPlt3QwbSdaCDv5vaTTTFt6HFEPkEf5BPyCwSFCD2iBxhYBtHhp3bldFzEbd3nqIO+FlJyRzSQ4aAeC4UGLGzdQUae6vnAElfL5VPzJ2FGc8+W3qxxB7W6oXS5LUx5sEemNbIXn+qd+lLpI0hwZHQ2SuCo2nkwQZFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501838; c=relaxed/simple;
	bh=cNjhCLtHBv58xVxWSoKFDLQINxAY93WS0LaC6HKR8Ww=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JEaTWKHC2alulRTHqhrlN+zDXGZ+kwn878m9Xw1Rpsgw3yjbXU7SJeScI22Vir2WypA5RI1nktJdqlkMnO+XTxaWnf6SV6GFdW3QDbXohgZKZ72EpsxpUxghgm9W4Fur36VrwkXEN5S5k6L8z14YQICZEtInPOgvh3E8Wms48ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T5wnORji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5wnORji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE081F000FF;
	Tue, 15 Sep 2026 19:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501836;
	bh=tu8Ky0+820wR/OD362evPSvdWA4B/pBwdDMmrnhtADM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=T5wnORjihruSBtREEMzS0beuXyFHBUpe+YD9zEjCjekD/AK8/Gfgq+A5SZAEBHD5A
	 3zjlmJQ8H1yFD7o5OtISKX9ucB8JFBfwdia/RQxEboDEyqfz/suCujGA7Dr+cYFDdz
	 OR2cKXyTEwKpF5/VJIwpufZb+SmdMSZbp1Ln3cfi7VQJ75hM/N1mQgGy5n+P7u63ZH
	 iTKyCtSUlgZ/O0fyPuNjCIssmundpSoJrzBiQagXrSjLydn77waQs2TaW4YDBqILx1
	 U28qcTEHw6GYbP+n3ScbnBbKWf8Gn+yQRm9lrJIdAWLXDmhWBfYoNn4p1PlYovWIWR
	 ol89Vvmy89VHg==
Subject: Re: [PATCH net-next v15 04/15] quic: provide family ops for address
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
 mef@scarletmail.rutgers.edu, paul@jakma.org
Date: Tue, 15 Sep 2026 19:50:25 +0000
Message-ID: <178950182544.22033.14354065225790738831@kernel.org>
In-Reply-To: =?utf-8?q?=3C627ebfc68bf77c45ae511de694aed1a4f2d9aa87=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C627ebfc68bf77c45ae511de694aed1a4f2d9aa87=2E17893937?=
 =?utf-8?q?75=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 2

- [Low] The commit message describes this patch only as the introduction
  of family helper code ("provide helpers for routing, skb transmit…
- [Low] Both new transmit debug messages format the unsigned skb->len
  field with the signed %d conversion instead of %u:…

--

quic: provide family ops for address and protocol

This adds net/quic/family.{c,h} with IPv4/IPv6 helpers for routing, lower
transmit, address parsing and comparison, MTU info extraction and UDP
tunnel socket configuration. It also wires quic_inet_getname() and the
non-SOL_QUIC setsockopt/getsockopt paths into the new helpers.

> diff --git a/net/quic/Makefile b/net/quic/Makefile

[ ... ]

> diff --git a/net/quic/family.c b/net/quic/family.c
> new file mode 100644
> index 0000000000000..f61a8203b2e17
> --- /dev/null
> +++ b/net/quic/family.c
> @@ -0,0 +1,446 @@

[ ... ]

> +static void quic_v4_lower_xmit(struct sock *sk, struct sk_buff *skb,
> +			       struct flowi *fl)
> +{
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	struct flowi4 *fl4 = &fl->u.ip4;
> +	u8 tos = inet_sk(sk)->tos, ttl;
> +	struct dst_entry *dst;
> +	__be16 df = 0;
> +
> +	pr_debug("%s: skb: %p, len: %d, num: %lld, %pI4:%d -> %pI4:%d\n",
> +		 __func__, skb, skb->len, cb->number, &fl4->saddr,
> +		 ntohs(fl4->fl4_sport), &fl4->daddr, ntohs(fl4->fl4_dport));

[Severity: Low]
This isn't a bug, but should the length conversion be %u here?  skb->len is
declared unsigned in struct sk_buff:

include/linux/skbuff.h:
	unsigned int		len,
				data_len;

The same mismatch appears in quic_v6_lower_xmit() below.

[ ... ]

> +static void quic_v6_lower_xmit(struct sock *sk, struct sk_buff *skb,
> +			       struct flowi *fl)
> +{
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	u8 tc = inet6_sk(sk)->tclass, ttl;
> +	struct flowi6 *fl6 = &fl->u.ip6;
> +	struct dst_entry *dst;
> +	__be32 label;
> +
> +	pr_debug("%s: skb: %p, len: %d, num: %lld, %pI6c:%d -> %pI6c:%d\n",
> +		 __func__, skb, skb->len, cb->number, &fl6->saddr,
> +		 ntohs(fl6->fl6_sport), &fl6->daddr, ntohs(fl6->fl6_dport));

[ ... ]

> diff --git a/net/quic/protocol.c b/net/quic/protocol.c
> index a53a2b1218a63..c5cd6d609d06f 100644
> --- a/net/quic/protocol.c
> +++ b/net/quic/protocol.c
> @@ -47,7 +47,7 @@ static int quic_inet_listen(struct socket *sock, int backlog)
>  static int quic_inet_getname(struct socket *sock, struct sockaddr *uaddr,
>  			     int peer)
>  {
> -	return -EOPNOTSUPP;
> +	return quic_get_sk_addr(sock, uaddr, peer);
>  }
>  
>  static __poll_t quic_inet_poll(struct file *file, struct socket *sock,
> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index c2841caca5dcc..1c97d95c61b2c 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c
> @@ -121,7 +121,8 @@ static int quic_setsockopt(struct sock *sk, int level, int optname,
>  			   sockptr_t optval, unsigned int optlen)
>  {
>  	if (level != SOL_QUIC)
> -		return -EOPNOTSUPP;
> +		return quic_common_setsockopt(sk, level, optname, optval,
> +					      optlen);
>  
>  	return quic_do_setsockopt(sk, optname, optval, optlen);
>  }
> @@ -136,7 +137,8 @@ static int quic_getsockopt(struct sock *sk, int level, int optname,
>  			   char __user *optval, int __user *optlen)
>  {
>  	if (level != SOL_QUIC)
> -		return -EOPNOTSUPP;
> +		return quic_common_getsockopt(sk, level, optname, optval,
> +					      optlen);
>  
>  	return quic_do_getsockopt(sk, optname, USER_SOCKPTR(optval),
>  				  USER_SOCKPTR(optlen));

[Severity: Low]
Could the changelog mention these three behaviour changes?  The commit
message describes the patch as

    "The new quic_family.{c,h} provide helpers for routing, skb transmit
    handling, address parsing and comparison and UDP socket config
    initializing etc."

but beyond adding helpers, three entry points that previously returned
-EOPNOTSUPP now work:

  quic_inet_getname() -> quic_get_sk_addr()
  quic_setsockopt()   -> quic_common_setsockopt() -> ip_setsockopt()/ipv6_setsockopt()
  quic_getsockopt()   -> quic_common_getsockopt() -> ip_getsockopt()/ipv6_getsockopt()

So getsockname()/getpeername() start returning addresses, and every
level != SOL_QUIC option is now passed through to the IP/IPv6 option
handlers.  Some of those values are consumed by code added in this same
patch: inet_sk(sk)->tos in quic_v4_lower_xmit(), inet6_sk(sk)->tclass in
quic_v6_lower_xmit(), ipv6_only_sock() in quic_v6_udp_conf_init(), and
pmtudisc through ip_dont_fragment() and quic_sk_accept_pmtu().

Also, the message names the new files quic_family.{c,h} while the patch
adds net/quic/family.{c,h}.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
