Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD98ECAAD1
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 23:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiHaXgZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 19:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiHaXgX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 19:36:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77696792F5
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 16:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15055B823C0
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 23:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D34C433D7
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 23:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661988978;
        bh=gWpkGeHSqfat7J3HJNSoiVixCVKafiPpsCxtK+zv5Qc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=VKfaw2dCZgT8Bg4l7TpGFbxCuVYji8ZmUEkQkpsG++OUL0nt0PO86fnnls5CyG4N5
         KtdH9OYYNw/Rojsg6TbPDou3txxrg6bBgzZTCAs1YCBZW1F+iwK2O2wa45AyXo/Zg3
         DApCOQZ2BtDZFUMyB3jwQpgf0y5mvUPDaIUwwPgy8Qse73dY9ZoaM/uKQpl+rJvhSc
         E6Jvq/c+eIWxUAdi6tPPo9qVFw9hlVKUbTqWtnUzYDRpDm+SugwhqGpQikzJuVWwVd
         IBdTPXbVwRG6jLjg25xLFJDQzYuF9M1Y88U6oNHZx0btyx3NnHdSrIKCPWlyMfkjV7
         Tu0KsNL9XTwWw==
Received: by mail-oo1-f49.google.com with SMTP id t15-20020a4a96cf000000b0044e0142ec24so1504366ooi.8
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 16:36:18 -0700 (PDT)
X-Gm-Message-State: ACgBeo1HiWkk2QkEyti4JTAglvFCkxsJGMQKBGoJCTsWi5uwAFyJ71JH
        hKiwri+eLwC78jdvF8AJfuekUefZIcbp86ibiBU=
X-Google-Smtp-Source: AA6agR6q1kg8YBdMBt4r9sVm9Sm+WR+T89ql4+I+Xg4diGwJ7Rhu5qjrxRRfd4VfP+H9vECLKqql40pl0Ah+naIz6OI=
X-Received: by 2002:a05:6820:812:b0:44a:a398:893c with SMTP id
 bg18-20020a056820081200b0044aa398893cmr9813650oob.84.1661988977852; Wed, 31
 Aug 2022 16:36:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 31 Aug 2022 16:36:17
 -0700 (PDT)
In-Reply-To: <CANFS6bYYEtXPDQnmAKFujLPu_xO7zhtwhQ+kJqdkjjgKcvZLjQ@mail.gmail.com>
References: <20220819043557.26745-1-hyc.lee@gmail.com> <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
 <CANFS6bZ1Xh+BTFDpWQdChcoY_5t5MwT5UMQ=tQupXmEeSO3kPw@mail.gmail.com>
 <CAKYAXd_Qd3jf_GwvzmZ+V+s--k-+T8HBD9HfvDvAesuv1vth2g@mail.gmail.com>
 <CANFS6ba3zUFW3Cju6zXiAoQ0jU_-oq=1EZLfwBCf9uGyqVzOKA@mail.gmail.com>
 <CAKYAXd9iP8h-rxju-JG9=9QJbVTpMqsMhySGMeZzHrkA4JnC_g@mail.gmail.com>
 <CANFS6bbMYjn9kw574vpKPj74Zs6oQYiCdPEknMbCQf77_30v6Q@mail.gmail.com>
 <CAKYAXd9yiTOg2FPtCtyZn+4fdCbXOU2edDk2L-9Vv5ehJ+w=jA@mail.gmail.com>
 <CANFS6bbwZDGhB4Dp+A192U=S1VfWa0091OBvmxhTB_C4BPz7sA@mail.gmail.com>
 <CAKYAXd_7p1gmV+3HZE9v+biUxRPzoNL7-cqRpfY8yCFHik7M5g@mail.gmail.com> <CANFS6bYYEtXPDQnmAKFujLPu_xO7zhtwhQ+kJqdkjjgKcvZLjQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 1 Sep 2022 08:36:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8tAtfEN9DTwAAUrwDn24tA=+jCPzsZMg32kwmftkg=hA@mail.gmail.com>
Message-ID: <CAKYAXd8tAtfEN9DTwAAUrwDn24tA=+jCPzsZMg32kwmftkg=hA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix incorrect handling of iterate_dir
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

>
> When I set the last entry of directory FAT chain to be invalid value in
> exFAT,
> the last getdents returns -EIO, but Samba sends responses without an error
There seems to be an attempt to improve this in Samba as well.
https://bugzilla.samba.org/show_bug.cgi?id=13718

>
>> >
>> >> There is no reason to follow it. I think that ksmbd is able to return
>> >> this error.
>> >
>> > Can we determine we should return a response with
>> > STATUS_FILE_CORRUPT_ERROR
>> > if iterate_dir returns -EIO?
>> STATUS_FILE_CORRUPT_ERROR is still not cleared. want to know how
>> windows server handle it.
>
> In the above example, Windows server sends an empty SMB2_QUERY_DIRECTORY
> response with STATUS_FILE_CORRUPT_ERROR.
>
> And when executing "dir <directory>" in Windows terminal for the local
> exFAT filesystem,
> there are no files iterated and DirIOError is generated.
This is the behavior I was expecting. ksmbd can handle this as well.

Thanks.
>
>
>> >
>> > --
>> > Thanks,
>> > Hyunchul
>> >
>
>
>
> --
> Thanks,
> Hyunchul
>
