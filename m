Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF5626CE26
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 16:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758644150; cv=none; b=m3xEZ8vt4YS7o+s8gjG3t+gxmB7qW5GyYTM3Cg9Ud58u/g5cN/ngolEova7k91yNKHakiroFzGQB0j28WN9iTi/r/qj98N7PRlhOzXWii8hfS3zg9OguJmrdoMiOJ87F2gzdjM2dZKTPuNsjc7J94jrMbAbnfQI422KKBdJncJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758644150; c=relaxed/simple;
	bh=4zx0+5+9ay+MLcWv70cajEU6N8L5ebaupdKpX+3hV3U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=geXu62EE1MTVpzRuNWqlb+2c/K05KwMBNmy+6/gNBhyWyVGqfKTFWzPzACw4ujJfkB8I85GOQ0y9XkIBKBN5xN+bkg3wUc6A0K6Y/jnoQcR5CLrxrZ2JyX/vbHGNlJNXI0E7Xpd50QLXhqk94QveJvTL4yX4kZn5scfvIF0j308=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WjFwnUdk; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WjFwnUdk"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b4c29d2ea05so43799a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 09:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758644147; x=1759248947; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=roqOkA4mhpUTuV7zHtlQunwhS2i7eky1y7Fn2tYtn+g=;
        b=WjFwnUdkyjJ9YmKXFjRWFLuMSk/qlXRxwetuTEKIMKv87PRyzk0E577FJArupeqxiP
         ADsCvDQEhSoQyK7fzDjkGc1snbW3xNzNTdozU4o5ajCkc4pVK8dRHbVJUnz8zHqM9f/5
         cG2pNIa0njnFcFWyLHY2wfx35SRBg/GmP80Azksial0umwDcDW+NL51a/fmohkVYZlAW
         mCaLXV9OpJRzitI9nqUllfx4Ejbf84/EgQNM8emQkLYU/vb0nBo6sj5G9pR3IfnHR2iC
         OXQaVbxOJuhn5W0QutSn80/AyE9gMX+gAkAOUeLTcXeHr2H+39lv3AueP6MWnikYrF/W
         MHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758644147; x=1759248947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=roqOkA4mhpUTuV7zHtlQunwhS2i7eky1y7Fn2tYtn+g=;
        b=MMocHPjJSC13120yntcEYUaRF0kkAVJD7EmfA4i8gidFLiNDYc4Tv81FEPkTSpNHGx
         RyU/H4MTUAIGZ2SH4uAgGBeyR0drAykFQGQ3vDcJCGsbVuvSzoMmUMyvF76TrBxXFvdG
         AU8DnBrr92mH9E422yHtXFvDKwSOD1VItsi2XIdszGBOE4ZxbCQi7dW5pMHb2A5kpbv6
         bh6OyEH6d2Dl3Na8UIHFUEvs+yWg0TGvkgJOF/L6TqYXnq3i38PRn13n7XjHQq+EfVxx
         EwMzJ2lliN3UpzISOoV0o6UnWeC1xoCdvqn0q9nUyi9FkQecawDqjy7hNmZNQcAEYWSF
         eqbg==
X-Forwarded-Encrypted: i=1; AJvYcCXQMdj14QtAlOSC3ttF+5te61dHNOdqVzjNlBNVJPb3XYR3fZRsUcKcIjGlFz/tMI8C//+jTgIM18pz@vger.kernel.org
X-Gm-Message-State: AOJu0YwS/0ogWCHWWhz9SMDja0/vFovCq3ta5lYvYCVR+7U/CgWxE4AZ
	Lh0TiPKudxvRBnLFmo/is8fFAXw+B0HWq4O2f/06A1E0ONQi4P5bC7ZRysaqwE8LGd+sDVANgwp
	yxPIS/OP6gImkibppjBDO2fBJNyydx5U=
X-Gm-Gg: ASbGncuM9TMFN6J2Hf9M2tXUKG2bmfw3ixguLSbeSUYQjohiUCWcNbcxRorWq+H7+fR
	K501vcOXtLS3FJpFEaWdWi+nliejMYNAi2UoW0ICjQ6hKz22JOWCVKIFONCpslWmTMBtJ2c68O9
	8DjeB9g+/FoZu0+bIstJmLoOsFFzWhoXdSXZqpGrUpQB/wDQR679ywCRJN8IpZ3w43RTZSxJZ2m
	74V7Vq7Spk1a3rKSyW1B8vcKMlYJrEieklcBf9GAA==
X-Google-Smtp-Source: AGHT+IEr1Wp7lnOKYbQogTRU49tZDRjCU4IgU+hKGrAKTHaQZHlUYbH4i5PmQJfU7XjQcSc/cw2/AJTEJkkkscjPCoQ=
X-Received: by 2002:a17:90b:4f45:b0:32e:64ed:c20a with SMTP id
 98e67ed59e1d1-332ab42e4c4mr4048060a91.0.1758644146952; Tue, 23 Sep 2025
 09:15:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1758234904.git.lucien.xin@gmail.com> <01dd8f3b9afc6c813f036924790997d3ed4bcf3d.1758234904.git.lucien.xin@gmail.com>
 <a3fa95a3-ce18-498a-a656-16581212c6cb@redhat.com>
In-Reply-To: <a3fa95a3-ce18-498a-a656-16581212c6cb@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 Sep 2025 12:15:35 -0400
X-Gm-Features: AS18NWC507yrnKiwe_bDMHV3OqCbUCcPotGyyraAzalosS-A-S1QEYQItoSZtSA
Message-ID: <CADvbK_cfdcCEXP8xUa=k6+NxV2JLOBP1Z4KA6Pa+rDEyhc9OTw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 04/15] quic: provide family ops for address
 and protocol
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 7:30=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 9/19/25 12:34 AM, Xin Long wrote:
> > +static int quic_v4_flow_route(struct sock *sk, union quic_addr *da, un=
ion quic_addr *sa,
> > +                           struct flowi *fl)
> > +{
> > +     struct flowi4 *fl4;
> > +     struct rtable *rt;
> > +     struct flowi _fl;
> > +
> > +     if (__sk_dst_check(sk, 0))
> > +             return 1;
> > +
> > +     fl4 =3D &_fl.u.ip4;
> > +     memset(&_fl, 0x00, sizeof(_fl));
> > +     fl4->saddr =3D sa->v4.sin_addr.s_addr;
> > +     fl4->fl4_sport =3D sa->v4.sin_port;
> > +     fl4->daddr =3D da->v4.sin_addr.s_addr;
> > +     fl4->fl4_dport =3D da->v4.sin_port;
> > +     fl4->flowi4_proto =3D IPPROTO_UDP;
> > +     fl4->flowi4_oif =3D sk->sk_bound_dev_if;
>
> Why you need a local variable? I think you could use the 'fl' argument
> directly.
You're right, I don't really need this '_fl'.

>
> > +
> > +     fl4->flowi4_scope =3D ip_sock_rt_scope(sk);
> > +     fl4->flowi4_dscp =3D inet_sk_dscp(inet_sk(sk));
> > +
> > +     rt =3D ip_route_output_key(sock_net(sk), fl4);
> > +     if (IS_ERR(rt))
> > +             return PTR_ERR(rt);
> > +
> > +     if (!sa->v4.sin_family) {
> > +             sa->v4.sin_family =3D AF_INET;
> > +             sa->v4.sin_addr.s_addr =3D fl4->saddr;
> > +     }
> > +     sk_setup_caps(sk, &rt->dst);
> > +     memcpy(fl, &_fl, sizeof(_fl));
> > +     return 0;
> > +}
> > +
> > +static int quic_v6_flow_route(struct sock *sk, union quic_addr *da, un=
ion quic_addr *sa,
> > +                           struct flowi *fl)
> > +{
> > +     struct ipv6_pinfo *np =3D inet6_sk(sk);
> > +     struct ip6_flowlabel *flowlabel;
> > +     struct dst_entry *dst;
> > +     struct flowi6 *fl6;
> > +     struct flowi _fl;
> > +
> > +     if (__sk_dst_check(sk, np->dst_cookie))
> > +             return 1;
> > +
> > +     fl6 =3D &_fl.u.ip6;
> > +     memset(&_fl, 0x0, sizeof(_fl));
> > +     fl6->saddr =3D sa->v6.sin6_addr;
> > +     fl6->fl6_sport =3D sa->v6.sin6_port;
> > +     fl6->daddr =3D da->v6.sin6_addr;
> > +     fl6->fl6_dport =3D da->v6.sin6_port;
> > +     fl6->flowi6_proto =3D IPPROTO_UDP;
> > +     fl6->flowi6_oif =3D sk->sk_bound_dev_if;
>
> Same here.
Yes.

>
> > +
> > +     if (inet6_test_bit(SNDFLOW, sk)) {
> > +             fl6->flowlabel =3D (da->v6.sin6_flowinfo & IPV6_FLOWINFO_=
MASK);
> > +             if (fl6->flowlabel & IPV6_FLOWLABEL_MASK) {
> > +                     flowlabel =3D fl6_sock_lookup(sk, fl6->flowlabel)=
;
> > +                     if (IS_ERR(flowlabel))
> > +                             return -EINVAL;
> > +                     fl6_sock_release(flowlabel);
> > +             }
> > +     }
> > +
> > +     dst =3D ip6_dst_lookup_flow(sock_net(sk), sk, fl6, NULL);
> > +     if (IS_ERR(dst))
> > +             return PTR_ERR(dst);
> > +
> > +     if (!sa->v6.sin6_family) {
> > +             sa->v6.sin6_family =3D AF_INET6;
> > +             sa->v6.sin6_addr =3D fl6->saddr;
> > +     }
> > +     ip6_dst_store(sk, dst, NULL, NULL);
> > +     memcpy(fl, &_fl, sizeof(_fl));
> > +     return 0;
> > +}
> > +
> > +static void quic_v4_lower_xmit(struct sock *sk, struct sk_buff *skb, s=
truct flowi *fl)
> > +{
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     u8 tos =3D (inet_sk(sk)->tos | cb->ecn), ttl;
> > +     struct flowi4 *fl4 =3D &fl->u.ip4;
> > +     struct dst_entry *dst;
> > +     __be16 df =3D 0;
> > +
> > +     pr_debug("%s: skb: %p, len: %d, num: %llu, %pI4:%d -> %pI4:%d\n",=
 __func__,
> > +              skb, skb->len, cb->number, &fl4->saddr, ntohs(fl4->fl4_s=
port),
> > +              &fl4->daddr, ntohs(fl4->fl4_dport));
> > +
> > +     dst =3D sk_dst_get(sk);
> > +     if (!dst) {
> > +             kfree_skb(skb);
> > +             return;
> > +     }
> > +     if (ip_dont_fragment(sk, dst) && !skb->ignore_df)
> > +             df =3D htons(IP_DF);
> > +
> > +     ttl =3D (u8)ip4_dst_hoplimit(dst);
> > +     udp_tunnel_xmit_skb((struct rtable *)dst, sk, skb, fl4->saddr, fl=
4->daddr,
> > +                         tos, ttl, df, fl4->fl4_sport, fl4->fl4_dport,=
 false, false, 0);
> > +}
> > +
> > +static void quic_v6_lower_xmit(struct sock *sk, struct sk_buff *skb, s=
truct flowi *fl)
> > +{
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     u8 tc =3D (inet6_sk(sk)->tclass | cb->ecn), ttl;
> > +     struct flowi6 *fl6 =3D &fl->u.ip6;
> > +     struct dst_entry *dst;
> > +     __be32 label;
> > +
> > +     pr_debug("%s: skb: %p, len: %d, num: %llu, %pI6c:%d -> %pI6c:%d\n=
", __func__,
> > +              skb, skb->len, cb->number, &fl6->saddr, ntohs(fl6->fl6_s=
port),
> > +              &fl6->daddr, ntohs(fl6->fl6_dport));
> > +
> > +     dst =3D sk_dst_get(sk);
> > +     if (!dst) {
> > +             kfree_skb(skb);
> > +             return;
> > +     }
> > +
> > +     ttl =3D (u8)ip6_dst_hoplimit(dst);
> > +     label =3D ip6_make_flowlabel(sock_net(sk), skb, fl6->flowlabel, t=
rue, fl6);
> > +     udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr, &fl6->daddr=
, tc,
> > +                          ttl, label, fl6->fl6_sport, fl6->fl6_dport, =
false, 0);
> > +}
> > +
> > +static void quic_v4_get_msg_addrs(struct sk_buff *skb, union quic_addr=
 *da, union quic_addr *sa)
> > +{
> > +     struct udphdr *uh =3D quic_udphdr(skb);
> > +
> > +     sa->v4.sin_family =3D AF_INET;
> > +     sa->v4.sin_port =3D uh->source;
> > +     sa->v4.sin_addr.s_addr =3D ip_hdr(skb)->saddr;
> > +
> > +     da->v4.sin_family =3D AF_INET;
> > +     da->v4.sin_port =3D uh->dest;
> > +     da->v4.sin_addr.s_addr =3D ip_hdr(skb)->daddr;
> > +}
> > +
> > +static void quic_v6_get_msg_addrs(struct sk_buff *skb, union quic_addr=
 *da, union quic_addr *sa)
> > +{
> > +     struct udphdr *uh =3D quic_udphdr(skb);
> > +
> > +     sa->v6.sin6_family =3D AF_INET6;
> > +     sa->v6.sin6_port =3D uh->source;
> > +     sa->v6.sin6_addr =3D ipv6_hdr(skb)->saddr;
> > +
> > +     da->v6.sin6_family =3D AF_INET6;
> > +     da->v6.sin6_port =3D uh->dest;
> > +     da->v6.sin6_addr =3D ipv6_hdr(skb)->daddr;
> > +}
> > +
> > +static int quic_v4_get_mtu_info(struct sk_buff *skb, u32 *info)
> > +{
> > +     struct icmphdr *hdr;
> > +
> > +     hdr =3D (struct icmphdr *)(skb_network_header(skb) - sizeof(struc=
t icmphdr));
> > +     if (hdr->type =3D=3D ICMP_DEST_UNREACH && hdr->code =3D=3D ICMP_F=
RAG_NEEDED) {
> > +             *info =3D ntohs(hdr->un.frag.mtu);
> > +             return 0;
> > +     }
> > +
> > +     /* Defer other types' processing to UDP error handler. */
> > +     return 1;
> > +}
> > +
> > +static int quic_v6_get_mtu_info(struct sk_buff *skb, u32 *info)
> > +{
> > +     struct icmp6hdr *hdr;
> > +
> > +     hdr =3D (struct icmp6hdr *)(skb_network_header(skb) - sizeof(stru=
ct icmp6hdr));
> > +     if (hdr->icmp6_type =3D=3D ICMPV6_PKT_TOOBIG) {
> > +             *info =3D ntohl(hdr->icmp6_mtu);
> > +             return 0;
> > +     }
> > +
> > +     /* Defer other types' processing to UDP error handler. */
> > +     return 1;
> > +}
> > +
> > +static u8 quic_v4_get_msg_ecn(struct sk_buff *skb)
> > +{
> > +     return (ip_hdr(skb)->tos & INET_ECN_MASK);
> > +}
> > +
> > +static u8 quic_v6_get_msg_ecn(struct sk_buff *skb)
> > +{
> > +     return (ipv6_get_dsfield(ipv6_hdr(skb)) & INET_ECN_MASK);
> > +}
> > +
> > +static int quic_v4_get_user_addr(struct sock *sk, union quic_addr *a, =
struct sockaddr *addr,
> > +                              int addr_len)
> > +{
> > +     u32 len =3D sizeof(struct sockaddr_in);
> > +
> > +     if (addr_len < len || addr->sa_family !=3D AF_INET)
> > +             return 1;
> > +     if (ipv4_is_multicast(quic_addr(addr)->v4.sin_addr.s_addr))
> > +             return 1;
> > +     memcpy(a, addr, len);
> > +     return 0;
> > +}
> > +
> > +static int quic_v6_get_user_addr(struct sock *sk, union quic_addr *a, =
struct sockaddr *addr,
> > +                              int addr_len)
> > +{
> > +     u32 len =3D sizeof(struct sockaddr_in);
> > +     int type;
> > +
> > +     if (addr_len < len)
> > +             return 1;
> > +
> > +     if (addr->sa_family !=3D AF_INET6) {
> > +             if (ipv6_only_sock(sk))
> > +                     return 1;
> > +             return quic_v4_get_user_addr(sk, a, addr, addr_len);
> > +     }
> > +
> > +     len =3D sizeof(struct sockaddr_in6);
> > +     if (addr_len < len)
> > +             return 1;
> > +     type =3D ipv6_addr_type(&quic_addr(addr)->v6.sin6_addr);
> > +     if (type !=3D IPV6_ADDR_ANY && !(type & IPV6_ADDR_UNICAST))
> > +             return 1;
> > +     memcpy(a, addr, len);
> > +     return 0;
> > +}
> > +
> > +static void quic_v4_get_pref_addr(struct sock *sk, union quic_addr *ad=
dr, u8 **pp, u32 *plen)
> > +{
> > +     u8 *p =3D *pp;
> > +
> > +     memcpy(&addr->v4.sin_addr, p, QUIC_ADDR4_LEN);
> > +     p +=3D QUIC_ADDR4_LEN;
> > +     memcpy(&addr->v4.sin_port, p, QUIC_PORT_LEN);
> > +     p +=3D QUIC_PORT_LEN;
> > +     addr->v4.sin_family =3D AF_INET;
> > +     /* Skip over IPv6 address and port, not used for AF_INET sockets.=
 */
> > +     p +=3D QUIC_ADDR6_LEN;
> > +     p +=3D QUIC_PORT_LEN;
> > +
> > +     if (!addr->v4.sin_port || quic_v4_is_any_addr(addr) ||
> > +         ipv4_is_multicast(addr->v4.sin_addr.s_addr))
> > +             memset(addr, 0, sizeof(*addr));
> > +     *plen -=3D (p - *pp);
> > +     *pp =3D p;
> > +}
> > +
> > +static void quic_v6_get_pref_addr(struct sock *sk, union quic_addr *ad=
dr, u8 **pp, u32 *plen)
> > +{
> > +     u8 *p =3D *pp;
> > +     int type;
> > +
> > +     /* Skip over IPv4 address and port. */
> > +     p +=3D QUIC_ADDR4_LEN;
> > +     p +=3D QUIC_PORT_LEN;
> > +     /* Try to use IPv6 address and port first. */
> > +     memcpy(&addr->v6.sin6_addr, p, QUIC_ADDR6_LEN);
> > +     p +=3D QUIC_ADDR6_LEN;
> > +     memcpy(&addr->v6.sin6_port, p, QUIC_PORT_LEN);
> > +     p +=3D QUIC_PORT_LEN;
> > +     addr->v6.sin6_family =3D AF_INET6;
> > +
> > +     type =3D ipv6_addr_type(&addr->v6.sin6_addr);
> > +     if (!addr->v6.sin6_port || !(type & IPV6_ADDR_UNICAST)) {
> > +             memset(addr, 0, sizeof(*addr));
> > +             if (ipv6_only_sock(sk))
> > +                     goto out;
> > +             /* Fallback to IPv4 if IPv6 address is not usable. */
> > +             return quic_v4_get_pref_addr(sk, addr, pp, plen);
> > +     }
> > +out:
> > +     *plen -=3D (p - *pp);
> > +     *pp =3D p;
> > +}
> > +
> > +static void quic_v4_set_pref_addr(struct sock *sk, u8 *p, union quic_a=
ddr *addr)
> > +{
> > +     memcpy(p, &addr->v4.sin_addr, QUIC_ADDR4_LEN);
> > +     p +=3D QUIC_ADDR4_LEN;
> > +     memcpy(p, &addr->v4.sin_port, QUIC_PORT_LEN);
> > +     p +=3D QUIC_PORT_LEN;
> > +     memset(p, 0, QUIC_ADDR6_LEN);
> > +     p +=3D QUIC_ADDR6_LEN;
> > +     memset(p, 0, QUIC_PORT_LEN);
> > +}
> > +
> > +static void quic_v6_set_pref_addr(struct sock *sk, u8 *p, union quic_a=
ddr *addr)
> > +{
> > +     if (addr->sa.sa_family =3D=3D AF_INET)
> > +             return quic_v4_set_pref_addr(sk, p, addr);
> > +
> > +     memset(p, 0, QUIC_ADDR4_LEN);
> > +     p +=3D QUIC_ADDR4_LEN;
> > +     memset(p, 0, QUIC_PORT_LEN);
> > +     p +=3D QUIC_PORT_LEN;
> > +     memcpy(p, &addr->v6.sin6_addr, QUIC_ADDR6_LEN);
> > +     p +=3D QUIC_ADDR6_LEN;
> > +     memcpy(p, &addr->v6.sin6_port, QUIC_PORT_LEN);
> > +}
> > +
> > +static bool quic_v4_cmp_sk_addr(struct sock *sk, union quic_addr *a, u=
nion quic_addr *addr)
> > +{
> > +     if (a->v4.sin_port !=3D addr->v4.sin_port)
> > +             return false;
> > +     if (a->v4.sin_family !=3D addr->v4.sin_family)
> > +             return false;
> > +     if (a->v4.sin_addr.s_addr =3D=3D htonl(INADDR_ANY) ||
> > +         addr->v4.sin_addr.s_addr =3D=3D htonl(INADDR_ANY))
> > +             return true;
> > +     return a->v4.sin_addr.s_addr =3D=3D addr->v4.sin_addr.s_addr;
> > +}
> > +
> > +static bool quic_v6_cmp_sk_addr(struct sock *sk, union quic_addr *a, u=
nion quic_addr *addr)
> > +{
> > +     if (a->v4.sin_port !=3D addr->v4.sin_port)
> > +             return false;
> > +
> > +     if (a->sa.sa_family =3D=3D AF_INET && addr->sa.sa_family =3D=3D A=
F_INET) {
> > +             if (a->v4.sin_addr.s_addr =3D=3D htonl(INADDR_ANY) ||
> > +                 addr->v4.sin_addr.s_addr =3D=3D htonl(INADDR_ANY))
> > +                     return true;
> > +             return a->v4.sin_addr.s_addr =3D=3D addr->v4.sin_addr.s_a=
ddr;
> > +     }
> > +
> > +     if (a->sa.sa_family !=3D addr->sa.sa_family) {
> > +             if (ipv6_only_sock(sk))
> > +                     return false;
> > +             if (a->sa.sa_family =3D=3D AF_INET6 && ipv6_addr_any(&a->=
v6.sin6_addr))
> > +                     return true;
> > +             if (a->sa.sa_family =3D=3D AF_INET && addr->sa.sa_family =
=3D=3D AF_INET6 &&
> > +                 ipv6_addr_v4mapped(&addr->v6.sin6_addr) &&
> > +                 addr->v6.sin6_addr.s6_addr32[3] =3D=3D a->v4.sin_addr=
.s_addr)
> > +                     return true;
> > +             if (addr->sa.sa_family =3D=3D AF_INET && a->sa.sa_family =
=3D=3D AF_INET6 &&
> > +                 ipv6_addr_v4mapped(&a->v6.sin6_addr) &&
> > +                 a->v6.sin6_addr.s6_addr32[3] =3D=3D addr->v4.sin_addr=
.s_addr)
> > +                     return true;
> > +             return false;
> > +     }
> > +
> > +     if (ipv6_addr_any(&a->v6.sin6_addr) || ipv6_addr_any(&addr->v6.si=
n6_addr))
> > +             return true;
> > +     return ipv6_addr_equal(&a->v6.sin6_addr, &addr->v6.sin6_addr);
> > +}
> > +
> > +static int quic_v4_get_sk_addr(struct socket *sock, struct sockaddr *u=
addr, int peer)
> > +{
> > +     return inet_getname(sock, uaddr, peer);
> > +}
> > +
> > +static int quic_v6_get_sk_addr(struct socket *sock, struct sockaddr *u=
addr, int peer)
> > +{
> > +     union quic_addr *a =3D quic_addr(uaddr);
> > +     int ret;
> > +
> > +     ret =3D inet6_getname(sock, uaddr, peer);
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     if (a->sa.sa_family =3D=3D AF_INET6 && ipv6_addr_v4mapped(&a->v6.=
sin6_addr)) {
> > +             a->v4.sin_family =3D AF_INET;
> > +             a->v4.sin_port =3D a->v6.sin6_port;
> > +             a->v4.sin_addr.s_addr =3D a->v6.sin6_addr.s6_addr32[3];
> > +     }
> > +
> > +     if (a->sa.sa_family =3D=3D AF_INET) {
> > +             memset(a->v4.sin_zero, 0, sizeof(a->v4.sin_zero));
> > +             return sizeof(struct sockaddr_in);
> > +     }
> > +     return sizeof(struct sockaddr_in6);
> > +}
> > +
> > +static void quic_v4_set_sk_addr(struct sock *sk, union quic_addr *a, b=
ool src)
> > +{
> > +     if (src) {
> > +             inet_sk(sk)->inet_sport =3D a->v4.sin_port;
> > +             inet_sk(sk)->inet_saddr =3D a->v4.sin_addr.s_addr;
> > +     } else {
> > +             inet_sk(sk)->inet_dport =3D a->v4.sin_port;
> > +             inet_sk(sk)->inet_daddr =3D a->v4.sin_addr.s_addr;
> > +     }
> > +}
> > +
> > +static void quic_v6_copy_sk_addr(struct in6_addr *skaddr, union quic_a=
ddr *a)
> > +{
> > +     if (a->sa.sa_family =3D=3D AF_INET) {
> > +             skaddr->s6_addr32[0] =3D 0;
> > +             skaddr->s6_addr32[1] =3D 0;
> > +             skaddr->s6_addr32[2] =3D htonl(0x0000ffff);
> > +             skaddr->s6_addr32[3] =3D a->v4.sin_addr.s_addr;
> > +     } else {
> > +             *skaddr =3D a->v6.sin6_addr;
> > +     }
> > +}
> > +
> > +static void quic_v6_set_sk_addr(struct sock *sk, union quic_addr *a, b=
ool src)
> > +{
> > +     if (src) {
> > +             inet_sk(sk)->inet_sport =3D a->v4.sin_port;
> > +             quic_v6_copy_sk_addr(&sk->sk_v6_rcv_saddr, a);
> > +     } else {
> > +             inet_sk(sk)->inet_dport =3D a->v4.sin_port;
> > +             quic_v6_copy_sk_addr(&sk->sk_v6_daddr, a);
> > +     }
> > +}
> > +
> > +static void quic_v4_set_sk_ecn(struct sock *sk, u8 ecn)
> > +{
> > +     inet_sk(sk)->tos =3D ((inet_sk(sk)->tos & ~INET_ECN_MASK) | ecn);
> > +}
> > +
> > +static void quic_v6_set_sk_ecn(struct sock *sk, u8 ecn)
> > +{
> > +     quic_v4_set_sk_ecn(sk, ecn);
> > +     inet6_sk(sk)->tclass =3D ((inet6_sk(sk)->tclass & ~INET_ECN_MASK)=
 | ecn);
> > +}
> > +
> > +#define quic_af_ipv4(a)              ((a)->sa.sa_family =3D=3D AF_INET=
)
> > +
> > +u32 quic_encap_len(union quic_addr *a)
> > +{
> > +     return (quic_af_ipv4(a) ? sizeof(struct iphdr) : sizeof(struct ip=
v6hdr)) +
> > +            sizeof(struct udphdr);
> > +}
> > +
> > +int quic_is_any_addr(union quic_addr *a)
> > +{
> > +     return quic_af_ipv4(a) ? quic_v4_is_any_addr(a) : quic_v6_is_any_=
addr(a);
> > +}
> > +
> > +void quic_seq_dump_addr(struct seq_file *seq, union quic_addr *addr)
> > +{
> > +     quic_af_ipv4(addr) ? quic_v4_seq_dump_addr(seq, addr) : quic_v6_s=
eq_dump_addr(seq, addr);
> > +}
> > +
> > +void quic_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, un=
ion quic_addr *a)
> > +{
> > +     quic_af_ipv4(a) ? quic_v4_udp_conf_init(sk, conf, a) : quic_v6_ud=
p_conf_init(sk, conf, a);
> > +}
> > +
> > +int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_a=
ddr *sa, struct flowi *fl)
> > +{
> > +     return quic_af_ipv4(da) ? quic_v4_flow_route(sk, da, sa, fl)
> > +                             : quic_v6_flow_route(sk, da, sa, fl);
> > +}
> > +
> > +void quic_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_=
addr *da, struct flowi *fl)
> > +{
> > +     quic_af_ipv4(da) ? quic_v4_lower_xmit(sk, skb, fl) : quic_v6_lowe=
r_xmit(sk, skb, fl);
> > +}
> > +
> > +#define quic_skb_ipv4(skb)   (ip_hdr(skb)->version =3D=3D 4)
> > +
> > +void quic_get_msg_addrs(struct sk_buff *skb, union quic_addr *da, unio=
n quic_addr *sa)
> > +{
> > +     memset(sa, 0, sizeof(*sa));
> > +     memset(da, 0, sizeof(*da));
> > +     quic_skb_ipv4(skb) ? quic_v4_get_msg_addrs(skb, da, sa)
> > +                        : quic_v6_get_msg_addrs(skb, da, sa);
> > +}
> > +
> > +int quic_get_mtu_info(struct sk_buff *skb, u32 *info)
> > +{
> > +     return quic_skb_ipv4(skb) ? quic_v4_get_mtu_info(skb, info)
> > +                               : quic_v6_get_mtu_info(skb, info);
> > +}
> > +
> > +u8 quic_get_msg_ecn(struct sk_buff *skb)
> > +{
> > +     return quic_skb_ipv4(skb) ? quic_v4_get_msg_ecn(skb) : quic_v6_ge=
t_msg_ecn(skb);
> > +}
> > +
> > +#define quic_pf_ipv4(sk)     ((sk)->sk_family =3D=3D PF_INET)
> > +
> > +int quic_get_user_addr(struct sock *sk, union quic_addr *a, struct soc=
kaddr *addr, int addr_len)
> > +{
> > +     memset(a, 0, sizeof(*a));
> > +     return quic_pf_ipv4(sk) ? quic_v4_get_user_addr(sk, a, addr, addr=
_len)
> > +                             : quic_v6_get_user_addr(sk, a, addr, addr=
_len);
>
> Minor nit: I think the most idiomatic way to express the abvoe is:
>
> return quic_pf_ipv4(sk) ? quic_v4_get_user_addr(sk, a, addr, addr_len) :
>                           quic_v6_get_user_addr(sk, a, addr, addr_len);
>
I somehow have been following the style of aligning the ? and : .
will change to the most idiomatic way. :-)

Thanks.
