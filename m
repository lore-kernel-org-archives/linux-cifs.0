Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C884C07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 22:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 496A661625
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 22:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhGHWOm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 18:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhGHWOl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 18:14:41 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C523C061574
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jul 2021 15:11:59 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t10so4660947eds.2
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jul 2021 15:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jjk6Al87CvQpEU1c5kPLVS3pbG6nM7JLhRHQCcBHrhM=;
        b=rLaF+FEiLSYI6BK8Ic0ypp/LVZQ9GA0G/TV2L9vFD4JuAKh/4RWdEIIFazxe9tNEd4
         3QIEj48S6r6yHKUSfGSbU/FNDfpC6wh1MTxh4+0iRcSWc7C4kz9N2hZsiG97S4k2lcy/
         CN8tH0hxDUm7CiJORILXrncPhDWUX4w6fpoqT3o/JsF9Uo2X2CTf42E8lkyXSlm7zG7g
         eGnfP3dXwcrBi/dBOKAglwbmqgo63TVrOHaoQQjp94Srm4GTE5MjSLH9BQ2o14F7kcPu
         8Bilh0vID/Ii7ny+8cWugsP3VnXAr013s13f5so1bTyOpgm2rDZfHWTJgQuQv0FCMLmr
         kxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jjk6Al87CvQpEU1c5kPLVS3pbG6nM7JLhRHQCcBHrhM=;
        b=JgZ3ho8a/PEOdjX7zxd8tCcBKfXpssyXJbFyYUC7StqrEwzmB/4XC15HoO8/JWqdwx
         UvmvL6gKJyJXWwbiPiUN4QO1ZlCsWOG1Ibr5F8+mnXqyJ0QNHJHzBdIR0A+TVoakwaI6
         ziaRaf4nWkTp+KlumS4RkoZfmZFQqAEeSoOZbLKOkSkmo9cHbfoDbCigUt5v8r21r77S
         MHFL5KRTZeUmnGKpXTKzOh4DfrpH+F3RNvP5toLAsAy+MozbmI9CmJVu5u/9JaFm0Y9E
         zjoy3PCgkqECWX00vsrfRWBBuS9U0qLJkirWc/Kd//vfuHkL7NyWTis+3W1lxqGiP27S
         qYLw==
X-Gm-Message-State: AOAM533TxgiyZzObowysy12I/cxLiRDRwv14I+MBiV7l5kc4qciUEWTd
        o/qH6ByI0hMSGUtvWEaqbvJ72jjFmPrHKqL+zA==
X-Google-Smtp-Source: ABdhPJynFt3FC0A0zaDM40zv55hCLIc9Mih82U4pve9ws8OEVBzRnMktsCkuOv9hZa/tavDWejlUTHUpv0coCbI+uCI=
X-Received: by 2002:a50:875d:: with SMTP id 29mr18414920edv.340.1625782317673;
 Thu, 08 Jul 2021 15:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210707232416.2694911-1-lsahlber@redhat.com> <20210707232416.2694911-2-lsahlber@redhat.com>
In-Reply-To: <20210707232416.2694911-2-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 8 Jul 2021 15:11:46 -0700
Message-ID: <CAKywueSiuJU4YipMtsyf+CYDywSX3ySgMrmsvt9swJT4GkjTZg@mail.gmail.com>
Subject: Re: [PATCH] cifs: use helpers when parsing uid/gid mount options and
 validate them
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 7 =D0=B8=D1=8E=D0=BB. 2021 =D0=B3. =D0=B2 16:25, Ronnie Sahlb=
erg <lsahlber@redhat.com>:
>
> Use the nice helpers to initialize and the uid/gid/cred_uid when passed a=
s mount arguments.
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
> @@ -322,7 +322,6 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, =
struct smb3_fs_context *ctx
>         new_ctx->UNC =3D NULL;
>         new_ctx->source =3D NULL;
>         new_ctx->iocharset =3D NULL;
> -
>         /*
>          * Make sure to stay in sync with smb3_cleanup_fs_context_content=
s()
>          */
> @@ -792,6 +791,8 @@ static int smb3_fs_context_parse_param(struct fs_cont=
ext *fc,
>         int i, opt;
>         bool is_smb3 =3D !strcmp(fc->fs_type->name, "smb3");
>         bool skip_parsing =3D false;
> +       kuid_t uid;
> +       kgid_t gid;
>
>         cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->ke=
y);
>
> @@ -904,18 +905,31 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
>                 }
>                 break;
>         case Opt_uid:
> -               ctx->linux_uid.val =3D result.uint_32;
> +               uid =3D make_kuid(current_user_ns(), result.uint_32);
> +               if (!uid_valid(uid))
> +                       goto cifs_parse_mount_err;
> +               ctx->linux_uid =3D uid;
>                 ctx->uid_specified =3D true;
>                 break;
>         case Opt_cruid:
> -               ctx->cred_uid.val =3D result.uint_32;
> +               uid =3D make_kuid(current_user_ns(), result.uint_32);
> +               if (!uid_valid(uid))
> +                       goto cifs_parse_mount_err;
> +               ctx->cred_uid =3D uid;
> +               ctx->cruid_specified =3D true;
>                 break;
>         case Opt_backupgid:
> -               ctx->backupgid.val =3D result.uint_32;
> +               gid =3D make_kgid(current_user_ns(), result.uint_32);
> +               if (!gid_valid(gid))
> +                       goto cifs_parse_mount_err;
> +               ctx->backupgid =3D gid;
>                 ctx->backupgid_specified =3D true;
>                 break;
>         case Opt_gid:
> -               ctx->linux_gid.val =3D result.uint_32;
> +               gid =3D make_kgid(current_user_ns(), result.uint_32);
> +               if (!gid_valid(gid))
> +                       goto cifs_parse_mount_err;
> +               ctx->linux_gid =3D gid;
>                 ctx->gid_specified =3D true;
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

Is it going to be used somewhere?

>         bool gid_specified;
>         bool sloppy;
>         bool got_ip;
> --
> 2.30.2
>

Acked-by: Pavel Shilovsky <pshilovsky@samba.org>

--
Best regards,
Pavel Shilovsky
