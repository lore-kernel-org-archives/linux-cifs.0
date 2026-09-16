Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBDF4D795C
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 15:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789573745; cv=pass; b=innrfUFEnVNXVn1ITzKFOMTekQ9aGfA3cIDAcCJXA+7pyoGqwH1gp70SbCiMYf0b/1qqMk2Nqx3ZlyPKQMHivNdJ1cgrKEJ6rp57Riv+zFQL1XV2SZiUjYN231iFbtFRctkCZSZf1V5g5pTiwbLAkzrFNSh85Kl/4UNT0OewioY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789573745; c=relaxed/simple;
	bh=2HTFcw51GJTpM0vzPofi6oeFOtDofXyLi0if3h9f4Tg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B1tTIw0joXrOp68QjuYP7u3mCSaXeLS/kFp4YvqW9hjj6xd4SEeX+6iK/0BVcCRy+AMimZgkQMnHMLNMWb1c2I47Wsypva873yWK9pBShGESiAK+/zFO3FAzjbCXiwofY42Bf3HYOrrteIzNVGrqd07M12lD8XZbH+PmrCz1aF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FamlximZ; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FamlximZ"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-86212a185dcso1019346b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 08:49:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789573741; cv=none;
        d=google.com; s=arc-20260327;
        b=LtgMrcC5XeuQTsIwF2+k8GRfVGWZxqkgiDLmy9B5MnAjmA3SCvxsQMv+NH1ee6wXxb
         MTeBB+zNnt942DlMRmQCpA4ywb3RMzy5E7AsrgzdLucxkHoTeeApLw93e/6DJz4xbmCb
         Rn3/MG/30rOUowxpUXa/8/XgbzLyOAXzR/zgwVf7lILNmzDRSo+5flOhQrz88E4MA7HP
         jj4IFh8noDhaxiNeAHUaw7OOy4/Fw1cw1rjxchRgJ6ujnbYAglOzV+9olZX/TXRcd7GX
         YMGh/pYFfUXjwGoSi0P2/XV32LVhnKG+OqMok2B+/fj8FdXj9urUZkmNGwBMNs1iJGSz
         xaow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9gmxz7ND3t4uc8MZW2dQN60LpvsltqXz4L3oWlJ7Ftw=;
        fh=m6f8rUFyvB4AyHYRNrn1ZrEGKofu6FDXFa0DjYMqMtA=;
        b=NGnz8oXxcYPjDF8lqIvzxf3YM33gCGJCWDMZZqhrP9/ROu25i5KbNNDkg5P0z5+e/v
         zZXTuJWg8EWgbDQGSJkX2udQqFse8uLGGcTOguPczhEZAFpp3lPQHKmrIQ7Wc9FOmP8W
         CI4WZ62LVxPHF1+dkMvp34eMleaI6wcemJbSXe+nFm+KLjr3kevx7UXnIvE+TOTOOZU0
         NEb70wAIk5NhYvCPtY0/rMQGLn2KL8JaZGtXcZPhUPbBktX6Dxono2qV8jE7D/ueH2h0
         XXufSLN46jsQIrBE9V61LjjWAWUbPwzmAj8fZWy632kZm5b3vxBOJGWYnkp/zqmWX2sA
         KxMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789573741; x=1790178541; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9gmxz7ND3t4uc8MZW2dQN60LpvsltqXz4L3oWlJ7Ftw=;
        b=FamlximZGdrzR+/F3Zu1GMSPUjJmbhB7nInxQ6RRRBCiKHc3C3r1ozqMW3qpU0ev5q
         9dtThWRhvmQnPu3BMXzCY9mC5H3DbsMxi51uji3OnH+pirxFnBG0JpWvppxsTm23us9t
         snIvLRQ0gx5T1M8BtT881KF18MEb2sfwP/iW23oTYMoEuRoln+FZxmVpczBUEAiuFbvt
         VgHkPECX7U8hxJwGRGbJHYcAVnxhJpsY/Oos30QCOo3/qURGaOnotK59q0YxhuCCqUUK
         N8FNqUhIEKW4N/dXriY4+uMffMUeWiFobn5rXpV3GI+41LfJ518PvvSzsdMbaD1ziAwO
         OiDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789573741; x=1790178541;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9gmxz7ND3t4uc8MZW2dQN60LpvsltqXz4L3oWlJ7Ftw=;
        b=fhR61klKtqb8baG2wn16i1IMsCxFCNAyWQivyuX/AlWSuQLjT3Gegux7ISbqK5DWvY
         PjSqC3ydITkZHsLwwWJibCAvaTS1jHT4cPZKLz/mLr62slROgh9F5H7TdFENf9B4IxTj
         TvbzWBy5eXdu/W4N1s6weOzL3BpoYbnHJSIFPLJiD3++nqk8yGsMqkJcgXvC6vncQiyJ
         nQ/7ySU/crVzC9eN4d2Per+QPvXAIc+MMIqXphmPw1AexwPR/g/lq0RY4N6pjMJJyYbn
         lEBmFfV0hwq9wkWQRuEdmsGIxBtpo9m9nLGfGVTplHOUdXut9H3wMitqsHObjACwrDGC
         LbBw==
X-Forwarded-Encrypted: i=1; AKwUvBxKBSPxwQdxcLDHu5xJnV9+tMveqeG65J9yuNxu4BD+VAwofgaf4Hy3SqmsA4za+CHNw/smYBiM+mQD@vger.kernel.org
X-Gm-Message-State: AFuF++k/eOyngCjCKdCB2UIqXqqALgc9FH0siPFqv8PYTvkw0VHRb25T
	0lUxqFePcj/R+bjk8dWgAqCBbyxaPMRm1h/hP2vsbebkjFFhyGbancQhRGBcowV1nsOIjV/owA4
	qlJNl0A9EkTusFnU1TadtGVO66pZySuA=
X-Gm-Gg: AYBFou35XZmplOuGFpHZJeeTlt9C3HpGDSfXsJCcn1J/osr2EcrqmFDkaJ+tSxmoHWl
	5uDtHBee7+cVnwOfQD/SidozHIGWpe2ZyeCp6l8A+JJraGRnL5b83LSviCMnvZ9Jmthy77gYMQ/
	HGDCPCfQ2he+lN7c7YXPwIVzcLjkyCz/a5qlMV1thNPHx/IqGxdIeO0XLwTGRlGpW0sP2Rhf+z/
	6I8xKtN6AjH9yEUwn697wSsI96ifKmiKkGxXzI7GuzGxT1o4iTZ6foa2om7DcylIEOUR0qNkrY9
	roOYDpKCVx7r8Sy4lVxpOMietoPHwxr9iUJeR6EhayBmiQ7GhjFjEW2ChBstFNKs5+MkbLH/AaK
	J+lqfbgIfTgyDJSj7RxVmdRIKqj6StlhyT6RLi+Ji+3Ug1bjcHGyETyQA
X-Received: by 2002:a05:6a00:a88e:b0:872:20f2:3282 with SMTP id
 d2e1a72fcca58-8723de188d4mr6336975b3a.22.1789573740955; Wed, 16 Sep 2026
 08:49:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ede5ba63212b87ddfa14acf70426b81d87501e44.1789393775.git.lucien.xin@gmail.com>
 <178950184662.22033.5889968066649167674@kernel.org>
In-Reply-To: <178950184662.22033.5889968066649167674@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 16 Sep 2026 11:48:49 -0400
X-Gm-Features: AcwNN1Xi8cSlHvt5PrpP04qaA_yB_ZBp9zlIFRWFrwm51DDVLQoanNnzmXwbS2M
Message-ID: <CADvbK_eU+ozoWVcCWEhKuyeBK_c78Eqp-OTKQHqUBTu8hwq+hg@mail.gmail.com>
Subject: Re: [PATCH net-next v15 09/15] quic: add congestion control
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
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 3:50=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider:
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 1
>
> - [Medium] Spurious persistent-congestion detection:
>   quic_cong_on_packet_lost() (net/quic/cong.c:125-140) is the ONLY place=
=E2=80=A6
> - [Low] Commit message vs. what the patch actually enables: the message
>   says the implementation 'adjusts the congestion window accordingly=E2=
=80=A6
>
> --
>
> quic: add congestion control
>
> This adds net/quic/cong.c and net/quic/cong.h with RTT estimation, a
> congestion control state machine (slow start, recovery, congestion
> avoidance), pacing helpers and the New Reno algorithm behind a
> quic_cong_ops indirection.  quic_init_sock() now calls quic_cong_init().
>
> A couple of questions below.
>
> > This patch introduces 'quic_cong' for RTT measurement and congestion
> > control. The 'quic_cong_ops' is added to define the congestion
> > control algorithm.
> [ ... ]
> > +static bool quic_cong_check_persistent_congestion(struct quic_cong *co=
ng,
> > +                                               u64 time)
> > +{
> > +     u32 ssthresh;
> > +
> > +     time -=3D cong->pc_start_time;
> > +
> > +     /* rfc9002#section-7.6.1:
> > +      *   (smoothed_rtt + max(4*rttvar, kGranularity) + max_ack_delay)=
 *
> > +      *      kPersistentCongestionThreshold
> > +      */
> > +     ssthresh =3D cong->smoothed_rtt +
> > +                max(4 * cong->rttvar, QUIC_KGRANULARITY);
> > +     ssthresh =3D (ssthresh + cong->max_ack_delay) *
> > +                QUIC_KPERSISTENT_CONGESTION_THRESHOLD;
> > +
> > +     return time > ssthresh;
> > +}
> > +
> > +/* COMMON APIs */
> > +void quic_cong_on_packet_lost(struct quic_cong *cong, u64 time, u32 by=
tes,
> > +                           s64 number)
> > +{
> > +     if (cong->pc_start_time && time > cong->pc_start_time &&
> > +         quic_cong_check_persistent_congestion(cong, time)) {
> > +             cong->pc_start_time =3D 0;
> > +             cong->min_rtt_valid =3D 0;
> > +             cong->window =3D cong->min_window;
> > +             cong->state =3D QUIC_CONG_SLOW_START;
> > +             return;
> > +     }
> > +
> > +     if (!cong->pc_start_time && cong->is_rtt_set)
> > +             cong->pc_start_time =3D time;
>                 ^^^^
>
> [Severity: Medium]
> Can persistent congestion be declared here even though a packet sent
> inside the interval was acknowledged?
>
> quic_cong_on_packet_lost() is the only place that establishes
> cong->pc_start_time, and quic_cong_on_packet_acked() can only clear an
> interval that already exists, so an acknowledgment processed before the
> first loss callback leaves no state behind.
>
> With srtt =3D 100ms the duration threshold is roughly 400ms.  Consider
> packet A sent at t=3D0, B sent at t=3D100ms, C sent at t=3D500ms, and B
> acknowledged first (ACK processing precedes loss detection):
>
> quic_cong_on_packet_acked(time=3D100ms)
>         /* pc_start_time =3D=3D 0, so this guard is false */
>         if (cong->pc_start_time && time > cong->pc_start_time &&
>             !quic_cong_check_persistent_congestion(cong, time))
>                 cong->pc_start_time =3D 0;
>
> quic_cong_on_packet_lost(time=3D0ms)      /* A declared lost */
>         if (!cong->pc_start_time && cong->is_rtt_set)
>                 cong->pc_start_time =3D time;     /* pc_start_time =3D 0m=
s */
>
> quic_cong_on_packet_lost(time=3D500ms)    /* C declared lost */
>         /* 500ms - 0ms > 400ms */
>         quic_cong_check_persistent_congestion() =3D=3D true
>                 cong->window =3D cong->min_window;
>                 cong->state =3D QUIC_CONG_SLOW_START;
>                 cong->min_rtt_valid =3D 0;
>
> B was sent at 100ms, i.e. between the send times of A and C, and it was
> acknowledged, which rfc9002#section-7.6.2 says should disqualify the
> interval.  Since neither the acknowledgment timestamp nor the packet
> number is retained (the number argument is unused in both callbacks), is
> there a way to reject this interval, for example by recording the send
> time or packet number of the most recently acknowledged packet?
>
False:

The above case relies on packet A having a send time of 0, but packet send
times come from quic_ktime_get_us(), which cannot return 0 in practice on a
running system.

Thanks.
