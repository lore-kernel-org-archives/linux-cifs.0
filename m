Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935FC19C54B
	for <linux-cifs@vger.kernel.org>; Wed, 12 Mar 2025 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741795606; cv=none; b=JhG2HEOyeBk8RC1zaNYN4FS5PHpG1n2f+pWbzjsGonKe8LKVnhaOX2Mg8BTztCWcIBsLWDoDnh5JMf9Jh+Sq7B8hvRoNKs17BNDrH3WoN85hQ3rXl6xwT609O3F8D2f15g88gYg6v4rqhElVs5jdKhtjz2ikofoJCFE2eHy6Frk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741795606; c=relaxed/simple;
	bh=KAtWcbfS+q9O67Gu+CBUH/r5eysWy0jSwmsp+yogRoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qcy1qsVAS7RRGSedBVoXX2pReJiyTMJa60NW3iO9Q6CSqJdVQDDpv5X1mYTw068fY3e4xRsNBi1udpK0uDU8BCoL/xeT1cz9kEo12rQz8YdEIFxIlBwSinP97RvQ1uvlV5qbcS8qLuyPk6DO0VXDgTIPOwMUZQisJTTXmx92Myc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IOV5H4bx; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IOV5H4bx"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-30bee278c2aso11765921fa.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Mar 2025 09:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741795602; x=1742400402; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m0LOfnUyrqrSMUfxbaFDXI2LoItMKDS9DfMNLzET7iU=;
        b=IOV5H4bxF7A1DWVqrf2P3wwRw7i23JrrVQBqLOTvX1vwKcOvjFWyYJNCEKYMsyVW5Y
         g2ylcdG2d/QxMICn6GEiFb99fc1J6GLlgtvAxTI55kDhjPvhzzKjLcE8wHrMwFRnIQLw
         RXiVGIfxDxhZcXlpPrFvTIdmHNiO0HJ2iJrJ+c+TanEU1lNphNpZxSr0PY5Xsu5Sjxi/
         v+2XCuBLnAM3xCS4N1AWaSi/jxDPWKTpn80P0qb+pX2YyJtFfyTQXmFTUF4iWERFtsi9
         EkQukYdhtOOuowb76t2DqQqRR/wHCSKvqWnEAKA4pQLsw5al47tEuj9uz6wbP7SxJYkd
         kUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741795602; x=1742400402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m0LOfnUyrqrSMUfxbaFDXI2LoItMKDS9DfMNLzET7iU=;
        b=KLSiTlaukY3f0fj8VMbE6FlMelQ04jGZqpBOuVQuQieYGEdaoDlcGw0+9FmiD1sdND
         eCfYFLROlg+RNxLMxcoPZDRYEWPaWYm3Pi/gYmdKHDbZ/OFmDw0kiG04qKYgE05feILN
         pR0JTwbFygpT3n1JINLYX8ELSIo7q33QaJX5n/FUh8xSbKTeHqoNAAfQbJzE734fjjeP
         H+3xFOeXvVLuLNVcIpRf4VhnC+IGObQmaVI43CWQDIHxKSzHgvO+wolognKfzxCllLMJ
         9+TLr2SfxRV8j7PZKGVC0XOQBmvOB6YIkwjIWpWKIes478DvyhBB38TayUKKj1W92C4y
         4bCg==
X-Forwarded-Encrypted: i=1; AJvYcCWhk89l9TG6qv1yAMGUiUJrVX/8eL6bNwmnKazB68b9z3K31WlJC8gmifum5YZ4TIV/ait9NKKc+bNe@vger.kernel.org
X-Gm-Message-State: AOJu0YyghVnXpXkd3OSA3FKW4EpLHgYJzIP4x/ziq8p7wvdwA8AT2Oi2
	xnuw32flGNkUIHHL2oLl/T3v0MAI+4GAIwc37sKzpiemcdmVNxeyHfeH4TqlkihF843gX4YVqaH
	d1mKP2an7GWspGgRhr851YBzWIh8=
X-Gm-Gg: ASbGncsVvJMx0E3W2hQvbizT0+J68PKmNKKB243V1/vRadsiJJfKK69RvPIEYrGBkDK
	znH758yuQFgNCYHd5x3k24MI7XmrSwNnjfZuiunhVIWnLnapplcFFQQFXLir07gfNtFK/HQ75F3
	zgm3jI/0C4CkHXr3r/94l+LmTWKreALCw4belZBvIKIahBGMf/jNqa1TQD5EWx
X-Google-Smtp-Source: AGHT+IG/M4KqSBaml1cUk2JdL4QdDrMsvZHIbmgNdY0clTvlexc2+OwRlymj+t2nosNWxjBZ5g7T1pu3M/O0mMOrbMo=
X-Received: by 2002:a05:6512:23a0:b0:549:7d22:8325 with SMTP id
 2adb3069b0e04-549b8345ce1mr108946e87.2.1741795602285; Wed, 12 Mar 2025
 09:06:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250312135131.628756-1-pc@manguebit.com> <CAH2r5mtjtigJf7JKUiL3D5Lp8f4qTe4GUxQPXwz1o=SQMqiqdA@mail.gmail.com>
 <70d0157ac13725595d64978b11c4d3a91f417803.camel@redhat.com> <4cbaab94c2ba97a8d91b9f43ea8a3662@manguebit.com>
In-Reply-To: <4cbaab94c2ba97a8d91b9f43ea8a3662@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 12 Mar 2025 11:06:30 -0500
X-Gm-Features: AQ5f1Jqr0cJVyXe4JiaoxmohDF9YTt0IKi7Em34wCW3kj4kLlmj0dvX_5T13y4A
Message-ID: <CAH2r5mu5=nnBwibmARGoLepbQfU6qkXnez8whaWaSM7G7MEVXw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix regression with guest option
To: Paulo Alcantara <pc@manguebit.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: Adam Williamson <awilliam@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Meetakshi sent a patch idea to try (to also fix this in cifs-utils) -
will take a look

On Wed, Mar 12, 2025 at 11:02=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> Adam Williamson <awilliam@redhat.com> writes:
>
> > On Wed, 2025-03-12 at 10:32 -0500, Steve French wrote:
> >> merged into cifs-2.6.git for-next pending additional testing/review
> >>
> >> Presumably we could also update cifs-utils (mount.cifs.c) to
> >> workaround this as well.  Thoughts?
> >
> > Yeah, I was going to ask whether just not passing password2 when doing
> > anonymous mount might be an option? That way the new cifs-utils will
> > work with older kernels, rather than being a sudden surprise for anyone
> > who happens to get a new cifs-utils but not a new kernel, for whatever
>
> Yes, we could also change cifs-utils to not send both password=3D and
> password2=3D when using guest mount option.
>
> The kernel change is still required in case someone is using mount(2)
> directly and end up passing an empty password2=3D option.



--=20
Thanks,

Steve
