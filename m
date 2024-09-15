Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385771B3A;
	Sun, 15 Sep 2024 21:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726434904; cv=none; b=nxj/HgqXR26DaPO84D3EFXYBax8eD7C97TLsOQuWW2nZajo9VGon2D4/JCHJCTJ2yDvwLYo6svMGwbFBIiHGEy0+UCbvP0+MvX36wplUouKWxkcbPoS1AM96z5hX9tNJimYbedYz7gnMvkMBbxUahfrkYANnW0gbMtIOfLjaINM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726434904; c=relaxed/simple;
	bh=txhWcGG8CfXEdLXos9+WOR9RFYic05Z9cYZN3DhZQWI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hmHgAZ3DEGF6QFCNIgqYIGjI0jsPbmnGaA09wKV6FEJucZmsdlcyXStCwFi8dv2Hon1CANoTNll4sVcUmLRNq+e1Ecir8DHU5k23SlQOyWJSnqVmrN1rSvnEfE+W2Jps/E6M7uYShu8JylDTMOLDiXxtq6VjrG4vBIrgrft+gkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LY5cnY65; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LY5cnY65"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-53655b9bbcdso4533818e87.2;
        Sun, 15 Sep 2024 14:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726434901; x=1727039701; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+5DU3xtN3aEOgSko+Iu7voI/QA/frYZ7n62pfo+DV0=;
        b=LY5cnY65MN5Pb6yHS02MRlaikWHAGcP9ewJyexYHmDvPQbkr+7ep+XrNhW7yKJBJDu
         ksfoHCz3dcLxsyYdsDM+7XMG8i7r6EegLgEZaaF1j9ZWwg3F8t45CxVzcAQULzmXKyqH
         QI4a+0bjSAQf5ki9p7D4mQ7GnuQntkBVeOxgwqVkmA7RhUapU+pxVTZZD54Lt/IrRjQG
         9MJ2YYjEl3odcA0Rb9KIzjtj+da9a/AgAmt6nUU4wMHo3SExPGIhI0zaC4hQIG3FtIMc
         aydFzRT6lukdxxGEGJHB2/B7S85dSOQLCTvnNjUFJduBfeilUenI1VXl/IB4hwD+6Lwq
         SDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726434901; x=1727039701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D+5DU3xtN3aEOgSko+Iu7voI/QA/frYZ7n62pfo+DV0=;
        b=g75auxA8Di36jsmAoWpahAsp4ME9ByEoKVG1orKH82f2wtPvdYkVhUL+COWZExhaYb
         guB1nwHvR0044IOEj0TXMZxaQ26gNSnDVsJ7lEj7XpHDF5nbd7wbK4HbbKZk0Z5MRVi3
         aegegGXOFH51+aUBf7VEtI/bsxKE4YEy4cf7ZGhE2EqINo+dMM8H3vuKYUnc4atdOitp
         GGKTy120I5Vgtr2ic004mbRVHNO3achU/kIXdcrNzx8/xLvsLIoredHNmaqH5i1PoI42
         dLHSR24wzEjNCsL2oQxFvThpJiTix61+0dZYQs7lRLZGLfJKHHdnABr0mA5H5ErREHPB
         7mJw==
X-Forwarded-Encrypted: i=1; AJvYcCUCBTF1hksx2YWtXleCYHYXVe1ryscrZ5qpNimxC988PtefaLNp/ZZOaZKiPTsaVTiiHA0ZXChjm0ed@vger.kernel.org, AJvYcCW69mICN1CjSXCJAhp4jj6/4wbMJn2oQB/YY6iFN+baPklHsdNN5+/APqFKxWj2T3MdzL/9kN5DG8tyoR82@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm3tPprYoQmTT4jXRGwHGt9IV5kQeYIN6+iBfiRittJ4ijk6JX
	mEmC028y3obw+y6La//5XHv9SjCt5BJ3YG/lJY6vsqJsEOH0uKZECeKrD2Cqn2CVXVl89I3gsVr
	ryPkkpgGoe4tdravYvx6+8UXzIQQ=
X-Google-Smtp-Source: AGHT+IEwBBUF7hyt7YeuKRP/mN7bvf9Ypr8cdRExledHjfeVGcMiYM8wHWUy+PQdAh80oxQ8sgSqOI5dhsy2EY9Prw8=
X-Received: by 2002:a05:6512:10ce:b0:530:ba4b:f65d with SMTP id
 2adb3069b0e04-53678fbf80fmr6547275e87.28.1726434900395; Sun, 15 Sep 2024
 14:15:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912120548.15877-7-pali@kernel.org> <20240915194545.14779-1-pali@kernel.org>
 <20240915194545.14779-5-pali@kernel.org>
In-Reply-To: <20240915194545.14779-5-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 15 Sep 2024 16:14:49 -0500
Message-ID: <CAH2r5mtimz32E=65vb0NTM=D8B7aMYz6N1+E960_Q+Mh4ZneOg@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: Update SFU comments about fifos and sockets
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Sun, Sep 15, 2024 at 2:46=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> In SFU mode, activated by -o sfu mount option is now also support for
> creating new fifos and sockets.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/cifssmb.c | 8 ++++----
>  fs/smb/client/smb1ops.c | 2 +-
>  fs/smb/client/smb2ops.c | 2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index cfae2e918209..0ffc45aa5e2c 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -1076,8 +1076,8 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_t=
con *tcon,
>         pSMB->OpenFlags |=3D cpu_to_le16(REQ_MORE_INFO);
>         pSMB->Mode =3D cpu_to_le16(access_flags_to_smbopen_mode(access_fl=
ags));
>         pSMB->Mode |=3D cpu_to_le16(0x40); /* deny none */
> -       /* set file as system file if special file such
> -          as fifo and server expecting SFU style and
> +       /* set file as system file if special file such as fifo,
> +        * socket, char or block and server expecting SFU style and
>            no Unix extensions */
>
>         if (create_options & CREATE_OPTION_SPECIAL)
> @@ -1193,8 +1193,8 @@ CIFS_open(const unsigned int xid, struct cifs_open_=
parms *oparms, int *oplock,
>         req->AllocationSize =3D 0;
>
>         /*
> -        * Set file as system file if special file such as fifo and serve=
r
> -        * expecting SFU style and no Unix extensions.
> +        * Set file as system file if special file such as fifo, socket, =
char
> +        * or block and server expecting SFU style and no Unix extensions=
.
>          */
>         if (create_options & CREATE_OPTION_SPECIAL)
>                 req->FileAttributes =3D cpu_to_le32(ATTR_SYSTEM);
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index e1f2feb56f45..e03c91a49650 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -1078,7 +1078,7 @@ cifs_make_node(unsigned int xid, struct inode *inod=
e,
>         /*
>          * Check if mounted with mount parm 'sfu' mount parm.
>          * SFU emulation should work with all servers, but only
> -        * supports block and char device (no socket & fifo),
> +        * supports block and char device, socket & fifo,
>          * and was used by default in earlier versions of Windows
>          */
>         if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 406f2399f0c5..d30f7cab197e 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -5190,7 +5190,7 @@ static int smb2_make_node(unsigned int xid, struct =
inode *inode,
>         /*
>          * Check if mounted with mount parm 'sfu' mount parm.
>          * SFU emulation should work with all servers, but only
> -        * supports block and char device (no socket & fifo),
> +        * supports block and char device, socket & fifo,
>          * and was used by default in earlier versions of Windows
>          */
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
