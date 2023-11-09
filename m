Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CFC13AC6
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 09:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PeOfvin3"
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1142D4F
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 01:56:04 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9dbb3d12aefso113369766b.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Nov 2023 01:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699523762; x=1700128562; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oa1O1uumpRCtKsVaw6Nfvd64ptjJsLBL5TK0ASq2QeE=;
        b=PeOfvin3QMDFSsSI6FLd2D9a8652NTPvaObOLWRLnDRBdF3qoZIWmhrLn2GX192Ssu
         FgKkg/wxTBfW8QfajumIlXLallJ+8i/nFV4AKhouOnoObcbNgNzu9jK5A6f1RTRSjxQx
         m02Ltq5TOb1dL6/mEcmnUIEoT4/ac7XB+SLvD3yxMNWUeoDpElmnTJtT3J2lpxApvrUd
         89wZvOa0RkSJVCjQIiz1JaFQP/hZbRqIzgO7RF+A4uuApYNZhyrUO+7UCVhw2Um3ndEl
         DHs1jJPRHlHNpwUa/owVViiBW2uBP9qm1HGWBR+Dh0IQ2GAQCqB0rcZ6JAizy1QeQyRC
         f6wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699523762; x=1700128562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oa1O1uumpRCtKsVaw6Nfvd64ptjJsLBL5TK0ASq2QeE=;
        b=qgRQE2Un9i3oO6eTJ+dQrcCf35W2M6tXPH2dSSbqqMjDJ6+TyIM+xYIyMKY9CepNX4
         QeJoSEhXNWIks3mRvxLgEzGOkdwbobS00ZzwXTJFaaT2gEXhNTfqlw/N7UcvpA4Xcmml
         UHLuaANJiNkkXv7hC1kd9tspC4NvT0VlzpKLkpIBhdBZG//4xCsCgM0iK9ZcxmoAZ6hr
         lAluiMNVUaZ5dCowLiJVPqTNSqq4NvZ7P9gJG1qLdNoUAhA6sC//2J00fwza+dWFmKEj
         NbYcBR0UagDQNUyhh+Na3oSdZ7+6xLmwQZg0N+eWO0scjRiR6i67DBiZSiSXeWXAqy8d
         sUAg==
X-Gm-Message-State: AOJu0Yz5+bDM3a9V0FHi8Mu7ZcxJd41Sv+nOslVeo+nfk4dRVm5Iqylf
	h72IYedKbfcJ+qGFmpvGPjYbi3eMQR6w772+pXxSKSBCl/U=
X-Google-Smtp-Source: AGHT+IEf2oLA7/EuDkhRLu6Dwd5K9A/KHfEuXHsJD44IGNrkuuElv25M1Y2IBeOMGq/UNoNy+prSFF8YXJNazuPEwgs=
X-Received: by 2002:a17:907:72d2:b0:9e0:5d5c:aa6d with SMTP id
 du18-20020a17090772d200b009e05d5caa6dmr3866113ejc.20.1699523762325; Thu, 09
 Nov 2023 01:56:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADCRUiNvZuiUZ0VGZZO9HRyPyw6x92kiA7o7Q4tsX5FkZqUkKg@mail.gmail.com>
 <d2c0c53db617b6d2f9b71e734b165b4b.pc@manguebit.com>
In-Reply-To: <d2c0c53db617b6d2f9b71e734b165b4b.pc@manguebit.com>
From: Eduard Bachmakov <e.bachmakov@gmail.com>
Date: Thu, 9 Nov 2023 10:55:36 +0100
Message-ID: <CADCRUiNSk7b7jVQrYoD153UmaBdFzpcA1q3DvfwJcNC6Q=gy0w@mail.gmail.com>
Subject: Re: Unexpected additional umh-based DNS lookup in 6.6.0
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 4:43=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Eduard Bachmakov <e.bachmakov@gmail.com> writes:
>
> > When attempting to mount (mount.cifs version 7.0) a share using
> >
> >     $ mount -t cifs -o
> > vers=3D3.1.1,cred=3D/home/u/.secret.txt,uid=3D1000,gid=3D100
> > //smb.server.example.com/scans /home/u/mnt
> >
> > it succeeds on 6.5.9:
> >
> >     mount("//smb.server.example.com/scans", ".", "cifs", 0,
> > "ip=3D192.168.5.43,unc=3D\\\\smb.server.example.com\\scans,vers=3D3.1.1=
,uid=3D1000,gid=3D100,user=3Du,pass=3Dmypassword")
> > =3D 0
> >
> > but fails on 6.0.0:
> >
> >     mount("//smb.server.example.com/scans", ".", "cifs", 0,
> > "ip=3D192.168.5.43,unc=3D\\\\smb.server.example.com\\scans,vers=3D3.1.1=
,uid=3D1000,gid=3D100,user=3Du,pass=3Dmypassword")
> > =3D -1 ENOKEY (Required key not available)
> >
> > (or ENOENT) though it still works with using the IP instead of the doma=
in:
> >
> >     mount("//192.168.5.43/scans", ".", "cifs", 0,
> > "ip=3D192.168.5.43,unc=3D\\\\192.168.5.43\\scans,vers=3D3.1.1,uid=3D100=
0,gid=3D100,user=3Du,pass=3Dmypassword")
> > =3D 0
> >
> > Based on my reading ever since 348a04a ("smb: client: get rid of dfs
> > code dep in namespace.c") dfs_mount_share() is now calling
> > dns_resolve_server_name_to_ip() early and unconditionally. This can be
> > verified on a running system by enabling dns_resolver logging (echo 1
> > | sudo tee /sys/module/dns_resolver/parameters/debug + watch dmesg).
> > An additional DNS lookup is attempted in 6.0.0 that previously wasn't.
> > My best guess is that ENOENT is "didn't work" and ENOKEY means "didn't
> > work but cached".
>
> Yes, this is a regression.  Commit assumed that there would be always a
> dns_resolver key set up on kernels built with CONFIG_CIFS_DFS_UPCALL=3Dy
> so that cifs.ko could safely upcall to resolve UNC hostname regardless
> whether mounting a DFS share or a regular share.
>
> Could you please try attached patch?

Can confirm, this works. No more UMH DNS lookup, share is mounted successfu=
lly.

I don't see is_dfs_mount() being called so in my scenario we're simply
relying on kzalloc initializing dfs_automount to false.

> Thanks.
