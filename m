Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC86C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Oct 2022 15:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiJHPWD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 Oct 2022 11:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJHPWC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 Oct 2022 11:22:02 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8941233421
        for <linux-cifs@vger.kernel.org>; Sat,  8 Oct 2022 08:22:01 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id k14so3494695vkk.0
        for <linux-cifs@vger.kernel.org>; Sat, 08 Oct 2022 08:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8IZbx6ROuGfZ6tm7lt7fkD+i5Vi/7auLHsf0csZYXCE=;
        b=OSQuBxd9b5fUWcwOEQTGvFjvEo9fNNx/xks2Vd797ph3b2bipfjCx8piE2/nQ8VOWt
         mmiuZy1+FhnHClMznZrBpomQWH/UfZaI5l88CLa31jE8N96bRFii1QEkwqqrjP1A8xwR
         1JsJ+/F35MLokAUP16tstGg19F+zgZreF5m3K/wh3B8Ve1gc4xqKwwfOhi9C4hHpOfXj
         fgfn44XwFf7twZ3UyRpR8N3kWJuhNx9nMTIRTOTZXib6r+tUHiEvqngw6vyPyFbrKSk3
         3t3LUC7rTYuvxWnOfjJfmzfGnDFzI0RQYHo9DjKqBtSFBvwGwRG2MED+Eny2njchBRFT
         KgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8IZbx6ROuGfZ6tm7lt7fkD+i5Vi/7auLHsf0csZYXCE=;
        b=AWdWOklqIggnIr77/72cdf1CPgvifvx0v87QT9zdkQPmERy5aW46hNHd0MqbHc5nds
         r8bMbTGdwChuSWiXPJMccSnIiUbmiYI0Q3MD/F/n6cwPZasQ7S/H0AGZQ2CSZ5qJ+YwR
         cQsn2UNTjQSrAtzQWY2G4JJI8jpX81pNBfpKiXIeMm188fBydEFloQ0IGFR5zkRAnnjF
         hM0snNLnE3HmEkl8cyc02Ov+glMqKFDHgmpQZE8htX2DSR3fxDHOcgNgs4xjYXtr3XpG
         bTjbz6U29XLBIdBrbMKRUcpetuwVjXdmx38ncZvkSb98GGtrohiF4GIcjYqlDUvPvjPC
         LSEw==
X-Gm-Message-State: ACrzQf0ZnioqhLLn84oNzf65nRjJM8feK5xC6Xt4BVOVKw92dnpgbGyr
        dA2ZM40DdcsjaiVW5g1c7nt0H2/5mnZ0/g5of4Y=
X-Google-Smtp-Source: AMsMyM4iWAv+sgByHeaUIAw3CGV+9biz3KccMVoaQgMhFQJ/cVXztRZIkIgyaZ9kPgYYRCLZg491Jg+1JGrgo+J6Xf0=
X-Received: by 2002:a1f:a788:0:b0:3a1:e690:a2a3 with SMTP id
 q130-20020a1fa788000000b003a1e690a2a3mr5359443vke.4.1665242520527; Sat, 08
 Oct 2022 08:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221006043609.1193398-1-lsahlber@redhat.com> <20221006043609.1193398-2-lsahlber@redhat.com>
In-Reply-To: <20221006043609.1193398-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 8 Oct 2022 10:21:49 -0500
Message-ID: <CAH2r5mu6M-AAeyXe9P7rZakjBKcAkYuUWqUhffK6hmvoL_Pf5g@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix skipping to incorrect offset in emit_cached_dirents
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Adding this one patch onto for-next, it went from passing all (except
452 which is known issue with refcount and umount/mount) of buildbot
cifs-testing group to hanging on generic/010 and generic/024 to
Windows (interestingly 024 did not hang when run to Samba)

On Wed, Oct 5, 2022 at 11:36 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> When application has done lseek() to a different offset on a directory fd
> we skipped one entry too many before we start emitting directory entries
> from the cache.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/readdir.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 8e060c00c969..da0d1e188432 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -847,9 +847,13 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
>         int rc;
>
>         list_for_each_entry(dirent, &cde->entries, entry) {
> -               if (ctx->pos >= dirent->pos)
> +               /*
> +                * Skip ahead until we get to the current position of the
> +                * directory.
> +                */
> +               if (ctx->pos > dirent->pos)
>                         continue;
> -               ctx->pos = dirent->pos;
> +
>                 rc = dir_emit(ctx, dirent->name, dirent->namelen,
>                               dirent->fattr.cf_uniqueid,
>                               dirent->fattr.cf_dtype);
> --
> 2.35.3
>


-- 
Thanks,

Steve
