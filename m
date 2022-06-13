Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC0BBC43334
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jun 2022 23:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiFMXIu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Jun 2022 19:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiFMXIt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Jun 2022 19:08:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C2A31505
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 16:08:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 56BBDCE1861
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 23:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4774C341C0
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 23:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655161721;
        bh=HGc6cIbtgjv7o6fmoJz8Pl7CJMO8oq52Nh3gEPEQma8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=g6YnBfplIFgfYMk+ue4s7GwCtkyyZksgdmgPQCX/IR66XZ02/2/09+zqKh25cp+OS
         VCQeYtuLaSVXgTdDTg4uzZNJC+ATQyZ8Nj0jqkUQjXMwiuPrFpa0qhfcEPk4VrLtDE
         hWmRiwOd4BP7kxG6cy/Qu6yHnt/PXawjMbtsdbjX9quSBeH74khEBM/eaV83U8okeQ
         U5QG9fZE0t3wQZ9biKQyAUCqmidhGlw7wrzoVLPDGCB7ctEX2tCd4jCVjIOrCAj1ZG
         k/J8M6nrcNucLR0kjQZC18ZbMf9F7noka9yXdpfl6Mozt2Vq7wFlr2ekwDAhKFpjGR
         AfyGHJlGf2wKQ==
Received: by mail-wm1-f45.google.com with SMTP id x6-20020a1c7c06000000b003972dfca96cso3870702wmc.4
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 16:08:41 -0700 (PDT)
X-Gm-Message-State: AOAM532LlJ+VRbWd1gQEodTG1a9iqRoyWY4xqrH5WpDgxmZzCyL5QJd/
        ZgwjFSSdOpq6vxX4KS0LBxXA/9PmREZ7ztPHys8=
X-Google-Smtp-Source: ABdhPJxqjoR8ChdW1rCMMi4oZ8veyI8NDoCxC4Pmi7DtRAirS7wG+ocnXmEE0vwOcG56ET54Ily1hr98pl1r76XgYjg=
X-Received: by 2002:a05:600c:19c7:b0:39c:30b0:2b05 with SMTP id
 u7-20020a05600c19c700b0039c30b02b05mr1005110wmq.170.1655161719882; Mon, 13
 Jun 2022 16:08:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:4c4a:0:0:0:0:0 with HTTP; Mon, 13 Jun 2022 16:08:39
 -0700 (PDT)
In-Reply-To: <20220613230119.73475-1-hyc.lee@gmail.com>
References: <20220613230119.73475-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 14 Jun 2022 08:08:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_4drxMozKppYKG8n5NJ2WqSn_n6dWoFBf=AsJ9zWrMvA@mail.gmail.com>
Message-ID: <CAKYAXd_4drxMozKppYKG8n5NJ2WqSn_n6dWoFBf=AsJ9zWrMvA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: remove duplicate flag set in smb2_write
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-06-14 8:01 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> The writethrough flag is set again if
> is_rdma_channel is false.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
>  fs/ksmbd/smb2pdu.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index e6f4ccc12f49..553aad4ca6fa 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -6506,9 +6506,6 @@ int smb2_write(struct ksmbd_work *work)
>  				    le16_to_cpu(req->DataOffset));
>
>  		ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
Could you move debug print to flags check above also ?

> -		if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
> -			writethrough = true;
> -
>  		ksmbd_debug(SMB, "filename %pd, offset %lld, len %zu\n",
>  			    fp->filp->f_path.dentry, offset, length);
>  		err = ksmbd_vfs_write(work, fp, data_buf, length, &offset,
> --
> 2.25.1
>
>
