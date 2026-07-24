Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF8131985D
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784913156; cv=pass; b=jDSXyJ1ed1/lqbGA6r+8WkR3xOoZ14UOMuquVoEtAGYdLq1yZ9rK+jAbZ7Aq0OOjnSgv6JHnou438hharEbvWEN29F2Ute5ZSyqnKsZwRNv7M91WKLj5Z2sLaEzWm7TyGybIpE42ic39KjMAEM+waUYCs3Szvkjvz0t49X3NwAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784913156; c=relaxed/simple;
	bh=tkMusmPT7/O6qhj23/Uf/qaf1cUXx6bJc0lU5+kqB5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jTQBlcO7bsBoiF/nkDow9HyEXaB/W/JnTl9T+aQ1IFX0QKFkTyCQyHy50TTfYsEfxUpC60QKITnNhIQHWk1BbZBvkALSvAt6SaVYP47TYekTEe1fxd+klHyRJidIdIfEqcIZi4RK3hwXCzIZfGOBV7xlqCHJMoIQTwcAngbVFw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=htoTJAIM; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="htoTJAIM"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7dbcb505578so6609717b3.3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:12:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784913153; cv=none;
        d=google.com; s=arc-20260327;
        b=YmcVUQDbknv1jpfBumtHQI7w6VKlGt5R45VKBw5TlGe4l24yguAEzVqTaYPMviOkP2
         kM0dQUMO24uBfUdUzlOZTQu7/HR2QxCPdPaupsHXy5n/Mgu/CCTleb2ZHIOqQ+7c3YBj
         eflxpiENA4yvFC6A0KfHR4LGF4IVbtzA7YaOobroWCX8u8upk1eDVJBiFjMhKuISEmZP
         wIq8cMzX2+WlsDoKR5YtxMuCMAdGf+f6JTkrky8ENhNgWyKtY9ifvxRz8c5lE1v8m+hp
         yGZRyzN95O11kB1v5hPrpaXnzYlO/tK1A9z94a8YG/NcO0pxhuPhyvcG3KnwDqRcsp1L
         aPrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z3kTxhXUJAqu6YeMO4jBR/UMewULQEc8nT5/sQMj3Ec=;
        fh=toCeSbUJ7pJaw1na3Gzq6Q4gZ+nB6JQBVCXMBD6SyJ8=;
        b=oy5fcoJhkxNjxEtg+4uIFSJ6hXOW5WnhThOu3UwpxkU4cqPFmHVzJgkPZhR+ilcmCG
         QX6k4CxZLA1m87FQVBE/0uic65e9PvaUONjkdxk7leTX4KQpotIF2Hjt37HL2K6KmcFO
         RAiAgX56hMqEqRJqCA0s2h4cYZxuy79exMvLuDTqCIv0dURkbrfceC4lgMzlKuartG5+
         RycOXwkOf7M5fDeLuu7hEkW1erxa6I6wY5bNS1/i+3xJRi/rnk0N4z+MrXfOJcfF6c28
         7HJo+8pP9HX5WxYkz0I5kVjUoVFLDToXFGK8FOn4T+Mt0OBXkUGZxSIcR//MALZZMIV1
         6NrQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784913153; x=1785517953; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z3kTxhXUJAqu6YeMO4jBR/UMewULQEc8nT5/sQMj3Ec=;
        b=htoTJAIM0XSROkRL72hprAe+ylVwxJygFB8MgmWFPUJHsYWj+b8BypS1QSBeVE2S1X
         3JfOvGX/4gzOoYtxbIZYXkU0ik/CdFZlUjVApUExJoSXdBPgV1hE4GCSkEKeWGyysghH
         6f64orYHf1UI1htpD1wfm2kiaUQcABLwu9LiRO3TQB5u5v76z/MyUd1wxNnKwIO4ksW7
         VmmmxMVSUcfX8tIhhEGACKq3MKtleHfj72yW5RbAjAHdLxXx577w4d/k2CX1K6Su3go9
         DV+Jw9kwTBZIhcWBrfLpdHnrnrZ3cwekl2ONbDO2xu3041wu+MTGgOLRghL36jdeBM21
         Q5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784913153; x=1785517953;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z3kTxhXUJAqu6YeMO4jBR/UMewULQEc8nT5/sQMj3Ec=;
        b=k8Kqyer/YPA34OsD/tyAoTf2l9idZJ69+jYtzcAGf+WIDNB6/wJ8L58JtHptdSdT/4
         Ww7GERu2+j677+V6pjDbH2PxK6Kw+ahvY1AERh7pCA6huWitxHTrTvT0QsjKaBd2l41r
         8elTzRSe7pkS5FgrMBeA5jl1Ls+qylehC4TzSVngJDMjaTcul0wQo2XuwZ8Y6YCnkfro
         0keaHwKxzyrcW9YUhI2ugwjnRCyi6HNb//DugaOL6DXIaKRlTuvcWWtEfF9ROchxcZ79
         wE50mVXSqmGR7kLOCyuDYln8S0BBFoDgmrxFudW6pwAwmO8BZ9Kf10kR6wwiGalnyY92
         95ug==
X-Forwarded-Encrypted: i=1; AHgh+RrHFWug7Bii8gcLybPNdsMF2xtR8w9DjPnJ0te8MbBz0L1QJ5pKNl+HoZNWfe21FUCGHIi7r6DtF0+4@vger.kernel.org
X-Gm-Message-State: AOJu0YwHXeMTO2GprkNqEmDcjVcpkuHH3FWkMMLE9ZZ4kaHFizgMUL4e
	n7JSPZ8nSov0zdSpFdBo0rlYhwMA/uGpuU4wSgle55z0CaWtuJgcmui2YUU/AuJTmzNT8Igcgsu
	ZryQrMCYxAF/7V+yVQBNZS6xRgglVU7U=
X-Gm-Gg: AR+sD12QJiMLtIL8T3zI/uJuE8ewbXF7x8ef2FCR+u/rf0PGR1aDmLPWZnYg1MEPzp0
	Ou2e26r9hklU+4uD0C81TjBGIj9euoWzxXbv/CyFUIZZeFqM0Lyw6Y7hc6ACaYQ0sk6zMIZYp79
	LaAeCUq9WeY9s9aD8QRZquib/quM1JuSbUGajqHVLuGVL3mh5heQMwRCYpTTbgeDUj2gH5IA5Hp
	Pz5yxqH8DC2I3etGjY5ALfWoBbqD9Ca5K2qQFnssgPKDKctn1bOgAGkC8Y=
X-Received: by 2002:a05:690c:6308:b0:81e:742c:8c41 with SMTP id
 00721157ae682-81f4c31be28mr30534647b3.56.1784913153292; Fri, 24 Jul 2026
 10:12:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
 <20260723184538.3888637-35-ekffu200098@gmail.com> <CAH2r5muT20HXUANLnXQc1dAAvs+N=jFneSsV9gUqS8GE-wWNPQ@mail.gmail.com>
In-Reply-To: <CAH2r5muT20HXUANLnXQc1dAAvs+N=jFneSsV9gUqS8GE-wWNPQ@mail.gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sat, 25 Jul 2026 02:12:22 +0900
X-Gm-Features: AUfX_mzuE8BIzTW71YBPHhbDBNC6znqF4qg4uLZzc1eHBFxwXGo8wazgEbSQ4ag
Message-ID: <CABFDxMH=1M2m8tyyHZHwpJ9OUmMRBCftfq2SiMxTyKUr7a9FNA@mail.gmail.com>
Subject: Re: [PATCH 34/36] smb: client: remove conditional return with no effect
To: Steve French <smfrench@gmail.com>
Cc: Julia.Lawall@inria.fr, Steve French <sfrench@samba.org>, cocci@inria.fr, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, samba-technical@lists.samba.org, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Fri, Jul 24, 2026 at 5:27=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> You can add my Reviewed-by if it is not going through my tree.
>
> Which tree do you want this changeset to go through?

I don't have a strong preference. But some patches in this series have
already been picked up by their subsystem trees, and I'm planning to
send v2 that fixes several issues and addresses feedback.

So could you take this patch through the cifs tree? Then I will
happily drop this patch from v2.

> On Thu, Jul 23, 2026 at 2:04=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail=
.com> wrote:
> >
> > Both branches of the check return the same value, so the check has
> > no effect. Remove it and return the value directly.
> >
> > This is the result of running the Coccinelle script from
> > scripts/coccinelle/misc/cond_return_no_effect.cocci.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> >  fs/smb/client/smb1maperror.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.=
c
> > index ab3d09613c91..395299f9121b 100644
> > --- a/fs/smb/client/smb1maperror.c
> > +++ b/fs/smb/client/smb1maperror.c
> > @@ -234,11 +234,7 @@ int __init smb1_init_maperror(void)
> >         if (rc)
> >                 return rc;
> >
> > -       rc =3D mapping_table_ERRSRV_is_sorted();
> > -       if (rc)
> > -               return rc;
> > -
> > -       return rc;
> > +       return mapping_table_ERRSRV_is_sorted();
> >  }
> >
> >  #if IS_ENABLED(CONFIG_SMB1_KUNIT_TESTS)
> > --
> > 2.43.0
> >
> >
>
>
> --
> Thanks,
>
> Steve

Thanks for reviewing.

Best Regards,
Sang-Heon Jeon
