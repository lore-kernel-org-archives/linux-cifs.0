Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE35C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 18:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B72264FBB
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 18:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCJSJB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Mar 2021 13:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbhCJSIv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Mar 2021 13:08:51 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60DBC061760
        for <linux-cifs@vger.kernel.org>; Wed, 10 Mar 2021 10:08:50 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id r3so26880466lfc.13
        for <linux-cifs@vger.kernel.org>; Wed, 10 Mar 2021 10:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yub35a3naysHpuxKxqimjEZvpxVU7RGTFJJiIk/NnNw=;
        b=kYJuT4E4rSRJD5k94kWcJ6IqGR6D519qytPgZ8a6uwY6ChFRMp/aGaIZBAeb51iT4K
         EFiWXvXRC6SHdv2kdgQ+n96vHUKoQgsqSkMBWmT6NRaw9iIhNxYR386JvgHRb3XTJmSq
         W15c8VBPnFK31F2FSXT6v1LAKx/GZjbrNt2Ygp6fBsSIm+eVXvTpddm+wvlAnnZO0uwc
         30MlsZwoS6aSWIIngoTmqLDhz8eKB765KoD8Nit3x0bEHax1O7yQtQ5R1HArMD7bbfWP
         ST14ONmbI2LKrHbfTbIoH7GrsDSnNpY5Mia4kk8Ib2y2nk25xMUt7UsmjTqoqpAUKmqM
         ryiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yub35a3naysHpuxKxqimjEZvpxVU7RGTFJJiIk/NnNw=;
        b=YduHJiE7InJjzTy0Jc7zdp2k4bAX34oeYNnFI9OqVvFcLzO8XKXfPoVe3maTM9Te5Z
         OBTPInvB2wrR+A9uSCa7uM3h16NduLg9Wk3tTUvuowB5dFJuHQVSFnZm0CgqbFQ4iavr
         aYmZDZcjWC/oMUkjRpMDdSTE+9IhsiCalkbKYHAQyDrYl8dCtGzwyN/DxnQWIOzCggMq
         ix4RQg1tyC3UszILo3LiQEx9zqzC/Kr8xoH70zUA7bfRkliFIhmb64Vlsg0NhUdZ6EOS
         VmjCghGuiWqoFtAMoF+Qp8cke7gRA+D5x+5An0ubKg7kGwB4wEfiSSswDWPYiRTH0Uj0
         QGuA==
X-Gm-Message-State: AOAM532YYEAPggFrQeEeu5dPEA6LqRmGzaSwhjUexEndgg8iz7zFWQbc
        9Q0qxcn+/cMRrIg5p8jHKK9CyFOTawxl/uwq42gEXcnZ2v0=
X-Google-Smtp-Source: ABdhPJza5yIvSDQVKv2pSSyk1O5stXGIaFXKfAGMThpr4ztNDGptMOSZvghIZR64Yuw5VIZ8sbMg7YxoSvMW7mslOo0=
X-Received: by 2002:a05:6512:1284:: with SMTP id u4mr2858012lfs.175.1615399729385;
 Wed, 10 Mar 2021 10:08:49 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=o0sV5XjLw1D-9L3qnWwy4DV7WF3QOrHJ8hc5gPVjNj5Q@mail.gmail.com>
 <CACdtm0Z4Qj1ehiPs7nu+aVDsoLob0GXTe7SGqmrkeTA=WWZhKg@mail.gmail.com>
In-Reply-To: <CACdtm0Z4Qj1ehiPs7nu+aVDsoLob0GXTe7SGqmrkeTA=WWZhKg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Mar 2021 12:08:38 -0600
Message-ID: <CAH2r5ms7zTQ-GXPPPbe+3HoucDE3NvbT7K7JPcCAzr6=nNs28Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: update new ACE pointer after populate_new_aces.
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Test 317 will require additional changes for test 317 when run with
cifsacl (to map ownership) or will need to be run with winbind or sssd
- but I verified that it does fix test 317 for idsfromsid,modefromsid

On Wed, Mar 10, 2021 at 11:58 AM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Looks good to me.
> Reviewed-by: Rohith Surabattula <rohiths@microsoft.com>
>
> On Wed, Mar 10, 2021 at 11:14 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > Hi Steve,
> >
> > Please consider this fix for the failing generic/317 test for cifsacl
> > and idsfromsid,modefromsid.
> > This is exposed on certain combinations of default ACEs on the file.
> >
> > --
> > Regards,
> > Shyam



-- 
Thanks,

Steve
