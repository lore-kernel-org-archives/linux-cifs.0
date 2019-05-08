Return-Path: <SRS0=nxME=TI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF34C04A6B
	for <linux-cifs@archiver.kernel.org>; Wed,  8 May 2019 21:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A430216C4
	for <linux-cifs@archiver.kernel.org>; Wed,  8 May 2019 21:47:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pBlRZGaL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfEHVr4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 May 2019 17:47:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46433 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfEHVr4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 May 2019 17:47:56 -0400
Received: by mail-pl1-f194.google.com with SMTP id bi2so29701plb.13;
        Wed, 08 May 2019 14:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5bNHEZyoMBk+M3klI9aU53M2aRLAmC1Bv+JFzOfGHa0=;
        b=pBlRZGaLwQVLu6p7WDopNzOsjrEGhrlO/Y573oVOa0V1JmJhiKJX7YKDURJpbhWIfh
         p7Pmn+fT58/zf0jzExbvDtqLLvCG33F+IqblJJSkAIHEWVrb+0dGx4Ht2fruP1duuFAO
         lICxbo4B0JTwANqsBnhW/FNlAyKrxSwn9bn8fowc/TSTzd7O4/WR1OzQoQ6ftdDzjwCG
         0rgiMmMf7zN4+SIP6dzG9PoM40O+4YCUG+05j0eC9zQEryfct5+tFjIizEajdI/xcicX
         Yc8sgGy5gKVjaEz91MYZr2C6pAam2vrBmnFoEGbEGNlueLj8a2HYZhn6e5un5lRMhBdR
         X9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5bNHEZyoMBk+M3klI9aU53M2aRLAmC1Bv+JFzOfGHa0=;
        b=nzGKJ9DGkfK2cG5+lh4YgqjJ1EBZOSmRSGEvyXHhWi0JxiI4trIQoSEHaSpX1ILm7u
         +5fZr78hBLeExkACy+D0iy7Q3boiVgQ2XwJCDTMMwHpIMSQf0oeLacFertoieu39Dt1r
         3IYApzBi9sBBGPR4S+Je32qdwXOqTP7vxIJP2BXwGQn0qINFRCWa9mI1GpUg1/zXnF0c
         hp92lj1QKTAJsC1I00z0JDRyFvOUpTkQ59sXnvlN74LxVEYklI70T820aJMJg094rzVl
         HnV/41SQuQW1CgEkGmTCwrl8LqumECIINddz/dl32PhF4WDIEhViFaDfdvk7Kj+d7vnH
         a+zA==
X-Gm-Message-State: APjAAAUudpQL1Q1ZI9WuU0NiPJ+mdsuT1Qu1jdPyZFwrVSUZ+8bZR4OF
        0rhGQjIrJfxWyAt95d6xZwHKIZ6qjc5RL2OHfhBcZA==
X-Google-Smtp-Source: APXvYqxZh9GqHMV6SQwteGF/JoL1z9bDQTTi2v9t2Ry5aUK/J9uIr86FN0DdFGdCrfU9nIkUusb604Ppp8Z18reiUVg=
X-Received: by 2002:a17:902:b105:: with SMTP id q5mr190268plr.290.1557352074726;
 Wed, 08 May 2019 14:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv=4JsaF-8v=U4JR3jrOyPfhtUsJPogNudLejDh09xGSA@mail.gmail.com>
 <CAHk-=wiKoePP_9CM0fn_Vv1bYom7iB5N=ULaLLz7yOST3K+k5g@mail.gmail.com>
In-Reply-To: <CAHk-=wiKoePP_9CM0fn_Vv1bYom7iB5N=ULaLLz7yOST3K+k5g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 8 May 2019 16:47:43 -0500
Message-ID: <CAH2r5mu2tsupGjLQPK0z7va-FPdWb_WT0DKTYjZw-SW4=DCaRQ@mail.gmail.com>
Subject: Re: [GIT PULL] CIFS/SMB3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, May 8, 2019 at 3:37 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, May 8, 2019 at 11:32 AM Steve French <smfrench@gmail.com> wrote:
> >
> >    [..] Our
> > build verification tests passed (and continue to be extended to
> > include more tests).  See e.g. our 'buildbot' results at:
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/199
>
> Still, is there any reason for that very late rebase?
>
> Why are all the commits so recent?

Most of the commits were from April, three from March, only a few more
recent. I rebased
yesterday (bad idea it seems based on your note) simply to avoid any potential
merge conflict with the two broad VFS changes (unrelated to my PR)
that hit cifs code yesterday (albeit they turned out to be very small).

> And perhaps even more importantly, why is the base for that rebase is
> some completely random and inappropriate commit in the middle of the
> merge window?

Understood. I had originally based it on v5.1 tag, but changed that
for testing after
I saw two other PR's hit I wanted to run the regression tests on
'current' mainline
with the changes in for-next code just in case (very unlikely) the other two
changes that I hadn't seen that hit cifs since 5.1 broke anything or
caused conflicts.

> So don't do the whole "rebase the day before" in the first place, but
> *DEFINITELY* don't do it when you then pick a random and bad point to
> rebase things on top of!

Understood - will do the rebase for our verification testing only
(e.g. to spot any
regressions in recent global or VFS changes) but not for
sending to you.   So for future, will try to send with base as that of
mainline kernel
as of he last cifs PR  merge or new kernel version or rc (e.g.
v5.2-rc1 or v5.1 etc)
whichever is more recent.  Is that ok?



-- 
Thanks,

Steve
