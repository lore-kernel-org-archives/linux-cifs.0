Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5D9C77B7A
	for <linux-cifs@archiver.kernel.org>; Thu, 25 May 2023 10:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbjEYKuE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 06:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjEYKuE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 06:50:04 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91158183
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 03:50:02 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-510b6a249a8so4149300a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 03:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685011801; x=1687603801;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rN6ZW64ptAPiChsD8/Re4zwk3t8TAiT9Ua8kP37+Lkg=;
        b=lYIL3BIu+RDUZJTXSVC658u0V2Ce7+nzeTiewzSXohOPKGZFXPLYacrpYxCEgyNICh
         cXELFY1buBVTOcOxFTzMsIrxzUHOOyK4SzEESOVpfY4npWAgu6VaNhVGcvUbfIlhC/bv
         dChXosk2ecGLJZaRJaKn+MCpzi/n6fh2uP4SAdp3N+PTDEtZXS8bVMUnoVz8rReJtxhn
         hMQ4m8gRovt3M6LwBp2zTSFCP9Uur5dQqvXYV/WVT0Lv9eWdPmWs2xPn4w6JjLaPWd2X
         fvbQmkGp0osZoU4naJPlYBFrBmfT+R8pfRahdUZWLUv1rXTukY1ZpdElu8LQi1W+kugF
         +UCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685011801; x=1687603801;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rN6ZW64ptAPiChsD8/Re4zwk3t8TAiT9Ua8kP37+Lkg=;
        b=GxCOHVuGvcLilSepPVzKNTgfcc7SM0NvbzOPdv04GzzYI22e18/J2uICQOcH+8HGcX
         TqDtvVt6QtYhnQWvUkLxxUo/p8N5kbYW7oWSZpoOOgdMelXZ0Ppn/ANjhEzdN0ICNWVE
         vRaO9RB3Q3iYKp9x8+6269OAvGk2H96OlCb/S3U/MrF8IEgp7vBfFKH23oPbjdQNBw/l
         88ZeInRBwXNsffOYLJmtZsY/LDkRtzFIKY7zdrfZl8Sf49INP9dNJthO/eeFtnTTQcTH
         iPbzS2EUHJwzXJO3zPTyzas9ta7rllYgX4glQAmQ89GUyEQCHFotObf8b7WNd5UiELUV
         bKmg==
X-Gm-Message-State: AC+VfDwH3IRL6hyQpnYWC5g4AIbvMlRNbp0opRSGp1T+TOZprETcuOb4
        JRAh/RCHkcsWKm3FxI8dmXFWdeCkwT+tA7uoOPA=
X-Google-Smtp-Source: ACHHUZ7/YbD1ePdaBGN21fVv2YdIqa3m3paKObfHLUcLwEzf70Hqg0dT2HXP30JPFZuIzhReriX4cscUAbJjFNLkpHM=
X-Received: by 2002:a17:907:3689:b0:973:797b:50de with SMTP id
 bi9-20020a170907368900b00973797b50demr828239ejc.60.1685011800726; Thu, 25 May
 2023 03:50:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop> <20230525093900.GA261009@sernet.de>
In-Reply-To: <20230525093900.GA261009@sernet.de>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 25 May 2023 20:49:47 +1000
Message-ID: <CAN05THTi0BC_iwjXMiWn61fg3hRemi5Momwp3O0WGygyWLGomQ@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     =?UTF-8?B?QmrDtnJuIEpBQ0tF?= <bj@sernet.de>,
        Jeremy Allison <jra@samba.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 25 May 2023 at 19:40, Bj=C3=B6rn JACKE via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> On 2023-05-22 at 09:21 -0700 Jeremy Allison via samba-technical sent off:
> > On Mon, May 22, 2023 at 01:39:50AM -0500, Steve French wrote:
> > > On Sun, May 21, 2023 at 11:33=E2=80=AFPM ronnie sahlberg
> > > <ronniesahlberg@gmail.com> wrote:
> > > >
> > > > A problem  we have with xattrs today is that we use EAs and these a=
re
> > > > case insensitive.
> > > > Even worse I think windows may also convert the names to uppercase =
:-(
> > > > And there is no way to change it in the registry :-(
> > >
> > > But for alternate data streams if we allowed them to be retrieved via=
 xattrs,
> > > would case sensitivity matter?  Alternate data streams IIRC are alrea=
dy
> > > case preserving.   Presumably the more common case is for a Linux use=
r
> > > to read (or backup) an existing alternate data stream (which are usua=
lly
> > > created by Windows so case sensitivity would not be relevant).
> >
> > Warning Will Robinson ! Mixing ADS and xattrs on the client side is a r=
eceipe for
> > confusion and disaster IMHO.
> >
> > They really are different things. No good will come of trying to mix
> > the two into one client namespace.
> >
>
> just took a look at how the ntfs-3g module is handling this. It was an op=
tion
> streams_interface=3Dvalue, which allows "windows", which means that the
> alternative data streams are accessable as-is like in Windows, with ":" b=
eing
> the separator. This might be a nice option for cifsfs also. That option w=
ould
> just be usable if no posix extensions are enabled of course.

We could. But that is a windowism where ':' is a reserved character
but which is not a reserved character in unixens.
For example:
You have the file "foo" with stream "bar" and you have another normal
file "foo:bar"
Which one does open("foo:bar") give you?

The openat/... semantics that solaris uses provides an elegant and
unambiguous semantics for it.
You want to open stream bar on file foo?
1, fh =3D open("foo")
2, sh =3D openatf(h, "bar")

There are at least two non-windows related filesystems that support
something similar to ADS,
solaris filesystem and apples filesystem(s) so it would be nice to
have a neutral API where an application can use the same
code to access streams be they cifs/ntfs/solarisfs/applefs/...other...

Steve, I think this would be a good discussion topic for vfs meetings.
Is it desirable to bless an api in the vfs to do alternate data
streams?
There are at least 4 filesystems that provide this feature, 3 of which
are still very popular and common today.

One approach would be to mimic the interface that solaris provides
with openatfile-fd, "stream-name")
But that would not just be a filesystem change but also a VFS change
since it would suddenly accept passing a file-fd as argument
as a valid option (for those filesystems that have signalled
alternative stream support?)
while the vfs currently only allows openat() on a directory-fd.

ADS as a concept is really powerful and could be enormously useful as
way to attach metadata to a file object in a standardized way.
There are very many use-cases where having a file that embedded both
the executable as well as various other types of data but still be
able to treat it as a single self-contained file from an end-user
perspective.

This should be discussed and we should probe the vfs folks about what
they think about it.

regards
ronnie s

>
> Bj=C3=B6rn
>
