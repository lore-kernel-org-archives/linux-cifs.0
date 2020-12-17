Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B35C4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 03:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A1942376F
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 03:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgLQD5h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Dec 2020 22:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbgLQD5h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Dec 2020 22:57:37 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46090C061794
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 19:56:57 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id y4so4076451ybn.3
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 19:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AQL3h+gjUdKwQApvurBTXpgQ9IqW1H7vY26M1J0LLLM=;
        b=Kkyc3oNuoAFUg/CeiUlL74rjz4I1cMfsjsRC9ugxiIgA+kNpBId2kJpRnMD9YQXsQe
         BiHwlqRuGPAvb1sg8fvYNTyg1DNV4nGYMsoL0JpZPK8Wo4fZQ8GaLpqmil8nJtSljqno
         SaHA6AzKi6aev5xnVWxanu4xoZaK1Rf4Flgbq5N9ARiyM5Iy+tJdxW1DWIqql9zAoQiu
         /LNLUvIM6z3CqWeVMHDF+HCBnZSPZWKzea1QB89f+9MWM2xFn3rSNF+2BfsxXWn5Nj4U
         7N2AkDB8jvNF2zRchM1WngvkZ7JlLhjBppmC9YDRGJYk20e5mEuw7Y2Ndmpv0dbLqx43
         IjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQL3h+gjUdKwQApvurBTXpgQ9IqW1H7vY26M1J0LLLM=;
        b=aQ7Rh1Qc1WrpEU/uw2J8IRwxPGuN3MFRpwNP4ma0r/U/pgOlcIY4wwBmFMSEtkmSd5
         n84KF4QGe1RkOjVYsNTMYIfOCUAb9iZO/efCwpqYqBsCq6qPg6mKuUemXPctE6ozVgIQ
         U+PgqImDY7wnLxwbZLYD1+fZV3OrWyNCTcAXcRyU9l6I/4ceSMQyKDgLr1QwkArQvvP6
         MM/2eNz1VMaxqSt4fhC9+j47KN3CEhvq8qNiVdLb+e2uxZXArhWqe9DachK7ipcowSaR
         0EGxzXetA5RLgWMZKFup7OE6rgylx+HUFc6RMVxaNowB7gnsf0qyDebaHzM7G7y9fjHQ
         1MUg==
X-Gm-Message-State: AOAM530bgYK7jOEi9I662TptaUOcquD2mJyxlVFUZA7g2xMci4Y9cemp
        8iY0Jt7YG9M6BimTV1Y/jWLRY3Hp4HVsTCU+j9o=
X-Google-Smtp-Source: ABdhPJx02hMdwgAnHyR1HBhpDgB/RmqFesvBqkFqcWnJ7MxuwL9D6A17+1EC5xzJH9XlLtNLqokcnbOjNJte/+uwN1o=
X-Received: by 2002:a25:69d1:: with SMTP id e200mr49726470ybc.3.1608177416527;
 Wed, 16 Dec 2020 19:56:56 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mv6AXFVQ-QLsKMsYM5zqegf6bmmq=4rbFztj3JiJi_N1g@mail.gmail.com>
In-Reply-To: <CAH2r5mv6AXFVQ-QLsKMsYM5zqegf6bmmq=4rbFztj3JiJi_N1g@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 17 Dec 2020 09:26:47 +0530
Message-ID: <CANT5p=p3u4Q4PKEmKwSmQTpwjipwzZEy=gLQp9KMPDPopVGzXw@mail.gmail.com>
Subject: Re: [CIFS][PATCH] Fix support for remount when not changing rsize/wsize
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.

On Thu, Dec 17, 2020 at 5:39 AM Steve French <smfrench@gmail.com> wrote:
>
> When remounting with the new mount API, we need to set
> rsize and wsize to the previous values if they are not passed
> in on the remount. Otherwise they get set to zero which breaks
> xfstest 452 for example.
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/fs_context.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 734b30db580f..0afccbbed2e6 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -707,6 +707,13 @@ static int smb3_reconfigure(struct fs_context *fc)
>   STEAL_STRING(cifs_sb, ctx, nodename);
>   STEAL_STRING(cifs_sb, ctx, iocharset);
>
> + /* if rsize or wsize not passed in on remount, use previous values */
> + if (ctx->rsize == 0)
> + ctx->rsize = cifs_sb->ctx->rsize;
> + if (ctx->wsize == 0)
> + ctx->wsize = cifs_sb->ctx->wsize;
> +
> +
>   smb3_cleanup_fs_context_contents(cifs_sb->ctx);
>   rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
>   smb3_update_mnt_flags(cifs_sb);
>
> --
> Thanks,
>
> Steve



-- 
-Shyam
