Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5035C00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 17:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiHARX1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiHARX0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 13:23:26 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6431B62DC
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 10:23:24 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id 129so11969674vsq.8
        for <linux-cifs@vger.kernel.org>; Mon, 01 Aug 2022 10:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lTLkiIIy6pBQ7NS5UswG4WYMAbWMi1EXhdW0qles3io=;
        b=lIkP12logxtQf4xQPtez7PKZ7c21MMLK0AuVMQAUmAFQ9N7geQNEIbq2ZiujDAE5ao
         7IxXxLGuD+30gJmEseSbJW0ZTP00fzBG6rk10/kiWroK8oNKWU4eAFNISehhjpkZfVzT
         mHfG0XBJjyBhK1uW6J3GEOSFZ9aCzDgnCEuP/cSLl3nCn+g9mgnR8v5XLbD3MY2zkhOt
         mACNIVEJtLAzpnGLAXBH63I13+kS/rc+f9WA415YUq4l7Se8HAdT4jAVRPUR1/IgvR68
         +eZJT85WrzhEMJqA9XVGRDHiutBC+lw9KHjazW9sQv0ouOataUiKzoyreWeJzWz/TMR+
         FMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lTLkiIIy6pBQ7NS5UswG4WYMAbWMi1EXhdW0qles3io=;
        b=BqF7hhpSYQ+5E/WtyULx/tbKddEhuiLdemDcnBvDHTBD1CBB0dZZJJMGdU1G+sDOj2
         ynmxqH1d8NPxshTg02s6EP+rT7F9PZju/vHpEwAngVsAJYhw1b+7U0WoRFL3RObCRheJ
         gNNlDREqMtbJWgbral511ugAgtcOfmIO4A3FFiXK/HFZl+UynBIRodmHESxKCsU3Pxnr
         +qfA3KZPjUk2xJjXMojHIktQqz9UOAUTiWVNz9RkZaCOvl5YAScHz2aqK7IX9/b+2iAw
         BfMI9qfhtdVFyWRVIMfqbA7pRBUxx/00jpvo1KtIDHsy19wTftPFR5Nk785j4nkOaM0+
         xKhA==
X-Gm-Message-State: AJIora/rim5Y3abfN3qScUbhJcSI3optNVxwwzDsDdLFiLHYo3MxolMS
        I44b3JXiuRHQ0zNQXMJKsdIYk1ChrsC0KoSeUgE=
X-Google-Smtp-Source: AGRyM1s3i+UlzkMLHXrl3z0RN7UHr8j2hvEpKGB8ZczGBXJcvmDrcYIRDQ3q9wi7Yv+guxzZY54pZG8e2tmhyNna/iA=
X-Received: by 2002:a67:f943:0:b0:35a:2603:6c94 with SMTP id
 u3-20020a67f943000000b0035a26036c94mr6665431vsq.17.1659374603335; Mon, 01 Aug
 2022 10:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvX3UT0q50rmMb-WSt6eSxh1i_gcmPdDBW1x1Qn6ppDNg@mail.gmail.com>
 <CAN05THRJTvA7huZjuW-tCPZjk6Nq_8EasjP6kQ0BGMBxBCtgqg@mail.gmail.com>
 <20220801121507.zpcnz55jj2qre3kh@cyberdelia> <20220801123930.ltet3tadtdlf6hpq@cyberdelia>
 <f8632ab0-ddc4-ff8e-1bd1-3088cf05eb5c@talpey.com> <CAH2r5muP5ZgcsypLSFm1t2cE8x4n_8fmu7heoUiW5x2L6rN__Q@mail.gmail.com>
 <20220801171126.wotyb4mibyvrttio@cyberdelia>
In-Reply-To: <20220801171126.wotyb4mibyvrttio@cyberdelia>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 1 Aug 2022 12:23:12 -0500
Message-ID: <CAH2r5mu9-3CyRbcrhKLCNRyOUqUko=riO784y5dueDj6tce4-A@mail.gmail.com>
Subject: Re: [WIP PATCH][CIFS] move legacy cifs (smb1) code to legacy ifdef
 and do not include in build when legacy disabled
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Tom Talpey <tom@talpey.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Aug 1, 2022 at 12:11 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 08/01, Steve French wrote:
> >On Mon, Aug 1, 2022 at 10:49 AM Tom Talpey <tom@talpey.com> wrote:
> >>
> >> I think a big chunk of cifsfs.c, and a boatload of module params,
> >> can be similarly conditionalized.
> >
> >Good point - and will make it easier to read as well.  Perhaps I can
> >move most of cifsfs.c to smbfs.c and just leave smb1 specific
> >things in cifsfs.c so it can be optionally compiled out?
>
> I'd suggest "core.c" (but smbfs.h) so it doesn't conflict with module name,

aah - good point


-- 
Thanks,

Steve
