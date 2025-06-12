Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205DF23BCFF
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 11:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749727546; cv=none; b=MjfrmwcnMoJDVwxOmd3yszlCgxu1u85+mpr8s/ofz6iRvnSeNqeJ0VwIccI3FSQTYU1kBprREsErXjuhCDHQpF39eST+UqtOZ9PFY2x+OSZQHNGD/ZsQD0O95KF9/eJpbecr0ApVXM7gV4gVMu1H7NUV7AD0i5ztGrPid09OoG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749727546; c=relaxed/simple;
	bh=kiOyGdzOdU+OP/Xow4B8REW5JdXMJ8RYFh1FbTaAYTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hs46HvtOq+Xwx8/y5pVwdP9jUSZigPHQdLY/L1Gaqt6x5b3wnUxjeVeWPp8SNua3zgtBmo0FP06AOjRXfyMcNtOae8Ex6b9t1RAKfLSLX+dNxCOOidd7s4EzI37CxnQiKp1KKnFHj0eWBeij+NAIluB/z+DH4OXrhOKwMqi1bHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PTxHDeNv; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PTxHDeNv"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4a3db0666f2so19439641cf.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 04:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749727543; x=1750332343; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tPZxYD67UtVxppvUO7WX7Db7finKYvqbTH8UdFO7cXo=;
        b=PTxHDeNvhuFl62RQJmIMJYs5JArgFPKdxLYHkDIDwNb8jW0DaHBrtIH1TOzK4bguZB
         SiJzu0cFG+hNSwU3P2vFaGahUuyHwf6ZyRyPMn4Kvlf2YfUlvJDUJtxlvo7HAaTeZNse
         yOfr/pefajzwhRtYFdjMM+ZiKHTPFRJemRuxqHOVJo33xExe11cUTqqcognuBPHXWxkm
         SvsgvbURSAW/TgMPi2tMj2yRjnqTVhCMQXBa5/MTrpRxO5iW0KeviUEo4xDt825tEry7
         S5hP4hOeygZCInnmAP2evSupOXzpq4YUVrxzuzY028WIAwxLIOlDzyINHTQDP7sO1Hh8
         JHYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749727543; x=1750332343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tPZxYD67UtVxppvUO7WX7Db7finKYvqbTH8UdFO7cXo=;
        b=IPGUzudARn77ZLtizNMpWo/twac/E+lORAnkAUgqONiNrrzZnexTaxRtWNhpthC0lC
         16RLxguk1vswTEabYNitBV25tkbHBkdqB528c0w5MV92oxoqocINgchZN4ZdR/Qp/Jkp
         DpCSkhILjHuTMkByHyyO21M/+1ntV/VBPdU3w7NwR3NRcPBcKTiVnzvPs27j79yParlK
         bQzWsX2S+peM8fk2ciwkd+ATPDoOZ2JeARJCJpFHzGVqKXPQBq9O2pZauVoDi+d4zzGg
         fsIEo4ZXVlRzDJX49JyyfyEjpcu56SLO7rmfZI6DXfFUyCWZByhGfhilhjcySYhnI2W1
         YKWg==
X-Forwarded-Encrypted: i=1; AJvYcCUJuykb0qKnKKIpf06Huob0+o7K00lz0fGfxnzNvPDfM3rvu1smWkiKGr+E0wDUqOKKQPixZzYiukpG@vger.kernel.org
X-Gm-Message-State: AOJu0YxuB5uy5RheHuSLYoRs7babCmWqpWz6l223qTw5mBm0C6QaZHXS
	zLAKLuHUOA5BTScTmiwr20mYvB6haN3wulyuFb9LucwSuQRwcD7Df2zaP7KL+iKe9yzI9rhty/n
	hpbgD3zT/DjbhzeaSuKPZu08H/UFhEBEfeM3mHbE=
X-Gm-Gg: ASbGncuUoDvpDFlLE5vkAcjCbQRarwV5cGWZ9Dt1O0ars7A8LWJVJkTTBx3fsfya7wu
	NNCR1nt2bBmAS7iUw9U85zWa5SKDkUmRQh1ArFeVGLlVtRhlpZ+ic88goXNRzqNiYncophkkm7x
	bX0gMZbzUgbe0wEkutnl9dlL2WOvknk4vcN++tILmFxvA=
X-Google-Smtp-Source: AGHT+IHN4QWWPNvxYWKe9dR+gFlpAGAO1g+NItA1azT6cG/RN5dPlt+WzJg5TzVH1Ige1RV8GRq+e022wiMKLSqT7Ms=
X-Received: by 2002:a05:690c:312:b0:70d:ed5d:b4bf with SMTP id
 00721157ae682-7114ed3fee8mr44172687b3.24.1749727531191; Thu, 12 Jun 2025
 04:25:31 -0700 (PDT)
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
 <CAH2r5mv-V=H0QF205oZTc0Y3yfUchEyk4Y-QqFvVJgpJhxPWRw@mail.gmail.com>
 <CAMHwNVtLS91okXnESNrja2OWJoN1gebeB1hHeuvMbmHD2Y0uMw@mail.gmail.com> <CAH2r5msidsBxCuDwjE0o3ZD4ZFGrN962svLTwb9o=uzpe=fodg@mail.gmail.com>
In-Reply-To: <CAH2r5msidsBxCuDwjE0o3ZD4ZFGrN962svLTwb9o=uzpe=fodg@mail.gmail.com>
From: Marc <1marc1@gmail.com>
Date: Thu, 12 Jun 2025 21:25:20 +1000
X-Gm-Features: AX0GCFuhD7jyAfQX0ZyWqW61IGQIO605Av6KZCCJ3_SOZd7xbT7Zx5wSPLGF3rk
Message-ID: <CAMHwNVu+NK=XixCwoSVK6QOq3H=m=ML4k_aXYs2mDCGwNMReGQ@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: Steve French <smfrench@gmail.com>
Cc: Anthony Nandaa <profnandaa@gmail.com>, Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear all,

Not sure if this is the correct way to respond. Please direct me
somewhere else if required.

Following the incorporation of the patch into the mainstream Ubuntu
kernel, I noticed that I cannot open PDF files. With all PDF files I
attempt to open I get a message saying the file is corrupted. If I
revert back from 6.8.x-xx to kernel version 6.5.0.45 the problem goes
away.

To be clear, the patch did resolve the issue of me being unable to
mount a shared OneDrive directory. Opening other files (like text
files and .XLSX spreadsheets) is no problem.

Regards, /|/|arc.

Op vr 23 aug 2024 om 12:39 schreef Steve French <smfrench@gmail.com>:
>
> I plan to send it upstream this week, so should make it into some
> distros fairly soon after that.
>
> On Thu, Aug 22, 2024 at 7:06=E2=80=AFPM Marc <1marc1@gmail.com> wrote:
> >
> > Thank you all for working on this and resolving this issue so quickly.
> > Am I correct to assume that this update will eventually flow through
> > in an update on my Ubuntu desktop?
> >
> > Regards, /|/|arc.
> >
> > Op do 22 aug 2024 om 03:58 schreef Steve French <smfrench@gmail.com>:
> > >
> > > thx for testing this.  Have added your tested-by.  Let me know if any
> > > followon patches or issues.
> > >
> > > On Wed, Aug 21, 2024 at 12:43=E2=80=AFPM Anthony Nandaa <profnandaa@g=
mail.com> wrote:
> > > >
> > > > I have now tested the patch.
> > > >
> > > > On Wed, 21 Aug 2024 at 18:55, Anthony Nandaa <profnandaa@gmail.com>=
 wrote:
> > > > >
> > > > > I can help with this. Marc, if you can help me with the minimal r=
epro steps, is OneDrive needed?
> > > > >
> > > > >
> > > > > On Wed, Aug 21, 2024, 15:15 Marc <1marc1@gmail.com> wrote:
> > > > >>
> > > > >> Happy to help and assist where I can, but I have no idea how I w=
ould
> > > > >> try this updated code. I think it involves compiling a kernel an=
d
> > > > >> applying the patch to it. This is not something I have ever done=
 or
> > > > >> have an idea on how to go about it.
> > > > >>
> > > > >>
> > > > >> Op wo 21 aug 2024 om 09:45 schreef Paulo Alcantara <pc@manguebit=
.com>:
> > > > >> >
> > > > >> > Marc <1marc1@gmail.com> writes:
> > > > >> >
> > > > >> > > This has been working great for many years. Yesterday, this =
stopped
> > > > >> > > working. When I tried mounting the share, I would get the fo=
llowing
> > > > >> > > error: "mount error(95): Operation not supported". In dmesg =
I see:
> > > > >> > > "VFS: parse_reparse_point: unhandled reparse tag: 0x9000601a=
" and
> > > > >> > > "VFS: cifs_read_super: get root inode failed".
> > > > >> >
> > > > >> > Can you try the following changes?  Thanks.
> > > > >> >
> > > > I see that the patch is in
> > > > for-next@80dd92d6ac7d1bc4b95d0a9f4d7730fe5ee42162, so I have just u=
sed
> > > > that to build a new module.
> > > >
> > > > I created a share from one of the directories in my OneDrive:
> > > >
> > > >     sudo mount -t cifs //WIN-31GSG2M9E6N/Users/Usa/OneDrive/Shuttle
> > > > /mnt/shuttle -o username=3D...,password=3D...
> > > >
> > > > Before the patch, the mounting was failing but after building with =
the
> > > > patch, it mounted successfully.
> > > >
> > > > Aug 21 17:25:32 ubuntu-test-2 kernel: CIFS: VFS: parse_reparse_poin=
t:
> > > > unhandled reparse tag: 0x9000601a
> > > > Aug 21 17:25:32 ubuntu-test-2 kernel: CIFS: VFS: cifs_read_super: g=
et
> > > > root inode failed <~~~~ FAIL
> > > > ...
> > > > Aug 21 17:31:22 ubuntu-test-2 kernel: CIFS: Attempting to mount
> > > > //WIN-31GSG2M9E6N/Users/Administrator/OneDrive/Shuttle
> > > > ...
> > > > Aug 21 17:31:22 ubuntu-test-2 kernel: CIFS: VFS:
> > > > \\WIN-31GSG2M9E6N\Users unhandled reparse tag: 0x9000601a
> > > > ^^^ SUCCESS.
> > > >
> > > > >> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > > > >> > index 689d8a506d45..48c27581ec51 100644
> > > > >> > --- a/fs/smb/client/reparse.c
> > > > >> > +++ b/fs/smb/client/reparse.c
> > > > >> > @@ -378,6 +378,8 @@ int parse_reparse_point(struct reparse_dat=
a_buffer *buf,
> > > > >> >                         u32 plen, struct cifs_sb_info *cifs_sb=
,
> > > > >> >                         bool unicode, struct cifs_open_info_da=
ta *data)
> > > > >> >  {
> > > > >> > +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb=
);
> > > > >> > +
> > > > >> >         data->reparse.buf =3D buf;
> > > > >> >
> > > > >> >         /* See MS-FSCC 2.1.2 */
> > > > >> > @@ -394,12 +396,13 @@ int parse_reparse_point(struct reparse_d=
ata_buffer *buf,
> > > > >> >         case IO_REPARSE_TAG_LX_FIFO:
> > > > >> >         case IO_REPARSE_TAG_LX_CHR:
> > > > >> >         case IO_REPARSE_TAG_LX_BLK:
> > > > >> > -               return 0;
> > > > >> > +               break;
> > > > >> >         default:
> > > > >> > -               cifs_dbg(VFS, "%s: unhandled reparse tag: 0x%0=
8x\n",
> > > > >> > -                        __func__, le32_to_cpu(buf->ReparseTag=
));
> > > > >> > -               return -EOPNOTSUPP;
> > > > >> > +               cifs_tcon_dbg(VFS | ONCE, "unhandled reparse t=
ag: 0x%08x\n",
> > > > >> > +                             le32_to_cpu(buf->ReparseTag));
> > > > >> > +               break;
> > > > >> >         }
> > > > >> > +       return 0;
> > > > >> >  }
> > > > >> >
> > > > >> >  int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
> > > > >>
> > > >
> > > >
> > > > --
> > > > ___
> > > > Nandaa Anthony
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve
