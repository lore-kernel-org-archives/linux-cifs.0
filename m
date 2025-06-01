Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B84197A7A
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 20:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748808840; cv=none; b=ReUTWrQEZ2CYZrNoM8b4h42+UEyB5PvM+EvyXBEjd++IeE8KxyGzxBrLIOqNGXlJtw5ufy1cxQmwxe6onIY9od+W7Z5HDvK8oBIFCx/h+47hjY3wpilVc2hDy6dzL4xtj61me15qV3zDujaVBk88x7Qz3H1zdY0nQGi+Zmvr9xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748808840; c=relaxed/simple;
	bh=o0z1W4ujPM52pooC5hlNfB5KfPxLthEpR82z8uZUH3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BvcpNS0RhyNBBnByeGHhRdRvugTp75sIuqcNrZcabPDqmGuZArYaUNWWrFCsRyjcFv03Tn9l/qnzebz/zzGaMATvxPaYN10aLTgXZq2G6CO2ViC6Ycu5+Gl6QIJwhTTYhbjjeV4wiBvCTHIHDQsvlXXJtLD+quARneZNBoyfyjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MprchEwO; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MprchEwO"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-32934448e8bso36648401fa.3
        for <linux-cifs@vger.kernel.org>; Sun, 01 Jun 2025 13:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748808837; x=1749413637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTJlW85qNH5CkCI0lFTdZGoyhQLe1AYCsUsIixz7t8U=;
        b=MprchEwOFJnGD5ssRAs63u9+urhrf9lgc2gkf2oh5koXjVN5QbNJrrTR7ihhjxV+bd
         Vg7mJZcVPvIVXGSqyPwrU7A5kdBbu6XI6X2xCVFI39EavKw/v1JJMPYKrTT/Ov4lwm0Y
         K36J4oQY7QdhFFdt+wXuEQqlVo3ZNxgOANQPWO4POwVP4GtTqRPOURfvx5QKp/trGJGY
         y5Cjc2P5hsniYYCtYxckTyLU3gimkintwVL8/xDGs7cUP3pKNu3nB1CEUcMPgIDQuRaH
         2H+GUA71k9r9ZG/s7lE051KA+OGXdQ1r2iNeBM5rCbuu+x++oC0AU5wXxE4r8NwxXBtI
         y14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748808837; x=1749413637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZTJlW85qNH5CkCI0lFTdZGoyhQLe1AYCsUsIixz7t8U=;
        b=ozHpKNtI20n5UHycy1zEjjzKvXE9cJffOO44aQhXb+G/h27rp1u4Lf/9U21LoOnFYc
         JHFyJAN0jMs6N0q/nCldwmtV8SMXjUtsUCBa1jnV6P2ndKJyXIxnDXv3EKp319Pu0uUb
         AsNpj5ESHIktEe2UI/AhWzpbZzKBk1g5jNGLS2eeB4KSoavGe3Gq7686YNHLZa9yVKLt
         vYiRM9vgKNtIumWJOEk4EOn6okg42ZQ+pOJnPQ1X5cM6BBCUkxPfKHkAOWBg63LEPe2m
         pM2WXBI2XXa2DPC6uJpHBKJRkC+F1wc3jPF7TNkj/hDoApmtK9b1ZE03sQfPeiufCXRG
         WKyA==
X-Forwarded-Encrypted: i=1; AJvYcCWfL8uzht+Cy2mlmiFDTI7mpmjYaRRGBndIi2D2dPUvTkynYCJ20PxIPmzqRQ+1cLgL8ue0fch5R9TE@vger.kernel.org
X-Gm-Message-State: AOJu0YyAeA2MnPkzkqQtxHNswSCXo4TXZK9Z8KUggSwJ8OZpNcXyc1GV
	xkdz3cRD3lzR09W+5m5y04CnGS8bJnsLC6XWv1q0pcU3GqGcLG/8Dw298z8g3sEY+f0XMNS4pVr
	0nD5MEzi1y1cJ3ds3WiBIg3NAsVcfC7bJbQ==
X-Gm-Gg: ASbGncvjYlidnzJ7Ap9wM5Yk/X0IwNMf7bjCuNUS60whorxiL1WTNHWSUtOWRvo1hzl
	RCjqIoqUkYKXFOvzhafj3EeGF/Dq/FHlLVduPnhPmGNPlifSp9cwPNuXujqTJbP+nhnUCk5C5zM
	cn847lJF1JIuAuXfJJJu+ZC5T8LsIsra/VrmhYhV4/8zyd7akHkZFUdjW849ggfr0ZSB1n+Sey2
	WVl
X-Google-Smtp-Source: AGHT+IGakqWpiQWcaG8I2t9Xaxggx4BxoH9CygWlFwbbdNTJewR13ywZJ5Ngl528BsqR8nH/NThHe28lBN9h25OTRjU=
X-Received: by 2002:a05:651c:b25:b0:32a:847c:a1c0 with SMTP id
 38308e7fff4ca-32a8cd2bc75mr36696341fa.6.1748808837029; Sun, 01 Jun 2025
 13:13:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250601171855.12268-1-devosruben6@gmail.com>
In-Reply-To: <20250601171855.12268-1-devosruben6@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 1 Jun 2025 15:13:45 -0500
X-Gm-Features: AX0GCFsyPF3ZKZrWRZ4KThAG5x4sszM2JJiLUyigC33DPLsIeEz9Jnqd_zzeUBM
Message-ID: <CAH2r5mvu0CeEaqYjUT43m6Vj=dQ81SMfAQduXT-Ca52D6uBacg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: add NULL check in automount_fullpath
To: Ruben Devos <devosruben6@gmail.com>
Cc: pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

good catch.  Added to cifs-2.6.git for-next, and added Cc: stable

On Sun, Jun 1, 2025 at 12:25=E2=80=AFPM Ruben Devos <devosruben6@gmail.com>=
 wrote:
>
> page is checked for null in __build_path_from_dentry_optional_prefix
> when tcon->origin_fullpath is not set. However, the check is missing when
> it is set.
> Add a check to prevent a potential NULL pointer dereference.
>
> Signed-off-by: Ruben Devos <devosruben6@gmail.com>
> ---
>  fs/smb/client/namespace.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/smb/client/namespace.c b/fs/smb/client/namespace.c
> index e3f9213131c4..a6655807c086 100644
> --- a/fs/smb/client/namespace.c
> +++ b/fs/smb/client/namespace.c
> @@ -146,6 +146,9 @@ static char *automount_fullpath(struct dentry *dentry=
, void *page)
>         }
>         spin_unlock(&tcon->tc_lock);
>
> +       if (unlikely(!page))
> +               return ERR_PTR(-ENOMEM);
> +
>         s =3D dentry_path_raw(dentry, page, PATH_MAX);
>         if (IS_ERR(s))
>                 return s;
> --
> 2.49.0
>
>


--=20
Thanks,

Steve
