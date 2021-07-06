Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40ACC11F66
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Jul 2021 12:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F5961C7A
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Jul 2021 12:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbhGFMqp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Jul 2021 08:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236988AbhGFMqi (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 6 Jul 2021 08:46:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B705361C89;
        Tue,  6 Jul 2021 12:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625575439;
        bh=nwvOkJ+F4QjiF8fh8gKZ9edl/Xfc+oYRAgBD8OQ7gSM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ZHJuRZOdaqa+m6Q9NiUzlYqj8gCeTCM1U9+v3eqEhmEV8ILAGAtSLxhPI9TAW1nSJ
         iiJ6sXoEfGV8cy7cJdzjUxwGXOrFZ1e/76JCaI/UkG905yzwSkHp9ZfvPiQP0Td7os
         YLdWGci+fkRHuQZFrjIIyemluKMGohWin756NL2aj8zoxdpZHtUsJJaThqYFk+bDoQ
         SqJfZVf9maXLdC8OEfvIM69p14WndOHozwoU7fwdtzrE7nf/5pU8sQANj2mjELgrmh
         Smm2BHbyAWaOnZYieZpcBFbWfZRDKeCHLKgNau//PJZjDK8cXRBL427wApBxc1dA9W
         gjoMJwkZvqOpA==
Received: by mail-ot1-f44.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so21439718oti.2;
        Tue, 06 Jul 2021 05:43:59 -0700 (PDT)
X-Gm-Message-State: AOAM530YU19W1NJ0w5r5IAK60h0cYufbGmLitwn3yO8WZToG59lkWtb5
        pdPSYu1k8gMtUq5712cOdU3+czzkDqsZnX2UO3Q=
X-Google-Smtp-Source: ABdhPJyf62PRFT6h7jdgxj8GHwgtbQJ8Q9Eq0NWfVX8aIXw5K03OksUYcrdEWkYgKybIO7uTUmj4Tk8Ud0BO1SKk9SM=
X-Received: by 2002:a9d:3644:: with SMTP id w62mr14724460otb.205.1625575439094;
 Tue, 06 Jul 2021 05:43:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:4443:0:0:0:0:0 with HTTP; Tue, 6 Jul 2021 05:43:58 -0700 (PDT)
In-Reply-To: <20210706120501.28776-1-colin.king@canonical.com>
References: <20210706120501.28776-1-colin.king@canonical.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 6 Jul 2021 21:43:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9=fQv2jqSUkeavnccvTd8n5ShpCW=jFC5ikx_=Bo=G3A@mail.gmail.com>
Message-ID: <CAKYAXd9=fQv2jqSUkeavnccvTd8n5ShpCW=jFC5ikx_=Bo=G3A@mail.gmail.com>
Subject: Re: [PATCH][next] ksmbd: Fix read on the uninitialized pointer sess
To:     Colin King <colin.king@canonical.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Colin,

2021-07-06 21:05 GMT+09:00, Colin King <colin.king@canonical.com>:
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a error handling case that passes control to label out_err
> without pointer sess being assigned a value. The unassigned pointer
> may be any garbage value and so the test of rc < 0 && sess maybe
> true leading to sess being passed to the call to ksmbd_session_destroy.
> Fix this by setting sess to NULL in this corner case.
>
> Addresses-Coverity: ("Uninitialized pointer read")
> Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
I will apply this patch. Thanks for your patch!
