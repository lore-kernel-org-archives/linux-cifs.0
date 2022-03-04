Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A44C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Mar 2022 05:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiCDFub (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Mar 2022 00:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiCDFub (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Mar 2022 00:50:31 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DBD5EDF1
        for <linux-cifs@vger.kernel.org>; Thu,  3 Mar 2022 21:49:43 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id bi12so2123568ejb.3
        for <linux-cifs@vger.kernel.org>; Thu, 03 Mar 2022 21:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fjW5q4EhTl9Ua9XZ8exe2N5HZm167BX78Qdq6vCxVxM=;
        b=lNNP3ChN/0KWoV698AvgviN9B8VhITOfUkEMZh3Tnxeurj1Hp1/R41pnLyn2lBf4PE
         2JtZYn0812ZUQEouGoCe8rf0XXYnWow+pSCh+aBif8oj2VJ9Q+zAj9M5fhPF28K2xK+/
         umOjf/0fhnFphi/NbBtS/G6yed0vH+d66EzRRz3hT8M6kKhUhJqZC0co3XWpKilveYHH
         WXT9MXify45AFGH/QYFuXegWw9eZkfPnbC2pHgr/GCKzvRr9/i5B1XWWrKVCnnbN2/JB
         bcAqTksEbozQFEaEfaYYBuRwgJVs15LR3JShtgmcZbLVYaIUfOW/eU4G7lswSGf84cSy
         t0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fjW5q4EhTl9Ua9XZ8exe2N5HZm167BX78Qdq6vCxVxM=;
        b=54jOYyor8ciQbydQYG7anhpm78Ldl8wRDFvUmSJeA5ZMizsbq+Thqx9P8j3FFvvFex
         +kAK+nhmw4MpJLesYCWHAs3by6sBErzC63imTatQS7IeAal3e1BbBJBJd/DQPC9sm20v
         yanfUbMPysLiG+9Y1tjU+WprgD7MmfzOJ8fnSYZeyS1UyX82YdZOtxVL3ZgBrQrtXret
         vVXMp6F/nxHjAKO3ci+5zzVbHPTvdDRKbH8p4OTRv9Se5L5rfNyKzSyputPA6gRcUGYj
         tcHpmnMzu0L8H5SgXOMkXpsNMwET+mtzGpMHTPXqkBSt2z16wDai65PgmKGqIOfIkEHw
         dSfQ==
X-Gm-Message-State: AOAM531ASPdmksZoPNjQ9KEZIN4yWIbuwfOIQFVKybPhu25PeoPKqW6Q
        Gcls0mtKr+l86cgymcuR0pkdcZux+ahSSBGAqNw=
X-Google-Smtp-Source: ABdhPJwLdJQAc950dfGTo/WnWLCdgdoUNyHQHiKUGSTB0XMN+m5OAu6OaPxXNGYvC9bH74xgmO3AkhFfkpoA5uFJbFM=
X-Received: by 2002:a17:906:3117:b0:6cd:f81b:e295 with SMTP id
 23-20020a170906311700b006cdf81be295mr28654660ejx.511.1646372981466; Thu, 03
 Mar 2022 21:49:41 -0800 (PST)
MIME-Version: 1.0
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
 <eae5c0cc-55d1-f8db-aba0-57cee7f10332@leemhuis.info> <CAH2r5msUiBuZ74_nPVyzn=k=g0ELpcMnoTm_z30zrMSxF4sn1A@mail.gmail.com>
 <CAFrh3J-oOR1FxPrpzKsQQvronyk9fhDSqD2CY5DNsYO5Lt0ydg@mail.gmail.com>
 <CAFrh3J-TOW4JG6QND0nz_9asiv2g0DzPmxR68BBB_an9yAQ+Vw@mail.gmail.com>
 <CAFrh3J83sUd3tQYHzssKoBb4uQXd3MXf9e=4jLsJ9aH7z2B3oA@mail.gmail.com>
 <CANT5p=qvrV5mrE8dN=RAmCBefGd4_3BzTfM7U98eqmZN2ZVjEg@mail.gmail.com> <CAFrh3J8xaEoLo56SmgTKd7gU_KZiyK2AqmrT_7VSM-Hxsyxwrw@mail.gmail.com>
In-Reply-To: <CAFrh3J8xaEoLo56SmgTKd7gU_KZiyK2AqmrT_7VSM-Hxsyxwrw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 4 Mar 2022 11:19:30 +0530
Message-ID: <CANT5p=p50RU4HY=Dbx0+HzorZ_W0gTmE6iCZbQf0RdF3ZcfRLw@mail.gmail.com>
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
To:     Satadru Pramanik <satadru@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        CIFS <linux-cifs@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Mar 2, 2022 at 8:16 PM Satadru Pramanik <satadru@gmail.com> wrote:
>
> Here is also the dmesg as promised. (After resuming from suspend/sleep
> this morning, when I again had the same issue.)
>
> On Wed, Mar 2, 2022 at 2:57 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > On Wed, Mar 2, 2022 at 3:51 AM Satadru Pramanik <satadru@gmail.com> wrote:
> > >
> > > I have put the trace.dat and other debug files here since I can not
> > > attach the files to a message to the list. (Apparently the trace.dat
> > > file is too large.)
> > >
> > > https://drive.google.com/drive/folders/1wEi968RbXxivXMMH8J7XUsHhrxu9OWDX?usp=sharing
> > >
> > > On Mon, Feb 28, 2022 at 11:12 PM Satadru Pramanik <satadru@gmail.com> wrote:
> > > >
> > > > The trace.dat file is attached, covering the period before suspend,
> > > > and through wake several hours later, when the mount no longer worked,
> > > > and showed the CIFS: VFS: cifs_tree_connect: could not find
> > > > superblock: -22 message, and through when I unmounted and remounted
> > > > the share, which then started working.
> > > >
> > > > On Mon, Feb 28, 2022 at 9:31 AM Satadru Pramanik <satadru@gmail.com> wrote:
> > > > >
> > > > > Here is the DebugData from before and after from the system with the
> > > > > failed mount.
> > > > > Both systems are now running 5.17-rc6.
> > > > >
> > > > > Working on the trace-cmd now.
> > > > >
> > > > > On Sun, Feb 27, 2022 at 9:37 PM Steve French <smfrench@gmail.com> wrote:
> > > > > >
> > > > > > I would like to see the output of:
> > > > > >
> > > > > > /proc/fs/cifs/DebugData before and after the failure if possible.
> > > > > >
> > > > > > In addition, there would be some value in seeing trace information
> > > > > > (e.g start tracing by
> > > > > > "trace-cmd record -e cifs" before the failure and then forward the
> > > > > > debug information displayed by "trace-cmd show" after the failure)
> > > > > >
> > > > > > On Sun, Feb 27, 2022 at 7:55 AM Thorsten Leemhuis
> > > > > > <regressions@leemhuis.info> wrote:
> > > > > > >
> > > > > > > [TLDR: I'm adding the regression report below to regzbot, the Linux
> > > > > > > kernel regression tracking bot; all text you find below is compiled from
> > > > > > > a few templates paragraphs you might have encountered already already
> > > > > > > from similar mails.]
> > > > > > >
> > > > > > > Hi, this is your Linux kernel regression tracker. Top-posting for once,
> > > > > > > to make this easily accessible to everyone.
> > > > > > >
> > > > > > > CCing the regression mailing list, as it should be in the loop for all
> > > > > > > regressions, as explained here:
> > > > > > > https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html
> > > > > > >
> > > > > > > To be sure below issue doesn't fall through the cracks unnoticed, I'm
> > > > > > > adding it to regzbot, my Linux kernel regression tracking bot:
> > > > > > >
> > > > > > > #regzbot ^introduced v5.16.11..v5.17-rc5
> > > > > > > #regzbot title cifs: Failure to access cifs mount of samba share after
> > > > > > > resume from sleep
> > > > > > > #regzbot ignore-activity
> > > > > > >
> > > > > > > Reminder for developers: when fixing the issue, please add a 'Link:'
> > > > > > > tags pointing to the report (the mail quoted above) using
> > > > > > > lore.kernel.org/r/, as explained in
> > > > > > > 'Documentation/process/submitting-patches.rst' and
> > > > > > > 'Documentation/process/5.Posting.rst'. This allows the bot to connect
> > > > > > > the report with any patches posted or committed to fix the issue; this
> > > > > > > again allows the bot to show the current status of regressions and
> > > > > > > automatically resolve the issue when the fix hits the right tree.
> > > > > > >
> > > > > > > I'm sending this to everyone that got the initial report, to make them
> > > > > > > aware of the tracking. I also hope that messages like this motivate
> > > > > > > people to directly get at least the regression mailing list and ideally
> > > > > > > even regzbot involved when dealing with regressions, as messages like
> > > > > > > this wouldn't be needed then. And don't worry, if I need to send other
> > > > > > > mails regarding this regression only relevant for regzbot I'll send them
> > > > > > > to the regressions lists only (with a tag in the subject so people can
> > > > > > > filter them away). With a bit of luck no such messages will be needed
> > > > > > > anyway.
> > > > > > >
> > > > > > > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> > > > > > >
> > > > > > > P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> > > > > > > reports on my table. I can only look briefly into most of them and lack
> > > > > > > knowledge about most of the areas they concern. I thus unfortunately
> > > > > > > will sometimes get things wrong or miss something important. I hope
> > > > > > > that's not the case here; if you think it is, don't hesitate to tell me
> > > > > > > in a public reply, it's in everyone's interest to set the public record
> > > > > > > straight.
> > > > > > >
> > > > > > >
> > > > > > > On 27.02.22 03:36, Satadru Pramanik wrote:
> > > > > > > > I'm on a x86_64 ubuntu 22.04 system accessing a similar system running
> > > > > > > > samba Version 4.13.14-Ubuntu. Both systems are on ubuntu mainline
> > > > > > > > kernel 5.17-rc5.
> > > > > > > >
> > > > > > > > I have a samba share mounted from my fstab, and file access works fine.
> > > > > > > > Upon suspending my system and resuming though, the mounted samba share
> > > > > > > > is inaccessible, and my dmesg has many "CIFS: VFS: cifs_tree_connect:
> > > > > > > > could not find superblock: -22" messages.
> > > > > > > >
> > > > > > > > Unmounting and remounting the share restores access.
> > > > > > > >
> > > > > > > > When I boot into kernel 5.16.11, I do not have this issue. The cifs
> > > > > > > > share is accessible just fine after a suspend/resume cycle.
> > > > > > > >
> > > > > > > > I assume this is a regression with 5.17? Is there any information
> > > > > > > > worth providing which might help debug and fix this issue?
> > > > > > > >
> > > > > > > > Regards,
> > > > > > > >
> > > > > > > > Satadru Pramanik
> > > > > > >
> > > > > > > --
> > > > > > > Additional information about regzbot:
> > > > > > >
> > > > > > > If you want to know more about regzbot, check out its web-interface, the
> > > > > > > getting start guide, and the references documentation:
> > > > > > >
> > > > > > > https://linux-regtracking.leemhuis.info/regzbot/
> > > > > > > https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
> > > > > > > https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md
> > > > > > >
> > > > > > > The last two documents will explain how you can interact with regzbot
> > > > > > > yourself if your want to.
> > > > > > >
> > > > > > > Hint for reporters: when reporting a regression it's in your interest to
> > > > > > > CC the regression list and tell regzbot about the issue, as that ensures
> > > > > > > the regression makes it onto the radar of the Linux kernel's regression
> > > > > > > tracker -- that's in your interest, as it ensures your report won't fall
> > > > > > > through the cracks unnoticed.
> > > > > > >
> > > > > > > Hint for developers: you normally don't need to care about regzbot once
> > > > > > > it's involved. Fix the issue as you normally would, just remember to
> > > > > > > include 'Link:' tag in the patch descriptions pointing to all reports
> > > > > > > about the issue. This has been expected from developers even before
> > > > > > > regzbot showed up for reasons explained in
> > > > > > > 'Documentation/process/submitting-patches.rst' and
> > > > > > > 'Documentation/process/5.Posting.rst'.
> > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Thanks,
> > > > > >
> > > > > > Steve
> >
> > The DebugData shows that the connection and smb session are fine, but
> > the tree connect is not in a good state.
> > Similarly, the trace output shows that connection was reconnected
> > successfully, SMB session was reconnected as well. However, the tree
> > connect did not go over the wire.
> >
> > > The trace.dat file is attached, covering the period before suspend,
> > > and through wake several hours later, when the mount no longer worked,
> > > and showed the CIFS: VFS: cifs_tree_connect: could not find
> > > superblock: -22 message, and through when I unmounted and remounted
> > > the share, which then started working.
> >
> > This suggests to me that the cifs_tcp_get_super is failing.
> > This is odd, since it looks up the server as pointers.
> > Did we start undercounting the ref count somewhere?
> >
> > --
> > Regards,
> > Shyam

Hi Satadru,

The attached dmesg did not have cifsFYI enabled.
Please use the below steps to enable cifsFYI before the sleep:
# echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
# echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
# echo 7 > /proc/fs/cifs/cifsFYI

You can disable it after the repro using this cmd:
# echo 0 > /proc/fs/cifs/cifsFYI

-- 
Regards,
Shyam
