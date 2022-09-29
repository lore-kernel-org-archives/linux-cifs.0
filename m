Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC1EC6FA90
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 02:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiI2CVt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbiI2CV2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 22:21:28 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCFCA98DB
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 19:21:08 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id j123so131958vsc.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 19:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=G0IB4cERIjDubE/xAafwN6NbpwiDJ1PlVPq7IDnhcQg=;
        b=dw70rxsuGIGolXCkAR0nsZJ9nodYBeRM6P/blmaVLqtsORxA5ke8vLCQWHC1ivbdQK
         SlSWG7HwaanPnf7pGWsM3iGGMBVIZ4BsgLAJEfpGtA5BkZtCgYPcDwnqGq0BROrc9m9X
         wQVUQhfW4ntiPycV5usbsRURdjJkFodLcVBlI6emN0whFn0tbiifVIQcyYBozZeqG7IJ
         3p7gg+9z997P7Fwc/5M02NqeBL73kZUJiGqCwlEqPeHyt50Segg5o++gqLM8LtY1qEl+
         jrsmIwLZD8S0n4EP+MmzB2oVFcK7mY5Tcj8+yyWx9vqwRjQj6/I9GJ2KS7Vb5Jb6W+ZG
         kdvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=G0IB4cERIjDubE/xAafwN6NbpwiDJ1PlVPq7IDnhcQg=;
        b=Je/DikdlRpVGoLsnYS7sUL2ekodlWUxfBX6RvPRnpo+YOj6Sv+eXK7QYTGcxb87ayf
         xWPm6OVrUj6AZIolwAEyKp1Uyi+1o73FolbzUW5bQJZx73u3irisvnL2VDqV70qKQM5N
         9ukz1hsZwNjXBIs7dh6WH0FUBlOxEiEXpxOB8/kKr2jlPFHCwyFUraZw6FX9zAZYVfjV
         rf8hIWy0P3e/tJU0UDXj5vfzxaq6e0+CaH0tbTk/8/JW0BFWnHYBWjgQTEX8hRaR4WMx
         PPjYwzWMwlvsI11n8R1460qvs+N74Vo2ZPuE0d/I/Wt/xZgF5iTqKcrV8OzScPxxwdCe
         5X1Q==
X-Gm-Message-State: ACrzQf2sstllfrHRvY/0YUf9sVgCc+SOXGWkx7O7Cjf+PCDkMCaTWbxk
        ivOr8MTrdTwBJdcTD77v9HwAvsIR8uB1QmJJutXe+m1AzwI=
X-Google-Smtp-Source: AMsMyM7FZR4QblmC24N0J2/SeyVStSbVhllg4SWbDcz9WTBnP8wz7ugDasfHiB7KkBdTYmP2lqmWyHqL+0jzfXolR3o=
X-Received: by 2002:a67:f705:0:b0:39b:ff07:108d with SMTP id
 m5-20020a67f705000000b0039bff07108dmr282191vso.60.1664418067023; Wed, 28 Sep
 2022 19:21:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtg603usx5f=-+U6S-Lv5oWKjoxFpmKUC6xMq-XB2gTxg@mail.gmail.com>
 <CAH2r5mu2aGmf0uM6GBAV8zhA2rUiJ_nJ1CEP631J+KrWadOeLg@mail.gmail.com> <CAN05THTN24JMTgsthX3fghkyFDEjmBOH9qpqCpennPXEb+68pw@mail.gmail.com>
In-Reply-To: <CAN05THTN24JMTgsthX3fghkyFDEjmBOH9qpqCpennPXEb+68pw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Sep 2022 21:20:56 -0500
Message-ID: <CAH2r5mvxz8cse34T0w6XNvmUwxK6Of7miGVfxsBmr2J+UQgz9A@mail.gmail.com>
Subject: Re: Buildbot: builder cifs-testing build 1038
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rerunning with one more patch from the series removed (remove "find
and use the dentry for cached non-root directories also")

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/1039

Includes:
fcb583e8d3e0 (HEAD -> for-next) cifs: enable caching of directories
for which lease is held
41b019f780eb cifs: store a pointer to a fid in the cfid structure
instead of the struct
9af47dd06bfb cifs: improve handlecaching
c3c380942b69 cifs: Make tcon contain a wrapper structure cached_fids
instead of cached_fid
27d5d2bb788e smb3: add dynamic trace points for tree disconnect
bb44c31cdcac cifs: destage dirty pages before re-reading them for cache=none
09a1f9a168ae cifs: return correct error in ->calc_signature()
d7752a6c60c2 MAINTAINERS: Add Tom Talpey as cifs.ko reviewer
c3b6eed31f44 cifs: misc: fix spelling typo in comment
f76349cf4145 Linux 6.0-rc7


On Wed, Sep 28, 2022 at 9:04 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Thu, 29 Sept 2022 at 01:56, Steve French <smfrench@gmail.com> wrote:
> >
> > ---------- Forwarded message ---------
> > From: Steve French <smfrench@gmail.com>
> > Date: Wed, Sep 28, 2022 at 10:16 AM
> > Subject: Buildbot: builder cifs-testing build 1038
> > To: ronnie sahlberg <ronniesahlberg@gmail.com>
> > Cc: CIFS <linux-cifs@vger.kernel.org>
> >
> >
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/1038
> >
> > Theories on the xfstest failures with the first five of your six dir
> > lease patches?
>
> Interesting that the git tests fail.
> Remove the last patch you have in that series for now  and I will
> investigate it in a few days.
>
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
