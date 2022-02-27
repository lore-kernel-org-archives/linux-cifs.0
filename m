Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FF6C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Feb 2022 08:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiB0Ihy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 27 Feb 2022 03:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiB0Ihy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 27 Feb 2022 03:37:54 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135734D611
        for <linux-cifs@vger.kernel.org>; Sun, 27 Feb 2022 00:37:18 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nOF3M-0004DT-C7; Sun, 27 Feb 2022 09:37:16 +0100
Message-ID: <eae5c0cc-55d1-f8db-aba0-57cee7f10332@leemhuis.info>
Date:   Sun, 27 Feb 2022 09:37:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
Content-Language: en-BS
To:     Satadru Pramanik <satadru@gmail.com>, linux-cifs@vger.kernel.org
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
In-Reply-To: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1645951038;d7b24e9e;
X-HE-SMSGID: 1nOF3M-0004DT-C7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

[TLDR: I'm adding the regression report below to regzbot, the Linux
kernel regression tracking bot; all text you find below is compiled from
a few templates paragraphs you might have encountered already already
from similar mails.]

Hi, this is your Linux kernel regression tracker. Top-posting for once,
to make this easily accessible to everyone.

CCing the regression mailing list, as it should be in the loop for all
regressions, as explained here:
https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html

To be sure below issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced v5.16.11..v5.17-rc5
#regzbot title cifs: Failure to access cifs mount of samba share after
resume from sleep
#regzbot ignore-activity

Reminder for developers: when fixing the issue, please add a 'Link:'
tags pointing to the report (the mail quoted above) using
lore.kernel.org/r/, as explained in
'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst'. This allows the bot to connect
the report with any patches posted or committed to fix the issue; this
again allows the bot to show the current status of regressions and
automatically resolve the issue when the fix hits the right tree.

I'm sending this to everyone that got the initial report, to make them
aware of the tracking. I also hope that messages like this motivate
people to directly get at least the regression mailing list and ideally
even regzbot involved when dealing with regressions, as messages like
this wouldn't be needed then. And don't worry, if I need to send other
mails regarding this regression only relevant for regzbot I'll send them
to the regressions lists only (with a tag in the subject so people can
filter them away). With a bit of luck no such messages will be needed
anyway.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.


On 27.02.22 03:36, Satadru Pramanik wrote:
> I'm on a x86_64 ubuntu 22.04 system accessing a similar system running
> samba Version 4.13.14-Ubuntu. Both systems are on ubuntu mainline
> kernel 5.17-rc5.
> 
> I have a samba share mounted from my fstab, and file access works fine.
> Upon suspending my system and resuming though, the mounted samba share
> is inaccessible, and my dmesg has many "CIFS: VFS: cifs_tree_connect:
> could not find superblock: -22" messages.
> 
> Unmounting and remounting the share restores access.
> 
> When I boot into kernel 5.16.11, I do not have this issue. The cifs
> share is accessible just fine after a suspend/resume cycle.
> 
> I assume this is a regression with 5.17? Is there any information
> worth providing which might help debug and fix this issue?
> 
> Regards,
> 
> Satadru Pramanik

-- 
Additional information about regzbot:

If you want to know more about regzbot, check out its web-interface, the
getting start guide, and the references documentation:

https://linux-regtracking.leemhuis.info/regzbot/
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md

The last two documents will explain how you can interact with regzbot
yourself if your want to.

Hint for reporters: when reporting a regression it's in your interest to
CC the regression list and tell regzbot about the issue, as that ensures
the regression makes it onto the radar of the Linux kernel's regression
tracker -- that's in your interest, as it ensures your report won't fall
through the cracks unnoticed.

Hint for developers: you normally don't need to care about regzbot once
it's involved. Fix the issue as you normally would, just remember to
include 'Link:' tag in the patch descriptions pointing to all reports
about the issue. This has been expected from developers even before
regzbot showed up for reasons explained in
'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst'.
