Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229772C6BB;
	Wed,  7 Aug 2024 18:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723054927; cv=none; b=df96uIvZbABgHPYwnYT+IqaqsVLG8Sno5yB+TqJiADfRHbDbTyIcy47kwgMrGtWHem/J3QI0oZN+frqfAiXF1R9hDHk6CJahMnw9q6Du+AkEX/g0QrmxUxvMExxvH0HbWyqSUe790/57VupZXa85aAC40gPV6NmYmbS+SmObww8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723054927; c=relaxed/simple;
	bh=fDfcFdmakI++BkXYuEP/btbJ62BTnOOKW0jQ+rr4vxo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t7dovMEJqFRA3fnAwl61fRJoVdtWZ6S0C8HNWx2xwAbA1WziBPo/kf3kCHTBoo3xbKJO6Wyyg9Tebg8M0dNBpWSqvhc4Ffs2C8efiqU3EhvoTMzwbYu4pTMkOSlH91OM3ROyL7q9yBkjYBjcCjVn1KO1E8qYOaMSzclSS+PG8Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U40SNU4Z; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U40SNU4Z"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-492959b906eso57284137.0;
        Wed, 07 Aug 2024 11:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723054925; x=1723659725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YiD65ALE8vSuJ/TYiGjXSUpB/Z9nRB8hNQrAdGVuTNM=;
        b=U40SNU4ZNy6fs6pxRMcWZS3ZcoKvlG/bLE9Cc8yPPRH96oIZ3GCnSxGc20r9+chZgr
         DoZhUnKETNM2Nx4WVLbQwvondbkabhdOSv0U7vVEM09JDoN856WsoNpSvm30yOBBQaqZ
         P5Yw5ifv07IqabsVk0QiQrzkIDjhoJHp3gquyrnY4SBKybyPKekQA8L3DNtAEuX++b0I
         tI/h9hdzdi4I7uLzBn8iba/BQnwzCGPchHqYFI+wDV5rTaMbL21SXtRMuwgtP4Fc2+bL
         GMcEv77paQLdh5VYe839Jdo2LKbd1Zq7DHQ532kqiGw0s2/BYRNfXpfZRyjMp8fgrr3R
         kA1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723054925; x=1723659725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YiD65ALE8vSuJ/TYiGjXSUpB/Z9nRB8hNQrAdGVuTNM=;
        b=kZi826eQrI8M4JxFoP0/hSSYZU3vwNkc6uDrG7zfJwISMAHWM/0ZedUh1h3ySs+vEf
         9QUOD4DgIlnDjs6vl6l19FZ4FV4+urQ1VTZKZ0OgIluIo2ZCL+NwRK3EioDZL4+kZDrg
         c5CFmboiFvPCD0rO5sJDldh984IffLNpQx9Zj5BDhTvqyVoO9AWCkHnRTDuhFRdzetDE
         tlhXBz0yNchveJqkYp8/oPzEgkIv+5EBsbJsgPZv3xNFSjshRKXUCI9K69iS+Ns2yj+I
         a6EHFJxFGQHfWWfU/4X+RwJriIfeQrnmyegaEahD4Fu7jbDqIlAkND7UUYdn+6oOwmaQ
         X2eA==
X-Forwarded-Encrypted: i=1; AJvYcCVerB5AupnAv9lPozowuDlkpk3kS+ZBIns1xpmLTqz451K5gXVAw8wttGS+bMuiQJIAogFWMrmFZGd0Y7KFv0jwJDeZuewU5jZXZs2s
X-Gm-Message-State: AOJu0YzTOhfA2cUD/kE6LFh8BIpfvqA9ub1u9zKcQKXgdMGGj8yFrRDQ
	CbUNaHYhb1Fh0vHMAShIIMGqzRY+mtL3eaWGEWwCqGOtntOweNt/XiB79EW7F/Vgey09wpIHS0x
	jnSQCGv1MghAg4NLsgLr/MOvlPexisKNSq58=
X-Google-Smtp-Source: AGHT+IF+J5Zq7SgYt7XYbQ2oOHbhfYqZksxMQWoCSQ7rhmm9huPiKHpPgRelTV3bZdIXPOJzmMs2DkgqaKhPVbX6vTU=
X-Received: by 2002:a05:6102:6d1:b0:492:a11f:a87a with SMTP id
 ada2fe7eead31-4945bf055d5mr23227164137.25.1723054924882; Wed, 07 Aug 2024
 11:22:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c0967665-343d-4ca9-90a0-a072159c1056@leemhuis.info> <ZrOwPx+jhEM+sJFM@nandaa-linux-dev.lp3xo4ddmz1ulowbk5mwlke0vc.bx.internal.cloudapp.net>
In-Reply-To: <ZrOwPx+jhEM+sJFM@nandaa-linux-dev.lp3xo4ddmz1ulowbk5mwlke0vc.bx.internal.cloudapp.net>
From: Anthony Nandaa <profnandaa@gmail.com>
Date: Wed, 7 Aug 2024 21:21:53 +0300
Message-ID: <CAACuyFWCsnYQvqsz9ZuCCkxZ9hPC_BjSLF_mDj_0aPwmXqj3_g@mail.gmail.com>
Subject: Re: [regression] smb: client: - Failure to mount DFS namespaces
 without ASCII symbols
To: Linux regressions mailing list <regressions@lists.linux.dev>, smfrench@gmail.com, 
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, gkorobeynikov@astralinux.ru, 
	linux-kernel@vger.kernel.org, annandaa@linux.microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Aug 2024 at 20:34, Anthony Nandaa <profnandaa@gmail.com> wrote:
>
> On Fri, Aug 02, 2024 at 11:44:18AM +0200, Linux regression tracking (Thor=
sten Leemhuis) wrote:
> > Hi, Thorsten here, the Linux kernel's regression tracker.
> >
> > Paulo, I noticed a report about a regression in bugzilla.kernel.org tha=
t
> > appears to be caused by this change of yours:
> >
> > 3ae872de410751 ("smb: client: fix shared DFS root mounts with different
> > prefixes") [v6.5-rc1]
> >
> > As many (most?) kernel developers don't keep an eye on the bug tracker,
> > I decided to write this mail. To quote from
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D219083 :
> >
> > >  Gleb Korobeynikov 2024-07-22 10:59:46 UTC
> > >
> > > Windows version of SMB host: Windows Server 2022 Standard x64
> > > Kernel: 6.3.13(upstream)
> ~~~~~~~~~~~~^~~~ Testing with same WS2022 host with 6.11.0-rc1+
>
> > > CONFIG_CIFS_DFS_UPCALL
> > >
> > > In the function cifs_inval_name_dfs_link_error(), a check was added f=
or tcon->origin_fullpath (3ae872de410751fe5e629e04da491a632d95201c). I beli=
eve it's unnecessary because when mounting a dfs name without ASCII charact=
ers, we always fail at this check and exit the function, leading to dfs nam=
espaces not being mounted
> > >
> > > Steps to reproduce:
> > >
> > > 1. At Windows, create DFS namespace with name containing non-ASCII sy=
mbols (for example =D0=B4=D1=84=D1=81)
> > >
> > > 2. mount -t cifs \\\\<smb_server>\\=D0=B4=D1=84=D1=81  /tmp/dfs -o do=
main=3D...,user=3D...,password=3D...
> > >
> > > result:
> > > mount error(2): No such file or directory
> > > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kern=
el log messages (dmesg)
> > >
> I couldn't repro this issue.
> I rebuilt the cifs modules both on master and in the recent
> for-next@cecb49e3594c2a69163865c214b71fff26d5761d sources:
>
>         $ sudo mount -t cifs //WIN-31GSG2M9E6N/=D0=B4=D1=84=D1=81 /mnt/ut=
f_repro -o `
>                 username=3Dadministrator,password=3Dxxx
>         $ ls -l /mnt/utf_repro
>         total 0
>         -rwxr-xr-x 1 root root 0 Aug  7 15:54 hello_cifs.txt
>         drwxr-xr-x 2 root root 0 Aug  7 15:54 test_utf8_=D0=B4=D1=84=D1=
=81
>
>         // nothing outstanding in dmesg
>         [430885.246220] CIFS: Attempting to mount //WIN-31GSG2M9E6N/=D0=
=B4=D1=84=D1=81
>
> Is there anything I might be missing?
My bad, I wasn't creating a DFS namespace, it was just a share.

I have also seen the recent updates on
https://bugzilla.kernel.org/show_bug.cgi?id=3D219083
I had missed that.
>
> > > CIFS debug log:
> > > [Mon Jul 22 11:00:24 2024] CIFS: Status code returned 0xc0000033 STAT=
US_OBJECT_NAME_INVALID
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/smb2maperror.c: Mappin=
g SMB2 status code 0xc0000033 to POSIX err -2
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/dfs_cache.c: dfs_cache=
_noreq_update_tgthint: path: \test.local\=D0=B4=D1=84=D1=81
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_=
smb_ses: ses_count=3D2
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_=
smb_ses: ses ipc: \\test.local\IPC$
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: cifs_put_tc=
on: tc_count=3D1
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: VFS: in cif=
s_put_tcon as Xid: 17 with uid: 0
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/smb2pdu.c: Tree Discon=
nect
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/fscache.c: cifs_fscach=
e_release_super_cookie: (0x0000000000000000)
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_=
smb_ses: ses_count=3D1
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_=
smb_ses: ses ipc: \\DC.test.local\IPC$
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: VFS: in __c=
ifs_put_smb_ses as Xid: 18 with uid: 0
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/smb2pdu.c: disconnect =
session 00000000360c6881
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_=
smb_ses: ses_count=3D1
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_=
smb_ses: ses ipc: \\test.local\IPC$
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: VFS: in __c=
ifs_put_smb_ses as Xid: 19 with uid: 0
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/smb2pdu.c: disconnect =
session 00000000db1ddbb6
> > > [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: VFS: leavin=
g cifs_mount_put_conns (xid =3D 13) rc =3D 0
> > > [Mon Jul 22 11:00:24 2024] CIFS: VFS: cifs_mount failed w/return code=
 =3D -2
> >
> > And
> >
> > >  Gleb Korobeynikov 2024-07-30 11:03:01 UTC
> > >
> > > (In reply to Gleb Korobeynikov from comment #5)
> > >> (In reply to The Linux kernel's regression tracker (Thorsten Leemhui=
s) from
> > >> comment #4)
> > >> > Please check if 6.10 (or 6.11-rc1 once it's out on Monday) is stil=
l
> > >> affected
> > >>
> > >> Alright, I will definitely check
> > >
> > > Checked on 6.11-rc1. The reproduction issue happens identically.
> >
> > See the ticket for more details.
> >
> > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat=
)
> > --
> > Everything you wanna know about Linux kernel regression tracking:
> > https://linux-regtracking.leemhuis.info/about/#tldr
> > If I did something stupid, please tell me, as explained on that page.
> >
> > [1] because bugzilla.kernel.org tells users upon registration their
> > "email address will never be displayed to logged out users"
> >
> > P.S.: let me use this mail to also add the report to the list of tracke=
d
> > regressions to ensure it's doesn't fall through the cracks:
> >
> > #regzbot introduced: 3ae872de410751fe5e629e04da491a632d95201c
> > #regzbot title: smb: client: failure to mount DFS namespaces without
> > ASCII symbols
> > #regzbot from: Gleb Korobeynikov <gkorobeynikov@astralinux.ru>
> > #regzbot duplicate: https://bugzilla.kernel.org/show_bug.cgi?id=3D21908=
3
> > #regzbot ignore-activity
> >
> Thanks,
> Nandaa
>


--=20
___
Nandaa Anthony
