Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795625083;
	b=tJkCjjbp1XyCsR6sp5+HqEYCAZP0wfxaXhGR0SqKclNL6V0iXNgRHtzhU8KIQki7jp/i
	 diVAOSZ2u4v61mSXDzLHht4SnFHnNF78CsCJ2CQ6gHQ26KiQZTxGTZAb5im5Km3I2YbYu
	 7ZMwD1WpSj3r3dnye2SnC81Aja46wbFTy6BSKqEazjJCSqhwxCJ48y/19424vbT45VI7z
	 dQqg29KsNqFWovESSrA7MEmAAaJsTOM62P1515jHi01gk+3Pvip3x54e7eNEnMPd36jt+
	 7C/WZEjXhdYYAb2ztpoAUck22SnerKmumYIJXs1LpJQXYUu1Em5+v6q/r993A99Ddpw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625083;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=VqQCnrL/aKCm/C9vlxA9BxjPZ3u2dEkyObqv4aLYECU=;
	b=kvNF4Pyg0rOY6KN9I6ITu0O4d7ALpTnvOeJA0an/FkdcTTyuwb9+yxcZUtORua6IL603
	 HYLUJWaOytD+Hk0lXNORpBmJMveTc/vsPLlst+VBGVHbbRsfQOKNbLr4FqRCYZyc2xhJr
	 jnW1HyRkRKae0ANDhlpc/CG7SaatZpnQvz8AlfrbYdiOgMhP4s6VV8MVK3wAek8Hj26kp
	 vq9pcwwnqUJOcrjSh2/ppm88UlizIawAOy5SYlOVoXxKTX1fi9htzgQ5gDBV+/wlKJKo3
	 PBWO4GjWa93p4BfjLQWL3ffOBvquY+dcCpHOh38kw8tWCLaDf1hJTS3oNNiioCyt2dA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="nTpR210/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337AE606A32C
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 16:44:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 337AE606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nTpR210/
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8b600fae14dso2124155b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 08:44:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795625082; cv=none;
        d=google.com; s=arc-20260327;
        b=Qf07juwICUC+RpkcQ7f/L4gawZsdlztMGTgIuMY0cL4rpohmJv4UoSI7muawQZnivj
         XqUJ3UIT34temSQ0zBjKX3thQz957FLrdCz9l55q0t5sBeMyH995BIpkz7cGhjuqt/9r
         heeoQ0q4SxsxsTD8ik+xR6ZOBHhGpmWaiFmpii0hYmEt0iycAsAyvkdKbPeMkTKfRRL1
         nwv4lwF+/90mPQa/I9wBRJ48UNVgg8W4/MW+EF7/yCQvo4W1CiZjjQ0cQv+odTmfAvvF
         M1p6dvTpEC4OlV0SYgTdgFLjM+3O2wANVFkU7kkZqezyhbB+lq7MZulc5a5eyGm96Hju
         J0mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VqQCnrL/aKCm/C9vlxA9BxjPZ3u2dEkyObqv4aLYECU=;
        fh=CgvNVmes5syyYh2xqlIjJwFs4ex0GZAj7S77YAkPf2k=;
        b=ESDw1FOAp53csZs9ivcEjwW7ma4/gQOFhzemKAAS0IR6DTzQdlaNppTb4pg9177/k8
         WI79U18LiCLUjZtWuWap4srIeifMthk8wiRXfDhOnL56ErTdFZevbLPOskK74tSaQmUW
         PgkrR7rtfUlosVD74UmXL+wch34GJohEkl4GUHUeVivck60I+/GqTAy/2pUvPcKDUYO8
         UXopiFn3vKKiARbu++q2GMq+DZ2Rr3K87Em6i1/zXhh0PhtBqkyKGjjg0RHVik+F3Epg
         Xl+o/5F9jH/ytlX42c5LD0N8o69u3c/7k+4qg0HTpwvxxjuf3ukrKRTqO+YYUr0hrK5D
         TJow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795625082; x=1796229882; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VqQCnrL/aKCm/C9vlxA9BxjPZ3u2dEkyObqv4aLYECU=;
        b=nTpR210/7WPhItYFJ3rIvBCK7DgJA6FunfHRYgyCiMiTQKIuFslN2+oqlT6dl7XsaP
         svAAdzVR3fKYhs9mZzRgXgH+SM3y/9q5qjtrl+UFPev0RmVuXohlQ/2taCJa+AHxDbzx
         JXk5SSupM6YK6KxXFaZ6qTmS/K7k36+44GnOimPnGvE8Pcqzz4Ju/6Ump10E8LA2AkUa
         yK28/CRfe4dP74p8lPwzgX78W7xRyO2ZY4iF/uvLLhRIPKW/1MgKvwa//ZJwNE9RvVaB
         dXdRV2ZyCS5LYTQ4Ns/VzfcYEtWTvCsV8ybkkRbGD39jXm6mXllHN6Tkb+hn3rjzk+SJ
         OAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795625082; x=1796229882;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VqQCnrL/aKCm/C9vlxA9BxjPZ3u2dEkyObqv4aLYECU=;
        b=QBJ5GRbwxv3zZza7lqF4kr6Bb+gjWv3inWNRQG6W2MLOIZDql2kwS1+LnY1cSRNxAD
         LmlmDpxx0D+sjtuznuBzHSZ1Xml1M4Y66ckZ+SZ44TdQCsljfBMhprt6abq7+77otXMc
         1IRjYT3dND07o7RuDWhsB+PPySPSKWdgPpSGiiXNQZHkihFkLTaa9bFWfxcZM6tzkc0L
         8aMAp6lZ8wpWsoxRrd5svmd4O46DGLv/B10RLHndhXMSC9kiCMISdFNESqm35scN5142
         sMS9/9JRdcr5EOwJTf95373JaWyjqP/ay0ITnurZ05uU6QOjPryDsgyL/IKYPRc5EsZj
         8T7g==
X-Forwarded-Encrypted: i=1; AL+hErEChKq1XniIUEV1wmfFKA4lKEwWYJaj1bSPJdT4BF/d3DiXhCg1h/ECvPD81cHWk81sK0jJwH5n/ApR@vger.kernel.org
X-Gm-Message-State: APuU4Z9osPgUvXGTK+7SxKs0wjy6wg+KzZwMhbQe4uKB+FuDJZmxYIaU
	rtRsZKez1etFkyVLUcLLnpopaDDuDNqFS17nifrSx2jZgeAA+r+eNzC6OyglNCNkBUUcpx5KB4b
	zWPGBZ5IuPMYqg0sECZU0vORgOy5OglU=
X-Gm-Gg: AZFdTZd/TRI//t4/vKRUV4qEd9kKH+VjrYk5MsZ9auNZvTiJ+x9/uujMtILD64xNlJz
	MqukQ5+zeaeYKyYpLxuGyEG64S1CkyjqN6GZDAftq0SNkaJrRUhGyG7pOWTwljFrlu4Yk1On/y3
	K5l49NfRu+qzjpsj0rkCPOQ5FX+lrKH0/ITuWws5dkaxABdogKENx/K4ndAY4EXtDORUXS4x7/t
	d/EBtof0IfYVOOTCxSkWUHNmaV0xsEmi6Bcl0jFbTu30XSx9YwMJaC1lVTtBjiK68YvSx/rEnTg
	EOWUEUNHtDPPYziJnVfCajXoO/XA4eYyU8pG8JVqszdHDTH9sfNCIZWK1s1zABBkpDzQ75S0IjN
	emNC8abpxK+k4Y4a/8td+I0QrkIRuDfYCCrR6nt9e9RiDXurqjiprMyAPITfzyshRtMUHBey8Dg
	fP8yMomCkOuUckHiX8Wl1OsegUgBzzJKkhT/2EmXwn5Pc0U5Weejuf56ScK0qVgeNzENgR
X-Received: by 2002:a05:6a00:17a3:b0:881:cbb0:6a90 with SMTP id
 d2e1a72fcca58-8c87d80b24bmr16495257b3a.58.1795625082380; Wed, 25 Nov 2026
 08:44:42 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <e33f69fbe24e60c4f624c08279553be2888558ff.1795393691.git.lucien.xin@gmail.com>
 <179548326686.3135.1885327270671072036@kernel.org>
In-Reply-To: <179548326686.3135.1885327270671072036@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 25 Nov 2026 11:44:30 -0500
X-Gm-Features: Aa3M54rwA_4B_Qvf2uz_eVnjuVavXWhSvilNzKm8mtiFvEJGwuVKtS7cR4uh2Fw
Message-ID: <CADvbK_dW3LHZq1b0Y7pbWBbi1BikLyajruJ=iJz25sp_nkXdAA@mail.gmail.com>
Subject: Re: [PATCH net-next v19 04/15] quic: provide family ops for address
 and protocol
To: netdev-bot+sashiko@kernel.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 8:21=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 4 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 3 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] quic_flow_route() in net/quic/family.c returns -EINVAL
>   whenever `sa->sa.sa_family` is non-zero and differs from=E2=80=A6
> - [Medium] quic_v4_flow_route() in net/quic/family.c accepts any route
>   returned by ip_route_output_flow() and passes it straight to=E2=80=A6
> - [Medium] When the selected IPv6 source is link-local,
>   quic_v6_flow_route() in net/quic/family.c runs `sa->v6.sin6_scope_id =
=3D=E2=80=A6
> - [Low] The commit message does not mention three user-visible behaviour
>   changes.
>
> --
>
> quic: provide family ops for address and protocol
>
> This patch adds net/quic/family.{c,h} with IPv4/IPv6 helpers for routing,
> transmit, address parsing and comparison, and UDP tunnel socket
> configuration. It also wires quic_inet_getname(), quic_setsockopt() and
> quic_getsockopt() to these helpers.
>
> > quic: provide family ops for address and protocol
> >
> > Introduce QUIC address and protocol family operations to handle IPv4/IP=
v6
> > specifics consistently. The new family.{c,h} provide helpers for routin=
g,
> > skb transmit handling, address parsing and comparison and UDP socket co=
nfig
> > initializing etc.
>
> [Severity: Low]
> This isn't a bug, but the commit message describes only internal helpers.
> The patch also changes user-visible behaviour on QUIC sockets.
>
> quic_inet_getname() used to return -EOPNOTSUPP. It now calls
> quic_get_sk_addr(), so getsockname() and getpeername() return real
> addresses through inet_getname() or inet6_getname().
>
> quic_setsockopt() and quic_getsockopt() used to return -EOPNOTSUPP for an=
y
> level other than SOL_QUIC. They now pass the call to ip_setsockopt() or
> ipv6_setsockopt(), and to ip_getsockopt() or ipv6_getsockopt(). With
> CONFIG_NETFILTER the call can also reach nf_setsockopt() or
> nf_getsockopt(). For unknown levels the error changes from -EOPNOTSUPP to
> -ENOPROTOOPT.
>
> SOL_IP and SOL_IPV6 options set this way change state that the new helper=
s
> read: inet_sk(sk)->tos, uc_ttl, np->tclass, SNDFLOW and ipv6_only_sock().
>
> Could the commit message mention these changes? The subject also still
> says "family ops", but v3 replaced the ops abstraction with if/else
> helpers.
>
> > diff --git a/net/quic/family.c b/net/quic/family.c
> > new file mode 100644
> > index 0000000000000..73f3b955e13c4
> > --- /dev/null
> > +++ b/net/quic/family.c
>
> [ ... ]
>
> > +static int quic_v4_flow_route(struct sock *sk, union quic_addr *da,
> > +                           union quic_addr *sa, struct flowi *fl)
> > +{
>
> [ ... ]
>
> > +     security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
> > +     rt =3D ip_route_output_flow(sock_net(sk), fl4, sk);
> > +     if (IS_ERR(rt))
> > +             return PTR_ERR(rt);
> > +
> > +     if (quic_v4_is_any_addr(sa)) {
> > +             sa->v4.sin_family =3D AF_INET;
> > +             sa->v4.sin_addr.s_addr =3D fl4->saddr;
> > +     }
> > +     sk_setup_caps(sk, &rt->dst);
>
> [Severity: Medium]
> Should quic_v4_flow_route() reject RTCF_BROADCAST and RTCF_MULTICAST
> routes before caching the dst?
>
> Other IPv4 socket types check rt->rt_flags at this point. For example,
> __ip4_datagram_connect() does:
>
>         if ((rt->rt_flags & RTCF_BROADCAST) && !sock_flag(sk, SOCK_BROADC=
AST)) {
>                 ip_rt_put(rt);
>                 err =3D -EACCES;
>                 goto out;
>         }
>
> raw_sendmsg() has the same check. tcp_v4_connect() returns -ENETUNREACH
> for both RTCF_MULTICAST and RTCF_BROADCAST.
>
> Without such a check, a QUIC socket can cache and send on a broadcast
> route (255.255.255.255 or a subnet-directed broadcast) without
> SO_BROADCAST.
>
> On the server side, the reply destination comes from the source address
> of a received packet. With rp_filter=3D0, the kernel default, a spoofed
> source equal to the local subnet broadcast (e.g. 192.168.1.255) gets past
> ip_route_input_slow() and fib_validate_source().
>
> Would the server's replies then go out as link-layer broadcasts to every
> host on the LAN? That multiplies the 3x anti-amplification budget by the
> number of hosts. A userspace QUIC server on a UDP socket would get -EACCE=
S
> from sendto() in this case.
>
False.

The spoofed broadcast source) is already blocked by the IP layer for
multicast and 255.255.255.255, and by fib_validate_source() for subnet
broadcast on any system with rp_filter >=3D 1. The remaining gap: subnet
broadcast with rp_filter=3D0 is narrow, and the 3x anti-amplification limit
further constrains it. It's a defense-in-depth improvement, not a security
hole.

> > +     return 0;
> > +}
> > +
> > +static int quic_v6_flow_route(struct sock *sk, union quic_addr *da,
> > +                           union quic_addr *sa, struct flowi *fl)
> > +{
>
> [ ... ]
>
> > +     dst =3D ip6_dst_lookup_flow(sock_net(sk), sk, fl6, NULL);
> > +     if (IS_ERR(dst))
> > +             return PTR_ERR(dst);
> > +
> > +     if (quic_v6_is_any_addr(sa)) {
> > +             sa->v6.sin6_family =3D AF_INET6;
> > +             sa->v6.sin6_addr =3D fl6->saddr;
> > +             if ((ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_LINKLOCAL))
> > +                     sa->v6.sin6_scope_id =3D dst->dev->ifindex;
>
> [Severity: Medium]
> Is it safe to dereference dst->dev here without rcu_read_lock()?
>
> This code runs in preemptible process context, under lock_sock() through
> quic_packet_route(). A dst reference does not pin the original
> net_device. On unregister, dst_dev_put() does:
>
>         rcu_assign_pointer(dst->dev_rcu, blackhole_netdev);
>         netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
>                            GFP_ATOMIC);
>
> That drops the reference on the old device. This reader is not inside an
> RCU read-side section, so the synchronize_net() calls during unregister
> do not wait for it.
>
> If the task is preempted after loading dst->dev but before reading
> ->ifindex, can it read freed net_device memory? Even in the harmless
> case, it could store blackhole_netdev's ifindex as the scope ID.
>
> include/net/dst.h provides dst_dev() and dst_dev_rcu() for this.
> sk_setup_caps() on the IPv4 path reads the device through dst_dev_rcu()
> under rcu_read_lock().
>
True.

But the practical risk is low: this code only runs for link-local source
addresses, which is uncommon, and the window between loading dst->dev and
reading ->ifindex is tiny. Even if the race occurs, the most likely outcome
is reading blackhole_netdev->ifindex as the scope ID, incorrect but not a
crash.

There's a similar case in quic_v6_get_pref_addr() in the subsequent
patchset. I can fix both there when adding the function.

Thanks.

> > +     }
> > +     ip6_dst_store(sk, dst, false, false);
> > +     return 0;
> > +}
>
> [ ... ]
>
> > +int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_a=
ddr *sa,
> > +                 struct flowi *fl)
> > +{
> > +     if (sa->sa.sa_family && da->sa.sa_family !=3D sa->sa.sa_family)
> > +             return -EINVAL;
>
> [Severity: Medium]
> Does this check reject a valid dual-stack setup?
>
> An AF_INET6 '::' source (a socket bound to the IPv6 wildcard) with an
> AF_INET destination fails here. quic_v6_cmp_sk_addr() accepts that same
> pairing on receive:
>
>         if (a->sa.sa_family !=3D addr->sa.sa_family) {
>                 if (ipv6_only_sock(sk) || a->sa.sa_family =3D=3D AF_INET)
>                         return false;
>                 return quic_is_any_addr(a);
>         }
>
> So a stored AF_INET6 '::' address matches AF_INET traffic on receive, but
> routing refuses the same combination on transmit.
>
> Suppose the later bind() and connect() code stores a bound [::] source
> as-is. Would a client bound to [::]:port that connects to an IPv4 peer
> then fail in quic_packet_route()->quic_flow_route() with -EINVAL? The v14
> changelog says IPv4-mapped addresses are converted to AF_INET, so the
> peer address would arrive here as AF_INET. Plain UDP allows this on a
> dual-stack socket.
>
> Dropping the check alone would not fix it. quic_v4_flow_route() reads
> sa->v4.sin_addr, which overlays sin6_flowinfo, so an IPv6-wildcard sa
> would need to be treated as IPv4 ANY.
>
> The v15 changelog shows the family mismatch check is intentional. Was the
> dual-stack wildcard case considered?
>
False.

The dual-stack server case works correctly. accept sockets and stateless
reply paths use addresses from the received packet, which are already
family-matched. The only affected case is a client explicitly binding to
[::] then connecting to a bare IPv4 address, which is uncommon. clients
typically either auto-bind or use IPv4-mapped addresses. We can address
this in a follow-up if needed.

> > +
> > +     return quic_af_ipv4(da) ? quic_v4_flow_route(sk, da, sa, fl) :
> > +                               quic_v6_flow_route(sk, da, sa, fl);
> > +}
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1795393690.git.lucien.xin%40gmail.com
