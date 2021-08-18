Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB883C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 16:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD05360EFE
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 16:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhHRQaE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 12:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhHRQaB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Aug 2021 12:30:01 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE7DC06179A
        for <linux-cifs@vger.kernel.org>; Wed, 18 Aug 2021 09:29:26 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id d11so6201753eja.8
        for <linux-cifs@vger.kernel.org>; Wed, 18 Aug 2021 09:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lx2mQZ//Ii6+5mpE/8cN+N2w2n4hvMHo49+Kx6QlYoc=;
        b=EfHMTAV3oXYc/2BYTKgl/fTgK/tvHEVzrvRu3pWThHwyOd07j5VsCeORdLbwf1wI25
         39+oMF0w+FCS1aR5zSZ3KIs/YMJ3g3peu3+pTFueOkkXjtM+7pwNIF9Bf1c0HEu6fKwc
         RYU7+Tn2xLUBhKEm2tGi0UX5SOAmQi39/diEOODj52iOOeLn19NpiRLqz+DIvBHQIEOx
         4PwjkbYxOlEWWaHCbMbKL8mcNRG3fyheJIgMkchjc6Jdn1RqKfUe6X1rVpsEKLk0E24q
         GXzF5BaskLE0ieiXQVYKbMs6U4PCJFGNGHa/WpqrzDXQKzCGm84E5G9ytZZ/JWGoPTD7
         Ah6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lx2mQZ//Ii6+5mpE/8cN+N2w2n4hvMHo49+Kx6QlYoc=;
        b=nFftIYJGdwYXrQRNo3Cetp/hkmBHHg45uzAkwcyDwfaBEYkcOwngKh4o7oJSP8ZaWl
         rspQJVmvbHlMladLCGP7345lTopVRRDxVPYpL8Ta4/qT1aiX8+RAzHLj5om8DJnf56+1
         9GbvDxKfV6UWE5oGZOCnQEGQWs79bZL19rPR89oCeXoEbRvLEkBoahFdw1PWXre5U6PY
         pAFWMvUz2ps3YbzduReNjRtMhGcAsGfe5xfq5yNBZSb/QKnoSpYd5fKJisZ1WBVyW3oC
         /YYBT6lQS8bkkhEWN7aA5ZovMiFEkD8uedqWLYe3t7du8PQ/iJhiQY2k5YTKjb24WXDR
         VLsA==
X-Gm-Message-State: AOAM5304rmRo4HSnppGvCSAH8ftceS227tWFJSDXBwVrIpk2d081SS0m
        9ctCFMyk8UEdBgwTT9J5tmM4+lStGGUmtTtOoRI=
X-Google-Smtp-Source: ABdhPJxQpJF8sX3ssccRZmf6IQoOIB3MaOXGCdTDTasT/wKKPrjxy3AjkpEMMbD7apk1W0oqYqxNmEdAvRk6pNnliUU=
X-Received: by 2002:a17:906:3782:: with SMTP id n2mr10301504ejc.368.1629304165056;
 Wed, 18 Aug 2021 09:29:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210818041021.1210797-1-lsahlber@redhat.com> <815daf08-7569-59ce-0318-dfe2b16e1d96@talpey.com>
In-Reply-To: <815daf08-7569-59ce-0318-dfe2b16e1d96@talpey.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 19 Aug 2021 02:29:13 +1000
Message-ID: <CAN05THR_Y+uoER=iNiwoiZ0yPcJ2T-LvRqOew59G53SafUMg3g@mail.gmail.com>
Subject: Re: Disable key exchange if ARC4 is not available
To:     Tom Talpey <tom@talpey.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 18, 2021 at 11:18 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 8/18/2021 12:10 AM, Ronnie Sahlberg wrote:
> > Steve,
> >
> > We depend on ARC4 for generating the encrypted session key in key exchange.
> > This patch disables the key exchange/encrypted session key for ntlmssp
> > IF the kernel does not have any ARC4 support.
> >
> > This allows to build the cifs module even if ARC4 has been removed
> > though with a weaker type of NTLMSSP support.
>
> It's a good goal but it seems wrong to downgrade the security
> so silently. Wouldn't it be a better approach to select ARC4,
> and thereby force the build to succeed or fail? Alternatively,
> change the #ifndef ARC4 to a positive option named (for example)
> DOWNGRADED_NTLMSSP or something equally foreboding?

Good point.
Maybe we should drop this patch and instead copy ARC4 into fs/cifs
so we have a private version of the code in cifs.ko.
And do the same for md4 and md5.
>
> Tom.
