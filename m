Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1532D3733
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 16:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447761; cv=none; b=nUf7j3ilr14OGquPjFLC66WVk5SL7lQzH4Cak4v/BrJ/TFULY/LnInsJWwRYzFrQPAyMEyGcBkWkLw4fstySbhvA5JFCgpDJ56apRka/7E5BaCqFiaXS6e/yyt2ve9lggyDR+Nd9G8X4RAIbq8KPsGrtgrxLKLDpmr7/C/1P5Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447761; c=relaxed/simple;
	bh=gPC9VPLFYbjfVxBSFkmUOkcw3DGZnlisHf1J732GkLk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kGaB9gSqFPzzxftSL65mCk8R6PYhX7PTBQi8OP0ZQMGVEo3u01RcQwsm21wCenx7I1ksEmMaebLcGNqwV+EUeeGn+s4qQ6rWlfyKxqvHUlF2ZJJmY4uj1Ina0lJ9fJdgS3Rw9sCA5J5xLta4eqbX5dVetj3d32rMyyEffoOCxmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pxdy5pNV; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pxdy5pNV"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-793021f348fso1035222b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 06 Nov 2025 08:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762447760; x=1763052560; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qzn6+Sh35pzxbK3z/xOK777J6LI54V1OZ2Oy1H+1YU=;
        b=Pxdy5pNVYWILmUSusu47+TjwZlsqGFBaR0IidrJzRoMtGDpXyUs+YIxMsMoiseL/bJ
         hiL6CS6636iL8aIq4ZILae2grig0IdTbCkNWBmQ/bqlfbNjaicKYBmiedN+i+rc4hPcb
         w6Sy5+OviusZWIDVGhnskDCyioxinh7itjziVJYHNLFEXqc3NUzcuOhYj++5QlMuPEJN
         FOr43I1zwz8Ps6cEEh8H78mZy4JIcIpOwl/2mTrj3Rca/x8a274j9RWd8MZWkuBIOlY+
         vGmqRf59G0gwFIpTSAeoWoiar/UXs5PZOvf3rz+duCw75SKGFoIn+wZuxA5CveXSnjl+
         Y8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447760; x=1763052560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1qzn6+Sh35pzxbK3z/xOK777J6LI54V1OZ2Oy1H+1YU=;
        b=C966di2zsGvf07enztB76MNkGvIIz+ZuFuQlTteT/WdxSa9MaV/RjIthjITCXp4wB5
         C55NXKuVaf4uzWklG6jjSw2jQtM24BFeneviB6ShbW63pbWiRrmtU3IZgxbKxRBMh9OK
         PxbVQs5Wis0iwJBTHicVFaoCt3h768yH/H8PeO2yQmAkNHoXU5A8i3t6sc7OiJErcSjE
         IZEhg/QOBS8eTZqFq4y7oonyzAgVncUcwOIRHtrgJ5ps8J7DPGEZ9/WKXPdga3bjq+wY
         FAgsGC5HXu+rtlVNPJqI1vwgGsj48ubC7DSy9DwMZQHnBqcCRCv2t0J2gLLg5i+LY2co
         +tGA==
X-Forwarded-Encrypted: i=1; AJvYcCUGvlncTrWKaAsFuBmxP2ieCfnR/ttIItykN8ZcYOB8pdPwE0hzNmzI7C7gnf5YVl8QJ+KHMccNZGk0@vger.kernel.org
X-Gm-Message-State: AOJu0YxOMGrMIcDCWl8X0w4P0qXo9iR9Qad+TAzKpUx/enculajRVXIV
	ep81akq/vr6iYgZj9BZhI+fo82oAxTI8cPzz3m12rCvHsJGD174ke17/Eh6ioxrLoNwXuCf7UqN
	urOLwW6BlmRu1eoFpm+YfJXzDhaEHWnQ=
X-Gm-Gg: ASbGncvaW3oMfuEt2oHKJP+KVOvbT937OTaR4YtzUj6WLuDohVRcPOgW5JS9iMJZPIA
	+J3oT3yPtg0mq+hTxohum/uPIKAdRWRsdjBWS5Vo5K4FcOGdxXZB/p28D3VyELlIcL7sLPWPOcd
	p+AJu4iVY8xCCiKOSvzQqw7nD060xyBNq8tfZyuYDBsPYpQr25DHD2EHFp5BYiEavt1Lzva9rey
	P/nqo8LNckJzM1Uj4JDGuajBxFsK0WbzhAMUZ8G/ptROK/JT2olyivYSwKK20yri9mZQ52FhMue
	cAbEJmMhrpGD3lbr+6Pha9OOYBTk7w==
X-Google-Smtp-Source: AGHT+IF5xt57zcNq+U+HwDSwBlT/1oLe/u7UB3heYQ1Kbhs29xTrM/I6aw5xgiWPTyWZevpEl+UkTdOu25fxJ6wmzM0=
X-Received: by 2002:a17:902:ef4f:b0:290:dd1f:3d60 with SMTP id
 d9443c01a7336-297c04931c8mr1358545ad.51.1762447759701; Thu, 06 Nov 2025
 08:49:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761748557.git.lucien.xin@gmail.com> <cc874b85134ba00f8d1d334e93633fbfa04b5a9a.1761748557.git.lucien.xin@gmail.com>
 <3618948d-8372-4f8d-9a0e-97a059bbf6eb@redhat.com>
In-Reply-To: <3618948d-8372-4f8d-9a0e-97a059bbf6eb@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 6 Nov 2025 11:49:08 -0500
X-Gm-Features: AWmQ_bkulaWnvSaWsxVAziWY-nd-sBA09kWceVf7bj-CFTKpUJNHZl6a4fE2Pjg
Message-ID: <CADvbK_f9o=_L=K+Vo_MbJk3mXFgriUUtGCSVm6GNo6hFHk5Kzw@mail.gmail.com>
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

On Tue, Nov 4, 2025 at 7:33=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 10/29/25 3:35 PM, Xin Long wrote:
> > +void quic_timer_stop(struct sock *sk, u8 type)
> > +{
> > +     if (type =3D=3D QUIC_TIMER_PACE) {
> > +             if (hrtimer_try_to_cancel(quic_timer(sk, type)) =3D=3D 1)
> > +                     sock_put(sk);
> > +             return;
> > +     }
> > +     if (timer_delete(quic_timer(sk, type)))
>
> timer_shutdown()
Will update. Thanks.

>
> Other than that:
>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
>
