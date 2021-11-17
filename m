Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07FFC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Nov 2021 09:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D4D1610CA
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Nov 2021 09:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbhKQKBv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Nov 2021 05:01:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235754AbhKQKBu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 17 Nov 2021 05:01:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64A13610CA;
        Wed, 17 Nov 2021 09:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637143131;
        bh=i7DSm+rL3kUoLwWZ/2x8CUFNAELOEBapiSNXn8u8kNo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ao3D8rYNp7SkSueiXxH7iyjfTvMw4pF4oVu87DmUZDt7P5DOXzjSslkFRwmJ/BCwI
         R44xvhtZpi3P4IrfGGk4JavOVBe4jBnt2Hs8g6RtOrsxljHFBlPWcgXIusFqud9e43
         5X0pSOI2aOl5cDHsoEz5d8Tz8Vcxia1IpCYsZxFOWpK7goushOwPO+wOQyBXyCgZjd
         yphSz4tudaz2eIhw4xXIIZ3n5733GhbnuwBWmGnAeF5/THBowCsCG5gPo6ShmVC9Cb
         OY2nlpbBECUdrF65BPRgU4wRLwfcFrf4NOS2PR0ODXTSniK8fhqydv88mSPX3BK6VU
         EwxEAK3mzVrWQ==
Received: by mail-ot1-f52.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso3743582ots.6;
        Wed, 17 Nov 2021 01:58:51 -0800 (PST)
X-Gm-Message-State: AOAM532AVUyf/tXjPcuSz03TYgHMgiq3DOno52nv3YtnN+HkEJBRNhJ5
        O/aAT7lKKqV1fuUWnclo6IFLmfpEsKxGbBldmzw=
X-Google-Smtp-Source: ABdhPJzkTx0Ti045S+OUp7bX0P3vYAjLTDbDy35SYYLaLHJyIhLjY6bOcAA6Cs9vcnTqFOMjaorzLT8U0Hs2o0Jmd6c=
X-Received: by 2002:a9d:6653:: with SMTP id q19mr12476293otm.116.1637143130723;
 Wed, 17 Nov 2021 01:58:50 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:4448:0:0:0:0:0 with HTTP; Wed, 17 Nov 2021 01:58:50
 -0800 (PST)
In-Reply-To: <2865530.e9J7NaK4W3@natalenko.name>
References: <5831447.lOV4Wx5bFT@natalenko.name> <CAKYAXd-KmxMeYWP8z6RYYK6za-Sj81Qtb3RO=oG+Yy3kXDaLjg@mail.gmail.com>
 <2865530.e9J7NaK4W3@natalenko.name>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 17 Nov 2021 18:58:50 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9wKDTE5WPQWcBZ_mHfaAOOY+pDj7=yndi17gf2KqWpwg@mail.gmail.com>
Message-ID: <CAKYAXd9wKDTE5WPQWcBZ_mHfaAOOY+pDj7=yndi17gf2KqWpwg@mail.gmail.com>
Subject: Re: ksmbd: Unsupported addition info
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-17 16:00 GMT+09:00, Oleksandr Natalenko <oleksandr@natalenko.name>:
> Hello.
>
> On st=C5=99eda 17. listopadu 2021 0:36:53 CET Namjae Jeon wrote:
>> 2021-11-17 6:44 GMT+09:00, Oleksandr Natalenko
>> <oleksandr@natalenko.name>:
>> > With the latest ksmbd from the next branch I have an issue with wife's
>> > Windows
>> > 10 laptop while copying/removing files from the network share. On her
>> > client it
>> > looks like copy operation (server -> laptop) reaches 99% and then
>> > stalls,
>> > and
>> > on the server side there's this in the kernel log:
>> >
>> > ```
>> > ksmbd: Unsupported addition info: 0xf)
>> > ksmbd: Unsupported addition info: 0x20)
>> > ```
>> >
>> > repeated multiple times. I must note that in fact the file gets copied
>> > to
>> > her
>> > laptop, but Windows copy dialog just hangs.
>> >
>> > Any idea what it could be and how to avoid it? This also happened
>> > before
>> > (I'm
>> > a pretty early ksmbd adopter), but I'm reporting it just now because I
>> > na=C3=AFvely
>> > hoped it would be fixed automagically :). This never happened to me
>> > with
>> > userspace Samba though.
>> >
>> > This is my smb.conf:
>> >
>> > ```
>> > [global]
>> > workgroup =3D KANAPKA
>> > server string =3D ksmbd server %v
>> > netbios name =3D defiant
>> > valid users =3D __guest
>> >
>> > [Shared]
>> > valid users =3D __guest
>> > path =3D /mnt/shared
>> > force user =3D _shared
>> > force group =3D _shared
>> > browsable =3D no
>> > writeable =3D yes
>> > veto files =3D /lost+found/
>> > ```
>> >
>> > Appreciate your time and looking forward to your response.
>>
>> Thanks for your report, I have seen same symptom before, I thought it
>> was a windows issue as it is also reproduced against samba. If you
>> wait for a few minutes, does not the 99% message window close?
>
> Eventually it does close on its own in a minute or so. Also, it may close
> after clicking the "X" (close) button, but not instantly.
As I remember, The X button will delete the file you copied. Could you
please give me packet dump(tcpdump) on problem situation ? and It
would be nice to give a dump also for a successful copy. I will try to
compare the two.

Thanks!
>
> --
> Oleksandr Natalenko (post-factum)
>
>
>
