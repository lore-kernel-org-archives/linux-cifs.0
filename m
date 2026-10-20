Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792531994;
	b=mdJ6KctE7ZhQQccUD8a9p2c0wcq/YkymJDvqUq1JtYi9NYCXTOAiRkab7nfXjKtQ63zI
	 sl8W/QLN3USTomj/pQnd9kuFMLxabwK4wP0qeFMay2UT2UXW9jOUCPmmNmTC8m1u7dZyc
	 6wsB73fVDH3F8sJHyeNQRd4ZNyvCfJZbEudEFY1LsZiDczekI0KwdCJ0xRWvJqJQYSMzo
	 pwYOBSF2to8pjqVlY6BCRsov045euKtRVC3X7d1j2i3QjSJb4bINVTqJGZuB6JqWtmnW+
	 AuFB+rlsp3V6oW/RyVgrVJdnrEsonHykDUe2NOCV0ps862WrJqZR57g2+Amhgt0owAQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792531994;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2AgfGA8Z+ldUgBgGgA9RrGOTzaa/n9KB7xtFx5qm7gA=;
	b=vFiLaOQk9krKzM3yOnMhHeRyld67tSQgDfMjEIIYUp8lj1YSWApxP+ebJB5xnvoJ/BPW
	 ZNIILkCp9PUibW8j9GUwt+OFzBSVnl1JiUhZr1yxpfZBfkNW3+xnLHGTkG6T9FGTRkYFQ
	 HWzbyMVnJOXXlyEa4GgHPqKpcc+F3hjmHC85VzTSfluaU83Yt/7zvEVCZJb89E24odJXK
	 8tKMoLOvc+Ldv4x3gNcMGD06JAPRW3keJwvNaXdQF8A8/7B39THft7aTNMJG/cHCkRuIv
	 uVGmJ1g83syCZiaSLD0cy6A79OE4Mhmkrxgi8l1kKiPIDyVvaXAbVsU1ZAuM1H+YayA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PstJMPG1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51233606A319
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 21:33:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51233606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PstJMPG1
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-868b3248b2cso38226b3a.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 14:33:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792531994; cv=none;
        d=google.com; s=arc-20260327;
        b=JqL2HvsVumA+3QGGkD7H3AwizHs6PDMQ4LBYv94Ka8e9RU/Bzv6FlD8TXtj4RhrmBp
         YVyVL/dvCsOaimWzsKWp1woJ4ArlPgGd7enNCP7DQkbNVkk84w0Cq5qfZQF3XzjcxcNp
         G22CRtoDKZWnR8O3pIBNLMzenIE0yZkH9xa7P4o5LtAFxktY46TnRrspb2WKjZSdcH02
         bd14gBSv2LZ1VcdZ8OBFON8W+EWNjQ75WKVYO2SBRK54Q2A4S9f3ArDp8Nnt8+5yZyCP
         FOGszIaizQ61YvY2NDP1klxSEJIyOBrFb55xI35m1AAV5KaKn/iicljYryHmMoeLzVJI
         /pbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2AgfGA8Z+ldUgBgGgA9RrGOTzaa/n9KB7xtFx5qm7gA=;
        fh=lR4muEjXRyeglZdO5HSTwUFD9FX540bDe3FyTp6dA4c=;
        b=oILlQB2wDFx0uNgLwkmxcnPtLn+Q6Y87KHSs8M7yw5Hhd3w6wue5rgyOmEHddi5K+G
         UJrWOXsEwUR0myEiMUIDElpp3yVjJ64k/69FNXGk2M3NchU0SX+DIL77OaFDE9MhAAXD
         sD42im2VMmnRtklEM1+YTXipXCMuFV2jMEfunRKwGk+rqVJTUn4zBaUw6kuWKYcAgous
         zxVh7VIsoFU9ydKUmrniQ9Qv/1rVLNw+MfJr3HSCQ8SUmL7JSSFr76J7CoMXEmjGVgNb
         PlE4RTYwHWQR7gTnYkJ74pBdgjTUhQeaSWh0jnTOZWAtiXMUytQqP1nHBnCJFhtCN8Oa
         z/DQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792531994; x=1793136794; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2AgfGA8Z+ldUgBgGgA9RrGOTzaa/n9KB7xtFx5qm7gA=;
        b=PstJMPG1RCu9TauBU0uB7KK9t8qQe8psNqbqWWlhVLK54wLJTJnY2a5ocHf2B1+BaY
         j1MoWGReMJHIxTj5NvHLrvWc/33+wXPz0yI3rZZbnOys9hb29EhmglXVTFnWaV7CxVUD
         jAclk5I4DRiymGDTXibLowpbsasxuYt3ijZWKNluS3euv6k3YwbrcBj24NKlKhtd50ft
         jXGFc4/Px99ALtZ3Jsksflt/E1jlhhehC45+VuYSPyVRaynzqYfkk2t3F8HBKrrE6zA6
         UEP61voehlpy2YEWIv4qOpVUkjOlQrM+18YSmELM+ImFQEljc83HQhYJDImCsC5LoHuR
         yxzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792531994; x=1793136794;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2AgfGA8Z+ldUgBgGgA9RrGOTzaa/n9KB7xtFx5qm7gA=;
        b=hAPhde53twcwe0ILbNnZIzYR7FGr0WJzp/lYXP+2tdInkJ/gpMU0zdY4y91hce4wwr
         TO/upZAcWEotfsDeV2K7vC58cOty5+1Z8atulVtw8JIW+RtjzhA9ECuh/SPP9qgkeEJx
         CnjBcXeFLiEy1hxntaPDt00KKH0Bb2H5D/Zw9kZN9dnjzXPrwlVw4mJH71gcaM2AWsiI
         P0qFfWlVRDebEjfNJOtOie8LT/UYVhJPTTPjeI/9EOmGImCByjR6R0/mer57u20+OXlx
         owI8wkrCk4cckcZ3P+Y6lF30ITqkKzE5HCj8OFJTEaKhasrF1GXX63TUGA9+mRescnam
         xBHQ==
X-Forwarded-Encrypted: i=1; AKwUvBz6/2A27OiCgKfCZUhCiiwkUOKpx1HIG55H5kAGlHtgMy/Yu1ys3GUcG/0DDNT70MMmrif6dlP2RP0u@vger.kernel.org
X-Gm-Message-State: AFq9FYLmPIgFssg8s2GU4HJJT9Pp4xw9Eh9Z2lG/bkXTd3DZtfdt+Edz
	WL1ApHnntYZ0os7PIcfebr5mze7cq1BLchEbX39t55kHgA1g+whTu7rF72H3E4YToSPu4/Fmu7r
	pNL2j9BL8/+DunkNolV3+0cYnyIUz3xc=
X-Gm-Gg: AYBFou0H6l4LW2PG+ZWvgh0YlpGtmyhfc/0aHsApQ9YEaZV9/pIu4E/FgNrD1nx+o36
	eSldLTgqwFzDuXpSy/j5AyxtZO+bVzyW0dDj3IvF7ex1wpPMpJL86cG7AdArSxjQvnPIOKzLC4z
	XNI/n4gmyD2EF5I64PsZffTnZjLSH7/ebjZyJQeX15gzWt5AUqieCZXQKgDYBvgnp/axByYCPOD
	BOf6ovA53AG5wgTeooVhs6i7B7G6IX1mppNbig16UE8FfVD1n5Cxmjsb6FA0WFcU2JtqF0FXupv
	loCPoqxe67+RZfgZUwqWRBWSO58tEf4vW7EzKLFPWUzrKUBCdUxjHPTqOjhgJmfxkVOjYtszeLE
	LJko1TORzt1D1N2xSeahrd35GyQQYJRPsrS31/6OW7WkxMj3/43CXMcSnA30c1pFlgL8U0jsHsI
	bWI3fmWljRphrR
X-Received: by 2002:a05:6a00:a0c:b0:89e:779b:d0f with SMTP id
 d2e1a72fcca58-8a089dfdbb8mr140032b3a.37.1792531993626; Tue, 20 Oct 2026
 14:33:13 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <ae36949f7685ef74318d3c742f02e1398db3b454.1792164438.git.lucien.xin@gmail.com>
 <179244539859.3135.15973054396060254186@kernel.org>
In-Reply-To: <179244539859.3135.15973054396060254186@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Oct 2026 17:33:00 -0400
X-Gm-Features: AclHuK-OS8Rlsq-Vf92z9Ck0SMvPAMUJ9Zd-S0XjwZRWioNbmezgdXlvGsvI2pg
Message-ID: <CADvbK_en5dm-psb_eXs26y1bYTNq8_76eHv6ZWX_FbcSPjv8Zg@mail.gmail.com>
Subject: Re: [PATCH net-next v17 08/15] quic: add path management
To: netdev-bot+sashiko@kernel.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 5:30=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 2 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] quic_udp_sock_create() in net/quic/path.c zero-initializes
>   udp_conf and fills it with quic_udp_conf_init() ->=E2=80=A6
> - [Medium] IP_FREEBIND (and the IPv6 equivalent) set on a QUIC socket has
>   no effect when a new UDP tunnel socket is created.
>
> --
>
> quic: add path management
>
> This adds struct quic_path_group and struct quic_path to manage the
> active and alternate paths of a QUIC connection. Each path is bound to a
> kernel UDP tunnel socket, which can be shared and is tracked in a
> per-port hash table. The patch also adds bind, unbind and swap helpers,
> alternate path detection for migration, and basic PLPMTUD state handling.
>
> > diff --git a/net/quic/path.c b/net/quic/path.c
> > new file mode 100644
> > index 0000000000000..ba7e2c952a36a
> > --- /dev/null
> > +++ b/net/quic/path.c
> > @@ -0,0 +1,596 @@
>
> [ ... ]
>
> > +static struct quic_udp_sock *quic_udp_sock_create(struct sock *sk,
> > +                                               union quic_addr *a)
> > +{
> > +     struct udp_tunnel_sock_cfg tuncfg =3D {};
> > +     struct udp_port_cfg udp_conf =3D {};
> > +     struct net *net =3D sock_net(sk);
> > +     struct quic_uhash_head *head;
> > +     struct quic_udp_sock *us;
> > +     struct socket *sock;
> > +     int err;
> > +
> > +     us =3D kmalloc_obj(*us);
> > +     if (!us)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     quic_udp_conf_init(sk, &udp_conf, a);
>
> [Severity: Medium]
> Should the tunnel socket take its IPV6_V6ONLY setting from the QUIC
> socket that owns it?
>
> quic_udp_conf_init()->quic_v6_udp_conf_init() fills in the family,
> address, port, checksum flags and bind_ifindex. It never sets
> conf->ipv6_v6only:
>
> net/quic/family.c:quic_v6_udp_conf_init() {
>         conf->family =3D AF_INET6;
>         conf->local_ip6 =3D a->v6.sin6_addr;
>         conf->local_udp_port =3D a->v6.sin6_port;
>         conf->use_udp6_rx_checksums =3D true;
>         conf->use_udp6_tx_checksums =3D true;
>         conf->bind_ifindex =3D quic_get_dev_if(sk, a);
> }
>
> udp_sock_create6() applies v6only only when the config asks for it:
>
> net/ipv6/ip6_udp_tunnel.c:udp_sock_create6() {
>     ...
>         if (cfg->ipv6_v6only) {
>                 err =3D ip6_sock_set_v6only(sock->sk);
>     ...
> }
>
> As a result, the kernel UDP socket always gets the net.ipv6.bindv6only
> default. An IPV6_V6ONLY value set on the QUIC socket through
> quic_setsockopt()->ipv6_setsockopt() is ignored. A zero cfg value also
> can't clear an inherited bindv6only=3D1.
>
> With bindv6only=3D0, could an IPV6_V6ONLY QUIC socket bound to [::]:P get=
 a
> dual-stack tunnel? That tunnel would also hold IPv4 port P and could
> cause unexpected EADDRINUSE for IPv4 binds.
>
> With bindv6only=3D1, a QUIC socket that cleared IPV6_V6ONLY gets a v6-onl=
y
> tunnel, and IPv4 UDP lookup skips ipv6_only sockets. Would IPv4 packets
> for that dual-stack QUIC socket ever be delivered?
>
> quic_udp_sock_lookup() also decides sharing through
> quic_cmp_sk_addr(us->sk, ...), which checks ipv6_only_sock() on the
> tunnel socket. A wrong v6only state would therefore also change which
> QUIC sockets end up sharing a tunnel.
>
> quic_path_bind() has no caller yet in this series, so this would only
> show up once quic_bind() is wired in by the next patchset.
>
False.

This is on purpose, as two quic socket may share the same lower
udp tunnel socket, we try to make the lower :: bind udp socket always
with bindv6only =3D 0 (unless net.ipv6.bindv6only =3D 1), so that two socke=
ts:

- bind(sk1, ::, 1234, ALPN=3D'h3', bindv6only =3D 1)
- bind(sk2, ::, 1234, ALPN=3D'smbd', bindv6only =3D 0)

can co-exist, the bindv6only check will be performed on the quic
socket layer like when looking up the listen socket.

if the tunnel socket takes its IPV6_V6ONLY setting from the QUIC,
the sk2 will never accept IPv4 requests.

> > +     err =3D udp_sock_create(net, &udp_conf, &sock);
>
> [Severity: Medium]
> Is IP_FREEBIND (or its IPv6 equivalent) on the QUIC socket honoured
> when a new tunnel socket is created here?
>
> struct udp_port_cfg has no freebind or transparent field.
> udp_sock_create4() and udp_sock_create6() call kernel_bind() right after
> sock_create_kern(), so FREEBIND can never be set on the new socket
> before it is bound:
>
> net/ipv6/ip6_udp_tunnel.c:udp_sock_create6() {
>         err =3D sock_create_kern(net, AF_INET6, SOCK_DGRAM, 0, &sock);
>     ...
>         err =3D kernel_bind(sock, (struct sockaddr_unsized *)&udp6_addr,
>                           sizeof(udp6_addr));
>     ...
> }
>
> The bind path then calls inet_addr_valid_or_nonlocal() on the new tunnel
> socket. That socket doesn't have FREEBIND set, so a nonlocal source
> address would fail with -EADDRNOTAVAIL.
>
> The QUIC socket accepts IP_FREEBIND through
> quic_common_setsockopt()->ip_setsockopt(). quic_get_user_addr() in the
> next patchset is described as honouring FREEBIND. Could bind validation
> then accept the address, only for
> quic_path_bind()->quic_udp_sock_create() to reject it?
>
> It looks like only the netns-wide ip_nonlocal_bind sysctl would make a
> nonlocal bind work here.
>
False.

quic_get_user_addr() will be called to handle IP_FREEBIND for user
addresses in quic_bind/quic_connect/quic_sock_connection_migrate
in the next patchset.

Thanks.

> > +     if (err) {
> > +             pr_debug("%s: failed to create udp sock\n", __func__);
> > +             kfree(us);
> > +             return ERR_PTR(err);
> > +     }
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1792164438.git.lucien.xin%40gmail.com
