Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DBD0C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Jan 2021 02:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 199C46146D
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Jan 2021 02:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhA2CIx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhA2CIw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Jan 2021 21:08:52 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B8DC061573
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jan 2021 18:08:11 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u8so2650990ior.13
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jan 2021 18:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NAUaovU26IJgAvbH6tJ5ZphMl7ZJJFraMcWT03sIbb0=;
        b=YHHyQAuD5o2Br86ya1dxgHOaf9yMB8BdFQMdeUPutCgliKeBMvE5SnPJkrYuISJYHC
         PqQYZ09BwHnffLHhpPR0Tnw/1oJ71RfwpKhT30qdqKp80R603TTCKLpNqoaxTrQ7SPIv
         PsEqQ5/b3InJLEAEHL2pHf07WIMhfh7EUP3nq7LDwM5cnvqiIE2DvfzvusM55oHWKOnG
         /Otf0WIVV1uykzhQkQkS3X63WYYddioKA5Aj04IJSyhUAERlqwaz/aSjGP/Wye9VZS1+
         ldAuZhvPHihvmpbWJrP/EfukEXooVUdTfEYSlWuhCKniJolu4kPqH3ZqMoowQtR+xduT
         YBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NAUaovU26IJgAvbH6tJ5ZphMl7ZJJFraMcWT03sIbb0=;
        b=AoHx21L9BsFRIvqgSFrM6fvUmfNhAz0zj0kFO1X61U74zMSWtZF47E9ViebihSz0qm
         86SbxXHh9UtKuRJB+eckWah+z+uxXs0nrv67+vsuFC4hxOrcz2kAUO6yd5ZVM55sKPUg
         1KJm/Kx1/9/YQ1T1y+JRg0ZZb/Av5Ft+ChG0dxGdHhLJBlAHWv7S9QZdMYyYlCVRnBqC
         39UZvh0RMKUTlYVGGw/khQm5BfMuIMMwBhDgmTfNSH3mNLIYZytCJQy417c8RLA6s5ss
         bODCs2pLh+sQ3vKLthQcINy5VmYCDrmc0n4evlaggyLZAQ32LxbtaeNGFLviWyiYdRGN
         nX/A==
X-Gm-Message-State: AOAM532D0+2h/e9THU660zOL0FL4AjIUiZfT3860L7b1p31lpV7ml6Vl
        A9VCtlvtuGksoQ+kGQlCpzuQlPWJ5zeF7HA3ByrWd8rE
X-Google-Smtp-Source: ABdhPJy0J0st7nUgifVPhk0h3sWz7uHi7XZqPGDKJ7Fol5vIULBqKB53atELfFixcJYnWnoYvvwqmR6GFOlQ8c1xhsE=
X-Received: by 2002:a6b:d80e:: with SMTP id y14mr2082361iob.101.1611886090900;
 Thu, 28 Jan 2021 18:08:10 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muGrzDP9FWNed44XpYs3NNbmRt7kzGrwX_+h=Xje8qUfg@mail.gmail.com>
In-Reply-To: <CAH2r5muGrzDP9FWNed44XpYs3NNbmRt7kzGrwX_+h=Xje8qUfg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 29 Jan 2021 12:07:59 +1000
Message-ID: <CAN05THR7AcTOtbGXVEf12Gj_orO0Yd88agUP=jnM0-cg8dztJA@mail.gmail.com>
Subject: Re: [PATCH] cifs: returning mount parm processing errors correctly
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

acked-by me

On Fri, Jan 29, 2021 at 8:52 AM Steve French <smfrench@gmail.com> wrote:
>
>     During additional testing of the updated cifs.ko with the
>     new mount API support, we found a few additional cases where
>     we were logging errors, but not returning them to the user.
>
>     For example:
>        a) invalid security mechanisms
>        b) invalid cache options
>        c) unsupported rdma
>        d) invalid smb dialect requested
>
>     Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
>     Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
>     Signed-off-by: Steve French <stfrench@microsoft.com>
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 818c413db82d..27354417e988 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -533,7 +533,7 @@ static int smb3_fs_context_validate(struct fs_context *fc)
>
>         if (ctx->rdma && ctx->vals->protocol_id < SMB30_PROT_ID) {
>                 cifs_dbg(VFS, "SMB Direct requires Version >=3.0\n");
> -               return -1;
> +               return -EOPNOTSUPP;
>         }
>
>  #ifndef CONFIG_KEYS
> @@ -556,7 +556,7 @@ static int smb3_fs_context_validate(struct fs_context *fc)
>         /* make sure UNC has a share name */
>         if (strlen(ctx->UNC) < 3 || !strchr(ctx->UNC + 3, '\\')) {
>                 cifs_dbg(VFS, "Malformed UNC. Unable to find share name.\n");
> -               return -1;
> +               return -ENOENT;
>         }
>
>         if (!ctx->got_ip) {
> @@ -570,7 +570,7 @@ static int smb3_fs_context_validate(struct fs_context *fc)
>                 if (!cifs_convert_address((struct sockaddr *)&ctx->dstaddr,
>                                           &ctx->UNC[2], len)) {
>                         pr_err("Unable to determine destination address\n");
> -                       return -1;
> +                       return -EHOSTUNREACH;
>                 }
>         }
>
> @@ -1265,7 +1265,7 @@ static int smb3_fs_context_parse_param(struct
> fs_context *fc,
>         return 0;
>
>   cifs_parse_mount_err:
> -       return 1;
> +       return -EINVAL;
>  }
>
>  int smb3_init_fs_context(struct fs_context *fc)
>
>
> --
> Thanks,
>
> Steve
