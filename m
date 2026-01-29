Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD083271EB
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 19:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769715880; cv=pass; b=X30EyhBpfBQ2g57nzKgc/jp2KlwJhtxeAFff/stRuoABBmc18cJsJQtpM4v3aqJ5o4mKr9QntqiAyLKhBGQGYOyI7FZA8+2an71xVEA/pSnisIV4/QWOzflsIWL5dpTAmYLHkgroXpdlUE4IVIEffG3XQAEP4y914DGWc+Gt23c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769715880; c=relaxed/simple;
	bh=Y0rOjxXytJB+38cdl2LNr6UYE5fA4/7cWyfoN0StXhU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kdg+8Dmoyly+d/JxFlMtUDpft0pPmPtQ08XEoQFAMi9Ta4o+CIxv+u+qFBkghVEaezStB9dSr/iGHPVO7oGeFJi6Ac6XlGJR4YMnQRodX0CHwu2nHYet8iXiAhJmHyA8cvmwLoncymePYHNZL4Ca1timyY/VkeHIl9CF4aRIX9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i+U+QY4/; arc=pass smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i+U+QY4/"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5f547823192so560408137.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 11:44:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769715877; cv=none;
        d=google.com; s=arc-20240605;
        b=LUdMmVag8Gb4iyz4apU9MCaC0XjibYDZlsWQQr/7yetF4CUEMRh5VgOKMiPPoXxeAE
         y3gCdVj0qGVKk8zScmPrjq4KxdXHntMBYsRUo+DjJv7TzN9HaA8kaAuitVCNq6x7rPiP
         x90TGGiog1TO9yc/foDBTiQO+E8DaSA8TOy2Ha1qGtkU8PhGR5twXhpNxVxrcA7XXrMx
         3RTqRejXjih3SMzAVVXqcEuYj+etp3SPyaKhjvpdC+SrbMp/I8tJHR4L4dAsNVgt4cat
         J2m9b8Ng+fBrpUZP851+Iq5suv6t7TheFna2+BCYjHJV1UON9NugtnlSVc8cM4VqExjG
         4Z7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gbwVti2MveWgbF61EO9aejU185mP/ZCSwXbR5m8XjS0=;
        fh=0hYt+0NCa3mjOco2W3gCymCqC5JKZJaWRxtoOvm8wpg=;
        b=lj0GArI8I1YuqRIyoBXR+MITTTSj5aMXi47q7oZ7ehGpResJ9dnDGQOWTfBWMG1Q3d
         j6IAUgdiMSzKTnNYVIzaTK0iRdGGI4PHa7DmZfNpB78p3wt4u+VSuPJWjkA2dwjjbtqj
         zYIsY5e+FLS7niwmr077N24OXwLqNGC/I59HwHix+EVgqSW94JcKpmac5YeVlD34C3Vc
         MRrZpaC2xWkTRdsA46FRNYVQWAEmKLGdIdGUGUAl1w8ci6r1L+CM8ZqRG61bHlxSTt1s
         AqqXFCW7TAqXZzd8kRIZU+qbv5HP+cfzAY3MvlsGPou5t8veR/75OU7laM6KO1MlIN7j
         6Oow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769715877; x=1770320677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gbwVti2MveWgbF61EO9aejU185mP/ZCSwXbR5m8XjS0=;
        b=i+U+QY4/8SKhsKGIab8XPm0cB5toASuCzlmBZhre8O882K7JKZAre1VMB/ducovgef
         Jj3DLv2X4YwzLkc0zx8Ig+4VbOfPKgxq41QkXNkxncXbE8Yvcq+C8lLw3ZhXMwjQKZKE
         EQ5UKTI2yt1Yb1jjnEMoRn9y+lzcaxg7T8v2jpoYcyPIA/X9198+J7UMc2/Z9qbCZNsm
         Eu2MYEvmxzq6+7oCYyoJXIS9y42G7JJ9V8fyQk2YcF9tevTqpI2++qGbttdNVcqop9iT
         ltflJ1Fd6Z+z4dwRjWbQMk+7pJD4w1CLKnzTHHpDXNn5ydPPaTczmwj0xQ8aYUTbqFC/
         vHzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769715877; x=1770320677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gbwVti2MveWgbF61EO9aejU185mP/ZCSwXbR5m8XjS0=;
        b=MkJaMj1E8jX2CNnf2yLgkJDD4VfsKfw+H2mBsjWdPWQXjMZCcPKyMqPMz3vlpwYB6F
         j5FlI1K2mmFwOw+M1x85C2a/frxYoctJ0ZlCFcTt3h6zvsJWUeDvEe4TQRYzxClQ1g/p
         j/r853t1fx2iKu9sauqUM5cePDIjXfVnvw5IB3pCZZ3KwzxnomPPCl2iH6tJsx+erQXm
         ncGyVZSxg2yf3TDMHgsD7gq5E0Af3dFKrDeHsHtiMW0ZAodU/PdJ/wDsm5RPi7hr5sh6
         T+QalpXOHtD0nDkF4z5PLtxr/Y6tolzyUkZTBuDWubiGdpT56vwp2QKe3gbrB85iIhj7
         WILA==
X-Forwarded-Encrypted: i=1; AJvYcCVCYUVHUULD9fmldnPWFzNduWDK77zOfG1q893gxjFM5yzhw2Wjb1auiS5uf78sR3+9NfZnz+3bBKfb@vger.kernel.org
X-Gm-Message-State: AOJu0YxbPV1QyEnkkjasDHSrGUvPs8aongFqqp83xS9+FlSHc5CZevBF
	HUVS8cTk7ziBczFsUzo+V97iaAnIaghZLtPiy0Hhh+sfY1fizBVyHVVcczlwq/ZkKBa/9jH4kv1
	xAsC+JAZYZNa3GNGumHoEIp1ty6pZJnY=
X-Gm-Gg: AZuq6aI2IfBbnrmS2geV0ydEgznSyvDfybdr/rOp5KujJ9VeOpbFWuMRowihvk/frMn
	7Q3OHeELYtLRZ1m92BpX5hfh2pkrLR2ceNzfSsLf5h5eWvQaTEP9Fx5lmzlM+PX+HdxRumqA/N2
	jvhar00ZWh5OKstkg6W8QTERIr74KzJBIuI6mTQ8CQFpd6oyRl3vfCQm9dZbwQaCkCsrJDsczYH
	l3TGP9YA6YHLvSzzbpS/MTGMeDpbTB8aJGhNDY3wdXkLpLJUtUFQhM4TQBieuuCceN+bh/B4Wuy
	eEsiT5kF4y2K1xd6zPFriGtIQNzB3w==
X-Received: by 2002:a05:6102:3a0d:b0:5f5:33e4:12ea with SMTP id
 ada2fe7eead31-5f8e25b8bb5mr192452137.31.1769715876891; Thu, 29 Jan 2026
 11:44:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9b38b4291e2b1b47ee17f7247c4c66f5bcdccffe.1769439073.git.lucien.xin@gmail.com>
 <20260128161505.1454974-1-horms@kernel.org>
In-Reply-To: <20260128161505.1454974-1-horms@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 29 Jan 2026 14:44:24 -0500
X-Gm-Features: AZwV_QiOMgB9Wkbq9Dg2c4rBLhA6Us48hykz0TzV8M9p-NxQPJtuqm3d7-FhuP0
Message-ID: <CADvbK_cNUg+N5jAnmJXGBri27+AkwuFFhbKUqONkAgu1ZAmOJg@mail.gmail.com>
Subject: Re: [net-next,v8,09/15] quic: add congestion control
To: Simon Horman <horms@kernel.org>
Cc: jlayton@kernel.org, davem@davemloft.net, daniel@haxx.se, kuba@kernel.org, 
	dhowells@redhat.com, chuck.lever@oracle.com, andrew.gospodarek@broadcom.com, 
	matttbe@kernel.org, tfanelli@redhat.com, metze@samba.org, 
	marcelo.leitner@gmail.com, edumazet@google.com, linkinjeon@kernel.org, 
	hepengtao@xiaomi.com, illiliti@protonmail.com, quic@lists.linux.dev, 
	mail@johnericson.me, jbaron@akamai.com, alibuda@linux.alibaba.com, 
	tom@talpey.com, steved@redhat.com, sd@queasysnail.net, pc@manguebit.com, 
	smfrench@gmail.com, pabeni@redhat.com, netdev@vger.kernel.org, 
	linux-cifs@vger.kernel.org, xiyou.wangcong@gmail.com, dreibh@simula.no, 
	kernel-tls-handshake@lists.linux.dev, mbuhl@openbsd.org, aahringo@redhat.com, 
	hare@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2026 at 11:15=E2=80=AFAM Simon Horman <horms@kernel.org> wr=
ote:
>
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
>
> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-loca=
l.html
> ---
> quic: add congestion control
>
> This patch introduces quic_cong for RTT measurement and congestion
> control. It implements a congestion control state machine with slow
> start, congestion avoidance, and recovery phases using New Reno.
>
> > diff --git a/net/quic/cong.c b/net/quic/cong.c
> > new file mode 100644
> > index 000000000000..1a8b7f8db977
> > --- /dev/null
> > +++ b/net/quic/cong.c
>
> [ ... ]
>
> > +/* rfc9002#section-5: Estimating the Round-Trip Time */
> > +void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_de=
lay)
> > +{
> > +     u32 adjusted_rtt, rttvar_sample;
>
> [ ... ]
>
> > +     /* rfc9002#section-5.3:
> > +      *   adjusted_rtt =3D latest_rtt
> > +      *   if (latest_rtt >=3D min_rtt + ack_delay):
> > +      *     adjusted_rtt =3D latest_rtt - ack_delay
> > +      *   smoothed_rtt =3D 7/8 * smoothed_rtt + 1/8 * adjusted_rtt
> > +      *   rttvar_sample =3D abs(smoothed_rtt - adjusted_rtt)
> > +      *   rttvar =3D 3/4 * rttvar + 1/4 * rttvar_sample
> > +      */
> > +     adjusted_rtt =3D cong->latest_rtt;
> > +     if (cong->latest_rtt >=3D cong->min_rtt + ack_delay)
> > +             adjusted_rtt =3D cong->latest_rtt - ack_delay;
> > +
> > +     cong->smoothed_rtt =3D (cong->smoothed_rtt * 7 + adjusted_rtt) / =
8;
> > +     if (cong->smoothed_rtt >=3D adjusted_rtt)
> > +             rttvar_sample =3D cong->smoothed_rtt - adjusted_rtt;
> > +     else
> > +             rttvar_sample =3D adjusted_rtt - cong->smoothed_rtt;
>
> The comment above references abs(smoothed_rtt - adjusted_rtt). Paolo Aben=
i
> suggested using abs_diff() from linux/math.h for this calculation in v3
> review, and it was acknowledged. Could abs_diff() be used here instead of
> the manual if-else?
>
> https://lore.kernel.org/netdev/a9427359-a798-4f3a-88ef-c10a0bf614ec@redha=
t.com/
>
Wow, AI truly has a good memory.
Right, I somehow missed this. will apply abs_diff() here.

> [ ... ]
>
> > diff --git a/net/quic/cong.h b/net/quic/cong.h
> > new file mode 100644
> > index 000000000000..e6cfb0fa1b6c
> > --- /dev/null
> > +++ b/net/quic/cong.h
>
> [ ... ]
>
> > +struct quic_cong {
> > +     /* RTT tracking */
> > +     u32 max_ack_delay;      /* max_ack_delay from rfc9000#section-18.=
2 */
> > +     u32 smoothed_rtt;       /* Smoothed RTT */
> > +     u32 latest_rtt;         /* Latest RTT sample */
> > +     u32 min_rtt;            /* Lowest observed RTT */
> > +     u32 rttvar;             /* RTT variation */
> > +     u32 pto;                /* Probe timeout */
> > +
> > +     /* Timing & pacing */
> > +     u64 recovery_time;      /* Recovery period start timestamp */
> > +     u64 pacing_rate;        /* Packet sending speed Bytes/sec */
> > +     u64 pacing_time;        /* Next scheduled send timestamp (ns) */
> > +     u64 time;               /* Cachedached current timestamp */
>                                    ^^^^^^^^^^
>
> There appears to be a typo here - "Cachedached" should be "Cached".
Will fix this typo.

Thanks.
