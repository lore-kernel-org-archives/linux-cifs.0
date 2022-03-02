Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318F2C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Mar 2022 14:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbiCBOrQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Mar 2022 09:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243217AbiCBOrN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Mar 2022 09:47:13 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA90C7C22
        for <linux-cifs@vger.kernel.org>; Wed,  2 Mar 2022 06:46:28 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id p20so2660621ljo.0
        for <linux-cifs@vger.kernel.org>; Wed, 02 Mar 2022 06:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XJ5En0V9C/DoD695Fse0dNeSdtqVQBBp3ob6ZXy2U8o=;
        b=M5duJrJDioQAbCM7pyunpVT+YIaot1GD1s6rkMDe7zOK3oagG0g3ASI02a0lWudiyl
         51EZsAij6nrSkGDvnwThqc5lEQTGpT3fPPpr2tTT6crBPXjxfWlHCCHF5a5FChNjVWQY
         tvw/Hb7uL8/F7Wv7pOmwCgBXUyq2RG7RKU3rTJrzH3/o6I/EFVZKax0DTKly2TPZ9BQb
         7B4m1fXYhUV9pvLKmZ5enAYixai4d8jjPosygPD/yC7878AsXm2gVz22ARXkhMrk3ePz
         klJQ+HZfzUQ9Db2gHgQQLydqiDCXkD7/NXAA49WV0huku8UcXKsliuiZxk5YNAINSW3a
         vX3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XJ5En0V9C/DoD695Fse0dNeSdtqVQBBp3ob6ZXy2U8o=;
        b=pbcDE+deixHBuil8GGv9vy1iu+JZ1iZXBfBOi2hNp25sPKYKqKqYWxrNXpbwpzIRjI
         yytdQqxcPbBxFzBFlISuM2/d08zQZvS9OlO9Xei3T0I5/y8SV+yEKJxxfGZG8UE2SoHe
         K1m5fM+Y+RJAxNLN/voT4e2Cz3wUOyQULz/FqfqI2t5FF3Btq9VzMqYrL9bmhIocGZZJ
         HjWIq6p1TrToPmq2m5AULAL1jF7CVkJvsVTLzSFQfn5H5da/gDqsH4dSy6HgTFEM5qzJ
         1TNZ5SAoTBjNvodrtstZWNY79aTf3rxWsFKZxfpVk0LHusS70q8QVCqTFcjWXKasTH/1
         xbzQ==
X-Gm-Message-State: AOAM531yE++pdHe0KhxQgi2fid0zGIOg0SAoDMCsgMKIrXYpCj9n9xYI
        lDwoa6/DITYzRLsRlRBp6Qj7ZJHC4shT7fuLOoE=
X-Google-Smtp-Source: ABdhPJy+BH5wTrduSDep9Yt7zZ489PB9pI6912qR2KP8RdfW4xhzpCuPL11HGBPI7McYFQ8KFLcESvrZ9XoD0nlkgvc=
X-Received: by 2002:a2e:9bc4:0:b0:246:652c:843 with SMTP id
 w4-20020a2e9bc4000000b00246652c0843mr20400833ljj.193.1646232383326; Wed, 02
 Mar 2022 06:46:23 -0800 (PST)
MIME-Version: 1.0
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
 <eae5c0cc-55d1-f8db-aba0-57cee7f10332@leemhuis.info> <CAH2r5msUiBuZ74_nPVyzn=k=g0ELpcMnoTm_z30zrMSxF4sn1A@mail.gmail.com>
 <CAFrh3J-oOR1FxPrpzKsQQvronyk9fhDSqD2CY5DNsYO5Lt0ydg@mail.gmail.com>
 <CAFrh3J-TOW4JG6QND0nz_9asiv2g0DzPmxR68BBB_an9yAQ+Vw@mail.gmail.com>
 <CAFrh3J83sUd3tQYHzssKoBb4uQXd3MXf9e=4jLsJ9aH7z2B3oA@mail.gmail.com> <CANT5p=qvrV5mrE8dN=RAmCBefGd4_3BzTfM7U98eqmZN2ZVjEg@mail.gmail.com>
In-Reply-To: <CANT5p=qvrV5mrE8dN=RAmCBefGd4_3BzTfM7U98eqmZN2ZVjEg@mail.gmail.com>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Wed, 2 Mar 2022 09:46:12 -0500
Message-ID: <CAFrh3J8xaEoLo56SmgTKd7gU_KZiyK2AqmrT_7VSM-Hxsyxwrw@mail.gmail.com>
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        CIFS <linux-cifs@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: multipart/mixed; boundary="0000000000006d6eee05d93d5846"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000006d6eee05d93d5846
Content-Type: text/plain; charset="UTF-8"

Here is also the dmesg as promised. (After resuming from suspend/sleep
this morning, when I again had the same issue.)

On Wed, Mar 2, 2022 at 2:57 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Wed, Mar 2, 2022 at 3:51 AM Satadru Pramanik <satadru@gmail.com> wrote:
> >
> > I have put the trace.dat and other debug files here since I can not
> > attach the files to a message to the list. (Apparently the trace.dat
> > file is too large.)
> >
> > https://drive.google.com/drive/folders/1wEi968RbXxivXMMH8J7XUsHhrxu9OWDX?usp=sharing
> >
> > On Mon, Feb 28, 2022 at 11:12 PM Satadru Pramanik <satadru@gmail.com> wrote:
> > >
> > > The trace.dat file is attached, covering the period before suspend,
> > > and through wake several hours later, when the mount no longer worked,
> > > and showed the CIFS: VFS: cifs_tree_connect: could not find
> > > superblock: -22 message, and through when I unmounted and remounted
> > > the share, which then started working.
> > >
> > > On Mon, Feb 28, 2022 at 9:31 AM Satadru Pramanik <satadru@gmail.com> wrote:
> > > >
> > > > Here is the DebugData from before and after from the system with the
> > > > failed mount.
> > > > Both systems are now running 5.17-rc6.
> > > >
> > > > Working on the trace-cmd now.
> > > >
> > > > On Sun, Feb 27, 2022 at 9:37 PM Steve French <smfrench@gmail.com> wrote:
> > > > >
> > > > > I would like to see the output of:
> > > > >
> > > > > /proc/fs/cifs/DebugData before and after the failure if possible.
> > > > >
> > > > > In addition, there would be some value in seeing trace information
> > > > > (e.g start tracing by
> > > > > "trace-cmd record -e cifs" before the failure and then forward the
> > > > > debug information displayed by "trace-cmd show" after the failure)
> > > > >
> > > > > On Sun, Feb 27, 2022 at 7:55 AM Thorsten Leemhuis
> > > > > <regressions@leemhuis.info> wrote:
> > > > > >
> > > > > > [TLDR: I'm adding the regression report below to regzbot, the Linux
> > > > > > kernel regression tracking bot; all text you find below is compiled from
> > > > > > a few templates paragraphs you might have encountered already already
> > > > > > from similar mails.]
> > > > > >
> > > > > > Hi, this is your Linux kernel regression tracker. Top-posting for once,
> > > > > > to make this easily accessible to everyone.
> > > > > >
> > > > > > CCing the regression mailing list, as it should be in the loop for all
> > > > > > regressions, as explained here:
> > > > > > https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html
> > > > > >
> > > > > > To be sure below issue doesn't fall through the cracks unnoticed, I'm
> > > > > > adding it to regzbot, my Linux kernel regression tracking bot:
> > > > > >
> > > > > > #regzbot ^introduced v5.16.11..v5.17-rc5
> > > > > > #regzbot title cifs: Failure to access cifs mount of samba share after
> > > > > > resume from sleep
> > > > > > #regzbot ignore-activity
> > > > > >
> > > > > > Reminder for developers: when fixing the issue, please add a 'Link:'
> > > > > > tags pointing to the report (the mail quoted above) using
> > > > > > lore.kernel.org/r/, as explained in
> > > > > > 'Documentation/process/submitting-patches.rst' and
> > > > > > 'Documentation/process/5.Posting.rst'. This allows the bot to connect
> > > > > > the report with any patches posted or committed to fix the issue; this
> > > > > > again allows the bot to show the current status of regressions and
> > > > > > automatically resolve the issue when the fix hits the right tree.
> > > > > >
> > > > > > I'm sending this to everyone that got the initial report, to make them
> > > > > > aware of the tracking. I also hope that messages like this motivate
> > > > > > people to directly get at least the regression mailing list and ideally
> > > > > > even regzbot involved when dealing with regressions, as messages like
> > > > > > this wouldn't be needed then. And don't worry, if I need to send other
> > > > > > mails regarding this regression only relevant for regzbot I'll send them
> > > > > > to the regressions lists only (with a tag in the subject so people can
> > > > > > filter them away). With a bit of luck no such messages will be needed
> > > > > > anyway.
> > > > > >
> > > > > > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> > > > > >
> > > > > > P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> > > > > > reports on my table. I can only look briefly into most of them and lack
> > > > > > knowledge about most of the areas they concern. I thus unfortunately
> > > > > > will sometimes get things wrong or miss something important. I hope
> > > > > > that's not the case here; if you think it is, don't hesitate to tell me
> > > > > > in a public reply, it's in everyone's interest to set the public record
> > > > > > straight.
> > > > > >
> > > > > >
> > > > > > On 27.02.22 03:36, Satadru Pramanik wrote:
> > > > > > > I'm on a x86_64 ubuntu 22.04 system accessing a similar system running
> > > > > > > samba Version 4.13.14-Ubuntu. Both systems are on ubuntu mainline
> > > > > > > kernel 5.17-rc5.
> > > > > > >
> > > > > > > I have a samba share mounted from my fstab, and file access works fine.
> > > > > > > Upon suspending my system and resuming though, the mounted samba share
> > > > > > > is inaccessible, and my dmesg has many "CIFS: VFS: cifs_tree_connect:
> > > > > > > could not find superblock: -22" messages.
> > > > > > >
> > > > > > > Unmounting and remounting the share restores access.
> > > > > > >
> > > > > > > When I boot into kernel 5.16.11, I do not have this issue. The cifs
> > > > > > > share is accessible just fine after a suspend/resume cycle.
> > > > > > >
> > > > > > > I assume this is a regression with 5.17? Is there any information
> > > > > > > worth providing which might help debug and fix this issue?
> > > > > > >
> > > > > > > Regards,
> > > > > > >
> > > > > > > Satadru Pramanik
> > > > > >
> > > > > > --
> > > > > > Additional information about regzbot:
> > > > > >
> > > > > > If you want to know more about regzbot, check out its web-interface, the
> > > > > > getting start guide, and the references documentation:
> > > > > >
> > > > > > https://linux-regtracking.leemhuis.info/regzbot/
> > > > > > https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
> > > > > > https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md
> > > > > >
> > > > > > The last two documents will explain how you can interact with regzbot
> > > > > > yourself if your want to.
> > > > > >
> > > > > > Hint for reporters: when reporting a regression it's in your interest to
> > > > > > CC the regression list and tell regzbot about the issue, as that ensures
> > > > > > the regression makes it onto the radar of the Linux kernel's regression
> > > > > > tracker -- that's in your interest, as it ensures your report won't fall
> > > > > > through the cracks unnoticed.
> > > > > >
> > > > > > Hint for developers: you normally don't need to care about regzbot once
> > > > > > it's involved. Fix the issue as you normally would, just remember to
> > > > > > include 'Link:' tag in the patch descriptions pointing to all reports
> > > > > > about the issue. This has been expected from developers even before
> > > > > > regzbot showed up for reasons explained in
> > > > > > 'Documentation/process/submitting-patches.rst' and
> > > > > > 'Documentation/process/5.Posting.rst'.
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
>
> The DebugData shows that the connection and smb session are fine, but
> the tree connect is not in a good state.
> Similarly, the trace output shows that connection was reconnected
> successfully, SMB session was reconnected as well. However, the tree
> connect did not go over the wire.
>
> > The trace.dat file is attached, covering the period before suspend,
> > and through wake several hours later, when the mount no longer worked,
> > and showed the CIFS: VFS: cifs_tree_connect: could not find
> > superblock: -22 message, and through when I unmounted and remounted
> > the share, which then started working.
>
> This suggests to me that the cifs_tcp_get_super is failing.
> This is odd, since it looks up the server as pointers.
> Did we start undercounting the ref count somewhere?
>
> --
> Regards,
> Shyam

--0000000000006d6eee05d93d5846
Content-Type: application/gzip; name="dmesg.txt.gz"
Content-Disposition: attachment; filename="dmesg.txt.gz"
Content-Transfer-Encoding: base64
Content-ID: <f_l09o812p0>
X-Attachment-Id: f_l09o812p0

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
CizJpDDCGAosjT4CKYdi/QBPnr9UjXABAA==
--0000000000006d6eee05d93d5846--
