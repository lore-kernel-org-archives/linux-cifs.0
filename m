Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61161F8BD6
	for <linux-cifs@vger.kernel.org>; Sun,  7 Dec 2025 17:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765129681; cv=none; b=nF04o4n9t3eX1WfFk+ek0ztuadgsgwJl1I1w4VeJLfSoA2jjJH18STPrVvkHfedOKlPnz11kuhTQXG2A2o2ZVoS5FXV+dpaWNJJpEbdrbA1bjOSTtDUQdzY8W5tjZrKrTrOlnyCroR4Ur3ryU2tyWk8I8OJxyiSFFvoC/EuezXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765129681; c=relaxed/simple;
	bh=jHaXTNaPHtvhAgYQKTlb2gA8chO+EkmSFBZqa6kSVKk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z3w1IYvRqkYwwWyPsw3jDIMf2yNnJ2hcJk0iEgYx3uwOuChl0yJ0eV3Zbwd5Ia37SHZVR2v195jw49K82DrKrB8/Pfd05PbNPmZO4dMHBwvJsxIgigpT+glL7FFmLeJhuZ+lIKuxEnj+lbJbEbesmSWfgxNdbG7Z6aWF3XcZW9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lnGSxQxP; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lnGSxQxP"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b25dd7ab33so219061485a.1
        for <linux-cifs@vger.kernel.org>; Sun, 07 Dec 2025 09:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765129679; x=1765734479; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tFBNqKPcM+sTadoTxHLv7ur3hvA9qwgA81a8ZjXYjQU=;
        b=lnGSxQxP3Nz9qmw8RzLF1PsQ5UvcFO5a3e9Xtoiaw1bC7368GsajVzUR5D4h7RV4KC
         tifYyVQ+absXIG9bpeJbx9PAR5e5EJNuqesloICqUqD5j47lWYgzT/8Lzkohx+xMHgD+
         zjrERzDj2x1VY8snKm4v2JqRqjW/+1M56Dybf45Tw/7v9N9FwJ4ww2sYhfCLpUeZSUvi
         zy52Y8F/09Dw/6qpGjPfugosBIrLMpYxuAn09WyBEQDsRjsg8lgy9tkDbKcMYk5i9Rjw
         Q6ts//x8K2igXeugFl6kpvSufuNijp+hqbCfoikOiHLJXharKYwA5/fWfVcXd1l2DAou
         XzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765129679; x=1765734479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tFBNqKPcM+sTadoTxHLv7ur3hvA9qwgA81a8ZjXYjQU=;
        b=TQeFDev6rBo0rPV00xJopApquFZkN9qY7MTi462SxxgQHAxt98NrfZSpKrvqL1jHUM
         nrOXhU/ocAIELE3SWHYFxDEUK5VA3x/ycmWOW4ixmhZZJM+ByUrsNzjSHcGijEugvDcl
         zBHdu2x3o84rOBeDXj8wlRbkB+RZew8OXSf4BQMqo+zQblsUKM25ZDHrwtCiC9I0eijb
         YZiqX+CqexNUB3h7OvSGJBjqGLv8XZfT5EmSs05eJq+3zdjyG1aSWmMjPeZzq0yEg9ns
         gIOttSIivhfx4LaVRtsEj8dOW7amJIoIsX9jb2LnxtXEbbzPDtWcMcx5SBqSlD4y0b+y
         GrFw==
X-Forwarded-Encrypted: i=1; AJvYcCW4/KN1H4gcCoi1Iqr7pNx+G4oJM+nCVu9yD8IEw7Ij1IS4CCt4ZlDcuwVPB65fvDQF1hL8dm3jXU6Z@vger.kernel.org
X-Gm-Message-State: AOJu0YzYUKd1/nn0+C6zWkb5qTz+woUdf5o49iQxDbZw2T05t7UssDPm
	D3dUiJAC32+kjLhN7tSg23SakJcfoYFIvCTUj/GdnY5J8UJBiD5uYPEyH5Us1F8zq0DG3m39XGl
	jZIXs3dgca1xJ6gFqly+MblzZ1gQh2ZY=
X-Gm-Gg: ASbGncvuU+d1TOkpw3wIQ04Qb/6JXl5sVFNoEyN5Z1qj68ulTtNP2Mr+9E4FmV+OPh1
	HLpOHU0FuLWTGlg7rkFGYDM440WzklmFJk7nNocq6Miqq7gbmRS/CuV7gXKIE416foXpkktqUI3
	Pl/l3PGeQ01BfTKJQNHe4jPX2wDaVvdcimrHfJD6TVTxgrXt7lQwqs/3jOlKpmvbSA/L2p3+jLb
	l13vTOiT3bo/h+v30hlaZbLR7+aQAgmBiDWqjXU4wnQ+J8+P0NoT5TK98xXVd4WGUjG5sHcFe4u
	+sQtSRC+Ihb4GgTBX1NO5G4cvbddHJOhp8xqhbyIMlIT+Axbfah3Eh4ebeoirZV7dVjKoC48pM+
	lS3peWka9fPpSVAEzqujgzJXiYOfMaynQaoJmD4R/VEbBKJNzqRlqHmgeYFGKNmzR4AjVvJjXRH
	zGgDSl8d9K
X-Google-Smtp-Source: AGHT+IF9XIf4O9JHzTdRYwF9Pef+SC5LuHP7HoBj9HXiOfQt1banR+r+g9Ga85kyhS1tXTLnrTw7F57CjoieUhBPqwE=
X-Received: by 2002:a05:620a:1aa6:b0:8b2:eb9f:f1c3 with SMTP id
 af79cd13be357-8b6a2331697mr768585885a.7.1765129678539; Sun, 07 Dec 2025
 09:47:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev> <20251206151826.2932970-10-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251206151826.2932970-10-chenxiaosong.chenxiaosong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Sun, 7 Dec 2025 11:47:47 -0600
X-Gm-Features: AQt7F2r8-IUXv8x1BFea4jeUv3RFYJcOdhljHg8-Zl9xDiCELDOVFawmPqM9Eos
Message-ID: <CAH2r5mtrVo4FMd-fwhJ8FKovage=429AWU6TeyB5RkpZtzBA1g@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] smb/client: update some SMB2 status strings
To: chenxiaosong.chenxiaosong@linux.dev
Cc: linkinjeon@kernel.org, linkinjeon@samba.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch - merged into cifs-2.6.git for-next

On Sat, Dec 6, 2025 at 9:20=E2=80=AFAM <chenxiaosong.chenxiaosong@linux.dev=
> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> The smb2maperror KUnit tests reported the following errors:
>
>   KTAP version 1
>   1..1
>       KTAP version 1
>       # Subtest: smb2_maperror
>       # module: cifs
>       1..2
>       ok 1 maperror_test_check_sort
>       # maperror_test_check_search: EXPECTATION FAILED at fs/smb/client/s=
mb2maperror_test.c:40
>       Expected expect->status_string =3D=3D result->status_string, but
>           expect->status_string =3D=3D "STATUS_ABANDONED_WAIT_0"
>           result->status_string =3D=3D "STATUS_ABANDONED"
>       # maperror_test_check_search: EXPECTATION FAILED at fs/smb/client/s=
mb2maperror_test.c:40
>       Expected expect->status_string =3D=3D result->status_string, but
>           expect->status_string =3D=3D "STATUS_FWP_TOO_MANY_CALLOUTS"
>           result->status_string =3D=3D "STATUS_FWP_TOO_MANY_BOOTTIME_FILT=
ERS"
>       not ok 2 maperror_test_check_search
>   # smb2_maperror: pass:1 fail:1 skip:0 total:2
>   # Totals: pass:1 fail:1 skip:0 total:2
>   not ok 1 smb2_maperror
>
> These status codes have duplicate values, so update the status strings to
> make the log messages more explicit.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2maperror.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
> index dc2edeafc93b..e54b5871ecc9 100644
> --- a/fs/smb/client/smb2maperror.c
> +++ b/fs/smb/client/smb2maperror.c
> @@ -22,8 +22,9 @@ static struct status_to_posix_error smb2_error_map_tabl=
e[] =3D {
>         {STATUS_WAIT_2, -EIO, "STATUS_WAIT_2"},
>         {STATUS_WAIT_3, -EIO, "STATUS_WAIT_3"},
>         {STATUS_WAIT_63, -EIO, "STATUS_WAIT_63"},
> -       {STATUS_ABANDONED, -EIO, "STATUS_ABANDONED"},
> -       {STATUS_ABANDONED_WAIT_0, -EIO, "STATUS_ABANDONED_WAIT_0"},
> +       {STATUS_ABANDONED, -EIO, "STATUS_ABANDONED or STATUS_ABANDONED_WA=
IT_0"},
> +       {STATUS_ABANDONED_WAIT_0, -EIO,
> +       "STATUS_ABANDONED or STATUS_ABANDONED_WAIT_0"},
>         {STATUS_ABANDONED_WAIT_63, -EIO, "STATUS_ABANDONED_WAIT_63"},
>         {STATUS_USER_APC, -EIO, "STATUS_USER_APC"},
>         {STATUS_KERNEL_APC, -EIO, "STATUS_KERNEL_APC"},
> @@ -2292,8 +2293,9 @@ static struct status_to_posix_error smb2_error_map_=
table[] =3D {
>         {STATUS_FWP_LIFETIME_MISMATCH, -EIO, "STATUS_FWP_LIFETIME_MISMATC=
H"},
>         {STATUS_FWP_BUILTIN_OBJECT, -EIO, "STATUS_FWP_BUILTIN_OBJECT"},
>         {STATUS_FWP_TOO_MANY_BOOTTIME_FILTERS, -EIO,
> -       "STATUS_FWP_TOO_MANY_BOOTTIME_FILTERS"},
> -       {STATUS_FWP_TOO_MANY_CALLOUTS, -EIO, "STATUS_FWP_TOO_MANY_CALLOUT=
S"},
> +       "STATUS_FWP_TOO_MANY_BOOTTIME_FILTERS or STATUS_FWP_TOO_MANY_CALL=
OUTS"},
> +       {STATUS_FWP_TOO_MANY_CALLOUTS, -EIO,
> +       "STATUS_FWP_TOO_MANY_BOOTTIME_FILTERS or STATUS_FWP_TOO_MANY_CALL=
OUTS"},
>         {STATUS_FWP_NOTIFICATION_DROPPED, -EIO,
>         "STATUS_FWP_NOTIFICATION_DROPPED"},
>         {STATUS_FWP_TRAFFIC_MISMATCH, -EIO, "STATUS_FWP_TRAFFIC_MISMATCH"=
},
> --
> 2.43.0
>


--=20
Thanks,

Steve
