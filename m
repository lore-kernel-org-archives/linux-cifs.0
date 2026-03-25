Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C342313546
	for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 06:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774420080; cv=pass; b=hZ653/vainm6zaujyRPq+sV04Z0SqJYYwpS5FELHBP4HagB1CSdm/tHp7ltZkMHvtTxxs/HHUUOCSoQjyGi+L3WeNCjgo5muEvxXPMGuhev2asU1hznWNDBiGQwRklhznjaS7RS0M+Wy1RbfOx/5vPdE34hMsGdClwCjSPW0scE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774420080; c=relaxed/simple;
	bh=MJEoW7xmbsgf8ccUD0trvF3J+NKmwZJnCVsuFcirp8c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HAwdxDZzdO2tJad8PmknmSxLJjbIVQfpUxhz3EDBH/2AY7JhkqVLRIlWZ1qJnfM5DAY+1KLZ6Kb/eStWZtkzPrj5bUNems0q+ivJF7/UgGHZSdpt0jQz9eeASF3Kq+CeXpZPUlGM+v1T0dQ4FY3mBYPclwaMqFeakGkN/4hG3Kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qcRjmzZV; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qcRjmzZV"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-66a851e62c6so391630a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 24 Mar 2026 23:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774420078; cv=none;
        d=google.com; s=arc-20240605;
        b=LdGOjBNeWeJHvlv7pCOuxkkDZ84/GKtvLVdOKwJn93Fn9wskHUdHAcVsgsmH4J51K6
         Ad3GCuvOrRI47WhD5Auue3zISc3C1E63SzHug3rRDn9tr2jtL7vJ8gQMfchRWRoWHekZ
         gIM7eI2uR6TSSDs+lddEtArI62SP8JHgKXBR6Xh7Rw9ad93OQCDTW5B0WnLj2YM4xGSX
         unlflqdUQnJTW4dwzJP8IsjYDDt5hv499SnlRtCh7fmUMjTbZoIEmtq+ElK5jIgDxPu+
         W0RpOOg2x8d7EwopBulgDX4BM2/6TBQcmDr5xcMP/JocIfTdHvfa28GYty26uQzoGGyQ
         VhcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M6McgGdWNeUSRU1+qLW5hhdwIQf8ldUK3zxn67ADOeA=;
        fh=mjbHuUT6L+TcT4hRZ7xS3Tn3Y2zrzo+BC+wEuQ78IdM=;
        b=AObf13CJ2lhREr3NUrzRXRz8Ql2hySYXmShkzjBCCoMlk6DSZMKiZxokRzfjMOhiNI
         G+2bcIK1GI/eRFfuljT0O5oIwu+FupGQnbC+IE9aQ/JjSES/2AUfvdBxTWT6AXsYe8GW
         Rufl4OvjklaW9+6oRxC6nFv4SMsa1q1u7MuiRJgSodZLiBexlVYcxS6OabjvNTwZvJZK
         OXvX/wyuTR/F1StQpJZsMnGqCeZQ+xD+l20FPubXsMo2f+kE+2J5CgAwtmO3nAJfor6l
         Ouo+wSt/djKhbZO+70eeZfKc55bem4NHEXlLrB6+3x+b80tm9MD9vK+C5b+DmRj8fp82
         udGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774420078; x=1775024878; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6McgGdWNeUSRU1+qLW5hhdwIQf8ldUK3zxn67ADOeA=;
        b=qcRjmzZV1DGcFvsPTbcfa9HCjv0r4ugdclPsDRWRWvlZQT7qf1p+lplFTvgVEE7JYH
         ghKA71R28V7pI32M88GQAexaT+5EToaMyhs3jrDpmdhZJdy5oNt4hcf6TbInyX+zn1bN
         fosEdPwf0aihSrBLCZQ/Je7R1C+w9EFEWIa9OO3AU5yFmZd6o6M+5VZUAnW6nNbDJTbx
         rtpk5ob0uz2eZWMPWsMaQhzX0bjwR9pwQaHSqppigWg5UqqP+F9hHkSrOfEu+WKDPb52
         iYIM1efsZ2KmFOlcBqhd0yt18/cpnVBcbAO6gCh6P7/kKk9J/f01gaakgw0vXZRpJgIi
         jLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774420078; x=1775024878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M6McgGdWNeUSRU1+qLW5hhdwIQf8ldUK3zxn67ADOeA=;
        b=I+v+3IWhAuKaVnQ44rsvUJhxvhFDqHgGBFrlpsPPfQHqTM25atUbJ7WD+3Kh8lyJP9
         OCiQjqhOLDy7PWoXpf3pGkMxFbfD0GksSsvE3vNRhrCbaPBeldT+DOxXikRukdYUR9w5
         PH41cuRvsWXZqxHliGQ8AzcfOm1J/Xik2IMtuvXv/cBTl1Nu9kLmm8I5YEc54Ld1j5E5
         0iAuYTsveG39L3vwJzmD+lMscnVv+rvPh0/6KejHRLTls5PiU3DbYchhHFErTPJJrBed
         cmuIDk43Jdugpv3BuU7aCMjHg12JBswIT5fHg6btszQG+N5EbIZzZRhxY/gkj6pHNXgc
         K1pw==
X-Gm-Message-State: AOJu0Yw9QN1xmIpOVJpLpRui4Y35pWvSe73AVe7FRuQp/wsYUHIxYaHE
	Jp1O3dw06jjiddsGPR9j1Qe4V0mSBYA3FyyDEhRY57pLPKIHQO3BXVADfyHhJ1vfpqo+Lv62rLc
	B76187o43mW0wEk1OVoKX/W1/HIkw4fg=
X-Gm-Gg: ATEYQzxX4lYPVAn4BgJm7tsNttCbM4+hX3FF7ORtSTSzybMWDD9M5nCo5dbcopwj5tJ
	0+YDjOUfhJOZbpwISzGBloKsuLOuobMr1jGH1jdn4MJsj9FtHH0Ld1GiTEQHc5W2F+j0+4Isiyi
	d1QzCehhiRx9kjlV+HlSMKnwJYYhMrPNS4zC/5snNkYQsC5puAp/+x2MXm8oE2E+GQ3KPGCXyuH
	4/iiEEsTb2qNtc9w6soUdsU32IVZZEOI0Br1xfPVA5g8Y21L5SgPy1LNl1Wv9rRpR4v3C5zL1Cg
	3/gJ4kUlvh/mpQ/4BBzZEb1gCoKACnLpCCZQ1xDJOYt9bfI3EHm5hYkscwh7R7iYKh4+oh1bO2t
	SYHG3Eg==
X-Received: by 2002:a05:6402:23d8:b0:669:67e7:9243 with SMTP id
 4fb4d7f45d1cf-66a826ffd29mr1101261a12.25.1774420077624; Tue, 24 Mar 2026
 23:27:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306063522.439782-1-rosenp@gmail.com> <CAKYAXd_1WEkL80a_fLR4g7+9ryZRZhNJXtKxQG0UJnifd-y9+Q@mail.gmail.com>
In-Reply-To: <CAKYAXd_1WEkL80a_fLR4g7+9ryZRZhNJXtKxQG0UJnifd-y9+Q@mail.gmail.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 24 Mar 2026 23:27:46 -0700
X-Gm-Features: AQROBzCvufYW1IFUKKi4L31QdLKirkufJMjtfLfrtOCbzA3A1hTK49N1Hmkm8UY
Message-ID: <CAKxU2N8fFHOFSeCvmdPrcZcLrT7BP8+AAauz8e5LQ-8yedJ5+g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: ipc: use kzalloc_flex and __counted_by
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be)?b" <linux-hardening@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 11:26=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org=
> wrote:
>
> On Fri, Mar 6, 2026 at 3:35=E2=80=AFPM Rosen Penev <rosenp@gmail.com> wro=
te:
> >
> > The former is just a nice macro and the latter allows runtime analysis
> > of the allocation and its size.
> >
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  fs/smb/server/transport_ipc.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ip=
c.c
> > index 2dbabe2d8005..f7aa427a06fe 100644
> > --- a/fs/smb/server/transport_ipc.c
> > +++ b/fs/smb/server/transport_ipc.c
> > @@ -55,7 +55,7 @@ static bool ksmbd_ipc_validate_version(struct genl_in=
fo *m)
> >  struct ksmbd_ipc_msg {
> >         unsigned int            type;
> >         unsigned int            sz;
> > -       unsigned char           payload[];
> > +       unsigned char           payload[] __counted_by(sz);
> >  };
> >
> >  struct ipc_msg_table_entry {
> > @@ -242,9 +242,8 @@ static void ipc_update_last_active(void)
> >  static struct ksmbd_ipc_msg *ipc_msg_alloc(size_t sz)
> >  {
> >         struct ksmbd_ipc_msg *msg;
> > -       size_t msg_sz =3D sz + sizeof(struct ksmbd_ipc_msg);
> >
> > -       msg =3D kvzalloc(msg_sz, KSMBD_DEFAULT_GFP);
> > +       msg =3D kvzalloc_flex(*msg, payload, sz, KSMBD_DEFAULT_GFP);
> >         if (msg)
> >                 msg->sz =3D sz;
> We don't need to manually set msg->sz if the flexible array member is
> properly annotated with __counted_by(sz) ?
> kvmalloc_flex() automatically sets the counter via internal
> __set_flex_counter().
Needs GCC15.
