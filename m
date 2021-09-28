Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA20FC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 05:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4DD86108F
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 05:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhI1Fio (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 01:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234177AbhI1Fin (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 28 Sep 2021 01:38:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1639610A5;
        Tue, 28 Sep 2021 05:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632807424;
        bh=mY7DzCCKmoP9FbOE974hh/zqkva4viRT0m/5IWCizT8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=A87lu1zgZhioZfYM5GrnZmNExfPFhXc/LWJCjxJWv8B3Eq4SxCnSK2Rxe5mZACib6
         fQqJbNvRBHjGx1/3Zmv1Lsk2Q09MTuHSIHlyo1nQowqtQMLDrXHjeZP5gtMOZI62lJ
         T8Q6nuRIZjGoVWoKy1o/2bSFPPFz1GjzpSok1CQPzC3GXmzIUnUIl559Rcl0RAC9m+
         3vVDOR0w8q6EkWlaqD1w2anXT6QrNM/PdIYu2GKbySu5SvJgtFDjnbopg3hO1GObvP
         fRU1zxuTdGpueA344FgLH5erehUGl2971RJnkkcQ0ifSYTHu69aqR2PIvVb4MTR7pM
         N+XOYg6beKyVQ==
Received: by mail-oo1-f52.google.com with SMTP id k11-20020a4abd8b000000b002b5c622a4ddso1485974oop.1;
        Mon, 27 Sep 2021 22:37:04 -0700 (PDT)
X-Gm-Message-State: AOAM533EMEbrBBTH2qP0yqWalY/VSYlYY7Nrcg+CNk3C5ndN0t+GpEve
        dlaCYmuQgtCZBl/ufnYdNYaavDHrEQJLyc6efKQ=
X-Google-Smtp-Source: ABdhPJyEciQDsXzEHR9d5YxpBUEtnxvR/CZ2ECbE3jOQodQWUH6dlYBwQhldKNLrW892gkjLFkSEuRLKW2Uz2KDVj9U=
X-Received: by 2002:a4a:b78c:: with SMTP id a12mr3440673oop.58.1632807424194;
 Mon, 27 Sep 2021 22:37:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Mon, 27 Sep 2021 22:37:03
 -0700 (PDT)
In-Reply-To: <CAKXUXMyhrjf0=0jaYG89zHULKGA-z+tgUZr=tQmBWZZUCCDuwQ@mail.gmail.com>
References: <CAKXUXMyhrjf0=0jaYG89zHULKGA-z+tgUZr=tQmBWZZUCCDuwQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 28 Sep 2021 14:37:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_N5juxVTbfA0cVMMKbZa3sk1MnCeBjoMxQnmzEK4Paqw@mail.gmail.com>
Message-ID: <CAKYAXd_N5juxVTbfA0cVMMKbZa3sk1MnCeBjoMxQnmzEK4Paqw@mail.gmail.com>
Subject: Re: No fs/cifs_common directory in kernel tree
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        Steve French <stfrench@microsoft.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-28 13:19 GMT+09:00, Lukas Bulwahn <lukas.bulwahn@gmail.com>:
> Dear Steve, dear Namjae,
Hi Lukas,

First, Thanks for your report!
>
> I am tracking consistency of the MAINTAINERS file and noticed:
>
> Commit 332c404a55ef ("cifs: add cifs_common directory to MAINTAINERS
> file") and commit e9e3d5f9e34c ("MAINTAINERS: ksmbd: add cifs_common
> directory to ksmbd entry") add the file entry fs/cifs_common/ to the
> sections COMMON INTERNET FILE SYSTEM CLIENT (CIFS) and KERNEL SMB3
> SERVER (KSMBD).
>
> However, as of now, there is no fs/cifs_common/ directory in the
> mainline tree or in the latest linux-next tree.
>
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:
>
>   warning: no file matches    F:    fs/cifs_common/
>
> Are there more commits to come that will add or move files to
> fs/cifs_common/, or did you decide against introducing fs/cifs_common/
> in the course of the development and these commits are left-over from
> a previous development?
cifs_common directory has recently been renamed to smbfs_common.
I will update cifs and ksmbd entry in MAINTAINERS.

Thanks!
>
> Best regards,
>
> Lukas
>
