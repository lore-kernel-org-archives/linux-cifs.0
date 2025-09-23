Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD592F9C37
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 19:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758656270; cv=none; b=Fdv4+ahMZLjsMPuOTNjjBfdO0K6TNPeD5i7BW3rmf0/QGmHw+28Gwd+m5jReFvv67rOPD80fdNl7Rz22xf5PQIE5So/8uKv23DLRneLtK18PfhW3+xZSXCdJs/RJAjPw/7xoMGTo5TYBArN044QcwMsFtkrSw9RpQa6NtIKT26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758656270; c=relaxed/simple;
	bh=+XXoF2ZxwT72G+CmMpYi9V7S13kBzWWDC8EXupg/QuA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nexaRxMKFmGh+UVJY9YX+xmYqo9RdfVu9UXRGTO0CLtS441madiVQaQDnC26S8dW+bJzwMJ+8o9nJPRN1ev7fFso0g/4x2nFdlBerL66nLiQFCwvPUk0CY//2/S+t95/11U/PeBDjys8wbPJVYXpj1AV6QwW+C6NUWKTE3u0Du8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R5e4Vi65; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R5e4Vi65"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-77f207d0891so2696519b3a.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 12:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758656268; x=1759261068; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KLUrp+cYYYU8MC53CfS/yqja0bSDjgPTxLoATUISEfA=;
        b=R5e4Vi65GhvbGIQinrl132poQG56koBvOL8x8Qbg9EX80ZuNRe7iU5itzS2GsDC8Wq
         j2tL2zqtMVqwP+tg5KuF7wrZvobtbVPxTLm9ATJy6U0e5r3SlUzO6VR0co2bFcWeZNOQ
         GKhhe5yrH9T36gI9y/Qby/3RFE024jxfLXHuUYuelb3p++wuIhRrXdG76RTCuQgk3Fc7
         l7grYoO4LbpXdiOGQpJ4mvlc16AeY3AS/vZEHuJcEIbZQ5XmaBvfDBNO8ZG8BkGAdNzy
         tE1pVFLa97GVJqU3V8RbcNjs6KgPynCF2kC7dQYDTIMLNSghRSvCNMenZTpmyX/B/Zc/
         Hurw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758656268; x=1759261068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KLUrp+cYYYU8MC53CfS/yqja0bSDjgPTxLoATUISEfA=;
        b=sprSL8aTKK8nx3gIONfd4sagptneehjm4mwKsmCcIfA3T4nR9VpEHuH2DUztpg1Cca
         7PxUgi7NWqpBgmvf7smkbbhMrFCL9YIJCda85c7mGa+eozRLDSajzvdejfvzWfOzAdrL
         +ZkPUAxtrpjAD6ebmC9M50lebPNqK08kpz+zksSzW6o8X/zGZs+SsXQyT6kbobJzWaZJ
         gTBe4K2EdeSXrvYZUH1rbqVr+H8KtBJWb5lQUmo4XZstY2Aj3kOLgeWZyUrsGqhU4OCY
         r4SHpQUypZ+SHINfI4qVSADEAusfRivxvdt0lOXj14t0YEhziq3v8v47PwDXS7oZSpsY
         GzJA==
X-Forwarded-Encrypted: i=1; AJvYcCWxisl2wV6Sj2Hje8sdXr9PTCNe+K6WGhGwUyJWym6MXCf67jW3ySNbZH30BucSrjHe6wP255MgOpBN@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7anQC8O0trYyn35YcqjP1G4CDbtZb1ajwSLgbpg4192tY9Jjm
	x3iO7ZpJF3+6/cIOgIG6x5niH2k2mnuSp4XL7ySdsNcXfqLPqMOOJHSd8AdGeJruY4JDPCESJ2K
	rArrMFt8Z+tp5tBUa+6XoH4LJJC+HzfQ=
X-Gm-Gg: ASbGncuGTIKnbLZAv35XeoOYvzKu1MaFaGs/lNALyzvX7L4p1ts4a2Pj/OQlGseWAB5
	3IEre1EHcGcPV5MhrcezaF2Rth81I/5cLp53VMlHFUgs6s6gpn829PVM9+FlbG957bsX/GPoCW0
	jqC+Od0pTb1lQP8SevPlUSe7wPfk1lvbNjwAIMrAmGKFbIsiWjuR8pMTvodW1J+5Q/v5e+L8bpm
	SroA8SLEA==
X-Google-Smtp-Source: AGHT+IErV6AYpLUins4xB7r0Q9A08f2HDRHBMzxtSLII0Tooor4nIEURR9QvyBSmUNpN2jo0FdszTswnlWssSR99fDo=
X-Received: by 2002:a05:6a20:7344:b0:24c:dd96:54f2 with SMTP id
 adf61e73a8af0-2cfd4836ad3mr5789184637.1.1758656267868; Tue, 23 Sep 2025
 12:37:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1758234904.git.lucien.xin@gmail.com> <3475257318dcfce0ee996131142969b1fce7ae8b.1758234904.git.lucien.xin@gmail.com>
 <a9427359-a798-4f3a-88ef-c10a0bf614ec@redhat.com>
In-Reply-To: <a9427359-a798-4f3a-88ef-c10a0bf614ec@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 Sep 2025 15:37:35 -0400
X-Gm-Features: AS18NWA9emAx36cB5XrlF-1nvhVl7KRbIJ2r3YH_HsuND-2tSxb3DLgCGkI_Y8U
Message-ID: <CADvbK_dxa0G-drauyggde2_46PdRfd9qzzmfuhj5NcMsOkGHRw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 09/15] quic: add congestion control
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

On Tue, Sep 23, 2025 at 9:55=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 9/19/25 12:34 AM, Xin Long wrote:
> > This patch introduces 'quic_cong' for RTT measurement and congestion
> > control. The 'quic_cong_ops' is added to define the congestion
> > control algorithm.
> >
> > It implements a congestion control state machine with slow start,
> > congestion avoidance, and recovery phases, and introduces the New
> > Reno and CUBIC algorithms.
>
> To moderate the initial submission size, you could initially introduce
> just one of the above.
That sounds like a good idea, and I will keep the one specified
in rfc9002: the New Reno, and remove the CUBIC.

>
> > The implementation updates RTT estimates when packets are acknowledged,
> > reacts to loss and ECN signals, and adjusts the congestion window
> > accordingly during packet transmission and acknowledgment processing.
> >
> > - quic_cong_rtt_update(): Performs RTT measurement, invoked when a
> >   packet is acknowledged by the largest number in the ACK frame.
> >
> > - quic_cong_on_packet_acked(): Invoked when a packet is acknowledged.
> >
> > - quic_cong_on_packet_lost(): Invoked when a packet is marked as lost.
> >
> > - quic_cong_on_process_ecn(): Invoked when an ACK_ECN frame is received=
.
> >
> > - quic_cong_on_packet_sent(): Invoked when a packet is transmitted.
> >
> > - quic_cong_on_ack_recv(): Invoked when an ACK frame is received.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/quic/Makefile |   3 +-
> >  net/quic/cong.c   | 700 ++++++++++++++++++++++++++++++++++++++++++++++
> >  net/quic/cong.h   | 120 ++++++++
> >  net/quic/socket.c |   1 +
> >  net/quic/socket.h |   7 +
> >  5 files changed, 830 insertions(+), 1 deletion(-)
> >  create mode 100644 net/quic/cong.c
> >  create mode 100644 net/quic/cong.h
> >
> > diff --git a/net/quic/Makefile b/net/quic/Makefile
> > index 1565fb5cef9d..4d4a42c6d565 100644
> > --- a/net/quic/Makefile
> > +++ b/net/quic/Makefile
> > @@ -5,4 +5,5 @@
> >
> >  obj-$(CONFIG_IP_QUIC) +=3D quic.o
> >
> > -quic-y :=3D common.o family.o protocol.o socket.o stream.o connid.o pa=
th.o
> > +quic-y :=3D common.o family.o protocol.o socket.o stream.o connid.o pa=
th.o \
> > +       cong.o
> > diff --git a/net/quic/cong.c b/net/quic/cong.c
> > new file mode 100644
> > index 000000000000..d598cc14b15e
> > --- /dev/null
> > +++ b/net/quic/cong.c
> > @@ -0,0 +1,700 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/* QUIC kernel implementation
> > + * (C) Copyright Red Hat Corp. 2023
> > + *
> > + * This file is part of the QUIC kernel implementation
> > + *
> > + * Initialization/cleanup for QUIC protocol support.
> > + *
> > + * Written or modified by:
> > + *    Xin Long <lucien.xin@gmail.com>
> > + */
> > +
> > +#include <linux/jiffies.h>
> > +#include <linux/quic.h>
> > +#include <net/sock.h>
> > +
> > +#include "common.h"
> > +#include "cong.h"
> > +
> > +/* CUBIC APIs */
> > +struct quic_cubic {
> > +     /* Variables of Interest in rfc9438#section-4.1.2 */
> > +     u32 pending_w_add;              /* Accumulate fractional incremen=
ts to W_est */
> > +     u32 origin_point;               /* W_max */
> > +     u32 epoch_start;                /* t_epoch */
> > +     u32 pending_add;                /* Accumulates fractional additio=
ns to W_cubic */
> > +     u32 w_last_max;                 /* last W_max */
> > +     u32 w_tcp;                      /* W_est */
> > +     u64 k;                          /* K */
> > +
> > +     /* HyStart++ variables in rfc9406#section-4.2 */
> > +     u32 current_round_min_rtt;      /* currentRoundMinRTT */
> > +     u32 css_baseline_min_rtt;       /* cssBaselineMinRtt */
> > +     u32 last_round_min_rtt;         /* lastRoundMinRTT */
> > +     u16 rtt_sample_count;           /* rttSampleCount */
> > +     u16 css_rounds;                 /* Counter for consecutive rounds=
 showing RTT increase */
> > +     s64 window_end;                 /* End of current CSS round (pack=
et number) */
> > +};
> > +
> > +/* HyStart++ constants in rfc9406#section-4.3 */
> > +#define QUIC_HS_MIN_SSTHRESH         16
> > +#define QUIC_HS_N_RTT_SAMPLE         8
> > +#define QUIC_HS_MIN_ETA                      4000
> > +#define QUIC_HS_MAX_ETA                      16000
> > +#define QUIC_HS_MIN_RTT_DIVISOR              8
> > +#define QUIC_HS_CSS_GROWTH_DIVISOR   4
> > +#define QUIC_HS_CSS_ROUNDS           5
> > +
> > +static u64 cubic_root(u64 n)
> > +{
> > +     u64 a, d;
> > +
> > +     if (!n)
> > +             return 0;
> > +
> > +     d =3D (64 - __builtin_clzll(n)) / 3;
> > +     a =3D BIT_ULL(d + 1);
> > +
> > +     for (; a * a * a > n;) {
> > +             d =3D div64_ul(n, a * a);
> > +             a =3D div64_ul(2 * a + d, 3);
> > +     }
> > +     return a;
> > +}
>
> tcp_cubic() has already an helper to compute the square root. You could
> re-use that one.
>
> > +
> > +/* rfc9406#section-4: HyStart++ Algorithm */
> > +static void cubic_slow_start(struct quic_cong *cong, u32 bytes, s64 nu=
mber)
> > +{
> > +     struct quic_cubic *cubic =3D quic_cong_priv(cong);
> > +     u32 eta;
> > +
> > +     if (cubic->window_end <=3D number)
> > +             cubic->window_end =3D -1;
> > +
> > +     /* cwnd =3D cwnd + (min(N, L * SMSS) / CSS_GROWTH_DIVISOR) */
> > +     if (cubic->css_baseline_min_rtt !=3D U32_MAX)
> > +             bytes =3D bytes / QUIC_HS_CSS_GROWTH_DIVISOR;
> > +     cong->window =3D min_t(u32, cong->window + bytes, cong->max_windo=
w);
> > +
> > +     if (cubic->css_baseline_min_rtt !=3D U32_MAX) {
> > +             /* If CSS_ROUNDS rounds are complete, enter congestion av=
oidance. */
> > +             if (++cubic->css_rounds > QUIC_HS_CSS_ROUNDS) {
> > +                     cubic->css_baseline_min_rtt =3D U32_MAX;
> > +                     cubic->w_last_max =3D cong->window;
> > +                     cong->ssthresh =3D cong->window;
> > +                     cubic->css_rounds =3D 0;
> > +             }
> > +             return;
> > +     }
> > +
> > +     /* if ((rttSampleCount >=3D N_RTT_SAMPLE) AND
> > +      *     (currentRoundMinRTT !=3D infinity) AND
> > +      *     (lastRoundMinRTT !=3D infinity))
> > +      *   RttThresh =3D max(MIN_RTT_THRESH,
> > +      *     min(lastRoundMinRTT / MIN_RTT_DIVISOR, MAX_RTT_THRESH))
> > +      *   if (currentRoundMinRTT >=3D (lastRoundMinRTT + RttThresh))
> > +      *     cssBaselineMinRtt =3D currentRoundMinRTT
> > +      *     exit slow start and enter CSS
> > +      */
> > +     if (cubic->last_round_min_rtt !=3D U32_MAX &&
> > +         cubic->current_round_min_rtt !=3D U32_MAX &&
> > +         cong->window >=3D QUIC_HS_MIN_SSTHRESH * cong->mss &&
> > +         cubic->rtt_sample_count >=3D QUIC_HS_N_RTT_SAMPLE) {
> > +             eta =3D cubic->last_round_min_rtt / QUIC_HS_MIN_RTT_DIVIS=
OR;
> > +             if (eta < QUIC_HS_MIN_ETA)
> > +                     eta =3D QUIC_HS_MIN_ETA;
> > +             else if (eta > QUIC_HS_MAX_ETA)
> > +                     eta =3D QUIC_HS_MAX_ETA;
> > +
> > +             pr_debug("%s: current_round_min_rtt: %u, last_round_min_r=
tt: %u, eta: %u\n",
> > +                      __func__, cubic->current_round_min_rtt, cubic->l=
ast_round_min_rtt, eta);
> > +
> > +             /* Delay increase triggers slow start exit and enter CSS.=
 */
> > +             if (cubic->current_round_min_rtt >=3D cubic->last_round_m=
in_rtt + eta)
> > +                     cubic->css_baseline_min_rtt =3D cubic->current_ro=
und_min_rtt;
> > +     }
> > +}
> > +
> > +/* rfc9438#section-4: CUBIC Congestion Control */
> > +static void cubic_cong_avoid(struct quic_cong *cong, u32 bytes)
> > +{
> > +     struct quic_cubic *cubic =3D quic_cong_priv(cong);
> > +     u64 tx, kx, time_delta, delta, t;
> > +     u64 target_add, tcp_add =3D 0;
> > +     u64 target, cwnd_thres, m;
> > +
> > +     if (cubic->epoch_start =3D=3D U32_MAX) {
> > +             cubic->epoch_start =3D cong->time;
> > +             if (cong->window < cubic->w_last_max) {
> > +                     /*
> > +                      *        =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> > +                      *     3  =E2=94=82W    - cwnd
> > +                      *     =E2=95=B2  =E2=94=82 max       epoch
> > +                      * K =3D  =E2=95=B2 =E2=94=82=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
> > +                      *       =E2=95=B2=E2=94=82       C
> > +                      */
> > +                     cubic->k =3D cubic->w_last_max - cong->window;
> > +                     cubic->k =3D cubic_root(div64_ul(cubic->k * 10, (=
u64)cong->mss * 4));
>
> Can `mss` be 0 at this point? Why?
There is QUIC_PATH_MIN_PMTU (1200) defined.
quic_flow_route() must be done and mss is calculated to set cong->mss
via quic_cong_set_mss() based on pmtu before coming to this place.

It should be ensured on the 2nd patchset, I will double check it.

>
> > +                     cubic->origin_point =3D cubic->w_last_max;
> > +             } else {
> > +                     cubic->k =3D 0;
> > +                     cubic->origin_point =3D cong->window;
> > +             }
> > +             cubic->w_tcp =3D cong->window;
> > +             cubic->pending_add =3D 0;
> > +             cubic->pending_w_add =3D 0;
> > +     }
> > +
> > +     /*
> > +      * t =3D t        - t
> > +      *      current    epoch
> > +      */
> > +     t =3D cong->time - cubic->epoch_start;
> > +     tx =3D div64_ul(t << 10, USEC_PER_SEC);
> > +     kx =3D (cubic->k << 10);
> > +     if (tx > kx)
> > +             time_delta =3D tx - kx;
> > +     else
> > +             time_delta =3D kx - tx;
> > +     /*
> > +      *                        3
> > +      * W     (t) =3D C * (t - K)  + W
> > +      *  cubic                      max
> > +      */
> > +     delta =3D cong->mss * ((((time_delta * time_delta) >> 10) * time_=
delta) >> 10);
> > +     delta =3D div64_ul(delta * 4, 10) >> 10;
> > +     if (tx > kx)
> > +             target =3D cubic->origin_point + delta;
> > +     else
> > +             target =3D cubic->origin_point - delta;
> > +
> > +     /*
> > +      * W     (t + RTT)
> > +      *  cubic
> > +      */
> > +     cwnd_thres =3D (div64_ul((t + cong->smoothed_rtt) << 10, USEC_PER=
_SEC) * target) >> 10;
> > +     pr_debug("%s: tgt: %llu, thres: %llu, delta: %llu, t: %llu, srtt:=
 %u, tx: %llu, kx: %llu\n",
> > +              __func__, target, cwnd_thres, delta, t, cong->smoothed_r=
tt, tx, kx);
> > +     /*
> > +      *          =E2=8E=A7
> > +      *          =E2=8E=AAcwnd            if  W     (t + RTT) < cwnd
> > +      *          =E2=8E=AA                     cubic
> > +      *          =E2=8E=A81.5 * cwnd      if  W     (t + RTT) > 1.5 * =
cwnd
> > +      * target =3D =E2=8E=AA                     cubic
> > +      *          =E2=8E=AAW     (t + RTT) otherwise
> > +      *          =E2=8E=A9 cubic
> > +      */
> > +     if (cwnd_thres < cong->window)
> > +             target =3D cong->window;
> > +     else if (cwnd_thres * 2 > (u64)cong->window * 3)
> > +             target =3D cong->window * 3 / 2;
> > +     else
> > +             target =3D cwnd_thres;
> > +
> > +     /*
> > +      * target - cwnd
> > +      * =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
> > +      *      cwnd
> > +      */
> > +     if (target > cong->window) {
> > +             target_add =3D cubic->pending_add + cong->mss * (target -=
 cong->window);
> > +             cubic->pending_add =3D do_div(target_add, cong->window);
> > +     } else {
> > +             target_add =3D cubic->pending_add + cong->mss;
> > +             cubic->pending_add =3D do_div(target_add, 100 * cong->win=
dow);
> > +     }
>
> Can `window` be 0 here? why?
It should not. When changing cong->window, there's always a check to
cong->min_window, which is set via quic_cong_set_mss().

>
> > +
> > +     pr_debug("%s: target: %llu, window: %u, target_add: %llu\n",
> > +              __func__, target, cong->window, target_add);
> > +
> > +     /*
> > +      *                        segments_acked
> > +      * W    =3D W    + =CE=B1      * =E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80
> > +      *  est    est    cubic        cwnd
> > +      */
> > +     m =3D cubic->pending_w_add + cong->mss * bytes;
> > +     cubic->pending_w_add =3D do_div(m, cong->window);
> > +     cubic->w_tcp +=3D m;
> > +
> > +     if (cubic->w_tcp > cong->window)
> > +             tcp_add =3D div64_ul((u64)cong->mss * (cubic->w_tcp - con=
g->window), cong->window);
> > +
> > +     pr_debug("%s: w_tcp: %u, window: %u, tcp_add: %llu\n",
> > +              __func__, cubic->w_tcp, cong->window, tcp_add);
> > +
> > +     /* W_cubic(_t_) or _W_est_, whichever is bigger. */
> > +     cong->window +=3D max(tcp_add, target_add);
> > +}
> > +
> > +static void cubic_recovery(struct quic_cong *cong)
> > +{
> > +     struct quic_cubic *cubic =3D quic_cong_priv(cong);
> > +
> > +     cong->recovery_time =3D cong->time;
> > +     cubic->epoch_start =3D U32_MAX;
> > +
> > +     /* rfc9438#section-3.4:
> > +      *   CUBIC sets the multiplicative window decrease factor (=CE=B2=
__cubic_) to 0.7,
> > +      *   whereas Reno uses 0.5.
> > +      *
> > +      * rfc9438#section-4.6:
> > +      *   ssthresh =3D  flight_size * =CE=B2      new  ssthresh
> > +      *
> > +      *   Some implementations of CUBIC currently use _cwnd_ instead o=
f _flight_size_ when
> > +      *   calculating a new _ssthresh_.
> > +      *
> > +      * rfc9438#section-4.7:
> > +      *
> > +      *          =E2=8E=A7       1 + =CE=B2
> > +      *          =E2=8E=AA            cubic
> > +      *          =E2=8E=AAcwnd * =E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80 if  cwnd < W_max and=
 fast convergence
> > +      *   W    =3D =E2=8E=A8           2
> > +      *    max   =E2=8E=AA                  enabled, further reduce  W=
_max
> > +      *          =E2=8E=AA
> > +      *          =E2=8E=A9cwnd             otherwise, remember cwnd be=
fore reduction
> > +      */
> > +     if (cong->window < cubic->w_last_max)
> > +             cubic->w_last_max =3D cong->window * 17 / 10 / 2;
> > +     else
> > +             cubic->w_last_max =3D cong->window;
> > +
> > +     cong->ssthresh =3D cong->window * 7 / 10;
>
> There are quite a bit of magic numbers that should be replaced by macros
> and/or associated with explainatory comments.
Yes, better to use macros.
I was expecting people to understand if from the comment I put in above.

>
> > +
> > +/* rfc9002#section-5: Estimating the Round-Trip Time */
> > +void quic_cong_rtt_update(struct quic_cong *cong, u32 time, u32 ack_de=
lay)
> > +{
> > +     u32 adjusted_rtt, rttvar_sample;
> > +
> > +     /* Ignore RTT sample if ACK delay is suspiciously large. */
> > +     if (ack_delay > cong->max_ack_delay * 2)
> > +             return;
> > +
> > +     /* rfc9002#section-5.1: latest_rtt =3D ack_time - send_time_of_la=
rgest_acked */
> > +     cong->latest_rtt =3D cong->time - time;
> > +
> > +     /* rfc9002#section-5.2: Estimating min_rtt */
> > +     if (!cong->min_rtt_valid) {
> > +             cong->min_rtt =3D cong->latest_rtt;
> > +             cong->min_rtt_valid =3D 1;
> > +     }
> > +     if (cong->min_rtt > cong->latest_rtt)
> > +             cong->min_rtt =3D cong->latest_rtt;
> > +
> > +     if (!cong->is_rtt_set) {
> > +             /* rfc9002#section-5.3:
> > +              *   smoothed_rtt =3D latest_rtt
> > +              *   rttvar =3D latest_rtt / 2
> > +              */
> > +             cong->smoothed_rtt =3D cong->latest_rtt;
> > +             cong->rttvar =3D cong->smoothed_rtt / 2;
> > +             quic_cong_pto_update(cong);
> > +             cong->is_rtt_set =3D 1;
> > +             return;
> > +     }
> > +
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
> Here in a few other place before you could use abs_diff()
Sure.

Thanks.
