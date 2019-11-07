Return-Path: <SRS0=qFu0=Y7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADE9C5DF61
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Nov 2019 03:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEB2A21882
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Nov 2019 03:34:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HuVYeWAp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733032AbfKGDen (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:34:43 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:35607 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbfKGDen (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Nov 2019 22:34:43 -0500
Received: by mail-io1-f65.google.com with SMTP id x21so713268iol.2;
        Wed, 06 Nov 2019 19:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j00j0P5tg7ufiLDUoOnBdVRUf6hj9hF5UDph/p/NK68=;
        b=HuVYeWApBFO+9D/Ggj+4qUY5unti4vS0dXk7MlI4Db3/qZV+3I4AlmGIXTH4c0Pbor
         Ohju8tXGFXrjbLL15eFdQogG9VSPpgSD7eNLLGbrxmR3d2ORHI/IyT1R+m3hxZ6Awa3o
         ge9NysOVl3U8sVP5UAbuKX6D9hsmOW1JwtWG672dko0/3YW2L7iUtC8a/z6E5/tGbd41
         cvNXQgoo3/T3rd5tnlXFOuLLAI7s2/XlIgIfph5qnZdLTOcSe+rZZUwAWSFOMZf7Ezv1
         sBJ0R3Tvper9gJYi7zv36leQkTCkamH39dLFU6i66FGwxe3T5rTMgyFl4mbKb1ifyneW
         Ixcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j00j0P5tg7ufiLDUoOnBdVRUf6hj9hF5UDph/p/NK68=;
        b=lMqPGrpFdvW7pme3cxF4FyPKxtw1CqEl+bOFo9QicHA2DK/JqXOJc0OCxURS+LVWh4
         BOo1k6R9RLAUsiSF5BH+DPUo7zo+zWlPiyJM+GSbJeheUTvzBF79r3hHlvkJRbdiDKLD
         sxkb+3bnuLVNb1J3eYQwjJv08sgxUBXN3yDjrb6ZbWvS7ul6DaR7r6BZu4KUrikfI+8q
         sQRFWCBkooT9rAhtCvwawMCL6g/6toDafk9ifXTEYlJkVUVtGWm1ziajMJFtUcsDVHpp
         u9uKWVnnG5kBvoA1nxtAO1CBLUVTToB+boVh6scx0R4UHVh2ta8LfpWG+R+zFMnax6sf
         lrDg==
X-Gm-Message-State: APjAAAXwP15FyW9NBIlKTiTlmG4ve1OcnD5c1OcYM8WWKmWuNYG9EI+O
        ikXPIO81y4VVW/3yRswH8bUVvS3nArKpq60vqVc=
X-Google-Smtp-Source: APXvYqxmxrcUqMIf+MxenLaiixpDBKSDY+CiliO91aSSQhnW/VD9p8c0URvnBnQ5MC999/3P1DmXVKNifyw+ZyDx0vE=
X-Received: by 2002:a05:6638:20a:: with SMTP id e10mr1797639jaq.27.1573097681936;
 Wed, 06 Nov 2019 19:34:41 -0800 (PST)
MIME-Version: 1.0
References: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net> <24a10b1a-3b4a-da70-1670-23b4ec9abff8@users.sourceforge.net>
In-Reply-To: <24a10b1a-3b4a-da70-1670-23b4ec9abff8@users.sourceforge.net>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 6 Nov 2019 21:34:30 -0600
Message-ID: <CAH2r5msOyZXi6msPOPNnM4pF_YJEEOkxFk=dScUW0ZMuEvHFaQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] CIFS: Return directly after a failed
 build_path_from_dentry() in cifs_do_create()
To:     SF Markus Elfring <elfring@users.sourceforge.net>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Steve French <sfrench@samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Sun, Aug 20, 2017 at 11:40 AM SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 20 Aug 2017 17:17:30 +0200
>
> Return directly after a call of the function "build_path_from_dentry"
> failed at the beginning.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/cifs/dir.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 2c9cbd8393d6..248aead1f3f4 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -239,10 +239,8 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
>                 *oplock = REQ_OPLOCK;
>
>         full_path = build_path_from_dentry(direntry);
> -       if (full_path == NULL) {
> -               rc = -ENOMEM;
> -               goto out;
> -       }
> +       if (!full_path)
> +               return -ENOMEM;
>
>         if (tcon->unix_ext && cap_unix(tcon->ses) && !tcon->broken_posix_open &&
>             (CIFS_UNIX_POSIX_PATH_OPS_CAP &
> --
> 2.14.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
