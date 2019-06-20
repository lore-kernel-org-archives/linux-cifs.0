Return-Path: <SRS0=yIrz=UT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110CBC43613
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jun 2019 12:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 997202083B
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jun 2019 12:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="EJC8QwYi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbfFTM5g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Jun 2019 08:57:36 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:20143 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfFTM5g (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Jun 2019 08:57:36 -0400
X-Greylist: delayed 3637 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2019 08:57:34 EDT
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x5KCvU8B027065;
        Thu, 20 Jun 2019 21:57:30 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x5KCvU8B027065
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1561035451;
        bh=DXG5y81lrP/RKhO89tmCKKnh3jfXbbbg+RNGm7NGto0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EJC8QwYiu9oojxw2/ID1Tp3EKITOxmledi91rGucVgHRQVO3zsYe27eDyBg4VUQAM
         iGD1AkT8gXLaWrbERv5uPyNkVw6AgA85T2cTFGAqGqZbxgPXDvdDiWyodnzo1n2z99
         YV1lmbPIuVFcv9p8/6b8Ce5yD3UuKwD2tOIz3lqqjhhs0hxMIsWvX+dMOsMZ5BpZrX
         K0rVbcW/VF3BUjLOf4AUlFZxZ1BSKMwHJ1Q9X0R1dzh03shD9JSBMc1pdFuKIAe6FL
         ly80hNgR0yN/sU/mzZ3nRC3MkT5/NLpVa2ENXoBkpHZrucgm1RoUgAz96cRBelEix6
         xhuKX8dgEDxZQ==
X-Nifty-SrcIP: [209.85.222.46]
Received: by mail-ua1-f46.google.com with SMTP id o2so1561738uae.10;
        Thu, 20 Jun 2019 05:57:30 -0700 (PDT)
X-Gm-Message-State: APjAAAX7xTX7NEsQx+t5tmvRcIrkpqKypVX/P2mffoqNvD9l/abdOOIa
        cZheLFOjLnfnCzyBR4yJxnWd1IhzQHPngeuCob4=
X-Google-Smtp-Source: APXvYqzrNTww1AguIyE54k4Jk1wXaMolaYxF4sdwNY72AKai7w9sRNS+zr4hfc+ni2hk7WglSUP5dibKqbIA9o2vU1M=
X-Received: by 2002:ab0:2b0a:: with SMTP id e10mr39239409uar.109.1561035449821;
 Thu, 20 Jun 2019 05:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190620064023.cwvcj5g4rgnmkmmn@gondor.apana.org.au>
 <9c994536a297449d843947ba9be05998@SOC-EX01V.e01.socionext.com>
 <20190620075838.sthw4kjpp2gt6t6j@gondor.apana.org.au> <CAK7LNATbMou4DHN9=POay4RGT6upj1RoUZPwfvaB7oZwqm5rfA@mail.gmail.com>
 <20190620124731.dpnocjhh5co2ab5g@gondor.apana.org.au>
In-Reply-To: <20190620124731.dpnocjhh5co2ab5g@gondor.apana.org.au>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 20 Jun 2019 21:56:53 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQrdkUYzDVEf5SERiNVquAyEjTrTL3tqw=1VGq=yumYUw@mail.gmail.com>
Message-ID: <CAK7LNAQrdkUYzDVEf5SERiNVquAyEjTrTL3tqw=1VGq=yumYUw@mail.gmail.com>
Subject: Re: cifs: Fix tracing build error with O=
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     stfrench@microsoft.com, linux-cifs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jun 20, 2019 at 9:47 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jun 20, 2019 at 08:56:10PM +0900, Masahiro Yamada wrote:
> >
> > The similar question, and the answer is here:
> > https://lkml.org/lkml/2019/1/17/584
>
> But it doesn't work with O=:
>
> $ rm -rf build-compile/fs/cifs
> $ make O=build-compile fs/cifs
> make[1]: Entering directory '/home/herbert/src/build/kernel/test/build-compile'
> make[1]: Nothing to be done for '../fs/cifs'.
> make[1]: Leaving directory '/home/herbert/src/build/kernel/test/build-compile'
> $

You missed the trailing slash.

I suggested 'fs/cifs/' instead of 'fs/cifs'



-- 
Best Regards
Masahiro Yamada
