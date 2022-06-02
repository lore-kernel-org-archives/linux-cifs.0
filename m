Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6345DC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 23:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbiFBXSZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 19:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiFBXSY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 19:18:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFA51AD8B;
        Thu,  2 Jun 2022 16:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1591A6193B;
        Thu,  2 Jun 2022 23:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AD7C3411D;
        Thu,  2 Jun 2022 23:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654211902;
        bh=5zKH3voexk5e83hgAVhHRhu2LSifRxckQ3WYBidmU7U=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=cRgu8+OdUxpDFyKBjDcIn62/AQl+3qXQCtonmgdeLLA0Ti36ANMHILLsnbrwrFmnj
         7GPpS/Dlwgz+BHwSQhz0zjd2Jkq9gAmZK/t65+/66ckgdM5lT8SvitDtGb5sUR1oJ4
         308EILRLrRN6QkwH+7FSqdvEiG7RcG2GmOXPINrWJkoaeD/N7aUBoHGB70RM03720C
         qNF/mpdvKfBgREKSGbgdriQykwWFEVCV/t0n05h7vMDX6eSz/NQqje5u6WsFvjU86Y
         ZdwZ2u+DLYIwf5nUdL4WCavyT4hjBSLP2dABMVypGB9BWzc+Q7P3xqKHoggpyFXobI
         BCNy36sA+HzuA==
Received: by mail-wr1-f50.google.com with SMTP id t13so8267205wrg.9;
        Thu, 02 Jun 2022 16:18:22 -0700 (PDT)
X-Gm-Message-State: AOAM5330C9X1/wHLqT7CxyoCaNkpbPthZsWRNscBqMOZ212pIr6fbtfH
        QTnjFprFd6CXjCd5daxjLytbCt0n9DTFV6xFy/A=
X-Google-Smtp-Source: ABdhPJwYK3iMlCvoE8L29L60LKUBjEn2kabGNSKet5+dKQ5bVeKIfKIaU8sJU2ObzX9MNoEtcG89dECUEuTb+RiZTC0=
X-Received: by 2002:a5d:457b:0:b0:210:2101:ef76 with SMTP id
 a27-20020a5d457b000000b002102101ef76mr5303295wrc.401.1654211900644; Thu, 02
 Jun 2022 16:18:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:ee4e:0:0:0:0:0 with HTTP; Thu, 2 Jun 2022 16:18:19 -0700 (PDT)
In-Reply-To: <YpiWS/WQr2qMidvA@kili>
References: <YpiWS/WQr2qMidvA@kili>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 3 Jun 2022 08:18:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_=x-uT8U_2tdbmVxbhyg_pDY03NKP9zzDwQZmm0TxQmg@mail.gmail.com>
Message-ID: <CAKYAXd_=x-uT8U_2tdbmVxbhyg_pDY03NKP9zzDwQZmm0TxQmg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: clean up a type in ksmbd_vfs_stream_write()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Steve French <sfrench@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-06-02 19:51 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> The existing code works fine because ksmbd_vfs_getcasexattr() isn't
> going to return values greater than INT_MAX.  But it's ugly to do
> the casting and using a ssize_t makes everything cleaner.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/ksmbd/vfs.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
> index dcdd07c6efff..efdc35717f6d 100644
> --- a/fs/ksmbd/vfs.c
> +++ b/fs/ksmbd/vfs.c
> @@ -411,7 +411,8 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp,
> char *buf, loff_t *pos,
>  {
>  	char *stream_buf = NULL, *wbuf;
>  	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
> -	size_t size, v_len;
> +	ssize_t v_len;
> +	size_t size;
>  	int err = 0;
>
>  	ksmbd_debug(VFS, "write stream data pos : %llu, count : %zd\n",
> @@ -428,9 +429,9 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp,
> char *buf, loff_t *pos,
>  				       fp->stream.name,
>  				       fp->stream.size,
>  				       &stream_buf);
> -	if ((int)v_len < 0) {
> +	if (v_len < 0) {
>  		pr_err("not found stream in xattr : %zd\n", v_len);
> -		err = (int)v_len;
> +		err = v_len;
Data type of ssize_t is long. Wouldn't some static checker warn us
that this is a problem?

Thanks!
>  		goto out;
>  	}
>
> --
> 2.35.1
>
>
