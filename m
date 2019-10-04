Return-Path: <SRS0=e7DE=X5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF186C10F14
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 03:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30A53207FF
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 03:41:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="0alpy7wn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387612AbfJDDlp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Oct 2019 23:41:45 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:52960 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387609AbfJDDlp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Oct 2019 23:41:45 -0400
X-Greylist: delayed 44248 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Oct 2019 23:41:43 EDT
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id x943fWY2009707;
        Fri, 4 Oct 2019 12:41:33 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com x943fWY2009707
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1570160494;
        bh=tsNv9PjAWMKsBmZiQ4rHHUiCG55Utym9hyikFYWrjgo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0alpy7wnjELo0LrwkzuFJ2Uu5/HkQByrHc2XPHOSBa7hDLJU7t9z0iq2P4LoZeIjz
         N5nIOcWY2nzGYjyM92WTFr81khgwp0n8lefSijXeO1TkvCZHgNivaKleJ34AXtzjBZ
         /VGJ+N0fE2OrjfUpwvCwuzy8Q5WyljF81i9NjjasKrFa7eHu9NdDoyE3edxx0eIKhl
         Tn+a4Q7X2xPme9Gn+hCGNlpVKfe66NZZDXGhrp2vpLpF3Qu48NT9IcSTpfEHsKJF2I
         rvW9Q/WhhGnDDxUb2k26bQOme31wjKhKrrJgOt6yFTn6S1j4YaPLXYYd7OZ3mPYHGZ
         jLnTSbzi3snNg==
X-Nifty-SrcIP: [209.85.222.51]
Received: by mail-ua1-f51.google.com with SMTP id b14so1626088uap.6;
        Thu, 03 Oct 2019 20:41:33 -0700 (PDT)
X-Gm-Message-State: APjAAAWuNAKbWeRxOW3ECMHgJeMNNGnGbxSXNZ7UV6Onc00m6vhg05zy
        WqgiYgQXOOI1UAxExzLay8vkWB3rSgHLhpxtVWY=
X-Google-Smtp-Source: APXvYqxDT+cVvkRb6+yYkfgFMPB2QpfRyp2c5b0GJLjFciXgHbBn1ZaWcMrlPFjRxUIkzoJyH0Weuw+VsgkCkIQA2xY=
X-Received: by 2002:a9f:2213:: with SMTP id 19mr454284uad.25.1570160492229;
 Thu, 03 Oct 2019 20:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv49T9gwwoJxKJfkgdi6xbf+hDALUiAJHghGikgUNParw@mail.gmail.com>
 <CAH2r5mtVW=3-2L+0QFJAqBG+uj2sYmF=dtzT_kqwK59cu94vGw@mail.gmail.com>
 <20191003104356.GA77584@google.com> <CAH2r5msF5DF2ac+-V0xRR-8RYeQdwpsS1iBLHM6iKTB+aEVc5Q@mail.gmail.com>
 <CAK7LNARrdQad9=U1LknT9yRYtRagNVS8T5r_Ovv5Sa91QO3TsA@mail.gmail.com> <CAH2r5ms_GdhAG4q3kcadeU44EQPjnebzBG8=DUcsi9Gh5J8UXw@mail.gmail.com>
In-Reply-To: <CAH2r5ms_GdhAG4q3kcadeU44EQPjnebzBG8=DUcsi9Gh5J8UXw@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Fri, 4 Oct 2019 12:40:56 +0900
X-Gmail-Original-Message-ID: <CAK7LNATLCG6DOsnqfFNe61NkcEHV1fS4fCWyy2qzMHVvDDHHHw@mail.gmail.com>
Message-ID: <CAK7LNATLCG6DOsnqfFNe61NkcEHV1fS4fCWyy2qzMHVvDDHHHw@mail.gmail.com>
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

On Fri, Oct 4, 2019 at 1:07 AM Steve French <smfrench@gmail.com> wrote:
>
> On Thu, Oct 3, 2019 at 10:24 AM Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > Hi Steve,
> >
> > On Fri, Oct 4, 2019 at 12:15 AM Steve French <smfrench@gmail.com> wrote:
> > >
> > > On Thu, Oct 3, 2019 at 5:43 AM Matthias Maennich <maennich@google.com> wrote:
> > > >
> > > > Hi Steve!
> > > >
> > > > On Wed, Oct 02, 2019 at 06:54:26PM -0500, Steve French wrote:
> > > > >And running the build differently, from the root of the git tree
> > > > >(5.4-rc1) rather than using the Ubuntu 5.4-rc1 headers also fails
> > > > >
> > > > >e.g. "make  M=fs/cifs modules nsdeps"
> > > > >
> > > > >...
> > > > >  LD [M]  fs/cifs/cifs.o
> > > > >  Building modules, stage 2.
> > > > >  MODPOST 1 modules
> > > > >WARNING: module cifs uses symbol sigprocmask from namespace
> > > > >_fs/cifs/cache.o), but does not import it.
> > > > >...
> > > > >WARNING: module cifs uses symbol posix_test_lock from namespace
> > > > >cifs/cache.o), but does not import it.
> > > > >  CC [M]  fs/cifs/cifs.mod.o
> > > > >  LD [M]  fs/cifs/cifs.ko
> > > > >  Building modules, stage 2.
> > > > >  MODPOST 1 modules
> > > > >./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
> > > > >make: *** [Makefile:1710: nsdeps] Error 2
> > > >
> > > > Thanks for reporting this. It appears to me you hit a bug that was
> > > > recently discovered: when building with `make M=some/subdirectory`,
> > > > modpost is misbehaving. Can you try whether this patch series solves
> > > > your problems:
> > > > https://lore.kernel.org/lkml/20191003075826.7478-1-yamada.masahiro@socionext.com/
> > > > In particular patch 2/6 out of the series.
> > > >
> > > > Cheers,
> > > > Matthias
> > >
> > >
> > > Applying just patch 2 and doing "make" from the root of the git tree
> > > (5.4-rc1), at the tail end of the build I got
> > >
> > > ...
> > > Kernel: arch/x86/boot/bzImage is ready  (#87)
> > >   Building modules, stage 2.
> > >   MODPOST 5340 modules
> > > free(): invalid pointer
> > > Aborted (core dumped)
> >
> >
> > Right.
> >
> > Since 2/6 depends on 1/6,
> > applying only the second one does not work.
>
> Applying both 1 and 2 I get the following error doing make (although
> it makes it a long way into the build)
>
> <snip>
> WARNING: drivers/usb/storage/usb-storage: 'USB_STORAGE' exported
> twice. Previous export was in drivers/usb/storage/usb-storage.ko
> ERROR: "usb_stor_set_xfer_buf" [drivers/usb/storage/ums-usbat.ko] undefined!
> ERROR: "usb_stor_access_xfer_buf" [drivers/usb/storage/ums-usbat.ko] undefined!
> ERROR: "usb_stor_post_reset" [drivers/usb/storage/ums-usbat.ko] undefined!
> ERROR: "usb_stor_disconnect" [drivers/usb/storage/ums-usbat.ko] undefined!
> <snip>
> ERROR: "usb_stor_adjust_quirks" [drivers/usb/storage/uas.ko] undefined!
> ERROR: "usb_stor_sense_invalidCDB" [drivers/usb/storage/uas.ko] undefined!
> WARNING: "USB_STORAGE" [drivers/usb/storage/usb-storage] is a static
> EXPORT_SYMBOL_GPL
> make[1]: *** [scripts/Makefile.modpost:94: __modpost] Error 1
> make: *** [Makefile:1303: modules] Error 2


Hmm, I do not see those error.
I was able to build the kernel successfully.
(I asked the 0-day bot to test whole of my patch set
in case I am missing something.)


Could you share the steps to reproduce the errors and your .config file?






> Running "make M=fs/cifs nsdeps" I still get the error

Sorry, I do not understand why you are doing this.


>
>   Building modules, stage 2.
>   MODPOST 1 modules
> ./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
> make: *** [Makefile:1710: nsdeps] Error 2
>
>
>
> --
> Thanks,
>
> Steve



-- 
Best Regards
Masahiro Yamada
