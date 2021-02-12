Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168B1C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Feb 2021 20:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D493E64E35
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Feb 2021 20:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhBLUFx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Feb 2021 15:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhBLUFw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Feb 2021 15:05:52 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23792C0613D6
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 12:05:12 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id v24so1174802lfr.7
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 12:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nExWR88RkPeOkqISGn/jpVoXJu9W7N0qKFDCio4UzKU=;
        b=U5PQPNXrgUjJcMKwLFquE94Fo6SR6+QexZmX+lUZ54tGZpEYsW/pFvUfW9NzR3s02L
         3RxyCVEarkwE9pjzzkd2fYKmSf8YglBxbWhUCf/C7d+fRAlmTXehalOyLy3peBXnrtZv
         PHDZzrCWgToC8mkDkPlgx3Cw5gRjWLX5H65BM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nExWR88RkPeOkqISGn/jpVoXJu9W7N0qKFDCio4UzKU=;
        b=gp8tcj5NoXRW5sbEJPgCHLaRSQe+OlL+3sC1jaMJgOztpHWx5GyRRxD9+5KExvDzt4
         k27yW2L14/5ERdwDt4B2ASiXMb0Ozdx1hQ5y31kpEAXlc6M/FmUkQU3BhuCqMho/diWA
         +L9Wx0EzpDJ/v7Cp/pRlCCZshjyjxD7Z1zaFTeFPgAWpjHy0fBHXb8kX5Jla0NI+yuqW
         qoiy7nkmXGAOoOtjeCQl98e0WeohzMTGFiN3xa9e+iN2TH7T2E16gL1LaB/kjCzh+fnA
         gOZUbCX2X+rFMd6i47iy72eMQNfvauz4WcGr5fKwdWSqdfQDsa8QBowuopm7pKcnpLng
         Jx+g==
X-Gm-Message-State: AOAM530nrb8kP2KXc7CcCYVz/EQby9VY4bMCg3xFFXhwMreF5u747fJ4
        OsGpenB5Dm82nCg2RvOyMAkSa+wIZtZXHQ==
X-Google-Smtp-Source: ABdhPJwEdVIsCECamD3SNHzBexsUwICa1ceQmWj7Ep0vLRWw+Aky3kVb3uBLSYIuvnFQJxrFB/yxUg==
X-Received: by 2002:ac2:5ec2:: with SMTP id d2mr2442544lfq.1.1613160310290;
        Fri, 12 Feb 2021 12:05:10 -0800 (PST)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id q2sm1385924ljg.67.2021.02.12.12.05.09
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 12:05:09 -0800 (PST)
Received: by mail-lj1-f170.google.com with SMTP id a22so451936ljp.10
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 12:05:09 -0800 (PST)
X-Received: by 2002:a2e:8049:: with SMTP id p9mr2544160ljg.411.1613160308969;
 Fri, 12 Feb 2021 12:05:08 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
In-Reply-To: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Feb 2021 12:04:53 -0800
X-Gmail-Original-Message-ID: <CAHk-=wja1Y8r5UKrmXcMFrS=VPkTPbkyK-vt8B9MBkEU4+-WLw@mail.gmail.com>
Message-ID: <CAHk-=wja1Y8r5UKrmXcMFrS=VPkTPbkyK-vt8B9MBkEU4+-WLw@mail.gmail.com>
Subject: Re: [GIT PULL] cifs fixes
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Feb 12, 2021 at 10:16 AM Steve French <smfrench@gmail.com> wrote:
>
>   git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc7-smb3

It looks like git.samba.org is feeling very sick and is not answering.
Not git, not ping (but maybe icmp ping is blocked).

Please give it a kick, or provide some other hosting mirror?

           Linus
