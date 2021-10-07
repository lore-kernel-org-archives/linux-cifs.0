Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0054C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 14:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB50E610EA
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 14:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242086AbhJGOdH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 10:33:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233381AbhJGOdH (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 7 Oct 2021 10:33:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D3E2610EA;
        Thu,  7 Oct 2021 14:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633617073;
        bh=VN63RB522o8WFY2Ey9405BvBXJdWFy4UFPRQ2hg36Ig=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=SoVky5XUMZsKen9HX7ymW9QmSloaYyq4Q4U2w4sa7YDxDZWRCEdxvgMHuaOXOg+NK
         xnbaYmAT2977HqGJUhq/yb4rrYIxmO3Z9uB1d2ipjdKYaT43m6ojzYGlXFsNUVX9gk
         d8gvfre0yRDb3QO+RN6oKN2exgo0vEtqQ6j3YOwljkq33M3DDWesAM7zF/Hyt22TiS
         i5Nrlbv8UG2L6b/h63tlgZLWqHy1Gmw38XlFQ22xWEQFNwqC07Ftw0CJ5UqCiSM1MI
         bEN9uHqWIfSeHGnAga32sYA212uPljZ/hIzSnYlUIqJNE/C4ltrgibNLQ3lAzyRoWA
         s8avTIB4fKATQ==
Received: by mail-ot1-f42.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so3209924ote.8;
        Thu, 07 Oct 2021 07:31:13 -0700 (PDT)
X-Gm-Message-State: AOAM5339G/3nDfu8HQlYHEuTkSwLejvt5vgv3F8dsn3dftHaotydZpOr
        8dO5AKh6EspSby2swDrIVbloASjAMBV1d9/jF+A=
X-Google-Smtp-Source: ABdhPJx9+OtS8s0Zlrpz2JV2zuvtULulfL7uYDLsTkKxgEkDIeKPkAnSu95wk6RUbALrfaoxXD7ny9OgEXtPNLiwgt8=
X-Received: by 2002:a05:6830:17da:: with SMTP id p26mr3953027ota.116.1633617072833;
 Thu, 07 Oct 2021 07:31:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Thu, 7 Oct 2021 07:31:12 -0700 (PDT)
In-Reply-To: <20211007133541.GC2048@kadam>
References: <20211007114716.13123-1-colin.king@canonical.com>
 <CAKYAXd_aOawm4MkBtkTxnLfeEk+F5VgrJHjyH8GSaeHjQbLtGQ@mail.gmail.com> <20211007133541.GC2048@kadam>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 7 Oct 2021 23:31:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd824PDidipzYR3ZqP0BkQqi2MXXQRhqZ_OUAO62AtdQXQ@mail.gmail.com>
Message-ID: <CAKYAXd824PDidipzYR3ZqP0BkQqi2MXXQRhqZ_OUAO62AtdQXQ@mail.gmail.com>
Subject: Re: [PATCH][next] cifsd: Fix a less than zero comparison with the
 unsigned int nbytes
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Colin King <colin.king@canonical.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-07 22:35 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> On Thu, Oct 07, 2021 at 09:37:04PM +0900, Namjae Jeon wrote:
>> 2021-10-07 20:47 GMT+09:00, Colin King <colin.king@canonical.com>:
>> >
>> > Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
>> I think that this alarm is caused by 	b66732021c64 (ksmbd: add
>> validation in smb2_ioctl).
>> Fixes tag may be not needed. Because b66732021c64 patch is not applied
>> to Linus' tree yet ?
>
> If you are going to modify the commit to include this fix then that's
> fine.  Otherise if you are going to apply this commit then the Fixes
> tag is still required.
>
> The fixes tag saves time for backporters because they can automatically
> rule out that this patch needs to be backported.  Or if they backport
> commit b66732021c64 then they know they have to backport the fix as
> well.
>
> Also the Fixes tag is used for other purposes besides backporting.
> It helps review.  It's also an interesting metric to measure how long
> between the bug is introduced and the fix is applied.
Okay, Thanks for your detailed explanation:)
>
> regards,
> dan carpenter
>
>
