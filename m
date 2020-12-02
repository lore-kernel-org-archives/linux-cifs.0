Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B49C64E7C
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Dec 2020 10:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F06220679
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Dec 2020 10:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388202AbgLBKBo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388089AbgLBKBn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Dec 2020 05:01:43 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E30C0613D4
        for <linux-cifs@vger.kernel.org>; Wed,  2 Dec 2020 02:01:03 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id k8so999580ilr.4
        for <linux-cifs@vger.kernel.org>; Wed, 02 Dec 2020 02:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fTuf0Tq3Nk3Hz/H62CzsXzQ+usjzwNEUcAtQM0dax1I=;
        b=He6LAobv7pIGm6cFESTrmOZd3szD4tklgwUo/AQxE03MEtQiKPeARQ0h2DfcFeKXCP
         6Pl2+Xb+pygW7AWaGuYaS6GdGN01CaU2DAkcMN03MuQmcqmS8c9ZoEHP7HNbdCuWIYhH
         04ktiwPOW9gpm9wfsza/YOQe6E5dS2J/VkFk/fOmnYQiW5853p9APM2gWRBaLzZ2qsJu
         pk2VMuY0gcppxA9Rk1R/2AOUvhjzgt3QozNCVCpO7KREYNW13SWEcvQv8FSQgbQN/rxj
         02unEaA87JdTPDv/sFvR93ltoJRg77j1uF4ULtAMtRKbJxRpKn1hHNQ6Ea+rGIVye1h2
         soKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fTuf0Tq3Nk3Hz/H62CzsXzQ+usjzwNEUcAtQM0dax1I=;
        b=epGVPD5mKOszvTmPtRXNNFgHnWVgYj8y0RD2T7Lrb2HYoNAS0DdXdSFgFGV8zooo3V
         Hrq2FYyOAYKACrsReSSqHEbtWjtealzDcM/1zEZXZqB3mjhN6iwOQZEZuHdZiBpka+6g
         ghJkXhZDW2noys1nJ0l3LkH8z5BqQSQO20497l6o5sUQ5p/26oURIiyEyRJhedCITtxd
         ACoq1Pgc32Q1K+dklmnZrzHmWCLmGTw71JkbmcYIwsEY/4ASeG2Nw+li+jOG/s052NLL
         GPM5XRHyaJJhNg/4MYAacQzD19xNTx8B2sjhhrmUt76Vekv+NjatdbqQKKlrPf0NqF5f
         ThMw==
X-Gm-Message-State: AOAM532u1SKZkq6EIhvnIi7rJcSFoHMNos7iHmBdTGJ3qPVXnRFzF5LV
        aEiyrWOpz39P0VjieKHKaGn3fWlqgvQD6tiJqr0=
X-Google-Smtp-Source: ABdhPJz71arfLP+AgJ0CwwW+GvZktxtzY5ivIBTxO4H+zG2R0wEYdaWY7Osuk/fTEdn87zECjmUwEqiJAZXRoyoDJLc=
X-Received: by 2002:a92:c5a7:: with SMTP id r7mr1609854ilt.219.1606903262568;
 Wed, 02 Dec 2020 02:01:02 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtkt6-ezyTC6zoi+DBjYQ3qFwW3UneF0_4qETEt51Tm9w@mail.gmail.com>
 <CAH2r5mt+=ELCwSASFsPPjET=qf80_1tOTMPN-gG9cF=BQd-VBg@mail.gmail.com> <CANT5p=rXznKiOK0mGa+K00vsi2siTLiniKKD3M62QeKSAUj58Q@mail.gmail.com>
In-Reply-To: <CANT5p=rXznKiOK0mGa+K00vsi2siTLiniKKD3M62QeKSAUj58Q@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 2 Dec 2020 20:00:51 +1000
Message-ID: <CAN05THSm8oe3dhjLiisiQTw_iyhsp=OC-dv0Bi7Ld+_b+rBp6w@mail.gmail.com>
Subject: Re: [SMB3][PATCH] ifs: refactor create_sd_buf() and and avoid
 corrupting the buffer
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Dec 2, 2020 at 7:52 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Friday, I made similar changes as a part of my changes for sending
> default sec_desc, while testing against Azure.
> The idea is similar to Ronnie's patch. Move the owner and group SIDs
> up and push down the DACL.
> In addition to the changes Ronnie made, it looks like the 8-byte
> alignment is required for few of the other offset fields too.
> Hopefully, I'll have it tested out by EOD, and send out another patch.

Nice, but what types need 8 byte alignment did you find?
MS-DTYP says that for self relative security descriptors that padding
is not required.
(section 2.4.6)
If this is the case we might need to involve dochelp.

>
> Regards,
> Shyam
>
> On Tue, Dec 1, 2020 at 9:54 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Updated patch with fixes for various endian sparse warnings
> >
> >
> > On Mon, Nov 30, 2020 at 12:02 AM Steve French <smfrench@gmail.com> wrote:
> > >
> > > When mounting with "idsfromsid" mount option, Azure
> > > corrupted the owner SIDs due to excessive padding
> > > caused by placing the owner fields at the end of the
> > > security descriptor on create.  Placing owners at the
> > > front of the security descriptor (rather than the end)
> > > is also safer, as the number of ACEs (that follow it)
> > > are variable.
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> -Shyam
