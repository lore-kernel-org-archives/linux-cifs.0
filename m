Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E009C2DD5F6
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 01:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791510188; cv=pass; b=MqF/1RJa4RgqVP9nvCytBQPcpbHCYeZufj2bjKOVGwXQQftrDXbFrWAOZ4Vh/dnQdPxvabw+lvQXW7OtILI2fLV2DhhFgQ0Aww2J+ec819WTFBHU2jETCY5ULGdBLAvopsdzFMx1d5cLcMI36qdWbh3NQzj5maD+MJ69Op4rJ58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791510188; c=relaxed/simple;
	bh=n8YcwL7I6ncHN6Di+TjkLj9HcqFEku0JBz9C1UzgFh8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dplxkxh7yxxSA84qZBJrptGRh/bVQ0Fv0hoGepN6Ek0QstCfuIbtv/1OuYXSeTogoHq/DTui8dCM6Pr9z3DaZlAFc4OkDOtvq3BTmhZpB4JCWETHM5YSnWvxu7yY7eAUEddOLgJBgpCzn6SWNXH+KyMYr+3aVAe1+PR+G31L8pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dQo5ywy2; arc=pass smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dQo5ywy2"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc1cb472b76so1671574a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2026 18:43:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791510185; cv=none;
        d=google.com; s=arc-20260327;
        b=IU2nrX+wFW1pDnXdbuEDvjGPWN55TQfZHmZnk8VrEpZeGl0SzGsIP1QnsW4lrnCxfP
         MSpLEDBkgumLp1X8vBTdqgoPFoRxPwH2vpRG9XtP2T+qU2LTzsU7dendlcb2pJri51IB
         BrtnrS8j3ql9zOn24ui3pcQjRrYxIrFGnq68gM8jvaq0676dOD6/5QWJN6YFss/szUeQ
         1RGsdmiY22vJYaDMxRI2gViL8uaBrhm+uW1ks2hpE0GXAktAcvb5c/EbTh/36woYkRao
         rpHY2SgkVxPNIus7wL5+hNiqSzXbygbW35S0mJGBWo0ajv6DMU6W8lD608xmStblhzRx
         fDrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nvNO4+uRT42xaw6c57vhH/gJBgCPU/zxf+gr5Cfeshg=;
        fh=DRLHWYRKooPw3yCflwJSj1lveV+0Lr9mhWBV42ih58M=;
        b=CHo0z+FMiGiaJfEQYtk8gR8Gs4suxKdEtvyBRd0XHqPb9HkUYBu78r5/zR7Uq3tphP
         42uJPd2gZqaCSUj95D8ULzAeHYQa/yzNQRn6OiGzfm+HQW7mO/x6ABtyr9jymWisO9kW
         mpB+LCmLrim6kK4NssqBjs3pl7UZU3j6uIHh7BNpmHFghVEXDxvVN+j9GcLRIBZi+i/I
         V/Ab2K8YB+KB5GfKCYcbiLENOB5Ol4tTBfbnRUGzXIWZKztMa6e+tD1Ov4JBMq9dVzUj
         XiZuai/s1y0o3kGaDsVClDRjMJ5x00u3KlPVx3oxgWuMAuICWiKqZO1UVMMdblu6iJrR
         lrjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791510185; x=1792114985; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nvNO4+uRT42xaw6c57vhH/gJBgCPU/zxf+gr5Cfeshg=;
        b=dQo5ywy21i/At4hQMF37VWpi03lvu3GNJ0j2LYtt7liPTumA3n2u06dukLRNWTc1tX
         LJGaTB54UI/YvfHxdeWz0XcrKmPTPd9wi9JZdRfAdq94tayyQnlc7++cVdoTV8f22STR
         J9Rrdmuikcw2bnwZlQYB9SUzEmpoMHnv+vRD43yWW5c22xQB64BNPTvNwzauYN556aRt
         xiRHZ3y5a93vSPUchTqcGybbFjGsDRbq/ElEFpDasrmwlA5UIPVsqY661CSyZyUwpMMg
         1kgjyAhIDkW+6rJXBW21xTalGUKYdLpdFi4RDds4E3UptnCjjB57o6ixsqmTVhc6DSsT
         bozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791510185; x=1792114985;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nvNO4+uRT42xaw6c57vhH/gJBgCPU/zxf+gr5Cfeshg=;
        b=nufFbdZNvv+qc1vfqOSyGR74Omceh1ZEnLU76IBNVw646c/tIXS82SDM+VjPYH9b25
         AkHQlR5PrDvIXjfRRWNtCVHEY0EY6Ggn54ZYPrPM4sx1MeIt7Ezg5rj1R9T1S8pwLXv6
         F/wxgWR3HfNRjlJxHEA6vCZHC/Y/aB60OEdW2O1qNFQ4Efa8nm1rgz65Pn5U+xDGlI0R
         WVic8WMVvRQmHeQJJ1h5X26G12vyHeCz1wmcB5HnbbVklY8Rs/VufR/B8wmgaUBWLDjY
         8cZ+U9nhaXZ+a8HrGXupoNrNyMSg8bl1Q/KgTXTT4eT84Obba/nrZlCWiTUatDAPx09M
         pv3g==
X-Forwarded-Encrypted: i=1; AKwUvBzDpEN0NYyF875auL0YG7jwdQi99DERLCkjvZ7gNTZ59MTpWRiRlDFJTB4chZN9qgxhL7nglwqM8hv0@vger.kernel.org
X-Gm-Message-State: AFuF++nDgcwO9CjNsIPoW4RRLnwx+WX8cBrT6SijQM8LL/0sWIeVt0UO
	ttgGBjAsExo2J64jrI7PioKP73YECNJNbvXuHdXNLlNSK7iJIcgDIkwF3zchboou80pOErxmnYU
	edRmSsMbiH9u+aSwTtsBwNOS38momuW8=
X-Gm-Gg: AYBFou0FkYw4U/jOd0lG4FZfE55Sb1kOJNKocXFYqNYQSM7QKqZTA0tTf2I0oAs8+rW
	7dIr8bgqK9YPtAprrYOuct7p+zofh9bnuyJvKrRTBixbZCS0UaqDmsfSMLc8fAMdz9rWcyYYTv9
	YUY+Qf0Nfcl5QXrAu045pufZ0zDzGQNuIPurm55hxOJ8SrGLyL7ZOmCREE93Zd4ZYCdNF6KOAj3
	wsgetiS4sQXnHTk3vnBLeGyi5SM95QzpTqhFisl7Tl9KQLkx6Su+e/QZZe+ooeMtfrMhq6LdAEI
	47nLH19XqhebXF8joTMVgSu0xATNPksp8oYohMhaVf2SU76aP0HPUPXJquHCbeKhyEZUEqsXK4p
	JwWpjb22d79pQoGGCqbzUrsZs5mtPGwra8yMg923I6cJwWPZwJ1MosQZOagXFCPA=
X-Received: by 2002:a05:6a21:483:b0:3e0:da23:874e with SMTP id
 adf61e73a8af0-3e16bdae7acmr234756637.21.1791510185039; Thu, 08 Oct 2026
 18:43:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <04d71cfc6acd9df9eb52e4f998c35eee568c4319.1791227050.git.lucien.xin@gmail.com>
 <179133511607.434549.17774997950314089010@kernel.org>
In-Reply-To: <179133511607.434549.17774997950314089010@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 8 Oct 2026 21:42:53 -0400
X-Gm-Features: AclHuK8W1Wf3zRSa6LnwypKbXEMa4xVD7fPbE6nLopWcgl-4MV4wP3DczF0C_mI
Message-ID: <CADvbK_cYEE8nb3H8CB=sy_8HRmC+uxxFq+EC4bctyWQ+SnbOVQ@mail.gmail.com>
Subject: Re: [PATCH net-next v16 09/15] quic: add congestion control
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
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 2 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] quic_cong_on_packet_lost() (net/quic/cong.c) lets a packet
>   that was sent before the first RTT sample start the persistent-=E2=80=
=A6
> - [Medium] The New Reno handlers in net/quic/cong.c decide whether to
>   react to loss or ECN using only cong->state.
>
> --
>
> quic: add congestion control
>
> This patch adds struct quic_cong for RTT measurement and congestion
> control, and a quic_cong_ops interface for congestion control
> algorithms. It implements the RFC 9002 state machine (slow start,
> congestion avoidance, recovery) with New Reno as the only algorithm. It
> also adds persistent congestion detection and pacing.
>
> > diff --git a/net/quic/cong.c b/net/quic/cong.c
> > new file mode 100644
> > index 0000000000000..4779ffe90a3f2
> > --- /dev/null
> > +++ b/net/quic/cong.c
> > @@ -0,0 +1,319 @@
>
> [ ... ]
>
> > +/* NEW RENO APIs */
> > +static void quic_reno_handle_packet_lost(struct quic_cong *cong)
> > +{
> > +     switch (cong->state) {
> > +     case QUIC_CONG_SLOW_START:
> > +             pr_debug("%s: slow_start -> recovery, cwnd: %u, ssth: %u\=
n",
> > +                      __func__, cong->window, cong->ssthresh);
> > +             break;
> > +     case QUIC_CONG_RECOVERY_PERIOD:
> > +             return;
> > +     case QUIC_CONG_CONGESTION_AVOIDANCE:
>
> [ ... ]
>
> > +     cong->recovery_time =3D cong->time;
> > +     cong->state =3D QUIC_CONG_RECOVERY_PERIOD;
> > +     cong->ssthresh =3D max(cong->window >> 1U, cong->min_window);
> > +     cong->window =3D cong->ssthresh;
> > +}
> > +
> > +static void quic_reno_on_packet_lost(struct quic_cong *cong, u64 time,
> > +                                  u32 bytes, s64 number)
> > +{
> > +     quic_reno_handle_packet_lost(cong);
> > +}
>
> [Severity: Medium]
> Can one congestion event halve the window twice here?
> quic_reno_on_packet_lost() gets the lost packet's send time in time, but
> never uses it. quic_reno_handle_packet_lost() skips the reduction only
> when cong->state is QUIC_CONG_RECOVERY_PERIOD.
>
> In quic_reno_on_packet_acked(), the state leaves recovery as soon as one
> packet sent after recovery_time is acked:
>
>         case QUIC_CONG_RECOVERY_PERIOD:
>                 if (cong->recovery_time >=3D time)
>                         break;
>                 cong->state =3D QUIC_CONG_CONGESTION_AVOIDANCE;
>                 ...
>                 fallthrough;
>
> Here is one sequence:
>
>   - A loss at time T starts recovery.
>   - P20 was sent just before T and is lost in the network.
>   - An ACK of P21, sent after T, ends recovery.
>
> Later, P20 is declared lost, either by packet threshold on a later ACK
> or by the time-threshold loss timer. At that point the state is
> QUIC_CONG_CONGESTION_AVOIDANCE. A new recovery period starts and both
> ssthresh and window are halved again.
>
> In RFC 9002 Appendix B.6, OnCongestionEvent(sent_time) returns early
> when sent_time <=3D congestion_recovery_start_time. B.7 applies the same
> rule to ECN-CE.
>
> Should quic_reno_on_packet_lost() compare time against
> cong->recovery_time instead of relying only on cong->state?
> quic_reno_on_process_ecn() gets no send time at all, so this check can't
> be done there either.
>
> The ACK side has a similar gap. In B.5, acked packets sent before the
> recovery start don't grow cwnd. In QUIC_CONG_CONGESTION_AVOIDANCE,
> quic_reno_on_packet_acked() grows the window for every acked packet,
> whatever its send time.
>
True.

Will check quic_cong_in_recovery() before calling .on_process_ecn,
.on_packet_acked and .on_packet_lost.

I may also remove these cong->state switches to simplify the code.

> [ ... ]
>
> > +/* COMMON APIs */
> > +void quic_cong_on_packet_lost(struct quic_cong *cong, u64 time, u32 by=
tes,
> > +                           s64 number)
> > +{
> > +     if (cong->pc_detected)
> > +             return;
> > +
> > +     if (cong->pc_start_time && time > cong->pc_start_time &&
> > +         quic_cong_check_persistent_congestion(cong, time)) {
> > +             cong->pc_detected =3D 1;
> > +             cong->min_rtt_valid =3D 0;
> > +             cong->window =3D cong->min_window;
> > +             cong->state =3D QUIC_CONG_SLOW_START;
> > +             return;
> > +     }
> > +
> > +     if (!cong->pc_start_time && cong->is_rtt_set)
> > +             cong->pc_start_time =3D time;
>
> [Severity: Medium]
> Can a packet sent before the first RTT sample start the persistent
> congestion period here? time is the lost packet's send time. is_rtt_set
> shows the state when the loss is detected, not when the packet was sent.
>
> RFC 9002 section 7.6.2 says the persistent congestion period should not
> start until there is at least one RTT sample. Appendix B.8 only looks at
> lost packets with lost.time_sent > first_rtt_sample.
>
> struct quic_cong has no field for the time of the first RTT sample.
> quic_cong_rtt_update() sets cong->is_rtt_set =3D 1 but doesn't record
> when.
>
> Here is an example:
>
>   - A client sends Initial PN0 at T0.
>   - It sends a PTO probe PN1 at about T0 + 1s. The PTO from
>     QUIC_RTT_INIT is about 999ms.
>   - Both packets are lost.
>   - A later probe, PN2, is acked and gives a first RTT sample of 50ms.
>
> Loss detection on that ACK marks PN0 lost. is_rtt_set is now 1, so
> PN0's send time becomes pc_start_time.
>
> PN1 is then marked lost. The gap of about 1s is larger than
> (50 + max(4 * 25, 1) + 25) * 3 =3D 525ms. So the persistent congestion
> branch above runs, cwnd drops to 2 * mss, and min_rtt_valid is cleared,
> right after the handshake.
>
> Should quic_cong_rtt_update() record the time of the first RTT sample?
> quic_cong_on_packet_lost() could then use only lost packets sent after
> that time.
>
True.

Will replace is_rtt_set with first_rtt_time, and check it before recording
persistent_congestion.

Thanks.

> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1791227050.git.lucien.xin%40gmail.com
