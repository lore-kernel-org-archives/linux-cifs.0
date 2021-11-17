Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F9AC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Nov 2021 14:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 773DD63214
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Nov 2021 14:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbhKQOUN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Nov 2021 09:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbhKQOUM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Nov 2021 09:20:12 -0500
X-Greylist: delayed 59547 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 Nov 2021 06:17:13 PST
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D3BC061570;
        Wed, 17 Nov 2021 06:17:13 -0800 (PST)
Received: from spock.localnet (unknown [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 291BECA0E85;
        Wed, 17 Nov 2021 15:17:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1637158630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=woZ1ZInzcNBerI+2JSrE9Zhj8imAzu1Pm6s9DSv1lSI=;
        b=ReFpsDCao1VWJZWBdHZnJOrbzau2gisPpdh65ZeE8sht12CLIYS4iuraAft0qhmPzcDs+X
        AXPc9jP84WmiN0E96VQL5Zqvdfq0BNmzQVf3/U6xPEgv8RwWaK3drMsYYu0MaivrbglqkS
        ffVM+zlG4CDHw5Emz/AHHDKqJhc8W4c=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ksmbd: Unsupported addition info
Date:   Wed, 17 Nov 2021 15:17:08 +0100
Message-ID: <10049688.nUPlyArG6x@natalenko.name>
In-Reply-To: <CAKYAXd9wKDTE5WPQWcBZ_mHfaAOOY+pDj7=yndi17gf2KqWpwg@mail.gmail.com>
References: <5831447.lOV4Wx5bFT@natalenko.name> <2865530.e9J7NaK4W3@natalenko.name> <CAKYAXd9wKDTE5WPQWcBZ_mHfaAOOY+pDj7=yndi17gf2KqWpwg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello.

On st=C5=99eda 17. listopadu 2021 10:58:50 CET Namjae Jeon wrote:
> 2021-11-17 16:00 GMT+09:00, Oleksandr Natalenko <oleksandr@natalenko.name=
>:
> > On st=C5=99eda 17. listopadu 2021 0:36:53 CET Namjae Jeon wrote:
> >> 2021-11-17 6:44 GMT+09:00, Oleksandr Natalenko
> >>=20
> >> <oleksandr@natalenko.name>:
> >> > With the latest ksmbd from the next branch I have an issue with wife=
's
> >> > Windows
> >> > 10 laptop while copying/removing files from the network share. On her
> >> > client it
> >> > looks like copy operation (server -> laptop) reaches 99% and then
> >> > stalls,
> >> > and
> >> > on the server side there's this in the kernel log:
> >> >=20
> >> > ```
> >> > ksmbd: Unsupported addition info: 0xf)
> >> > ksmbd: Unsupported addition info: 0x20)
> >> > ```
> >> >=20
> >> > repeated multiple times. I must note that in fact the file gets copi=
ed
> >> > to
> >> > her
> >> > laptop, but Windows copy dialog just hangs.
> >> >=20
> >> > Any idea what it could be and how to avoid it? This also happened
> >> > before
> >> > (I'm
> >> > a pretty early ksmbd adopter), but I'm reporting it just now because=
 I
> >> > na=C3=AFvely
> >> > hoped it would be fixed automagically :). This never happened to me
> >> > with
> >> > userspace Samba though.
> >> >=20
> >> > This is my smb.conf:
> >> >=20
> >> > ```
> >> > [global]
> >> > workgroup =3D KANAPKA
> >> > server string =3D ksmbd server %v
> >> > netbios name =3D defiant
> >> > valid users =3D __guest
> >> >=20
> >> > [Shared]
> >> > valid users =3D __guest
> >> > path =3D /mnt/shared
> >> > force user =3D _shared
> >> > force group =3D _shared
> >> > browsable =3D no
> >> > writeable =3D yes
> >> > veto files =3D /lost+found/
> >> > ```
> >> >=20
> >> > Appreciate your time and looking forward to your response.
> >>=20
> >> Thanks for your report, I have seen same symptom before, I thought it
> >> was a windows issue as it is also reproduced against samba. If you
> >> wait for a few minutes, does not the 99% message window close?
> >=20
> > Eventually it does close on its own in a minute or so. Also, it may clo=
se
> > after clicking the "X" (close) button, but not instantly.
>=20
> As I remember, The X button will delete the file you copied.

In my case the file is not deleted. So, probably, it is already copied, but=
=20
Windows wants something extra from the share.

> Could you
> please give me packet dump(tcpdump) on problem situation ? and It
> would be nice to give a dump also for a successful copy. I will try to
> compare the two.

Sure.

OK one: [1]

Non-OK one: [2]

Thank you.

[1] https://natalenko.name/myfiles/misc/ksmbd-ok.pcap.gz
[2] https://natalenko.name/myfiles/misc/ksmbd-stalled.pcap.gz

=2D-=20
Oleksandr Natalenko (post-factum)


