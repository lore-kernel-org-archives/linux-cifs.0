Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9818AC83F29
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Aug 2023 04:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243893AbjHaEWG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Aug 2023 00:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242702AbjHaEWF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Aug 2023 00:22:05 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7449ACEE
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 21:21:51 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9a1de3417acso343578766b.0
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 21:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1693455710; x=1694060510; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PHb9iCWiCKsZWNp88MghqnJTU1cLcLheiIAV94LFPoE=;
        b=SsVeHgTMLgD4H/3iftGRkc1CZsqgO8j9eMJ2qNDMcDGrfwwOzCn3eRYp97xfoPxU1j
         h/KkM9+pW20uvlyVYB3KQJ7Q4cljuShH6YnwaajxY6TzXNi6JqurOsR3oEZ6G4Cub4LL
         BYxiz2mFaWOYhGEfmTlYj/hjzRMv49Y9U75BM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693455710; x=1694060510;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PHb9iCWiCKsZWNp88MghqnJTU1cLcLheiIAV94LFPoE=;
        b=Mm9aEEAR2nEe6WL58nWcoxuqfKPQWeNNp0fNE8cbPwhaOLxomPAzKz8Wj1HIKYFN+w
         +BWVCqM1lqrfHT2tHmlPH+kKAbSLYiS6oVyi1yZ9C4X/hBnkY8yV7BkgWpmkMa6Gi6sN
         Mx6SbYIv3iFf7YA8sHRaze1wTZgYTmIRPLEfFaR1gnBBvoQDFuQZgv7SfHynrcyEGnxb
         +1s5Glpy/Sd5fl7cTMkT1R8WPKJZEkthKYnMzPIqCPIn102r3A2bPFuLiDovwZGi8zsO
         dpl5au9QiH2xfK9vOyxRcev46L33+0GJ5Pr0CFBdTSDVzBoqkyV/F4hQyQ0gDsCEXTTY
         wuWA==
X-Gm-Message-State: AOJu0YyE843nq9UT8BYuZAgMDFXBerrzNCh3d20xVjKr0RlauPbQQHBX
        NYS3QDxexses45BnSjnwo+DDuL0xYmacHYStIPRYVg==
X-Google-Smtp-Source: AGHT+IEyNIqSGaifOsc3AgiKQJf8/KBoutHoqms6UFzSPpNmhagAgc0s2Uz+B2gTb1c7DJkNrekYMg==
X-Received: by 2002:a17:907:3e9c:b0:9a5:aa43:1c7c with SMTP id hs28-20020a1709073e9c00b009a5aa431c7cmr1769640ejc.26.1693455709898;
        Wed, 30 Aug 2023 21:21:49 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id b6-20020a170906d10600b009a57d30df89sm282273ejz.132.2023.08.30.21.21.48
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 21:21:49 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-51e28cac164so3331413a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 21:21:48 -0700 (PDT)
X-Received: by 2002:a17:906:310a:b0:9a5:f038:a4c1 with SMTP id
 10-20020a170906310a00b009a5f038a4c1mr1825108ejx.26.1693455708372; Wed, 30 Aug
 2023 21:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtpOtiP3Hk6FJPav8tYDhKJTQmELP31zYzVxf4DPNKbiQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtpOtiP3Hk6FJPav8tYDhKJTQmELP31zYzVxf4DPNKbiQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Aug 2023 21:21:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiCPoGieS-hkV+ze6UqvzNyPNT7WoD_v54ZuVwi-d5Bmw@mail.gmail.com>
Message-ID: <CAHk-=wiCPoGieS-hkV+ze6UqvzNyPNT7WoD_v54ZuVwi-d5Bmw@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To:     Steve French <smfrench@gmail.com>
Cc:     Dave Kleikamp <shaggy@kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 30 Aug 2023 at 13:48, Steve French <smfrench@gmail.com> wrote:
>
> - move UCS-2 conversion code to fs/nls and update cifs.ko and jfs.ko to use them

I've pulled this, but I think the new NLS_UCS2_UTILS config option
shouldn't be something that is asked about. The filesystems that want
it already select it, and users shouldn't be asked about a module with
no use.

The way to do that is to simply not have a user query string for it,
ie instead of

  config NLS_UCS2_UTILS
          tristate "NLS UCS-2 UTILS"

it could be (an dI think should be) just

  config NLS_UCS2_UTILS
          tristate

which tells the config system not to ask users about it.

Because users really shouldn't be asked questions that there is no point in.

And then, on a purely visual commentary about your pull request -
lines like these are just noise:

>  fs/{smb/server/uniupr.h => nls/nls_ucs2_utils.c} | 156
> +++++-------------------------------------
>  fs/nls/nls_ucs2_utils.h                          | 285
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

and the problem seems to be that you generate the diffstat in a very
wide terminal (where git tries to be helpful and give you lots of
detail), and then you cut-and-paste the result.

If you pipe it to a tool instead (xsel, perhaps), git will limit the
width of the diffstat to something sane.

Or, if you really want to use a terminal and cut-and-paste it
manually, you could try to tell git to use '--stat=72' to limit the
stat to 72 characters (which is the canonical "width for email", as
the Lord spake unto us all in rfc822, even if the Lord was confused
and also mentioned the number 65).

                         Linus
