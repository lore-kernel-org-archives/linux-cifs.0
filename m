Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083D2331208
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 16:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025166; cv=none; b=SPV0KiUOsWOK1l4DaODBBLvyybEKiUmyd4V5Q/HvEVTVBgDeaA18GoPfBOAelPZRotxn+V2YX1R62DBR3XLqANnzrtYDTYSD2R8EVTYy4UGYwUjybXs4Lmwur1YvZqIbOSu/+rpjlOsGH8RVNo4em4XvWgOClL8tcx3E6IpXGZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025166; c=relaxed/simple;
	bh=VNmia4qOjfsHgAIEBtVd9Pp7wWkP0TNsCSlA8ZZBsY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=KA+FHOadMlvG2EITO3AeN1gIebOX3UvLRP7O2IccnQtWMQJ/LoZcJCIuEJYr7DmzAAuS21mEztEHcL0gmePNi6g00iHA55fQRUcnFjHZkUFkXGA6H58DDv9Iq4lnOjTUiG4ywSee/7dhxBoJj2FAHrkVdG2VYM1LJNHwzGbD6LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8ONjXqD; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8ONjXqD"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-88a2b99d8c5so70200126d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 08:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767025164; x=1767629964; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NlO3S9xswOYajKhirUR4mGkzWkDUeqL4Rc0uKKnD8ug=;
        b=e8ONjXqD0R/kACufifr6SejoDIJNV7D1vjtjoMBIBUdbH4LA3CYMkQoCBYKFwRPyWx
         y/qSl2Aiu3dIoZXYS4uCZAbPsDREjE63i2YB4rnK3Lg5VJRTVD3inqw0fuRdtlfR7eUF
         DCK4jud1AHeYSbOe3X5JUXj1zW/BDLeSuctEGFyMnSOfigEFCUua0adAK5c6NiGKRhku
         Qan2HWOy3fd1KCWMJiahHG5l7UgkcvXd2k2fE7hg8gLzIupvDKVftOD40p5To1Ni28Hs
         XwzEqkmwGgCfqAeqE9sCPETVlP6h4Yvmd/HlLlaEgaQBmcdKnzD0zl5KCfiQpolPQSVz
         z+/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767025164; x=1767629964;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NlO3S9xswOYajKhirUR4mGkzWkDUeqL4Rc0uKKnD8ug=;
        b=U5qEJ3Y2CVPP9pWt+TTSsxwVajB/U0nuXwlG71fV9OPsjRU5QjGgI45O0lPlSXhBX3
         1/JrhKDPvWt5o4vqm6KyY3n5P06pT8MW0exI/pkqFIKWKup/Hqi4at6Mpc1mrZqAEyZQ
         /u+BP+aMBeLOpOLhWMmMJPFLVyg46RtkDQQbUd6DMFcBNIBvgFZ4TL0UG4pDSHXgQn3I
         j6eTDpE8BR9zyAPHIXr4ZgL0Wfr41YDKXIDkdBIWqxdq00dEYEbWMQ2NIXOxloV4eUW2
         UgbD0O73zD9gJXdztqQ5PLrVtRCRB9hgwrh9TQj5R3zjWCqAzaHy+0DStMP27kDIJnuL
         Sj8g==
X-Gm-Message-State: AOJu0Yyd4gSci7/o4Ex+XzqKVvk0+s6FhadEwu4EjkFzqra6PKpS14+Y
	TuLvV66fCZdKXcYEz3JHXrxzPkVQtJgaebuh68xH4hI6UJQtMb7WY8E+jnjAf5Wg7fm5JdAWTIo
	uA687xRmsIQIUyd1CtleJbsC/EU5HwT3Kxw==
X-Gm-Gg: AY/fxX6X7JDi0X1Qwx1KGNjU8vnrQgjLI03ejNVAZXsnZ5EOC93k1QAYEjyOLl1NENc
	9f/PwMvbySawEqVvcOtpx+AQcP5LSzTJOUwhk6do0BntegvwYqHV0e5Ny1Spa6RdTClqw3a6hyL
	8o7oJTOuHX+eTlHmDXTVugSmRQQoHmjPcJQa3Ww9Vn/3YJzgLfjfI4eb0hTQIxEcZi6LNg0D4hR
	pQHMWoiTvPyU9Me6pJtSk/G3hqRROd7vUAPpe1IXGTA6FT8lGpAOTGFEz54Qdf5a2b1bMCE36KV
	jlqjpfoK6c+rZQjIOVBj0pBiIRhOLx5Zlikyo9A/wk0253tKsleZHpdA25WPSsq+U9QrTMH6gOd
	rJXaaqM9U0JPyBh1Sz05teVMOeTuUkzl/WR+eTt6bGh6AkicNUDo=
X-Google-Smtp-Source: AGHT+IEaIAzX4QC6s5rce8634Syqgr/OYHBMLfdDmhuV4zPaTRIMVvEwOKvxTlTC4zatWkx2opXGfCdBWMzoVMnEl2k=
X-Received: by 2002:a05:6214:6212:b0:880:480c:6054 with SMTP id
 6a1803df08f44-88d81957188mr298435636d6.19.1767025163478; Mon, 29 Dec 2025
 08:19:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mt8+dgy+OH4=S8YxJoq_T70pO0n3Fd+xr8U_GXZ5G4jtQ@mail.gmail.com>
In-Reply-To: <CAH2r5mt8+dgy+OH4=S8YxJoq_T70pO0n3Fd+xr8U_GXZ5G4jtQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Dec 2025 10:19:12 -0600
X-Gm-Features: AQt7F2r477iQoeuv__PLbIxMVhecjLtwIaE0B5xcan_jh6ifbdVkQEG7v6JXTUg
Message-ID: <CAH2r5mtOW4o+6NPA9z_pZDH9-FA3WRLW56DLnvBeKzjvcdeg-g@mail.gmail.com>
Subject: Re: [PATCH] smb3 client: add missing tracepoint for unsupported ioctls
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

There was bug in patch (missing null check).  Will resend v2

On Sun, Dec 28, 2025 at 1:24=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> In debugging a recent problem with an xfstest, noticed that we weren't
> tracing cases where the ioctl was not supported.  Add dynamic tracepoint:
>     "trace-cmd record -e smb3_unsupported_ioctl"
> and then after running an app which calls unsupported ioctl,
> "trace-cmd show"would display e.g.
>       xfs_io-7289    [012] .....  1205.137765: smb3_unsupported_ioctl:
> xid=3D19 fid=3D0x4535bb84 ioctl cmd=3D0x801c581f
>
> See attached
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
