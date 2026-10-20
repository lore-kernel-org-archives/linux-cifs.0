Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792530193;
	b=EZfbQzXCAOxsXhlqaGqjfY2oWx9WfYsJIfibG4nMJeECDv+Zf5FnKHvhA7dxxkIHuo4e
	 yrclrw3McPFVV8a4XiZFCw3z7o7ESgg4z7KtoHiHQrZ3sG2i0nBM7i0ZiB5prVVeeFE2s
	 Jpf5AcdtxghT/Q99ecXzBNT6dYHmassSgDXKha3ah5Woq59TS2zzv0RqVfmPtTzsU+eJy
	 mjuRPksTOEs/QYr+aPhBkEAk7CDguc7LuLdemDjmjyWJO7QMlobHUnt7PrHXWxBrFZgET
	 PVMVJkJWbMoNAgZIh3TInudacikzKDoP+RLVG4It5iVZZ8nIb/m6csHKN++RwJqPD2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792530193;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=P+M7CfskTRpfCCmHZHh6Qk0GgoGpx6QjJDA8d2t+rA0=;
	b=DEuQoV6wyN78J4L9/wjBedGP6+eO9soIA1+RZbNiLzhLOgbpO0yiZFwYE1C1XSeUirp1
	 kphGCGmnjxc6eX+4o01f+dp+STFl86QTveBHtw6WUQ2sHY56dgnHWMDnN9ily9xGA4z6Q
	 pa7AYB45dIbEnMeYUQlVE9nVXzykrYdgd21Hb2Yjd9T5Wt5SEtllOUjNm6qCJIXO9oBya
	 cLRwIanJvMir9dLLMM09yFCpr5BBTs2Hfk6mrNRUORyw0BZuhjnD1ENXogJqEDo8yruI1
	 yTsm/MK3N89JAe4kduTfGqquBI7/fu3d65JzguqBMUEhBQXmfdTRstJK0gLQHySTOQQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=tJN6tuJI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71AB606A31C
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 21:03:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D71AB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=tJN6tuJI
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a06c60065fso33564b3a.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 14:03:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792530192; cv=none;
        d=google.com; s=arc-20260327;
        b=onAlfsc+Q47CKcPf+menPNwR4JnUcTJ1G3+lLtYgJwz+fP4JmsvSk6RMy9VZMlbxdo
         fujuawkk5IK/2h12YuOm6B27lZxFLsHtAwMEx44W9o5HuaEDEeDjDqfmdgaI5SP4ZeKN
         d/dIdJgMHobgk0Tg4d7Y3gAtpTBXVPoLg6Yn4k5fcnPf6uIdYbyTPk0BPQL5T3UJvdGv
         XhcJTdZSloPvfzct4oOWFl2Vkn5XASf8gtHZhOQ5QVc+o9Qivb3d2Zk0MHvblnRbvxI6
         xftVzQSJwYH40QMl2it2ep9KbLgkDsKdOrdGks0tAjQfxvdU6Vd0+XJEJDkA479qlmPM
         SUYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P+M7CfskTRpfCCmHZHh6Qk0GgoGpx6QjJDA8d2t+rA0=;
        fh=bKlVAZIQcIIbUE3UwZ81CAxaOdSdVuB1CfUOyNU3LM8=;
        b=XAEt6Tw6WM2EMrYih1QcBL/Lk/KxrjD9PqlOFV4v8swTer/aQiiDPf3tncPuWnZNMj
         88wfl6KeiROyxPHAfNYp81nzwvcZDuE+/lZwgQtVjOTEjzSBRHwrr7pgBTTgX40T3gBz
         GcnCtkUCrxPo7PAEPDBt24E59GImtf9sXCvfasW6K12Wc+JWYg6hCCp/fV1M2AbJUkn4
         /BOwyvfx/3HIX1Zd6NaXmsaAZH+9yx/CZ/cGkPPjOcrJH+A4d4ivV4b92k9a3hT3isL3
         mWzs/lCu3aKD4S65wjhtKxpJ/9g/4mKsSAeLrpdnIKC42dGlKUrkiP3meUegdIqRZ8Dn
         THPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792530192; x=1793134992; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P+M7CfskTRpfCCmHZHh6Qk0GgoGpx6QjJDA8d2t+rA0=;
        b=tJN6tuJI07puS/lEC0QBVbdXUfg40buwpv40xL8F1KCvDSaFk736Pm3ShYaaE4c1TD
         7kmos+zWVkhTUdgBjb63aaXL38p8bvDwNQoGESQfaxb8sfzag1B5JWHEIhaDLNObXVdo
         UTQ53XoB2XNHbnFq9xSJ3jKIQwX/dUvRLyiu570EvEFKETIn/HZGeI8d5mmaT8BQII6h
         k4oBiDcRRLJUgCQdipIjBTfOvy5PB4X4XxaB0cZZXpao5LpOXbmJL7OXe4SUmut3itMy
         47+bWftnySVLbdFON2iEYecVKyPcGZ8ck5s3aAUFibFTm0Jw7Ns22gmSvnB4vqCCFkGa
         7HgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792530192; x=1793134992;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P+M7CfskTRpfCCmHZHh6Qk0GgoGpx6QjJDA8d2t+rA0=;
        b=ZjypDMAj4ivi0XbauUTJcgtITyzVDga+z0NYZ7FxT2HO/iR5xZqUjVZtUub+ccVZ6p
         twW3nZA+Dx5+vcoxDUIbg6tOiOPfAuBHGiSjJtB51OdpC78Aw6C10jkSUTsrPC//gymS
         5m13azQFRpu3kLQsVV72b43Ie7+XBD3GAfHMNFz2TC22Hix7CMn56cpa1K/LCTJ4+OLg
         BgGf71HdxftBmqZwvCmCw1aNzsblB4Z6D7GNn7/YYWTnQzwiKBMGt3spLcHPCECSCPqO
         EWxTD9mtLV2u8lUmwRUXIygS1JDm6zbOZAyHmfFXcyyXct+0ad7UmWw5qkZueA0gysyH
         RRZQ==
X-Forwarded-Encrypted: i=1; AKwUvBwYwpZU4HbeSZq2AbdO0zwHUAQbYARrMDb9YFZKbJcgSJArngG51lNsgi1GxkghPNOK9JC0l2DWTUua@vger.kernel.org
X-Gm-Message-State: AFq9FYJs2jDNk4p9k6rkp74J+ZLiKaxnaJKcEpOrgtN0UCeD5gG+0dnO
	4G43d/4oD4Tg1riwH5837msFW65v2adt61jpHTvPbAI1V1BigzyXQtiN/IVAp8ZxRJoa9PbOGEr
	Afz/FUBK5AIcLsTySYDNXK8AgPOgcZwo=
X-Gm-Gg: AYBFou2mAfVUxjVj25/5h1H7fD3/NJ4gsRXwH6e+CkKGrhu1BqXs3vHA3+8eRUQPLU3
	rOAgpVi35QxMq5jS4GtuGHyfWCU1TuCO56CObqdAy9ClwK3odb+g9+LEhBC5wuzLB06KWkx9AKK
	ySMaKMPoqIYf9pAxo24Tgm2JGMXQ/4YNXUO9f3lvuuSL2Nl1/7uZ3Hq8xoVou7/T9iJcEKl9J4p
	Rsf0th/KwHkBi1IjpxmFT4d8eWh6TBtXTbfuyK3SfA5NMv098s6z78QSH4CxBJP1+M+rt048hRt
	zb3EzovquuMuLItKRFMZ7Ozjwa0/Y35lfUL8P8RwtTjS5u0dcjbNNR4LYg0AZMGasqGP8KwJKOZ
	zF5tuWFqy1AtjnF95QSfCaMsqoRPAKDF84nobvCyT2auKx0BXeB9e6NCg4JjOXfQ2Hya/LlvEhW
	x5uAuD7dAu3Q7d
X-Received: by 2002:a05:6a00:2da9:b0:8a0:8848:8c6c with SMTP id
 d2e1a72fcca58-8a089ce8f78mr109412b3a.12.1792530191760; Tue, 20 Oct 2026
 14:03:11 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <47ec29f97f3986e6b9cb5b07f109dcae340916e6.1792164438.git.lucien.xin@gmail.com>
 <179244541026.3135.1595523596507400028@kernel.org>
In-Reply-To: <179244541026.3135.1595523596507400028@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Oct 2026 17:02:58 -0400
X-Gm-Features: AclHuK8v95g8ztNuG9E9AbrqjvVlozrNsBMaZdXl4ZuQOU1-dXrL-PgzpONNaKU
Message-ID: <CADvbK_eiVcp=00D=2D5WToq+1P-U2n8FenQMqqTPbgS_3goDPw@mail.gmail.com>
Subject: Re: [PATCH net-next v17 15/15] quic: add packet parser base
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
> Thank you for your contribution! Sashiko AI review found 6 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 1 =C2=B7 Low: 4
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [High] When PLPMTUD is disabled, ICMP Packet Too Big messages never
>   lower the MSS.
> - [Medium] quic_accept_sock_exists() (net/quic/socket.c) passes an skb to
>   an accept socket's sk_backlog_rcv() while atomic: local_bh_disable()=E2=
=80=A6
> - [Low] quic_packet_get_connid() rejects any connection ID longer than
>   QUIC_CONN_ID_MAX_LEN (20) regardless of version.
> - [Low] quic_request_sock_backlog_tail() calls __sk_rmem_schedule(sk,
>   len) before skb_set_owner_r().
> - [Low] quic_packet_deferred_work() drains deferred_list while holding
>   lock_sock(sk) and never calls cond_resched(): `while ((skb =3D=E2=80=A6
> - [Low] quic_packet_get_alpn() prints the u32 field alpn->len (struct
>   quic_data in net/quic/common.h) with %d: `pr_debug("%s: alpn_len:=E2=80=
=A6
>
> --
>
> quic: add packet parser base
>
> This patch adds the QUIC receive path. Sockets are looked up by
> connection ID and address, and packets are dispatched by socket state.
> Listen sockets handle client Initial packets (request sockets, ALPN
> demux, deferred work), and ICMP Packet Too Big errors update the path
> MTU.
>
> > diff --git a/net/quic/packet.c b/net/quic/packet.c
> > index 56d2b8df292a0..a2f836cc22d70 100644
> > --- a/net/quic/packet.c
> > +++ b/net/quic/packet.c
> > @@ -14,6 +14,801 @@
>
> [ ... ]
>
> > +/* Extracts a QUIC Connection ID from a buffer in the long header pack=
et. */
> > +static int quic_packet_get_connid(struct quic_conn_id *connid, u8 **pp=
,
> > +                               u32 *plen)
> > +{
> > +     u64 len;
> > +
> > +     if (!quic_get_int(pp, plen, &len, 1) ||
> > +         len > *plen || len > QUIC_CONN_ID_MAX_LEN)
> > +             return -EINVAL;
>
> [Severity: Low]
> Should the 20-byte connection ID limit be applied before we know the
> version is supported?
>
> quic_packet_get_long_header() is called from quic_packet_get_sock() and
> from quic_packet_listen_process(). Both calls happen before the
> !quic_packet_compatible_versions(version) branch that sends Version
> Negotiation.
>
> So a long-header packet with an unknown version and a CID longer than
> 20 bytes is dropped as an invalid header, and no Version Negotiation is
> sent.
>
> RFC 9000 section 17.2 limits CIDs to 20 bytes only for version 1.
> Sections 5.2.2 and 6.1 say a server SHOULD be able to read longer CIDs
> from other versions so that it can send Version Negotiation.
>
> [ ... ]
>
> > +/* Process PMTU reduction event on a QUIC socket. */
> > +void quic_packet_rcv_err_pmtu(struct sock *sk)
> > +{
>
> [ ... ]
>
> > +     info =3D clamp(paths->mtu_info, QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX=
_PMTU);
> > +     /* If PLPMTUD is not enabled, update MSS using route and ICMP inf=
o. */
> > +     if (!paths->plpmtud_interval) {
> > +             if (quic_packet_route(sk))
> > +                     return;
> > +
> > +             dst =3D __sk_dst_get(sk);
> > +             if (dst) {
> > +                     dst->ops->update_pmtu(dst, sk, NULL, info, true);
> > +                     /* Re-read actual MTU after update_pmtu, which ma=
y have
> > +                      * rejected the increase. Only use values accepte=
d by
> > +                      * route layer to prevent spoofed ICMP from raisi=
ng MSS.
> > +                      */
> > +                     info =3D clamp(dst_mtu(dst), QUIC_PATH_MIN_PMTU,
> > +                                  QUIC_PATH_MAX_PMTU);
> > +             }
> > +             quic_packet_mss_update(sk, info - packet->hlen);
>
> [Severity: High]
> Does this ever lower the MSS when PLPMTUD is disabled?
>
> With skb =3D=3D NULL, ip_rt_update_pmtu() builds its flow key through
> ip_rt_build_flow_key()->build_sk_flow_key(), which takes the
> destination from the socket:
>
> net/ipv4/route.c:build_sk_flow_key() {
>     ...
>         __be32 daddr =3D inet->inet_daddr;
>     ...
> }
>
> When there is no packet header, __ip6_rt_update_pmtu() does the same
> with sk->sk_v6_daddr.
>
> Nothing in net/quic sets inet_daddr or sk_v6_daddr, and ip6_dst_store()
> is called with daddr_set false. The exception would then be created for
> 0.0.0.0 or :: instead of the peer.
False.

inet_daddr/sk_v6_daddr is always set whenever the dadd is updated/set
in the quic sk.

>
> Even with the right key there is a second problem. When
> update_or_create_fnhe() creates a new exception, it only marks the
> cached routes obsolete:
>
>         WRITE_ONCE(rt->dst.obsolete, DST_OBSOLETE_KILL);
>
> It does not change their MTU. The IPv6 path inserts a new RTF_CACHE
> route and leaves the old dst unchanged.
>
> So re-reading dst_mtu(dst) on the same cached dst would return the old
> MTU, and quic_packet_mss_update() keeps the old MSS.
>
> If that's right, the v17 change to re-read the MTU after update_pmtu()
> makes the ICMP-driven reduction a no-op. plpmtud_interval is 0 by
> default, so a path whose PMTU is below the local MTU could stall:
> full-size DF packets are dropped and the PTBs are ignored.
>
> For comparison, SCTP temporarily sets the socket daddr around
> update_pmtu() (to_sk_daddr()), and inet_csk_update_pmtu() re-checks the
> dst with __sk_dst_check() afterwards. Is something similar needed here?
True.

I will change to just call __sk_dst_reset() after .update_pmtu() and later
quic_packet_mss_update() will be called to update mss whenever
quic_packet_route() is called.

Thanks.

>
> [ ... ]
>
> > +     pr_debug("%s: alpn_len: %d\n", __func__, alpn->len);
>
> [Severity: Low]
> This isn't a bug, but alpn->len is a u32 in struct quic_data, so %u
> would match it. The v16 changelog made the same fix in quic_packet_rcv().
>
> [ ... ]
>
> > +/* Work function to process packets in the deferred list. */
> > +static void quic_packet_deferred_work(struct work_struct *work)
> > +{
> > +     struct quic_sock *qs =3D container_of(work, struct quic_sock, wor=
k);
> > +     struct sock *sk =3D &qs->inet.sk;
> > +     struct sk_buff_head *head;
> > +     struct sk_buff *skb;
> > +
> > +     lock_sock(sk);
> > +     head =3D &quic_packet(sk)->deferred_list;
> > +     while ((skb =3D __skb_dequeue(head)) !=3D NULL)
> > +             quic_packet_process(sk, skb, GFP_KERNEL);
>
> [Severity: Low]
> Was the cond_resched() from the v12 changelog lost in the v15 rework?
> The v12 entry reads:
>
>   "Call cond_resched() in the loop inside quic_packet_backlog_work()."
>
> Each iteration here can run synchronous AEAD decryption (cb->sync =3D 1),
> GFP_KERNEL allocations and token verification, all under lock_sock().
>
> On the quic_listen_sock_switch() path, the listener lock is dropped and
> re-taken in the middle of this loop. Under sustained traffic, packets
> processed from the socket backlog in that window can keep adding to
> deferred_list, so the loop keeps running.
>
> > +     release_sock(sk);
> > +     sock_put(sk);
> > +}
>
> [ ... ]
>
> > diff --git a/net/quic/socket.c b/net/quic/socket.c
> > index 0173416d0368a..c75d2dcaba9d4 100644
> > --- a/net/quic/socket.c
> > +++ b/net/quic/socket.c
> > @@ -24,6 +24,319 @@ static void quic_enter_memory_pressure(struct sock =
*sk)
>
> [ ... ]
>
> > +int quic_request_sock_backlog_tail(struct sock *sk,
> > +                                struct quic_request_sock *req,
> > +                                struct sk_buff *skb)
> > +{
> > +     u32 limit =3D sk->sk_rcvbuf / sk->sk_max_ack_backlog;
> > +     int len =3D skb->truesize;
> > +
> > +     limit =3D  max_t(u32, limit, QUIC_MIN_UDP_PAYLOAD * 4);
> > +     if (req->blen + len > limit || !__sk_rmem_schedule(sk, len, false=
)) {
> > +             QUIC_INC_STATS(sock_net(sk), QUIC_MIB_PKT_RCVDROP);
> > +             kfree_skb(skb);
> > +             return -ENOBUFS;
> > +     }
> > +
> > +     QUIC_SKB_CB(skb)->backlog =3D 1;
> > +     skb_set_owner_r(skb, sk);
>
> [Severity: Low]
> Can this push sk_forward_alloc negative when the skb is already charged
> to this listener?
>
> Consider a second Initial packet for the same connection that was
> deferred through quic_packet_deferred_schedule(). Its destructor is
> already sock_rfree, and in quic_packet_listen_process() it takes this
> path, which skips skb_set_owner_sk_safe():
>
>         req =3D quic_request_sock_lookup(sk);
>         if (req) /* If request sock already exists, enqueue packet direct=
ly. */
>                 goto out;
>
> In quic_request_sock_backlog_tail(), __sk_rmem_schedule() reserves the
> memory first. skb_set_owner_r() then orphans the skb
> (sock_rfree()->sk_mem_uncharge()->sk_mem_reclaim()) and charges it
> again.
>
> The reclaim can return the pages that were just reserved, so the
> sk_mem_charge() that follows can leave sk_forward_alloc below zero.
>
> For example, start with forward_alloc 2000 and truesize 2304:
>
>   schedule adds a page:      6096
>   uncharge:                  8400
>   reclaim leaves:            208
>   charge leaves:             -2096
>
> Would orphaning the skb before the __sk_rmem_schedule() check avoid
> this?
>
> > +     __skb_queue_tail(&req->backlog_list, skb);
> > +     req->blen +=3D len;
>
> [ ... ]
>
> > +     /* Look up accepted socket matching packet addresses and DCID. */
> > +     local_bh_disable();
> > +     sk =3D quic_sock_lookup(skb, &packet->daddr, &packet->saddr,
> > +                           quic_path_usock(quic_paths(sk), 0),
> > +                           &packet->dcid);
> > +     if (!sk)
> > +             goto out;
> > +
> > +     /* Found a matching accept socket. Process packet with this socke=
t. */
> > +     skb_orphan(skb);
> > +     bh_lock_sock_nested(sk);
> > +     if (sock_owned_by_user(sk)) {
> > +             /* Socket is busy (owned by user context): queue to backl=
og. */
> > +             if (sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf))) {
> > +                     QUIC_INC_STATS(sock_net(sk), QUIC_MIB_PKT_RCVDROP=
);
> > +                     kfree_skb(skb);
> > +             }
> > +     } else {
> > +             /* Socket not busy: process immediately. */
> > +             sk->sk_backlog_rcv(sk, skb); /* quic_backlog_rcv(). */
> > +     }
>
> [Severity: Medium]
> Should cb->backlog and cb->sync be cleared before the skb is handed to
> the accept socket here?
>
> When this runs from quic_packet_deferred_work(), the skb came off
> deferred_list with cb->backlog =3D 1. An skb that went through
> quic_listen_sock_switch() also has cb->sync =3D 1 and cb->resume =3D 1, s=
et
> by quic_packet_get_alpn().
>
> The call path here is atomic:
>
> quic_packet_deferred_work()
>   quic_packet_process()
>     quic_packet_listen_process()
>       quic_accept_sock_exists()
>         local_bh_disable()
>         bh_lock_sock_nested(accept_sk)
>         accept_sk->sk_backlog_rcv()
>           quic_packet_process(..., GFP_ATOMIC)
>
> Elsewhere the patch treats cb->backlog as meaning the context can sleep,
> for example in quic_packet_deferred_schedule():
>
>         if (cb->backlog)
>                 return 0;
>
> quic_crypto_decrypt() also checks !cb->backlog before doing a key
> update, and cb->sync forces a blocking crypto wait.
>
> The handshake and app handlers are still stubs in this patch. Once they
> are filled in, could these leftover flags make them sleep while holding
> the spinlock with BH disabled?
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1792164438.git.lucien.xin%40gmail.com
