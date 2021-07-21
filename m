Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38CFC636C9
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jul 2021 17:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6A7C60FF3
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jul 2021 17:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhGUQ2h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jul 2021 12:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhGUQ2h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Jul 2021 12:28:37 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A088AC061575
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jul 2021 10:09:12 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gb6so4323133ejc.5
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jul 2021 10:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=fcB0b9OnXwiSLahFiMezwWcBXoM+Dk63RiEUDbB8wxg=;
        b=hAumjq8KLBkLHVdm/Xu+ECFyoDgO1IQ1hxb6Ug7gZwFIB+WI7FSWgycI27eKpB1GUB
         Rk1VSwfJJPloNNvKux7q728d3UxxuEQGHCTqhvaRBivyQjUmKpkMt2Hb7VDdow+hZQfu
         Av8C/1X3lsZfydhx4hOMTXsjl+9ebANcUBbgyviqEAFJPaN/uFclB0XlzkUcz+a02/jf
         pi/akRUShhCKmqI32rX4W7AsoTewiPMlRnlrF7Og2aB2qunDOOPpHQWZkqPq8kSk2i7s
         pSsm2lZcerP9rYOyvXZqC9qB4fMPRKLcKdYam5RYKQtPoDH1KdsjtpYMZTjC6TotfAUk
         3vFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fcB0b9OnXwiSLahFiMezwWcBXoM+Dk63RiEUDbB8wxg=;
        b=UE95rShe2XnBOgwfqQSZ62F0vpwxMn1nq/verAx9kZF5jZbtHF8um8iInkpYSXctTG
         3NRsZ6GWOciayvK6CtgetGGSFBfHsjNXLWuiadVubcyQUzHA7Ng+tqFYRiBilzK/P5xH
         rZa+kzsdOERz7vO5/L6JYqMXxUj/c52oiiOjeINO7B+Y8HCuLUs3Jb9TjdhYWykgrRA4
         E1tBwGOL8Ye2K5vs6D6N+EFXszzMV1kdL8jRXaoyJxsp0SxFV4FvFy67rCTkEewyTI0r
         jYMQ98HizfnUkWLmydY0rY1f3ff2x24Z3Jo9Fc3uJHViSJdWje3Hz4V6BVrX7HOgPDgB
         pngQ==
X-Gm-Message-State: AOAM531qKWLOeJVXMCyzSG25Nu2ewy3J4FxllMnz6t3+HkAbnMY76KoJ
        Nq65Fyhhu1hAr2k4nLxeXttt2e6h/TlAH6BdYy0=
X-Google-Smtp-Source: ABdhPJxuwCmv1Kn6t3ffygt7zZ58hVTRmhOLBn0h06/Nd5A/i+1YQrzXL3GRBy4rtcxhWL6njiK8MskNelmk8y+5rEg=
X-Received: by 2002:a17:906:63ca:: with SMTP id u10mr29296046ejk.411.1626887351188;
 Wed, 21 Jul 2021 10:09:11 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 21 Jul 2021 22:38:59 +0530
Message-ID: <CANT5p=p+f6mrQqKULqJdbyDN-NJoQCsGruvVMH+BUJU0-n62rg@mail.gmail.com>
Subject: Classification of reads within a filesystem
To:     Matthew Wilcox <willy@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Matthew,

I had a query about a filesystem's ability to differentiate readaheads
from actual reads.
David Howells suggested that you may be able to answer this one. If
not, please feel free to add the right people to this email.

In a scenario where a user/application issues a readahead/fadvise for
large data ranges in advance (informing the kernel that they intend to
read these data ranges soon). Depending on how much data ranges these
calls cover, it could keep the network quite busy for a network
filesystem (or the disk for a block filesystem).

I see some value if filesystems have the ability to differentiate the
reads from regular buffered reads by users. In such cases, the
filesystem can choose to throttle the readahead reads, so that there's
a specified bandwidth that's still available for regular reads.

I wanted to get your opinions about this. And whether this can be done
already in VFS ->readahead and ->readpage calls in the filesystems?

-- 
Regards,
Shyam
