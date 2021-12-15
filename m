Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF1DC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Dec 2021 06:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240286AbhLOG7d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 01:59:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240284AbhLOG7c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 15 Dec 2021 01:59:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639551572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UcpwwD43R1or7NeD2dP64m1yxGz/641w1QnQXTdSpf0=;
        b=C3zw0mW7j78eR8qEWZanQIlybMj9S8jYdAeHh+d7jw2O4pXkc7z2Hi5+9m8gNTwFQ2ZIcp
        Mmz/cxmIA5CIqFxovqUULdcnfiajslONcxK/OOx3h15XMVU+4kBKorxszQLJjfffAR+86B
        SBNplBrcg6JW48IInItnynvbze125Ws=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-z_G8pZGcMLW4pDYkqVpd7g-1; Wed, 15 Dec 2021 01:59:30 -0500
X-MC-Unique: z_G8pZGcMLW4pDYkqVpd7g-1
Received: by mail-ed1-f69.google.com with SMTP id y17-20020a056402271100b003f7ef5ca612so8129edd.17
        for <linux-cifs@vger.kernel.org>; Tue, 14 Dec 2021 22:59:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UcpwwD43R1or7NeD2dP64m1yxGz/641w1QnQXTdSpf0=;
        b=iLfNAXcEsMGgeKgyEsx3zuMnpDzHq6jouhix0ZrsXWFHoXuQrjMwK2iAVK1JqMfhYL
         7RFVhjFLoS27J7LMwl/EqqbYwOiyyOYFiYuqJUaWG6XpU5acdACZuBlQpR8G6w3113gI
         pGTocJSkkyjo8tf+q3XM+NxrZNRZc9nW1oJDeoBVEAEPtDGW7HEdJqfp+FDi+w+wvFHd
         CPOTIPrf/keWY1VrhNg7LbKt4LX5uWiX2jA0zXrk6Ubynmhr74acuZfDhiLAeK/8LYFE
         ep8jAeBunEtTliTmfFEQScyhVJtOaQKpDUiDgK0m505OWkwa3RpdT7S9A8EvIM8EL4Z5
         uRWQ==
X-Gm-Message-State: AOAM532exCotZQ3JUUPtfqdKy8mY7it8japcTQdxFVNvV1X6iKAIALl6
        vpbH/6q7ILGf5Q0walx7mySmGUALYbHl5tcNBjufiDNpiZrD7xLb2yhywanufxhogTuwwI+Fwx1
        JHuQSIulurxkzqvvYY2o1LxVxoxz6JbdwHg93Hw==
X-Received: by 2002:a05:6402:2706:: with SMTP id y6mr13266522edd.29.1639551569466;
        Tue, 14 Dec 2021 22:59:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLEtdH6OwY04TWX96qvtzBjBz+n0WHWrGbPbU0g+bbxsrxtTZ9ZwBnpDrgJQH46xOpIL5izQRkdmgEqsIc9Dw=
X-Received: by 2002:a05:6402:2706:: with SMTP id y6mr13266510edd.29.1639551569282;
 Tue, 14 Dec 2021 22:59:29 -0800 (PST)
MIME-Version: 1.0
References: <20211215030831.24058-1-trbecker@gmail.com>
In-Reply-To: <20211215030831.24058-1-trbecker@gmail.com>
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Wed, 15 Dec 2021 16:59:18 +1000
Message-ID: <CAGvGhF4y4ydeuQg9CmTF5OrrVmXG6D05PtBCWHb-EFmY8Y4zOA@mail.gmail.com>
Subject: Re: [PATCH 1/1] cifs: sanitize multiple delimiters in prepath
To:     Thiago Rafael Becker <trbecker@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,

Acked-by: me
Steve, we should have this in stable

    Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
    Cc: stable@vger.kernel.org # 5.11+


On Wed, Dec 15, 2021 at 1:09 PM Thiago Rafael Becker <trbecker@gmail.com> wrote:
>
> mount.cifs can pass a device with multiple delimiters in it. This will
> cause rename(2) to fail with ENOENT.
>
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=2031200
> Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
> ---
>  fs/cifs/fs_context.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 6a179ae753c1..4ce8a7df3a02 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -434,6 +434,34 @@ int smb3_parse_opt(const char *options, const char *key, char **val)
>         return rc;
>  }
>
> +/*
> + * remove duplicate path delimiters. Windows is supposed to do that
> + * but there are some bugs that prevent rename from working if there are
> + * multiple delimiters.
> + */
> +void sanitize_path(char *path) {
> +        char *pos = path, last = *path;
> +        unsigned int offset = 0;
> +
> +        while(*(++pos)) {
> +                if ((*pos == '/' || *pos == '\\') && (last == '/' || last == '\\')) {
> +                        offset++;
> +                        continue;
> +                }
> +
> +                last = *pos;
> +                *(pos - offset) = *pos;
> +        }
> +
> +        pos = pos - offset - 1;
> +
> +        /* At this point, there should be only zero or one delimiter at the end of the string */
> +        if (*pos != '/' && *pos != '\\')
> +                pos++;
> +
> +        *pos = '\0';
> +}
> +
>  /*
>   * Parse a devname into substrings and populate the ctx->UNC and ctx->prepath
>   * fields with the result. Returns 0 on success and an error otherwise
> @@ -497,6 +525,8 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
>         if (!ctx->prepath)
>                 return -ENOMEM;
>
> +       sanitize_path(ctx->prepath);
> +
>         return 0;
>  }
>
> --
> 2.31.1
>

