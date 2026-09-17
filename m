Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5251149D58F
	for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 19:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789672015; cv=pass; b=duPd44aaka4palgMSwyTyqqgNzKIq5ozAAEOnxJxEe5GXvnh65kz88J//hm+Awpc67YapjlfxJcerbpUIZUnrDO1eZiMzd3VBiSM3Nyshtf2Kqgd+322Q/drNkizHHVSAQZc03y+MbuQkfQJ6Idp+jx74F/bX0Xkc7E4tgaXeH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789672015; c=relaxed/simple;
	bh=qqBrqtVZFn6NsXxcXXIMtlSWkhWESw0qIbjgWLUJZHc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jfxD6qxVrbl4+6eK8gDvGTfzTXBaQOJJTkVAfzvpeFvGYndUoao6d5RnRpXqrRkxHFWYnLToeqWAqvbmdVynYVViYUUESu6wm4treFyRZJo2JMmNZGNW4wGjzbFjpWKJfQG5Uv/TYClpHzsMNeESowyndbwRVpdjphZ8tH6XUgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IycoU3EF; arc=pass smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IycoU3EF"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39b350c6920so14857a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 12:06:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789672014; cv=none;
        d=google.com; s=arc-20260327;
        b=kivtZO+Ok+3Wys2kZ/XF4aFDvoFosp9f7Cvd02c7FBw1pdR7m88eD8C+/3ufXCgGxq
         43r/QGYm6vfqHkzw859i3VEdUDP23mBkO/Mt2Y7aNeQ9eACZEgSZerE1SCueBuKneVes
         AaaSvkbB+xCbfD2gH585FKlJSQvJnEcBWX1UY+jH84r43dU17rGGmjvuEt8Wmfd9SJOU
         Q+ksBMUutLeHW1sKQL4i8pZKKsknyujj2VkNDaIkCd9SgEAEb8QAV7khEWSDZleTC30U
         Ij5KkWp4fkIsGNLHjoeHGTF9UeOllel+dZyXsk2R/ZEiSWXlu4wCcmQrwkeqip8m2KHi
         e09Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AJdmTMqYmE/7xu/8ItFmggn+Kr8BDXFZhgiN1tzQfFI=;
        fh=ydl9OudZqwZcimcGlR2CA2+13i44JODTwSUND/EELyc=;
        b=cCW4Jvums4J90AM+uQQd6f/NVjF/aGW8C/q4Gv2h/EQ+HyGT4nuiAmBziyHIXcdwm1
         mOznflVrTUwqc3ISR4dzra96/gKdzmM5CjuIlyS7PFouab5QD+RI9U7mdJZHwE6ORnVd
         GCV9LobpqB74zFSqylAc2YvnEVPEsXwA47C564Fln/gfaB1wK9SeXyiBt87vwu688Tpd
         r/yhV2rM4GRds9p4H8M41YoxrzIv+WNsoQxKqHq2Sio6ePCr4F080f9WNJTUH33MIS8P
         djuUbJ+4Ku+QBkCb7Y0DvqVwIjCwFdNdtqkgR7XMDqC6rcpSxc37QYOPhqJ468R4M9Iv
         pGXA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789672014; x=1790276814; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AJdmTMqYmE/7xu/8ItFmggn+Kr8BDXFZhgiN1tzQfFI=;
        b=IycoU3EFALTx1858ujT4tsuxDZ8tn271nr0x3R95A4/sbG16/g5jI1VlOID8w0K79G
         06o6MMxQnyuwyrngxy4KLpkr2jw4k6HXreNVITiaczRMXqxng+adySA3g14sFWpg2X51
         Dkfda3ArcnrZI5RGq28QTnWB+Zs2WHCICpCuuLpVntAc77gCmenmCC7T4M6OozsuTuEz
         lrRV8a8hMr8SqdqsCwenhAIU+cTA4MJE+1pcbC76E8rXuy/J5VmYcb55g/qBIgorYrjy
         ybns6tXE3N3LBYDCcrVyOJxFuCaTnumJkopyJXFEhnOHVEia6Y3rxR1ib5IF55G0Epvt
         5b4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789672014; x=1790276814;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AJdmTMqYmE/7xu/8ItFmggn+Kr8BDXFZhgiN1tzQfFI=;
        b=rG0mSLEOwOwCuYyUKbPWxiVUj3a9lAy+1eVwDjcuOKaN4JP/HoI/R1iMXAfN9eaqY3
         oI/DWK2wcHBvX+Qsh5Ut/7bQQHJepGmC3fhqOia6BXPHqmcU7NxOuHUt9Qc20ANrAGLe
         tLyhL+qonGMBSRNsAC9moZ43jshw83LsvChdHgUULlgSEDFqyJ+6dAS28RHjyHO1HY8g
         50bWv98C82ioDbLDvL+/PL62RW1AovLdna6zE4lQr3PkLOATFaH0SnrA3i8/EZhrRGl/
         lu3C38VJO/JGCgx/fDsdH1nuaH+BI3nf1qbBqB9BcmmA7vtsQqBDWWqEm9nw5Gh7pGpB
         P33A==
X-Forwarded-Encrypted: i=1; AKwUvBzkVJuvwvQqeABIp8fsym8nk1DNrzORf7lhj4Fr/i6JuxfgH5/GQHjIFHxIFQhYCNTkMVKQ+ZQrYZFt@vger.kernel.org
X-Gm-Message-State: AFuF++lMWGP3AthCnrF56YelXIauYxP9ex9+OQi0J8vb5RQxTeuvMSzD
	vOKbkr2iZXMAGO6/tp3oBY4H8wBUKStjdUD4YL7umcFKoEQx+kqG+/iOWylfJAtEzF4fe/GmOxa
	5kadLZ1auchNjWqf69B/WAylgB/h9vBAv8fGxzhIE
X-Gm-Gg: AYBFou0oglxrxz/h1ety64YEXiO89atWyk0w4/OB68Sx14Rj1WsNZM/gqDovO72ym0U
	OJeEtcluu975Tp6o/2KklQjPAEB6uD+Glo3SpI4OpPbOXgq4hxB46YxLATaouNwfaKbbWRuOAO5
	sd/Iwzd8qTTUFGZMLis4umjtoRSI2Tq0y74l6tZRUZfGYgOFCq0g2WO8b7hZwWDRyi0zpJntLTx
	vnldHn5L6/2GoKbySShd5oefdW7PzwEFPn94/c4X05Rt8BOmUAEFgDja2O3tPu1njQPVvCOuR6g
	jWvcsJek16e+M02C1QLdElUZI03IY9en5KOd08JwvD9bmniQDUdT0tyfZTRCUzOrh3lzwX1E84y
	jjh0IUYiBGB20T6fPTA/6k5/yKu5Ilsjhfr9lwnoD96Gb3+Y120jfLVPvzz31GDWnz2hPeAu7+E
	BsPhA4Rj6kznnaQHtFpcM+OAeJqw==
X-Received: by 2002:a17:90b:54c4:b0:39e:4c7f:7308 with SMTP id
 98e67ed59e1d1-39e55071981mr225580a91.31.1789672013089; Thu, 17 Sep 2026
 12:06:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADvbK_dHPkHjkPwu0RepYgDsHs5reHepprRHU9hDFBxQM9_RGw@mail.gmail.com>
 <20260916234654.420056-1-kuniyu@google.com> <CADvbK_df5X=Szsd-d8=0gndhoBSHJhnEqSh826iYUW6=Ce_xEw@mail.gmail.com>
In-Reply-To: <CADvbK_df5X=Szsd-d8=0gndhoBSHJhnEqSh826iYUW6=Ce_xEw@mail.gmail.com>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Thu, 17 Sep 2026 12:06:41 -0700
X-Gm-Features: AcwNN1Vf1Dgl1Yuz1331KMxjXrgwRsS9uLrWePJOZIUaTVSoZLWo_yT69Va3HQo
Message-ID: <CAAVpQUCRcBQOS4H5zJBOoYeCgsQBiGyu8gjhXaocDXDw9jqTOg@mail.gmail.com>
Subject: Re: [PATCH net-next v15 15/15] quic: add packet parser base
To: Xin Long <lucien.xin@gmail.com>
Cc: aahringo@redhat.com, alibuda@linux.alibaba.com, 
	andrew.gospodarek@broadcom.com, chuck.lever@oracle.com, daniel@haxx.se, 
	davem@davemloft.net, dhowells@redhat.com, dreibh@simula.no, 
	edumazet@google.com, hare@suse.de, hepengtao@xiaomi.com, horms@kernel.org, 
	illiliti@protonmail.com, jbaron@akamai.com, jlayton@kernel.org, 
	kernel-tls-handshake@lists.linux.dev, kuba@kernel.org, linkinjeon@kernel.org, 
	linux-cifs@vger.kernel.org, mail@johnericson.me, marcelo.leitner@gmail.com, 
	matttbe@kernel.org, mbuhl@openbsd.org, mef@scarletmail.rutgers.edu, 
	metze@samba.org, netdev-bot+sashiko@kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, paul@jakma.org, pc@manguebit.org, quic@lists.linux.dev, 
	sd@queasysnail.net, steved@redhat.com, tfanelli@redhat.com, tom@talpey.com, 
	xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 6:38=E2=80=AFAM Xin Long <lucien.xin@gmail.com> wro=
te:
>
> On Wed, Sep 16, 2026 at 7:46=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.=
com> wrote:
> >
> > From: Xin Long <lucien.xin@gmail.com>
> > Date: Wed, 16 Sep 2026 14:08:22 -0400
> > > > > +struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union =
quic_addr *sa,
> > > > > +                                  union quic_addr *da, struct so=
ck *usk,
> > > > > +                                  struct quic_data *alpns)
> > > > > +{
> > > >
> > > > [ ... ]
> > > >
> > > > > +out:
> > > > > +     if (sk && sk->sk_reuseport)
> > > > > +             sk =3D reuseport_select_sock(sk, quic_addr_hash(net=
, da), skb, 1);
> > > >
> > > > [Severity: Medium]
> > > > Should the hdr_len argument be 0 rather than 1 here?
> > > >
> > > > quic_udp_rcv() already did skb_pull(skb, sizeof(struct udphdr)) bef=
ore
> > > > quic_packet_rcv() is reached, so skb->data points at the QUIC paylo=
ad, and
> > > > reuseport_select_sock() documents hdr_len as how far the pointer mu=
st advance
> > > > to reach the payload.
> > > >
> > > > With a classic SO_ATTACH_REUSEPORT_CBPF program, run_bpf_filter() d=
oes:
> > > >
> > > > net/core/sock_reuseport.c:
> > > >         if (unlikely(!pskb_may_pull(skb, hdr_len)))
> > > >                 return -EINVAL;
> > > >         ...
> > > >         pskb_pull(skb, hdr_len);
> > > >         ...
> > > >         __skb_push(skb, hdr_len);
> > > >
> > > > so the filter would see the datagram starting one byte into the QUI=
C header:
> > > > all its offsets are shifted and the first byte (form/fixed/type bit=
s) is
> > > > invisible, which can select the wrong socket in the reuseport group=
.
> > > >
> > > > [ ... ]
> > > >
> > > True:
> > >
> > > BPF programs may need to access the QUIC header, so I will pass 0 to
> > > reuseport_select_sock() to ensure the full QUIC packet is visible.
> >
> > Why do you use reuseport_select_sock() here ?
>
> Because QUIC socket supports SO_REUSEPORT and allows multiple sockets
> listening on the same addr/port/ALPNs:
>
> https://github.com/lxin/quic/blob/main/modules/net/quic/socket.c#L724

Okay, I was wondering how it was supposed to work without
reuseport_add_sock() etc.

reuseport_select_sock() should be moved to a later patch.


>
> The client Initial packet can select the listening socket based on the
> packet's source address and port, or by a BPF program that can inspect
> the QUIC packet.
>
> Thanks.
