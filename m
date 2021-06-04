Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECB1C07E94
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 09:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 932A16108D
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 09:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhFDJXP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 05:23:15 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:44904 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhFDJXP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Jun 2021 05:23:15 -0400
Received: by mail-ej1-f46.google.com with SMTP id c10so13400759eja.11
        for <linux-cifs@vger.kernel.org>; Fri, 04 Jun 2021 02:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=hy/qFdBqxnuvliwIjp97UN0D29BYkAVb7TMvJfgcgs0=;
        b=QeWMrNbKywBFEOv7REdQjtOA11T9a4l+Go6fuCCYNNrMLtH8qzH3JyR763YM9BXDlV
         Rkvp9FVhrH4XQ8vmyD7SOv/nwSa8tglOsz4hTkkaoLv3r8WtIU0NbhDO/r0t3dCsizGX
         NtaO1sLKVSS54+UUv3RyCxhRu2MBloCMHahVb3LqhiZPe8UUGz2MgbWfa6uX6ddvFXjf
         B3Q2smzYEKAsCMK4Lf1kbFV9fDxOuYmRPsgupPV+x35pu3D/CMwSFmeavi9aFPqSLG3T
         YY/mlqv53Vy1BVGzffrup+S50mxeGBbQBjtEXpyOm8gP3+XKwhzH40n6i7yErt2np8/E
         WMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=hy/qFdBqxnuvliwIjp97UN0D29BYkAVb7TMvJfgcgs0=;
        b=WH5Ta2MVgRCCWl+gkadkvDDpkvERb63u9Hry3s9J12Dy6klEe0Och8w3R6jBcmSysT
         O4OOGtStHGIbfUinXyVPNjKRIZdwafRHGz1HwyLbzdRBPOm2sWYA2/wIED6zlSQUeNTK
         hx069hovFP/W2rhbns9FC1ipU0z9Y2PZcNQIsE/e/RNWY0EHAyC9z1mb8Cx9li6gJdLC
         uzfCfACb1z8eToCalis05IWLW61+9CjVJEND6JJQKRk43EOdX/rnGMuRJk5QUOV+POwR
         hQeX0sA+aVB8T4upLO6R5vCmdTAs27nxg8nj9S3Hy+FsfKw0Ybd0EscHcU7pmUVj47I8
         /v5A==
X-Gm-Message-State: AOAM532qaTYPk8K/59Ii5OAD5T6NZ+VfvAYvgoywbRfNPoUB8/h5H+9J
        TXQBgiaKOwVbopu0ogFcnMblo52vxlBFLOowJj2eafep1fvIOf/z
X-Google-Smtp-Source: ABdhPJwkGJjRjKIcmJirI7Y6tIxR9hgQPaSiTRjT1j1NsCCJNsKTajl1oRrxbpDpDy2+lhQRgv0f9CB3LE9YFl7PsMI=
X-Received: by 2002:a17:906:9d05:: with SMTP id fn5mr3247466ejc.133.1622798427976;
 Fri, 04 Jun 2021 02:20:27 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 4 Jun 2021 14:50:16 +0530
Message-ID: <CA+G9fYsnWUYuahxv3+vQx3UQ_CvJ5caiQwb7BXEuDGxPjmrM1w@mail.gmail.com>
Subject: [next] fs: cifsglob.h:955:20: error: passing argument 2 of 'test_bit'
 from incompatible pointer type
To:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Steve French <sfrench@samba.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The following builds failed on Linux next-20210604 due to warnings / errors.

  - arm (s3c2410_defconfig) with gcc- 8 / 9 / 10
  - parisc (defconfig) with gcc-8 / 9 / 10
  - powerpc (ppc6xx_defconfig) with gcc- 8 / 9 /10

In file included from fs/cifs/transport.c:38:
fs/cifs/transport.c: In function 'cifs_pick_channel':
fs/cifs/cifsglob.h:955:20: error: passing argument 2 of 'test_bit'
from incompatible pointer type [-Werror=incompatible-pointer-types]
  955 |  test_bit((index), &(ses)->chans_need_reconnect)
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |
           size_t * {aka unsigned int *}
fs/cifs/transport.c:1065:7: note: in expansion of macro
'CIFS_CHAN_NEEDS_RECONNECT'
 1065 |   if (CIFS_CHAN_NEEDS_RECONNECT(ses, index))
      |       ^~~~~~~~~~~~~~~~~~~~~~~~~
In file included from arch/powerpc/include/asm/bitops.h:193,
                 from include/linux/bitops.h:32,
                 from include/linux/kernel.h:12,
                 from include/linux/list.h:9,
                 from include/linux/wait.h:7,
                 from include/linux/wait_bit.h:8,
                 from include/linux/fs.h:6,
                 from fs/cifs/transport.c:23:
include/asm-generic/bitops/non-atomic.h:104:66: note: expected 'const
volatile long unsigned int *' but argument is of type 'size_t *' {aka
'unsigned int *'}
  104 | static inline int test_bit(int nr, const volatile unsigned long *addr)
                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
cc1: some warnings being treated as errors
make[3]: *** [scripts/Makefile.build:272: fs/cifs/transport.o] Error 1
fs/cifs/sess.c: In function 'cifs_chan_set_need_reconnect':
fs/cifs/sess.c:98:22: error: passing argument 2 of 'set_bit' from
incompatible pointer type [-Werror=incompatible-pointer-types]
   98 |  set_bit(chan_index, &ses->chans_need_reconnect);
             ^~~~~~~~~~~~~~~~~~~~~~~~~~
             |
             size_t * {aka unsigned int *}


Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Full build log:
https://gitlab.com/Linaro/lkft/mirrors/next/linux-next/-/jobs/1317929765#L247

Steps to reproduce:
-----------------------------

# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.

tuxmake --runtime podman --target-arch arm --toolchain gcc-8 --kconfig
s3c2410_defconfig


--
Linaro LKFT
https://lkft.linaro.org
