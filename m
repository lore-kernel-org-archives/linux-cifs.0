Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C2E2D058
	for <linux-cifs@vger.kernel.org>; Fri, 23 Aug 2024 02:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724380762; cv=none; b=EckI6gcLiJRa70QoK6LYSbtFgEeLNWS7fKFwnmTaVJQx0g9jpNPYmFTMsLDkRZDPNZw99cOS8qAvvB0xPceOoTm6WxkoejpA9wptT9YKTqNtrxCsAa5ad3apdZge5dT+HZ//gmwXG3rMGF6AJsTwnNWEr5vjyb4sRkue9022Cck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724380762; c=relaxed/simple;
	bh=+y9kwr5psuHcLaZjlGYoWTQxV+M83FMZkA6Wewyfspg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWzdSDwtMvZJdeHX0shiIjq4Um+hVM23xHS1YMQJ5OEMxy85OMQWGVmqmKzvZSbdc/RN/fodSKWblbJCMAhulSlpW9vwwPYqDSJAV8p5DA+rjZYyTLJonv8Z64gSGDt/RzAiKDljBHZGbnzDcxNwm2os/o4TB3EQiqFtck85w6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OdIglptL; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OdIglptL"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-533488ffaddso1939724e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Aug 2024 19:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724380759; x=1724985559; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PIAAonjEb0GCoYR3ZhslNiv9ZKUToHOe4Lq+Z4Pz1nA=;
        b=OdIglptL950G7PQMjGH3ZmlUqH/rjhrL8M3+TqZ9iGXSufFpNNQGKrPJ3/sN0Ooynv
         X3y3ImnVvC6V90TBxWjNIkYcpbqbNfHx+kH+S1GE0J/hz8DSBcenAa5DbddhBo3AocyQ
         Fgwu6vES/rCVmonP7mcyV5+WaxtC6f3GjEedHRoyvBgRTwc/GZjnFx3cuFKHcI15d5kD
         DFfEfDttDA9br1vsWlPAz5hMZCIarQC+XLX5rXdbpIzAc6lfv440HCuIT/rkDZL/I4iu
         tIkDFWnPBn62zWmgIjyOI/tcurbkraYzoT+aWizfae9ZsuQEKA7ZiM8cWceGevgyIqTY
         RmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724380759; x=1724985559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PIAAonjEb0GCoYR3ZhslNiv9ZKUToHOe4Lq+Z4Pz1nA=;
        b=SN3EJaRWVb6PoP7SFrj21J/IT4NZcv4ykkyyEKSRwRIktoNvy71DuN2Lai2hQa6/ku
         IXdeGBdjADa/9khLxFE8H8OYwqvrn8UvZgkkmW4ZWpliToXQXjBacaHIb09zqrLmE1nC
         FsUvMfTvz93bRjBbqi29e5+/D5qDia2qrkH71DuMC+mGfCO1mPutFAq4ZnllSl/e23bz
         4D8sUEN4ZajCsktQ8Ulh8njLs0gHSVFvA0aByKgXFe9z9WkE4IL63HWccXr93lnsNAc2
         Bt3uPEI+Bn/13AYLMAMv0YCBunGBAYi/ApcyIJfP+gVBWVLWA2CZmyeCaKl88B9neeRs
         LK1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU4MLwa7ZZAS+gby2T4c3ot1gc5mJtAI0pHULMrkAyLGLkm/l8VXq8ZIF9GWXcUf1d6gebJruZvMDC1@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7yw1Ae2BA11lJ1vKq8UNn7h1a4B8jVx8WZys6IKgHFFlCTTWa
	MG74peeQdprmAkaRLzjfqjnGoLYVbGqb0axb5FBEL77TUmI1TXNUyVc03ThL3ZuaYlhkW/g51EC
	1y8FJXalLIMI+eZP0JS69Mvv+4RA=
X-Google-Smtp-Source: AGHT+IFo+VOMaJL9XUUg9KNI6yqDH6suGSKQ1Ll5vnOdUzARROyLMrF0dGthEQ8ThRcIc0dcJMQOsZ5msO1mpz47L3g=
X-Received: by 2002:a05:6512:401d:b0:52c:a7c8:ec43 with SMTP id
 2adb3069b0e04-5343870bbf8mr535361e87.0.1724380758482; Thu, 22 Aug 2024
 19:39:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
 <54a46d0e05c754fbc5643af2b576e876@manguebit.com> <CAMHwNVvAT-qeRvJ0jV2+5byHQnwzW9-YFj13ovXFC+M8hAfmyQ@mail.gmail.com>
 <CAACuyFU2va16OGn7_i-Ur-TEic7AW7pQj3c3xrPT1P2HJts9bg@mail.gmail.com>
 <CAACuyFWrejfaYiFU8REzj=uTFg88qi7guL1oQg3zqnDWY-vR_w@mail.gmail.com>
 <CAH2r5mv-V=H0QF205oZTc0Y3yfUchEyk4Y-QqFvVJgpJhxPWRw@mail.gmail.com> <CAMHwNVtLS91okXnESNrja2OWJoN1gebeB1hHeuvMbmHD2Y0uMw@mail.gmail.com>
In-Reply-To: <CAMHwNVtLS91okXnESNrja2OWJoN1gebeB1hHeuvMbmHD2Y0uMw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 22 Aug 2024 21:39:06 -0500
Message-ID: <CAH2r5msidsBxCuDwjE0o3ZD4ZFGrN962svLTwb9o=uzpe=fodg@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: Marc <1marc1@gmail.com>
Cc: Anthony Nandaa <profnandaa@gmail.com>, Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I plan to send it upstream this week, so should make it into some
distros fairly soon after that.

On Thu, Aug 22, 2024 at 7:06=E2=80=AFPM Marc <1marc1@gmail.com> wrote:
>
> Thank you all for working on this and resolving this issue so quickly.
> Am I correct to assume that this update will eventually flow through
> in an update on my Ubuntu desktop?
>
> Regards, /|/|arc.
>
> Op do 22 aug 2024 om 03:58 schreef Steve French <smfrench@gmail.com>:
> >
> > thx for testing this.  Have added your tested-by.  Let me know if any
> > followon patches or issues.
> >
> > On Wed, Aug 21, 2024 at 12:43=E2=80=AFPM Anthony Nandaa <profnandaa@gma=
il.com> wrote:
> > >
> > > I have now tested the patch.
> > >
> > > On Wed, 21 Aug 2024 at 18:55, Anthony Nandaa <profnandaa@gmail.com> w=
rote:
> > > >
> > > > I can help with this. Marc, if you can help me with the minimal rep=
ro steps, is OneDrive needed?
> > > >
> > > >
> > > > On Wed, Aug 21, 2024, 15:15 Marc <1marc1@gmail.com> wrote:
> > > >>
> > > >> Happy to help and assist where I can, but I have no idea how I wou=
ld
> > > >> try this updated code. I think it involves compiling a kernel and
> > > >> applying the patch to it. This is not something I have ever done o=
r
> > > >> have an idea on how to go about it.
> > > >>
> > > >>
> > > >> Op wo 21 aug 2024 om 09:45 schreef Paulo Alcantara <pc@manguebit.c=
om>:
> > > >> >
> > > >> > Marc <1marc1@gmail.com> writes:
> > > >> >
> > > >> > > This has been working great for many years. Yesterday, this st=
opped
> > > >> > > working. When I tried mounting the share, I would get the foll=
owing
> > > >> > > error: "mount error(95): Operation not supported". In dmesg I =
see:
> > > >> > > "VFS: parse_reparse_point: unhandled reparse tag: 0x9000601a" =
and
> > > >> > > "VFS: cifs_read_super: get root inode failed".
> > > >> >
> > > >> > Can you try the following changes?  Thanks.
> > > >> >
> > > I see that the patch is in
> > > for-next@80dd92d6ac7d1bc4b95d0a9f4d7730fe5ee42162, so I have just use=
d
> > > that to build a new module.
> > >
> > > I created a share from one of the directories in my OneDrive:
> > >
> > >     sudo mount -t cifs //WIN-31GSG2M9E6N/Users/Usa/OneDrive/Shuttle
> > > /mnt/shuttle -o username=3D...,password=3D...
> > >
> > > Before the patch, the mounting was failing but after building with th=
e
> > > patch, it mounted successfully.
> > >
> > > Aug 21 17:25:32 ubuntu-test-2 kernel: CIFS: VFS: parse_reparse_point:
> > > unhandled reparse tag: 0x9000601a
> > > Aug 21 17:25:32 ubuntu-test-2 kernel: CIFS: VFS: cifs_read_super: get
> > > root inode failed <~~~~ FAIL
> > > ...
> > > Aug 21 17:31:22 ubuntu-test-2 kernel: CIFS: Attempting to mount
> > > //WIN-31GSG2M9E6N/Users/Administrator/OneDrive/Shuttle
> > > ...
> > > Aug 21 17:31:22 ubuntu-test-2 kernel: CIFS: VFS:
> > > \\WIN-31GSG2M9E6N\Users unhandled reparse tag: 0x9000601a
> > > ^^^ SUCCESS.
> > >
> > > >> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > > >> > index 689d8a506d45..48c27581ec51 100644
> > > >> > --- a/fs/smb/client/reparse.c
> > > >> > +++ b/fs/smb/client/reparse.c
> > > >> > @@ -378,6 +378,8 @@ int parse_reparse_point(struct reparse_data_=
buffer *buf,
> > > >> >                         u32 plen, struct cifs_sb_info *cifs_sb,
> > > >> >                         bool unicode, struct cifs_open_info_data=
 *data)
> > > >> >  {
> > > >> > +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> > > >> > +
> > > >> >         data->reparse.buf =3D buf;
> > > >> >
> > > >> >         /* See MS-FSCC 2.1.2 */
> > > >> > @@ -394,12 +396,13 @@ int parse_reparse_point(struct reparse_dat=
a_buffer *buf,
> > > >> >         case IO_REPARSE_TAG_LX_FIFO:
> > > >> >         case IO_REPARSE_TAG_LX_CHR:
> > > >> >         case IO_REPARSE_TAG_LX_BLK:
> > > >> > -               return 0;
> > > >> > +               break;
> > > >> >         default:
> > > >> > -               cifs_dbg(VFS, "%s: unhandled reparse tag: 0x%08x=
\n",
> > > >> > -                        __func__, le32_to_cpu(buf->ReparseTag))=
;
> > > >> > -               return -EOPNOTSUPP;
> > > >> > +               cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag=
: 0x%08x\n",
> > > >> > +                             le32_to_cpu(buf->ReparseTag));
> > > >> > +               break;
> > > >> >         }
> > > >> > +       return 0;
> > > >> >  }
> > > >> >
> > > >> >  int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
> > > >>
> > >
> > >
> > > --
> > > ___
> > > Nandaa Anthony
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
