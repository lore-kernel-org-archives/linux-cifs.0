Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CA4C0032E
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Oct 2023 13:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbjJYNLq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbjJYNLq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Oct 2023 09:11:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5C0131;
        Wed, 25 Oct 2023 06:11:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670EAC433CA;
        Wed, 25 Oct 2023 13:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698239503;
        bh=GDdzGV3MiYNKKFRYk6u/x6TYOnQ9UFTSb7uwo4WP6Ks=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=qmJB8FfSNRXYnFYFB59Ud+uMDafLJKBTHyT8fs3mZZxUPf+oYejFrDkdM4Dtq7ouf
         Gr38QbGVR9Hm9OQ+lI417gU7W2uBYc79XZzffY56mwGNO+xkACFuoXVHrNq6sDL3nS
         NaQBUZWG5IiqMeJ3guUURRHZ6i7DxwYA6GwT3wNLXkpH1OFUelK10p+0IDiddkB7I2
         Sn08qHSDuycXARm0ha3wCmxw//EFfh9YgQAYDpXNbI0E0Njt2EwKF6NkfribfwdYoU
         wSUrpJdE6ULwBoGpXIajPKkhm1oKrVdw+B65npVHKylSZoNO0MhQEPUgq0wbmxhcKY
         6JmV5X4/s39Sw==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1e9bb3a0bfeso4158280fac.3;
        Wed, 25 Oct 2023 06:11:43 -0700 (PDT)
X-Gm-Message-State: AOJu0YxOjvkFH9XH0rEUWQQu1iiI5wJppfpV91XwOraDyfGbGizru4WK
        3F2g4EbpOJjwxrzC5H+oLhTlouC/LjLs7M5Grps=
X-Google-Smtp-Source: AGHT+IHR2aadGdDxcDmg09kaNEwRZAD1KRJmEL+XLhtGDvaBOWzyHRAF5IXsAYGQUQv0pTycSbyQYx0EG9tu30DkAp4=
X-Received: by 2002:a05:6870:e0ca:b0:1e9:a741:44f3 with SMTP id
 a10-20020a056870e0ca00b001e9a74144f3mr17395866oab.14.1698239502584; Wed, 25
 Oct 2023 06:11:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:107:0:b0:4fa:bc5a:10a5 with HTTP; Wed, 25 Oct 2023
 06:11:41 -0700 (PDT)
In-Reply-To: <205c4ec1-7c41-4f5d-8058-501fc1b5163c@moroto.mountain>
References: <205c4ec1-7c41-4f5d-8058-501fc1b5163c@moroto.mountain>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 25 Oct 2023 22:11:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_vhTswRUQMGXXMKOO4i_cuyZte28qDZ3AzfOKd76jdAQ@mail.gmail.com>
Message-ID: <CAKYAXd_vhTswRUQMGXXMKOO4i_cuyZte28qDZ3AzfOKd76jdAQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: prevent some integer overflows
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> @@ -757,7 +756,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct
Hi Dan,

> ksmbd_session *sess, int handle
>  	struct ksmbd_rpc_command *req;
>  	struct ksmbd_rpc_command *resp;
>
> -	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
> +	msg = ipc_msg_alloc(size_add(sizeof(struct ksmbd_rpc_command) + 1,
> payload_sz));
>  	if (!msg)
>  		return NULL;
There is a memcpy() below as follows.
 memcpy(req->payload, payload, payload_sz);

Doesn't memcpy with payload_sz cause buffer overflow?
Wouldn't it be better to handle integer overflows as an error?

Thanks.
