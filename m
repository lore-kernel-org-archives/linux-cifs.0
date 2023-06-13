Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5FBEB64D7
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jun 2023 23:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjFMXRv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Jun 2023 19:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjFMXRu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Jun 2023 19:17:50 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600BD199A
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jun 2023 16:17:49 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2b1acd41ad2so656821fa.3
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jun 2023 16:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686698267; x=1689290267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T9oFByAzuwdj+HsDoRgbHwbCEXCI0Rwd5k3Gw6RNojE=;
        b=Bwcj5rTA4MzDF+tXocbm/r7JcZIIzfMQcCeNt3W3EAt4lBk7I7xJCIPtcZYOOUy1JH
         luHw99WjiPBVy8o3JH/LaZHzJUlwx7uHuma1ieMT8WmiIy7jzNVwfFeIwwuZIK6+Amti
         O9FNGNtN37Z+GgeNOpccysbUyRZHnjznxYVOi91GQsXKaVrrXaKPff7S4q1a7IYwKOx1
         kfoZL+L/93u42sO+OeySFLc6cKdhp0ZRALG9OfswOpYeeSeMv7YVjrWV+ISntUPJFMi9
         EcDBcEK1ia6r6RniOr+V7VIbAxne2IDYQV0/cJqHpR3rK4zP79QOQGvCKztm6LvkHoe/
         GOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686698267; x=1689290267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T9oFByAzuwdj+HsDoRgbHwbCEXCI0Rwd5k3Gw6RNojE=;
        b=d5UoflyDCKpSv9g1kazJxc3b03Xo712DL8rfyKw83xTcnBwDPcQDjL6exNqyctm6gH
         azTtdoOD3CgG6npeG9o6xstyiMcjIE3dqtkE2iEqC3FSCgv/PDjtg93OIm4rxagfco/k
         PuDPCOUS8K3DbyOshiEQiL7cFtPNu9o8HaS/EhlRyhpyqy1yCclrohZHrEbdZkftJRQd
         6AINQIBqcEuI9bE1OLBiErd+RGArU7bqLG+a4FDEzgkVk9m6nNB2nXXCXOVmpC1zeKHR
         XBnusLg1D/Wqbe9a7dyIcZSfcCDIGFTap3nhDXVxGC3G8Fo3NC2zgAWlHsWtIZQzq3/p
         5X1g==
X-Gm-Message-State: AC+VfDxGG9+/W2Vm8Jg9dPSuPK6BF+s9ROHab/OrRJGMo1dw8TE5D2im
        gkCh46u2dtDst4/TZ6yBtHrpAbsVQu27y0plBLx/1oNanW4=
X-Google-Smtp-Source: ACHHUZ5eERM7hKG+43pMJWnWZy7bPCECwe7WCyHWlpfZyXI1mjb9cG7GpMyEAsJJGgnG28h0kYcohfNBBmU8AjYgy04=
X-Received: by 2002:a2e:87d3:0:b0:2b1:b6aa:c5f6 with SMTP id
 v19-20020a2e87d3000000b002b1b6aac5f6mr5407634ljj.7.1686698267231; Tue, 13 Jun
 2023 16:17:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muZavtKBU__Qy2s+XRG11u1HXyjC3oXF2yxY5h1b2jh1g@mail.gmail.com>
In-Reply-To: <CAH2r5muZavtKBU__Qy2s+XRG11u1HXyjC3oXF2yxY5h1b2jh1g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 13 Jun 2023 18:17:35 -0500
Message-ID: <CAH2r5muVt+x26kMQ+OsB4WOVZ4bqeTLtG0GAVSXksSuE6YDy=Q@mail.gmail.com>
Subject: Re: Samba returning mtime for multiple time stamp fields
To:     samba-technical <samba-technical@lists.samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Samba seems to be the only server with this bug (I tried it with and
without vfs_btrfs as well).  The test works to the other servers I
tried including Windows.

Windows server updates ctime on hardlinks, but Samba fails to update
the timestamps in this case since it looks like it populates both
ChangeTime (ctime) and LastWriteTime (mtime) based on mtime rather
than setting:    ChangeTime =3D ctime (and LastWriteTime =3D mtime).
Locally the mtime and ctime are correct on the Samba server, but
remotely it reports it wrong.

On Tue, May 9, 2023 at 3:54=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> I noticed a problem with Samba when running xfstest 236.
>
> xfstest/236 does
> touch file1
> stat file1
> ln file1 file2
> stat file2
>
> And checks to make sure ctime is updated.  Locally I can see the ctime
> is updated, but Samba reports the value of mtime in both mtime and
> ctime (and doesn't show the change to ctime which causes the test to
> fail)
>
> root@smfrench-ThinkPad-P52:/mnt2# stat /test/out1
>   File: /test/out1
>   Size: 0          Blocks: 8          IO Block: 4096   regular empty file
> Device: 10302h/66306d Inode: 552933716   Links: 2
> Access: (0777/-rwxrwxrwx)  Uid: ( 1000/smfrench)   Gid: ( 1000/smfrench)
> Access: 2023-05-09 15:49:37.000109800 -0500
> Modify: 2023-05-09 15:49:37.000109800 -0500
> Change: 2023-05-09 15:50:08.405799460 -0500
>  Birth: 2023-05-09 15:49:36.980131061 -0500
> root@smfrench-ThinkPad-P52:/mnt2# stat out1
>   File: out1
>   Size: 0          Blocks: 8          IO Block: 1048576 regular empty fil=
e
> Device: 35h/53d Inode: 226         Links: 2
> Access: (0777/-rwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2023-05-09 15:49:37.000109800 -0500
> Modify: 2023-05-09 15:49:37.000109800 -0500
> Change: 2023-05-09 15:49:37.000109800 -0500
>  Birth: 2023-05-09 15:49:36.980131000 -0500
>
> #  /usr/local/samba/sbin/smbd -V
> Version 4.19.0pre1-GIT-3633027e49a
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
