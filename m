Return-Path: <SRS0=yIrz=UT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1437DC43613
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jun 2019 12:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E80BE20675
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jun 2019 12:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731743AbfFTMri (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Jun 2019 08:47:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:45742 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731729AbfFTMri (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 20 Jun 2019 08:47:38 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hdwTW-0001yT-RK; Thu, 20 Jun 2019 20:47:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hdwTT-0004hJ-Cw; Thu, 20 Jun 2019 20:47:31 +0800
Date:   Thu, 20 Jun 2019 20:47:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     stfrench@microsoft.com, linux-cifs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: cifs: Fix tracing build error with O=
Message-ID: <20190620124731.dpnocjhh5co2ab5g@gondor.apana.org.au>
References: <20190620064023.cwvcj5g4rgnmkmmn@gondor.apana.org.au>
 <9c994536a297449d843947ba9be05998@SOC-EX01V.e01.socionext.com>
 <20190620075838.sthw4kjpp2gt6t6j@gondor.apana.org.au>
 <CAK7LNATbMou4DHN9=POay4RGT6upj1RoUZPwfvaB7oZwqm5rfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNATbMou4DHN9=POay4RGT6upj1RoUZPwfvaB7oZwqm5rfA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jun 20, 2019 at 08:56:10PM +0900, Masahiro Yamada wrote:
>
> The similar question, and the answer is here:
> https://lkml.org/lkml/2019/1/17/584

But it doesn't work with O=:

$ rm -rf build-compile/fs/cifs
$ make O=build-compile fs/cifs
make[1]: Entering directory '/home/herbert/src/build/kernel/test/build-compile'
make[1]: Nothing to be done for '../fs/cifs'.
make[1]: Leaving directory '/home/herbert/src/build/kernel/test/build-compile'
$

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
