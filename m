Return-Path: <SRS0=xEhF=ST=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C0EC282DC
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 13:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 016F220872
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 13:50:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VHep33TN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732315AbfDQNuI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Apr 2019 09:50:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46108 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbfDQNuH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Apr 2019 09:50:07 -0400
Received: by mail-pf1-f194.google.com with SMTP id 9so12114639pfj.13
        for <linux-cifs@vger.kernel.org>; Wed, 17 Apr 2019 06:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WKX0Fpfw+NApY93/fExIhWXn/N/Dk+s13h6EJ37ZgIQ=;
        b=VHep33TN5yo3RX7Dc6YzLOe+CIjDXDiQqAFSnkBAYFFSl5cnDrmRjZ5xUDSBCN/O5D
         1uhGPPBr+aiOZaXwDA/3i+opXH4hbPe4ttAh8T2ww+V85fAsAOReeikQeUnGJfEA61uL
         0o0a00YcUNMokkWpAt9GzBvsbSA4xOBtfY4QsnejGTAuyEwD8MgQfE/sL2GgtDmJktVV
         CG8uDBKEfJYhi6KDosanbkaQmqxs8HZLDQpxZWhOdypUVcG+AaghUf8ZHle17VP0Rzek
         wCDl/f98IDutuL72apQQ1mJj/WJXi5p1Zeu56Td2fLvvjcofwNTaRu0pfWwBseQiUyAW
         18gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WKX0Fpfw+NApY93/fExIhWXn/N/Dk+s13h6EJ37ZgIQ=;
        b=Z4PhW8KErvktzO3j6QnBmDw1xV0qZ9rQzNIpkOl7Dv3iZJk0IdYyvMjQHPor+ea1SO
         RWBcU/HbLRRFK/0SQoxXr1gqek0xuoPAr+kO9Y88LURCZr5PhReoj33K7WTZXT9jbTVw
         VjJ4FZPnHThzP/0jf5Eho7IdLuQ1/RkyzrTyVWi2ePCI2BL3mOk0yMubCcAi6wyRET0t
         eKhe8QZMoG9rQab6vgKo7CjF+a4u8nJZRWFDdzVsVJh8uQvheMQ/dh5QuunqxlBxyqqx
         KPrxNvPV1o6MUzX1Bi1MaZsEYHLmyNVn03NRMGXLs1lknJWZUoett0ao7ZLwP7s81LwB
         DBZw==
X-Gm-Message-State: APjAAAXAhRG+e8U3GJKrfuZ56T0bHVYsFrSjHQVb00cCQVNvBbOrxuxe
        ozLrwH+/HLmf+s0t4OKV2+iVsU5ZV2bhtB453WWhnA==
X-Google-Smtp-Source: APXvYqw4ALsoAubIClB37Xp+BcdNikY1MMsymqENx+uUOD20tN0l2XAY3PEHadY5NTW8XxI8zyz8tHc9S72D5slcfdk=
X-Received: by 2002:a63:4e64:: with SMTP id o36mr84543318pgl.213.1555509006272;
 Wed, 17 Apr 2019 06:50:06 -0700 (PDT)
MIME-Version: 1.0
References: <359361880.3486881.1555294820885.JavaMail.zimbra@redhat.com> <510628530.3487503.1555295453817.JavaMail.zimbra@redhat.com>
In-Reply-To: <510628530.3487503.1555295453817.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 17 Apr 2019 08:49:54 -0500
Message-ID: <CAH2r5msb+euA-qCumXcQnRk3vw_9=Jm6MznE1t22YaRYKcrXkw@mail.gmail.com>
Subject: Re: [regression]: CIFS: block in wait_for_free_credits when open file
 for SMB1.0
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie's patch fixed this and I have merged into cifs-2.6.git for-next
and added cc:stable

On Sun, Apr 14, 2019 at 9:31 PM Xiaoli Feng <xifeng@redhat.com> wrote:
>
> Hi,
>
> Setup samba server on v5.1-rc3 and mount it in local with vers=3D1.0. Use=
 the reproducer below to test if open file succesffully after unlink.
> The process blocked in wait_for_free_credits and never return. SMB2.0+ do=
n't have this issue because of
>
>   https://bugzilla.kernel.org/show_bug.cgi?id=3D203271
>
> It's a regression issue. Testing pass on v4.9-rc8 but start failed after =
v5.0.
>
> [<0>] wait_for_free_credits+0x258/0x460 [cifs]
> [<0>] SendReceive+0xcd/0x360 [cifs]
> [<0>] CIFSPOSIXCreate+0x1bf/0x440 [cifs]
> [<0>] cifs_posix_open+0x1ee/0x300 [cifs]
> [<0>] cifs_do_create+0x447/0x710 [cifs]
> [<0>] cifs_atomic_open+0x1ab/0x530 [cifs]
> [<0>] path_openat+0xd54/0x1670
> [<0>] do_filp_open+0x93/0x100
> [<0>] do_sys_open+0x186/0x220
> [<0>] do_syscall_64+0x55/0x1a0
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [<0>] 0xffffffffffffffff
>
> reproducer.c:
> #define _GNU_SOURCE
> #include <fcntl.h>
> #include <stdlib.h>
> #include <stdio.h>
> #include <sys/file.h>
> #include <errno.h>
> void test()
> {
>     int fd;
>     int ret;
>
>     fd =3D open("./testfile",O_RDWR|O_CREAT,0644);
>     printf("errno=3D%d\n",errno);
>     if (fd < 0)
>     {
>         perror("open failed");
>         exit(1);
>     }
>     ret =3D unlink("./testfile");
>     if (ret < 0)
>     {
>         perror("unlink failed");
>         exit(1);
>     }
>     //add close(fd) here, then does not block.
> }
> int main(int argc, char **argv)
> {
>     int index=3D50;
>     while(index)
>     {
>         index--;
>         printf("loop %d\n",index);
>         test();
>     }
>     return 0;
> }
>
>
> I reported it in https://bugzilla.kernel.org/show_bug.cgi?id=3D203269
>
> --
> Best regards!
> XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
>
> Red Hat Software (Beijing) Co.,Ltd
> filesystem-qe Team
> IRC:xifeng=EF=BC=8C#channel: fs-qe
> Tel:+86-10-8388112
> 9/F, Raycom



--=20
Thanks,

Steve
