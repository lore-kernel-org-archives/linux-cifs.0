Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CADC433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Feb 2022 02:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiB0Chp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 26 Feb 2022 21:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiB0Cho (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 26 Feb 2022 21:37:44 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C972A24A829
        for <linux-cifs@vger.kernel.org>; Sat, 26 Feb 2022 18:37:07 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id v22so12658539ljh.7
        for <linux-cifs@vger.kernel.org>; Sat, 26 Feb 2022 18:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=Yz3Ywju4CAZDdX91LkFgEI/u0yFaY8yVia1patdfBks=;
        b=gP9BxbJUrWrPJelaRfNE3WQzwiF+KxzGvePHOZDfx9WTJRTZjml+Hhp6ywm4wdnwAu
         5jT1F3ByTsF81LIJ6huyxQ2x/yyTMdFYtwjtjGghf71suBjLU2aBvnkcYUXGpIE0ZKPf
         MjJuDZ1InMqQSNCHNEQMbrXh8lyDN4yc7p6ZtiEzOj/6pFB2CHdDSQOFfK4fnKAEK5wu
         zfZlNiLch4gmXKA4rwS/1TYFYmJVivSXTdIq3KMZq50XElvb6Yw++SeXG8z963x4zSOX
         EU5Fb+hlXNZ+/v7ivk1sillU5GnMnQ0USX4etszNfyTXOU5CWD6eucBmuYhkEHx5UmoI
         FFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Yz3Ywju4CAZDdX91LkFgEI/u0yFaY8yVia1patdfBks=;
        b=DaQZvZ2w5u6ay+g74cVLeXpNWY6pJsbVw5MMgXL/FVs1oBZhOFQBFTGirCEHPdsAtH
         O+Ko33O2hNRZLl4iVoBIEnehVSKw2mh38sTqMxtVBLsLkoFjHWUbjr8DLLABTAn1ZISx
         maBCoRJ+JyK0xciC1zb3nEw99DckUzWcNGKxcHRv7Jz5uZu1Nx166yEIPy4L6gajZT7I
         qk4WAJqvJahiHsR0CRZ+oTnUURotyLfq1/IRP85CAA+4d0cr/QLy6yHxnqQlzGe4a0Gk
         CEk7pwBuz3so+u11O4TH1XiV7ra7e8JSHsBEX2n/WRJAvaUw0h5zt63XU9SfPxzs/Z0v
         A0kQ==
X-Gm-Message-State: AOAM530hOHtrzwP3fxIFNrlCgYCW3iiitj1QBSdB+0QZyzxC8pnyspas
        qVV8uvkxMx7bIVDDzGXRm1lZmYIpQB/5rC5uL9yq/ePYoexHfw==
X-Google-Smtp-Source: ABdhPJwj4IoB2WPkINUp86GMoJvjmLuDbL254oV766fI3NYlxP4iDVtdXsDzy1W65HGiO2AvMscY/Lmvlt34hr0po3g=
X-Received: by 2002:a05:651c:b06:b0:246:6331:c34f with SMTP id
 b6-20020a05651c0b0600b002466331c34fmr9925299ljr.362.1645929425592; Sat, 26
 Feb 2022 18:37:05 -0800 (PST)
MIME-Version: 1.0
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Sat, 26 Feb 2022 21:36:53 -0500
Message-ID: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
Subject: Failure to access cifs mount of samba share after resume from sleep
 with 5.17-rc5
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I'm on a x86_64 ubuntu 22.04 system accessing a similar system running
samba Version 4.13.14-Ubuntu. Both systems are on ubuntu mainline
kernel 5.17-rc5.

I have a samba share mounted from my fstab, and file access works fine.
Upon suspending my system and resuming though, the mounted samba share
is inaccessible, and my dmesg has many "CIFS: VFS: cifs_tree_connect:
could not find superblock: -22" messages.

Unmounting and remounting the share restores access.

When I boot into kernel 5.16.11, I do not have this issue. The cifs
share is accessible just fine after a suspend/resume cycle.

I assume this is a regression with 5.17? Is there any information
worth providing which might help debug and fix this issue?

Regards,

Satadru Pramanik
