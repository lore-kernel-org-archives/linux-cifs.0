Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541742C95
	for <linux-cifs@vger.kernel.org>; Tue, 26 Nov 2024 00:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732582276; cv=none; b=JulGVtAD+hhlgrZEJ/pwPfKGQjpbukoxjwf2rVgLevnb4oqSj8b5iT9DEdgVHDwWxyVlZOJ+aZrBmd1RXswxAN+ptZqGLL1f+q8bqoRXySi1xcpITmFMmYSN51QepVBRhzvq2MNwdQ68seTmFsJJu83u1SqLo3mA2cMNzY31TJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732582276; c=relaxed/simple;
	bh=d4N0vb0fmIt7lYKXQF29rJ2qrExkjsMiPu+kev7JT8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=suDiYouz3vacnkR6PD+/2SBdxRamfGiBnf0R4i2SSH17r2ZFujcYp0JDSIv4edn+j9c/4g3CgEcDtuhWhPumdqmRkINyBfQT5IvSAQ8AlY2mTTRZqLQQP2ABtCxQYNDfUaSNdnbWhW8QEakntkqtoJo6fmNr9Jz/2Ustmtpcatg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jzxz05kE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jzxz05kE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEA6C4AF09
	for <linux-cifs@vger.kernel.org>; Tue, 26 Nov 2024 00:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732582275;
	bh=d4N0vb0fmIt7lYKXQF29rJ2qrExkjsMiPu+kev7JT8E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Jzxz05kEH8L0ZeqGpcdCGiYBZXkD2XOIULfbl8F95JZfh9SRs2x2VEDG73FKgNbVc
	 PznDVOArTEOy5W3H2EC6dcur5LopiT6GJ9bbp54ncQ5pZPIV1h7LJ7wQR/78Oka/+0
	 EnYQPjwm+NFOyrTMxfndHpvoWKdLhZsaxHlEXILynJ3+myiQ4ninPtE5ayUJHIc+6S
	 NZ4v6ko74IcHuRa1sdA7hSZClSt3YtO7X3YRxopRdEEp+XawtmfkwpacpzvWn1xtrL
	 cG+52hotjl0iiyicPXqcTaQM9WbvBLX8dEiG0ZBtIg803/rZP6CRe5cf4Oy0uOE2Hu
	 YCKto1eTIKftQ==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-29666708da7so3189213fac.0
        for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 16:51:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWhV9OGqiqnwjRcruDLdHUoDiIdwSCQj8WgwvmQCYliemAg9MTsyUgAb017HiowMpBinCB9Mwwpk+mr@vger.kernel.org
X-Gm-Message-State: AOJu0YyswYbcvO77m+TdGAeD46n1CbUH9U5dmH1GlOKBb6Duqi3UK7ju
	Uujbg029dB5WDpkz8oTSebn9VcWbGzQL7wyB/b+QQsGrYak4mP2IAQzAe5j/7PAyAi+RmwEzSAp
	PEMPuto2A6l2loDSYipptut9Mb2M=
X-Google-Smtp-Source: AGHT+IE7B9Tto+yJ1vgqXYfmjY5Aeoap3OErRk90ziddPV3b3KoklNQM+mk392OgpoLp/sYwi59da/n+sMkQ2zPOlEY=
X-Received: by 2002:a05:6870:e2ce:b0:24f:c31a:5c29 with SMTP id
 586e51a60fabf-29720e96f79mr10042513fac.43.1732582275168; Mon, 25 Nov 2024
 16:51:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241125201551.2538182-1-brahmajit.xyz@gmail.com>
In-Reply-To: <20241125201551.2538182-1-brahmajit.xyz@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 26 Nov 2024 09:51:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_aZ1RT4yxC4fasmYk+M6vWrpwrjrJgxvf2hNzra7VJPw@mail.gmail.com>
Message-ID: <CAKYAXd_aZ1RT4yxC4fasmYk+M6vWrpwrjrJgxvf2hNzra7VJPw@mail.gmail.com>
Subject: Re: [PATCH] smb: server: Fix building with GCC 15
To: Brahmajit Das <brahmajit.xyz@gmail.com>
Cc: ematsumiya@suse.de, sfrench@samba.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2024 at 5:16=E2=80=AFAM Brahmajit Das <brahmajit.xyz@gmail.=
com> wrote:
>
> GCC 15 introduces -Werror=3Dunterminated-string-initialization by default=
,
> this results in the following build error
>
> fs/smb/server/smb_common.c:21:35: error: initializer-string for array of =
'char' is too long [-Werror=3Dunterminated-string-ini
> tialization]
>    21 | static const char basechars[43] =3D "0123456789ABCDEFGHIJKLMNOPQR=
STUVWXYZ_-!@#$%";
>       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
>
> To this we are replacing char basechars[43] with a character pointer
> and then using strlen to get the length.
>
> Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
> ---
>  fs/smb/server/smb_common.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
> index 75b4eb856d32..85a34aeacfe8 100644
> --- a/fs/smb/server/smb_common.c
> +++ b/fs/smb/server/smb_common.c
> @@ -18,8 +18,9 @@
>  #include "mgmt/share_config.h"
>
>  /*for shortname implementation */
> -static const char basechars[43] =3D "0123456789ABCDEFGHIJKLMNOPQRSTUVWXY=
Z_-!@#$%";
> -#define MANGLE_BASE (sizeof(basechars) / sizeof(char) - 1)
> +static const char *basechars =3D "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-=
!@#$%";
> +#define BASE_LEN (strlen(basechars))
Why do we need BASE_LEN macro? Why not just declare MANGLE_BASE as
strlen(basechars) - 1?

Thanks.
> +#define MANGLE_BASE (BASE_LEN - 1)
>  #define MAGIC_CHAR '~'
>  #define PERIOD '.'
>  #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
> --
> 2.47.0
>
