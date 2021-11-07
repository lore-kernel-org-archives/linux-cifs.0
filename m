Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDD3C433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 20:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D960C6115A
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 20:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbhKGUgV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 15:36:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233254AbhKGUgU (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 7 Nov 2021 15:36:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DE016137D;
        Sun,  7 Nov 2021 20:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636317217;
        bh=TipMEeXbLK71rqDUcKVBo/tOx+moJRr+RfW/8r72DaU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=GRaC+dr35Xxuw3vS2yWcRXSF2SOySq3TBTibjAMxcN2YDdHMNq3GI6uiM2KiYN5tt
         CAhvR4ltb+TOmYAQIoSD89qG6u/7BlNmibsNay8xbXD0VgtULxN4V2/SUCMe1IMxnw
         /nR3ezMWnVjH6pU4xEmgTEgzqIiKN+WseF0HLU0zpi+ocnjxDVdpw4HLcwqhjlILHf
         adlsORYvJRh+s3KFKzJ/UnU8y4mOBWHeSvI6tiCoVLS+xHBrhQ07ZlNWtj6AgXMYva
         kxfY4UcWl+BKvpM7JNPfsrO7s6HxWp8A92ZRNZhjI1+ATbCFmqeQLMBQ95ZHspKfNG
         9jAJN64kTYv5w==
Received: by mail-ot1-f49.google.com with SMTP id v40-20020a056830092800b0055591caa9c6so22485255ott.4;
        Sun, 07 Nov 2021 12:33:37 -0800 (PST)
X-Gm-Message-State: AOAM532CHAtwUTVXN6n9njEPTz9m2z4DzFsBwBXjACKqANYL1FrvaMmi
        qZ2dRykmQKZ44bua1oNsHanSvNrRkmqSwW/aUME=
X-Google-Smtp-Source: ABdhPJwVshPPrt2lhJPMOMOUZjKHGN41W72uyeuko9xH1CyuG98J7HrQjaQ8Xvst12YH+EaVXaXnhckIpUVhavAhQMA=
X-Received: by 2002:a9d:46a:: with SMTP id 97mr19692381otc.18.1636317216766;
 Sun, 07 Nov 2021 12:33:36 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:4448:0:0:0:0:0 with HTTP; Sun, 7 Nov 2021 12:33:36 -0800 (PST)
In-Reply-To: <17d0c2af6d0a35c2951f0ac5c7a1dfea04df410f.1636298480.git.christophe.jaillet@wanadoo.fr>
References: <17d0c2af6d0a35c2951f0ac5c7a1dfea04df410f.1636298480.git.christophe.jaillet@wanadoo.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 8 Nov 2021 05:33:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9zhFB0cX4DVz-ZwpBzPHq+aN_-Mi-pYeo+EGxaDYd_LA@mail.gmail.com>
Message-ID: <CAKYAXd9zhFB0cX4DVz-ZwpBzPHq+aN_-Mi-pYeo+EGxaDYd_LA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Fix an error handling path in 'smb2_sess_setup()'
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     senozhatsky@chromium.org, sfrench@samba.org, hyc.lee@gmail.com,
        mmakassikis@freebox.fr, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-08 0:22 GMT+09:00, Christophe JAILLET <christophe.jaillet@wanadoo.fr>:
> All the error handling paths of 'smb2_sess_setup()' end to 'out_err'.
>
> All but the new error handling path added by the commit given in the Fixes
> tag below.
>
> Fix this error handling path and branch to 'out_err' as well.
>
> Fixes: 0d994cd482ee ("ksmbd: add buffer validation in session setup")
Cc: stable@vger.kernel.org # v5.15
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
