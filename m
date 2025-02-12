Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38797134A8;
	Wed, 12 Feb 2025 20:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739392544; cv=none; b=H0EAlbEFrOA5tOSkgrm2gvpEOE1IHLj6eW4+LRn7FS4LH5pMaYR6VMtknxQyV3BDcI7JFTeXKRmfbHphS9KqgmfZEwAFNSZVMJIWFWsCBl8YTrazN3OoyiI616bzNM9std3LIcw8vmn4xncEJbpaZiM17KZwysZpstAXgIR6JS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739392544; c=relaxed/simple;
	bh=m3fSLrs8RwTeycQL/yS8zwR0LdKMfmutI4GsL4BAGbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FeB62XxudMMx0Ljxf30mtin9jwZGy0Po6GODW57t6IUnfMc0O+rg+2LdvClgSMhoHZPh+FO90eA3qppulZvIEEKJYOFvyc8fbZ3DqS4Axfzu+qH7PoJriU7Sf7vdfA1Z93aKgvZ+CHwOh18kUjAcrPONWGGgpqGtw6vi+aRurDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=agGalzwQ; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="agGalzwQ"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5450f38393aso73156e87.0;
        Wed, 12 Feb 2025 12:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739392540; x=1739997340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOlyctz2EGvuteVNgI+DOj0oV4+D7fwYRa1j2XIcfNc=;
        b=agGalzwQFJkwsH3x3xMy2o9HC1gRRPDM3CNCZjbygSJ5LFfodKYwuhQ4+zidS6OVgu
         LaBM9XjqTl3DAN1oXFVsg0Mav65a5dH95EaBZkWYJ7w8K7qB8PmmVEMhb+Kb3+pwsK1q
         8ofbxmnlo2G8yiA4Df8QMXmr85yySeQ11Mnp9fWn+4PEtEEyv9ll++++WtAM6dQ5InOU
         mpgHsssheVstEbwKh7exyLStw/RKtEJul5wL3ic9c3uqvaZIeLhaxqSvBhodfZAnUg6P
         wg9g2tk100Co2xzxrq4KaAlaE/pa926T2AKilSsZthuSSOeYGFKoptzBXUEdCrT6/TD4
         G9Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739392540; x=1739997340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KOlyctz2EGvuteVNgI+DOj0oV4+D7fwYRa1j2XIcfNc=;
        b=ds3TqeMdziT3q6CFhBmnMqmjVS3gjbVNHxY3vX6zJ/9cO+V5MzWKukSPZfvHw/MYuM
         VSJmKwV2hzp169GXtEAG9nFWzVnEsU50WKaixS8zGy6+qh9u8vOibDclMeLOjTjOmFr3
         QKvVBtOruIsJB2kR0B0RNl99iNxuX4NvjM6HtphZ9gY+l5JdQDcZuXPYYpW538LS/tsL
         t+NP49TnfJYZDqCCi93Lhue5HxoEC3DdwawLYz59tKL63OEDGAdKIsT3U/CAn7cTGCpI
         MV45l2BdN84pNkzNgldL63aOSPNUdoS05YAREaAD9b+gxtSLcZOkwF/dp1L8uFE2EC+e
         8qtA==
X-Forwarded-Encrypted: i=1; AJvYcCUa9N8p5QXhbUcMp5+PgFfatQ8E7fHB8ucf4zxOxXjRBKGewSHHlTl9TBqDMPhVUgXpGRXxapc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWUiZr9jq2TE16LI2fLmyJOhNyqQKEzrIWIp5ZUaBu6mcFWrsk
	7wic9N1IPNDDvk9fRg/HzjbM7k8wwhwn0qeQDKs+yzDSIpMOUw/Zi1kV3pliJGk14bi7bYn3eIm
	9F1dQcCAyzYnCgrC47auk2rTApfk=
X-Gm-Gg: ASbGncu05uMKQzdf34r4EDZAWN1b4Li+FzTRCLc7dwg5PHT+dMJ7qrd1ucMsJ5o7Ng/
	Mm7GXSApHFXAY2IrVQJm36jfv0uWDyfjELgZ00ZgQgyK8Dd2DSL1hDIAKrKXb36L4G1lvFQEoBA
	==
X-Google-Smtp-Source: AGHT+IFZTsIUwQQj/o2a13UQOeNCyuQkKukbW3ljCaZATn9oPt0/nKLvJha06/abaaebuj29iscOoN5W1tgymjejgjU=
X-Received: by 2002:ac2:4e05:0:b0:545:aaf:13f5 with SMTP id
 2adb3069b0e04-545184a3aa5mr1636607e87.37.1739392539951; Wed, 12 Feb 2025
 12:35:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212073440.12538-1-sprasad@microsoft.com>
In-Reply-To: <20250212073440.12538-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 12 Feb 2025 14:35:27 -0600
X-Gm-Features: AWEUYZmbbLBi0xo7rSe-aBd_dDmdlPLbJKvrX_yDK96Q0OtS8SExk0NpP-MFV_U
Message-ID: <CAH2r5mtOoCrMwo=O+9XxcSuis2GH_Qo2fXhmXd2EyWGKtoBcMA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: deal with the channel loading lag while picking channels
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending more reviews and test=
ing

On Wed, Feb 12, 2025 at 1:35=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Our current approach to select a channel for sending requests is this:
> 1. iterate all channels to find the min and max queue depth
> 2. if min and max are not the same, pick the channel with min depth
> 3. if min and max are same, round robin, as all channels are equally load=
ed
>
> The problem with this approach is that there's a lag between selecting
> a channel and sending the request (that increases the queue depth on the =
channel).
> While these numbers will eventually catch up, there could be a skew in th=
e
> channel usage, depending on the application's I/O parallelism and the ser=
ver's
> speed of handling requests.
>
> With sufficient parallelism, this lag can artificially increase the queue=
 depth,
> thereby impacting the performance negatively.
>
> This change will change the step 1 above to start the iteration from the =
last
> selected channel. This is to reduce the skew in channel usage even in the=
 presence
> of this lag.
>
> Fixes: ea90708d3cf3 ("cifs: use the least loaded channel for sending requ=
ests")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/transport.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 0dc80959ce48..e2fbf8b18eb2 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -1015,14 +1015,16 @@ struct TCP_Server_Info *cifs_pick_channel(struct =
cifs_ses *ses)
>         uint index =3D 0;
>         unsigned int min_in_flight =3D UINT_MAX, max_in_flight =3D 0;
>         struct TCP_Server_Info *server =3D NULL;
> -       int i;
> +       int i, start, cur;
>
>         if (!ses)
>                 return NULL;
>
>         spin_lock(&ses->chan_lock);
> +       start =3D atomic_inc_return(&ses->chan_seq);
>         for (i =3D 0; i < ses->chan_count; i++) {
> -               server =3D ses->chans[i].server;
> +               cur =3D (start + i) % ses->chan_count;
> +               server =3D ses->chans[cur].server;
>                 if (!server || server->terminate)
>                         continue;
>
> @@ -1039,17 +1041,15 @@ struct TCP_Server_Info *cifs_pick_channel(struct =
cifs_ses *ses)
>                  */
>                 if (server->in_flight < min_in_flight) {
>                         min_in_flight =3D server->in_flight;
> -                       index =3D i;
> +                       index =3D cur;
>                 }
>                 if (server->in_flight > max_in_flight)
>                         max_in_flight =3D server->in_flight;
>         }
>
>         /* if all channels are equally loaded, fall back to round-robin *=
/
> -       if (min_in_flight =3D=3D max_in_flight) {
> -               index =3D (uint)atomic_inc_return(&ses->chan_seq);
> -               index %=3D ses->chan_count;
> -       }
> +       if (min_in_flight =3D=3D max_in_flight)
> +               index =3D (uint)start % ses->chan_count;
>
>         server =3D ses->chans[index].server;
>         spin_unlock(&ses->chan_lock);
> --
> 2.43.0
>


--=20
Thanks,

Steve
