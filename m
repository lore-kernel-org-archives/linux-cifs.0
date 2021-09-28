Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F38C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 14:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2851611CA
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 14:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240488AbhI1OZa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 10:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240960AbhI1OZa (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 28 Sep 2021 10:25:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5633611EF
        for <linux-cifs@vger.kernel.org>; Tue, 28 Sep 2021 14:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632839030;
        bh=Suft2963Dnzg5vGR77nyh4y7/XPWCc7O/Ur10Yo0poE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=AKkevt5bhJ8QUW/TrAbDSKddwQ9n3BLgzvwJhINFYGP9SFcg28ALiVc1goNlDf+Jc
         U2iirco0N+7iapfMrH/N3YPiVVKd/qjmAv2QxtLxd9ErKYeUZHauHICX8PbPO7DBBK
         obzr66gFYG6jBp4l0Pky0BMzJH/jp2vcAlvvEKhUcwRIwSyhld7IHvrw9N7+OSKjGa
         CQrIW/hjUkeZ3ZQJn7In69K784QT68M5qjYBrDyHhnoKohNoZJhSXpwxuKDi3q7ZdN
         rltN+uTX8osK1J0fDOs0wEw+WJ7h/LGae7SnHRXkSv5TBF1uM8FiqDrOe4Q3Hvyuhs
         OhFzbVYRvRVCg==
Received: by mail-ot1-f45.google.com with SMTP id x33-20020a9d37a4000000b0054733a85462so29128813otb.10
        for <linux-cifs@vger.kernel.org>; Tue, 28 Sep 2021 07:23:50 -0700 (PDT)
X-Gm-Message-State: AOAM532VZCXq2mF7ZDo7eWXnCFK6eAJFUsKKm73g15mWfFYmZEFSgjKi
        ciHMVhKVT4oq2+w3OMkUEkIxy0siZdW69YUKUJ4=
X-Google-Smtp-Source: ABdhPJyKiXConHhOYV2bQq5CrT7HcgQx1hZ8/bhaXnqDX37xyosYgEldmsrGJyrA3zuleNMaiEih3In99b4VpVnTyNA=
X-Received: by 2002:a9d:729d:: with SMTP id t29mr5398058otj.61.1632839030125;
 Tue, 28 Sep 2021 07:23:50 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 28 Sep 2021 07:23:49
 -0700 (PDT)
In-Reply-To: <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org> <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org> <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 28 Sep 2021 23:23:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
Message-ID: <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-28 22:43 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 28.09.21 um 05:26 schrieb Ralph Boehme:
>> both: there are issues with the patch and I have changes on-top. :) It
>> just takes a bit of time due to other stuff going on currently like SDC.
>
> finally... :)
>
> Please check my branch
> <https://github.com/slowfranklin/smb3-kernel/commits/ksmbd-for-next-pending>
>
> for added commits and two SQUASHes. Remaining commits reviewed-by: me.
Yep, looks good, I will update them in patches. And thanks for your review!
>
> Oh, and I also split out the setinfo basic infolevel changes into its
> own commit.
If you want to add clean-up patch first, we can change
get_file_basic_info() together in patch. I will update it also.
>
> Let me know what you think of the additional checks I've added.
You should submit patches to the list to be checked by other developers.

Thanks!
>
> Cheers!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
