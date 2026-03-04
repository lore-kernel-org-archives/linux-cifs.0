Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E554C384249
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 21:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772659563; cv=pass; b=OenOt7VI90srxb9o9y8aS4+1OFC8Y11G82WsRLVQPzxAiXYMne2puvotpUEz7kogOFwtdsgaCWDTZeKRq+aJQlByAMP89FeaMTlzD7I61azacwrnlwfAGrIW/MYlhQzjWEsuseFEhf6/EiRNi1DxEF2yzcJ64ozdMCuL+fT9oGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772659563; c=relaxed/simple;
	bh=KLXKEYtmB4SEqI4A4FSyQZAfj2jvvWR0iwdwG84js9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TwW77ltkVxle1YQk7V7aMYOVdm23toWiKdelZaGTQeYZMf7jesd+D0baHeNri+wPMwbdvhXnq9Pbfqa9a3cTtM6Qj8V7umXxidO+bsvBo7M+4LYqA6AYObmsHRS8zD0KqNrUoVdCHC9CFLJfc5ldQAH1LU5J1Oaavg4rH6xLTK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dUz6Unsk; arc=pass smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dUz6Unsk"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-824af5e5c81so7393750b3a.0
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 13:26:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772659561; cv=none;
        d=google.com; s=arc-20240605;
        b=joc5Sl7TvmsxA6L75JmUJm8V/xaOi5xx5f3W5r1OIQ869RhYGYKOE2413ZpDTc9BOr
         P9HBlooaEFNf+voW0HgNRr6X0BIskPupSCaW2sX7w68gjzJkGBSdIT3NOaFj9nvM13pJ
         ACvM4cX9DI1zTMIdiw8Dr93KxDSzHFttRxdbybP8tQjb86btgX3qj3yd4hweJkv/GNKG
         iKadObaMuKzyCONqDZ4VcLb3etscm+MeHXNrk7eGeepBQggNhg5HH2iBbrWKNy6dCCdT
         WQhEfTvCmAlJyiFkUEI0VFhGrZtxh8bM3d5wN+l/Lsmlv+4n+FkH012ASkO2DYvMTh/G
         bU7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yL8TME+Vn0JkBONxs9K32ojI9vGSbFL0WZFBDJPwgpg=;
        fh=ASI8h6HnjjYOF0P41BD4450HVf+rDVEf/DuqSMoDQPA=;
        b=lovvVcGUsvmMbrMZ7BpSPl7MvBfzveYwQAIEJc5HfN8582BF3j9sSCda+ztl13Y8Vo
         IRnlWbgo0K38b/LRyNH4oqN6925vIeDOSQC/qeODkXjlm4KgXIeqpDF1wnIcEgnz6xPA
         c9Yx5mcVYkBNKjQXWx79LimOT+cZe54QcDNI7xdFaPwNGIfPIscBf0pX6ItNK32Iiovq
         z8j0ZCg7HIFnfCCm88Hx1amlSJi42ToQ7yFQinrLJmD76uuHm1Y8dUIHVyiKHGZxHOEs
         ZnKAUwJDF/4KjMybrJ+a3xGtrqIdBxhPj+pGMQ9VHpAFHBex4zmg50jr5wACl0/o40b6
         OjFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772659561; x=1773264361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yL8TME+Vn0JkBONxs9K32ojI9vGSbFL0WZFBDJPwgpg=;
        b=dUz6UnsksJVnNjKspySrj7AbDMJEOZ7hTzpeudxEtfvE6vkR8/AMGgblfReCFAwPPF
         bzjPHwRt4GPPOd5G2FwMcEVkyk2yKWgK5L/+s6dydsdLP1SSkvMig3awN/D/We2M1AL5
         UQQpIVrHj4Whry5s23NhgWSiDenp8ZpPSdlHkB+/1xyMzX3VuZCEbyQ7BAmDoqCHHiUe
         WMTxi5kHeI45qyiMDPORbaBWjwzFODEc9MNcFF5L1qBDFkJ/tAr+Exa8S4VEa57bhyEq
         dkmgvqJnkMaLOxrJdbMok1e1/ASRCaN8WNI/+roS2AEcUJJh+tAmc+TaPDZP6SpaHlP4
         y4NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772659561; x=1773264361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yL8TME+Vn0JkBONxs9K32ojI9vGSbFL0WZFBDJPwgpg=;
        b=SyCPLPf6GReisVJGatSFahyRy8v/1BQqGQCnlZJTlkj0xYuhTCfgRhZaYdqwAG5h9E
         VZwNrrmsPVxky74jyPutlPJ7sPyAn+IcY/pbiuWwQRy9lvGhnOvJEbbw97U/8t+jO05A
         0XnqfvSZ2SClq3V52iRaFRm5mN58SToV6yPlOOdVXbOjUmakkbicmxD09YfZwjmkUOr/
         09uIKg6sMPWO4h/gG9RS1Ydk9YrSIHg/R1dxd+Qqd79sU2gPX25uSNh6GPbOwAIZLj4Z
         fQ96tJKIie+kXG7hH61fSC3PbcPIqMJnF7HefQs0rJ/6ZxE2grLPAWVlx+7W6eh5kpzg
         pn7w==
X-Forwarded-Encrypted: i=1; AJvYcCUdy3dPa8ZMm8vUa5MPlrKuCq0X2Kl68OJZbQx/kblsnJhfJ0qu5MzEJ5V7ssvmZnWDY7ghCw3Aj06K@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1LsbRe8fm6cHbsaMoBLx59UI8TnM1bAwZMQlV5WM8PKRQBAi6
	QtzG5KBWvjqlko0eLANP1FBzsbgWBBo5iYLtsesst2c32yzftYVZkr2DbsJwxcLXfHLN/hOTa8T
	4IKi5q/gYPDyODbnF4Vfz9zDy7kY6peA=
X-Gm-Gg: ATEYQzzXMQRRWVclQRXC7oVz6QBxsd2QCtrJYr+rlbCSQ8ZyW0F6AWceAhihbz1On97
	eI38DyToAF5lMntLabFe+pB8Sbp6Nq5z3cBffg2Mv+SWpvqb2luxfcXyCscrem5H9elY61ePyCE
	weUeqJziqVzzBtKcMI3qBkV5skx2jplUI6Q8uLbsnlCCtsJVp+gBvbQ5H2jUZoEVNRfGuilV80d
	AdDWJRgILV/WcU0PgYb2LgCQYwSSb3Cbqqzc2DGKiKckGNvIgNtVlATEQny4nSE2ZOy1lLLzIOX
	R2pyUXapK+GCUnOhyhqwWv3CwDQXD15cKikkf7LqBpidte23NCAkeBpiGLrkXIIHADlBngFfk7T
	TCdoZ7KHYqAacAa1AirxvsBxWFGFRq9MMeuM/BcGY
X-Received: by 2002:a05:6a21:44c8:b0:38b:e9eb:b12c with SMTP id
 adf61e73a8af0-3982defa8fdmr3188341637.31.1772659561307; Wed, 04 Mar 2026
 13:26:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1771986861.git.lucien.xin@gmail.com> <4e03deebdc944d9c963b0732abe8ba631893d82e.1771986861.git.lucien.xin@gmail.com>
 <CAF6piC+W=QKU53vix1f8JxxFhRKCcMvXaX1NKBT3kcZLfCydEA@mail.gmail.com>
In-Reply-To: <CAF6piC+W=QKU53vix1f8JxxFhRKCcMvXaX1NKBT3kcZLfCydEA@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 4 Mar 2026 16:25:50 -0500
X-Gm-Features: AaiRm50sq6Q3ttOp0vRNqW0uaev0YqHa-ggFkCiWTmshlDbHcjOdnyr83v7j-LI
Message-ID: <CADvbK_f84jwQPRq-xztO9mN+m_NWXaf6Q+9Ao-YtDiGQfmudLw@mail.gmail.com>
Subject: Re: [PATCH net-next v10 08/15] quic: add path management
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, 
	David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, 
	John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	"Marc E . Fiuczynski" <marc@fiuczynski.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 3:23=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 2/25/26 3:34 AM, Xin Long wrote:
> > +/* Binds a QUIC path to a local port and sets up a UDP socket. */
> > +int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 =
path)
> > +{
> > +     union quic_addr *a =3D quic_path_saddr(paths, path);
> > +     int rover, low, high, remaining;
> > +     struct net *net =3D sock_net(sk);
> > +     struct quic_uhash_head *head;
> > +     struct quic_udp_sock *us;
> > +     u16 port;
> > +
> > +     port =3D ntohs(a->v4.sin_port);
> > +     if (port) {
> > +             head =3D quic_udp_sock_head(net, port);
> > +             mutex_lock(&head->lock);
> > +             us =3D quic_udp_sock_lookup(sk, a, port);
> > +             if (us) {
>
> When the quick socket is already bound to a local port, reusing an
> existing udp tunnel sock is allowed, but when the quick socket is not
> bound, UDP tunnel sock reused is prevented. This looks confusing and not
> documented, please clarify the behavior and/or make it consistent.
>
Yes,

/* Reuse of an existing UDP tunnel socket is allowed,
* but if it is currently being freed asynchronously by the workqueue,
* it cannot be used now =E2=80=94 retry later.
*/

Let me know if it's still not clear.
>
> > +                     if (!quic_udp_sock_get(us)) { /* Releasing in wor=
kqueue; retry later. */
> > +                             mutex_unlock(&head->lock);
> > +                             return -EAGAIN;
>
> Why not -EADDRINUSE here?
Because in this case, the us is being released in workqueue, a retry
will likely succeed.

>
> > +                     }
> > +             } else {
> > +                     us =3D quic_udp_sock_create(sk, a);
> > +                     if (!us) {
> > +                             mutex_unlock(&head->lock);
> > +                             return -EINVAL;
>
> It's probably better to propagate an error code (PTR_ERR) from
> quic_udp_sock_create(), or use -ENOMEM
>
Changing to PTR_ERR looks better.

> [...]
> > @@ -332,6 +333,12 @@ static __init int quic_init(void)
> >       if (err)
> >               goto err_hash;
> >
> > +     quic_wq =3D create_workqueue("quic_workqueue");
> > +     if (!quic_wq) {
> > +             err =3D -ENOMEM;
> > +             goto err_wq;
> > +     }
>
> AI review noted that:
>
> This isn't a bug, but create_workqueue() is a legacy API marked with
> __WQ_LEGACY in include/linux/workqueue.h. Should new subsystem code use
> alloc_workqueue() with explicit flags instead?
>
> Looking at include/linux/workqueue.h, create_workqueue() implicitly sets
> WQ_PERCPU, creating per-CPU worker threads. Since quic_wq only handles
> infrequent UDP socket cleanup via quic_udp_sock_put_work() in path.c, is
> per-CPU allocation necessary here? Would alloc_workqueue("quic_workqueue"=
,
> WQ_MEM_RECLAIM, 0) be more appropriate, or could this simply use system_w=
q
> if memory reclaim safety is not required?
>
This workqueue is also used for processing some backlog packets, which requ=
ires
process context.

I will move the infrequent UDP socket cleanup to system_wq as the AI sugges=
ts,
and leave this workqueue for the backlog packets processing only.
Then the allocation becomes:

quic_wq =3D alloc_workqueue("quic_workqueue", WQ_PERCPU, 0);

Thanks.
