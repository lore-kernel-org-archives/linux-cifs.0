Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45109C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21F8061177
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbhITQik (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:32856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhITQik (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Sep 2021 12:38:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31EF8611AE
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 16:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632155833;
        bh=zWVCWK8T8xS4bTY/qjdujAf/dmZvrABDNgu5CvieeG4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=M41zRQobVa5G7LEmGBrL/1Tgj8d0qcyX4ijO+cKmrorcUJNyOG44DvHsFMejJ08wF
         7BmOYv53uekVmK3wsH2S/PiqSd6HqNfOvCXZXMhTXTiOPOL5fS0ks9GH/k+0y2kazD
         8XlNFqSGBM7tpWlxDXMTWBiftywogvdYvJYxzxZtrwJOBRg5wkuk0bfGqycAwMrJt3
         qEMmclNVLrjia/Qqo4hpK1NHJA4YbYY9V/0XzHbrP/fK/L2GP4iYpTgMuFWWgj8opW
         fcsWUKTfCJJxGd4rLWnqzWVnf0xNfta+Q1b0+XFJARYFg1NsB+dP4StjcSb2ybpuNs
         26LFeLbITi3SA==
Received: by mail-oi1-f172.google.com with SMTP id 6so25530117oiy.8
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 09:37:13 -0700 (PDT)
X-Gm-Message-State: AOAM530tgPVJ44hmqdjyZqw9Mj5kZTcffqnAr358JbtVkfMDwck818Bd
        35udd4mZWmK7ha+aq8XvyxxQIv4xH0/ATamSQ18=
X-Google-Smtp-Source: ABdhPJy1aLrEoWIO9iAWgXSyPUYDmpDxTr+yzhWF0MvB0GhONg9KYIhYikseiELjIbKxdvro8T33piWfh+oYQrhcqQA=
X-Received: by 2002:a54:4f03:: with SMTP id e3mr13727149oiy.32.1632155832592;
 Mon, 20 Sep 2021 09:37:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Mon, 20 Sep 2021 09:37:12
 -0700 (PDT)
In-Reply-To: <5633aaea-84f3-ce70-ff14-aa2dc80a93b8@samba.org>
References: <20210920065613.5506-1-linkinjeon@kernel.org> <6e8b6c79-3394-f39c-8e1b-06b3c2950a28@samba.org>
 <CAKYAXd9Re_iHpwKq4t4GUibKo8g_D3QB1rzBOYiTvv5dLhdvsw@mail.gmail.com> <5633aaea-84f3-ce70-ff14-aa2dc80a93b8@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 21 Sep 2021 01:37:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd91WHicHun_XBJnF3L9y9Of3gBaVe6NK8H8gmMxsXf-Tw@mail.gmail.com>
Message-ID: <CAKYAXd91WHicHun_XBJnF3L9y9Of3gBaVe6NK8H8gmMxsXf-Tw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-21 1:28 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 20.09.21 um 17:57 schrieb Namjae Jeon:
>> ksmbd_vfs_kern_path() doesn't return -ELOOP if last component is a
>> symlink. So need to check it using d_is_symlink().
>
> Really? I missed that. Is that a behaviour of kern_path() when passing
> LOOKUP_NO_SYMLINKS?
Yes.
> I don't see the behaviour expressed inside
> ksmbd_vfs_kern_path(), but maybe I'm looking at the wrong branch+patchset?
I think that you checked correct branch and patch-set.
>
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
