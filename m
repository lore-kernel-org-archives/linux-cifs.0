Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795623688;
	b=NrAf/EmB5Pl3s8hrIVJFHRpS3SdJCGNI3WVSnJgUOTm0+Xpul3Plx11+p5NXiTguotzj
	 5OXOMv2QJvuZJ5FSE5KOqMdOLTlIdkgyodditXWvYCb4acna/zOTXuOH5ZZRkJY/Lj5mh
	 PoqcyJbTkdjgqL0PWAd33qz99PLMSp5f+004k1huqgyWfOvp8QzOFLQECY7DfyB9oLaeK
	 FviVYQOPThOO7JEsJRCWyrfLwu/Mt1t/PmG/9VT3Wklbj2tIdaJo/N0mWBue50I8SA9cQ
	 +xXtaHgWjh2osM1Fy2m6sqRBSZcUtibsbzBD9SkwxSwbfJHxMOdgwNVDC4URiymOxpA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623688;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=jL/0Bwl1ePYdGwOEmrzwhpq81wxXh5l9YreMntjOUuk=;
	b=0K/sv93OHV/0C4fObyzPzGu3Yj0POfKG7osIR+1yRwU7DhLFq5aaguvKQPl9SDyft7zn
	 j8UyZaRLRPnSKQbkD5aG1uSfPDTcrlG8qGVh8pfUf/k/59pe5mzliIWI1IaN7qEGdrqUf
	 Q+2HxF/OTRYbcYLBHgyda2owG6Be0C1q7ft5/aM6O9NaQOFOY3uggt1pZy6pUy7TJirVG
	 aqCN4utsw5wulxfAjcQVMrP83IDP8H9WO+S6B3+mSvUQjjgcx4o9UyP11YqZMgzazJqxs
	 H78zTwtNZmodA93yTMf7LZJWeUb8YcyO/eyK05E5zqCiZdvu8VIIyqvXW4xqRZS6agQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f2cVcbdD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CD1606A33A
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 16:21:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46CD1606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f2cVcbdD
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b4c8b51b58so3523223b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 08:21:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795623685; cv=none;
        d=google.com; s=arc-20260327;
        b=OEnt6w8Fsc21zNyFTi4TwjscvmFsbO74UQKGoigXQUU17P3p0XJfxMcbCM0JrzSJRo
         dBNBxAl0zq7a1PkHVKfiIqDJb/3DzcqkDFnLevMf/6/n8hxgSaKa6qih3teHV49buvuB
         khpmgbMz0hN/uY3bXfRXxTxaQfULLpWEQF11A/6HjxzRjTZEEh1WvoAAxAf8by6ofVrr
         Yl3oOaP1SPftZE8+ESHHH+qHxD6Zp84VVOBvciZprqTsJ+zgYQAKKhmT8SUB0tW2t20f
         As5STHqCBRCsJWr9o2siLxxF9SHFu8Lgba0I0OLJX3kel2l4hFnAkQ+fwjELm221mMlU
         uxbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jL/0Bwl1ePYdGwOEmrzwhpq81wxXh5l9YreMntjOUuk=;
        fh=OVH6oM31OdcQX0e5KDMWJyrXAed70Uq776guzxO/3t0=;
        b=mx5ejuR8TiIyDxsP7eyqLOaB/7AY7Izs9U/WxpUhd127qmiTxpk6gX/I2alfg50KRy
         W1wilMdy4TfTrEl2nTw1jEhNBh1zgka7QjUNqoCd5YENO1nQCud3W9buy26OWI+hsPE4
         ixbFxc+DiRtRFlMDNNylFBdUN1Y+um1fdIFzIMb2w7hy0VmhIKaYOEiDfpx0XxXVRGRT
         em/B3wq3Rx2sgIBKp0wdwwi65TCh1gdCGS0jbI5477veO4jiWU0VvKCONaEpDPTHangJ
         smhh8STp39GS/psioAGlCHvoeNoDzI3Cb3tVseT5GzzPt9uO5IZV2KZNBOFOoOKXLOlC
         2Scg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795623685; x=1796228485; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jL/0Bwl1ePYdGwOEmrzwhpq81wxXh5l9YreMntjOUuk=;
        b=f2cVcbdDMZEBlcPjE5sRYlQQrXQH5IkfJ0JumUh5DhLd02TOS7lHGh7klAYhjSYHJl
         otaDveuL5cU+KMtGh+/+Bf6IY3zU3eXioGymzHuyHTjcyUT2SF3oTWyNxee8v1lSPCGK
         HstZRfacXh1mMm+8rKcVE231hanIhmXe3FvDJHOqbWwkuHeRvPbCm1qgjOLWCJtQ38kn
         bMc3NRN1ioMI0hqEgSr/o5QHa6UBv97kUp8sZ7gWB2u8+aZ8seA4hYYQij2Q/FFRiYwf
         Edpov13WE1eSNLJWBHQB/5pSVTJo174EZy+4jn3K2DLw2NuFmqBAbPvySesrdinDhSHX
         n/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795623685; x=1796228485;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jL/0Bwl1ePYdGwOEmrzwhpq81wxXh5l9YreMntjOUuk=;
        b=LEgp/7pl5bzRMZ1DvCMGcOY58dbWrlv1+A1L5WbstliD1Mdmsd35w2AQ/LiDnLt1i6
         eBM/RbQtUwke/pBjC+6cZhn1b0PMDO1OX/1nS/CRHRYbkke1d0of+u7s9jsp7AxIQjkY
         PUbfTnjBgturuUmXS5kVH3vDTexXgMrNMyLa/lil4Bmehp5Zhg7KZc9Nz9+V4SReHsUr
         fIU0VgA0MbFOl7WvlFdDUsgrpeSsQKCewRc9IWQCYB8FetlmtIc3c/sepRaB9maSBRJa
         +mskHA+n6uyLKWcNC3WkqzKxY+aPL2pkNVgCUaqMC6pD+u9lqILEi9H0CHGe9ohXcEeG
         O7jw==
X-Forwarded-Encrypted: i=1; AL+hErEgan9ce7SsoabsbbrFEQsRQoyQbYvPgNwQ1VkhXv3FAsKuZU/NaA8GsqK8RoebuvrqNLy+wf5PieBf@vger.kernel.org
X-Gm-Message-State: APuU4Z/moHOkCXpBu/8EIoG8gBVz5oamzg096GmODv/ouYkWp+lUV29S
	YWriKFT9b5K12b7qKQtdUolLoMaKlAYpCvzRZeYgeTXLLkMuIimv3B0WeQIr3ER3nJQorQxBueh
	S9ibibtCmB3ILa2YBgmZb9zVMNweFToM=
X-Gm-Gg: AZFdTZe8riz4t8qdvmRtCjbYPKeh/yWx1jq6a4BCGjJSutkb7DMFeTKOiB8sRlkk/2w
	XlLxlqMTjrntpiAX+51KSmTXAsoBSt54WPK8FUPiSbxQ6GFVKY1pWfC2nPEE6aVtCtaWWkJlz4c
	m6VuhAK7nxIcZ82LPOu5oW6Isx0EJjoxwZZrX+7df57GU5qxpzSKXYYLEsBvcGzkgUCU0G52SYQ
	CnG5MtbZc6YW9agFPJ0QjZeWVieKgqsUIjs8dkIy8HXJwHb3UwCZXnz5NHbIn/825xGxwafWnJH
	TWiIFt1kIS1625d48Sc+4GxQNmrK/Dqhm9WR9jNOwSCLFtaALGsBrWL29e41P8Fec3vKFUWmqPv
	cYcSuNrPuRKkh0VVn6sBxKzT3YVLsSiifo1iUghF1Pnwm92HBpKuUV7LoDpxzj/JHmwCAlfuWeS
	3vW1Gd5u+uNUXyX544vTaXtorA2TcTPQLWL90aZlwkAWqP32Zy6GJ1Ic1GyWWdzX8V+gHD
X-Received: by 2002:a05:6a00:2185:b0:8b5:8fcd:a5d6 with SMTP id
 d2e1a72fcca58-8c87ca51d89mr16484911b3a.41.1795623685392; Wed, 25 Nov 2026
 08:21:25 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <b69a2cad6c2faeab9ee1e90ad11c4b64168c8235.1795393691.git.lucien.xin@gmail.com>
 <179548327865.3135.16261562840994895440@kernel.org>
In-Reply-To: <179548327865.3135.16261562840994895440@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 25 Nov 2026 11:21:13 -0500
X-Gm-Features: Aa3M54rsWzghsJWI76cZEUFf_JplE3C1oHkXrqs2BiFz_WXGdtzu3O8u2H29aYA
Message-ID: <CADvbK_fRG1sXR97cXfMMMG30RyM+-vyHMamOje5oxUO6=UEnpw@mail.gmail.com>
Subject: Re: [PATCH net-next v19 09/15] quic: add congestion control
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com, 
	dreibh@simula.no, jamie.bainbridge@gmail.com, linux-cifs@vger.kernel.org, 
	pc@manguebit.org, linkinjeon@kernel.org, tom@talpey.com, 
	kernel-tls-handshake@lists.linux.dev, cel@kernel.org, jlayton@kernel.org, 
	steved@redhat.com, hare@suse.de, aahringo@redhat.com, dhowells@redhat.com, 
	matttbe@kernel.org, mail@johnericson.me, xiyou.wangcong@gmail.com, 
	alibuda@linux.alibaba.com, jbaron@akamai.com, illiliti@protonmail.com, 
	sd@queasysnail.net, marcelo.leitner@gmail.com, daniel@haxx.se, 
	andrew.gospodarek@broadcom.com, mef@scarletmail.rutgers.edu, paul@jakma.org, 
	kuniyu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 8:21=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] quic_cong_rtt_update() in net/quic/cong.c begins with `if
>   (ack_delay > cong->max_ack_delay * 2) return;`.
>
> --
>
> quic: add congestion control
>
> This patch adds struct quic_cong for RTT measurement and congestion
> control, along with struct quic_cong_ops for congestion control
> algorithms. It implements a slow start, congestion avoidance and
> recovery state machine, and currently provides New Reno only.
>
> > diff --git a/net/quic/cong.c b/net/quic/cong.c
> > new file mode 100644
> > index 0000000000000..99fe8045d0170
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
> > +     u64 raw_rtt;
> > +
> > +     /* Ignore RTT sample if ACK delay is suspiciously large. */
> > +     if (ack_delay > cong->max_ack_delay * 2)
> > +             return;
>
> [Severity: Medium]
> Should this early return be here? When it fires, quic_cong_rtt_update()
> skips every update. latest_rtt, min_rtt/min_rtt_valid, smoothed_rtt,
> rttvar and first_rtt_time stay as they are, and quic_cong_pto_update()
> is never called.
>
> RFC 9002 section 5.1 generates an RTT sample whenever the largest
> acknowledged packet is newly acked and at least one newly acked packet
> was ack-eliciting. It has no rule for rejecting a sample because of its
> ack_delay.
>
> RFC 9002 section 5.3 also says the endpoint SHOULD ignore the peer's
> max_ack_delay until the handshake is confirmed. During the handshake,
> peers can legitimately report delays larger than max_ack_delay (RFC 9000
> sections 13.2.1 and 13.2.5). One example is a peer that buffers
> undecryptable packets until keys arrive.
>
> The changelog says callers will cap ack_delay to max_ack_delay after
> handshake confirmation. If so, this check can only fire before
> confirmation, which is the phase where the RFC says to ignore
> max_ack_delay.
>
> With the default from quic_cong_init():
>
>         cong->max_ack_delay =3D QUIC_DEF_ACK_DELAY;
>
> any handshake-phase sample with ack_delay above 50ms would be dropped. A
> peer that advertises max_ack_delay of 0, which is a legal value, would
> cause every pre-confirmation sample with a non-zero ack_delay to be
> dropped.
>
> In that case smoothed_rtt and rttvar would stay at the QUIC_RTT_INIT
> values set by quic_cong_set_srtt(), so pto and loss_delay would not match
> the real path. first_rtt_time would also stay 0. That keeps
> quic_cong_on_packet_lost() from ever setting pc_start_time.
>
> The RFC already handles a large ack_delay safely further down in this
> function:
>
> > +     adjusted_rtt =3D cong->latest_rtt;
> > +     if (cong->latest_rtt >=3D cong->min_rtt + ack_delay)
> > +             adjusted_rtt =3D cong->latest_rtt - ack_delay;
>
> Is the drop-the-sample heuristic needed on top of this?
>
> The commit message describes quic_cong_rtt_update() as "Performs RTT
> measurement" and does not mention this deviation from RFC 9002.
>
> This patch has no caller of quic_cong_rtt_update(), so whether this
> triggers depends on the ACK processing code in the later patchset.
>
False.

This is a defense-in-depth sanity check for pre-handshake RTT samples.
Post-handshake it's unreachable because the caller already clamps
ack_delay. During the handshake, samples with large ack_delay reflect
peer-side key-derivation buffering, not network RTT =E2=80=94 using them wo=
uld
inflate SRTT and delay loss detection. The max_ack_delay =3D 0 concern
doesn't apply in practice: the default QUIC_DEF_ACK_DELAY is active during
the handshake, before the peer's transport parameter is applied. The 2x
threshold is intentionally generous to pass normal samples while catching
outliers.

> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1795393690.git.lucien.xin%40gmail.com
