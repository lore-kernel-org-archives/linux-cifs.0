Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577F82F361F
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 05:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764827384; cv=none; b=mw09GruJeX3d4pOfJ0OWyN2d4lh6wmtvoKIbMfA2wru/GWXzx4T78rULOaNxeqvW8QfY9oJi2r0u0Ik4GGPnIx5bJBrtSEULLCG3PeIsuhvDgxJZZuuUyDsJ+y6U2YrwziSTsEBqv0oxetVOf+j5PFPl0wEPVnTjpZPWjkhtpBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764827384; c=relaxed/simple;
	bh=c8onD4MJrx6+l7961m+qFj7qmMv3YdyDbjSfginvv7Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LyIS8XuNkgwsC0SQY5/DIzpP6ReKb6gyXmkdCupSRvSTPP9LijD2nQ0SP3IOVhhPaycS9Di4FS9XKPXrgMzrq5r3hxBYoj8D4qm1IDSftQFnMh4tLnipP24C7syNPWisjHtR+ODXTf87QaTn0jSDwKi6suPsa4ky2l1oM321F5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A2oMQ0l/; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A2oMQ0l/"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8824ce98111so7475306d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 03 Dec 2025 21:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764827381; x=1765432181; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7SYomATI96u/VTFhrTFGmsIeKSb/fBLFBlpYECdhpKU=;
        b=A2oMQ0l/+cW4sSOGa0YkEARTCp4NidlTDfN397EJd81dAUt9i30sPdIzoHRQPBJQlv
         GX2DvBtPA3jD9ny5SBj4XwC5F6ClBCzNx59wesT2MYG98XFWYa+/75SfoKHMOzt9+vTs
         5iU3QuykD5AJvfT+48rmpiOOcZDSZdhaScJcBEEZWSFYIYjvvM8W8uFOFMi30KOaJ96X
         ic+fUOCasvrMB92q13KHDc+qB8/hEC6uLCQ2YwIvDBGmvrwATCFu4FhdjSwEGKkb741Z
         lYjU/VVNvxMVVWKonzltbtvcClfa8gprGs1mLeWH3AQYJj0y3RazYZnlqghaygcNhVRa
         dVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764827381; x=1765432181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7SYomATI96u/VTFhrTFGmsIeKSb/fBLFBlpYECdhpKU=;
        b=gB3NASzQy+qd9yXmBMtlBTIuWUgtiE1ORiBWQto1kMcCTZj00ZQ9zCL3aZgF14sdKw
         eQQunReQ92+CgS1RcTy64A0xaFQ/8gaWrQ73NZfllF/mJvOxm5+Ci2iqESIxU7vrzamo
         YjcNlDMuyfzuKWvLH2aL4gA2RkpPvvd19Em3ED1iZb4K2jT3hstsx47q6DTPErEjwTkj
         AkbAytUmzRQ4eIwmVmrmIu1BIeJ2bqRSA2Fk6ZPixw6xNJtwTV3OTziDs0l+ku72Nz+U
         zANfhaIwS4B0GXViR4B+9ioXmvXMPUq+QLmGiZXqYdLlOiFyqF2qGfKGJAkJS8PAKifx
         2FGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXus/QoyMn2UfowL5gQq1AS6EdnHQo4PGBhrdy79kluGNwvWzjRNs8cwnL62zm0qN9AIiVlOzaFBQcq@vger.kernel.org
X-Gm-Message-State: AOJu0YylPpMEOFvzfiOpl/49JDGkgSO2nxOnd9bGNc4l/cgrtChzOD+5
	ef/7ZtZw2GYY7LNS8ge0M2Q1A+mEKFBOSGrJCYQMvhs1nI9xsH26RkbFBVt6tkxfs2iaM1kuHfh
	3PX9OmCBCski/+jhvZvxzX0++U9LxUz8=
X-Gm-Gg: ASbGncuvGTH+JlwSq9QGteG6/YehRmeLDy+8xLS4n466/UiTae9O/XGiTq3id6cZpkN
	J7IUGeuT7PsH95l/lGUCsV0DJj2pf1wjH18pXIGHZVO/+K977u+bGCZ7pJaUe/4WEXVL9LHjOAo
	0BvvS0M0x9UxjU1RBwejbEQ/JhJaHhAzT6wsO47crftkPEuxP1Wzx9w825JcFGjWmp8WpQNMWq5
	dv6rWDW3TZ1QWeYkKssD7wFQy2I80wMVt3SVlP92ab/hRocRlv7Vk1Zd5OXlEqcEkq5jkyFw/9r
	Av2NtYsgud7aqM0NiTZkRTlw2ZLD8TWeIoADiiu16Z6Bu7xfcDCTE81mEGCrRxmop3ghzqHE6mT
	YLK8VWZKwAff75Gw/LwTJ1b8z/pa+9u4kqiOsdDjsqQJlokwXofT/U+eIvHrk4n2Uhc+b4NfFLS
	Agml6cOmJaFQ==
X-Google-Smtp-Source: AGHT+IFt1TernB5P6diYBIWL/AavdCTOlaqpzrySpPeZUqcetycbtPAfnU//r8D1iw4R5PNNZoaNGJ+Rzok50eKUhPg=
X-Received: by 2002:a05:6214:2c13:b0:882:3759:9155 with SMTP id
 6a1803df08f44-888194f1abcmr77833716d6.21.1764827380949; Wed, 03 Dec 2025
 21:49:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev> <20251204045818.2590727-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251204045818.2590727-2-chenxiaosong.chenxiaosong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Wed, 3 Dec 2025 23:49:29 -0600
X-Gm-Features: AWmQ_blsEQ4BXbbGrQMr1rTFyRAygmGD1bccTRFT_VTxGy-vBcE9rOmz8X2wpNs
Message-ID: <CAH2r5mu25T8sBO4P25St_H0F0KMenn+5QGWx1Tfa+=6AsF6aNw@mail.gmail.com>
Subject: Re: [PATCH 01/10] smb/client: reduce loop count in
 map_smb2_to_linux_error() by half
To: chenxiaosong.chenxiaosong@linux.dev
Cc: linkinjeon@kernel.org, linkinjeon@samba.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>, samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Have merged the first three patches (see below) in this series into
cifs-2.6.git for-next pending additional review and testing.   The
other seven may also be ok - but want to look more carefully at them,
more review appreciated

ba521f56912f (HEAD -> for-next, origin/for-next) smb: add two elements
to smb2_error_map_table array
905d8999d67d smb/client: remove unused elements from smb2_error_map_table a=
rray
26866d690bd1 smb/client: reduce loop count in map_smb2_to_linux_error() by =
half

On Wed, Dec 3, 2025 at 10:59=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> The smb2_error_map_table array currently has 1740 elements. When searchin=
g
> for the last element and calling smb2_print_status(), 3480 comparisons
> are needed.
>
> The loop in smb2_print_status() is unnecessary, smb2_print_status() can b=
e
> removed, and only iterate over the array once, printing the message when
> the target status code is found.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2maperror.c | 30 ++++++------------------------
>  1 file changed, 6 insertions(+), 24 deletions(-)
>
> diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
> index 12c2b868789f..d1df6e518d21 100644
> --- a/fs/smb/client/smb2maperror.c
> +++ b/fs/smb/client/smb2maperror.c
> @@ -2418,24 +2418,6 @@ static const struct status_to_posix_error smb2_err=
or_map_table[] =3D {
>         {0, 0, NULL}
>  };
>
> -/***********************************************************************=
******
> - Print an error message from the status code
> - ***********************************************************************=
******/
> -static void
> -smb2_print_status(__le32 status)
> -{
> -       int idx =3D 0;
> -
> -       while (smb2_error_map_table[idx].status_string !=3D NULL) {
> -               if ((smb2_error_map_table[idx].smb2_status) =3D=3D status=
) {
> -                       pr_notice("Status code returned 0x%08x %s\n", sta=
tus,
> -                                 smb2_error_map_table[idx].status_string=
);
> -               }
> -               idx++;
> -       }
> -       return;
> -}
> -
>  int
>  map_smb2_to_linux_error(char *buf, bool log_err)
>  {
> @@ -2452,16 +2434,16 @@ map_smb2_to_linux_error(char *buf, bool log_err)
>                 return 0;
>         }
>
> -       /* mask facility */
> -       if (log_err && (smb2err !=3D STATUS_MORE_PROCESSING_REQUIRED) &&
> -           (smb2err !=3D STATUS_END_OF_FILE))
> -               smb2_print_status(smb2err);
> -       else if (cifsFYI & CIFS_RC)
> -               smb2_print_status(smb2err);
> +       log_err =3D (log_err && (smb2err !=3D STATUS_MORE_PROCESSING_REQU=
IRED) &&
> +                  (smb2err !=3D STATUS_END_OF_FILE)) ||
> +                 (cifsFYI & CIFS_RC);
>
>         for (i =3D 0; i < sizeof(smb2_error_map_table) /
>                         sizeof(struct status_to_posix_error); i++) {
>                 if (smb2_error_map_table[i].smb2_status =3D=3D smb2err) {
> +                       if (log_err)
> +                               pr_notice("Status code returned 0x%08x %s=
\n", smb2err,
> +                                         smb2_error_map_table[i].status_=
string);
>                         rc =3D smb2_error_map_table[i].posix_error;
>                         break;
>                 }
> --
> 2.43.0
>


--=20
Thanks,

Steve
