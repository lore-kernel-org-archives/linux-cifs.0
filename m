Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B82EC433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Oct 2021 15:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56D4660E8B
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Oct 2021 15:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhJ3PlB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Oct 2021 11:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhJ3PlB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 30 Oct 2021 11:41:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3BE460E8C
        for <linux-cifs@vger.kernel.org>; Sat, 30 Oct 2021 15:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635608310;
        bh=e8m2ndaC9FuJOUCQNKgXOLHcniqy6T50zYDDaoxUe2k=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ffzoJVCZHKvwm50ZgSTXnagQUSZFJUQgcOJ1dqFUKcNww96hg5iz2ReppjhtifLnL
         i0zokyZ87Q9rsgl3E/3m+icNYZ3PXTX9H//9mi29rTdmGkAY74w6dFyLNsIxz2xyF/
         jsTzswVKHNQ2TbRrO53dk9LmvhoXukN+mA/0oUaPgiwQ6ZouVyN3e1ENYkCTbv20R7
         OiOq2TjSB9jl+6+9FHh9q6fnrQBVHQG2N/ZrnKvVE1OVCnk07iWZ7tI5sToUSjhqwe
         LTp0Z0I93qnOLXLTs2Z24C+X2YplGMgWUVT/Bn1Ukbx4UVDPdFcTFx4JFl8QOHVunt
         LzQShsb8n2Cag==
Received: by mail-ot1-f49.google.com with SMTP id o10-20020a9d718a000000b00554a0fe7ba0so12296261otj.11
        for <linux-cifs@vger.kernel.org>; Sat, 30 Oct 2021 08:38:30 -0700 (PDT)
X-Gm-Message-State: AOAM531/kR7TjkEokxfEQt1WK7nQSDpW8HrjXUgsJdVinDv5JuFRZAS/
        5bfd6qNrPQnH8B45XlnewkM0KmRKsGFOs/RsR2w=
X-Google-Smtp-Source: ABdhPJwU7pGJ0xd5dPIxYereO/9iZf/ntHgYseN9vlb2rPubcmaviJUgt2EuvHTCYIODNag1AxK9qk78cwtvmuvQm08=
X-Received: by 2002:a05:6830:25c2:: with SMTP id d2mr13831311otu.116.1635608310095;
 Sat, 30 Oct 2021 08:38:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Sat, 30 Oct 2021 08:38:29
 -0700 (PDT)
In-Reply-To: <CAH2r5mv8HDTp6mQD=JQE8z1vZMZ8JytsB-Te7JnhPOiKzwe_2w@mail.gmail.com>
References: <CAH2r5mv8HDTp6mQD=JQE8z1vZMZ8JytsB-Te7JnhPOiKzwe_2w@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 31 Oct 2021 00:38:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9HM0A7GjZY0_=WDQR1ip-5dcqN7+HZ5wt8O1SQrLmn7Q@mail.gmail.com>
Message-ID: <CAKYAXd9HM0A7GjZY0_=WDQR1ip-5dcqN7+HZ5wt8O1SQrLmn7Q@mail.gmail.com>
Subject: Re: Volume Serial Number and Creation time not populated by ksmbd server
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-30 20:57 GMT+09:00, Steve French <smfrench@gmail.com>:
> When debugging an fscache problem with Dave Howells, I noticed that
> ksmbd does not populate the VolumeCreationTime or VolumeSerialNumber
> in QUERY_FS_INFO for level FS_VOLUME_INFO (see
> smb2_get_info_filesystem() in fs/ksmbd/smb2pdu.c)
>
>                 info->VolumeCreationTime = 0;
>                 /* Taking dummy value of serial number*/
>                 info->SerialNumber = cpu_to_le32(0xbc3ac512);
>
> Can we fix at least one of these to query info from the underlying fs
> to populate this so our fscache info is more unique by fs?
I will check it.

Thanks!
> --
> Thanks,
>
> Steve
>
