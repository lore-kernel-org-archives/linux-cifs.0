Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916C0C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 23:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7248761B71
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 23:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhKPXjw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Nov 2021 18:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229532AbhKPXjw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 16 Nov 2021 18:39:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C05E61B71;
        Tue, 16 Nov 2021 23:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637105814;
        bh=yYPlVugWDLGu9reVQ8/u3/GZP8SiDuuyCaxKBOzfcVM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=m/AKUdkjjyY6+d3sb0CiKGOAeikfv8YLummaMW7zDUzdxdGIBMHIgraY5HCMertt6
         aCyeOUzgjLzA+TmhsPK5+MPE8EKVQkHMOKLI/S8DRZIbBgAIR473kqWjV8w7YWC2iI
         nSAf6KYVYkMwDPV7mecs797zARv0uMUQBbrpkVIPRD8pb6zMWWYauJeJVh5FqIr7yz
         B68kdvu6bwkaWUun0+7coAlOBQ54NOvvYApr3VMJRK7Zy+Zpa+CdVk1Vxcu4O9SUsb
         K2udHY1hlFrD9hYW/B3OaYrkTbuj6mRM+/DP5P8NlbEQAkK/5OaChjDBP++xcOTkQ0
         DGYUWMCKx/R9A==
Received: by mail-oi1-f179.google.com with SMTP id t23so2163863oiw.3;
        Tue, 16 Nov 2021 15:36:54 -0800 (PST)
X-Gm-Message-State: AOAM53179ESS9Vryg+su2NIZvHa76tLk4aBWsqKEwnxtlIT3MMnh5JCb
        IUIe9CIZR1Tm84aVcOPJb4BslsbC+0tI8WSkv0c=
X-Google-Smtp-Source: ABdhPJzsFjtMS0Pa8Z55mHQ8ceBA+FC1Ld+XmJGtIqRgm4plYpcEVCG7bhZzJ90L91LUeE1jf1i9fj2sZHC8gedbV1c=
X-Received: by 2002:a05:6808:14c3:: with SMTP id f3mr37766948oiw.51.1637105813781;
 Tue, 16 Nov 2021 15:36:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:4448:0:0:0:0:0 with HTTP; Tue, 16 Nov 2021 15:36:53
 -0800 (PST)
In-Reply-To: <5831447.lOV4Wx5bFT@natalenko.name>
References: <5831447.lOV4Wx5bFT@natalenko.name>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 17 Nov 2021 08:36:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-KmxMeYWP8z6RYYK6za-Sj81Qtb3RO=oG+Yy3kXDaLjg@mail.gmail.com>
Message-ID: <CAKYAXd-KmxMeYWP8z6RYYK6za-Sj81Qtb3RO=oG+Yy3kXDaLjg@mail.gmail.com>
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

2021-11-17 6:44 GMT+09:00, Oleksandr Natalenko <oleksandr@natalenko.name>:
> Hello Namjae et al.
Hi Oleksandr,
>
> With the latest ksmbd from the next branch I have an issue with wife's
> Windows
> 10 laptop while copying/removing files from the network share. On her cli=
ent
> it
> looks like copy operation (server -> laptop) reaches 99% and then stalls,
> and
> on the server side there's this in the kernel log:
>
> ```
> ksmbd: Unsupported addition info: 0xf)
> ksmbd: Unsupported addition info: 0x20)
> ```
>
> repeated multiple times. I must note that in fact the file gets copied to
> her
> laptop, but Windows copy dialog just hangs.
>
> Any idea what it could be and how to avoid it? This also happened before
> (I'm
> a pretty early ksmbd adopter), but I'm reporting it just now because I
> na=C3=AFvely
> hoped it would be fixed automagically :). This never happened to me with
> userspace Samba though.
>
> This is my smb.conf:
>
> ```
> [global]
> workgroup =3D KANAPKA
> server string =3D ksmbd server %v
> netbios name =3D defiant
> valid users =3D __guest
>
> [Shared]
> valid users =3D __guest
> path =3D /mnt/shared
> force user =3D _shared
> force group =3D _shared
> browsable =3D no
> writeable =3D yes
> veto files =3D /lost+found/
> ```
>
> Appreciate your time and looking forward to your response.
Thanks for your report, I have seen same symptom before, I thought it
was a windows issue as it is also reproduced against samba. If you
wait for a few minutes, does not the 99% message window close?

Thanks!
>
> Thanks.
>
> --
> Oleksandr Natalenko (post-factum)
>
>
>
