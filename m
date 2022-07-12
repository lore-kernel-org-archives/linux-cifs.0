Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC75C43334
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Jul 2022 21:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiGLVkw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Jul 2022 17:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiGLVkv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Jul 2022 17:40:51 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2926CE380
        for <linux-cifs@vger.kernel.org>; Tue, 12 Jul 2022 14:40:49 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id a10so9586783ljj.5
        for <linux-cifs@vger.kernel.org>; Tue, 12 Jul 2022 14:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BqlIeCHKfCTZAGZghqKXSFI5UdhUXR8ohHaF7TDfq3w=;
        b=Z+G1d0PdATeztUwjdevntDob/BivcMWBfc5symI19tGLPrxmSHspMBBY4k2IgFxeYD
         lZ8ONhOuTBBySWkUKY791hoRIe1kkqzoej6p1MX5ObXLWXsL0wpOLGYsDNT8Os3s4T38
         LRCKmGoNus4/JKhBdVrOsRkBC8rhy//LLm+jSjJg+wZ/JPdJBVBWE15XD61N+0O1NMne
         qUbeQNoXH2SVstbOx6FwzIReWYJxDKWbKnsJefQAoJOzr5JGjMxmgxM8lmocBosFqgEa
         TapzTD7DTtIlJqpS2b5i9gBQLClo5o59PJEHWj6/PWPW/obvWae50oJDt8rqaJXkYsgN
         MDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BqlIeCHKfCTZAGZghqKXSFI5UdhUXR8ohHaF7TDfq3w=;
        b=IUir9BDjyaQFTccug2CVoHU8CW99uAyja8XxBtprBH82myLDxq2rv68uAdIzIWhHcX
         /WQGhilSv42trPotGnzBplbbcWeDwP1kvkwMxPdCyuEELLlmMrPsVuBqxtKhnCMe+Fgz
         CM9g7IzbhlY8wNnh/cDC7vJ2wxL9jOCpt0KMyKoTWA2OAQX1sfa4kdDLVwjNw/yXRz99
         ky5kJ2S81005st2O0bwTQ8EVbhsu8DFUjh8n+80yb5ZF9bzMsWqFSeMujly7ZX6yLjNj
         wixt8zKO39Ob2ApzZsXWJyP/NzPUFOtHhMA3Wi3UwoJ1RTBK0w/wfqWOp7zmHaOH8Ezt
         a0rA==
X-Gm-Message-State: AJIora+ZEJXLo6vcO6BJjfx1spU3vR0xmnzFDS+8fszVkO44t6zxjXFC
        ozGWBZHBlqDBd8TgNxSDIfRqLLoGyb2E9Tplbg8Lnt4w
X-Google-Smtp-Source: AGRyM1tLK9GHiCdbgLPa9NcijBOFs/FmYtwjdCAzgoMpYxWQwnzFr2uzkSQRt33VaAyEsebbIacskLqL9S/uKAvpBfw=
X-Received: by 2002:a2e:b55a:0:b0:25d:485e:5d86 with SMTP id
 a26-20020a2eb55a000000b0025d485e5d86mr44958ljn.194.1657662048188; Tue, 12 Jul
 2022 14:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pamwCmYC3pFHPmg1QGNTEpNdqp9aoE=8w++BEVk+8nbQ@mail.gmail.com>
 <CANT5p=pPdY_-gUQUamOJ2p79riyJ++h2V2HJ7mGm9+OHPQ2L7w@mail.gmail.com>
In-Reply-To: <CANT5p=pPdY_-gUQUamOJ2p79riyJ++h2V2HJ7mGm9+OHPQ2L7w@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 13 Jul 2022 07:40:35 +1000
Message-ID: <CAN05THSk6UKeTGo3=2kg3pJcHTz+DB2K9h4ijg7c9Ep=XsVqeQ@mail.gmail.com>
Subject: Re: Problem with deferred close after umount
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, 9 Jul 2022 at 16:48, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Sat, Jul 9, 2022 at 11:45 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > Hi Steve/Ronnie,
> >
> > I'm seeing a strange problem with deferred close.
> > This is the test that I'm running:
> > 1. mount a share with actime=600
> > 2. open a file in the share so that a handle is opened, and it gets
> > scheduled for deferred close.
> > 3. umount the share. That works.
> > 4. rmmod cifs does not seem to work. It says module cifs is in use.
> > DebugData shows that tcon/ses/connections are all active for the
> > unmounted share.
> >
> > I think I understand why this happens, but need help understanding how
> > to fix this.
> >
> > Each handle open takes a reference on tcon, and also on the
> > superblock. So even when the mount point is umounted, tcon does not
> > get freed. I see that it gets freed when all handles that are deferred
> > for close are actually closed.
> >
> > I tried calling cifs_close_all_deferred_files for the tcon in
> > cifs_umount_begin. I even tried printing a log there. I did not see
> > that getting logged during umount. Does that mean umount_begin is not
> > getting called?
> >
> > Wondering what is the correct way to fix this? Ideally, we should call
> > cifs_close_all_deferred_files as soon as the share is umounted. Which
> > is the first callback in cifs.ko for this. I was assuming that
> > umount_begin is that callback. But my experiments are not seeing that
> > getting called.
> >
> > --
> > Regards,
> > Shyam
>
> I checked the VFS code. It looks like the umount_begin callback gets
> called only when called with "umount --force" option.
> I tested that. It seems to work.
>
> Is it the expected though without force? Doesn't seem right to me.


 umount_begin() is a special callback just for network filesystems
that need to do something special
if/when a forced umount is attempted so this would be the wrong place
for the normal deferred close
handling.  It is poorly documented though :-(

Maybe cifs_kill_sb() would be the right place to use?


>
> --
> Regards,
> Shyam
