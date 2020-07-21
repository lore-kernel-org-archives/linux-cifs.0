Return-Path: <SRS0=/QKu=BA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4686C433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Jul 2020 23:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7876420709
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Jul 2020 23:11:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QugQk0rJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgGUXLH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Jul 2020 19:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUXLG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Jul 2020 19:11:06 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A69C061794
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2020 16:11:06 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l17so189083iok.7
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2020 16:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8bvKB9VH/fywhPcoVWTA5S5sozlipU5wLHV2w6iYvEU=;
        b=QugQk0rJzFIrB2qkI+dTDZLu5rLbVcOGO1BleQWMotHyg+hsVFH3/gKXvKEnMI/Bjo
         HJhgYvXvDEFMBYvZU/AtTFpmkFlgQorXVBN4NV0EzTMmFPknCc82uSdKCX/2leFZkxBQ
         wga/KIZ4LgOyr06JW0IYic2aWh32uinWiRTd+Q03mpEdSFGtLSbdbmL69/E5pvRKRYRp
         cO/egtQggUluDXc7R595F2XG6/1EOAqZ8XrrCcp34Ps81idev+BbUAXf8tL8MRlD2l8F
         721vbPl7cVE3lpa9JSersb5SDu7IfIFrSvYUM9qiCEq4c8xB2IQyQk4pgajtvlatFg9R
         yQMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8bvKB9VH/fywhPcoVWTA5S5sozlipU5wLHV2w6iYvEU=;
        b=KL9GJcfWHodEGCC8365rDnZxksWGSjxbKE6Vq5HLZvc8j8KgE4koKXERVwX1GJp+K0
         XCrXodPiWm8gSSI/Bm/jXymSMYr6X52KXlaY2c0obPbWhEk8u3WjB3NaxEMJf4b7/yps
         /fEDrNhFo0Ah234nmNxgBTWFHPEKNKGMNzwz7YAIh4sswhJuZQQVCkZeOfg8sxh9N1ua
         cj5gpG7XRwoDfsdrYRaiU+k+2kWSPrCLJCUzcfJRTNKUzbsPB81gbDTaHYhbSf6firVG
         7cM6aN2eucUBs13I8ASAIXKAxJ54od7ZJBQAFvjU0SfMtnMpDqc0A997bNYEUfLaaIwZ
         8lqw==
X-Gm-Message-State: AOAM5326JNRSOrWBo7Epix08x7u755L7rGda98q8nWuiIV46alJ/D5xM
        6bLLrojcmM5eMF+EQlPRJ0IiKQ/ENVxHX4mXbKk=
X-Google-Smtp-Source: ABdhPJzhag+KQrWpd/AapO6Tpei06ifjCy2BPWGhJDlUS90bTSoC0zfX3kRN5EK+DJxnB1ELXTGi2W+tTNQXProMuJY=
X-Received: by 2002:a5e:d80e:: with SMTP id l14mr25332489iok.65.1595373065905;
 Tue, 21 Jul 2020 16:11:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAD737DGhAiRUb6WZz_RQ6GwfXwH3CFB_5iOmzvnJwSPoncXdLg@mail.gmail.com>
 <d8dbaf42-0f81-f25e-ea47-28b29c44fcd1@huawei.com>
In-Reply-To: <d8dbaf42-0f81-f25e-ea47-28b29c44fcd1@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 21 Jul 2020 18:10:54 -0500
Message-ID: <CAH2r5mucBQ8cYCdahhv2i6nMhotyUS3PcuEi5hsonP5DL7pNug@mail.gmail.com>
Subject: Re: PROBLEM: mv command fails: "File exists" on cifs mount on kernel>=5.7.8
To:     "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Cc:     Patrick Fernie <patrick.fernie@gmail.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

By the way - I am unable to reproduce this on smb3 or later.  It only
seems to be an smb1 regression.

Any additional updates or information?

On Tue, Jul 21, 2020 at 8:52 AM zhangxiaoxu (A) <zhangxiaoxu5@huawei.com> w=
rote:
>
> Thanks for your report.
>
> Since commit 9ffad9263b46 ("cifs: Fix the target file was deleted
> when rename failed.") want to fix the problem when rename(file1, file2)
> with file2 exist, the server return -EACESS, then cifs client will
> delete the file2 and rename it again, but 2nd rename on server also
> return -EACESS, then the file2 was deleted.
>
> It can be reproduce by xfstests generic/035.
> When 't_rename_overwrite file1 file2':
>    open(file2)
>    rename(file1, file2)
>    fstat(file2).st_nlink should be 0.
>
> The solution on commit 9ffad9263b46 ("cifs: Fix the target file was
> deleted when rename failed.") was wrong. we should revert it.
>
> The root cause of the file2 deleted maybe the file2 was opened
> when rename(file1, file2), I will re-debug it.
>
> =E5=9C=A8 2020/7/21 1:09, Patrick Fernie =E5=86=99=E9=81=93:
> > # One line summary of the problem:
> >
> > mv command fails: "File exists" on cifs mount on kernel>=3D5.7.8
> >
> > # Full description of the problem/report:
> >
> > Since v5.7.8 (v5.4.51 for -lts), there appears to be a regression with
> > cifs mounts; mv commands fail with a "File exists" when attempting to
> > overwrite a file. Similarly, rsync commands which create a temporary
> > file during transfer and then attempt to move it into place after
> > copying fail ("File Exists (17)"). I believe this is related to this
> > commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.gi=
t/commit/fs/cifs/inode.c?id=3D9ffad9263b467efd8f8dc7ae1941a0a655a2bab2
> >
> > The mount in question is from a Drobo FS NAS device, and is forced to
> > SMB1 (`vers=3D1.0` specified).
> >
> > Running v5.7.7 or 5.4.50 does not exhibit this behavior, behavior was
> > confirmed on 5.7.8, 5.7.9, 5.4.51 and 5.4.52.
> >
> > These users appear to be experiencing the same issue:
> > 1) https://serverfault.com/questions/1025734/cifs-automounts-suddenly-s=
topped-working
> > 2) https://unix.stackexchange.com/questions/599281/cifs-mount-is-return=
ing-errors-when-operating-on-remote-files-file-exists-inte
> >
> > # Most recent kernel version which did not have the bug:
> >
> > 5.7.7 / 5.4.50
> >
> > # A small shell script or example program which triggers the problem
> > (if possible):
> >
> > [vagrant@archlinux ~]$ uname -a
> > Linux archlinux 5.7.9-arch1-1 #1 SMP PREEMPT Thu, 16 Jul 2020 19:34:49
> > +0000 x86_64 GNU/Linux
> > # Same behavior seen on Linux archlinux 5.4.52-1-lts #1 SMP Thu, 16
> > Jul 2020 19:35:06 +0000 x86_64 GNU/Linux
> > [vagrant@archlinux ~]$ cd /mnt/drobo/Share/cifs-test/
> > [vagrant@archlinux cifs-test]$ touch a b
> > [vagrant@archlinux cifs-test]$ mv a b
> > mv: cannot move 'a' to 'b': File exists
> > [vagrant@archlinux cifs-test]$ mkdir -p /tmp/sync_dir
> > [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> > [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> > [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> > [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> > rsync: [receiver] rename
> > "/mnt/drobo/Share/cifs-test/sync_dir/.foo.FQiit5" -> "sync_dir/foo":
> > File exists (17)
> > rsync error: some files/attrs were not transferred (see previous
> > errors) (code 23) at main.c(1287) [sender=3D3.2.2]
> >
> > ## Behavior as expected on older kernel:
> >
> > [vagrant@archlinux ~]$ uname -a
> > Linux archlinux 5.7.7-arch1-1 #1 SMP PREEMPT Wed, 01 Jul 2020 14:53:16
> > +0000 x86_64 GNU/Linux
> > # Same behavior seen on Linux archlinux 5.4.50-1-lts #1 SMP Wed, 01
> > Jul 2020 14:53:03 +0000 x86_64 GNU/Linux
> > [vagrant@archlinux ~]$ cd /mnt/drobo/Share/cifs-test/
> > [vagrant@archlinux cifs-test]$ touch a b
> > [vagrant@archlinux cifs-test]$ mv a b
> > [vagrant@archlinux cifs-test]$ mkdir -p /tmp/sync_dir
> > [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> > [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> > [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> > [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> > [vagrant@archlinux cifs-test]$
> >
> > # Environment:
> >
> > Arch Linux
> >
> > CIFS mount (vers=3D1.0) from Drobo FS NAS device
> >
> > CIFS share mount information:
> >
> > systemd-1 on /mnt/drobo/Share type autofs
> > (rw,relatime,fd=3D44,pgrp=3D1,timeout=3D0,minproto=3D5,maxproto=3D5,dir=
ect,pipe_ino=3D12139)
> > //10.76.9.11/Share on /mnt/drobo/Share type cifs
> > (rw,relatime,vers=3D1.0,cache=3Dstrict,username=3DXXXXXXX,uid=3D0,nofor=
ceuid,gid=3D0,noforcegid,addr=3D10.76.9.11,file_mode=3D0775,dir_mode=3D0775=
,nocase,soft,nounix,serverino,mapposix,nobrl,noperm,rsize=3D61440,wsize=3D6=
5536,bsize=3D1048576,echo_interval=3D60,actimeo=3D1,x-systemd.automount)
> >
> > Regards,
> > Patrick Fernie
> >
> > .
> >
>


--=20
Thanks,

Steve
