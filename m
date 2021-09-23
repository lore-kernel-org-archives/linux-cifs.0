Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57539C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 11:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3978E61164
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 11:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240498AbhIWLPN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 07:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240585AbhIWLPN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 07:15:13 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3778C061574;
        Thu, 23 Sep 2021 04:13:41 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id c22so21901284edn.12;
        Thu, 23 Sep 2021 04:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2YROe/l9i87aFktTShE/cGYLVd3ZGJJJdLJu/J3xLPM=;
        b=mQCRwAD5e+FmFW6mCbmhRtPfheWErMjvw2Oo1JrYUx7ICR2qgJx4GEOy1r31myAnLa
         4p99mVXnpN6hWUUuW9GOTUIA/QWR4uwDMV4tiZHLX6Hx7YuSgO90m3hr6M6aP95YQZvz
         Cng3Tvlw6nt2hrfj2tzFaKFAQPG8zTDiETC8Bx2HY1a3TQPtelVw5vRl213Zgz02Gc43
         n9p9WuAGxRxBVkeqToWyTAHZVQDzQHZxTVDD435QVIuVkY6n1sJ+4xeivQyD2EO9RkwG
         M5tW1xzOwQe4bNr2MdqRuJIQvpF+cxP4zRpPdvas/VL9zrL6JVMIE/dVi1cL4vteRQG5
         VYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2YROe/l9i87aFktTShE/cGYLVd3ZGJJJdLJu/J3xLPM=;
        b=rdwdRKhz8XHQ8wvNULp8hye+xrROY6Sn8/iE8Ig79YYaqO9ufEm1TeyXQw8B6IR8PM
         gwyTjDaurMuyQf9hVboKFQ3IcRIHajMP59PsiCil1CE3k84A5rzaFcprCqQn4O39tk5W
         uscS1ta7dSWPTPzW8mFhEFzSGNsYuKnN4hdn1t/HLva193sobpKSSp6iT1vFv/RIMKs5
         RCz/vhV314aUqpibMXKa9cdjSovp+JiBe7z/5AbzEk+tXNB6DcQS5ndOmZsawuMRLThZ
         zfopffmbj5QcuJ3LEEzLZX1XYiABlJ4pkKLgeBT6slo67aeNVwg+0fejnGvpg/6xSak8
         zfmg==
X-Gm-Message-State: AOAM531qO3kVQA35XLfEd21ZExcbunDJ8l7/bUeUTLh45WCSQsoErf2c
        pxAdu2w0ZJUBFA/mkZgtfg8PFFzo3NMrLpOsC7g=
X-Google-Smtp-Source: ABdhPJxIn01DQZ/5fhkJ4ei7DPdz93L1LP3E3hOiKHj+98hCcwLqqPClDpFToG1jp5foSxpF7PRJCuJYwmRpKhC35h4=
X-Received: by 2002:a17:906:aeda:: with SMTP id me26mr4344981ejb.83.1632395620227;
 Thu, 23 Sep 2021 04:13:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvu5wTcgoR-EeXLcoZOvhEiMR0Lfmwt6gd1J1wvtTLDHA@mail.gmail.com>
 <202109221850.003A16EC1@keescook>
In-Reply-To: <202109221850.003A16EC1@keescook>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 23 Sep 2021 21:13:28 +1000
Message-ID: <CAN05THQ6xT0dWyev+c-PhJ+LZ6ABNpCxCzBK7PQHJM_yaE+wWQ@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server security fixes
To:     Kees Cook <keescook@chromium.org>
Cc:     Steve French <smfrench@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 23, 2021 at 12:48 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Sun, Sep 19, 2021 at 09:22:31AM -0500, Steve French wrote:
> > 3 ksmbd fixes: including an important security fix for path
> > processing, and a missing buffer overflow check, and a trivial fix for
> > incorrect header inclusion
> >
> > There are three additional patches (and also a patch to improve
> > symlink checks) for other buffer overflow cases that are being
> > reviewed and tested.
>
> Hi Steve,
>
> I was looking through the history[1] of the ksmbd work, and I'm kind
> of surprised at some of the flaws being found here. This looks like new
> code being written, too, I think (I found[0])? Some of these flaws are
> pretty foundational filesystem security properties[2] that weren't being
> tested for, besides the upsetting case of having buffer overflows[3]
> in an in-kernel filesystem server.
>
> I'm concerned about code quality here, and I think something needs to
> change about the review and testing processes.
>
> > Regression test results:
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/67
> > and
> > https://app.travis-ci.com/github/namjaejeon/ksmbd/builds/237919800
>
> Can you tell me more about these tests? I'm not immediately filled with
> confidence, when I see on the second line of the test harness:
>
> - wget --no-check-certificate https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.4.109.tar.gz
>        ^^^^^^^^^^^^^^^^^^^^^^
>
> (and why isn't this a sparse clone?)
>
> I see xfstests and smbtorture getting run. Were these not catching
> things like "../../../../../" and the buffer overflows? And if not,
> where are the new tests that make sure these bugs can never recur?
>
> (Also, I see they're being run individually -- why not run the totality?)

I can answer this

I set it up this way to unload and reload the module for each test because at
the time the module was in really bad shape and doing these reset to known state
would make it easier to find easily reproducible faults from running
test xyz than chasing
shadows when previous test abc or def had left residuals that caused an oops.

I.e. Find oopses and failures that are contained in a single test.

It should be possible to skip the unload/reload cycle for each test
now as the module
is a lot more stable.

>
> And looking at the Coverity report[4] under fs/ksmbd/* for linux-next, I
> see 12 issues dating back to Mar 17, and 1 from 2 days ago: 5 concurrency,
> 4 memory corruptions, 1 hang, and 2 resource leaks. Coverity is hardly
> free from false positives, but those seems worth addressing. (Both you and
> Namjae have accounts already; thank you for doing that a few months back!)
>
> Anyway, I think my point is: this doesn't look ready for production use.
> I understand having bugs, growing new features, etc, but I think more
> work is needed here to really prove this code is ready to expose the
> kernel to SMB protocol based attacks. Any binary parsing code needs to be
> extremely paranoid, and a network file server gets it coming and going:
> filesystem metadata and protocol handling (and crypto)! :P
>
> Anyway, I hope something can change here; if we're going to have an
> in-kernel SMB server, it should have a distinct advantage over userspace
> options.
>
> -Kees
>
> [0] https://lore.kernel.org/lkml/20210322051344.1706-1-namjae.jeon@samsung.com/
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/log/fs/ksmbd
> [2] https://git.kernel.org/linus/f58eae6c5fa882d6d0a6b7587a099602a59d57b5
> [3] https://git.kernel.org/linus/6d56262c3d224699b29b9bb6b4ace8bab7d692c2
> [4] https://scan.coverity.com/projects/linux-next-weekly-scan
>     View Defects, Settings cog, Filters, File: *ksmbd*, OK
>
> --
> Kees Cook
