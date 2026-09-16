Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9771137FF6F
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 15:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789571918; cv=pass; b=PcaOwFwg2UDChWzHbMYL+V+XJlRbuPtaBFmNrrlvGf3BtkX8aikt/G6qFQeE8TcFSmEzSyaSQF0Xh5IgNuLr4qiX5E5uCZrim+yFE+QHGy+7+JQhu9TTGzjA3aH4cCeDzDl2Lka7sZIwHpGii41SnjyDjXnVWh8ABGOtX6jR8Kc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789571918; c=relaxed/simple;
	bh=Dj+80PpyFtuTTPI24RANQuQHDc3eXfflbc+ICFvzogo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N72e5LF7zZo71cPCUNMh+f2B80btBNUi4cny7C84p5v3Tp6DEYgFyNUrExsJ3rEhQNsaIpRLVk3mZgv3kXorUg2VNp5P2akKTsX8AxYBu8qyD0WFAmGFDajCuWrXmO6NsC4JjlKxyCoO4nHeS9D8Cdo8jNpkFysOIMRr8ccFgxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p6Fz9oeg; arc=pass smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p6Fz9oeg"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469f204f6so651785b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 08:18:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789571916; cv=none;
        d=google.com; s=arc-20260327;
        b=KX217sbsIia0KufgZbkiqdBx/+a/HZapHVkQpVgbS+Dw4THsIrcKfbWrrIu6x6u2fj
         a8PNujtBxGteszohAIAw2OE5Fuf88VLn9yopUW2CB3xMCapDXqePudFLpTBfJqwkWund
         luEbnie3/reb0AQtJddVmiif2uxytAhH1ixE04gaVHbEGIceyA/+VkU76+3Avd3Yme0U
         52+kRXJPN18M9SsZzY3e/FKo0HWQXZH9ZmJHff8MnnlhPNIFE/FQSheZEyIay7CAQI2o
         cTgePr96J8U6oxw5tPEMDtDgyPFaBCBq6gTjlec4K3SHy5sjhKotQNXULaIYP50GtnDP
         wlKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BhkqwMNKc8zR/oVQWFJv9edBfd9F+9BsRk6J/+nHhu0=;
        fh=mFX+YTPTIPHky0UYmsHBc94aKOTJFv3NaDpFlC5ThdQ=;
        b=dWr2JPm6WcTHQgAl4SqKTEVd9dOQX2Uf4PDTArKGZ5WWAxh/SBRoICqnCrACZiETDx
         SPCzS2VRGbR/1jFsi3ZsAtP8/79XwIlgIEdFzEVPNLLc1ArnCg5cfr6X7RzMb5aj+gaq
         LFd/SF8eDQGgnJcataxXRbjn9//tXbT3hmic5VpVdHP4b/ZSbZPx1FwvP8ICnFQyjeMX
         x80wpApZfw0UMM5ottsr0h/19KjmpQ5W57u0+Po/4GoDmnwNEzqtoi5FWNZHyxRlx2eD
         7dT4xChEHAtjFRJqet3V5m7b5MK9WcNGl52/INOGWZTytlLysH2Z2bykVb2IIII4v+Ak
         ZcIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789571916; x=1790176716; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BhkqwMNKc8zR/oVQWFJv9edBfd9F+9BsRk6J/+nHhu0=;
        b=p6Fz9oegCiY0ldDuMQC7sX59TPJXzw7/kyXWVmfnl4qllZ4GRV9nfMxf0QtI57k0xS
         JpVtRCXr1hZJH9TPgqJl+kiUqIXVzjduJ7pIQ/XBT1oAMGKaQFieqanEKMraRsACm/yz
         79TlIcVSC3b4rJ5NiihuJNqbJCpyBw0B8uBj2kH8HXF09pxpUXj5ssitf4xByslbSmnp
         VfVfhB0ddLZNAys6ry4cGKz/v8Ika4hE3yv8w8Ml+dRPUQGih3FMqWvrBWHoWoNbH9Bm
         SKCQfMHWzfzK34VK6DZoNL3VlZcLw0aUoCahoePztk0ik4MaO2x74g+sHjqCWz+9k3PJ
         6UYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789571916; x=1790176716;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BhkqwMNKc8zR/oVQWFJv9edBfd9F+9BsRk6J/+nHhu0=;
        b=2UVdX4r3odKW9sBTFBTty4XqOyZeLG9Z/ksLAfLoLrXiZQ5L05Iwq/rRvMh8Xqk218
         nuVOnLHKSoM4mpf41T2nLGJ78qra6+xFV0vEgag+yfVABJM4MtRdxXY/yWqO7hWUbbXh
         1FdxD4SrFkCqaL3dVudW8FBibzXqcRaD9yLZUXWzMdBG0cFAYvGDffbIpXnBlRXO0tvJ
         8mdRnXF4Fwmsqw/rw6BkOVhQRprDuz70xuZWCtnDlzjBHCe0ne0kw00JBx0LM1Fem4IX
         Z5m3vvjmPraHdu1Oc36DBPbwu39+XcjFz4nrrzi4aAksjUAFh0i61wJ9RVttfMuyMk72
         DxOA==
X-Forwarded-Encrypted: i=1; AKwUvByQShP1557o6BaO+Xuq3yZK8KhJPeoyLW5btUH2f5wRfu5PEfdmF2CDPVJwo1vUoKzs1w89/UYwFUeO@vger.kernel.org
X-Gm-Message-State: AFuF++kX4xNv592GHc1fPYjs110nx1sN02ijeJnxF9MPRy87bt7/l3O8
	U+BJ/z3TPmAz4UIHgBGMZIiPh2DeD79ihXtuHvsQNhLdAVoitPiuj5OhBGboAaueFQj+4a2Qwbj
	X3ocenkDEfiTCKD6sboe3Rn2IaR0TZ2M=
X-Gm-Gg: AYBFou081WYJm2A1ikJSXC/JW/KziRS/SYviRkHAICrw5L1l4lxdipH0uqjJovfzNuQ
	2+6I6oGbOirSvgwPMgqxqHheAtApO2UYg1M4YnsK2bK/lu3gGf0/+lCknJ0IsVUJ21brfVCCk5Y
	4vrg2EQLznZBXvFBg9w6VGRJvOHGS8GG3+HGPeRNgK5kvseJAu/+k3crLmxyrnZtKM1aWNnsTEY
	EjDe8rTI5NCv5OGIyJGJMQgJUDLMFiL+ZRjk3ZMNVeKCVp+DlfCNG/8dCdMkzck0fBwaozYheUR
	RFUu2NzkxH2mkhnaDQssDzUBgvPNnMtBXBpgYIAU4X6cvLnmO0oBh/BmwmZVHOtviQlnAPUp1dH
	m7WPmCB3iP0XCxRcPqyYpUu92exGPqkcDw0t4lggi3q51ZLGhxs2Vm/Q46QNHRI90WeE=
X-Received: by 2002:a05:6a00:c481:b0:872:6004:f117 with SMTP id
 d2e1a72fcca58-8726004f36dmr4040074b3a.24.1789571915717; Wed, 16 Sep 2026
 08:18:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1cf83a4eb178197cd842e34468f4e357f42b9c28.1789393775.git.lucien.xin@gmail.com>
 <178950182306.22033.14152384539754204368@kernel.org>
In-Reply-To: <178950182306.22033.14152384539754204368@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 16 Sep 2026 11:18:23 -0400
X-Gm-Features: AcwNN1UEOUO9io4IO0BxkvntuRVWDPeW_lFsEE-noRtB4rxUETC2sWqvf53BLHc
Message-ID: <CADvbK_ejURHE3C6BPv+b=Qnu8jPAcWDHMmqYOyEQ324_qsgknA@mail.gmail.com>
Subject: Re: [PATCH net-next v15 03/15] quic: provide common utilities and
 data structures
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
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 3:50=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> - [Medium] Weak hash seeding in the new QUIC hash helpers:
>   `quic_sock_hash()` (net/quic/common.c:40-53) reduces IPv6 addresses to=
=E2=80=A6
>
> --
>
> quic: provide common utilities and data structures
>
> This patch adds net/quic/common.c and net/quic/common.h with the QUIC
> packet header types, connection ID and address helpers, the socket and
> connection ID hash tables, and the varint/transport-parameter encoding
> helpers. quic_init() now initializes and tears down the hash tables.
>
> One question below about the hash helpers.
>
> > diff --git a/net/quic/common.c b/net/quic/common.c
> > new file mode 100644
> > index 0000000000000..51d71b6733c7d
> > --- /dev/null
> > +++ b/net/quic/common.c
> > @@ -0,0 +1,565 @@
>
> [ ... ]
>
> > +u32 quic_sock_hash(struct net *net, union quic_addr *s, union quic_add=
r *d)
> > +{
> > +     u32 ports =3D ((__force u32)s->v4.sin_port) << 16 |
> > +                 (__force u32)d->v4.sin_port;
> > +     u32 saddr =3D (s->sa.sa_family =3D=3D AF_INET6) ?
> > +                 jhash(&s->v6.sin6_addr, 16, 0) :
> > +                 (__force u32)s->v4.sin_addr.s_addr;
> > +     u32 daddr =3D (d->sa.sa_family =3D=3D AF_INET6) ?
> > +                 jhash(&d->v6.sin6_addr, 16, 0) :
> > +                 (__force u32)d->v4.sin_addr.s_addr;
> > +     u32 hash =3D jhash_3words(saddr, daddr, ports, net_hash_mix(net))=
;
> > +
> > +     return hash & (quic_sock_hash_size() - 1);
> > +}
>
> [Severity: Medium]
> Should the inner IPv6 fold in quic_sock_hash() be seeded?
>
> The per-netns secret is only mixed in the outer jhash_3words() call, whil=
e
> the 128-bit address is first reduced to 32 bits with jhash(..., 0). Since
> jhash_3words(a, b, c, initval) is a pure function of its inputs, two peer
> addresses whose unseeded 32-bit fold is equal produce identical (saddr,
> daddr, ports) triples and therefore the same bucket for every value of
> net_hash_mix(net).
>
> Does that let a peer controlling an IPv6 prefix pick colliding source
> addresses offline, without knowing the secret, and collapse many
> connections into one chain of quic_hashinfo.chash (capped at 16K buckets)
> that the per-packet lookup then walks?
>
> Compare with sctp_hashfn() in net/sctp/input.c, which the commit message
> cites as the model and which passes the seed into the inner fold:
>
>         if (paddr->sa.sa_family =3D=3D AF_INET6)
>                 addr =3D jhash(&paddr->v6.sin6_addr, 16, seed);
>         else
>                 addr =3D (__force __u32)paddr->v4.sin_addr.s_addr;
>
>         return  jhash_3words(addr, ((__force __u32)paddr->v4.sin_port) <<=
 16 |
>                              (__force __u32)lport, net_hash_mix(net), see=
d);
>
> Would jhash(&s->v6.sin6_addr, 16, net_hash_mix(net)) here be equivalent i=
n
> cost?
>
> [ ... ]
>
> > +struct quic_shash_head *quic_source_conn_id_head(struct net *net, u8 *=
scid,
> > +                                              u32 len)
> > +{
> > +     u32 hash =3D jhash_1word(jhash(scid, len, 0), net_hash_mix(net));
> > +     struct quic_shash_table *ht =3D &quic_hashinfo.shash;
> > +
> > +     return &ht->hash[hash & (ht->size - 1)];
> > +}
>
> [Severity: Medium]
> Same pattern here: the connection ID bytes are folded with jhash(scid, le=
n,
> 0) before the secret is applied, so any two connection IDs colliding in
> that unseeded fold share a bucket for any secret. Would passing
> net_hash_mix(net) as the initval of the inner jhash() be preferable?
>
> Note the connection IDs inserted in this series come from
> quic_conn_id_generate() using get_random_bytes(), so the practical exposu=
re
> is smaller than for the connection socket table.
>
> > +u32 quic_addr_hash(struct net *net, union quic_addr *a)
> > +{
> > +     u32 addr =3D (a->sa.sa_family =3D=3D AF_INET6) ?
> > +                jhash(&a->v6.sin6_addr, 16, 0) :
> > +                (__force u32)a->v4.sin_addr.s_addr;
> > +
> > +     return jhash_2words(addr, (__force u32)a->v4.sin_port,
> > +                         net_hash_mix(net));
> > +}
>
> [Severity: Medium]
> And the same unseeded sin6_addr fold appears in quic_addr_hash(), so
> address-keyed hashing inherits the same property. Should all three helper=
s
> be updated together?
>
False:

Not necessary. The per-netns net_hash_mix(net) is already used as the seed
of the final jhash_3words()/jhash_2words() call.

Thanks.
