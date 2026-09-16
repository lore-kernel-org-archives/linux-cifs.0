Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C119C4AB3B5
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 23:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602417; cv=none; b=l4z1XPaBpU+M/jtxuK6zbbS7a61DsnJQ1peU1SCWDd2qRzBzSo/xBmSGHGxTrgaPb1vDFeK1MJF3u4RuOCisyIQRF72IjMf9txsu/Z8N4ebMhmOvTvN5PjqrAbQPHMXWzw9ROqWZBnDoburH6Qz8gI1e9zBfaFv2jQz1hUZyjYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602417; c=relaxed/simple;
	bh=VIzkbkLXxZKsovXpA+xdjAahySxj4wsP44L+acvQp1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=asQ/MzifA0SEf8yjQ99ImeAko/nddob1/xsFNIxWXgsFjvPywBqYUS8idVGyuaJTXG0u3iI6yn8aNPnMZnEKKscTEcf1s3E1kvIWbZaKPjqDRfPJ45NUy2wTtlwokFDwbNiCk7Y+zme1kS6wU6IHhVel7vNDj4pXDsWo2is2lhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kRE6/LFA; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kRE6/LFA"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d7443e0f0bso5010925ad.1
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 16:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789602415; x=1790207215; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hK+wEjpxWroA8oXhEwZgbSNMxTBytitf0+teGzIfaNE=;
        b=kRE6/LFAmorDNoeizhKwXfudaRivj9m2hO8dQM1I6oySraQn4hRxGMGQFiUDsscVbn
         hHKS+93OP2LHaVV/4z+0in0OSBUxGRNUh9UPjVrNF05c/Uxam4VQ+AodyEDYYq+WSg6I
         HwJllHTmMP0Cmhat+KTl79hcU5qljolUdtFrpgTD0nFlccGA6x1u6kCwqhVXLi8J5G9C
         x2HBt283gkOmv02Fwj8KewVZ+5s79WY0nRyG6K2Q3Uq1hoKykQx6QsxNjKS0PhUpM36q
         lPNss/jOniTK4PNWlbUxjHfGp0SkOp8dwB3znttf7ZbemWBSYdvuGEJb8Yvw34pxQ3NZ
         wk4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789602415; x=1790207215;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hK+wEjpxWroA8oXhEwZgbSNMxTBytitf0+teGzIfaNE=;
        b=Ok3/g4ayRfZJbEZkEuHO+Kfto8s7Ch+4Lm/80IuwZ6iOSqpT3BmiMtXJoKUXsO0vQU
         qPsSri5EhU21G1kL4JBHLCYPSsOsX7ArBtJVz3h7snwlsdIVsYCN1rSftCWrfh3Y8Joc
         r1lgSd/cHKuQzDmqllaf0Iirh4qaJnZoMKoEDaBj8vHxAwv3/blIxk3DBzO3miNcoKKm
         7us6MyPSnKH8MiS9Pupye5UxhOXfMz2cobTY1496ZR63e0p4zS3PnwHb74rsKHGaDtK9
         gHMJLHbL/7ASsKl4Czjs5rSUSnvkRyOMFwwZs/bWLU7/ktnoT7xK7H23+9mWFmMhv91/
         HYaw==
X-Forwarded-Encrypted: i=1; AKwUvBxoEoSS6B/vcQ5POC+soomH0qWrI1eyskBlQOqy4VBED1m+748V7aDqrTrHei0ugszPkqEU/KmKvHe4@vger.kernel.org
X-Gm-Message-State: AFuF++mBFjNXcHLiG+nvPwIvvrQidBM3cP/URw/BuddO2Qd5suKtSY3U
	lgvcwvrSMw3TOlevu9CCFvGpWRlh01Klu7SlYO1CI0+d1DgnHnQ9LiMGlcDqQr+PFdC76dHnMKR
	4mw1esw==
X-Received: from plhl8.prod.google.com ([2002:a17:903:1208:b0:2dd:630:cea4])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2984:b0:2db:7269:38ef
 with SMTP id d9443c01a7336-2dd8e40ef80mr99903675ad.14.1789602414500; Wed, 16
 Sep 2026 16:46:54 -0700 (PDT)
Date: Wed, 16 Sep 2026 23:46:13 +0000
In-Reply-To: <CADvbK_dHPkHjkPwu0RepYgDsHs5reHepprRHU9hDFBxQM9_RGw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CADvbK_dHPkHjkPwu0RepYgDsHs5reHepprRHU9hDFBxQM9_RGw@mail.gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260916234654.420056-1-kuniyu@google.com>
Subject: Re: [PATCH net-next v15 15/15] quic: add packet parser base
From: Kuniyuki Iwashima <kuniyu@google.com>
To: lucien.xin@gmail.com
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

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 16 Sep 2026 14:08:22 -0400
> > > +struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
> > > +                                  union quic_addr *da, struct sock *usk,
> > > +                                  struct quic_data *alpns)
> > > +{
> >
> > [ ... ]
> >
> > > +out:
> > > +     if (sk && sk->sk_reuseport)
> > > +             sk = reuseport_select_sock(sk, quic_addr_hash(net, da), skb, 1);
> >
> > [Severity: Medium]
> > Should the hdr_len argument be 0 rather than 1 here?
> >
> > quic_udp_rcv() already did skb_pull(skb, sizeof(struct udphdr)) before
> > quic_packet_rcv() is reached, so skb->data points at the QUIC payload, and
> > reuseport_select_sock() documents hdr_len as how far the pointer must advance
> > to reach the payload.
> >
> > With a classic SO_ATTACH_REUSEPORT_CBPF program, run_bpf_filter() does:
> >
> > net/core/sock_reuseport.c:
> >         if (unlikely(!pskb_may_pull(skb, hdr_len)))
> >                 return -EINVAL;
> >         ...
> >         pskb_pull(skb, hdr_len);
> >         ...
> >         __skb_push(skb, hdr_len);
> >
> > so the filter would see the datagram starting one byte into the QUIC header:
> > all its offsets are shifted and the first byte (form/fixed/type bits) is
> > invisible, which can select the wrong socket in the reuseport group.
> >
> > [ ... ]
> >
> True:
> 
> BPF programs may need to access the QUIC header, so I will pass 0 to
> reuseport_select_sock() to ensure the full QUIC packet is visible.

Why do you use reuseport_select_sock() here ?
