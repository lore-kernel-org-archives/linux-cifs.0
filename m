Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAE9C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Mar 2022 14:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbiCDOCf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Mar 2022 09:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiCDOCe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Mar 2022 09:02:34 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBD31B8FDA
        for <linux-cifs@vger.kernel.org>; Fri,  4 Mar 2022 06:01:45 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id y24so11048683ljh.11
        for <linux-cifs@vger.kernel.org>; Fri, 04 Mar 2022 06:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=91BO89Vfc31AkZOmLkNkiQ2wUGsFFuRJNfxs9ijRJhE=;
        b=aFT2d72F8pBVe2sn8OFAxlADDNPj0fyDHyOm+3LWiagOj4hubhSBA4Bh5CW35GbL91
         B5HidrUlWzMQYFe23D1jbVw5Wg9ukJvFy7IlIWNWavy4Hzx3ll5Lonf5j8+7L0POsDTg
         oBtEXf3dBctXAcVMB7dqtAbGBuUefzvGaRJquIxUJMoH60Ah5FOHcZvfvdXSH8IyCUjx
         7YAy6GT9B0pAL7GtU3jHsT8pO2AQ59ECOw7Hemf8fB0opgSfOzfEcw52AptWuY+CnCbO
         7caqrF6VbtBYUZ3Ep+IrGKgEBCmUU+Ttoe7UPGZLi2TzGzhKCUQkyVj/IXWQz1g3irnn
         yiRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=91BO89Vfc31AkZOmLkNkiQ2wUGsFFuRJNfxs9ijRJhE=;
        b=wANL9QJHSoLDi7pWokZazHELBeFrTmg3OZtvOeU+a37CeptF24NLB+ypa6MQ5Et2tP
         Qw12BHIcNRxiONjnJXOqRonw3ehF0C4TnI3gdrVyqyIxJz897cKPHOzWgUtvMSIydzKI
         9Eeg+dQBgUrRVT8yDUBoAITMi71fXDjE4hwB56yqUMTCa171Yip0+9U4lFRs4oscsEpc
         7gPqhFjtlbKT2Tns2jXn+8jy4yoGiW1/dITL5P73FGJtsfmRdOIT8ViI8m4tVpD6XFuN
         2P+vlhyDGRz9pZfgZTX1iBWPnN6VMn+ZQsWqPMifTe6KqNro/rtcI0sM9t7EIEi/PxP3
         +8pA==
X-Gm-Message-State: AOAM530dq1zbEmyyq+mI6reJATDZxqoGsAp8KNqjEElmHo8cU4vB1gV8
        iMAl8z7+NtlO0ZAm1LwvZP5t6eoltd5vh2m7CPI=
X-Google-Smtp-Source: ABdhPJxDdCZ22hl4itakTrNbO76HvpnBkPfiTif85Fcey5HpvKITsTFv0NEpfShUg2ZuIabaWJ8hRNJa6TgUo1LpHrI=
X-Received: by 2002:a2e:9847:0:b0:238:eca:62fd with SMTP id
 e7-20020a2e9847000000b002380eca62fdmr26271876ljj.65.1646402497426; Fri, 04
 Mar 2022 06:01:37 -0800 (PST)
MIME-Version: 1.0
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
 <eae5c0cc-55d1-f8db-aba0-57cee7f10332@leemhuis.info> <CAH2r5msUiBuZ74_nPVyzn=k=g0ELpcMnoTm_z30zrMSxF4sn1A@mail.gmail.com>
 <CAFrh3J-oOR1FxPrpzKsQQvronyk9fhDSqD2CY5DNsYO5Lt0ydg@mail.gmail.com>
 <CAFrh3J-TOW4JG6QND0nz_9asiv2g0DzPmxR68BBB_an9yAQ+Vw@mail.gmail.com>
 <CAFrh3J83sUd3tQYHzssKoBb4uQXd3MXf9e=4jLsJ9aH7z2B3oA@mail.gmail.com>
 <CANT5p=qvrV5mrE8dN=RAmCBefGd4_3BzTfM7U98eqmZN2ZVjEg@mail.gmail.com>
 <CAFrh3J8xaEoLo56SmgTKd7gU_KZiyK2AqmrT_7VSM-Hxsyxwrw@mail.gmail.com>
 <CANT5p=p50RU4HY=Dbx0+HzorZ_W0gTmE6iCZbQf0RdF3ZcfRLw@mail.gmail.com> <CAFrh3J-xXK1ScRT2BddWzYw9VbeUsGT9cL30bC_KwhQn4G3dtQ@mail.gmail.com>
In-Reply-To: <CAFrh3J-xXK1ScRT2BddWzYw9VbeUsGT9cL30bC_KwhQn4G3dtQ@mail.gmail.com>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Fri, 4 Mar 2022 09:01:24 -0500
Message-ID: <CAFrh3J8+Yb9gHoCaxMPCTyzzS68v9Fz9VGggkjm2hOB07Hj0Yw@mail.gmail.com>
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        CIFS <linux-cifs@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: multipart/mixed; boundary="0000000000000457a105d964f409"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000457a105d964f409
Content-Type: text/plain; charset="UTF-8"

Here is a subset of the recent dmesg during failed mounts, followed by
an unmount and remount.

On Fri, Mar 4, 2022 at 8:58 AM Satadru Pramanik <satadru@gmail.com> wrote:
>
> I have put this in my /etc/rc.local:
> echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
> echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
> echo 7 > /proc/fs/cifs/cifsFYI
>
> I ran the commands again manually, and the attached dmesg appears to
> be capturing some of the aforementioned reconnection efforts this
> morning.
>
> On Fri, Mar 4, 2022 at 12:49 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > On Wed, Mar 2, 2022 at 8:16 PM Satadru Pramanik <satadru@gmail.com> wrote:
> > >
> > > Here is also the dmesg as promised. (After resuming from suspend/sleep
> > > this morning, when I again had the same issue.)
> > >
> > > On Wed, Mar 2, 2022 at 2:57 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > > >
> > > > On Wed, Mar 2, 2022 at 3:51 AM Satadru Pramanik <satadru@gmail.com> wrote:
> > > > >
> > > > > I have put the trace.dat and other debug files here since I can not
> > > > > attach the files to a message to the list. (Apparently the trace.dat
> > > > > file is too large.)
> > > > >
> > > > > https://drive.google.com/drive/folders/1wEi968RbXxivXMMH8J7XUsHhrxu9OWDX?usp=sharing
> > > > >
> > > > > On Mon, Feb 28, 2022 at 11:12 PM Satadru Pramanik <satadru@gmail.com> wrote:
> > > > > >
> > > > > > The trace.dat file is attached, covering the period before suspend,
> > > > > > and through wake several hours later, when the mount no longer worked,
> > > > > > and showed the CIFS: VFS: cifs_tree_connect: could not find
> > > > > > superblock: -22 message, and through when I unmounted and remounted
> > > > > > the share, which then started working.
> > > > > >
> > > > > > On Mon, Feb 28, 2022 at 9:31 AM Satadru Pramanik <satadru@gmail.com> wrote:
> > > > > > >
> > > > > > > Here is the DebugData from before and after from the system with the
> > > > > > > failed mount.
> > > > > > > Both systems are now running 5.17-rc6.
> > > > > > >
> > > > > > > Working on the trace-cmd now.
> > > > > > >
> > > > > > > On Sun, Feb 27, 2022 at 9:37 PM Steve French <smfrench@gmail.com> wrote:
> > > > > > > >
> > > > > > > > I would like to see the output of:
> > > > > > > >
> > > > > > > > /proc/fs/cifs/DebugData before and after the failure if possible.
> > > > > > > >
> > > > > > > > In addition, there would be some value in seeing trace information
> > > > > > > > (e.g start tracing by
> > > > > > > > "trace-cmd record -e cifs" before the failure and then forward the
> > > > > > > > debug information displayed by "trace-cmd show" after the failure)
> > > > > > > >
> > > > > > > > On Sun, Feb 27, 2022 at 7:55 AM Thorsten Leemhuis
> > > > > > > > <regressions@leemhuis.info> wrote:
> > > > > > > > >
> > > > > > > > > [TLDR: I'm adding the regression report below to regzbot, the Linux
> > > > > > > > > kernel regression tracking bot; all text you find below is compiled from
> > > > > > > > > a few templates paragraphs you might have encountered already already
> > > > > > > > > from similar mails.]
> > > > > > > > >
> > > > > > > > > Hi, this is your Linux kernel regression tracker. Top-posting for once,
> > > > > > > > > to make this easily accessible to everyone.
> > > > > > > > >
> > > > > > > > > CCing the regression mailing list, as it should be in the loop for all
> > > > > > > > > regressions, as explained here:
> > > > > > > > > https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html
> > > > > > > > >
> > > > > > > > > To be sure below issue doesn't fall through the cracks unnoticed, I'm
> > > > > > > > > adding it to regzbot, my Linux kernel regression tracking bot:
> > > > > > > > >
> > > > > > > > > #regzbot ^introduced v5.16.11..v5.17-rc5
> > > > > > > > > #regzbot title cifs: Failure to access cifs mount of samba share after
> > > > > > > > > resume from sleep
> > > > > > > > > #regzbot ignore-activity
> > > > > > > > >
> > > > > > > > > Reminder for developers: when fixing the issue, please add a 'Link:'
> > > > > > > > > tags pointing to the report (the mail quoted above) using
> > > > > > > > > lore.kernel.org/r/, as explained in
> > > > > > > > > 'Documentation/process/submitting-patches.rst' and
> > > > > > > > > 'Documentation/process/5.Posting.rst'. This allows the bot to connect
> > > > > > > > > the report with any patches posted or committed to fix the issue; this
> > > > > > > > > again allows the bot to show the current status of regressions and
> > > > > > > > > automatically resolve the issue when the fix hits the right tree.
> > > > > > > > >
> > > > > > > > > I'm sending this to everyone that got the initial report, to make them
> > > > > > > > > aware of the tracking. I also hope that messages like this motivate
> > > > > > > > > people to directly get at least the regression mailing list and ideally
> > > > > > > > > even regzbot involved when dealing with regressions, as messages like
> > > > > > > > > this wouldn't be needed then. And don't worry, if I need to send other
> > > > > > > > > mails regarding this regression only relevant for regzbot I'll send them
> > > > > > > > > to the regressions lists only (with a tag in the subject so people can
> > > > > > > > > filter them away). With a bit of luck no such messages will be needed
> > > > > > > > > anyway.
> > > > > > > > >
> > > > > > > > > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> > > > > > > > >
> > > > > > > > > P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> > > > > > > > > reports on my table. I can only look briefly into most of them and lack
> > > > > > > > > knowledge about most of the areas they concern. I thus unfortunately
> > > > > > > > > will sometimes get things wrong or miss something important. I hope
> > > > > > > > > that's not the case here; if you think it is, don't hesitate to tell me
> > > > > > > > > in a public reply, it's in everyone's interest to set the public record
> > > > > > > > > straight.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > On 27.02.22 03:36, Satadru Pramanik wrote:
> > > > > > > > > > I'm on a x86_64 ubuntu 22.04 system accessing a similar system running
> > > > > > > > > > samba Version 4.13.14-Ubuntu. Both systems are on ubuntu mainline
> > > > > > > > > > kernel 5.17-rc5.
> > > > > > > > > >
> > > > > > > > > > I have a samba share mounted from my fstab, and file access works fine.
> > > > > > > > > > Upon suspending my system and resuming though, the mounted samba share
> > > > > > > > > > is inaccessible, and my dmesg has many "CIFS: VFS: cifs_tree_connect:
> > > > > > > > > > could not find superblock: -22" messages.
> > > > > > > > > >
> > > > > > > > > > Unmounting and remounting the share restores access.
> > > > > > > > > >
> > > > > > > > > > When I boot into kernel 5.16.11, I do not have this issue. The cifs
> > > > > > > > > > share is accessible just fine after a suspend/resume cycle.
> > > > > > > > > >
> > > > > > > > > > I assume this is a regression with 5.17? Is there any information
> > > > > > > > > > worth providing which might help debug and fix this issue?
> > > > > > > > > >
> > > > > > > > > > Regards,
> > > > > > > > > >
> > > > > > > > > > Satadru Pramanik
> > > > > > > > >
> > > > > > > > > --
> > > > > > > > > Additional information about regzbot:
> > > > > > > > >
> > > > > > > > > If you want to know more about regzbot, check out its web-interface, the
> > > > > > > > > getting start guide, and the references documentation:
> > > > > > > > >
> > > > > > > > > https://linux-regtracking.leemhuis.info/regzbot/
> > > > > > > > > https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
> > > > > > > > > https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md
> > > > > > > > >
> > > > > > > > > The last two documents will explain how you can interact with regzbot
> > > > > > > > > yourself if your want to.
> > > > > > > > >
> > > > > > > > > Hint for reporters: when reporting a regression it's in your interest to
> > > > > > > > > CC the regression list and tell regzbot about the issue, as that ensures
> > > > > > > > > the regression makes it onto the radar of the Linux kernel's regression
> > > > > > > > > tracker -- that's in your interest, as it ensures your report won't fall
> > > > > > > > > through the cracks unnoticed.
> > > > > > > > >
> > > > > > > > > Hint for developers: you normally don't need to care about regzbot once
> > > > > > > > > it's involved. Fix the issue as you normally would, just remember to
> > > > > > > > > include 'Link:' tag in the patch descriptions pointing to all reports
> > > > > > > > > about the issue. This has been expected from developers even before
> > > > > > > > > regzbot showed up for reasons explained in
> > > > > > > > > 'Documentation/process/submitting-patches.rst' and
> > > > > > > > > 'Documentation/process/5.Posting.rst'.
> > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > --
> > > > > > > > Thanks,
> > > > > > > >
> > > > > > > > Steve
> > > >
> > > > The DebugData shows that the connection and smb session are fine, but
> > > > the tree connect is not in a good state.
> > > > Similarly, the trace output shows that connection was reconnected
> > > > successfully, SMB session was reconnected as well. However, the tree
> > > > connect did not go over the wire.
> > > >
> > > > > The trace.dat file is attached, covering the period before suspend,
> > > > > and through wake several hours later, when the mount no longer worked,
> > > > > and showed the CIFS: VFS: cifs_tree_connect: could not find
> > > > > superblock: -22 message, and through when I unmounted and remounted
> > > > > the share, which then started working.
> > > >
> > > > This suggests to me that the cifs_tcp_get_super is failing.
> > > > This is odd, since it looks up the server as pointers.
> > > > Did we start undercounting the ref count somewhere?
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> >
> > Hi Satadru,
> >
> > The attached dmesg did not have cifsFYI enabled.
> > Please use the below steps to enable cifsFYI before the sleep:
> > # echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
> > # echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
> > # echo 7 > /proc/fs/cifs/cifsFYI
> >
> > You can disable it after the repro using this cmd:
> > # echo 0 > /proc/fs/cifs/cifsFYI
> >
> > --
> > Regards,
> > Shyam

--0000000000000457a105d964f409
Content-Type: application/zstd; name="cifs-dmesg.txt.zst"
Content-Disposition: attachment; filename="cifs-dmesg.txt.zst"
Content-Transfer-Encoding: base64
Content-ID: <f_l0chizcz0>
X-Attachment-Id: f_l0chizcz0

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
--0000000000000457a105d964f409--
