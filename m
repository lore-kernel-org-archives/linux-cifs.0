Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59DF3382CD
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 01:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791510937; cv=pass; b=B0cNGCHM/fg46GNxDYdZcid5mCr/tNp14299Rs45XL5bc1FnyLq4L15j8/oSA2kq/rhocJZY6arbYJDKm33mq8aJFje5e4i2H5q2ajMKi9vZXC3Q5nEcsQw+5nH/mJVpPC0xhz48qkXmGNerWxXlAzetkL+Q6pCx3MWiz7vgQJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791510937; c=relaxed/simple;
	bh=35fIWUdY0+PUqZkYVHqyYWSj8S/8qpG3+Jwu5f2fVSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u7W+Uz/sB0v4dVu852PsHcEVJIgbZLhTBTD9MaROZlhRS/n6j6KWlkphmeNozPBWnoJTpw2KmEzYy4JIGOV52+6FQS2RlES9auu0rcTH5yXb4CyYi9Fqa2qPZ6sBX0M6jde3rQzgtKkuHNgPPW8I3A38AlyGHhUbjDN/T/YGzIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n85S0maM; arc=pass smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n85S0maM"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-892734ce7e6so1167859b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2026 18:55:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791510934; cv=none;
        d=google.com; s=arc-20260327;
        b=qe/Dl/Kw3/tBYR4XHJeeKGcCY/43BtPphptLjk78CQvU5VloYBy53YnQvt9fXA2yDb
         245oJyz13BfMCDMKT/EN8s83BjSYDOw00VC7IX0YmpOkPmKxZIBiesy3ClBWZLuloLMF
         EPKJqU/mAwvK2DNv4K1nWFxljv5PRo63JlYXaeK5UIDYSW3QxJSgrXLBBDzToiYBsDZc
         VacYQBgZpgl50lvWJhujOt04OM0FwP69j/MQ8CuCBrWkri8JPPURS0K1edTglEMyxA+W
         F/miPTJbwql8C3dDmEoOAC21c5wj2UGQu+6JFflgnH+jL0AloGHf6qR+494A4qph2Gel
         +lDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bKGCaBNhIQly2LY7lY+NOmyJ6aI0Yd/h629XMH7wx3Q=;
        fh=t/vLE+ydOcOwSC/6ySEUOHPhLjbjZ5xw9IaklE0pA9M=;
        b=QlunKHfbYVPpORuhjsz6XtABQrMFYoCI21NgMhSNs8hu007NMeM2vNHFQac2y61MxF
         2W4FG38ecG8kCiISiqWJWPYm2AS3+83tsg1oGnV9qiIjwSINICYoffTW78QtndrhvG92
         pGfo8queW81FeySYMBCIKOflcXx47iEiXcN1BcogqpAqk5kXPPT/hi79O+3JT+qW9KJo
         hnrUWZ1F8Dl6y4XRH19muW7NTEZsjt5+jygmnoae81x50PtOYGVA1otlsHnmZyOsNBFo
         OzbbrYUebyr97G5H1LLAzkbYDAh4FUVf6ej4QZbr2jtWrM4Wuh8u+NLwwVO9TlOqx0Lf
         xSVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791510934; x=1792115734; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bKGCaBNhIQly2LY7lY+NOmyJ6aI0Yd/h629XMH7wx3Q=;
        b=n85S0maMMYdJNjJeIea1AIL1ucIBiMZ8jEvI8a3fHf68dgmgVmxFQ3TN9JJsKuxlqd
         x1+lawMxkzwMLbZsOg3x+1ovo0ZaCTFcVfgxHkXg7hGbqyOxY86htMGiRwzh/Nr8un7g
         H1JeIe/weGeQuwa7TUK9+csR4hr74vevCNQ1vg8iMqpfutpXf8fr31nqxu3IuNjNCnsJ
         0FsjKqKWnSK+R5gK0be0RAKDfBd4TJ5wh+zL0vNbTvCLLURaLZV318s8RfVjjYspFDMb
         YbIwCXR5SROzd63IKFd10RL/QydiDXyd+1m/QNkVQ6HyI4aM8PsBcXPt+zgPJ50/cUJy
         A81w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791510934; x=1792115734;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bKGCaBNhIQly2LY7lY+NOmyJ6aI0Yd/h629XMH7wx3Q=;
        b=bMdd1NfstoY/mKMkHR+vrWw4Oubgqfxe1XmAtfSZmmYVnfE6kthNGTJYTVnmEco/W+
         fC7yURVMyPDHPqRxMuef0jRYtyYonB5F7qJxLvlKBGSF26Me8Q7LT11NpK16hlhPbFhD
         uZpeGqeUW7mjl6YwwTtfcsEIRYuWcb2A+DwDmFp0/kUbqpaVkiai6O4rl5XiM4WFzxYX
         yreNwWrA8DSRmzW1gWkHI3sFaBeRluBgYrlFjfleScBTphBKH2XEt0yey3v+pQgH8o4e
         V18aFtzTbzzepK3hnxB/FbG+UyT+PaUw8+5quWgs2MkJO8YriLXX0PRWADQYblZv8A12
         LDMA==
X-Forwarded-Encrypted: i=1; AKwUvByc2vEjvFsyJ5SijjjQRx9Goiu3B3p03Vok+EpbKiySlJLxnqItNHI0P9h+qkcYf0NNqOBDtkvICNup@vger.kernel.org
X-Gm-Message-State: AFq9FYL2XQph0bvLB3w5oiRWmSycy/nyx878q0gwsPHjE21I1qBm7feK
	1/lx4OnjR/U3+Xo50JPd4nTcvajUV072zRIWPrMZEuZPpiqW267KAkUVCEZLWq9uz8VG3YX5UwU
	LW5pE+6IDRzZVZ/6EBvxDR7ZzFZDX9xA=
X-Gm-Gg: AYBFou2YVJDzkOqyqkIy/YhaJYAXlE+8Gxax2R+hebHcET852TKWdyybxVtDzEbqTsH
	1qIeqX9yfywacvEGNeWXj9yO+oKTiEDcYPfnoK4U489q5fq43VXT4zhaE7nnwau/wPf8l1+ASkC
	zlFpIKR96lVGQ3aJ+Jq/L6Zjh+Pd5LtSxx1bxACzDuF7YUtlkOrkaG406lu0MBqpxHdngU3Q42o
	g2EzXWHhKPE11sbYu+dMr3McDAZleWTNbYl9Zv0llpxjDZ9iEXACFUoGAuPq/TWdzNdDrppil2h
	h6Oig2oujP3ngLLN8l6HISz4KWorWMeYWhxXdYAQPc5Oe+SWs6HuXc2epfFkrwLEDpjt49QgaIQ
	bgOAanebM5R3vhol19a9ojpJOBjAXjcaGkqk9R4b8XkNehrRidhEq
X-Received: by 2002:a05:6a00:2887:b0:881:4b47:f30b with SMTP id
 d2e1a72fcca58-897c6443587mr353692b3a.12.1791510933832; Thu, 08 Oct 2026
 18:55:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <333607babf249e24fe90625d7abb7625b97c0b50.1791227050.git.lucien.xin@gmail.com>
 <179133512872.434549.11248338098140405125@kernel.org>
In-Reply-To: <179133512872.434549.11248338098140405125@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 8 Oct 2026 21:55:21 -0400
X-Gm-Features: AclHuK8bQc1UycT-_KEl0eTokTRsi7auN1Ri9mWxKSe-T9TNyMx8BTQMr8J1Amw
Message-ID: <CADvbK_crkLjX2D+nu4LE16UpcQkUFa9DUp59hVKcXeTHxZXMHA@mail.gmail.com>
Subject: Re: [PATCH net-next v16 15/15] quic: add packet parser base
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

On Tue, Oct 6, 2026 at 9:05=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wrot=
e:
>
> Thank you for your contribution! Sashiko AI review found 7 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 3 =C2=B7 Low: 4
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] The permanent commit message (the part above '---') describes
>   much less than the patch does, and some of it is wrong.
> - [Medium] When PLPMTUD is disabled (paths->plpmtud_interval =3D=3D 0, th=
e
>   default in this tree because nothing sets it),=E2=80=A6
> - [Medium] quic_packet_listen_process() replies to, and creates state
>   for, long-header packets of any size.
> - [Low] The kernel-doc for quic_listen_sock_lookup() in net/quic/socket.c
>   says that when several listening sockets share the same address, port=
=E2=80=A6
> - [Low] The patch adds definitions that nothing in this commit uses.
> - [Low] struct quic_packet in net/quic/packet.h documents `daddr` as
>   'Dest address from received packet' and `saddr` as 'Source address=E2=
=80=A6
> - [Low] The header comment of quic_packet_deferred_work() (packet.c:776)
>   reads 'Work function to process packets in the backlog queue', but the=
=E2=80=A6
>
> --
>
> quic: add packet parser base
>
> This commit adds the QUIC receive path. quic_packet_rcv() finds the
> owning socket by connection ID, by address, or through the listener, then
> passes the packet to quic_packet_process(). The patch also adds
> listen-side Initial handling, request sockets, ALPN-based listener
> switching through a per-socket work item, and ICMP Packet Too Big
> handling through quic_packet_rcv_err() and quic_packet_rcv_err_pmtu().
>
> > This patch uses 'quic_packet' to handle packing of QUIC packets on the
> > receive (RX) path.
>
> [ ... ]
>
> > - quic_packet_get_alpn(): Parse the ALPN from a client Initial packet,
> >   then locate the appropriate listener using the ALPN.
>
> [ ... ]
>
> > - quic_packet_rcv_err_pmtu(): Find the socket and update the PMTU via
> >   quic_packet_mss_update().
>
> [Severity: Medium]
> Some parts of the commit message don't match the code.
>
> Should "packing" in the first sentence be "parsing"?
>
> quic_packet_get_alpn() installs the Initial keys, decrypts the packet and
> parses the ALPN list. It doesn't look up a listener. The lookup and the
> switch happen in quic_listen_sock_switch() in net/quic/socket.c.
>
> For ICMP errors, the socket lookup is done in quic_packet_rcv_err(), not
> in quic_packet_rcv_err_pmtu().
>
> The message also leaves out much of what the patch adds:
>
>   - quic_packet_listen_process(), with token verification and the
>     Stateless Reset, Version Negotiation, Retry and CONNECTION_REFUSED
>     triggers
>   - struct quic_request_sock and quic_request_sock_lookup(),
>     quic_request_sock_create() and quic_request_sock_backlog_tail(),
>     which charge sk_ack_backlog and receive memory
>   - the per-socket work_struct with deferred_list/backlog_list on
>     quic_wq, and flush_work() in quic_packet_free()
>   - quic_accept_sock_exists() and quic_listen_sock_switch()
>   - quic_backlog_rcv() now processing packets instead of dropping them
>   - the ALPN free moving from quic_destroy_sock() to quic_sock_destruct()
>
True.

These updates were added only to the last version, and
I will also reflect them on the commit message.

> Most of this is described only in the changelog below the --- line, and
> git am drops that part. Could the permanent commit message cover these
> pieces?
>
> > diff --git a/net/quic/packet.c b/net/quic/packet.c
> > index 56d2b8df292a0..673f1cd491438 100644
> > --- a/net/quic/packet.c
> > +++ b/net/quic/packet.c
> > @@ -14,6 +14,781 @@
> >
> >  #define QUIC_HLEN            1
> >
> > +#define QUIC_LONG_HLEN(dcid, scid) \
> > +     (QUIC_HLEN + QUIC_VERSION_LEN + 1 + (dcid)->len + 1 + (scid)->len=
)
>
> [Severity: Low]
> This isn't a bug, but nothing in this patch uses QUIC_LONG_HLEN().
>
> Two of the new struct quic_packet members are in a similar state.
>
> backlog_list is described as "Packets waiting for crypto keys". It is
> only initialized in quic_packet_init() and purged in quic_packet_free(),
> and nothing enqueues to it yet.
>
> quic_packet_listen_process() reads validate_peer_address, but nothing
> ever sets it, so the token validation and Retry branch can't be reached:
>
>         if (packet->validate_peer_address) {
>
> The changelog says these are staged for the next patchset. Could they be
> added together with the code that uses them? Failing that, could the
> backlog_list comment describe what the field does today?
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
> > +             if (dst)
> > +                     dst->ops->update_pmtu(dst, sk, NULL, info, true);
> > +             quic_packet_mss_update(sk, info - packet->hlen);
>
> [Severity: Medium]
> Can a Packet Too Big that reports a larger MTU than the current path MTU
> raise the MSS here?
>
> info is only clamped to [QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU], and
> quic_packet_mss_update() stores whatever it is given. The route layer
> ignores increases:
>
> net/ipv4/route.c:__ip_rt_update_pmtu() {
>     ...
>         old_mtu =3D ipv4_mtu(dst);
>         if (old_mtu < mtu)
>                 return;
>     ...
> }
>
> __ip6_rt_update_pmtu() also returns early when mtu >=3D dst6_mtu(dst).
>
> Nothing in this tree sets plpmtud_interval, so this branch is the
> default. A delayed or spoofed ICMP that arrives through quic_udp_err()
> -> quic_packet_rcv() -> quic_packet_rcv_err() -> quic_packet_rcv_err_pmtu=
()
> and claims 9000 on a 1500-byte path would set the MSS to 9000 - hlen.
>
> The route is left unchanged, so the cached dst stays valid. Later
> quic_packet_route() calls then get 1 back from quic_flow_route() and
> never recompute the MSS from dst_mtu().
>
> Would it be safer to re-read dst_mtu(dst) after update_pmtu(), or to only
> ever lower the MSS, as tcp_v4_mtu_reduced() does?
>
True.

Will follow the suggestion to re-read it after update_pmtu():

    info =3D dst_mtu(dst);

> [ ... ]
>
> > +static int quic_packet_listen_process(struct sock *sk, struct sk_buff =
*skb,
> > +                                   gfp_t gfp)
> > +{
>
> [ ... ]
>
> > +     if (!quic_packet_compatible_versions(version)) {
> > +             /* rfc9000#section-6.1:
> > +              *
> > +              * If the version selected by the client is not acceptabl=
e to
> > +              * the server, the server responds with a Version Negotia=
tion
> > +              * packet. This includes a list of versions that the serv=
er
> > +              * will accept.
> > +              */
> > +             err =3D quic_packet_version_create_and_xmit(sk, gfp);
> > +             consume_skb(skb);
> > +             return err;
> > +     }
>
> [Severity: Medium]
> Is a minimum datagram size check missing before this reply?
>
> RFC 9000 sections 5.2.2 and 6.1 say a server MUST drop smaller packets
> that specify an unsupported version. Section 14.1 says a server MUST
> discard an Initial packet in a UDP datagram whose payload is smaller than
> 1200 bytes.
>
> On the receive path nothing compares skb->len with QUIC_MIN_UDP_PAYLOAD.
> quic_packet_rcv() and quic_packet_get_sock() only require
> skb->len >=3D QUIC_HLEN.
>
> Packets of any size can therefore reach the Version Negotiation reply
> above, the Retry and refuse-close paths, and this call further down:
>
>         req =3D quic_request_sock_create(sk, &odcid, retry, gfp);
>
> When ALPN demux is disabled, the Length field isn't parsed at all. A
> 16-byte spoofed long-header Initial (8-byte DCID, empty SCID, empty
> token) would allocate a quic_request_sock and call sk_acceptq_added().
>
> Could a burst of these fill the accept queue, so that legitimate clients
> hit sk_acceptq_is_full() and get CONNECTION_REFUSED?
>
> Once the Version Negotiation and Retry builders are implemented, would
> they also reply to spoofed sources for these small datagrams?
>
True.

Will add a check for udp_hdr(skb)->len against QUIC_MIN_UDP_PAYLOAD here.

Thanks.

> [ ... ]
>
> > +/* Work function to process packets in the backlog queue. */
> > +static void quic_packet_deferred_work(struct work_struct *work)
> > +{
>
> [ ... ]
>
> > +     head =3D &quic_packet(sk)->deferred_list;
>
> [Severity: Low]
> This isn't a bug, but the comment says "backlog queue" while the function
> drains deferred_list. struct quic_packet now has a separate backlog_list,
> so should the comment say deferred list instead?
>
> [ ... ]
>
> > diff --git a/net/quic/packet.h b/net/quic/packet.h
> > index cf0b97112d9b1..4a7bcf959e997 100644
> > --- a/net/quic/packet.h
> > +++ b/net/quic/packet.h
> > @@ -14,6 +14,8 @@ struct quic_packet {
> >       union quic_addr daddr;    /* Dest address from received packet */
> >       union quic_addr saddr;    /* Source address from received packet =
*/
>
> [Severity: Low]
> These comments seem reversed compared to how this patch fills the fields.
>
> quic_get_msg_addrs() takes (skb, da, sa), and quic_packet_listen_process(=
)
> calls it like this:
>
>         quic_get_msg_addrs(skb, &packet->saddr, &packet->daddr);
>
> The inline comment there says "Read Destination address (packet->saddr)
> and Source address (packet->daddr)".
>
> So packet->saddr holds the received packet's destination (local) address
> and packet->daddr holds its source (peer) address. The users,
> quic_crypto_verify_token(), quic_accept_sock_exists() and
> quic_listen_sock_switch(), all follow that convention.
>
> Could the struct comments be changed to match?
>
> [ ... ]
>
> > diff --git a/net/quic/socket.c b/net/quic/socket.c
> > index 0173416d0368a..be8dc30f8208a 100644
> > --- a/net/quic/socket.c
> > +++ b/net/quic/socket.c
>
> [ ... ]
>
> > +/* Find the listening QUIC socket for an incoming packet.
> > + *
> > + * This function searches the QUIC socket table for a listening socket=
 that
> > + * matches the dest address and port, and the ALPN(s) if presented in =
the
> > + * ClientHello.  If multiple listening sockets are bound to the same a=
ddress,
> > + * port, and ALPN(s) (e.g., via SO_REUSEPORT), this function selects a=
 socket
> > + * from the reuseport group.
>
> [Severity: Low]
> This isn't a bug, but the function body doesn't select from a reuseport
> group.
>
> It walks the hash chain with sk_nulls_for_each_rcu() and returns the
> first specific-address match, or an ANY-address candidate. It never calls
> reuseport_select_sock() or looks at sk_reuseport_cb.
>
> The v16 changelog says reuseport_select_sock() moved to the next
> patchset. Should this part of the comment move with it?
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1791227050.git.lucien.xin%40gmail.com
