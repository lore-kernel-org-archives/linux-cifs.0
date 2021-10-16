Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E36C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Oct 2021 04:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8366161181
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Oct 2021 04:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbhJPE62 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Oct 2021 00:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236300AbhJPE62 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 16 Oct 2021 00:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD75A61181
        for <linux-cifs@vger.kernel.org>; Sat, 16 Oct 2021 04:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634360180;
        bh=csCEMnNxdzxpxZEtLgNvAxoOpbX1yIU6o90JuxbZeRE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=GCwncv+/W4PHL5azIXuOfI5M+NSrZbhlGVjyn1c9Mv3qB2aFpz5/0EaOPwvrne6gc
         LNk++kvze1kzD3d0fIeBiYV2X6gqg30sIv8nWF7Y/f2X0NqRaQGz/6FmSlb05gzBpD
         0R/Y47EbFEgG6mmSTiZkzHVsCWKsHbgoM9aXYNRxp7NqdZqJDk3ut/4Uvy+p+HF+Jw
         BjVj/Qi/sRzwBxi0PljsAMkKNdz8Lzjjtf5JkZcJj1g4NquXeLS9qZCW41BCUDJ5HI
         +Ur/w/UvCT4tcB3S0l19hBxIhMaRIqv+fYv33Cu/Pgo0biSE4lWtSlN7ADpLagtJai
         IxeHay76HuFxA==
Received: by mail-ot1-f44.google.com with SMTP id 62-20020a9d0a44000000b00552a6f8b804so267893otg.13
        for <linux-cifs@vger.kernel.org>; Fri, 15 Oct 2021 21:56:20 -0700 (PDT)
X-Gm-Message-State: AOAM5337/smhgy5ba3BB06AKcwsjSCbBIMZwQ64LPI3jj7dUzsSGjfeq
        FnzLrWEXV9mtLejYjTB+R5BRoFut+WY+uo9o3zI=
X-Google-Smtp-Source: ABdhPJwxWPRouCxE12mRt+nBQ4295xHZP1G7One+zTG7Ms4NIENlkKsdGI5Or1lNBr9Enpk+PeGMr0ETIwBai5pEXOw=
X-Received: by 2002:a05:6830:17da:: with SMTP id p26mr11509086ota.116.1634360180182;
 Fri, 15 Oct 2021 21:56:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Fri, 15 Oct 2021 21:56:19
 -0700 (PDT)
In-Reply-To: <20211015233954.305265-1-hyc.lee@gmail.com>
References: <20211015233954.305265-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 16 Oct 2021 13:56:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9OZ0h8fh0OwdhO1hT5M_GBovwZ4hz1VPAzwbnA2SpBPw@mail.gmail.com>
Message-ID: <CAKYAXd9OZ0h8fh0OwdhO1hT5M_GBovwZ4hz1VPAzwbnA2SpBPw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate OutputBufferLength of QUERY_DIR,
 QUERY_INFO, IOCTL requests
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-16 8:39 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Validate OutputBufferLength of QUERY_DIR, QUERY_INFO, IOCTL requests and
> check the free size of response buffer for these requests.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
