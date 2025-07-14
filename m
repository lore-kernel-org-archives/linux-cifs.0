Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3170C26058B
	for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752513818; cv=none; b=pYfvUDnNKXdqj99zmKQ/58Q27TuUGtL7tjly9Wy7qwP7vZRzNHFhZVexGLrmUq6ENdiszEfmSoXC7j8VymTnUYkV6tVcE+QuE8tvKzGDOxq/SZGMX/ihtE22j+2ZfAXodcG+N+BMroSoSYnrVEaAHkXjcINqp40Phnu60DhUBYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752513818; c=relaxed/simple;
	bh=Y6lslHVfbA7FdD6UKhErhC4UNQtEAvtLUHZkACZQ/cE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dG7+xMvWZWKNd6AkGjpJgKFPTra4MIyMi2G0oRlJT3ZLc2C+EqV81sxWi77bgz3UI8T9YYMJyzRTah0XInEXRgMuE4aeNQJtSvftHEMKK4OQDswVel9NwWDtjI8wO7E4m7/BrkE/BVP3aUCfHarhQVnsSl0cwpBeLBVJSt40/dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ECElC9q+; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ECElC9q+"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6fd0a7d3949so67087576d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 10:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752513816; x=1753118616; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Mf0XvhF6cXmT7OcdaUhbeSAjWhmje0isYhrsQFiYMk=;
        b=ECElC9q+tOZboBSaHuWisL+c425EdNT8klEw20jBJAHolxUvJmnQUdpuiFlVKWqCh8
         MAVBBoALct9e6unOJx7IS6R0CJ+me0QmDDb+AZIwaKpTo7udbksLDlgDFoBv8MNE+YDs
         sM1hyTohJ1xOzZSUTpmwErgURD5ekNAr/TSip7v3iSfovmGKRFfpAhAnj4ngsdLKTqRF
         s1fY3TWyPQigIsnFuczoEEWykD2XTi0fxtAA0ENORGOvj5TG8OpLg8ft0adBHzVc/a03
         Kij8H7vqpxkS7ucdaz6E/hVpZEknYC9TrJ0hUCqFWNi/y49+EbeRk1+IZcIFswfJgVRU
         FkYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752513816; x=1753118616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Mf0XvhF6cXmT7OcdaUhbeSAjWhmje0isYhrsQFiYMk=;
        b=D6ra8/d47a3CnRz6FMBc9cLKo3fXaUKF8m5IJld1RNqn41UwgZ963m5XmNRakp80/m
         5rQp9p8a+oS92fNF4iqQByY4+onVyoruCQu0e2REWQNBa12wsX50EXsfHqs6NZJeWNGd
         7EanplwXjzhQeK2A5hSZQU70TGTBSiiiP4GGTZXt76C8GfCUHOEE0vp4VRb6crjp9bP6
         cqEbx0m5RrPqOOTFfr7dQobOuTLl421OJQKfb+R2BwPOUQrBLdwqaFf8nSiTh5BDinw3
         mSxs2hzzyfibXblKeZBS0QQ4w6KpNw2SuteD836LoDpPQwHJ1v7Vdzwnn6nI7wv+llcu
         BlxA==
X-Gm-Message-State: AOJu0YxaGoiVLKuP/hFflYGw2+czE21bC6l5cFbg1tKCYnkxVb/y5DSR
	uWtQ7c0P31x/dBp9wXKSGpIKShWBm+yQjdvGfmDdBjml8eIrmvngWWuZnHIj71JDw3X/AJb0DDq
	VL8l5wFwGe2+R4FsoNeov1wC3C/2D2qYlm+EZ
X-Gm-Gg: ASbGncty+9ypYzgGohhhTlRIfIxK++JybPUlr6XcZcNKw17AS5t9zAj59MT4X4sU5gQ
	UgjvYUl4e5+Jl5kUR6S0iFbgI+Kuk34RfA74CHf+YGXD08CO9sAQKZ/W+oYIkee1SThyVSQ+5Kg
	X7oHYjncIrRJPKYK8221ZrI5QFH9XGzuyYTFq15HRiZjQZXyi919D1HQAcOLAu3/edIqB2Jra4c
	+DYWYZ6WoZOEb6/QWa+c3kuWwaVENQDrICJSlCWRQ==
X-Google-Smtp-Source: AGHT+IE0779miNZ8dIplGHikh8ph2bMvnXxOqcfGbKggwOxQ+sCzyEnN+twB144dai4xCrJ8a+CyGLC59MU/IEtpy5A=
X-Received: by 2002:a05:6214:2aa7:b0:6fa:ccb6:602a with SMTP id
 6a1803df08f44-704a35903femr234985456d6.20.1752513815766; Mon, 14 Jul 2025
 10:23:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a97b22e8-144e-45ed-8850-c3fd18769a6c@pre-sense.de>
In-Reply-To: <a97b22e8-144e-45ed-8850-c3fd18769a6c@pre-sense.de>
From: Steve French <smfrench@gmail.com>
Date: Mon, 14 Jul 2025 12:23:24 -0500
X-Gm-Features: Ac12FXz2c-4Im9oHCGYQ9FrZ0zzhuGMvupQ0rKGx21u87M_KUS6wFr_C-w_4ENU
Message-ID: <CAH2r5mtgWfxQtoy2gwnMiWM3HXno2icuWmiuhMJ64yTAi_jsyQ@mail.gmail.com>
Subject: Re: Using UPN with mount.cifs?
To: =?UTF-8?B?VGlsbCBEw7ZyZ2Vz?= <doerges@pre-sense.de>
Cc: linux-cifs <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is an interesting question.

mount.cifs will pass it (the UPN) down to cifs.ko so it will get sent
on the wire, so behavior will vary by server.

I tried it to current Samba (passing "username=3Dtestuser" and also
"username=3Dtestuser@somedomain" and also for
"username=3Dtestuser,domain=3Dsomedomain") and it worked fine for all
three cases (with and without UPN, with and without "domain=3D").

Trying it to Windows though:
1) "username=3Dtestuser" worked
2) "username=3Dtestuser,domain=3Dsomedomain"  worked
3) "username=3Dtestuser@somedomain"  did not work to Windows server

So looks like the behavior varies by server, but safest way is to
specify the UPN as "username=3D" and "domain=3D" rather than
username=3Dsomeuser@somedomain

On Mon, Jul 14, 2025 at 7:44=E2=80=AFAM Till D=C3=B6rges <doerges@pre-sense=
.de> wrote:
>
> Hello everyone,
>
>
> I'm wondering whether it is possible to use User Principal Names (UPN) in=
stead of
> accountnames + workgroup/domain, when mounting a share with mount.cifs?
>
>
> The man page for mount.cifs does not mention UPN. A quick grep through th=
e latest
> sources (cifs-utils-7.4) doesn't mention UPN either.
>
> Searching the ML in particular and the web in general came up emtpy, too.
>
>
> So, is there a way to do it?
>
>
> Thanks and regards -- Till
>
> --
> Dipl.-Inform. Till D=C3=B6rges                  doerges@pre-sense.de
>
>                                          www.pre-sense.de/fcknzs
>
> PRESENSE Technologies GmbH             Nagelsweg 41, D-20097 HH
> Gesch=C3=A4ftsf=C3=BChrer/Managing Director        AG Hamburg, HRB 107844
> Till D=C3=B6rges                              USt-IdNr.: DE263765024
>


--=20
Thanks,

Steve
