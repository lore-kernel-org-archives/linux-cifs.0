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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A59D5C48BE8
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 03:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81B1861351
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 03:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhFRD5V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Jun 2021 23:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhFRD5U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Jun 2021 23:57:20 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8B9C061574
        for <linux-cifs@vger.kernel.org>; Thu, 17 Jun 2021 20:55:12 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id a21so7107715ljj.1
        for <linux-cifs@vger.kernel.org>; Thu, 17 Jun 2021 20:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gD0ENR2WFkgQ8MRu5JeRKMW0kM+a+UL7D/5SRU2dL9o=;
        b=uNCbmkB29jIzgrhqk0VOBCGEG412UGXuAIMhfJNbSjYv2e6z8g+OFw4yZjAdjNqFf2
         wGqYfTfnljcXrjI9dfiKFBjJLZ+xs1t5X163kj2JwaKCM1llUi+2wljpBz0dEs0U4dg6
         jZFR53hhxTfZR0FT0WAvxyQ0ft/JrmtLQztG5H9DAemRUflXm4un37f9ZU10qn2BoG0U
         uxQG8E71HnDfNRwR19uZWiRkI+9m3kHqpkgUlBkGLI/abpJFV8LtZneZooRpbe0gnkVP
         J7qwBbXhb+16IF0rLSSw121UXZ76yyEE8vPBZ+Vw25D0TUkXQHem+u6QKpzV/JYl8XQ0
         DidQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gD0ENR2WFkgQ8MRu5JeRKMW0kM+a+UL7D/5SRU2dL9o=;
        b=jcZeBPF5pS92I4ujGk0vscc1fBQAmHxv/WjBDCxJ713clH3gAKRXZ6ZI2+uzXUkAFh
         0wMcZ86E4GhctDgwMj5iQls7gbaCKlm2rufGwSagJaT/8ZMaeDSILKjX9BMtgQhkLSJ7
         TyCptDQG/dirgHsO/l27jVkLoSH5FUJTWPFC+zXtdsRerm2tyjA9C3cxbqx9Y0E9i8GK
         Bm6S3aqS17p4XoMuwhLuQK5w9NwKTIP6qhm6QL2iMw2B5djoPhTxsz35tFVJsLIUUOlp
         2xP2ttm+hSleBONvQRt9nkcuJxut6POGpVvlGkW3RQa8JE6ZCifmdt9iXckroW+zih3B
         RMnw==
X-Gm-Message-State: AOAM531rcVta2v7imOdCb/sQhIqoiBYGn7YmEIm5r6n/5Ine6Tw73yFi
        gohnZkdQSpXbF4zL1AfhRP787AwTzokw7505gUenS7yyGufx1w==
X-Google-Smtp-Source: ABdhPJwfK5IbgVhCn/xIgGuj5cbvhNO+09farhjKoAKnUQ+kfFY5N+e5Qs17K6FoZD8oDCz3K6NJzTw13OMZsNjx2HA=
X-Received: by 2002:a2e:86d7:: with SMTP id n23mr7641370ljj.406.1623988510338;
 Thu, 17 Jun 2021 20:55:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210618005830.1819887-1-lsahlber@redhat.com>
In-Reply-To: <20210618005830.1819887-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 17 Jun 2021 22:54:59 -0500
Message-ID: <CAH2r5mss4WEBCF945jZFOGRCB6J+Jxd6LEYEx7f9eFjycXLcTA@mail.gmail.com>
Subject: Re: [PATCH] cifs: avoid extra calls in posix_info_parse
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Don't we have a secondary problem (have you been able to pull up a
more complete coverity explanation of the warning - I just see minimal
info on the line numbers of the two functions returning -1)?

e.g. if posix_info_sid_size returns -1, posix_info_parse returns -1
... but we don't check for the rc in one of the callers
cifs_posix_to_fattr

/* Fill a cifs_fattr struct with info from SMB_FIND_FILE_POSIX_INFO. */
static void
cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
                    struct cifs_sb_info *cifs_sb)
{
        struct smb2_posix_info_parsed parsed;

        posix_info_parse(info, NULL, &parsed);
... NEED TO CHECK RC HERE ...
        memset(fattr, 0, sizeof(*fattr));
...

On Thu, Jun 17, 2021 at 7:58 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> In posix_info_parse() we call posix_info_sid_size twice for each of the owner and the group
> sid. The first time to check that it is valid, i.e. >= 0 and the second time
> to just pass it in as a length to memcpy().
> As this is a pure function we know that it can not be negative the second time and this
> is technically a false warning in coverity.
> However, as it is a pure function we are just wasting cycles by calling it a second time.
> Record the length from the first time we call it and save some cycles as well as make
> Coverity happy.
>
> Addresses-Coverity-ID: 1491379 ("Argument can not be negative")
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2pdu.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index c205f93e0a10..4a244cc4e902 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -4498,7 +4498,7 @@ int posix_info_parse(const void *beg, const void *end,
>
>  {
>         int total_len = 0;
> -       int sid_len;
> +       int owner_len, group_len;
>         int name_len;
>         const void *owner_sid;
>         const void *group_sid;
> @@ -4521,17 +4521,17 @@ int posix_info_parse(const void *beg, const void *end,
>
>         /* check owner sid */
>         owner_sid = beg + total_len;
> -       sid_len = posix_info_sid_size(owner_sid, end);
> -       if (sid_len < 0)
> +       owner_len = posix_info_sid_size(owner_sid, end);
> +       if (owner_len < 0)
>                 return -1;
> -       total_len += sid_len;
> +       total_len += owner_len;
>
>         /* check group sid */
>         group_sid = beg + total_len;
> -       sid_len = posix_info_sid_size(group_sid, end);
> -       if (sid_len < 0)
> +       group_len = posix_info_sid_size(group_sid, end);
> +       if (group_len < 0)
>                 return -1;
> -       total_len += sid_len;
> +       total_len += group_len;
>
>         /* check name len */
>         if (beg + total_len + 4 > end)
> @@ -4552,10 +4552,8 @@ int posix_info_parse(const void *beg, const void *end,
>                 out->size = total_len;
>                 out->name_len = name_len;
>                 out->name = name;
> -               memcpy(&out->owner, owner_sid,
> -                      posix_info_sid_size(owner_sid, end));
> -               memcpy(&out->group, group_sid,
> -                      posix_info_sid_size(group_sid, end));
> +               memcpy(&out->owner, owner_sid, owner_len);
> +               memcpy(&out->group, group_sid, group_len);
>         }
>         return total_len;
>  }
> --
> 2.30.2
>


-- 
Thanks,

Steve
