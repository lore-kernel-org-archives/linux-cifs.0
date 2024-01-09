Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FFE3E46E
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jan 2024 23:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KGJIV4XF"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2cd08f0c12aso37942761fa.0
        for <linux-cifs@vger.kernel.org>; Tue, 09 Jan 2024 15:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704843889; x=1705448689; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r0xssl5eNQfkC5b8fxkYPbQCZF+UqOUjcvTJ1Q4A1i0=;
        b=KGJIV4XFvdrvnmyD/ywCTgzjmFdsaEN+klbGotqfOSrPShFXKls+7EqBWYSTS35TsN
         PdUsXvGKRPviOogkONCzKjL3CAwb+mPWZnjp0qClKl60dB6THK9XQeYRSjdBG79PPcnP
         ssexTsvP858Oh7AD5bJRa63LLRej8Plf4BxzDKymQoXR2RcqMj2W/tB6KCQVRUN7wHrJ
         87hJO1tc9xJfZQacIaVmgRa4JIHn3O892D6UJqgR0Qh/8ayE/DlitRZhZWImXdtEH7rA
         XsnB1rEshHkXYf5hVHmQgvnju5jWiIEKoppeRqLEog3dpW9DUJDs9AfA7xqX5bh0dV7f
         4Jog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704843889; x=1705448689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r0xssl5eNQfkC5b8fxkYPbQCZF+UqOUjcvTJ1Q4A1i0=;
        b=kYTlg2J/2eqpdSkaNRtvxzy/JneO7ZhYZlCFRbpF/ek7JnEopq/GIRkEsQwWfHhfAV
         M9x+7TEvpehLiIrcYvb3GbeJpRtNGuxNy8f0gFiT9pX2CzMS4hw1CJI6diG5aVD+rZEe
         tPTvMBH7VlUx8teKjNmTnuKHtGYYCRffvO3uY8lo1rpMRxuFOJG8VUxtfapoHCMRtpBj
         peIPSeQOeP1T1wYlbfonLrf9I53zWbwFMdT+kqYI8yDZj4Fe6qs9/uBQUcOuWkhXJSLM
         iHGpz7Ln2/CiKHPQj16BhBoZMjY3uze3oPMECO1YPyxdaq4z8ekeXJme3GQfiR+o0LtT
         SN4Q==
X-Gm-Message-State: AOJu0Yx1YPUXqzSIZFP0151SJl9Qvzb6YU7FVXhxK3uyylUET8Ypb0qe
	jhv5YhV8gnP5o8tV+1kvo6csumUSAAv7EItwMkc=
X-Google-Smtp-Source: AGHT+IFwtPAUzLEm51hXQ6PHtBTTtd4txFwdltu9e/8LXt505SwKnOff2gtcy3FE5xHEp6vwRhXq+3iRhmyNX6uyd/o=
X-Received: by 2002:a2e:a4c5:0:b0:2cc:f3b1:e3b8 with SMTP id
 p5-20020a2ea4c5000000b002ccf3b1e3b8mr44395ljm.61.1704843889189; Tue, 09 Jan
 2024 15:44:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3c4154d3192607277bc3a7453f05cbae8a7bba5b.1701062286.git.pierre.mariani@gmail.com>
 <1f2c738ab53d6aa430001b5847feee0f73dd51c4.1701062286.git.pierre.mariani@gmail.com>
In-Reply-To: <1f2c738ab53d6aa430001b5847feee0f73dd51c4.1701062286.git.pierre.mariani@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 9 Jan 2024 17:44:37 -0600
Message-ID: <CAH2r5mvBQkJcGVNYDrYiPNv-4h5mA11jQkB30_8ytUv-=ZCssA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] smb: client: Protect tcon->status with tc_lock
 spin lock
To: Pierre Mariani <pierre.mariani@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

presumably this is unneeded since in this code path we are
initializing - we have a newly allocated tcon which hasn't been
returned to anyone yet so no other threads could update those fields
(until e.g. worker threads or launched which doesn't happen until a
few lines lower, or the tcon returned)

On Sun, Nov 26, 2023 at 11:23=E2=80=AFPM Pierre Mariani
<pierre.mariani@gmail.com> wrote:
>
> Protect the update of tcon->status with tc_lock spin lock as per document=
ation
> from cifsglob.h.
> Fixes Coverity 1560722 Data race condition.
>
> Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
> ---
>  fs/smb/client/connect.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index f7d436daaa80..26e3eeda0c4c 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -2711,7 +2711,9 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_=
context *ctx)
>         tcon->nodelete =3D ctx->nodelete;
>         tcon->local_lease =3D ctx->local_lease;
>         INIT_LIST_HEAD(&tcon->pending_opens);
> +       spin_lock(&tcon->tc_lock);
>         tcon->status =3D TID_GOOD;
> +       spin_unlock(&tcon->tc_lock);
>
>         INIT_DELAYED_WORK(&tcon->query_interfaces,
>                           smb2_query_server_interfaces);
> --
> 2.39.2
>


--=20
Thanks,

Steve
