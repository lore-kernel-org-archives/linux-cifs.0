Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB3ECA0FE4
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Sep 2023 16:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbjIAQtk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Sep 2023 12:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbjIAQtk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Sep 2023 12:49:40 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19F110F1
        for <linux-cifs@vger.kernel.org>; Fri,  1 Sep 2023 09:49:36 -0700 (PDT)
Date:   Fri, 01 Sep 2023 13:49:27 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1693586975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nFErcHl+LcyL84BvjC0tqCEwDQLqwT1le8Wr52qTEqY=;
        b=Ib2xvw+8+CtTBG64HxizMt80pC2Fj57obWb8iWn3/Wq7L4tCMh3EejF6l+2cDzLOyzWsYE
        VYAHpDy0FE9ASxzz81/pqIy1s7QanW1o/R4AgdhCJLwInmt+iq9UNudwIxdYOkfZZJyUNb
        W5vQwYf4nHObnTHg1zNSKzw9i728pWzjFqprCQBfWj6TxmjOclP5xwKu8L6yCitphQ46lX
        xJEXH4Mxa6HpzxwIujPjQmCBtgK88gvg45aMPiHdU8hc/0BulEksnyRrUK7V82TEvGaAJS
        CsFxlaLN/DShTUN8nKYQGP0VV16MDhQEFtrtthDL61wHrh98CX5lEYKKb/iQ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1693586975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nFErcHl+LcyL84BvjC0tqCEwDQLqwT1le8Wr52qTEqY=;
        b=MESlzVqlxFdQ7zPrUcIhOLDfwtQLylfG6PHp05k7Gr+nZr7wZCMlbrcdQWqAUdtc+yiWgM
        b9mizD+P0+l0XWe4elsBVTStzPm1L53lnoz7yM2VcDyL9kemdhwW3MIVk0R8tUV+TSp8/C
        UqJD+qcJS1Ob4YK+qqwdytEFz6DXc2z+KsaIme13OKyRzR2COfEExPDty8TcZ6+yh7urcf
        OtABUpknra7AHPkOVj7a6XoVY4dvWJrPwTYRXQlzuVclO+R8l4f2KHr4EdjNGPLYh9Kyws
        YjzqPfMotXxmR25FkeNG7+bPMHyDOu3/lC2aa+mIV+2afY1KLln3eA81C7bMiQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1693586975; a=rsa-sha256;
        cv=none;
        b=FuktWczFAefZmhnLfuD/WW+hgRqo6xr9VBXh1n+0GJUsmjqMwb0k3hBN+iT8ppJFjl/i66
        QzrQ5ZMI/lKXsbDlWKlYker5r9waYbuQcoesAbASHDkv9bzGjif4IdIuXqkRimE69b5YqY
        +sFb4+u/+sH439gFyn7pmzSd6q850WK2xLxgPjNCFnxZpJ/PEFz+x09bl9UQdekBVrRVUi
        sfaJotxaCO0touYr/Mi1Er0sPVS9aTApWa7F9wZWcc8wxrIBCa1LLc+gloC/97uETHx5XE
        HcqaRtGibjadhU/Z2j+mDp5vGuFzYHncQHIbs6LsHio7REA7fD06X2KBBOM2OA==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Steve French <smfrench@gmail.com>
CC:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, lsahlber@redhat.com, sprasad@microsoft.com,
        tom@talpey.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_2/2=5D_cifs=3A_Move_the_in?= =?US-ASCII?Q?=5Fsend_statistic_to_=5F=5Fsmb=5Fsend=5Frqst=28=29?=
In-Reply-To: <CAH2r5msd3JzDGR1pCCQFb4rP9dUEOSw5YxQj3o9OfNFDVk5mpA@mail.gmail.com>
References: <20221116031136.3967579-1-zhangxiaoxu5@huawei.com> <20221116031136.3967579-3-zhangxiaoxu5@huawei.com> <ca2f166ed7f54e22d07b07c4b43b98a6.pc@manguebit.com> <CAH2r5msd3JzDGR1pCCQFb4rP9dUEOSw5YxQj3o9OfNFDVk5mpA@mail.gmail.com>
Message-ID: <5DEA9FD6-10FA-4910-9E0E-D97B5365DA3A@manguebit.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Whopps - I replied to wrong email, sorry=2E

I meant patch 1/2 [1]=2E

[1] https://lore=2Ekernel=2Eorg/linux-cifs/20221116031136=2E3967579-2-zhan=
gxiaoxu5@huawei=2Ecom/

On 1 September 2023 13:25:10 GMT-03:00, Steve French <smfrench@gmail=2Ecom=
> wrote:
>That patch was already been merged last year
>
>commit d0dc41119905f740e8d5594adce277f7c0de8c92
>Author: Zhang Xiaoxu <zhangxiaoxu5@huawei=2Ecom>
>Date:   Wed Nov 16 11:11:36 2022 +0800
>
>    cifs: Move the in_send statistic to __smb_send_rqst()
>
>    When send SMB_COM_NT_CANCEL and RFC1002_SESSION_REQUEST, the
>    in_send statistic was lost=2E
>
>    Let's move the in_send statistic to the send function to avoid
>    this scenario=2E
>
>    Fixes: 7ee1af765dfa ("[CIFS]")
>    Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei=2Ecom>
>    Signed-off-by: Steve French <stfrench@microsoft=2Ecom>
>
>On Fri, Sep 1, 2023 at 10:25=E2=80=AFAM Paulo Alcantara <pc@manguebit=2Ec=
om> wrote:
>>
>> Hi Steve,
>>
>> Zhang Xiaoxu <zhangxiaoxu5@huawei=2Ecom> writes:
>>
>> > When send SMB_COM_NT_CANCEL and RFC1002_SESSION_REQUEST, the
>> > in_send statistic was lost=2E
>> >
>> > Let's move the in_send statistic to the send function to avoid
>> > this scenario=2E
>> >
>> > Fixes: 7ee1af765dfa ("[CIFS]")
>> > Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei=2Ecom>
>> > ---
>> >  fs/cifs/transport=2Ec | 21 +++++++++------------
>> >  1 file changed, 9 insertions(+), 12 deletions(-)
>>
>> Could you please pick this up?
>>
>> Thanks=2E
>
>
>
