Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842A51A01BE
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 13:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776087074; cv=pass; b=AjMiV0ejp6NgQqFFmuD/ex8NsqyfTPoIz4/AiUD9EctUDeGeO/TTW18JnGVAUx2HKZe4P/MKDny7tpgT/+mK6XFnrZHP8Vbibfgih8mXqs3d6jDUFx3D3FtcQXqmHkWWqWtXgQp4OmXVT1n2WI9nPxnAOwx8BAw+kCwAgKHK1qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776087074; c=relaxed/simple;
	bh=skp1tH+vmQ6SKPgNwRguUtoo6yE+BVoGpu0xyhTQGek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GsXLb1AP0LSNR+3aGpWxZ/Rq0ORoQSiI/JODjoHSRfTc4R2nM2i484nUX/87teyKzE3CVLFLA5Kbz805n56Ba4vS3PqxoWNJjzeHGQZX4maqLx+HY4tbGjiohAnxXTGYZoL2+X28l4Ov+NO66vrFo10AFdWqncLCDr47QP6CC0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UcglS+ry; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UcglS+ry"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8a15ebb3abbso65201976d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 06:31:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776087072; cv=none;
        d=google.com; s=arc-20240605;
        b=QTKq2IY6zk4lIvXjO1kXZmvMPzEonw8nFAur5ydIVBTPQ7SrU71HCnfw3iGd5+rChX
         Z1yer9Y7l5JFaK207SpX8fkMpVm0rC5h9012f5BkfEgG5A9wDvjCrjTMS0/WDQD/8wPs
         71JRO5oJj7TxLX9X/tFa9vDt1g6DkHjYg3PJWqOYe49+4s6M/ogReAfr6kYUcyVbi9Br
         9+PVtKRpUQ5hgxtUnweq35/S2zEytjUKX0Tamj1UxgULChYGJCLX11GibkcWZt3Pvgkp
         donOqpvKy7ZsfQzDOQRezpEGj4Xfm4F+nd1H0rHkb9qV5dJBuk9ZiEu8NCas2hqNVvyA
         P4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HzE9//XdVVTPu3aPueyZqedAVwjhRKQ5eNLydzTye+A=;
        fh=ZrItM5gBYJp75xwe8gaMA+bSB+0dQmOcE/7i5gan2WE=;
        b=YAUemwDiwBy1U542DJsGRucs4xoMNjpwDv7DBYalhdp9bb2CZqVW97Znwg21O4vxhf
         Vqv+fGjt8tB8zDULi4zz9ERdWXVMepqpezDNswxVZBrB57HXI5e8czfB0VfWphoT/Fqw
         FiMmdfk1Lg7C3BBdel0PpX1GKmcwjq4O1CDeKBVI1Cqb2ZWf3GtHTqSU4F0GRo/AV+bx
         VVTYUFROiq3DfNP5jVdFHfzElsvw9jSmQtrUmpLs1mbJOSb6/b6HZW88YVtCp0S/BnUx
         RcU+vnV2UDhaQF9wsbOSZh1H8RiINTYnzRc9fyIvRZppWcKrdgf8L0+NxVgK0qlOHf80
         2rmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776087072; x=1776691872; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HzE9//XdVVTPu3aPueyZqedAVwjhRKQ5eNLydzTye+A=;
        b=UcglS+ryZI0Vyr/3eq9TxXjTqRzDjRlF+LC8jNsc81+ZTfWfu+kpwMffULsXemTjWe
         41fZiuoxbuHaWnEYLE2+fZqLQnbK1Fi5hj1SduTdmGMOFJsINRBzZZH4WmHNXGbkckHP
         OoTGInTiSoe/tgjiJBgA1hMOgNn8+RXDBm7mPHwNH1zt7Pr68poRSthdq+vlt1n+h3L+
         M1RYaqX7KGtoMFK/dJckqAkqaEmWIGmiIt74G4w9mvWqM63ERXSr72AV9A5YbJPa8m+m
         liB76y33k3iqZf9JLxP/0l0igkrgV1qd9NnJb+SpKpNaMQgvAfZCmllyTquxsfoqrquP
         Y5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776087072; x=1776691872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HzE9//XdVVTPu3aPueyZqedAVwjhRKQ5eNLydzTye+A=;
        b=gCbY56zIeCht0JtPbad8aD9wg96T8FCAOHxYOapaH1lTuS+F6QFqYlv1/pAu//BE+K
         +Fd4m2S2QJ+WDMUW1eFe9KWJkHdYShJliQgK8Co8J5wQjwjmKiYVdtFFMMz92d5tMFlu
         53jygHgjgUsLePO3AgzQfhnF8ug8xjfhxKaK8voGT2hDI4SATZYcnoxpJg7H6kPaMrf5
         Kvu/Q7qmsQVub8tubto+fnbxjhFY7cpzZlVoJKoQAjB8dmseL92JlRZ+LUXSOh52wQ7u
         glj+lAyYYI2RGgswXK/D8QQWWtkprSMSxT9UZccZ95TZdF/y5XarzdK6K5YNiRaAaD3q
         tq0g==
X-Forwarded-Encrypted: i=1; AFNElJ9WAq+s5e4esqx5NbruPAMImt2fWv8vvCWDwWm7XkpeHK8659BkDpp5tHDD3s0AVKKFY1gm/P0UmCwP@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4qY5U5p0WAoiFpaIzgedfZqXUKP5w8UGRqRkkXrbW5nGH4SM+
	1YXcLcGhsvBMHG2Irs38hJk0RCZzSDMTpkJNg8nLcfOe4DKfNej633ZWeY2CUCWXP3cQ4NOFKQS
	e4JbGLhCAeym6UW3QurEo0sMOJ4SJCOycrsdo
X-Gm-Gg: AeBDietLl68DDrJjS30Nb9WvmbmT5IAOD1hVpqzHWHlq+SBh5CbCM/0UFiNcHrP1mvB
	f8YFcr91LJjeAFGrc8R4ZPehKC65+9qXTgivx/LYHvH7Wamh+tDPCc6dVnwMQ/J70wjTsVH0zHI
	iTESAnxnJW9FHdVz++ELuPMB3vsBvm6Si2WqsGIoLpz8kCd3bHn9NiUka+4/mYpqZhTeEkR+BZM
	vOGAI4uoo1Jj3WnsvxDK5gX9e7rD9hYuiSEy22JTEf3sg5iKbE2scDjTcEgHdkip6LkfWajJ362
	47vsdQ==
X-Received: by 2002:ad4:576d:0:b0:8ac:a6f7:8a68 with SMTP id
 6a1803df08f44-8aca6f79762mr82786606d6.21.1776087072161; Mon, 13 Apr 2026
 06:31:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409095926.905020-1-rajasimandalos@gmail.com> <20260409095926.905020-2-rajasimandalos@gmail.com>
In-Reply-To: <20260409095926.905020-2-rajasimandalos@gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Mon, 13 Apr 2026 06:30:59 -0700
X-Gm-Features: AQROBzDWvfgB5U9xzjBedKTu6pP4aj8295MeRHwECIpFXdXpCa6xEo1TaUewycY
Message-ID: <CAFTVevUOL5wjLjs2aVXP_0Wn627R=46NcKFWxRfAoN6bwuHmBQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] smb: client: allow both 'lease' and 'nolease' mount options
To: rajasimandalos@gmail.com
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	metze@samba.org, bharathsm@microsoft.com, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>

On Thu, Apr 9, 2026 at 3:07=E2=80=AFAM <rajasimandalos@gmail.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> Change the nolease mount option from fsparam_flag() to fsparam_flag_no()
> so that both 'lease' and 'nolease' are accepted as valid mount options.
>
> Previously, only 'nolease' was recognized. Passing 'lease' would fail
> with an unknown parameter error (or be silently ignored with 'sloppy').
>
> With this change:
>   - 'nolease' disables lease requests (same behavior as before)
>   - 'lease' explicitly enables lease requests
>
> This also renames the enum value from Opt_nolease to Opt_lease and uses
> result.negated to set ctx->no_lease, which is the standard pattern used
> by other flag_no options in the cifs mount option parser.
>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 6 +++---
>  fs/smb/client/fs_context.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 0f6c1eb8e274..e1bf7bad5be6 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -80,7 +80,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] =3D=
 {
>         fsparam_flag_no("forcegid", Opt_forcegid),
>         fsparam_flag("noblocksend", Opt_noblocksend),
>         fsparam_flag("noautotune", Opt_noautotune),
> -       fsparam_flag("nolease", Opt_nolease),
> +       fsparam_flag_no("lease", Opt_lease),
>         fsparam_flag_no("hard", Opt_hard),
>         fsparam_flag_no("soft", Opt_soft),
>         fsparam_flag_no("perm", Opt_perm),
> @@ -1572,8 +1572,8 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
>         case Opt_noautotune:
>                 ctx->noautotune =3D 1;
>                 break;
> -       case Opt_nolease:
> -               ctx->no_lease =3D 1;
> +       case Opt_lease:
> +               ctx->no_lease =3D result.negated;
>                 break;
>         case Opt_nosparse:
>                 ctx->no_sparse =3D 1;
> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> index 0b64fcb5d302..a80a5caff23c 100644
> --- a/fs/smb/client/fs_context.h
> +++ b/fs/smb/client/fs_context.h
> @@ -102,7 +102,7 @@ enum cifs_param {
>         Opt_forcegid,
>         Opt_noblocksend,
>         Opt_noautotune,
> -       Opt_nolease,
> +       Opt_lease,
>         Opt_nosparse,
>         Opt_hard,
>         Opt_soft,
> --
> 2.43.0
>
>
