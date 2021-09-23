Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2997C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 03:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F2860F6B
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 03:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbhIWDVr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 23:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbhIWDVp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 23:21:45 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EC4C061574;
        Wed, 22 Sep 2021 20:20:14 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i25so20831051lfg.6;
        Wed, 22 Sep 2021 20:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EaUcazH2tLz6tC0pcoRniTceWE6LRO85tzRxEp+hFWk=;
        b=gaEEsquodOKjrBe9BDSyY7JXegNEkCAPjEMT57bCkf2kn/91hGZTMDwOj4Y6JTXDUa
         nd6sLvMyjVrhS47+duGktRRuf9DS9PBHZ9gvRXmK8Ev5Ib9LMMyqbftsxya/VUALCbP/
         dVtIBz5nlt5GMnxKbTnFaQ/N1PysAgydo1vUBGmgkNxC2sFfiuGTDwECqJ+WdyWxFuaB
         5oOo7HLia83Yru7PnLJqIKpYOGyhMPtcnLJ1NrfhOeQeu7gMbz6EyX8RdMKMI3dL0a/v
         UhMYJrWMd0e+AQ5hHnAmcCcXyb4W+7HoQmITL3xCbcp917JdDfo0Z8eTM8usWW8cHip3
         043g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EaUcazH2tLz6tC0pcoRniTceWE6LRO85tzRxEp+hFWk=;
        b=E6JGysdV5ClQT6yHd7MrlzebfQLU4Gxj9XBsakPG+8katN6qTXzjGCQ0xFNgXKEbow
         29eDmr4owEc0P0v8hpSMdH+0cuwfsS8M1Ts9ksWXxpeembAJ2F9TDrQw/2rF/1DET0ib
         SX7T5IvtE7AcCGiszmQBOalkGPhxiiBlhLlYgdYEYqnfEGtNKTq96wbXHZlPcbi5DhoH
         w7u/nDdo2rkUe6YIve64qmurH+JBoaE/9AyRhXKNHQN9kCb7kabxbv2OK7nD+rsDj+/1
         aV1yPGQSl1uJlEm5z/pfWSlt2cgk/nNasNuPTT/iLdFTbSwPVkToB7YzUwoAqWe7be9H
         akcw==
X-Gm-Message-State: AOAM533r5o1dPQVitTtF7pPETDyjWIgA7B91KKrz5vAU+osx9HvPmxk8
        J0UExRHuuCf6cXrYJB0/XRhHOsF0Wy8NLrN8CiZS2zAAuKM=
X-Google-Smtp-Source: ABdhPJx0Zv4taWuiuhUMJs1lxWE9YoY71IoJ7VVQpDYj4mHcMJWSr9qIX0S2KPyerwZ0QDtYgnzYFaBleB9iQSxsF34=
X-Received: by 2002:a05:6512:78:: with SMTP id i24mr2092465lfo.595.1632367213035;
 Wed, 22 Sep 2021 20:20:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvu5wTcgoR-EeXLcoZOvhEiMR0Lfmwt6gd1J1wvtTLDHA@mail.gmail.com>
 <202109221850.003A16EC1@keescook>
In-Reply-To: <202109221850.003A16EC1@keescook>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 22 Sep 2021 22:20:01 -0500
Message-ID: <CAH2r5muNG4GvziyMG2unkYNjUiT4V+pz0pWUGkWQNxUZJnBadw@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server security fixes
To:     Kees Cook <keescook@chromium.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Sep 22, 2021 at 9:47 PM Kees Cook <keescook@chromium.org> wrote:
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
> of surprised at some of the flaws being found here.

I was also surprised that a couple of these weren't found by smbtorture,
although to be fair it is more focused on functional testing of the protocol
(and is quite detailed).  Most of my analysis of the code had been
focused on functional coverage, and protocol features (and removing
older less secure
dialects, which he did).

After lots of discussion about areas to review - we created this wiki
page to track some of the detailed security review ongoing:

https://wiki.samba.org/index.php/Ksmbd-review

> I'm concerned about code quality here, and I think something needs to
> change about the review and testing processes.

Yes - we Namjae, Ronnie, Ralph and others have had multiple recent discussions
 about the review and testing process, and some useful improvements
have been suggested.
At a minimum it will include a review of each of the key security
areas, and additional
tests added (I added a few functional tests yesterday, but more need
to be added, perhaps
using some of Ronnie's libsmb2 libraries that we used to repro some of
the security problems).

> > Regression test results:
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/67
> > and
> > https://app.travis-ci.com/github/namjaejeon/ksmbd/builds/237919800
>
> Can you tell me more about these tests? I'm not immediately

There are basically two types of tests run:
- xfstests from Linux to Linux (usually from current mainline cifs.ko mounted
to current ksmbd). These are largely functional tests, more at an
application level
- smbtorture is the Samba functional test suite, and is largely at the
protocol level,
to show protocol correctness.  There are a few security/overflow
related tests in
this, but more need to be added.  The smbtorture runs are automated in github,
the xfstest runs are semi-automated, but I have to manually trigger them.

The builders for xfstest 'buildbot runs use a Fedora VM on the client,
that is spun
up with the standard Linux 'buildbot' testing infrastructure, then the
kernel is rebbuilt
and replaced and then the Fedora client VM rebooted to the current
kernel (in the
case of the run you are pointing it is was running 5.15-rc2 with one patch
applied (see below). The patch was added (from one posted on lkml)
to avoid the build break in current mainline Linux.

"HEAD is now at 1f07f2e... scripts/sorttable: riscv: fix undelcred
identifier 'EM_RISCV' error"

> I see xfstests and smbtorture getting run. Were these not catching
> things like "../../../../../" and the buffer overflows? And if not,
> where are the new tests that make sure these bugs can never recur?

That (adding additional functional tests for smb3 overflows, and
also it restarts a discussion about creating open source "smb3 fuzzing"
tools to help Samba and ksmbd both) ... that is a discussion I have
been having with others on the Samba team as well, some of
the security bugs could have been found with additions
to the "smbtorture" set of functional tests (which are hosted in the Samba
server projects).

> (Also, I see they're being run individually -- why not run the totality?)

You can't run the totality of xfstests (some are not applicable for
network fs e.g.) nor of smbtorture (some tests aren't applicable).

> And looking at the Coverity report[4] under fs/ksmbd/* for linux-next, I
> see 12 issues dating back to Mar 17, and 1 from 2 days ago: 5 concurrency,
> 4 memory corruptions, 1 hang, and 2 resource leaks. Coverity is hardly
> free from false positives, but those seems worth addressing. (Both you and
> Namjae have accounts already; thank you for doing that a few months back!)

I completely agree with the importance of Coverity as, even if the majority are
'false positives' or not high priority - there are plenty that
Coverity points out that are not.
I have focused more on Coverity for cifs.ko than for ksmbd, but after
the security patches
are merged, it would be good to switch gears to that.

> Anyway, I think my point is: this doesn't look ready for production use.
> I understand having bugs, growing new features, etc, but I think more
> work is needed here to really prove this code is ready to expose the

I am pleased with the progress that Namjae et al have been making
addressing the problems identified, but agree it is not ready for production
use yet, despite good functional test results - and testing events
(like the SMB3
plugfest next week) are going to be important, as well as the security reviews.
Fortunately the code size is manageable (25KLOC), and without legacy,
insecure dialects to worry about (SMB1, LANMAN etc.), unlike most servers,
the reviews should proceed reasonably quickly.

The current patch list which has been reviewed and tested so far (includes
fixes for some of the issues you mention) is:

ksmbd: add request buffer validation in smb2_set_info
743d886affeb ksmbd: remove follow symlinks support
3bee78ad0062 ksmbd: fix invalid request buffer access in compound request
18a015bccf9e ksmbd: check protocol id in ksmbd_verify_smb_message()
9f6323311c70 ksmbd: add default data stream name in FILE_STREAM_INFORMATION
e44fd5081c50 ksmbd: log that server is experimental at module load

But there at least five more under review and testing.  Namjae et al have been
very responsive.

Good news about these test events, which are held multiple times each year
for SMB, is that some of the companies participating in the past have run their
fuzzers against Samba (and now will be able to do the same against ksmbd).

There is some good news (relating to security), once Namjae et al get past
these buffer overflow etc. patches.
- he has already implemented the strongest encryption supported in SMB3.1.1
- he has implemented the man in the middle attack prevention features
of the protocol
- strong (Kerberos) authentication is implemented
- he has removed support for weak older dialects (including SMB1 and
SMB2) of the protocol
- he will be removing support for weaker authentication (including NTLMv1)

Any feedback you have on the security list identified in the wiki list
above, or other
things you see in Coverity or the mailing list discussions reviewing the patches
would be helpful.


-- 
Thanks,

Steve
