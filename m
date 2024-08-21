Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701E91B2516;
	Wed, 21 Aug 2024 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724262843; cv=none; b=NRIKosvJOa5H/3SwVsnA7oPZsMbGDUx0ZSY1fdIKSzSMAG9JyAtBS1HJCH0UcCf5FVVoI8GB/3In3ACL88oQeKAFCiWQ9ZHiUQ7t6hg9Z2LPY1kT6wbxyQYSadEoRtoerRVCwk/lWTkqYdQ2RiDqFoy9+46jrBjrtq21D/p5cM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724262843; c=relaxed/simple;
	bh=gqzFeewnT/4SkWL7qbqbqUiqOnUI7YBTulM9X9YebVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LtnBjr/JZlaflxvc/6hJSlgayF4er0UPGGc4uUUd7Y5b5n32wMoBJJWHfW47kAGn7S0DNs+3E9gyxhmiMiCOYMRxOor9bnROiIE3Sv1KyzV/Tc08BKUF5UhAurJDa1oRomsy1fl+6zKQuFiHbeelTMvYnzEHFvNXM7bfdqhWz2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EUn05KqG; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EUn05KqG"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-533463f6b16so2034427e87.1;
        Wed, 21 Aug 2024 10:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724262839; x=1724867639; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XeboYcfWTTgzgC9R/V8HkigBdb65HMv0vbDDvFHgRIU=;
        b=EUn05KqGslPuOfa53eKrqgnp2s1K0oWL/Z41ukoDHHdFx75+2HtBej76NveCX+nDCR
         e7htqJYpoPr9oqfnUuWzOeZ4NRiKOGd+OLlE7SaTp0W+IacRfKU5rknFvGEL1cYb2J0+
         9Xu9Y6xq86ncmCWHmuMDlQkWX2ZKk4bmNZ+JFSsnBzsuCBm6UNqa5C0qqR8oO0wfm2wW
         6qwYzwmUUZ7gBAUCsrMZo393vrbi1WNxCvaXyJwuHGomXDKLTfK11EmXut1HGlpPHDvf
         15Wp4eJE7cI7cu63HGe/COadam1CNfP8BzCfRHlZpjfbaxz2XCViJayBdlAzD1HmUz3j
         VOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724262839; x=1724867639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XeboYcfWTTgzgC9R/V8HkigBdb65HMv0vbDDvFHgRIU=;
        b=LnpR6GhGfECXdW8+eLJ74bf9Vcbk5sRh3/0b4fj5JtNxSxS4PhWZlZf9JCug3MoaZY
         CbH/55PLqrq7dIQjIIR5sYFGNtx5gfP1sZUuDleMFi+L8Et1OEP8eoGlVagdwm1DgiUN
         +AbANUydL3yINPjGbW5EmfotieGPRdoC9//iUnBZi4BfY73axcZx0Zv4na9P1GJqazco
         kLCrJVTzFYfQYE/aJnJR9BnszEvrEklhLzFql0XvHLlBoFBkX5MOAgIUzV+rHoUzhzyZ
         nBRaTotRfFB7Gri08yrqlH2phGRVaz6+AzADjDv8GQAEyeFUQrw44RqJiYY8GGgjG2Pt
         7Jtg==
X-Forwarded-Encrypted: i=1; AJvYcCUga8B7N4R+OgzmCrtsp5DuPtN3OfZjQ+OGFB5PJ/dJOOmrSKkW80CXYCGF7KrImyNrWP0dzLQC6cKo@vger.kernel.org, AJvYcCVWUyG81jvMLiviKAD/NAq6MU41Wm/4ZdCeGcVjgBi5d7CoyWd44u2JkMA/SvVEMTGFgbTLodrc4SEN+HOA@vger.kernel.org
X-Gm-Message-State: AOJu0YxJmtuSsT+CtXDpm4ij31cKxyMGMLdvkJ1PtTPbVq0T6QHZh309
	+iX+jTy5V3F7EBKXdGN+RdHJ4TaWJ/8d0UmTvefnUPJyJelpNFLfezJ1DAzaQ5bHheqtqIfwOr6
	42wSS8/IKS4wBO2udBFXm5RHFock=
X-Google-Smtp-Source: AGHT+IENB8z7U4LhzbCB9S5yEp3QWpYpbi2CLtomom1sOWJ/ScHSp/Zd0Wu6SeMyCJ7S5YBoTVJDwpFKcz9Z7pJfGl8=
X-Received: by 2002:a05:6512:b99:b0:530:ac7d:58b0 with SMTP id
 2adb3069b0e04-53348549bacmr2047328e87.5.1724262839238; Wed, 21 Aug 2024
 10:53:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com> <20240820143319.274033-8-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240820143319.274033-8-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 21 Aug 2024 12:53:48 -0500
Message-ID: <CAH2r5mseDtpxgjyW1HbeDpuidrGWHqBzAyvaweiQS+0tC9i5Dw@mail.gmail.com>
Subject: Re: [PATCH 7/8] smb/client: fix typo: STATUS_MCA_OCCURED -> STATUS_MCA_OCCURRED
To: chenxiaosong@chenxiaosong.com
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	bharathsm@microsoft.com, chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, 
	huhai@kylinos.cn, liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next (but fixed Signed-off-by email
address to match Author email address)

On Tue, Aug 20, 2024 at 10:13=E2=80=AFAM <chenxiaosong@chenxiaosong.com> wr=
ote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Preparation for moving the SMB2 Status code definitions to a common
> header file.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> ---
>  fs/smb/client/smb2maperror.c | 2 +-
>  fs/smb/client/smb2status.h   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
> index ac1895358908..3ac17d43bb7d 100644
> --- a/fs/smb/client/smb2maperror.c
> +++ b/fs/smb/client/smb2maperror.c
> @@ -1096,7 +1096,7 @@ static const struct status_to_posix_error smb2_erro=
r_map_table[] =3D {
>         "STATUS_MOUNT_POINT_NOT_RESOLVED"},
>         {STATUS_INVALID_DEVICE_OBJECT_PARAMETER, -EIO,
>         "STATUS_INVALID_DEVICE_OBJECT_PARAMETER"},
> -       {STATUS_MCA_OCCURED, -EIO, "STATUS_MCA_OCCURED"},
> +       {STATUS_MCA_OCCURRED, -EIO, "STATUS_MCA_OCCURRED"},
>         {STATUS_DRIVER_BLOCKED_CRITICAL, -EIO,
>         "STATUS_DRIVER_BLOCKED_CRITICAL"},
>         {STATUS_DRIVER_BLOCKED, -EIO, "STATUS_DRIVER_BLOCKED"},
> diff --git a/fs/smb/client/smb2status.h b/fs/smb/client/smb2status.h
> index 9c6d79b0bd49..15364c4328ec 100644
> --- a/fs/smb/client/smb2status.h
> +++ b/fs/smb/client/smb2status.h
> @@ -901,7 +901,7 @@ struct ntstatus {
>  #define STATUS_DEVICE_ENUMERATION_ERROR cpu_to_le32(0xC0000366)
>  #define STATUS_MOUNT_POINT_NOT_RESOLVED cpu_to_le32(0xC0000368)
>  #define STATUS_INVALID_DEVICE_OBJECT_PARAMETER cpu_to_le32(0xC0000369)
> -#define STATUS_MCA_OCCURED cpu_to_le32(0xC000036A)
> +#define STATUS_MCA_OCCURRED cpu_to_le32(0xC000036A)
>  #define STATUS_DRIVER_BLOCKED_CRITICAL cpu_to_le32(0xC000036B)
>  #define STATUS_DRIVER_BLOCKED cpu_to_le32(0xC000036C)
>  #define STATUS_DRIVER_DATABASE_ERROR cpu_to_le32(0xC000036D)
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
