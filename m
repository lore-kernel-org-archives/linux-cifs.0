Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AD519CC3D
	for <linux-cifs@vger.kernel.org>; Mon, 26 May 2025 11:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748259486; cv=none; b=ZmAunGG3RFS/0n0MaMpPcCYBxgR35r7CH7/cG2VEkBMMR1UMWF9M2BGV2Hag414ygaZ8UgzutgAfolfXqiaaSPqDR/UveGFGgI6cRDAvIGduZuXlm8mJQhXOy8KmrmxjxwfWQz6qpBP/MbRRYPhQXLUcanNej721zjXo5YFv6Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748259486; c=relaxed/simple;
	bh=UF1wmyrGHPYt/1vs7WD9XxBgqpoyVWKuk2MMrzx614s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V22EAXQJ/0MMe7lN3rR2EjxPTSVbY2/eiiHhByIJNuhiRaVkxrb7xsFC/9zJAUhryFz1bGRYmDMD39THvY2siU68rqTUxAGs/4wqXtFcZCyArsWxJOr72BjANaJYf2fzGwbvwdUbh3Eeg8DQ1h/Bbk+qepKyFTqzICVA3nuphx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/tcqhWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/tcqhWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F7EC4CEF0
	for <linux-cifs@vger.kernel.org>; Mon, 26 May 2025 11:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748259486;
	bh=UF1wmyrGHPYt/1vs7WD9XxBgqpoyVWKuk2MMrzx614s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=M/tcqhWoiCX/3ZYbWsTi/sVuMBLFnvI7NxeIX9TeeA2KO68Dgaw+o5pzw0A8r3nI4
	 7BXwJHyyHokvXeDm7Y29Z//PahAhGrZ2TQKFTpplNxFwGzV/rJJq8NQIzp06dmZAWI
	 RijobQ548ARCxeCiU8BYbZRSu2D14CUnhDhoigZLdOp0IyETMl2jWwjLaDVMb7V3Kx
	 NpERTKPZaTjM6YF3IAm6dDLWUy7nmJUqRqn04tz/QFGLV18UbzFYDqkcb+RSLtDNqp
	 KM7BpEdU5BIMtLEDdtSbCc+bmc/Uo1S8WyijYzQJ4n/CE00/vXAa21UDCrX8MzfQDX
	 BD6cfuAou3UzQ==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ad1f6aa2f84so435193166b.0
        for <linux-cifs@vger.kernel.org>; Mon, 26 May 2025 04:38:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX06VRcEwzrLdLnPR3g6UXsGxirwE2i0QMtKyGUmXWhpqXvQ6lH9uid4Ms1iz2z2eUo3c3C5vYryLg0@vger.kernel.org
X-Gm-Message-State: AOJu0YzxRSSzq0SGWk98ZEBsCiT6H11inHUbCYP4iR8+ykjI7ayloDKn
	pcCKX39mTHp5g+5hW/ODsaRI2OmtXygt1E+NgHRyxNywy+Zi1GEnTl0XweTbSPV9Q6kR0UjRmVY
	y7Q7xzz4/w6UiOTztKZAPn4pZmC13Ci4=
X-Google-Smtp-Source: AGHT+IHBDD5NJWv1OTM0OjjUYbkMZnNuvcAsjh+bHcO2kuUeqWoSCyomlyPTvjUnLdzurygQMRW0g1Us058yZm3TDCU=
X-Received: by 2002:a17:907:2cc6:b0:ad2:e08:e9e2 with SMTP id
 a640c23a62f3a-ad859b5729amr715235966b.27.1748259484691; Mon, 26 May 2025
 04:38:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
 <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com> <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
In-Reply-To: <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 26 May 2025 20:37:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>
X-Gm-Features: AX0GCFu1Fg99I2dqyGMRWaclphrcpYOUQ18ms87riBszGHrz0PIKGJ3EPm6e_0U
Message-ID: <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>
Subject: Re: ksmbd and special characters in file names
To: Steve French <smfrench@gmail.com>
Cc: Philipp Kerling <pkerling@casix.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2025 at 7:45=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> On Sun, May 25, 2025 at 3:19=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.or=
g> wrote:
> >
> > On Sun, May 25, 2025 at 6:57=E2=80=AFAM Philipp Kerling <pkerling@casix=
.org> wrote:
> > >
> > > Hi!
> > >
> > > I've been reading a lot about the SAMBA 3.1.1 POSIX extensions and ha=
d
> > > (perhaps wrongly?) hoped that they would allow native support for all
> > > file names valid in POSIX if the server and client agree, so I could
> > > continue to access my files that contain colons or quotes as I did
> > > using nfs. I know there are remapping options for the reserved
> > > characters, but they are very annoying to use if you want to have
> > > direct access to the files on the server machine as well or want to
> > > serve a directory that already exists and has "problematic" file name=
s.
> > >
> > > I have been playing with this on Linux 6.14.6 with ksmbd as server an=
d
> > > Linux cifs as client. Unfortunately, I was not able to access any
> > > file/folder containing, for example, a double quote character ("). Fr=
om
> > > what I can tell in the logs, this is due to ksmbd validating the name
> > > and failing:
> > >
> > >    May 24 22:25:15 takaishi kernel: ksmbd: converted name =3D Jazz/SO=
IL&"PIMP" SESSIONS
> > >    May 24 22:25:15 takaishi kernel: ksmbd: File name validation faile=
d: 0x22
> > >
> > > This seems to be an explicit and intentional check for various
> > > characters including ?"<>|* [1]. If not for that check, I could acces=
s
> > > my files just fine (mounting with -o nomapposix of course). I've
> > > patched it out locally to test and it's working great. Even smbclient
> > > and gvfs are happy with it. Is this something that would make sense
> > > (even if only as an option), or are there other restrictions/security
> > > concerns in the SMB protocol that prevent having the special characte=
rs
> > > be treated as valid?
> > Files containing special characters are not recognized in Windows.
> > That's why ksmbd restricts the creation of such files.
> > However, it seems right to allow it when mounting posix extensions.
> > So we can probably handle it like the following change.
> >
> > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > index 3a4bffe97b54..de66eed6afb9 100644
> > --- a/fs/smb/server/smb2pdu.c
> > +++ b/fs/smb/server/smb2pdu.c
> > @@ -2925,9 +2925,11 @@ int smb2_open(struct ksmbd_work *work)
> >                                 goto err_out2;
> >                 }
> >
> > -               rc =3D ksmbd_validate_filename(name);
> > -               if (rc < 0)
> > -                       goto err_out2;
> > +               if (tcon->posix_extensions =3D=3D false) {
> > +                       rc =3D ksmbd_validate_filename(name);
> > +                       if (rc < 0)
> > +                               goto err_out2;
> > +               }
> >
> >                 if (ksmbd_share_veto_filename(share, name)) {
> >                         rc =3D -ENOENT;
> >
> > But There is one problem. cifs.ko always sends
> > SMB2_POSIX_EXTENSIONS_AVAILABLE context
> > to the server regardless of mount option -o posix.
> >
> > Steve,
> > ksmbd assumes that the client is doing smb3.1.1 posix extension mount
> > if it sends SMB2_POSIX_EXTENSIONS_AVAILABLE context.
> > If cifs.ko always sends SMB2_POSIX_EXTENSIONS_AVAILABLE context
> > regardless of -o posix, how does the server know whether posix
> > extension mount or not?
>
> If the POSIX/Linux context is included in the SMB3.1.1 open then we
> mounted with ("linux" or "posix")
Such a context could be created in smb2_create context like apple context(A=
APL).
However, I wonder if there is any plan to add it to SMB3.1.1 posix
extension specification.
>
>
> --
> Thanks,
>
> Steve
