Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30369C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Aug 2022 07:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiHJH6N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Aug 2022 03:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiHJH6M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Aug 2022 03:58:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962FF74373
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 00:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 129E5614DB
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 07:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7191FC433C1
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 07:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660118290;
        bh=4Ghv/3zHnExvv+RIlfUH366UHhH/RTaGHA+vsj8cDZw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=P2OyBsnvAfi8yZwivEo4KY6QUdgYO07mE02yBEo8JKLXSr0wp304uDaOkE4+xl0gI
         eiCqBmOJymepgFnXwdEE+JtQrWjbbgm2DKriqwhalMF01cj/qaFSwc5f6d1VOthhtS
         PCGukem2AAhP4SeVdwMpf+WDdoYkCsPq7f/JFAy1FvYEFaGj2H3BY6hqcWmusODcM5
         zKuLNk7sgMaGhkfCWI7CEGZ+td8zSYcn7EiIrg3dkU7u06aY5xZIHt6ZBSrpIt1NtD
         bst84g3i872vdDZ6q2oh3mQGWHJH5eDvn2DRyYkrBVysvhC24NV6NrqNNkB2Sxck3i
         xQJQulWwESDYA==
Received: by mail-ot1-f52.google.com with SMTP id p22-20020a9d6956000000b00636a088b2aeso10085827oto.9
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 00:58:10 -0700 (PDT)
X-Gm-Message-State: ACgBeo3+tGoyjOXoQIzKfKtwcN9+gnanchIg9YLP190brRoqYkOD/bvc
        Zc2l2FC8SAXIUqwFiOOkag70EOxq6jP/xxA41iQ=
X-Google-Smtp-Source: AA6agR65bN/r+P/JvnP1L/NVpymlvN+PlohwdtjyfRuxbnnkupY4GPry5pFK5vcsJn/QB++xp8FQpUz+Wh4H6qXTWs0=
X-Received: by 2002:a9d:7519:0:b0:636:d935:ee8e with SMTP id
 r25-20020a9d7519000000b00636d935ee8emr5739528otk.339.1660118289521; Wed, 10
 Aug 2022 00:58:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 10 Aug 2022 00:58:09
 -0700 (PDT)
In-Reply-To: <20220810010446.9229-1-hyc.lee@gmail.com>
References: <20220810010446.9229-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 10 Aug 2022 16:58:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8vXKY2mp58zc3epFxS7Pp4AZ+ggKh0Rv-rXCLAaQAW1w@mail.gmail.com>
Message-ID: <CAKYAXd8vXKY2mp58zc3epFxS7Pp4AZ+ggKh0Rv-rXCLAaQAW1w@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: remove unnecessary generic_fillattr in smb2_open
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-10 10:04 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Move the call of ksmbd_vfs_getattr above the place
> where stat is needed, and remove unnecessary
> the call of generic_fillattr.
>
> This patch fixes wrong AllocationSize of SMB2_CREATE
> response. Because ext4 updates inode->i_blocks only
> when disk space is allocated, generic_fillattr does
> not set stat.blocks properly for delayed allocation.
So what causes delay allocation between the lines you moved this code?

> But ext4 returns the blocks that include the delayed
> allocation blocks when getattr is called.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
> Changes from v1:
>  - Update the commit description.
>
>  fs/ksmbd/smb2pdu.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index e6f4ccc12f49..7b4bd0d81133 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -3022,12 +3022,6 @@ int smb2_open(struct ksmbd_work *work)
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
> @@ -3114,6 +3108,12 @@ int smb2_open(struct ksmbd_work *work)
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
> @@ -3129,9 +3129,6 @@ int smb2_open(struct ksmbd_work *work)
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
