Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94216199E89;
	Wed,  7 Oct 2026 01:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335101; cv=none; b=RfcLWRODm9EGYCrpl8e7Aovm/le/b46r+kPLX1OkVP9elnKfsi4m1P4KoUgsEtI+a/s4NJoA5xGWrpzERrQN0vSkUYR4Suu1L3fg2t8Xf5eGHi4whRM+2PSPStQ9gS774mGarOXsleQYMVy7ieGWc2LQ/d7IjVPWvqcsPhd7FLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335101; c=relaxed/simple;
	bh=bAVG1WmBZ2kNBQXbAP6N83iHKKxTWsHEVRhgN6sXa0Q=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WyEQSrR5n55Gi6MmNlpZISSZ7F838L2h7TRaSIkEe1hNY9z7KoGc5Y0WN2X3+KhBj206aRmDjv0Px4DTdA2pSjx1HP5ry+E8bxSJ4utNypYdzPpYHT9uV5CLW3D5/tcynD+5GyqoeyHKHg1zK5wdgFHgLPxpWowsC2NkilhBZE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eul1gh81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eul1gh81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5464A1F0089B;
	Wed,  7 Oct 2026 01:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335100;
	bh=L8zCEm4ebpEhT1oPkMuKU8PPb72WeSJDkF0vOeGDjZ8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Eul1gh816ukMGn1Y/EIFdtyje9ry3CS0b/U2Qtei/7FYliR0+X3EPU09pf3gqSIBy
	 OwytpCz/g6ArDUNbv6NrAFyQgpMY7+qOWKtqdxFxQ+0bzEdqfoe2DPAtw0m96Whzmu
	 Ua3Xh/Zzeixq9G8p05SQoR5WJw+8EVk+sBE69nctyiWaZFvn9PKnV6sTWCoyPMtG04
	 QGcyw3NIm+lUR+LCqk5TIJt49V6wCAFcdF9ZDUEmCTYXbn+8Xm1JkoZtHuB1lcTcTX
	 L4y/K3/ynccPV6/GltWFJk4c7vZ6lJTEl0PYSqMAfhoOpNYmAu40OZl4p035pPBdyZ
	 iLyc2eRnIvfzw==
Subject: Re: [PATCH net-next v16 02/15] net: build socket infrastructure for
 QUIC protocol
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
Date: Wed, 07 Oct 2026 01:04:57 +0000
Message-ID: <179133509783.434549.2591261955322103799@kernel.org>
In-Reply-To: =?utf-8?q?=3C266c7e267db1c1687001b2ffb194492c4f50c77e=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C266c7e267db1c1687001b2ffb194492c4f50c77e=2E17912270?=
 =?utf-8?q?50=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The patch installs the native family ioctl handlers in
  quic_proto_ops (`.ioctl = inet_ioctl`, net/quic/protocol.c:138) and…

--

net: build socket infrastructure for QUIC protocol

This patch adds the first socket scaffolding for an in-kernel QUIC
implementation. It defines the QUIC proto and proto_ops tables for IPv4
and IPv6, per-netns SNMP statistics and sysctls. It also adds the
Kconfig/Makefile glue needed to build the code as CONFIG_IP_QUIC=m.

> diff --git a/net/quic/protocol.c b/net/quic/protocol.c
> new file mode 100644
> index 0000000000000..91db48e79c2c6
> --- /dev/null
> +++ b/net/quic/protocol.c
> @@ -0,0 +1,378 @@

[ ... ]

> +static const struct proto_ops quic_proto_ops = {
> +	.family		   = PF_INET,

[ ... ]

> +	.poll		   = quic_inet_poll,
> +	.ioctl		   = inet_ioctl,
> +	.gettstamp	   = sock_gettstamp,

[ ... ]

> +static const struct proto_ops quicv6_proto_ops = {
> +	.family		   = PF_INET6,

[ ... ]

> +	.poll		   = quic_inet_poll,
> +	.ioctl		   = inet6_ioctl,
> +	.gettstamp	   = sock_gettstamp,

[Severity: Low]
Should quic_proto_ops and quicv6_proto_ops also set .compat_ioctl, to
inet_compat_ioctl and inet6_compat_ioctl respectively?

Both tables use the native inet_ioctl() and inet6_ioctl() handlers but
leave .compat_ioctl NULL. On a CONFIG_COMPAT kernel, a 32-bit task that
issues SIOCADDRT or SIOCDELRT on a QUIC socket ends up here:

net/socket.c:compat_sock_ioctl() {
    ...
	if (ops->compat_ioctl)
		ret = ops->compat_ioctl(sock, cmd, arg);
    ...
	if (ret == -ENOIOCTLCMD)
		ret = compat_sock_ioctl_trans(file, sock, cmd, arg);
    ...
}

compat_sock_ioctl_trans() has no case for SIOCADDRT or SIOCDELRT. The
32-bit task therefore gets -ENOTTY. A native 64-bit task on the same
socket reaches the routing ioctl.

Only inet_compat_ioctl() and inet6_compat_ioctl() translate the compat
struct rtentry and struct in6_rtmsg:

net/ipv4/af_inet.c:inet_compat_ioctl() {
    ...
	case SIOCADDRT:
	case SIOCDELRT:
		return inet_compat_routing_ioctl(sk, cmd, argp);
    ...
}

The other INET and INET6 proto_ops tables that use inet_ioctl() or
inet6_ioctl() all set .compat_ioctl. These include inet_stream_ops,
inet_dgram_ops, inet_sockraw_ops, inet6_stream_ops, inet6_dgram_ops, and
the SCTP, MPTCP and raw IPv6 ops.

In the final revision of the series, the only ioctl entries under
net/quic/ are these two .ioctl lines. So no later patch seems to add
.compat_ioctl for QUIC either.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com
