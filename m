Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A93C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 21:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbiCAVRy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 16:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235470AbiCAVRx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 16:17:53 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2728260A9C
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 13:17:11 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id s25so23590249lji.5
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 13:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=16ZNhJ1BQ4Dh3yBBuWi2O3KgukvlyFUrp3KmRTBFO+E=;
        b=SYQHevikLBA4kamGd2lyFUvor7Y1EJiH9YVEeRdWQJhRi8nTLFTBxKA86OgWcX50eK
         EcZCVJEoUE+K89kPEWaYjM5tQfLLpQk5c6AMiKBMTGpobq7a89DY4juD1lLiJbyEw8Dt
         rtfUu4vdB5StzyRx5q2TdZkSz+pE9mIdKo9XE/ujwGyxyUJ1DsQPgFxGXUoJCLHfkOr9
         P7s0+YWKQGIayKJw5OgEflxrT0So9fYMmhk0T+Pl8xZOpeyzuz0H2pjxVVSkvpRNPw4S
         62pKLtYA7Iy/LX9blTfhnHp0mxSYJ3SuTk+CwQuoBc3xkp1jczRRvafxKGLCVDZrED2a
         56ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=16ZNhJ1BQ4Dh3yBBuWi2O3KgukvlyFUrp3KmRTBFO+E=;
        b=wUzzKvMnyGL8AJ1ZfN4QUwAvLECugz16QFNAJYeSqWa5Rwv+5E+5eTVEPsLOJkc9GK
         VeS99YMI5A7Fn0YOelg8FRVWGBSFURQ9nrVHQJwj5JV2zsUyi4IYO/oummrdCwAQ52g6
         8IWmMvbLofZNno//lXQY0WLGszLOsSm89/2OUrwxnZxZWJzm2r5z4YzeB9+ffrGM0sEa
         rsi8lGGDj8pztWjDBV2LWB24Lx1Xs8R4BWtBsZfk1P52fHOe0LyuQtmef+CRl1rHy06I
         t0c9rNoDhWROJ21YVBhKfoKUF0W+1xeb8Mmo/3jO3OcN2QmC3qOG8x/oUpAdzK/PRVJO
         D3kQ==
X-Gm-Message-State: AOAM530ePmcFjNgAog3uaCVw8NFY1bl5reuTJpUrblKZzMk24u9UJsfy
        wqTaEjQV12WRHKAxZgT4mYMhGGWu9rJ0NTz373f62a7KG4hSJQ==
X-Google-Smtp-Source: ABdhPJwTBF7NQJHaPnCRkHxRZae+rdwwh1LyYO7a/yO8OYX2O9Oz2ngXJaGow8TtNMxxmAh0gFdj7Bm+60RPlYqSOmQ=
X-Received: by 2002:a05:651c:12c5:b0:23e:1f55:35b4 with SMTP id
 5-20020a05651c12c500b0023e1f5535b4mr17904306lje.58.1646169428651; Tue, 01 Mar
 2022 13:17:08 -0800 (PST)
MIME-Version: 1.0
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
 <eae5c0cc-55d1-f8db-aba0-57cee7f10332@leemhuis.info> <CAH2r5msUiBuZ74_nPVyzn=k=g0ELpcMnoTm_z30zrMSxF4sn1A@mail.gmail.com>
 <CAFrh3J-oOR1FxPrpzKsQQvronyk9fhDSqD2CY5DNsYO5Lt0ydg@mail.gmail.com> <CAFrh3J-TOW4JG6QND0nz_9asiv2g0DzPmxR68BBB_an9yAQ+Vw@mail.gmail.com>
In-Reply-To: <CAFrh3J-TOW4JG6QND0nz_9asiv2g0DzPmxR68BBB_an9yAQ+Vw@mail.gmail.com>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Tue, 1 Mar 2022 16:16:57 -0500
Message-ID: <CAFrh3J83sUd3tQYHzssKoBb4uQXd3MXf9e=4jLsJ9aH7z2B3oA@mail.gmail.com>
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
To:     Steve French <smfrench@gmail.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        CIFS <linux-cifs@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I have put the trace.dat and other debug files here since I can not
attach the files to a message to the list. (Apparently the trace.dat
file is too large.)

https://drive.google.com/drive/folders/1wEi968RbXxivXMMH8J7XUsHhrxu9OWDX?usp=sharing

On Mon, Feb 28, 2022 at 11:12 PM Satadru Pramanik <satadru@gmail.com> wrote:
>
> The trace.dat file is attached, covering the period before suspend,
> and through wake several hours later, when the mount no longer worked,
> and showed the CIFS: VFS: cifs_tree_connect: could not find
> superblock: -22 message, and through when I unmounted and remounted
> the share, which then started working.
>
> On Mon, Feb 28, 2022 at 9:31 AM Satadru Pramanik <satadru@gmail.com> wrote:
> >
> > Here is the DebugData from before and after from the system with the
> > failed mount.
> > Both systems are now running 5.17-rc6.
> >
> > Working on the trace-cmd now.
> >
> > On Sun, Feb 27, 2022 at 9:37 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > I would like to see the output of:
> > >
> > > /proc/fs/cifs/DebugData before and after the failure if possible.
> > >
> > > In addition, there would be some value in seeing trace information
> > > (e.g start tracing by
> > > "trace-cmd record -e cifs" before the failure and then forward the
> > > debug information displayed by "trace-cmd show" after the failure)
> > >
> > > On Sun, Feb 27, 2022 at 7:55 AM Thorsten Leemhuis
> > > <regressions@leemhuis.info> wrote:
> > > >
> > > > [TLDR: I'm adding the regression report below to regzbot, the Linux
> > > > kernel regression tracking bot; all text you find below is compiled from
> > > > a few templates paragraphs you might have encountered already already
> > > > from similar mails.]
> > > >
> > > > Hi, this is your Linux kernel regression tracker. Top-posting for once,
> > > > to make this easily accessible to everyone.
> > > >
> > > > CCing the regression mailing list, as it should be in the loop for all
> > > > regressions, as explained here:
> > > > https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html
> > > >
> > > > To be sure below issue doesn't fall through the cracks unnoticed, I'm
> > > > adding it to regzbot, my Linux kernel regression tracking bot:
> > > >
> > > > #regzbot ^introduced v5.16.11..v5.17-rc5
> > > > #regzbot title cifs: Failure to access cifs mount of samba share after
> > > > resume from sleep
> > > > #regzbot ignore-activity
> > > >
> > > > Reminder for developers: when fixing the issue, please add a 'Link:'
> > > > tags pointing to the report (the mail quoted above) using
> > > > lore.kernel.org/r/, as explained in
> > > > 'Documentation/process/submitting-patches.rst' and
> > > > 'Documentation/process/5.Posting.rst'. This allows the bot to connect
> > > > the report with any patches posted or committed to fix the issue; this
> > > > again allows the bot to show the current status of regressions and
> > > > automatically resolve the issue when the fix hits the right tree.
> > > >
> > > > I'm sending this to everyone that got the initial report, to make them
> > > > aware of the tracking. I also hope that messages like this motivate
> > > > people to directly get at least the regression mailing list and ideally
> > > > even regzbot involved when dealing with regressions, as messages like
> > > > this wouldn't be needed then. And don't worry, if I need to send other
> > > > mails regarding this regression only relevant for regzbot I'll send them
> > > > to the regressions lists only (with a tag in the subject so people can
> > > > filter them away). With a bit of luck no such messages will be needed
> > > > anyway.
> > > >
> > > > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> > > >
> > > > P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> > > > reports on my table. I can only look briefly into most of them and lack
> > > > knowledge about most of the areas they concern. I thus unfortunately
> > > > will sometimes get things wrong or miss something important. I hope
> > > > that's not the case here; if you think it is, don't hesitate to tell me
> > > > in a public reply, it's in everyone's interest to set the public record
> > > > straight.
> > > >
> > > >
> > > > On 27.02.22 03:36, Satadru Pramanik wrote:
> > > > > I'm on a x86_64 ubuntu 22.04 system accessing a similar system running
> > > > > samba Version 4.13.14-Ubuntu. Both systems are on ubuntu mainline
> > > > > kernel 5.17-rc5.
> > > > >
> > > > > I have a samba share mounted from my fstab, and file access works fine.
> > > > > Upon suspending my system and resuming though, the mounted samba share
> > > > > is inaccessible, and my dmesg has many "CIFS: VFS: cifs_tree_connect:
> > > > > could not find superblock: -22" messages.
> > > > >
> > > > > Unmounting and remounting the share restores access.
> > > > >
> > > > > When I boot into kernel 5.16.11, I do not have this issue. The cifs
> > > > > share is accessible just fine after a suspend/resume cycle.
> > > > >
> > > > > I assume this is a regression with 5.17? Is there any information
> > > > > worth providing which might help debug and fix this issue?
> > > > >
> > > > > Regards,
> > > > >
> > > > > Satadru Pramanik
> > > >
> > > > --
> > > > Additional information about regzbot:
> > > >
> > > > If you want to know more about regzbot, check out its web-interface, the
> > > > getting start guide, and the references documentation:
> > > >
> > > > https://linux-regtracking.leemhuis.info/regzbot/
> > > > https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
> > > > https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md
> > > >
> > > > The last two documents will explain how you can interact with regzbot
> > > > yourself if your want to.
> > > >
> > > > Hint for reporters: when reporting a regression it's in your interest to
> > > > CC the regression list and tell regzbot about the issue, as that ensures
> > > > the regression makes it onto the radar of the Linux kernel's regression
> > > > tracker -- that's in your interest, as it ensures your report won't fall
> > > > through the cracks unnoticed.
> > > >
> > > > Hint for developers: you normally don't need to care about regzbot once
> > > > it's involved. Fix the issue as you normally would, just remember to
> > > > include 'Link:' tag in the patch descriptions pointing to all reports
> > > > about the issue. This has been expected from developers even before
> > > > regzbot showed up for reasons explained in
> > > > 'Documentation/process/submitting-patches.rst' and
> > > > 'Documentation/process/5.Posting.rst'.
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
