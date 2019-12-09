Return-Path: <SRS0=ClyU=Z7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51280C3F68F
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Dec 2019 03:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 232082071A
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Dec 2019 03:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575861379;
	bh=MdXAeM4nIuesUS1DGhu6YwaHYJFsIoKaB8559f5xhAI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=WFUtnNBSaaP4MvYXkFmFZ1bSVWpKeZr/7XI/Yp8atuMx4L6aROfSJyQfhi1sDtRDD
	 gSpfes7IyQGL2fwG3xSn7ivsbvmG22do4WyOkjcp3CBIn5H6YSz48cnNOwHNP+6vOi
	 rD9UW2Q67ZEndK+0r87iGtXL8PYsxkjSHJO7P+/8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfLIDQS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Dec 2019 22:16:18 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40901 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfLIDQS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 8 Dec 2019 22:16:18 -0500
Received: by mail-lj1-f195.google.com with SMTP id s22so13870336ljs.7
        for <linux-cifs@vger.kernel.org>; Sun, 08 Dec 2019 19:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0eZBzbT0umg6+Hs7q0Pnqxg4tmozetMjiZRECdwYTQ0=;
        b=MWuYxiKb2CdwSMwdcUQLL2uhffAmgdvG0nK6gTfcO2CRxV0EDyfH78R4RWl7nvxi1m
         VPXqRvcP3Y1Rqmgt4bq1b5gQp3Tim9naBLL3rs+ghsEI+/WZ7HKpaPQpBj88BYdb/5Ic
         a5Y6pc+UVsIzS8JCmTj5F9uNcZYYFBKeLkqJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0eZBzbT0umg6+Hs7q0Pnqxg4tmozetMjiZRECdwYTQ0=;
        b=sTvrNADiflIs2z/5CyWvG9pP2ZgC30sqLiLNU0TginfyDaduHU1yYhtYYqwt1Ld9fW
         ph4GkxVsoz+wpheNUwnjc0Tzf3PJXhaaDCXRT5+bbXrpY6loYuPtutkvdxRaB8wtf80E
         2jM6T8haMu+q7AepIErEAnnOslQ3u+nwz+2uX0ULpe77n7I4sL/8Tk6r1dx1puB4eMP9
         yrwSIWB4Xk0cvmm1auBp2U+UXDLYlkf/Hzf82xE5jRVlrL3E9BYuiRczOQPu4YuXx0wC
         3n2beOv6SFnX4hVyZLI5V3Uq6Ygnn8L85sKJ3p0Lk6rPYlcKLg3P/fJTjajtWVtaxLmo
         IEXg==
X-Gm-Message-State: APjAAAWeCUDW79Ofwr3CVu0tzAg5IHAwTgO7OTalMbEhZtFG9QT4IgU9
        Z5NAivPqOshLSNyVGozDPVpcL/HSC+E=
X-Google-Smtp-Source: APXvYqx0J+Qq9iiALuyhM3N52Biw0GtS0P4y0MAqKKJw+UmLUbB8oeSHvF9MgBT08nh18IQ+5MCPdQ==
X-Received: by 2002:a2e:85c9:: with SMTP id h9mr7112762ljj.155.1575861375598;
        Sun, 08 Dec 2019 19:16:15 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id s16sm4603373lfc.35.2019.12.08.19.16.14
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2019 19:16:14 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id n25so9512727lfl.0
        for <linux-cifs@vger.kernel.org>; Sun, 08 Dec 2019 19:16:14 -0800 (PST)
X-Received: by 2002:ac2:50cc:: with SMTP id h12mr13797909lfm.29.1575861374341;
 Sun, 08 Dec 2019 19:16:14 -0800 (PST)
MIME-Version: 1.0
References: <30808b0b-367a-266a-7ef4-de69c08e1319@internode.on.net>
 <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net> <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
 <20191209025209.GA4203@ZenIV.linux.org.uk> <CAHk-=whY0GL-FpnjUmc7fjDqz-yRJ=QBO7LT6aEzt-_raAb1bw@mail.gmail.com>
In-Reply-To: <CAHk-=whY0GL-FpnjUmc7fjDqz-yRJ=QBO7LT6aEzt-_raAb1bw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 8 Dec 2019 19:15:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=whyQ-Ets2v3bg7eP8GAGpzA7f2pqyiw5tPj8HFoxFcEjw@mail.gmail.com>
Message-ID: <CAHk-=whyQ-Ets2v3bg7eP8GAGpzA7f2pqyiw5tPj8HFoxFcEjw@mail.gmail.com>
Subject: Re: refcount_t: underflow; use-after-free with CIFS umount after
 scsi-misc commit ef2cc88e2a205b8a11a19e78db63a70d3728cdf5
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Arthur Marsh <arthur.marsh@internode.on.net>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Dec 8, 2019 at 7:10 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> You're right that at least the CI bots might want to disable it for
> bisecting. Or force a particular seed for RANDSTRUCT - I seem to
> recall that there was some way to make it be at least repeatable for
> any particular structure.

Yeah, if you build in the same directory and don't do a "distclean" or
"git clean -dqfx", the seed remains in
scripts/gcc-plgins/randomize_layout_seed.h across builds, and the
result then _should_ be repeatable.

But yes, it's the kind of noise that is likely not worth fighting for
bisection (or any random bug hunting) at all, and turning off
RANDSTRUCT is probably the right thing to do.

But I don't think Arthur had RANDSTRUCT enabled, so that should be fine.

            Linus
