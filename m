Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B14189BB6
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770318046; cv=pass; b=cteXvSUed+7IjlVa2no17SIymqLgVG6kI2roDiMmMxoTv3m28J0HK4VSZ12bvqqSqu+yoU2B2Y74qf9PfS+eHCd/zAyOgIuT/c2Uht1Tcm7YhMxgG0QMbOVAHoahTBHoQfWVI2c6qL3/m3XoV3poO6MU05FPzTRG3tn9qPLPEX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770318046; c=relaxed/simple;
	bh=AuskjtNOz6nZ0G+yrh6WViA45fpVm0rg4c0PZaDjONg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hK/1VhHLHvOvJ3xrNyZL+tc2GXX3jIWGJJ8DMwcGJmTolONSgzG/JYXb84hOJtfu76a58L2FIE2Tpy0rw4WzS+wRTTsAaUd5sj4PUGGGamx6G7AC62DAU0VhPe6JGWWTrM07vq8Xeh7xGfu/p2RSVpJK6TscaCy0gD3JALrNdyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gT/8/tKO; arc=pass smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gT/8/tKO"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8231061d234so1366514b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 05 Feb 2026 11:00:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770318046; cv=none;
        d=google.com; s=arc-20240605;
        b=XeS+a7+Ra8zQEUR9LiohkrZg29cLv2OuYG+IZgfLn83PAmCTpFnImkxl15KhXC3ffg
         1T/OVwc4gVzMr6zdwmLZNH48azzfDCXHvYPohBpsHDvO5xXq8p32BD8nmKgPo9pj4ivg
         CCa7afE3elIuAVRWhYrUgRq1Ql9khK4INYGeZXEl3K0bX650Yzf5cApNehrCx8OfNCfi
         jqf0JIK/zDP8Ea471H7AfwXwpJXKrfrliQLijLAn1WxZzZiQYBSdw/at+Dkku3wwqH18
         8LZ9yvD9HooBw3ThtDVeHf+dn16XaLU5w1Hk5ZYHo4EmrfNRH7fGy/+OyeUhIH94o1fC
         nfYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CzWk8gLvE9O246b4A2vdYNLzmmHIUhQKe38cf0ISaC8=;
        fh=KGNbeZAC5ibLadBTROHo1ASE9gk6psX+1sMHH4IER7o=;
        b=HrzxivFKvA9WCXPX69s+nOzbCi7IiaLC6UguIR6MDEahVwD9lwoadtRijguEl3MP0L
         x0VdhsrsLN+v2FWL14h2bJqKNwn3GCKb31uacj3Iwy2HBgdSrFMihVC37byJw0/Nk2wT
         DUt2YHCNeNpcKNy3iGJaYX9Hc4QNWwk1RsaWvQzz7JU4n1UnJkdB1Qa0A9wF2Y1+rZrB
         LEBnyy7tY2ZL3Ym7EzihyE1SCoHVdcCG/k2wwJdy1Iho+rp73a8tj9FTI20V4OalRTEt
         KknhBt3kXuQ186XtBoIdJ4QrFMGVEjwD7+USpNjpn+TgXatXhaLmTdPKaglEcq7YBb35
         CkpQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770318046; x=1770922846; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CzWk8gLvE9O246b4A2vdYNLzmmHIUhQKe38cf0ISaC8=;
        b=gT/8/tKOSOVMsz6n9OZMC2rrdO2BqPLRFDyZZsc+jFnSA0y3QlfPHWb0oIkvwU6G2k
         RNdfQ5Bigi6EEHo6VJNrgcT2ozHzbjniFWs+rv4e4PvyMCSPiFO61CAivsSaMEdKonOv
         PE9hnuU8lVqj4gBxcMg9vRTLp4Be2GiKJA32EENTQy9YlY8qVqb4gHc6Nsh7ETZ0uJ51
         JNT5ArXbNkdIBMRUK9kdPyw3daY/upi5v0gEt/DIdyMgYgkG3ZDIT755YPUn3Qc605w3
         54+hDQ2yta2BUNYaH53PT9wGspIGGqiUQp4eCaoanQN9+bcovFzg8Uc0r/1hSBaq7MJg
         a9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770318046; x=1770922846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CzWk8gLvE9O246b4A2vdYNLzmmHIUhQKe38cf0ISaC8=;
        b=hzdloUMh+puLW+JtN+GaBbNScFMPaIeae9ljmLF4RSZj/cPiy60BPsJmx84xxUzFZt
         kvqYN1sC0rsmW8Q0dI50xbREW1WZMdqFHoquZP6CBcfKiwEN8nsMN/V9hHHR1cjP1T+Y
         PLu2YhlBB8o/0Y4ehuGHpdZjgTYPgz043hUjP//gU6O719BjSuXr1fCFIa5lAc7Vx+sK
         g3pEFbAE4vSE+K48OECWcq/BcnGq+elN9XrTKPtKO5CTTzg9/CcW6fEI8eVG1ymBCh56
         vVZj7JkZDwNGjHCUTICVdenPyNv1er+LyM+Jr/B1w/n08aBHWFgZneEb0Ykhx5od5sJn
         DBCw==
X-Forwarded-Encrypted: i=1; AJvYcCVdHGEeLjoaavY98X5TnzSliZ2ptVX2RvdbMsDS5eTZzaFk591R7wrFduTLyXrhvGWjarJQTAPfaCLi@vger.kernel.org
X-Gm-Message-State: AOJu0YyT5OBfU1svVaSKb4sHngX+ZWgjx8ont8ngymLy6TWCbL9KqYED
	axBzYB4WxYiHnoPU7ug3nnr6oQy8x/+ib5J+PL/Lz16SOc8fsE7x3Z3nZkmm4KsQMOXS1w9bsos
	G9JsBWSIGhHmEKcbn2iRxmVnArcWx6qk=
X-Gm-Gg: AZuq6aJ9LgvZQVKsdS0VtnyG8IbR8oAWQ8l06Mihe442P9Lrf2+LBgLRSErH/AVmK1J
	5hRK8A9EDsc2PUIivEcbQuoJ+gb45FCSt7AEPwfSfx3hX5akdFmHq90OMGNYFqLWeJNNYocpjKB
	KbMv3q4GtzXwNw3p4kQWO3L2YSvBe1Afgv8STeojqvvBUEGye+7/85KxgxP6HIIzh3BfQOroc4h
	8Ug/YPyRYqYRpbXGQPDKEVNw1Ok0ep1dEqGjPr/DkCSKuSDciKlLuuHj5qYGJCTTf6/49HxORST
	R34ot3QSyRE8SLGawzTE6dYDBmz9
X-Received: by 2002:a05:6a00:2e07:b0:81e:711d:b26f with SMTP id
 d2e1a72fcca58-824416f7a4bmr51256b3a.43.1770318045758; Thu, 05 Feb 2026
 11:00:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a872188a6e4d7b39d6d6d0f6fad7e5077bce4bae.1770042461.git.lucien.xin@gmail.com>
 <20260205115532.2195345-1-horms@kernel.org>
In-Reply-To: <20260205115532.2195345-1-horms@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 5 Feb 2026 14:00:34 -0500
X-Gm-Features: AZwV_QhKP_xJtDWc386RLFvCIecEAqeBpy1wdehizIZr3NTnLt_Pak2USLctFus
Message-ID: <CADvbK_cHtubdKv4PbYf0vG=3EPMrYw_Jo=_qqNvVb6+SoDvB3w@mail.gmail.com>
Subject: Re: [net-next,v9,09/15] quic: add congestion control
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
> quic: add congestion control
>
> This patch introduces quic_cong for RTT measurement and congestion contro=
l,
> implementing a state machine with slow start, congestion avoidance, and
> recovery phases using the New Reno algorithm.
>
> > diff --git a/net/quic/cong.c b/net/quic/cong.c
> > --- /dev/null
> > +++ b/net/quic/cong.c
>
> [ ... ]
>
> > +static int quic_cong_check_persistent_congestion(struct quic_cong *con=
g, u64 time)
> > +{
> > +     u32 ssthresh;
> > +
> > +     /* rfc9002#section-7.6.1:
> > +      *   (smoothed_rtt + max(4*rttvar, kGranularity) + max_ack_delay)=
 *
> > +      *      kPersistentCongestionThreshold
> > +      */
> > +     ssthresh =3D cong->smoothed_rtt + max(4 * cong->rttvar, QUIC_KGRA=
NULARITY);
> > +     ssthresh =3D (ssthresh + cong->max_ack_delay) * QUIC_KPERSISTENT_=
CONGESTION_THRESHOLD;
> > +     if (cong->time - time <=3D ssthresh)
> > +             return 0;
>
> [ ... ]
>
> > +/* rfc9002#section-5: Estimating the Round-Trip Time */
> > +void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_de=
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
>
> The field cong->time is described as "Cached current timestamp" in struct
> quic_cong, but where is it written? The socket struct is zero-initialized=
,
> so cong->time will always be 0.
>
> When computing RTT with a positive packet send timestamp in the time
> parameter, does this cause unsigned integer underflow? For example, if th=
e
> packet was sent at time 12345, computing 0 - 12345 wraps to a very large
> value.
>
> The same issue appears in quic_cong_check_persistent_congestion() where
> cong->time - time is compared against ssthresh, and in quic_reno_on_packe=
t_lost()
> and quic_reno_on_process_ecn() where recovery_time is set to cong->time.
This is not a problem, cong->time will always be set before processing
the packet on the TX path in the next patch series.

Thanks.
