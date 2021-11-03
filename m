Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C16C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 23:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64446611AE
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 23:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhKCXX2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230414AbhKCXX1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 3 Nov 2021 19:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 964AA611AE
        for <linux-cifs@vger.kernel.org>; Wed,  3 Nov 2021 23:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635981650;
        bh=bMLbiS6MPhB2fHUpO1EicONNq2g5n2aZO7rWJsATTmo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ZajULsBLVJZpyZt8nb4g3CWm4X0Ga8NyIQXCN/OKVybbOtIz5wyNs8xdBhwq5cc8a
         tDE/wwmPQlDLT7p7t7rJr/P4XAI+G5nGhidRMs30ZOirvuYQHvYCpHNbIPGi6bWJd1
         KYFLbNIWBGzYAHsbMWhafjkg9KoBk0TsGmEKk/CXbAY0wKGlZayT2K3DyVTjbnkN3k
         bixtLLhyI+VbEwB/wYP7rOtXabMqSA0HXqG6W+tQdoZ8JOx6ra1yZPF+3BfJR9zkOA
         BJqA32bqt1UMygZ6EZ6yjiROfKr3h6LWPuoLn4TntN/yFMr3mVUlBqX2cVHHRYdPwy
         usLChE8FJb+ig==
Received: by mail-ot1-f47.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so5753005ote.8
        for <linux-cifs@vger.kernel.org>; Wed, 03 Nov 2021 16:20:50 -0700 (PDT)
X-Gm-Message-State: AOAM530vzm3EoWdNyu2FYB8WGDA0WkUNrL6JXa9R8CDg/Fe7HtClLm61
        VMbCfV4EbgBtYn9ZCErNPbZ/BlPSpPT6Gh3AdAw=
X-Google-Smtp-Source: ABdhPJyNsKElVZ1eSDV6Vw1ydRRz1v0/o++sBd6BM1OTGBx5GKGdF5blc1A3uE3m7sTvv+2Si0K6wkM93PS6y542WyE=
X-Received: by 2002:a05:6830:1ace:: with SMTP id r14mr35078046otc.232.1635981649921;
 Wed, 03 Nov 2021 16:20:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Wed, 3 Nov 2021 16:20:49 -0700 (PDT)
In-Reply-To: <20211103162030.183975-1-casta@xwing.info>
References: <20211103162030.183975-1-casta@xwing.info>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 4 Nov 2021 08:20:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8vugZ3JrtteYRWvAr-Fqk8LAM59cVv33QhCiKM6h4Shw@mail.gmail.com>
Message-ID: <CAKYAXd8vugZ3JrtteYRWvAr-Fqk8LAM59cVv33QhCiKM6h4Shw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: fix unit file
To:     Guillaume Castagnino <casta@xwing.info>
Cc:     linux-cifs@vger.kernel.org, Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-04 1:20 GMT+09:00, Guillaume Castagnino <casta@xwing.info>:
Cc: Enzo.

I will add the below description in patch header.

"Shell logic must be enclosed in shell subprocess, systemd cannot
handle it directly, so reload will fail."

> Signed-off-by: Guillaume Castagnino <casta@xwing.info>
I will apply this patch, Enzo, Let me know if you have other opinion.

Thanks!
> ---
>  ksmbd.service | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/ksmbd.service b/ksmbd.service
> index 5717177..3309fa9 100644
> --- a/ksmbd.service
> +++ b/ksmbd.service
> @@ -10,7 +10,7 @@ Group=root
>  RemainAfterExit=yes
>  ExecStartPre=-/sbin/modprobe ksmbd
>  ExecStart=/sbin/ksmbd.mountd -s
> -ExecReload=/sbin/ksmbd.control -s && /sbin/ksmbd.mountd
> +ExecReload=/bin/sh -c '/sbin/ksmbd.control -s && /sbin/ksmbd.mountd -s'
>  ExecStop=/sbin/ksmbd.control -s
>
>  [Install]
> --
> 2.33.1
>
>
