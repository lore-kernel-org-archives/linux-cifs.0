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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DADC433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 18:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEC0664E6C
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 18:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhBYS1m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbhBYS1i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Feb 2021 13:27:38 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63242C06174A
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 10:26:58 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id a17so7632961ljq.2
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 10:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1obIaPlPklaAH32Wz2xnUWXhGK98m+gPaR5LFBsmWZc=;
        b=sOJc9+GewJ/vE9G95N0cHbs5R83FBYZTAibGGWqG/Vj+t072gs6mSYzjL/bXiLx+6s
         2weFKrEqESjO11UeQtIfE8BV1i4cKK7iYYflOWFpr89HwOsDvHr5ABAwGALtUyqVkqQi
         UebuNqKcMBJZ1e3hhaqBCnZciPf8zTAG60Hil4V6PfaN0AC7oIRlwIwZ3Q90XoOIrw6F
         0jGV+4iWaekb8Iifp8UTQ/Gp1CagYL1seIISJJS3b0AnssnbIP1bbcAnE43QqPEUh56X
         lxjElXc0Lw9q4tpoP2QvV/fbl29rfNpDQnDjjjZzRHRpQ7YUbyu/jEWrzWfSuUamWz8v
         4Xog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1obIaPlPklaAH32Wz2xnUWXhGK98m+gPaR5LFBsmWZc=;
        b=SsYDZ7X+mzJn0xdISP15ZsyWkuOeac/BOfnr4QGhNWy1KhumL/601BrfdguTeeD0A5
         ffHj6NErWIcYfcUJiH90XiitU18lWWNnfJfcrwAyCwW02OlxeThzCeky6Q3uGUYqoyqB
         Y7BoAF2SkxO/zN1agLOtDTMp9jvAm5gcL/jHJgE23rMtBRqkPZMLjEY0s5uVUpk50gjv
         ttClpwlilpGcXHCnVExa8dR0TD41v/nDzMxoy+He0TBcOXmQ/ySNch5V62RhzwXbTXWw
         71ZeE8bhPeT6n52iwi7TNttTGSuTBKPYZ1wekE26gfsKZ/BeketoEQnnNpbC1QKWp3+p
         GoZQ==
X-Gm-Message-State: AOAM533sVyzN+Af8Jh6fmy+pKa3ZVaOYJhGcoiAJp91Q2dcWoC1iA4jX
        wohZqGRxkxUR3at2C6tt8fPn9XlUZez6r5dvuIdw3pQdG/s=
X-Google-Smtp-Source: ABdhPJyipUa2iYHQFUkWdMCLqm2NlTUddwuhbd6nwC9LWhS+sMbQNroIxBMCZKZNDAgK2nasUBQcxaicPfBL8As2nNU=
X-Received: by 2002:a2e:9e48:: with SMTP id g8mr2342472ljk.477.1614277616872;
 Thu, 25 Feb 2021 10:26:56 -0800 (PST)
MIME-Version: 1.0
References: <20210225073627.32234-1-lsahlber@redhat.com>
In-Reply-To: <20210225073627.32234-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 Feb 2021 12:26:45 -0600
Message-ID: <CAH2r5mtJtxYUZOnJDzO9dPO-REPQqLLosPykgfArz-7AOaF9Gg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix handling of escaped ',' in the password mount argument
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added cc: stable # 5.11 and pushed into cifs-2.6 for-next

On Thu, Feb 25, 2021 at 1:36 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Passwords can contain ',' which are also used as the separator between
> mount options. Mount.cifs will escape all ',' characters as the string ",,".
> Update parsing of the mount options to detect ",," and treat it as a single
> 'c' character.
>
> Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/fs_context.c | 43 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 30 insertions(+), 13 deletions(-)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 14c955a30006..892f51a21278 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -544,20 +544,37 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
>
>         /* BB Need to add support for sep= here TBD */
>         while ((key = strsep(&options, ",")) != NULL) {
> -               if (*key) {
> -                       size_t v_len = 0;
> -                       char *value = strchr(key, '=');
> -
> -                       if (value) {
> -                               if (value == key)
> -                                       continue;
> -                               *value++ = 0;
> -                               v_len = strlen(value);
> -                       }
> -                       ret = vfs_parse_fs_string(fc, key, value, v_len);
> -                       if (ret < 0)
> -                               break;
> +               size_t len;
> +               char *value;
> +
> +               if (*key == 0)
> +                       break;
> +
> +               /* Check if following character is the deliminator If yes,
> +                * we have encountered a double deliminator reset the NULL
> +                * character to the deliminator
> +                */
> +               while (options && options[0] == ',') {
> +                       len = strlen(key);
> +                       strcpy(key + len, options);
> +                       options = strchr(options, ',');
> +                       if (options)
> +                               *options++ = 0;
>                 }
> +
> +
> +               len = 0;
> +               value = strchr(key, '=');
> +               if (value) {
> +                       if (value == key)
> +                               continue;
> +                       *value++ = 0;
> +                       len = strlen(value);
> +               }
> +
> +               ret = vfs_parse_fs_string(fc, key, value, len);
> +               if (ret < 0)
> +                       break;
>         }
>
>         return ret;
> --
> 2.13.6
>


-- 
Thanks,

Steve
