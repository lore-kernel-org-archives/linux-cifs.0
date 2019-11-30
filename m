Return-Path: <SRS0=R0d0=ZW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA20C43215
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Nov 2019 21:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B70602075A
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Nov 2019 21:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X5WaM+IY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfK3VUP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Nov 2019 16:20:15 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:42779 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfK3VUP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Nov 2019 16:20:15 -0500
Received: by mail-io1-f67.google.com with SMTP id f25so9894744iog.9;
        Sat, 30 Nov 2019 13:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NbOkOAsiiOjamOjJqITROUWM1WjDallWI/CL6nXDDWc=;
        b=X5WaM+IYr0X8/nF6gmcecUSKqP61OObhlUcs61f+iELjVbB9YvqEHioXS3nouQxr/R
         Jd98e1SLXedIb6Vg6bw8YS15jpGhRjw5D7e/ngcaj8DviIZ3/TIMlat3I8RiuyUcz4lS
         klTNSoHNTFqrCnbYctMIZTzMs6QbI9SwASjsGqi3vaNSfR0yK2bxAbpBe+7RMsTl70D0
         UYiSRz1jsP7tBf58+lol/JeaZ1qPKbBXy1xUgycZqCql1lgrsqJNhUR2wnLAcxlZP8Om
         RRd2P0dgQzQwVGYvdLwHN9bUjplZ1CsCzL9QkiBsqgyhx05Bym9rqR4e8R5+EhGGOpAS
         Xmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NbOkOAsiiOjamOjJqITROUWM1WjDallWI/CL6nXDDWc=;
        b=oRLSDB+UvWhvVhEXtygFkQFt5K4jQ3uYpA+gqqMWv/D3Q2QeBKy11Z2ZLZxUodnIA3
         6lBURrVNlqzoF2JGndKntpVCyNIN9xGsFuKmm1U+X8ybxfI66x/6V38n3kne4+13A6nJ
         3mtI5aGPoEBCtRaiSPsF+zvNteMCv5j3vYPWCU7ti1vD35i3fwZWtN7/AbtbpQ2oJkri
         jl306AYuvHS76f3WAtISQa/6v84ugUgyHqDMsRMpyJwOIibr0nutekJatmImRzNQ8ogc
         VzOks557vZ4WxlX9cUyCmKQGK2cpu1mZw+MUe/aeukKDk9JIn2Cmg0Dii92i7SbDg+iK
         m8ow==
X-Gm-Message-State: APjAAAX30niO0QfVGBKOR8pzBc2ayinQRv5h0YOeu0FFioxVWhJYjN0Y
        Zcc4lksyhFLCTAsjOAd0z0ncQeaFF5KBq7Qd7TOFLQ==
X-Google-Smtp-Source: APXvYqwBORWr8IdF9/z/AmkxTIZedBNklTNEuFR4EgxV2ImrMwzl0FAnvT8no/nrr3x229YTK9alrK+CQX74QtKGCw8=
X-Received: by 2002:a6b:8d11:: with SMTP id p17mr4258661iod.3.1575148814828;
 Sat, 30 Nov 2019 13:20:14 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtDpwY=MrQ=yN29JeWUqf+ozgYvgnzbnb91VoK8Vg4Zmw@mail.gmail.com>
 <CAHk-=wiy3Bh5c6mCYSzxOL63oQWO40s1PNM9q6hD46M3wPKR_A@mail.gmail.com>
In-Reply-To: <CAHk-=wiy3Bh5c6mCYSzxOL63oQWO40s1PNM9q6hD46M3wPKR_A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 30 Nov 2019 15:20:04 -0600
Message-ID: <CAH2r5muv535qCrzLZ_ZiEa=nc1=pis=xX2nYLaUVLS59DdD7Lg@mail.gmail.com>
Subject: Re: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Nov 30, 2019 at 1:13 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Nov 27, 2019 at 3:49 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Various smb3 fixes (including 12 for stable) and also features
> > (addition of multichannel support).
>
> That's a _very_ weak explanation for many hundreds of lines of code changed:
>
> >  23 files changed, 1340 insertions(+), 529 deletions(-)
>
> Please spend more time explaining what you send me, so that I can
> write better merge messages or what is actually going on.

Sorry about leaving that out. Will have more detail in subsequent
pull requests.


-- 
Thanks,

Steve
