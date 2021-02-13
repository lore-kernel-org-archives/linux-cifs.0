Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86F4C433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Feb 2021 01:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB2164E05
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Feb 2021 01:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhBMBDe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Feb 2021 20:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhBMBDd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Feb 2021 20:03:33 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E140C061574
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 17:02:53 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id c17so142700ljn.0
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 17:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ug7HArqGmF1vWBXzbZZtTb4cswmqCb7RnJ5VpB42MFk=;
        b=CzASO3uZRA9mULKSb2Xk4vctqLx9m57xjZ/1jQnWrTk2/27hzIlTZfMQwR3I5PEdes
         aE8oyFOhfvB80kSaMpp9Yb5ARtlz8x5M2QRJI44mcuQmFnA8X4SbFxEFLcX029G6OFJ+
         LcCvdR9L9FxvZ/Tw5v2D2uOlo/jgRmT3ciroA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ug7HArqGmF1vWBXzbZZtTb4cswmqCb7RnJ5VpB42MFk=;
        b=PoZkr7/ELEVQLxvA+IFs1azZQguTHSrK+pVlFJWGU4eqlm0W2n5BBSwQPEmKh3NEOp
         oQqZveBh+d0WjNsrBJUPsOQrjBmm4xnR60G9WFsDMMhemCJUzEfhtSn1yPQvfFUsPjyf
         GIbwYXlMMpZ3XkuoOPIKZLXtu+8x5/QcbQzbwzPMUsLP2bV7njzhbniUQCeUIwx/i22+
         k6utCPAIcPUzIkz2QpYpuN2KwfMer55o1UE989NvogftD8ndYycQrwr9jVSSxqWoaGRo
         3ZBeHvevtSg6mnt704YJtQ1qnwZgGU2x1TwK+oPLuz4L5hfjGa2ZOqelqBDlc5rxf/aC
         vsFQ==
X-Gm-Message-State: AOAM5317E1vnu3hbBz3BBIdwDFqaTbRoAc9yX5B88SJc0xff+LjAwDC6
        VLCYRi0Yso+bBr0UUMCOdbjeumFaPXjQCA==
X-Google-Smtp-Source: ABdhPJxwZtYQZCrHsaWLS2pxYOwV93lSQhKK69UdSXYfEHoYHa6+6E+CYgW53qhtOo9iiyhrd5+atQ==
X-Received: by 2002:a2e:b8d5:: with SMTP id s21mr3192927ljp.408.1613178171694;
        Fri, 12 Feb 2021 17:02:51 -0800 (PST)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id e10sm1887882ljn.79.2021.02.12.17.02.50
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 17:02:50 -0800 (PST)
Received: by mail-lf1-f49.google.com with SMTP id f1so2064367lfu.3
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 17:02:50 -0800 (PST)
X-Received: by 2002:a05:6512:2287:: with SMTP id f7mr2767877lfu.40.1613178170443;
 Fri, 12 Feb 2021 17:02:50 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
 <CAHk-=wja1Y8r5UKrmXcMFrS=VPkTPbkyK-vt8B9MBkEU4+-WLw@mail.gmail.com>
 <CAH2r5mtj+-xGDy-YN0JwSJAsgvB+HpQFCBi-zdTNXTRBY_Mteg@mail.gmail.com> <592ad76a-866e-f932-5a82-1af4a2ba4880@samba.org>
In-Reply-To: <592ad76a-866e-f932-5a82-1af4a2ba4880@samba.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Feb 2021 17:02:34 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh8n15NOcHkuxD=rXnMZCcsYD316JjRDdHUFwcFi8vq6g@mail.gmail.com>
Message-ID: <CAHk-=wh8n15NOcHkuxD=rXnMZCcsYD316JjRDdHUFwcFi8vq6g@mail.gmail.com>
Subject: Re: [GIT PULL] cifs fixes
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?B?QmrDtnJuIEpBQ0tF?= <bjacke@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Feb 12, 2021 at 4:26 PM Stefan Metzmacher <metze@samba.org> wrote:
>
> The machine is running a 'AMD Ryzen Threadripper 2950X 16-Core Processor'
> and is freezing without any trace every view days.

I don't think the first-gen Zen issues ever really got solved. There
were multiple ones, with random segfaults for the early ones (but
afaik those were fixed by an RMA process with AMD), but the "it
randomly locks up" ones never had a satisfactory resolution afaik.

There were lots of random workarounds, but judging by your email:

> We played with various boot parameters (currently we're using
> 'mem_encrypt=off rcu_nocbs=0-31 processor.max_cstate=1 idle=nomwait nomodeset consoleblank=0',

I suspect you've seen all the bugzilla threads on this issue (kernel
bugzilla 196683 is probably the main one, but it was discussed
elsewhere too).

I assume you've updated to latest BIOS and looked at various BIOS
power management settings too?

Zen 2 seems to have fixed things (knock wood - it's certainly working
for me), But many people obviously never saw any issues with Zen 1
either.

           Linus
