Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC7DC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Dec 2021 20:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242876AbhLJUmk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Dec 2021 15:42:40 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:44318
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238944AbhLJUmi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 10 Dec 2021 15:42:38 -0500
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 585753F1FE
        for <linux-cifs@vger.kernel.org>; Fri, 10 Dec 2021 20:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639168739;
        bh=5yoGUr7pzPnZBDOdChvpH3bNEBPR4tkHUNd2RR7JJH4=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=BRCUsPR06OVqA3BSsD2JDjbk0HpixY2uxOL+YPspNWLiElif4YZ/QmhfKPeNczP17
         kt7Lm2ZJbHUmiPzO+Ow4d3qOY2kQfEeaUFUnW7TS2SYvychOKysswYMLNh/FSS/CH5
         a7QEzF7+Tpned5dvgBdKfCfCNoM7+yV6M7DtZJdWJtr2yj3EEOFc6OIo1Fmu/0LbeR
         BhAmQ29pvEZHK592tlMl5l9hFP5OoCBJDNAJRWoFd/CxH24OR34Xe8HbhZ4yyzd8J3
         gbIX64rcF1/C/s+ReLqKPbtPFk0z6kySgnRaLhMrigwqK2VLGYVRvH/UER1lgkkUEI
         5pENmOAe6qpMQ==
Received: by mail-ed1-f72.google.com with SMTP id q17-20020aa7da91000000b003e7c0641b9cso9185720eds.12
        for <linux-cifs@vger.kernel.org>; Fri, 10 Dec 2021 12:38:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5yoGUr7pzPnZBDOdChvpH3bNEBPR4tkHUNd2RR7JJH4=;
        b=hCDcw6pZ4pTma3EO2+cX2U5U0U7a03uPJyQFpCFvxYfh8dU0FmFxavyZ9g7DTUI23z
         +AKibyt6Qp3EdPDwIYSWhDGapcn4NNgyOMhLvsQ+xPBJdNayOKgdkiZuI1/ZEbCG00te
         EY+4//GTR4rtxjQqeZPMMbSrrcvmhvH/UytGPooBcMYv2fcZJyzA3/AML+An+cQZe8DU
         pH1CghSrMOmy9+Lxj7Wut11ypfxb9MSNdh+MK1OQAvPjhRLYvrjWXZRi6wc0qEk4BU4P
         HIsAiAtxakDipHzQ/bN0f27F6pWkv2T9q9RNkSDEagrxa0ufzk7FYNrQbHhEHVaQXEvY
         5UAQ==
X-Gm-Message-State: AOAM53275yDZ2qQuHXFGLF4JDJt+iPOqx46MqTUV7voxcyA2PD24m7Yj
        s3O0/1j+/RMT3x9wjPlnyXKbtqiK+yj0Oe0nnkuVWMJhzaCi1AB6kNMdBelgyRYcGtgU+PesGeP
        I33r8VT2Zb/504ab0BpszYVItCMnDoPpe8H2vMcdK0WAoChgVT6z/zgU=
X-Received: by 2002:a05:6402:274c:: with SMTP id z12mr43261379edd.294.1639168738732;
        Fri, 10 Dec 2021 12:38:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgA236x/yjx6TWkXOleXezvnEgrIAVa1yzBQb8Ze+JaO9/0KXgBOBtxlFprZiSdLFnjBlcdw/PZl80G6UL+y4=
X-Received: by 2002:a05:6402:274c:: with SMTP id z12mr43261361edd.294.1639168738589;
 Fri, 10 Dec 2021 12:38:58 -0800 (PST)
MIME-Version: 1.0
References: <20211105154334.1841927-1-alexandre.ghiti@canonical.com> <CAK8P3a2AnLJgGNBFvjUQqXd-Az9vjgE7yJQXGDwCav5E0btSsg@mail.gmail.com>
In-Reply-To: <CAK8P3a2AnLJgGNBFvjUQqXd-Az9vjgE7yJQXGDwCav5E0btSsg@mail.gmail.com>
From:   Alexandre Ghiti <alexandre.ghiti@canonical.com>
Date:   Fri, 10 Dec 2021 21:38:47 +0100
Message-ID: <CA+zEjCtajRJhs8zSdR_oFBOO3P5FWWZJ3L6N-GK+JnUjdymTiA@mail.gmail.com>
Subject: Re: [PATCH 0/7] Cleanup after removal of configs
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Steve French <sfrench@samba.org>, Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jeff Layton <jlayton@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cachefs@redhat.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-power@fi.rohmeurope.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Nov 5, 2021 at 4:56 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Fri, Nov 5, 2021 at 4:43 PM Alexandre Ghiti
> <alexandre.ghiti@canonical.com> wrote:
> >
> > While bumping from 5.13 to 5.15, I found that a few deleted configs had
> > left some pieces here and there: this patchset cleans that.
> >
> > Alexandre Ghiti (7):
> >   Documentation, arch: Remove leftovers from fscache/cachefiles
> >     histograms
> >   Documentation, arch: Remove leftovers from raw device
> >   Documentation, arch: Remove leftovers from CIFS_WEAK_PW_HASH
> >   arch: Remove leftovers from mandatory file locking
> >   Documentation, arch, fs: Remove leftovers from fscache object list
> >   include: mfd: Remove leftovers from bd70528 watchdog
> >   arch: Remove leftovers from prism54 wireless driver
>
> Looks all good to me, thanks a lot for the cleanup!
>
> For arch/arm/configs:
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> assuming this goes through someone else's tree. Let me know if you need me
> to pick up the patches in the asm-generic tree for cross-architecture work.

Arnd, do you mind taking the whole series except patch 6 ("include:
mfd: Remove leftovers from bd70528 watchdog") as this will be handled
separately. I can ask Jonathan for the doc patches if needed.

Thanks,

Alex

>
>          Arnd
