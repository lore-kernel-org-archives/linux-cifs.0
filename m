Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB69314D6F1
	for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 16:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714064140; cv=none; b=WxiwQgf/yfnwZPeXuUGezXZNhbWvLaUs6lIHDSlWLgQvgqQdtU+J8DpRr4n0Bqe30OtmriaPCQFTZlU1xDtrK01VePhxWGp8VHRIvNCz4sfnn9EWPqQpBn//oZtfdxdk24Oxc19iDWSZd9VEaLM1zN19X9+766Wr1VFQsyaAZEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714064140; c=relaxed/simple;
	bh=ddM1XLVS7dfMKPVIhBjVi1t0HNSc0C6sEOh9JsCuHV0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UQy1O9ez3aKTcMP8B1xeWs6llCz9a0aNc4W8JnWqNSOYMkFiOc4+bSzqwcx+TcMs7w22GxPtnsC+yV1qezvY4fpzyMMYYoLwklFLwAXAVePQ0L7P+DWqDZPOqNNOlIOHMeO+kyjuBillCyL/vHADvr3Q662YP+yGT22MVGZlD0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=klgjcuKv; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="klgjcuKv"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-51bae805c56so1423056e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 09:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714064137; x=1714668937; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrUMpO79Q1VW6ei2uvDYlSeCoQDW9KDdKO2FljciGMs=;
        b=klgjcuKvoNgmONJ9i/cp+92gEHZMfwjomhNcCo9A8JRUzKiI0wg10l4UKa+ABsM1O8
         Z6/d5oSqAYvG9QcvncQAuE6QkHSfUpiNuKF/PlOeYu5PividYa79ZlRmw+FIol4+XJ93
         xcRcX6rZmLwvLLEyfraK8+829KIqQjXp52JjLvEqUrQQcsJLv8yluv66txhF1w71kB+h
         anTBCN5x7Sq3VRQ6lzAJXsRwDB9u0GWrJqEi9RBcFH/hyMV0qYKPJwlxvRQkE5nDtodt
         Lvd2p0sU/v2eQWHVtkZ6/ylTrWvh7Y4rDFVUlMIDrPM0oKKLJqWfEYN+S9sFF7cCO8uN
         3cQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714064137; x=1714668937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zrUMpO79Q1VW6ei2uvDYlSeCoQDW9KDdKO2FljciGMs=;
        b=crBCdqOxdidZEYQgWOonwJa44ntCJX+0FfB5NoIgM9smvldP3b7BPgbISFw6DMUAfD
         FRyo2NuSajKoPokfHwKG2yJm+eNnBc4p5zNfyTm3Sis0DsOjm/EqPzNIZKzvqw2ZWuuv
         8pnTseimKlFmAn2tnvFgulmWzL7//B+lb3nXGpIP9nNoWKZjQugslBhf9Sy5aetpNs4u
         hra4yLEYP0+34OlEfNwsUODhQhXSNZChdsf3EKat+j+2DBhxVsq3A10Z9Z3Y4B0RQWAc
         AMo3v7eM4tZG3qV26hI0hUhuTsTkBi44/GuWLAxwO6TlB89Rphqgda/qiqsaYKb1eAH2
         0s4g==
X-Gm-Message-State: AOJu0YwtcYXrPw4kbSTxn++tUKs622wwseSvHYHNfhXW9gS+432QRHd0
	vzLrcgELG+L8grJmO05ZslrHa+aZlzqmj+sf3TgaGwYOjjYWjrCq9EUyz33O7jEDvDLqwPJ7onA
	Sbeaq32R3f7Qh02cBqkrlvh/0w5QxoA==
X-Google-Smtp-Source: AGHT+IF5FXdQ+S3YqlBd516KFx47zW38RnICYmg/qYDU09TGSaOOHYLJtrOKoAOlwGTElq66PzLSJczcsjHWBAqQu8Q=
X-Received: by 2002:a19:ca1b:0:b0:518:c959:8be with SMTP id
 a27-20020a19ca1b000000b00518c95908bemr4327645lfg.58.1714064136507; Thu, 25
 Apr 2024 09:55:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5ms2xmxgZ08pecifj+Za=_oWnrhVOUgifjYLnCw+Rz9_kA@mail.gmail.com>
In-Reply-To: <CAH2r5ms2xmxgZ08pecifj+Za=_oWnrhVOUgifjYLnCw+Rz9_kA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 25 Apr 2024 22:25:24 +0530
Message-ID: <CANT5p=oZ6xs6zWU_WUYc90LuNHPH88m33iS-vyw2tQSOuSb6OA@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] missing lock when picking channel
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 10:14=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Coverity spotted a place where we should have been holding the
> channel lock when accessing the ses channel index.
>
> Addresses-Coverity: 1582039 ("Data race condition (MISSING_LOCK)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/smb/client/transport.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 443b4b89431d..fc0ddc75abc9 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -1059,9 +1059,11 @@ struct TCP_Server_Info
> *cifs_pick_channel(struct cifs_ses *ses)
>   index =3D (uint)atomic_inc_return(&ses->chan_seq);
>   index %=3D ses->chan_count;
>   }
> +
> + server =3D ses->chans[index].server;
>   spin_unlock(&ses->chan_lock);
>
> - return ses->chans[index].server;
> + return server;
>  }
>
> --
> Thanks,
>
> Steve

Looks good to me.

--=20
Regards,
Shyam
