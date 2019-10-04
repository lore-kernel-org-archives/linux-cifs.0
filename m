Return-Path: <SRS0=e7DE=X5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC644C4360C
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 10:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1AD02133F
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 10:40:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ERmKYlHx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbfJDKkP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Oct 2019 06:40:15 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52574 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfJDKkP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Oct 2019 06:40:15 -0400
Received: by mail-wm1-f67.google.com with SMTP id r19so5300453wmh.2
        for <linux-cifs@vger.kernel.org>; Fri, 04 Oct 2019 03:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ObH9+JWT5QlzGuiPiIPPz8SadjDsdoqDZZO8TLwA4Wg=;
        b=ERmKYlHxhYJJlaT7s9PRcGzr1SmeXV00PBHtfynFVd/R5NXHpyZeeQhRK653MT3L/p
         rQBVUIixRjWRntgz6lrBuD1naZDPZHcGWiX2z+8vsS6/Trt+FYi7BtLzgN5LhFpfXbZV
         jr8o3lxw9MvQSo/lXWef5V3MrpaXTxgYiT+3uxkEVbzrF0SjoxkngX0sHdUIEotEYzCn
         JryqYqGC1IaLTwk9lB8EorEUqEJ56Ospm/DIbv4cYSkQ9r17inpmR0jKeGbQEqPmfJuc
         J7lYzXwCVxWBkcvgxsiSMGdWY3pQGhNTVrbMZVxD7CxbX1gahuXRvCvaTNpi2bYfMB6M
         e0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ObH9+JWT5QlzGuiPiIPPz8SadjDsdoqDZZO8TLwA4Wg=;
        b=YWlyax5AkuU8BQ1ucAuvejw5CRXSxujQ3baXTkVpN/G38MIpPAjmOqQuG4WrtHc2s8
         hqTbva2t/JmAVZKWHzxl8lEqmMc0bm6ywRvYGWP4BZjE92cJcw5C8nV2lLAOzFepg8aq
         rLvYtHqYcbW+Vq8Q+dy51vejhL9svcpMMevFYhYFJ2YKKOZU9/tFikmS9IDB/Eo2X7jL
         5ZfbjxDGtFdoWPxPdGFwj+0L7wJbZZpUSEf3g5TQop3s+tvhVAx4We6OXNpCHB3nuBDK
         mio/wK13kS1tYGB7YxFm3jsUrOlWDbVvA/mWZmgEf/EiYSCKyb+Sub4HCAS6p+/N2ZmK
         QIPA==
X-Gm-Message-State: APjAAAUXbZrcyBwr17nyNiidvU7qxsZ1k1mbJOfYQASXqVv2wsjKXi+G
        YvuczDx+t1ENVNXbu237egwCug==
X-Google-Smtp-Source: APXvYqwSFtxCK4lDOz7PwbHKo0+dQi51HBVhbeSrDiK8qujtfY+6jbEplDUl4zLzyMP055hAnXj2pw==
X-Received: by 2002:a1c:4945:: with SMTP id w66mr10180402wma.40.1570185611599;
        Fri, 04 Oct 2019 03:40:11 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:e8f7:125b:61e9:733d])
        by smtp.gmail.com with ESMTPSA id n22sm4139704wmk.19.2019.10.04.03.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 03:40:10 -0700 (PDT)
Date:   Fri, 4 Oct 2019 11:40:10 +0100
From:   Matthias Maennich <maennich@google.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>
Subject: Re: nsdeps not working on modules in 5.4-rc1
Message-ID: <20191004104010.GA93243@google.com>
References: <CAH2r5mv49T9gwwoJxKJfkgdi6xbf+hDALUiAJHghGikgUNParw@mail.gmail.com>
 <CAH2r5mtVW=3-2L+0QFJAqBG+uj2sYmF=dtzT_kqwK59cu94vGw@mail.gmail.com>
 <20191003104356.GA77584@google.com>
 <CAH2r5msF5DF2ac+-V0xRR-8RYeQdwpsS1iBLHM6iKTB+aEVc5Q@mail.gmail.com>
 <CAK7LNARrdQad9=U1LknT9yRYtRagNVS8T5r_Ovv5Sa91QO3TsA@mail.gmail.com>
 <CAH2r5ms_GdhAG4q3kcadeU44EQPjnebzBG8=DUcsi9Gh5J8UXw@mail.gmail.com>
 <CAK7LNATLCG6DOsnqfFNe61NkcEHV1fS4fCWyy2qzMHVvDDHHHw@mail.gmail.com>
 <CAH2r5muRXaaa4MV0455Sx5JOPyO0ZE_TVTkhuy3rAJXAHyhccQ@mail.gmail.com>
 <CAK7LNASNu2iovxs84_0ouD_GKNfkqnwy4k0QhUGu+XbH9oT0UQ@mail.gmail.com>
 <CAH2r5mu8SiZUMwnfA6zZXUrNZhofc3pUFJOhKvq=0X6MZXVjyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mu8SiZUMwnfA6zZXUrNZhofc3pUFJOhKvq=0X6MZXVjyQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

On Fri, Oct 04, 2019 at 12:01:20AM -0500, Steve French wrote:
>ok - so to sum up, it sounds like you are saying the 350 false
>positives (see attached file) that happen on building cifs.ko .will be
>fixed by a
>future change to modpost?  This is  a typical module build ...

Yes, the reason for you to see these false positive warnings is a bug in
modpost. The patch series we were referring to addresses this problem
(and some others). I do not believe you need to run nsdeps to fixup
anything in fs/cifs at this time.

>download and install current kernel package (in this case Ubuntu
>5.4-rc1). which saves huge amount of build time, then build just the
>module of interest (in my case cifs.ko)
>
>                   cd fs/cifs
>                   make C=1 -C /usr/src/linux-headers-`uname -r` M=`pwd` modules
>
>If nsdeps is not needed to fixup some namespace issue then shouldn't
>be a problem, just trying to avoid the distraction of 300+
>warning messages every time I build just this one module.  Is there a
>workaround?

Sorry for the noise this creates. The only known workaround is to
locally apply the complete patch series.

Cheers,
Matthias

>On Thu, Oct 3, 2019 at 11:51 PM Masahiro Yamada
><yamada.masahiro@socionext.com> wrote:
>>
>> Hi Steve,
>>
>> On Fri, Oct 4, 2019 at 1:28 PM Steve French <smfrench@gmail.com> wrote:
>> >
>> > On Thu, Oct 3, 2019 at 10:41 PM Masahiro Yamada
>> > <yamada.masahiro@socionext.com> wrote:
>> > >
>> > > Hi Steve,
>> > >
>> > > On Fri, Oct 4, 2019 at 1:07 AM Steve French <smfrench@gmail.com> wrote:
>> > > >
>> > > > On Thu, Oct 3, 2019 at 10:24 AM Masahiro Yamada
>> > > > <yamada.masahiro@socionext.com> wrote:
>> > > > >
>> > > > > Hi Steve,
>> > > > >
>> > > > > On Fri, Oct 4, 2019 at 12:15 AM Steve French <smfrench@gmail.com> wrote:
>> > > > > >
>> > > > > > On Thu, Oct 3, 2019 at 5:43 AM Matthias Maennich <maennich@google.com> wrote:
>> > > > > > >
>> > > > > > > Hi Steve!
>> > > > > > >
>> > > > > > > On Wed, Oct 02, 2019 at 06:54:26PM -0500, Steve French wrote:
>> > > > > > > >And running the build differently, from the root of the git tree
>> > > > > > > >(5.4-rc1) rather than using the Ubuntu 5.4-rc1 headers also fails
>> > > > > > > >
>> > > > > > > >e.g. "make  M=fs/cifs modules nsdeps"
>> > > > > > > >
>> > > > > > > >...
>> > > > > > > >  LD [M]  fs/cifs/cifs.o
>> > > > > > > >  Building modules, stage 2.
>> > > > > > > >  MODPOST 1 modules
>> > > > > > > >WARNING: module cifs uses symbol sigprocmask from namespace
>> > > > > > > >_fs/cifs/cache.o), but does not import it.
>> > > > > > > >...
>> > > > > > > >WARNING: module cifs uses symbol posix_test_lock from namespace
>> > > > > > > >cifs/cache.o), but does not import it.
>> > > > > > > >  CC [M]  fs/cifs/cifs.mod.o
>> > > > > > > >  LD [M]  fs/cifs/cifs.ko
>> > > > > > > >  Building modules, stage 2.
>> > > > > > > >  MODPOST 1 modules
>> > > > > > > >./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
>> > > > > > > >make: *** [Makefile:1710: nsdeps] Error 2
>> > > > > > >
>> > > > > > > Thanks for reporting this. It appears to me you hit a bug that was
>> > > > > > > recently discovered: when building with `make M=some/subdirectory`,
>> > > > > > > modpost is misbehaving. Can you try whether this patch series solves
>> > > > > > > your problems:
>> > > > > > > https://lore.kernel.org/lkml/20191003075826.7478-1-yamada.masahiro@socionext.com/
>> > > > > > > In particular patch 2/6 out of the series.
>> > > > > > >
>> > > > > > > Cheers,
>> > > > > > > Matthias
>> > > > > >
>> > > > > >
>> > > > > > Applying just patch 2 and doing "make" from the root of the git tree
>> > > > > > (5.4-rc1), at the tail end of the build I got
>> > > > > >
>> > > > > > ...
>> > > > > > Kernel: arch/x86/boot/bzImage is ready  (#87)
>> > > > > >   Building modules, stage 2.
>> > > > > >   MODPOST 5340 modules
>> > > > > > free(): invalid pointer
>> > > > > > Aborted (core dumped)
>> > > > >
>> > > > >
>> > > > > Right.
>> > > > >
>> > > > > Since 2/6 depends on 1/6,
>> > > > > applying only the second one does not work.
>> > > >
>> > > > Applying both 1 and 2 I get the following error doing make (although
>> > > > it makes it a long way into the build)
>> > > >
>> > > > <snip>
>> > > > WARNING: drivers/usb/storage/usb-storage: 'USB_STORAGE' exported
>> > > > twice. Previous export was in drivers/usb/storage/usb-storage.ko
>> > > > ERROR: "usb_stor_set_xfer_buf" [drivers/usb/storage/ums-usbat.ko] undefined!
>> > > > ERROR: "usb_stor_access_xfer_buf" [drivers/usb/storage/ums-usbat.ko] undefined!
>> > > > ERROR: "usb_stor_post_reset" [drivers/usb/storage/ums-usbat.ko] undefined!
>> > > > ERROR: "usb_stor_disconnect" [drivers/usb/storage/ums-usbat.ko] undefined!
>> > > > <snip>
>> > > > ERROR: "usb_stor_adjust_quirks" [drivers/usb/storage/uas.ko] undefined!
>> > > > ERROR: "usb_stor_sense_invalidCDB" [drivers/usb/storage/uas.ko] undefined!
>> > > > WARNING: "USB_STORAGE" [drivers/usb/storage/usb-storage] is a static
>> > > > EXPORT_SYMBOL_GPL
>> > > > make[1]: *** [scripts/Makefile.modpost:94: __modpost] Error 1
>> > > > make: *** [Makefile:1303: modules] Error 2
>> > >
>> > >
>> > > Hmm, I do not see those error.
>> > > I was able to build the kernel successfully.
>> > > (I asked the 0-day bot to test whole of my patch set
>> > > in case I am missing something.)
>> > >
>> > >
>> > > Could you share the steps to reproduce the errors and your .config file?
>> >
>> > From the root of git tree - at exactly 5.4-rc1
>> >
>> > ~/cifs-2.6$ make nsdeps
>> >   CALL    scripts/checksyscalls.sh
>> >   CALL    scripts/atomic/check-atomics.sh
>> >   DESCEND  objtool
>> >   CHK     include/generated/compile.h
>> >   CHK     kernel/kheaders_data.tar.xz
>> >   Building modules, stage 2.
>> >   MODPOST 5340 modules
>> >   Building modules, stage 2.
>> >   MODPOST 5340 modules
>> > ./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
>> > make: *** [Makefile:1710: nsdeps] Error 2
>> >
>> > I get the same error doing "rm fs/cifs/*.o" and repeating the "make
>> > nsdeps" command
>> >
>> > I will send you the .config
>>
>>
>>
>> You need to clarify your problem.
>>
>> In the first post from you, you pointed out
>> "hundreds of new warnings introduced by namespaces in 5.4-rc1 when
>> building my module"
>>
>> So, 1/6 and 2/6 should address that problem.
>> https://lore.kernel.org/patchwork/patch/1133628/
>> https://lore.kernel.org/patchwork/patch/1133626/
>>
>>
>> Then, in the previous email ("Applying both 1 and 2 I get the
>> following error doing make")
>> it looks like you were talking about in-kernel building
>> instead of the external module.
>>
>>
>> Then, in this email, you are talking about "make nsdeps".
>> "make nsdeps" obviously does not support M=.
>>
>>
>> I am afraid you are mixing up different issues,
>> which is so confusing. (and I am afraid you were too confused)
>>
>> Currently, the namespace is used only by USB_STORAGE.
>> So, it should not be a problem for your module.
>>
>> To sum up, you do not need to run nsdeps at all.
>> The hundreds of false-positive warnings came from the modpost bug,
>> and should be fixed soon.
>>
>>
>> --
>> Best Regards
>> Masahiro Yamada
>
>
>
>-- 
>Thanks,
>
>Steve


