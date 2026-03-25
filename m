Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D2435292A
	for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 06:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774420003; cv=none; b=iJ9B0RXJCNf37aH/V0YfQkaiELLep2nIe/G+RcXn7n9rqEYtpRA96aZlq0HqxtWQ/AjBLpVdTgtL0sVK0kHdlNnFIpd0xUdHgItZfxLN+d5xMf0FBIh8LGo0DNHFbsGaneR6qlAlrED/DYSiKs8rM4Uyqnyk7fVuKteJDlYv3G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774420003; c=relaxed/simple;
	bh=y2s3daz2/AgFmm+2RkufDdAXOmoqJVV+QTZyrL+t7os=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ae5pmXfiDnXYKcoTzmoMPg8/csN7XDVU2xl2tXQU+IkygvSHcZ8AbAbW7lKNLDnv6OZ/QsSpoLGhnAo+Tcfmbm2zzmKsEQoDEB/M9AINh/ucAbVJS1m19STujcZUevhC5CdA8BMzt/VDRCB6TDIuvnsygFsXXPze/+g3WyVt35E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Km2qOpR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Km2qOpR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61806C2BCB2
	for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 06:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774420003;
	bh=y2s3daz2/AgFmm+2RkufDdAXOmoqJVV+QTZyrL+t7os=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Km2qOpR4+jFEl3xVrDzeNHP2VONdL4d37Bw9YG/7qBphPmjYuOb3BgyogLvaEZBXB
	 Xlh2hZg3wgQzxh95s4Fr+RWaDIn2redFYFX7q9S/UHEMCJpcppo+TvnXsnRAlM54Ll
	 AExj+qZUbbaRDIdlfA3lIhM053DnACRJ4/Oe5+5aM+qPwuRvp1gI8DSfjs1/YWwZrP
	 2efyeCcQoNF9Mw+DHF+K1//m/U+F3P9QxDFPf1ngQj5EiGcQPrssKBR1ip/ZbKlyYM
	 bbz/whgAlRGlgxA7IqavKd0RBVFYm+3WgbOECIDNAKKLQh7zTWJpWm11I295JxBGtp
	 EMud1xaVzAbuQ==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-66a33f61d80so3398786a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 24 Mar 2026 23:26:43 -0700 (PDT)
X-Gm-Message-State: AOJu0YwM10xf7PwLKHTNGSPZ4/XknT+bMUEgHMGmuWrcRt39iHbm6GTM
	hhddePCJKzLb2dpx8KHNw0z0gMWGH1OpPz0CC14Bqu5koLkn89HXAl1Lli58HZXjNSux/xbIhTd
	OYN4UG3FCK1JuBxuf1J8SJPf19oLJELU=
X-Received: by 2002:a05:6402:4389:b0:663:4315:7271 with SMTP id
 4fb4d7f45d1cf-66a826b1645mr1178122a12.23.1774420001895; Tue, 24 Mar 2026
 23:26:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306063522.439782-1-rosenp@gmail.com>
In-Reply-To: <20260306063522.439782-1-rosenp@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 25 Mar 2026 15:26:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_1WEkL80a_fLR4g7+9ryZRZhNJXtKxQG0UJnifd-y9+Q@mail.gmail.com>
X-Gm-Features: AQROBzCMW1LOXPgwm0q-72oettjs4Zf2K4bMk-mrVfU75v_XyrgD_93PLiXSzwU
Message-ID: <CAKYAXd_1WEkL80a_fLR4g7+9ryZRZhNJXtKxQG0UJnifd-y9+Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: ipc: use kzalloc_flex and __counted_by
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be)?b" <linux-hardening@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 6, 2026 at 3:35=E2=80=AFPM Rosen Penev <rosenp@gmail.com> wrote=
:
>
> The former is just a nice macro and the latter allows runtime analysis
> of the allocation and its size.
>
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  fs/smb/server/transport_ipc.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.=
c
> index 2dbabe2d8005..f7aa427a06fe 100644
> --- a/fs/smb/server/transport_ipc.c
> +++ b/fs/smb/server/transport_ipc.c
> @@ -55,7 +55,7 @@ static bool ksmbd_ipc_validate_version(struct genl_info=
 *m)
>  struct ksmbd_ipc_msg {
>         unsigned int            type;
>         unsigned int            sz;
> -       unsigned char           payload[];
> +       unsigned char           payload[] __counted_by(sz);
>  };
>
>  struct ipc_msg_table_entry {
> @@ -242,9 +242,8 @@ static void ipc_update_last_active(void)
>  static struct ksmbd_ipc_msg *ipc_msg_alloc(size_t sz)
>  {
>         struct ksmbd_ipc_msg *msg;
> -       size_t msg_sz =3D sz + sizeof(struct ksmbd_ipc_msg);
>
> -       msg =3D kvzalloc(msg_sz, KSMBD_DEFAULT_GFP);
> +       msg =3D kvzalloc_flex(*msg, payload, sz, KSMBD_DEFAULT_GFP);
>         if (msg)
>                 msg->sz =3D sz;
We don't need to manually set msg->sz if the flexible array member is
properly annotated with __counted_by(sz) ?
kvmalloc_flex() automatically sets the counter via internal
__set_flex_counter().
