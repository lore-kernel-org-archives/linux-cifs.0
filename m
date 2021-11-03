Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184C5C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 13:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0092361108
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 13:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhKCNxt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Nov 2021 09:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhKCNxs (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 3 Nov 2021 09:53:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DE4061101;
        Wed,  3 Nov 2021 13:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635947472;
        bh=FuC3InfUiUzftFrFY+xCzxY6nwi+F5ahmotN+IR5InA=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=gjkxqj0TaNVbEpotyLbLGfCn9JPQVZOpjZzFJC0FNRgzIT2JoSFDcYzWQoCaJf8P1
         rsSzo1cMgX5KGitL/rXO1GeMTPA/OU0sKPo5eDz403664JUHoQEOIN/ap1mhwjA/dj
         BA2iapg4J40RD0ByDi8z9Ko65Uk7ivsdtIcLi6rJLjHGXlT8pYQc0YsNp823o6rs7l
         uQ1VhdJMp4mXTqKYOZ2mAgk7fzwRTYrvrF/1Q4odp+3WOgwuOgO3EapP+eMVoxjhpB
         3Cy3osqOMRb9t93InyDDwiWlMmqGnFPrxeoSCOc/3c0gSh4JKUYQfSK2j/77UtQzT+
         /b2hM5der7Tnw==
Received: by mail-oi1-f172.google.com with SMTP id u2so3740324oiu.12;
        Wed, 03 Nov 2021 06:51:12 -0700 (PDT)
X-Gm-Message-State: AOAM531dmO03m9GUUoJfk0edk17i9BtNGRuoPExrJ4mGN+CgpRRwZJXx
        k7ztlvQU7tA7r5VjmEVf68/0rYnuqoaOrDp7aDE=
X-Google-Smtp-Source: ABdhPJym86zgQIkWMOH6sF8Ud42fAMTDq6MWFF5vgxyB9VSEK34PWSOV1PpvGh24w0DA4nyBeuVDOG9Ryw11EsXCLVs=
X-Received: by 2002:aca:3885:: with SMTP id f127mr10743369oia.65.1635947471658;
 Wed, 03 Nov 2021 06:51:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Wed, 3 Nov 2021 06:51:11 -0700 (PDT)
In-Reply-To: <20211103131901.28695-1-guozhengkui@vivo.com>
References: <20211103131901.28695-1-guozhengkui@vivo.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 3 Nov 2021 22:51:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8dd83NoCetj+-Cza5EnTvSZXBbu4UWR0WHT5YjAD-05g@mail.gmail.com>
Message-ID: <CAKYAXd8dd83NoCetj+-Cza5EnTvSZXBbu4UWR0WHT5YjAD-05g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix flexible_array.cocci warnings
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-03 22:19 GMT+09:00, Guo Zhengkui <guozhengkui@vivo.com>:
> Fix following coccicheck warning:
> ./fs/ksmbd/transport_rdma.c:201:20-27: WARNING use flexible-array
> member instead.
Is there only one here? It would be better to change them together in
this patch.
>
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---
>  fs/ksmbd/transport_rdma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index 6330dfc302ff..ca62060acd2b 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -198,7 +198,7 @@ struct smb_direct_rdma_rw_msg {
>  	struct completion	*completion;
>  	struct rdma_rw_ctx	rw_ctx;
>  	struct sg_table		sgt;
> -	struct scatterlist	sg_list[0];
> +	struct scatterlist	sg_list[];
>  };
>
>  static inline int get_buf_page_count(void *buf, int size)
> --
> 2.20.1
>
>
