Return-Path: <SRS0=2csP=X4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3874C10F14
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 17:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAF4D20862
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 17:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V3NMv022"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731708AbfJCQG4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Oct 2019 12:06:56 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42540 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731347AbfJCQGz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Oct 2019 12:06:55 -0400
Received: by mail-io1-f66.google.com with SMTP id n197so6759978iod.9;
        Thu, 03 Oct 2019 09:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mlk8A86Fq4GMU/KjC59awMny/l9qD3VrtRXq6Ecrchc=;
        b=V3NMv022bIO4LOUDBGXngyMnjadYmEv5jEvTTZuP5q/wQS5Vm1+q6D3RcD6VZc4VjO
         6H/Recodkm+uluNF6IuIBjp2G+wkmroJ/7VYdkIj9+4guGwcAOIL6AxPPA33VQCUFMtr
         +NnezmU5s8g6cJqjvx1nTgi7f18SKpobHNbSEnoDD/NFdmfOKAbAhg6GgOv6V3YuGS8a
         7uwt3HpW71eSJcOfJrnYrQmhoqrmBsyzNCT/7LFxPcD07Hecy/QEpgJsqfYm0UBByHrN
         luK/55rb0RpO2vIWK446OJ1f86KwD8zL+2JZQxkuj2A+APwRRrPOSTSbfNMx3yq9299S
         EMRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mlk8A86Fq4GMU/KjC59awMny/l9qD3VrtRXq6Ecrchc=;
        b=OjjSfM8IKEfWKBuFJoA2RKFzDfIzwHUFwygzp+D7SH1FlUFXFBdmc5xF91cJyYiouO
         zEyI+HsJE7WpZqPW0HowoCbB0A0C/ny+W5i2QcEJUcskVnBi3Mf7yEwJvEezlOOQUybq
         sB6tee8US/DnCAcURjWjfV1vzzki4vkmXSBLLQIxDyLOZYAfYKObaM4OtDBbeZqZCC03
         AizTeLH8hkrfapNQFXdnUNR5FebkgIkw/gGmpIGbcDYiHrprZYhQSxidi5i5HoR1C1hp
         Zm/mY29h7Y6ly1HgwDDHJAo6krCu4etMkaoMH++ApZdQsyZHsTlUL9HKvfygS6l1iwAh
         unVA==
X-Gm-Message-State: APjAAAUP+LUozqgBUrBMVYBqdIHzN11GqJmNyL9HOXXDD9dyqNSjcSkt
        8NuAb4msoCPtdGBB2vTzqck4EVJjoaUFhusjXZo=
X-Google-Smtp-Source: APXvYqwKVFct2U1efQS8h4m+GJhx1lW98NQBdZGp7Re59o/Ywbh4H1PWNheYUDsMKUc0sleg/qKJqe+Z1d/Rp8qmIKg=
X-Received: by 2002:a6b:a0d:: with SMTP id z13mr8337013ioi.5.1570118813951;
 Thu, 03 Oct 2019 09:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv49T9gwwoJxKJfkgdi6xbf+hDALUiAJHghGikgUNParw@mail.gmail.com>
 <CAH2r5mtVW=3-2L+0QFJAqBG+uj2sYmF=dtzT_kqwK59cu94vGw@mail.gmail.com>
 <20191003104356.GA77584@google.com> <CAH2r5msF5DF2ac+-V0xRR-8RYeQdwpsS1iBLHM6iKTB+aEVc5Q@mail.gmail.com>
 <CAK7LNARrdQad9=U1LknT9yRYtRagNVS8T5r_Ovv5Sa91QO3TsA@mail.gmail.com>
In-Reply-To: <CAK7LNARrdQad9=U1LknT9yRYtRagNVS8T5r_Ovv5Sa91QO3TsA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 3 Oct 2019 11:06:42 -0500
Message-ID: <CAH2r5ms_GdhAG4q3kcadeU44EQPjnebzBG8=DUcsi9Gh5J8UXw@mail.gmail.com>
Subject: Re: nsdeps not working on modules in 5.4-rc1
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Matthias Maennich <maennich@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Oct 3, 2019 at 10:24 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> Hi Steve,
>
> On Fri, Oct 4, 2019 at 12:15 AM Steve French <smfrench@gmail.com> wrote:
> >
> > On Thu, Oct 3, 2019 at 5:43 AM Matthias Maennich <maennich@google.com> wrote:
> > >
> > > Hi Steve!
> > >
> > > On Wed, Oct 02, 2019 at 06:54:26PM -0500, Steve French wrote:
> > > >And running the build differently, from the root of the git tree
> > > >(5.4-rc1) rather than using the Ubuntu 5.4-rc1 headers also fails
> > > >
> > > >e.g. "make  M=fs/cifs modules nsdeps"
> > > >
> > > >...
> > > >  LD [M]  fs/cifs/cifs.o
> > > >  Building modules, stage 2.
> > > >  MODPOST 1 modules
> > > >WARNING: module cifs uses symbol sigprocmask from namespace
> > > >_fs/cifs/cache.o), but does not import it.
> > > >...
> > > >WARNING: module cifs uses symbol posix_test_lock from namespace
> > > >cifs/cache.o), but does not import it.
> > > >  CC [M]  fs/cifs/cifs.mod.o
> > > >  LD [M]  fs/cifs/cifs.ko
> > > >  Building modules, stage 2.
> > > >  MODPOST 1 modules
> > > >./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
> > > >make: *** [Makefile:1710: nsdeps] Error 2
> > >
> > > Thanks for reporting this. It appears to me you hit a bug that was
> > > recently discovered: when building with `make M=some/subdirectory`,
> > > modpost is misbehaving. Can you try whether this patch series solves
> > > your problems:
> > > https://lore.kernel.org/lkml/20191003075826.7478-1-yamada.masahiro@socionext.com/
> > > In particular patch 2/6 out of the series.
> > >
> > > Cheers,
> > > Matthias
> >
> >
> > Applying just patch 2 and doing "make" from the root of the git tree
> > (5.4-rc1), at the tail end of the build I got
> >
> > ...
> > Kernel: arch/x86/boot/bzImage is ready  (#87)
> >   Building modules, stage 2.
> >   MODPOST 5340 modules
> > free(): invalid pointer
> > Aborted (core dumped)
>
>
> Right.
>
> Since 2/6 depends on 1/6,
> applying only the second one does not work.

Applying both 1 and 2 I get the following error doing make (although
it makes it a long way into the build)

<snip>
WARNING: drivers/usb/storage/usb-storage: 'USB_STORAGE' exported
twice. Previous export was in drivers/usb/storage/usb-storage.ko
ERROR: "usb_stor_set_xfer_buf" [drivers/usb/storage/ums-usbat.ko] undefined!
ERROR: "usb_stor_access_xfer_buf" [drivers/usb/storage/ums-usbat.ko] undefined!
ERROR: "usb_stor_post_reset" [drivers/usb/storage/ums-usbat.ko] undefined!
ERROR: "usb_stor_disconnect" [drivers/usb/storage/ums-usbat.ko] undefined!
<snip>
ERROR: "usb_stor_adjust_quirks" [drivers/usb/storage/uas.ko] undefined!
ERROR: "usb_stor_sense_invalidCDB" [drivers/usb/storage/uas.ko] undefined!
WARNING: "USB_STORAGE" [drivers/usb/storage/usb-storage] is a static
EXPORT_SYMBOL_GPL
make[1]: *** [scripts/Makefile.modpost:94: __modpost] Error 1
make: *** [Makefile:1303: modules] Error 2

Running "make M=fs/cifs nsdeps" I still get the error

  Building modules, stage 2.
  MODPOST 1 modules
./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
make: *** [Makefile:1710: nsdeps] Error 2



-- 
Thanks,

Steve
