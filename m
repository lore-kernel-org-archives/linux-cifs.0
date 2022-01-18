Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3660AC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jan 2022 16:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbiARQ0y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Jan 2022 11:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235878AbiARQ0y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Jan 2022 11:26:54 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BCFC061574
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jan 2022 08:26:53 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id o15so72839050lfo.11
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jan 2022 08:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=JTUB5ic0JD5Skfd8nRgcdVQ3dICdSvSAyGsCx+vPqJk=;
        b=OOFaiguktVi3FkZ2+Ll4jPQFgzms11IDbW0Ixgtta6RDrmTphyTvyG//Ob6a+Eg1lk
         py2r/8qeKUrhmI4AJga3guBjKCGpuJMji0KjQmbDHK32imlrRoj6QINakDykVWqD3l2w
         m+2K75C20Cv+JdaZOBIvAHXj1GFCJZ8xLAo8copnZuVua2l2JI83OTvQUM1mMu7kq8jj
         ZFhe7S5Yce44Vcsyd+lIkbygo8XEc5dZZzRqwGT36EUp+jrMbx2ZfnCMkRof7szDCPMX
         P0NzzTigDPm42VlchOUPBd4I2t6/J6IZTPVtrsjR/fH555WnMVZzpRC3NlsbBu9w/XkL
         ViEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JTUB5ic0JD5Skfd8nRgcdVQ3dICdSvSAyGsCx+vPqJk=;
        b=SbQaNTjQNLe2szf71F43XN9IavqnOSoaAYXHAXW/NvqJnA7XMj61wylSC8PQnD98dG
         nryyac/YUK+PXUHSgLOTrnSQBld+T+nwDA+j6IZgsXkS/5hEeAE7lukWImHktBjrt8fV
         s+CWYYCc9uUVA9k8AxkviqvthwV3g0u1NSQTwCdG4xqSBSo/i553ZZu2VeMtbBlCnCmA
         E3u7uiJRGGnGdGLhW0Xw5kR8vUvAG8oUwlFOttU0GiihleujryZgxO3HJfgxRSQAgxbt
         MBZqymnhHmqx13Zdx0OSiLYx+O3UkeHB3ODJPk0HYno/YOILhQoHd4HI2vnVGlCGJZJV
         njKQ==
X-Gm-Message-State: AOAM533zdc0DwmU+SUAvStf30XHTl4/kj3vG00xQUjOF4hYg3QtJBdUJ
        IJX5jlRmjqwG+cYinomrk+Z+rZNvadPO6U1Cls6Ror2IeOA=
X-Google-Smtp-Source: ABdhPJzXLyvEiDukAv9ztFvTsnIBcgOh+DjQSAioG/h1ntKQQHsJELcdYolcdDNO35uXaWTN7gvRytWW+DaaNJ8k0dI=
X-Received: by 2002:a2e:8658:: with SMTP id i24mr19918147ljj.209.1642523211899;
 Tue, 18 Jan 2022 08:26:51 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 18 Jan 2022 10:26:40 -0600
Message-ID: <CAH2r5msUYQPgRgCBTwt_=aO++yNtqD5+tnVgud1sdspUvvLUOw@mail.gmail.com>
Subject: memleak on test generic/422 to windows
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

generic/422 18s ... _check_kmemleak: something found in kmemleak (see
/data/xfstests-dev/results//smb3/generic/422.kmemleak)

Ran: generic/422
Failures: generic/422
Failed 1 of 1 tests

SECTION       -- smb3
=========================
Ran: generic/422
Failures: generic/422
Failed 1 of 1 tests

[root@fedora29 xfstests-dev]# cat
/data/xfstests-dev/results/smb3/generic/422.kmemleak
EXPERIMENTAL kmemleak reported some memory leaks!  Due to the way kmemleak
works, the leak might be from an earlier test, or something totally unrelated.
unreferenced object 0xffff93ce8da27680 (size 64):
  comm "xfs_io", pid 2192, jiffies 4295079181 (age 11.080s)
  hex dump (first 32 bytes):
    20 e7 15 97 ce 93 ff ff 20 e7 15 97 ce 93 ff ff   ....... .......
    c0 5a 77 88 ce 93 ff ff 00 00 00 00 00 00 00 00  .Zw.............
  backtrace:
    [<000000006347e51d>] kmem_cache_alloc_trace+0x148/0x1e0
    [<000000008fd709d1>] cifs_close+0x53/0x1d0 [cifs]
    [<0000000078434f61>] __fput+0x9b/0x260
    [<000000007c7c1be3>] task_work_run+0x6a/0xa0
    [<0000000010962b60>] do_exit+0x386/0xc80
    [<00000000ea225eec>] do_group_exit+0x33/0xb0
    [<00000000a9ccd814>] get_signal+0xbe/0xee0
    [<000000006bfe7e75>] arch_do_signal_or_restart+0xba/0x710
    [<00000000606ff0f6>] exit_to_user_mode_prepare+0xe8/0x2b0
    [<00000000645b542d>] syscall_exit_to_user_mode+0x2c/0x60
    [<000000009113bdcc>] do_syscall_64+0x46/0x80
    [<00000000f9e0cc0a>] entry_SYSCALL_64_after_hwframe+0x44/0xae
unreferenced object 0xffff93ce8db5df40 (size 64):
  comm "xfs_io", pid 2206, jiffies 4295079315 (age 10.946s)
  hex dump (first 32 bytes):
    10 74 33 97 ce 93 ff ff 10 74 33 97 ce 93 ff ff  .t3......t3.....
    c0 5a 77 88 ce 93 ff ff 00 00 00 00 00 00 00 00  .Zw.............
  backtrace:
    [<000000006347e51d>] kmem_cache_alloc_trace+0x148/0x1e0
    [<000000008fd709d1>] cifs_close+0x53/0x1d0 [cifs]
    [<0000000078434f61>] __fput+0x9b/0x260
    [<000000007c7c1be3>] task_work_run+0x6a/0xa0
    [<0000000010962b60>] do_exit+0x386/0xc80
    [<00000000ea225eec>] do_group_exit+0x33/0xb0
    [<000000007effc4d0>] __x64_sys_exit_group+0x14/0x20
    [<0000000026ca460f>] do_syscall_64+0x3a/0x80
    [<00000000f9e0cc0a>] entry_SYSCALL_64_after_hwframe+0x44/0xae


-- 
Thanks,

Steve
