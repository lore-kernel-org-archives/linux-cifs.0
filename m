Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363EE309F0E
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762272747; cv=none; b=kMVJ+Si36ldPjfb48KJgPnSVS8knrA2oJD520b221ToE/qeLWlGevWjdFqVgszGxq87QNCV5TElou8IAPGNysFQ//ham38d9ZTjr1uhWJdRy1PEKOWg+MWBAxdvJR3uuVxAKDnvv0q4QAxUb2xq5dE2fARSf0vVdb8j2ulgIv3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762272747; c=relaxed/simple;
	bh=4kgZK9PEsWHNk3PqlA9LLgsQrG06zbKbx2metOUutm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vvd99bJPu5p/jGepu/+/XovXnnTGdgHA6SsCvDWvk0zKHCl6IGMLqj0zpez+Ylm22V/ZsBeX9Ww2bmp3MGzCxFUYry2maaBVb7ID+0mJ674lfce1u4PDHIuAL/IUBmBP6kNC8NZ/XXxg4n1iyqVzc4fT2tyo177Z3QNa6TGK5F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VJGRP0pg; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VJGRP0pg"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-88025eb208bso49471676d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 08:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762272745; x=1762877545; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gn2hwuUiPC8/Q2G266HcOJ5nNM1p+pgOQFA8M+yNExQ=;
        b=VJGRP0pgYy+/Z0UptJz1aN1gwHkKHBTBNX0NmVYA6zq0Rww8DpYBUjuOVF0Q3LJKLj
         Zb0OAzCugbpP/hU3q9uH7VXhq65R1TjJsKNSc9HErbn9geGD2RTQvp4w8iO+TQhYQFqt
         zND7ECaGfDUICPJVPmhEwXhkVg92J3RLvlWeBz0I4lyButkuvg2NK4sKDfNTUzSxhGAC
         s50mDobzRaeRPPDeaJ3+laqUtShPTQpr7u8flAt6xJIBIUpikhMtdihGSVqEH7C8T0kG
         P0L0Doo9jamDUzYEckJ7yOvpi64FnolBu6alTIBQbPCIQtVlWBtRRaCYA7Zl5hvjQ4EI
         4U5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762272745; x=1762877545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gn2hwuUiPC8/Q2G266HcOJ5nNM1p+pgOQFA8M+yNExQ=;
        b=SQY/Gs1HoA+Dbv/tvJSgQlwbWHPdtzQYIJB+ycAiqKUsF5RI6z0LeOvSOV8+NWm+Vg
         /aUp95NVGfDOny3H9suvzfKNFcLl/ALH6517Mc3zC7camWYGErCecQg9O+6wvyx7XHEF
         EzsK6vIm/3xBJoSyAnodJCPrzO3d7q7MRX93AClg76QJYrFMzUkwTWq6HByLYoq22oYQ
         umej/VKtXJUMI95TZUHwTYawkeGiA1cAfeJvMr6lyfRXlDlvLbVM9SFPra8NuUmfDCfK
         M/tAyEAl5I28fWy+15yMc7SU5s2WClt/tN+gSCxzXpYXbTQESOXfJPucx4hA0MikDD9w
         ycDQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1pT1SoGELE7NMQbS7lndh3EUgIohoo9cFvwKpJ3V9USf+QHXzWstYH+nKjxQIwYwqCrQBNflUPf6d@vger.kernel.org
X-Gm-Message-State: AOJu0YwRZ6h5Wo15Q3J0QIP1Mgbg/SR9VjlQC6N6610J3Gp0nz8WSC6h
	fxG/dIOKCESQGVSxE6VR50eq3NRFNOdTI9hh+OprzLZNtARqjWC0Ka2BMzzqDJAyCyLaL/21ApC
	ZIhM5asrXkdCYep5ANzVuXG/g69W7oCzl4UPB
X-Gm-Gg: ASbGnctjsB4h/+qDQDYRR25y/YNCwOoNOUgJYlbJPVP4uctj56d/8dZg0JCnqirLSfS
	O2i0Qs71dCdRv44xCF73D5G4kr5yll5E34KeXKQc/xGjRfgV4ojsXIfeEjuMLCEHiiCBiPCt/hL
	Dd586vq2fV2qGr1LRALbZE2mUTr7BDRzQh8Du/r/cmOLUlXtJdjzZSUAPp9mQQxsUcVdMSEwJv2
	EAv7zQdBR8YACIZrAhUrQwSGcvCBUsAyh99HbitOqUiSEmW6LAIoJWt2TGUQOLX3Gv4hlqMnbPC
	JdGqBv2FieNfpfSxdFWq28Y4zIdsPc0FB2H5WuIITqF0jHFNmhQsMjFuolroxl7ybXDW+AWtKHC
	PUQW8GwmAJvSl3aQXHYNXWA+P/ek0tKP6PIsosRo=
X-Google-Smtp-Source: AGHT+IED+GjqaBe66KWozlF5qlUX46+UXTDSGyStL4Ec1xFghQ8tKmJeoeUM3fbVkK6cckiH8C39lCagfXCl3ojuYgM=
X-Received: by 2002:a05:6214:d63:b0:880:5365:46f3 with SMTP id
 6a1803df08f44-88071190af1mr1980246d6.48.1762272745039; Tue, 04 Nov 2025
 08:12:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aQoYCxKqMHwH4sOK@osx.local>
In-Reply-To: <aQoYCxKqMHwH4sOK@osx.local>
From: Steve French <smfrench@gmail.com>
Date: Tue, 4 Nov 2025 10:12:13 -0600
X-Gm-Features: AWmQ_bnENIVd9iuIwtt-CFvdgGVQlHaSwLipDA4bB04baKUxG5zWSRWEKYEzUVY
Message-ID: <CAH2r5mu7s4p88RhUbCm5mqUvEVM60OOTTJOZ+rz09nFfc+t3mQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix refcount leak in smb2_set_path_attr
To: Shuhao Fu <sfual@cse.ust.hk>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

There are multiple callers - are there callers that don't call
"set_writeable_path()" ?    And so could cause the reverse refcount
issue?

On Tue, Nov 4, 2025 at 9:21=E2=80=AFAM Shuhao Fu <sfual@cse.ust.hk> wrote:
>
> Fix refcount leak in `smb2_set_path_attr` when path conversion fails.
>
> Function `cifs_get_writable_path` returns `cfile` with its reference
> counter `cfile->count` increased on success. Function `smb2_compound_op`
> would decrease the reference counter for `cfile`, as stated in its
> comment. By calling `smb2_rename_path`, the reference counter of `cfile`
> would leak if `cifs_convert_path_to_utf16` fails in `smb2_set_path_attr`.
>
> Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by=
 path name")
> Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
> ---
>  fs/smb/client/smb2inode.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 09e3fc81d..69cb81fa0 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1294,6 +1294,8 @@ static int smb2_set_path_attr(const unsigned int xi=
d, struct cifs_tcon *tcon,
>         smb2_to_name =3D cifs_convert_path_to_utf16(to_name, cifs_sb);
>         if (smb2_to_name =3D=3D NULL) {
>                 rc =3D -ENOMEM;
> +               if (cfile)
> +                       cifsFileInfo_put(cfile);
>                 goto smb2_rename_path;
>         }
>         in_iov.iov_base =3D smb2_to_name;
> --
> 2.39.5 (Apple Git-154)
>
>


--=20
Thanks,

Steve
