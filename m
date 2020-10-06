Return-Path: <SRS0=Y/WD=DN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333AFC41604
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 04:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA39F208B6
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 04:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOZfwvd6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgJFEdK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgJFEdK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Oct 2020 00:33:10 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D19C0613A7
        for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2020 21:33:10 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id m16so7262228ljo.6
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2020 21:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pd3Qom1RDLjZG9A9DmFv+9vKojGkajjENu7r6N85yf8=;
        b=KOZfwvd6txJNIpb7VlIz9fo6RmofqHf+qgri0LvNGypDHxpzxtzP/sz7e6fUpCOktB
         7mPp5P2ytAf4qOIDb3SU8zYYczolRfOHJH1mI0NTTTI2kZ2HahPORGbzydD2liZTINuV
         FyQw/RLiS6q1yJubJ5DdZeQurc4zMV421AgkqfXxCGHWclRv+DXGjwKYQzd2iG3Xygty
         j4Q1hHvZ/hNJhMnHLvna6vaGVGKkey21nWBGiVqmAGDcTV8sG0BKCjgM4QyybUulg2Rt
         1iKgziUbR1JyakKZpxiUcxLIwM/PN5CGW7WTfWaDxqdJWuQ4BLvwvGehWsz1KXG9gxMN
         J/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pd3Qom1RDLjZG9A9DmFv+9vKojGkajjENu7r6N85yf8=;
        b=sIhSD48vM5gSKqj61Sp26WjLJMdKPnbMI9BG54EGAeqeP1E9Fx/xUhd5E/AUTJNMi9
         nS+U4ulj/iJ5DMooEfkhlJorC1CfGzj1SnL5GMPM+A7ThnqyeCdoe+VnMzc00rppMPI6
         0YC3Udimqotpg3VviEkjFEnh23b6h1kfU3wxZv3AfQAQg0zuRwFKXAuxWdM5KSAf6w3X
         hY2edAJbyoU4WbEwrjr1LYjZyP84yiNfVAk3xUS0t6mRAINMX0s0zbcLytz3j3CaFgdn
         HNsHs/eszrcan5Ts2o4xTT81h4JCan7QrutpqJla5g5yvpNJ53p5n2T8LpxSn4SgGPpZ
         P3GQ==
X-Gm-Message-State: AOAM531ayHXj68TmKOnbBbMOoZRyDJNgl3I0uXgIb9XkdsNi6HA1UtyE
        G/rsiDP/nShedKQlEkvr2HqADtIuFhuGqJgBOyk=
X-Google-Smtp-Source: ABdhPJyAfHy91kVpri27IV2HY3YO+GJTQhH/jUfb3ha4Y9dBDneomC+0ZkuKqFZqqnF4Upw5Lm70gfMyI7c9AwDl3ww=
X-Received: by 2002:a2e:b009:: with SMTP id y9mr948086ljk.372.1601958788410;
 Mon, 05 Oct 2020 21:33:08 -0700 (PDT)
MIME-Version: 1.0
References: <20201006022623.21026-1-lsahlber@redhat.com>
In-Reply-To: <20201006022623.21026-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 5 Oct 2020 23:32:57 -0500
Message-ID: <CAH2r5mtGS0pX0nvzAk6hgrfocHzxUQLiidBi8WzU4a5FQ5v6CQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: handle -EINTR in cifs_setattr
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next

On Mon, Oct 5, 2020 at 9:26 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 1848178
>
> Some calls that set attributes, like utimensat(), are not supposed to return
> -EINTR and thus do not have handlers for this in glibc which causes us
> to leak -EINTR to the applications which are also unprepared to handle it.
>
> For example tar will break if utimensat() return -EINTR and abort unpacking
> the archive. Other applications may break too.
>
> To handle this we add checks, and retry, for -EINTR in cifs_setattr()
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/inode.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 3989d08396ac..74ed12f2c8aa 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2879,13 +2879,17 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
>  {
>         struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
>         struct cifs_tcon *pTcon = cifs_sb_master_tcon(cifs_sb);
> +       int rc;
>
> -       if (pTcon->unix_ext)
> -               return cifs_setattr_unix(direntry, attrs);
> -
> -       return cifs_setattr_nounix(direntry, attrs);
> +       do {
> +               if (pTcon->unix_ext)
> +                       rc = cifs_setattr_unix(direntry, attrs);
> +               else
> +                       rc = cifs_setattr_nounix(direntry, attrs);
> +       } while (rc == -EINTR);
>
>         /* BB: add cifs_setattr_legacy for really old servers */
> +       return rc;
>  }
>
>  #if 0
> --
> 2.13.6
>


-- 
Thanks,

Steve
