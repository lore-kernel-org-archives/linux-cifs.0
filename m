Return-Path: <SRS0=R0d0=ZW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D68C432C0
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Nov 2019 19:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E62F22073C
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Nov 2019 19:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575141212;
	bh=cDYVb5kDkrKl0RAihyqpkO8cbNcl97ywThIY0JA4uuo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Crs2OWG99vGKHBuyE0KsGythdMH6ghunDbUf6gl7JJtm67f4fz+Ac+Lqin2OTlx+h
	 uwIjXhF1h5iDvGIcgLblorY9O8stYCNxpvcDjfzIjCUbOy9UAczwi9uDU6NM5uYLov
	 a8hQW0qrJlFNbRd8iWFKhDRSEo7T8rcNRlfOc6iQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfK3TNb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Nov 2019 14:13:31 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35856 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfK3TN3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Nov 2019 14:13:29 -0500
Received: by mail-lj1-f196.google.com with SMTP id r19so1581407ljg.3
        for <linux-cifs@vger.kernel.org>; Sat, 30 Nov 2019 11:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1LVgMGL6TsgB3lm4PtejpFpxtB2Ve5gBgTZF/idEeYI=;
        b=GioxllDGT2eS886RUhKNrSfKjQ9P2TXZy5xyeCNfQvcb8FQ9FwWw565sT/eUWR4iWB
         BUuKChkLMnBQ4PD7kE0pjmsryOGaRW9T3Jyfd0e6SZs4RfSyU2DyOYZMVpryGG18viWW
         xfdV4jJho2gJjKH/dAiyTqJzFPNjh7Abp2D0A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1LVgMGL6TsgB3lm4PtejpFpxtB2Ve5gBgTZF/idEeYI=;
        b=liYZQTHkIF0H8X7P3CEo9hCjf2oN0Kl4PjgLRNnFHWNTS6lF2FmMfdRDSs2eMcQBjK
         ObANxi+YX3iGNAp2TaXcopBadfl/ddARYhuKdQsMJd4VcDSyhgivlIvsdKab5+QDZ35w
         +zWe3iq5mR+irNd6ACTP6cZ4EAqTt87JzYDOEbEcmeTtEmTq3D4aPTG8+qXftRA3rcBa
         8uN6R8tnpTvfw38WQNHA80PZE9/CM/uiZtQm1iNRaIpV6B4/qv8bIU/LGFdsCI0cOIW7
         MOIcGpJMGWeab0SPq8QeWwl2bphpexPC4sjdTPZylvJv9wX8o9v4Kt86bP41mhaX9AqB
         hywg==
X-Gm-Message-State: APjAAAWssCO7gBHuR1RyHfF+7D+3l7pIfoqZF4cH7hGacVQDUSccrvDT
        a1zi3ePTHTwXhpIpSHItXkLBqtGGbdU=
X-Google-Smtp-Source: APXvYqw90MGD8BpA1DWFbuZXhhMqMJZd96f8Cab0e/VL7+Jfi21yxZDI/xjiohds2qZ1PSxtm4KHTQ==
X-Received: by 2002:a2e:9194:: with SMTP id f20mr41283039ljg.154.1575141206702;
        Sat, 30 Nov 2019 11:13:26 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id d4sm11873891lfi.32.2019.11.30.11.13.25
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Nov 2019 11:13:25 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id r15so22002465lff.2
        for <linux-cifs@vger.kernel.org>; Sat, 30 Nov 2019 11:13:25 -0800 (PST)
X-Received: by 2002:ac2:5a08:: with SMTP id q8mr38766418lfn.106.1575141205423;
 Sat, 30 Nov 2019 11:13:25 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtDpwY=MrQ=yN29JeWUqf+ozgYvgnzbnb91VoK8Vg4Zmw@mail.gmail.com>
In-Reply-To: <CAH2r5mtDpwY=MrQ=yN29JeWUqf+ozgYvgnzbnb91VoK8Vg4Zmw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 30 Nov 2019 11:13:09 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiy3Bh5c6mCYSzxOL63oQWO40s1PNM9q6hD46M3wPKR_A@mail.gmail.com>
Message-ID: <CAHk-=wiy3Bh5c6mCYSzxOL63oQWO40s1PNM9q6hD46M3wPKR_A@mail.gmail.com>
Subject: Re: [GIT PULL] CIFS/SMB3 Fixes
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 27, 2019 at 3:49 PM Steve French <smfrench@gmail.com> wrote:
>
> Various smb3 fixes (including 12 for stable) and also features
> (addition of multichannel support).

That's a _very_ weak explanation for many hundreds of lines of code changed:

>  23 files changed, 1340 insertions(+), 529 deletions(-)

Please spend more time explaining what you send me, so that I can
write better merge messages or what is actually going on.

                Linus
