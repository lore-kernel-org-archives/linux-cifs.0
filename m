Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373C8C6FA82
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Sep 2022 23:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiIYX4i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Sep 2022 19:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiIYX4h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Sep 2022 19:56:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAD827DC3
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 16:56:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C2BDB80D23
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 23:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA78C433D7
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 23:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664150193;
        bh=y9T1IXK3k34203u9E1t4LfSvzIo5cDHV6QtPjld4rPI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Z2X1khCt9qcDetQflGW7p3W8TOKajmFvgrB9UISfCHvRL0GIJdv7GoFxn0cppDZMn
         1lx/chBUE/6nd2HT4gNBzrs7dKEjUwo92xlcOCeJA18od2tEd1IhgA5CBOrxnKAC7s
         cjr8Ik7RL2wKQu6N7MuJLQx/7YJc/3P6MDMKakA4dK/sS629G4SRdOgP1/v6lANkJG
         2x13gYMfm1915peQUwhBlLBiMXrcAEr9lkXH9xK5xHF4sWro/MLoSep1lsr2OtdP4L
         Qpcf0oBLEITpW14A7etyQQ8jOmGdq6LrAodUOdiMbGePcZsWkJnWE7xWdKAfSAnGi9
         jOMEpMbDSSOZA==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-12803ac8113so7291988fac.8
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 16:56:33 -0700 (PDT)
X-Gm-Message-State: ACrzQf03fQMUDuocg3nC7cSVcZNmVytdaJLoKHtMlPCIF5uDWNbKe3pw
        LmZjlfeiCZAt6vI1wTq4zWNdtJ6m+rkHwkRJNKQ=
X-Google-Smtp-Source: AMsMyM5+am3KHNd1xKWX7m1+qZKEqK1kZv6gSxPZXz3xAaReM2wWQ4vT4nBd/XiJkE+jWS7k2wOLcfljKOmAwb4PmJo=
X-Received: by 2002:a05:6870:9a26:b0:12d:7e1:e9c7 with SMTP id
 fo38-20020a0568709a2600b0012d07e1e9c7mr11656269oab.257.1664150192924; Sun, 25
 Sep 2022 16:56:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sun, 25 Sep 2022 16:56:32
 -0700 (PDT)
In-Reply-To: <20220924105255.336399-3-zhangxiaoxu5@huawei.com>
References: <20220924105255.336399-1-zhangxiaoxu5@huawei.com> <20220924105255.336399-3-zhangxiaoxu5@huawei.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 26 Sep 2022 08:56:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9OTKCMkDqoUGsX7z2VZTYWM+noR-6G-EDfp2wqrM4zFw@mail.gmail.com>
Message-ID: <CAKYAXd9OTKCMkDqoUGsX7z2VZTYWM+noR-6G-EDfp2wqrM4zFw@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] ksmbd: Fix wrong return value and message length
 check in smb2_ioctl()
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, rohiths@microsoft.com,
        smfrench@gmail.com, tom@talpey.com, hyc.lee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-24 19:52 GMT+09:00, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>:
> The structure size includes 4 dialect slots, but the protocol does not
> require the client to send all 4. So this allows the negotiation to not
> fail.
This comment is a bit vague.
You need to add the description to validate DialectCount before
calling fsctl_validate_negotiate_info(). Because there is the check
using DialectCount
in this function, so we have to validate it first.

>
> Also when the {in, out}_buf_len is less than the required, should goto
> out to initialize the status in the response header.
>
> Fixes: f7db8fd03a4bc ("ksmbd: add validation in smb2_ioctl")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/ksmbd/smb2pdu.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 15c487aa19ad..d8ef50530a73 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7638,11 +7638,16 @@ int smb2_ioctl(struct ksmbd_work *work)
>  			goto out;
>  		}
>
> -		if (in_buf_len < sizeof(struct validate_negotiate_info_req))
> -			return -EINVAL;
> +		if (in_buf_len < offsetof(struct validate_negotiate_info_req,
> +					  Dialects[1])) {
Why did you change it from v6? v6 is the correct fix...

> +			ret = -EINVAL;
> +			goto out;
> +		}
>
> -		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
> -			return -EINVAL;
> +		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp)) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>
>  		ret = fsctl_validate_negotiate_info(conn,
>  			(struct validate_negotiate_info_req *)&req->Buffer[0],
> --
> 2.31.1
>
>
