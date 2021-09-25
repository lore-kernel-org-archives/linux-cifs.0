Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF87C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 10:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D32E61279
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 10:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240911AbhIYKeG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 06:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234958AbhIYKeD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 25 Sep 2021 06:34:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FB0D60EC0
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 10:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632565949;
        bh=TpJejBaZ1jTzr+4qw0tLF0AB7cW+yGB/LvqHzZ8QiQI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=eJqO95AAyZevMRcdhuET/NNUEYeLZtJDuvcdQO2b5XEbzfGOWxiBbZSADoi36P7Za
         1JS5XlcfMaI0ElH6DxIomANNuuHXpmA83iheH7neb40iStEasDENlslqYHjj+G/POk
         /6bmbGkg7W/JJCG73fXA0vcuog7NLIZ0RBJs70PXax8heqUvIiHXQ7iZA2Xx1WJo4Y
         vbji+00oxEabdBpU86HCQh59Z0xI5/kQfrL+er9RdW5xRMgdym1TcSAxDrjFzdr6Wa
         x2J99ZNmDd6F7O5/a445Ki08sJgKzM4abFOt3Xie2qTVLtFbA/c3vq8c9AHQTjKZSG
         EWT1mpzZav3tQ==
Received: by mail-ot1-f42.google.com with SMTP id h9-20020a9d2f09000000b005453f95356cso16696513otb.11
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 03:32:29 -0700 (PDT)
X-Gm-Message-State: AOAM533O55R97dxHTX8UvAMd73W6F3XqxD0MB2+eoN7oNQk05eSnsTrO
        2ISKFVh3wgT4qZlzqwEGJlKCJVRINaj9hVns7oI=
X-Google-Smtp-Source: ABdhPJx3gxK7HMC0lvuisn9xMMwLeJd1dWL11VS1o2qDihvdFZ/aEVNVgD41hzVSteel5XNeFvsHfztFrEUlqTYWObM=
X-Received: by 2002:a05:6830:24a8:: with SMTP id v8mr7873609ots.185.1632565948878;
 Sat, 25 Sep 2021 03:32:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 25 Sep 2021 03:32:28
 -0700 (PDT)
In-Reply-To: <408a97fe-19dc-54dd-eb15-284043ddee69@samba.org>
References: <040d44a6-5c7c-5053-6e03-8db045519c0a@samba.org> <408a97fe-19dc-54dd-eb15-284043ddee69@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 25 Sep 2021 19:32:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd82DJPwH_LTYSQE56hftW2v2ZW_kSqmCSymDTSciddi=w@mail.gmail.com>
Message-ID: <CAKYAXd82DJPwH_LTYSQE56hftW2v2ZW_kSqmCSymDTSciddi=w@mail.gmail.com>
Subject: Re: Building ksmbd as external module on kernel < 5.15
To:     Ralph Boehme <slow@samba.org>
Cc:     COMMON INTERNET FILE SYSTEM SERVER <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-25 18:51 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 25.09.21 um 11:15 schrieb Ralph Boehme:
>> Is building the module on older kernels (I'm
>> on 5.13.14-200.fc34.x86_64) actually supported?
>
> as checkpatch.pl warns about using LINUX_VERSION_CODE, I guess the
> building on older kernels is not supported anymore.
>
> Is there any other way to just compile the module against a running
> distro kernel? Or do I have to bite the bullit and build and install the
> full kernel?
Yes. Install the latest kernel or use QEMU.
>
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
