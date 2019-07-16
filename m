Return-Path: <SRS0=queM=VN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505E1C76191
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 03:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2378220693
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 03:09:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bL4jbgYY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbfGPDJw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 Jul 2019 23:09:52 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:33861 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbfGPDJw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 15 Jul 2019 23:09:52 -0400
Received: by mail-io1-f46.google.com with SMTP id k8so37678758iot.1
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jul 2019 20:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sFV7Lzloxa0WMeO4aQ8eBW2VyFIHf9UYmWEYqxnfAUM=;
        b=bL4jbgYYQZpb34J/JJkr8gwtaAY6pxaJwyAkROuGwJa1vryR+rN93U5NIkBAnaKHeC
         nU3qzLenhTPIvk2VlKZFHjcPERClfk0pL5jl3BljQB1LBF5f/PnUAtsY3sj386HH63Ju
         9e8ZOs2UepXaMw/M4H4Tr1ypl49Mp0pN15p7l7Sk/Ad8lFQGr+/8GGWIST3Xg21RfNqE
         sHI6zlYO5OVVxij4fWnvfdeUiX3Apy+PWI/Cl+9qh9h5em26Xkn+8xhD9tgMrhT+yN4i
         n8uPvrTs2c3VncHzk3qYBf4/F4CBQN4c8jnM0Pz6zHyxW8/5PyQg91ztib3fq6fvtkYK
         0dOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sFV7Lzloxa0WMeO4aQ8eBW2VyFIHf9UYmWEYqxnfAUM=;
        b=NFS3/WoYEwtFn4/vVGGJEM06ogMd+azIN/1pfQ0nOm8D9purcdWgSY6QKKB/11aB7x
         Lm/lcP2F9Y35yhs7uYUSx3oc4MlNKTjpmPWqDRDJQo4r64N2w4cerYZh1EOhv9wvsaCW
         8ZTrWF1oNK18QIbKC65LBZTMd4fmLV/GEwSskC/H2yQxFDXOKDWuDs6Uc/R/GxdT7+AY
         AyHuNH3veDV+iYbizVFDJjGrr8fvSvKB9GcWYK4D+PWH7eXEFkna/bWaivq1DvwtXxDt
         FEx2hlXopkSq/p1D6l7ouBKi/xcZQuP891JVmZNmEGg/RPc7hilDuHQyoL+y9SFqSkOw
         /DvA==
X-Gm-Message-State: APjAAAXv8Mz10bFSa8XKoKyNLvS+Vmj30hxIrW3e/PULxfx6z22kyhEA
        xPieHB6rjSHziz1c9XCy9BqcxwYELvtzs/kkh7kktA==
X-Google-Smtp-Source: APXvYqzQaoVfCsI3y3P9L+tj/JUaXxowhmckpah1ELJ3z5UfQOsSxMsSK7I2R7art43MjJdbY99eU738mTSgXJqnxb4=
X-Received: by 2002:a6b:dc08:: with SMTP id s8mr28947288ioc.209.1563246591547;
 Mon, 15 Jul 2019 20:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtkLjmjiT7QYLsGKqVHwx4JBU5=e68gTEztQ5BDCg0PWA@mail.gmail.com>
In-Reply-To: <CAH2r5mtkLjmjiT7QYLsGKqVHwx4JBU5=e68gTEztQ5BDCg0PWA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 16 Jul 2019 13:09:39 +1000
Message-ID: <CAN05THSaUDRLyXazvL=Pao103AuJ0obqHPKsDrizZqpC7j=apw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] CONFIG_CIFS_SMB_DIRECT no longer experimental
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jul 16, 2019 at 1:06 PM Steve French <smfrench@gmail.com> wrote:
>
> Long Li has made good progress in fixing remaining xfstest results
> over rdma smb3 mounts

Acked-by: me

>
>
>
> --
> Thanks,
>
> Steve
