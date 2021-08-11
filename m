Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13323C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Aug 2021 13:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAB9C60FC0
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Aug 2021 13:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhHKNOr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Aug 2021 09:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbhHKNOr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Aug 2021 09:14:47 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CDAC061765
        for <linux-cifs@vger.kernel.org>; Wed, 11 Aug 2021 06:14:23 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id c24so5577234lfi.11
        for <linux-cifs@vger.kernel.org>; Wed, 11 Aug 2021 06:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=hHdqaqdTsPWJDS3MJ9beCzDI2xcDaT1X9lo1VFSmxno=;
        b=tVv7cxir5ZKiBC/HnJ7Y6nN5kiUNIP/9dUbmHJIiD7mAV9oSH3Fon5sNrm9KBZhU7K
         DGs9uFjxUIwCQJApLHymmNSdEmZAIjktDM3UCUEZr8EfGA4Tb/byJH/fXdeG7eZhRAbP
         DdLijswNcJMeK3SEPafk1xdIP6T2rM+epJBlx1+pFtm4m8i+QoknQ1sb+hMnG44lCJY4
         D5TFqiQuqilMjXRVg/BDWyG91eA1cAl6r4un+q3DbCIAsoplE4SXW9Ao8Rk+mkDkc2hl
         CR1VPm3ScAIxI+C/NlySILi7+FiI0kiPxVHmVlqNPPUPVX2/0lzA3y36ub0ykKElCMAK
         kfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=hHdqaqdTsPWJDS3MJ9beCzDI2xcDaT1X9lo1VFSmxno=;
        b=WED9eyRYQhRyPkfRuXM7Zuj0xNnLBiIjpW9kon83/9en9Mn76T7UywKyDAJwd188qL
         ROutp2dJXdG8IvdS7IoD+owBOhFm9TMX4C42BVj0CzPZ3/B9zHOulM6IedmSQaMD9lU7
         w0DwSuE7PitkWbzViqmyMUfbsEH/56t4D1SXyCvRAkpIRtAUac+htw79WOiWuZqhjQiF
         S75vuBz1EQNi8zlN7IpQ/T9mHKuvOSXiidiJVxSlmgYWwrxYJoRw/sL0/ulYJGqbHjCE
         s8FYuGON996r9z95a87IpgYdJ1v4fbA4Y2Vk4SLPA1JnteHPVyv65IC1MPYmvWhpcvDv
         +mvQ==
X-Gm-Message-State: AOAM532ERlHha9qht/l/Fgukvx7DJ2PTGE3H77zvWLJY8NCq55IfFJnP
        h/5pgEkHvCOsxvPMt3t17EW65Ynv5rvJ4YOxshd48ED8zVKhQA==
X-Google-Smtp-Source: ABdhPJyY3RRZXnwf0x5rvSo3KaWYQ5aoEgrt/rRJh0mFG84gLwLn+XV9PGOHGfkZ12MI+vhruQuh1WVBHqbvUp0gHBs=
X-Received: by 2002:a05:6512:1518:: with SMTP id bq24mr24751312lfb.271.1628687661964;
 Wed, 11 Aug 2021 06:14:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAJK_Yh-m-p8r=9WhrHn=V5yMWBpYZCRZeqWyci+NbUEGNPwpYw@mail.gmail.com>
 <CAJK_Yh_tWGoRkCSfSwPBHi2SAPi9cKeyb8L=Lg1Gx=xtEDY29w@mail.gmail.com> <CAH2r5mv0XxFDMyY-iSDKqQUvH38fpjHJ762hNaCKjwwUM1eY4w@mail.gmail.com>
In-Reply-To: <CAH2r5mv0XxFDMyY-iSDKqQUvH38fpjHJ762hNaCKjwwUM1eY4w@mail.gmail.com>
From:   =?UTF-8?B?U1pJR0VUVsOBUkkgSsOhbm9z?= <jszigetvari@gmail.com>
Date:   Wed, 11 Aug 2021 15:13:45 +0200
Message-ID: <CAJK_Yh_h60N0muLaEjj6M-=VSHdSAT7tsXD__RPdaOJkMpazwg@mail.gmail.com>
Subject: Re: rsync copy operation fails on a CIFS mount
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dear Steve,

Thank you so much for the long list of recommendations and tips.
I will try to answer to some of your questions that I can answer right
away, and will try to
come back to you on the others at a later time.

Steve French <smfrench@gmail.com> ezt =C3=ADrta (id=C5=91pont: 2021. aug. 8=
., V, 22:57):
> Is this a large file workload, or lots of small files in directories,
> or deep directory trees?

Yes, it is in deed. A directory typically has between 1700 and 1100
files, with a total size of
about 150 GB. In each directory there is one large file with a size of
between 90 and 100 GB,
and the rest of the 1xxx files are about 40-50 MB each.
Based on the recommendations I got over the samba mailing-list, I
recommended some config
changes that would hopefully reduce the number of the smaller files in
a directory to about 1/8th
of the current numbers. We'll see what difference that change makes.
Ideally one or two such directories are copied in a routine rsync job run.

> Large directories, and deep directory trees can result in the Linux
> VFS layer doing many revalidate
> requests beyond the default 1 second metadata caching timeout (cifs.ko
> is stricter than some other
> fs in defaulting to 1 second).   Especially if this is the only client
> likely to update the files while backing them up
> then setting actimeo much higher (e.g. actimeo=3D30) could be helpful.

Thank you, we will try this option!
In our case, the machine offering the share is doing so for only one client=
.
There is another client, but that uses a different/non-overlapping share.

> In general SMB3.1.1 is MUCH faster with reasonably current Ubuntu
> (make sure you have updated
> your Ubuntu to at least 5.4 although current Ubuntu AFAIK is 5.8 or
> 5.11 kernel now).   It is VERY
> important to use a kernel more recent than 5.3, not just because of
> the many bugfixes but also
> because of the addition of GCM (much faster) encryption for SMB3.1.1
> in 5.3 kernel.kernel:

As mentioned, our appliance is Ubuntu-based, but unfortunately it's
built on 18.04 LTS.
Currently we use a 4.15 version kernel, so can be considered old by now.

During our tests, we tried using CIFS version 3.1.1, but the mount did
not succeed.
In our tests CIFS version 3.02 was the latest one the mount succeeded with.
It may be that CIFS 3.1.1 support was missing from either the 4.15
Linux kernel, or
it may have not been present in the Windows 2012 Storage Edition, that
was providing the share.

> There are other parameters that can be helpful e.g. "nostrictsync" in
> some cases.

Okay, we'll make sure to try that one too.

> Also consider whether rsync is what you want to use - rsync picks an
> unfortunately small default I/O size and its
> maximum I/O size is also terrible - this is less of an issue if you
> are using the default caching (which goes
> through the Linux page cache so will aggregate I/O into larger chunks)
> but for a network FS you really want
> I/O 1MB or larger (SMB2+ will typically default to 4MB or 1MB I/O and
> even NFSv4+ will typically default to 1MB)

I guess we use the default caching, but I'll look into it.

> If you have the ability to try newer kernels (e.g. Ubuntu makes it
> very easy to download install packages to update
> to the more current 5.13 kernel from the Ubuntu website for testing on
> older Ubuntu) - give 5.13 a try and experiment
> with the new mount parm ("rasize") e.g. setting it to 8MB and see if that=
 helps.

Unfortunately doing that is not so easy in our case, but we may give
it some thought
to see whether and how it could be done.

> Another key thing to look at is whether there are reconnects being
> triggered (e.g. by bad app behavior - like we saw
> with scp sometimes sending signals accidentally killing the TCP
> network connection, or by timeouts on the server,
> or bugs that have been fixed in more recent kernels).   See the number
> of reconnects in /proc/fs/cifs/Stats and if
> it is increasing then focusing on whether that is a server bug, or a
> bug due to an older kernel on the client which
> is missing fixes can be useful.

Okay, the next time we do some testing, I will monitor that counter as well=
.

Thank you so much Steve for your help!

Best Regards,
J=C3=A1nos Szigetv=C3=A1ri
