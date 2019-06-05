Return-Path: <SRS0=m+wU=UE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C29AC28CC5
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Jun 2019 21:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7031D206BB
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Jun 2019 21:52:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o0onlU0z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfFEVwm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jun 2019 17:52:42 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46271 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfFEVwm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jun 2019 17:52:42 -0400
Received: by mail-pf1-f196.google.com with SMTP id y11so111503pfm.13;
        Wed, 05 Jun 2019 14:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pcjlD80KxqjkrJpLh0zg0y8IPXMG4YKyEPyNxaKimzE=;
        b=o0onlU0z+qsTXYziIZn66NQ2jsSX0MO6KYoQXm0fIF79bfEs+9YKw8o6seNpgADsOe
         VN8QCmTR4+lGIVXmTw0UbHjnRZQQ4Mqj/fw2JcMB4KRzyZd0+dIL/4lfIqXIWMJWzZYW
         gnRifZJTd+FZ+ao2kvpDb7/Lwxp7fPB9VKthhkYC/2rr1dKeDOVHf9jbCFwwMjBZTwSD
         VNi3VnXQJus9WpKtF+iHqSfZmYHB3dg/ypFqCYrdemCOKb03FjwmJTUtbpBLHJcUJQvS
         0W0azfecf8jx+6LzLHeY40SG+61o66fsnf4bnoM/CJ6ao07c9tQcQMS8a8t0MG5jAT9s
         50Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pcjlD80KxqjkrJpLh0zg0y8IPXMG4YKyEPyNxaKimzE=;
        b=qg1oWxD8qvDm2ieIWGbUygLVkvZjFIvCfe8k3ONWNmR06t5zGuNQoArI/UKe7VC4+E
         GXP7r6tefXvDyM++mXFQWrLmCIxXXH5MUcOkntxHODI2PsuUCcihFs7n9GO9t/ZOupTr
         KLmIcGktnJG6WlHG5ryAUn4dKi7W9ULIU47RLbamePwH3Z8If5oN9yFadvA34r6S6qZE
         UVxhhD1H3YTr8HUfb6lQiNMNkNYPVZi/frXQCLrc0GjWT9RSTu+F1AJiCIH0ohHjw7ji
         2A5/eQPA7Cx68VFfFm3qNIZnyR86XD/89ifSyqPmdTvO25YILWmlmmlL+AKLQJia4++X
         YBfw==
X-Gm-Message-State: APjAAAWCbu/xdy4LtPjQmlsIiqBGJ7Rlfw1IYvJ8fNESZWC3nJTCfeTt
        Phw+UbHOY4JJdOdNpbDwU/HDTOMTcpJeiRlks4Q=
X-Google-Smtp-Source: APXvYqx80No/1styLEMcrYrPQiNeCLl7fYi2qEaBpkNmgIzsNFA6azr7O+9NlgEXZmfEf3tLVZbhUfZyH7jzwBj0RUM=
X-Received: by 2002:a62:7552:: with SMTP id q79mr29394127pfc.71.1559771561768;
 Wed, 05 Jun 2019 14:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <1559769249-22011-1-git-send-email-info@metux.net>
In-Reply-To: <1559769249-22011-1-git-send-email-info@metux.net>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 Jun 2019 16:52:30 -0500
Message-ID: <CAH2r5mvzEPj2NXMJW5fOfq0+bbh-pZFnJnL1jEnyFYDt1HJi1A@mail.gmail.com>
Subject: Re: [PATCH] fs: cifs: drop unneeded likely() call around IS_ERR()
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This duplicates a patch submitted earlier by Kefeng Wang
<wangkefeng.wang@huawei.com> which I plan to merge later today into
cifs-2.6.git for-next

On Wed, Jun 5, 2019 at 4:14 PM Enrico Weigelt, metux IT consult
<info@metux.net> wrote:
>
> From: Enrico Weigelt <info@metux.net>
>
> IS_ERR() already calls unlikely(), so this extra unlikely() call
> around IS_ERR() is not needed.
>
> Signed-off-by: Enrico Weigelt <info@metux.net>
> ---
>  fs/cifs/dfs_cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> index e3e1c13..1692c0c 100644
> --- a/fs/cifs/dfs_cache.c
> +++ b/fs/cifs/dfs_cache.c
> @@ -492,7 +492,7 @@ static struct dfs_cache_entry *__find_cache_entry(unsigned int hash,
>  #ifdef CONFIG_CIFS_DEBUG2
>                         char *name = get_tgt_name(ce);
>
> -                       if (unlikely(IS_ERR(name))) {
> +                       if (IS_ERR(name)) {
>                                 rcu_read_unlock();
>                                 return ERR_CAST(name);
>                         }
> --
> 1.9.1
>


-- 
Thanks,

Steve
