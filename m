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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7888C43461
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Apr 2021 20:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDB6A61462
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Apr 2021 20:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbhDXUJW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 24 Apr 2021 16:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbhDXUJV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 24 Apr 2021 16:09:21 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFECC061574
        for <linux-cifs@vger.kernel.org>; Sat, 24 Apr 2021 13:08:41 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id g8so82455666lfv.12
        for <linux-cifs@vger.kernel.org>; Sat, 24 Apr 2021 13:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OHBwGQlr3fU6GOTvKQKCEZr13Bmzj0fK3MeMz8MM8ks=;
        b=IKaTfySdGN3J+9X/h77KkyvaBwz/P51hp03IqXDqHTadNDXafxJgSy7jjqpZn1xZ/Y
         fTyy2AWEc/0la2MW7+GD2PvxVX0nqsjdWdOcZozMWcvL8lZA56c+QSIs66EQxa1Xb6jD
         /23RrG8/rlOQyUVkOEFMkipYB/gxiZrfpFPyG806FGbtZjfWSZAph8QzsCasxKom/oeG
         JfbDEgdebr8gWS5labWyjdNUx269+fC61ZGixDLgKeXfWIefJlJ0RVP0+1d71YNVF0GU
         gDqwqH8O0PcgDOH3wDcOzcDW1JFz3Egue00Q31sI4S8T8OydOT+rnaEN8hNgyEnJYoan
         +ijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OHBwGQlr3fU6GOTvKQKCEZr13Bmzj0fK3MeMz8MM8ks=;
        b=Xd4GIeoXJl3zhWmnHYTcn8WlK+q/Ovsh5y+4J3e4pDaLrgZPQim89svBucE4F8hCrL
         gXQVBEh33Payht+WYsxFkqctn8zxY6dJuVCFdWvsGk/AORY/bTIILUIBmEWlGGBmnkK4
         bFBkLzGyqgktTiayFT7D/nXDYjFLG7PEY14FYa+D/84gs3aLVLjQZoi0rMxuLzqJeYYL
         spTmWvAGCFiF6AocE6POiJ6jSxSCMCmVhYKoOP9COfTjRZZKU1yRs9mgcQay7EyOc//2
         RiyE0AdJAeT4A2ZyANKYDnVxsr8kvu8IwYfpKbmDghrJr/Rqt8gHuE8wR92nAzsvAdZp
         74sg==
X-Gm-Message-State: AOAM531T1ez4DMXn8Csbcg6pFjtGb/EnXOcS99gs/aSkglcwPOg92Cc9
        bahTsjBaClqEOVnFWTItWRvYDjXrubS0iqulnWTOXa72
X-Google-Smtp-Source: ABdhPJxiSFAR3+ZYBnXwSXRIFHGLNKopOJjLPz83zEW3lREcxB5Y15SWxEiR6LjAibq+++KZz9FTwkmPYtW59S9BlEE=
X-Received: by 2002:ac2:5cab:: with SMTP id e11mr7040220lfq.175.1619294919621;
 Sat, 24 Apr 2021 13:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 24 Apr 2021 15:08:28 -0500
Message-ID: <CAH2r5mtJACVdvKsFbZ9RAgF7hJ1xTj=wXACct3PcxOJA-rdT7A@mail.gmail.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
  of readahead
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I need to rerun the perf numbers - I may have gotten some of them incorrectly.

On Sat, Apr 24, 2021 at 2:27 PM Steve French <smfrench@gmail.com> wrote:
>
> In some cases readahead of more than the read size can help
> (to allow parallel i/o of read ahead which can improve performance).
>
> Using the buildbot test systems, this resulted in an average improvement
> of 14% to the Windows server test target for the first 12 tests I
> tried (no multichannel)
> changing to 12MB rasize (read ahead size).   Similarly increasing the
> rasize to 12MB to Azure (this time with multichannel, 4 channels)
> improved performance 37%
>
> Note that Ceph had already introduced a mount parameter "rasize" to
> allow controlling this.  Add mount parameter "rasize" to cifs.ko to
> allow control of read ahead (rasize defaults to 4MB which is typically
> what it used to default to to the many servers whose rsize was that).
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/cifsfs.c     |  1 +
>  fs/cifs/fs_context.c | 25 ++++++++++++++++++++++++-
>  fs/cifs/fs_context.h |  2 ++
>  3 files changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 39f4889a036b..a1217682da1f 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -649,6 +649,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>   seq_printf(s, ",rsize=%u", cifs_sb->ctx->rsize);
>   seq_printf(s, ",wsize=%u", cifs_sb->ctx->wsize);
>   seq_printf(s, ",bsize=%u", cifs_sb->ctx->bsize);
> + seq_printf(s, ",rasize=%u", cifs_sb->ctx->rasize);
>   if (tcon->ses->server->min_offload)
>   seq_printf(s, ",esize=%u", tcon->ses->server->min_offload);
>   seq_printf(s, ",echo_interval=%lu",
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 74758e954035..5ce1f7b854e7 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -137,6 +137,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
>   fsparam_u32("min_enc_offload", Opt_min_enc_offload),
>   fsparam_u32("esize", Opt_min_enc_offload),
>   fsparam_u32("bsize", Opt_blocksize),
> + fsparam_u32("rasize", Opt_rasize),
>   fsparam_u32("rsize", Opt_rsize),
>   fsparam_u32("wsize", Opt_wsize),
>   fsparam_u32("actimeo", Opt_actimeo),
> @@ -941,6 +942,26 @@ static int smb3_fs_context_parse_param(struct
> fs_context *fc,
>   ctx->bsize = result.uint_32;
>   ctx->got_bsize = true;
>   break;
> + case Opt_rasize:
> + /*
> + * readahead size realistically should never need to be
> + * less than 1M (CIFS_DEFAULT_IOSIZE) or greater than 32M
> + * (perhaps an exception should be considered in the
> + * for the case of a large number of channels
> + * when multichannel is negotiated) since that would lead
> + * to plenty of parallel I/O in flight to the server.
> + * Note that smaller read ahead sizes would
> + * hurt performance of common tools like cp and scp
> + * which often trigger sequential i/o with read ahead
> + */
> + if ((result.uint_32 > (8 * SMB3_DEFAULT_IOSIZE)) ||
> +     (result.uint_32 < CIFS_DEFAULT_IOSIZE)) {
> + cifs_errorf(fc, "%s: Invalid rasize %d vs. %d\n",
> + __func__, result.uint_32, SMB3_DEFAULT_IOSIZE);
> + goto cifs_parse_mount_err;
> + }
> + ctx->rasize = result.uint_32;
> + break;
>   case Opt_rsize:
>   ctx->rsize = result.uint_32;
>   ctx->got_rsize = true;
> @@ -1377,7 +1398,9 @@ int smb3_init_fs_context(struct fs_context *fc)
>   ctx->cred_uid = current_uid();
>   ctx->linux_uid = current_uid();
>   ctx->linux_gid = current_gid();
> - ctx->bsize = 1024 * 1024; /* can improve cp performance significantly */
> + /* By default 4MB read ahead size, 1MB block size */
> + ctx->bsize = CIFS_DEFAULT_IOSIZE; /* can improve cp performance
> significantly */
> + ctx->rasize = SMB3_DEFAULT_IOSIZE; /* can improve sequential read ahead */
>
>   /*
>   * default to SFM style remapping of seven reserved characters
> diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
> index 56d7a75e2390..2a71c8e411ac 100644
> --- a/fs/cifs/fs_context.h
> +++ b/fs/cifs/fs_context.h
> @@ -120,6 +120,7 @@ enum cifs_param {
>   Opt_dirmode,
>   Opt_min_enc_offload,
>   Opt_blocksize,
> + Opt_rasize,
>   Opt_rsize,
>   Opt_wsize,
>   Opt_actimeo,
> @@ -235,6 +236,7 @@ struct smb3_fs_context {
>   /* reuse existing guid for multichannel */
>   u8 client_guid[SMB2_CLIENT_GUID_SIZE];
>   unsigned int bsize;
> + unsigned int rasize;
>   unsigned int rsize;
>   unsigned int wsize;
>   unsigned int min_offload;
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
