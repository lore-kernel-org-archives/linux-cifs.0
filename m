Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF39CC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Oct 2022 23:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJEXhq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Oct 2022 19:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJEXhp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Oct 2022 19:37:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307047287D
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 16:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFF34617F0
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 23:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCBEC433D6
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 23:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665013063;
        bh=bOSnOU3FYTrdAJaTvOIWM6GkLXsaVv4T6vqWFqr98xI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FdJlxUyXcT/mv1xpttgckmbjRQaCIH3zMmEJk9w/NiUzybPVvJoXmasWOcPFqHFJn
         NafewowAt4pagzziuQqAQ0RHV4P4dPK5VJzLjj0J1N71UJcVq+kota5aJIOIHmnk6G
         hSSVuaSAoweg2B7NYMxj2tbz6uT8I7f7PJD5ASsJ705rbaoukEtdUFkSWqiARpvPUu
         /a0tGIClzBgK7ZrVFiw6CV1ehlxWJfo56dIJRTuUS5+8hqN3WaIFUYa3i4eE274roB
         rVORNA9Zi9lwsFXPEQvORF9rjkPHik4UGL0raYkgYBB4fC+QdH+hJRJVR5zY11YDah
         NSfB8M4FKgIPQ==
Received: by mail-oo1-f46.google.com with SMTP id c13-20020a4ac30d000000b0047663e3e16bso333529ooq.6
        for <linux-cifs@vger.kernel.org>; Wed, 05 Oct 2022 16:37:42 -0700 (PDT)
X-Gm-Message-State: ACrzQf0B+qOy5i8Pm1KqOjVfmi7DRMo1Y1/lk3bmgPo9vn8rV0slbW+n
        03nC0/DpLFI9Ned7dZXxWScdjZt1g/A5YX5HwO8=
X-Google-Smtp-Source: AMsMyM5V/jF5axgVi9Iux01mjDik/5ZSXSKshHPoqt4VnzzIP4hWS0F0dyAC2+VqPARy8YtPGqTQSFpPs+R1d9RrOnc=
X-Received: by 2002:a9d:4b0b:0:b0:660:f380:8780 with SMTP id
 q11-20020a9d4b0b000000b00660f3808780mr465119otf.339.1665013062167; Wed, 05
 Oct 2022 16:37:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:ea0c:0:0:0:0 with HTTP; Wed, 5 Oct 2022 16:37:41
 -0700 (PDT)
In-Reply-To: <CAH2r5mvmYgfDQ4aYGJf+_1fC9aW4HCRVtm92dQe5CvAtc-5NOg@mail.gmail.com>
References: <CAH2r5ms9NbH+_ruMke+ezYo-7+qZuinrP_SQbHxf3E3ikxnN0A@mail.gmail.com>
 <CAH2r5mvmYgfDQ4aYGJf+_1fC9aW4HCRVtm92dQe5CvAtc-5NOg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 6 Oct 2022 08:37:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Pso5=OeCHQqSKD_8jw1N+7HwVh=rsGgEzJgwdXPMGPw@mail.gmail.com>
Message-ID: <CAKYAXd9Pso5=OeCHQqSKD_8jw1N+7HwVh=rsGgEzJgwdXPMGPw@mail.gmail.com>
Subject: Re: build failures on 6.0
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

The kernel was built by: x86_64-linux-gnu-gcc (Ubuntu 12.2.0-3ubuntu1) 12.2=
.0
  You are using:           gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0

Have you ever tried to do make clean and make again ?
It seems that you upgraded ubuntu before ... ? the version looks different.

Thanks!


2022-10-06 8:02 GMT+09:00, Steve French <smfrench@gmail.com>:
> This is actually ubuntu 22.04 which fails building out of tree modules
> (as we do for testing) on 6.0-rc7 (last working one was 6.0-rc3) and
> later
>
> On Wed, Oct 5, 2022 at 6:00 PM Steve French <smfrench@gmail.com> wrote:
>>
>> I noticed that 6.0-rc7 and later don't build out of tree modules (was
>> trying to setup ksmbd for running buildbot tests).  Any ideas about
>> this "unrecognized command-line option" for gcc error (this is on
>> Ubuntu)
>>
>> smfrench@ubuntu20-ksmbd-target:~/smb3-kernel/fs/ksmbd$ ~/build-stock-cif=
s
>> make: Entering directory '/usr/src/linux-headers-6.0.0-060000-generic'
>> warning: the compiler differs from the one used to build the kernel
>>   The kernel was built by: x86_64-linux-gnu-gcc (Ubuntu 12.2.0-3ubuntu1)
>> 12.2.0
>>   You are using:           gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0
>>   CC [M]  /home/smfrench/smb3-kernel/fs/ksmbd/unicode.o
>> gcc: error: unrecognized command-line option
>> =E2=80=98-ftrivial-auto-var-init=3Dzero=E2=80=99
>> make[1]: *** [scripts/Makefile.build:249:
>> /home/smfrench/smb3-kernel/fs/ksmbd/unicode.o] Error 1
>> make: *** [Makefile:1858: /home/smfrench/smb3-kernel/fs/ksmbd] Error 2
>> make: Leaving directory '/usr/src/linux-headers-6.0.0-060000-generic'
>> smfrench@ubuntu20-ksmbd-target:~/smb3-kernel/fs/ksmbd$ uname -a
>> Linux ubuntu20-ksmbd-target 6.0.0-060000-generic #202210022231 SMP
>> PREEMPT_DYNAMIC Sun Oct 2 22:35:09 UTC 2022 x86_64 x86_64 x86_64
>> GNU/Linux
>>
>>
>> --
>> Thanks,
>>
>> Steve
>
>
>
> --
> Thanks,
>
> Steve
>
