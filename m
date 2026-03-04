Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B66376489
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 23:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772665410; cv=pass; b=KRye/Aj4Ibb5Eh3P8cod+ToenM1Y3GOHLYhTZ+sVKqsTdKnxz6xUpPgGfMbSWtb5ZfG96hVqseriVXyUI5InAqdr1UE/LkuaP4vY3upyTuBJZi6ioLKI/k4qQsfmVTmVhDuZ45z+a+7SkA2tY8JMZxvqTjt7V+PLsl+lgfxmuxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772665410; c=relaxed/simple;
	bh=2i+IHSwXdo2vJdP59dU99G2iRMYrlyhf0Di7pAHPdxk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OSy0Xbq0AkOT3SfweZl+Kk6p8izZXDr2HPU4OU3bUcdoQVQUS8MIg4pty7JiWticUN3x7lS8mesJ2mbDN7SNdOm3/qvcELyBffT8ljQyiLliSUfZQaIkbkcnSKeCrBIO5i2OyAXH+RBCBQBzcinfi+gH+VT33Y0ws5ebc+bdqyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cC7bgrvx; arc=pass smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cC7bgrvx"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-94de63dea9aso4673920241.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 15:03:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772665406; cv=none;
        d=google.com; s=arc-20240605;
        b=CqN9qxk4BK2ci8HhqBzXvs+2tQVwdDm6uejhTiyH0BcP2gmqRznkGoeLbqYaeycE2V
         5XcDIO/wbKg8T8SbPLP3MZlkI5TNVrxo5hMUKBDEBbyVMDYnS87k7orImXekUNWK9mZ7
         XxvUJuGXfVgxW/ShRzk70389pWtbEUfPh7L5Eibwc3KHYeu8GF2KvDENIh5sBrOso6O/
         1ed+Xyi5LHuBWiOU0Dm++MhECG6qo6wnDdjRxkOYLVOMVCo1RyGHXLSvjIKtQ+BDkcLu
         Mn9s1K7IGjTPlHjwX+sW53JEXNN+TNMFF1AiLczVA+CQ3oA2jx1vI1PvbxZeBN4Vgf0U
         H/kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ivkx6puhgdlm/jw1xcgfFyqPx3PkaCKD+eg0EyAqi2E=;
        fh=/n1D/0TxWjsHNTsAeHPAbQ0u5yQpvUegPNh737U7EhE=;
        b=kLVnU/5lNezd3aYq/4MOHD9zva8WnZl5z2n9PIpepOSB4PY+AAsoFDYHXmceIluL4E
         mvEgvuW6btZ06aC0Offz8TMDwclnY/Bbsm3HOlg60dvUD6DSPxc7QDe/zooQqBaNjW8O
         61L2V9kZMzwNSLkyI7QxcuGpVu6LKT4861Zbj2RRS3MiHK3YLEnM8VanYVLYzjZEMHUo
         4c7moOK8eChiY9/cOsnsJMrDEqpbrXeEiAsfn1DkvAwCkr3cGeKW+kCE7KQdzeycj24i
         KG+RMENMMWPrcrIWTZlbkmX3kRsPc1oMaw0K2jwhauvFmvWEv7ooyT2NFXKUcOan2QXg
         5rBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772665406; x=1773270206; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ivkx6puhgdlm/jw1xcgfFyqPx3PkaCKD+eg0EyAqi2E=;
        b=cC7bgrvxkIsXlGlwT6cNLnNmWRB8elw0aW5/2nK3ozQ/1QTqWz5fQ6Q9r4BaBwCoji
         trv6yvN8+je5RUmO4Iqxa5DsAZfnHovcxfHkeoOFOK/yVjVMZ1vZ3c8Qj09bhi7ycWk8
         Zua+We+8NS8W5zjYIs7wqX+WaFahFzDSn8ltSU9uGbrKxO1FftCwNFQIgNnXrduVL/kU
         gQEXZ6hXqB3YPDgUSCAoAKvtVpFMU3TNC6HXyaLDm0aHd4UTH75AfLfd7t31c8VAouq6
         qVifOOYuXg3cqbBuWBXMBcQIlO7w1H8TewoQDfHan8k4R2qW28c16AW4TT5Wsl0MBNNO
         x6lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772665406; x=1773270206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ivkx6puhgdlm/jw1xcgfFyqPx3PkaCKD+eg0EyAqi2E=;
        b=TxQj5h0p+95/wzk1rP/+zcm9A5JcOI4NpTBZkSippH6/Spx1wHaWWwd61wMIKx1w/z
         MKLEa75NqH7MY9wu10koswrucxDhifxKZoRdx044W0wD2K65i8/EzrJa/FmP2Lf5cxfo
         HAShyY3upaQzaz5lnlX1zwi9VIN/NEgWRf3XCZRVOH7Z4sf7v6MCqCWthksbOYg/ie+I
         1iUCR59HSufMX0bDuAbQJ828+mrdwpK59uzyaVqQIKBbbsLtxQ+CW2lstyKpFQKRYGAE
         E5zovX8hQDsZc1UkeYTBZ94kJtY5Ci5hzYtnNrdyQOU6eFtC2hfrzNT/A9wishvVvXIa
         A2Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUjuNGv4tNmafMSuDc3lE9X+K/RcfR1+K9OBi++B6sIbpi4yOurRExrX9l5F/HGEkabDvMytpEzNc+S@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6/Gyh8F333rMOBHx2VqG4/7FdkSAFIVLEnpbVqbnfGRhGzpUH
	xxz3ytvJ06cd8u/vJ4qJqnb8UG3ADV+Qa7u0MA15nt1XoK3RvFwYf+YqdY1H5t7aTHeErQeC04A
	Bt6VmVNLGBk1GE97QTgW5CicjGxPHSlI=
X-Gm-Gg: ATEYQzzzCKfyQyWMGFSBwuPhhJ12PGKhVuEh+Qh8spLDHItt3GKTlsDWMt+szF1F0x5
	8Jsg5JUN8Hh536vQ2hCAzWl0rjSke33HGy54qAuYessLKn0Y8/K0vGGebuJ6R/TQmEW9DMbbHQ9
	tUVTsQsitN0Xvm2mN4S7NmFlDjkUE2vvR8qNWVAiQy8UI50H9GH3tqJwIItAzu5xPgUXlvg6slr
	QVLoCfu+7MeO6DaIt7aN5wJLxBP4NUtYJfsOQWEGmCWvuU9qc185uYEmj5m8Pe48EN4dU6vpx5w
	i7+i3KBX80QGWX20V4EWtoIZrsSGKjTD0BFza53YR5rLkziY3bQoIjqFxMhLBJfxx5zPwbF5yxG
	o3c7R9w==
X-Received: by 2002:a05:6102:26d1:b0:5ee:a8c4:18d4 with SMTP id
 ada2fe7eead31-5ffab04169amr1874568137.35.1772665406379; Wed, 04 Mar 2026
 15:03:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <bffaab8d4727991c8dd46c8b57a08507545a25a4.1771986861.git.lucien.xin@gmail.com>
 <20260303083324.35531-1-pabeni@redhat.com>
In-Reply-To: <20260303083324.35531-1-pabeni@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 4 Mar 2026 18:03:14 -0500
X-Gm-Features: AaiRm53WpBr8gTUmyaCTW1p2ySTbZ_Gi0kG47wju22GuqYXLQHQ7psn2_WgPq2w
Message-ID: <CADvbK_f96OxCWnP9UdKxYtJ9=3xY69_ScTrU=9AQF1iUrBp_Cg@mail.gmail.com>
Subject: Re: [net-next,v10,13/15] quic: add timer management
To: Paolo Abeni <pabeni@redhat.com>
Cc: hepengtao@xiaomi.com, kuba@kernel.org, jlayton@kernel.org, metze@samba.org, 
	davem@davemloft.net, kernel-tls-handshake@lists.linux.dev, horms@kernel.org, 
	hare@suse.de, aahringo@redhat.com, tfanelli@redhat.com, mail@johnericson.me, 
	andrew.gospodarek@broadcom.com, linkinjeon@kernel.org, dhowells@redhat.com, 
	matttbe@kernel.org, xiyou.wangcong@gmail.com, dreibh@simula.no, 
	jbaron@akamai.com, quic@lists.linux.dev, pc@manguebit.com, 
	marc@fiuczynski.com, edumazet@google.com, alibuda@linux.alibaba.com, 
	steved@redhat.com, illiliti@protonmail.com, tom@talpey.com, 
	marcelo.leitner@gmail.com, sd@queasysnail.net, linux-cifs@vger.kernel.org, 
	netdev@vger.kernel.org, mbuhl@openbsd.org, smfrench@gmail.com, 
	chuck.lever@oracle.com, daniel@haxx.se
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 3:33=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
>
> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-loca=
l.html
> ---
> quic: add timer management
>
> This patch introduces 'quic_timer' to unify and manage the five main
> timers used in QUIC: loss detection, delayed ACK, path validation,
> PMTU probing, and pacing. These timers are critical for driving
> retransmissions, connection liveness, and flow control.
>
> > diff --git a/net/quic/Makefile b/net/quic/Makefile
> > index 58bb18f7926d..2ccf01ad9e22 100644
> > --- a/net/quic/Makefile
> > +++ b/net/quic/Makefile
>
> [ ... ]
>
> > diff --git a/net/quic/socket.c b/net/quic/socket.c
> > index 74e3e3939c61..93a7abefc226 100644
> > --- a/net/quic/socket.c
> > +++ b/net/quic/socket.c
>
> [ ... ]
>
> > diff --git a/net/quic/socket.h b/net/quic/socket.h
> > index d7811391cc8b..c5654fdc06b5 100644
> > --- a/net/quic/socket.h
> > +++ b/net/quic/socket.h
>
> [ ... ]
>
> > diff --git a/net/quic/timer.c b/net/quic/timer.c
> > new file mode 100644
> > index 000000000000..6f957385a341
> > --- /dev/null
> > +++ b/net/quic/timer.c
> > @@ -0,0 +1,196 @@
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
> > +#include "socket.h"
>
> [ ... ]
>
> > +static void quic_timer_sack_timeout(struct timer_list *t)
> > +{
> > +     struct quic_sock *qs =3D container_of(t, struct quic_sock, timers=
[QUIC_TIMER_SACK].t);
> > +     struct sock *sk =3D &qs->inet.sk;
> > +
> > +     bh_lock_sock(sk);
> > +     if (sock_owned_by_user(sk)) {
> > +             if (!test_and_set_bit(QUIC_SACK_DEFERRED, &sk->sk_tsq_fla=
gs))
> > +                     sock_hold(sk);
> > +             goto out;
> > +     }
> > +
> > +     quic_timer_sack_handler(sk);
> > +out:
> > +     bh_unlock_sock(sk);
> > +     sock_put(sk);
> > +}
>
> [ ... ]
>
> > +static void quic_timer_loss_timeout(struct timer_list *t)
> > +{
> > +     struct quic_sock *qs =3D container_of(t, struct quic_sock, timers=
[QUIC_TIMER_LOSS].t);
> > +     struct sock *sk =3D &qs->inet.sk;
> > +
> > +     bh_lock_sock(sk);
> > +     if (sock_owned_by_user(sk)) {
> > +             if (!test_and_set_bit(QUIC_LOSS_DEFERRED, &sk->sk_tsq_fla=
gs))
> > +                     sock_hold(sk);
> > +             goto out;
> > +     }
> > +
> > +     quic_timer_loss_handler(sk);
> > +out:
> > +     bh_unlock_sock(sk);
> > +     sock_put(sk);
> > +}
>
> [ ... ]
>
> > +static void quic_timer_path_timeout(struct timer_list *t)
> > +{
> > +     struct quic_sock *qs =3D container_of(t, struct quic_sock, timers=
[QUIC_TIMER_PATH].t);
> > +     struct sock *sk =3D &qs->inet.sk;
> > +
> > +     bh_lock_sock(sk);
> > +     if (sock_owned_by_user(sk)) {
> > +             if (!test_and_set_bit(QUIC_PATH_DEFERRED, &sk->sk_tsq_fla=
gs))
> > +                     sock_hold(sk);
> > +             goto out;
> > +     }
> > +
> > +     quic_timer_path_handler(sk);
> > +out:
> > +     bh_unlock_sock(sk);
> > +     sock_put(sk);
> > +}
>
> [ ... ]
>
> > +static void quic_timer_pmtu_timeout(struct timer_list *t)
> > +{
> > +     struct quic_sock *qs =3D container_of(t, struct quic_sock, timers=
[QUIC_TIMER_PMTU].t);
> > +     struct sock *sk =3D &qs->inet.sk;
> > +
> > +     bh_lock_sock(sk);
> > +     if (sock_owned_by_user(sk)) {
> > +             if (!test_and_set_bit(QUIC_PMTU_DEFERRED, &sk->sk_tsq_fla=
gs))
> > +                     sock_hold(sk);
> > +             goto out;
> > +     }
> > +
> > +     quic_timer_pmtu_handler(sk);
> > +out:
> > +     bh_unlock_sock(sk);
> > +     sock_put(sk);
> > +}
>
> This isn't a bug, but the four timer_list-based timeout callbacks
> (quic_timer_sack_timeout, quic_timer_loss_timeout, quic_timer_path_timeou=
t,
> quic_timer_pmtu_timeout) are structurally identical.
>
> Each extracts the sock via container_of, takes bh_lock_sock, checks
> sock_owned_by_user to conditionally defer via test_and_set_bit/sock_hold,
> otherwise calls the handler directly, then bh_unlock_sock/sock_put. They
> differ only in the timer index constant, the deferred bit name, and the
> handler function.
>
> This pattern could be consolidated into a single parameterized timeout
> callback using a data table that maps timer type to deferred bit and hand=
ler
> function pointer, reducing around 60 lines of near-duplicate code to
> roughly 15 lines. The TCP subsystem uses a similar approach for some of i=
ts
> timer infrastructure.
>
> That said, this follows the existing per-timer-callback pattern used
> elsewhere in the kernel networking stack (for example, tcp_write_timer,
> tcp_delack_timer are also separate functions), so this is a minor style
> observation rather than a defect.
>
This is a good one. May not add a data table, but a simple helper like this=
:

static void quic_timer_timeout(struct timer_list *t, int type, int defer,
                               void (*handler)(struct sock *sk))
{
        struct quic_sock *qs =3D container_of(t, struct quic_sock,
timers[type].t);
        struct sock *sk =3D &qs->inet.sk;

        bh_lock_sock(sk);
        if (sock_owned_by_user(sk)) {
                if (!test_and_set_bit(defer, &sk->sk_tsq_flags))
                        sock_hold(sk);
                goto out;
        }

        handler(sk);
out:
        bh_unlock_sock(sk);
        sock_put(sk);
}

will reduce quite some dup code.

> > +void quic_timer_reset(struct sock *sk, u8 type, u64 timeout)
> > +{
> > +     struct timer_list *t =3D quic_timer(sk, type);
> > +
> > +     if (timeout && !mod_timer(t, jiffies + usecs_to_jiffies(timeout))=
)
> > +             sock_hold(sk);
> > +}
>
> Can this function handle QUIC_TIMER_PACE safely? It unconditionally casts
> the result of quic_timer() to 'struct timer_list *' and calls mod_timer()=
.
>
> Looking at the timer API in this patch:
>
> Both quic_timer_start() and quic_timer_stop() have explicit QUIC_TIMER_PA=
CE
> guards that dispatch to hrtimer APIs:
>
> quic_timer_start():
>         if (type =3D=3D QUIC_TIMER_PACE) {
>                 hr =3D quic_timer(sk, type);
>                 if (!hrtimer_is_queued(hr)) {
>                         hrtimer_start(hr, ns_to_ktime(timeout), ...);
>                         sock_hold(sk);
>                 }
>                 return;
>         }
>
> quic_timer_stop():
>         if (type =3D=3D QUIC_TIMER_PACE) {
>                 if (hrtimer_try_to_cancel(quic_timer(sk, type)) =3D=3D 1)
>                         sock_put(sk);
>                 return;
>         }
>
> However, quic_timer_reset() does not have a similar guard. If a future
> caller invokes quic_timer_reset(sk, QUIC_TIMER_PACE, timeout), mod_timer(=
)
> will operate on memory that is actually a 'struct hrtimer', potentially
> causing memory corruption.
>
> Should quic_timer_reset() either add a QUIC_TIMER_PACE guard consistent w=
ith
> quic_timer_start()/quic_timer_stop(), or document that this function must
> only be used with timer_list-based timers?
>
There will be no callers to quic_timer_reset(QUIC_TIMER_PACE), so no need
to add a check for QUIC_TIMER_PACE, I will leave a comment there for this.

Thanks.

> > +void quic_timer_start(struct sock *sk, u8 type, u64 timeout)
> > +{
> > +     struct timer_list *t;
> > +     struct hrtimer *hr;
> > +
> > +     if (type =3D=3D QUIC_TIMER_PACE) {
> > +             hr =3D quic_timer(sk, type);
> > +
> > +             if (!hrtimer_is_queued(hr)) {
> > +                     hrtimer_start(hr, ns_to_ktime(timeout), HRTIMER_M=
ODE_ABS_PINNED_SOFT);
> > +                     sock_hold(sk);
> > +             }
> > +             return;
> > +     }
> > +
> > +     t =3D quic_timer(sk, type);
> > +     if (timeout && !timer_pending(t)) {
> > +             if (!mod_timer(t, jiffies + usecs_to_jiffies(timeout)))
> > +                     sock_hold(sk);
> > +     }
> > +}
> > +
> > +void quic_timer_stop(struct sock *sk, u8 type)
> > +{
> > +     if (type =3D=3D QUIC_TIMER_PACE) {
> > +             if (hrtimer_try_to_cancel(quic_timer(sk, type)) =3D=3D 1)
> > +                     sock_put(sk);
> > +             return;
> > +     }
> > +     if (timer_delete(quic_timer(sk, type)))
> > +             sock_put(sk);
> > +}
>
> [ ... ]
>
> > diff --git a/net/quic/timer.h b/net/quic/timer.h
> > new file mode 100644
> > index 000000000000..61b094325334
> > --- /dev/null
> > +++ b/net/quic/timer.h
>
> [ ... ]
>
