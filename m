Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DD7C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Oct 2022 02:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiJFC4T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Oct 2022 22:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiJFCzn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Oct 2022 22:55:43 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEF789ADD
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 19:53:51 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id p4so207716uao.0
        for <linux-cifs@vger.kernel.org>; Wed, 05 Oct 2022 19:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=5MqOXU/GO6ySFXNdWWpGuGaYsTEAcOj5xz5y35r5Kxw=;
        b=LUhxkpXUV9ezp7XNhb5VdUsAR5GNU1x5no0U7Z3v1Fcig1TnC/8NIr1GjvE4QTJ93A
         Hzh0TIs2C/W88Nzf9iQ3vfxs9bYLCJxhMMhjdOTAYMfUZM6LMrmVBfyC1MJDRnyaPzC5
         eSCXnszjzbiSH/TXhmFikaHp7T4BnC1WpUkg+eUhBv7+rGyZcG0/9X8oT6Sma8HW17+n
         FmJHvht17DvYJ36KcmfYY1Z6jyfHZYGwb4gs0ydDut+RheltnIBZ6rTr6kghAMFaMO05
         MheViuGVDm35SfSClKayn+y7JxInaahDHKIf3dbdi3y/DT3WQNlWc9TZPJWqazeSgnye
         QGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5MqOXU/GO6ySFXNdWWpGuGaYsTEAcOj5xz5y35r5Kxw=;
        b=l20v84164UEH0X0oZthvzo7jYQf6gtv4AcNusVoI0EvSCMTBVuwdcp9x9RBCMlvl67
         YlpuJHCshMI//D2xM9m1Y61z1yhz8rUY3YXYJ1UDSbJp98vl6Ib+/N3uke7OtVf/WFHT
         b286nKnqCORdtHHp4TIVQLJa6gvg1xczbTf+OImgwI+SDUXeBPrDuIywHxhzzhrbL9uN
         YpMTzjq8sm+KDWp0FYR9ymoZllxkiEac9g6fwvxGmetfNY8lGJ0sW/6oRECjEC97sNn0
         n0mwmFb3QvmCDh3kRsuH/Kmm1tDkk7hP2BxtWoDMPi3kKFaDnfmyzE9JJBBXoL6s8hYy
         y/CA==
X-Gm-Message-State: ACrzQf39NvR4RZy9WywV1vXr9LR77LD+TtSWChlp5kLACOCKgicbio1G
        DEbRamVLsxgRQtCBxutNyTO/7AdjXe3a73N7o6/of3FM
X-Google-Smtp-Source: AMsMyM4QKMpoaz+44sH+jKxwKWN+ZsTho/+CQpR1rbUpQk2dFn2DAN8Jf965QZxAQ0DeiKhSOOFO6cv1CgQx+iVlIZg=
X-Received: by 2002:ab0:6494:0:b0:3da:7cac:c48d with SMTP id
 p20-20020ab06494000000b003da7cacc48dmr1366569uam.96.1665024830440; Wed, 05
 Oct 2022 19:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms9NbH+_ruMke+ezYo-7+qZuinrP_SQbHxf3E3ikxnN0A@mail.gmail.com>
 <CAH2r5mvmYgfDQ4aYGJf+_1fC9aW4HCRVtm92dQe5CvAtc-5NOg@mail.gmail.com>
 <CAKYAXd9Pso5=OeCHQqSKD_8jw1N+7HwVh=rsGgEzJgwdXPMGPw@mail.gmail.com> <CAH2r5mtuUJ7pQ4XcmXSOPvq26MSim=p_x_SOy7ympOVKgb-CLA@mail.gmail.com>
In-Reply-To: <CAH2r5mtuUJ7pQ4XcmXSOPvq26MSim=p_x_SOy7ympOVKgb-CLA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 Oct 2022 21:53:39 -0500
Message-ID: <CAH2r5mv+-rcy2wZM7KfX7sMovm4KRzP0KUzCgk+5Tk=i8_rfLg@mail.gmail.com>
Subject: Fwd: build failures on 6.0
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Wed, Oct 5, 2022 at 9:41 PM
Subject: Re: build failures on 6.0
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>


I worked around it by installing gcc-12

sudo add-apt-repository ppa:ubuntu-toolchain-r/test

sudo apt-get install gcc-12

cd /usr/bin

sudo rm gcc

sudo ln gcc-12 gcc


On Wed, Oct 5, 2022 at 6:37 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> Hi Steve,
>
> The kernel was built by: x86_64-linux-gnu-gcc (Ubuntu 12.2.0-3ubuntu1) 12=
.2.0
>   You are using:           gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0
>
> Have you ever tried to do make clean and make again ?
> It seems that you upgraded ubuntu before ... ? the version looks differen=
t.
>
> Thanks!
>
>
> 2022-10-06 8:02 GMT+09:00, Steve French <smfrench@gmail.com>:
> > This is actually ubuntu 22.04 which fails building out of tree modules
> > (as we do for testing) on 6.0-rc7 (last working one was 6.0-rc3) and
> > later
> >
> > On Wed, Oct 5, 2022 at 6:00 PM Steve French <smfrench@gmail.com> wrote:
> >>
> >> I noticed that 6.0-rc7 and later don't build out of tree modules (was
> >> trying to setup ksmbd for running buildbot tests).  Any ideas about
> >> this "unrecognized command-line option" for gcc error (this is on
> >> Ubuntu)
> >>
> >> smfrench@ubuntu20-ksmbd-target:~/smb3-kernel/fs/ksmbd$ ~/build-stock-c=
ifs
> >> make: Entering directory '/usr/src/linux-headers-6.0.0-060000-generic'
> >> warning: the compiler differs from the one used to build the kernel
> >>   The kernel was built by: x86_64-linux-gnu-gcc (Ubuntu 12.2.0-3ubuntu=
1)
> >> 12.2.0
> >>   You are using:           gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0
> >>   CC [M]  /home/smfrench/smb3-kernel/fs/ksmbd/unicode.o
> >> gcc: error: unrecognized command-line option
> >> =E2=80=98-ftrivial-auto-var-init=3Dzero=E2=80=99
> >> make[1]: *** [scripts/Makefile.build:249:
> >> /home/smfrench/smb3-kernel/fs/ksmbd/unicode.o] Error 1
> >> make: *** [Makefile:1858: /home/smfrench/smb3-kernel/fs/ksmbd] Error 2
> >> make: Leaving directory '/usr/src/linux-headers-6.0.0-060000-generic'
> >> smfrench@ubuntu20-ksmbd-target:~/smb3-kernel/fs/ksmbd$ uname -a
> >> Linux ubuntu20-ksmbd-target 6.0.0-060000-generic #202210022231 SMP
> >> PREEMPT_DYNAMIC Sun Oct 2 22:35:09 UTC 2022 x86_64 x86_64 x86_64
> >> GNU/Linux
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >



--=20
Thanks,

Steve


--=20
Thanks,

Steve
