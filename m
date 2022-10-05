Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735D0C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Oct 2022 23:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJEXDG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Oct 2022 19:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJEXDD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Oct 2022 19:03:03 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01778559B
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 16:03:02 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id x7so47153vkx.5
        for <linux-cifs@vger.kernel.org>; Wed, 05 Oct 2022 16:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=+8J+xxqzlZABci/EVav6Mgl+uhEykk4qUYtvzyFVXUw=;
        b=UGXiHXoaevHf9LodhLv2XXfXKQJXfsn0Hr2Bb4z9FCuc/O1yxkOMKEbr8a9RNV90CH
         PGHmnTODHew8U1rG4kltDqSIQqIrTRBARxm60p6y6v6ZtoOwM51mcZA3Bp5rTiPIQa+A
         a34+82W0S+/szDyo9rzq4UmtbZqzSbkU/qd//3BK+ZemRMF9xyRu6UpZywiGTF6hrOJJ
         1bGMd1kb+/69XSHPb4+ramZ+APtJLU55tna5D3yQQEDgQiH07/SL/hH3658f+iv7UDAY
         /C55hu7SpuKL4uDbdk5WOUXBXmO1INXqVLFLvaDidhboCcF2EYIbu04E9zCZ7ONu/Ub7
         7RNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=+8J+xxqzlZABci/EVav6Mgl+uhEykk4qUYtvzyFVXUw=;
        b=fvjqy3XuhPGDtn3vhbDNSS2lJW4vdKDdDKj9ud+8L5b+q/l4aK3ns3HjDqsi4OliI6
         R2sbPnvu9rNQaG2a70Y+JBZNkKJXGN/ZiIkzvwuS9oKiT6Eyrb1Z1n5vhA+8G1wGdrM4
         b9YLWqjDvEqqKP7rqBfR0udZZI92w182ofk/stXHK5287LBPfHjE7qlvdC5xGSUwtde7
         VmSQeK8ON52nDxJOk1iJPe4hQesujNpKu+0XRwRCiNOed0p4YpWk/aeQle/MoR2qG8N0
         KwhRC5ggXDDRsuwO8UU8z50U1jNMgfrMFqf26rzyRGpNPsn/ITOsXla2a5fXE6MVFJvo
         LpLw==
X-Gm-Message-State: ACrzQf1zMAm2G8czcC5J8JQRG9u7WCs0GmxZ71C0NSUt7n/0OWAIN1Zn
        BS6JqX8QBvXngMm4hoyPNqNnHW09bHzVP8HuMG0NzNAL
X-Google-Smtp-Source: AMsMyM6sJdBNACNtiPQHiZp4DYyqW6H1z1LKh8jpzNZD+aHWJV4eb7zweRrM8Kqth1cI8+zWL5h3Tdn8fBmFLhenbhU=
X-Received: by 2002:ac5:c313:0:b0:3aa:9b16:9534 with SMTP id
 j19-20020ac5c313000000b003aa9b169534mr936052vkk.38.1665010981589; Wed, 05 Oct
 2022 16:03:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms9NbH+_ruMke+ezYo-7+qZuinrP_SQbHxf3E3ikxnN0A@mail.gmail.com>
In-Reply-To: <CAH2r5ms9NbH+_ruMke+ezYo-7+qZuinrP_SQbHxf3E3ikxnN0A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 Oct 2022 18:02:50 -0500
Message-ID: <CAH2r5mvmYgfDQ4aYGJf+_1fC9aW4HCRVtm92dQe5CvAtc-5NOg@mail.gmail.com>
Subject: Re: build failures on 6.0
To:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is actually ubuntu 22.04 which fails building out of tree modules
(as we do for testing) on 6.0-rc7 (last working one was 6.0-rc3) and
later

On Wed, Oct 5, 2022 at 6:00 PM Steve French <smfrench@gmail.com> wrote:
>
> I noticed that 6.0-rc7 and later don't build out of tree modules (was
> trying to setup ksmbd for running buildbot tests).  Any ideas about
> this "unrecognized command-line option" for gcc error (this is on
> Ubuntu)
>
> smfrench@ubuntu20-ksmbd-target:~/smb3-kernel/fs/ksmbd$ ~/build-stock-cifs
> make: Entering directory '/usr/src/linux-headers-6.0.0-060000-generic'
> warning: the compiler differs from the one used to build the kernel
>   The kernel was built by: x86_64-linux-gnu-gcc (Ubuntu 12.2.0-3ubuntu1) =
12.2.0
>   You are using:           gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0
>   CC [M]  /home/smfrench/smb3-kernel/fs/ksmbd/unicode.o
> gcc: error: unrecognized command-line option =E2=80=98-ftrivial-auto-var-=
init=3Dzero=E2=80=99
> make[1]: *** [scripts/Makefile.build:249:
> /home/smfrench/smb3-kernel/fs/ksmbd/unicode.o] Error 1
> make: *** [Makefile:1858: /home/smfrench/smb3-kernel/fs/ksmbd] Error 2
> make: Leaving directory '/usr/src/linux-headers-6.0.0-060000-generic'
> smfrench@ubuntu20-ksmbd-target:~/smb3-kernel/fs/ksmbd$ uname -a
> Linux ubuntu20-ksmbd-target 6.0.0-060000-generic #202210022231 SMP
> PREEMPT_DYNAMIC Sun Oct 2 22:35:09 UTC 2022 x86_64 x86_64 x86_64
> GNU/Linux
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
