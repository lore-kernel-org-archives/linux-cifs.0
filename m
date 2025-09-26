Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CB71C5D77
	for <linux-cifs@vger.kernel.org>; Fri, 26 Sep 2025 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758899283; cv=none; b=kN8AAM+aIRn20UhRcakocirYLdcW45uPII9XjmPrqEWwHEp7vs4JXqocQTthysM/2Ql6MnPGP9M7TLnKaKj++id8cZ5wyZttWl7L2PTnITEixHiZuNPJ/w+XZ0xWAKBI+l8dtLfD5+xSF6yRVfuA3RsXGWGrSIrk8WVHAidYb/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758899283; c=relaxed/simple;
	bh=u1p0R4dEvuzmus8zTCDKERwPEzqyg2PrNuWbAzKS7dg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UEtiREOf312UIVCD/jpr24NHSO9W0szWFrq6MqfE0HpM69k7Cj2jijP3xY+frpMPbzunQ6Zb4FDu5oNcth9FNaF1WWel/dxyqURxWgimPUaqChfvwmFzZv+qb6x7DuTnomIrcaiUcRfSk4ZBsP1OtXVOthgn2/yb1Ne7yCYG5fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KWUM4mMJ; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KWUM4mMJ"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-78f75b0a058so17632366d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 26 Sep 2025 08:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758899280; x=1759504080; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DD8vJ1RHOj+3isIzImcUAfajjaY7qpmdVOOXfTyVV3A=;
        b=KWUM4mMJWZTWnBEguxs8qc4LP6StNiXuPT4taAjJeOtjopbMx3wkq8sowAiwsJJtK8
         bUvjKyFxVfXxIDrk/iS7Br5U0cwAeOIVmZLayNLM9ws2cmESW5jXoYO5uOVs5D2hOCQ/
         hL7G67rJoIIMk+pDhG+PqyCbfRlLa1sH3b9GHdTINtIiqoM42evanu9VDR4eIpkXDA2o
         KrLSNdYvO3nzF5oTS74CFDh63rbnwKMG44+2VvADQIIOQmj/SzPa1Y7Aujtc6isGjUMA
         LW4jIjAzG0SggHU86EOoH212USeuq/RVXgzlFvUbBsFdAlbfvg7BECbEkI/cTHCJw9E/
         DBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758899280; x=1759504080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DD8vJ1RHOj+3isIzImcUAfajjaY7qpmdVOOXfTyVV3A=;
        b=t5EUEZgAxp28S6phXESLlgwk7k4h2WfSoeapoCVd0dgz9bcKXmoBKBBNjwd/jcl8xT
         f4gbPqp1EUFnpMj0ODzGqPJdRplYeOd2Sh3vxqC0KNfeI8olIWN3f6mqtxjvK6Fzvhnf
         UP/UvNWR1xCil0V3sF3p74VodcncnTA6T4gvJ72IDsAHlm8Y62dRRZsoZTooelROelHq
         9ePU3eJ5DJ9r8btJ84W6vA/ddK+tHnj0aGDW3L6ra0IkIAJN5/RWX93qydJDZpUNhprR
         tKjv3l3O98NuvqXYPUVbojmDaO8OSZDNRf02dGIklydLREF2H1l12jz+Z4jvbRGsC+8G
         mi0Q==
X-Gm-Message-State: AOJu0YxL/yrg7sAfVR7svwZQAiBdHhigs6vfbrWXeQMInO33of8S7E+6
	qwCKg95NTBM5E0wQHTsx9Axym3yVPyKSseXuiGLFl5AlTh+dBxhttg3EczPs4mHpWLcWHiGvxLk
	UjN9i9eNZaMTEuKiESfKGqwHFTlsBNNqd4A==
X-Gm-Gg: ASbGncun9q8S/xRGQRU7YI9t1TyRxHrloqH2iEI72KFqP9zv3R+nDkp2yyTpKcsYnHO
	4JfR2cQz6fmEbqsqfmBqxYGarGF8U1wUVmjMqWrAvXbwn8YHAOjvWenAqdEsWzhshNo8ajCy4ic
	VIz3Voz4xQruN3yi+o5zLq6iQEhBaxdvFn5HcENUuKD0ZRtVqnipOOCDMds/w8Ee0QWuQQWwY6i
	McrA1XDRw3v9o6u40Yt3D2K/4kI/wAYxHVAtZbRPBAzDjKx4mgVEXVSIzW4kEWGNqmasi7IgHb2
	2EWhTbOTPRmBRrJ/lszzAxmhlEHof8t+Jjkb2q5A5/6qZ3uQzKGhpNnY7m0mQwl0FyfZW9Lysw/
	i+F9NxEWh5I4qlUfgl6tiVQ==
X-Google-Smtp-Source: AGHT+IFZHg+V839AvKcr8dIvh9PkPGgvgdHWN785Uu/HhCNHnIuiahcmepbkwsIuWBtGyNLBNViW9C633GswyIOpXiw=
X-Received: by 2002:a05:6214:2483:b0:820:9def:ab0f with SMTP id
 6a1803df08f44-8209defb493mr23068686d6.11.1758899279469; Fri, 26 Sep 2025
 08:07:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muDbZTXitjyMP3LWnAHvZwdLKk5OigR8_fH849jz2ukQg@mail.gmail.com>
 <CAH2r5mteYtF_Fq1dWi7k2DSLoQdk7gMsicvJpU+FjZbv+FgGZw@mail.gmail.com> <CAH2r5muO=HXkxAuEMt8LZgfr=9i=rd_mG3Hobapf8rVGgWLxSA@mail.gmail.com>
In-Reply-To: <CAH2r5muO=HXkxAuEMt8LZgfr=9i=rd_mG3Hobapf8rVGgWLxSA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 26 Sep 2025 10:07:45 -0500
X-Gm-Features: AS18NWBrbyo3ZKhxuC_fxB-6BqKq9o_1AF_Q10u-KXYKNO36Y6r-d6pPHHmGW7k
Message-ID: <CAH2r5mv0y=+G5=fnJ59EBzbCkErxsC4DtefjLxrRPXsZXvszhg@mail.gmail.com>
Subject: Re: Fix for xfstest generic/637 (dir lease not updating for newly
 created file on same client)
To: CIFS <linux-cifs@vger.kernel.org>, 
	Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Bharath spotted a missing line in the patch (and it does cause some
scenarios that he and I tried to fail) so will hold off on this till
next week and let Bharath update the fix

On Wed, Sep 24, 2025 at 10:15=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> The patch (which is in for-next/linux-next) does pass all of the
> 'expected buildbot' groups.
>
> Testing looks fine but if anyone sees a problem let me know
>
> On Mon, Sep 22, 2025 at 10:25=E2=80=AFPM Steve French <smfrench@gmail.com=
> wrote:
> >
> > Sorry about confusion - sent the wrong patch in the attachment.
> > Correct patch for this important problem is attached
> >
> >
> > On Mon, Sep 22, 2025 at 7:50=E2=80=AFPM Steve French <smfrench@gmail.co=
m> wrote:
> > >
> > > Am testing this potential fix for the dir lease caching issue now.
> > > See attached fix.  Additional testing and review would be very
> > > helpful.
> > >
> > >    smb client: fix dir lease bug with newly created file in cached di=
r
> > >
> > >     Test generic/637 spotted a problem with create of a new file in a
> > >     cached directory (by the same client) could cause cases where the
> > >     new file does not show up properly in ls on that client until the
> > >     lease times out.
> > >
> > >     Fixes: 037e1bae588e ("smb: client: use ParentLeaseKey in cifs_do_=
create")
> > >     Cc: stable@vger.kernel.org
> > >     Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
