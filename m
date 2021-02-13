Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A4CC433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Feb 2021 01:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E2B764E95
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Feb 2021 01:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhBMB3j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Feb 2021 20:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhBMB3h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Feb 2021 20:29:37 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2911FC061574
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 17:28:57 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id z11so2050626lfb.9
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 17:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CiqXRmojC4JwBHhoVk4DYTWwIEbtC25jfG/VbdzJc2Y=;
        b=AVywlp9EKlBrA8lARvxt1258Gw3mHl0ZnHD9XiNJzUvYfdkbG+QmOVQLlbsKR61LjF
         sY1meUqr3pjxgqJuzwwqAjhmF30pGYmJAFlE9ANktxg9lxd24G8n9Z8uAsPu94c6CPFf
         eIiws2pR5nz43eMT/uYQnZ2lVgVYzWs6pmB24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CiqXRmojC4JwBHhoVk4DYTWwIEbtC25jfG/VbdzJc2Y=;
        b=bWeMkXRuPs9LppWIrg6zHadWRy741+U23XZjtqJpZQ5ERQ1HFxKwR3rn79AdM/bmZM
         sTX6AfF2I2tFiIVO7wI2xR1labqtwVozBC9HqQ1FrXAoETvDRHupKlmmT0j9iH2b5V3L
         BWrINyhUzbPH/O0B4Si4KFIDMSkt62IzrUoS1CqmAOHm1NrSzbf0/ZgQefWAT2qBnolm
         /kB7LuLq5LFMWAhhMdnWm0yxTFUeaVS1L/Qlr37Jjxu+TLhPYi/enevNZRYHPPIjDq86
         Q74YcwU/EkSYhdb42WgMJXvaw+k51tE7tR+TRgTB1MIvPC3Ypga0LJA0Gv23kBV2kbIA
         sYAw==
X-Gm-Message-State: AOAM531v/rd5559FdTWlRqEgAI9JRJluHBFLpPBYukZ8TBU1foZt2sZn
        qE9rMEa2xnMPpu2CMg6344wW9NhuRBgznQ==
X-Google-Smtp-Source: ABdhPJyCk2sM3QO/S5fiFGX9oPPGMQr4zOE9advNQ8s4X/OA4wjPIvmVaHRbFYr8QXtrm1tiHRDKaA==
X-Received: by 2002:ac2:4466:: with SMTP id y6mr336353lfl.384.1613179735271;
        Fri, 12 Feb 2021 17:28:55 -0800 (PST)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id q15sm504490lfm.285.2021.02.12.17.28.53
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 17:28:54 -0800 (PST)
Received: by mail-lf1-f49.google.com with SMTP id j19so2020651lfr.12
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 17:28:53 -0800 (PST)
X-Received: by 2002:a19:7f44:: with SMTP id a65mr2786768lfd.41.1613179733615;
 Fri, 12 Feb 2021 17:28:53 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
 <CAHk-=wja1Y8r5UKrmXcMFrS=VPkTPbkyK-vt8B9MBkEU4+-WLw@mail.gmail.com>
 <CAH2r5mtj+-xGDy-YN0JwSJAsgvB+HpQFCBi-zdTNXTRBY_Mteg@mail.gmail.com>
 <592ad76a-866e-f932-5a82-1af4a2ba4880@samba.org> <CAHk-=wh8n15NOcHkuxD=rXnMZCcsYD316JjRDdHUFwcFi8vq6g@mail.gmail.com>
 <cb3740c6-6413-8411-e141-798e9dadc6d1@samba.org>
In-Reply-To: <cb3740c6-6413-8411-e141-798e9dadc6d1@samba.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Feb 2021 17:28:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=whOXR8ha7Zjzn2UPM8Ka-X1VSY7R07Pv-Fxeb3iKjKK3A@mail.gmail.com>
Message-ID: <CAHk-=whOXR8ha7Zjzn2UPM8Ka-X1VSY7R07Pv-Fxeb3iKjKK3A@mail.gmail.com>
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

On Fri, Feb 12, 2021 at 5:08 PM Stefan Metzmacher <metze@samba.org> wrote:
>
> > Zen 2 seems to have fixed things (knock wood - it's certainly working
> > for me), But many people obviously never saw any issues with Zen 1
> > either.
>
> Do you know about the Zen3 status, I was thinking to replace the system
> by this one with AMD Ryzen 9 5950X:

I have heard nothing but good things about Zen3 so far (apart from
apparently people complaining about availability), but it's only been
out a few months, so obviously coverage is somewhat limited.

I wish AMD hadn't decimated their Linux team (several years ago), and
they definitely had some embarrassing issues early on with Zen (apart
from the Zen 1 stability issues, they've screwed up rdrand at least
three times, iirc). But I've yet to hear of any Zen 3 issues, and I
suspect I'll upgrade when Threadripper comes out (I've become quite
spoiled by the build speeds of my Threadripper 3970X - the only thing
I miss is the better 'perf' support from Intel PEBS).

Note that I'm not necessarily the person who would hear about any
issues first, though, so take the above with a pinch of salt.

       Linus
