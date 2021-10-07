Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B3DC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 12:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4320610EA
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 12:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241422AbhJGMjB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 08:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241433AbhJGMi6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 7 Oct 2021 08:38:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 000FF6137F;
        Thu,  7 Oct 2021 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633610225;
        bh=j7T30MWfBZ37KKV75705QjJRPWVEgJm1h5JiJ53Ih+k=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=DL22dAXI0oNlF+831yD2/MSR6JnjU09CpPQqlLUuPbTq888CBpQkLDypnbE/48hwB
         v6zK/VIxdsms1NzFIIiC/2yYItk4KhoO0FqkZwGzP+eecC5c8JEUBnoHf201MWxNx8
         ERVFs3Y3Q7jEGd+JNQ2e0gbkuqUS91u+8JawxfEkVhRbLp6Rnhj25QtL/h6FMn5jJE
         qNnmx4fsG+4h+/SQPlTTRoBoFd1UjhK0O4Xe2QzkQIxltWZq+nQAxp40T8szhOu6Wg
         3w4Wa6sdj8+KawAQrdHN53GwPJmFAIXLbs44v7IhSgzwd4Inns8KdZRbNSd0X3vybK
         T0YbeCagyUKyg==
Received: by mail-oi1-f178.google.com with SMTP id y207so5634839oia.11;
        Thu, 07 Oct 2021 05:37:04 -0700 (PDT)
X-Gm-Message-State: AOAM532c80usCWFEVx9Drq+8VWkE82iI4nWlkvs5moxiKLnKlruQTYXA
        LiGLXcqs/+mEBMc7fvAo8W6ysFkGslxrkKzruFg=
X-Google-Smtp-Source: ABdhPJxdYakXmOwXP80XIWRD6rzCBWj0KIXOR4XlvuA7IBP9I+OexJSlLCZz4t11+FqAJ48T+YXJvDvrJA2Dv7mReBE=
X-Received: by 2002:aca:b5c3:: with SMTP id e186mr11725969oif.51.1633610224391;
 Thu, 07 Oct 2021 05:37:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Thu, 7 Oct 2021 05:37:04 -0700 (PDT)
In-Reply-To: <20211007114716.13123-1-colin.king@canonical.com>
References: <20211007114716.13123-1-colin.king@canonical.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 7 Oct 2021 21:37:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_aOawm4MkBtkTxnLfeEk+F5VgrJHjyH8GSaeHjQbLtGQ@mail.gmail.com>
Message-ID: <CAKYAXd_aOawm4MkBtkTxnLfeEk+F5VgrJHjyH8GSaeHjQbLtGQ@mail.gmail.com>
Subject: Re: [PATCH][next] cifsd: Fix a less than zero comparison with the
 unsigned int nbytes
To:     Colin King <colin.king@canonical.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-07 20:47 GMT+09:00, Colin King <colin.king@canonical.com>:
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently the check for nbytes < 0 is always false because nbytes
> is an unsigned int and can never be less than zero.  Fix this by
> using ret for the assignment and comparison and assigning nbytes
> to ret later if the check is successful. The fix also passes the
> error return in ret to the error handling path that caters for
> various values of ret.
>
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
I think that this alarm is caused by 	b66732021c64 (ksmbd: add
validation in smb2_ioctl).
Fixes tag may be not needed. Because b66732021c64 patch is not applied
to Linus' tree yet ?
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
