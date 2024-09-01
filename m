Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E51417C;
	Sun,  1 Sep 2024 04:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725165862; cv=none; b=Ww+bFNqQ7AEvenlkygmberJLEa1hVeUm5bSnfNPcgBpQdLBtoh1Atw7YZAEtINwCEsSduMd11EZnec4WJU/DaL4yWWe9IeJkDcIhApWUoIzxwqnd+TQfxIUvpYxtJhLs8raChOq+O1pvRr827PBlLSC7qnpQ65Z3ufTlSmaxw4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725165862; c=relaxed/simple;
	bh=ivcaVk0IgMnBKJNCllYhsKL3D3UylqSlvJWi+yiuiGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jt+in+mzWaykUIpJbFZRrxcOq438AYQnINsPgxrjs1obVG79WEvvadItRh+Bj27r4Uv0ifv6pHY6qJ9ynvgA4efLYXJnajO3yGpCZDTZsveDzkwk1gjHboT9gOGHwCMKAyrkuFWaywk6WZE/Yz6Cr6h+dT4BWEPWRcXr9332Wa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DNKEbIpc; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DNKEbIpc"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-533488ffaf7so4262394e87.0;
        Sat, 31 Aug 2024 21:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725165859; x=1725770659; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aBtRKRMQWYzKZO+mGYF6UE6dJWp8UJ4hAbPEjFtpHqo=;
        b=DNKEbIpcJsJQAYs7jAaFw2L0sE5pZhffxUkCjkypEP0C50wU0lXKK9jWc4Z6VAmWwI
         J7r0li3hF8Mfj2I5Vb+DNBFp7ubhVomzCBoPdQdYcb8RyTy6q0DbzIqcQFmxNiPCiZJG
         fjjHcHm+Vulb/LOKSPHI3Vy8jioH802srYOQ9q6dNCp/5pf6Y+AXqLYpGdtLchHssUQD
         v5hhJEJvTkYVsrbx5lAYWxh6Zqbhjy/74SZm3p+8/BRb4Do2l5Msu2HAb9V0lCCG80Ke
         GGijQKa+uZ1MEVWx8Hf8ZbwG91Xa4Hhc7xmx9fM4nv4ntiJ2cuizGT/hkCqfvOCUAns2
         dLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725165859; x=1725770659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aBtRKRMQWYzKZO+mGYF6UE6dJWp8UJ4hAbPEjFtpHqo=;
        b=rRcOKS+7TcjjmJiXWCnQoV2PuKo389bFyVSxePNOZxcWA+bdOnzUgv2C/Evjjmew6M
         lKkKwY+JalUq9Cl7W8S5HteYWUH8lwjg/fNC4BD0WAdphmsz8kF0HLyTtAEbrrzA2rIY
         m1Y8iCs8hukTfdpeWXd9llARf/BxIddyOMLxVJwl/gTMShMMxcBINSm2xedyNY5ReB8c
         6U5ZctWJWulGbbWrDny3gU4VrWr3mLYjkVrQMCechB+eAHkK60gJijWVkjGV3c+1fY5f
         UNmPc4wrVgoujAJIe6aQF2kN6qBhKMoGhqFDLEG9JwvHWKejmGSvGldc6NvlZKiQcxZ8
         /R3w==
X-Forwarded-Encrypted: i=1; AJvYcCVQtaYK8eg+WoY6mPL+OCjzximXKUZBqB7Ea6A1PymHe3JggG5J5cOjt+r49SpWVYmSCDdoyO/TVS8m@vger.kernel.org, AJvYcCWqst7nVByLAlSNl9OqIm/AyqL8DJVfOwrXL9Zm0Iqvn8QZfCzhnl2J1LSrh45cT6jLTofdFzEDa8KYfije@vger.kernel.org
X-Gm-Message-State: AOJu0YxooAF2sxFqhEmuSiAVHXTcen2+z66TBj/dTzm49CFHJ3YuUcXh
	vr+HIQDKiyqB42QN3OoJTpxuHDC49dVvvrQSxTqLD/hTRuF2OzeY+KbeMlBQFZqJRzwYI4GLcCa
	h5neTB6NTMRHtp7BcsDxFLpJjBi0=
X-Google-Smtp-Source: AGHT+IFPecv30WQWJ10cN57Q/RGQoGMicgHiKPf3/lUr3fyGdydhdb5QraimYObk1KPkSWRX5zbkHO34p/i+7q/WlTY=
X-Received: by 2002:a05:6512:3ba5:b0:530:ad8b:de11 with SMTP id
 2adb3069b0e04-53546afd8dfmr3791376e87.9.1725165858324; Sat, 31 Aug 2024
 21:44:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829115241.3204608-1-liyuesong@vivo.com>
In-Reply-To: <20240829115241.3204608-1-liyuesong@vivo.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 31 Aug 2024 23:44:07 -0500
Message-ID: <CAH2r5mtBGfU-UFmzJv4YKPKQ==Zs+r6j2TG1m_uzAJm2GJJguQ@mail.gmail.com>
Subject: Re: [PATCH v1] cifs: convert to use ERR_CAST()
To: Yuesong Li <liyuesong@vivo.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged to cifs-2.6.git for-next-next (target for 6.12-rc)
pending additional review and testing

On Thu, Aug 29, 2024 at 6:53=E2=80=AFAM Yuesong Li <liyuesong@vivo.com> wro=
te:
>
> Use ERR_CAST() as it is designed for casting an error pointer to
> another type.
>
> This macro uses the __force and __must_check modifiers, which are used
> to tell the compiler to check for errors where this macro is used.
>
> Signed-off-by: Yuesong Li <liyuesong@vivo.com>
> ---
>  fs/smb/client/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index c1c14274930a..c51b536aa9ad 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -4069,7 +4069,7 @@ __cifs_construct_tcon(struct cifs_sb_info *cifs_sb,=
 kuid_t fsuid)
>
>         ses =3D cifs_get_smb_ses(master_tcon->ses->server, ctx);
>         if (IS_ERR(ses)) {
> -               tcon =3D (struct cifs_tcon *)ses;
> +               tcon =3D ERR_CAST(ses);
>                 cifs_put_tcp_session(master_tcon->ses->server, 0);
>                 goto out;
>         }
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
