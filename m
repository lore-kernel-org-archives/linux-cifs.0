Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA373C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 16:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0371613A2
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 16:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhKPQro (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Nov 2021 11:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbhKPQrn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Nov 2021 11:47:43 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7403FC061570
        for <linux-cifs@vger.kernel.org>; Tue, 16 Nov 2021 08:44:46 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id 1so44672283ljv.2
        for <linux-cifs@vger.kernel.org>; Tue, 16 Nov 2021 08:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a5jQvlihngL7gKJ1WxUeOEKfDBtcBdMvFJkimiBzZ5g=;
        b=cujP9PdcsnzacYzyXd3Aoineqps1ab3fw8aTMTg59Lol5jn7RZacnSi1Pi5B4GyL1d
         /G73lgA9J5zCTXCf4IrJxDDbBufJffTGbEiwQaan/c/DMFOSMUABIVi2j+jTmPrOitsl
         nIq1DDjZs1zbCbnpLv/LIIoJnNLtf82QVI8RP9RT3rTmgXurxO+3WqZXQUw/j19YQq80
         svg/a8yvNx7hl85o1nk5KTNm1NYKkF8ChR3AAR8ezLcvzybGpjhJeh2OWyYh9M9GdRc6
         25LhIEZOVYrI2OczSi67j2jNpvbawN9fnhb4E1tfViifStskGIkOQHaReDS8C7Y4iLT0
         qMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a5jQvlihngL7gKJ1WxUeOEKfDBtcBdMvFJkimiBzZ5g=;
        b=guerUbA4Brev1nr+HgJT+L468PjnrXwRYhIGKhf9dhA3/oFEDh4rQ7LMZUW9jsllxF
         BgXo/mV92pbcq01tJK8JQwDjXyUE2+91pY5vJpe9oBIaka0Onq6m+PZU8aMJLsnaKZ5a
         6qfoNr8QBQfx7S4/lpmbDoevI+QaFmQ+NMErhCWCcz4dyBPgE2KukL91WWzWhI9TiAj/
         tkriiOgZysKjTgPDp4ysd5/3ztPszf2JQLUEKDT72voIjZbP2kkr0f7XnZIS5hCqXP3r
         JXEy5r981djTpbkYiJdDTNMvIp79HC0wpCYJ7z46gd3Otf4lJpxCDFruWxv+BuSFKKvr
         7tag==
X-Gm-Message-State: AOAM532blP68828gehYI70oQBkjfr5aLvPKfWCM7GobSuZVnXyVOMp4T
        /o8sR5cN027kevcyiIobyORtseJjwz1I/qwY8vA=
X-Google-Smtp-Source: ABdhPJzBkNPt31AKpRNnO08xEooPBDC4JtV+Sg1DiSrjL2iPFreI67aO2P4HGU9JPK5J1tOxG6P07db44FTInWIhwDM=
X-Received: by 2002:a2e:7114:: with SMTP id m20mr506482ljc.229.1637081084559;
 Tue, 16 Nov 2021 08:44:44 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msH=b0UCkxfXsCEHpqQxkcvJ68qUSD+cy6JeMYi17zsHA@mail.gmail.com>
 <87a6i415ms.fsf@cjr.nz> <CANT5p=p800shbvtRW6SYpfsp1c7p68i=XS1jT8sigZ6ydtZ=QQ@mail.gmail.com>
In-Reply-To: <CANT5p=p800shbvtRW6SYpfsp1c7p68i=XS1jT8sigZ6ydtZ=QQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 Nov 2021 10:44:33 -0600
Message-ID: <CAH2r5ms-EzSgCMecsKXeQL7RN2=ODixBypkUR6-L5V6eZPbZ+g@mail.gmail.com>
Subject: Re: [PATCH] trivial coverity cleanup from multichannel series
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There may be others, I have fixed a few, and I am not convinced it is
illegal (just presumably better to printk outside of spinlocks, due to
the nesting concern, if reasonably possible) - in some cases we have
ignored it.

On Tue, Nov 16, 2021 at 10:42 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Tue, Nov 16, 2021 at 8:59 PM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Looks good,
> >
> > Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>
>
> Looks good.
> But is this the only such occurrence?
> --
> Regards,
> Shyam



-- 
Thanks,

Steve
