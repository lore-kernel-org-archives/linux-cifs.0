Return-Path: <SRS0=CLpK=A7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52D7C433E1
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Jul 2020 17:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ECC7207DF
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Jul 2020 17:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WYg2jBCn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgGTRJs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Jul 2020 13:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728782AbgGTRJr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Jul 2020 13:09:47 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75979C061794
        for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2020 10:09:47 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id e15so8874053vsc.7
        for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2020 10:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=/3Gvp4yLww6oterTuFs3fZNcSDJN/p/gq8f18M7pTT8=;
        b=WYg2jBCnrw7GqZmSJzveIovOWTJGnRPQqrw+7y7JKXZEa+orHbWLYkp6onEodI8oKI
         QLa1Pns775qbw28NW892Mg1CqK5GeCGQypuRHk2O+zIVa0REu2sc8nw/swUGaG6JS0Na
         KH5RydF3L3J9CurTwGBgP49p/XYFDxcu0P2w4wQ7JswEvDceGl0s7eYfc0e6kEKnJlDP
         EuwieurxdlCDi1bWjsMEFha6u6th85wpXevtdD4iGmGS8LZ3FVTXC1Uezj1BjCs8tz+n
         DWghrV9WbeAq2eToiYUVnweZ7YHo/sV8kagUhPDOLq9nkd9fSnXtouzW/W8Ekqq72sye
         Emww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=/3Gvp4yLww6oterTuFs3fZNcSDJN/p/gq8f18M7pTT8=;
        b=CJADb4GHTifKDg0GuuwETl4QjDgRENCAovZWJNwpmBgc6u2hmf+AR9ExVGY5itlqt4
         bASQ/0IHf2WomNL+pdxwLQDua/wStoXNbS/yf12uh20vk7DuuFSWrEj2N3M6xP9L6p8S
         5fR03hzYImuFq8WpGDA9eGYE6AlkwyRZjkG8E8dS7hRPS2XBwfb9Lms5a23wBJIa47dy
         LRYN2DD/BkXuiYjfluG9DXjeigt10Z3j0NpHh5Yn8pIK6Qw/4Vv/eEV579xgl0/rt4R9
         5gDrJwU6IVPuAz+6ni+m9vrgL/OdaeDb7xxBWWvvoVMzwqlRqka87XdWeiD8o9ECewQq
         xYMw==
X-Gm-Message-State: AOAM532e0bJQtEKI9tt5RLGn1XXPKjHVfPOMWTMGyQehlcuK9ZZLajTP
        D99qYrDtuAC0ukhSYBp6XA0YJwjiKMJ64nMZVw==
X-Google-Smtp-Source: ABdhPJwOIJ2QZnGMWzhgH2MrZFOknnLOgXib99jf0t1PicqHCO+68aPh+nU7gb7Req+Ywk5Il1zdAEs+cbdZeP+Yt0Q=
X-Received: by 2002:a05:6102:127c:: with SMTP id q28mr17347321vsg.231.1595264986434;
 Mon, 20 Jul 2020 10:09:46 -0700 (PDT)
MIME-Version: 1.0
From:   Patrick Fernie <patrick.fernie@gmail.com>
Date:   Mon, 20 Jul 2020 13:09:35 -0400
Message-ID: <CAD737DGhAiRUb6WZz_RQ6GwfXwH3CFB_5iOmzvnJwSPoncXdLg@mail.gmail.com>
Subject: PROBLEM: mv command fails: "File exists" on cifs mount on kernel>=5.7.8
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

# One line summary of the problem:

mv command fails: "File exists" on cifs mount on kernel>=3D5.7.8

# Full description of the problem/report:

Since v5.7.8 (v5.4.51 for -lts), there appears to be a regression with
cifs mounts; mv commands fail with a "File exists" when attempting to
overwrite a file. Similarly, rsync commands which create a temporary
file during transfer and then attempt to move it into place after
copying fail ("File Exists (17)"). I believe this is related to this
commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/co=
mmit/fs/cifs/inode.c?id=3D9ffad9263b467efd8f8dc7ae1941a0a655a2bab2

The mount in question is from a Drobo FS NAS device, and is forced to
SMB1 (`vers=3D1.0` specified).

Running v5.7.7 or 5.4.50 does not exhibit this behavior, behavior was
confirmed on 5.7.8, 5.7.9, 5.4.51 and 5.4.52.

These users appear to be experiencing the same issue:
1) https://serverfault.com/questions/1025734/cifs-automounts-suddenly-stopp=
ed-working
2) https://unix.stackexchange.com/questions/599281/cifs-mount-is-returning-=
errors-when-operating-on-remote-files-file-exists-inte

# Most recent kernel version which did not have the bug:

5.7.7 / 5.4.50

# A small shell script or example program which triggers the problem
(if possible):

[vagrant@archlinux ~]$ uname -a
Linux archlinux 5.7.9-arch1-1 #1 SMP PREEMPT Thu, 16 Jul 2020 19:34:49
+0000 x86_64 GNU/Linux
# Same behavior seen on Linux archlinux 5.4.52-1-lts #1 SMP Thu, 16
Jul 2020 19:35:06 +0000 x86_64 GNU/Linux
[vagrant@archlinux ~]$ cd /mnt/drobo/Share/cifs-test/
[vagrant@archlinux cifs-test]$ touch a b
[vagrant@archlinux cifs-test]$ mv a b
mv: cannot move 'a' to 'b': File exists
[vagrant@archlinux cifs-test]$ mkdir -p /tmp/sync_dir
[vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
[vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
[vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
[vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
rsync: [receiver] rename
"/mnt/drobo/Share/cifs-test/sync_dir/.foo.FQiit5" -> "sync_dir/foo":
File exists (17)
rsync error: some files/attrs were not transferred (see previous
errors) (code 23) at main.c(1287) [sender=3D3.2.2]

## Behavior as expected on older kernel:

[vagrant@archlinux ~]$ uname -a
Linux archlinux 5.7.7-arch1-1 #1 SMP PREEMPT Wed, 01 Jul 2020 14:53:16
+0000 x86_64 GNU/Linux
# Same behavior seen on Linux archlinux 5.4.50-1-lts #1 SMP Wed, 01
Jul 2020 14:53:03 +0000 x86_64 GNU/Linux
[vagrant@archlinux ~]$ cd /mnt/drobo/Share/cifs-test/
[vagrant@archlinux cifs-test]$ touch a b
[vagrant@archlinux cifs-test]$ mv a b
[vagrant@archlinux cifs-test]$ mkdir -p /tmp/sync_dir
[vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
[vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
[vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
[vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
[vagrant@archlinux cifs-test]$

# Environment:

Arch Linux

CIFS mount (vers=3D1.0) from Drobo FS NAS device

CIFS share mount information:

systemd-1 on /mnt/drobo/Share type autofs
(rw,relatime,fd=3D44,pgrp=3D1,timeout=3D0,minproto=3D5,maxproto=3D5,direct,=
pipe_ino=3D12139)
//10.76.9.11/Share on /mnt/drobo/Share type cifs
(rw,relatime,vers=3D1.0,cache=3Dstrict,username=3DXXXXXXX,uid=3D0,noforceui=
d,gid=3D0,noforcegid,addr=3D10.76.9.11,file_mode=3D0775,dir_mode=3D0775,noc=
ase,soft,nounix,serverino,mapposix,nobrl,noperm,rsize=3D61440,wsize=3D65536=
,bsize=3D1048576,echo_interval=3D60,actimeo=3D1,x-systemd.automount)

Regards,
Patrick Fernie
