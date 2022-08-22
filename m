Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE202C00140
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Aug 2022 00:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiHVAv6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 Aug 2022 20:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiHVAv6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 21 Aug 2022 20:51:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21864201A8
        for <linux-cifs@vger.kernel.org>; Sun, 21 Aug 2022 17:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B81C060E06
        for <linux-cifs@vger.kernel.org>; Mon, 22 Aug 2022 00:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B29CC433D7
        for <linux-cifs@vger.kernel.org>; Mon, 22 Aug 2022 00:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661129516;
        bh=p1u/xQfh0QPsuyqRxgZxxuQITOj73htf/ky+Z+YZU1w=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Jel03JGvLmokWcOlhtZ2L09jwUeCHp+Xv3JDhACwCV85dl7F63ckGapvdNtv/dAIv
         UkJz/T/Lx9W4wx6ymCG7X8p0qEQGEKRMyculL+bGH7wwabd6u4xZ/GZiTZGWXNRUnA
         Vs+dsgybvlnofDPPRsvb/PDTSKdkArH+39wjaigke33KfH1QGiBV2t/L7ddGrdzCuA
         AGMODVedB/3DqdkHfNurwN4D6TlGGhIDJzaU2oh98MqI7BhzZYd1BjlAKfm3pfteDX
         g9oO6TKl76zsd/a2kFjVod3h7Ec93Suwus4RZKy56osMLX2COjcXUrBkBdN/+keW+P
         nICjPEbMkkhNg==
Received: by mail-ot1-f49.google.com with SMTP id m21-20020a9d6ad5000000b00638df677850so6747735otq.5
        for <linux-cifs@vger.kernel.org>; Sun, 21 Aug 2022 17:51:56 -0700 (PDT)
X-Gm-Message-State: ACgBeo2HyOMHZFoPT6pnUX6xirbXZoUKPI32Ek09ka2wPZ655EHSTUCW
        b81vBKjvUiZlub9KOh3b7SVUB4H6R+ifaznv3Lg=
X-Google-Smtp-Source: AA6agR7S8/a2H99aOQhT7fT+oN/QZ4NIMwKVSh7EuwN8fxihduj+OlicQ3CRUKZJkXULSxbTqN7rWuyfymRasYEBZJE=
X-Received: by 2002:a9d:5619:0:b0:617:3dd:f32b with SMTP id
 e25-20020a9d5619000000b0061703ddf32bmr6891401oti.187.1661129515215; Sun, 21
 Aug 2022 17:51:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sun, 21 Aug 2022 17:51:54
 -0700 (PDT)
In-Reply-To: <20220819043557.26745-1-hyc.lee@gmail.com>
References: <20220819043557.26745-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 22 Aug 2022 09:51:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
Message-ID: <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix incorrect handling of iterate_dir
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-19 13:35 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> if iterate_dir() returns non-negative value,
> caller has to treat it as normal and
> check there is any error while populating
> dentry information. ksmbd doesn't have to
> do anything because ksmbd already
> checks too small OutputBufferLength to
> store one file information.
>
> And because ctx->pos is set to file->f_pos
> when iterative_dir is called, remove
> restart_ctx().
Shouldn't we get rid of the useless restart_ctx() ?

>
> This patch fixes some failure of
> SMB2_QUERY_DIRECTORY, which happens when
> ntfs3 is local filesystem.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
>  fs/ksmbd/smb2pdu.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 53c91ab02be2..6716c4e3c16d 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -3970,11 +3970,9 @@ int smb2_query_dir(struct ksmbd_work *work)
>  	 */
>  	if (!d_info.out_buf_len && !d_info.num_entry)
>  		goto no_buf_len;
> -	if (rc == 0)
> -		restart_ctx(&dir_fp->readdir_data.ctx);
> -	if (rc == -ENOSPC)
> +	if (rc > 0 || rc == -ENOSPC)
Do you know why -ENOSPC error is ignored ?

Thanks.
>  		rc = 0;
> -	if (rc)
> +	else if (rc)
>  		goto err_out;
>
>  	d_info.wptr = d_info.rptr;
> --
> 2.17.1
>
>
