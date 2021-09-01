Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646C6C432BE
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 12:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E5E60E98
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 12:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345171AbhIAMxn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Sep 2021 08:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345206AbhIAMvl (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 1 Sep 2021 08:51:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C6E6610E6
        for <linux-cifs@vger.kernel.org>; Wed,  1 Sep 2021 12:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630500438;
        bh=n1GgJcs9bvTndl7eeVPgGvG2hxnBAlwJ5GlxekWZBAs=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Hxbfy+ZtxqZqSm4N4ZXnZHR2WZEtCMNw65FgFJ2Nj+AkTJZhzFsYchDfpjZ3DyXvL
         YWlVxDjaW+BwJQFzMfFrJey1Mtxu+ntSSkZmUHIaLGLDVrY4o7NQ/Tmb4wNhVUK4ch
         949WaQ3x4GP3b6WfLgWXITUuMytZFlob9Voe9RSeUyjxraWi8GIp2JQNg6PP6ZXV/g
         SpuiNsA/MCLdO1RZRPUm1aXKARoAf/tXAL4SekgtWJOY0M28XZ6wWSmKtX9VrYexVQ
         4xCSTlZk4EmrFc+AF6bOZsFmx0ThigSXToOXD29mZG3Wncrz/z6tomD8cgweJyeKnJ
         1TiZwK0qkJ2mg==
Received: by mail-ot1-f45.google.com with SMTP id v33-20020a0568300921b0290517cd06302dso3223944ott.13
        for <linux-cifs@vger.kernel.org>; Wed, 01 Sep 2021 05:47:18 -0700 (PDT)
X-Gm-Message-State: AOAM532YdOcU367rbEDfouIIiARYWejosAl29VtePUDcs+2cJRESNXpr
        bGqDqaOC9RWW9ppNGy+bmyYS9oa2EJB8cuDBvuA=
X-Google-Smtp-Source: ABdhPJzwKWtnEvpuca73zMruhWYKG5pAEcfcYN9AMZ0+ZK465xTCF46GanA8J5Gg+9Aee4GiZIu3szwgh4gNwI2ZFPs=
X-Received: by 2002:a9d:3e09:: with SMTP id a9mr7549278otd.87.1630500437840;
 Wed, 01 Sep 2021 05:47:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:1bc6:0:0:0:0:0 with HTTP; Wed, 1 Sep 2021 05:47:17 -0700 (PDT)
In-Reply-To: <20210823151357.471691-11-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org> <20210823151357.471691-11-brauner@kernel.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 1 Sep 2021 21:47:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8MAk2hO7fdM1PSSh5czdaT+BGuidcm3Q3RFKBqzD5tLA@mail.gmail.com>
Message-ID: <CAKYAXd8MAk2hO7fdM1PSSh5czdaT+BGuidcm3Q3RFKBqzD5tLA@mail.gmail.com>
Subject: Re: [PATCH 10/11] ksmbd: remove setattr preparations in set_file_basic_info()
To:     Christian Brauner <brauner@kernel.org>
Cc:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-08-24 0:13 GMT+09:00, Christian Brauner <brauner@kernel.org>:
> From: Christian Brauner <christian.brauner@ubuntu.com>
>
> Permission checking and copying over ownership information is the task
> of the underlying filesystem not ksmbd. The order is also wrong here.
> This modifies the inode before notify_change(). If notify_change() fails
> this will have changed ownership nonetheless. All of this is unnecessary
> though since the underlying filesystem's ->setattr handler will do all
> this (if required) by itself.
>
> Cc: Steve French <stfrench@microsoft.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: linux-cifs@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/ksmbd/smb2pdu.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 1148e52a4037..059764753aaa 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -5521,12 +5521,7 @@ static int set_file_basic_info(struct ksmbd_file *fp,
> char *buf,
>  		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  			return -EACCES;
>
> -		rc = setattr_prepare(user_ns, dentry, &attrs);
> -		if (rc)
> -			return -EINVAL;
> -
>  		inode_lock(inode);
> -		setattr_copy(user_ns, inode, &attrs);
>  		attrs.ia_valid &= ~ATTR_CTIME;
>  		rc = notify_change(user_ns, dentry, &attrs, NULL);
setattr_prepare() was used for updating ->ctime to ChangeTime in set
file basic info request. but notify_change() have just updated it to
current time. So some of smbtorture tests failed.
Could you please review the below change ?
https://github.com/namjaejeon/smb3-kernel/commit/831bcdeaa5231a8d8125f6155833f1cb5dc0f8ca

Thanks!
>  		inode_unlock(inode);
> --
> 2.30.2
>
>
