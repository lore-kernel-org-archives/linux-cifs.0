Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3B2C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 16:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84EE06108D
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 16:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhHRQwi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 12:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhHRQwh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Aug 2021 12:52:37 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD5AC061764
        for <linux-cifs@vger.kernel.org>; Wed, 18 Aug 2021 09:52:02 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u22so5908911lfq.13
        for <linux-cifs@vger.kernel.org>; Wed, 18 Aug 2021 09:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O3Y3KGkU9uYEt8yInDYkUTKbM38pZsVc3yS9x48C7g8=;
        b=d2oyBSh36vqeZB+Jh0yRSJ+BSYH+eCo4+GSb8wp9AVzxhBXzb2InD/kqupi7YtnSjh
         Qr1OJZloLR07/wGckRoGm1KRwM/P+liPdmhda9hq4iv4HQVLSz14tPAeAdbpB6kGpgn/
         3n5WnWmcn7D9bNlU1iuQW8qgPZtMmdR52bwL+6ZmT/qqcSVV5vFIYQX/FLuzGuoc1BVz
         1GIb70tsU9hO9xl1dMpmRH8Di6c1LXFe1JrQ8SKMb7HfaJp8XiNsE8uwilDu6EItmLg/
         mau+rG8LfAzp/qatolzWEwAWk+S0RxajwegB4DR3dCOPXnZvKOmyOeO9RiPiaW8orlIb
         HTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O3Y3KGkU9uYEt8yInDYkUTKbM38pZsVc3yS9x48C7g8=;
        b=ECJsuwa9i0lMZKvijhjvMRxAB4AjLjDQw9tONDJu7LV7hBTK3zhxddnpncESOpp/xW
         eVA2yuOFa5lArdCvcYf4ZyehNQlvqd6t0vCFZJiug1tBaTcENuUk+cDuMFHzDGEbvgrV
         cShRoHFes8zsqNScsFjWsxEA+PjWUkxNzhfaLu4Mg5AgE0s5P8fAwdQzFZXEhAYkvEgf
         5UILxv2d/5uNTm2DvcfbanxyBARAxzy4/nijIur7LabgQO2HgG/T3MW/qgxko18hRU7n
         xQzO5DFYtL+YkESjB0n19/9yGy/KDIvqe4eRtQ4QeG28PhshYRFne/ovCZ5jDAmo7Vex
         toFQ==
X-Gm-Message-State: AOAM532x/C/BnBzq/7fR5GjhF8vz6qHu7grN7L3+toTIq3OMk0KEG52P
        0fOvgxEXykm1ovCbiGvuXcu05DlG2vVrJZ0M31g=
X-Google-Smtp-Source: ABdhPJzH/4a66wwJom7UUu1cCrnQvZKWOGORpRU5gUpock4T1uUNaFqJZKQflSgJcqcOewm16muwT/8OUVoMdXhNO9Q=
X-Received: by 2002:a19:c796:: with SMTP id x144mr6948397lff.395.1629305520860;
 Wed, 18 Aug 2021 09:52:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210818041021.1210797-1-lsahlber@redhat.com> <815daf08-7569-59ce-0318-dfe2b16e1d96@talpey.com>
 <CAN05THR_Y+uoER=iNiwoiZ0yPcJ2T-LvRqOew59G53SafUMg3g@mail.gmail.com>
In-Reply-To: <CAN05THR_Y+uoER=iNiwoiZ0yPcJ2T-LvRqOew59G53SafUMg3g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 18 Aug 2021 11:51:49 -0500
Message-ID: <CAH2r5mvj5w1NxkyH4XE6S6J0O7VFJ-XWB_Og_JsmA0M8i=AW2A@mail.gmail.com>
Subject: Re: Disable key exchange if ARC4 is not available
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 18, 2021 at 11:29 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Wed, Aug 18, 2021 at 11:18 PM Tom Talpey <tom@talpey.com> wrote:
> >
> > On 8/18/2021 12:10 AM, Ronnie Sahlberg wrote:
> > > Steve,
> > >
> > > We depend on ARC4 for generating the encrypted session key in key exchange.
> > > This patch disables the key exchange/encrypted session key for ntlmssp
> > > IF the kernel does not have any ARC4 support.
> > >
> > > This allows to build the cifs module even if ARC4 has been removed
> > > though with a weaker type of NTLMSSP support.
> >
> > It's a good goal but it seems wrong to downgrade the security
> > so silently. Wouldn't it be a better approach to select ARC4,
> > and thereby force the build to succeed or fail? Alternatively,
> > change the #ifndef ARC4 to a positive option named (for example)
> > DOWNGRADED_NTLMSSP or something equally foreboding?
>
> Good point.
> Maybe we should drop this patch and instead copy ARC4 into fs/cifs
> so we have a private version of the code in cifs.ko.
> And do the same for md4 and md5.


Yes ... and allow a build option where ARC4/MD4 are removed from the
build and NTLMSSP disabled,
forcing kerberos in the short term, and then we need to get working
ASAP on adding some choices in the future,
perhaps something similar to

https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/jj852232(v=ws.11)

where Windows allows plugging in additional auth mechanisms to SPNEGO
(and pick at least one new mechanism beyond
KRB5 to support in the kernel client ...)

-- 
Thanks,

Steve
