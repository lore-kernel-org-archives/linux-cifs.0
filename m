Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E13C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 23:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE7C261B96
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 23:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhKPX0Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Nov 2021 18:26:24 -0500
Received: from vulcan.natalenko.name ([104.207.131.136]:33440 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbhKPX0Y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Nov 2021 18:26:24 -0500
Received: from spock.localnet (unknown [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 29AABC9F44C;
        Wed, 17 Nov 2021 00:23:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1637105004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v3cajH+nftkRylUmyQ7XyT0sa+oEqmsLI9ulOPFbqd8=;
        b=sDcKf+/7D/v0FAstWgSQAG2nOPXv6mVAhPJnjTwMqUSXkQwBdQs71f+6hegK1mkFa/feXz
        zRjllutN5bGF6SDy9QpeLIOOkUlwAcLroKyzDUHd1JEcVv8RVSknZJte77wPkDU1COzRRi
        uy9eVPJRTRIW+sO+MxjdOmyNQ0fkN3Q=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: ksmbd: Unsupported addition info
Date:   Wed, 17 Nov 2021 00:23:22 +0100
Message-ID: <2147198.irdbgypaU6@natalenko.name>
In-Reply-To: <CAF6XXKXKivX-_OR+ZtqQP4yMVtJ=rGTPWvBDQSdys1vTCBHKUw@mail.gmail.com>
References: <5831447.lOV4Wx5bFT@natalenko.name> <CAF6XXKXKivX-_OR+ZtqQP4yMVtJ=rGTPWvBDQSdys1vTCBHKUw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello.

Thanks for your response. Please find my answers inline.

On st=C5=99eda 17. listopadu 2021 0:03:34 CET Marios Makassikis wrote:
> On Tue, Nov 16, 2021 at 10:44 PM Oleksandr Natalenko
>=20
> <oleksandr@natalenko.name> wrote:
> > Hello Namjae et al.
> >=20
> > With the latest ksmbd from the next branch I have an issue with wife's
> > Windows 10 laptop while copying/removing files from the network share. =
On
> > her client it looks like copy operation (server -> laptop) reaches 99%
> > and then stalls, and on the server side there's this in the kernel log:
> >=20
> > ```
> > ksmbd: Unsupported addition info: 0xf)
> > ksmbd: Unsupported addition info: 0x20)
> > ```
> >=20
> > repeated multiple times. I must note that in fact the file gets copied =
to
> > her laptop, but Windows copy dialog just hangs.
> >=20
> > Any idea what it could be and how to avoid it? This also happened before
> > (I'm a pretty early ksmbd adopter), but I'm reporting it just now becau=
se
> > I na=C3=AFvely hoped it would be fixed automagically :). This never hap=
pened
> > to me with userspace Samba though.
> >=20
> > This is my smb.conf:
> >=20
> > ```
> > [global]
> > workgroup =3D KANAPKA
> > server string =3D ksmbd server %v
> > netbios name =3D defiant
> > valid users =3D __guest
> >=20
> > [Shared]
> > valid users =3D __guest
> > path =3D /mnt/shared
> > force user =3D _shared
> > force group =3D _shared
> > browsable =3D no
> > writeable =3D yes
> > veto files =3D /lost+found/
> > ```
> >=20
> > Appreciate your time and looking forward to your response.
>=20
> This sounds like an issue reported on github a couple of months ago [1].
>=20
> Can you specify the exact Windows version (+ edition) ?

It is Windows 10 Pro 21H1 19043.1348

> Are you accessing the share through a network-mapped drive ? If not,
> can you try to reproduce it ?

Yes, the share is "mounted" as a network-mapped drive Z:.

> Does this happen with files of any type ?

I didn't find it depending on a specific file type. Just tried a couple of =
fresh=20
jpgs and xslx, all hung, but another pair of old jpgs went fine instantly,=
=20
although the same message was logged in the kernel log on the server side f=
or=20
all the files.

> IIRC, the "Unsupported addition
> info" message you're seeing is related to Windows requesting some
> attributes that are not handled yet by ksmbd. It seems it was added to fix
> windows 10 clients
> after ACLs support was added [2]. Makes me wonder if Windows doesn't like
> the fake response it is getting when it's trying to read the SACLs.

Cannot comment on this since I have no idea how things work or are supposed=
 to=20
work, but I'm ready to test patches as well as ksmbd options if there are s=
ome=20
suggestions.

Thanks you!

> https://github.com/cifsd-team/ksmbd-tools/issues/208
> https://github.com/namjaejeon/ksmbd/commit/cb9167856ffca6483

=2D-=20
Oleksandr Natalenko (post-factum)


