Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DBE379EC8
	for <linux-cifs@vger.kernel.org>; Wed,  8 Apr 2026 13:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775655394; cv=pass; b=lmqFbq6DS3pwSqzd825qRt9addyM9nZrxKEhQAiYhkAKNpI0We/ti6WckFPMMsB/11d2nT0jnVQd99YyfDy/q04wbbhACUBm4Yl3KIFZhEl3FwrvQ7Y/MbnNblpTHOCBq3YlTQYI5VUWfIA6W9VJdR8ZLHbxAyPc+bIog9dqWxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775655394; c=relaxed/simple;
	bh=/s5gC8HSy8UeBeq4WIizO3FYh2VzesouJUuu1FGt66Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PGkaTS/mdqzqrBThAZbAShahunj1E3D1xJxkP5U8j8n4rFGG4SiPhfnIKARuJF3vbUEGwNwu5ZE4F2njFZfrD/luJJ2FOJiVoXgJ9ICZYUwCgvFJHwp/yLdcS8wphnF1rSExpu4nxGoCKGRhj9uXKB4fNHRWjdbE34UPVFiT3ak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pwno.io; spf=pass smtp.mailfrom=pwno.io; dkim=pass (2048-bit key) header.d=pwno-io.20251104.gappssmtp.com header.i=@pwno-io.20251104.gappssmtp.com header.b=vZSB3F3F; arc=pass smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pwno.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwno.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pwno-io.20251104.gappssmtp.com header.i=@pwno-io.20251104.gappssmtp.com header.b="vZSB3F3F"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2c54c68db4dso12125071eec.0
        for <linux-cifs@vger.kernel.org>; Wed, 08 Apr 2026 06:36:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775655392; cv=none;
        d=google.com; s=arc-20240605;
        b=OddrVFXcgRya6Dr2H9zozBWLHg6YmDu8KR2cRnSubuNk0Rlav2TWJk3+OqY66Nooos
         dY1mUQfid+vJWhDhNX7xMQ7zs++em2gcxWUrr4abwI73O6At3OuLQtQ6m2WWu1RPRNi2
         aIF+4hEgo6GbykHuWCu2fE7aUe5wDd95YgAvpxWRAj7ON0DufAGhnd56IuzivSShAJI1
         zVjTBfWkIqASapL7oeoXmcDpACt6mzgeW2vEl46wgLezhIEVwhaCKnIy+bFOSzAtLlHl
         FHtxgkmSeekho659/wJUNEu0sar/qSLw0YWxqg3lVEwXTAxgfDDr76QjwBFTjOYDJ8XV
         pkRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TT/XNxxFiSMJvri2UCR+//5EQ4kSR43N5t6IvbUFsnQ=;
        fh=htuDZNONgJ0rk7wYg0Z4XPF3hWBG5lMmwGnLNfL7v50=;
        b=TpEDtSa9XyZBMPhsevS8aEpbBbH22ELvkuC9Ht+jE0vZwfaJZThI7sU+vAejfRaDB1
         4kRpeNoR2UHpbQkRfsdRg9ZXyMlZ+CGuFXuXx99/qg9eCELX0qy6vM7sp14VKmMgb4oN
         aXqROf5awYO8xdIRisFFnKDuB/TLVpfXsG2z4Ttka/3UF5V0C01If/aSSycTAfUy9hc2
         K0Z39MII2eOP0dONZE23rA6MhWeWQQSHI3wFvrBjaXlvrohgZd77PLWlRVVEOP9qmXiJ
         ohk2stLkEdOMQqYa6xg+sJz6qMbu06aYm63/5NJ/3snoVpPqNszclNX+b2pb9QZmVr0W
         tJ/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pwno-io.20251104.gappssmtp.com; s=20251104; t=1775655392; x=1776260192; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TT/XNxxFiSMJvri2UCR+//5EQ4kSR43N5t6IvbUFsnQ=;
        b=vZSB3F3FJktmt7f+OOwvWe3YV8WCLPb/0njyiU44hX4Q1HoXTUokUmHVpvY2adby6C
         JvIRUfunEFBxtUAIMa2/faZ4iq/1OjmmzuHyUhV67EqWaT7huNEJqMHIjIHvn3vZixgh
         hr86P7Gg5pKTUyAEssHBX+GoucxUu3hjqp/ypW0+UMqGGWtu56YaZFySqR0bHDESTYa2
         A1wLnL897p3W90sqcB9f7aKgNKSP2WfI4YFzRgxOznxI63rF+J/rGQ1DJEStdCeUjRWP
         +WhMos9haLxXscRMWN2cZWTNUrWwM0fJOZ6zEwvfsnJUB30RNAF0VR+jjzrO4SbNg7ed
         lZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775655392; x=1776260192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TT/XNxxFiSMJvri2UCR+//5EQ4kSR43N5t6IvbUFsnQ=;
        b=q8kjasU8cAuz3oimKfPV7w6Tj1cbHJgpNqOY1R+oo6pQJenbNTwRHzTxH1Vb4j6H4V
         VsaZwrDYA1Stz23q3vKanI7d8FhkhKP7lndpDfjgNTzF3UQWxATwqVCEcmOvenOMrKK3
         rEiW6ilRk62QwBnSupMV5TU8gxdTiecRVQXn3dAZS/YKd6jWUm8fQ+iFE6qgfXQTVpqv
         iS8Dih0QEq9oE6jWYrmwXOXhU7aGFe4ML5aCv3UT6k5H8IRUuAXUIy0LWs2P6RdtWQUY
         UBp7xyG2765u66lPueLjrd5CPO78Ar2YZ7NiklaNm/6zh6mdcYDydXMuTsNWpHOU9CqP
         HxGA==
X-Forwarded-Encrypted: i=1; AJvYcCUtwMPwgDDckoJttBSTJA2zJTXyGDzYyjmu1GAAyE9Rz4FUOww+3KamVApErEdAJ77n5S4uo4KO3SpL@vger.kernel.org
X-Gm-Message-State: AOJu0YzlJrg3TJtPr3uS6qgC9x/teHnMQX9ukAvOFwk3vhXDx8cF82OK
	mbweR30Zvql/yZInJAr4iyRCh1FqPp4VCO+YSrkPE9IeQKXz33SsC/b44zUGN5tosvDLIsUCTRr
	9LbR29OAtqsreEDC2MFFjcVaFB19BNU+gEw8IwPIagH0=
X-Gm-Gg: AeBDieuHVdpoNBqKYid32SCutoUzjFVdMgfmgr5srhH3MuoaG6CurRcmbXSPvD6mOh+
	ucYc54pAtJLF3o5ji/yYTNRA2R8E9GhwGdf5Vu1pVjTnop7aNS0L6ys8WEKnfHJhFkZnQdS1oiq
	B1dCXaEmjrOD+FNILll0UbopHWkhD55oVfOUZz2qfSJTKiDWQONeqOVNTaEadU6ul4tI9A8fNcD
	rr+3TCiTv3bHJwWCO9dEKTiVuFlaOgjXV6xOJlU0jnW8xXatCdoqf9EqarZWds5bZ6nM458R02k
	ClmG87YE8PKn7icF6LGD2v+1QFiDYZuXpCF8Ps7qu4lptsYMTInCI2il29PM0Q7pvbTF99k27lK
	GjchXkn/cyvHDdwyMDoShM58ZOo3CDmG1ig4=
X-Received: by 2002:a05:7300:a10c:b0:2d3:dff7:13b1 with SMTP id
 5a478bee46e88-2d3dff7416emr110557eec.15.1775655391562; Wed, 08 Apr 2026
 06:36:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com>
 <72ccf23d-f3e1-4e33-9eb0-4b4c9cd6d504@samba.org>
In-Reply-To: <72ccf23d-f3e1-4e33-9eb0-4b4c9cd6d504@samba.org>
From: Ruikai Peng <ruikai@pwno.io>
Date: Wed, 8 Apr 2026 09:36:20 -0400
X-Gm-Features: AQROBzCgpwVMua6gTXBsFVHj1dyIyjzzvQD3sOamGKErG1PYE9dJ4y1oyvopJA0
Message-ID: <CAFD3drPDXtzHpRLMNcdV5cScBVTkXZgQZwkfxi24LG0ins956Q@mail.gmail.com>
Subject: Re: [SECURITY] SMB Direct: double-free of send_io on ib_post_send
 failure in batch flush path
To: Stefan Metzmacher <metze@samba.org>
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, security@kernel.org, pc@manguebit.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Stefan,

This looks good to me. Thank you for the patch.

Best,
- Ruikai Peng

On Wed, Apr 8, 2026 at 9:10=E2=80=AFAM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Hi Ruikai,
>
> can you please check if the changes below fix the problem?
> If so I'll prepare real commits.
>
> Thanks!
> metze
>
>   fs/smb/client/smbdirect.c      | 8 ++++++++
>   fs/smb/server/transport_rdma.c | 8 +++++++-
>   2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index c79304012b08..461658105013 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -1551,17 +1551,25 @@ static int smbd_post_send_iter(struct smbdirect_s=
ocket *sc,
>
>         rc =3D smbd_post_send(sc, batch, request);
>         if (!rc) {
> +               /*
> +                * From here request is moved to batch
> +                * and we should not free it explicitly.
> +                */
> +
>                 if (batch !=3D &_batch)
>                         return 0;
>
>                 rc =3D smbd_send_batch_flush(sc, batch, true);
>                 if (!rc)
>                         return 0;
> +
> +               goto err_flush;
>         }
>
>   err_dma:
>         smbd_free_send_io(request);
>
> +err_flush:
>   err_alloc:
>         atomic_inc(&sc->send_io.credits.count);
>         wake_up(&sc->send_io.credits.wait_queue);
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdm=
a.c
> index 188572491d53..dbc8dedb85dc 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -1588,15 +1588,21 @@ static int smb_direct_post_send_data(struct smbdi=
rect_socket *sc,
>         if (ret)
>                 goto err;
>
> +       /*
> +        * From here msg is moved to send_ctx
> +        * and we should not free it explicitly.
> +        */
> +
>         if (send_ctx =3D=3D &_send_ctx) {
>                 ret =3D smb_direct_flush_send_list(sc, send_ctx, true);
>                 if (ret)
> -                       goto err;
> +                       goto flush_failed;
>         }
>
>         return 0;
>   err:
>         smb_direct_free_sendmsg(sc, msg);
> +flush_failed:
>   header_failed:
>         atomic_inc(&sc->send_io.credits.count);
>   credit_failed:
>
