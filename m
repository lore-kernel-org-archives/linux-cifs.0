Return-Path: <SRS0=e7DE=X5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D95C4360C
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 04:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9D90215EA
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 04:51:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="MhEnQjSU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387855AbfJDEvF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Oct 2019 00:51:05 -0400
Received: from conssluserg-06.nifty.com ([210.131.2.91]:19371 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387754AbfJDEvF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Oct 2019 00:51:05 -0400
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id x944ohLB002008;
        Fri, 4 Oct 2019 13:50:44 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com x944ohLB002008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1570164644;
        bh=fsbozbb/MSH/TOlX6a8dcbPbQbiSqz22glUTSAenSgo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MhEnQjSUDJwG40GK4kDNPRs3XRPwUyvnDvq7LKlPi3GywE54n9xViFZ70ToTziIMA
         e8TimkZBRzCynBc9gBTX0gm3dr5g94NMdYRIwA9VFdPOqF/ZO/yfcA9iptoyFReHre
         /6R9T3PhoESPty686zdOSsVz6+zkvDVMN3OBQ0bLcVMm7mhCfao2BHbio6S4He8pxn
         5gMaAyNjsgfWBppot6c2MCxKshAjsOEswML4Re5zzuPEnhDfPCUw09XLtpm1VRwaRg
         PglnSFPVRmnG9lp4jmWZT96iZHqpU+LoBpDWXNxX9lXh/6+5/djwztYcaGktd/88TB
         +LKOM6izmqLJg==
X-Nifty-SrcIP: [209.85.222.51]
Received: by mail-ua1-f51.google.com with SMTP id l13so1648324uap.8;
        Thu, 03 Oct 2019 21:50:44 -0700 (PDT)
X-Gm-Message-State: APjAAAV+FjgqGHJGhOv2l5nnXVZbDv14BqEpHRtjmAfNy2Rlu0AGTSUv
        rJm2P7sIXQSL3ZDJaQ0alynNa6CpLf4uG6irWyc=
X-Google-Smtp-Source: APXvYqyoApWRjFfhTZQQuqKfut/dQVMveDO8oJqVqs8S4l8r+FXDn0wlEE6F0pFbghSQP9k/fkAEIsqW5J/xD5xq9fk=
X-Received: by 2002:ab0:4a83:: with SMTP id s3mr6830458uae.95.1570164643279;
 Thu, 03 Oct 2019 21:50:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv49T9gwwoJxKJfkgdi6xbf+hDALUiAJHghGikgUNParw@mail.gmail.com>
 <CAH2r5mtVW=3-2L+0QFJAqBG+uj2sYmF=dtzT_kqwK59cu94vGw@mail.gmail.com>
 <20191003104356.GA77584@google.com> <CAH2r5msF5DF2ac+-V0xRR-8RYeQdwpsS1iBLHM6iKTB+aEVc5Q@mail.gmail.com>
 <CAK7LNARrdQad9=U1LknT9yRYtRagNVS8T5r_Ovv5Sa91QO3TsA@mail.gmail.com>
 <CAH2r5ms_GdhAG4q3kcadeU44EQPjnebzBG8=DUcsi9Gh5J8UXw@mail.gmail.com>
 <CAK7LNATLCG6DOsnqfFNe61NkcEHV1fS4fCWyy2qzMHVvDDHHHw@mail.gmail.com> <CAH2r5muRXaaa4MV0455Sx5JOPyO0ZE_TVTkhuy3rAJXAHyhccQ@mail.gmail.com>
In-Reply-To: <CAH2r5muRXaaa4MV0455Sx5JOPyO0ZE_TVTkhuy3rAJXAHyhccQ@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Fri, 4 Oct 2019 13:50:06 +0900
X-Gmail-Original-Message-ID: <CAK7LNASNu2iovxs84_0ouD_GKNfkqnwy4k0QhUGu+XbH9oT0UQ@mail.gmail.com>
Message-ID: <CAK7LNASNu2iovxs84_0ouD_GKNfkqnwy4k0QhUGu+XbH9oT0UQ@mail.gmail.com>
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

On Fri, Oct 4, 2019 at 1:28 PM Steve French <smfrench@gmail.com> wrote:
>
> On Thu, Oct 3, 2019 at 10:41 PM Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > Hi Steve,
> >
> > On Fri, Oct 4, 2019 at 1:07 AM Steve French <smfrench@gmail.com> wrote:
> > >
> > > On Thu, Oct 3, 2019 at 10:24 AM Masahiro Yamada
> > > <yamada.masahiro@socionext.com> wrote:
> > > >
> > > > Hi Steve,
> > > >
> > > > On Fri, Oct 4, 2019 at 12:15 AM Steve French <smfrench@gmail.com> wrote:
> > > > >
> > > > > On Thu, Oct 3, 2019 at 5:43 AM Matthias Maennich <maennich@google.com> wrote:
> > > > > >
> > > > > > Hi Steve!
> > > > > >
> > > > > > On Wed, Oct 02, 2019 at 06:54:26PM -0500, Steve French wrote:
> > > > > > >And running the build differently, from the root of the git tree
> > > > > > >(5.4-rc1) rather than using the Ubuntu 5.4-rc1 headers also fails
> > > > > > >
> > > > > > >e.g. "make  M=fs/cifs modules nsdeps"
> > > > > > >
> > > > > > >...
> > > > > > >  LD [M]  fs/cifs/cifs.o
> > > > > > >  Building modules, stage 2.
> > > > > > >  MODPOST 1 modules
> > > > > > >WARNING: module cifs uses symbol sigprocmask from namespace
> > > > > > >_fs/cifs/cache.o), but does not import it.
> > > > > > >...
> > > > > > >WARNING: module cifs uses symbol posix_test_lock from namespace
> > > > > > >cifs/cache.o), but does not import it.
> > > > > > >  CC [M]  fs/cifs/cifs.mod.o
> > > > > > >  LD [M]  fs/cifs/cifs.ko
> > > > > > >  Building modules, stage 2.
> > > > > > >  MODPOST 1 modules
> > > > > > >./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
> > > > > > >make: *** [Makefile:1710: nsdeps] Error 2
> > > > > >
> > > > > > Thanks for reporting this. It appears to me you hit a bug that was
> > > > > > recently discovered: when building with `make M=some/subdirectory`,
> > > > > > modpost is misbehaving. Can you try whether this patch series solves
> > > > > > your problems:
> > > > > > https://lore.kernel.org/lkml/20191003075826.7478-1-yamada.masahiro@socionext.com/
> > > > > > In particular patch 2/6 out of the series.
> > > > > >
> > > > > > Cheers,
> > > > > > Matthias
> > > > >
> > > > >
> > > > > Applying just patch 2 and doing "make" from the root of the git tree
> > > > > (5.4-rc1), at the tail end of the build I got
> > > > >
> > > > > ...
> > > > > Kernel: arch/x86/boot/bzImage is ready  (#87)
> > > > >   Building modules, stage 2.
> > > > >   MODPOST 5340 modules
> > > > > free(): invalid pointer
> > > > > Aborted (core dumped)
> > > >
> > > >
> > > > Right.
> > > >
> > > > Since 2/6 depends on 1/6,
> > > > applying only the second one does not work.
> > >
> > > Applying both 1 and 2 I get the following error doing make (although
> > > it makes it a long way into the build)
> > >
> > > <snip>
> > > WARNING: drivers/usb/storage/usb-storage: 'USB_STORAGE' exported
> > > twice. Previous export was in drivers/usb/storage/usb-storage.ko
> > > ERROR: "usb_stor_set_xfer_buf" [drivers/usb/storage/ums-usbat.ko] undefined!
> > > ERROR: "usb_stor_access_xfer_buf" [drivers/usb/storage/ums-usbat.ko] undefined!
> > > ERROR: "usb_stor_post_reset" [drivers/usb/storage/ums-usbat.ko] undefined!
> > > ERROR: "usb_stor_disconnect" [drivers/usb/storage/ums-usbat.ko] undefined!
> > > <snip>
> > > ERROR: "usb_stor_adjust_quirks" [drivers/usb/storage/uas.ko] undefined!
> > > ERROR: "usb_stor_sense_invalidCDB" [drivers/usb/storage/uas.ko] undefined!
> > > WARNING: "USB_STORAGE" [drivers/usb/storage/usb-storage] is a static
> > > EXPORT_SYMBOL_GPL
> > > make[1]: *** [scripts/Makefile.modpost:94: __modpost] Error 1
> > > make: *** [Makefile:1303: modules] Error 2
> >
> >
> > Hmm, I do not see those error.
> > I was able to build the kernel successfully.
> > (I asked the 0-day bot to test whole of my patch set
> > in case I am missing something.)
> >
> >
> > Could you share the steps to reproduce the errors and your .config file?
>
> From the root of git tree - at exactly 5.4-rc1
>
> ~/cifs-2.6$ make nsdeps
>   CALL    scripts/checksyscalls.sh
>   CALL    scripts/atomic/check-atomics.sh
>   DESCEND  objtool
>   CHK     include/generated/compile.h
>   CHK     kernel/kheaders_data.tar.xz
>   Building modules, stage 2.
>   MODPOST 5340 modules
>   Building modules, stage 2.
>   MODPOST 5340 modules
> ./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
> make: *** [Makefile:1710: nsdeps] Error 2
>
> I get the same error doing "rm fs/cifs/*.o" and repeating the "make
> nsdeps" command
>
> I will send you the .config



You need to clarify your problem.

In the first post from you, you pointed out
"hundreds of new warnings introduced by namespaces in 5.4-rc1 when
building my module"

So, 1/6 and 2/6 should address that problem.
https://lore.kernel.org/patchwork/patch/1133628/
https://lore.kernel.org/patchwork/patch/1133626/


Then, in the previous email ("Applying both 1 and 2 I get the
following error doing make")
it looks like you were talking about in-kernel building
instead of the external module.


Then, in this email, you are talking about "make nsdeps".
"make nsdeps" obviously does not support M=.


I am afraid you are mixing up different issues,
which is so confusing. (and I am afraid you were too confused)

Currently, the namespace is used only by USB_STORAGE.
So, it should not be a problem for your module.

To sum up, you do not need to run nsdeps at all.
The hundreds of false-positive warnings came from the modpost bug,
and should be fixed soon.


-- 
Best Regards
Masahiro Yamada
