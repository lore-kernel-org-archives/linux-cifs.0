Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D225C4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 10:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhLPKFd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Dec 2021 05:05:33 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:51136
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233678AbhLPKFb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 16 Dec 2021 05:05:31 -0500
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0D68B4068E
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 10:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639649130;
        bh=iEjFNSHMwi4aeXpe7cQghYno80kPHKULcTC4SGtg0Js=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=sQlCXDkHyyfpPGofjCMUtFw2SsLAVDnrnr/gISSdvLsK8qiFt2TvzkP2xscHxyifA
         M6vl3sB3NeWDqPjJvOwQJcpg/ffx0cDO7WrDF1ETPFsIjP6m/rsAoJcaVBpJ6iU/qA
         VLuS3kO1l3lEw4hHnBggRSmVoydaVE4YGHzE0kRvZXB7cezyMXl8Xg+PozwZRg8UlG
         Ojrp439VUuhFhvMowYle2ZjkPmnPcV92Bkt+N1LVGIuxSg0cRsazzrml5eNcayreLd
         yhtYk7mjWdOUcJ3PViUQgllOYzu8XhDJAaNNSslvuF4AL+PjjR2SldldlexKdPHvVH
         JTv6gx0aiBIdA==
Received: by mail-ed1-f71.google.com with SMTP id d13-20020a056402516d00b003e7e67a8f93so22857689ede.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 02:05:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iEjFNSHMwi4aeXpe7cQghYno80kPHKULcTC4SGtg0Js=;
        b=Eca3VwgkPher8Cw/AMOibLC2nMSUgcMViV0U/bV/8jFVbxPItnmUqB6lL2RDb9eCRL
         3v1dOqyb4kuYQIFIvOZ2g62W02UIxWvz5fcnk8ZnmMyoR2mYK3qAou+YxPn5CRdRmdQk
         1V/x/gGcMO3fSvlAl2x+A5uPbH6Rl52fJy06OOAMnEQJiF0qgyycLVgGyGnBI1d2ymoI
         Sdh+h+cVtGVywtaWBRLV8wX7ILKpGZggggEnit83iyk1/DTm2ZNbzXMW/vCJmtsepnBs
         SBFPF14gvx4ACqqmSqEgJzBHSEC2CqtK0BBA99cuEqfrjxqi9uJLxUCoXKWrS1Sj01gv
         3qWg==
X-Gm-Message-State: AOAM531UGSS8BevxVwboqQmU+tewyxbdyFPSRvGKUUtNg3WzMoiVlhT+
        voy6bS0IAVGNbuLrIb8lH2e0YFB6zRBjOxspszS0iXAqFouICo5l/+3oQjQxCazsanNEZDk3QkZ
        bedVeF9XQvYBuygj0SDEGzgzSLH2LkvI0ZXGW6hHHlGIVOJYyWdZFFKI=
X-Received: by 2002:a17:906:48d:: with SMTP id f13mr1328909eja.178.1639649129033;
        Thu, 16 Dec 2021 02:05:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4csYse2ts0CIc+GNT8hFD4S36DkgIwbzgfyBzIjr+nwEiJtuY5m75c6D7//m27d8UIPSjBoFZUfOIoRMOvGc=
X-Received: by 2002:a17:906:48d:: with SMTP id f13mr1328883eja.178.1639649128845;
 Thu, 16 Dec 2021 02:05:28 -0800 (PST)
MIME-Version: 1.0
References: <20211105154334.1841927-1-alexandre.ghiti@canonical.com>
 <CAK8P3a2AnLJgGNBFvjUQqXd-Az9vjgE7yJQXGDwCav5E0btSsg@mail.gmail.com>
 <CA+zEjCtajRJhs8zSdR_oFBOO3P5FWWZJ3L6N-GK+JnUjdymTiA@mail.gmail.com> <CAK8P3a3aJJYcONV9JMcn47=mW4P4kvYFdwnTdyZfRqeo+eGndQ@mail.gmail.com>
In-Reply-To: <CAK8P3a3aJJYcONV9JMcn47=mW4P4kvYFdwnTdyZfRqeo+eGndQ@mail.gmail.com>
From:   Alexandre Ghiti <alexandre.ghiti@canonical.com>
Date:   Thu, 16 Dec 2021 11:05:18 +0100
Message-ID: <CA+zEjCu9KmTMpvXkFqgHX0C1jNZKquZU4owZKaJ_-o4+M_7ACg@mail.gmail.com>
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

On Wed, Dec 15, 2021 at 10:49 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Fri, Dec 10, 2021 at 9:38 PM Alexandre Ghiti
> <alexandre.ghiti@canonical.com> wrote:
> >
> > On Fri, Nov 5, 2021 at 4:56 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > On Fri, Nov 5, 2021 at 4:43 PM Alexandre Ghiti
> > > <alexandre.ghiti@canonical.com> wrote:
> > > >
> > > > While bumping from 5.13 to 5.15, I found that a few deleted configs had
> > > > left some pieces here and there: this patchset cleans that.
> > > >
> > > > Alexandre Ghiti (7):
> > > >   Documentation, arch: Remove leftovers from fscache/cachefiles
> > > >     histograms
> > > >   Documentation, arch: Remove leftovers from raw device
> > > >   Documentation, arch: Remove leftovers from CIFS_WEAK_PW_HASH
> > > >   arch: Remove leftovers from mandatory file locking
> > > >   Documentation, arch, fs: Remove leftovers from fscache object list
> > > >   include: mfd: Remove leftovers from bd70528 watchdog
> > > >   arch: Remove leftovers from prism54 wireless driver
> > >
> > > Looks all good to me, thanks a lot for the cleanup!
> > >
> > > For arch/arm/configs:
> > >
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > >
> > > assuming this goes through someone else's tree. Let me know if you need me
> > > to pick up the patches in the asm-generic tree for cross-architecture work.
> >
> > Arnd, do you mind taking the whole series except patch 6 ("include:
> > mfd: Remove leftovers from bd70528 watchdog") as this will be handled
> > separately. I can ask Jonathan for the doc patches if needed.
>
> I tried to apply them, but only three of the patches applied cleanly. Can you
> resend them based on v5.16-rc1?

Sure, I have just sent the v2.

Thanks,

Alex

>
>         Arnd
