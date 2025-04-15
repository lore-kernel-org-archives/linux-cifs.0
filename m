Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16BF22EE5;
	Tue, 15 Apr 2025 00:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744677845; cv=none; b=u09rqr3WJINZwzr+7PDmzpUteBmpjKv/dahwjM8wx7iQFcu70M3l11BDiZBzQ5bZQNpPD6bStO5wIT2GUbVnBGiNvLudlzktTrj8c98hr04Y3zRXEfz+RmrEr3CQaznm6lb032vuvaiuudaRdp5mcEddjRAqc3bzO3HMIYna/oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744677845; c=relaxed/simple;
	bh=EDQucIP+54cSAFnSTaN8POqjj3hLTUVBjhkVpqRysJQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AAdm+cXgNOtE6U3Td30DUkVCtjh8lcXRVIZMrTJpVlxya16ywk82NuxXWFzBpkafd+2d8ZUQEhssZsgGvg/pstocFxLK6gOPEakaVqN3vYgvcUtPHonnUyBVEz7AwvDNRtFMytvutOc/F1MEI1Dwwp05SIx8n+yPDtYgTZ8B1Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tnD1RidM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tnD1RidM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237FDC4CEED;
	Tue, 15 Apr 2025 00:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744677845;
	bh=EDQucIP+54cSAFnSTaN8POqjj3hLTUVBjhkVpqRysJQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tnD1RidMj7G07k5r3ajaxJAFVvslMpRfqIPS66pMEu4ZOO2Lq+qcP0ij/l5PlF914
	 SshkDX6FW2jHI5j9r8sUS0WpFCUxQjU8N6emWXv4s1209YT3TtQC71eI/Wk8AJtNEJ
	 So/6ef4XUBbn1NwLDErramG+fhFBjogO6q79LsNVzFA3XI6xvD94KLZ6BBRDRskveM
	 8A6uSl9Tt93kMsOAw1MR2E93qACOYxQTMabwtVEclHe1ErSzPwkgnOw9Bb5kuNK8y2
	 q8X7fyogvSlGHomnKubtRnIXykpdOFyd1zQepUDgT6ZT1rB5AFzJHAdm2MziCwXX8p
	 xiwwa2JLnug4A==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-2cc89c59cc0so3515157fac.0;
        Mon, 14 Apr 2025 17:44:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVubEk34xM7uinEigDe/A6PuwhRyYz07LS4zJDcqmdtWPtRXblEj8MQXUYDtrd9LvTZ6gW3cYO/GKHIdHCX@vger.kernel.org, AJvYcCWo2Imzio4h+CCnBC+gvJ4hFhFVZB98ulGzOHBCU21YCMAYNAPY/txjm3hLAHIMnPB55qZi2k39QlLv@vger.kernel.org
X-Gm-Message-State: AOJu0YzcIO16+woLVxI7BOFRWzjFkVCimbA+/t66yT4L92xLGxtBBqSp
	h7xF8w/IP9bxBMQR6MSc8k/b44um4qnBGplE8uVLK/98xTqM/tIJxC3S0nK5mKg9E294RVS2oQ8
	UPQTOXXIKJhoF6MPf4RzHavkCtwg=
X-Google-Smtp-Source: AGHT+IGMOo2FfFXUaSeUsjEQn5MkU91TS07/k138mootjVYf/LC/NWPikMbcqd3oZ5jlZUPPahOCcvby4Mqj5saLAPw=
X-Received: by 2002:a05:6871:4004:b0:2c3:13f7:2b3d with SMTP id
 586e51a60fabf-2d1da70fcedmr994819fac.13.1744677844363; Mon, 14 Apr 2025
 17:44:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z_1hB9GQL_Y7IAdA@pc>
In-Reply-To: <Z_1hB9GQL_Y7IAdA@pc>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 15 Apr 2025 09:43:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd83Pj37B9vuytFjXrL67_ohMBSjoQKM+6PdvzrqVxjxag@mail.gmail.com>
X-Gm-Features: ATxdqUFWmEX3eff4iu1JkRwUAS1AuhWzWWCLlxkV2WzXBsM-Wi7KQGIu1BHcIfU
Message-ID: <CAKYAXd83Pj37B9vuytFjXrL67_ohMBSjoQKM+6PdvzrqVxjxag@mail.gmail.com>
Subject: Re: [PATCH] smb: server: smb2pdu: check return value of xa_store()
To: Salah Triki <salah.triki@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 15, 2025 at 4:25=E2=80=AFAM Salah Triki <salah.triki@gmail.com>=
 wrote:
>
> xa_store() may fail so check its return value and return error code if
> error occurred.
>
> Signed-off-by: Salah Triki <salah.triki@gmail.com>
> ---
>  fs/smb/server/smb2pdu.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index d24d95d15d87..e32f8910e892 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -1445,7 +1445,7 @@ static int ntlm_authenticate(struct ksmbd_work *wor=
k,
>  {
>         struct ksmbd_conn *conn =3D work->conn;
>         struct ksmbd_session *sess =3D work->sess;
> -       struct channel *chann =3D NULL;
> +       struct channel *chann =3D NULL, *old;
>         struct ksmbd_user *user;
>         u64 prev_id;
>         int sz, rc;
> @@ -1557,7 +1557,10 @@ static int ntlm_authenticate(struct ksmbd_work *wo=
rk,
>                                 return -ENOMEM;
>
>                         chann->conn =3D conn;
> -                       xa_store(&sess->ksmbd_chann_list, (long)conn, cha=
nn, KSMBD_DEFAULT_GFP);
> +                       old =3D xa_store(&sess->ksmbd_chann_list, (long)c=
onn, chann,
> +                                       KSMBD_DEFAULT_GFP);
> +                       if (xa_is_err(old))
We need to free chann before returning the error.
Thanks.
> +                               return xa_err(old);
>                 }
>         }
>
> --
> 2.43.0
>
