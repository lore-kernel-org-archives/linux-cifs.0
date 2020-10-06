Return-Path: <SRS0=Y/WD=DN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1ED4C47095
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A35C2078A
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:54:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oNsCy8g6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgJFFyG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Oct 2020 01:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgJFFyF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Oct 2020 01:54:05 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CD5C0613A7
        for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2020 22:54:05 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id n6so5296899ioc.12
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2020 22:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NpCrmllG71Cw+19EzjfgNasiTicD2S0gRmtQXvQeCWk=;
        b=oNsCy8g6LXt6CCbSnIawPxwBDSQhaqL86RTRcMYe+XwVHaw8VCmsRmxQNO3ErsREgG
         xYp7lVRXPKjAuoaXmeveMASZ4ViXefKqwzZJUw8TnvyMrq54+0PC5PALTiAgxHRQfmGV
         HcSHGHVjqTdYhCU+CnYEXn1VnMesvI5pd/4QrQLiY9Cb3thHan7Km/TN15Ks3tQFwcBV
         iawXnu8AslZ2bzwIx26vDvvybXWZK19wOn99Sy4m6oPg1s6suQaJmZZ8Ir1Ij42t6YkQ
         DMA7DNAsnvjK/Dc/mRW6UhdNBIeRnPb2mYCvxdYTyHvCJv6FqNfwk+I5S6SQJcuwRHnD
         cEiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NpCrmllG71Cw+19EzjfgNasiTicD2S0gRmtQXvQeCWk=;
        b=ip6y/KchP4xZECqeazbSUH1T2Gy0792eX5sHucwKbwi9wqxG9TnYOMvyZ1a5qxZEon
         4ylSRbvBJOPUY0feEFP+my2XZ2PE6IRaOtPWGKWYtoOoYs/INg8oYOt90A6HgQX6zcuc
         hk8wvWxQLj1gWax1hu8JiyuKySsB+4valFW6Gm92fNgYqgyTlw0kncNa6wpi2TRcvNnG
         0GI73/RMcuAfOIfTA//Wj2Xk4tw02ryD14ZWy8UjnBt5qimzwPSBZssKfU5oBgDHXykE
         t18qCSuGgsQGw5yeAreD1gHZ0zzK7yV/+hnzx+k9VOweCWdlM3xwFlwxmtfWMrwL//nM
         XQAQ==
X-Gm-Message-State: AOAM533I4a8dorglqvM5mw2NQWD0jPiuyn3+zm6c4+CAgXkK5sFptav1
        6rgxjc+Qplrtpe452NcIUGr+ZxLa7di/X3Jj79A=
X-Google-Smtp-Source: ABdhPJzXhjKqftv6+KAmsqu9mBfUQ34AEq0pz+5ZPq9HrutLkrWBcENhn+antI7hP2FoqEgZVyMpkw7gX5EnEq/VG74=
X-Received: by 2002:a5e:9613:: with SMTP id a19mr2681975ioq.116.1601963644898;
 Mon, 05 Oct 2020 22:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oUOsR---hHYF2k0smsq+qu7K4W3hUYXD2-c3D_cCsf1g@mail.gmail.com>
In-Reply-To: <CANT5p=oUOsR---hHYF2k0smsq+qu7K4W3hUYXD2-c3D_cCsf1g@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 6 Oct 2020 15:53:53 +1000
Message-ID: <CAN05THSL9WBtaKaWVn7NJtzV90dtxghqHiGU4NBCB71ms_JNvg@mail.gmail.com>
Subject: Re: ENOTSUPP to userspace
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Oct 6, 2020 at 3:25 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi,
>
> Recently, we saw one customer hitting an error during file I/O with
> error "Unknown error" 524. Since this error does not translate to any
> error using strerror(), it was quite confusing. Only when I saw that
> in errno.h in Linux kernel, I could see that this error corresponds to
> ENOTSUPP, which we return in a few places in our code.
>
> I also noticed that there's an error ENOTSUP, which does translate to
> a userspace error.

After a quick look, we do not use ENOTSUPP a lot.
But there are three places in transport.c that look suspicious.
They all trigger if we run out of credits for an extended period and
from a brief glance it might be able to leak ENOTSUPP to userspace for
almost any syscall.

I think this needs to be audited. The places are
wait_for_compound_request() and wait_for_free_request().

What to do here is not obvious. We could retry in cifs.ko but we can't
do this indefinitely since when we have no credits
for an extended time, every syscall will become a new thread that gets
stuck in cifs.ko waiting for credits that might never become
available.
So maybe we should rework this and return -EAGAIN here, push it to
userspace right away and hope userspace can deal with it?

And if we decide to push -EAGAIN to userspace we might do that right
away without any retries in cifs.ko since if we have been at zero
credits for a long long time already chances are that retry will not
work and we will remain at zero credits for a long time more.



> My question here are:
> 1. What's the purpose of these two error codes which look similar?
> 2. Who should we talk to about having corresponding translation in strerror?
> 3. Should we be returning ENOTSUPP to userspace at all? The open man
> page says that for ENOTSUPP: The filesystem containing pathname does
> not support O_TMPFILE. Is this the only reason where we return
> ENOTSUPP?
>
> --
> -Shyam
