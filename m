Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101631E517;
	Sun,  1 Sep 2024 20:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725223818; cv=none; b=JFcGX2U43W9jugGOEEhPk6taBTYItT9/8IPLQ0OCUKvLBGtk2Xbepol+oOifNhssb81SAndo3T6UZ8Ob0iF5gkVXwg23uGP0dZi+e5eCU35+fNFonSuhh+2QG3UeoBN4cZZpAqPLsTyLY3oHJEF0ZpM2Hw8ndnLP0MKCWNEZdlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725223818; c=relaxed/simple;
	bh=krrDibKBxYbpDoeYbKNjC5PPYxNQFs4NRzESdYWoOcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hKbh5ttlWvN1H4yn4t+zj+CK3lG76y6hWBbRxgE1wxuFx/YuuXdtbRLh7G+lExocRVEux2BgCu41jIoWS++z+I5Qik4Pkt2dNTY8Ww+SmAgwv5cRAJFfKnOt1eVHukvLIMqyXY7SiBxFly3RjB1oBDgUx5aKdlnOtZSN9kBdJ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DzNAAnmD; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DzNAAnmD"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5333b2fbedaso6162076e87.0;
        Sun, 01 Sep 2024 13:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725223815; x=1725828615; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmvtuu/nnTTPB5TNvDIzqgJV2raybGXEoThCiuyR1CU=;
        b=DzNAAnmDXuyB/mz/+Vtlkvx5NAXaHy9DG7+wkJ/KcDD7Luset6cKaEYr1f4yO1EijA
         NCCvzKe409nLoani5U8T++xg2wDGQAOlIQEDncOb3sq1wh4oJgn6euVKZxzjy9ykgAKd
         WEBAvZN5iYtWjBn/dGtRYdhF2E3ser3hvDzT5ChAXtSQQmCebC9/DOZP1IryGEvDFHMm
         SMrxq4uBocfG6XMk8scY78duVT8kLLPulsOG8ZgW7nkxaMPdsklFRw7tYYW86/QsQBUy
         QKbLGPpS2hEGqC7Z5tFhQN/EA0FxEhqeIljRuGhTQnvVuxh71PcdK1rA2FUIhk2+npR+
         fkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725223815; x=1725828615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nmvtuu/nnTTPB5TNvDIzqgJV2raybGXEoThCiuyR1CU=;
        b=fJ2uY0c/EJFkR9j09EiYnw+e63PdDh30IZrDTgyQLS1r6SvCZGN5XdYm0fZpqpETzx
         dRkrcMkqoiNXosCmjMh+Da38yLZsXomREfqb7NhgXxqxx/edSkaVKUN38cFpREOiqeJG
         viDz9UmP+ESIALN4hEWCbE2frx2Z4iki/Sib6tAPX3A/eyNoYcXv4SYUnvT5HsB2wuas
         vkggfBYyMDhFfeyJxEujX25s5g104Xl5z7U8JRefFwo7k/tsygu0xIm+53B2nanzJRNJ
         ITVzWpZL3Dvn2xkgrtllWOu5Hn96KpGgVqNhi6zc8B+7G8ZoNE02DgsQcyaHwSzHyFQI
         ZI3A==
X-Forwarded-Encrypted: i=1; AJvYcCWb3obd4mZh4BuqSLPIrcpNaqgQi1h+8JnxgZq7Bo61LTXAfuse//wQyAkcis0Wnikp8QUVuUOOWq69@vger.kernel.org, AJvYcCXDItt1Wd0qO52AIvN0X2Qa0kmxRCV30keOp8bfLupJlaUmwrwRxsPlyarN4YJc6w+DWULl06LZyJgEZHfD@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1p12i5N0M18k/+scotPAhnSq3y+m7aHq2V0CUhzeps1TKaTaA
	wFEr7YWiTJb9RhL2AMyieot9X8iRRtnx1uQZvsXeI2Q+x/ANnBBlUD7qFlyA8AMw5OZ5vsQr8of
	gQzHFqz48KQGluz3EziUNDgaWe+gHPA+qp5A=
X-Google-Smtp-Source: AGHT+IG/8AvC2IZQG8jqrB7dUuMYI9EscwxoJgIuyGSjXS7j3FsDwsUJazVMpgHaKq3g1u2kyX2l4lqKO5wzDzEgD9A=
X-Received: by 2002:a05:6512:1382:b0:530:dab8:7dd6 with SMTP id
 2adb3069b0e04-53546ba7bffmr5010405e87.50.1725223814609; Sun, 01 Sep 2024
 13:50:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240901164002.117305-2-thorsten.blum@toblux.com>
In-Reply-To: <20240901164002.117305-2-thorsten.blum@toblux.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 1 Sep 2024 15:50:03 -0500
Message-ID: <CAH2r5msAs9Lm=jzWd=pYnK3r9iANSNRTqHvHxNjzsBucgq9Ktw@mail.gmail.com>
Subject: Re: [RESEND PATCH] smb3: Use min() to improve _smbd_get_connection()
To: Thorsten Blum <thorsten.blum@toblux.com>, Shen Lichuan <shenlichuan@vivo.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

There is a similar patch in cifs-2.6.git for-next-next (for 6.12-rc) from

smfrench@smfrench-ThinkPad-P52:~/cifs-2.6$ git show
commit a85383ccf515f82ad791f9bfe70b0e6fb5a2117f (HEAD ->
for-next-next, origin/for-next-next)
Author: Shen Lichuan <shenlichuan@vivo.com>
Date:   Tue Aug 27 16:54:20 2024 +0800

    smb: client: Use min() macro

    Use the min() macro to simplify the function and improve
    its readability.

    Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

On Sun, Sep 1, 2024 at 11:40=E2=80=AFAM Thorsten Blum <thorsten.blum@toblux=
.com> wrote:
>
> Use the min() macro to simplify the _smbd_get_connection() function and
> improve its readability.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>  fs/smb/client/smbdirect.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 7bcc379014ca..8f782edc3fd7 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -1585,10 +1585,8 @@ static struct smbd_connection *_smbd_get_connectio=
n(
>         conn_param.initiator_depth =3D 0;
>
>         conn_param.responder_resources =3D
> -               info->id->device->attrs.max_qp_rd_atom
> -                       < SMBD_CM_RESPONDER_RESOURCES ?
> -               info->id->device->attrs.max_qp_rd_atom :
> -               SMBD_CM_RESPONDER_RESOURCES;
> +               min(info->id->device->attrs.max_qp_rd_atom,
> +                   SMBD_CM_RESPONDER_RESOURCES);
>         info->responder_resources =3D conn_param.responder_resources;
>         log_rdma_mr(INFO, "responder_resources=3D%d\n",
>                 info->responder_resources);
> --
> 2.46.0
>
>


--=20
Thanks,

Steve
