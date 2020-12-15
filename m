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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21E1C4361B
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 22:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5139B22D6F
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 22:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgLOW55 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgLOW54 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Dec 2020 17:57:56 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08916C0613D3
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 14:57:16 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id o17so40677669lfg.4
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 14:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=syfGKGxmqSqCHQfAaS1FvS6G0ey5QyDMSzavtt1ycCk=;
        b=BdfemMDyJXqi1aYn3Buz4jeUCs06T7Str9h6VplNFnmoP6DdDIxacaASs6NouLtX3o
         OLBil2E1SbmOwTmDg0RjotiTwR0Jl2qb7AIgrz/a7feEUloKr/RpMnPJ2uLIq9EnAqvm
         xT7sreU3AU0f/2E2T7zrb0huihKXJWHI9Y4JegdWhYg5IarHKbGTn7YP0GWX9ICOfmTr
         7eiFwZGPCV6XEsROVTeA2GREqKPn1eUrtByhwJXBcpdkHctMxW4Ndj2OwGIOwpvUWOx0
         QRRIpM866OXeXSqM18DoDsi3kgva5Dxmge+IyVXBnK8bL5U/YUYfPYMoSXc0WK4mdxXD
         JXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=syfGKGxmqSqCHQfAaS1FvS6G0ey5QyDMSzavtt1ycCk=;
        b=pXv0yugW6Cl1AVTi0eRsGpcxntzniWIcbGmpwzaJZpbwRyuhrdWuKryM8aVH+toDrs
         3oVVRV+tiPg1oS8OcckFIXviGL8bF+T5KDc6zjV3iOBJa5vvCKcGwHoT/JpkIulmFDzc
         b8RI6N8Tk4lDEiNW87p8LW8U7yjlVUo0yEXzQsTlhcL5yigRSmJG6AgVZzzyhLlJ+sHe
         5QDzTvObsjP1LcsVSQKSRp9X0dSdH6alAbnfQeYlLuQO4nwQm4lw3o04P7jyhIHinKan
         ZVCAJ8PW8hhlLQ/M58TQFTZjD6G8ohA3Rd+A9n8wdUQhtnwYUYf3mO8l4AC+Ck2nukIU
         swlw==
X-Gm-Message-State: AOAM533Q5GEfRoWqqUSTVUtDxXBJL37UTdJsi34ePdyc7lhyriT8+H0E
        OOJfwyHpqLN70P0rgyiS2y1b9BaqJ3kEEiR/MB/ocYsjmMY=
X-Google-Smtp-Source: ABdhPJwp/SoNZYnAEoxf6iKtV6rcOSbh3pylNm0+CMmUuof+y4v7nEUZC5l4NAc1Tst3R84G3D4wMzRyoUeYDE9/mzs=
X-Received: by 2002:a2e:6a14:: with SMTP id f20mr179772ljc.6.1608073034453;
 Tue, 15 Dec 2020 14:57:14 -0800 (PST)
MIME-Version: 1.0
References: <20201215225133.20378-1-lsahlber@redhat.com>
In-Reply-To: <20201215225133.20378-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 15 Dec 2020 16:57:02 -0600
Message-ID: <CAH2r5mtq1p99QDmTRcfK8D6sfWB5jb2nObANTwrkegFepinEhw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix use after free in cifs_smb3_do_mount()
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next to address the issue Dan pointed out.

On Tue, Dec 15, 2020 at 4:51 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 4c385eeecc05..2c6e54fa6429 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -836,12 +836,14 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
>         if (IS_ERR(sb)) {
>                 root = ERR_CAST(sb);
>                 cifs_umount(cifs_sb);
> +               cifs_sb = NULL;
>                 goto out;
>         }
>
>         if (sb->s_root) {
>                 cifs_dbg(FYI, "Use existing superblock\n");
>                 cifs_umount(cifs_sb);
> +               cifs_sb = NULL;
>         } else {
>                 rc = cifs_read_super(sb);
>                 if (rc) {
> @@ -852,7 +854,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
>                 sb->s_flags |= SB_ACTIVE;
>         }
>
> -       root = cifs_get_root(cifs_sb->ctx, sb);
> +       root = cifs_get_root(cifs_sb ? cifs_sb->ctx : old_ctx, sb);
>         if (IS_ERR(root))
>                 goto out_super;
>
> --
> 2.13.6
>


-- 
Thanks,

Steve
