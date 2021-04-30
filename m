Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225E6C433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 10:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4AF2613D9
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 10:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhD3Ku1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 30 Apr 2021 06:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhD3Ku1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 30 Apr 2021 06:50:27 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0539FC06174A
        for <linux-cifs@vger.kernel.org>; Fri, 30 Apr 2021 03:49:38 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id r8so348207ybb.9
        for <linux-cifs@vger.kernel.org>; Fri, 30 Apr 2021 03:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R4KAnFdhO6G9CsLlE8ofYr9Wvrlqqlmn4GSTm1CHprE=;
        b=tzX9prW4tzXNxOGq4dhJQgQi7ZXWEQEpwm1GygumzbBfSJRNLtpeqDpedfz/LERYCe
         teQ3BuybYZlCU8b3fbzzLwCusltvkax9/c+dotT3CFmLx7AArnOWevJa53P6RBOhXimv
         j7E7JXEaWt/rf/y74Ghp6wslAy24MLAoOZj9SS0X+Q85827IvD5uHHp+PWoJBDpg8ymF
         GWPWm6cOrUlMR1x8JwBhspYWtrMP0Yws3g8qFQPD+fh4pWZ1jJwXDSmcBFTFGkVtICku
         DyrvK7weucoDUNhARBkA6aYCi/u4euegkMpBnTzNV+tJrDpioMY2+mhm4vhdwYCJAM+o
         N+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R4KAnFdhO6G9CsLlE8ofYr9Wvrlqqlmn4GSTm1CHprE=;
        b=gJbwL8znsuw7pcpEVG9EUY8TLQr9l4ql09XVGEFh9ZCEnRvZbTFNsgH6Wru63PU1VM
         3w5G2RdUsDEZpC3WYovoRm87NmlfRzGxZoN0GMe8/hC+06KVgdLS00xAIg3++vIu9+CG
         6snr5errqrNTqW+ZD5jLcd5KbtL5DZBy4c5QdpH6gqEvxhsl7KezaBeoR6WJiMFGOjIm
         JsNkoj06pLEFn5qt1mWiLuEu/qV0K4Inm0eWIEjwgLiwVJdBuIl+Xj8cSQ/mNA78mD9T
         k7tMekYTt7y8AXUxOZuV9uo7Jo609H+bPaEcvOOIzwZaRdYagy01AjZ7oiLNNC5I3sdc
         gFeQ==
X-Gm-Message-State: AOAM530TaT1JktasnVDpHECxjmbyg6ezCFfT0hRSNQjvjT3nbsqyS/Vv
        iW9EXZXx8uOB5dupLRFJnd5jaJxuPpO95A9HCJY=
X-Google-Smtp-Source: ABdhPJyyeRRDXZmqU5J8rRPQIk3+wo4TLkxcqlRbrpmoNYWBZ/WuYePr+RtGI/u5y6Z9HhQIME5na/dqGuO+Vv2xKTM=
X-Received: by 2002:a25:b84a:: with SMTP id b10mr3441301ybm.327.1619779778050;
 Fri, 30 Apr 2021 03:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org> <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
 <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
 <CANT5p=qVq5mD2jfvt1Ym24hQF9M-aj1v1GT2q+_41p1OTESTKw@mail.gmail.com> <20210426115457.GJ235567@casper.infradead.org>
In-Reply-To: <20210426115457.GJ235567@casper.infradead.org>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 30 Apr 2021 16:19:27 +0530
Message-ID: <CANT5p=rHgmLdHJm_y3CCpb=KoEbnJApce2wx4hORY2CwHP2NbQ@mail.gmail.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
 of readahead
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Matthew,

Sorry for the late reply. Still catching up on my emails.
No. I did not see read-aheads ramping up with random reads, so I feel
we're okay there with or without this patch.

Although ideally, I feel that we (cifs.ko) should be able to read in
larger granular "chunks" even for small reads, in expectation that
surrounding offsets will be read soon.
This is especially useful if the read comes from something like a loop
device backed file.

Is there a way for a filesystem to indicate to the mm/readahead layer
to read in chunks of N bytes? Even for random workloads? Even if the
actual read is much smaller?
I did some code reading of mm/readahead.c and understand that if the
file is opened with fadvise flag of FADV_RANDOM, there's some logic to
read in chunks. But that seems to work only if the actual read size is
bigger.

Regards,
Shyam

On Mon, Apr 26, 2021 at 5:25 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Apr 26, 2021 at 10:22:27AM +0530, Shyam Prasad N wrote:
> > Agree with this. Was experimenting on the similar lines on Friday.
> > Does show good improvements with sequential workload.
> > For random read/write workload, the user can use the default value.
>
> For a random access workload, Linux's readahead shouldn't kick in.
> Do you see a slowdown when using this patch with a random I/O workload?
>


-- 
Regards,
Shyam
