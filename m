Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF312F1FE9
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 23:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764115102; cv=none; b=tOYMfU0a391PYyrHcjyX30TAmq1h600MWqLVQ92zHaIsGwcS0JbJeWR7UuVPcA/Ns4D/Z9CAYAA4eSb4ExgcjsZCsitobAMDK3udVUwPp/5j+mhj6NSQoN2LAutgdQ2ii1zOcxyuJqyTouEcvgG2eEhUpeOK6X1oTbSp3TmNiCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764115102; c=relaxed/simple;
	bh=0Cp18DFXXEgdm7bt/WRHygN61Nk5btD3pIICkvmHQEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hTjwHxubtfBM1FTmf63y/Is7fzKsUefk+NW3Lg9kZ2WCMW/MsGzZcG7iLVwEVOXOfWeIQsLBiHw1dV9hRNE1SqOr+Lc33cIyqGCcUbfNvPyqkzq52mQZY7BnjL7YKE3TQef5S/FB5edg+LtEmQ5PDTTUQG9aI9A8t4xFx/k4G64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X6V2o73u; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X6V2o73u"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-88242fc32c9so71871706d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 15:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764115099; x=1764719899; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QXYNc/4laOM0Q97PY3J4KL3e2qPiUiGanCOWZDiW1kQ=;
        b=X6V2o73u5xyVdUKmUPK1zyo9m/INSv4RyVRNNyBae4g4fdBcLm/VC3TFNd54uDZBYX
         yYNEDUqpu7HKHQz6iLPAjtLsIWccb2KFtUyAjv4wDev3Inl6UY1YG8yd8P2QPHkXK/Zf
         GV/GJHsE2nG2zp2k/t9xXDREI0sUu75P898uPGWTdbBswKvN8KIrPDSgUTlUuMRYJ6yq
         rDbVf1WEkrA6iKJ0IwC64EnOsGTWZgBs0S92U+psghFFkBaLF1/d8Z8heYdhmJ5dwRHa
         jSgGW1Fwcd36dZBwC8XxqaQWQ0r0XrfGVZmc8kcVfmh+U74SMl6UymN8duJvtF5U3T8j
         AaUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764115099; x=1764719899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QXYNc/4laOM0Q97PY3J4KL3e2qPiUiGanCOWZDiW1kQ=;
        b=ftOzGPw8OTcXCh60vCGnMBxJ5A44KurTk2TNBS45SuGVyeZwf97btiLUQvJzN0BlAf
         2a7/VgH/wHxn6vR/mDE1rKEQa4rZhcBLDD4luLQUcuqDUTkKyb+gAHNkRm+R77RGETnd
         NWheLa2oClFzBGpPYqZiJJ/MQmgMuOFEZ0nqoKocqUhPzJfvMqLF4psHo8blsK5bSvoP
         OU8YABrUwfGiWy0ex97c91G6vWu39+NRq8i2O0y9kjnrne9btBtUU3VeAYTASk36I6Tw
         E4ZMVDpSX2uAhGdTkFTKAh3We1H7F0gOtqaeTDqIWOTB60pjoGc7OezT91K74LN90A0D
         U2jw==
X-Forwarded-Encrypted: i=1; AJvYcCX557pJriUt+SgGA6ufXEOXqIQzJKLUgkC1PmA9a8OZPLw2KobFHeSrvi57NI2yVkc8IaHnqzo3Zb+o@vger.kernel.org
X-Gm-Message-State: AOJu0YyCFVqZSZ8GKrm9z32whbOol8lvFvMoy2xeY10lTBKtjL4T5rtl
	vIpiXp0Bssfw4NSu1PkfUiAwMdUO1Msgu/xoC7ALTkebbi8qBc5kPuz9Q9oA8492nRiJ9oW/s/N
	Jf+PUgftRK2H4T6yco9QcK1uWZ2DHR6U=
X-Gm-Gg: ASbGncs7ePUweDJhSqRn/CROfixK9i3RUh1WlhMZCubKtqBWShDK1hhub26A5DY80aK
	jDFxM79u7ZQJq+CV/+MLnd+tyD6nhZXTS0Y5IRQ4v4RWFoSEN6IuCHzSgMlauljQnFtqQam4bk2
	jRbm1HI+1wM6+z5mp9vYi43egXKBXc0R44h13esCGsh/Hz5+NGzULKMVyEj+G5CWZshmfMhGfmg
	XPPf8TxDQI5dFyAQwDjOI26T49/W9Xfjd1KOtxwaD4Rum4/+SxfbCrYU6m97zt4PABOyzcJQ/bL
	wevPBg1N9ux6RORuJOJtH+KUlrtORBzOhsMyYKctSWwTj8mCAvtEA5OSSQ+D9cGEm8m1h2MD0Vt
	k23qkZBgSTb5FwtEZLMhc6sE4wYgTkOxoKprRARnIKAcGHNkEJP/b9IKlId31mQwrQ+2U/2pO5j
	3wch2gI7b+8Q==
X-Google-Smtp-Source: AGHT+IEPm4UOPjCmHNwcCFtz5kGdNpGHq9s2u6MTXL8/uO5hPvCs0suCKcEGIdT1obINcZkbVe0yMSQVoKLxYJVvflc=
X-Received: by 2002:a05:6214:3d8a:b0:880:4c68:f24c with SMTP id
 6a1803df08f44-8847c4880bbmr251839726d6.11.1764115099470; Tue, 25 Nov 2025
 15:58:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251125205829.1709717-1-pc@manguebit.org>
In-Reply-To: <20251125205829.1709717-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 25 Nov 2025 17:58:08 -0600
X-Gm-Features: AWmQ_bkQHdMLP4tnqgA7rEvpNL4rqfRp0ENrACip2zggxfg0JNMXh9zJ-Lef2dE
Message-ID: <CAH2r5mvb6O6bj0uecpViGC1k_sxXYk9QR6t-OUYFUMc1FnrGow@mail.gmail.com>
Subject: Re: [PATCH] docs: update echo_interval description
To: Paulo Alcantara <pc@manguebit.org>
Cc: piastryyy@gmail.com, Alexandros Panagiotou <apanagio@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added to cifs-utils for-next

On Tue, Nov 25, 2025 at 2:58=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> It is '3 * echo_interval' since upstream commit f2caf901c1b7 ("cifs:
> Fix a race condition with cifs_echo_request").
>
> Reported-by: Alexandros Panagiotou <apanagio@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  mount.cifs.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index d4890706a0fe..4b6d47447c0e 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -483,8 +483,8 @@ echo_interval=3Dn
>    sets the interval at which echo requests are sent to the server on an
>    idling connection. This setting also affects the time required for a
>    connection to an unresponsive server to timeout. Here n is the echo
> -  interval in seconds. The reconnection happens at twice the value of th=
e
> -  echo_interval set for an unresponsive server.
> +  interval in seconds. The reconnection happens at three times the
> +  value of the echo_interval set for an unresponsive server.
>    If this option is not given then the default value of 60 seconds is us=
ed.
>    The minimum tunable value is 1 second and maximum can go up to 600 sec=
onds.
>
> --
> 2.51.1
>


--=20
Thanks,

Steve
