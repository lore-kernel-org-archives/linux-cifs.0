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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652D4C48BC2
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 00:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E28361358
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 00:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFXAhQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 20:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFXAhQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Jun 2021 20:37:16 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0541C061574
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 17:34:56 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id k10so7093830lfv.13
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 17:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=35wMFdyzkOa4TjHnAOKXONNeCe969DVgaStb0sU0ovc=;
        b=gIqYVG6UPANPiWnCidoVZI/0p2o889NotYFWW/UgoDfnbp7Z/INIYyTz/wanUMh52A
         YrbrO+s5kVWkiR1gGYvqfQSNGPbTTCt8dlegn1jjkKlEyvmt1BmbGFpZQDaWQPF7rD27
         CI72qj9/FFa449cn7u2kvhHC+WbD5RNIS1gQeoA0uO166aR27cFXBniUH57y/uXSvy4k
         iiQmhztSoFD9DxP1JBwZ+Y82DPc9PtnVwAgtCVv5QJVFQCVpr+Hx+kesA0N/8l8AH+rh
         cE3LA3x3LAa7ngKISNJys3cXTrnVDdT/iok3h9yHlkM7IKDSwJdvQhA0igHZcWnhHMqK
         3SYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=35wMFdyzkOa4TjHnAOKXONNeCe969DVgaStb0sU0ovc=;
        b=Y5HOD3+e+JB1+RZ253LgiPthOYoMpJpt+1U+AQmMRjhOqxA+VmUmPf+naRqAx/yqsX
         2BJoS/G2y2QTdRcWgcp9ztIIk6FELTczCuFHZoeQMT6JPkyobxpbfJ/ymogmB+ylwDJy
         WgXUoGQGlh44XxlYULCpHdiMM/62/224n8NV8YheFPKk4x2o1sESkJBc3EPbPHckJsHi
         jRgztVDNgIIZrE4Ee5UwKbIsmoIekXTcqbaghsHOBR7eGX7GSssr5SQhlUJNwimxlrig
         APGo5l1WBBAYQeeh9uYnBSH54J+gJeUQhdUHw/X6AxCthqvpr5PzrT9vyWNoXXotbta3
         STdQ==
X-Gm-Message-State: AOAM530GpG/bVnzkv3g9jdrXq4v4opV4XGIp3pqErTxKWZ443BgQl9mU
        u90gzS3DLDHkA1SGmYW0EmZYMfejI6WdfkprXCw=
X-Google-Smtp-Source: ABdhPJz/yrP6yWg8DuORYC0K+xcUAAGyRoXn30BpmLmEiZH9Qes/atwoCWwvpU98M1lcWXWZrYecm8bcPkwXbZEJBt4=
X-Received: by 2002:ac2:546b:: with SMTP id e11mr1717353lfn.282.1624494895163;
 Wed, 23 Jun 2021 17:34:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210623220011.2074922-1-lsahlber@redhat.com>
In-Reply-To: <20210623220011.2074922-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 23 Jun 2021 19:34:44 -0500
Message-ID: <CAH2r5mseiMBQJ_31aAw_KotZJgVxTHsuoM79OvY6_sqE3ahvQw@mail.gmail.com>
Subject: Re: [PATCH] cifs: set the cred_uid/linux_uid/linux_gid when
 duplicating contexts
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing

On Wed, Jun 23, 2021 at 5:00 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Use the nice helpers to initialize and the uid/gid/cred_uid when passed as mount
> arguments.
> Also, when we duplicate a context, for example in multiuser,cruid=xxx we need to
> re-set these uid/gids to the current user or else we may get a crash.
>
> Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> Cc: stable@vger.kernel.org # 5.11
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/fs_context.c | 27 ++++++++++++++++++++++-----
>  fs/cifs/fs_context.h |  1 +
>  2 files changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 92d4ab029c91..39bebe298387 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -322,7 +322,9 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
>         new_ctx->UNC = NULL;
>         new_ctx->source = NULL;
>         new_ctx->iocharset = NULL;
> -
> +       new_ctx->linux_uid = current_fsuid();
> +       new_ctx->cred_uid = current_fsuid();
> +       new_ctx->linux_gid = current_fsgid();
>         /*
>          * Make sure to stay in sync with smb3_cleanup_fs_context_contents()
>          */
> @@ -792,6 +794,8 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>         int i, opt;
>         bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
>         bool skip_parsing = false;
> +       kuid_t uid;
> +       kgid_t gid;
>
>         cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
>
> @@ -904,18 +908,31 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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
