Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9844AC77B73
	for <linux-cifs@archiver.kernel.org>; Tue, 30 May 2023 14:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjE3OMt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 May 2023 10:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjE3OMs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 May 2023 10:12:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E139B107
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 07:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FC1C630E1
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 14:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E3CC433EF
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 14:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685455944;
        bh=+Pb9ix1wiw+nC9p3HhllbbxrYPtYrZWSc5N1XlwPqQQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Z4pBM3hnTAiU3FyEzpVeJPWW+BZNad9dSrhB2iBSRNepWGvnUVMV+PGnjEGER/5O3
         MAUkR6HPxPOj3tu1hhpHAmnjnmvmCD7FJa+RMoSe8YSVZkP85/o6hZW1NKJyTFUUhs
         z81DkMcVJ6H6CUOGz6nvINpZQuomfMSSh7wA4zbLeL6d/FcRVOiyZOYGHrXNJilwv3
         aIHBNhkIMn0X6imdv2V1erzhXXLwDuzQtFG2b2kHwgv9NzTLjCB0tcwuUvyZNpOk9v
         EP8f6GbwMKzuhew05ly7raC5VOQzgaUAGYu+OEcLKpxGsQAd/fWSzymMe+ZAuXGLUY
         9CnuA69wWYAEw==
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-55554ab909cso2170232eaf.2
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 07:12:24 -0700 (PDT)
X-Gm-Message-State: AC+VfDyD30vAPU7Dl1diYenR7ViozCC5hzuU8JyaFppN5oiLZyl7ow6F
        GgFBmDGSl95pHWfyyQn5tZaKBTXv+Bfd2Wb1R1I=
X-Google-Smtp-Source: ACHHUZ7sHvNm+s2FC4GR8rw4OBhYyuTl2b+h5isKnBk0NC6LGPR5aCjq8nD/7eiB9vKSggDfIV4PVzYX+rt3HB1JpW8=
X-Received: by 2002:a4a:2c90:0:b0:552:4a83:6e7d with SMTP id
 o138-20020a4a2c90000000b005524a836e7dmr1000618ooo.7.1685455943752; Tue, 30
 May 2023 07:12:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:acb:0:b0:4de:afc5:4d13 with HTTP; Tue, 30 May 2023
 07:12:23 -0700 (PDT)
In-Reply-To: <9f7d2528-45e8-45bb-b703-f4f8e1c08ed2@kili.mountain>
References: <20230530125757.12910-1-linkinjeon@kernel.org> <20230530125757.12910-4-linkinjeon@kernel.org>
 <9f7d2528-45e8-45bb-b703-f4f8e1c08ed2@kili.mountain>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 30 May 2023 23:12:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-3OqQYP62tX=vfh9Cq4=k4rdmfWe9cTQPoAEjCZ0KPQQ@mail.gmail.com>
Message-ID: <CAKYAXd-3OqQYP62tX=vfh9Cq4=k4rdmfWe9cTQPoAEjCZ0KPQQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: return a literal instead of 'err' in ksmbd_vfs_kern_path_locked()
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-30 23:01 GMT+09:00, Dan Carpenter <dan.carpenter@linaro.org>:
> On Tue, May 30, 2023 at 09:57:57PM +0900, Namjae Jeon wrote:
>> Return a literal instead of 'err' in ksmbd_vfs_kern_path_locked().
>>
>> Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and
>> ->d_name")
>
> No need for a Fixes tag.
OK.

Thanks.
>
> regards,
> dan carpenter
>
>
