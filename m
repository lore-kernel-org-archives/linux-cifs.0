Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C7AC433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 15:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBEEE60E52
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 15:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhIFPst (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 11:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhIFPss (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 11:48:48 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B03C061575
        for <linux-cifs@vger.kernel.org>; Mon,  6 Sep 2021 08:47:43 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id s3so11986354ljp.11
        for <linux-cifs@vger.kernel.org>; Mon, 06 Sep 2021 08:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ticI7F/GWjBd8T/lOsE/zzS4vnwt6Hm54UCWVFhEEoc=;
        b=Po67u2k5WPcpoxKyklD4+ltbOctd6zKrVMnPHqy217NE+vh72lXnJjWyNTe4UiUyN8
         fasQAdh4Ev4o4zfwV2JsIXioSoE+yWSuuFHJlxts4YhMGKJmqZrUgBAJWapAvAkUx0Pc
         ZYS7kcb2zbb3bZqwmX5zND+rzzUKSTZY4nY6t0qg/OTb5ul2OIY6eFz1WBfxc3V+UVIM
         Y+WXvYebHxDt0EogajVg7Mf4BYYND27Zgtq9iCMUG3p8LL4gD5vWJ7nglvcI/KHadNVe
         uozcFTwWrmXKXc7Ytz69pBxvgtPk7GKpyE6g3/5qFXE4Mo/dFWfpiWJUPZq0KrS2nXAM
         x4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ticI7F/GWjBd8T/lOsE/zzS4vnwt6Hm54UCWVFhEEoc=;
        b=L2jqIao2vnag6ctP1AqgzuPtoBuIMjwfWXrtrwk37efI/ez6knmlt9rZbp97gWyiEU
         ePlYxL3R8ZfcII0hDwBgNJlHgmwpBdmn4wEuOYRQbtxEzeTkdqXTRK6wR6Ns+o8XE3wn
         xzdS8gUF9uPK4tgtOEeRFTFNvyXi8vvO0dYN8m45DzXIir4v+01wZIdRSGv+H6hhIwQf
         vmWHxq+ZOjFzu5NjrIsNDULwP9sgkA9LGwatifbG4W5OLpB4Y1w6/rnN+X3zWXu6/1BJ
         0DtuZ5Rx4X8uO2j++cuPGrYXhxtRac20vxHlNcPrWTR2F25bkqHCscrzxVSYPSLDGUES
         ADIg==
X-Gm-Message-State: AOAM533vuCKj+7LW5yPu9zGReOtQgRQyvrYZCOx6Ft8dyvfOrUb1joWD
        umzjb/FWjmida25VwjvX+67kfCvHDZ3j+LGb8WEikoWTRaw=
X-Google-Smtp-Source: ABdhPJyzIDL3JKuwo2N/Paul4Mn19sbfIkyXGcbVWJuQyUcs2cPGXLftYC1dM7Mr4pHNl8Zmh6eHYDhLQ+zGxzzp1QE=
X-Received: by 2002:a2e:2414:: with SMTP id k20mr11231679ljk.482.1630943262051;
 Mon, 06 Sep 2021 08:47:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210906114551.azccg5o4lh4fompe@xzhoux.usersys.redhat.com>
In-Reply-To: <20210906114551.azccg5o4lh4fompe@xzhoux.usersys.redhat.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Mon, 6 Sep 2021 21:17:31 +0530
Message-ID: <CACdtm0ZysFcRQga8DSrVz2iKVoFmTQihLzy+QY667+i06cQgAw@mail.gmail.com>
Subject: Re: [regression] lock test hang since 5.13-rc-smb3-part2
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Rohith Surabattula <rohiths@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Can you please share the mount options.

Did you observe the same failure with 5.14-rc5-smb3-fixes ?
I ran the generic/478 test on 5.14 and didn't see any hang. But, test
fails with below

generic/478     - output mismatch (see
/home/lxsmbadmin/xfstests-dev/results//sm
                                               b3/generic/478.out.bad)
    --- tests/generic/478.out   2021-05-03 19:01:04.767577557 +0000
    +++ /home/lxsmbadmin/xfstests-dev/results//smb3/generic/478.out.bad
2021-09-
              06 15:39:39.625248615 +0000
    @@ -1,13 +1,13 @@
     QA output created by 478
     get wrlck
     lock could be placed
    -get wrlck
    -get wrlck
     lock could be placed
     get wrlck
    ...
    (Run 'diff -u /home/lxsmbadmin/xfstests-dev/tests/generic/478.out
/home/lxsm
                badmin/xfstests-dev/results//smb3/generic/478.out.bad'
 to see the entire diff)
Ran: generic/478
Failures: generic/478
Failed 1 of 1 tests

Regards,
Rohith

On Mon, Sep 6, 2021 at 5:16 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> Hi,
>
> Since this commit:
>
> commit c3f207ab29f793b8c942ce8067ed123f18d5b81b
> Author: Rohith Surabattula <rohiths@microsoft.com>
> Date:   Tue Apr 13 00:26:42 2021 -0500
>
>     cifs: Deferred close for files
>
> Xfstests generic/478 on CIFS can't finish like before. The test programme
> never returns but killable. The kernel does not warn about soft or hard
> lockups. So it looks like looping forever at some point.
>
> It's always reproducible. Without this commit, generic/478 fails the test
> because of different lock schema but complete very fast. With this commit,
> test hang like forever.
>
> Sorry that I do not look further here, because I have another bisecting to
> do to hunting another regression.
>
> Thanks,
> Murphy
