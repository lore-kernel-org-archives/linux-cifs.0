Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC1C5427FC
	for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 13:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789652304; cv=pass; b=oyF0ihVqWngo/H3c5Kam4Fz0CeasE4SQoWPv45G4GZ7KPbeRq/YA6tECopVAzuqQMKpCZgPv9Dwe09nrqGGFV67JvvuFNblzHKYF3tcGHV7pjP88PVi2DJGVVM/6huXl4evdrkkuDSLwwerCYil4KdswHhIOUdTDJjTrbpQPumM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789652304; c=relaxed/simple;
	bh=QNgM/kGDeBltidJ5TEbfEpxfYTzoLMWF0KKEi/Dse7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=snzxOXeeCwpFS1EGgWBpC+7UXigbtQx9lhHNX6efaqn0ELvQsboovUVO/iLl8c09M1o6xYjFEsSTowArdCnhqwaBWOE8uO7szKdSXRqdJWL5EvzAfgounaBsG6u9G5VD++TOc4VLp6wkLTA+DUNIlQaoxdmLUnQ0bJKqdPB4eA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pIrSUZxZ; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pIrSUZxZ"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-86ec25cf7ecso728318b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 06:38:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789652292; cv=none;
        d=google.com; s=arc-20260327;
        b=VphJq+1OqmymFt5yX2Rh2QZVnfoL/454N+6Mz5kjnBIGYY4Yj1lNKW3sJZzk/ryJ6U
         vzLEtYMgc545Mj7HHaAU2/xzqy54emJDCOW8VA0KisZtCPTYUG9ZqYv5ipb+H9id4hkQ
         k5PSbRqo1GZ2D7nqBecm8PNbATMgdzO9Q7c2C04ecXVX7RU+1O0KT0h8eCKVG9zi6CwE
         9HixuFAjtlU9w/qoLSmwagzv54mxyhfsmLL2lB1hcjxWUJRiCgWzWDGDvGr8pQI201b2
         wTUc1LlvsuSqyx/sQ/I8uHGRGUjlO7NxKDi9VyS80b/tKpjodWcxXtvytAJPm0md3LU8
         yHEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iuO1BQZ4V2eevpIqkFGI24nl/ujAkD0tm8XPYi2iD1M=;
        fh=0yFdGGtjap+kcFE/oi6kygF6CFoT+TU6MOTRLM6/1Y0=;
        b=pPeTMyFXxC3oUHeETn6XWgSyLI3GIuST8ogowT66ftAIiW3Oqoz9UAiC0Y4epeGd5u
         9qiYP3+aKmIbVEyfoHi6HDuspei+LoWhLG0BwcF7ffZEFmEUwHiJ4z1E0uj8tGGA+e8f
         rKR1paXILAJ2dCp5dDvbtCRZ/GKutfTyULVP9lG59dLTsUOJTWZ2qmBHcoHChQyBW5pj
         5IZDsA5nL5FURvK49ID4uyq2TsNuaqwFGVa7OvZijb28vRnpMvT36YanMjlxzvm83hbf
         iFKBt4Ldc8IX2kG3yaOW/PTyszaq2/m/YZv4IqZe/wZZMuAP1asi02qjzpRmUcLWZIYl
         f2Yw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789652292; x=1790257092; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iuO1BQZ4V2eevpIqkFGI24nl/ujAkD0tm8XPYi2iD1M=;
        b=pIrSUZxZcSdtIn2adyUd9JOpVISkFGg1qUjGy5JGjBzG8JYWdkHNQAN3IojHp7kMuw
         5rJe0TbTZZULKB3Pq/03PWrAJgDa1LPXpqr8MCLCDE0uJOqUkgO91MDGWhLk7Vqvgo2K
         Q7RGzGY+XeFjdYHdwL0hpsZod7Lsv5kT2f4lA6YxyMQh/fEr/Zx2YoG1C8pLK2pGSqoz
         sjONTM2QL6O7wPGRNz+keRcEiXzi0zj+OsG6vTWz8lwCG+iD8HyR2+2Pnr6XTcQWeEGr
         nBX9XMEwxPIAE89F+vhilGu9PA3T+1wc1AErBYjrlDK9uchf3ZhfXAb/Bkp+3iSfFxQ0
         6TKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789652292; x=1790257092;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iuO1BQZ4V2eevpIqkFGI24nl/ujAkD0tm8XPYi2iD1M=;
        b=DKUQfRKAXeQymKEXt1SLK4l/W5qjPE/8G737o7ErNTecYXDWO4Z9P9emdQ/jpi/+T8
         y9qTkSbmCAP23Hqutuydvx3+zIvXw0l9XekcvU20wydebru+p9IDDUwHLX/O/v/hLnGp
         DVprzvSPTCFyfWfNS5Rox95FxZNoIZ1Ckq8d0E1g/YF5HT1f4i+GEHTzKypxGvuhAfyi
         3diCJ65To7dRH1cihwQO4Rj6iqPHQY+GxlSBPA3Q34zvpxRtKwirZeKL6+DGOZDrs+/w
         WjOq/XgxG3HpvHmM6HRCn9JnX9PNNy464VWqZE4duPYWDUzGkyrB2uNT7ONsWcH22vwN
         P3ig==
X-Forwarded-Encrypted: i=1; AKwUvBzLNZnLyeDHBmaTMI18gLDHgwTNcZuy7WrO9EE2w1GGkHvRU1dcsfD0GdWCxg0oeyhQkxG3LinVl0DA@vger.kernel.org
X-Gm-Message-State: AFuF++lak9dmahmtJs0nM/UBnryX24+BRzqKnzrykauM6jqNEK0jxVHA
	Tz0T9jBPmJk4uDKLAak1XGg8nzW5x57/AWTlPvx5/QV1yB+pm4y1lqbF4HH/4Unot/v29Zia29Y
	0HMPaHq02ASnZLOm0gYZ3O734SZ4ssOU=
X-Gm-Gg: AYBFou0IErQVDXhI38lTmzdCkSwj5dE/HfyfPR8T7kSaMz3K+WGa58DrG/hZ9FU7Fr8
	FeR/zI6GdK9kppEoHeXW4F3VuYkRwoSt5g1Y1SwYwAvh4eNlYXakwl3EcvPVxLa8hYdaPYTTF7q
	mT9MOCm2oQ3DbT6qfCZPRonIQCdpLkntMTkNBnrAYSpzmeWglZOjvxcT7gUYh9Oo3kCucba4PVm
	/WSAxIYyXP+RJUvfjtw/VsypqhUeujrHzRLc+J7ZjrKANXwM7zk7fus0e3i0qTPZEPNMoUswJaj
	CtlWKxV1KGIheHAdUT8XbrxwSuSGytVTI3a+dpPVAOYsHHm2AbIZv8d0ji3EtOWysGcmceccL4q
	GV1S9UgczErIRoOyLchBAUY23gSfpzPVzuAsEaCMBNvz9JCjQYCdV1pw=
X-Received: by 2002:a05:6a00:c58e:10b0:874:72b6:7dac with SMTP id
 d2e1a72fcca58-87472b68104mr229753b3a.39.1789652291802; Thu, 17 Sep 2026
 06:38:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADvbK_dHPkHjkPwu0RepYgDsHs5reHepprRHU9hDFBxQM9_RGw@mail.gmail.com>
 <20260916234654.420056-1-kuniyu@google.com>
In-Reply-To: <20260916234654.420056-1-kuniyu@google.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 17 Sep 2026 09:38:00 -0400
X-Gm-Features: AcwNN1WyswquGpQo0eLBq8SospQls0DTN_D79sTSRdER_SDP9o7rXxWvgz7asJ4
Message-ID: <CADvbK_df5X=Szsd-d8=0gndhoBSHJhnEqSh826iYUW6=Ce_xEw@mail.gmail.com>
Subject: Re: [PATCH net-next v15 15/15] quic: add packet parser base
To: Kuniyuki Iwashima <kuniyu@google.com>
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

On Wed, Sep 16, 2026 at 7:46=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.co=
m> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Wed, 16 Sep 2026 14:08:22 -0400
> > > > +struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union qu=
ic_addr *sa,
> > > > +                                  union quic_addr *da, struct sock=
 *usk,
> > > > +                                  struct quic_data *alpns)
> > > > +{
> > >
> > > [ ... ]
> > >
> > > > +out:
> > > > +     if (sk && sk->sk_reuseport)
> > > > +             sk =3D reuseport_select_sock(sk, quic_addr_hash(net, =
da), skb, 1);
> > >
> > > [Severity: Medium]
> > > Should the hdr_len argument be 0 rather than 1 here?
> > >
> > > quic_udp_rcv() already did skb_pull(skb, sizeof(struct udphdr)) befor=
e
> > > quic_packet_rcv() is reached, so skb->data points at the QUIC payload=
, and
> > > reuseport_select_sock() documents hdr_len as how far the pointer must=
 advance
> > > to reach the payload.
> > >
> > > With a classic SO_ATTACH_REUSEPORT_CBPF program, run_bpf_filter() doe=
s:
> > >
> > > net/core/sock_reuseport.c:
> > >         if (unlikely(!pskb_may_pull(skb, hdr_len)))
> > >                 return -EINVAL;
> > >         ...
> > >         pskb_pull(skb, hdr_len);
> > >         ...
> > >         __skb_push(skb, hdr_len);
> > >
> > > so the filter would see the datagram starting one byte into the QUIC =
header:
> > > all its offsets are shifted and the first byte (form/fixed/type bits)=
 is
> > > invisible, which can select the wrong socket in the reuseport group.
> > >
> > > [ ... ]
> > >
> > True:
> >
> > BPF programs may need to access the QUIC header, so I will pass 0 to
> > reuseport_select_sock() to ensure the full QUIC packet is visible.
>
> Why do you use reuseport_select_sock() here ?

Because QUIC socket supports SO_REUSEPORT and allows multiple sockets
listening on the same addr/port/ALPNs:

https://github.com/lxin/quic/blob/main/modules/net/quic/socket.c#L724

The client Initial packet can select the listening socket based on the
packet's source address and port, or by a BPF program that can inspect
the QUIC packet.

Thanks.
