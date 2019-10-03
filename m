Return-Path: <SRS0=2csP=X4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC38C10F14
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 15:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F0012133F
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 15:15:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oTWdxx7p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbfJCPPG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Oct 2019 11:15:06 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40476 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfJCPPG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Oct 2019 11:15:06 -0400
Received: by mail-io1-f65.google.com with SMTP id h144so6356391iof.7;
        Thu, 03 Oct 2019 08:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BFFGExXDIOP688HODdFkIiqsjWnVg60lYlZNG2xLq9A=;
        b=oTWdxx7pbev64Bc7cqoj93/GvY/xdreUbNKmZoAn9Mm89tX3kb25USyQObqSfrp3kx
         ErPyyOF3wXzdSXFAd8XLrpZyY781HEpnH2+JFBT5xNRaHNN+xwFWHK50JDMqknxS+R7b
         uf4FXTQRR0tBSKlGgQVqHv+/uSYfKzmbdihfmWVfxh/Y2tl5uOwrrbF2DVUcj6j39tDe
         onO6tPj2IuSkL6qLS1shxUYGiuwxP5XdvTKcMidZ2V7RMT7tB4B0vgnTgRmDUISinHTe
         WieVn4gnC7Pl2+AA7MvreRdNo92mhkoAK78OU9UW3C9bUH2LY2v5N1j0KNBigkoCsvDZ
         GyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BFFGExXDIOP688HODdFkIiqsjWnVg60lYlZNG2xLq9A=;
        b=k+uyQc1QP1ow1gqzqHBPli5cqGgchA6+SkQYRv2sMbjiK5oT13MPHYhBtwOdHB3CDq
         kVCpojl1/wNbz3XTJiJC1WXc6wFTaX/2i+IRKY4yaZKJi41jM3om7AH5wQ1Z8qjZuj3j
         IDcD93IR8plaex2N1qajO0tnoiiN/bnMIwUW3qwgRw14quq6WsDORrTL/bOFQdOXzXSn
         ItV8dFFH7dEpRyqVGkg/RQhf99+9m41yvIJxIvxUfmuLu1HcFDLEfjNsI2FZr0kJl9qk
         93EC9JijrxDPs2sfOVG4JHhzxCILmFi1GVMZTuOo4ewDHwT15B/WtjbPDJqlGhRIcV1c
         Qw4g==
X-Gm-Message-State: APjAAAWLckyGA2T83TUPxZkN7+Sfxa86FYg3Py0Y7fwRKI2OMayShGHW
        tEQO7UeVP130SCfnNAee8MBb6up07xSwQyFj0Hg=
X-Google-Smtp-Source: APXvYqzJ/zX2nd/XPq84jrI516/U/wJV0qmtgohJTozU6PDbDv+UccxtLygnD08lGJmOfk56Dh9QLU+VvnjWNPsmk0o=
X-Received: by 2002:a92:15c4:: with SMTP id 65mr10840441ilv.173.1570115705615;
 Thu, 03 Oct 2019 08:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv49T9gwwoJxKJfkgdi6xbf+hDALUiAJHghGikgUNParw@mail.gmail.com>
 <CAH2r5mtVW=3-2L+0QFJAqBG+uj2sYmF=dtzT_kqwK59cu94vGw@mail.gmail.com> <20191003104356.GA77584@google.com>
In-Reply-To: <20191003104356.GA77584@google.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 3 Oct 2019 10:14:53 -0500
Message-ID: <CAH2r5msF5DF2ac+-V0xRR-8RYeQdwpsS1iBLHM6iKTB+aEVc5Q@mail.gmail.com>
Subject: Re: nsdeps not working on modules in 5.4-rc1
To:     Matthias Maennich <maennich@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jessica Yu <jeyu@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Oct 3, 2019 at 5:43 AM Matthias Maennich <maennich@google.com> wrote:
>
> Hi Steve!
>
> On Wed, Oct 02, 2019 at 06:54:26PM -0500, Steve French wrote:
> >And running the build differently, from the root of the git tree
> >(5.4-rc1) rather than using the Ubuntu 5.4-rc1 headers also fails
> >
> >e.g. "make  M=fs/cifs modules nsdeps"
> >
> >...
> >  LD [M]  fs/cifs/cifs.o
> >  Building modules, stage 2.
> >  MODPOST 1 modules
> >WARNING: module cifs uses symbol sigprocmask from namespace
> >_fs/cifs/cache.o), but does not import it.
> >...
> >WARNING: module cifs uses symbol posix_test_lock from namespace
> >cifs/cache.o), but does not import it.
> >  CC [M]  fs/cifs/cifs.mod.o
> >  LD [M]  fs/cifs/cifs.ko
> >  Building modules, stage 2.
> >  MODPOST 1 modules
> >./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
> >make: *** [Makefile:1710: nsdeps] Error 2
>
> Thanks for reporting this. It appears to me you hit a bug that was
> recently discovered: when building with `make M=some/subdirectory`,
> modpost is misbehaving. Can you try whether this patch series solves
> your problems:
> https://lore.kernel.org/lkml/20191003075826.7478-1-yamada.masahiro@socionext.com/
> In particular patch 2/6 out of the series.
>
> Cheers,
> Matthias


Applying just patch 2 and doing "make" from the root of the git tree
(5.4-rc1), at the tail end of the build I got

...
Kernel: arch/x86/boot/bzImage is ready  (#87)
  Building modules, stage 2.
  MODPOST 5340 modules
free(): invalid pointer
Aborted (core dumped)
make[1]: *** [scripts/Makefile.modpost:94: __modpost] Error 134
make: *** [Makefile:1303: modules] Error 2

With patch 2 and doing make M=fs/cifs nsdeps from the root of the git tree I get

$ make M=fs/cifs nsdeps
  Building modules, stage 2.
  MODPOST 1 modules
  Building modules, stage 2.
  MODPOST 1 modules
./scripts/nsdeps: 34: local: ./fs/cifs/cifsfs.c: bad variable name
make: *** [Makefile:1710: nsdeps] Error 2


-- 
Thanks,

Steve
