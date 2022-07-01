Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCB6C43334
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jul 2022 11:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiGALAp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Jul 2022 07:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiGALAn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Jul 2022 07:00:43 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E85580484
        for <linux-cifs@vger.kernel.org>; Fri,  1 Jul 2022 04:00:41 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id v9so2148219ljk.10
        for <linux-cifs@vger.kernel.org>; Fri, 01 Jul 2022 04:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vd9VdYu3eRODYqrzITKI8JU5dkeALUmdmjD06LVyz9s=;
        b=Wx9O7RhzADics7VVlAke0IDiLwdTlTOU/bKx/MiZnhaopldEmgDtLZ2XetHWJjUtEv
         WWX21u662Aj9Wt3jEMXYAy1O+Wx5zj8M9VYuhPX2cWH4igZM2f0fknajXQ6D1bK/t7Ja
         OHI5HrnIdMC5StPZf5/Ww06qEf+dXDx66vuzJKz6FCszkvkj/VKBlvBsmE3d2Iaq/jA+
         PgzZSbrr0IE1yiqODYAEsdhCcLNYSEWNqJy/ukZgdmQ2dEWqTbYL6Gw3TdX/0ozHtJGh
         u1KZwryfDb2AQxbCXpzen40JXYLuqxecXd4JHdOb8ASkC5TxZam4fGyc8KPsXmmTqNia
         hQiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vd9VdYu3eRODYqrzITKI8JU5dkeALUmdmjD06LVyz9s=;
        b=jO50tIJk7X3nn7uG/iJnCk014hYXq4G1E1K5hddDkhGk8m1ApCcuwYE3iS4k9lK6d+
         EXole5v4PLpuu6db3tDOFo49B5FjGcXLQ6J/Lc4wj71eiNQH2+3qJ8CPAJmgDpBBPV2V
         Ho3cd4uMJ0uvvShR3J1kwm5DHlA/qD/qgsm3oszRTdR6GBDpf01wSN1rWveLSHLLK1Lh
         jo/ZX9klhOrZ0k4+abizM237ut5DASOLi3LwDgsFoOc/Nev+gX6NkeRWgFxpIWYuXHLc
         /te74SYQIQFNNKVg/JP/9vQJQKlyaDgLwQsQlnBHC8sLk21w9lcjlAv7FR22gOVl3PKB
         eHsQ==
X-Gm-Message-State: AJIora8yA29gDRGIzDvCNSEw0a1hUJiTsAX+3zjC0PCjSNmYrvxjAUXw
        RehKpQX1iofjMafBMC1ZWdswr5sHuUToyvfJ/ro=
X-Google-Smtp-Source: AGRyM1twgTpdFdBejX4Vkbb7hvA48P87y287cLGM8udpLHeaVehpl/nBgitP5WqUsflKPS/Mab31fBGnXsxOMx+fZ5U=
X-Received: by 2002:a2e:1414:0:b0:25b:b9e8:1fef with SMTP id
 u20-20020a2e1414000000b0025bb9e81fefmr7746379ljd.22.1656673239697; Fri, 01
 Jul 2022 04:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAGypqWyKzYL+MKwsmStP=brsxYCE9MNq=2o-8QoywFX4oPSdTw@mail.gmail.com>
 <75e51680-f6b1-d83e-0832-bc384b7157be@talpey.com> <CANT5p=rhUvsrveJDA+AsJ6=j=sWC97LiTH+HcTFxbqRtFKqkAw@mail.gmail.com>
 <CAN05THSaD5JbdkjfEzQDtNOL-M+ZQhm-yrz6n1ystJKXOsJArw@mail.gmail.com> <CANT5p=pXXfou2H0pTX+yorFTkJ-AryhhDeaAuVzxoDb4-=U69Q@mail.gmail.com>
In-Reply-To: <CANT5p=pXXfou2H0pTX+yorFTkJ-AryhhDeaAuVzxoDb4-=U69Q@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 1 Jul 2022 21:00:27 +1000
Message-ID: <CAN05THTyNW6mw=arsDd5PCNvX_PwV2xijghe_MDFvbz_hMC-Nw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add mount parameter to control deferred close timeout
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm.hsk@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 1 Jul 2022 at 18:44, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Fri, Jul 1, 2022 at 12:07 PM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > On Fri, 1 Jul 2022 at 16:03, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >
> > > On Fri, Jul 1, 2022 at 3:23 AM Tom Talpey <tom@talpey.com> wrote:
> > > >
> > > > Is there a justification for why this is necessary?
> > > >
> > > > When and how are admins expected to use it, and with what values?
> > > >
> > >
> > > Hi Tom,
> > >
> > > This came up specifically when a customer reported an issue with lease break.
> > > We wanted to rule out (or confirm) if deferred close is playing any
> > > part in this by disabling it.
> > > However, to disable it today, we will need to set acregmax to 0, which
> > > will also disable attribute caching.
> > >
> > > So Bharath now submitted a patch for this to be able to tune this
> > > parameter separately.
> >
> > Ok,  will the option be removed later once the investigation is done?
> > We shouldn't add options that are difficult/impossible to use
> > correctly by normal users.
> We didn't intend to. We thought that this could be a useful tunable
> parameter that the basic users need not even worry about, but advanced
> users / developers could suggest changing it to tune / troubleshoot
> specific scenarios.

If it is just for developers needing it to debug specific issues  it
should absolutely not be a mount option in upstream.
Maybe have it as a /proc/fs/cifs/Debug thing or just provide custom
builds for the customer when debugging specific issues.

Once they become mount options they need to be documented, what they
do and why you would use them and exactly how to determine what to set
them to.



> >
> >
> > >
> > > > On 6/29/2022 4:26 AM, Bharath SM wrote:
> > > > > Adding a new mount parameter to specifically control timeout for deferred close.
> > >
> > >
> > >
> > > --
> > > Regards,
> > > Shyam
>
>
>
> --
> Regards,
> Shyam
