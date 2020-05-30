Return-Path: <SRS0=UyrF=7M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA5EC433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 30 May 2020 21:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F37F2076B
	for <linux-cifs@archiver.kernel.org>; Sat, 30 May 2020 21:08:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I+V69rxL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgE3VIO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 May 2020 17:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3VIN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 May 2020 17:08:13 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF28C03E969;
        Sat, 30 May 2020 14:08:13 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id g39so3060157ybe.7;
        Sat, 30 May 2020 14:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N3uLWYoa/hZAbc4d3OlSWhNwaMdQAPLUT8g8/VN/Ehc=;
        b=I+V69rxL5tA6THo02L4NHjlDUbUI/axbTjh0I3YDiDpDrcABy571xoZLELee6gmlha
         phRVT6GdK8A3Il32WoiTA/7wp0jWssqat/5oZ2adFYwEchyWJx3eIZYbkkjkjHVo2ECh
         icZItFXR2vRQB7LBCE7kVtTCuuoC9/0fseKchY0BM9WN7AfwCMsvTd+IuJDQm6XfuE6B
         UP+NmZEqPR00KwDqWgiTrFCRC5e62nO5byf8rEWH2FHjOQwU4pmuD7lNXGaD7qwISoE8
         9Ua72fJGhZCi4+JF2Fb6rgOClEjjN9VkNuapwoy1cdTEWA5HMbv2aGbFUR7CmRNxQCX2
         B+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N3uLWYoa/hZAbc4d3OlSWhNwaMdQAPLUT8g8/VN/Ehc=;
        b=r9IGjYCyzf/EGQ06+jl2ZRmkZhVhvXov2tnZpYD67JNrx0lndbjdq9o0ahwYmU/eU6
         zYdC7NgqxscbccAtRBhUM0ae6hNWsPA+/UL4c/522D9kNOjqzgLpVCTd7gqnrYCEC7q0
         nCX7p4xRg5EQYduos4X60rj/GCryQ5lmpXWlZv44Rly2pezOgCQWTalNO9p1vCahU/aZ
         oNZHi+ycH0IqPWZLD7V26EOieq7csy4/jEqOYwc4Px0O8CcEM9pBLnT47tD2ZahFD6NP
         o9Gr7etCkQYo21mM2NQ6xEmD9eXI36Ask5/whaffC4PCcsDflDwtaHC3Hdz4Ex5RmoPy
         Ktpw==
X-Gm-Message-State: AOAM530QI7DD4vHJblBVdXIvmkhF8q3jH+NwhxXbvfh6SrqCIHq4D+qf
        ksoITqJ4X0dk0Zg0n2RW2Lk82dF2uS7SajUjGKU=
X-Google-Smtp-Source: ABdhPJyWlckeGlqw5zAH1gPRyoitajS9v7QUSji0TnTK98AJzrSglomGIeyo01OMjM9VBYsEaZiuBqMxouRX1PXIFKU=
X-Received: by 2002:a25:4487:: with SMTP id r129mr9834916yba.14.1590872891914;
 Sat, 30 May 2020 14:08:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200527125031.173987-1-colin.king@canonical.com>
In-Reply-To: <20200527125031.173987-1-colin.king@canonical.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 30 May 2020 16:08:01 -0500
Message-ID: <CAH2r5mumV8UJPaXx-hWMWOB3bjz5dPH=4gEkiDGQBqnYdFxq3w@mail.gmail.com>
Subject: Re: [PATCH] cifs: remove redundant initialization of variable rc
To:     Colin King <colin.king@canonical.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next


On Wed, May 27, 2020 at 7:52 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The variable rc is being initialized with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/cifs/cifssmb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 5014a82391ff..d62f9175c546 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -2375,7 +2375,7 @@ int
>  CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
>               unsigned int *nbytes, struct kvec *iov, int n_vec)
>  {
> -       int rc = -EACCES;
> +       int rc;
>         WRITE_REQ *pSMB = NULL;
>         int wct;
>         int smb_hdr_len;
> --
> 2.25.1
>


--
Thanks,

Steve
