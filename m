Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75990C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 17:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34D2F60201
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 17:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhBYRZR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 12:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhBYRZQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Feb 2021 12:25:16 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C7CC061574
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 09:24:35 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id u125so5522652wmg.4
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 09:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EK02vbDhS3wbLOl6TYczf2PM3ezTw7wQjxU6JZk2d0k=;
        b=SAevHF6hhs7FjUAOc9IrLTm5nvkmoTyjLrOAFH47mlAv/nASmwLYW0xYjzCOpfHCJf
         VlxnKgSpNrXn6v6IsEXXbZ4ulhrDlH5znaGwXIHXuKhy5chse6FM82D6HK0FrQiJVGfl
         f7breI+//LALSEC99fmG+SIzr1wJA9gli7DGqlfA9yBA7oE6ZodHKr0U+msdvKJgUQ7X
         sBU0W6bHaZHO/hdgoe3FeUP3Jdn+0lMkmkdV9W0yClq826SL8pFRk3HZpbQlTD7oRTRH
         VzCBVmpAO1raQmvuMPjKhRv9zwCVn6Z6q5V0a1nm1KCewRUnu9x1l3Bk09oi8hxWADPQ
         x3ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EK02vbDhS3wbLOl6TYczf2PM3ezTw7wQjxU6JZk2d0k=;
        b=otvVQ4VLyALzOxhJKP+PYTlOzph8t0lqzlh0fzfX+RamDj2IzInAD50rFAjTPsOjec
         u8byL9YTxTloXNPnc2RZ1eoUv7TiYSrELrbGCRBHCwQj34f21i5uPlE6nZLXjyjZ2RgT
         5fLjhkKHsl6Hz3AdQpsk9aVMKS0ZcMcZi7U9p8iyGsR0E0nZ1N4bMhLuqzv7hO4FZ/2G
         AGfPT+A0MI/pbaWlO95EmGY2wUC6NEvPzP3y0hKyjGv6L2FoNEXjtKQBhO6ITpcBkmRl
         sz3xcdpovTNI6fJBWj4hCnsc1A7NN07cIVW1Ae+tjVhyCeDyNrCihfMk577ilzG4jjB3
         Q0dg==
X-Gm-Message-State: AOAM530mShokoZflgmWQWMEYZYv0hEdmRYps6hj68fWcf/WRUS8hHNB7
        sJR1JEH2xFVI8NNetC/95gFG+k+bJ/LrJu0N0j8=
X-Google-Smtp-Source: ABdhPJxOcCtzSPwg7yP3l3wsDoxAiIo+4zlc8JoAElQd+4Nya2+hYUrm5ATBMy2MZWqkcEpTBAoHraQSVdUR+fSp2fI=
X-Received: by 2002:a1c:7e4e:: with SMTP id z75mr4269599wmc.168.1614273873949;
 Thu, 25 Feb 2021 09:24:33 -0800 (PST)
MIME-Version: 1.0
References: <0736dea6-ab54-454d-a40b-adaa372a1f53@www.fastmail.com>
 <CAN05THRTEXjZ+TQB+X2kA_i8CgKctBDB1UhbifAu0WzqHOuNmw@mail.gmail.com>
 <cd9f90aa-53f0-43a2-9683-b5730d01ca90@www.fastmail.com> <CAN05THQfXstKOvVMN-KGBk6bdkUaQCa_4CY9o5oXn_qDhdW9-w@mail.gmail.com>
In-Reply-To: <CAN05THQfXstKOvVMN-KGBk6bdkUaQCa_4CY9o5oXn_qDhdW9-w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 Feb 2021 11:24:23 -0600
Message-ID: <CAH2r5muZ0Dc=1dR9oO5+N0wZ5KM1KjePk_yD-f5SpodS9eZmXw@mail.gmail.com>
Subject: Re: Using a password containing a comma fails with 5.11.1 kernel
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Simon Taylor <simon@simon-taylor.me.uk>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Feb 25, 2021 at 3:34 AM ronnie sahlberg via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> On Thu, Feb 25, 2021 at 7:18 PM Simon Taylor <simon@simon-taylor.me.uk> wrote:
> >
> > On Thu, 25 Feb 2021, at 7:37 AM, ronnie sahlberg wrote:
> > > Hi Simon,
> > >
> > > Looks like the special handling of escaped ',' characters in the
> > > password mount argument was lost when we
> > > switched to the new mount api.
> > >
> > > I just sent a patch for this to the list,  can you try that patch?
> > >
> > > Thanks for the report.
> >
> > Hi Ronnie,
> >
> > Thanks. Your patch resolved the issue.
> >
>
> That is good to hear.
>
> Steve,  can you add a Tested-by for Simon and maybe we should have cc
> stable so it gets into 5.11 ?

Yes - agreed


-- 
Thanks,

Steve
