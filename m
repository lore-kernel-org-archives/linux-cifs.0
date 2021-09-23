Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3894CC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 18:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DC23601FA
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 18:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242745AbhIWSWr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 14:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242746AbhIWSWp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 14:22:45 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA39C061574
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 11:21:13 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w11so4524478plz.13
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 11:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9ob8il3sRtB0EI7oiEUopUhSlFw8JQBlyLJrl6BInFM=;
        b=HRjK4Qx9mhlqFEzTjmanpRbSehH0JkVBu3hRLhbHZz727WBzyxGUZoZX274nPyswKZ
         8O6MWupe2Yppruq/Nc7SvEBtlS/VlvGz8DC3iIFmtnqelUbMrtpNG3LTHUC/jPZ/ne3A
         +nRH9XNTHn46Kzc5Ox8+E+ozUGqo2igsTEX/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9ob8il3sRtB0EI7oiEUopUhSlFw8JQBlyLJrl6BInFM=;
        b=ZsV+C0z99PS4l87prtFtWrqAoPIG9pxmsgU64PQ3XKI3fqE1wjI9D2dxmlVhrCeEs4
         XO5lKCxYbbre6cCk47SqgjXsNSwzya/7XRJvuNLQ5s0I6YTjOgtIewnlJBWjGnJgMGhT
         vyHuz7YbiNJQPZf5OYPYMvAtXzTsGEQsK6oWDHJFVwf4Ap4CDxJ2WPoB1mgUaeXDFttP
         w8u/XHu82rgqtdwCkUS4lF6EDV2ghvj/HEfHa62dwWYs0uISSAM4j5tWBH8cOpsLGlvj
         AKrH97C+gO/lvuR+P2c3/syPIdg1Jcb4sSTlNSDyid08Lr+C7bAE24imN7Kukeg9Qvk0
         2QKQ==
X-Gm-Message-State: AOAM532c7ErlJOGZo/KjdWzdL2V56LgYyftAW5UOLU7azT9uvCD+uFsU
        oHA3VHqy3oYdPC7TCzQ1GvB7was55qZdsQ==
X-Google-Smtp-Source: ABdhPJygSTaJiz/7Xf1f5dFn5nSbDvvYu1SpdmTUrC2Va/hxHGSHYbn4p/Kz12L8EwlttC6T4Kff7g==
X-Received: by 2002:a17:90b:4a0d:: with SMTP id kk13mr19503270pjb.215.1632421273292;
        Thu, 23 Sep 2021 11:21:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s89sm6117532pjj.43.2021.09.23.11.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 11:21:12 -0700 (PDT)
Date:   Thu, 23 Sep 2021 11:21:11 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [GIT PULL] ksmbd server security fixes
Message-ID: <202109231109.0AD3D5A@keescook>
References: <CAH2r5mvu5wTcgoR-EeXLcoZOvhEiMR0Lfmwt6gd1J1wvtTLDHA@mail.gmail.com>
 <202109221850.003A16EC1@keescook>
 <CAH2r5muNG4GvziyMG2unkYNjUiT4V+pz0pWUGkWQNxUZJnBadw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muNG4GvziyMG2unkYNjUiT4V+pz0pWUGkWQNxUZJnBadw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Sep 22, 2021 at 10:20:01PM -0500, Steve French wrote:
> After lots of discussion about areas to review - we created this wiki
> page to track some of the detailed security review ongoing:
> 
> https://wiki.samba.org/index.php/Ksmbd-review

Great!

> That (adding additional functional tests for smb3 overflows, and
> also it restarts a discussion about creating open source "smb3 fuzzing"
> tools to help Samba and ksmbd both) ... that is a discussion I have
> been having with others on the Samba team as well, some of
> the security bugs could have been found with additions
> to the "smbtorture" set of functional tests (which are hosted in the Samba
> server projects).

Yeah, I think this is really important, and especially for bug fixing:
if a bug gets fixed in protocol or filesystem handling, there needs to
be a test to go with it. Without that, no one can say with a straight
face that it is actually fixed. It's just a band-aid unless there is an
accompanying test that exercises the flaw to make sure the fix doesn't
regress in the future.

So, I think each of the recent fixes needs to have an associated test --
especially the path walking and buffer overflows.

Is there a "patch requirements" doc for doing reviews? I don't see
anything specific to the "on going" review process at the wiki. The wiki
just calls out a number of areas that need out-of-band examination
(which is great!) in the form of basically a detailed TODO list. But I
don't see an actual patch review process. Specifically, what things must
a patch author do before the maintainer will be happy to accept a patch?

> I am pleased with the progress that Namjae et al have been making
> addressing the problems identified, but agree it is not ready for production
> use yet, despite good functional test results - and testing events
> (like the SMB3
> plugfest next week) are going to be important, as well as the security reviews.
> Fortunately the code size is manageable (25KLOC), and without legacy,
> insecure dialects to worry about (SMB1, LANMAN etc.), unlike most servers,
> the reviews should proceed reasonably quickly.

Great! I'm glad to hear it. For those events do you build kernels will
full KASAN, KMSAN, KCSAN, etc enabled? There might be a lot of flaws
that wouldn't otherwise get noticed.

> There is some good news (relating to security), once Namjae et al get past
> these buffer overflow etc. patches.
> - he has already implemented the strongest encryption supported in SMB3.1.1
> - he has implemented the man in the middle attack prevention features
> of the protocol
> - strong (Kerberos) authentication is implemented

Sounds excellent -- have these received professional crypto review?
There are a lot of corner cases in crypto negotiation procotols.

> - he has removed support for weak older dialects (including SMB1 and
> SMB2) of the protocol
> - he will be removing support for weaker authentication (including NTLMv1)

Yay attack surface reduction! :)

> Any feedback you have on the security list identified in the wiki list
> above, or other
> things you see in Coverity or the mailing list discussions reviewing the patches
> would be helpful.

Thanks for making these recent changes; I feel much better about ksmbd's
direction. I'll take a look through the Wiki.

Thanks!

-Kees

-- 
Kees Cook
