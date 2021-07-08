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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CFEC07E95
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 00:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF5CA61452
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 00:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhGHBAR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhGHBAQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 21:00:16 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F37C061574
        for <linux-cifs@vger.kernel.org>; Wed,  7 Jul 2021 17:57:35 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id r26so9580947lfp.2
        for <linux-cifs@vger.kernel.org>; Wed, 07 Jul 2021 17:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vp7vWnNKG5gRe2+eHcONDppm5kFSPMwR8GgiK4ts9xE=;
        b=aSyruXpwjcu2cTo2zJVB6KFYiXtOZDn4lYnYrTYBKrf4dcsydCUaJg62Am8z47ehWK
         RVTJlR1EuUOHcJ+gUa9GoDzsGmmwkz2SNHK/NazjGzFEOezMcQjQvaZiXl7k3t/SzbDc
         PXLbycVFpBQzB7Rkb2nT4qQi1SYMbso2s3R0UqmCp2WEZUN3e0Gpu7f70eLBWdY2PMxC
         zpCqAZRMnRJfFu2ex7TZDfyi+dpd7FlUPqMtGtaT/EV0liUdIyZ2x02shKe+37GDZaBE
         xNj1JItOT8fBR8Acqps9aeGcslDJ6VIgzZStYJ63WIR32Xtj+rWuDmls5oLrFeofX5yE
         9UEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vp7vWnNKG5gRe2+eHcONDppm5kFSPMwR8GgiK4ts9xE=;
        b=T0s6EBIETq0Wb+T7Q/wmKM81KrM4lmfZ7u5C2inmMLSSCaEjggfrZJGlGvmFrJ0uIi
         U6rIpvArncI6juXO1hksMPzF3qiHuK88ZoA1ey9YqFcq1z/BXwLzAnzfWDhky0+exH9I
         /09+9z0ZKe6HqOMMSdMVtYY8fdqlEBf/Wzet7myuOUVA91KLj94U/+U19BjNid0wcd/P
         nvNLL/tNR6cFSHJP2i8vh/555iRZUJi4ZcJtD1y7ml0U51ixjQFw9TKIYdjGz9EdyA6M
         t+PxKaR1Vr66Qmn7x5hArPDyn8Kn/qzDoeiV0498Fqg9jGv/JY2nY6gLYf96dNmFEuy3
         Us7Q==
X-Gm-Message-State: AOAM530pvtPEDAdtpwSqAsO1ZFlXHvt+OxgTQXcRI5xBneZfvKxxT8WI
        eLODWTWBeake3EWLtZB9uMEK9PwcYE1afc6sEMo=
X-Google-Smtp-Source: ABdhPJzBbV38L/rO71XcRmACNXaJRCVtONGt6w71a5J1RC3Pl438Zz5LYeLG80il+GvlYCuVmGqn26jxOiOvPmJOBLY=
X-Received: by 2002:a05:6512:2316:: with SMTP id o22mr7568lfu.175.1625705854010;
 Wed, 07 Jul 2021 17:57:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210707232416.2694911-1-lsahlber@redhat.com> <20210707232416.2694911-2-lsahlber@redhat.com>
In-Reply-To: <20210707232416.2694911-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 7 Jul 2021 19:57:20 -0500
Message-ID: <CAH2r5ms0uH=3O=HjUB=DfApqD8d+Q4j4SqjpQxjk6C0PiJgpXA@mail.gmail.com>
Subject: Re: [PATCH] cifs: use helpers when parsing uid/gid mount options and
 validate them
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git pending testing

On Wed, Jul 7, 2021 at 6:24 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Use the nice helpers to initialize and the uid/gid/cred_uid when passed as mount arguments.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/fs_context.c | 24 +++++++++++++++++++-----
>  fs/cifs/fs_context.h |  1 +
>  2 files changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 92d4ab029c91..553adfbcc22a 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -322,7 +322,6 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
>         new_ctx->UNC = NULL;
>         new_ctx->source = NULL;
>         new_ctx->iocharset = NULL;
> -
>         /*
>          * Make sure to stay in sync with smb3_cleanup_fs_context_contents()
>          */
> @@ -792,6 +791,8 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>         int i, opt;
>         bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
>         bool skip_parsing = false;
> +       kuid_t uid;
> +       kgid_t gid;
>
>         cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
>
> @@ -904,18 +905,31 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>                 }
>                 break;
>         case Opt_uid:
> -               ctx->linux_uid.val = result.uint_32;
> +               uid = make_kuid(current_user_ns(), result.uint_32);
> +               if (!uid_valid(uid))
> +                       goto cifs_parse_mount_err;
> +               ctx->linux_uid = uid;
>                 ctx->uid_specified = true;
>                 break;
>         case Opt_cruid:
> -               ctx->cred_uid.val = result.uint_32;
> +               uid = make_kuid(current_user_ns(), result.uint_32);
> +               if (!uid_valid(uid))
> +                       goto cifs_parse_mount_err;
> +               ctx->cred_uid = uid;
> +               ctx->cruid_specified = true;
>                 break;
>         case Opt_backupgid:
> -               ctx->backupgid.val = result.uint_32;
> +               gid = make_kgid(current_user_ns(), result.uint_32);
> +               if (!gid_valid(gid))
> +                       goto cifs_parse_mount_err;
> +               ctx->backupgid = gid;
>                 ctx->backupgid_specified = true;
>                 break;
>         case Opt_gid:
> -               ctx->linux_gid.val = result.uint_32;
> +               gid = make_kgid(current_user_ns(), result.uint_32);
> +               if (!gid_valid(gid))
> +                       goto cifs_parse_mount_err;
> +               ctx->linux_gid = gid;
>                 ctx->gid_specified = true;
>                 break;
>         case Opt_port:
> diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
> index 2a71c8e411ac..b6243972edf3 100644
> --- a/fs/cifs/fs_context.h
> +++ b/fs/cifs/fs_context.h
> @@ -155,6 +155,7 @@ enum cifs_param {
>
>  struct smb3_fs_context {
>         bool uid_specified;
> +       bool cruid_specified;
>         bool gid_specified;
>         bool sloppy;
>         bool got_ip;
> --
> 2.30.2
>


-- 
Thanks,

Steve
