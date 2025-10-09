Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C0EDF6C
	for <linux-cifs@vger.kernel.org>; Thu,  9 Oct 2025 00:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759968759; cv=none; b=pf24YFGcx7E3pUrUD7zXvR6bjhAbpl1bz90TbH23rjlh+mrEXhL6OnQBH52aPgqjOXbY4ac0VflC7CVJV9UizS1H33mNW+38U9SrKiMkWL4wooXk7kTOrHhm83a7LkbneV1kKL7YcOtNAl2Jb0dMWeLqU3bUK6IOARGJModfuXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759968759; c=relaxed/simple;
	bh=Z0JF/h8mBUCqcPAR13Gn4OPXCm3qaHZYWJB6uhLvJtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rqSCf7vidsg7ULFIfbaAG+c6tlG6O5/yzVRYAJwQ+ke7TGZ4VufScdR4k9ATiJtDXkUJvEMOWy6w13TtlmkPL58XPxGci+L2OUfNq53r+zQyZunD8UYNf9nqaOeR7YOAqyutSIeUmfbElU8mG2O74NcpRl1xx0c5u0Ck2YWWp+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DLDVNUOk; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DLDVNUOk"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4e06163d9e9so3146191cf.3
        for <linux-cifs@vger.kernel.org>; Wed, 08 Oct 2025 17:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759968756; x=1760573556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iLOs0m+C5vy8eU1JuQcMkicCaJKpraCdPB1zIalrqqQ=;
        b=DLDVNUOkky4k1sok6w7IfZN1sYj1GMmOaLvooxszPDdZn8YxmOwoNqgnOjAiH4AQ+2
         0Gg0nnLNt90ImTl0WeO7iuuVQnxwXl3pAnbusMS9TxlfPhILRqRqLBFGhCjxLiJ11mou
         9gWxK/JMEcxZK2qysIR8oB5yB/CRC0QfPkzvRD+X4pyUEJR4b0SIEctQRUME+mVZ2Ocz
         /hReImJNenpbKGAlmv5KOvkWsARcHHS+AFkIw+tiZoppOcFoieVtFTzHwB83Tq2Z2vib
         PCuG8RpKWOjfwl5mJho2MlY/9XMfRFAPMI8TX56OQQgfg8S5hdKQwWIiMZRTdUiQjLBa
         48Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759968756; x=1760573556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iLOs0m+C5vy8eU1JuQcMkicCaJKpraCdPB1zIalrqqQ=;
        b=i6CZzWX6980GMeEaNTDHPcePKqq0v43GQjq46iJJUpnOkY+GTnZsNkNoSbJwhrDUTz
         7+5LauBh8XAPknq92ZDOUiRr2IF4euefjG3mFKIW34I0zN7pq31ucih103m52aA2Jjy9
         rNvxwg/KP788zrVkpmuFPTIa7YY7/0+a8vZT+TzVlAQIY0rxYpMYf4M01ddAbzY6H0t1
         s6z3m4CBxA7dDRToMzj0WHidcL9JCFwD5UnYn+x69Mhf6F5Jheb+ryQFNISyJs/SMnNh
         bi7MtvZBDXXfLjxb6lgfRbChx8dCPDvd1meqJyldrcG0UTATLmxurPJN6jSvgsIoRY4C
         uPhQ==
X-Gm-Message-State: AOJu0YwELJjAd7TMzAEajVJPyr2WcIsdoXWFndKGQZOKapA9KgqgTCcM
	bLUR8TfW1cd+3sjHBm85Lft2j4ngJSiq+m5rq8/t7+ywBYmIzZL2A35UF4sRCGKUMtQAlbGdI8v
	4+AVnjINLrvZqPVpF/efaEF/kjI6OzGg=
X-Gm-Gg: ASbGncvVDDZHaof7Oz3FcAGWZPVwx6jg2lLxIHJYyF1+quvQYzEz2t0m7EdnV+JZDOx
	pktldZLPvmK0ZNlvP99rY1SVAAGvLuBgelVoDsvZjD8SYtw2Io56SZxn8me8lXnHFcRxMoway7F
	Vj1l3f4KH7w06rTH5lFlZmxqxWSiyU3DnVsYSXjY3tkTvod+qqjzKgvMcxK8T3/9zDAypMqWENK
	GzKvrq3F3SZ3aZuK+h/w0gvVB7RwqkKZUgaz3DxHA4zN5AKxAYTLLIXGDMAGKThv+S5TDKa1u4p
	Ku/RBs946ybO0VBSIb3MSpAdiEZQvAmXNyWF4OqPaV1LkQEjtril2DQwOok1oCx7AaUEzxo+p0e
	tQopFxlBHo2ShWdmOtr5qOXkayRf4fjOD0pzWFY/uB2gmQQ==
X-Google-Smtp-Source: AGHT+IGTMJxEUzyjJOaL0+NNwHEI9UfsX87q17OQxRmhejzUvwBxmkwB9k17auDXhJE1cMaLG7jkj1CnKy1ELrzjvrA=
X-Received: by 2002:a05:622a:6a42:b0:4e6:ee71:ee96 with SMTP id
 d75a77b69052e-4e6ee71f26cmr35134331cf.25.1759968756008; Wed, 08 Oct 2025
 17:12:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5b95806a-e72e-4d05-9db8-104be645e6e5@web.de>
In-Reply-To: <5b95806a-e72e-4d05-9db8-104be645e6e5@web.de>
From: Steve French <smfrench@gmail.com>
Date: Wed, 8 Oct 2025 19:12:24 -0500
X-Gm-Features: AS18NWBDO6yK69iSBzCC-3F6icpJXqhtpmdffwn6wWQE7dyQKytMaHCk49ryAxs
Message-ID: <CAH2r5mtrT7m71i2928akVarmQ0FTKzaEOu2q4781U8a-_w__ZA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Simplify a return statement in get_smb2_acl_by_path()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>, LKML <linux-kernel@vger.kernel.org>, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Wed, Oct 8, 2025 at 3:02=E2=80=AFPM Markus Elfring <Markus.Elfring@web.d=
e> wrote:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 8 Oct 2025 21:56:34 +0200
>
> Return an error pointer without referencing another local variable
> in an if branch of this function implementation.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/smb/client/smb2ops.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 7c3e96260fd4..bb5eda032aa4 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -3216,9 +3216,8 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
>
>         utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
>         if (!utf16_path) {
> -               rc =3D -ENOMEM;
>                 free_xid(xid);
> -               return ERR_PTR(rc);
> +               return ERR_PTR(-ENOMEM);
>         }
>
>         oparms =3D (struct cifs_open_parms) {
> --
> 2.51.0
>
>


--=20
Thanks,

Steve
