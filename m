Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238A4C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Oct 2023 13:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344545AbjJaNah (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 09:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344538AbjJaNag (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 09:30:36 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C2CDE
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 06:30:30 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-507bd644a96so8186641e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 06:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698759028; x=1699363828; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vUEuSVCjjbnmgw+tmucLL7jewA9XFlVXm9dgNUz8WA=;
        b=k6NjmnTSPPMZfNKfOad6/x7QBDZGhFZYRwTRnmxnGBawjxlKLXG0VszKpVVssTvd0i
         OhU3kY+NELRHVrN70Rl3sSrdlVeJQR7fzEJAwgPHGQmM00ybVTGyrfG/fPyFAUXhAfhs
         M4X1Tl7ukZAkHML80pLfQKhBvZB0ZeL1OUWyW28vMp4M1fvPvJIOBuNkEOWE5DaDdR7c
         JqmSx2shdg+sSb6718mD5hA73CWbyDoMIAvHfRqxqROtzxErsT6Ig9rOYwZTedOmIR4r
         Fpybk9Yb62dfnzwm4ackDdczqirGBWGNUqEnxwToOAoR6IoptusHRk6OyJZErYoDznCV
         gIyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698759028; x=1699363828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/vUEuSVCjjbnmgw+tmucLL7jewA9XFlVXm9dgNUz8WA=;
        b=KAIeJSh7Z4DBQGjxpBUZEYRU0Wnul9r63+Zm9EUJlXuErzMiwoeNHD7vP8Y70/3nr7
         Pnz+dEkEgxo0ZdkcnCehtsEj8BJDzUA97JAsUF37GRHdXOFNJF7rs/3jmmwfP6Rk9I7T
         RQQ27iYHK5cHCfODC3mjQB4TxeaO6XbO+XXzHL/f3F80omtsEZPpIapvP7QYgf72zYjz
         96jwgn92FKffVBK/ODAiiOpdRIoFqHmoAjXTQmDdk6W9ns7n4ieGu6wIUl6mncYA0vZG
         DnZkKDUHqUcII0ckeOs11iHkLx8O6ZkHID7zY0FAMIEeL33eOMdgHGDW5fkUiqIr1Yo9
         lUyA==
X-Gm-Message-State: AOJu0Ywvu7UHQN5ggztKOE2JPe2vArfblS8Dthw/bh7c0+bPaLwptQEc
        oqQWLKTA6a80OcTEXuI3brtz1FiTwPuj6alvwm4SugO2PjY=
X-Google-Smtp-Source: AGHT+IG1Cjzx31Wt9SoNXfsLdkyJnHFHnDVJUVZ6oFKgzD40s298u7xXWSi8H5Y4odAfGJoVvkgq2HfiaelUFWXaXHE=
X-Received: by 2002:a05:6512:48d1:b0:503:5cd:998b with SMTP id
 er17-20020a05651248d100b0050305cd998bmr8623070lfb.28.1698759027671; Tue, 31
 Oct 2023 06:30:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvve4euMUqsBBqRr2VWgz7ukEZ15vZRVDO=zbzY=XhF1Q@mail.gmail.com>
 <29169963-d1c6-4972-8e68-1f24d8d2e5b9@miami.edu> <CAH2r5mv1phW57TErdO1jWQaUyZqiLmOEGdLDbF8RDfPwJvkPSA@mail.gmail.com>
 <CAH2r5mu2r2dQefpLxS+Le=1GLdhTVBspjC1HDa1v0p-0-prQ2g@mail.gmail.com>
In-Reply-To: <CAH2r5mu2r2dQefpLxS+Le=1GLdhTVBspjC1HDa1v0p-0-prQ2g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Oct 2023 08:30:15 -0500
Message-ID: <CAH2r5muHkFvZD7cxy8psSPDh85p=u1=gcj2X6P=Fi-r=AZgqpQ@mail.gmail.com>
Subject: Re: [PATCH][CIFS] allow creating FIFOs when "sfu" mount option specified
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Adding linux-cifs mailing list (the updated patch was only sent to
samba-technical)

On Sun, Oct 29, 2023 at 4:12=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> updated patch attached
>
>
> On Sun, Oct 29, 2023 at 4:06=E2=80=AFPM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > Good catch - yes that was a typo - will fix.
> >
> > On Fri, Oct 20, 2023 at 10:07=E2=80=AFAM Brown, James William via
> > samba-technical <samba-technical@lists.samba.org> wrote:
> > >
> > > On 10/20/2023 12:32 AM, Steve French via samba-technical wrote:
> > > > CAUTION: This email originated from outside the organization. DO NO=
T CLICK ON LINKS or OPEN ATTACHMENTS unless you know and trust the sender.
> > > >
> > > > mb3: fix creating FIFOs when mounting with "sfu" mount
> > > >   option
> > > >
> > > > Fixes some xfstests including generic/564 and generic/157
> > > >
> > > > The "sfu" mount option can be useful for creating special files (ch=
aracter
> > > > and block devices in particular) but could not create FIFOs. It did
> > > > recognize existing empty files with the "system" attribute flag as =
FIFOs
> > > > but this is too general, so to support creating FIFOs more safely u=
se a new
> > > > tag (but the same length as those for char and block devices ie "In=
txLNK"
> > > > and "IntxBLK") "LnxFIFO" to indicate that the file should be treate=
d as a
> > > > FIFO (when mounted with the "sfu").   For some additional context n=
ote that
> > > > "sfu" followed the way that "Services for Unix" on Windows handled =
these
> > > > special files (at least for character and block devices and symlink=
s),
> > > > which is different than newer Windows which can handle special file=
s
> > > > as reparse points (which isn't an option to many servers).
> > > >
> > > > @@ -5135,6 +5135,12 @@ smb2_make_node(unsigned int xid, struct inod=
e *inode,
> > > >               pdev->minor =3D cpu_to_le64(MINOR(dev));
> > > >               rc =3D tcon->ses->server->ops->sync_write(xid, &fid, =
&io_parms,
> > > >                                                       &bytes_writte=
n, iov, 1);
> > > > +     } else if (S_ISBLK(mode)) {
> > > > +             memcpy(pdev->type, "LnxFIFO", 8);
> > > > +             pdev->major =3D 0;
> > > > +             pdev->minor =3D 0;
> > > > +             rc =3D tcon->ses->server->ops->sync_write(xid, &fid, =
&io_parms,
> > > > +                                                     &bytes_writte=
n, iov, 1);
> > > >       }
> > > >       tcon->ses->server->ops->close(xid, tcon, &fid);
> > > >       d_drop(dentry);
> > > > --
> > > Shouldn't "else if (S_ISBLK(mode))" be "S_ISFIFO"?
> > >
> > > else if (S_ISBLK(mode))
> > >
> > > else if (S_ISBLK(mode))
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
