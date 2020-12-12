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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7860DC433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 19:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CEF322257
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 19:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgLLTps (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 14:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgLLTps (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 14:45:48 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DEDC0613CF
        for <linux-cifs@vger.kernel.org>; Sat, 12 Dec 2020 11:45:08 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id 23so20145843lfg.10
        for <linux-cifs@vger.kernel.org>; Sat, 12 Dec 2020 11:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qFiG9oOhJr7Zsv/mCsb1O2ETPcZ2uWZSKFA5/AG1+04=;
        b=DOgLltbqZXpGnLlzV2tQp+IkCDntT0QJTiygnfJCuqzHCIXyGTtcRu2enBcddzLGRB
         cExbzULn8FyEkm5LjYDI/WMF8rB35kmKwXOFCk8Dse1eex3+m385WhQOc9HMnqpArOBf
         kmOZAiStQPklLvrYatglEu0OkozTAKCHEeO9snCeXMOZ1CixBib4rxOYYuPFb+tSvWLR
         2+iQ5Dg2Qb5i9dRgVara9fsBhV8/WcCS1XMSGU0rgnZlhzMeWT7RfU7Ie2J24xztPKOs
         TtZqVnH/1hBJ3Q5aAWIyoJVdqwveXGfD7b1363KYMyxBMEKn1mbJdz3ldlF1UaAdPbOX
         M2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qFiG9oOhJr7Zsv/mCsb1O2ETPcZ2uWZSKFA5/AG1+04=;
        b=aRO1oIpmWDN239vUHtLkg2DgDN8PcsiICGbbSVAmQBpN4MIstsdWKzkCRRGbf6m+w/
         9GwtDj5JtEKzmVytVuGexyrJEfwcyPxsam1F34uUCLPcpfctUL0xsHTUNN6fO+N+fYo8
         w3Is1IKD5YQAxGihbUlfxDUms1us+U5YAmavyD+CVawduJWu9ExCNui5PxuzTbO0AeF5
         mHWxVdFt5990naPM1LRdzla5saYOuBnmmn/2QAH3A0JtsCLjPRCfE/3hPoU2PylNe6L9
         n+R0LtdlaCjDbKcr2jTCR51KxAq9jjbrtU0LmiB0JXxgZfzYgie00b2xZRpWQJgP244K
         /0vg==
X-Gm-Message-State: AOAM5337GvvRXj/EYMToo0fflEjmfI9wkq8/xWvQBwrmVvE8dg2Ni4r2
        maHlTLD5xEunksYRTfgy1BnznRXDdvSbgmH5Fxo=
X-Google-Smtp-Source: ABdhPJzys62qaBT33OIb/CrKcFa9BY+H3KCPVuBZPmvriGGBs0rcXC184x2EZWupa7QlKZJwDKXtQfQP3y+09EB7dkc=
X-Received: by 2002:a2e:9250:: with SMTP id v16mr1452646ljg.256.1607802306704;
 Sat, 12 Dec 2020 11:45:06 -0800 (PST)
MIME-Version: 1.0
References: <20201207233646.29823-1-lsahlber@redhat.com> <20201207233646.29823-10-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-10-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 12 Dec 2020 13:44:55 -0600
Message-ID: <CAH2r5murj9gJgS218vafXTh6mu8O2B+m7L7ert2bzY2x2xJa3A@mail.gmail.com>
Subject: Re: [PATCH 10/21] cifs: remove actimeo from cifs_sb
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.gif for-next

On Mon, Dec 7, 2020 at 5:37 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifs_fs_sb.h | 1 -
>  fs/cifs/cifsfs.c     | 2 +-
>  fs/cifs/connect.c    | 3 +--
>  fs/cifs/inode.c      | 4 ++--
>  4 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index 3f4f1487f714..69d26313d350 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -65,7 +65,6 @@ struct cifs_sb_info {
>         unsigned int bsize;
>         unsigned int rsize;
>         unsigned int wsize;
> -       unsigned long actimeo; /* attribute cache timeout (jiffies) */
>         atomic_t active;
>         unsigned int mnt_cifs_flags;
>         struct delayed_work prune_tlinks;
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 4ea8c3c3bce1..e432de7c6ca1 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -629,7 +629,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>         if (tcon->handle_timeout)
>                 seq_printf(s, ",handletimeout=%u", tcon->handle_timeout);
>         /* convert actimeo and display it in seconds */
> -       seq_printf(s, ",actimeo=%lu", cifs_sb->actimeo / HZ);
> +       seq_printf(s, ",actimeo=%lu", cifs_sb->ctx->actimeo / HZ);
>
>         if (tcon->ses->chan_max > 1)
>                 seq_printf(s, ",multichannel,max_channels=%zu",
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 96c5b66d4b44..47e2fe8c19a2 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2236,7 +2236,7 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
>         if (strcmp(old->local_nls->charset, new->local_nls->charset))
>                 return 0;
>
> -       if (old->actimeo != new->actimeo)
> +       if (old->ctx->actimeo != new->ctx->actimeo)
>                 return 0;
>
>         return 1;
> @@ -2682,7 +2682,6 @@ int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
>         cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
>                  cifs_sb->ctx->file_mode, cifs_sb->ctx->dir_mode);
>
> -       cifs_sb->actimeo = ctx->actimeo;
>         cifs_sb->local_nls = ctx->local_nls;
>
>         if (ctx->nodfs)
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index e8a7110db2a6..fb07e0828958 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2165,11 +2165,11 @@ cifs_inode_needs_reval(struct inode *inode)
>         if (!lookupCacheEnabled)
>                 return true;
>
> -       if (!cifs_sb->actimeo)
> +       if (!cifs_sb->ctx->actimeo)
>                 return true;
>
>         if (!time_in_range(jiffies, cifs_i->time,
> -                               cifs_i->time + cifs_sb->actimeo))
> +                               cifs_i->time + cifs_sb->ctx->actimeo))
>                 return true;
>
>         /* hardlinked files w/ noserverino get "special" treatment */
> --
> 2.13.6
>


-- 
Thanks,

Steve
