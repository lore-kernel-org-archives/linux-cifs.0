Return-Path: <SRS0=2csP=X4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7770C10F14
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 15:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA5B320700
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 15:35:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="nefoQvKO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbfJCPfB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Oct 2019 11:35:01 -0400
Received: from condef-05.nifty.com ([202.248.20.70]:38864 "EHLO
        condef-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729763AbfJCPfA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Oct 2019 11:35:00 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Oct 2019 11:34:58 EDT
Received: from conssluserg-01.nifty.com ([10.126.8.80])by condef-05.nifty.com with ESMTP id x93FOI36005091
        for <linux-cifs@vger.kernel.org>; Fri, 4 Oct 2019 00:24:18 +0900
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id x93FO8qd009730;
        Fri, 4 Oct 2019 00:24:09 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com x93FO8qd009730
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1570116249;
        bh=Dmv6s+uqyytUyC6g7SzMJmF4FwfXF9kOMKIAKnBwkSk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nefoQvKOH5/pGzV2/xAzoODhtmlFBoPgwbsMBMEHkOo0mkyOkEQr12Yqdt5NgzIun
         lBnvIOTRmbewYxm/PIclCJ9F/9jxUyFu8Ee+g1CM7rsVTQIpwUGSWK6WcpzS4pUf+7
         I1Hrnj2xeDMA5nf6mcbrN8SsCh61jFMumLMIHbhObwOJU8qt5rpt0vKBDTIBvSsA4k
         CLMCGzrh2odfbYtWT3C17S5Fjtr3cKu0/+wFTmbGrVTvW9L1i6399EWZqAdKLNMZfb
         UljwUE/HSK9CUVbSZQtx+JuHTRcQgX7qx5dJ0hRwekNohUKLn9QuLffdsT2BY0iuDS
         uvAO9TEUcLD5A==
X-Nifty-SrcIP: [209.85.217.45]
Received: by mail-vs1-f45.google.com with SMTP id p13so2015802vso.0;
        Thu, 03 Oct 2019 08:24:08 -0700 (PDT)
X-Gm-Message-State: APjAAAUYcV50U1zkH2Txs0yiMfjRtA5fhpAb8zWXZAKfqesDv3uuczEE
        3/jKirYEdZ42LJ7vyYszoNRF8e6INLQP3J27VHc=
X-Google-Smtp-Source: APXvYqxvoBS3AJJguZgQfhgLU2Y+1tfOH0OISGkhyAcw9LZHzEx/rEES/e9/5moqmDFKGeTciS63ATAwjhr8A/N0y8w=
X-Received: by 2002:a67:7c03:: with SMTP id x3mr5489693vsc.155.1570116247531;
 Thu, 03 Oct 2019 08:24:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv49T9gwwoJxKJfkgdi6xbf+hDALUiAJHghGikgUNParw@mail.gmail.com>
 <CAH2r5mtVW=3-2L+0QFJAqBG+uj2sYmF=dtzT_kqwK59cu94vGw@mail.gmail.com>
 <20191003104356.GA77584@google.com> <CAH2r5msF5DF2ac+-V0xRR-8RYeQdwpsS1iBLHM6iKTB+aEVc5Q@mail.gmail.com>
In-Reply-To: <CAH2r5msF5DF2ac+-V0xRR-8RYeQdwpsS1iBLHM6iKTB+aEVc5Q@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Fri, 4 Oct 2019 00:23:31 +0900
X-Gmail-Original-Message-ID: <CAK7LNARrdQad9=U1LknT9yRYtRagNVS8T5r_Ovv5Sa91QO3TsA@mail.gmail.com>
Message-ID: <CAK7LNARrdQad9=U1LknT9yRYtRagNVS8T5r_Ovv5Sa91QO3TsA@mail.gmail.com>
Subject: Re: nsdeps not working on modules in 5.4-rc1
To:     Steve French <smfrench@gmail.com>
Cc:     Matthias Maennich <maennich@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

On Fri, Oct 4, 2019 at 12:15 AM Steve French <smfrench@gmail.com> wrote:
>
> On Thu, Oct 3, 2019 at 5:43 AM Matthias Maennich <maennich@google.com> wrote:
> >
> > Hi Steve!
> >
> > On Wed, Oct 02, 2019 at 06:54:26PM -0500, Steve French wrote:
> > >And running the build differently, from the root of the git tree
> > >(5.4-rc1) rather than using the Ubuntu 5.4-rc1 headers also fails
> > >
> > >e.g. "make  M=fs/cifs modules nsdeps"
> > >
> > >...
> > >  LD [M]  fs/cifs/cifs.o
> > >  Building modules, stage 2.
> > >  MODPOST 1 modules
> > >WARNING: module cifs uses symbol sigprocmask from namespace
> > >_fs/cifs/cache.o), but does not import it.
> > >...
> > >WARNING: module cifs uses symbol posix_test_lock from namespace
> > >cifs/cache.o), but does not import it.
> > >  CC [M]  fs/cifs/cifs.mod.o
> > >  LD [M]  fs/cifs/cifs.ko
> > >  Building modules, stage 2.
> > >  MODPOST 1 modules
> > >./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
> > >make: *** [Makefile:1710: nsdeps] Error 2
> >
> > Thanks for reporting this. It appears to me you hit a bug that was
> > recently discovered: when building with `make M=some/subdirectory`,
> > modpost is misbehaving. Can you try whether this patch series solves
> > your problems:
> > https://lore.kernel.org/lkml/20191003075826.7478-1-yamada.masahiro@socionext.com/
> > In particular patch 2/6 out of the series.
> >
> > Cheers,
> > Matthias
>
>
> Applying just patch 2 and doing "make" from the root of the git tree
> (5.4-rc1), at the tail end of the build I got
>
> ...
> Kernel: arch/x86/boot/bzImage is ready  (#87)
>   Building modules, stage 2.
>   MODPOST 5340 modules
> free(): invalid pointer
> Aborted (core dumped)


Right.

Since 2/6 depends on 1/6,
applying only the second one does not work.




> make[1]: *** [scripts/Makefile.modpost:94: __modpost] Error 134
> make: *** [Makefile:1303: modules] Error 2
>
> With patch 2 and doing make M=fs/cifs nsdeps from the root of the git tree I get
>
> $ make M=fs/cifs nsdeps
>   Building modules, stage 2.
>   MODPOST 1 modules
>   Building modules, stage 2.
>   MODPOST 1 modules
> ./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
> make: *** [Makefile:1710: nsdeps] Error 2
>
>
> --
> Thanks,
>
> Steve



-- 
Best Regards
Masahiro Yamada
