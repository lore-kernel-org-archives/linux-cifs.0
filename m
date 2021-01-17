Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E438C433DB
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Jan 2021 02:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 000CF2225E
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Jan 2021 02:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbhAQCJ2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Jan 2021 21:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbhAQCJ1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Jan 2021 21:09:27 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09624C061573;
        Sat, 16 Jan 2021 18:08:47 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id w26so14587504ljo.4;
        Sat, 16 Jan 2021 18:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=skWXKBO5JylLVb0KSTuDJa6QX2Cc1e4g3gSH2v4DxRg=;
        b=lGDUe8UHP0tJrQFAELz/00Bcig9hZeH+CjwnZm7QMQilWyHAL5S6z9E3MH8ywpW8/Q
         yTix1+LjyYNicCEin6/cXsvIKtGlR2N7w+5KRPSbgegwCqC4eSu4LGoYlc0fyyKIuwQd
         7nkkexJxhCMXIe4hSozC6mfAGhhBrb9GPBje7GCS92FJKdlaERi1G2DRRCPKZ/MFiGCd
         vbozIrNco1jxdIJ7CS/yHBm/jcffv1jrfUgP9521lahbDsQPkHFZWAYoGcFkSPZnQRAs
         WlhUmKhfrbxyTDyrK3ob2/xb83HbN8lunmj8q8TPFGXpRgvhi5tdZuP+D1bWcYDrcAal
         JU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=skWXKBO5JylLVb0KSTuDJa6QX2Cc1e4g3gSH2v4DxRg=;
        b=Ta1rcsRRbREhLOl7EXb4+u0EHXLCa7UOgP/2/YcP53CyV5LDCGQbkCMOwFGGyA5a7v
         BUsJJrpajmjUvXxX6+XxVwM0nOjzzO93Then4STKguCVLJN2vJLfZHbT8TGC8T4wE6l0
         DeLHmPnUCTLqTDfD7yitOpXSlygCrLD3X/l09Ow/XTxCG3zdez8tAVzRnX/+RKxtZKK1
         y/YPwqh/JgVy2ei8LOwej/wMKGpMMEde5f/R2ThQzSATs/9akT2IisVxRD9JApZNTl+R
         h6kxZwy6IKCIisxHNGw60xmyXZHMm1ufLHhoIHNJkLGhhinwcjuI1v91FFjSVYlR8aOR
         Ga7w==
X-Gm-Message-State: AOAM531867aLPuNdZRQpQLzDBFJZU9zaWpUlbp3XUN4D7DBg6fZINarj
        AyvV17hdsnEvN3H48Ed6Hzw5gwtGfWuQs23BBaWpOyzAWF4=
X-Google-Smtp-Source: ABdhPJzpUyLDd6N64NHll1kRS/L5CQKVrYgGVoDeJNNMJChZbmNzVmFgNOVeENBYpjjcSZSNkfAcPZ46neM3oye19Ao=
X-Received: by 2002:a2e:6a14:: with SMTP id f20mr8486556ljc.6.1610849325438;
 Sat, 16 Jan 2021 18:08:45 -0800 (PST)
MIME-Version: 1.0
References: <1610615360-70523-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1610615360-70523-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 16 Jan 2021 20:08:34 -0600
Message-ID: <CAH2r5mvTuu+dfTgE_zhBL5Sa1BiZ3UT=fdd79J99b36Dcjn2cg@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs: Assign boolean values to a bool variable
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Jan 14, 2021 at 3:11 AM Jiapeng Zhong
<abaci-bugfix@linux.alibaba.com> wrote:
>
> Fix the following coccicheck warnings:
>
> ./fs/cifs/connect.c:3386:2-21: WARNING: Assignment of 0/1 to
> bool variable.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> ---
>  fs/cifs/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b9df855..8fbb5ea 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2195,7 +2195,7 @@ static int match_tcon(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
>         if (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING)
>                 tcon->nohandlecache = ctx->nohandlecache;
>         else
> -               tcon->nohandlecache = 1;
> +               tcon->nohandlecache = true;
>         tcon->nodelete = ctx->nodelete;
>         tcon->local_lease = ctx->local_lease;
>         INIT_LIST_HEAD(&tcon->pending_opens);
> --
> 1.8.3.1
>


-- 
Thanks,

Steve
