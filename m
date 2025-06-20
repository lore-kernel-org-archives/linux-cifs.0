Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31D028DF36
	for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750431906; cv=none; b=RqIFRoVRA9t8Jaudl/Au9FdqjlV2juLGIapV0A3wWCDoyDpobONLE4TFc8Iv7Zc7mHskVXobEi9BaHDOPKpQXBMwuUv2qfT9ThioRN+lzWK1WgQ7cX5BcTIpNeljhqR4UmeMlkqDsPpu+vt1tmupXuHrwlM/wDRK24dzbod7k44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750431906; c=relaxed/simple;
	bh=hMKyN8fUaKvAs9BcB7MigaV/V9V2mr6/UtAD//h4ZB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SH0+ki4H5/fwA4r6HanzNPlBj/bxVgPQ+0oKd9fmJFN7uWN7Wgo55gS1Jkpz6BjE4lYZIbSCF8Q6rRdLHZbkOHhSkxPITh7Cxxr1wadKYmbkWSQYOGEpRRMQ7bUDM4JRXlxsRueqhz5F9LjrMMwY8B3Jsvk96YLjd+47BWzTLSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZCsj3cjC; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZCsj3cjC"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7113ac6d4b3so18314037b3.3
        for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 08:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750431904; x=1751036704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cvj7ZxtbL/VRU3g1nsxDhKdSd5nOzQLjVaNEspVGMZI=;
        b=ZCsj3cjCnldAsgEC1VHws5vW6zpWdm+G1w8+e8QkngNnfhqZE6ybmKIiNv5s/BSwxL
         lUlyAzLmkozPHo/ieQTg+g7Z5u02J5WuwtUEuost9HkcApapUkh0hUXRGLwmhaE0I/G5
         N5YNYmVGjm4fCmKcxlDKfmGg+COkRfE1Ludd4Ih4d3blNA+KhExhuDBet3eE+5iVhl3/
         VE4PDp4x/bb5plTKhorggURNPJzl2vhdmHJhmhSa4QcS8Bq3J9NIG9JZ8zMCsQF7lpEI
         KlPuCHq4eePCUIP2k3h9HSCgESuHfuSNdjRvCKN9oK8bCpLARkvlzG7BmU/gaXFU2J2r
         yzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750431904; x=1751036704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cvj7ZxtbL/VRU3g1nsxDhKdSd5nOzQLjVaNEspVGMZI=;
        b=vMAzAfNI/EYeYqcE7FnFILmoPs4nPXE3LmxQ6HSjpTkPgxQVEFhgDQ1JZ3mu7Yvttl
         pKXt9fkq/Kd6AGAr5g5f4g5gKjsDBx1u5584LRkrwWSUxcmAsJU9sneLJL1iKRED89KE
         Epw3BIn6CynBIuvlTT4L7bJ724NJjsKovuiycGAbmgycxRuog1BNwlPRwPZ+sGLevB+u
         9FF6R8uAPUvFkOMaJPJKaCEI52/sd9nfrVntYFiluGvMEqngvqaHvu0B96WhVzok08if
         NYGa0sTi1cHFWkEUf47aIbIK1CE6e2fadTniQ/FGa3l7L70f5lOEBd5ebWy3UCq8ObJ7
         sxRA==
X-Gm-Message-State: AOJu0Yx0QWdpQpzvUOZvajwnZKZPl+ipAen6+0JD6A30u5RVGx17Z7bz
	8u4iMMxyKqnhPoFtHloH5+8pZOlxx/8KNgmwLgzs5/CF5fQcVVXIO21cakGqzsnaZyIC+uujfh1
	K7duX/q9KOhX2QFvw/T3EhXIsGgLncFkyvfVV
X-Gm-Gg: ASbGncv2Wi10kiC55cqPMR6x7D4B0A6shZRqDshDWyW7RMEQoikjAdTefndB0LQMW20
	Cb852M7F9ZUc8CQ+FfcKywiBnlAKFvsTfM9lVa3TySCVHrEC4X0Z5y2p5EkMXZMskjRAAnc7d+H
	gB7zb0doHvy4e5vBwyk4+2g+2V1KVTBOee/TGgkmdgb3VJzg==
X-Google-Smtp-Source: AGHT+IFcyWP8D9w4GmG/QXreMmVs5J1mxAMhT7YGr9dhPc0xEGp2r15iqmGUIfXF2Iw0mu2de9smY94lXeeUkD1Jcp4=
X-Received: by 2002:a05:690c:6d09:b0:712:c295:d00d with SMTP id
 00721157ae682-712c63f1f0fmr46506237b3.14.1750431903708; Fri, 20 Jun 2025
 08:05:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
 <20250619153538.1600500-4-bharathsm@microsoft.com> <54184af46fa389c51312534fe05994b5@manguebit.org>
In-Reply-To: <54184af46fa389c51312534fe05994b5@manguebit.org>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Fri, 20 Jun 2025 08:04:52 -0700
X-Gm-Features: Ac12FXymU5jdTc3bU0FiUPP-NhzV7EVh-QRSwKlCjvvgcNi_2banipbpImAeCMs
Message-ID: <CAGypqWxF5goV6DDx-S3TqcrVRrn1TmaaMBhyRPktkP9LoAz+xA@mail.gmail.com>
Subject: Re: [PATCH 4/7] smb: add NULL check after kzalloc in cifsConvertToUTF16
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

makes sense. thanks. will update.


On Thu, Jun 19, 2025 at 9:24=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Bharath SM <bharathsm.hsk@gmail.com> writes:
>
> > Added a check to return -ENOMEM if kzalloc for wchar_to fails
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/smb/client/cifs_unicode.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.=
c
> > index 4cc6e0896fad..7bc2268d6881 100644
> > --- a/fs/smb/client/cifs_unicode.c
> > +++ b/fs/smb/client/cifs_unicode.c
> > @@ -466,6 +466,8 @@ cifsConvertToUTF16(__le16 *target, const char *sour=
ce, int srclen,
> >               return cifs_strtoUTF16(target, source, PATH_MAX, cp);
> >
> >       wchar_to =3D kzalloc(6, GFP_KERNEL);
> > +     if (wchar_to =3D=3D NULL)
> > +             return -ENOMEM;
>
> I wouldn't do that as there are several places that rely on
> cifsConvertToUTF16() returning >=3D 0 and some other places that don't
> even check its return value.
>
> What about having it defined as
>
>         wchar_t wchar_to[3] =3D {};
>
> and then getting rid of the memory allocation altogether?
