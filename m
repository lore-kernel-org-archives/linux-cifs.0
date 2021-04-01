Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4E0C433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 18:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04B6E601FC
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 18:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhDAS1i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237301AbhDASW7 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 1 Apr 2021 14:22:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F28B56125F;
        Thu,  1 Apr 2021 13:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617284193;
        bh=vdqpbIiFVQCTzNkTSPPb4s679q4GnbQsjQR5dtp0kpw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=lc1Ypn2QCS+etYZjiz7TJYylTWImQNHyQmWsCig/mgpJ4QeUVcQtLRkHmNqcZZbHo
         51emm0oOmo61C8E/tme13bhTZkCs57qA17nkncb7Mw1U3+G7fPUEsiFS8WHDSQjBNo
         Xwa+Inq2fH6DB9JAac3ob/XkbfT3dIPrXfN5rzypeyypCGgvWVvwZ8dOZmvz3AtfEv
         lyJBTr+v1yuKLG5nDV4wdiJb0IP4WH1Ilk1QMW7GmW/vAnFodOfLBkl3etOV8HYATd
         5scAdOpUHrSVs3KVN/6krObgBSrOVe/dejo3wk4Icol6e/sTfYsqR90mitoOR4WvJT
         5ALBTxqzXEBAg==
Received: by mail-oo1-f47.google.com with SMTP id x187-20020a4a41c40000b02901b664cf3220so556781ooa.10;
        Thu, 01 Apr 2021 06:36:32 -0700 (PDT)
X-Gm-Message-State: AOAM531ZCcGIXgSz/2uaa1J2XnVKsQFcQk2pGeredc0oWPOeHklQzoP/
        ETHeLc1wY+UiY4iWnsBQy6oyipBoe/Ukqrke9L0=
X-Google-Smtp-Source: ABdhPJxG5NOdiJPO3847XJakVS3nw89NRW7KqKUiwhStvsrTCGzw7AIm5C8p258c1KbPsOpl+YfYdoZXlU4mt6YmGwY=
X-Received: by 2002:a4a:3c48:: with SMTP id p8mr7283092oof.79.1617284192287;
 Thu, 01 Apr 2021 06:36:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5ed4:0:0:0:0:0 with HTTP; Thu, 1 Apr 2021 06:36:31 -0700 (PDT)
In-Reply-To: <2b758812-f00b-9465-c24e-763912748809@samba.org>
References: <20210401113933.GA2828895@LEGION> <20210401115008.GS2088@kadam>
 <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com>
 <ca1b9b0c-55f9-025d-558b-1b2b6c866d12@samba.org> <CAKYAXd-ScM9i9Ln_FL8pWyEnPO_0n8t1BLH8MJ=b4NkqEbhZ=Q@mail.gmail.com>
 <2b758812-f00b-9465-c24e-763912748809@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 1 Apr 2021 22:36:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_p1MrB2G25_p52OfppfSUcEWQEVxgJbBikAe3GZrJFhw@mail.gmail.com>
Message-ID: <CAKYAXd_p1MrB2G25_p52OfppfSUcEWQEVxgJbBikAe3GZrJFhw@mail.gmail.com>
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: use kfree to free memory
 allocated by kzalloc
To:     Ralph Boehme <slow@samba.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, colin.king@canonical.com,
        Muhammad Usama Anjum <musamaanjum@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-04-01 22:14 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 4/1/21 um 2:59 PM schrieb Namjae Jeon:
>> 2021-04-01 21:50 GMT+09:00, Ralph Boehme <slow@samba.org>:
>>> fwiw, while at it what about renaming everything that still references
>>> "cifs" to "smb" ? This is not the 90's... :)
>> It is also used with the name "ksmbd". So function and variable prefix
>> are used with ksmbd.
>
> well, I was thinking of this:
>
>  > +++ b/fs/cifsd/...
>
> We should really stop using the name cifs for modern implementation of
> SMB{23} and the code should not be added as fs/cifsd/ to the kernel.
As I know, currently "cifs" is being used for the subdirectory name
for historical reasons and to avoid confusions, even though the CIFS
(SMB1) dialect is no longer recommended.
>
> Cheers!
> -slow
>
> --
> Ralph Boehme, Samba Team                https://samba.org/
> Samba Developer, SerNet GmbH   https://sernet.de/en/samba/
> GPG-Fingerprint   FAE2C6088A24252051C559E4AA1E9B7126399E46
>
>
