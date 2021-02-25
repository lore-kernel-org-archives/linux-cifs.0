Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA78DC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 06:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 820A664EC4
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 06:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhBYGHk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 01:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbhBYGFd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Feb 2021 01:05:33 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A757C061756
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 22:04:52 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id c131so4308346ybf.7
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 22:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6+jxr3lScrNwu/Ca7R4dnLv42howEuNQQJHNj9A8bAk=;
        b=J1I35l2JwveyjyrjvxdKSlpC54BHD4yJ0kIAnd47yxqWOe2iMEfqv9d1WSeerdorX8
         +J3XReFKJZp7SriCPAtvHGr2r6vOwxpVZ2CLmX/LIT9VzeR2/ASmmyoGvxnxv4STsEz3
         Kg3A284sjgS66+apakDCwRSgfqBs1lFPNa46FHAGwhKvcTz1IwNBsQC6+A1uITKyHTe1
         WuBSDjRhcL0uTUWEfKI7zXdv3/E0G/os86CRjpDgKilyvDWMeytZE7jfXTa2ZaGf+1wN
         3+08js87qk344PT83vJF1SxJd3Y64GHTOM6FUGmKgGMJZKLhYNXCN5fNW0l9tBv7ALp3
         lVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6+jxr3lScrNwu/Ca7R4dnLv42howEuNQQJHNj9A8bAk=;
        b=Wn3L4rFez57q4byMNbTNORxbDjb7oH6mMNEeNwp34jMwtqfsXsJGrEZHVcMKqXuCj8
         DSrnDOJjGrcUfOOI6amAgYHesFlDkIRGOssBwjIWePBdQVZiSkK0T9gwTuHcP+axYz1e
         X2D3x1KHlt2u6P0BnjMvdEI0DRp1MlfHb3ak2O3bILNgrob3jkMx7pa7gXsSfxUw2Qtv
         VHliCJDfZZS70vPR8yJbU4NKfAKEqXAUxI/UFvFg/Pw6paI2zPfm+qONZvG+A/t9k+Dh
         icrlnZaTowCC5QCPQu65S//+mHXxgzuTKuRiqFzn0Yjp3rTAovR2WmkCFw5w4LrRcAZR
         X4jg==
X-Gm-Message-State: AOAM532BznaME6vIJmY5MhzOUOhbVFGuNR909+iulvFudi5/OH36BD0b
        mm75mgnO088bFv2MqyBpyqIEZE1sdrKmNzuhmso=
X-Google-Smtp-Source: ABdhPJwKsiB7c3T8IpmAqyF9sLgPy1KGjZZLzsAtRykklOpnF9UcruXyU6rCv1DGHKUvfp3ye2pY1qB6o83howYwHxQ=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr1776543yba.3.1614233091876;
 Wed, 24 Feb 2021 22:04:51 -0800 (PST)
MIME-Version: 1.0
References: <20210224235924.29931-1-pc@cjr.nz> <20210224235924.29931-4-pc@cjr.nz>
In-Reply-To: <20210224235924.29931-4-pc@cjr.nz>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 25 Feb 2021 11:34:41 +0530
Message-ID: <CANT5p=p0hSUaDiXzbLDb-VoiztoQ-efXNnqz8Ue2MJHXdYFsPw@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: fix nodfs mount option
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

On Thu, Feb 25, 2021 at 10:16 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Skip DFS resolving when mounting with 'nodfs' even if
> CONFIG_CIFS_DFS_UPCALL is enabled.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/connect.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 37452b2e24b8..6ab5f96fe1b4 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3373,15 +3373,15 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
>
>         rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
>         /*
> -        * Unconditionally try to get an DFS referral (even cached) to determine whether it is an
> -        * DFS mount.
> +        * If called with 'nodfs' mount option, then skip DFS resolving.  Otherwise unconditionally
> +        * try to get an DFS referral (even cached) to determine whether it is an DFS mount.
>          *
>          * Skip prefix path to provide support for DFS referrals from w2k8 servers which don't seem
>          * to respond with PATH_NOT_COVERED to requests that include the prefix.
>          */
> -       if (dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb), ctx->UNC + 1, NULL,
> +       if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
> +           dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb), ctx->UNC + 1, NULL,
>                            NULL)) {
> -               /* No DFS referral was returned.  Looks like a regular share. */
>                 if (rc)
>                         goto error;
>                 /* Check if it is fully accessible and then mount it */
> --
> 2.30.1
>


-- 
Regards,
Shyam
