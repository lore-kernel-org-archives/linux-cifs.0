Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625CB30C630
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 19:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770318191; cv=pass; b=Zgv9Y7EYrrvPlucD1UkXpQPFEEfCSBt4+Y4mopHaBu19CUdtuV4oVxzPIlZM7pezrP7EE/6G8HdecsLA57Fvav26IR1OAjjZ/HvP7Lh1HRfTgbh2DD1vAxeJAXICaT/QmvmMxlPa2H0qvBUdlqNAIjKyfQHIVuieokexIQd47rE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770318191; c=relaxed/simple;
	bh=Sv7j14ymtGLHlmTqP+BoOPCTX/cQqHoGUXoIMpAvOkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TFyORZ2d8+D/GLByDItoIcXE4hKdIw74OB8C81ENTYvl0goISZ32XBO1nAjLaOZ45uYvEASOMKkQxv9du+wwPJvJ6WX2np/ej2+yefKOFSEtW6gHzS2YvOaB/nLuLcWyhzUwEEipPg0Ho/yobct8fXnwY8jyapK+XWh7p6by/ac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LUKrkkTd; arc=pass smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUKrkkTd"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c5513f598c0so473681a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 05 Feb 2026 11:03:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770318191; cv=none;
        d=google.com; s=arc-20240605;
        b=IMmbv8zImrjit69cyENWQgf327kBxRzwcrvjYf25r+yGRidVEzAl3nZ6ZbRUgdoe47
         kqg2NV+gQ0qR3QtkURLSw1nh3uSQgAG5yYdkk30TeZICb6uROzcVNBSVa5gbeL4BTy5l
         E3M3obvAk5lPRtinvN9L/D0S1XxFgl986x3ybCw2B8G2affFvEcGXdgw0yM6dCdRyZv2
         ZnIi7NeH33qX11hUzOi9q1RfOzsE+4ncqVc7jvkdNyRiF9WNU3+LizUuZsfEn5OoI/Bx
         8TRL37x8ySHLk1SZZcffSgRlyMJB6XqaFaKxD/7T2Wihwqo5ygo/g6VwM3lajfQgn3+W
         eFtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wMq2czingLs1wcNHuupFAGOHUrKeCMVUSnWEEmpxoVE=;
        fh=hFwVkff2kzyNC90pe7QepSBpkEE5NdawWPBXPdnDfgI=;
        b=Aivpi+CrBpkDIAtm9Ynl2VemgNvk8czFJKHLkdagRPr6P1GAAe0AYjy4EfSq8pB8jh
         pJiEpJc2fyccKi3dpZ/tBdN3LvhR6JKi7VgeM8hgQwvLiCOPVoDfh2Hz5gUA+R/kfJmK
         tkYpt/TjRKyQmOjBumoArWnr02+FsIoAbP/E9qOem7R+ViDvcVHT+my/MAwKZQdSnS8M
         nRqP0zXtLoTozvMLPzOa5t0RwHNNevE/LrcrHGu5fFyTByi+DrYtfGdNvetV+M6swnhN
         mKDtYasrF3eTIS9Ft7V5tI/+egAOC8GJBW2TkWfcGkXbGZQJJucIXl1eJuDRkl72GZwo
         WJ/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770318191; x=1770922991; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMq2czingLs1wcNHuupFAGOHUrKeCMVUSnWEEmpxoVE=;
        b=LUKrkkTdaUKhoVrqnePTJHYYIUfa+gb1niw+MpsIPqA92saT4XjtO3gZsXtV5NBxJj
         +Ayt7uPHrCdwSp44o+VXbJcoj0SqoyVVx6uQ5SGMXgsS3Zx+xWIb+EVMixaD+hZTUyqb
         2w6Bn/h5eD9aIyJ9h8kvniPLFigHwCJoD7ya5LT28WY7sKgTC/rskkw3pgDvuPagfQeF
         8PVqYM67CBJFwMKKdmcLQoWJp/ga1ihxCyFEM7ktW0DjuoYddCNtvfn9vNrLgojiki0a
         YThcs42zzL0IVnXiNryAQSrsQrPZrm2gYOszfcuiFF6VTxkevoPmtS5zNmaam+lGFaX8
         nw1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770318191; x=1770922991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wMq2czingLs1wcNHuupFAGOHUrKeCMVUSnWEEmpxoVE=;
        b=TP05vmr64LPphJwtsLQ18nRWVXxy0gAieajJ4dtOKXg65N0Ku5s190Jcwn3hs6fV+z
         hLJrRLt3Kdn7fJAZzAnA9xutF64BDqy1yTv7n7qNX+Pg9PLfSQzgADRo6wMUljcXAhF/
         M0jxTp9uBgXWl8VeBC+5zw1DyHVhp/gYuqMkAWLlNxiKOlWENB9CyyhEeshQTP/cjBnQ
         hvgyowpkayP9Y2X0WoD/UWgYC9HCfUwi+wmdauqHNb5GvI7RcpPVclB9bl+UBZ5HvmC5
         HXqfhp1aIHQd7Y0teyTRtfto7JXGhwRipi/a+B8yPcyx0YJ0VehMO4fdEnGlme6X2Mc+
         XNyA==
X-Forwarded-Encrypted: i=1; AJvYcCUJ/Fh0gWHoyl2u+4195Df+6m+NsUwYgsMbEmqbRsWQ9IVJqXw2+Vby27rq60uwS9DrY964XT1RODS0@vger.kernel.org
X-Gm-Message-State: AOJu0YxOShovdYW3R+j6GU4WCeB32ADblaLjHdXc4uTtQdmIvdZ4ajTe
	vK3YjcM6iAC0p/Gw2ADl9gQ5HJJHa9oRW/CHh1FSCS1bSy6mgylfH1yCJplLAaVWUIepzXuV5wv
	2701aRSzjofFVPc50T48qpbBWwUUXn6s=
X-Gm-Gg: AZuq6aK4iiJ3TRLioDGRc9WASUsHe5CKN9Tj4+2txPXChCj4NXqbEcnV5VWpJfVzBHj
	fTmmnfw6xKEHYA6trZ5Yd/XswvtnFVD2E6sHrj1P0P3CjrqZpYoKf1OmVXCVzJ3h/N+qTjEWea6
	KHJ2xPNWT/NbuBnPZGoomA2u89jSC81gYtlco4Kwi80k/YWm7YLz+vmMSYKeJRi0KvUbEKoOcdl
	hOFM+arlq/+zIag5/cGkfmQ/MGvCRdZY+CmWjqi4e0xrS+JQpe6WC8wfGrtk1ptCWRt5IlPcpPz
	6wj+GTt7520lvVgyIma5x49eJ8oN
X-Received: by 2002:a17:90a:dfcd:b0:352:d59a:b28 with SMTP id
 98e67ed59e1d1-354b3cae091mr42496a91.19.1770318190665; Thu, 05 Feb 2026
 11:03:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <431335747d3604c46f2e57a32d839a73aa8a8536.1770042461.git.lucien.xin@gmail.com>
 <20260205115542.2195362-1-horms@kernel.org>
In-Reply-To: <20260205115542.2195362-1-horms@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 5 Feb 2026 14:02:58 -0500
X-Gm-Features: AZwV_QhI8OwuLRWeiqC_GNUtx69lACcTHyYZmGGt6r8v7RB2RzBMyspqQrCybPk
Message-ID: <CADvbK_e8Sbm8Q3KVR=uZZDYuQLTdprRskN=jgompaSeYDkmhFw@mail.gmail.com>
Subject: Re: [net-next,v9,15/15] quic: add packet parser base
To: Simon Horman <horms@kernel.org>
Cc: steved@redhat.com, marcelo.leitner@gmail.com, aahringo@redhat.com, 
	alibuda@linux.alibaba.com, jbaron@akamai.com, hare@suse.de, kuba@kernel.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org, daniel@haxx.se, 
	quic@lists.linux.dev, jlayton@kernel.org, tfanelli@redhat.com, 
	dhowells@redhat.com, linkinjeon@kernel.org, hepengtao@xiaomi.com, 
	pc@manguebit.com, kernel-tls-handshake@lists.linux.dev, 
	illiliti@protonmail.com, xiyou.wangcong@gmail.com, 
	andrew.gospodarek@broadcom.com, mail@johnericson.me, edumazet@google.com, 
	pabeni@redhat.com, matttbe@kernel.org, netdev@vger.kernel.org, 
	smfrench@gmail.com, metze@samba.org, mbuhl@openbsd.org, 
	chuck.lever@oracle.com, dreibh@simula.no, davem@davemloft.net, 
	sd@queasysnail.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 6:55=E2=80=AFAM Simon Horman <horms@kernel.org> wrot=
e:
>
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
>
> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-loca=
l.html
> ---
> quic: add packet parser base
>
> This patch uses 'quic_packet' to handle packing of QUIC packets on the
> receive (RX) path. It introduces mechanisms to parse the ALPN from client
> Initial packets to determine the correct listener socket, routes received
> packets accordingly, and adds support for ICMP-based MTU updates by
> locating the relevant socket and updating the stored PMTU.
>
> > diff --git a/net/quic/packet.c b/net/quic/packet.c
> > index cf64a6aaa795..16a7db6ccd87 100644
> > --- a/net/quic/packet.c
> > +++ b/net/quic/packet.c
>
> [ ... ]
>
> > @@ -14,6 +14,637 @@
> >
> >  #define QUIC_HLEN            1
> >
> > +/* Handle ICMP Toobig packet and update QUIC socket path MTU. */
> > +static int quic_packet_rcv_err(struct sock *sk, struct sk_buff *skb)
> > +{
> > +     union quic_addr daddr, saddr;
> > +     u32 info;
> > +
> > +     /* All we can do is lookup the matching QUIC socket by addresses.=
 */
> > +     quic_get_msg_addrs(skb, &saddr, &daddr);
> > +     sk =3D quic_sock_lookup(skb, &daddr, &saddr, sk, NULL);
>
> Are the address arguments swapped in quic_packet_rcv_err()? Looking at
> other call sites in this file, quic_get_msg_addrs is consistently called
> with &daddr first, then &saddr:
>
>   Line 476 in quic_packet_get_listen_sock():
>     quic_get_msg_addrs(skb, &daddr, &saddr);
>
>   Line 513 in quic_packet_get_sock():
>     quic_get_msg_addrs(skb, &daddr, &saddr);
>
>   Line 536 in quic_packet_get_sock():
>     quic_get_msg_addrs(skb, &daddr, &saddr);
>
> But here quic_packet_rcv_err() passes &saddr first, then &daddr.
>
> Looking at the implementation of quic_v4_get_msg_addrs() in
> net/quic/family.c, the function extracts addresses from the packet as:
>
>   sa->v4.sin_port =3D uh->source;
>   sa->v4.sin_addr.s_addr =3D ip_hdr(skb)->saddr;
>   da->v4.sin_port =3D uh->dest;
>   da->v4.sin_addr.s_addr =3D ip_hdr(skb)->daddr;
>
> So sa gets the packet's source address (remote), and da gets the packet's
> destination address (local).
>
> Then quic_sock_lookup() in net/quic/socket.c expects:
>
>   if (quic_cmp_sk_addr(tmp, quic_path_saddr(paths, 0), sa) &&
>       quic_cmp_sk_addr(tmp, quic_path_daddr(paths, 0), da) &&
>
> This compares the socket's local address with sa and the socket's remote
> address with da, meaning sa should be the local (packet dest) address and
> da should be the remote (packet source) address.
>
> With the swapped arguments, quic_packet_rcv_err() would pass the remote
> address where the local is expected and vice versa, causing the socket
> lookup to fail. This would prevent ICMP Packet Too Big messages from bein=
g
> processed correctly, breaking Path MTU Discovery.
>
The code is correct, I may add a comment for the explanation:


        /* ICMP embeds the original outgoing QUIC packet, so
saddr/daddr are reversed when
         * parsed. Only address-based socket lookup is possible in this cas=
e.
         */

Thanks.
