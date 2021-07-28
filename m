Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EFEFC4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jul 2021 15:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2688660E09
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jul 2021 15:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbhG1P2j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Jul 2021 11:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236793AbhG1P2i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Jul 2021 11:28:38 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C049C061757
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jul 2021 08:28:36 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id da26so3813360edb.1
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jul 2021 08:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ft1bbROl2zFuaejuWvSLZK6OFlyR9Hur4Kvds8IcZNE=;
        b=XU/k9ZcEI6OcGkQtURhfA5PE5PUEEf6Gzwd89fP/4NM/JGFZDM6xgNDs1E8PW6UB+4
         sP6lgGOR1XM/l1FxIbUVQiz7i3N5gzURz0n91sE8nlaJLthdrhH8jfk14zJxXJNkXYaH
         4MgGk1yTA7ZNXzufdWjs1slnl9+b8pxMbDUEruWoJe9Ta//dNWLcX9LJYVXegZSnz69R
         jV5bsq2PeVR8RkOVmeFjzkbvo4WAxuHLMwO6WgyiMGIyz42o9cdVD5w1jVip70fwPJiW
         aN0mFLNmkxgtVeQKCDxM4TdOI5Kp4IzyNwtIJcT0Dlda+Nba7a1SOlMLjnMjACJ/Bl60
         A8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ft1bbROl2zFuaejuWvSLZK6OFlyR9Hur4Kvds8IcZNE=;
        b=XbNzSN2xLdDj2dwCI4GQTgksZEO2MwsltRjUlCEah5VR0ejcXES5gMLvoVMuzKT+7o
         wt4DxL8pr4IINROZuNNK1u6nThtac8ay3bwGW6DV1CwqE9TdW+BKFjIdFFchhVfgnaIP
         IF2a6nOaqXKj3qhLxeHrdJNsOBFFcRowTdnLhHr11BFJCLiDhEzbXasbR2UB5N3hOA1V
         KEddzrfgvC40Pn3NPZBxJZ7ORe75Am5Dl2TfzBtKtHMow3jkk1wNk4Rf8xPnl+lfBgn2
         Fz8bh9cf9LH+7wIMlizFcOBCpHD1DZWuHE3xJt/NhP3NsCDIpkKRbc4Tx5lCH3MiUWSc
         otcQ==
X-Gm-Message-State: AOAM530OkDXchIGjGx68PEkSErC5o1QuDjO05HOGi+/w8v0aE32JOYuB
        EKJJj8YmpiHBBkGdPtOFDs7rMNnGU7AtUJTMsoQ=
X-Google-Smtp-Source: ABdhPJyWSlczqYbE78b5GkcKsZYn3HZnKVkgIBL8qR3Qf7K4jjapFsTo7rGPruXvEF37MvrvhMwRv3yEDEYWbbP0IlQ=
X-Received: by 2002:a05:6402:898:: with SMTP id e24mr428376edy.197.1627486114655;
 Wed, 28 Jul 2021 08:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210728063829.15099-1-lsahlber@redhat.com>
In-Reply-To: <20210728063829.15099-1-lsahlber@redhat.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 28 Jul 2021 20:58:23 +0530
Message-ID: <CANT5p=p2=5wcATX6rhLcCVGAAHiVOJhV4PKpPL9A1mZtDogfgA@mail.gmail.com>
Subject: Re: [PATCH] cifs: add missing parsing of backupuid
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 28, 2021 at 12:08 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> We lost parsing of backupuid in the switch to new mount API.
> Add it back.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/fs_context.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 9a59d7ff9a11..eed59bc1d913 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -925,6 +925,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>                 ctx->cred_uid = uid;
>                 ctx->cruid_specified = true;
>                 break;
> +       case Opt_backupuid:
> +               uid = make_kuid(current_user_ns(), result.uint_32);
> +               if (!uid_valid(uid))
> +                       goto cifs_parse_mount_err;
> +               ctx->backupuid = uid;
> +               ctx->backupuid_specified = true;
> +               break;
>         case Opt_backupgid:
>                 gid = make_kgid(current_user_ns(), result.uint_32);
>                 if (!gid_valid(gid))
> --
> 2.30.2
>

Looks good to me.
Might also be worthwhile to check if we missed any other mount option?

-- 
Regards,
Shyam
