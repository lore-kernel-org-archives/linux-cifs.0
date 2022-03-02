Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF85C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Mar 2022 06:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbiCBG2B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Mar 2022 01:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiCBG2A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Mar 2022 01:28:00 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D567A7DA96
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 22:27:17 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id v22so840907ljh.7
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 22:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=UOoJpr7XG4ZPO+R+Mwx3qKmFLiJGX9WdTEjW2+8YjwA=;
        b=mc1L50hfJ8qtPshW9tJXAnvmAudWsc2m6OlCNqC6H24RbfbhBDc9lGSY6F5lu3ylBq
         /0LPQOuVTS6i324yvYpXBJ//DKDvEmkC9UDCEm69ChSJAQ9DKWnUftPU9NUXmNxeeTPr
         07AfpXne3wVWpyBHO3llL/ngox6noscKjewx0SX57fPJmFIoB0P69bD4Jq1krN+PHnED
         m7iQOfo7HfgT7ifyg+p45qNO1AXc567ExqPVxgYbprMBg0Mu/o43kyPYFyEKI2Gk3eAi
         vfRIVOMq/yFWri7OfbJ0us15y3+xeZqTQXNFNXAqivP66M3V1hWsSO49VrXWgGSmtzvJ
         daaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=UOoJpr7XG4ZPO+R+Mwx3qKmFLiJGX9WdTEjW2+8YjwA=;
        b=qNgfNDHDV3CavwvwHx2HWpqmMxV4g9kE1F+QN5ozw8dIjL58o4yRoGy66Szobbfz6H
         BRfIs5thiEmD6IGTur17XvYWgN5iZSgA+FaHgUPDubnnZ+4+2UYEUvhHJxVQPi2lLUnY
         mGSWgDY0CrjWjaZzr0UPO6Jd87BW/5RFV8OzGd/r2JDpTMWsbicAbdv8utRcGVKVQGkx
         yZQeLgTj5+3raX6627iFAMp4YqDwxN2vlf1T8HeGdEEExLf7fmbDHo4KFJ1Ou3BP9AWv
         r+Efgni2lhtE3HJB9m+PKJrVxr9b9wKE0VTfYl/TQ5K5z8psV7G6BYVIbixA64ZLIm+j
         LSnQ==
X-Gm-Message-State: AOAM530rduKcv4kDaEuiY5ofAZlnR/l7FYjxNmRf5j66Q4xItCZI8H+S
        0Yab41iUEAf98uHNmoSWUpl1lUDp1X35YvsgPIk=
X-Google-Smtp-Source: ABdhPJyMSP6tvl4igxZqe3Y66ebGvfl5Y6nUrPC5HfHUT9tEyL+Jdim1e4qxk+1Bmb77nzyYpPDJVQRlbSICnZjOYyU=
X-Received: by 2002:a2e:9c94:0:b0:233:82df:a3b8 with SMTP id
 x20-20020a2e9c94000000b0023382dfa3b8mr19675632lji.229.1646202435787; Tue, 01
 Mar 2022 22:27:15 -0800 (PST)
MIME-Version: 1.0
References: <20220210094454.826716-1-rbergant@redhat.com>
In-Reply-To: <20220210094454.826716-1-rbergant@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 2 Mar 2022 00:27:04 -0600
Message-ID: <CAH2r5mtpWxfhWP969nJQMRNQuUHR7RP63pvLyGxX7az5Kdh7KQ@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: parse sloppy mount option in correct order
To:     Roberto Bergantinos Corpas <rbergant@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

should we split the cifs part out and merge that distinctly or have
Dave merge it or ...

On Thu, Feb 10, 2022 at 8:27 AM Roberto Bergantinos Corpas
<rbergant@redhat.com> wrote:
>
> With addition of fs_context support, options string is parsed
> sequentially, if 'sloppy' option is not leftmost one, we may
> return ENOPARAM to userland if a non-valid option preceeds sloopy
> and mount will fail :
>
> host# mount -o quota,sloppy 172.23.1.225:/share /mnt
> mount.nfs: an incorrect mount option was specified
> host# mount -o sloppy,quota 172.23.1.225:/share /mnt
> host#
>
> This patch correct that behaviour so that sloppy takes precedence
> if specified anywhere on the string
>
> Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
> ---
>  fs/cifs/fs_context.c       |  4 ++--
>  fs/cifs/fs_context.h       |  1 -
>  fs/fs_context.c            | 14 ++++++++++++--
>  fs/nfs/fs_context.c        |  4 ++--
>  fs/nfs/internal.h          |  1 -
>  include/linux/fs_context.h |  2 ++
>  6 files changed, 18 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 7ec35f3f0a5f..5a8c074df74a 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -866,7 +866,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>         if (!skip_parsing) {
>                 opt = fs_parse(fc, smb3_fs_parameters, param, &result);
>                 if (opt < 0)
> -                       return ctx->sloppy ? 1 : opt;
> +                       return fc->sloppy ? 1 : opt;
>         }
>
>         switch (opt) {
> @@ -1412,7 +1412,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>                 ctx->multiuser = true;
>                 break;
>         case Opt_sloppy:
> -               ctx->sloppy = true;
> +               fc->sloppy = true;
>                 break;
>         case Opt_nosharesock:
>                 ctx->nosharesock = true;
> diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
> index e54090d9ef36..52a67a96fb67 100644
> --- a/fs/cifs/fs_context.h
> +++ b/fs/cifs/fs_context.h
> @@ -155,7 +155,6 @@ struct smb3_fs_context {
>         bool uid_specified;
>         bool cruid_specified;
>         bool gid_specified;
> -       bool sloppy;
>         bool got_ip;
>         bool got_version;
>         bool got_rsize;
> diff --git a/fs/fs_context.c b/fs/fs_context.c
> index 24ce12f0db32..2f9284e53589 100644
> --- a/fs/fs_context.c
> +++ b/fs/fs_context.c
> @@ -155,8 +155,15 @@ int vfs_parse_fs_param(struct fs_context *fc, struct fs_parameter *param)
>         if (ret != -ENOPARAM)
>                 return ret;
>
> -       return invalf(fc, "%s: Unknown parameter '%s'",
> -                     fc->fs_type->name, param->key);
> +       /* We got an invalid parameter, but sloppy may have been specified
> +        * later on param string.
> +        * Let's wait to process whole params to return EINVAL.
> +        */
> +
> +       fc->param_inval = true;
> +       errorf(fc, "%s: Unknown parameter '%s'", fc->fs_type->name, param->key);
> +
> +       return 0;
>  }
>  EXPORT_SYMBOL(vfs_parse_fs_param);
>
> @@ -227,6 +234,9 @@ int generic_parse_monolithic(struct fs_context *fc, void *data)
>                 }
>         }
>
> +       if (!fc->sloppy && fc->param_inval)
> +               ret = -EINVAL;
> +
>         return ret;
>  }
>  EXPORT_SYMBOL(generic_parse_monolithic);
> diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
> index ea17fa1f31ec..c9ff68e17b68 100644
> --- a/fs/nfs/fs_context.c
> +++ b/fs/nfs/fs_context.c
> @@ -482,7 +482,7 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
>
>         opt = fs_parse(fc, nfs_fs_parameters, param, &result);
>         if (opt < 0)
> -               return ctx->sloppy ? 1 : opt;
> +               return fc->sloppy ? 1 : opt;
>
>         if (fc->security)
>                 ctx->has_sec_mnt_opts = 1;
> @@ -837,7 +837,7 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
>                  * Special options
>                  */
>         case Opt_sloppy:
> -               ctx->sloppy = true;
> +               fc->sloppy = true;
>                 dfprintk(MOUNT, "NFS:   relaxing parsing rules\n");
>                 break;
>         }
> diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
> index 12f6acb483bb..9febdc95b4d0 100644
> --- a/fs/nfs/internal.h
> +++ b/fs/nfs/internal.h
> @@ -80,7 +80,6 @@ struct nfs_fs_context {
>         bool                    internal;
>         bool                    skip_reconfig_option_check;
>         bool                    need_mount;
> -       bool                    sloppy;
>         unsigned int            flags;          /* NFS{,4}_MOUNT_* flags */
>         unsigned int            rsize, wsize;
>         unsigned int            timeo, retrans;
> diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
> index 13fa6f3df8e4..06a4b72a0f98 100644
> --- a/include/linux/fs_context.h
> +++ b/include/linux/fs_context.h
> @@ -110,6 +110,8 @@ struct fs_context {
>         bool                    need_free:1;    /* Need to call ops->free() */
>         bool                    global:1;       /* Goes into &init_user_ns */
>         bool                    oldapi:1;       /* Coming from mount(2) */
> +       bool                    sloppy:1;       /* If fs support it and was specified */
> +       bool                    param_inval:1;  /* If set, check sloppy value */
>  };
>
>  struct fs_context_operations {
> --
> 2.31.1
>


-- 
Thanks,

Steve
