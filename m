Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DE1C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 19:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 243C460F94
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 19:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhHJT3M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 15:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhHJT3M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Aug 2021 15:29:12 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666FEC0613C1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 12:28:49 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id z2so111302lft.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 12:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i7XaZWvNrWqYppF1d6NTdThVzd5KxFhBVezgJ/FbqNI=;
        b=PXcwdSarfk0XAW9aJGMOLs74poYu57HSKnlGiI/zdk63nB7GMb2zWQ9bLOMRTvJYrb
         C1OTaOlqiDqv8cC2vl8kS5I/yUFdajLz2jNXgeAdvQUhrujefpB5/yLhvanwj6EKe72y
         VbD8nj8BXVjnQQv9VLM0FRv5vIAIgJJ0UZ0GkDlt2q8vGhFw9B75OD/a/ak8QtBZKiyD
         XnOFyMwsa+iHNX67RI9PeAiZWwfkhnaOGewGh7sLfuZLIAfXGhyWqaALy1zawsl3KlJD
         D6W5nL41LPCVCh8K3qUrSNAZNqRZo93yhT0JKuGF1Osghix9ubVNfjvVrGnwUNVqnw6P
         OXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i7XaZWvNrWqYppF1d6NTdThVzd5KxFhBVezgJ/FbqNI=;
        b=g+MYV34NDnYd72WnIhJuS0S5dFF3A5W5d7EAOwI1XWFHxvNK8Pwn/S8BuIxGWMz87V
         oFZc1P9JmW4VJDMhEkHEiyQq6C2UlmKt/LqMec9dWLFlEBMhsrf9dUm3uaw7+FGEZTQz
         LFGxslcSgJY2UtTPGqGaZ8+C8V3umLcokQFgyJO0Jdoy86z/AXKMmnqCXhgr1Q150OkN
         6fhGAocwri+v2ZLcy9kX+eQIkWdGnIjPUZFblezssHkW6dc8SuTe66iaBdNXL/nS+nZ6
         KveDqMitLKZpns4PMcJ12+7Z4ZdsG+v0JvC3KGR2H8BgFjIMO1YflegueRXfy10tfyOg
         LErA==
X-Gm-Message-State: AOAM532qiqi0P3eg/sMGQUW5WRHHVHjmh6fah5BAap3adIrKwAQOmRjV
        6uvmevwO5PaxNO2Bfg6Lrl+F7MFIBueaUTep5fE=
X-Google-Smtp-Source: ABdhPJxcgFMA7Qo8hSVnGlm0TWac3f2lYBWUmEcejZBKcuzi8OddBR+Xqo/MEky9pnd/nzBr2jdo0VY48ykD9bHNrWs=
X-Received: by 2002:ac2:4350:: with SMTP id o16mr23921167lfl.184.1628623727601;
 Tue, 10 Aug 2021 12:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0Z4rDEGsi02+0DJnw2EoTV2CSC-jDN-SyDhKz0WcGZoAQ@mail.gmail.com>
 <CANT5p=rN_ogRccKmYpE+17qz=zRyUJChcKo5+cJiwDTFq_cBJw@mail.gmail.com> <CACdtm0aGGqtSsv1t2=VTGZZTBD52JvOsWD_oqXuUnejeDCVJFw@mail.gmail.com>
In-Reply-To: <CACdtm0aGGqtSsv1t2=VTGZZTBD52JvOsWD_oqXuUnejeDCVJFw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 10 Aug 2021 14:28:36 -0500
Message-ID: <CAH2r5mtQCC8upykXm5zZVO94-TRbxq2HMN5S65ROASwaRqOfuA@mail.gmail.com>
Subject: Re: [PATCH][CIFS]Call close synchronously during unlink/rename/lease break.
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I saw some test failures in

and looking in /var/log/messages I see e.g.

Aug 10 14:00:22 fedora29 systemd[1]: Started /usr/bin/bash -c exit 77.
Aug 10 14:00:25 fedora29 kernel: kmemleak: 10 new suspected memory
leaks (see /sys/kernel/debug/kmemleak)
Aug 10 14:00:28 fedora29 kernel: kmemleak: 1 new suspected memory
leaks (see /sys/kernel/debug/kmemleak)
Aug 10 14:00:28 fedora29 kernel: CIFS: Attempting to mount
\\win16.vm.test\Scratch
Aug 10 14:00:28 fedora29 kernel: CIFS: Attempting to mount
\\win16.vm.test\Scratch
Aug 10 14:00:29 fedora29 root[6460]: run xfstest cifs/100
Aug 10 14:00:29 fedora29 journal: run fstests cifs/100 at 2021-08-10 14:00:29
Aug 10 14:00:29 fedora29 systemd[1]: Started /usr/bin/bash -c test -w
/proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec
./tests/cifs/100.
Aug 10 14:00:30 fedora29 kernel: general protection fault, probably
for non-canonical address 0xdead000000000110: 0000 [#4] SMP PTI
Aug 10 14:00:30 fedora29 kernel: CPU: 0 PID: 6624 Comm: rm Tainted: G
    D           5.14.0-rc4 #1
Aug 10 14:00:30 fedora29 kernel: Hardware name: Red Hat KVM, BIOS
0.5.1 01/01/2011
Aug 10 14:00:30 fedora29 kernel: RIP:
0010:cifs_close_deferred_file+0x77/0x140 [cifs]
Aug 10 14:00:30 fedora29 kernel: Code: 85 de 00 00 00 4c 89 ef e8 06
96 2e e8 48 8b 1c 24 4c 39 e3 74 55 49 bd 00 01 00 00 00 00 ad de 48
bd 22 01 00 00 00 00 ad de <48> 8b 7b 10 31 d2 be 01 00 00 00 e8 a9 c5
fe ff 48 89 df e8 61 46
Aug 10 14:00:30 fedora29 kernel: RSP: 0018:ffffb121806dbdd0 EFLAGS: 00010287
Aug 10 14:00:30 fedora29 kernel: RAX: ffff88dc55b8ca01 RBX:
dead000000000100 RCX: 00000000000034d9
Aug 10 14:00:30 fedora29 kernel: RDX: 00000000000034d8 RSI:
67739b6f43694caa RDI: 0000000000032080

and

Aug 10 14:00:30 fedora29 kernel: ---[ end trace b062b12a095f4dd5 ]---
Aug 10 14:00:30 fedora29 kernel: RIP:
0010:cifs_close_deferred_file+0x77/0x140 [cifs]
Aug 10 14:00:30 fedora29 kernel: Code: 85 de 00 00 00 4c 89 ef e8 06
96 2e e8 48 8b 1c 24 4c 39 e3 74 55 49 bd 00 01 00 00 00 00 ad de 48
bd 22 01 00 00 00 00 ad de <48> 8b 7b 10 31 d2 be 01 00 00 00 e8 a9 c5
fe ff 48 89 df e8 61 46
Aug 10 14:00:30 fedora29 kernel: RSP: 0018:ffffb12180f0fc80 EFLAGS: 00010283
Aug 10 14:00:30 fedora29 kernel: RAX: ffff88dc5b2ca201 RBX:
dead000000000100 RCX: 0000000000002367
Aug 10 14:00:30 fedora29 kernel: RDX: 0000000000002366 RSI:
67100f614dfd246a RDI: 0000000000032080
Aug 10 14:00:30 fedora29 kernel: RBP: dead000000000122 R08:
0000000000000001 R09: 0000000000000001
Aug 10 14:00:30 fedora29 kernel: R10: ffffb12180f0fba0 R11:
0000000000000001 R12: ffffb12180f0fc80

On Tue, Aug 10, 2021 at 12:29 PM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Hi All,
>
> Have updated the patch to fix the memleak.
>
> Regards,
> Rohith
>
> On Tue, Aug 10, 2021 at 5:18 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > Already gave my review comments along with this one to the other email.
> >
> > Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
> >
> > On Mon, Aug 9, 2021 at 3:28 PM Rohith Surabattula
> > <rohiths.msft@gmail.com> wrote:
> > >
> > > Hi Steve/All,
> > >
> > > During unlink/rename/lease break, deferred work for close is
> > > scheduled immediately but in asynchronous manner which might
> > > lead to race with actual(unlink/rename) commands.
> > >
> > > This change will schedule close synchronously which will avoid
> > > the race conditions with other commands.
> > >
> > > Regards,
> > > Rohith
> >
> >
> >
> > --
> > Regards,
> > Shyam



-- 
Thanks,

Steve
