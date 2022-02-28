Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0942C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Feb 2022 02:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiB1Chw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiB1Chv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 27 Feb 2022 21:37:51 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889E66C91C
        for <linux-cifs@vger.kernel.org>; Sun, 27 Feb 2022 18:37:13 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id t14so15386056ljh.8
        for <linux-cifs@vger.kernel.org>; Sun, 27 Feb 2022 18:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ob3GDnxv9BI+m8mH7EQ3OIL8NRbXgnB9x++oQzEgJ40=;
        b=L/tF6gqEPZmweG1DqdYI/OSl5aIBRFCt5ZIVRYRosqWXSgDaYI2PSkrYC7wT6cIRU3
         G0vYlT4LXrV+IFgin1/25pbLJzMVQLDQXyJcUtmKIBDvUVotsSfJlcM3qGd2uqKWK3WZ
         LlkylEA7w+3PGcyrmdjNUboxUoC08LHeUqgOeh5SA1A+KyJL4OmlX+NHY8gl4i9pHlPV
         GPYGKNELC7LM3KoiWGjG7OZ8bdBhRnJBpMPHHPl4ysvFI2Ckcn9TmidZVSKMtCTK6v6l
         Qh34nZgbXxi6vZfqrNtzNz+p/3R8SZmFU9DVbMjsLATSirmFOwcMC9Guug3Cd6yabupf
         Fxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ob3GDnxv9BI+m8mH7EQ3OIL8NRbXgnB9x++oQzEgJ40=;
        b=e0lfxrxEmnO7/SAFLhs39h6iWAiaoynk+76jo6L6MHbJzHwzCmSPXPSRoTWN1uXkas
         WrlQLUSA5YV1dqLRnKv9KEs3BXJuY1piVdCptFiZ28+ogROd4vs5tUVbjkugsCtOZ7/v
         VLIUk1KcX40gUVmaFcTzqIfKciXvuHXBDH17u4s6kdhH48qxRVkeY7qqezMisHFtNyCI
         paky1yB0p0t/LX/xtRYeq01SePILXKpoGMSwD7Z7MvKiI560t8vqYiYjBOdrsNAWXKqw
         PUAYp9780JC32dBEcYcEl+R6+9MBUhtDFtSyT4MlGfFEagADHTR1WsE965+Q5uNjBG5e
         L4aQ==
X-Gm-Message-State: AOAM533GIs4sHrgucRRiCTYycY2JESDbGa+YgzDBFyxP3QqmJXJS0m/0
        2URt8s6cP41PP2dW1uieMtwYS4b3tPhX/anbh+s=
X-Google-Smtp-Source: ABdhPJyzVvI3fvpgOD0SJ03iWrScXDCudjbSnv61oy+N2uj4yaKknGR3VXdKhzv/RxVgAGrChN1dSHfqvHkLL9bSeJo=
X-Received: by 2002:a2e:b014:0:b0:23c:9593:f7 with SMTP id y20-20020a2eb014000000b0023c959300f7mr12658935ljk.209.1646015831388;
 Sun, 27 Feb 2022 18:37:11 -0800 (PST)
MIME-Version: 1.0
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
 <eae5c0cc-55d1-f8db-aba0-57cee7f10332@leemhuis.info>
In-Reply-To: <eae5c0cc-55d1-f8db-aba0-57cee7f10332@leemhuis.info>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 27 Feb 2022 20:37:00 -0600
Message-ID: <CAH2r5msUiBuZ74_nPVyzn=k=g0ELpcMnoTm_z30zrMSxF4sn1A@mail.gmail.com>
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Satadru Pramanik <satadru@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I would like to see the output of:

/proc/fs/cifs/DebugData before and after the failure if possible.

In addition, there would be some value in seeing trace information
(e.g start tracing by
"trace-cmd record -e cifs" before the failure and then forward the
debug information displayed by "trace-cmd show" after the failure)

On Sun, Feb 27, 2022 at 7:55 AM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> [TLDR: I'm adding the regression report below to regzbot, the Linux
> kernel regression tracking bot; all text you find below is compiled from
> a few templates paragraphs you might have encountered already already
> from similar mails.]
>
> Hi, this is your Linux kernel regression tracker. Top-posting for once,
> to make this easily accessible to everyone.
>
> CCing the regression mailing list, as it should be in the loop for all
> regressions, as explained here:
> https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html
>
> To be sure below issue doesn't fall through the cracks unnoticed, I'm
> adding it to regzbot, my Linux kernel regression tracking bot:
>
> #regzbot ^introduced v5.16.11..v5.17-rc5
> #regzbot title cifs: Failure to access cifs mount of samba share after
> resume from sleep
> #regzbot ignore-activity
>
> Reminder for developers: when fixing the issue, please add a 'Link:'
> tags pointing to the report (the mail quoted above) using
> lore.kernel.org/r/, as explained in
> 'Documentation/process/submitting-patches.rst' and
> 'Documentation/process/5.Posting.rst'. This allows the bot to connect
> the report with any patches posted or committed to fix the issue; this
> again allows the bot to show the current status of regressions and
> automatically resolve the issue when the fix hits the right tree.
>
> I'm sending this to everyone that got the initial report, to make them
> aware of the tracking. I also hope that messages like this motivate
> people to directly get at least the regression mailing list and ideally
> even regzbot involved when dealing with regressions, as messages like
> this wouldn't be needed then. And don't worry, if I need to send other
> mails regarding this regression only relevant for regzbot I'll send them
> to the regressions lists only (with a tag in the subject so people can
> filter them away). With a bit of luck no such messages will be needed
> anyway.
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>
> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> reports on my table. I can only look briefly into most of them and lack
> knowledge about most of the areas they concern. I thus unfortunately
> will sometimes get things wrong or miss something important. I hope
> that's not the case here; if you think it is, don't hesitate to tell me
> in a public reply, it's in everyone's interest to set the public record
> straight.
>
>
> On 27.02.22 03:36, Satadru Pramanik wrote:
> > I'm on a x86_64 ubuntu 22.04 system accessing a similar system running
> > samba Version 4.13.14-Ubuntu. Both systems are on ubuntu mainline
> > kernel 5.17-rc5.
> >
> > I have a samba share mounted from my fstab, and file access works fine.
> > Upon suspending my system and resuming though, the mounted samba share
> > is inaccessible, and my dmesg has many "CIFS: VFS: cifs_tree_connect:
> > could not find superblock: -22" messages.
> >
> > Unmounting and remounting the share restores access.
> >
> > When I boot into kernel 5.16.11, I do not have this issue. The cifs
> > share is accessible just fine after a suspend/resume cycle.
> >
> > I assume this is a regression with 5.17? Is there any information
> > worth providing which might help debug and fix this issue?
> >
> > Regards,
> >
> > Satadru Pramanik
>
> --
> Additional information about regzbot:
>
> If you want to know more about regzbot, check out its web-interface, the
> getting start guide, and the references documentation:
>
> https://linux-regtracking.leemhuis.info/regzbot/
> https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
> https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md
>
> The last two documents will explain how you can interact with regzbot
> yourself if your want to.
>
> Hint for reporters: when reporting a regression it's in your interest to
> CC the regression list and tell regzbot about the issue, as that ensures
> the regression makes it onto the radar of the Linux kernel's regression
> tracker -- that's in your interest, as it ensures your report won't fall
> through the cracks unnoticed.
>
> Hint for developers: you normally don't need to care about regzbot once
> it's involved. Fix the issue as you normally would, just remember to
> include 'Link:' tag in the patch descriptions pointing to all reports
> about the issue. This has been expected from developers even before
> regzbot showed up for reasons explained in
> 'Documentation/process/submitting-patches.rst' and
> 'Documentation/process/5.Posting.rst'.



-- 
Thanks,

Steve
