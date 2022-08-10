Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A39C19F2D
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Aug 2022 00:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiHJAq3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Aug 2022 20:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiHJAq1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Aug 2022 20:46:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655A77CB6D
        for <linux-cifs@vger.kernel.org>; Tue,  9 Aug 2022 17:46:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0D626122A
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 00:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B95C433D7
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 00:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660092382;
        bh=bXrGP7JY/AZ5QmF7iAEaOZPo36i8HJc3gYXHMwH/PbU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=b341pvzCKiRgeVBXA1qg4wrqk5mRU3rYKfKQzh7gClarpvBVbDINfvK2/ctPWV4mC
         MLy4NotC6uvgXirbREezIVIyzXGR97feRK1fiC9YEBerOpF2eo+B4QHLmgaIv5iy2m
         o8ItIDl2dr+wcRVBW2r/IjQPnszVBQXO+CoDgwvBG+4pOeJPoAYUg/8o9/BLvVlvcX
         KR/DxSfke4v0cNwUy0/FiXnU7MZkKiXnUI4ghCxp4ilrNyqzVoI49fILo0/NkH3bbf
         sahhKCOvcIb3f4RWoXHKUR2sEJJ9WmTZy8cL7UCDm3R8Mg2w8Anq7bvhNgUKmRjudq
         lmFAUwlkf6FRw==
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-10dc1b16c12so16052260fac.6
        for <linux-cifs@vger.kernel.org>; Tue, 09 Aug 2022 17:46:22 -0700 (PDT)
X-Gm-Message-State: ACgBeo2cYJ2An6YO2AiH6MCFv7LK+IcVIQRHaMOzgYvkvR6B4JeG9uJk
        Il/q9TeCD+wFyicvtTpRrDCBh1PuoXY5qLSaKIs=
X-Google-Smtp-Source: AA6agR6foyfwOufjoXtniqeOWVu0B1Pk0PFZhjk4ht0h+UnDwihBFxNTI8MlTzGNvIGtWxZk5UUzsZsDFBQnvYE/RR8=
X-Received: by 2002:a05:6870:b00b:b0:113:5b32:3d4d with SMTP id
 y11-20020a056870b00b00b001135b323d4dmr498648oae.8.1660092381382; Tue, 09 Aug
 2022 17:46:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Tue, 9 Aug 2022 17:46:20
 -0700 (PDT)
In-Reply-To: <20220809224522.11725-1-hyc.lee@gmail.com>
References: <20220809224522.11725-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 10 Aug 2022 09:46:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-7Rp5jX0Rw3EavAEkDAaGkq4rgeKExxTO+r7AB_GyQ1g@mail.gmail.com>
Message-ID: <CAKYAXd-7Rp5jX0Rw3EavAEkDAaGkq4rgeKExxTO+r7AB_GyQ1g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: remove unnecessary generic_fillattr in smb2_open
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-10 7:45 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Move the call of ksmbd_vfs_getattr above the place
> where stat is needed, and remove unnecessary
> the call of generic_fillattr.
>
> This patch fixes wrong AllocationSize of SMB2_CREATE
> response because generic_fillattr does not reflect
> i_blocks for delayed allocation.
Could you please elaborate more ? I didn't understand how moving a few
lines would fix this.

>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
>  fs/ksmbd/smb2pdu.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 9751cc92c111..d0a0256334ea 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -3042,12 +3042,6 @@ int smb2_open(struct ksmbd_work *work)
>  	list_add(&fp->node, &fp->f_ci->m_fp_list);
>  	write_unlock(&fp->f_ci->m_lock);
>
> -	rc = ksmbd_vfs_getattr(&path, &stat);
> -	if (rc) {
> -		generic_fillattr(user_ns, d_inode(path.dentry), &stat);
> -		rc = 0;
> -	}
> -
>  	/* Check delete pending among previous fp before oplock break */
>  	if (ksmbd_inode_pending_delete(fp)) {
>  		rc = -EBUSY;
> @@ -3134,6 +3128,12 @@ int smb2_open(struct ksmbd_work *work)
>  		}
>  	}
>
> +	rc = ksmbd_vfs_getattr(&path, &stat);
> +	if (rc) {
> +		generic_fillattr(user_ns, d_inode(path.dentry), &stat);
> +		rc = 0;
> +	}
> +
>  	if (stat.result_mask & STATX_BTIME)
>  		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
>  	else
> @@ -3149,9 +3149,6 @@ int smb2_open(struct ksmbd_work *work)
>
>  	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
>
> -	generic_fillattr(user_ns, file_inode(fp->filp),
> -			 &stat);
> -
>  	rsp->StructureSize = cpu_to_le16(89);
>  	rcu_read_lock();
>  	opinfo = rcu_dereference(fp->f_opinfo);
> --
> 2.17.1
>
>
