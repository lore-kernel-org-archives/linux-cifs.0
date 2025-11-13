Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B420D31195A
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 21:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763069041; cv=none; b=IAEVDOXQ1QxpIYZJAJAeIHpuWGQ8VZs5nELh8nRzyfSGX2bdXfkYXa7sdaVTcM+znifGx/cClFtEYWSThd5xxrXt5VF05c+pLB3Oo4FuHyl5dIQYOrnbJqq/XuoIviYKO6R0EJehglYB0fQ3Jn9j0Uvd1PrgNo6CAqzY/Kr1YAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763069041; c=relaxed/simple;
	bh=pO5srCnJ/G8Wtg56D/7o5a0CmnBEcn72CLEb/fHokxE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cPYM+Jz9DWiMaZhlbMltxv0lz+3Hhb2LJvYVCJoaXXmm18TPJpNDs9JPu3JACQg5VZgq+Z5Rs15ooR73tXNPsY+EccgekJJjlIQlndcar58wqbDOcqh61cTuV0ZOmwrFefIXG/eRi/opRDrILrejK9j6EGYQaaQJkyWHeUGpHyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eI/xzN4m; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eI/xzN4m"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-298287a26c3so14950105ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 13:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763069039; x=1763673839; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eh73fAdHPRVMVUq30CorTp1R5F8aS3XmyyV4X7uyU7E=;
        b=eI/xzN4mkntpzlGY6HqBvRBgOqSg58DBIPpzyvWAG3ZWanFkg6Z61zKadGHvxT47Qm
         UDThgTfgYG12c/mNZeJINbDaBMn2o3LFOjryhdGJxleKL1GoO6utBrU2xCZJgj00UCfA
         6KdrgH5AnXglxgUNSKEC+Tn1fUXftqkDq9PWjuYbuxIKxBAVxCvtmEKzxKaGd+UZ7KKi
         vaOYM1LUXjlO74LBFsn2+mm3ohR1+TvfhKkQaKpZRNtbP3zSQlGzftMS/SjT3CkNx6+X
         244W7EcfWaziUDCX+2o01v8FTEox2GsR8TNGuBhIcLXoIGilOtiACKxhlQlHXNgdznzD
         yv0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763069039; x=1763673839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Eh73fAdHPRVMVUq30CorTp1R5F8aS3XmyyV4X7uyU7E=;
        b=kulZpKO1rZVfiogW5vH+A9QrOr6TunvDAMV96ctkq8R5FYLXE8pPIWX4bL6x4z20eF
         MysRRaaKliwMGkOTOx85OTSwE1eMJYcOXbTI06aNvlul7er96N5z282OoExH7M208dO7
         r/2pMkcMjRPF4derw5V8NCO5tptcxvUHo2IO6rLzsu4qQy9o8nTN/9sZgL6wBIlbDh1r
         THfU6pdHQwydMkqSl4fSqy1rkelBXavAW1f1jIVH0OPKGhbRypaZwboyFya6xc45LIhT
         Ohuoy0QWbNxLWlKQ/ctOp3Ti57HH5rRGLunmDD4vHwOH6mAML0pFo2tY8oKcUf1FTtd4
         RqKQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4JKcVb4ErK6Sr/gJcmt74Z9VMWJDyf6hsiAbV6GTwvubUb0dGEOGZXy4YA1qYWwHz51VCutkywYdq@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3KURgts5Bc7CwQkyher1Nv/kqV6yqiJUW6bdENaVXjEnqjuEO
	2lKV5B7Y7vJJOhKXiAtMFye2y+5qR+tcHOXpusaZa5NlnRmN2L1UjaPIvPuC6CqwEekfsm+Dnz1
	OUIIUh+I5KA/g4F4OyAh6eZeb9oPxRlE=
X-Gm-Gg: ASbGncugqd0e4Jug5qrtkXM3lhHZlIYlNbko1uB+AGaG32K0GXwxlf9ajC8Kip2McUa
	6wsCh9CaE3GFPuTgpVYLYqDJiW3u2gfyLfzaBjRESVSXTjYUjG3hinSPWKyHNx+Epktaz/tJEhV
	0uCXERx2nHpwHQnVUk9ixnvqx9lS4fYc8YtvcH+uHZVyPHCZsxM+IVHJBdiUGj2cwfqsAd6bCcT
	6/WTf6RSi6H8Dxk3iWZKSA0L0W8phJK6wi79k7xD8biy098AO0Q3Jzm/Sjs
X-Google-Smtp-Source: AGHT+IHIy62FYNI2+fsss76ZAxstDpGuH13CcKtwJwf7q37KPjXXhYyeWXtZJfedfcdinC12R6BE741QmBSKtVPCgHU=
X-Received: by 2002:a17:903:1a10:b0:295:21ac:352b with SMTP id
 d9443c01a7336-2986a6d6834mr4511285ad.15.1763069038948; Thu, 13 Nov 2025
 13:23:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761748557.git.lucien.xin@gmail.com> <cc874b85134ba00f8d1d334e93633fbfa04b5a9a.1761748557.git.lucien.xin@gmail.com>
 <3618948d-8372-4f8d-9a0e-97a059bbf6eb@redhat.com> <CADvbK_f9o=_L=K+Vo_MbJk3mXFgriUUtGCSVm6GNo6hFHk5Kzw@mail.gmail.com>
In-Reply-To: <CADvbK_f9o=_L=K+Vo_MbJk3mXFgriUUtGCSVm6GNo6hFHk5Kzw@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 13 Nov 2025 16:23:47 -0500
X-Gm-Features: AWmQ_bl_mzAmk37GvxSMi73Wl76L8rzqwm6CGLE5Z5FgVRtg24EVCmyQJDOWLoo
Message-ID: <CADvbK_fi6GDOwpo_vRNWDXLn9v7Kys5zuz8RGNxFYEm6y0KcTQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 13/15] quic: add timer management
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
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 11:49=E2=80=AFAM Xin Long <lucien.xin@gmail.com> wro=
te:
>
> On Tue, Nov 4, 2025 at 7:33=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wr=
ote:
> >
> > On 10/29/25 3:35 PM, Xin Long wrote:
> > > +void quic_timer_stop(struct sock *sk, u8 type)
> > > +{
> > > +     if (type =3D=3D QUIC_TIMER_PACE) {
> > > +             if (hrtimer_try_to_cancel(quic_timer(sk, type)) =3D=3D =
1)
> > > +                     sock_put(sk);
> > > +             return;
> > > +     }
> > > +     if (timer_delete(quic_timer(sk, type)))
> >
> > timer_shutdown()
> Will update. Thanks.
timer_shutdown() sets timer->function to NULL, and it causes mod_timer()
to return 0 without enqueuing the timer. This breaks the code:

                if (!mod_timer(t, jiffies + usecs_to_jiffies(timeout)))
                        sock_hold(sk);

in quic_timer_start(), and cause sk leak.

So I will keep timer_delete() here.

Thanks.

>
> >
> > Other than that:
> >
> > Acked-by: Paolo Abeni <pabeni@redhat.com>
> >
