Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A623859EB
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 01:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178109; cv=none; b=spgFATR50mH16O/mamopRPgJ/s0jyY1cwf0dETXNTsUnHUJvf9fyuzTeWgwh1pfgMUI4oXtiEZhzQgk6NbSs74HoE5J73ZuqPShgYNFjqjDIZRzs4s4RNtxy+JnKmrb7V5Lc0YC+mXpq3RGZWO/4aH78KfUSKwvtdadL3jr9hgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178109; c=relaxed/simple;
	bh=8KDpOU0JHMoSSSeTtBm9USzAuYOKj+zCGkX7aXBHBQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Er1yr0x44K3wVMMiirPg84THD6Ynui1fbrYkPpYTuXilrpFSW/5STSIIkyI7wyonukqm6DD4eSHH43nLreE/6sjLl9s67U0b2ovDBASY7hKF8KI7YOqr0OodwgngITPO1J0kznuM3+ryVmCqiBhbbNi1RZYVqN0A/ZDslcanQqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UOA+zxVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOA+zxVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061171F00A3F
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 01:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782178108;
	bh=zpKNZ1t/wxw/lSZ+Ci5rSeZPKyYMNkzHRYL1rw9QQkg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UOA+zxVFBno/pgaSvTmDFf8YCj3MeO3QRSX3rTRCPiprHKUAcaeWYJSsEtAd8Fsqe
	 XnbS+hjbQIoV54ZZJLjwFxOAaqM3bx0eZkuGg/WH08IGfEaEXjtYI2aDw54pyhPQkS
	 +jRyqzYMedKSdZMoXM4GWPb7FQWT/rmUMfb3WSfZmb+svvDPUV4Ve+Jh/07aLRCN36
	 +FFw/f51RkQ3ss6lPV6QfRTjVuPin2I7PSv5qcQQLwQg/6fH2pse/AIFlc2UFlCEsF
	 4AhQbvkhhkbPwuiAIzw8t8MTLwLarXjL9V5HcQJwy2lvgwjC3HIds7rPrDc3o7gWT3
	 Lawwvkmllpd3A==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-695bba79ae1so668846a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jun 2026 18:28:27 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx1WHSAD6ktta18KXmaWtDcNW7AI+Rr/0Ya4U239QRetQ0YHy33
	1FAiKN+M/xfTKGSg+OGd3qM/GlVDCiaOYbsCVcL/vDVDsAS2m5Z/PLVxLFTRJzqtmwGQsA3hETa
	5hC01Zlj5iaXXyPE6P5CTl0V+/2gSaJg=
X-Received: by 2002:a17:907:388a:b0:bf9:b543:bb86 with SMTP id
 a640c23a62f3a-c102eec4498mr86248066b.6.1782178106746; Mon, 22 Jun 2026
 18:28:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260621124844.6235-1-linkinjeon@kernel.org> <20260621124844.6235-17-linkinjeon@kernel.org>
 <20260622230109.GA3328@ax162>
In-Reply-To: <20260622230109.GA3328@ax162>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 23 Jun 2026 10:28:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_7sAUG_zY7V1y06apd0kBNU6ni3vhQyKhKYwDz=ukBfA@mail.gmail.com>
X-Gm-Features: AVVi8Ccvs6sVHatp7iNV6uRt1nYS5efajXB5RJj8QgNck9bLWH8JyWD_gj42qNY
Message-ID: <CAKYAXd_7sAUG_zY7V1y06apd0kBNU6ni3vhQyKhKYwDz=ukBfA@mail.gmail.com>
Subject: Re: [PATCH 17/29] ksmbd: return requested create allocation size
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 8:01=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Hi,
>
> On Sun, Jun 21, 2026 at 09:48:32PM +0900, Namjae Jeon wrote:
> ...
> > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > index d6001cdce085..cca04bf84b81 100644
> > --- a/fs/smb/server/smb2pdu.c
> > +++ b/fs/smb/server/smb2pdu.c
> ...
> > @@ -3926,8 +3927,19 @@ int smb2_open(struct ksmbd_work *work)
> >       time =3D ksmbd_UnixTimeToNT(stat.mtime);
> >       rsp->LastWriteTime =3D cpu_to_le64(time);
> >       rsp->ChangeTime =3D cpu_to_le64(fp->change_time);
> > -     rsp->AllocationSize =3D S_ISDIR(stat.mode) ? 0 :
> > -             cpu_to_le64(stat.blocks << 9);
> > +     /*
> > +      * The cached allocation size hides filesystem rounding for the
> > +      * requested allocation, but it can go stale when the file grows =
past
> > +      * it via writes (e.g. across a durable reconnect). Refresh it on=
ce the
> > +      * file exceeds the cached value, rounding the end of file up to =
the
> > +      * volume allocation unit (the filesystem block size, matching th=
e
> > +      * SectorsPerAllocationUnit/BytesPerSector ksmbd advertises) rath=
er than
> > +      * using the raw on-disk block count, which can include filesyste=
m
> > +      * preallocation and metadata rounding.
> > +      */
> > +     if (!S_ISDIR(stat.mode) && stat.size > fp->allocation_size)
> > +             fp->allocation_size =3D roundup(stat.size, stat.blksize);
>
> This patch is in -next as commit 64ab25180b27 ("ksmbd: return requested
> create allocation size"), where it breaks the build for 32-bit
> platforms, as stat.size is a loff_t and roundup() performs a plain
> division:
>
>   $ cat allno.config
>   CONFIG_INET=3Dy
>   CONFIG_NET=3Dy
>   CONFIG_NETWORK_FILESYSTEMS=3Dy
>   CONFIG_SMB_SERVER=3Dy
>
>   $ make -skj"$(nproc)" ARCH=3Darm CROSS_COMPILE=3Darm-linux-gnueabi- KCO=
NFIG_ALLCONFIG=3D1 mrproper allnoconfig vmlinux
>   arm-linux-gnueabi-ld: fs/smb/server/smb2pdu.o: in function `smb2_open':
>   smb2pdu.c:(.text+0x765a): undefined reference to `__aeabi_ldivmod'
>   arm-linux-gnueabi-ld: (__aeabi_ldivmod): Unknown destination type (ARM/=
Thumb) in fs/smb/server/smb2pdu.o
>   smb2pdu.c:(.text+0x765a): dangerous relocation: unsupported relocation
>   ...
I have fixed it. Thanks for the report:)
>
> Is this series intended for 7.2 or 7.3? If it is 7.3, it really
> shouldn't be in -next during the merge window...
This series is intended for 7.2. Since we just updated our tree, we
expect it to be merged in linux-next today.
Thanks.
>
> --
> Cheers,
> Nathan
